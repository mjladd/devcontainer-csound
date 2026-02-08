<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from grainvox.orc and grainvox.sco
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         1





          instr 1
gibpv               =         3
gitpv               =         3
gicpv               =         3
giapv               =         3
gispv               =         3

gibpn               =         cpspch( 6.00)
gitpn               =         cpspch( 6.00)
gicpn               =         cpspch( 7.00)
giapn               =         cpspch( 7.00)
gispn               =         cpspch( 8.00)
endin


          instr 2

inote               =         cpspch( p4)
p3                  =         p3 + 1.7 * (1 / inote)

if   p5 == 2        igoto     pb
if   p5 == 5        igoto     pt
if   p5 == 8        igoto     pc
if   p5 == 11       igoto     pa
if   p5 == 14       igoto     ps
pb:
     ipvowel        =         gibpv
     ipnote         =         gibpn
     gibpn          =         inote
     gibpv          =         p6
     igoto cont
pt:
     ipvowel        =         gitpv
     ipnote         =         gitpn
     gitpn          =         inote
     gitpv          =         p6
     igoto cont
pc:
     ipvowel        =         gicpv
     ipnote         =         gicpn
     gicpn          =         inote
     gicpv          =         p6
     igoto cont
pa:
     ipvowel        =         giapv
     ipnote         =         giapn
     giapn          =         inote
     giapv          =         p6
     igoto cont
ps:
     ipvowel        =         gispv
     ipnote         =         gispn
     gispn          =         inote
     gispv          =         p6
     igoto cont

cont:

     index          =         5 * p6
     ipindex        =         5 * ipvowel
     idb            =         80

     iform1freq     table     index,              p5,  0
     iform1db       table     index,              p5 + 1,   0
     iform1amp      =         ampdb( idb + iform1db)

     iform2freq     table     index + 1,          p5,  0
     iform2db       table     index + 1,          p5 + 1,   0
     iform2amp      =         ampdb( idb + iform2db)

     iform3freq     table     index + 2,          p5,  0
     iform3db       table     index + 2,          p5 + 1,   0
     iform3amp      =         ampdb( idb + iform3db)

     iform4freq     table     index + 3,          p5,  0
     iform4db       table     index + 3,          p5 + 1,   0
     iform4amp      =         ampdb( idb + iform4db)

     iform5freq     table     index + 4,          p5,  0
     iform5db       table     index + 4,          p5 + 1,   0
     iform5amp      =         ampdb( idb + iform5db)

     ipform1        table     ipindex,       p5,  0
     ipform2        table     ipindex + 1,   p5,  0
     ipform3        table     ipindex + 2,   p5,  0
     ipform4        table     ipindex + 3,   p5,  0
     ipform5        table     ipindex + 4,   p5,  0

     ipform1db      table     ipindex,       p5 + 1,   0
     ipform2db      table     ipindex + 1,   p5 + 1,   0
     ipform3db      table     ipindex + 2,   p5 + 1,   0
     ipform4db      table     ipindex + 3,   p5 + 1,   0
     ipform5db      table     ipindex + 4,   p5 + 1,   0

     ipform1amp     =         ampdb( idb + ipform1db)
     ipform2amp     =         ampdb( idb + ipform2db)
     ipform3amp     =         ampdb( idb + ipform3db)
     ipform4amp     =         ampdb( idb + ipform4db)
     ipform5amp     =         ampdb( idb + ipform5db)

numcrunch:

;PITCH, VIBRATO AND AMPLITUDE CONTROLS

     kvibdepth linseg    0,   1,   1,   p3 - 1,   0
     kvib      oscil     4 * inote / 100 * kvibdepth,  5 ,  1

     krand1              randi     2 * inote / 100,    14
     krand2              randi     .6 * inote / 100,   1.6
     krand3              randi     inote / 100,   125
     krand     =         krand1 + krand2     + krand3 - 1.8
     kfund     =         kvib + krand

     kenv      linseg    p7, p9, 1, (p3 - 2 * p9), 1, p9, p8
     krand3              randi     .2, 4
     krand3              port krand3,   2
     kamp      =         kenv

     knote               expseg    ipnote, p11, inote, (p3 - p11), inote
     kpitch    =         knote + kfund

