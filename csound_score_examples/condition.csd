<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from condition.orc and condition.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2


          instr 1

          if        p4 == 0 then kgoto dark

light:
anoise    rand      10000
a1        reson     anoise, 1760, 4
a2        reson     anoise, 880, 40

          goto      contin

dark:
anoise    rand      10000
a2        reson     anoise, 55, 0.04

goto contin

contin:
krimp     line      30000,p3,0
aamp      oscil     krimp, 440, 1
aleft     balance   a1, aamp
aright    balance   a2, aamp
          outs      aleft,aright
          endin

</CsInstruments>
<CsScore>
f1 0 8192 10 10 5 9 5 8 4 7 3 7 2 6 3 3 1 1

t 0 60

i1 0 2 1
i1 2 2 0
i1 4 2 1
i1 6 2 0

</CsScore>
</CsoundSynthesizer>
