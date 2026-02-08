# 10 Hello Random - Code Example 1

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 01-GS-10
- **Section:** The 'random' Opcode and the 'seed'
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

instr Random
  iRandomNumber = random:i(10,20)
  prints("Random number between 10 and 20: %f\n",iRandomNumber)
endin

</CsInstruments>
<CsScore>
i "Random" 0 0
</CsScore>
</CsoundSynthesizer>
```

---

## Context

This code example is from the FLOSS Manual chapter "10 Hello Random".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/01-GS-10.md](../chapters/01-GS-10.md)
