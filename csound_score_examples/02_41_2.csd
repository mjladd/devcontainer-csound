<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 02_41_2.orc and 02_41_2.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:     02_41_2.ORC
; timbre:    brass
; synthesis: additive, with equivalent parallel units(02)
;            basic instrument with added random frequency variation(41)
; source:    #200 Brass-like Sounds through Independent Control of
;            Harmonics, Risset(1969) /instr 1 and instr2-6/
; coded:     jpg 8/93


instr 1; *****************************************************************
idur  =  p3
iamp  =  p4
ifq1  =  p5
if2   =  p6            ; function number for envelope
ifundr=  p7 * .04      ; 4% of fundamental

        afqr   randi   ifundr, 20            ;random frequency fluctuations
        aenv   oscili  iamp, 1/idur, if2     ;envelope
        a1     oscili  aenv, ifq1 + afqr, 1  ;carrier
               out     a1
endin

</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:    02_41_2.SCO
; source:   #200 Brass-like Sounds through Independent Control of
;           Harmonics, Risset(1969)
; coded:    jpg 8/93



; GEN functions **********************************************************
; waveforms
f1  0 1024 10 1     ;sinus
; envelopes
f31 0 1024 7  0 20 .001  32 .282  28 .112 778 .178 88 .159 54 .008 24 .001
f32 0 1024 7  0 38 .001 830 .5    40 .355  72 .016 44 .001
f33 0 1024 7  0 46 .001 824 .56  144 .001
f34 0 1024 7  0 20 .001  18 .005 798 .224  26 .224 54 .178 108 .001
f35 0 1024 7  0 20 .001  22 .009  24 .089  24 .022 56 .022 306 .112 76
                      .178 162 .071 246 .062  88 .001
; These envelopes reach maximum amplitudes of:  .282, .5, .56, .224, .178
; Total possible value is 1.744

;score *******************************************************************
; instr 1  idur  iamp ifq1   if2   ifundr

i1  0       .4   2000  784    31    784             ;******* note 1 ******
i1  .       .    .    1568    32                    ;**** 5 harmonics ****
i1  .       .    .    2352    33
i1  .       .    .    3136    34
i1  .       .    .    3920    35

i1  1       .7   2500  830    31    830            ;******* note 2 *******
i1  .       .    .    1660    32                   ;***** 5 harmonics ****
i1  .       .    .    2490    33
i1  .       .    .    3320    34
i1  .       .    .    4150    35

e

</CsScore>
</CsoundSynthesizer>
