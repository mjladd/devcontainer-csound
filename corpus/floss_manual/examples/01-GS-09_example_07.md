# 09 Hello If - Code Example 8

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 01-GS-09
- **Section:** Looping with 'if'
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

instr LoopIf
  iCount = p4
  start:
  if (iCount > 0) then
    print(iCount)
    iCount = iCount-1
    igoto start
  else
    prints("Finished!\n")
  endif
endin

</CsInstruments>
<CsScore>
i "LoopIf" 0 0 10
</CsScore>
</CsoundSynthesizer>
```

---

## Context

This code example is from the FLOSS Manual chapter "09 Hello If".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/01-GS-09.md](../chapters/01-GS-09.md)
