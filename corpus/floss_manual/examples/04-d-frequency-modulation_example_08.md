# 04 D. FREQUENCY MODULATION - Code Example 9

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 04-d-frequency-modulation
- **Section:** The John Chowning FM Model of a Trumpet
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

instr simple_trumpet
 kCarFreq = 440
 kModFreq = 440
 kIndex = 5
 kIndexM = 0
 kMaxDev = kIndex*kModFreq
 kMinDev = kIndexM * kModFreq
 kVarDev = kMaxDev-kMinDev
 aEnv expseg .001, 0.2, 1, p3-0.3, 1, 0.2, 0.001
 aModAmp = kMinDev+kVarDev*aEnv
 aModulator poscil aModAmp, kModFreq
 aCarrier poscil 0.3*aEnv, kCarFreq+aModulator
 outs aCarrier, aCarrier
endin

</CsInstruments>
<CsScore>
i 1 0 2
</CsScore>
</CsoundSynthesizer>
;example by Alex Hofmann
```

---

## Context

This code example is from the FLOSS Manual chapter "04 D. FREQUENCY MODULATION".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/04-d-frequency-modulation.md](../chapters/04-d-frequency-modulation.md)
