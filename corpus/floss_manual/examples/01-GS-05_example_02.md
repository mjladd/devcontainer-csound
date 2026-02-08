# 05 Hello MIDI Keys - Code Example 3

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 01-GS-05
- **Section:** The 'prints' Opcode and Strings
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

instr Prints
  prints("Hello String!\n")
endin

</CsInstruments>
<CsScore>
i "Prints" 0 0
</CsScore>
</CsoundSynthesizer>
```

---

## Context

This code example is from the FLOSS Manual chapter "05 Hello MIDI Keys".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/01-GS-05.md](../chapters/01-GS-05.md)
