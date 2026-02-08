<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from myfile.orc and myfile.sco
; Original files preserved in same directory

sr        =         44100                         ; Sample Rate
kr        =         22050                         ; Control Rate
ksmps     =         2                             ; sr/kr As far as I know this is always the case
nchnls    =         2                             ; 1=mono, 2=stereo, 4=quad




          instr 1                                 ; Instrument 1 begins here
aout      oscil     10000, 440, 1                 ; An oscillator
          outs      aout, aout                    ; Output the results to a stereo sound file
          endin                                   ; Instrument 1 ends here


          instr  2                                ; Instrument 2 begins here
iamp      =         p4                            ; Amplitude
ifqc      =         p5                            ; Frequency
itabl1    =         p6                            ; Waveform Table
aout      oscil     iamp, ifqc, itabl1            ; An oscillator
          outs      aout, aout                    ; Output the results to a stereo sound file
          endin                                   ; Instrument 2 ends here


          instr     3                             ; Instrument 1 begins here
idur      =         p3                            ; Duration
iamp      =         p4                            ; Amplitude
ifqc      =         cpspch(p5)                    ; Frequency
itabl1    =         p6                            ; Waveform

; ATTACK DECAY SUSTAIN RELEASE ENVELOPE

kamp      linseg    0, .1, 1, .2, .8, p3-.5, .8, .2, 0
aout      oscil     iamp, ifqc, itabl1            ; An oscillator
          outs      aout*kamp, aout*kamp          ; Output the results to a stereo sound file
          endin                                   ; Instrument 3 ends here

</CsInstruments>
<CsScore>
; SCORE

;Table# Start TableSize TableGenerator Parameter  Comment
;-----------------------------------------------------------
f1      0     16384     10             1          ; Sine

;Instrument# Start Duration
;-----------------------------------------------------------
i1           0     1

;Instrument#(p1) Start(p2) Duration(p3) Amplitude(p4) Frequency(p5) Table(p6)
;------------------------------------------------------------------------------
i2               1         1            10000         440           1

; Instr  Sta  Dur  Amp  Freq  Table
;-----------------------------------------------------------
i2       2    1    2000 330   1
i2       3    1    4000 440   1
i2       4    1    6000 600   1
i2       5    1    8000 660   1

; Instr Sta Dur  Amp  Freq  Table
;-----------------------------------------------------------
i3      6   1    8000 8.00  1
i3      +   .    7000 8.02  .
i3      .   .    6000 8.04  .
i3      .   .    8000 8.05  .

</CsScore>
</CsoundSynthesizer>
