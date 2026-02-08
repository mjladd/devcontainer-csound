# 05 A. ENVELOPES - Code Example 9

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

  instr 1; expon envelope
iEndVal  =        p4 ; variable 'iEndVal' retrieved from score
aEnv     expon    1, p3, iEndVal
aSig     poscil   aEnv, 500
         out      aSig, aSig
  endin

</CsInstruments>
<CsScore>
;p1  p2 p3 p4
i 1  0  1  0.001
i 1  1  1  0.000001
i 1  2  1  0.000000000000001
e
</CsScore>
</CsoundSynthesizer>
;example by Iain McCurdy
```

---

## Context

This code example is from the FLOSS Manual chapter "05 A. ENVELOPES".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/05-a-envelopes.md](../chapters/05-a-envelopes.md)
