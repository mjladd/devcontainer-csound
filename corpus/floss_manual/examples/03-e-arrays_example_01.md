# 03 E. ARRAYS - Code Example 2

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 03-e-arrays
- **Section:** _i_- and _k_-Rate
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `03`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-nm128 ;no sound and reduced messages
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 4410 ;10 k-cycles per second

instr 1
iArr[] fillarray 1, 2, 3
iArr[0] = iArr[0] + 10
prints "   iArr[0] = %d\n\n", iArr[0]
endin

instr 2
kArr[] fillarray 1, 2, 3
kArr[0] = kArr[0] + 10
printks "   kArr[0] = %d\n", 0, kArr[0]
endin

</CsInstruments>
<CsScore>
i 1 0 1
i 2 1 1
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "03 E. ARRAYS".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/03-e-arrays.md](../chapters/03-e-arrays.md)
