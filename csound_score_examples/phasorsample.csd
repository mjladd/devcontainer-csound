<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from phasorsample.orc and phasorsample.sco
; Original files preserved in same directory

sr = 44100
kr = 4410
ksmps = 10
nchnls = 1

instr 1

 aindex line 0, p3, 1               ; RISES FROM 0 TO 1 IN THE TOTAL DURATION
 asig table aindex*32768, 1         ; READ TABLE 1 (WITH RAW VALUES)
 out asig                           ; OUTPUT


endin

</CsInstruments>
<CsScore>
f1 0 65536 -1 "hellorcb.aif" 0 4 0      ;GEN-01 STATEMENT (ACCESSES 2 SEC FILE "TSE-U")


;       st      dur

i1     0        1

</CsScore>
</CsoundSynthesizer>
