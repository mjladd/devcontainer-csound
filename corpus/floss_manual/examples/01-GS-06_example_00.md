# 06 Hello Decibel - Code Example 1

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 01-GS-06
- **Section:** The 'ampdb' Opcode
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `01`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-o dac
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 1

instr Convert
  iAmp = ampdb:i(-6)
  print(iAmp)
endin

</CsInstruments>
<CsScore>
i "Convert" 0 0
</CsScore>
</CsoundSynthesizer>
```

---

## Context

This code example is from the FLOSS Manual chapter "06 Hello Decibel".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/01-GS-06.md](../chapters/01-GS-06.md)
