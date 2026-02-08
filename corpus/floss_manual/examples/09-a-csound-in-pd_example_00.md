# 09 A. CSOUND IN PD - Code Example 1

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 09-a-csound-in-pd
- **Section:** Control Data
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
kFreq     invalue   "freq"
kAmp      invalue   "amp"
aSin      poscil    kAmp, kFreq
          out       aSin, aSin
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
