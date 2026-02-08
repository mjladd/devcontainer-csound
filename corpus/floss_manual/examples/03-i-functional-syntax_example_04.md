# 03 I. FUNCTIONAL SYNTAX - Code Example 5

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 03-i-functional-syntax
- **Section:** Declare your color: i, k or a?
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
out(poscil:a(linseg:k(0, p3/2, 1, p3/2, 0),
             expseg:k(400, p3/2, random:i(700, 1400), p3/2, 600)))
endin

</CsInstruments>
<CsScore>
r 5
i 1 0 3
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "03 I. FUNCTIONAL SYNTAX".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/03-i-functional-syntax.md](../chapters/03-i-functional-syntax.md)
