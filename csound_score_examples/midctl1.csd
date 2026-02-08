<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from midctl1.orc and midctl1.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2

;MIDI CONTROLLERS - EXAMPLE.ORC


          instr 1

kval1     midictrl  1

kcps      cpsmidib
icps      cpsmidi
iamp      ampmidi   5000, 2
kbend     pchbend   100
kamp      expon     iamp, 5, iamp/icps       ; FREQ-DEPENDENT OVERALL DECAY
amp       linenr    kamp, .01, .333, .05
a1        oscil     amp, kcps+kval1, 1

          outs      a1*(kval1/127), a1*(1-(kval1/127))

          endin


</CsInstruments>
<CsScore>
;MIDI Controllers  -  example.sco

f1 0 1024 10 1
f2 0 128 5 1 128 8

;for veloc to non-linear amp

f0 15

e

</CsScore>
</CsoundSynthesizer>
