\ProvidesClass{pt-article}[2021/07/01 v1.0 PT Article Class]
\NeedsTeXFormat{LaTeX2e}

% Load class
\LoadClass{article}

% Class parameters
\renewcommand{\title}[1]{\newcommand{\pta@title}{#1}}
\newcommand{\titlesub}[1]{\newcommand{\pta@titlesub}{#1}}
\newcommand{\titlesubsub}[1]{\newcommand{\pta@titlesubsub}{#1}}
\newcommand{\logo}[1]{\newcommand{\pta@logo}{#1}}
\newcommand{\version}[1]{\newcommand{\pta@version}{#1}}
\newcommand{\build}[1]{\newcommand{\pta@build}{#1}}
\newcommand{\watermark}[1]{\newcommand{\pta@watermark}{#1}}
\newcommand{\docversion}{v\pta@version}

% Packages
\RequirePackage[hyphens]{url}
\RequirePackage[english,spanish]{babel}
\RequirePackage{bookmark}
\RequirePackage[stamp=false]{draftwatermark}
\RequirePackage{etoolbox}
\RequirePackage{fancyhdr}
\RequirePackage[sfdefault,scaled=.85]{FiraSans}
\RequirePackage[T1]{fontenc}
\RequirePackage{ftnright}
\RequirePackage{geometry}
\RequirePackage{graphicx}
\RequirePackage{hyperref}
\RequirePackage{listings}
\RequirePackage{microtype}
\RequirePackage{newtxsf} % Simbolos matemáticos en sand serif
\RequirePackage{pgfplots}
\RequirePackage{tabularray}
\RequirePackage{tcolorbox}
\RequirePackage{xcolor}

% Class version
\def\ptaversionmajor{1}
\def\ptaversionminor{0}

% Conditionals
\newcommand{\ifvardefined}[3]{%
    \ifcsname#1\endcsname%
        #2%
    \else%
        #3%
    \fi
}

% Date format
\newcommand{\todayymd}{\the\year/\twodigits\month/\twodigits\day}
\newcommand{\twodigits}[1]{\ifnum#1<10 0\fi\the#1}

% Plot configuration
\usepgfplotslibrary{groupplots}
\pgfplotsset{compat=1.18}

% Page format
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

% Colors
\definecolor{utfsmred}{RGB}{214,0,25}
\definecolor{utfsmblue}{RGB}{0,75,133}
\definecolor{utfsmgreen}{RGB}{0,132,82}
\definecolor{utfsmyellow}{RGB}{247,174,0}

% Watermark format
\DraftwatermarkOptions{
    angle=45,
    color=utfsmred!21,
    fontsize=84pt
}

% Babel translations
% \renewcommand{\contentsname}{}
% \renewcommand{\listfigurename}{}
% \renewcommand{\listtablename}{}
% \renewcommand{\figurename}{}
% \renewcommand{\tablename}{}
% \renewcommand{\partname}{}
% \renewcommand{\chaptername}{}
% \renewcommand{\appendixname}{}
% \renewcommand{\bibname}{}
% \renewcommand{\indexname}{}
% \renewcommand{\refname}{}
% \renewcommand{\abstractname}{}
% \renewcommand{\proofname}{}
\addto\captionsenglish{
}
\addto\captionsspanish{
    \renewcommand{\tablename}{Tabla}
    \renewcommand{\listtablename}{Índice de tablas}
}

% Links format
\hypersetup{
    colorlinks,
    linkcolor=utfsmblue,
    urlcolor=utfsmblue
}

% Footnotes rule (deleted by ftnright)
\renewcommand\footnoterule{
    \kern 3pt
    \hrule \@width 126pt
    \kern 3pt
}

% Header and footer
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
        \ifvardefined{pta@version}{\\v\pta@version}{}%
        \ifvardefined{pta@build}{%
            \ifvardefined{pta@version}{.}{\\B}\ifdefstring{\pta@build}{auto}{\buildcount}{\pta@build}- \todayymd
        }{%
            \ifvardefined{pta@version}{\ - \todayymd}{}%
        }%
    }%
}
\rfoot{}

% Lists spacing
\def\@listi{\leftmargin 21pt \labelsep 6pt \topsep 6pt \parsep 0pt \itemsep 0pt}
\let\@listI\@listi
\def\@listii{\leftmargin 12pt \topsep 0pt}
\def\@listiii{}
\def\@listiv{}

% Numbered list label styles
\def\labelenumi{\theenumi.}
\def\labelenumii{\theenumii.}
\def\labelenumiii{\theenumiii.}
\def\labelenumiv{\theenumiv.}

\def\theenumi{\arabic{enumi}}
\def\theenumii{\arabic{enumii}}
\def\theenumiii{\arabic{enumiii}}
\def\theenumiv{\arabic{enumiv}}

% Bulleted list label styles
\def\labelitemi{$\scriptstyle\bullet$}
\def\labelitemii{$\scriptstyle\bullet$}
\def\labelitemiii{$\scriptstyle\bullet$}
\def\labelitemiv{$\scriptstyle\bullet$}

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

% Caption formating
\setlength{\abovecaptionskip}{5pt}
\def\@makecaption#1#2{
    \vskip\abovecaptionskip
    \footnotesize
    \textbf{#1:} #2
    \vskip\belowcaptionskip
}

% Tables styling
\renewcommand*\l@table{\@dottedtocline{1}{0pt}{21pt}}
\BeforeBeginEnvironment{tblr}{\centering}
\AtBeginEnvironment{tblr}{\footnotesize}
\newcommand{\cellrotated}[1]{\rotatebox{90}{#1\hspace{4pt}}}
\SetTblrInner{rowsep=0.6pt}
\SetTblrInner{colsep=3pt}
\SetTblrInner{width=\columnwidth}
\NewColumnType{L}[1]{Q[l,t,wd=#1]}
\NewColumnType{C}[1]{Q[c,t,wd=#1]}
\NewColumnType{R}[1]{Q[r,t,wd=#1]}
\NewTableCommand\tableheader{
    \SetRow{
        utfsmblue!42,
        c,
        font=\bfseries
    }
}
\NewTableCommand\tablesubheader{
    \SetRow{
        utfsmblue!21
    }
}

% Figures
\renewcommand*\l@figure{\@dottedtocline{1}{0pt}{21pt}}
\newcommand{\ptfigure}[5]{
    \begin{figure}[#1]
        \centering
        \includegraphics[#2]{#3}
        \caption{#4}
        \label{fig:#5}
    \end{figure}
}

% Listings
\lstset{
    basicstyle=\small\ttfamily,
    backgroundcolor=\color{gray!10},
    keywordstyle=\color{blue},
    commentstyle=\color{green!40!black},
    stringstyle=\color{red},
    rulecolor=\color{gray},
    frame=single,
    framerule=0pt,
    framesep=2pt,
    captionpos=b,
    aboveskip=10pt,
    belowskip=5pt,
    columns=fullflexible,
    keepspaces=true,
    numberstyle=\color{black},
    numbers=left,
    stepnumber=1,
    numbersep=5pt,
    showstringspaces=false,
}
\lstdefinestyle{print}{
    basicstyle=\color{black}\small\ttfamily,
    keywordstyle=\color{black},
    commentstyle=\color{black},
    stringstyle=\color{black},
    identifierstyle=\color{black}
}

% Rule
\newcommand{\templaterule}{
    \vspace{6pt}
    \noindent\hfill\rule{0.42\columnwidth}{0.4pt}\hfill
    \vspace{2pt}
}

% Command to add an author
\newlength{\lengthname}
\newlength{\lengthmail}
\newlength{\minipagelength}
\newcounter{authorindex}
\setcounter{authorindex}{0}
\newcommand\authornameentry[2]{#1, #2}
\newcommand\authoremailentry[1]{\href{mailto:#1}{#1}}
\newcommand\authordetailentry[1]{#1}
\newcommand\addauthor[4]{%
    \stepcounter{authorindex}%
    \expandafter\def\csname authornames\theauthorindex\endcsname{\authornameentry{#1}{#2}}
    \expandafter\def\csname authoremails\theauthorindex\endcsname{\authoremailentry{#3}}
    \expandafter\def\csname authordetails\theauthorindex\endcsname{\authordetailentry{#4}}
    \settowidth{\lengthname}{#1, #2\textsuperscript{\alph{authorindex}}}%
    \settowidth{\lengthmail}{#3}%
    \ifdim\lengthname>\minipagelength
        \setlength{\minipagelength}{\lengthname}%
    \fi
    \ifdim\lengthmail>\minipagelength
        \setlength{\minipagelength}{\lengthmail}%
    \fi
}
\newcommand{\authorstitle}{
    \addtolength{\minipagelength}{3pt}
    \count1=1
    \loop
    \ifnum\count1<\numexpr\value{authorindex}+1\relax
    \begin{minipage}{\minipagelength}
        \centering
        \if\relax\csname authordetails\the\count1\endcsname\relax
            \csname authornames\the\count1\endcsname\\
        \else
            \csname authornames\the\count1\endcsname\footnotemark[\the\count1]\\
        \fi
        \csname authoremails\the\count1\endcsname
    \end{minipage}
    \advance\count1 by 1
    \repeat
}
\newcommand{\authorsfooter}{
    \count1=1
    \loop
    \ifnum\count1<\numexpr\value{authorindex}+1\relax
    \if\relax\csname authordetails\the\count1\endcsname\relax
    \else
        \footnotetext[\the\count1]{\csname authordetails\the\count1\endcsname}
    \fi
    \advance\count1 by 1
    \repeat
}

\newcommand{\ptgrid}[4]{
    \begin{center}
        \begin{tikzpicture}
            \def\nrows{#4}
            \def\ncols{#3}
            \foreach \x in {0,...,\numexpr\ncols-1\relax} {
                    \foreach \y in {0,...,\numexpr\nrows-1\relax} {
                            \draw[thick] (\x*#1, \y*#2) rectangle (\x*#1+#1, \y*#2+#2);
                        }
                }
        \end{tikzpicture}
    \end{center}
}

\newcommand{\ptgridindent}[4]{
    \begin{center}
        \begin{tikzpicture}
            \def\nrows{#4}
            \def\ncols{#3}
            \foreach \x in {0,...,\numexpr\ncols-1\relax} {
                    \foreach \y in {0,...,\numexpr\nrows-1\relax} {
                            \draw[very thin, dashed] (\x*#1, \y*#2) -- (\x*#1, \y*#2+#2); % Vertical dashed lines (even slimmer)
                            \draw[thick] (\x*#1, \y*#2) -- (\x*#1+#1, \y*#2); % Horizontal solid lines
                        }
                }
            % Add the right border
            \foreach \y in {0,...,\numexpr\nrows-1\relax} {
                    \draw[very thin, dashed] (\ncols*#1, \y*#2) -- (\ncols*#1, \y*#2+#2); % Right vertical dashed line (even slimmer)
                }
            % Add the top border
            \foreach \x in {0,...,\numexpr\ncols-1\relax} {
                    \draw[thick] (\x*#1, \nrows*#2) -- (\x*#1+#1, \nrows*#2); % Top horizontal solid line
                }
        \end{tikzpicture}
    \end{center}
}

% Title
\renewcommand{\maketitle}{
    \renewcommand{\thefootnote}{\alph{footnote}}
    \twocolumn[%
        \begin{@twocolumnfalse}%
            \ifvardefined{pta@logo}{\noindent\includegraphics[height=30pt]{\pta@logo}\vspace{14pt}}{}%
            \begin{center}%
                \vspace{6pt}%
                {\Huge\pta@title}\\%
                \ifvardefined{pta@titlesub}{\vspace{6pt}{\LARGE\pta@titlesub}\\}{}%
                \ifvardefined{pta@titlesubsub}{\vspace{6pt}\ifvardefined{pta@watermark}{\pta@watermark\ - }{}{\pta@titlesubsub}\\}{}%
                \ifnum\value{authorindex}>0%
                \vspace{12pt}%
                \authorstitle%
                \fi%
            \end{center}%
            \vspace{21pt}%
        \end{@twocolumnfalse}%
    ]
    \authorsfooter
    \renewcommand{\thefootnote}{\arabic{footnote}}
}

% Environments
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

% Hooks
\AfterEndPreamble{
    \ifvardefined{pta@watermark}{%
        \DraftwatermarkOptions{stamp=true}
        \SetWatermarkText{\pta@watermark\ifvardefined{pta@version}{\ - v\pta@version\ifvardefined{pta@build}{\ifdefstring{\pta@build}{auto}{.\buildcount}{.\pta@build}}{}}{\ifvardefined{pta@build}{\ifdefstring{\pta@build}{auto}{\ - B\buildcount}{\ - B\pta@build}}{}}}
    }{}
    \maketitle
    \sloppy
}
\newcommand{\buildcountfile}{
    \ifvardefined{pta@version}{
        \jobname\pta@version.buildcount
    }{
        \jobname.buildcount
    }
}
\AtBeginDocument{
    \IfFileExists{\buildcountfile}{%
        \newread\file
        \openin\file=\buildcountfile
        \read\file to\buildcount
        \closein\file
        \ifx\buildcount\empty
            \def\buildcount{0}
        \fi
    }{
        \def\buildcount{0}
    }
}
\AtEndDocument{
    \newwrite\file
    \immediate\openout\file=\buildcountfile
    \edef\next{\number\numexpr\buildcount+1\relax}
    \immediate\write\file{\next}
    \immediate\closeout\file
}

% Vertical spacing to fill columns
\flushbottom

\endinput
