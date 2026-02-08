# 03 D. FUNCTION TABLES - Code Example 1

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 03-d-function-tables
- **Section:** GEN02 and General Parameters for GEN Routines
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `03`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-nm0
</CsOptions>
<CsInstruments>
instr 1 ;prints the values of table 1 or 2
 prints "%nFunction Table %d:%n", p4
 indx init 0
 while indx < 7 do
  ival table indx, p4
  prints "Index %d = %f%n", indx, ival
  indx += 1
 od
endin
</CsInstruments>
<CsScore>
f 1 0 -7 -2 1.1 2.2 3.3 5.5 8.8 13.13 21.21; not normalized
f 2 0 -7 2 1.1 2.2 3.3 5.5 8.8 13.13 21.21; normalized
i 1 0 0 1; prints function table 1
i 1 0 0 2; prints function table 2
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "03 D. FUNCTION TABLES".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/03-d-function-tables.md](../chapters/03-d-function-tables.md)
