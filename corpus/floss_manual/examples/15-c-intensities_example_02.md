# 15 C. INTENSITIES - Code Example 3

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 15-c-intensities
- **Section:** Fletcher-Munson Curves
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

instr 1
 kfreq     expseg    p4, p3, p5
           printk    1, kfreq ;prints the frequencies once a second
 asin      poscil    .2, kfreq
 aout      linen     asin, .01, p3, .01
           outs      aout, aout
endin
</CsInstruments>
<CsScore>
i 1 0 5 1000 1000
i 1 6 20 20  20000
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "15 C. INTENSITIES".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/15-c-intensities.md](../chapters/15-c-intensities.md)
