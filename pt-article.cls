%%
%% pt-article.cls
%% Article document class for ptoledo-teaching
%%
%% Author: Pedro Toledo Correa
%% Repo: https://github.com/ptoledo-teaching/pt-article
%% License: LaTeX Project Public License 1.3c or later
%% Created: 2021-07-01
%% Updated: 2026-08-29
%% Version: v0.3
%%
%% -----------------------------------------------------------------
%% This work may be distributed and/or modified under
%% the conditions of the LaTeX Project Public License,
%% version 1.3c or later. The latest version is available at:
%%     https://www.latex-project.org/lppl.txt
%% -----------------------------------------------------------------
%%

\NeedsTeXFormat{LaTeX2e}[2023-06-01]
\ProvidesClass{pt-article}[2026/08/29 v0.3 PT Article Class]
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
% Individual module controls are namespaced at class level so generic options
% such as `layout` cannot be consumed accidentally by unrelated packages.
\DeclareOption{ptlayout}{\PassOptionsToPackage{layout}{pt-commons}}
\DeclareOption{ptnolayout}{\PassOptionsToPackage{nolayout}{pt-commons}}
\DeclareOption{ptcontent}{\PassOptionsToPackage{content}{pt-commons}}
\DeclareOption{ptnocontent}{\PassOptionsToPackage{nocontent}{pt-commons}}
\DeclareOption{ptruntime}{\PassOptionsToPackage{runtime}{pt-commons}}
\DeclareOption{ptnoruntime}{\PassOptionsToPackage{noruntime}{pt-commons}}
% PT Article is two-column by default. Track the last explicit column option
% and pass exactly one resolved value to the base class.
\newif\ifpt@article@onecolumn
\pt@article@onecolumnfalse
\DeclareOption{onecolumn}{%
    \pt@article@onecolumntrue
}
\DeclareOption{twocolumn}{%
    \pt@article@onecolumnfalse
}
\DeclareOption{titlepage}{%
    \ClassError{pt-article}{The titlepage option is not supported}{%
        Use pt-report for a document with a dedicated title page.}%
}
% Pass all other options to base article class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
% Default options
\ExecuteOptions{letterpaper}
\ProcessOptions*\relax
\ifpt@article@onecolumn
    \PassOptionsToClass{onecolumn}{article}
\else
    \PassOptionsToClass{twocolumn}{article}
\fi
% Load base class
\LoadClass{article}
% Load the matching PT Commons semester release.
\RequirePackage{pt-commons}[2026/08/29]

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
\ptiflayoutloaded{}{%
    % Keep a quiet, useful page style when PT's optional layout is disabled.
    \fancyhf{}
    \cfoot{\thepage}
    \renewcommand{\headrulewidth}{0pt}
}
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
% Allow a controlled final line-breaking pass without globally enabling \sloppy.
\setlength{\emergencystretch}{3em}
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

% In two-column documents, collect footnotes at the bottom of the right column.
\if@twocolumn
    \RequirePackage{ftnright}
\fi
\renewcommand\footnoterule{
    \kern 3pt
    \hrule \@width 126pt
    \kern 3pt
}

% Elements %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Title masthead
\newcommand{\pt@article@missingtitle}{%
    \ClassError{pt-article}{No \string\title\space was provided}{%
        Define \string\title\string{...\string} in the preamble.}%
}

\newcommand{\pt@article@renderlogo}{%
    \ptifmetadata{logo}{%
        \noindent\includegraphics[height=30pt]{\ptmetadata{logo}}%
        \par\vspace{14pt}%
    }{}%
}

\newcommand{\pt@article@rendertitle}{%
    \ptifmetadata{title}{%
        {\Huge\ptmetadata{title}\par}%
    }{%
        \pt@article@missingtitle
    }%
    \ptifmetadata{titlesub}{%
        \vspace{6pt}%
        {\LARGE\ptmetadata{titlesub}\par}%
    }{}%
    \ptifmetadata{titlesubsub}{%
        \vspace{6pt}%
        {\ptifmetadata{watermark}{%
            \ptmetadata{watermark}\space-\space
        }{}%
        \ptmetadata{titlesubsub}\par}%
    }{}%
}

