# 03 A. INITIALIZATION AND PERFORMANCE PASS - Code Example 21

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
-nm0
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

instr 1

 ;k-variables
 k_var init 20
 k_var linseg 10, 1, 0

 ;string variables
 S_var init "goodbye"
 S_var strcpyk "world"

 ;print out at init-time
 prints "k_var -> %d\n", k_var
 printf_i "S_var -> %s\n", 1, S_var

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
