# 09 B. CSOUND IN MAXMSP - Code Example 3

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 09-b-csound-in-maxmsp
- **Section:** Control Messages
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `09`

---

## Code

```csound
<CsoundSynthesizer>
<CsInstruments>
sr     = 44100
ksmps  = 32
nchnls = 2
0dbfs  = 1

giSine ftgen 1, 0, 16384, 10, 1 ; Generate a sine wave table.

instr 1
kPitch chnget "pitch"
kMod   invalue "mod"
aFM    foscil .2, cpsmidinn(kPitch), 2, kMod, 1.5, giSine
       outch 1, aFM, 2, aFM
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
