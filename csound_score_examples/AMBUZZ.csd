<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from AMBUZZ.ORC and AMBUZZ.SCO
; Original files preserved in same directory

sr        =         44100
sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


;=======================================================================;
; AMBUZZ          Amplitude Modulation Buzz Instrument                  ;
;                 Designed by Garth Molyneux                            ;
;                 University of Texas at Austin Computer Music Studio   ;
;=======================================================================;
; p6     =        rate of modulation                                    ;
; p7     =        modulation depth %                                    ;
; p8     =        function for mod rate                                 ;
; p9     =        function for mod depth                                ;
; p10    =        amount of portamento in oct.decimal                   ;
; p11    =        function for portamento                               ;
;=======================================================================;
          instr        1

icps      =         cpspch(p5)               ; PORTAMENTO DESIGN
ioct      =         octpch(p5)
kchange   oscil1i   0,p10,p3,p11
kline     =         cpsoct(ioct+kchange)
ibend     =         cpsoct(ioct+p10)
ilow      =         (ibend<icps ? ibend:icps)
iampfac   =         p4*p7                    ; TREMOLO DESIGN
ktsamp    oscil1    0,iampfac,p3,p9
kstfrq    oscil1    0,p6,p3,p8
ktrem     oscil     ktsamp,kstfrq,1
kamp      =         p4+ktrem
knh       =         int((sr*.42)/kline)      ; MAIN INSTRUMENT DESIGN
asrce     buzz      kamp,kline,knh,6
kbwchg    oscil1i   0,(kline*knh),p3,p11
kbw       =         kbwchg+(kline*.001)
aflt1     reson     asrce,kline,kbw,1
aflt      reson     aflt1,kline,kbw,1
abal      balance   aflt,asrce
aplk      pluck     kamp,kline,ilow,0,2,1.00001
asnd      =         (abal*.8)+(aplk*.41)
asig      envlpx    asnd,.0001,p3,(p3*.98),2,1,.01
          out       asig
          endin


</CsInstruments>
<CsScore>
;=======================================================================;
; AMBUZZ          Score for Amplitude Modulation Buzz by Molyneux       ;
;=======================================================================;
; p6     =        rate of modulation                                    ;
; p7     =        modulation depth %                                    ;
; p8     =        function for mod rate                                 ;
; p9     =        function for mod depth                                ;
; p10    =        amount of portamento in oct.decimal                   ;
; p11    =        function for portamento                               ;
;=======================================================================;
; sine
f1  0 512   10  1
; linear rise
f2  0 513   7   0    513   1
; linear fall
f3  0 513   7   1    513   0
; exponential rise
f4  0 513   5   .001 513   1
; exponential fall
f5  0 513   5   1    512  .00001  1  .00001
; sine function for buzz unit
f6  0 8192  10  1
; function for modulator rate
f7  0 513   5   .001  62  .9  150 .65 200 .97 51 .78 50  1
; function for modulator depth
f8  0 513   5   .5   163  .39 200 .97 150 .61
; function for portamento
f9  0 513   7   0    105  .4   31 .25 105 .65 31 .50 105 .90 31 .75 105 1
;=======================================================================;
; AMBUZZ     p4      p5     p6     p7     p8   p9   p10      p11        ;
;            amp     pch    mrate  mdpth  mrfn mdfn portdev  portfn     ;
;=======================================================================;
i1  0   2.0  20000   9.08   110    0.40   4    4    -0.09    4
i1  3   0.8  20000  11.10   624    0.40   5    5     0.00    3
i1  5   0.8   6900   8.09   624    0.40   5    5    -0.25    2
i1  7   0.7   8600   9.02   836    0.40   5    5    -0.08    2
i1  9   1.0  11000   9.03  1642    0.40   5    5     0.34    2
e

</CsScore>
</CsoundSynthesizer>
