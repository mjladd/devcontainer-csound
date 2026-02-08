<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from noise6.orc and noise6.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2

;Casti, John L. "Complexification: Explaining a Paradoxical
;World Through The Science Of Surprise",
;New York, HarperCollins, 1994.
;from "White, Brown and Pink Music" pp. 245-249 "A fractal process, on the other ;hand, has no characteristic frequency or scale, and its frequencies form what's ;called an inverse power spectrum."

;Here is an instrument utilizing tables that offer a variety of percussive 1/f ;accompaniment to Casti's "White Music." Casti's notated score is on page 247 of ;'Complexification.'

;ORKIE

          instr 1

i1        =         p4/2

k1        phasor    .9
k2        phasor    1.33
i2        table     p5,3
kp1       table     k1*6,4
kp2       table     k2*6,5
ip3       table     p6,6
ip4       table     p7,7
ip5       table     p8,8
ksweep    line      ip4,p3,ip5
kvib      oscil     2.75,cpspch(p4),1
kamp      linen     ampdb(i2),p3*.1,p3,p3*.9
asing1    oscil     kamp/4,cpspch(p4),2
asing2    oscil     kamp/4,cpspch(p4)+kvib,1
abari     oscil     kamp/4,cpspch(kp1)+kvib,1
abass     oscil     kamp/4,cpspch(kp2),2
a1        =         asing1+abari+asing2+abass
asig      rand      10000
afilt     reson     asig,ksweep,ip3
arampsig =          .05*afilt
afin      balance   arampsig,a1
          outs      a1+afin,a1+afin
          endin


</CsInstruments>
<CsScore>
;sco
f1 0 1024 10 10 6 2 5 2 4 2 3 2 3 2 3 1 2 1 f2 0 1024 9 1 5 45 2 4 302 3 1 73 4 4 223 5 1 34 6 3 157 f3 0 32 -2 90 88 86 84 82 80 78
f4 0 32 -2 7.00 7.09 7.05 7.02 7.00 7.07 f5 0 32 -2 6.04 6.05 6.02 6.07 6.05 6.04 f6 0 32 -2 2000 500 20 0.05
f7 0 32 -2 4000 3000 2000 1000
f8 0 32 -2 140 130 120 100

t 0 185
;"White Music" (c) 1994 by John L. Casti, The Santa Fe Institute. ;in on off pch v b s n
i1 0 2 8.04 6 3 2 1
i1 2 1 9.05 6 3 2 1
i1 3 .5 8.05 6 0 3 0
i1 3.5 4 8.05 6 3 2 1
i1 7.5 1 9.02 6 3 2 1
i1 8.5 1 9.04 6 3 2 1
i1 9.5 .5 8.11 5 0 1 2
i1 10     2 9.00 4 3 2 1
i1 12     2 9.02 6 3 2 1
i1 14     1 9.07 5 3 2 1
i1 15 .5 8.05 6 0 2 2
i1 16 .5 9.00 5 0 2 3
i1 16.5 1 9.00 4 3 2 1
i1 17.5 1 9.00 3 3 2 1
i1 18.5 .5 8.07 6 0 3 2
i1 19     4 8.05 3 3 2 1
i1 23 .5 8.04 6 1 0 0
i1 23.5 2 9.05 3 3 2 1
i1 25.5 .5 8.05 3 1 0 2
i1 24     4 8.07 3 3 2 1
i1 28     2 8.09 2 3 2 1
i1 30 .5 8.05 2 1 1 1
i1 30.5 2 9.02 2 3 2 1
i1 32.5 1 8.07 4 3 2 1
i1 33.5 .5 9.00 5 1 2 3
i1 34     1 9.05 3 3 2 1
i1 35     1 8.07 3 2 3 2
i1 36     1 9.07 3 0 1 3
i1 37     1 8.02 3 3 2 1
i1 38 .5 8.02 5 3 3 1
i1 38.5 1 8.09 3 3 0 0
i1 39.5 2 8.09 3 2 3 3
i1 41.5 4 9.00 2 3 2 1
i1 45.5 4 8.09 2 3 3 2
i1 49.5 1 9.07 3 3 1 1
i1 50.5 1 9.00 3 3 3 2
i1 51.5 2 9.00 2 3 2 3
i1 53.5 .5 9.02 6 2 3 3
i1 54 .5 9.04 6 0 3 3
e




</CsScore>
</CsoundSynthesizer>
