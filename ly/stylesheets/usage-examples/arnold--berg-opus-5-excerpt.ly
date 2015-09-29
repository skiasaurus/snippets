\version "2.19.12"

%TODO: Factor out paper and header blocks to get a consistent layout/titling
% for the font usage examples
\paper {
  indent = 0\cm
  right-margin = 1\cm
  system-count = 1
}

\header {
  title = "Vier Stücke für Klarinette und Klavier"
  composer = "Alban Berg"
  opus = "Opus 5/1 (excerpt)"

  instrument = "Notation font: ARNOLD"
}

% Global staff size should be set *before* selecting a font
#(set-global-staff-size 19.5)

\include "openlilylib"

\useLibrary "stylesheets"
\useNotationFont \with {
  extensions = ##t
}
Arnold

% Activate the alternative accent glyph
\altAccent

% use ScholarLY to annotate manual modifications
% to the engraving or the musical text.
\useLibrary scholarly
\useModule scholarly.annotate

#(display "")

%\setOption scholarly.colorize ##f

\layout {
  \context {
    \Score
    \remove "Bar_number_engraver"
    \accidentalStyle dodecaphonic-no-repeat
  }
}

\markup \vspace #2

\markup \justify {
  This example is taken from U.E. NNNN, but it isn't faithful to the edition.
  For the sake of displaying some glyphs there have been introduced some deliberate
  musical "errors".
}

\markup \vspace #1

% Here comes the musical content

global = {
 \time 4/4
}


clarinet = \relative b {
  \global
  \transposition bes
  \tempo "Ganz langsam." 4=40-44
  \repeat tremolo 8 { b32 \mf ( \startTrillSpan ais ) }
    \grace { c32 [ ( \stopTrillSpan a ] }
    \tuplet 3/2 {
      \repeat tremolo 16 gis64 )
        _\markup "quasi Flatterzunge"
      \repeat tremolo 16 g
      \repeat tremolo 16 fis
    } |

  % 07
  r4
    \once \override DynamicText.X-offset = -4
    a32 ( \f \< cis f as c es g b
    e8 \staccatissimo \arnoldWeakbeat ) \sfz \breathe
    e8-- \ff \arnoldStrongbeat  ( _\markup \italic (schwungvoll)
    \acciaccatura b8 dis-- e--)
}

rightOne = \relative bes'' {
  \global
  s2
  \voiceOne
  r8 ^\markup \italic "r.H."
  bes8-- ( _\markup { \dynamic fff \italic espress. } a4-- ~ |

  % 07
  a16 b fis \acciaccatura
    {
      \stemDown
      \lilypondIssue \with {
        message = "this isn't really an acciaccatura but it should
                   be a slashed grace note with a tie"
      }
      Flag
      d32
      \stemUp
    } d16
    \tuplet 6/4 {
      c16 bes g fis ) f^> _. e^> _.
    }
    gis8-> _( a4 ) gis8
}

rightTwo = \relative e' {
  \global
  r8 <e ges bes d>4 ^( ^\markup \italic "(voll)"
    ^\markup \italic "(Zeit lassen)"
    \arpeggio
      <d f a cis>8 \arpeggio
      <b c es g b>2 ) \arpeggio

  % 07
  \set tieWaitForNote = ##t
  \voiceTwo
  b'16 \rest \grace { c32 [ ~ e ] ~ } <c e>16
  b16 \rest b
  \once \override TupletBracket.stencil = ##f
  \once \override TupletNumber.stencil = ##f
  \tuplet 3/2 {
    g16 \rest bes \pp g
  }
  r8 \<
  s2 \! _\markup \italic cresc.
}

middle = \relative es'' {
  r8
    \once \override DynamicText.X-offset = -4
    es4-> ^\ff _( ^\markup \italic marc.
    e8-> bes'-> ) r8 r4 |

  %07
  \stopStaff
}

left = \relative as, {
  \global
  % Music follows here.
  r8 <as g'>4 _( ^\markup \italic "l.H. übergreifen" \arpeggio
    <g fis'>8 \arpeggio
    <fis e'>4. ) ~ \sustainOn
    \tuplet 3/2 { q16 <f' g>-> <as, bes>-> \sustainOff } |

 % 07
 es8-> (
   \sustainOn <e' gis>4-- )
   \once \override DynamicText.X-offset = -4
   \override TextScript.staff-padding = 3
   des,8-> \f ( ^\hauptstimme \sustainOff \sustainOn <d' ais' b>4-- ) ^\endstimme
   bes,8-> ( \sustainOff \sustainOn <des' f a c> )
}

pianoPart = \new PianoStaff  <<
  \new Staff = "right" <<
    \rightOne
    \rightTwo
  >>
  \new Staff = "middle" {
    \clef treble \middle
  }
  \new Staff = "left" {
    \clef bass \left
  }
>>

\score {
  <<
    \new Staff \clarinet
    \pianoPart
  >>
  \layout {}
}
