# 15 B. PITCH AND FREQUENCY - Code Example 2

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 15-b-pitch-and-frequency
- **Section:** Upper and Lower Limits of Hearing
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `15`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-odac -m0
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

instr 1
 prints  "Playing %d Hertz!\n", p4
 asig    poscil  .2, p4
 outs    asig, asig
endin

</CsInstruments>
<CsScore>
i 1 0 2 10
i . + . 100
i . + . 1000
i . + . 10000
i . + . 20000
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "15 B. PITCH AND FREQUENCY".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/15-b-pitch-and-frequency.md](../chapters/15-b-pitch-and-frequency.md)
