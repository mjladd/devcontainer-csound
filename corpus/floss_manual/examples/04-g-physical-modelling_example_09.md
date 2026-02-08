# 04 G. PHYSICAL MODELLING - Code Example 10

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 04-g-physical-modelling
- **Section:** wgbow - A Waveguide Emulation of a Bowed String by Perry Cook
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `04`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>
sr      =       44100
ksmps   =       32
nchnls  =       2
0dbfs   =       1
        seed    0

gisine  ftgen   0,0,4096,10,1

gaSend init 0

 instr 1 ; wgbow instrument
kamp     =        0.1
kfreq    =        p4
kpres    =        0.2
krat     rspline  0.006,0.988,0.1,0.4
kvibf    =        4.5
kvibamp  =        0
iminfreq =        20
aSig     wgbow    kamp,kfreq,kpres,krat,kvibf,kvibamp,gisine,iminfreq
aSig     butlp     aSig,2000
aSig     pareq    aSig,80,6,0.707
         outs     aSig,aSig
gaSend   =        gaSend + aSig/3
 endin

 instr 2 ; reverb
aRvbL,aRvbR reverbsc gaSend,gaSend,0.9,7000
            outs     aRvbL,aRvbR
            clear    gaSend
 endin

</CsInstruments>
<CsScore>
; instr. 1 (wgbow instrument)
;  p4 = pitch (hertz)
; wgbow instrument
i 1  0 480  20
i 1  0 480  40
i 1  0 480  80
i 1  0 480  160
i 1  0 480  320
i 1  0 480  640
i 1  0 480  1280
i 1  0 480  2460
; reverb instrument
i 2 0 480
</CsScore>
</CsoundSynthesizer>
;example by Iain McCurdy
```

---

## Context

This code example is from the FLOSS Manual chapter "04 G. PHYSICAL MODELLING".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/04-g-physical-modelling.md](../chapters/04-g-physical-modelling.md)
