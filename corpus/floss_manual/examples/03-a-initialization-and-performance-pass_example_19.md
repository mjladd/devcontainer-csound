# 03 A. INITIALIZATION AND PERFORMANCE PASS - Code Example 20

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 03-a-initialization-and-performance-pass
- **Section:** Hidden Initialization of k- and S-Variables
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `03`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

instr 1

 ;explicit initialization
 k_Exp init 10
 S_Exp init "goodbye"

 ;implicit initialization
 k_Imp linseg 10, 1, 0
 S_Imp strcpyk "world"

 ;print out at init-time
 prints "k_Exp -> %d\n", k_Exp
 printf_i "S_Exp -> %s\n", 1, S_Exp
 prints "k_Imp -> %d\n", k_Imp
 printf_i "S_Imp -> %s\n", 1, S_Imp

endin

</CsInstruments>
<CsScore>
i 1 0 1
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "03 A. INITIALIZATION AND PERFORMANCE PASS".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/03-a-initialization-and-performance-pass.md](../chapters/03-a-initialization-and-performance-pass.md)
