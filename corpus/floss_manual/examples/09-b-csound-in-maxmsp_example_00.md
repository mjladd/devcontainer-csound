# 09 B. CSOUND IN MAXMSP - Code Example 1

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 09-b-csound-in-maxmsp
- **Section:** Creating a _csound~_ Patch
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `09`

---

## Code

```csound
<CsoundSynthesizer>
<CsInstruments>
;Example by Davis Pyon
sr     = 44100
ksmps  = 32
nchnls = 2
0dbfs  = 1

instr 1
aNoise noise .1, 0
       outch 1, aNoise, 2, aNoise
endin

</CsInstruments>
<CsScore>
f0 86400
i1 0 86400
e
</CsScore>
</CsoundSynthesizer>
```

---

## Context

This code example is from the FLOSS Manual chapter "09 B. CSOUND IN MAXMSP".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/09-b-csound-in-maxmsp.md](../chapters/09-b-csound-in-maxmsp.md)
