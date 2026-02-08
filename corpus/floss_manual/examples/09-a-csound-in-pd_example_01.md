# 09 A. CSOUND IN PD - Code Example 2

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 09-a-csound-in-pd
- **Section:** Live Input
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `09`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr = 44100
0dbfs = 1
ksmps = 8
nchnls = 2

instr 1
aL        inch      1
aR        inch      2
kcfL      randomi   100, 1000, 1; center frequency
kcfR      randomi   100, 1000, 1; for band pass filter
aFiltL    butterbp  aL, kcfL, kcfL/10
aoutL     balance   aFiltL, aL
aFiltR    butterbp  aR, kcfR, kcfR/10
aoutR     balance   aFiltR, aR
          outch     1, aoutL
          outch     2, aoutR
endin

</CsInstruments>
<CsScore>
i 1 0 10000
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "09 A. CSOUND IN PD".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/09-a-csound-in-pd.md](../chapters/09-a-csound-in-pd.md)
