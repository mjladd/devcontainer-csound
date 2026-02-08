# 05 Hello MIDI Keys - Code Example 2

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 01-GS-05
- **Section:** Example
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `01`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-o dac
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 1

instr Hello
  kAmp = linseg:k(0.3,0.5,0.1)
  kMidi = linseg:k(72,0.5,68)
  kFreq = mtof:k(kMidi)
  aSine = poscil:a(kAmp,kFreq)
  aOut = linen:a(aSine,0,p3,1)
  outall(aOut)
endin

</CsInstruments>
<CsScore>
i "Hello" 0 2
</CsScore>
</CsoundSynthesizer>
```

---

## Context

This code example is from the FLOSS Manual chapter "05 Hello MIDI Keys".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/01-GS-05.md](../chapters/01-GS-05.md)
