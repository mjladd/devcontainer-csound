# 09 B. CSOUND IN MAXMSP - Code Example 2

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 09-b-csound-in-maxmsp
- **Section:** Audio I/O
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `09`

---

## Code

```csound
<CsoundSynthesizer>
<CsInstruments>
sr     = 44100
ksmps  = 32
nchnls = 3
0dbfs  = 1

instr 1
aTri1 inch 1
aTri2 inch 2
aTri3 inch 3
aMix  = (aTri1 + aTri2 + aTri3) * .2
      outch 1, aMix, 2, aMix
endin

</CsInstruments>
<CsScore>
f0 86400
i1 0 86400
e
</CsScore>
</CsoundSynthesizer>
;example by Davis Pyon
```

---

## Context

This code example is from the FLOSS Manual chapter "09 B. CSOUND IN MAXMSP".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/09-b-csound-in-maxmsp.md](../chapters/09-b-csound-in-maxmsp.md)
