<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from fmfeed1a.orc and fmfeed1a.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


          instr 1
afm1      init      0
afm2      init      0
isine     =         1
icaramp   =         p4
icarfreq  =         p5
ifeedscale =        p6
kamp      linseg    0, p3*.01,1, p3*.98, 1,p3*.01,0
kfeedamp  linseg    0, p3*.03,1, p3*.97, 0
kfeedampinv linseg  1, p3*.03,0, p3*.97, 1
afm1      oscili    icaramp, (icarfreq+afm2)+kfeedampinv,isine
afm2      =         (afm1*ifeedscale)*kfeedamp
asig      =         afm1*kamp
;         display   afm1, .25
;         display   afm2, .25
          out       asig
          endin

</CsInstruments>
<CsScore>
f1 0 4096 10 1

i1 0 6  5000 200    .02
s
i1 0 6  5000 200    .03
s
i1 0 6  5000 200    .04
s
i1 0 6  5000 200    .05
s
i1 0 6  5000 200    .06
s
i1 0 6  5000 200    .07
s
i1 0 6  5000 200    .08
s
i1 0 6  5000 200    .09
s
i1 0 6  5000 200    .1
s
i1 0 6  5000 200    .11
e

</CsScore>
</CsoundSynthesizer>
