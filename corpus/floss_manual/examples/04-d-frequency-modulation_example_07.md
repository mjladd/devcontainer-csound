# 04 D. FREQUENCY MODULATION - Code Example 8

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 04-d-frequency-modulation
- **Section:** Multiple Carriers (MC FM)
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

instr FM_two_carriers
 aModulator poscil 100, randomi:k(10,15,1,3)
 aCarrier1 poscil 0.3, 700 + aModulator
 aCarrier2 poscil 0.1, 701 + aModulator
 outs aCarrier1+aCarrier2, aCarrier1+aCarrier2
endin

</CsInstruments>
<CsScore>
i "FM_two_carriers" 0 20
</CsScore>
</CsoundSynthesizer>
;example by Marijana Janevska
```

---

## Context

This code example is from the FLOSS Manual chapter "04 D. FREQUENCY MODULATION".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/04-d-frequency-modulation.md](../chapters/04-d-frequency-modulation.md)
