# 04 C. AMPLITUDE AND RING MODULATION - Code Example 1

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 04-c-amplitude-and-ring-modulation
- **Section:** 04 C. AMPLITUDE AND RING MODULATION
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

instr 1
 aRaise expseg 2, 20, 100
 aModulator poscil 0.3, aRaise
 iDCOffset = 0.3
 aCarrier poscil iDCOffset+aModulator, 440
 out aCarrier, aCarrier
endin

</CsInstruments>
<CsScore>
i 1 0 25
</CsScore>
</CsoundSynthesizer>
; example by Alex Hofmann and joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "04 C. AMPLITUDE AND RING MODULATION".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/04-c-amplitude-and-ring-modulation.md](../chapters/04-c-amplitude-and-ring-modulation.md)
