<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from stoc.orc and stoc.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2


          instr 1

;-------------Stochastic---Granulator--------
;--------BEZKO<bezkorom@ere.umontreal.ca>-----
;----------------------1996------------------

iseed     =         .8765                    ; CHANGE THIS!!

; STOCHASTIC GENERATORS, DON'T TOUCH!!!

kpdur     rand      1,iseed*.243
kpfreq    rand      1,iseed*.734
kpint     rand      1,iseed*.452
kppan     rand      1,iseed*.634
kpjou     rand      1,iseed*.824
kpphs     rand      1,iseed*.951

; VARIABLES, REPLACE P BY WHATEVER

kgfs      =         p4                       ; MAXIMUM FREQUENCY (Hz)
kgfi      =         p5                       ; MINIMUM FREQUECY (Hz)

kgvs      =         p6                       ; MAXIMUM SPEED(GRAIN/SECOND) (Hz)
kgvi      =         p7                       ; MINIMUM SPEED (Hz)
kgis      =         p8                       ; (MAXIMUM INTENSITY) (0-->16000)
kgii      =         p9                       ; (MINIMUM INTENSITY)
kgps      =         p10                      ; (PANNING SPREAD, 0=CENTER 1=RANDOM PANNING)
kgjs      =         p11                      ; (DENSITY (PROBABILITY THAT THE GRAIN IS PLAYED 0->1)

; MATHEMATICAL CONVERSIONS DON'T TOUCH!!!!


kidur     =         1/exp(log((kgvi))+abs((kpdur))*(log((kgvs))-log((kgvi))))

chicoutimi:



idur      =         int(i(kidur)*kr)/kr
ifreq     =         exp(log(i(kgfi))+abs(i(kpfreq))*(log(i(kgfs))-log(i(kgfi))))
iint      =         exp(log(i(kgii))+abs(i(kpint))*(log(i(kgis))-log(i(kgii))))
ipan      =         i(kppan)
ijou      =         abs(i(kpjou))
idens     =         i(kgjs)
iphs      =         abs(i(kpphs))
ispa      =         i(kgps)
iamp      =         (ijou < idens?iint:0)

          timout    0,abs(idur),montreal

          reinit    chicoutimi


montreal:
aind      line      0,idur,1
aenv      tablei    aind,2,1,0,0
asig      oscili    iamp*aenv,ifreq,1,iphs

          outs      asig*(1+ipan*ispa),asig*(1-ipan*ispa)


          endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1;wave of the grain
f2 0 8192 20 2;envelope of the grain


i1 0 2 100 10 100 20 16000 10000 1 .5
i1 2 2 100 500 100 200 16000 1000 0 .1
i1 4 4 200 1000 50 300 8000 7000 1 1
i1 6 2 300 400 90 100 8000 100 0 .8
i1 8 2 1000 10000 50 100 16000 100 1 .2
i1 10 2 10 20000 200 300 16000 15000 0 .3
i1 12 2 800 1000 10 20 16000 10000 1 .5
i1 14 2 400 500 100 200 16000 1000 0 .1
i1 16 4 300 1500 150 300 8000 7000 1 1
i1 18 2 100 700 75 100 8000 100 0 .8
i1 20 2 9000 10000 300 400 16000 100 1 .2
i1 22 2 10000 20000 50 500 16000 15000 0 .3

</CsScore>
</CsoundSynthesizer>
