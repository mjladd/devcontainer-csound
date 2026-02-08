# 07 Hello p-Fields - Code Example 3

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 01-GS-07
- **Section:** Enumerate instrument instances as fractional part
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
ksmps = 32
nchnls = 2
0dbfs = 1

instr 1
  print(p1)
endin

</CsInstruments>
<CsScore>
i 1.1 0 3
i 1.2 2 2
i 1.3 5 1
</CsScore>
</CsoundSynthesizer>
```

---

## Context

This code example is from the FLOSS Manual chapter "07 Hello p-Fields".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/01-GS-07.md](../chapters/01-GS-07.md)
