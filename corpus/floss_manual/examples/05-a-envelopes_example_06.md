# 05 A. ENVELOPES - Code Example 7

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 05-a-envelopes
- **Section:** Different behaviour in linear continuation
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `05`

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

  instr 1 ; linseg envelope
aEnv     linseg   0.2, 2, 0      ; linseg holds its last value
aSig     poscil   aEnv, 500
         out      aSig, aSig
  endin

  instr 2 ; line envelope
aEnv     line     0.2, 2, 0      ; line continues its trajectory
aSig     poscil   aEnv, 500
         out      aSig
  endin

</CsInstruments>
<CsScore>
i 1 0 4 ; linseg envelope
i 2 5 4 ; line envelope
</CsScore>
</CsoundSynthesizer>
;example by Iain McCurdy and joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "05 A. ENVELOPES".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/05-a-envelopes.md](../chapters/05-a-envelopes.md)
