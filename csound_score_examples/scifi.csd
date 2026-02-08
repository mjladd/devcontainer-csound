<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from scifi.orc and scifi.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2

;------------------------------------------------------------------
; INDUSTRY
; BY HANS MIKELSON APRIL 1998
;------------------------------------------------------------------
; ORCHESTRA


;------------------------------------------------------------------
; SCIFI EFFECTS
;------------------------------------------------------------------
          instr      6

idur      =          p3
iamp      =          p4
ifqc      =          cpspch(p5)
irattab   =          p6
iratrat   =          p7
ipantab   =          p8
imixtab   =          p9
ilptab    =          p10
imodf     =          p11
imodl     =          p12

kpan      oscil      1, 1/idur, ipantab                     ; PANNING
kmix      oscil      1, 1/idur, imixtab                     ; FADING
kloop     oscil      1, 1/idur, ilptab                      ; LOOPING

loop1:
kprate    oscil      1, iratrat/kloop, irattab              ; PULSE RATE

;                Amp   Fqc          Car   Mod    MAmp    Wave
aout      foscil   iamp, ifqc*kprate, 1,    imodf, imodl,  1    ; FM SOURCE

;       WHEN THE TIME RUNS OUT REINITIALIZE
          timout     0, i(kloop), cont1
          reinit     loop1
cont1:

          outs       aout*sqrt(kpan)*kmix, aout*sqrt(1-kpan)*kmix ; OUTPUT PAN & FADE

          endin


</CsInstruments>
<CsScore>
; SCORE
f1 0 8192 10 1 ; SINE

; PULSE TABLES
f10	0 1024   7  0 256 0 256 1 256 0 256 0
f11 0 1024   7	 0 256 0 128 0 128 1 128 0 128 0 256 0
f12 0 1024   7	 0 512 1 512 0
; RATE TABLES
f20	0 1024  -5  100  512  1000  512 100
f21	0 1024  -5  10	 1024 1000
f22	0 1024  -5  100  512  10000 512  30
f23	0 1024  -5  25	 1024  62
f24	0 1024  -7  500  1024  62
f25	0 1024  -5  5000 1024  100
f26	0 1024  -7  50	  512  500 512 50
f27	0 1024  -5  .5	  512  2 512 .5
f28	0 1024  -5  .5	  1024 4
f29	0 1024  -7  .5	  250 .5 6 2 250 2 6 1 250 1 6 4 256 .5
f50	0 1024  -5  1.5  150 .75 106 2 200 2 56 1.75 200 1 56 4 256 .5
; PAN TABLES
f30	0 1024  7	 0  1024	1
f31	0 1024  7	 1  1024	0
f32	0 1024  7	 1 512  0 512 1
f33	0 1024  -7 .5 1024 .5
; MIX TABLES
f40	0 1024  5	 .01 256 1 512 1 256 .01
f41	0 1024  7	 0 200 1 624 1 200 0
f42	0 1024  5	 1 1024 1

; GENERATE SCI-FI SOUNDS
;   Sta  Dur  Amp	Pitch  RtTab  RtRt	PanTab  MixTab	 Loop  FMFqc FMAmp
i6  0    4   8000	6.07	  50	    2	30	   41	 42	  2	   6
i6  5    4   8000	8.00	  29	    2	31	   41	 42	  2	   6


</CsScore>
</CsoundSynthesizer>
