<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from grainer.orc and grainer.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2


          instr      1

idur      =         p3
iamp      =         p4
ifqc      =         cpspch(p5)
irate     =         p6
ipulse1   =         p7
ipulse2   =         p8

krate     oscil     1, 1/idur, p6
kamp1     oscil     iamp, krate, ipulse1
kamp2     oscil     iamp, krate, ipulse2

;                   Amp     Fqc   Car   Mod   MAmp           Wave
afout     foscil    kamp1, ifqc, 1,     2.72, 1+3*(1+kamp2), 1
arnd1     rand      kamp2
arout     butterbp  arnd1, ifqc, ifqc/2

          outs      afout+arout*16, afout+arout*16

          endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1
f2 0 1024 -5  1 256 10 256 100 256 4000 256 1
f3 0 4096  7  0 3072 0 512 1 512  0
f4 0 4096  7  0 512  1 512 0 3072 0

;    Sta  Dur  Amp  Pitch  Rate  Pulse1  Pulse2
i1   0    8   8000  8.00   2     3       4

</CsScore>
</CsoundSynthesizer>