;/LA/ FORMANT FUNCTION GENERATORS

     if   p12  == 0 goto norms

     it        =         p9
     ipform1   =         220            ;/l/ Formants
     ipform2   =         1300
     ipnote    =         inote

;FORMANT FUNCTION GENERATORS

norms:

     it        =         2 * p9

     kform1    linseg    ipform1, it, iform1freq, p3 - it,  iform1freq
     kform2    linseg    ipform2, it, iform2freq, p3 - it,  iform2freq
     kform3    linseg    ipform3, it, iform3freq, p3 - it,  iform3freq
     kform4    linseg    ipform4, it, iform4freq, p3 - it,  iform4freq
     kform5    linseg    ipform5, it, iform5freq, p3 - it,  iform5freq


;AMPLITUDE SMOOTHING LINES

     kform1amp linseg    ipform1amp, it, iform1amp, p3 - it, iform1amp
     kform2amp linseg    ipform2amp, it, iform2amp, p3 - it, iform2amp
     kform3amp linseg    ipform3amp, it, iform3amp, p3 - it, iform3amp
     kform4amp linseg    ipform4amp, it, iform4amp, p3 - it, iform4amp
     kform5amp linseg    ipform5amp, it, iform5amp, p3 - it, iform5amp

;FORMANTS
forms:

     aform1    grain     kform1amp * kamp, kform1, kpitch, 0, 0, .02, 1, 18, .02, 1
     aform2    grain     kform2amp * kamp, kform2, kpitch, 0, 0, .02, 1, 18, .02, 1
     aform3    grain     kform3amp * kamp, kform3, kpitch, 0, 0, .02, 1, 18, .02, 1
     aform4    grain     kform4amp * kamp, kform4, kpitch, 0, 0, .02, 1, 18, .02, 1
     aform5    grain     kform5amp * kamp, kform5, kpitch, 0, 0, .02, 1, 18, .02, 1


;SUMMATION OF FORMANTS AND OUTPUT

     avx       =         (aform1 + aform2 + aform3  + aform4 + aform5) / p10
               out       avx
               endin

</CsInstruments>
<CsScore>
f01  0    4096 10   1
f02  0    32   -2   600 1040 2250 2450 2750 400 1620 2400 2800 3100 250 1750 2600 3050 3340 400 750 2400 2600 2900 350 600 2400 2675 2950
f03  0    32   -2   0 -7 -9 -9 -20 0 -12 -9 -12 -18 0 -30 -16 -22 -28 0 -11 -21 -20 -40 0 -20 -32 -28 -36
f05  0    32   -2   650 1080 2650 2900 3250 400 1700 2600 3200 3580 290 1870 2800 3250 3540 400 800 2600 2800 3000 650 600 2700 2900 3300
f06  0    32   -2   0 -6 -7 -8 -22 0 -14 -12 -14 -20 0 -15 -18 -20 -30 0 -10 -12 -12 -26 0 -20 -17 -14 -16
f08  0    32   -2   660 1120 2750 3000 3350 440 1800 2700 3000 3300 270 1850 2900 3350 3590 430 820 2700 3000 3300 370 630 2750 3000 3400
f09  0    32   -2   0 -6 -23 -24 -38 0 -14 -18 -20 -20 0 -24 -24 -36 -36 0 -10 -26 -22 -34 0 -20 -23 -30 -34
f11  0    32   -2   800 1150 2800 3500 4950 400 1600 2700 3300 4950 350 1700 2700 3700 4950 450 800 2830 3500 4950 325 700 2530 3500 4950
f12  0    32   -2   0 -4 -20 -36 -60 0 -24 -30 -35 -60 0 -20 -30 -36 -60 0 -9 -16 -28 -55 0 -12 -30 -40 -64
f14  0    32   -2   800 1150 2900 3900 4950 350 2000 2800 3600 4950 270 2140 2950 3900 4950 450 800 2830 3800 4950 325 700 2700 3800 4850
f15  0    32   -2   0 -6 -32 -20 -50 0 -20 -15 -40 -56 0 -12 -26 -26 -44 -0 -11 -22 -22 -50 0 -16 -35 -40 -60
f18 0     4096 7  0 496 1 3600 0

t0   200

; Wake up the singers!
i1   0    1

; Voice codes: bass:2 tenor:5 countertenor:8 alto:11 soprano:14
; Vowel codes: a:0 e:1 i:2 o:3 u:4

