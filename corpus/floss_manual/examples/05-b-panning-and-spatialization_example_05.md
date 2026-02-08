# 05 B. PANNING AND SPATIALIZATION - Code Example 6

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 05-b-panning-and-spatialization
- **Section:** The _Spread_ Parameter
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `05`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-odac
--env:SSDIR+=../SourceMaterials
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
0dbfs = 1
nchnls = 8 ;only channels 1-7 used

vbaplsinit 2, 7, -40, 40, 70, 140, 180, -110, -70

  instr 1
Sfile      =          "ClassGuit.wav"
p3         filelen    Sfile
aSnd[]     diskin     Sfile
kAzim      line       0, p3, -360 ;counterclockwise
kSpread    linseg     0, p3/2, 100, p3/2, 0
aVbap[]    vbap       aSnd[0], kAzim, 0, kSpread
           out        aVbap
  endin
</CsInstruments>
<CsScore>
i 1 0 1
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "05 B. PANNING AND SPATIALIZATION".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/05-b-panning-and-spatialization.md](../chapters/05-b-panning-and-spatialization.md)
