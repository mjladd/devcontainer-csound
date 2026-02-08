<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 50_09_1.orc and 50_09_1.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 2

; ************************************************************************
; ACCCI:     50_09_1.ORC
; timbre:    noise
; synthesis: subtractive synthesis(50)
;            continuous control of bw(09)
;            variable cfq(1)
; source:    Dodge (1985)
; coded:     jpg 11/93




instr 1; *****************************************************************
idur     = p3
iamp     = p4
icfq     = p5
ipeakbw  = p6
iratebw  = p7*(1/idur)

   kbw     oscil    1, iratebw, 1, 0.75      ; sinus at 270 degrees
   kbw     =        (kbw + 1)/2              ; shift envelope to pos. dom.
   kbw     =        kbw * ipeakbw            ; scale it to peak deviation

   anoise  rand     iamp                     ; white noise
   a1      reson    anoise,  icfq, kbw, 1    ; filter
           outs      a1, a1

endin




</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     50_09_1.SCO
; coded:     jpg 11/93


; GEN functions **********************************************************
; envelopes
f1   0  1024  10  1



; score ******************************************************************

;                            bandwidth......             ; reson mode 1
;    start idur  iamp  icfq  ipeakbw iratebw             ; output amps
i1    0     5    8000     5   4000     2                 ; 7186   sisch..
i1    +     2    .     5000    100     3                 ; 1293   ring..
i1    .     .    .     1000    500    10                 ; 3175   fast exh.
i1    .     .    .      400    250     1                 ; 1868   slow blow
e



</CsScore>
</CsoundSynthesizer>
