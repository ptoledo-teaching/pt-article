%%
%% pt-article.cls
%% Article document class for ptoledo-teaching
%%
%% Author: Pedro Toledo Correa
%% Repo: https://github.com/ptoledo-teaching/pt-article
%% License: LaTeX Project Public License 1.3c or later
%% Created: 2021-07-01
%% Updated: 2026-08-28
%% Version: v0.2
%%
%% -----------------------------------------------------------------
%% This work may be distributed and/or modified under
%% the conditions of the LaTeX Project Public License,
%% version 1.3c or later. The latest version is available at:
%%     https://www.latex-project.org/lppl.txt
%% -----------------------------------------------------------------
%%

\NeedsTeXFormat{LaTeX2e}[2023-06-01]
\ProvidesClass{pt-article}[2026/08/28 v0.2 PT Article Class]
\makeatletter

% Class handling %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Declare language options for pt-commons
\DeclareOption{spanish}{\PassOptionsToPackage{\CurrentOption}{pt-commons}}
\DeclareOption{english}{\PassOptionsToPackage{\CurrentOption}{pt-commons}}
\DeclareOption{portuguese}{\PassOptionsToPackage{\CurrentOption}{pt-commons}}
\DeclareOption{french}{\PassOptionsToPackage{\CurrentOption}{pt-commons}}
\DeclareOption{nominted}{\PassOptionsToPackage{\CurrentOption}{pt-commons}}
\DeclareOption{coreonly}{\PassOptionsToPackage{\CurrentOption}{pt-commons}}
\DeclareOption{minimal}{\PassOptionsToPackage{\CurrentOption}{pt-commons}}
\DeclareOption{full}{\PassOptionsToPackage{\CurrentOption}{pt-commons}}
\DeclareOption{layout}{\PassOptionsToPackage{\CurrentOption}{pt-commons}}
\DeclareOption{nolayout}{\PassOptionsToPackage{\CurrentOption}{pt-commons}}
\DeclareOption{content}{\PassOptionsToPackage{\CurrentOption}{pt-commons}}
\DeclareOption{nocontent}{\PassOptionsToPackage{\CurrentOption}{pt-commons}}
\DeclareOption{runtime}{\PassOptionsToPackage{\CurrentOption}{pt-commons}}
\DeclareOption{noruntime}{\PassOptionsToPackage{\CurrentOption}{pt-commons}}
% PT Article is two-column by default, but an explicit onecolumn option must
% survive the custom title routine. Later occurrences win.
\newif\ifpt@articleonecolumn
\pt@articleonecolumnfalse
\DeclareOption{onecolumn}{%
    \pt@articleonecolumntrue
    \PassOptionsToClass{\CurrentOption}{article}%
}
\DeclareOption{twocolumn}{%
    \pt@articleonecolumnfalse
    \PassOptionsToClass{\CurrentOption}{article}%
}
% Pass all other options to base article class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
% Default options
\ExecuteOptions{letterpaper}
\ProcessOptions*\relax
% Load base class
\LoadClass{article}
% Load pt-commons package
\RequirePackage{pt-commons}

% Dependencies used directly by this class must not depend on optional Commons
% modules being enabled.
\RequirePackage{enumitem}
\RequirePackage{fancyhdr}
\RequirePackage{geometry}
\RequirePackage{graphicx}

% Page and text formatting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Font sizing
% Fancy footer
\pagestyle{fancy}
\ifpt@loadlayout\else
    % Keep a quiet, useful page style when PT's optional layout is disabled.
    \fancyhf{}
    \cfoot{\thepage}
    \renewcommand{\headrulewidth}{0pt}
