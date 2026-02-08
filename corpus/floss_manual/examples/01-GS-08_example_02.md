# 08 Hello Schedule - Code Example 3

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 01-GS-08
- **Section:** Three Particular Durations: 0, -1 and z
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `01`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-o dac -m128
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

instr Zero
  prints("Look at me!\n")
endin

</CsInstruments>
<CsScore>
i "Zero" 0 0
</CsScore>
</CsoundSynthesizer>
```

---

## Context

This code example is from the FLOSS Manual chapter "08 Hello Schedule".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/01-GS-08.md](../chapters/01-GS-08.md)
