# 03 A. INITIALIZATION AND PERFORMANCE PASS - Code Example 5

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 03-a-initialization-and-performance-pass
- **Section:** A Look at the Audio Vector
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `03`

---

## Code

```csound
<CsoundSynthesizer>
<CsInstruments>
sr = 44100
ksmps = 5
0dbfs = 1

instr 1
aSine      poscil     1, 2205
kVec1      vaget      0, aSine
kVec2      vaget      1, aSine
kVec3      vaget      2, aSine
kVec4      vaget      3, aSine
kVec5      vaget      4, aSine
printks "kVec1 = %f, kVec2 = %f, kVec3 = %f, kVec4 = %f, kVec5 = %f\n",
        0, kVec1, kVec2, kVec3, kVec4, kVec5
endin
</CsInstruments>
<CsScore>
i 1 0 [1/2205]
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "03 A. INITIALIZATION AND PERFORMANCE PASS".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/03-a-initialization-and-performance-pass.md](../chapters/03-a-initialization-and-performance-pass.md)
