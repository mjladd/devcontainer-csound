# 05 F. AM / RM / WAVESHAPING - Code Example 2

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 05-f-am-rm-waveshaping
- **Section:** Bit Depth Reduction
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `05`

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

giTrnsFnc ftgen 0, 0, 4, -7, -1, 3, 1

instr 1
aAmp      soundin   "fox.wav"
aIndx     =         (aAmp + 1) / 2
aWavShp   table     aIndx, giTrnsFnc, 1
          out       aWavShp, aWavShp
endin

</CsInstruments>
<CsScore>
i 1 0 2.767
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "05 F. AM / RM / WAVESHAPING".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/05-f-am-rm-waveshaping.md](../chapters/05-f-am-rm-waveshaping.md)
