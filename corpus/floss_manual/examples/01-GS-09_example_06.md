# 09 Hello If - Code Example 7

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 01-GS-09
- **Section:** Logical AND and OR
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

instr AndOr
  iSunIsShining = 1
  iFinishedWork = 1
  prints("iSunIsShining = %d\n",iSunIsShining)
  prints("iFinishedWork = %d\n",iFinishedWork)
  //AND
  if (iSunIsShining == 1) && (iFinishedWork == 1) then
    prints("AND = True\n")
  else
    prints("AND = False\n")
  endif
  //OR
  if (iSunIsShining == 1) || (iFinishedWork == 1) then
    prints("OR = True\n")
  else
    prints("OR = False\n")
  endif
endin

</CsInstruments>
<CsScore>
i "AndOr" 0 0
</CsScore>
</CsoundSynthesizer>
```

---

## Context

This code example is from the FLOSS Manual chapter "09 Hello If".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/01-GS-09.md](../chapters/01-GS-09.md)
