# 03 B. LOCAL AND GLOBAL VARIABLES - Code Example 7

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 03-b-local-and-global-variables
- **Section:** Adding Global Variables
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `03`

---

## Code

```csound
<CsoundSynthesizer>
<CsInstruments>
sr = 44100
ksmps = 4410; very high because of printing
nchnls = 2
0dbfs = 1

gkSum     init      0; sum is zero at init

  instr 1
gkAdd     =         1; control signal to add
  endin

  instr 2
gkSum     =         gkSum + gkAdd; new sum in each k-cycle
          printk    0, gkSum; print the sum
  endin

</CsInstruments>
<CsScore>
i 1 0 1
i 2 0 1
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "03 B. LOCAL AND GLOBAL VARIABLES".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/03-b-local-and-global-variables.md](../chapters/03-b-local-and-global-variables.md)
