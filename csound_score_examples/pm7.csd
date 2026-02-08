<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from pm7.orc and pm7.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10                       ; DON´T CHANGE IT!
nchnls    =         1


;""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
          instr 1             ; HAMMER ACTION SIMULATOR
;""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

; SET INITIAL POSITION AND VELOCITY OF THE MASS
iv0       =         0
ix0       =         25000

; SET K, Z AND M
ik        =         p4
iz        =         p5
im2       =         30
im3       =         22

; NORMALIZE (DON'T TOUCH THIS!)
ik        =         ik/(sr*sr)
iz        =         iz/(1000000000*sr)       ; Z GIVEN IN N*s/(kg*10e-9)
im2       =         im2/1000000000           ; MASS GIVEN IN kg*10e-9
im3       =         im3/1000000000           ; MASS GIVEN IN kg*10e-9

kx3       init      ix0
kxprev3   init      ix0-1000*iv0/sr

kx2       init      0
kxprev2   init      0

kf1       =         ik*(kx2) + iz*((kx2-kxprev2))
          if        kx3 > kx2 goto nolink
kf2       =         -kf1 + ik*(kx3-kx2) + iz*((kx3-kxprev3)-(kx2-kxprev2))
kf3       =         -kf2 + ik*(-kx3) + iz*(-(kx3-kxprev3))
          goto      next

nolink:
kf2       =         -kf1
kf3       =         ik*(-kx3) + iz*(-(kx3-kxprev3))

next:
knext2    =         kf2/im2 + 2*kx2-kxprev2
knext3    =         kf3/im3 + 2*kx3-kxprev3

          aout      upsamp knext2
          out       aout

kxprev2   =         kx2
kxprev3   =         kx3
kx2       =         knext2
kx3       =         knext3
          endin

</CsInstruments>
<CsScore>
;      k  damping
i1 0 2 .1  300
i1 2 2 .05 500
i1 4 2 .2  200
i1 6 6 .01  50
i1 12 25 .03  5

e

</CsScore>
</CsoundSynthesizer>
