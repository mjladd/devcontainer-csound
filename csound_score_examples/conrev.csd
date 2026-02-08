<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from conrev.orc and conrev.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2

; convrev.orc


          instr 1             ; EXPONENTIALLY ENVELOPED WHITE NOISE INSTRUMENT
idur      =         p3
iexpstrt  =         p4                       ; RANGE = .0000001 TO 1 (0 IS ILLEGAL)
iexpend   =         p5                       ; RANGE = .0000001 TO 1 (0 IS ILLEGAL)
iwhite    =         32000                    ; SET TO THE MAXIMUM AMPLITUDE FOR A 16 BIT LINEAR DAC
iseedl    =         .1                       ; SEED THE RANDOM NUMBER GENERATORS
iseedr    =         .3

kamp      expon     iexpstrt, idur, iexpend
asigl     rand      iwhite, iseedl
asigr     rand      iwhite, iseedr
          outs      kamp * asigl, kamp * asigr
          endin

          instr 2             ; EXPONENTIALLY ENVELOPED SOUNDIN INSTRUMENT
idur      =         p3
iexpstrt  =         p4                       ; RANGE = .0000001 TO 1
iexpend   =         p5                       ; RANGE = .0000001 TO 1
input     =         p6                       ; soundin.x -   x = NUMBERS FROM 1 TO 10
                                             ; RENAME YOUR INPUT FILES ACCORDINGLY
kamp      expon     iexpstrt, idur, iexpend
al, ar    soundin   input, 0, 4
          outs      kamp * al, kamp * ar
          endin

</CsInstruments>
<CsScore>
;   idur = p3
;   iexpstrt = p4             ; range = .0000001 to 1
;   iexpend = p5              ; range = .0000001 to 1
;   input = p6               ; soundin.x -   x = numbers from 1 to 10

i1   0    2.6    1      .001
s
f0 2                               ; 2 seconds of silence
s
i1   0    2.6    .001    1
s
f0 2                               ; 2 seconds of silence
s
i2   0    2.6     1     .0001  6    ; read in the file named - soundin.6
s
f0 2                               ; 2 seconds of silence
s
i2   0    2.6     1     .0001  5    ; read in the file named - soundin.5
e

</CsScore>
</CsoundSynthesizer>
