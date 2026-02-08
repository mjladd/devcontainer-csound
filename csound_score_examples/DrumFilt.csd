<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from DrumFilt.orc and DrumFilt.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;         BASIC DRUM FILE                               ;
;                                                       ;
;         p3 = DURATION        p4 = AMPLITUDE           ;
;         p5 = PITCH IN PCH                             ;
;                                                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

          instr 1
k         init  32
inibw     =         30
kbwchg    oscil1    0.0,30,.2,2
kbw       =         kbwchg + inibw
loop:
asnd      oscili    (p4*.2),cpspch(p5),1
arnd      rand      p4,-1
afltr1    reson     arnd,cpspch(p5),kbw,2
afltr2    reson     afltr1,0,100,2
afltr     balance   afltr2,arnd

          if        (k <= 0) kgoto continue
k         =         k - 1
            kgoto   loop
continue:
adrum     =         afltr + asnd
asig      envlpx    adrum,.1,.2,.1,2,1,.01
          out       asig
          endin

</CsInstruments>
<CsScore>
;       SINE WAVE
f1 0.0 512 10 1
;       LINEAR RISE
f2 0.0 513 7  0 513 1
;       LINEAR FALL
f3 0.0 513 7  1 513 0
;       EXPONENTIAL RISE
f4 0.0 513 5 .001 513 1
;       EXPONENTIAL RISE
f5 0.0 513 5 1 513 .001
;
;       INSTRUMENT CARDS
i1 0.000 1.000 28000 5.11
i1 0.001 0.998  2800 6.11
e

</CsScore>
</CsoundSynthesizer>
