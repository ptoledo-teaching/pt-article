# PT Article regression checks

Run the isolated regression suite from the repository root:

```bash
./tests/check-regressions.sh
```

By default it exercises PDFLaTeX, XeLaTeX, and LuaLaTeX. Pass engine names to
restrict a run:

```bash
./tests/check-regressions.sh pdflatex
```

The regular template smoke test forces the `nominted` fallback and does not use
shell escape. Set `PT_TEST_MINTED=1` to add the exact template with Minted and
shell escape:

```bash
PT_TEST_MINTED=1 ./tests/check-regressions.sh pdflatex
```

The suite writes all TeX outputs and caches to a temporary directory. It checks
the automatic masthead, missing and empty titles, one- and two-column contracts,
two-sided pagination, centered author names/emails, long authors, alphabetic
affiliation footnotes, ordinary footnote numbering and physical
right-column placement, geometric last-page balancing,
standalone-versus-float table spacing, Commons module composition, languages,
font sizes, and the public `L`/`C`/`R`/`X` table-column grammar.
