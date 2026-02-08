<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Noorden4.orc and Noorden4.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2


          instr     1

iamp      =         ampdb(p4)
ifreq     =         p5
irate     =         p6
ifun      =         p7
ifun2     =         p8

kamp      oscili    iamp, irate, ifun
kglis     oscili    1200, 1/p3, ifun2
asig      oscil     kamp, ifreq + kglis, 1
          outs      asig, asig
          endin

</CsInstruments>
<CsScore>
f1 0 512 10 1
f4 0 512 7 0 0 1 256 0 256 1
;"dummy" function
f5 0 512 7 0 1 512 1
;function for tones A
f6 0 512 7 0 10 0 49 1 15 1 49 0 276 0 49 1 15 1 49 0
;function for tones B
f7 0 512 7 0 133 0 93 1 60 1 93 0 133 0
;ins  start  dur  amp   freq   rate  fun1  fun2
i1      0    40   80     800     5    6     4
i1      0    40   80    1000   2.5    7     5
endin

</CsScore>
</CsoundSynthesizer>
