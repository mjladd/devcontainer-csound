<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from LorenzChorus.orc and LorenzChorus.sco
; Original files preserved in same directory

sr     = 44100
kr     = 44100
ksmps  = 1
nchnls = 2


instr    1 ; Lorenz Attractor Chorus

ilevl    = p4*.7     ; Output level
idelay   = p5/1000   ; Delay in ms
idepth   = p6/1000   ; Depth in ms
isv      = p7        ; S
irv      = p8        ; R
ibv      = p9        ; V
ix       = p10       ; X position
iy       = p11       ; Y position
iz       = p12       ; Z position
irate    = p13/10000 ; Rate
imax     = 1

ain      soundin  "Piano.aif"

ax, ay, az lorenz  isv, irv, ibv, irate, ix, iy, iz, 1

achor1   flanger  ain, (ax/18)*idepth + idelay, 0, imax
achor2   flanger  ain, (ay/18)*idepth + idelay, 0, imax
achor3   flanger  ain, (az/18)*idepth + idelay, 0, imax
outs1    (achor1 + achor2*.707)*ilevl
outs2    (achor3 + achor2*.707)*ilevl

endin

</CsInstruments>
<CsScore>
;Delay and Depth in ms

;   Strt  Leng  Levl  Delay Depth S     R     V     X     Y     Z     Rate
i1  0.00  1.47  1.00  20.0  2.50  10    28    2.667 0.60  0.60  0.60  0.50
e

</CsScore>
</CsoundSynthesizer>
