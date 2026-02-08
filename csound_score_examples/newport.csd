<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from newport.orc and newport.sco
; Original files preserved in same directory

sr     =       44100  ; Sample rate
kr     =       4410   ; Kontrol rate
ksmps  =       10     ; Samples per kontrol period
nchnls =       2      ; Number of channels

; ORCHESTRA
       zakinit 50, 50 ; Initialize the zak system

; Sends out a ratio signal on the appropriate channel
       instr  1

kratio =      p4    ; Ratio
ioutch =      p5    ; Output channel

       zkw    kratio, ioutch  ; Write k-rate zak array

       endin

; Instrument 2 reads it's pitch from instrument 1 zak channel
       instr 2

iamp   =      p4  ; Amplitude
ifqc   =      p5  ; Base frequency
irt    =      p6  ; Initial ratio
iinch  =      p7  ; Input zak channel

krt1   zkr    iinch         ; Read the zak channel
krt    port   krt1, .2, irt ; Portamento glide for .2 seconds

aoutl  poscil iamp, ifqc*krt*1.002, 1 ; Run the oscillator
aoutr  poscil iamp, ifqc*krt*0.998, 1 ; How about some stereo?

       outs  aoutl, aoutr

       endin

</CsInstruments>
<CsScore>


; SCORE
f1      0       8192    9       1 1 0 2.5 .5 0 3.5 .333 0 4.5 .25 0 5.5 .20

;inst   start   dur   ratio  OutCh
i1      0       8     1.125  1
i1      0       8     1.875  2
i1      0       8     1.5    3
;
i1      8       8     1.2    1
i1      8       8     1.7778 2
i1      8       8     1.5    3
;
i1     16       8     1.125  1
i1     16       8     1.875  2
i1     16       8     1.5    3

; Just turn on instr 2 and leave it on
; use instr 1 to change the ratios.
;inst   start   dur   amp     freq  InitRatio  InCh
i2      0       24    10000   220   1.125      1
i2      0       24    10000   110   1.875      2
i2      0       24    10000   110   1.5        3

e

</CsScore>
</CsoundSynthesizer>
