# 05 I. FOURIER ANALYSIS / SPECTRAL PROCESSING - Code Example 11

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 05-i-fourier-analysis-spectral-processing
- **Section:** Retrieving Single Bins from FFT
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `05`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-o dac
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

instr Simple
 aSig diskin "fox.wav"
 fSig pvsanal aSig, 1024, 256, 1024, 1
 fTrace pvstrace fSig, p4
 aTrace pvsynth fTrace
 out aTrace, aTrace
endin

</CsInstruments>
<CsScore>
i "Simple" 0 3 1
i . + . 2
i . + . 4
i . + . 8
i . + . 16
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "05 I. FOURIER ANALYSIS / SPECTRAL PROCESSING".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/05-i-fourier-analysis-spectral-processing.md](../chapters/05-i-fourier-analysis-spectral-processing.md)
