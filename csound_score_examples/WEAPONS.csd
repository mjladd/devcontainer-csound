<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from WEAPONS.ORC and WEAPONS.SCO
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         2


;ALIEN WEAPONRY 1

               instr     1

;--------------------------------------------------------------------
idur           init      p3
iamp           init      p4
ifqc           init      p5
ifqc2          init      p6
ax             init      p7
ay             init      p8
az             init      p9
is             init      p10
ir             init      p11
ib             init      p12
ih             init      p13
ilfo           init      p14
ipantab        init      p15

kclkold        init      -1
kpan           oscil     1, 1/idur, ipantab
kclknew        oscil     1, ilfo/p3/2, 3
if   (kclkold==kclknew)  goto next
  ax           =         p7
  ay           =         p8
  az           =         p9
next:
kclkold        =         kclknew

;--------------------------------------------------------------------
;kamp          linseg     0, .2, iamp, idur-.21, iamp, .01, 0
kamp           oscil     1, ilfo/p3, 4
kamp           =         kamp*iamp
krez           oscil     1, ilfo/p3, 2
krez           =         1000; (krez+1)*4000+1000
kfqc           oscil     1, ilfo/p3, 2
kfqc           =         (kfqc+1)*(ifqc-ifqc2)+ifqc


axnew          =         ax+ih*is*(ay-ax)
aynew          =         ay+ih*(-ax*az+ir*ax-ay)
aznew          =         az+ih*(ax*ay-ib*az)

;--------------------------------------------------------------------
ax             =         axnew
ay             =         aynew
az             =         aznew

;--------------------------------------------------------------------

aoutx          oscil     1, kfqc*(1+ax), 1
aouty          oscil     1, kfqc*(1+ay), 1

;arezx         reson     asigx, krez, krez/8
;aoutx         balance   arezx, asigx
;arezy         reson     asigy, krez, krez/8
;aouty         balance   arezy, asigy

               outs      aoutx*kamp*sqrt(kpan), aouty*kamp*sqrt(1-kpan)


endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1                               ; SINE
f2 0 8192 7  -1 8192 1                       ; RAMP
f3 0 8192 7  1 4096 1 0 -1 4096 -1           ; SQUARE
f4 0 8192 7  0 7992 1 200 0                  ; RAMP
f5 0 8192 7  0 1024 1 6968 1 200 0           ; ENVELOPE

f60 0 1024 7 1 256 0 256 .5 256 .1 256 1 ; Pan

;   Sta  Dur  Amp   Freq1 Freq2  X   Y   Z   s    r   b      h     LFO  PanTab
i1  0    4  12000  110   520    .6  .6  .6  16   28  2.667  .002  8      60
i1  0    4  10000  240   120    .6  .6  .7  10   27  2.657  .004  32     60


</CsScore>
</CsoundSynthesizer>