\fi
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
% Lists spacing (use enumitem rather than redefining LaTeX internals)
\setlist[itemize,1]{
    leftmargin=21pt,
    labelsep=6pt,
    topsep=6pt,
    parsep=0pt,
    itemsep=0pt
}
\setlist[itemize,2]{
    leftmargin=12pt,
    topsep=0pt
}
\setlist[enumerate,1]{
    leftmargin=21pt,
    labelsep=6pt,
    topsep=6pt,
    parsep=0pt,
    itemsep=0pt
}
\setlist[enumerate,2]{
    leftmargin=12pt,
    topsep=0pt
}
% Sections formating
\renewcommand{\section}{%
    \@startsection{section}%
    {1}{\z@}{6pt \@plus 3pt \@minus 3pt}{6pt \@plus 3pt \@minus 3pt}{\normalfont\large\bfseries}%
}
\renewcommand*\l@section[2]{%
    \ifnum \c@tocdepth >\z@
        \addvspace{6pt}%
        \@dottedtocline{1}{0pt}{21pt}{\bfseries #1}{\bfseries #2}%
    \fi
}
\renewcommand{\subsection}{%
    \@startsection{subsection}%
    {2}{\z@}{6pt \@plus 3pt \@minus 3pt}{6pt \@plus 3pt \@minus 3pt}{\normalfont\normalsize\bfseries}%
}
\renewcommand{\l@subsection}{\@dottedtocline{2}{0pt}{21pt}}
\renewcommand{\subsubsection}{%
    \@startsection{subsubsection}%
    {3}{\z@}{6pt \@plus 3pt \@minus 3pt}{6pt \@plus 3pt \@minus 3pt}{\normalfont\normalsize}%
}
\def\@seccntformat#1{\makebox[21pt][l]{\csname the#1\endcsname.}}
\renewcommand{\l@subsubsection}{\@dottedtocline{3}{0pt}{21pt}}
\renewcommand\paragraph{%
    \@startsection{paragraph}%
    {4}{\z@}{6pt \@plus 3pt \@minus 3pt}{6pt \@plus 3pt \@minus 3pt}{\normalfont\normalsize\underline}%
}
\flushbottom

% Header and footer %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Right footnotes and fixing rule
\RequirePackage{ftnright}
\renewcommand\footnoterule{
    \kern 3pt
    \hrule \@width 126pt
    \kern 3pt
}

% Elements %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Title
\newcommand{\pt@articletitleblock}{%
    \ifdefstring{\pt@logo}{}{}{%
        \noindent\includegraphics[height=30pt]{\pt@logo}%
        \vspace{14pt}%
    }%
    \begin{center}%
        \vspace{6pt}%
        {\Huge\pt@title}\\%
        \ifdefined\pt@titlesub\vspace{6pt}{\LARGE\pt@titlesub}\\\fi%
        \ifdefined\pt@titlesubsub%
            \vspace{6pt}%
            \ifdefined\pt@watermark%
                \pt@watermark\ - %
            \fi%
            {\pt@titlesubsub}\\%
        \fi%
        \ifnum\value{authorindex}>0%
            \vspace{12pt}%
            \titleauthorsboxes%
        \fi%
    \end{center}%
    \vspace{21pt}%
}
\renewcommand{\maketitle}{%
    \renewcommand{\thefootnote}{\alph{footnote}}%
    \ifpt@articleonecolumn
        \if@twocolumn\onecolumn\fi
        \pt@articletitleblock
    \else
        \twocolumn[%
            \begin{@twocolumnfalse}%
                \pt@articletitleblock
            \end{@twocolumnfalse}%
        ]%
    \fi
    \titleauthorsfootnotes%
    \renewcommand{\thefootnote}{\arabic{footnote}}%
}
% Balance columns at the end of the document.
% Default: do NOT force balancing (safer for long figures). Call \ptbalancecolumns to enable.
\newif\ifpt@balancecolumns
\pt@balancecolumnsfalse
\newcommand\ptbalancecolumns{\pt@balancecolumnstrue}
\newcommand\ptnobalancecolumns{\pt@balancecolumnsfalse}
% Load flushend only if balancing was requested (deferred to begin-document)
\AtBeginDocument{\ifpt@balancecolumns\RequirePackage{flushend}\fi}
% Quotation
\renewenvironment{quotation}{%
    \list{}{%
        \leftmargin=21pt%
        \rightmargin=21pt%
        \parsep=7pt%
        \topsep=7pt%
        \listparindent=14pt%
        \itemindent=\listparindent%
        \itshape%
    }%
    \item\relax%
}{%
    \endlist%
}

% Directory tree styles %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ifpt@loadcontent
    \setlength{\DTbaselineskip}{0.5cm}
    \renewcommand{\DTstyle}{\ttfamily\scriptsize}
\fi

% Hooks %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\AfterEndPreamble{
    \maketitle
}
\ifpt@loadcontent
    \AtBeginEnvironment{tblr}{
        \footnotesize
    }
\fi

\makeatother

\endinput
