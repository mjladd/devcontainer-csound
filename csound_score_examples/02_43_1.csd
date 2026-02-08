<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 02_43_1.orc and 02_43_1.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 2

; ************************************************************************
; ACCCI:      02_43_1.ORC
; timbre:     tibetan chant
; synthesis:  additive same units(02)
;             basic instrument with minimal differences in frequency(43)
;             arpeggio instrument by Risset
; source:     Phase6, Lorrain(1980); risset1.orc, MIT(1993)
; coded:      jpg 9/93


instr 1; *****************************************************************
idur  = p3
iamp  = p4/9
ifq   = p5
ioff1 = p6
ioff2 = 2*p6
ioff3 = 3*p6
ioff4 = 4*p6
irise = p7
idec  = p8

   ae  linen   iamp,irise,idur,idec

   a1  oscili  ae, ifq, 1
   a2  oscili  ae, ifq+ioff1, 1  ; nine oscillators with the same ae
   a3  oscili  ae, ifq+ioff2, 1  ; and waveform, but slightly different
   a4  oscili  ae, ifq+ioff3, 1  ; frequencies create harmonic arpeggio
   a5  oscili  ae, ifq+ioff4, 1
   a6  oscili  ae, ifq-ioff1, 1
   a7  oscili  ae, ifq-ioff2, 1
   a8  oscili  ae, ifq-ioff3, 1
   a9  oscili  ae, ifq-ioff4, 1
       outs1   a1+a2+a3+a4+a5+a6+a7+a8+a9

endin


instr 2; *****************************************************************
idur  = p3
iamp  = p4/9
ifq   = p5
ioff1 = p6
ioff2 = 2*p6
ioff3 = 3*p6
ioff4 = 4*p6
irise = p7
idec  = p8

   ae  linen   iamp,irise,idur,idec

   a1  oscili  ae, ifq, 1
   a2  oscili  ae, ifq+ioff1, 1  ; nine oscillators with the same ae
   a3  oscili  ae, ifq+ioff2, 1  ; and waveform, but slightly different
   a4  oscili  ae, ifq+ioff3, 1  ; frequencies create harmonic arpeggio
   a5  oscili  ae, ifq+ioff4, 1
   a6  oscili  ae, ifq-ioff1, 1
   a7  oscili  ae, ifq-ioff2, 1
   a8  oscili  ae, ifq-ioff3, 1
   a9  oscili  ae, ifq-ioff4, 1
       outs2   a1+a2+a3+a4+a5+a6+a7+a8+a9
endin

</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:      02_43_1.SCO
; coded:      jpg 9/93


; GEN functions **********************************************************

; carrier
f1 0 1024 10 .3 0 0 0 .1 .1 .1 .1 .1 .1


; score ******************************************************************

;    start   idur  iamp   ifq     ioff   irise   idec
i1     0      35   8000   110     .03     .07     21     ; 1st envelope
i2     5      20   9600    55     .02     .04     12     ;
i2    20      15   8000   220     .05         1.5    3      ;
i1    20      20   9600   110     .04         2      4      ;
i1    28      30   8000   220     .04         3      6      ;  2nd env.
i2    32      26   9600   110     .025        2.6    5.2    ;
i1    32.1    23   8000   110     .03         2.3    4.6    ;
i2    36      22   8000    55     .01     .04     13     ; 1st envelope
e

</CsScore>
</CsoundSynthesizer>
