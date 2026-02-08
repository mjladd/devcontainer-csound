# 04 D. FREQUENCY MODULATION - Code Example 7

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

instr serial_MM_FM
 kAmpMod2 randomi 200, 1400, .5
 aModulator2 poscil kAmpMod2, 700
 kAmpMod1 linseg 400, 15, 1800
 aModulator1 poscil kAmpMod1, 290+aModulator2
 aCarrier poscil 0.2, 440+aModulator1
 outs aCarrier, aCarrier
endin

</CsInstruments>
<CsScore>
i "serial_MM_FM" 0 20
</CsScore>
</CsoundSynthesizer>
;example by Alex Hofmann and Marijana Janevska
```

---

## Context

This code example is from the FLOSS Manual chapter "04 D. FREQUENCY MODULATION".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/04-d-frequency-modulation.md](../chapters/04-d-frequency-modulation.md)
