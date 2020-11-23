% Initial authors:     Michael Enders, Felix Lammermann
% Author's emails:     latex@flammermann.de
%
% Current maintainers: Markus Putnings
% Maintainer's emails: markus.putnings@fau.de
%
%
% Copyright 2019--2020 Michael Enders & Felix Lammermann
% 
% This work may be distributed and/or modified under the conditions of the
% LaTeX Project Public License, either version 1.3c of this license or (at your
% option) any later version.
% 
% The latest version of this license is in
% 
%   http://www.latex-project.org/lppl.txt
% 
% and version 1.3c or later is part of all distributions of LaTeX version
% 2008-05-04 or later.
% 
% This work has the LPPL maintenance status `maintained'.
% The current maintainer of this work is Markus Putnings.


\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{faupress}[2019/11/23 LaTeX Class for FAU University Press]


%%% LUALATEX %%%

% It is highly recommended to compile the documents based on this class with
% lualatex instead of standard pdflatex, because it makes the use of fonts
% significantly easier. Fallbacks for pdflatex are still included. In order
% to detect whether or not lualatex is used the ifluatex package is included.

\RequirePackage{ifluatex} % 2019/10/25 v1.5

% Whenever different commands or packages are required by lualatex or pdflatex
% the ifluatex command is used. Just like here where a class warning is given
% is pdflatex is used.

\ifluatex
% do nothing
\else
\ClassWarning{faupress}{You are not using LuaLaTeX for compilation! It is
  highly recommended to use LuaLaTeX, because it allocates memory dynamically
  (required for very large documents) and because the handling of fonts is more
  flexible.}
\fi


%%% HELPERS %%%

% The calc package enables calculations within length settings. It is commonly
% used and thus included by default in this class.

\RequirePackage{calc} % 2017/05/25 v4.3

% The xparse package allows to define new commands and environments more
% flexible. For example commands with multiple optional arguments can easily be
% defined.

\RequirePackage{xparse} % 2020-05-15 L3

% Sometimes you might define shortcuts for words or parts of a sentence.
% Depending whether the word is placed right before a punctuation mark, there
% should be a space after the word or not. The automatic placement of such
% spaces is enabled by the package xspace.

\RequirePackage{xspace} % 2014/10/28 v1.13

% Especially when creating new packages or classes if conditions are used all
% the time. The ifthen package provides an easy syntax for this as well as
% methodis for comparision of strings and numbers.

\RequirePackage{ifthen} % 2014/09/29 v1.1c

% The xstring package provides macros for manipulating strings - testing a
% string’s contents, extracting substrings, substitution of substrings and
% providing numbers such as string length, position of, or number of
% recurrences of, a substring. 

\RequirePackage{xstring} % 2019/02/06 v1.83


%%% CLASS OPTIONS %%%

% The options for this class shall all be in key-value format, because it is
% way more flexible than static options. For this task the kvoptions package is
% used. There are multiple ways to create options. String options and boolean
% options are most commonly used.

% In this class the string options will in most cases be converted to booleans,
% which makes working with them easier and allows multiple strings to have the
% same effect. The conversion is done in two steps. Firstly new booleans for
% all possible settings are created and initialized as false. Secondly the
% booleans are altered to true depending on the setting it receives from the
% kay-value option.

\RequirePackage{xkeyval} % 2014/12/03 v2.7a

% The paper format will be set to a size of 17cm × 24cm (also called
% Studienpartitur) as default. The only other option is DIN A5 paper. For this
% option a string is used to identify the paper format, which will later be
% converted to booleans.

\newif\iffaupress@studienpartitur\faupress@studienpartiturfalse
\newif\iffaupress@afive\faupress@afivefalse

\define@choicekey*+{faupress}{paper}[\val\nr]{%
  default,%
  studienpartitur,%
  17x24,%
  a5paper,%
  a5%
}{%
  \ifcase\nr\relax % default
    \faupress@studienpartiturtrue
    \faupress@afivefalse
  \or % studienpartitur
    \faupress@studienpartiturtrue
    \faupress@afivefalse
  \or % 17x24
    \faupress@studienpartiturtrue
    \faupress@afivefalse
  \or % a5paper
    \faupress@studienpartiturfalse
    \faupress@afivetrue
  \or % a5
    \faupress@studienpartiturfalse
    \faupress@afivetrue
  \fi
}{
  \ClassWarning{faupress}{unsupported paper format ignored, default (17x24) used}
}

% The user will be enabled to decide whether he wants the list of acronyms to
% be split in abbreviations and symbols (split) or have a combined list for
% both types (combined). If there are no abbreviations or no symbols used the
% functionality can be turned off partially (no symbol, no abbreviation, only
% symbol, only abbreviation). Furthermore the user can decide to turn off
% everything concerning acronyms (none) to enable own inplementations of
% acronyms and how they are handled. For this option again a string is used. 

\newif\iffaupress@acronym\faupress@acronymfalse
\newif\iffaupress@combinedacronym\faupress@combinedacronymfalse
\newif\iffaupress@splitacronym\faupress@splitacronymfalse
\newif\iffaupress@abbreviation\faupress@abbreviationfalse
\newif\iffaupress@symbol\faupress@symbolfalse

\define@choicekey*+{faupress}{acronym}[\val\nr]{%
  default,%
  true,%
  false,%
  combined,%
  split,%
  none,%
  noabbreviation,%
  onlyabbreviation,%
  nosymbol,%
  onlysymbol,%
}{%
  \ifcase\nr\relax % default
    \faupress@acronymtrue
    \faupress@combinedacronymfalse
    \faupress@splitacronymtrue
    \faupress@abbreviationfalse
    \faupress@symbolfalse
  \or % true
    \faupress@acronymtrue
    \faupress@combinedacronymfalse
    \faupress@splitacronymtrue
    \faupress@abbreviationfalse
    \faupress@symbolfalse
  \or % false
    \faupress@acronymfalse
    \faupress@combinedacronymfalse
    \faupress@splitacronymfalse
    \faupress@abbreviationfalse
    \faupress@symbolfalse
  \or % combined
    \faupress@acronymtrue
    \faupress@combinedacronymtrue
    \faupress@splitacronymfalse
    \faupress@abbreviationfalse
    \faupress@symbolfalse
  \or % split
    \faupress@acronymtrue
    \faupress@combinedacronymfalse
    \faupress@splitacronymtrue
    \faupress@abbreviationfalse
    \faupress@symbolfalse
  \or % none
    \faupress@acronymfalse
    \faupress@combinedacronymfalse
    \faupress@splitacronymfalse
    \faupress@abbreviationfalse
    \faupress@symbolfalse
  \or % noabbreviation
    \faupress@acronymtrue
    \faupress@combinedacronymfalse
    \faupress@splitacronymfalse
    \faupress@abbreviationfalse
    \faupress@symboltrue
  \or % onlyabbreviation
    \faupress@acronymtrue
    \faupress@combinedacronymfalse
    \faupress@splitacronymfalse
    \faupress@abbreviationtrue
    \faupress@symbolfalse
  \or % nosymbol
    \faupress@acronymtrue
    \faupress@combinedacronymfalse
    \faupress@splitacronymfalse
    \faupress@abbreviationtrue
    \faupress@symbolfalse
  \or % onlysymbol
    \faupress@acronymtrue
    \faupress@combinedacronymfalse
    \faupress@splitacronymfalse
    \faupress@abbreviationfalse
    \faupress@symboltrue
  \fi
}{
  \ClassWarning{faupress}{unsupported acronym option ignored, default (split) used}
}

% The user will furthermore be enabled to decide about the lines drawn in the
% list(s) of acronyms. By defaul horizontal and vertical lines are drawn into
% the tables (both, all, default, true). There are also options to only draw
% vertical lines (onlyvertical, nohorizontal), only draw horizontal lines
% (onlyhorizontal, novertical) or not draw any lines (none, false). For this
% option again a string is used. 

\newif\iffaupress@acronymlineboth\faupress@acronymlinebothfalse
\newif\iffaupress@acronymlinenone\faupress@acronymlinenonefalse
\newif\iffaupress@acronymlinehorizontal\faupress@acronymlinehorizontalfalse
\newif\iffaupress@acronymlinevertical\faupress@acronymlineverticalfalse

\define@choicekey*+{faupress}{acronymline}[\val\nr]{%
  default,%
  true,%
  false,%
  both,%
  all,%
  none,%
  nohorizontal,%
  onlyhorizontal,%
  novertical,%
  onlyvertical,%
}{%
  \ifcase\nr\relax % default
    \faupress@acronymlinebothtrue
    \faupress@acronymlinenonefalse
    \faupress@acronymlinehorizontalfalse
    \faupress@acronymlineverticalfalse
  \or % true
    \faupress@acronymlinebothtrue
    \faupress@acronymlinenonefalse
    \faupress@acronymlinehorizontalfalse
    \faupress@acronymlineverticalfalse
  \or % false
    \faupress@acronymlinebothfalse
    \faupress@acronymlinenonetrue
    \faupress@acronymlinehorizontalfalse
    \faupress@acronymlineverticalfalse
  \or % both
    \faupress@acronymlinebothtrue
    \faupress@acronymlinenonefalse
    \faupress@acronymlinehorizontalfalse
    \faupress@acronymlineverticalfalse
  \or % all
    \faupress@acronymlinebothtrue
    \faupress@acronymlinenonefalse
    \faupress@acronymlinehorizontalfalse
    \faupress@acronymlineverticalfalse
  \or % none
    \faupress@acronymlinebothfalse
    \faupress@acronymlinenonetrue
    \faupress@acronymlinehorizontalfalse
    \faupress@acronymlineverticalfalse
  \or % nohorizontal
    \faupress@acronymlinebothfalse
    \faupress@acronymlinenonefalse
    \faupress@acronymlinehorizontalfalse
    \faupress@acronymlineverticaltrue
  \or % onlyhorizontal
    \faupress@acronymlinebothfalse
    \faupress@acronymlinenonefalse
    \faupress@acronymlinehorizontaltrue
    \faupress@acronymlineverticalfalse
  \or % novertical
    \faupress@acronymlinebothfalse
    \faupress@acronymlinenonefalse
    \faupress@acronymlinehorizontaltrue
    \faupress@acronymlineverticalfalse
  \or % onlyvertical
    \faupress@acronymlinebothfalse
    \faupress@acronymlinenonefalse
    \faupress@acronymlinehorizontalfalse
    \faupress@acronymlineverticaltrue
  \fi
}{
  \ClassWarning{faupress}{unsupported acronymline option ignored, default (both) used}
}

% The bibliography apparatus implemented in this class can be turned off by a
% class option to enable own implementations to the user. Providently this
% function is also implemented as a string option in case there will be more
% settings concerning bibliographies in the future.

\newif\iffaupress@bibliography\faupress@bibliographyfalse
\newif\iffaupress@splitbibliography\faupress@splitbibliographyfalse
\newif\iffaupress@combinedbibliography\faupress@combinedbibliographyfalse

\define@choicekey*+{faupress}{bibliography}[\val\nr]{%
  default,%
  true,%
  false,%
  split,%
  combined,%
  none,%
}{%
  \ifcase\nr\relax % default
    \faupress@bibliographytrue
    \faupress@splitbibliographytrue
    \faupress@combinedbibliographyfalse
  \or % true
    \faupress@bibliographytrue
    \faupress@splitbibliographytrue
    \faupress@combinedbibliographyfalse
  \or % false
    \faupress@bibliographyfalse
    \faupress@splitbibliographyfalse
    \faupress@combinedbibliographyfalse
  \or % split
    \faupress@bibliographytrue
    \faupress@splitbibliographytrue
    \faupress@combinedbibliographyfalse
  \or % combined
    \faupress@bibliographytrue
    \faupress@splitbibliographyfalse
    \faupress@combinedbibliographytrue
  \or % none
    \faupress@bibliographyfalse
    \faupress@splitbibliographyfalse
    \faupress@combinedbibliographyfalse
  \fi
}{
  \ClassWarning{faupress}{unsupported bibliography option ignored, default (split) used}
}

% The bibliography in this class can have three parts. The parts are for
% references used in this work (main), own publications referring to this work
% (own) and students' theses referring to this work (student). The parts shall
% be selectable by class option.

\newif\iffaupress@mainbibliography\faupress@mainbibliographyfalse
\newif\iffaupress@ownbibliography\faupress@ownbibliographyfalse
\newif\iffaupress@studentbibliography\faupress@studentbibliographyfalse

\define@choicekey*+{faupress}{bibliographypart}[\val\nr]{%
  default,%
  true,%
  false,%
  all,%
  none,%
  nomain,%
  onlymain,%
  noown,%
  onlyown,%
  nostudent,%
  onlystudent,%
}{%
  \ifcase\nr\relax % default
    \faupress@mainbibliographytrue
    \faupress@ownbibliographytrue
    \faupress@studentbibliographytrue
  \or % true
    \faupress@mainbibliographytrue
    \faupress@ownbibliographytrue
    \faupress@studentbibliographytrue
  \or % false
    \faupress@mainbibliographyfalse
    \faupress@ownbibliographyfalse
    \faupress@studentbibliographyfalse
  \or % all
    \faupress@mainbibliographytrue
    \faupress@ownbibliographytrue
    \faupress@studentbibliographytrue
  \or % none
    \faupress@mainbibliographyfalse
    \faupress@ownbibliographyfalse
    \faupress@studentbibliographyfalse
  \or % nomain
    \faupress@mainbibliographyfalse
    \faupress@ownbibliographytrue
    \faupress@studentbibliographytrue
  \or % onlymain
    \faupress@mainbibliographytrue
    \faupress@ownbibliographyfalse
    \faupress@studentbibliographyfalse
  \or % noown
    \faupress@mainbibliographytrue
    \faupress@ownbibliographyfalse
    \faupress@studentbibliographytrue
  \or % onlyown
    \faupress@mainbibliographyfalse
    \faupress@ownbibliographytrue
    \faupress@studentbibliographyfalse
  \or % nostudent
    \faupress@mainbibliographytrue
    \faupress@ownbibliographytrue
    \faupress@studentbibliographyfalse
  \or % onlystudent
    \faupress@mainbibliographyfalse
    \faupress@ownbibliographyfalse
    \faupress@studentbibliographytrue
  \fi
}{
  \ClassWarning{faupress}{unsupported bibliographypart option ignored, default (all) used}
}

% The template and its language depended parts are available in German and
% English, but not in any other languages. To enable the user to choose one of
% the two template languages a class option is used.

% There might be situations in which the user wants to use the microtypographic
% finesses of another language somewhere in the continous text (e.g. a quote
% from a French or Hungarian author). Other languages can be loaded in the
% individual preamble via \setotherlanguage (polyglossia) or before loading the
% this class via \PassOptionsToPackage (babel).

\newif\iffaupress@german\faupress@germanfalse
\newif\iffaupress@english\faupress@englishfalse

\define@choicekey*+{faupress}{language}[\val\nr]{%
  default,%
  german,ngerman,germanb,austrian,naustrian,%
  english,USenglish,american,UKenglish,british,canadian,australian,newzealand,%
}{%
  \ifcase\nr\relax % default
    \faupress@englishfalse
    \faupress@germantrue
  \or % german
    \faupress@englishfalse
    \faupress@germantrue
  \or % ngerman
    \faupress@englishfalse
    \faupress@germantrue
  \or % germanb
    \faupress@englishfalse
    \faupress@germantrue
  \or % austrian
    \faupress@englishfalse
    \faupress@germantrue
  \or % naustrian
    \faupress@englishfalse
    \faupress@germantrue
  \or % english
    \faupress@englishtrue
    \faupress@germanfalse
  \or % USenglish
    \faupress@englishtrue
    \faupress@germanfalse
  \or % american
    \faupress@englishtrue
    \faupress@germanfalse
  \or % UKenglish
    \faupress@englishtrue
    \faupress@germanfalse
  \or % british
    \faupress@englishtrue
    \faupress@germanfalse
  \or % canadian
    \faupress@englishtrue
    \faupress@germanfalse
  \or % australian
    \faupress@englishtrue
    \faupress@germanfalse
  \or % newzealand
    \faupress@englishtrue
    \faupress@germanfalse
  \fi
}{
  \ClassWarning{faupress}{unsupported language ignored, default (german) used}
}

% When the title becomes very long the author might want to choose a smaller font. 

\newif\iffaupress@titleHuge\faupress@titleHugefalse
\newif\iffaupress@titleLARGE\faupress@titleLARGEfalse
\newif\iffaupress@titleLarge\faupress@titleLargefalse
\newif\iffaupress@titlelarge\faupress@titlelargefalse
\newif\iffaupress@titlenormalsize\faupress@titlenormalsizefalse

\define@choicekey*+{faupress}{titlesize}[\val\nr]{%
  default,%
  Huge,%
  LARGE,%
  Large,%
  large,%
  normalsize,%
}{%
  \ifcase\nr\relax % default
    \faupress@titleHugetrue
    \faupress@titleLARGEfalse
    \faupress@titleLargefalse
    \faupress@titlelargefalse
    \faupress@titlenormalsizefalse
  \or % Huge
    \faupress@titleHugetrue
    \faupress@titleLARGEfalse
    \faupress@titleLargefalse
    \faupress@titlelargefalse
    \faupress@titlenormalsizefalse
  \or % LARGE
    \faupress@titleHugefalse
    \faupress@titleLARGEtrue
    \faupress@titleLargefalse
    \faupress@titlelargefalse
    \faupress@titlenormalsizefalse
  \or % Large
    \faupress@titleHugefalse
    \faupress@titleLARGEfalse
    \faupress@titleLargetrue
    \faupress@titlelargefalse
    \faupress@titlenormalsizefalse
  \or % large
    \faupress@titleHugefalse
    \faupress@titleLARGEfalse
    \faupress@titleLargefalse
    \faupress@titlelargetrue
    \faupress@titlenormalsizefalse
  \or % normalsize
    \faupress@titleHugefalse
    \faupress@titleLARGEfalse
    \faupress@titleLargefalse
    \faupress@titlelargefalse
    \faupress@titlenormalsizetrue
  \fi
}{
  \ClassWarning{faupress}{unsupported title size ignored, default (Huge) used}
}

% Whether the start of a new paragraph should be visualized with a small
% vertical skip or an indention of the first line, is a matter of taste.
% Therefore the author can choose if a skip, a halfskip or an indention should
% be used.

\newif\iffaupress@parskip\faupress@parskipfalse
\newif\iffaupress@parhalfskip\faupress@parhalfskipfalse
\newif\iffaupress@parindent\faupress@parindentfalse

\define@choicekey*+{faupress}{par}[\val\nr]{%
  default,%
  skip,%
  halfskip,%
  indent,%
}{%
  \ifcase\nr\relax % default
    \faupress@parskipfalse
    \faupress@parhalfskiptrue
    \faupress@parindentfalse
  \or % skip
    \faupress@parskiptrue
    \faupress@parhalfskipfalse
    \faupress@parindentfalse
  \or % halfskip
    \faupress@parskipfalse
    \faupress@parhalfskiptrue
    \faupress@parindentfalse
  \or % indent
    \faupress@parskipfalse
    \faupress@parhalfskipfalse
    \faupress@parindenttrue
  \fi
}{
  \ClassWarning{faupress}{unsupported paragraph separation ignored, default (halfskip) used}
}

% After all these options were defined, we need to process them in order to
% make the set values available for the further parts of this class.

\ExecuteOptionsX<faupress>{
  paper = default,%
  acronym = default,%
  acronymline = default,%
  bibliography = default,%
  bibliographypart = default,%
  language = default,%
  titlesize = default,%
  par = default,%
}
\ProcessOptionsX<faupress>


%%% BASE CLASS %%%

% This class shall be based on the KOMA script and more specifically on the
% scrbook class, which is loaded here.

\LoadClass{scrbook} % 2020/04/19 v3.30

% Some packages from other authors do not work well with KOMA-Script.  The
% scrhack package alters the commands and definitions of other packages to work
% better with KOMA-Script.

\RequirePackage{scrhack} % 2020/04/19 v3.30

% The KOMA script has a whole lot of options, that will be set continously
% throughout this class whenever required. Further options can be loaded by the
% user in the individual preamble via \KOMAoptions.

\KOMAoptions{
  listof   = totoc,
  toc      = chapterentrydotfill,
  captions = tableheading,
  captions = figuresignature,
}


%%% MACROTYPOGRAPHY %%%

% The page size and margins can easily be controlled by the geometry package.
% Usually we would not use this package because the definitions made by the
% KOMA classes are very thought-out. However the paper format and margins
% required by FAU Univeristy Press are impossible to achieve with the KOMA
% classes. 

\RequirePackage{geometry} % 2020/01/02 v5.9

\iffaupress@studienpartitur
  \geometry{
    paperwidth   =    170mm,
    paperheight  =    240mm,
    top          =     25mm,
    bottom       =     20mm,
    inner        =     25mm,
    outer        =     20mm,
    headheight   =      1em,
    headsep      = 15mm-1em,
    footskip     =    7.5mm,
    %showframe,  
  }
\fi

\iffaupress@afive
  \geometry{
    paper = a5paper ,
    top          =     23mm,
    bottom       =     18mm,
    inner        =     23mm,
    outer        =     18mm,
    headheight   =      1em,
    headsep      = 13mm-1em,
    footskip     =      8mm,
    %showframe,  
  }
\fi

% The scrlayer-scrpage package is part of the KOMA script and provides
% functionalities to set the page headers and footers.

\RequirePackage{scrlayer-scrpage} % 2020/04/19 v3.30

% We want to automatically set the chapter (number and name) as the running
% head on even pages and the section (number and name) on odd pages.
% Fortunately exactly this requirement is an example from the KOMA script
% documentation. First we turn on headings of the KOMA class (\pagestyle),
% afterwards we ensure that chapters automatically set leftmark and rightmark
% (\automark) and at last we also allow sections to automatically set
% rightmarks as well (\automark*). <-- watch out for the asterisk

% To better understand how leftmark and rightmark work, please read
% corresponding chapter in the KOMA script documentation. In summary and only
% valid if no further settings are given: The optional argument of automark
% sets rightmark, the mandatory argument sets leftmark. In two-sided documents
% leftmark is printed in the left header on even pages and rightmark is printed
% in the right header on odd pages.

\pagestyle{scrheadings}
\automark[chapter]{chapter}
\automark*[section]{}


%%% LANGUAGES & LANGUAGE DEPENDED ELEMENTS %%%

% The package enabling extensive language support differs between pdflatex and
% lualatex. Therefore, we again require the \ifluatex switch. Regardless of
% the language chosen by the user, both language choices (German and English)
% are loaded, but the chosen one is set as the default language (polyglossia)
% or main language (babel).

% In the polyglossia package the German language in new spelling rules is
% selected with the option german. In the babel package the same option is
% called ngerman.

\ifluatex
  
  \RequirePackage{polyglossia} % 2020/04/08 v1.49
    
  \iffaupress@german
    \setdefaultlanguage{german}
    \setotherlanguage{english}
  \fi
  
  \iffaupress@english
    \setdefaultlanguage{english}
    \setotherlanguage{german}
  \fi

\else
  
  \iffaupress@german
    \RequirePackage[
      english,
      ngerman
    ]{babel} % 2020/06/10 3.45
  \fi
  
  \iffaupress@english
    \RequirePackage[
      ngerman,
      english
    ]{babel} % 2020/06/10 3.45
  \fi

\fi

% Specific keywords used in a document are set automatically by LaTeX (e.g. the
% heading of the table of contents or the bibliography). Some of those keywords
% shall be set to different values.

% The keywords are obviously language depended and both language packages
% define keywords per language in \captions<language>. The definition of keywords is
% extended by the hyperref package via \HyLang@<language>. 

% Two languages (German and English) are loaded above and both language
% packages allow switching between those mid-document. Therefore, the renewal
% of keywords needs to be done in \captionsgerman as well as \captionsenglish
% and \HyLang@german as well as \HyLang@english, regardless of the main
% language chosen by the user. Again the naming inconsistency between
% ployglossia and babel kicks in and \captionsgerman becomes \captionsngerman
% when compiling with pdflatex.

% To stabilze changes made in the packages also the keywords that remain
% unchanged are renewed.

\ifluatex

  \addto\captionsgerman{%
    \def\prefacename{Vorwort}                % unchanged, original: Vorwort
    \def\refname{Literatur}                  % unchanged, original: Literatur
    \def\abstractname{Zusammenfassung}       % unchanged, original: Zusammenfassung
    \def\bibname{Literaturverzeichnis}       % unchanged, original: Literaturverzeichnis
    \def\chaptername{Kapitel}                % unchanged, original: Kapitel
    \def\appendixname{Anhang}                % unchanged, original: Anhang
    \def\contentsname{Inhaltsverzeichnis}    % unchanged, original: Inhaltsverzeichnis
    \def\listfigurename{Bildverzeichnis}     % changed,   original: Abbildungsverzeichnis
    \def\listtablename{Tabellenverzeichnis}  % unchanged, original: Tabellenverzeichnis
    \def\indexname{Index}                    % unchanged, original: Index
    \def\figurename{Bild}                    % changed,   original: Abbildung
    \def\tablename{Tabelle}                  % unchanged, original: Tabelle
    \def\partname{Teil}                      % unchanged, original: Teil
    \def\enclname{Anlage(n)}                 % unchanged, original: Anlage(n)
    \def\ccname{Verteiler}                   % unchanged, original: Verteiler
    \def\headtoname{An}                      % unchanged, original: An
    \def\pagename{Seite}                     % unchanged, original: Seite
    \def\seename{siehe}                      % unchanged, original: siehe
    \def\alsoname{siehe auch}                % unchanged, original: siehe auch
    \def\proofname{Beweis}                   % unchanged, original: Beweis
    \def\glossaryname{Glossar}               % unchanged, original: Glossar
  }

\else

  \addto\captionsngerman{%
    \def\prefacename{Vorwort}                % unchanged, original: Vorwort
    \def\refname{Literatur}                  % unchanged, original: Literatur
    \def\abstractname{Zusammenfassung}       % unchanged, original: Zusammenfassung
    \def\bibname{Literaturverzeichnis}       % unchanged, original: Literaturverzeichnis
    \def\chaptername{Kapitel}                % unchanged, original: Kapitel
    \def\appendixname{Anhang}                % unchanged, original: Anhang
    \def\contentsname{Inhaltsverzeichnis}    % unchanged, original: Inhaltsverzeichnis
    \def\listfigurename{Bildverzeichnis}     % changed,   original: Abbildungsverzeichnis
    \def\listtablename{Tabellenverzeichnis}  % unchanged, original: Tabellenverzeichnis
    \def\indexname{Index}                    % unchanged, original: Index
    \def\figurename{Bild}                    % changed,   original: Abbildung
    \def\tablename{Tabelle}                  % unchanged, original: Tabelle
    \def\partname{Teil}                      % unchanged, original: Teil
    \def\enclname{Anlage(n)}                 % unchanged, original: Anlage(n)
    \def\ccname{Verteiler}                   % unchanged, original: Verteiler
    \def\headtoname{An}                      % unchanged, original: An
    \def\pagename{Seite}                     % unchanged, original: Seite
    \def\seename{siehe}                      % unchanged, original: siehe
    \def\alsoname{siehe auch}                % unchanged, original: siehe auch
    \def\proofname{Beweis}                   % unchanged, original: Beweis
    \def\glossaryname{Glossar}               % unchanged, original: Glossar
  }

\fi

\addto\HyLang@german{%
  \def\equationautorefname{Gleichung}                 % unchanged, original: Gleichung
  \def\footnoteautorefname{Fu\ss note}                % unchanged, original: Fu\ss note
  \def\itemautorefname{Punkt}                         % unchanged, original: Punkt
  \def\figureautorefname{Bild}                        % changed,   original: Abbildung
  \def\tableautorefname{Tabelle}                      % unchanged, original: Tabelle
  \def\partautorefname{Teil}                          % unchanged, original: Teil
  \def\appendixautorefname{Anhang}                    % unchanged, original: Anhang
  \def\chapterautorefname{Kapitel}                    % unchanged, original: Kapitel
  \def\sectionautorefname{Abschnitt}                  % unchanged, original: Abschnitt
  \def\subsectionautorefname{Unterabschnitt}          % unchanged, original: Unterabschnitt
  \def\subsubsectionautorefname{Unterunterabschnitt}  % unchanged, original: Unterunterabschnitt
  \def\paragraphautorefname{Absatz}                   % unchanged, original: Absatz
  \def\subparagraphautorefname{Unterabsatz}           % unchanged, original: Unterabsatz
  \def\FancyVerbLineautorefname{Zeile}                % unchanged, original: Zeile
  \def\theoremautorefname{Theorem}                    % unchanged, original: Theorem
  \def\pageautorefname{Seite}                         % unchanged, original: Seite
}

\addto\captionsenglish{%
  \def\prefacename{Preface}            % unchanged, original: Preface
  \def\refname{References}             % unchanged, original: References
  \def\abstractname{Abstract}          % unchanged, original: Abstract
  \def\bibname{Bibliography}           % unchanged, original: Bibliography
  \def\chaptername{Chapter}            % unchanged, original: Chapter
  \def\appendixname{Appendix}          % unchanged, original: Appendix
  \def\contentsname{Contents}          % unchanged, original: Contents
  \def\listfigurename{List of Figures} % unchanged, original: List of Figures
  \def\listtablename{List of Tables}   % unchanged, original: List of Tables
  \def\indexname{Index}                % unchanged, original: Index
  \def\figurename{Figure}              % unchanged, original: Figure
  \def\tablename{Table}                % unchanged, original: Table
  \def\partname{Part}                  % unchanged, original: Part
  \def\enclname{encl}                  % unchanged, original: encl
  \def\ccname{cc}                      % unchanged, original: cc
  \def\headtoname{To}                  % unchanged, original: To
  \def\pagename{Page}                  % unchanged, original: Page
  \def\seename{see}                    % unchanged, original: see
  \def\alsoname{see also}              % unchanged, original: see also
  \def\proofname{Proof}                % unchanged, original: Proof
}

\addto\HyLang@english{
  \def\equationautorefname{Equation}           % unchanged, original: Equation
  \def\footnoteautorefname{footnote}           % unchanged, original: footnote
  \def\itemautorefname{item}                   % unchanged, original: item
  \def\figureautorefname{Figure}               % unchanged, original: Figure
  \def\tableautorefname{Table}                 % unchanged, original: Table
  \def\partautorefname{Part}                   % unchanged, original: Part
  \def\appendixautorefname{Appendix}           % unchanged, original: Appendix
  \def\chapterautorefname{chapter}             % unchanged, original: chapter
  \def\sectionautorefname{section}             % unchanged, original: section
  \def\subsectionautorefname{subsection}       % unchanged, original: subsection
  \def\subsubsectionautorefname{subsubsection} % unchanged, original: subsubsection
  \def\paragraphautorefname{paragraph}         % unchanged, original: paragraph
  \def\subparagraphautorefname{subparagraph}   % unchanged, original: subparagraph
  \def\FancyVerbLineautorefname{line}          % unchanged, original: line
  \def\theoremautorefname{Theorem}             % unchanged, original: Theorem
  \def\pageautorefname{page}                   % unchanged, original: page
}

% In addition to the already existing keywords, the FAU University Press
% stipulates some headings to have fixed names. These must also added to
% \captionsgerman (or \captionsngerman) as well as \captionsenglish. Since none
% of those headings have anything to do with counters, no extensions of
% \HyLang@german or \HyLang@english are required.

\ifluatex

  \addto\captionsgerman{%
    \def\introductionname{Einleitung}%
    \def\acroname{Formelzeichen- und Abkürzungsverzeichnis}%
    \def\listabbrname{Abkürzungsverzeichnis}%
    \def\listsymbolname{Formelzeichenverzeichnis}%
    \def\abbrname{Abkürzung}%
    \def\descriptionname{Beschreibung}%
    \def\unitname{Einheit}%
    \def\symbolname{Symbol}%
    \def\mainbibname{Literaturverzeichnis}%
    \def\ownbibname{Verzeichnis promotionsbezogener, eigener Publikationen}%
    \def\studentbibname{Verzeichnis promotionsbezogener, studentischer Arbeiten}%
    \def\bibasterisk{Der Autor an zweiter (und ggf. dritter) Stelle bezeichnet
      den bzw. die Betreuer der studentischen Arbeit und an letztgenannter Stelle
      den/die Lehrstuhlinhaber/in.}%
  }

\else

  \addto\captionsngerman{%
    \def\introductionname{Einleitung}%
    \def\acroname{Formelzeichen- und Abkürzungsverzeichnis}%
    \def\listabbrname{Abkürzungsverzeichnis}%
    \def\listsymbolname{Formelzeichenverzeichnis}%
    \def\abbrname{Abkürzung}%
    \def\descriptionname{Beschreibung}%
    \def\unitname{Einheit}%
    \def\symbolname{Symbol}%
    \def\mainbibname{Literaturverzeichnis}%
    \def\ownbibname{Verzeichnis promotionsbezogener, eigener Publikationen}%
    \def\studentbibname{Verzeichnis promotionsbezogener, studentischer Arbeiten}%
    \def\bibasterisk{Der Autor an zweiter (und ggf. dritter) Stelle bezeichnet
      den bzw. die Betreuer der studentischen Arbeit und an letztgenannter Stelle
      den/die Lehrstuhlinhaber/in.}%
  }

\fi

\addto\captionsenglish{%
  \def\introductionname{Introduction}%
  \def\acroname{List of Symbols and Abbreviations}%
  \def\listabbrname{List of Abbreviations}%
  \def\listsymbolname{List of Symbols}%
  \def\abbrname{Abbreviation}%
  \def\descriptionname{Description}%
  \def\unitname{Unit}%
  \def\symbolname{Symbol}%
  \def\mainbibname{Bibliography}%
  \def\ownbibname{Own publications referring to this work}%
  \def\studentbibname{Students’ theses referring to this work}%
  \def\bibasterisk{The 2nd (3rd) author names the supervisor; the last author
    is head of the institute.}%
}

% The csquotes package allows to set quotation marks depending on the currently
% selected language. Usage is recommended by BibLaTeX when using babel or
% polyglossia. Further package options can be passed to it in the usual way by
% using \PassOptionsToPackage before loading this class.

\RequirePackage{csquotes} % 2019-12-06 v5.2j

%%% MATH & SCIENCE %%%

% The amsmath, amssymb and amsfonts packages of the American Mathematical
% Society are a comprehensive extension of LaTeX to allow proper typesetting of
% equations and other mathematical components.

% The mathtools package superceeds the amsmath package by fully including and
% then extending it. Therefore the amsmath package does not have to be loaded
% explicitly. The mathtools package is not really required for this class but
% is included nevertheless, because it is commonly used.

\RequirePackage{mathtools} % 2020/03/24 v1.24

% The amssymb package is required because one of the symbols used for itemize
% lists is defined here.

\RequirePackage{amssymb} % 2013/01/14 v3.01

% The siunitx package allows to properly and consistently set numbers, units,
% numbers in combination with units, lists of numbers, lists of numbers in
% combination with a unit, number ranges and number ranges in combination with
% a unit. The appearance of these can be set in the preamble without having to
% change the in-document code. The package is not required for this class but
% is included nevertheless, because it is commonly used and certain settings
% (see below) must be given to align the appearance to the fonts selected
% below. Further setup options can be passed to the package by using \sisetup
% in the preamble (or at any other point in the document).

% TODO: The package is currently available in version 2.8b which does not
% support all math fonts that are provided by the unicode-math package used in
% this class with LuaLaTeX. According to comments on a github issue that
% addresses this bug [https://github.com/josephwright/siunitx/issues/338],
% there will be a version 3 that will change the package significantly and add
% the required compatibilities for unicode-math.

\RequirePackage{siunitx} % 2020/02/25 v2.8b
  
  \AtBeginDocument{%
    \sisetup{%
      detect-all = true,%
      detect-display-math = true,%
    }%
  }%

%%% FONTS %%%

%TODO explain

\ifluatex

  \RequirePackage{fontspec} % 2020/02/21 v2.7i

    \setsansfont[
      Path           = fonts/,
      UprightFont    = *-light,
      BoldFont       = *-medium,
    ]{helveticaneueltcom.ttf}

    \setmainfont[
      Path           = fonts/,
      UprightFont    = *-regular,
      BoldFont       = *-bold,
      ItalicFont     = *-italic,
      BoldItalicFont = *-bold-italic,
      Numbers        = OldStyle,
    ]{constantia.ttf}

  \RequirePackage[
    bold-style = ISO
  ]{unicode-math} % 2020/01/31 v0.8q
 
    \setmathfont[
      Path           = fonts/,
    ]{cambria-math.ttf}

    \unimathsetup{
      mathrm = sym
    }

\else 

  \RequirePackage[T1]{fontenc} % 2020/02/11 v2.0o
  \RequirePackage[utf8]{inputenc} % 2018/08/11 v1.3c
  
  % To use garamond, the font must be installed on the system. It does not come
  % with the package itself, because it is a Microsoft font. Under Windows the
  % fonts should already be installed; under Linux and MacOS it can be
  % installed using the tool getnonfreefonts.

  \RequirePackage{textcomp} % 2020/02/02 v2.0n
  \RequirePackage{ebgaramond} % 2020/04/12
  \RequirePackage[ebgaramond]{newtxmath} % 2020/05/02 v1.626

\fi

%%% MICROTYPOGRAPHY %%%

\RequirePackage{microtype} % 2019/11/18 v2.7d
\RequirePackage{setspace} % 2011/12/19 v6.7a, must be loaded before footmisc package
\RequirePackage{ragged2e} % 2019/07/28 v2.2

% prevent hyphenation of certain short words

% hyphenmins define how many letters have to be typeset before the first
% hyphenation as well as after the last hyphenation. The setting below tells
% latex that in English and in German no hyphenation within the first three
% letters of a word or within the last four letters of a word is allowed. With
% these settings in English and in German no hyphenation of words shorter

\ifluatex
  \renewcommand\germanhyphenmins{33}  % default settings are 22
\else
  \renewcommand\ngermanhyphenmins{33} % default settings are 23
\fi
\renewcommand\englishhyphenmins{33}   % default settings are 23

% hyphenation can be used to define the hyphenation of words that are not
% hyphenated correctly by the babel algorithm. It can also be used to prevent
% hyphenation of certain words.

\hyphenation{
  % Neu-land %This line would tell LaTeX how to hyphenate the word "Neuland" correctly
  % außerdem %This line would tell LaTeX not to hyphenate the word "außerdem" at all.
}

%\renewcommand{\sfdefault}{\familydefault}

\iffaupress@studienpartitur
  \KOMAoption{fontsize}{11pt}
\fi
\iffaupress@afive
  \KOMAoption{fontsize}{10pt}
\fi

%% Alignment & style of sectioning commands
\setkomafont{disposition}{\normalfont\bfseries}
% Numbering up to \subsubsection
\setcounter{secnumdepth}{3}
% Command for fixed indentation of the sectioning commands
\newcommand*{\@fausectioning}[1]{\makebox[1.1cm][l]{#1}}
% Alignment of sections
\renewcommand*{\chapterformat}{%
  \@fausectioning{\chapappifchapterprefix{\nobreakspace}\thechapter\autodot}}
\renewcommand*{\sectionformat}{\@fausectioning{\thesection\autodot}}
\renewcommand*{\subsectionformat}{\@fausectioning{\thesubsection\autodot}}
\renewcommand*{\subsubsectionformat}{\@fausectioning{\thesubsubsection\autodot}}

%% Different style in TOC for \frontmatter & \mainmatter & \appendix & \backmatter
\newcommand\chaptertocstyle{}
\addtokomafont{chapterentry}{\chaptertocstyle}
\g@addto@macro\frontmatter{%
  \addtocontents{toc}{%
    \protect\renewcommand\protect\chaptertocstyle{\small}%
  }%
}
\g@addto@macro\mainmatter{%
  \addtocontents{toc}{%
    \vspace*{0.25em}
    \protect\renewcommand\protect\chaptertocstyle{\normalsize}%
  }%
}
\g@addto@macro\appendix{%
  \addtocontents{toc}{%
    \vspace*{0.25em}
    \protect\setcounter{tocdepth}{1}%
    \protect\renewcommand\protect\chaptertocstyle{\small}%
  }%
  \addchap{\appendixname}%
  \let\rememberchapterdef\chapter
  \let\chapter\relax
  \renewcommand*\thesection{\@Alph\c@section}
}
\g@addto@macro\backmatter{%
  \let\chapter\rememberchapterdef
  \addtocontents{toc}{%
    \protect\setcounter{tocdepth}{1}%
    \protect\renewcommand\protect\chaptertocstyle{\small}%
  }%
}

% Custom chapters
\newenvironment{preface}{\chapter*{\prefacename}\label{ch:preface}}{}
\newenvironment{introduction}{\chapter{\introductionname}\label{ch:intro}}{}

\RedeclareSectionCommand[
  afterindent    = false,
  beforeskip     = 0pt,
  afterskip      = 0.75\baselineskip,
  tocbeforeskip  = 0.6\baselineskip,
  font           = \LARGE,
]{chapter}
\RedeclareSectionCommand[
  afterindent    = false,
  beforeskip     = 0.75\baselineskip,
  afterskip      = 0.01pt,
  tocbeforeskip  = 0.25\baselineskip,
  tocentryformat = \small,
]{section}
\RedeclareSectionCommand[
  afterindent    = false,
  beforeskip     = 0.75\baselineskip,
  afterskip      = 0.01pt,
  tocbeforeskip  = 0pt,
  tocentryformat = \small,
]{subsection}
\RedeclareSectionCommand[
  afterindent    = false,
  beforeskip     = 0.50\baselineskip,
  afterskip      = 0.01pt,
  tocbeforeskip  = 0pt,
  tocentryformat = \small,
]{subsubsection}
\RedeclareSectionCommand[
  runin          = true,
  beforeskip     = 0.50\baselineskip,
  afterskip      = 1em,
]{paragraph}
\RedeclareSectionCommand[
  runin          = true,
  beforeskip     = 0.50\baselineskip,
  afterskip      = 1em,
]{subparagraph}  
\addtokomafont{pagehead}{\footnotesize}
\addtokomafont{pagefoot}{\footnotesize}

\iffaupress@parskip
  \setlength{\parskip}{1\baselineskip}
  \setlength{\parindent}{0pt}
\fi

\iffaupress@parhalfskip
  \setlength{\parskip}{0.5\baselineskip}
  \setlength{\parindent}{0pt}
\fi

\iffaupress@parindent
  \setlength{\parskip}{0pt}
  \setlength{\parindent}{1em}
\fi

% lists

\RequirePackage{enumitem} % 2019/06/20 v3.9

\setlist[itemize]{leftmargin = 2\baselineskip, itemindent = 0pt, labelsep = 0.5\baselineskip}
\setlist[itemize, 1]{label = \raisebox{0.11\baselineskip}{\scalebox{0.4333}{$\blacksquare$}}}
% blacksqaure of AMS was fitted to look like normal bullet
\setlist[itemize, 2]{label = $\bullet$}
\setlist[itemize, 3]{label = $\bullet$}
\setlist[itemize, 4]{label = $\bullet$}

% counter

\RequirePackage{chngcntr} % 2018/04/09 v1.1a

\counterwithout{figure}{chapter}
\counterwithout{table}{chapter}
\counterwithout{equation}{chapter}

% footnotes

\RequirePackage[
  stable, % so you can use \footnote in sectioning commands
  bottom,
  hang,
  multiple,
]{footmisc} % 2011/06/06 v5.5b, must be loaded after setspace package  

\renewcommand{\footnoterule}{%
  \kern -3pt
  \hrule width 52mm height 0.75pt
  \kern 2.25pt
}

\iffaupress@parskip
  \iffaupress@studienpartitur
    \addtolength{\footnotesep}{1\baselineskip * \real{0.80885}}
    % factor determined by trail and error
  \fi
  \iffaupress@afive
    \addtolength{\footnotesep}{1\baselineskip * \real{0.79169}}
    % factor determined by trail and error
  \fi
  \setlength{\footnotemargin}{1em}
  \renewcommand{\hangfootparskip}{1\baselineskip}
  \renewcommand{\hangfootparindent}{0pt}
\fi

\iffaupress@parhalfskip
  \iffaupress@studienpartitur
    \addtolength{\footnotesep}{0.5\baselineskip * \real{0.80885}}
    % factor determined by trail and error
  \fi
  \iffaupress@afive
    \addtolength{\footnotesep}{0.5\baselineskip * \real{0.79169}}
    % factor determined by trail and error
  \fi
  \setlength{\footnotemargin}{1em}
  \renewcommand{\hangfootparskip}{0.5\baselineskip}
  \renewcommand{\hangfootparindent}{0pt}
\fi

\iffaupress@parindent
  \addtolength{\footnotesep}{0pt * \real{0.8}}
  \setlength{\footnotemargin}{1em}
  \renewcommand{\hangfootparskip}{0pt}
  \renewcommand{\hangfootparindent}{1em}
\fi

% floats

\RequirePackage{float} % 2001/11/08 v1.3d

\RequirePackage{caption} % 2020/05/30 v3.4k
\captionsetup{
  singlelinecheck = false,
  format          = plain,
  font            = footnotesize,
  belowskip       = 0pt,
}

% figures

\RequirePackage{graphicx} % 2019/11/30 v1.2a
\graphicspath{
  {./graphics/},
  {./figures/},
}

% tables

\RequirePackage{booktabs} % 2020/01/12 v1.61803398
\RequirePackage{array} % 2019/08/31 v2.4l

\newcolumntype{L}[1]{>{\raggedright\let\newline\\\arraybackslash\hspace{0pt}}p{#1}}
\newcolumntype{C}[1]{>{\centering\let\newline\\\arraybackslash\hspace{0pt}}p{#1}}
\newcolumntype{R}[1]{>{\raggedleft\let\newline\\\arraybackslash\hspace{0pt}}p{#1}}
\renewcommand{\arraystretch}{1.3}

\RequirePackage{longtable} % 2020/01/07 v4.13

% Thickness of rules in tables
\setlength{\arrayrulewidth}{0.75pt}

% colors

\RequirePackage{xcolor} % 2016/05/11 v2.12
% \RequirePackage[faculty = nat]{faucolors} % exists, could be included in future to make fau colors available

% bibliography

\newcommand*{\faupressprintbibliography}{}

\iffaupress@bibliography

  \RequirePackage[
    backend      = biber ,
    bibencoding  = utf8  ,
    sorting      = nyt   ,
    sortcites    = true  ,
    defernumbers = true  ,
    date         = year  ,
    doi          = false , 
    eprint       = false ,
    isbn         = false ,
    url          = false ,
    giveninits   = true  ,
    maxnames     = 15    ,
    maxcitenames = 2     ,
  ]{biblatex} % 2019/12/01 v3.14
  
  \defbibheading{faupress-subbibliography}[\refname]{\section*{#1}}

  % many of the folowing style setting were taken from chem-acs bibstyle

  \renewcommand*{\begrelateddelim}{\addsemicolon\space}%
  \renewcommand*{\finalnamedelim}{%
    \ifcurrentname{labelname}
      {%
        \ifnumgreater{\value{liststop}}{2}
          {\finalandcomma}
          {}%
        \addspace
        \bibstring{and}%
        \space
      }
      {\multinamedelim}%
  }
  
  \DeclareNameFormat{default}{%
    \renewcommand*{\multinamedelim}{\addsemicolon\addspace}%
    \nameparts{#1}%
    \usebibmacro{name:family-given}
      {\namepartfamily}
      {\namepartgiveni}
      {\namepartprefix}
      {\namepartsuffix}%
    \usebibmacro{name:andothers}%
  }

  \DeclareNameFormat{editor}{%
    \renewcommand*{\multinamedelim}{\addcomma\addspace}%
    \nameparts{#1}%
    \usebibmacro{name:family-given}
      {\namepartfamily}
      {\namepartgiveni}
      {\namepartprefix}
      {\namepartsuffix}%
    \usebibmacro{name:andothers}%
  }

  \DeclareFieldFormat*{title}{#1}
  \DeclareFieldFormat[report]{title}{\mkbibitalic{#1}}
  \DeclareFieldFormat[book,collection,inproceedings]{title}{\mkbibitalic{#1}}
  \DeclareFieldFormat{labelnumberwidth}{\mkbibbrackets{#1}}
  \DeclareFieldFormat{pages}{#1}
  \DeclareDelimFormat[bib]{nametitledelim}{\addcolon\space} 
  
  % three files for the different bibliography parts
  \iffaupress@mainbibliography
    \addbibresource{./references/bibliography.bib}
  \fi
  \iffaupress@ownbibliography
    \addbibresource{./references/bibliography-own.bib}
  \fi
  \iffaupress@studentbibliography
    \addbibresource{./references/bibliography-student.bib}
  \fi

  % Adds keywords depending on filename
  \DeclareSourcemap{
    %
    \maps[datatype = bibtex, overwrite]{
      %
      \iffaupress@studentbibliography
        \map{
          \perdatasource{./references/bibliography-student.bib}
          \step[fieldset=keywords, fieldvalue={,student}, append]
        }
      \fi
      %
      \iffaupress@ownbibliography
        \map{
          \perdatasource{./references/bibliography-own.bib}
          \step[fieldset=keywords, fieldvalue={,own}, append]
        }
      \fi
      %
      \iffaupress@mainbibliography
        \map{
          \perdatasource{./references/bibliography.bib}
          \step[nocited, final]
          \step[entrynull]
        }
      \fi
      %
    }
    %
  }

  \iffaupress@splitbibliography
    
    % Command that prints the bibliography in FAU-press style
    \renewcommand*{\faupressprintbibliography}{
      %
      \nocite{*}%
      \chapter*{\mainbibname}%
      \addcontentsline{toc}{chapter}{\mainbibname}%
      \@mkboth{\abx@MakeMarkcase{\mainbibname}}{\abx@MakeMarkcase{\mainbibname}}%
      \sloppy%
      %
      \iffaupress@mainbibliography
        \printbibliography[ title = \mainbibname, heading = none,
                            notkeyword = student, notkeyword = own ]%
        \clearpage%
      \fi
      %
      \iffaupress@ownbibliography
        \newrefcontext[labelprefix = P]%
        \printbibliography[ title = \ownbibname, heading = faupress-subbibliography,
                            keyword = own, resetnumbers ]%
        \clearpage%
      \fi
      %
      \iffaupress@studentbibliography
        \renewcommand{\thefootnote}{\fnsymbol{footnote}}%
        \newrefcontext[labelprefix = S]%
        \printbibliography[ title = \studentbibname\protect{\footnote[1]{\bibasterisk}},
                            heading = faupress-subbibliography,
                            keyword = student, resetnumbers ]%
        \renewcommand{\thefootnote}{\arabic{footnote}}%
      \fi
      %
    }

  \fi

  \iffaupress@combinedbibliography

    % Command that prints the bibliography normally, but renamed
    \renewcommand*{\faupressprintbibliography}{
      %
      \sloppy
      \printbibliography[title = \mainbibname, heading = bibintoc]
      %
    }

  \fi

\fi

%%% ACRONYMS %%%

\newcommand*{\faupressprintacronyms}{}

% LaTeX offers multiple packages using different mechanisms to automatically
% create acronym lists from acronyms used throughout the document.
% Unfortunately none of the solutions is really stable. For this class the acro
% package (or rather its ancestor the experimental but more flexible acro2
% package) is used.

% At the time of writing the acro2 package was doing what it was supposed to do
% but was still under development. Also the current version had a bug, which
% was reported to the author and is fixed below for the time being. This class
% expects version 2.11d of the acro2 package. TODO: Check if the acro2 package
% is stable and the bug has been resolved. If it is stable, the bugfix is not
% required anymore.

% Since this whole implementation is rather unstable, the user can choose to
% turn it off in its entirety.

\iffaupress@acronym
  
  \RequirePackage{acro2} % 2020/03/07 v2.11d

  % As explained above this version of the package has a minor bug. It is
  % missing the initialization of one boolean. The package is written in LaTeX3
  % (the unfinished successor of LaTeX2e). Thus first the expl3 syntax is
  % turned on, the boolean is defined and then the expl3 syntax is again turned
  % off to continue with "normal" LaTeX2e syntax.

  \ExplSyntaxOn \bool_new:N\g__acro_rerun_bool \ExplSyntaxOff

  % In publications of the FAU University Press the acronyms can be split in
  % two parts, namely the abbreviations and symbols. They shall have tabular
  % layouts that slightly differ from the pre-defined templates.
  
  % The new templates are based on the code for the table templates from the
  % package. The code was changed regarding the general table layout and/or
  % extended to allow the definition of a table header (beforeinner) and footer
  % (afterinner).
  
  % The pre-defined "table" template has two columns. The first column is
  % filled with the short value of an acronym; the second column is filled with
  % the extra value and the long value of an acronym as well as a list of pages
  % the acronym is used on. The pre-definied "table extra" template has four
  % columns which are filled with the short value, the extra value and the page
  % list of an acronym in this order.

  % Below two new list templates are defined:
  %
  %  1. faupress-abbr   = table template + new keys beforeinner and afterinner
  %  2. faupress-symbol = table extra template + new keys beforeinner and
  %                       afterinner + redefinition of table layout merging
  %                       third (long value) and fourth (page list) column
  %
  % The actual table layout is defined via \acsetup using the table-spec
  % option. The "faupress-abbr" template expects two columns and the
  % "faupress-extra" expects three columns.

  \ExplSyntaxOn
    
    \DeclareTemplateInterface {acro-list} {faupress-abbr} {2}
    {
      table       : tokenlist = tabular,
      table-spec  : tokenlist = lp{.7\linewidth} ,
      foreign-sep : tokenlist = {~} ,
      reverse     : boolean   = false ,
      before      : tokenlist = ,
      after       : tokenlist = ,
      beforeinner : tokenlist = , % extended
      afterinner  : tokenlist =   % extended
    }

    \DeclareTemplateCode {acro-list} {faupress-abbr} {2}
    {
      table       = \l__acro_list_table_tl      ,
      table-spec  = \l__acro_list_table_spec_tl ,
      foreign-sep = \l__acro_foreign_sep_tl ,
      reverse     = \l__acro_list_reverse_long_extra_bool ,
      before      = \l__acro_list_before_tl ,
      after       = \l__acro_list_after_tl ,
      beforeinner = \l__acro_list_beforeinner_tl , % extended
      afterinner  = \l__acro_list_afterinner_tl    % extended
    }
    {
      \AssignTemplateKeys
      \acro_activate_hyperref_support:
      \bool_if:NTF \l__acro_list_reverse_long_extra_bool
      {
        \cs_set_protected:Npn \acro_print_list_entry:nnnn ##1##2##3##4
        { ##1 & ##3 ##2 ##4 \tabularnewline }
      }
      {
        \cs_set_protected:Npn \acro_print_list_entry:nnnn ##1##2##3##4
        { ##1 & ##2 ##3 ##4 \tabularnewline }
      }
      \acro_build_list_entries:Nnn \l__acro_list_entries_tl {#1} {#2}
      \use:x
      {
        \exp_not:V \l__acro_list_before_tl
        \exp_not:N \begin { \exp_not:V \l__acro_list_table_tl }
          { \exp_not:V \l__acro_list_table_spec_tl }
          \exp_not:V \l__acro_list_beforeinner_tl  % extended
          \exp_not:V \l__acro_list_entries_tl
          \exp_not:V \l__acro_list_afterinner_tl   % extended
          \exp_not:N \end { \exp_not:V \l__acro_list_table_tl }
        \exp_not:V \l__acro_list_after_tl
      }
    }

    \DeclareTemplateInterface {acro-list} {faupress-symbol} {2}
    {
      table       : tokenlist = tabular,
      table-spec  : tokenlist = lll , % changed, original: llll
      foreign-sep : tokenlist = {~} ,
      reverse     : boolean   = true ,
      before      : tokenlist = ,
      after       : tokenlist = ,
      beforeinner : tokenlist = ,     % extended
      afterinner  : tokenlist =       % extended
    }

    \DeclareTemplateCode {acro-list} {faupress-symbol} {2}
    {
      table       = \l__acro_list_table_tl      ,
      table-spec  = \l__acro_list_table_spec_tl ,
      foreign-sep = \l__acro_foreign_sep_tl ,
      reverse     = \l__acro_list_reverse_long_extra_bool ,
      before      = \l__acro_list_before_tl ,
      after       = \l__acro_list_after_tl,
      beforeinner = \l__acro_list_beforeinner_tl , % extended
      afterinner  = \l__acro_list_afterinner_tl    % extended
    }
    {
      \AssignTemplateKeys
      \acro_activate_hyperref_support:
      \bool_if:NTF \l__acro_list_reverse_long_extra_bool
      {
        \cs_set_protected:Npn \acro_print_list_entry:nnnn ##1##2##3##4
        { ##1 & ##3 & ##2 ##4 \tabularnewline }    % changed, original: ##1 & ##3 & ##2 & ##4
      }
      {
        \cs_set_protected:Npn \acro_print_list_entry:nnnn ##1##2##3##4
        { ##1 & ##2 & ##3 ##4 \tabularnewline }    % changed, original: ##1 & ##2 & ##3 & ##4
      }
      \acro_build_list_entries:Nnn \l__acro_list_entries_tl {#1} {#2}
      \use:x
      {
        \exp_not:V \l__acro_list_before_tl
        \exp_not:N \begin { \exp_not:V \l__acro_list_table_tl }
          { \exp_not:V \l__acro_list_table_spec_tl }
          \exp_not:V \l__acro_list_beforeinner_tl  % extended
          \exp_not:V \l__acro_list_entries_tl
          \exp_not:V \l__acro_list_afterinner_tl   % extended
          \exp_not:N \end { \exp_not:V \l__acro_list_table_tl }
        \exp_not:V \l__acro_list_after_tl
      }
    }
  
  \ExplSyntaxOff

  % With the general list templates set up for our use cases, we can now use
  % the commands provided by the package to do the fine-tuning and set the
  % actual table layout (table-spec), header (beforeinner) and footer
  % (afterinner). Since a list of acronyms can become longer than one page, we
  % set the enviroment used for creating the table to longtable (instead of
  % tabular). This also means we have no need for the afterinner key because
  % longtable requires the footer to be defined at the beginning of a table.

  % The user can alter the horizontal and vertical lines drawn in the table via
  % a class option.

  \iffaupress@acronymlineboth

    \DeclareAcroListStyle{faupress-abbr}{faupress-abbr}{
      table       = longtable,
      table-spec  = | L{.25\textwidth} |
                    L{.75\textwidth - 4\tabcolsep - 3\arrayrulewidth} |,
      beforeinner = \toprule {\bfseries\abbrname} & {\bfseries\descriptionname}
                    \\ \midrule \endhead \bottomrule \endfoot,
    }
    \DeclareAcroListStyle{faupress-symbol}{faupress-symbol}{
      table       = longtable,
      table-spec  = | L{.15\textwidth} | L{.15\textwidth} |
                    L{.7\textwidth - 6\tabcolsep - 4\arrayrulewidth} |,
      beforeinner = \toprule {\bfseries\symbolname} & {\bfseries\unitname} &
                    {\bfseries\descriptionname} \\ \midrule \endhead
                    \bottomrule \endfoot,
    }
 
  \fi

  \iffaupress@acronymlinenone

    \DeclareAcroListStyle{faupress-abbr}{faupress-abbr}{
      table       = longtable,
      table-spec  = @{} L{.25\textwidth} @{\hspace{2\tabcolsep}}
                    L{.75\textwidth - 2\tabcolsep} @{},
      beforeinner = {\bfseries\abbrname} & {\bfseries\descriptionname} \\
                    \endhead,
    }
    \DeclareAcroListStyle{faupress-symbol}{faupress-symbol}{
      table       = longtable,
      table-spec  = @{} L{.15\textwidth} @{\hspace{2\tabcolsep}}
                    L{.15\textwidth} @{\hspace{2\tabcolsep}}
                    L{.7\textwidth - 4\tabcolsep} @{},
      beforeinner = {\bfseries\symbolname} & {\bfseries\unitname} &
                    {\bfseries\descriptionname} \\ \endhead,
    }
 
  \fi

  \iffaupress@acronymlinehorizontal
  
    \DeclareAcroListStyle{faupress-abbr}{faupress-abbr}{
      table       = longtable,
      table-spec  = @{} L{.25\textwidth} @{\hspace{2\tabcolsep}}
                    L{.75\textwidth - 2\tabcolsep} @{},
      beforeinner = \toprule {\bfseries\abbrname} & {\bfseries\descriptionname}
                    \\ \midrule \endhead \bottomrule \endfoot,
    }
    \DeclareAcroListStyle{faupress-symbol}{faupress-symbol}{
      table       = longtable,
      table-spec  = @{} L{.15\textwidth} @{\hspace{2\tabcolsep}}
                    L{.15\textwidth} @{\hspace{2\tabcolsep}}
                    L{.7\textwidth - 4\tabcolsep} @{},
      beforeinner = \toprule {\bfseries\symbolname} & {\bfseries\unitname} &
                    {\bfseries\descriptionname} \\ \midrule \endhead
                    \bottomrule \endfoot,
    }
  
  \fi
  
  \iffaupress@acronymlinevertical
  
    \DeclareAcroListStyle{faupress-abbr}{faupress-abbr}{
      table       = longtable,
      table-spec  = | L{.25\textwidth} |
                    L{.75\textwidth - 4\tabcolsep - 3\arrayrulewidth} |,
      beforeinner = {\bfseries\abbrname} & {\bfseries\descriptionname} \\
                    \endhead,
    }
    \DeclareAcroListStyle{faupress-symbol}{faupress-symbol}{
      table       = longtable,
      table-spec  = | L{.15\textwidth} | L{.15\textwidth} |
                    L{.7\textwidth - 6\tabcolsep - 4\arrayrulewidth} |,
      beforeinner = {\bfseries\symbolname} & {\bfseries\unitname} &
                    {\bfseries\descriptionname} \\ \endhead,
    }
  
  \fi
  
  % Extra style for units
  \DeclareAcroExtraStyle{faupress-abbr}{inline}{
    brackets = true, 
    punct = true
  }
  % Extra style for units
  \DeclareAcroExtraStyle{faupress-symbol}{inline}{
    brackets = false, 
    punct = false
  }

  % Formatting of the acronyms
  \acsetup{hyperref, only-used = false}

  \iffaupress@splitacronym

    \renewcommand*{\faupressprintacronyms}[1][]{
      \addchap{\acroname}
      \label{faupressacronyms}
        \acsetup{list-style = faupress-abbr, extra-style = faupress-abbr, list-heading = section*} 
        \printacronyms[name = \listabbrname, exclude-classes = symbol, #1]
        \acsetup{list-style = faupress-symbol, extra-style = faupress-symbol, list-heading = section*} 
        \printacronyms[name = \listsymbolname, include-classes = symbol, #1]
      \cleardoublepage
      \addtocounter{table}{-2}
    }

  \fi

  \iffaupress@combinedacronym
  
    \renewcommand*{\faupressprintacronyms}[1][]{
      \acsetup{list-style = faupress-symbol, extra-style = faupress-symbol, list-heading = addchap}
      \printacronyms[name = \acroname, #1]
      \cleardoublepage
      \addtocounter{table}{-1}
    }

  \fi

  \iffaupress@abbreviation
  
    \renewcommand*{\faupressprintacronyms}[1][]{
      \acsetup{list-style = faupress-abbr, extra-style = faupress-abbr, list-heading = addchap}
      \printacronyms[name = \listabbrname, exclude-classes = symbol, #1]
      \cleardoublepage
      \addtocounter{table}{-1}
    }

  \fi

  \iffaupress@symbol
  
    \renewcommand*{\faupressprintacronyms}[1][]{
      \acsetup{list-style = faupress-symbol, extra-style = faupress-symbol, list-heading = addchap}
      \printacronyms[name = \listsymbolname, include-classes = symbol, #1]
      \cleardoublepage
      \addtocounter{table}{-1}
    }

  \fi

\fi

%   hyperlinks

\RequirePackage[
  hyperfootnotes = false, % required bc footmisc package is in use with multiple option
]{hyperref} % 2020-05-15 v7.00e
  \hypersetup{
    linktoc = all,
    hidelinks,
  }
\RequirePackage{nameref} % 2019/09/16 v2.46
\RequirePackage{bookmark} % 2019/12/03 v1.28

%%%%%%%%%%%%%%%%%
%%% TITLEPAGE %%%
%%%%%%%%%%%%%%%%%

%%% DEFINE NEW COMMANDS FOR VARIOUS EXTRA META INFO %%%

% author

\newcommand*\firstname[1]{\gdef\@firstname{#1}}
\newcommand\@firstname{\@latex@error{no \noexpand\firstname given}\@ehc}

\newcommand*\lastname[1]{\gdef\@lastname{#1}}
\newcommand\@lastname{\@latex@error{No \noexpand\lastname given}\@ehc}

\newcommand*\degree[1]{\gdef\@degree{#1}}
\newcommand\@degree{\@latex@error{no \noexpand\degree given}\@ehc}

\newcommand*\origin[1]{\gdef\@origin{#1}}
\newcommand\@origin{\@latex@error{No \noexpand\origin given}\@ehc}

% university and examination

\newcommand*\supervisor[1]{\gdef\@supervisor{#1}}
\newcommand\@supervisor{\@latex@error{no \noexpand\supervisor given}\@ehc}

\newcommand*\oralexam[1]{\gdef\@oralexam{#1}}
\newcommand\@oralexam{\@latex@error{no \noexpand\oralexam given}\@ehc}

\newcommand*\dean[1]{\gdef\@dean{#1}}
\newcommand\@dean{\@latex@error{no \noexpand\dean given}\@ehc}

\newcommand*\reviewer[1]{\gdef\@reviewer{#1}}
\newcommand\@reviewer{\@latex@error{no \noexpand\reviewer given}\@ehc}

\newcommand*\institute[1]{\gdef\@institute{#1}}
\newcommand\@institute{\@latex@error{no \noexpand\institute given}\@ehc}

% publication identifiers

\newcommand*\yearofpublication[1]{\gdef\@yearofpublication{#1}}
\newcommand\@yearofpublication{\@latex@error{no \noexpand\yearofpublication given}\@ehc}

\newcommand*\series[1]{\gdef\@series{#1}}
\newcommand\@series{\@latex@error{no \noexpand\series given}\@ehc}

\newcommand*\volume[1]{\gdef\@volume{#1}}
\newcommand\@volume{\@latex@error{no \noexpand\volume given}\@ehc}

\newcommand*\printinformation[1]{\gdef\@printinformation{#1}}
\newcommand\@printinformation{\@latex@error{no \noexpand\printinformation given}\@ehc}

\newcommand*\doi[1]{\gdef\@doi{#1}}
\newcommand\@doi{\@latex@error{no \noexpand\doi given}\@ehc}

\newcommand*\isbn[1]{\gdef\@isbn{#1}}
\newcommand\@isbn{\@latex@error{no \noexpand\isbn given}\@ehc}

\newcommand*\eisbn[1]{\gdef\@eisbn{#1}}
\newcommand\@eisbn{\@latex@error{no \noexpand\eisbn given}\@ehc}

\newcommand*\issn[1]{\gdef\@issn{#1}}
\newcommand\@issn{\@latex@error{no \noexpand\issn given}\@ehc}

% miscellaneous

\newcommand*\keywords[1]{\gdef\@keywords{#1}}
\newcommand\@keywords{\@latex@error{no \noexpand\keywords given}\@ehc}

%%% DEFINE FONTS TO BE USED FOR META INFO %%%

\newkomafont{supervisor}{\sffamily\normalsize}
\newkomafont{facultytitle}{\Large\bfseries}
\newkomafont{faculty}{\Large\normalfont}
\newkomafont{institute}{\sffamily\normalsize}

\setkomafont{author}{\bfseries\sffamily\LARGE}

\iffaupress@titleHuge
  \setkomafont{title}{\bfseries\sffamily\Huge}
  \setkomafont{subtitle}{\bfseries\sffamily\LARGE}
\fi
\iffaupress@titleLARGE
  \setkomafont{title}{\bfseries\sffamily\LARGE}
  \setkomafont{subtitle}{\bfseries\sffamily\Large}
\fi
\iffaupress@titleLarge
  \setkomafont{title}{\bfseries\sffamily\Large}
  \setkomafont{subtitle}{\bfseries\sffamily\large}
\fi
\iffaupress@titlelarge
  \setkomafont{title}{\bfseries\sffamily\large}
  \setkomafont{subtitle}{\bfseries\sffamily\normalsize}
\fi
\iffaupress@titlenormalsize
  \setkomafont{title}{\bfseries\sffamily\normalsize}
  \setkomafont{subtitle}{\bfseries\sffamily\normalsize}
\fi

% The command is \@addperiod checks if the argument ends with
% a period. If it does it does nothing, if it does not it adds
% a period. This command is used to automatically include the
% author's name, titel, ... in the citation specification. This
% avoids two periods in row if e.g. the author abbreviates
% their second name. It uses the command \IfEndWith from the
% xstring package.
\newcommand{\@addperiod}[1]{
  \IfEndWith{#1}{.}{#1}{#1.\@}
}

% Ignores linebreaks in the local group it is used in
% by relaxing the common commands \\,\newline,\linebreak
% This is used so one can use linebreaks in the (sub)title
% for formating the facultity title page, but the
% formating on the publisher's title page is kept consistent.
\newcommand{\@ignorelinebreaks}{
  \def\newline{\relax\ifhmode\unskip\fi\space\ignorespaces} 
  \def\\{\relax\ifhmode\unskip\fi\space\ignorespaces}
  \def\linebreak{\relax\ifhmode\unskip\fi\space\ignorespaces} 
}

% Titlepage of the publisher following the specifications of
% FAU University press
\renewcommand{\maketitle}{%
  % Add 2 empty pages before the title page
  \newpage\null\thispagestyle{empty}
  \newpage\null\thispagestyle{empty}
  \begin{titlepage}
    \setlength{\parindent}{\z@}
    \setlength{\parskip}{\z@}
    \typeout{Typesetting the titlepage!}
    {\raggedright\usekomafont{author} \@firstname\ \@lastname\par}
    \vspace{1em}
    \begin{minipage}[t]{\textwidth}
      \@ignorelinebreaks
      \RaggedRight
      {\usekomafont{title} \@title\par}
      \vspace{1.5em}
      {\usekomafont{subtitle} \@subtitle\par}
    \end{minipage}\par
    \vfill
    \begin{minipage}[t]{\textwidth}
      \RaggedRight
      \usekomafont{institute} \@institute \\
      \usekomafont{supervisor} \@supervisor\par
    \end{minipage}\par
    \vspace{8em}
    {\sffamily\LARGE Erlangen \\
      FAU University Press \\
      \@yearofpublication \par}
    \vskip2em
    \next@tpage
    Bibliografische Information der Deutschen Nationalbibliothek: \\
    Die Deutsche Nationalbibliothek verzeichnet diese Publikation in der
    Deutschen Nationalbibliografie; detaillierte bibliografische Daten sind
    im Internet über \href{http://dnb.d-nb.de}{http://dnb.d-nb.de} abrufbar.\par
    \vspace{2em}
    Bitte zitieren als\\
    {\@ignorelinebreaks
    \@lastname, \@addperiod{\@firstname} \@addperiod{\@yearofpublication} \@addperiod{\@title}
    \ifx\@subtitle\@empty \else {\@addperiod{\@subtitle}} \fi
    \@series \@addperiod{\@volume} Erlangen: FAU University Press. DOI:~\href{http://dx.doi.org/\@doi}{\@doi}.\par}
    \vspace{2em}
    Das Werk, einschließlich seiner Teile, ist urheberrechtlich geschützt.\\
    Die Rechte an allen Inhalten liegen bei ihren jeweiligen Autoren.
    Sie sind nutzbar unter der Creative Commons Lizenz BY-NC.\par
    \vspace{2em}
    Der vollständige Inhalt des Buchs ist als PDF über den OPUS Server
    der Friedrich-Alexander-Universität Erlangen-Nürnberg abrufbar:\\
    \href{https://opus4.kobv.de/opus4-fau/home}{https://opus4.kobv.de/opus4-fau/home}\par
    \vspace{4em}
    Verlag und Auslieferung:
    FAU University Press, Universitätsstraße 4, 91054 Erlangen\par
    \vfill
    \@printinformation\par
    \vfill
    \begin{tabular}{@{}l l}
      ISBN: & \@isbn \\
      eISBN: & \@eisbn \\
      ISSN: & \@issn \\
      DOI: & \@doi
    \end{tabular}
  \end{titlepage}%
}
% Titlepage of the faculty %%% BIS JETZT NUR FUER TECHFAK
\newcommand{\makefacultytitle}{
  \begin{titlepage}
    \setlength{\parindent}{\z@}
    \setlength{\parskip}{\z@}
    \onehalfspacing
    \typeout{Typesetting the faculty titlepage!}
    \centering
    \vspace*{4.8mm}
    {\usekomafont{facultytitle} \@title\par}
    \vfill
    {\usekomafont{faculty}
      Der Technischen Fakultät \\
      der Friedrich-Alexander-Universität\\
      Erlangen-Nürnberg \par}
    \vspace{6mm}
    {\usekomafont{faculty}
      zur \\
      Erlangung des Doktorgrades Dr.-Ing.\par}
    \vspace{34mm}
    {\usekomafont{faculty} vorgelegt von \par}
      \vspace{6.2mm}
    {\usekomafont{faculty} \@firstname\ \@lastname, \@degree \par}
      \vspace{6.2mm}
    {\usekomafont{faculty} aus \@origin \par}
    \vskip38mm
    \next@tpage
    \raggedright
    \normalfont\normalsize
    \phantom{M}\vfill
    { Als Dissertation genehmigt \\
      von der Technischen Fakultät \\
      der Friedrich-Alexander-Universität Erlangen-Nürnberg\par}
    \vspace{16mm}
    \begin{tabular}{@{}l l}
      \parbox[b]{20ex}{Tag der mündlichen \newline Prüfung:} & \@oralexam\\[1.25em]
      \parbox[b]{20ex}{Vorsitzender des \newline Promotionsorgans:} & \parbox[t]{0.6\textwidth}{\raggedright\@dean}\\[0.5em]
      Gutachter: & \parbox[t]{0.6\textwidth}{\raggedright\@reviewer} 
    \end{tabular}
    \vskip18mm
  \end{titlepage}
}


\AtEndPreamble{
  \iffaupress@acronym
    \iffaupress@splitacronym
      \input{acronyms/acronym-symbol.ac}
      \input{acronyms/acronym-abbreviation.ac}
    \fi 
    \iffaupress@combinedacronym
      \input{acronyms/acronym-symbol.ac}
      \input{acronyms/acronym-abbreviation.ac}
    \fi 
    \iffaupress@abbreviation
      \input{acronyms/acronym-abbreviation.ac}
    \fi 
    \iffaupress@symbol
      \input{acronyms/acronym-symbol.ac}
    \fi 
  \fi 
  % Adds author, title, subject, keywords to PDF metadata
  \hypersetup{
    pdfauthor = {\@firstname~\@lastname},
    pdftitle = {\@title},
    pdfsubject = {\@subject},
    pdfkeywords = {\@keywords}
  }
}

% Supress widows and orphans
\clubpenalty = 10000
\widowpenalty = 10000
\displaywidowpenalty = 10000
% Allow ragged page bottoms
\raggedbottom
\listfiles
