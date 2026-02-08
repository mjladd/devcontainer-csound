# 03 D. FUNCTION TABLES - Code Example 9

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 03-d-function-tables
- **Section:** i-Rate Example
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

giFt ftgen 0, 0, 12, 2, 0

instr 1; calculates first 12 fibonacci values and writes them to giFt
 istart = 1
 inext =	 2
 indx = 0
 while indx < 12 do
  tableiw istart, indx, giFt ;writes istart to table
  istartold = istart ;keep previous value of istart
  istart = inext ;reset istart for next loop
  inext = istartold + inext ;reset inext for next loop
  indx += 1
 od
endin

instr 2; prints the values of the table
 prints "%nContent of Function Table:%n"
 indx init 0
 while indx < 12 do
  ival table indx, giFt
  prints "Index %d = %f%n", indx, ival
  indx += 1
 od
  endin

</CsInstruments>
<CsScore>
i 1 0 0
i 2 0 0
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "03 D. FUNCTION TABLES".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/03-d-function-tables.md](../chapters/03-d-function-tables.md)
