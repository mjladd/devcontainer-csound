<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Width.orc and Width.sco
; Original files preserved in same directory

sr       = 44100
kr       = 4410
ksmps    = 10
nchnls   = 2


instr    1 ; Stereo Width Expander.

ilevl    = p4 ; Output level
iwidth   = p5 ; Stereo width: -1=Mono 0=Normal +1=Wide
ifreq    = p6 ; Bass cut frequency

a1, a2   soundin  "StereoSample"

ahp1     atone  a1, ifreq
ahp2     atone  a2, ifreq
aout1    = (iwidth >= 0 ? a1 - ahp2*iwidth : a1 + a2*int(iwidth))
aout2    = (iwidth >= 0 ? a2 - ahp1*iwidth : a2 + a1*int(iwidth))
outs1    aout1*ilevl
outs2    aout2*ilevl

endin

</CsInstruments>
<CsScore>
;     Strt  Leng  Levl  Width Freq
i01   0.00  1.50  1.00 -1.00  100 ; Mono
i01   2.00  .     .    -0.50  .   ; Narrow
i01   4.00  .     .     0.00  .   ; Normal stereo
i01   6.00  .     .     0.50  .   ; Wide
i01   8.00  .     .     1.00  .   ; Very wide
e

</CsScore>
</CsoundSynthesizer>
