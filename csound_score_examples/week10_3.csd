<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from week10_3.orc and week10_3.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


          instr 1

aindex    phasor    (.894/1.5)/p3,p6         ; OFFSET PASSED IN p6 (BETWEEN 0 AND 1)
asig      table     aindex*32768,1           ; READ TABLE 1 (WITH RAW VALUES)
          out       asig                     ; OUTPUT

          endin

</CsInstruments>
<CsScore>
f1 0 65536 -1 "hellorcb.aif" 0 4 0  ; GEN-01 STATEMENT (ACCESSES 2 SEC FILE "TSE-U")


;       st      dur

i1     0         2

</CsScore>
</CsoundSynthesizer>
