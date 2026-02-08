<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from ADSR-Exp.orc and ADSR-Exp.sco
; Original files preserved in same directory

sr       = 44100
kr       = 4410
ksmps    = 10
nchnls   = 1


instr    1 ; Exponential (CR) ADSR envelope with k-rate times

ilevl    = p4*32767                ; Output level
katk     = (p5 < .001 ? .001 : p5) ; Attack time >1ms
kdec     = (p6 < .001 ? .001 : p6) ; Decay time >1ms
ksusl    init p7                   ; Sustain level
krel     = (p8 < .001 ? .001 : p8) ; Release time >1ms
ksus     = p3 - katk - kdec - krel
krate    = 1/(katk + kdec + ksus + krel)
k1       = katk
k2       = k1 + kdec
k3       = k2 + ksus
k4       = k3 + krel
aramp    oscili  k4, krate, 1
a1       limit  aramp, 0, k1
a2       limit  aramp, k1, k2
a3       limit  aramp, k2, k3
a4       limit  aramp, k3, k4
aramp    = .25*(a1*(1/katk) + (a2-k1)*(1/kdec) + (a3-k2)*(1/ksus) + (a4-k3)*(1/krel))
adsr1    tablei  aramp, 2, 1
atk      tablei  aramp, 3, 1
adsr2    tablei  aramp, 4, 1
adsr3    = adsr1*ksusl + adsr2*(1 - ksusl)
out      (adsr3 - atk)*ilevl

endin

</CsInstruments>
<CsScore>
f1 0 8193 -7 0 8192 1                       ; Ramp
f2 0 8193 -5 1 6144 1 2048 .0001            ; DSR(Sustain=1)
f3 0 8193 -5 1 2048 .0001 6144 .0001        ; -A
f4 0 8193 -5 1 2048 1 2048 .0001 4096 .0001 ; DSR(Sustain=0)

;     Strt  Leng  Levl  AtkT  DecT  SusL  RelT
i01   0.00  1.00  1.00  0.25  0.25  0.00  0.25
i01   1.00  1.00  1.00  0.00  0.50  0.75  0.25
i01   2.00  1.00  1.00  0.00  0.75  0.00  0.25
e
</CsScore>
</CsoundSynthesizer>
