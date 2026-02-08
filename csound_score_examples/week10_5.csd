<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from week10_5.orc and week10_5.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


          instr 1

itrans    =         cpspch(8.00)/cpspch(p5)  ; RATIO OF ORIG TO NEW PITCH
aindex    phasor    (.894/1.5)/(1.5*itrans)  ; READ ONCE IN TABLE DURATION
asig      table     aindex*32768,1           ; READ TABLE 1
          out       asig                     ; OUTPUT

          endin

</CsInstruments>
<CsScore>
f1 0 65536 -1 "hellorcb.aif" 0 4 0          ; GEN-01 STATEMENT (ACCESSES 2 SEC FILE "TSE-U")

;      st       dur     amp        pitch

i1     0         2       0         7.00     ;  C PLAYED FOR 2 SECONDS

</CsScore>
</CsoundSynthesizer>
