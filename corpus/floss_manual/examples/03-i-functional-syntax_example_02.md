# 03 I. FUNCTIONAL SYNTAX - Code Example 3

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 03-i-functional-syntax
- **Section:** 03 I. FUNCTIONAL SYNTAX
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `03`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>
sr = 44100
nchnls = 1
ksmps = 32
0dbfs = 1

instr 1
out(poscil(linseg(0,p3/2,.2,p3/2,0),expseg(400,p3/2,800,p3/2,600)))
endin

</CsInstruments>
<CsScore>
i 1 0 5
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "03 I. FUNCTIONAL SYNTAX".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/03-i-functional-syntax.md](../chapters/03-i-functional-syntax.md)
