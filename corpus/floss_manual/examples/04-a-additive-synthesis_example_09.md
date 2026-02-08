# 04 A. ADDITIVE SYNTHESIS - Code Example 10

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 04-a-additive-synthesis
- **Section:** gbuzz, buzz and GEN11
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `04`

---

## Code

```csound
<CsoundSynthesizer>

<CsOptions>
-o dac
</CsOptions>

<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

; a cosine wave
gicos ftgen 0, 0, 2^10, 11, 1

 instr 1
knh  line  1, p3, 20  ; number of harmonics
klh  =     1          ; lowest harmonic
kmul =     1          ; amplitude coefficient multiplier
asig gbuzz 1, 100, knh, klh, kmul, gicos
     outs  asig, asig
 endin

</CsInstruments>

<CsScore>
i 1 0 8
e
</CsScore>

</CsoundSynthesizer>
;example by Iain McCurdy
```

---

## Context

This code example is from the FLOSS Manual chapter "04 A. ADDITIVE SYNTHESIS".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/04-a-additive-synthesis.md](../chapters/04-a-additive-synthesis.md)
