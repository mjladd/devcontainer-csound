<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from WaveShaper2.orc and WaveShaper2.sco
; Original files preserved in same directory

sr     = 44100
kr     = 44100
ksmps  = 1
nchnls = 1


instr    1 ; Dynamic Waveshaper - randomly crossfades between 8 tables

ilevl    = p4*32767 ; Output level
irate    = p5       ; Rate
itabl1   = p6       ; 1st table
itabl2   = p7       ; 2nd table
itabl3   = p8       ; 3rd table
itabl4   = p9       ; 4th table
itabl5   = p10      ; 5th table
itabl6   = p11      ; 6th table
itabl7   = p12      ; 7th table
itabl8   = p13      ; 8th table

ain      soundin  "Sample1"

ain      = ain/65535
iseed    = rnd(1)
kdclick  linseg  0, .002, 1, p3 - .004, 1, .002, 0
krnd     randi  .5, irate, iseed
krnd     = krnd + .5
krnd1    table  krnd, 100, 1,  000, 1
krnd2    table  krnd, 100, 1, .125, 1
krnd3    table  krnd, 100, 1, .250, 1
krnd4    table  krnd, 100, 1, .375, 1
krnd5    table  krnd, 100, 1, .500, 1
krnd6    table  krnd, 100, 1, .625, 1
krnd7    table  krnd, 100, 1, .750, 1
krnd8    table  krnd, 100, 1, .875, 1
awav1    tablei  ain, itabl1, 1, .5
awav2    tablei  ain, itabl2, 1, .5
awav3    tablei  ain, itabl3, 1, .5
awav4    tablei  ain, itabl4, 1, .5
awav5    tablei  ain, itabl5, 1, .5
awav6    tablei  ain, itabl6, 1, .5
awav7    tablei  ain, itabl7, 1, .5
awav8    tablei  ain, itabl8, 1, .5
asum1    = awav1*krnd1 + awav2*krnd2 + awav3*krnd3 + awav4*krnd4
asum2    = awav5*krnd5 + awav6*krnd6 + awav7*krnd7 + awav8*krnd8
;aout     atone  asum1 + asum2, 15
aout     = asum1 + asum2
out      aout*ilevl*kdclick

endin

</CsInstruments>
<CsScore>
f01 0 1025 7 -1 1024 1                             ; No effect
f02 0 1025 7 1 1024 -1                             ; Inverter
f03 0 1025 7 0 512 0 512 1                         ; Pos 1/2 wave rectifier
f04 0 1025 7 -1 512 0 512 0                        ; Neg 1/2 wave rectifier
f05 0 1025 7 1 512 0 512 1                         ; Full wave rectifier
f06 0 1025 -7 1 1024 1                             ; + DC offset
f07 0 1025 -7 -1 1024 -1                           ; - DC offset
f08 0 1025 -7 -1 512 0 256 .5 256 .5               ; Unipolar clipping distortion
f09 0 1025 7  0 512 1 0 -1 512 0                   ; 2's complement distortion
f10 0 1025 17 0 0 205 1 410 2 615 3 820 4          ; 5 Step staircase
f11 0 1025 17 0 0 128 1 256 2 384 3 512 4 640 5 768 6 896 7 ; 8 Step staircase
f12 0 1025 8 -1 12 -.99 1000 .99 12 1              ; Gentle distortion
f13 0 1025 8 -1 256 -.55 256 0 256 .45 256 1       ; Valve distortion
f14 0 1025 13 1 1 0 2 2 1                          ; Nice Distortion
f15 0 1025 13 1 1 0 10 .1                          ; Slight 2nd harmonic
f16 0 1025 7 -1 384 0 256 0 384 1                  ; Crossover distortion
f17 0 1025 -7 -.5 256 -.5 512 .5 256 .5            ; Hard clipping distortion
f18 0 1025 7 -1 500 0 6 -1 12 1 6 0 500 1          ; Zero crossing spike
f19 0 1025 7 -1 512 0 100 .2 2 0 410 1             ; Linear discontinuous
f20 0 1025 7 -1 128 -.75 0 0 256 0 0 -.25 256 .25 0 0 256 0 0 .75 128 1 ; Holes
f21 0 1025 7 0 64 1 128 -1 128 1 128 -1 128 1 128 -1 128 1 128 -1 64 0 ; 4 Triangles
f22 0 1025 9 .5 1 270                              ; Sine curve
f23 0 1025 5 .001 1024 1                           ; Exponential curve (unipolar)
f24 0 1025 8 -1 256 -.8 256 0 256 .8 256 1         ; Rough compress
f25 0 1025 13 1 1 0 1 1                            ; 2nd harmonic
f26 0 1025 13 1 1 0 1 1 1                          ; 2nd & 3rd harmonics
f27 0 1025 13 1 1 0 1 0 1                          ; 3rd harmonic
f28 0 1025 13 1 1 0 1 0 0 1                        ; 4th harmonic
f29 0 1025 13 1 1 0 1 0 0 0 1                      ; 5th harmonic
f30 0 1025 13 1 1 0 1 0 0 0 0 1                    ; 6th harmonic
f31 0 1025 13 1 1 0 1 0 0 0 0 0 1                  ; 7th harmonic
f32 0 1025 13 1 1 0 1 0 0 0 0 0 0 1                ; 8th harmonic
f33 0 1025 13 1 1 0 1 0 0 0 0 0 0 0 1              ; 9th harmonic
f34 0 1025 13 1 1 0 0 1 0 1 0 1 0 1 0 1 0 1 0 1    ; Even harmonics
f35 0 1025 13 1 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1      ; Odd harmonics
f36 0 1025 13 1 1 0 1 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1; High harmonics
f37 0 1025 13 1 1 0 1 0 1 0 0 1 0 0 0 1 0 1        ; Random harmonics
f38 0 1025 10 0 1                                  ; 2 sines
f39 0 1025 10 0 0 1                                ; 3 sines
f40 0 1025 10 0 0 0 1                              ; 4 sines
f41 0 1025 10 0 0 0 0 1                            ; 5 sines
f42 0 1025 10 0 0 0 0 0 1                          ; 6 sines
f43 0 1025 10 0 0 0 0 0 0 1                        ; 7 sines
f44 0 1025 10 0 0 0 0 0 0 0 1                      ; 8 sines
f45 0 1025 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1      ; 16 sines
f46 0 1025 7 -1 512 -1 0 1 512 1                   ; 1-Bit D/A
f47 0 1025 21 2                                    ; Linear Noise
f48 0 1025 21 1                                    ; White Noise

f100 0 4096 -7 1 512 0 3072 0 512 1                ; 1/4 triangle for crossfade


;   Strt  Leng  Levl  Rate  Tabl1 Tabl2 Tabl3 Tabl4 Tabl5 Tabl6 Tabl7 Tabl8
i1  0.00  1.47  1.00  2.51  11    19    31    16    10    04    05    27
e

</CsScore>
</CsoundSynthesizer>
