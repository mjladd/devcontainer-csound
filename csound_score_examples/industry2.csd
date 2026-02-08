<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from industry2.orc and industry2.sco
; Original files preserved in same directory

sr        =         44100
kr        =         22050
ksmps     =         2
nchnls    =         2


;------------------------------------------------------------------
; INDUSTRY
; BY HANS MIKELSON APRIL 1998
;------------------------------------------------------------------
; ORCHESTRA



          instr 2

idur      =         p3
iamp      =         p4*2
ifqc      =         cpspch(p5)
iplstab   =         p6
irattab   =         p7
iratrat   =         p8
ipantab   =         p9
imixtab   =         p10
iloop     =         p11
adel      init      0

kprate    oscil     1, iratrat, irattab
kamp      oscil     iamp, kprate, iplstab
kloop     linseg    0, .005, 1, iloop-.01, 1, .005, 0, p3-iloop-.01, 0
kpan      oscil     1, 1/idur, ipantab
kmix      oscil     1, 1/idur, imixtab

asig      rand      kamp
aflt      butterbp  asig, ifqc, ifqc/4
abal      balance   aflt, asig

aout      =         abal*kloop+adel
adel      delay     aout, iloop

          outs      aout*sqrt(kpan)*kmix, aout*sqrt(1-kpan)*kmix

          endin


</CsInstruments>
<CsScore>
; SCORE
; Pulse Tables
f10 0 1024 7 0 256 0 256 1 256 0 256 0
f11 0 1024 7 0 256 0 128 0 128 1 128 0 128 0 256 0
; Rate Tables
f20 0 1024 -5 1 512 200 512 100
f21 0 1024 -5 10 1024 1000
f22 0 1024 -5 100 512 10000 512 30
f23 0 1024 -5 25 1024 62
f24 0 1024 -7 500 1024 62
f25 0 1024 -5 5000 1024 1000
f26 0 1024 -7 50 512 500 512 50
; Pan Tables
f30 0 1024 7 0 1024 1
f31 0 1024 7 1 1024 0
f32 0 1024 7 1 512 0 512 1
; Mix Tables
f40 0 1024 5 .01 256 1 512 1 256 .01
f41 0 1024 5 .01 128 1 768 1 128 .01

; Generate industrial tones
; Sta Dur Amp Pitch PulseTab RtTab RtRt PanTab MixTab Loop
i2 0 8 8000 9.00 11 22 1 31 40 .2
i2 3 10 8000 7.00 10 22 1 32 41 .3
i2 7 12 8000 9.00 11 23 10 30 40 .2
i2 9 12 8000 8.00 11 24 10 32 41 .05

i2 11 20 8000 7.00 11 25 4 31 40 .5
i2 12 22 8000 7.02 11 25 10 32 41 .2
i2 17 8 8000 6.00 11 26 10 30 40 .01
i2 17 10 8000 8.05 11 26 10 31 41 .08


</CsScore>
</CsoundSynthesizer>
