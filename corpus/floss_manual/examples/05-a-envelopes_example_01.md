# 05 A. ENVELOPES - Code Example 2

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 05-a-envelopes
- **Section:** line
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
aEnv     line     0.5, 2, 0         ; amplitude envelope
aSig     poscil   aEnv, 500         ; audio oscillator
         out      aSig, aSig        ; audio sent to output
  endin

</CsInstruments>
<CsScore>
i 1 0 2 ; instrument 1 plays a note for 2 seconds
</CsScore>
</CsoundSynthesizer>
;example by Iain McCurdy
```

---

## Context

This code example is from the FLOSS Manual chapter "05 A. ENVELOPES".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/05-a-envelopes.md](../chapters/05-a-envelopes.md)
