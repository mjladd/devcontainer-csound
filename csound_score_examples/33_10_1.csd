<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 33_10_1.orc and 33_10_1.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:      33_10_1.ORC
; synthesis:  Amplitude Modulation(33)
;             ring modulation, exterior soundfile (10)
;             speech1.aiff(1)
; coded:      jpg 2/94


instr 1; *****************************************************************
idur    =  p3
iamp    =  p4
ifqm    =  p5
ifm     =  p6
istsec  =  p7

   a1    soundin  "Sflib/speech1.aiff", istsec   ; carrier is speech file
   a2    line     .25, idur, .25                 ; control signal
   a1    balance  a1, a2                         ; normalize a1

   amod  oscili   iamp, ifqm, ifm                ; modulator
   aenv  linen    1, .1, idur, 1                 ; envelope
         out      a1*amod*aenv                   ; ring modulation
endin


</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     33_10_1.SCO
; coded:     jpg 2/94


; GEN functions **********************************************************
; for modulator
f1 0 512 10 1                   ; one sinus
f2 0 512 10 5 4 3 2 1           ; five harmonics


; score ******************************************************************

;    idur iamp  ifqm  ifm istsec
i1  0  5  8000   200   1    0      ; audio range: split frequencies
i1  +  2  .      100   .    3      ;  "
i1  .  2  .      50    .    2      ;  "
i1  .  2  .      10    .    1      ; sub audio: vibrato effect
i1  .  2  .      5     .    0      ;               "

s
; section 2: five harmonics modulator

i1  2  2  8000   200   2    3      ; more inharmonics; noise
i1  +  .  .      100   .    3
i1  .  3  .      50    .    2
i1  .  4  .      10    .    1      ; vibrato effect
i1  .  5  .      5     .    0
e
</CsScore>
</CsoundSynthesizer>
