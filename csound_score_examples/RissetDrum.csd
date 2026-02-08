<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from RissetDrum.orc and RissetDrum.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1

; drum.o
; This is the Csound code for the Drum Instrument based on
; Risset's Introductory Catalog of Computer Synthesized Sounds
; see pp.93-94 and figure 3.26 in "Computer Music" - Dodge


          instr 1
                                             ; INITIALIZATION
i1        =         1/p3                     ; ONCE PER DURATION - FOR ENVELOPES
i2        =         cpspch(p4)               ; CONVERT OCT. POINT PCH-CLASS NOTATION TO Hz
i3        =         p5/2                     ; THESE THREE ASSIGNMENTS BALANCE THE THREE
i4        =         p5/6                     ; BRANCHES OF THE DRUM INSTRUMENT
i5        =         p5/2.5

                                             ; BRANCH 1 - NOISE
a1        oscili    i3,i1,2                  ; GENERATE STEEP EXPONENTIAL ENVELOPE
a1        randi     a1,p6                    ; GENERATE BAND OF NOISE WITH FREQ. GIVEN BY p6
a1        oscili    a1,500,4                 ; USE NOISE BAND FOR AMP INPUT - RING MOD.

                                             ; BRANCH 2 - INHARM
a2        oscili    i4,i1,2                  ; STEEP ENVELOPE WITH LOWER AMPLITUDE THAN a1
a2        oscili    a2,i2*.1,3               ; GENERATE INHARMONIC PARTIALS - 1,1.6,2.2,2.3

                                             ; BRANCH 3 - FUND
a3        oscili    i5,i1,1                  ; DECAY OF f1 IS LESS STEEP THAN f2
a3        oscili    a3,i2,4                  ; GENERATES FUNDAMENTAL TONE

                                             ; GLOBAL ENVELOPE TO PREVENT CLICKING
a4        linseg    1,p3-.05,1,.05,0,.01,0
          out       a4*(a1+a2+a3)
          endin

</CsInstruments>
<CsScore>
; Risset's score for drum sound

; amp envelopes

f1 0 512 5 1 512 .004
f2 0 512 5 1 512 .00012

; waveforms

f3 0 512 9 10 1 0 16 1.5 0 22 2 0 23 1.5 0
f4 0 512 9 1 1 0

;       start   dur     freq    amp     cps(noise)

i1      1.00    1       6.0     24000   400
i1      2.00    1       .       27000   .
i1      2.01    .3      .       25000   .
i1      2.33    .       .       26000   .
i1      2.66    .       .       22000   .
i1      3.00    .5      .       24000   .
i1      3.50    .       .       .       .
i1      4.06    .       .       5000    .
i1      4.12    .       .       <       .
i1      4.18    .       .       <       .
i1      4.25    .       .       <       .
i1      4.31    .       .       <       .
i1      4.37    .       .       <       .
i1      4.45    .       .       <       .
i1      4.50    .       .       <       .
i1      4.56    .       .       <       .
i1      4.62    .       .       <       .
i1      4.69    .       .       <       .
i1      4.75    .       .       <       .
i1      4.81    .       .       <       .
i1      4.87    .       .       <       .
i1      4.93    .       .       <       .
i1      5.00    2       .       30000   .
i1      5.01    3       .       22000   .
e

</CsScore>
</CsoundSynthesizer>
