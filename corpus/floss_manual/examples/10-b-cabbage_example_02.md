# 10 B. CABBAGE - Code Example 3

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 10-b-cabbage
- **Section:** Getting started
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `10`

---

## Code

```csound
<Cabbage>
form caption("Untitled") size(400, 300), \
  colour(58, 110, 182), \
  pluginID("def1")
keyboard bounds(8, 158, 381, 95)
</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-+rtmidi=NULL -M0 -m0d --midi-key-cps=4 --midi-velocity-amp=5
</CsOptions>
<CsInstruments>
; Initialize the global variables.
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

;instrument will be triggered by keyboard widget
instr 1
 iFreq = p4
 iAmp = p5
 aOut vco2 iAmp, iFreq
 outs aOut, aOut
endin

</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...
f0 z
</CsScore>
</CsoundSynthesizer>
```

---

## Context

This code example is from the FLOSS Manual chapter "10 B. CABBAGE".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/10-b-cabbage.md](../chapters/10-b-cabbage.md)
