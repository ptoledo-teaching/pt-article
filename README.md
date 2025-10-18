# PT Article Class

**Version:** 0.1  
**Date:** 2025/10/18  
**Author:** Pedro Toledo Correa  
**License:** LaTeX Project Public License 1.3c or later  
**Repository:** [GitHub - ptoledo-teaching/pt-commons](https://github.com/ptoledo-teaching/pt-commons)

A professional LaTeX article document class built on top of `pt-commons`, designed for academic papers, technical reports, and professional articles. Features two-column layout, automatic title page generation, and enhanced formatting capabilities.

## Overview

`pt-article` extends the standard LaTeX `article` class with:
- Professional two-column layout with optimized spacing
- Automatic title page with author management
- Custom header/footer with version control
- Enhanced section formatting
- Highlight boxes for important content
- Optional column balancing
- Right-side footnotes
- All features from `pt-commons` package

## Installation

Install both `pt-article.cls` and `pt-commons.sty` in your LaTeX project or texmf tree:

```bash
# Local installation
mkdir -p ~/texmf/tex/latex/pt-article
mkdir -p ~/texmf/tex/latex/pt-commons
cp pt-article.cls ~/texmf/tex/latex/pt-article/
cp pt-commons.sty ~/texmf/tex/latex/pt-commons/
texhash ~/texmf
```

## Basic Usage

```latex
\documentclass{pt-article}

\title{Your Article Title}
\addauthor{John}{Doe}{john.doe@example.com}{University Department}

\begin{document}
% Title is automatically generated

\section{Introduction}
Your content here...

\end{document}
```

## Class Options

### Language Options (from pt-commons)

```latex
\documentclass[english]{pt-article}    % English
\documentclass[spanish]{pt-article}    % Spanish (default)
\documentclass[portuguese]{pt-article} % Portuguese
\documentclass[french]{pt-article}     % French
```

### Standard Article Options

All standard `article` class options are supported:

```latex
\documentclass[twocolumn,10pt]{pt-article}  % Two-column, 10pt font
\documentclass[onecolumn,11pt]{pt-article}  % Single column, 11pt font
\documentclass[12pt]{pt-article}            % 12pt font
```

### Code Environment Options

```latex
\documentclass[nominted]{pt-article}  % Disable minted, use verbatim
```

## Document Metadata

### Title and Authors

```latex
\title{Main Title}
\titlesub{Optional Subtitle}
\titlesubsub{Optional Sub-subtitle}

% Add multiple authors
\addauthor{FirstName}{LastName}{email@example.com}{Affiliation}
\addauthor{Jane}{Smith}{jane@university.edu}{Department of CS, University}

% Optional: Add logo
\logo{path/to/logo.png}
```

The title page is automatically generated at the beginning of the document with:
- Logo (if specified)
- Title hierarchy
- Author boxes with emails
- Footnotes for affiliations

### Version Control

```latex
\version{1.0}              % Set document version
\build{auto}               % Auto-increment build number
\watermark{DRAFT}          % Add watermark
```

The footer displays:
- Page number
- Version (if set): `v1.0`
- Build number and date: `B5 - 2025/10/18`

### Academic Information

```latex
\classcode{CS-101}
\classname{Introduction to Computer Science}
\classsemester{Fall 2025}
```

## Page Layout

The class uses optimized spacing for professional documents:

- **Page margins:** 42pt on all sides
- **Column separation:** 21pt between columns
- **Paragraph indentation:** 21pt
- **Two-column layout** (can be overridden with `onecolumn` option)

### Geometry

```latex
% Automatically configured:
% - Letter paper size
% - 42pt margins (left, right, top, bottom)
% - Footer included in layout
```

## Section Formatting

The class provides custom section formatting with consistent spacing:

```latex
\section{Section Title}           % Large, bold
\subsection{Subsection Title}     % Normal size, bold
\subsubsection{Subsubsection}     % Normal size, regular
\paragraph{Paragraph Title}       % Normal size, underlined
```

**Features:**
- Sections numbered with 21pt spacing
- Bold formatting for sections and subsections
- Underlined paragraph titles
- Consistent 6pt spacing before and after

## Headers and Footers

Automatically configured with `fancyhdr`:

- **Header:** Empty (no header line)
- **Footer Center:** Page number with version/build info
- **Footer Sides:** Empty

The footer displays version and build information in light blue color when defined.

## Special Environments

### Highlight Box

Draw attention to important content:

```latex
\begin{highlightbox}
    This is important information that needs to be highlighted.
    It appears in a colored box within the column.
\end{highlightbox}
```

**Styling:**
- Light blue background (`ptblue!14`)
- Blue border (`ptblue`)
- Rounded corners
- Full column width

### Enhanced Quotations

```latex
\begin{quotation}
    This is a properly formatted quotation with:
    - 21pt left and right margins
    - Italic text
    - Proper paragraph indentation
\end{quotation}
```

## Column Balancing

Control column balancing at the end of the document:

```latex
\ptbalancecolumns     % Enable column balancing (uses flushend)
\ptnobalancecolumns   % Disable column balancing (default)
```

**Default behavior:** Columns are NOT balanced (safer for documents with large figures).

## Footnotes

Footnotes are automatically positioned on the right side using `ftnright` package with a custom rule width (126pt).

## Features from PT Commons

All features from `pt-commons` are available:

### Colors

```latex
\color{ptred}         % PT red
\color{ptblue}        % PT blue
\color{ptlightblue}   % PT light blue
\color{ptgreen}       % PT green
\color{ptyellow}      % PT yellow
\color{ptgray}        % PT gray
```

### Tables

```latex
\begin{tblr}{colspec={lcc}}
    \tableheader
    Header 1 & Header 2 & Header 3 \\
    \tablesubheader
    Data 1   & Data 2   & Data 3   \\
\end{tblr}
```

### Code Formatting

```latex
% With minted (requires -shell-escape)
\begin{minted}{python}
def hello():
    print("Hello, World!")
\end{minted}

% For printing (black & white, framed)
\begin{ptprintcode}{python}
def hello():
    print("Hello, World!")
\end{ptprintcode}

% Inline code
\inlinecode{variable_name}
```

### File Trees

```latex
\begin{filetree}
\begin{ptdirtree}
    \dirtree{%
        .1 \treeiconfirst{project/}.
        .2 \treeicon{src/}.
        .3 \treeicon{main.py}.
        .3 \treeicon{utils.py}.
        .2 \treeicon{README.md}.
    }%
\end{ptdirtree}
\caption{Project structure}
\end{filetree}
```

### Figures

```latex
\ptfigure{h}{width=0.8\columnwidth}{image.png}{Caption text}{label}
```

### Lists of Contents

```latex
\tableofcontents  % Standard TOC
\ptlistoftables   % Only if tables exist
\ptlistoffigures  % Only if figures exist
\ptlistofcodes    % Only if listings exist
```

## Compilation

### Standard Compilation

```bash
pdflatex document.tex
```

### With Code Highlighting (Minted)

```bash
pdflatex -shell-escape document.tex
```

### Full Compilation (with references)

```bash
pdflatex -shell-escape document.tex
bibtex document
pdflatex -shell-escape document.tex
pdflatex -shell-escape document.tex
```

## Example Document

```latex
\documentclass[english]{pt-article}

% Document metadata
\title{A Comprehensive Study of LaTeX Typography}
\titlesub{Best Practices and Guidelines}
\version{1.0}
\build{auto}

% Authors
\addauthor{John}{Doe}{john.doe@university.edu}{Department of Computer Science}
\addauthor{Jane}{Smith}{jane.smith@institute.org}{Research Institute}

% Optional: Add logo
\logo{logos/university-logo.png}

\begin{document}

\begin{abstract}
This paper presents a comprehensive study of LaTeX typography,
exploring best practices for academic and professional documents.
\end{abstract}

\section{Introduction}

LaTeX has been the de facto standard for scientific document preparation
since its creation in the 1980s.

\begin{highlightbox}
    \textbf{Key Point:} Always compile with \inlinecode{-shell-escape} 
    when using code highlighting features.
\end{highlightbox}

\subsection{Background}

The history of \TeX{} and \LaTeX{} is fascinating...

\section{Methodology}

\subsection{Data Collection}

We collected data from various sources...

\begin{quotation}
    ``Typography is the craft of endowing human language with a 
    durable visual form.'' --- Robert Bringhurst
\end{quotation}

\section{Results}

Our findings demonstrate...

\begin{table}[h]
\centering
\begin{tblr}{colspec={lcc}}
    \tableheader
    Method & Accuracy & Time \\
    \hline
    Approach A & 95\% & 10s \\
    Approach B & 97\% & 15s \\
\end{tblr}
\caption{Comparison of different approaches}
\label{tab:results}
\end{table}

\section{Conclusion}

This study has shown that...

\bibliographystyle{plain}
\bibliography{references}

\end{document}
```

## Tips and Best Practices

1. **Use `\addauthor`** for proper author formatting with affiliations
2. **Enable column balancing** only for final versions: `\ptbalancecolumns`
3. **Use highlight boxes** sparingly for key information
4. **Set version and build** for version control tracking
5. **Use `ptfigure`** instead of manual figure environments for consistency
6. **Compile with `-shell-escape`** when using minted for syntax highlighting
7. **Use `\inlinecode`** for code snippets in text
8. **Let the class handle spacing** - don't add manual `\vspace` unless necessary

## Compatibility

- **LaTeX Engine:** PDFTeX, XeTeX, LuaTeX
- **TeX Distribution:** TeX Live 2020 or later
- **Required Packages:** Automatically loaded via `pt-commons`
- **Optional:** Pygments (for minted support)

## Known Limitations

1. Column balancing with `\ptbalancecolumns` may not work well with large floats
2. Minted requires `-shell-escape` flag (security consideration)
3. Build counter files are stored in the document directory

## Troubleshooting

### Build Counter Not Updating

Ensure write permissions in the document directory. The class creates `.buildcount` files.

### Minted Not Working

1. Install Pygments: `pip install Pygments`
2. Compile with: `pdflatex -shell-escape document.tex`
3. Or use `[nominted]` option to disable

### Column Balancing Issues

Disable with `\ptnobalancecolumns` if you have large figures or tables.

## Related Classes

- **pt-book:** Book-style documents with chapters
- **pt-report:** Technical reports with title pages
- **pt-slides:** Beamer-based presentations
- **pt-letter:** Professional letters

## License

This work may be distributed and/or modified under the conditions of the LaTeX Project Public License, version 1.3c or later. The latest version of this license is available at:
https://www.latex-project.org/lppl.txt

## Contributing

Contributions are welcome! Please submit issues and pull requests to the repository.

## Support

For questions and support:
- **GitHub Issues:** [ptoledo-teaching/pt-commons](https://github.com/ptoledo-teaching/pt-commons/issues)
- **Email:** See package author information

---

**Version History:**
- v0.1 (2025-10-18): Initial release with pt-commons integration
