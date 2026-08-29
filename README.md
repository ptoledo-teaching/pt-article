# PT Article Class

**Version:** 0.3<br>
**Date:** 2026/08/29<br>
**Author:** Pedro Toledo Correa<br>
**License:** LaTeX Project Public License 1.3c or later<br>
**Repository:** [GitHub - ptoledo-teaching/pt-article](https://github.com/ptoledo-teaching/pt-article)

`pt-article` is a compact academic and technical article class built on the
standard LaTeX `article` class and the matching PT Commons 0.4 semester
release. Its default body is two-column, with an inline full-width masthead on
physical page 1.

## Main behavior

- Letter paper, 10pt, one-sided, and two-column by default
- Symmetric 42pt margins and 21pt column separation
- Required title rendered automatically once at the start of the document
- Optional subtitle, tertiary title, logo, watermark, and multiple authors
- Width-bounded author table that wraps long emails and affiliations
- Footnotes collected in the right column in two-column mode
- Optional last-page column balancing, disabled by default
- Shared PT typography, metadata, tables, code blocks, figures, and runtime
  features through `pt-commons`

The masthead is not a separate title page. Use `pt-report` when a dedicated
cover and recto/verso pagination are required.

## Installation

Install `pt-article.cls` together with all five `pt-commons*.sty` files in the
document directory or in a local TeX tree:

```bash
mkdir -p ~/texmf/tex/latex/pt-article
mkdir -p ~/texmf/tex/latex/pt-commons
cp pt-article.cls ~/texmf/tex/latex/pt-article/
cp pt-commons*.sty ~/texmf/tex/latex/pt-commons/
texhash ~/texmf
```

## Minimal document

```latex
\documentclass[nominted]{pt-article}

\title{Article title}
\addauthor
  {Jane}
  {Doe}
  {jane.doe@example.com}
  {Department of Computer Science, Example University}

\begin{document}

\begin{abstract}
A concise summary of the article.
\end{abstract}

\section{Introduction}
Article content starts on the same physical page as the masthead.

\end{document}
```

Do not call `\maketitle`: the class generates the masthead automatically at
the end of document initialization. A later explicit call is ignored with a
warning, preventing accidental duplicate titles.

## Class options

### Columns and base-class options

The body is two-column unless `onecolumn` is explicit:

```latex
\documentclass{pt-article}                   % Two columns, 10pt
\documentclass[onecolumn,11pt]{pt-article}   % One column, 11pt
\documentclass[twoside,12pt]{pt-article}     % Two-sided, two columns, 12pt
\documentclass[a4paper]{pt-article}          % A4 paper
```

The standard `article` paper, side, font-size, draft, equation, and equation
numbering options are forwarded. `titlepage` is deliberately rejected because
PT Article always uses an inline masthead; use `pt-report` for that layout.

Both one- and two-sided articles begin on physical and numbered page 1. The
`twoside` option changes the base-class two-sided conventions but does not
insert a blank page after the masthead.

### Languages

```latex
\documentclass[spanish]{pt-article}       % Default
\documentclass[english]{pt-article}
\documentclass[portuguese]{pt-article}
\documentclass[french]{pt-article}
```

### Commons modules

The complete Commons package is enabled by default. Composite options retain
their Commons names:

```latex
\documentclass[coreonly]{pt-article}  % Core only
\documentclass[minimal]{pt-article}   % Alias for coreonly
\documentclass[full]{pt-article}      % Restore all modules
```

Individual module controls are namespaced at class level so generic option
names cannot leak to unrelated packages:

| Class option | Commons effect |
| --- | --- |
| `ptlayout` / `ptnolayout` | Enable / disable typography and visual layout |
| `ptcontent` / `ptnocontent` | Enable / disable tables, figures, code, and trees |
| `ptruntime` / `ptnoruntime` | Enable / disable build state and watermarks |

Options are applied from left to right, so selected modules can be restored
after `coreonly`:

```latex
\documentclass[coreonly,ptcontent,nominted]{pt-article}
\documentclass[full,ptnoruntime]{pt-article}
```

Dependencies used directly by PT Article remain available when a Commons
module is disabled. Commands supplied only by a disabled module are
intentionally unavailable.

### Code rendering

Minted is enabled with the complete content module. Select the verbatim
fallback when shell escape or Pygments is unavailable:

```latex
\documentclass[nominted]{pt-article}
```

## Masthead metadata

The title is mandatory and must be non-empty. Optional fields may be omitted
or explicitly empty without leaving blank separators:

```latex
\title{Main title}
\titlesub{Optional subtitle}
\titlesubsub{Optional tertiary title}
\logo{figures/institution-logo.pdf}
\watermark{DRAFT}
```

If a tertiary title and watermark are both present, the masthead prints
`DRAFT - Tertiary title`. With the runtime module enabled, the watermark also
appears diagonally on the pages.

Add any number of authors as first name, last name, email, and affiliation:

```latex
\addauthor
  {Jane}
  {Doe}
  {jane.doe@example.com}
  {Department of Computer Science, Example University}
\addauthor
  {John}
  {Smith}
  {}
  {Research Laboratory}
```

The masthead centers the Commons `\titleauthorstable` renderer. It keeps its
natural width when the author data fits and expands to a full-width wrapping
table only when needed. Empty values do not produce placeholder rows or author
footnotes.

Other shared metadata setters remain available for footer, watermark, and
document content:

```latex
\version{1.0}
\build{auto}
\buildsource{included-section.tex}
\date{2026-08-29}
\classcode{IWI-131}
\classname{Programming}
\classsemester{First Semester 2026}
\department{Department of Computer Science}
\school{School of Engineering}
\university{Example University}
```

PT Article does not print `\date` or class/institution metadata in its compact
masthead. Version and build metadata appear in the Commons footer when the
layout module is enabled.

## Page and text layout

- Left, right, top, and bottom margins: 42pt
- Column separation: 21pt
- Paragraph indentation: 21pt
- Controlled emergency line-breaking stretch: 3em
- Section and subsection spacing: 6pt plus/minus 3pt
- First-level list margin: 21pt

The class supplies its own section and list measurements regardless of whether
the optional Commons layout module is enabled. With `ptnolayout`, it also
provides a quiet fallback footer containing only the page number.

## Tables

PT Commons provides the `tblr` environment and PT column grammar when the
content module is enabled:

```latex
\begin{table}[ht]
\centering
\begin{tblr}{width=\columnwidth,colspec={X C{18mm} R{18mm}}}
\tableheader
Method & Accuracy & Time \\
Approach A & 95\% & 10s \\
Approach B & 97\% & 15s \\
\end{tblr}
\caption{Comparison of approaches}
\label{tab:results}
\end{table}
```

The established PT forms are:

- `L`, `C`, and `R` for flexible top-aligned columns
- `L{width}`, `C{width}`, and `R{width}` for fixed-width columns
- `X`, `X[2]`, `X[l]`, and other native flexible `X` configurations
- `X{width}` and `X[l]{width}` for fixed-width PT `X` columns

Every `tblr` uses footnote-sized text. A standalone `tblr` is treated as a
display and receives `\medskipamount` before and after it. A `tblr` inside
`table` or `table*` adds no extra vertical space because the float and caption
already provide it.

## Code, figures, and other Commons content

```latex
\begin{ptprintcode}{python}
def hello():
    print("Hello")
\end{ptprintcode}

\inlinecode{value_name}

\ptfigure
  {ht}
  {width=0.8\columnwidth}
  {figures/result.pdf}
  {Result figure}
  {fig:result}
```

Conditional lists are also available when their registered entries exist:

```latex
\ptlistoftables
\ptlistoffigures
\ptlistofcodes
```

Consult PT Commons for the complete table, code, plot, file-tree, semantic
instruction, caption, link, color, and metadata APIs.

## Footnotes

In the default two-column layout, `ftnright` collects ordinary footnotes at the
bottom of the right column. In explicit one-column mode, standard article
footnote placement is used. Author details in the masthead do not consume the
document footnote counter.

## Column balancing

The final page remains unbalanced by default because this is safer for long
figures and tables. Enable balancing explicitly in the preamble:

```latex
\ptbalancecolumns
```

Disable it again with:

```latex
\ptnobalancecolumns
```

The class loads `flushend` during the preamble in two-column mode, avoiding a
late package load at `\begin{document}`. Both commands are harmless in
one-column mode.

## Compilation

Without Minted:

```bash
pdflatex document.tex
xelatex document.tex
lualatex document.tex
```

With Minted when the installed configuration requires shell escape:

```bash
pdflatex -shell-escape document.tex
```

## Regression suite

Run the isolated tests from the repository root:

```bash
./tests/check-regressions.sh
```

The suite exercises PDFLaTeX, XeLaTeX, and LuaLaTeX; the real template; title
errors and idempotence; one/two-column and one/two-sided pagination; long
authors; table wrapping and spacing; footnotes; balancing; languages; font
sizes; and all Commons module compositions. To include the exact Minted
template:

```bash
PT_TEST_MINTED=1 ./tests/check-regressions.sh
```

## Compatibility

- LaTeX format: 2023-06-01 or newer
- Engines: PDFTeX, XeTeX, and LuaTeX
- Shared dependency: PT Commons 0.4, released together with this class
- Other dependencies: declared by the class and enabled Commons modules
- Optional external dependency: Pygments for Minted

## Version history

- v0.3 (2026-08-29): Commons 0.4 integration; namespaced module options;
  explicit column and masthead contracts; wrapping authors; safe balancing;
  display-aware table spacing; modern hooks; documentation and regressions
- v0.2 (2026-08-28): Explicit dependencies, optional Commons modules, and
  one-column title rendering
- v0.1 (2025-10-18): Initial PT Commons integration
