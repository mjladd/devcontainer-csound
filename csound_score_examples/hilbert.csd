<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from hilbert.orc and hilbert.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2


; ------------------------------------------------------------------
;  SSB.ORC
;  AN IMPLEMENTATION OF A HILBERT-TRANSFORMER FREQUENCY SHIFTER.
;  Roger Klaveness , March 1999



gisintab  ftgen     0,0,4096,10,1

          zakinit   2,1

; DISKIN STEREO
          instr 1

iamp      =         p4
ipitch    =         p5
ifil      =         p6
ioffset   =         p7
izakl     =         p8
izakr     =         p9

al,ar     diskin    ifil,ipitch ,ioffset
          zaw       iamp*al,izakl
          zaw       iamp*ar,izakr

          endin

; DISKIN MONO
          instr 2

iamp      =         p4
ipitch    =         p5
ifil      =         p6
ioffset   =         p7
izak      =         p8

adisk     diskin    ifil,ipitch ,ioffset
          zaw       iamp*adisk,izak

          endin


; SSB INSTRUMENT
          instr 10
idur      =         p3
iamp      =         p4
ienvtab   =         p5
ipitchtab =         p6
izak      =         p7

kenv      oscili    iamp,1/idur,ienvtab
kpitch    oscili    1,1/idur,ipitchtab ;sin

asinmod   oscili    1,kpitch,gisintab
acosmod   oscili    1,kpitch,gisintab,0.25

ain       zar       izak

;------------------------------------------------------------------
; HILBERT TRANSFORM, 11-ORDER FIR

igain     =         1.570796327

axv0      init      0
axv1      init      0
axv2      init      0
axv3      init      0
axv4      init      0
axv5      init      0
axv6      init      0
axv7      init      0
axv8      init      0
axv9      init      0
axv10     init      0

axv0      =         axv1
axv1      =         axv2
axv2      =         axv3
axv3      =         axv4
axv4      =         axv5
axv5      =         axv6
axv6      =         axv7
axv7      =         axv8
axv8      =         axv9
axv9      =         axv10
axv10     =         ain/igain;

ahilb     =         .0160000000 * (axv0 - axv10) + .1326173942 * (axv2 - axv8) + .9121478174 * (axv4 - axv6)
;----------------------------------------------------------------------------------------------------------------

amod1     =         ahilb*asinmod
amod2     =         ain*acosmod

          outs      amod2-amod1,amod1+amod2


          endin

</CsInstruments>
<CsScore>
; ------------------------------------------------------------------
; ssb.sco

f1 0 1024 -10 1 2 4 1 3 ;ssb-pitch
;f1   0   256 -7 5 128 3000 128 0 ;ssb-pitch
f2   0   256 -7 0 28 1 200 1 28   0 ;amp

; diskin
;       amp pitch fil offset zakl zakr
i1 0 30 1   1     5   0      1    2

;ssb
;   start dur amp envtab pitchtab zak
i10 0     30  1   2      1        1
e

</CsScore>
</CsoundSynthesizer>
