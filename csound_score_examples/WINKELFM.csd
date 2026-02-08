<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from WINKELFM.ORC and WINKELFM.SCO
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2


instr     1
k1        linseg    p4*.1,p3*.2,p4,p3*.8,p4*.2
k2        linseg    4,.2,2,p3-.2,1.9
gk3       oscil     1,p6/p3,2
k4        linseg    p5,p3*.1,p5*1.1,p3*.9,p5*.95
ga1       foscili   k1,k4,3,1.007,k2,1
          ;outs1    ga1*gk3
          ;outs2    ga1*(1-gk3)                   ;TRYING TO GET DELAY ON BOTH SIDES
          ;outs2    ga1*(1-gk3)
endin


instr     3
k1        linseg    p4*.1,p3*.2,p4,p3*.8,p4*.2
;k1       linen     p4,.2,p3,.2
k2        linseg    4,.2,2,p3-.2,1.9
gk3       oscil     1,p6/p3,2
k4        linseg    p5,p3*.1,p5*.95,p3*.9,p5*1.1
ga2       foscili   k1,k4,3,1.007,k2,1
          ;outs1    ga2*gk3
          ;outs2    ga2*(1-gk3)                   ;TRYING TO GET DELAY ON BOTH SIDES
          ;outs2    ga1*(1-gk3)
endin

instr     2
a1        reverb    ga1+ga2,.5
          outs1     a1*(1-gk3)
          outs2     a1*gk3
endin


</CsInstruments>
<CsScore>
f1 0 512 9 1 1 0 1.1 .2 0     ;USE 1.1 .1 0 IF THIS STINKS
f2 0 512 7 0 256 1 256 0

i2 0  45.2                    ;REVERB GUY

i1 0    15   300 40    1
i3 0    15   300 40.25 1
i1 .2   15   250 41    1
i3 .2   15   300 39.25 1
i1 11   15   300 45    1
i1 11.2 15   250 46    1
i3 11   15   300 45.25 1
i3 11.2 15   300 44.25 1
i1 21   15   300 87    1
i1 21.2 15   250 87.5  1
i3 21   15   300 86    1
i3 21.2 15   250 85    1
i1 30   15   300 102   1
i1 30.2 15   300 103   1
i3 30   15   300 102   1
i3 30.2 15   300 101   1
s

i1 0  .2  300  50  1          ;P6 = PAN FUNCTION IN ORC /P3
i1 0.2 .  .     > 3
i1 0.4 .  .     > 5
i1 0.6 .  .     > 7
i1 0.8 .  .     > 9
i1 1  .2  300  > 1
i1 1.2 .  .     > 3
i1 1.4 .  .     > 5
i1 1.6 .  .     > 7
i1 1.8 .  .     > 9
i1 2  .2  3000  > 1
i1 2.2 .  .     > 3
i1 2.4 .  .     > 5
i1 2.6 .  .     > 7
i1 2.8 .  .     500 9
i2 0   3.5
s


i1 0    .3 3000 600 1
i1  .7 4.3  .   500 1
i1 5.5  .2  .   400 .1
i1 6    .5  .   300 .1
i1 7   1    .   200  2
i1 8   2    .   100 15
i1 10  .2  3000  50  1
i1 10.2 .  .    100  3
i1 10.4 .  .    200  5
i1 10.6 .  .    300  7
i1 10.8 .  .    400  9
i1 11   10 .    500 11

i2 0  22
s

</CsScore>
</CsoundSynthesizer>
