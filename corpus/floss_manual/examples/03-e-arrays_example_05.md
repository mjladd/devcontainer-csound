# 03 E. ARRAYS - Code Example 6

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 03-e-arrays
- **Section:** Analyse
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `03`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-m0
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

giArray[] fillarray 1, 2, 3, 4, 5
giCmpArray[] fillarray 3, 5, 1, 4, 2

instr Compare
 printarray giArray, "%d", "Array:"
 printarray giCmpArray, "%d", "CmpArray:"
 iResult[] cmp giArray, ">=", 3
 printarray iResult, "%d", "Array >= 3?"
 iResult[] cmp 1, "<", giArray, "<=", 4
 printarray iResult, "%d", "1 < Array <= 4?"
 iResult[] cmp giArray, ">", giCmpArray
 printarray iResult, "%d", "Array > CmpArray?"
endin

</CsInstruments>
<CsScore>
i "Compare" 0 1
</CsScore>
</CsoundSynthesizer>
;example by eduardo moguillansky and joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "03 E. ARRAYS".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/03-e-arrays.md](../chapters/03-e-arrays.md)