\newcommand{\pt@article@rendertitleauthors}{%
    \ptifauthors{%
        \vspace{12pt}%
        \begingroup
        \centering
        \titleauthorstable\par
        \endgroup
    }{}%
}

\newcommand{\pt@article@titleblock}{%
    \pt@article@renderlogo
    \begin{center}%
        \vspace{6pt}%
        \pt@article@rendertitle
    \end{center}%
    \pt@article@rendertitleauthors
    \vspace{21pt}%
}

\newif\ifpt@article@titlemade
\pt@article@titlemadefalse
\renewcommand{\maketitle}{%
    \ifpt@article@titlemade
        \ClassWarningNoLine{pt-article}{%
            The title masthead was already generated; ignoring duplicate
            \string\maketitle}%
    \else
        \global\pt@article@titlemadetrue
        \if@twocolumn
            \twocolumn[%
                \begin{@twocolumnfalse}%
                    \pt@article@titleblock
                \end{@twocolumnfalse}%
            ]%
        \else
            % Match the top inset that LaTeX's full-width twocolumn heading
            % supplies so the large title remains inside the 42pt margin.
            \vspace*{16pt}%
            \pt@article@titleblock
        \fi
    \fi
}
% Balance columns at the end of the document.
% Flushend must be loaded in the preamble; its behavior remains disabled unless
% the document explicitly calls \ptbalancecolumns.
\newif\ifpt@article@balancecolumns
\pt@article@balancecolumnsfalse
\if@twocolumn
    \RequirePackage{flushend}
\fi
\newcommand\ptbalancecolumns{%
    \pt@article@balancecolumnstrue
    \if@twocolumn\flushend\fi
}
\newcommand\ptnobalancecolumns{%
    \pt@article@balancecolumnsfalse
    \if@twocolumn\raggedend\fi
}
\AddToHook{begindocument/end}[pt-article/column-balance]{%
    \if@twocolumn
        \ifpt@article@balancecolumns\flushend\else\raggedend\fi
    \fi
}
% PGF may issue its own \clearpage from the end-document hook. Flushend
% normally activates its last-page output routine only after that hook, which
% is too late when the Commons content module has loaded TikZ. Activate the
% balancing output routine before PGF can ship the final columns.
\AddToHook{enddocument}[pt-article/column-balance]{%
    \if@twocolumn
        \ifpt@article@balancecolumns\flushcolsend\fi
    \fi
}
\DeclareHookRule{enddocument}{pt-article/column-balance}{before}{pgfcore}
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

\ptifcontentloaded{%
    \setlength{\DTbaselineskip}{0.5cm}
    \renewcommand{\DTstyle}{\ttfamily\scriptsize}
}{}

% Hooks %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\AddToHook{begindocument/end}[pt-article/title]{\maketitle}
% A tblr used directly in the article body is a display and needs its own
% vertical separation. A tblr inside a table float must not add another layer
% of space: the float and caption mechanisms already provide it.
\newif\ifpt@article@tablefloat
\pt@article@tablefloatfalse
\newcommand{\pt@article@addtblrspace}{%
    \ifpt@article@tablefloat\else
        \par\addvspace{\medskipamount}%
    \fi
}
\ptifcontentloaded{%
    \AddToHook{env/table/begin}{\pt@article@tablefloattrue}
    \AddToHook{env/table*/begin}{\pt@article@tablefloattrue}
    \AddToHook{env/tblr/before}{\pt@article@addtblrspace}
    \AddToHook{env/tblr/begin}{\footnotesize}
    \AddToHook{env/tblr/after}{\pt@article@addtblrspace}
}{}

\makeatother

\endinput
