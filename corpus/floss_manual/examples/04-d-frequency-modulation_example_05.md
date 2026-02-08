# 04 D. FREQUENCY MODULATION - Code Example 6

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 04-d-frequency-modulation
- **Section:** Multiple Modulators (MM FM)
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
ksmps = 32
nchnls = 2
0dbfs = 1

instr parallel_MM_FM
 kAmpMod1 randomi 200, 500, 20
 aModulator1 poscil kAmpMod1, 700
 kAmpMod2 randomi 4, 10, 5
 kFreqMod2 randomi 7, 12, 2
 aModulator2 poscil kAmpMod2, kFreqMod2
 kFreqCar randomi 50, 80, 1, 3
 aCarrier poscil 0.2, kFreqCar+aModulator1+aModulator2
 out aCarrier, aCarrier
endin

</CsInstruments>
<CsScore>
i "parallel_MM_FM" 0 20
</CsScore>
</CsoundSynthesizer>
;example by Alex Hofmann and Marijana Janevska
```

---

## Context

This code example is from the FLOSS Manual chapter "04 D. FREQUENCY MODULATION".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/04-d-frequency-modulation.md](../chapters/04-d-frequency-modulation.md)
