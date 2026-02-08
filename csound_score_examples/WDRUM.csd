<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from WDRUM.ORC and WDRUM.SCO
; Original files preserved in same directory

     sr        =         44100
     kr        =         4410
     ksmps     =         10
     nchnls    =         1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;         FM WOOD DRUM ORCHESTRA FILE                   ;
;                                                       ;
;         P3 = DURATION        P4 = AMPLITUDE           ;
;         P5 = PITCH IN PCH                             ;
;                                                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

               instr     1
     idur      =         .18
          if   p3 < .18  igoto reset
               igoto     index
reset:    idur =         p3
index:    kndx envlpx    1,.001,.002,.001,2,1,.001
     kamp      envlpx    p4,.001,idur,(idur*.92),2,1,.001
     asig      foscili   kamp,cpspch(p5),1,4.5,kndx,1
               out       asig
               endin

</CsInstruments>
<CsScore>
;        FM WOOD DRUM SCORE FILE
;
;       SINE WAVE
f1 0.0 512 10 1
;       LINEAR RISE
f2 0.0 513 7  0 513 1
;       LINEAR FALL
f3 0.0 513 7  1 513 0
;       EXPONENTIAL RISE
f4 0.0 513 5 .001 513 1
;       EXPONENTIAL RISE
f5 0.0 513 5 1 513 .001
;
;       INSTRUMENT CARDS
i1 0.00 0.12 10000 8.11
i1 0.50 0.12 10000 8.10
i1 1.50 0.12 10000 9.05
e

</CsScore>
</CsoundSynthesizer>
