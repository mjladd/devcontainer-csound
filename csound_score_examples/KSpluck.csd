<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from KSpluck.orc and KSpluck.sco
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         1

;****************************** ORCHESTRA **********************************

; EXAMPLE 1: KARPLUS-STRONG ALGORITHM.
; DAMIAN KELLER. MAY 1997.
; KARPLUS-STRONG IMPLEMENTED WITH A TABLE LOOKUP PROCEDURE.
; A TABLE IS READ AND WRITTEN UNTIL THE INSTRUMENT STOPS.
; LENGTH OF TABLE DETERMINES NOISINESS.


instr 1
     ilength   =         40                       ; LENGTH OF DELAY LINE: PITCH.

; INDEXING.
     aindex0   phasor    ilength
     aindex    =         aindex0 * ftlen(1)       ; INDEX TO READ TABLE.
     a1        tablei    (aindex), 1              ; PREVIOUS SAMPLE.

     aindex1   =         aindex + 1
     a2        tablei    (aindex1), 1             ; PRESENT SAMPLE.

; filter.
     a4        =         (a1 + a2)/2              ; LOWPASS FILTER.

; WRITING TABLE: FT1 WRITTEN TO FT1, GUARD POINT MODE.
               tablew    a4, aindex, 1, 0, 0, 2

               out       a4
endin

</CsInstruments>
<CsScore>
;***************************** SCORE ***************************************
; A TABLE IS INITIALIZED TO RANDOM VALUES.

;   length  Gen21 white noise   amplitude
f1  0 513    -21        1       32000

;inst   st  duration
i1      0   10

</CsScore>
</CsoundSynthesizer>
