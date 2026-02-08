# 07 C. WORKING WITH CONTROLLERS - Code Example 3

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 07-c-working-with-controllers
- **Section:** Initialising MIDI Controllers
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `07`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-Ma -odac
; activate all midi inputs and real-time audio output
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 1
0dbfs = 1

giSine ftgen 0,0,2^12,10,1 ; a sine wave
initc7 1,1,1               ; initialize CC 1 on chan. 1 to its max level

  instr 1
iCps cpsmidi               ; read in midi pitch in cycles-per-second
iAmp ampmidi 1             ; read in key velocity. Rescale to be from 0 to 1
kVol ctrl7   1,1,0,1       ; read in CC 1, chan 1. Rescale to be from 0 to 1
aSig poscil  iAmp*kVol, iCps, giSine ; an audio oscillator
     out     aSig          ; send audio to output
  endin

</CsInstruments>
<CsScore>
</CsScore>
<CsoundSynthesizer>
;example by Iain McCurdy
```

---

## Context

This code example is from the FLOSS Manual chapter "07 C. WORKING WITH CONTROLLERS".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/07-c-working-with-controllers.md](../chapters/07-c-working-with-controllers.md)
