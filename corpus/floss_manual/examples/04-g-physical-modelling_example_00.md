# 04 G. PHYSICAL MODELLING - Code Example 1

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 04-g-physical-modelling
- **Section:** The Mass-Spring Model
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `04`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-n ;no sound
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 8820 ;5 steps per second

instr PrintVals
 ;initial values
 kstep init 0
 k0 init 0
 k1 init 0.5
 kc init 0.4
 ;calculation of the next value
 k2 = k1 + (k1 - k0) - kc * k1
 printks "Sample=%d: k0 = %.3f, k1 = %.3f, k2 = %.3f\n", 0, kstep, k0, k1, k2
 ;actualize values for the next step
 kstep = kstep+1
 k0 = k1
 k1 = k2
endin

</CsInstruments>
<CsScore>
i "PrintVals" 0 10
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "04 G. PHYSICAL MODELLING".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/04-g-physical-modelling.md](../chapters/04-g-physical-modelling.md)
