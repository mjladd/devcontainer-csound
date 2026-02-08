<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from drum4.orc and drum4.sco
; Original files preserved in same directory

sr             =              44100                         ; SAMPLE RATE
kr             =              44100                         ; KONTROL RATE
ksmps          =              1                             ; SAMPLES/KONTROL PERIOD
nchnls         =              2                             ; NORMAL STEREO

; ORC
;---------------------------------------------------------
; KICK DRUM
; CODED BY HANS MIKELSON AUGUST 25, 1999
;---------------------------------------------------------
               zakinit        50,50                         ; MAY NEED THIS LATER

;---------------------------------------------------------
; KICK DRUM 1
;---------------------------------------------------------
               instr          10

idur           =              p3                            ; Duration
iamp           =              p4                            ; Amplitude
iacc           =              p5                            ; Accent
irez           =              p6                            ; Resonance

kfenv          expseg         1500*iacc,  .04, 200, .04, 120, idur-.04, 40      ; FREQ ENVELOPE
krenv          expseg         .7,  idur, 1                                      ; Q ENVELOPE
kaenv          expseg         .1, .001, 1, .02, 1, .04, .7, idur-.062, .7       ; AMP ENVELOPE
kdclck         linseg         0, .002, 1, idur-.004, 1, .002, 0                 ; DECLICK
asig           rand           2                                                 ; RANDOM NUMBER
; I USE RAND 2 TO RELY ON MOOGVCF BUILT IN LIMITER

aflt           moogvcf        asig, kfenv, irez*krenv       ; MOOG FILTER

aout1          =              aflt*kaenv*3                  ; SCALE THE SOUND

krms           rms            aout1, 1000                   ; LIMITER, GET RMS
klim           table3         krms*.5, 5, 1                 ; GET LIMITING VALUE
aout           =              aout1*klim*iamp*kdclck        ; SCALE AGAIN AND OUPUT

               outs           aout, aout                    ; OUTPUT THE SOUND

               endin

</CsInstruments>
<CsScore>
; SCO
f1 0 65536 10 1
f5 0 1024 -8 1 256 1 256 .7 256 .1 256 .01             ; COMPRESSION/LIMITING CURVE

;    Sta   Dur  Amp    Accent  Q
i10  0.0   .18  24000  1       1.2
i10  0.5   .    .      .8      1.5
i10  1.0   .    .      .5      1.8
i10  1.5   .    .      .4      2.2

i10  2.0   .18  24000  1       1.2
i10  2.5   .    .      .8      1.5
i10  3.0   .    .      .5      1.8
i10  3.75  .    .      .4      2.2
i10  3.5   .    .      .4      2.2

i10  4.0   .18  24000  1       1.2
i10  4.5   .    .      .8      1.5
i10  5.0   .    .      .5      1.8
i10  5.5   .    .      .4      2.2

i10  6.0   .18  24000  1       1.2
i10  6.5   .    .      .8      1.5
i10  7.0   .    .      .5      1.8
i10  7.75  .    .      .4      2.2
i10  7.5   .    .      .4      2.2

</CsScore>
</CsoundSynthesizer>
