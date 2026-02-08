<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 20_70_1.orc and 20_70_1.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:     20_70_1.ORC
; synthesis: FM(20),
;            single-carrier, complex wave FM (70)
;            string-like(1)
; source:    Schottstaedt(1977), adapted from string.orc: MIT(1993)
; coded:     jpg 10/93



instr 1; *****************************************************************
idur    = p3
iamp    = p4
ifqc    = cpspch(p5)      ;S = fc +- ifm1 +- kfm2 +- lfm3
ifm1    = ifqc
ifm2    = ifqc*3
ifm3    = ifqc*4
indx1   = 7.5/log(ifqc)    ;range from ca 2 to 1
indx2   = 15/sqrt(ifqc)    ;range from ca 2.6 to .5
indx3   = 1.25/sqrt(ifqc)  ;range from ca .2 to .038

irise   = p6
idec    = p7
inoisdur= .1
ivibdel =  1
ivibwth = p9
ivibrte = p10

        kvib    init    0
                timout  0,ivibdel,transient   ; delay vibrato ivibdel sec
        kvbctl  linen   1,.5,idur-ivibdel,.1  ; vibrato control envelope
        krnd    randi   .0075,2               ; random deviation vib width
        kvib    oscili  kvbctl*ivibwth+krnd,ivibrte*kvbctl,1   ; generator

transient:
                timout  inoisdur,p3,continue  ; execute for .2 secs only
        ktrans  linseg  1,inoisdur,0,1,0      ; transient envelope
        anoise  randi   ktrans*iamp/4,.2*ifqc ; attack noise...
        attack  oscili  anoise,2000,1         ; ...centered around 2kHz


continue:
        amod1   oscili  ifm1*(indx1+ktrans),ifm1,1
        amod2   oscili  ifm2*(indx2+ktrans),ifm2,1
        amod3   oscili  ifm3*(indx3+ktrans),ifm3,1
        asig    oscili  iamp,(ifqc+amod1+amod2+amod3)*(1+kvib),1
        asig    linen   asig+attack,irise,idur,idec
                out     asig



endin


</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     20_70_1.SCO
; notes:     melody taken from "Kennedy's Children" by E. Reitz
; coded:     jpg 10/93


; GEN functions **********************************************************

; carrier
f1     0       512     10      1


; score ******************************************************************
t 0 40

;    start    idur      iamp    ipch irise idec  ivibdel ivibwth ivibrte
i1      0      .5       8000    7.01  .2    .2     .75     .03     5.5
i1      .8      .5       7000    6.09  .2    .2     .75     .03     5.5
i1      1.2     2.5       6000    7.01  .2    .2     .75     .03     5.5
e
ji1     1.2    1.5      12000    6.08  .2    .2     .75     .03     5.5
i1     3.0     .5       8000    6.07  .2    .2     .75     .03     5.5
i1     3.4    1.5      16000    7.06  .2    .2     .75     .03     5.5
i1     4.8     .5      14000    7.07  .2    .2     .75     .03     5.5
i1     5.2     .5      10000    7.03  .2    .2     .75     .03     5.5
i1     5.6     .5       8000    6.11  .2    .2     .75     .03     5.5
i1     6.0    1.5       8000    7.02  .2    .2     .75     .03     5.5
i1     7.4     .5      12000    6.10  .2    .2     .75     .03     5.5
i1     7.8    2        12000    7.01  .2    .2     .75     .03     5.5
e


</CsScore>
</CsoundSynthesizer>
