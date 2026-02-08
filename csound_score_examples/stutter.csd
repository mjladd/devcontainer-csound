<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from stutter.orc and stutter.sco
; Original files preserved in same directory

sr             =              44100
kr             =              22050
ksmps          =              2
nchnls         =              2

; ORCHESTRA


;------------------------------------------------------------------
; SAMPLER EFFECTS
;------------------------------------------------------------------
               instr          7

idur           =              p3
iamp           =              p4
ifqc           =              p5
irattab        =              p6
iratrat        =              p7
ipantab        =              p8
imixtab        =              p9
ilptab         =              p10
isndin         =              p11

kpan           oscil          1, 1/idur, ipantab                 ; PANNING
kmix           oscil          1, 1/idur, imixtab                 ; FADING
kloop          oscil          1, 1/idur, ilptab                  ; LOOPING
koffset        linseg         0, idur, 1

loop1:
kprate         oscil          1, iratrat/kloop, irattab          ; PULSE RATE
kamp           linseg         0, .005, 1, i(kloop)-.01, 1, .005, 0
;                Amp     Fqc
a1, a2  soundin  isndin, i(koffset)
aout           =              (a1+a2)/2*kamp
;aout          oscil          10000*kamp, 440, 1

;       WHEN THE TIME RUNS OUT REINITIALIZE
               timout         0, i(kloop), cont1
               reinit         loop1
cont1:

               outs           aout*sqrt(kpan)*kmix, aout*sqrt(1-kpan)*kmix      ; OUTPUT PAN & FADE

               endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1

; PULSE TABLES
f10  0 1024   7  0 256 0 256 1 256 0 256 0
f11 0 1024   7  0 256 0 128 0 128 1 128 0 128 0 256 0
f12 0 1024   7  0 512 1 512 0
; RATE TABLES
f29  0 1024  -7  .5   1024 .5
; PAN TABLES
f31  0 1024  7  1  1024  0
; MIX TABLES
f41  0 1024  5  .01 128 1 768 1 128 .01

f53 0 1024 -7  .1 1024 .02
;   Sta  Dur  Amp   Pitch  RtTab  RtRt  PanTab  MixTab  Loop  SoundIn
i7  0    1    1     1      29     1     31      41      53    13


</CsScore>
</CsoundSynthesizer>
