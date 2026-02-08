# 03 B. LOCAL AND GLOBAL VARIABLES - Code Example 4

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 03-b-local-and-global-variables
- **Section:** Introductory Examples
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
ksmps = 32
nchnls = 2
0dbfs = 1

  instr 1; produces a 400 Hz sine
gaSig     oscils    .1, 400, 0
  endin

  instr 2; outputs gaSig
          outs      gaSig, gaSig
  endin

</CsInstruments>
<CsScore>
i 1 0 3
i 2 0 3
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "03 B. LOCAL AND GLOBAL VARIABLES".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/03-b-local-and-global-variables.md](../chapters/03-b-local-and-global-variables.md)
