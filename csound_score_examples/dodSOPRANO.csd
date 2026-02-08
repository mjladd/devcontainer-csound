<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from dodSOPRANO.ORC and dodSOPRANO.SCO
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1

;**********************************************************************
; chowning soprano instrument from dodge book, pp 120 - 121    rp     *
;**********************************************************************

          instr   1,2,3,4
;**********************INITIALIZATION...
iamp      =         p6                       ;RANGE 0 < AMP < 1
ifenvfn   =         p7
iportfn   =         p8
ifmtfn1   =         p9
ifmtfn2   =         p10
ifmtfn3   =         p11
ifundfn   =         p12
irange    =         3                        ; MAX RANGE OF 3 OCTAVES
ibase     =         octpch(7.07)             ; LOWEST NOTE = G3
icaroct   =         octpch(p5)
icarhz    =         cpspch(p5)
ipoint    =         (icaroct-ibase)/irange*511.999

ifmthz    table     ipoint,ifmtfn1           ; RELATIVE POS. OF FORMANT
ifmthz    =         ifmthz*3000              ; MAP ONTO FREQUENCY RANGE
ifmthz    =         int(ifmthz/icarhz+.5)*icarhz ; AS NEAREST HARMONIC

ifmtfac   table     ipoint,ifmtfn2           ; RELATIVE AMP. OF FORMANT
ifmtfac   =         ifmtfac*.1               ; MAX VALUE = .1
ifndfac   =         1-ifmtfac                ; RELATIVE AMP. OF FUND

ifmtndx   table     ipoint,ifmtfn3           ; RELATIVE INDEX OF FORMANT
ifmtndx   =         ifmtndx*5                ; MAX VALUE = 5

ifndndx   table     ipoint,ifundfn           ; RELATIVE INDEX OF FUND
ifndndx   =         ifndndx*.25              ; MAX VALUE = .25

ifndamp   =         ifndfac * sqrt(iamp)     ; AMP**.5
ifmtamp   =         ifmtfac * iamp * sqrt(iamp) ; AMP**1.5

imodhz    =         icarhz                   ; CALCULATE MODULATOR AND
ipkdev1   =         ifndndx*imodhz           ; PEAK DEVIATION

; compute vibrato parameters:
ilog2pch  =         log(icarhz)/log(2)
ivibwth   =         .002*ilog2pch            ; RELATE WIDTH TO FUND PCH
ivibhz    =         5                        ; FROM 5 TO 6.5 Hz AVERAGE
irandhz   =         125                      ; FROM MORRILL TRUMPET DESIGN
iportdev  =         .05                      ;  "     "       "      "
















;************************* PERFORMANCE...
; vibrato
krand     randi     ivibwth,irandhz
kvibwth   linen     ivibwth,.6,p3,.1         ; GATE VIBRATO WIDTH
kport     oscil1    0,iportdev,.2,iportfn    ; INITIAL PORTAMENTO
kvib      oscili    kvibwth,ivibhz,1         ; Fn1 = SINE
kv        =         1+kvib+kport+krand       ; VIBRATO FACTOR ALWAYS CA 1
; fm
adev1     oscili    ipkdev1,imodhz*kv,1      ; MODULATOR
adev2     =         adev1*ifmtndx/ifndndx    ; RESCALE FOR FORMANT CARRIER
afundhz   =         (icarhz+adev1)*kv        ; VIB THE MODULATED FUND...
aformhz   =         (ifmthz+adev2)*kv        ; ...AND MODULATED FORMANT

afund     linen     ifndamp,.1,p3,.08
afund     oscili    afund,afundhz,1
aform     envlpx    ifmtamp,.1,p3,.08,ifenvfn,1,.01
aform     oscili    aform,aformhz,1

asig      =         (afund+aform)*p4         ; SCALE TO PEAK AMP HERE
          out       asig
          endin

</CsInstruments>
<CsScore>
; test score for chowning soprano instrument
f01        0   512    10     1
; fmt amplitude rise function
f02        0   513     7     0   256    .2   256     1
; portamento function
f03        0   513     7    -1   200     1   100     0   212     0
; fmt freq lookup function
f04        0   513     7     1    80     1   200    .9   200    .6    32    .6
; fmt amplitude factor lookup function
f05        0   513     7    .4   100    .2   412     1
; index 1 lookup function
f06        0   513     7     1   100     1   112    .4   300   .15
; index 2 lookup function
f07        0   513     7     1   100    .5    80   .25   132    .5   100    .7
   100    .4
; play some notes
; p4 = amp; p5 = fund; p6 = 0 < ampfac < 1; p7 = fmt env func
; p8 = port func; p9 = fmt hz func; p10 = fmt amp func; p11, 12 = i1,i2 fns
i01        0     1 20000  7.07    .5     2     3     4     5     6     7
i01        1     .     .  8.04
i01        2     .     .  9.01
i01        3     .     .  9.10
i01        4     2     . 10.07
e

</CsScore>
</CsoundSynthesizer>
