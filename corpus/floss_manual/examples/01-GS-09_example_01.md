# 09 Hello If - Code Example 2

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 01-GS-09
- **Section:** The 'if' Opcode in Csound
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

instr TryMyIf
  iCount = 6
  if (iCount > 1) then
	prints("True!\n")
  else
    prints("False!\n")
  endif
endin

</CsInstruments>
<CsScore>
i "TryMyIf" 0 0
</CsScore>
</CsoundSynthesizer>
```

---

## Context

This code example is from the FLOSS Manual chapter "09 Hello If".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/01-GS-09.md](../chapters/01-GS-09.md)
