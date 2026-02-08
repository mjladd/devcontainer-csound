<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from king6.orc and king6.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2

;-------------- "PINK AND BLUE" ----------------------


          instr 1

;VOLTAGE CONTROL AMPLIFIER
irub      =         p4
kline     linseg    1,0.03,1500, p3,800,p3/2,0
kramp     line      1, p3, 1011

;FREQUENCY MODULATOR
i1        =         p5
islide    =         p7
i2        =         p6
k1        phasor    i1
k3        phasor    i2
kpch      table     k1 * 4, 1
kpch2     table     k1 * 4, 3
kpch3     table     k1 * 4, 5
kpch4     table     k3 * 4, 7
kpch5     table     k3 * 4,10
kbw       table     k1 * 4, 9

;VOLTAGE CONTROL OSCILATOR
a1        oscil     kline*islide, cpspch(kpch*irub), 2
a2        oscil     kline, cpspch(kpch2*irub), 4
a3        oscil     kline,cpspch(kpch*irub),2
a3a       buzz      kramp, cpspch(kpch3), 3, 6
k2        =         cpspch(kpch4)
krand     randh     1,10
a4        oscil     kline, cpsoct(krand+k2), 8
a5        pluck     kline+1500, cpspch(kpch4),1760 , 0, 1
a6        pluck     kline+1500, cpspch(kpch5),1760 , 0, 1

;VOLTAGE CONTROL FILTER
a3b       balance   a3a, a1
a4b       balance   a4, a1
a1l       =         a6 + a3b + a2
a1r       =         a5 + a4b + a3
aleft     balance   a1l, a1
asig1     tone      aleft, 440
aright    balance   a1r, a1
asighi    atone     aright, 440
asig2     reson     asighi, 1760, 2000
          outs      asig1,asig2
          endin

</CsInstruments>
<CsScore>
f1 0 64 2 8.04  5.07 9.09 7.10
f2 0 8192 10  0 10 0
f3 0 64 2 4.10 10.09 7.10 9.09
f4 0 8192 10  10  0  10
f5 0 64  2  8.09  9.01 4.05  10.03
f6 0 2049  10    7    3   0
f7 0 64 2  8.04  5.02 9.04  10.07
f8 0 2049 10  0  2.5  5  10 0
f9 0 64 2 400 40  4  0.4  0.04
f10 0 64 2 10.05  11.01 10.05  10.03

t 0 180 4 150 6 90 8 60

;p1 p2 p3  p4		p5	p6        p7
;I ON DUR  RUB      PHASE 1  PHASE 2  AMP SLIDE
i1 0 8   4.58697   	4	4         1
i1 4 6   1.237475	2	1         >
i1 6 5   3.5982		1	3         >
i1 7 4   1.4		3	2         3
i1 8 3   2.5868		2	5         1

</CsScore>
</CsoundSynthesizer>
