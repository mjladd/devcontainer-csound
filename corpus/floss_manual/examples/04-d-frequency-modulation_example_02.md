# 04 D. FREQUENCY MODULATION - Code Example 3

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 04-d-frequency-modulation
- **Section:** Index of Modulation
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

instr Rising_index
 kModAmp = 400
 kIndex linseg 3, p3, 8
 kModFreq = kModAmp/kIndex
 aModulator poscil kModAmp, kModFreq
 aCarrier poscil 0.3, 400 + aModulator
 aOut linen aCarrier, .1, p3, 1
 out aOut, aOut
endin

</CsInstruments>
<CsScore>
i "Rising_index" 0 10
</CsScore>
</CsoundSynthesizer>
;example by marijana janevska and joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "04 D. FREQUENCY MODULATION".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/04-d-frequency-modulation.md](../chapters/04-d-frequency-modulation.md)
