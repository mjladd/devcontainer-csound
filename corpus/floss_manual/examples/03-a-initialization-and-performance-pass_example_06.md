# 03 A. INITIALIZATION AND PERFORMANCE PASS - Code Example 7

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 03-a-initialization-and-performance-pass
- **Section:** Accessing the Initialization Value of a k-Variable
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `03`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-o dac
</CsOptions>
<CsInstruments>
instr 1
gkLine line 0, p3, 1
endin
instr 2
iInstr2LineValue = i(gkLine)
print iInstr2LineValue
endin
instr 3
iInstr3LineValue = i(gkLine)
print iInstr3LineValue
endin
</CsInstruments>
<CsScore>
i 1 0 5
i 2 2 0
i 3 4 0
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "03 A. INITIALIZATION AND PERFORMANCE PASS".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/03-a-initialization-and-performance-pass.md](../chapters/03-a-initialization-and-performance-pass.md)
