# HOW TO: HARDWARE - Code Example 2

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 02-c-hardware
- **Section:** How can I use a MIDI controller with plain Csound?
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `02`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
//it might be necessary to add -Ma here if you use plain Csound
-odac
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 1

instr 1
  //receive controller number 1 on channel 1 and scale from 220 to 440
  kFreq = ctrl7(1, 1, 220, 440)
  //use this value as varying frequency for a sine wave
  aOut = poscil:a(0.2, kFreq)
  //output
  outall(aOut)´
endin

</CsInstruments>
<CsScore>
i 1 0 60
</CsScore>
</CsoundSynthesizer>
;Example by Andrés Cabrera
```

---

## Context

This code example is from the FLOSS Manual chapter "HOW TO: HARDWARE".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/02-c-hardware.md](../chapters/02-c-hardware.md)
