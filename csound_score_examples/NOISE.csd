<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from NOISE.ORC and NOISE.SCO
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2


; PLUCKED MULTI-FOF WITH STEREO NOISE ORC




          instr 1
i1        table     p4,3
i2        table     p5,4
i3        table     p7,6
i4        table     p8,6
i5        table     p10,6
i6        table     p11,6
k2        linseg    i1,p3,0
k3        table     p5,4
kbw1      table     p6,5
kbw2      table     p9,5
kcf1      line      i3,p3,i4
kcf2      line      i5,p3,i6
aa        fof       k2,k3*1.00,250,0,40,.003,.02,.007,4,1,2,p3
ab        fof       k2,k3*1.01,250,0,40,.003,.02,.007,4,1,2,p3
ac        fof       k2,k3*1.02,250,0,40,.003,.02,.007,4,1,2,p3
ad        fof       k2,k3*0.99,250,0,40,.003,.02,.007,4,1,2,p3
ae        fof       k2,k3*0.98,250,0,40,.003,.02,.007,4,1,2,p3
af        fof       k2,k3*0.97,250,0,40,.003,.02,.007,4,1,2,p3
ag        fof       k2,k3*0.96,250,0,40,.003,.02,.007,4,1,2,p3
al        =         aa+ab+ac+ad+ae+af+ag
ap1       pluck     k2,i2,i2,0,1
ap2       pluck     k2,i2*1.005,i2*1.005,0,1
as        rand      10000
at1       reson     as,kcf1,kbw1
at2       reson     as,kcf2,kbw2
azl       balance   at1,ap1+al
azr       balance   at2,ap2+al
          outs      ap1+al+azr,ap2+al+azl
          endin

</CsInstruments>
<CsScore>
; SCO
f1 0 4096 10 10 6 4 5 4 4 3 2 1
f2 0 256 7 0 128 1 0 -1 128 0
f3 0 32 -2 3000 2750 2500 2250 2000
f4 0 32 -2 150 149 148 147 146 145 144 190 120
f5 0 16 -2 5000 2000 500 20 .05
f6 0 16 -2 10000 5000 2500 1250 625 312 156 78


t 0 60
;1 2 3 4 5 6 7 8 9 10 11
;n b d a p wl d1 d2 wr u1 u2
i1 0 1 3 7 0 3 2 3 1 2
i1 1 2 4 0 1 1 0 2 2 0

</CsScore>
</CsoundSynthesizer>
