# 09 A. CSOUND IN PD - Code Example 5

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 09-a-csound-in-pd
- **Section:** Control Output
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
nchnls = 2
0dbfs = 1
ksmps = 8

instr 1
ktim      times
kphas     phasor    1
          outvalue  "time", ktim
          outvalue  "phas", kphas*127
endin

</CsInstruments>
<CsScore>
i 1 0 30
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "09 A. CSOUND IN PD".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/09-a-csound-in-pd.md](../chapters/09-a-csound-in-pd.md)
