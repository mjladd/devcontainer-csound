<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from fmfeed1b.orc and fmfeed1b.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1

;====================================================================;
;                      Dx7 FMPair with Feedback on Op2               ;
;====================================================================;


          instr 1

idur      =         p3
iamp      =         p4
icarfreq  =         p5
imodfreq  =         p6
ifeed     =         p7/(2 * 3.14159)         ; DEV IN RADIANS

k1gatec   linseg    0, p3*.1, 1,p3*.9, 0
k2gatem   linseg    0, p3*.1, 1, p3*.7,1, p3*.2, 0

a2sig     init      0                        ; INITIALIZE FOR FEEDBACK
a2phs     phasor    imodfreq                 ; OPS TO BE MODULATED MUST USE PHASE...
a2sig     tablei    a2phs+a2sig*ifeed,1,1,0,1 ; ...MODULATION, NOT FM!
a2sig     =         a2sig*k2gatem

a1phs     phasor    icarfreq
a1sig     tablei    a1phs+a2sig,1,1,0,1
a1sig     =         a1sig*k1gatec

          out       a1sig * iamp
          endin

</CsInstruments>
<CsScore>
;====================================================================;
;       Dx7Feed.sco SimpleFM Pair with Feedback                      ;
;====================================================================;
f01     0       4096     10      1

i1 0           5    15000     440       440       7
s
i1 0           5    15000     440       440       5
s
i1 0           5    15000     440       440       3
s
i1 0           5    15000     440       440       1
s
i1 0           5    15000     440       440       0
s
i1 0           5    15000     440       440       .7
s
i1 0           5    15000     440       440       .5
s
i1 0           5    15000     440       440       .3
s
i1 0           5    15000     440       440       .1
s
i1 0           5    15000     440       440       .05
e


</CsScore>
</CsoundSynthesizer>
