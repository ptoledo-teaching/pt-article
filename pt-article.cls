\ProvidesClass{pt-article}[2021/03/01 v0.1 PT Article Class]
\NeedsTeXFormat{LaTeX2e}

% Load class
\LoadClass{article}

% Class parameters
\renewcommand{\title}[1]{\newcommand{\pta@title}{#1}}
\newcommand{\titlesub}[1]{\newcommand{\pta@titlesub}{#1}}
\newcommand{\logo}[1]{\newcommand{\pta@logo}{#1}}

% Packages
\RequirePackage[english,spanish]{babel}
\RequirePackage{etoolbox}
\RequirePackage{fancyhdr}
\RequirePackage[sfdefault,scaled=.85]{FiraSans}
\RequirePackage[T1]{fontenc}
\RequirePackage{ftnright}
\RequirePackage{geometry}
\RequirePackage{graphicx}
\RequirePackage{hyperref}
\RequirePackage{microtype}
\RequirePackage{newtxsf} % Simbolos matemáticos en sand serif
\RequirePackage{tabularray}
\RequirePackage{xcolor}

% Version
\def\ptaversionmajor{0}
\def\ptaversionminor{1}

% Confitional printing
\newcommand{\ifvardefined}[3]{%
  \ifcsname#1\endcsname%
    #2%
  \else%
    #3%
  \fi
}

% Page format
\geometry{
  left=0.6in,
  right=0.6in,
  top=0.6in,
  bottom=0.6in,
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
\renewcommand\footnoterule{%
  \vfill
  \hrule \@width 0.5\columnwidth \@height 0.4pt \@depth \z@
  \kern 2.7\p@
}

% Header and footer
\pagestyle{fancy}
\renewcommand{\headrule}{}
\lhead{}
\chead{}
\rhead{}
\lfoot{}
\cfoot{\thepage}%/\thetotalpages}
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
  {1}{\z@}{0.1in}{0.1in}{\normalfont\large\bfseries}%
}
\renewcommand*\l@section[2]{%
  \ifnum \c@tocdepth >\z@
    \addvspace{6pt}{\@dottedtocline{3}{0pt}{21pt}{\bfseries #1}{\bfseries #2}}
  \fi
}
\renewcommand{\subsection}{
  \@startsection{subsection}
  {2}{\z@}{0.1in}{0.1in}{\normalfont\normalsize\bfseries}%
}
\renewcommand{\l@subsection}{\@dottedtocline{2}{0pt}{21pt}}
\renewcommand{\subsubsection}{
  \@startsection{subsubsection}
  {3}{\z@}{0.1in}{0.1in}{\normalfont\normalsize}%
}
\def\@seccntformat#1{\makebox[21pt][l]{\csname the#1\endcsname.}}
\renewcommand{\l@subsubsection}{\@dottedtocline{3}{0pt}{21pt}}
\renewcommand\paragraph{
  \@startsection{paragraph}
  {4}{\z@}{0.1in}{0.1in}{\normalfont\normalsize\underline}%
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

% Title
\renewcommand{\maketitle}{
  \renewcommand{\thefootnote}{\alph{footnote}}
  \twocolumn[
    \begin{@twocolumnfalse}
      \ifvardefined{pta@logo}{
        \noindent\includegraphics[height=30pt]{\pta@logo}
        \vspace{12pt}
      }{}
      \begin{center}
        \vspace{7pt}
        {\Huge\pta@title}\\
        \ifvardefined{pta@titlesub}{%
          \vspace{7pt}
          {\LARGE\pta@titlesub}
        }{}\\
        \ifnum\value{authorindex}>0
          \vspace{12pt}
          \authorstitle
        \fi
      \end{center}
      \vspace{35pt}
    \end{@twocolumnfalse}
  ]
  \authorsfooter
  \renewcommand{\thefootnote}{\arabic{footnote}}
}

% Hooks
\AfterEndPreamble{
  \maketitle
  \sloppy
}

\endinput
