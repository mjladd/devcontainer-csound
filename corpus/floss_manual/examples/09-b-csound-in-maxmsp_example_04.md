# 09 B. CSOUND IN MAXMSP - Code Example 5

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 09-b-csound-in-maxmsp
- **Section:** Events
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

instr 1
  iDur = p3
  iCps = cpsmidinn(p4)
 iMeth = 1
       print iDur, iCps, iMeth
aPluck pluck .2, iCps, iCps, 0, iMeth
       outch 1, aPluck, 2, aPluck
endin
</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
;example by Davis Pyon
```

---

## Context

This code example is from the FLOSS Manual chapter "09 B. CSOUND IN MAXMSP".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/09-b-csound-in-maxmsp.md](../chapters/09-b-csound-in-maxmsp.md)
