<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from FltBuzz.orc and FltBuzz.sco
; Original files preserved in same directory

     sr             =         44100
     kr             =         4410
     ksmps          =         10
     nchnls         =         1


                    instr 1
   iattack          =         .01
   irelease         =         .2
   iwhite           =         10000
   idur             =         p3
   iamp             =         ampdb(p4)
   ifund            =         p5
   isweepstart      =         p6
   isweepend        =         p7
   ibandwidth       =         p8
   inoh             =         sr/2/ifund               ; CREATES A BANDLIMITED PULSE
   ifun             =         1

   kamp             linen     iamp, iattack, idur, irelease
   ksweep           line      isweepstart, idur, isweepend
   asig             buzz      1, ifund, inoh, ifun
   afltsig          reson     asig, ksweep, ibandwidth
   arampsig         =         kamp * afltsig
                    out       arampsig
                    endin

</CsInstruments>
<CsScore>
; buzzflt.sco

f1 0 4096 10 1

f0 1
f0 2
f0 3
f0 4
f0 5

; strt  dur   amp(dB)   fndfrq   stsweep  ndsweep   bndw
i1  0    5    60         200        650     650      100
i1  0    5    52         200        1100   1100      200
i1  0    5    47         200        2860   2860      600
i1  0    5    48         200        3300   3300      800
i1  0    5    41         200        4500   4500      900
e

</CsScore>
</CsoundSynthesizer>
