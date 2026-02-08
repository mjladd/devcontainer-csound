# 05 I. FOURIER ANALYSIS / SPECTRAL PROCESSING - Code Example 12

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

instr LoudestBin
 aSig diskin "fox.wav"
 fSig pvsanal aSig, 1024, 256, 1024, 1
 fTrace, kBins[] pvstrace fSig, 1, 1
 kAmp, kFreq pvsbin fSig, kBins[0]
 aLoudestBin poscil port(kAmp,.01), kFreq
 out aLoudestBin, aLoudestBin
endin

</CsInstruments>
<CsScore>
i "LoudestBin" 0 3
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "05 I. FOURIER ANALYSIS / SPECTRAL PROCESSING".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/05-i-fourier-analysis-spectral-processing.md](../chapters/05-i-fourier-analysis-spectral-processing.md)
