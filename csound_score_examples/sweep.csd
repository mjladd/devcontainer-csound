<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from sweep.orc and sweep.sco
; Original files preserved in same directory

sr          =           44100
kr          =           4410
ksmps       =           10
nchnls      =           1


            instr       1

iduration   =           p3
iamp        =           p4
inoiseamp   =           22050
istartfilt  =           p5
iendfilt    =           p6
iattack     =           .01
irelease    =           .1

kenvelope   linen       iamp, iattack, iduration, irelease
kcutoffrq   line        istartfilt, iduration, iendfilt

anoise      rand        inoiseamp
afilter1    butterbp    anoise, kcutoffrq, kcutoffrq / 10
afilter2    butterbp    afilter1, kcutoffrq, kcutoffrq  / 10
asignal     =           afilter2 * kenvelope

            out         asignal
            endin

</CsInstruments>
<CsScore>
; sweep.sco
; from "Making Music with Csound"
; copyright 1997 MIT Press ed. Richard Boulanger & Barry Vercoe

;   strt  dur   amp  strtflt endflt

i1  0.0   10.0  1.5  10000     20
i1 10.0    5.0  1.5     20  10000
i1 15.0    5.0  1.5   5000    500
i1 20.0    2.5  1.5     50   5000
i1 22.5    2.5  1.5  12000    100
s
i1  0.0   20.0  1.3  10000     20
i1  5.0   15.0  1.0     20  10000
i1 10.0   10.0  0.9   5000    500
i1 12.0    8.0  0.9     50   5000
i1 15.0    5.0  1.2  12000    100


</CsScore>
</CsoundSynthesizer>
