# 07 C. WORKING WITH CONTROLLERS - Code Example 4

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 07-c-working-with-controllers
- **Section:** Smoothing 7-bit Quantisation in MIDI Controllers
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `07`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-Ma -odac
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 1
0dbfs = 1

giSine   ftgen    0,0,2^12,10,1
         initc7   1,1,1          ;initialize CC 1 to its max. level

  instr 1
iCps      cpsmidi                ;read in midi pitch in cycles-per-second
iAmp      ampmidi 1              ;read in note velocity - re-range 0 to 1
kVol      ctrl7   1,1,0,1        ;read in CC 1, chan. 1. Re-range from 0 to 1
kPortTime linseg 0,0.001,0.01    ;create a value that quickly ramps up to .01
kVol      portk   kVol,kPortTime ;create a filtered version of kVol
aVol      interp  kVol           ;create an a-rate version of kVol
aSig      poscil  iAmp*aVol,iCps,giSine
          out     aSig
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
