<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Fm1.orc and Fm1.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1

; =================== Simple FM Instrument ======================== ;
; ================ with swept modulation index ==================== ;



          instr     1
iamp      =         ampdb(p4)                          ; p4 = AMPLITUDE IN dB
kamp      linseg    0,p3*.1,iamp,p3*.8,iamp,p3*.1,0    ; p5 = OSCILLATOR FREQ IN Hz
kind      linseg    p8,p3*.7,p9,p3*.3,p8               ; p6 = CARRIER FREQ RATIO
a1        foscili   kamp,p5,p6,p7,kind,1               ; p7 = MOD FREQ RATIO
          out       a1                                 ; p8 = START MOD SWEEP
          endin                                        ; p9 = PEAK MOD SWEEP

</CsInstruments>
<CsScore>
; =========== Testing Modulation Index and C:M Ratios =========== ;
; =================  Example Csound Note List  ================== ;

f1      0     2048      10     1

; =============================================================== ;
;    Start    Dur      Amp    Pitch Carrier  Mod    Start   Peak
;    in Sec   in Sec   in Db  in Hz Ratio    Ratio  Index   Index
; =============================================================== ;

i1      0      30      86     55      1       1      0        20
i1     30      30      86     55      1       1      0        40
i1     60      30      86     55      1       1      0        80
i1     90      30      86     55      1       1      0       160
i1    120      30      86     55      1       1      0       320
s
i1      0      30      86     55      1       1      0       640
i1     30      30      86     55      1       1      0      1280
i1     60      30      86     55      1       1      0      2560
i1     90      30      86     55      1       1      0      5120
i1    120      30      86     55      1       1      0     10240
e

</CsScore>
</CsoundSynthesizer>
