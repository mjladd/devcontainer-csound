<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Mutator.orc and Mutator.sco
; Original files preserved in same directory

sr     = 44100
kr     = 4410
ksmps  = 10
nchnls = 2


instr    1 ; Virtual Mutronics Mutator. (sans VCAs)

igain    = p4     ; Gain: >1=Overdrive
ifreq    = p5     ; Manual cutoff frequency (0 to 1)
idepth   = p6/2   ; LFO depth
irate1   = p7     ; L LFO rate
irate2   = p8     ; R LFO rate
iphase   = p9/360 ; R LFO phase
iwave    = p10    ; LFO waveform
irez     = p11    ; Resonance

ain      soundin  "AllOfMe.aif"

ain      = ain*igain                           ; Gain/Overdrive
klfo1    oscili  idepth, irate1, iwave         ; L LFO
klfo2    oscili  idepth, irate2, iwave, iphase ; R LFO
klfo1    = klfo1 + idepth                      ; Make unipolar
klfo2    = klfo2 + idepth                      ; Make unipolar
kfreq1   table  klfo1 + ifreq, 1, 1            ; L lin/exp convertor
kfreq2   table  klfo2 + ifreq, 1, 1            ; R lin/exp convertor
avcfl    moogvcf  ain, kfreq1, irez, 32768     ; L VCF
avcfr    moogvcf  ain, kfreq2, irez, 32768     ; R VCF
outs1    avcfl                                 ; L Output
outs2    avcfr                                 ; R Output

endin

</CsInstruments>
<CsScore>
f1 0 8193 -5 20 8192 10000       ; Exponential convertor
f2 0 8193 9 1 1 180              ; Sine
f3 0 8193 7 0 4096 1 4096 0      ; Triangle
f4 0 1025 7 1 512 1 0 0 512 0    ; Square
f5 0 8193 7 0 8192 1             ; Ramp up
f6 0 8193 10 1 0 0 0 0 0 0 0 0 1 ; Fast and slow sines

;Freq/Depth=0<1, PhseR=0<360 degrees
;                           ------------LFOs-------------
;   Strt  Leng  Gain  Freq  Depth RateL RateR PhseR Waves Rez(0<1)
i1  0.00  1.47  1.25  0.25  0.75  0.36  0.36  180   3     0.75
e

</CsScore>
</CsoundSynthesizer>
