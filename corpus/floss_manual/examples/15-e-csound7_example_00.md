# 15 E. NEW FEATURES IN CSOUND 7 - Code Example 1

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 15-e-csound7
- **Section:** Variable Names
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `15`

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

instr Locals

  freq:i = 500
  amp:i = 0.2

  sine:a = poscil(amp,freq)
  outall(sine)

endin

instr Globals

  dry@global:a init 0

  dry += diskin:a("fox.wav") / 3
  dry += pinkish(.05)

  schedule(GlobalsReverb,0,p3+3)

endin

instr GlobalsReverb

  wet:a = reverb2(dry,2,.5)
  outall(dry/5+wet/2)
  dry = 0

endin

</CsInstruments>
<CsScore>
i 1 0 2
i 2 3 3
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "15 E. NEW FEATURES IN CSOUND 7".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/15-e-csound7.md](../chapters/15-e-csound7.md)
