# 05 A. ENVELOPES - Code Example 5

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 05-a-envelopes
- **Section:** linseg
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

  instr 1
; a more complex amplitude envelope:
;                 |-attack-|-decay--|---sustain---|-release-|
aEnv     linseg   0, 0.01, 1, 0.1,  0.1, p3-0.21, 0.1, 0.1, 0
aSig     poscil   aEnv, 500
         out      aSig, aSig
  endin

</CsInstruments>
<CsScore>
i 1 0 1
i 1 2 5
</CsScore>
</CsoundSynthesizer>
;example by Iain McCurdy
```

---

## Context

This code example is from the FLOSS Manual chapter "05 A. ENVELOPES".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/05-a-envelopes.md](../chapters/05-a-envelopes.md)
