# 04 G. PHYSICAL MODELLING - Code Example 2

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
-odac
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 1
nchnls = 2
0dbfs = 1

instr MassSpring
 ;initial values
 a0        init      0
 a1        init      0.05
 ic        =         0.01 ;spring constant
 ;calculation of the next value
 a2        =         a1+(a1-a0) - ic*a1
           outs      a0, a0
 ;actualize values for the next step
 a0        =         a1
 a1        =         a2
endin
</CsInstruments>
<CsScore>
i "MassSpring" 0 10
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz, after martin neukom
```

---

## Context

This code example is from the FLOSS Manual chapter "04 G. PHYSICAL MODELLING".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/04-g-physical-modelling.md](../chapters/04-g-physical-modelling.md)