; PART 1 COUNTERTENOR
;              note voice     vowel     stamp     endamp    chtime    norm    portime /l/
i2   0    4    7.07 8         0         0         .8        .3        3         .1        0
i2   +    4    7.07 .         .         .8        .         .         .         .         .
i2   +    4    7.04 .         2         .         .         .         .         .         .
i2   +    4    7.09 .         .         .         .         .         .         .         .
i2   +    4    7.07 .         3         .         .         .         .         .         .
i2   +    6    7.07 .         .         .         .         .         .         .         .
i2   +    2    7.05 .         4         .         .         .         .         .         .
i2   +    8    7.04 .         .         .         .         .         .         .         .
i2   +    4    7.05 .         3         .         .         .         .         .         .
i2   +    4    7.09 .         .         .         .         .         .         .         .
i2   +    8    7.07 .         4         .         .         .         .         .         .
i2   +    6    7.05 .         .         .         .         .         .         .         .
i2   +    1    7.07 .         1         .         .         .         .         .         .
i2   +    1    7.05 .         .         .         .         .         .         .         .
i2   +    8    7.04 .         0         .         .         .         .         .         .

;PART 2 TENOR
;              note voice     vowel     stamp     endamp    chtime    norm    portime /l/
i2   2    2    7.04 5         0         0         .8        .3        3         .1        0
i2   +    4    7.04 .         .         .8        .         .         .         .         .
i2   +    4    7.00 .         1         .         .         .         .         .         .
i2   +    4    7.05 .         .         .         .         .         .         .         .
i2   +    4    7.04 .         3         .         .         .         .         .         .
i2   +    2    7.02 .         .         .         .         .         .         .         .
i2   +    2    6.11 .         2         .         .         .         .         .         .
i2   +    2    7.00 .         .         .         .         .         .         .         .
i2   +    2    7.02 .         .         .         .         .         .         .         .
i2   +    8    7.00 .         4         .         .         .         .         .         .
i2   +    4    7.02 .         .         .         .         .         .         .         .
i2   +    4    7.05 .         2         .         .         .         .         .         .
i2   +    4    7.05 .         .         .         .         .         .         .         .
i2   +    4    7.04 .         3         .         .         .         .         .         .
i2   +    6    7.02 .         .         .         .         .         .         .         .
i2   +    2    7.02 .         2         .         .         .         .         .         .
i2   +    8    7.00 .         0         .         .         .         .         .         .

;PART 3 BASS
;              note voice     vowel     stamp     endamp    chtime    norm    portime /l/
i2   6    2    6.07 2         0         .0        .8        .3        3         .1        0
i2   +    2    7.00 .         .         .8        .         .         .         .         .
i2   +    2    6.10 .         2         .         .         .         .         .         .
i2   +    2    6.09 .         .         .         .         .         .         .         .
i2   +    2    6.11 .         .         .         .         .         .         .         .
i2   +    2    7.00 .         3         .         .         .         .         .         .
i2   +    1    7.02 .         .         .         .         .         .         .         .
i2   +    1    7.00 .         .         .         .         .         .         .         .
i2   +    2    6.11 .         4         .         .         .         .         .         .
i2   +    2    6.07 .         .         .         .         .         .         .         .
i2   +    2    6.09 .         .         .         .         .         .         .         .
i2   +    2    6.11 .         3         .         .         .         .         .         .
i2   +    2    7.00 .         .         .         .         .         .         .         .
i2   +    2    6.07 .         .         .         .         .         .         .         .
i2   +    2    7.00 .         1         .         .         .         .         .         .
i2   +    2    6.10 .         .         .         .         .         .         .         .
i2   +    6    6.09 .         0         .         .         .         .         .         .
i2   +    1    7.02 .         .         .         .         .         .         .         .
i2   +    1    7.00 .         .         .         .         .         .         .         .
i2   +    2    6.11 .         3         .         .         .         .         .         .
i2   +    2    6.07 .         4         .         .         .         .         .         .
i2   +    8    7.00 .         .         .         .         .         .         .         .
i2   +    4    6.11 .         .         .         .         .         .         .         .
i2   +    8    7.00 .         0         .         .         .         .         .         .
e

</CsScore>
</CsoundSynthesizer>
