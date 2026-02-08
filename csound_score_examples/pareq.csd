<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from pareq.orc and pareq.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2


; ORCHESTRA:
;----------------------------------------------------------------
; PARAMETRIC EQUALIZER OPCODE
;----------------------------------------------------------------

          instr     15

ifc       =         p4            ; CENTER / SHELF
iq        =         p5            ; QUALITY FACTOR SQRT(.5) IS NO RESONANCE
iv        =         ampdb(p6)     ; VOLUME BOOST/CUT
imode     =         p7            ; MODE 0=PEAKING EQ, 1=LOW SHELF, 2=HIGH SHELF

kfc       linseg    ifc*2, p3, ifc/2

asig      rand      5000                          ; RANDOM NUMBER SOURCE FOR TESTING
aout      pareq     asig, kfc, iv, iq, imode      ; PARMETRIC EQUALIZATION
          outs      aout, aout                    ; OUTPUT THE RESULTS

          endin

</CsInstruments>
<CsScore>


; SCORE:
;   STA  DUR  FCENTER  Q           BOOST/CUT(DB)  MODE
i15 0    1    10000     .2          12             1
;i15 +    .    5000    .2          12             1
;i15 .    .    1000    .707       -12             2
;i15 .    .    5000    .1         -12             0

</CsScore>
</CsoundSynthesizer>
