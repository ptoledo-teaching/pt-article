\ProvidesClass{pt-article}[2021/07/01 v1.0 PT Article Class]
\NeedsTeXFormat{LaTeX2e}

% Class handling %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Pass user options to pt-commons
\DeclareOption*{%
    \PassOptionsToClass{\CurrentOption}{pt-commons}
}
\ProcessOptions\relax
% Fixed options
\PassOptionsToClass{letterpaper}{article}
% Loading class
\LoadClass{article}
% Loading pt-commons
\RequirePackage{pt-commons}

% Page and text formatting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Font sizing
\RequirePackage{microtype}
% Page size
\geometry{
    left=42pt,
    right=42pt,
    top=42pt,
    bottom=42pt,
    includefoot
}
% Column separation
\setlength{\columnsep}{21pt}
% Paragraph indentation
\setlength{\parindent}{21pt}
% Line spacing
\sloppy
% Lists spacing
\def\@listi{\leftmargin 21pt \labelsep 6pt \topsep 6pt \parsep 0pt \itemsep 0pt}
\let\@listI\@listi
\def\@listii{\leftmargin 12pt \topsep 0pt}
\def\@listiii{}
\def\@listiv{}
% Sections formating
\renewcommand{\section}{
    \@startsection{section}
    {1}{\z@}{6pt \@plus 3pt \@minus 3pt}{6pt \@plus 3pt \@minus 3pt}{\normalfont\large\bfseries}%
}
\renewcommand*\l@section[2]{%
    \ifnum \c@tocdepth >\z@
        \addvspace{6pt}{\@dottedtocline{3}{0pt}{21pt}{\bfseries #1}{\bfseries #2}}
    \fi
}
\renewcommand{\subsection}{
    \@startsection{subsection}
    {2}{\z@}{6pt \@plus 3pt \@minus 3pt}{6pt \@plus 3pt \@minus 3pt}{\normalfont\normalsize\bfseries}%
}
\renewcommand{\l@subsection}{\@dottedtocline{2}{0pt}{21pt}}
\renewcommand{\subsubsection}{
    \@startsection{subsubsection}
    {3}{\z@}{6pt \@plus 3pt \@minus 3pt}{6pt \@plus 3pt \@minus 3pt}{\normalfont\normalsize}%
}
\def\@seccntformat#1{\makebox[21pt][l]{\csname the#1\endcsname.}}
\renewcommand{\l@subsubsection}{\@dottedtocline{3}{0pt}{21pt}}
\renewcommand\paragraph{
    \@startsection{paragraph}
    {4}{\z@}{6pt \@plus 3pt \@minus 3pt}{6pt \@plus 3pt \@minus 3pt}{\normalfont\normalsize\underline}%
}
\flushbottom

% Header and footer %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{fancyhdr}
\pagestyle{fancy}
\renewcommand{\headrule}{}
\lhead{}
\chead{}
\rhead{}
\lfoot{}
\cfoot{
    \thepage%
    {%
        \color{utfsmblue!21}
        \ifvardefined{pt@version}{\\v\pt@version}{}%
        \ifvardefined{pt@build}{%
            \ifvardefined{pt@version}{.}{\\B}\ifdefstring{\pt@build}{auto}{\buildcount}{\pt@build}- \todayymd
        }{%
            \ifvardefined{pt@version}{\ - \todayymd}{}%
        }%
    }%
}
\rfoot{}
% Right footnotes and fixing rule
\RequirePackage{ftnright}
\renewcommand\footnoterule{
    \kern 3pt
    \hrule \@width 126pt
    \kern 3pt
}

% Elements %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Title
\renewcommand{\maketitle}{
    \renewcommand{\thefootnote}{\alph{footnote}}
    \twocolumn[%
        \begin{@twocolumnfalse}%
            \ifvardefined{pt@logo}{\noindent\includegraphics[height=30pt]{\pt@logo}\vspace{14pt}}{}%
            \begin{center}%
                \vspace{6pt}%
                {\Huge\pt@title}\\%
                \ifvardefined{pt@titlesub}{\vspace{6pt}{\LARGE\pt@titlesub}\\}{}%
                \ifvardefined{pt@titlesubsub}{\vspace{6pt}\ifvardefined{pt@watermark}{\pt@watermark\ - }{}{\pt@titlesubsub}\\}{}%
                \ifnum\value{authorindex}>0%
                \vspace{12pt}%
                \titleauthorsboxes%
                \fi%
            \end{center}%
            \vspace{21pt}%
        \end{@twocolumnfalse}%
    ]
    \titleauthorsfootnotes
    \renewcommand{\thefootnote}{\arabic{footnote}}
}
% Highlight box
\newenvironment{highlightbox}{%
    \begin{tcolorbox}[
            width=\columnwidth,
            colback=utfsmblue!14,
            colframe=utfsmblue,
            boxrule=0.4pt,
            arc=3pt,
            outer arc=3pt
        ]
        }{
    \end{tcolorbox}
}
% Balance columns
\newif\ifpt@balancecolumns
\pt@balancecolumnstrue
\newcommand\ptbalancecolumns{\pt@balancecolumnstrue}
\newcommand\ptnobalancecolumns{\pt@balancecolumnsfalse}
\ptbalancecolumns
\ifpt@balancecolumns
\else
    \RequirePackage{flushend}
\fi

% Hooks %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\AfterEndPreamble{
    \ifvardefined{pta@watermark}{%
        \DraftwatermarkOptions{stamp=true}
        \SetWatermarkText{\pta@watermark\ifvardefined{pta@version}{\ - v\pta@version\ifvardefined{pta@build}{\ifdefstring{\pta@build}{auto}{.\buildcount}{.\pta@build}}{}}{\ifvardefined{pta@build}{\ifdefstring{\pta@build}{auto}{\ - B\buildcount}{\ - B\pta@build}}{}}}
    }{}
    \maketitle
}

\endinput
