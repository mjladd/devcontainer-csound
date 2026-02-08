<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 20_20_6.orc and 20_20_6.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:     20_20_6.ORC
; synthesis: FM(20),
;            double-carrier FM, dynamic spectral evolution (20)
;            FM-soprano (5)
; source:    Chowning(1980)
; coded:     jpg 10/93, adapted rp's sopink.orc: MIT(1993)


instr 1; *****************************************************************
        idur    =       p3
        iampfac =       .5                      ; range 0 < AMPFAC < 1
        ifenv   =       49                      ; amp rise function
        ifport  =       31                      ; port function
        ifffq   =       32                      ; formant frequency lookup
        iffamp  =       33                      ; formant amp lookup
        iffimax =       42                      ; formant imax lookup
        ifcimax =       41                      ; carrier imax lookup
        irange  =       3                       ; max range of 3 octaves
        ibase   =       octpch(7.07)            ; lowest note = g3
        icaroct =       octpch(p5)              ; p5 in true decimal
        icarhz  =       cpspch(p5)              ; p5 in Hz

        ; ipoint points at p5-dependent location of a table with 512 locs
        ipoint  =       (icaroct-ibase)/irange*511.999

        ifmthz  table   ipoint,ifffq            ; relative pos. of formant
        ifmthz  =       ifmthz*3000             ; map onto frequency range
        ifmthz  =       int(ifmthz/icarhz+.5)*icarhz ; as nearest harmonic

        ifmtfac table   ipoint,iffamp           ; relative amp. of formant
        ifmtfac =       ifmtfac*.1              ; max value = .1
        ifndfac =       1-ifmtfac               ; relative amp. of fund

        ifmtndx table   ipoint,iffimax          ; relative index of formant
        ifmtndx =       ifmtndx*5               ; max value = 5

        ifndndx table   ipoint,ifcimax          ; relative index of fund
        ifndndx =       ifndndx*.25             ; max value = .25

        ifndamp =       ifndfac * sqrt(iampfac)            ; AMPFAC**.5
        ifmtamp =       ifmtfac * iampfac * sqrt(iampfac)  ; AMPFAC**1.5

        imodhz  =       icarhz                  ; calculate modulator and
        ipkdev1 =       ifndndx*imodhz          ; peak deviation

; compute vibrato parameters:
        ; change base of log:   log 2(hz) = log e(hz)/log e(2)
        ilog2pch =      log(icarhz)/log(2)
        ivibwth  =      .002*ilog2pch           ; relate width to fund pch
        ivibhz   =      5                       ; from 5 to 6.5 hz average
        irandhz  =      125                     ; same as Morril-trumpet
        iportdev =      .05                     ; "     "       "      "
;************************* performance
; vibrato generator
        krand   randi   ivibwth,irandhz         ; random contribution
        kvibwth linen   ivibwth,.6,p3,.1        ; gate vibrato width
        kvib    oscili  kvibwth,ivibhz,1        ;
        kport   oscil1  0,iportdev,.2,ifport    ; initial portamento
        kv      =       1+kvib+kport+krand      ; vibrato factor ca. 1

; modulating signal
        kdyn    linseg  0,.03,1,idur-.03-.01,.9,.01,0  ; dynamic index
        adev1   oscili  ipkdev1,imodhz*kv,1     ; modulator
        adev2   =       adev1*ifmtndx/ifndndx   ; rescale for formant

; carrier signals
        afundhz =       (icarhz+adev1)*kv       ; vib the modulated fund...
        aformhz =       (ifmthz+adev2)*kv       ; ...and modulated formant

        afund   linen   ifndamp,.1,p3,.08
        afund   oscili  afund,afundhz,1
        aform   envlpx  ifmtamp,.1,p3,.08,ifenv,1,.01
        aform   oscili  aform,aformhz,1

        asig    =       (afund+aform)*p4        ; scale to peak amp here
                out     asig
endin

</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     20_20_6.SCO
; coded:     jpg 10/93


; GEN functions **********************************************************

; carriers
f1        0   512    10     1

; envelopes
; portamento function
f31        0   513     7    -1   200     1   100     0   212     0
; fmt freq lookup function
f32        0   513     7     1    80     1   200    .9   200    .6    32
; fmt amplitude factor lookup function
f33        0   513     7    .4   100    .2   412     1
; index 1 lookup function
f41        0   513     7     1   100     1   112    .4   300   .15
; index 2 lookup function
f42        0   513     7     1   100    .5    80   .25   132    .5   100
; fmt amplitude rise function
f49        0   513     7     0   256    .2   256     1


; score ******************************************************************
t 0 40

; p6 = 0 < ampfac < 1
;             idur      iamp    ipch
i1      0      .5      12000    9.01
i1      .4     .5       7000    8.09
i1      .8     .4       6000    8.05
i1     1.2    1.5      12000    8.08
i1     3.0     .5       8000    8.07
i1     3.4    1.0      18000    9.06
i1     4.8     .5      14000    9.07
i1     5.2     .45     10000    9.03
i1     5.6     .5       4000    8.11
i1     6.0    1.4       8000    9.02
i1     7.4     .5      12000    8.10
i1     7.8    2        14000    9.01

e

</CsScore>
</CsoundSynthesizer>
