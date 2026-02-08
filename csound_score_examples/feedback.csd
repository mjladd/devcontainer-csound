<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from feedback.orc and feedback.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2

; FEEDBACK FILTER ORCHESTRA BY HANS MIKELSON


; FEEDBACK FILTER 1
          instr 1

idur      =         p3
iamp      =         p4
ifqc      =         cpspch(p5)
itab      =         p6
itabc     =         p7
ifeedbk   =         p8

kdclick   linseg    0, .002, 1, idur-.004, 1, .002, 0
kfco      linseg    500, .1*idur, 5000, .4*idur, 1000, .4*idur, 500, .1*idur, 500

asig      oscil     kdclick, ifqc, itab
afilt     tone      asig, kfco

afdbk     =         afilt/10                 ; REDUCE ORIGINAL SIGNAL
adeli     delayr    .2                       ; FEED BACK DELAY
adel1     deltapi   1/kfco
afilt2    butterbp  adel1, kfco, kfco/4      ; FILTER THE DELAYED SIGNAL
kamprms   rms       afilt2                   ; FIND RMS LEVEL
kampn     =         kamprms/6                ; NORMALIZE RMS LEVEL 0-1.
kcomp     tablei    kampn,itabc,1,0          ; LOOK UP COMPRESSION VALUE IN TABLE
          delayw    afdbk+kcomp*ifeedbk*afilt2 ; ADD LIMITED FEEDBACK
aout      =         adel1*10*kdclick*iamp

          outs      aout, aout

          endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1
f2 0 1024 7 1 512 1 0 -1 512 -1
f3 0 1024 7 1 1024 -1

; Compression Curve
f6 0 1025 7 1 128 .2 128 .15 256 .04 256 .02 257 .001

; Sta Dur Amp Pitch Waveform Compr Feedbk

i1 0 .15 5000 7.00 2     6    1.2
i1 + .15 5000 7.05 .     6    0.8
i1 . .15 5000 6.07 .     6    1.1
i1 . .15 5000 7.10 .     6    1.0
i1 . .15 5000 8.05 .     6    0.9
i1 . .15 5000 7.07 .     6    1.0
i1 . .15 5000 7.10 .     6    1.1
i1 . .15 5000 7.10 .     6    1.0
i1 . 1.2 5000 7.00 .     6    1.2

</CsScore>
</CsoundSynthesizer>
