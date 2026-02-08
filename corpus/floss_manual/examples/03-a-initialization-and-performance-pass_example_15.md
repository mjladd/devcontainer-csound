# 03 A. INITIALIZATION AND PERFORMANCE PASS - Code Example 16

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 03-a-initialization-and-performance-pass
- **Section:** About _i-time_ and _k-rate_ Opcodes
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
0dbfs = 1
nchnls = 2

          seed      0 ;each time different seed
giSine    ftgen     0, 0, 2^10, 10, 1 ;sine table

instr 1 ;i-rate random
iPch      random    300, 600
aAmp      linseg    .5, p3, 0
aSine     poscil    aAmp, iPch, giSine
          outs      aSine, aSine
endin

instr 2 ;k-rate random: noisy
kPch      random    300, 600
aAmp      linseg    .5, p3, 0
aSine     poscil    aAmp, kPch, giSine
          outs      aSine, aSine
endin

instr 3 ;k-rate random with interpolation: sliding pitch
kPch      randomi   300, 600, 3
aAmp      linseg    .5, p3, 0
aSine     poscil    aAmp, kPch, giSine
          outs      aSine, aSine
endin

instr 4 ;a-rate random: white noise
aNoise    random    -.1, .1
          outs      aNoise, aNoise
endin

</CsInstruments>
<CsScore>
i 1 0   .5
i 1 .25 .5
i 1 .5  .5
i 1 .75 .5
i 2 2   1
i 3 4   2
i 3 5   2
i 3 6   2
i 4 9   1
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "03 A. INITIALIZATION AND PERFORMANCE PASS".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/03-a-initialization-and-performance-pass.md](../chapters/03-a-initialization-and-performance-pass.md)
