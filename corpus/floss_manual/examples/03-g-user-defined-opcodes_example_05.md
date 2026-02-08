# 03 G. USER DEFINED OPCODES - Code Example 6

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 03-g-user-defined-opcodes
- **Section:** Default Arguments
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

  opcode Defaults, iii, opj
ia, ib, ic xin
xout ia, ib, ic
  endop

instr 1
ia, ib, ic Defaults
           print     ia, ib, ic
ia, ib, ic Defaults  10
           print     ia, ib, ic
ia, ib, ic Defaults  10, 100
           print     ia, ib, ic
ia, ib, ic Defaults  10, 100, 1000
           print     ia, ib, ic
endin

</CsInstruments>
<CsScore>
i 1 0 0
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "03 G. USER DEFINED OPCODES".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/03-g-user-defined-opcodes.md](../chapters/03-g-user-defined-opcodes.md)
