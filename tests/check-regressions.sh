#!/usr/bin/env bash
set -Eeuo pipefail

export LC_ALL=C.UTF-8

test_script_dir=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
test_repo_dir=$(dirname -- "$test_script_dir")
test_workspace_dir=$(dirname -- "$test_repo_dir")
test_fixture_dir="$test_script_dir/fixtures"
test_template_dir="$test_repo_dir/template"
test_commons_dir="$test_workspace_dir/pt-commons"
test_output_dir=$(mktemp -d "${TMPDIR:-/tmp}/pt-article-regressions.XXXXXX")
test_cache_dir="$test_output_dir/texmf-cache"
test_problem_pattern='(^!|LaTeX Error|Package .* Error|Class .* Error|Undefined control sequence|Overfull \\[hv]box|Missing character:|Emergency stop|Fatal error|Runaway argument|Missing number|Extra \})'

mkdir -p "$test_cache_dir"

die() {
    printf 'pt-article regression failure: %s\n' "$*" >&2
    printf 'Test artifacts: %s\n' "$test_output_dir" >&2
    exit 1
}

show_failure_context() {
    local test_log=$1
    local test_console=$2

    if [[ -f "$test_log" ]]; then
        printf '%s\n' '--- TeX log tail ---' >&2
        tail -n 80 "$test_log" >&2
    elif [[ -f "$test_console" ]]; then
        printf '%s\n' '--- TeX console tail ---' >&2
        tail -n 80 "$test_console" >&2
    fi
}

for test_tool in pdfinfo pdftotext awk grep tail mktemp tr wc; do
    command -v "$test_tool" >/dev/null 2>&1 ||
        die "required command not found: $test_tool"
done

case ${PT_TEST_MINTED:-0} in
    0|1) ;;
    *) die 'PT_TEST_MINTED must be either 0 or 1' ;;
esac

