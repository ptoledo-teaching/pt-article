%%
%% pt-article.cls
%% Article document class for ptoledo-teaching
%%
%% Author: Pedro Toledo Correa
%% Repo: https://github.com/ptoledo-teaching/pt-commons
%% License: LaTeX Project Public License 1.3c or later
%% Created: 2021-07-01
%% Updated: 2025-10-18
%% Version: v0.1
%%
%% -----------------------------------------------------------------
%% This work may be distributed and/or modified under
%% the conditions of the LaTeX Project Public License,
%% version 1.3c or later. The latest version is available at:
%%     https://www.latex-project.org/lppl.txt
%% -----------------------------------------------------------------
%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{pt-article}[2025/10/18 v0.1 PT Article Class]
\makeatletter

% Class handling %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Declare language options for pt-commons
\DeclareOption{spanish}{\PassOptionsToPackage{\CurrentOption}{pt-commons}}
\DeclareOption{english}{\PassOptionsToPackage{\CurrentOption}{pt-commons}}
\DeclareOption{portuguese}{\PassOptionsToPackage{\CurrentOption}{pt-commons}}
\DeclareOption{french}{\PassOptionsToPackage{\CurrentOption}{pt-commons}}
\DeclareOption{nominted}{\PassOptionsToPackage{\CurrentOption}{pt-commons}}
% Pass all other options to base article class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
% Default options
\ExecuteOptions{letterpaper}
\ProcessOptions\relax
% Load base class
\LoadClass{article}
% Load pt-commons package
\RequirePackage{pt-commons}

% Page and text formatting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Font sizing
% microtype is already loaded by pt-commons; avoid duplicate loads
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
\renewcommand{\maketitle}{%
    \renewcommand{\thefootnote}{\alph{footnote}}%
    \twocolumn[%
        \begin{@twocolumnfalse}%
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
                        \else%
                        {\pt@titlesubsub}\\%
                    \fi%
                \fi%
                \ifnum\value{authorindex}>0%
                \vspace{12pt}%
                \titleauthorsboxes%
                \fi%
            \end{center}%
            \vspace{21pt}%
        \end{@twocolumnfalse}%
    ]%
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

% Hooks %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\AfterEndPreamble{\maketitle}

\makeatother

\endinput