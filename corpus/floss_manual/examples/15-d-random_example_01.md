# 15 D. RANDOM - Code Example 2

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 15-d-random
- **Section:** Uniform Distribution and Seed
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `15`

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

instr white_noise
iBit       =          p4 ;0 = 16 bit, 1 = 31 bit
 ;input of rand: amplitude, fixed seed (0.5), bit size
aNoise     rand       .1, 0.5, iBit
           outs       aNoise, aNoise
endin

</CsInstruments>
<CsScore>
i "white_noise" 0 10 0
i "white_noise" 11 10 1
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "15 D. RANDOM".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/15-d-random.md](../chapters/15-d-random.md)
