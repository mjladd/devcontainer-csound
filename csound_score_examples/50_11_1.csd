<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 50_11_1.orc and 50_11_1.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 2

; ************************************************************************
; ACCCI:     50_11_1.ORC
; timbre:    bands of noise
; synthesis: subtractive synthesis(50)
;            continuous control cf and bw(11)
;            glissandoing noise bands(1)
; source:    Dodge (1985)
; coded:     jpg 11/93




instr 1; *****************************************************************
idur     = p3
iamp     = p4
imincfq  = cpspch(p5)
imaxcfq  = cpspch(p6)
iratio   = imaxcfq/imincfq
iminbw   = p7
irangebw = p8

   kcfq    expon  1, idur, iratio          ; control center frequency
   kcfq    =      kcfq*imincfq

   kbw     oscili irangebw, 1/idur, 31     ; control bw
   kbw     =      (kbw+iminbw)*kcfq

   anoise  rand   iamp                     ; white noise
   a1      reson  anoise,  kcfq, kbw, 2    ; filter
   a1      linen  a1, .1, idur, .1
           outs    a1, a1

endin

</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     50_11_1.SCO
; coded:     jpg 11/93

; GEN functions **********************************************************
; envelopes
f31  0   512   7   0    512  1


; score ******************************************************************

;                       center freq....  bandwidth......
;    start idur  iamp   iminpch imaxpch  iminbw irangebw
i1    0     4    8000   7.00    8.06      .05      .45
i1    4     4    8000   7.07   10.00      .05      .45
i1    8     6   10000  12.00    5.00      .05      .3

e



</CsScore>
</CsoundSynthesizer>
