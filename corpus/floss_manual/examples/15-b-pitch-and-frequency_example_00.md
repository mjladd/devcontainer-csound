# 15 B. PITCH AND FREQUENCY - Code Example 1

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 15-b-pitch-and-frequency
- **Section:** Periodic and Nonperiodic Sounds
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `15`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-o dac
</CsOptions>
<CsInstruments>

sr = 44100
nchnls = 2
0dbfs = 1
ksmps = 32

instr SineToNoise
 kMinFreq = expseg:k(1000, p3*1/5, 1000, p3*3/5, 20, p3*1/5, 20)
 kMaxFreq = expseg:k(1000, p3*1/5, 1000, p3*3/5, 20000, p3*1/5, 20000)
 kRndFreq = expseg:k(1, p3*1/5, 1, p3*3/5, 10000, p3*1/5, 10000)
 aFreq = randomi:a(kMinFreq, kMaxFreq, kRndFreq)
 aSine = poscil:a(.1, aFreq)
 aOut = linen:a(aSine, .5, p3, 1)
 out(aOut, aOut)
endin

instr NoiseToSine
 aNoise = rand:a(.1, 2, 1)
 kBw = expseg:k(10000, p3*1/5, 10000, p3*3/5, .1, p3*1/5, .1)
 aFilt = reson:a(aNoise, 1000, kBw, 2)
 aOut = linen:a(aFilt, .5, p3, 1)
 out(aOut, aOut)
endin

</CsInstruments>
<CsScore>
i "SineToNoise" 0 10
i "NoiseToSine" 11 10
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "15 B. PITCH AND FREQUENCY".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/15-b-pitch-and-frequency.md](../chapters/15-b-pitch-and-frequency.md)
