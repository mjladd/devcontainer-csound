<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 40_03_1.orc and 40_03_1.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls =2

; ************************************************************************
; ACCCI:      40_03_1.ORC
; synthesis:  Waveshaping(40)
;             Waveshaper Using Ring Modulation(03)
; source:     Dodge (p.145, 1985)
; coded:      jpg 8/93



instr 1; *****************************************************************
idur  =  p3
iamp  =  p4
ifq   =  cpspch(p5)

   a1    oscili    iamp, 1/idur, 31            ; envelope
   a2    oscili    a1, ifq, 1                  ; sinus of ring modulation

   a3    linseg    1, .04, 0, idur-.04, 0      ; very short envelope
   a4    oscili    a3, ifq*.7071, 1            ; sinus for waveshaper

   ; inline code for transfer function:
   ; f(x) = 1 + .841x - .707x**2 - .595x**3 + .5x**4 + .42x**5 -
   ;                      .354x**6 - .279x**7 + .25x**8 + .21x**9

   a5    =         a4*a4
   a6    =         a5*a4
   a7    =         a5*a5
   a8    =         a7*a4
   a9    =         a6*a6
   a10   =         a9*a4
   a11   =         a10*a4
   a12   =         a11*a4

   ; This is the polynomial representation of the transfer function


a13=1+.841*a4-.707*a5-.595*a6+.5*a7+.42*a8-.354*a9-.297*a10+.25*a11+.21*a12

   a14   =         a13*a2         ; ring modulation
         outs       a14,a14

endin

</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:      40_03_1.SCO
; coded:      jpg 8/93


; GEN functions **********************************************************
; carrier
f1  0  512  10  1  ; sinus

; envelope for sinus at ifq
f31 0 512 7 0 16 .2 16 .38 16 .54 16 .68 16 .8 16 .9 16 .98 8 1 2 1 6 .96
 64 .8313 32 .5704 80 .164 48 .0521 44 .0159 20 .0092 64 .005 32 0

; score ******************************************************************

;   start  idur   iamp   ipch
i1   0.0   0.2    8000   6.00
i1   +     0.25   .      6.05
i1   .     .      .      7.00
i1   .     0.2    .      7.05
i1   .     0.2    .      8.00
i1   .     0.2    .      8.05
i1   .     0.2    .      9.00
i1   .     0.2    .      8.07
i1   .     0.1    .      8.00
i1   .     0.25   .      7.07
i1   .     0.25   .      7.00
i1   .     0.25   .      6.07
i1   .     0.25   .      6.00

s

i1   0.0   0.2    8000   8.00
i1   +     0.25   .      8.05
i1   .     .      .      9.00
i1   .     0.2    .      9.05
i1   .     0.2    .     10.00
i1   .     0.2    .     10.05
i1   .     0.2    .     11.00
i1   .     0.2    .     10.07
i1   .     0.1    .     10.00
i1   .     0.25   .      9.07
i1   .     0.25   .      9.00
i1   .     0.25   .      8.07
i1   .     0.25   .      8.00
i1   .     0.2    .     11.00
i1   .     0.2    .     10.07
i1   .     0.1    .     10.00
i1   .     0.25   .      9.07
i1   .     0.25   .      9.00
i1   .     0.25   .      8.07
i1   .     0.25   .      8.00

e

</CsScore>
</CsoundSynthesizer>
