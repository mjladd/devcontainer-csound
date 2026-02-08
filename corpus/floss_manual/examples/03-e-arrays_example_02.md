# 03 E. ARRAYS - Code Example 3

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 03-e-arrays
- **Section:** Audio Arrays
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `03`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

instr AudioArray
 aArr[]  init    2
 aArr[0] poscil  .2, 400
 aArr[1] poscil  .2, 500
 aEnv    transeg 1, p3, -3, 0
         out     aArr*aEnv
endin

</CsInstruments>
<CsScore>
i "AudioArray" 0 3
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "03 E. ARRAYS".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/03-e-arrays.md](../chapters/03-e-arrays.md)