if (( $# == 0 )); then
    test_engines=(pdflatex xelatex lualatex)
else
    test_engines=("$@")
fi

for test_engine in "${test_engines[@]}"; do
    command -v "$test_engine" >/dev/null 2>&1 ||
        die "TeX engine not found: $test_engine"
done

COMPILED_LOG=
COMPILED_PDF=

compile_success() {
    local test_engine=$1
    local test_input=$2
    local test_case=$3
    local test_job=$4
    local test_passes=$5
    local test_work_dir=$6
    local test_shell_mode=${7:--no-shell-escape}
    local test_engine_name=${test_engine##*/}
    local test_case_dir="$test_output_dir/$test_engine_name/$test_case"
    local test_log="$test_case_dir/$test_job.log"
    local test_pdf="$test_case_dir/$test_job.pdf"
    local test_pass
    local test_console

    mkdir -p "$test_case_dir"
    printf '[%s] %s\n' "$test_engine_name" "$test_case"

    for (( test_pass = 1; test_pass <= test_passes; test_pass++ )); do
        test_console="$test_case_dir/pass-$test_pass.console"
        if ! (
            cd "$test_work_dir"
            env \
                TEXINPUTS="$test_fixture_dir:$test_template_dir:$test_repo_dir:$test_commons_dir:" \
                TEXMFCACHE="$test_cache_dir" \
                TEXMFVAR="$test_cache_dir" \
                XDG_CACHE_HOME="$test_cache_dir" \
                "$test_engine" \
                -interaction=nonstopmode \
                -halt-on-error \
                -file-line-error \
                "$test_shell_mode" \
                -recorder \
                -output-directory="$test_case_dir" \
                -jobname="$test_job" \
                "$test_input"
        ) >"$test_console" 2>&1; then
            show_failure_context "$test_log" "$test_console"
            die "$test_engine failed in $test_case on pass $test_pass"
        fi
    done

    [[ -s "$test_log" ]] || die "$test_case did not produce a TeX log"
    [[ -s "$test_pdf" ]] || die "$test_case did not produce a PDF"

    if grep -Eq "$test_problem_pattern" "$test_log"; then
        grep -En "$test_problem_pattern" "$test_log" >&2 || true
        die "$test_case produced a fatal diagnostic or an overfull box"
    fi

    COMPILED_LOG=$test_log
    COMPILED_PDF=$test_pdf
}

compile_expected_title_failure() {
    local test_engine=$1
    local test_fixture=$2
    local test_engine_name=${test_engine##*/}
    local test_case=${test_fixture%.tex}
    local test_case_dir="$test_output_dir/$test_engine_name/$test_case"
    local test_log="$test_case_dir/$test_case.log"
    local test_console="$test_case_dir/pass-1.console"

    mkdir -p "$test_case_dir"
    printf '[%s] %s (expected failure)\n' "$test_engine_name" "$test_case"

    if (
        cd "$test_fixture_dir"
        env \
            TEXINPUTS="$test_fixture_dir:$test_repo_dir:$test_commons_dir:" \
            TEXMFCACHE="$test_cache_dir" \
            TEXMFVAR="$test_cache_dir" \
            XDG_CACHE_HOME="$test_cache_dir" \
            "$test_engine" \
            -interaction=nonstopmode \
            -halt-on-error \
            -file-line-error \
            -no-shell-escape \
            -output-directory="$test_case_dir" \
            -jobname="$test_case" \
            "$test_fixture"
    ) >"$test_console" 2>&1; then
        die "$test_engine accepted $test_case without a non-empty title"
    fi

    [[ -f "$test_log" ]] || {
        show_failure_context "$test_log" "$test_console"
        die "$test_case failed without producing a TeX log"
    }
    grep -Eiq 'Class pt-article Error:.*title' "$test_log" || {
        show_failure_context "$test_log" "$test_console"
        die "$test_case did not report a clear pt-article class error"
    }
    if grep -Fq 'Undefined control sequence' "$test_log"; then
        show_failure_context "$test_log" "$test_console"
        die "$test_case leaked an internal undefined control sequence"
    fi
}

compile_expected_titlepage_failure() {
    local test_engine=$1
    local test_engine_name=${test_engine##*/}
    local test_case=rejected-titlepage
    local test_case_dir="$test_output_dir/$test_engine_name/$test_case"
    local test_log="$test_case_dir/$test_case.log"
    local test_console="$test_case_dir/pass-1.console"

    mkdir -p "$test_case_dir"
    printf '[%s] %s (expected failure)\n' "$test_engine_name" "$test_case"

    if (
        cd "$test_fixture_dir"
        env \
            TEXINPUTS="$test_fixture_dir:$test_repo_dir:$test_commons_dir:" \
            TEXMFCACHE="$test_cache_dir" \
            TEXMFVAR="$test_cache_dir" \
            XDG_CACHE_HOME="$test_cache_dir" \
            "$test_engine" \
            -interaction=nonstopmode \
            -halt-on-error \
            -file-line-error \
            -no-shell-escape \
            -output-directory="$test_case_dir" \
            -jobname="$test_case" \
            rejected-titlepage.tex
    ) >"$test_console" 2>&1; then
        die "$test_engine accepted the unsupported titlepage option"
    fi

    [[ -f "$test_log" ]] || {
        show_failure_context "$test_log" "$test_console"
        die "$test_case failed without producing a TeX log"
    }
    grep -Fq 'Error: The titlepage option is not supported.' "$test_log" || {
        show_failure_context "$test_log" "$test_console"
        die "$test_case did not report the expected class error"
    }
}

pdf_page_count() {
    local test_pdf=$1
    pdfinfo "$test_pdf" |
        awk '/^Pages:[[:space:]]*/ { pages = $2; found = 1 }
             END { if (!found) exit 1; print pages }'
}

assert_page_count() {
    local test_pdf=$1
    local test_expected=$2
    local test_actual

    test_actual=$(pdf_page_count "$test_pdf") ||
        die "could not read page count from $test_pdf"
    [[ "$test_actual" == "$test_expected" ]] ||
        die "$test_pdf has $test_actual physical pages; expected $test_expected"
}

assert_minimum_page_count() {
    local test_pdf=$1
    local test_expected_minimum=$2
    local test_actual

    test_actual=$(pdf_page_count "$test_pdf") ||
        die "could not read page count from $test_pdf"
    (( test_actual >= test_expected_minimum )) ||
        die "$test_pdf has $test_actual pages; expected at least $test_expected_minimum"
}

extract_pdf_text() {
    local test_pdf=$1
    local test_text="${test_pdf%.pdf}.txt"

    pdftotext -layout "$test_pdf" "$test_text" ||
        die "could not extract text from $test_pdf"
    printf '%s\n' "$test_text"
}

assert_pdf_contains() {
    local test_pdf=$1
    local test_expected=$2
    local test_text

    test_text=$(extract_pdf_text "$test_pdf")
    grep -Fq -- "$test_expected" "$test_text" ||
        die "$test_pdf does not contain '$test_expected'"
}

assert_pdf_occurrences() {
    local test_pdf=$1
    local test_expected=$2
    local test_count=$3
    local test_text
    local test_actual

    test_text=$(extract_pdf_text "$test_pdf")
    test_actual=$(grep -Fo -- "$test_expected" "$test_text" | wc -l)
    [[ "$test_actual" == "$test_count" ]] ||
        die "$test_pdf contains '$test_expected' $test_actual times; expected $test_count"
}

assert_page_number() {
    local test_pdf=$1
    local test_page=$2
    local test_expected=$3
    local test_text="${test_pdf%.pdf}.page-$test_page.txt"

    pdftotext -f "$test_page" -l "$test_page" -layout \
        "$test_pdf" "$test_text" ||
        die "could not extract page $test_page from $test_pdf"
    grep -Eq "^[[:space:]]*$test_expected[[:space:]]*$" "$test_text" ||
        die "physical page $test_page of $test_pdf is not numbered $test_expected"
}

assert_log_contains() {
    local test_log=$1
    local test_expected=$2

    grep -Fq -- "$test_expected" "$test_log" ||
        die "$test_log does not contain '$test_expected'"
}

assert_text_inside_masthead_bounds() {
    local test_pdf=$1
    local test_bbox="${test_pdf%.pdf}.page-1.bbox.html"

    pdftotext -f 1 -l 1 -bbox "$test_pdf" "$test_bbox" ||
        die "could not extract masthead bounding boxes from $test_pdf"

    awk -F'"' '
        /<word xMin=/ {
            seen = 1
            x_min = $2 + 0
            y_min = $4 + 0
            x_max = $6 + 0
            y_max = $8 + 0
            if (x_min < 38 || x_max > 574 || y_min < 34 || y_max > 770) {
                print "Text outside article bounds: " $0 > "/dev/stderr"
                bad = 1
            }
        }
        END {
            if (!seen) {
                print "No words found while checking article bounds" > "/dev/stderr"
                exit 2
            }
            exit bad
        }
    ' "$test_bbox" ||
        die "text escaped the 42pt article margins in $test_pdf"
}

create_page_bbox() {
    local test_pdf=$1
    local test_page=$2
    local test_bbox="${test_pdf%.pdf}.page-$test_page.wrap.bbox.html"

    pdftotext -f "$test_page" -l "$test_page" -bbox \
        "$test_pdf" "$test_bbox" ||
        die "could not extract table bounding boxes from $test_pdf"
    printf '%s\n' "$test_bbox"
}

assert_marker_in_right_column_bottom() {
    local test_pdf=$1
    local test_page=$2
    local test_marker=$3
    local test_bbox

    test_bbox=$(create_page_bbox "$test_pdf" "$test_page")
    awk -F'"' -v marker="$test_marker" '
        /<page width=/ {
            page_width = $2 + 0
            page_height = $4 + 0
        }
        index($0, ">" marker "</word>") {
            marker_count++
            marker_x_min = $2 + 0
            marker_y_min = $4 + 0
        }
        END {
            if (!page_width || !page_height) {
                print "Could not read PDF page dimensions" > "/dev/stderr"
                exit 2
            }
            if (marker_count != 1) {
                printf "Expected one %s marker, found %d\n", \
                    marker, marker_count > "/dev/stderr"
                exit 3
            }
            if (marker_x_min <= page_width / 2) {
                printf "%s starts at x=%.3fpt, outside the right column\n", \
                    marker, marker_x_min > "/dev/stderr"
                exit 4
            }
            if (marker_y_min <= page_height * 0.75) {
                printf "%s starts at y=%.3fpt, above the bottom quarter\n", \
                    marker, marker_y_min > "/dev/stderr"
                exit 5
            }
        }
    ' "$test_bbox" ||
        die "$test_marker is not at the bottom of the right column in $test_pdf"
}

assert_single_author_centered() {
    local test_pdf=$1
    local test_bbox

    test_bbox=$(create_page_bbox "$test_pdf" 1)
    awk -F'"' '
        /<page width=/ { page_center = ($2 + 0) / 2 }
        />Toledo</ || />Correa,</ || />Pedro</ {
            if (!name_count || $2 + 0 < name_left) name_left = $2 + 0
            if (!name_count || $6 + 0 > name_right) name_right = $6 + 0
            name_count++
        }
        />pedro.toledo@usm.cl</ {
            email_center = (($2 + 0) + ($6 + 0)) / 2
            email_count++
        }
        END {
            if (name_count != 3 || email_count != 1) exit 2
            name_offset = (name_left + name_right) / 2 - page_center
            email_offset = email_center - page_center
            if (name_offset < -1 || name_offset > 1 ||
                email_offset < -1 || email_offset > 1) {
                printf "Author offsets from page center: name=%.3fpt email=%.3fpt\n", \
                    name_offset, email_offset > "/dev/stderr"
                exit 3
            }
        }
    ' "$test_bbox" ||
        die "the single author name and email are not centered in $test_pdf"
}

assert_last_page_balanced() {
    local test_pdf=$1
    local test_marker=$2
    local test_page
    local test_bbox

    test_page=$(pdf_page_count "$test_pdf")
    test_bbox=$(create_page_bbox "$test_pdf" "$test_page")
    awk -F'"' -v marker="$test_marker" '
        /<page width=/ {
            page_width = $2 + 0
        }
        index($0, ">" marker "</word>") {
            marker_x_min = $2 + 0
            marker_y_max = $8 + 0
            if (marker_x_min < page_width / 2) {
                left_count++
                if (marker_y_max > left_bottom) left_bottom = marker_y_max
            } else {
                right_count++
                if (marker_y_max > right_bottom) right_bottom = marker_y_max
            }
        }
        END {
            if (!page_width || !left_count || !right_count) {
                printf "Last-page marker counts are left=%d right=%d\n", \
                    left_count, right_count > "/dev/stderr"
                exit 2
            }
            count_difference = left_count - right_count
            if (count_difference < 0) count_difference = -count_difference
            if (count_difference > 1) {
                printf "Last-page marker counts are left=%d right=%d\n", \
                    left_count, right_count > "/dev/stderr"
                exit 3
            }
            bottom_difference = left_bottom - right_bottom
            if (bottom_difference < 0) bottom_difference = -bottom_difference
            if (bottom_difference > 15) {
                printf "Last-page column bottoms differ by %.3fpt\n", \
                    bottom_difference > "/dev/stderr"
                exit 4
            }
        }
    ' "$test_bbox" ||
        die "last-page content is not geometrically balanced in $test_pdf"
}

assert_last_page_left_only() {
    local test_pdf=$1
    local test_marker=$2
    local test_page
    local test_bbox

    test_page=$(pdf_page_count "$test_pdf")
    test_bbox=$(create_page_bbox "$test_pdf" "$test_page")
    awk -F'"' -v marker="$test_marker" '
        /<page width=/ {
            page_width = $2 + 0
        }
        index($0, ">" marker "</word>") {
            marker_x_min = $2 + 0
            if (marker_x_min < page_width / 2) {
                left_count++
            } else {
                right_count++
            }
        }
        END {
            if (!page_width || left_count < 5 || right_count != 0) {
                printf "Unbalanced last-page marker counts are left=%d right=%d\n", \
                    left_count, right_count > "/dev/stderr"
                exit 2
            }
        }
    ' "$test_bbox" ||
        die "default last-page content was unexpectedly balanced in $test_pdf"
}

assert_markers_wrap() {
    local test_bbox=$1
    local test_start=$2
    local test_end=$3

    awk -F'"' -v start="$test_start" -v finish="$test_end" '
        index($0, ">" start "</word>") {
            start_y = $4 + 0
            have_start = 1
        }
        index($0, ">" finish "</word>") {
            finish_y = $4 + 0
            have_finish = 1
        }
        END {
            if (!have_start || !have_finish) {
                printf "Missing wrap markers %s/%s\n", start, finish > "/dev/stderr"
                exit 2
            }
            if (finish_y <= start_y + 2) {
                printf "%s and %s remained on one line\n", start, finish > "/dev/stderr"
                exit 3
            }
        }
    ' "$test_bbox" ||
        die "column content did not wrap between $test_start and $test_end"
}

assert_marker_gap_at_least() {
    local test_bbox=$1
    local test_upper=$2
    local test_lower=$3
    local test_minimum=$4

    awk -F'"' \
        -v upper="$test_upper" \
        -v lower="$test_lower" \
        -v minimum="$test_minimum" '
        index($0, ">" upper "</word>") {
            upper_y_max = $8 + 0
            have_upper = 1
        }
        index($0, ">" lower "</word>") {
            lower_y_min = $4 + 0
            have_lower = 1
        }
        END {
            if (!have_upper || !have_lower) {
                printf "Missing vertical-gap markers %s/%s\n", upper, lower > "/dev/stderr"
                exit 2
            }
            gap = lower_y_min - upper_y_max
            if (gap < minimum) {
                printf "Vertical gap %s -> %s is %.3fpt; expected at least %.3fpt\n", \
                    upper, lower, gap, minimum > "/dev/stderr"
                exit 3
            }
        }
    ' "$test_bbox" ||
        die "vertical gap between $test_upper and $test_lower is too small"
}

assert_marker_gap_at_most() {
    local test_bbox=$1
    local test_upper=$2
    local test_lower=$3
    local test_maximum=$4

    awk -F'"' \
        -v upper="$test_upper" \
        -v lower="$test_lower" \
        -v maximum="$test_maximum" '
        index($0, ">" upper "</word>") {
            upper_y_max = $8 + 0
            have_upper = 1
        }
        index($0, ">" lower "</word>") {
            lower_y_min = $4 + 0
            have_lower = 1
        }
        END {
            if (!have_upper || !have_lower) {
                printf "Missing vertical-gap markers %s/%s\n", upper, lower > "/dev/stderr"
                exit 2
            }
            gap = lower_y_min - upper_y_max
            if (gap > maximum) {
                printf "Vertical gap %s -> %s is %.3fpt; expected at most %.3fpt\n", \
                    upper, lower, gap, maximum > "/dev/stderr"
                exit 3
            }
        }
    ' "$test_bbox" ||
        die "vertical gap between $test_upper and $test_lower is too large"
}

declare -a option_fixtures=(
    options-coreonly-spanish-10pt
    options-minimal-english-11pt
    options-ptnolayout-french-12pt
    options-ptnocontent-portuguese-10pt
    options-ptnoruntime-spanish-11pt
    options-restore-ptlayout-english-12pt
    options-restore-ptcontent-french-10pt
    options-restore-ptruntime-portuguese-11pt
)

declare -A option_modules=(
    [options-coreonly-spanish-10pt]=000
    [options-minimal-english-11pt]=000
    [options-ptnolayout-french-12pt]=011
    [options-ptnocontent-portuguese-10pt]=101
    [options-ptnoruntime-spanish-11pt]=110
    [options-restore-ptlayout-english-12pt]=100
    [options-restore-ptcontent-french-10pt]=010
    [options-restore-ptruntime-portuguese-11pt]=001
)

declare -A option_font_sizes=(
    [options-coreonly-spanish-10pt]=10
    [options-minimal-english-11pt]=10.95
    [options-ptnolayout-french-12pt]=12
    [options-ptnocontent-portuguese-10pt]=10
    [options-ptnoruntime-spanish-11pt]=10.95
    [options-restore-ptlayout-english-12pt]=12
    [options-restore-ptcontent-french-10pt]=10
    [options-restore-ptruntime-portuguese-11pt]=10.95
)

declare -A option_languages=(
    [options-coreonly-spanish-10pt]=spanish
    [options-minimal-english-11pt]=english
    [options-ptnolayout-french-12pt]=french
    [options-ptnocontent-portuguese-10pt]=portuguese
    [options-ptnoruntime-spanish-11pt]=spanish
    [options-restore-ptlayout-english-12pt]=english
    [options-restore-ptcontent-french-10pt]=french
    [options-restore-ptruntime-portuguese-11pt]=portuguese
)

declare -A option_columns=(
    [options-coreonly-spanish-10pt]=two
    [options-minimal-english-11pt]=one
    [options-ptnolayout-french-12pt]=two
    [options-ptnocontent-portuguese-10pt]=two
    [options-ptnoruntime-spanish-11pt]=two
    [options-restore-ptlayout-english-12pt]=two
    [options-restore-ptcontent-french-10pt]=two
    [options-restore-ptruntime-portuguese-11pt]=two
)

for test_engine in "${test_engines[@]}"; do
    compile_success \
        "$test_engine" \
        '\PassOptionsToClass{nominted}{pt-article}\input{template.tex}' \
        template-smoke \
        template \
        3 \
        "$test_template_dir"
    assert_minimum_page_count "$COMPILED_PDF" 3
    assert_pdf_contains "$COMPILED_PDF" 'Título del Artículo'
    assert_pdf_contains "$COMPILED_PDF" 'Conclusión'

    if [[ ${PT_TEST_MINTED:-0} == 1 ]]; then
        compile_success \
            "$test_engine" \
            template.tex \
            template-minted-smoke \
            template \
            3 \
            "$test_template_dir" \
            -shell-escape
        assert_minimum_page_count "$COMPILED_PDF" 3
        assert_pdf_contains "$COMPILED_PDF" 'Título del Artículo'
        assert_pdf_contains "$COMPILED_PDF" 'Conclusión'
    fi

    compile_success \
        "$test_engine" default-two-column.tex default-two-column \
        default-two-column 1 "$test_fixture_dir"
    assert_page_count "$COMPILED_PDF" 1
    assert_page_number "$COMPILED_PDF" 1 1
    assert_pdf_contains "$COMPILED_PDF" PTARTICLEDEFAULTCONTENT
    assert_log_contains "$COMPILED_LOG" 'PT-TEST-COLUMNS=two'

    compile_success \
        "$test_engine" one-column.tex one-column one-column 1 \
        "$test_fixture_dir"
    assert_page_count "$COMPILED_PDF" 1
    assert_page_number "$COMPILED_PDF" 1 1
    assert_pdf_contains "$COMPILED_PDF" PTARTICLEONECOLUMNCONTENT
    assert_log_contains "$COMPILED_LOG" 'PT-TEST-COLUMNS=one'

    compile_success \
        "$test_engine" two-sided.tex two-sided two-sided 1 \
        "$test_fixture_dir"
    assert_page_count "$COMPILED_PDF" 1
    assert_page_number "$COMPILED_PDF" 1 1
    assert_pdf_contains "$COMPILED_PDF" PTARTICLETWOSIDECONTENT

    compile_success \
        "$test_engine" metadata-empty.tex metadata-empty metadata-empty 1 \
        "$test_fixture_dir"
    assert_page_count "$COMPILED_PDF" 1
    assert_pdf_contains "$COMPILED_PDF" PTARTICLEOPTIONALMETADATA
    assert_pdf_contains "$COMPILED_PDF" PTARTICLEEMPTYMETADATACONTENT

    compile_expected_title_failure "$test_engine" missing-title.tex
    compile_expected_title_failure "$test_engine" empty-title.tex
    compile_expected_titlepage_failure "$test_engine"

    compile_success \
        "$test_engine" duplicate-title.tex duplicate-title duplicate-title 1 \
        "$test_fixture_dir"
    assert_pdf_occurrences "$COMPILED_PDF" PTARTICLEDUPLICATETITLE 1
    assert_log_contains "$COMPILED_LOG" 'title masthead was already generated'

    compile_success \
        "$test_engine" author-centered.tex author-centered author-centered 1 \
        "$test_fixture_dir"
    assert_page_count "$COMPILED_PDF" 1
    assert_single_author_centered "$COMPILED_PDF"

    for test_author_fixture in authors-long-two-column authors-long-one-column; do
        compile_success \
            "$test_engine" "$test_author_fixture.tex" "$test_author_fixture" \
            "$test_author_fixture" 1 "$test_fixture_dir"
        assert_page_count "$COMPILED_PDF" 1
        assert_pdf_contains "$COMPILED_PDF" FINALAFFILIATIONMARKER
        assert_pdf_contains "$COMPILED_PDF" SECONDAFFILIATIONMARKER
        assert_text_inside_masthead_bounds "$COMPILED_PDF"
    done

    compile_success \
        "$test_engine" footnote-counter.tex footnote-counter footnote-counter 1 \
        "$test_fixture_dir"
    assert_pdf_contains "$COMPILED_PDF" PTARTICLEFIRSTFOOTNOTE
    assert_log_contains "$COMPILED_LOG" 'PT-TEST-FOOTNOTE=1'
    assert_pdf_contains "$COMPILED_PDF" 'a. PTARTICLEFIRSTAFFILIATION'
    assert_pdf_contains "$COMPILED_PDF" 'b. PTARTICLESECONDAFFILIATION'
    assert_marker_in_right_column_bottom \
        "$COMPILED_PDF" 1 PTARTICLEFIRSTAFFILIATION
    assert_marker_in_right_column_bottom \
        "$COMPILED_PDF" 1 PTARTICLESECONDAFFILIATION
    assert_marker_in_right_column_bottom \
        "$COMPILED_PDF" 1 PTARTICLEFIRSTFOOTNOTE

    compile_success \
        "$test_engine" balance-columns.tex balance-columns balance-columns 1 \
        "$test_fixture_dir"
    assert_log_contains "$COMPILED_LOG" 'PT-TEST-FLUSHEND=loaded'
    assert_minimum_page_count "$COMPILED_PDF" 2
    assert_last_page_balanced "$COMPILED_PDF" PTBALANCELINE

    compile_success \
        "$test_engine" no-balance-columns.tex no-balance-columns \
        no-balance-columns 1 "$test_fixture_dir"
    assert_log_contains "$COMPILED_LOG" 'PT-TEST-FLUSHEND=loaded'
    assert_minimum_page_count "$COMPILED_PDF" 2
    assert_last_page_left_only "$COMPILED_PDF" PTBALANCELINE

    compile_success \
        "$test_engine" balance-one-column.tex balance-one-column \
        balance-one-column 1 "$test_fixture_dir"
    assert_log_contains "$COMPILED_LOG" 'PT-TEST-FLUSHEND=missing'
    assert_log_contains "$COMPILED_LOG" 'PT-TEST-COLUMNS=one'

    compile_success \
        "$test_engine" table-columns.tex table-columns table-columns 1 \
        "$test_fixture_dir"
    assert_page_count "$COMPILED_PDF" 1
    test_table_bbox=$(create_page_bbox "$COMPILED_PDF" 1)
    assert_markers_wrap "$test_table_bbox" LSTART LEND
    assert_markers_wrap "$test_table_bbox" CSTART CEND
    assert_markers_wrap "$test_table_bbox" RSTART REND
    assert_markers_wrap "$test_table_bbox" XSTART XEND
    assert_markers_wrap "$test_table_bbox" XFLEXSTART XFLEXEND

    for test_spacing_fixture in \
        table-spacing-two-column \
        table-spacing-one-column; do
        compile_success \
            "$test_engine" \
            "$test_spacing_fixture.tex" \
            "$test_spacing_fixture" \
            "$test_spacing_fixture" \
            1 \
            "$test_fixture_dir"
        assert_page_count "$COMPILED_PDF" 2
        test_standalone_table_bbox=$(create_page_bbox "$COMPILED_PDF" 1)
        assert_marker_gap_at_least \
            "$test_standalone_table_bbox" \
            PTSTANDALONEBEFORE \
            PTSTANDALONECELL \
            7.5
        assert_marker_gap_at_least \
            "$test_standalone_table_bbox" \
            PTSTANDALONECELL \
            PTSTANDALONEAFTER \
            7.5
        test_float_table_bbox=$(create_page_bbox "$COMPILED_PDF" 2)
        assert_marker_gap_at_most \
            "$test_float_table_bbox" \
            PTFLOATBEFORE \
            PTFLOATCELL \
            18
        assert_marker_gap_at_most \
            "$test_float_table_bbox" \
            PTFLOATCELL \
            PTFLOATCAPTION \
            18
    done

    compile_success \
        "$test_engine" \
        table-spacing-star.tex \
        table-spacing-star \
        table-spacing-star \
        1 \
        "$test_fixture_dir"
    assert_pdf_contains "$COMPILED_PDF" PTSTARFLOATCELL
    assert_pdf_contains "$COMPILED_PDF" PTSTARFLOATCAPTION
    test_star_table_page=$(pdf_page_count "$COMPILED_PDF")
    test_star_table_bbox=$(create_page_bbox "$COMPILED_PDF" "$test_star_table_page")
    assert_marker_gap_at_most \
        "$test_star_table_bbox" \
        PTSTARFLOATCELL \
        PTSTARFLOATCAPTION \
        18

    for test_option_fixture in "${option_fixtures[@]}"; do
        compile_success \
            "$test_engine" \
            "$test_option_fixture.tex" \
            "$test_option_fixture" \
            "$test_option_fixture" \
            1 \
            "$test_fixture_dir"
        assert_log_contains \
            "$COMPILED_LOG" \
            "PT-TEST-MODULES=${option_modules[$test_option_fixture]}"
        assert_log_contains \
            "$COMPILED_LOG" \
            "PT-TEST-FONTSIZE=${option_font_sizes[$test_option_fixture]}"
        assert_log_contains \
            "$COMPILED_LOG" \
            "PT-TEST-LANGUAGE=${option_languages[$test_option_fixture]}"
        assert_log_contains \
            "$COMPILED_LOG" \
            "PT-TEST-COLUMNS=${option_columns[$test_option_fixture]}"
        assert_pdf_contains "$COMPILED_PDF" PTLANGUAGEMARKER
    done
done

printf 'PT Article regression checks passed: %s\n' "${test_engines[*]}"
printf 'Test artifacts: %s\n' "$test_output_dir"
