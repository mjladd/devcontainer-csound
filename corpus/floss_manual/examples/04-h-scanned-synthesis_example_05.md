# 04 H. SCANNED SYNTHESIS - Code Example 6

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 04-h-scanned-synthesis
- **Section:** Scan Trajectories
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
sr=44100
ksmps=32
nchnls=2
0dbfs=1

instr 1
andx phasor 440
andx table andx*8192, 2  ; read the table out of order!
aOut table andx*8192, 1
outs aOut*.2, aOut*.2
endin
</CsInstruments>
<CsScore>
f1 0 8192 10 1
f2 0 8192 -5 .001 8192 1;
i 1 0 4
</CsScore>
</CsoundSynthesizer>
;example by Christopher Saunders
```

---

## Context

This code example is from the FLOSS Manual chapter "04 H. SCANNED SYNTHESIS".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/04-h-scanned-synthesis.md](../chapters/04-h-scanned-synthesis.md)
