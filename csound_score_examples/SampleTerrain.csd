<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from SampleTerrain.orc and SampleTerrain.sco
; Original files preserved in same directory

sr     = 44100
kr     = 44100
ksmps  = 1
nchnls = 1


instr    1 ; 3D Sample Wave Terrain

ilevl    = p4*32767                    ; Output level
ipitch   = (p5 < 10 ? cpspch(p5) : p5) ; Pitch in cpspch or Hz
iposx1   = p6                          ; X position start
iposx2   = p7                          ; X position finish
iposy1   = p8                          ; Y position start
iposy2   = p9                          ; Y position finish
iradi1   = p10/1000                    ; Radius start (scaled)
iradi2   = p11/1000                    ; Radius end (scaled)
iratex   = p12                         ; X random rate
iratey   = p13                         ; Y random rate
idpth    = p14/1000                    ; Random depth (scaled)

kx       line  iposx1, p3, iposx2      ; X position
ky       line  iposy1, p3, iposy2      ; Y position
krad     line  iradi1, p3, iradi2      ; Radius
krndx    randi  idpth, iratex          ; X random position modulation
krndy    randi  idpth, iratey          ; Y random position modulation
ksin     oscili  krad, ipitch, 3       ; X indexing osc (sine)
kcos     oscili  krad, ipitch, 3, .25  ; Y indexing osc (cosine)
kindx    = kx + ksin + krndx           ; Add X indexes together
kindy    = ky + kcos + krndy           ; Add Y indexes together
ax       tablei  kindx, 1, 1, 0, 1     ; X indexing
ay       tablei  kindy, 2, 1, 0, 1     ; Y indexing
out      ax*ay*ilevl                   ; Output

endin

</CsInstruments>
<CsScore>
;Terrain Tables
f1 0 32768 1 "Sample1" 0 4 0 ; X Sample1
f2 0 65536 1 "Sample2" 0 4 0 ; Y Sample1

;Index Table
f3 0 8193 10 1 ; Sine

;   Strt  Leng  Levl  Pitch Xpos1 Xpos2 Ypos1 Ypos2 Radi1 Radi2 Xrate Yrate Depth
i1  0.00  16.0  4.00  110.0 0.25  0.35  0.10  0.75  0.00  0.25  2.35  1.11  0.10
i1  .     .     2.00  220.5 0.10  0.33  1.00  0.33  0.00  0.25  1.25  0.77  0.10
i1  .     .     1.00  440.3 0.50  0.77  0.80  0.74  0.01  0.10  2.23  3.14  0.10
e


</CsScore>
</CsoundSynthesizer>
