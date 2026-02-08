# 04 E. WAVESHAPING - Code Example 1

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 04-e-waveshaping
- **Section:** Basic Implementation Model
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
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

giTrnsFnc ftgen 0, 0, 4097, -7, -0.5, 1024, -0.5, 2048, 0.5, 1024, 0.5
giSine    ftgen 0, 0, 1024, 10, 1

instr 1
aAmp      poscil    1, 400, giSine
aIndx     =         (aAmp + 1) / 2
aWavShp   tablei    aIndx, giTrnsFnc, 1
          out       aWavShp, aWavShp
endin

</CsInstruments>
<CsScore>
i 1 0 10
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "04 E. WAVESHAPING".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/04-e-waveshaping.md](../chapters/04-e-waveshaping.md)
