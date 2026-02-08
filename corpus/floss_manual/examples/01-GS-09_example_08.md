# 09 Hello If - Code Example 9

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 01-GS-09
- **Section:** Format strings
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `01`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-o dac -m 128
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 1

instr FormatString
  prints("This is %d - an integer.\n",4)
  prints("This is %f - a float.\n",sqrt(2))
  prints("This is a %s.\n","string")
  prints("This is a %s","concate")
  prints("nated ")
  prints("string.\n")
endin

</CsInstruments>
<CsScore>
i "FormatString" 0 0
</CsScore>
</CsoundSynthesizer>
```

---

## Context

This code example is from the FLOSS Manual chapter "09 Hello If".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/01-GS-09.md](../chapters/01-GS-09.md)
