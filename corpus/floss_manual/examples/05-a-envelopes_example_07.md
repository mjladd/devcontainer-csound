# 05 A. ENVELOPES - Code Example 8

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 05-a-envelopes
- **Section:** expon and expseg
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

  instr 1 ; line envelope
aEnv     line     1, p3, 0
aSig     poscil   aEnv, 500
         out      aSig, aSig
  endin

  instr 2 ; expon envelope
aEnv     expon    1, p3, 0.0001
aSig     poscil   aEnv, 500
         out      aSig, aSig
  endin

</CsInstruments>
<CsScore>
i 1 0 2 ; line envelope
i 2 2 2 ; expon envelope
</CsScore>
</CsoundSynthesizer>
;example by Iain McCurdy
```

---

## Context

This code example is from the FLOSS Manual chapter "05 A. ENVELOPES".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/05-a-envelopes.md](../chapters/05-a-envelopes.md)
