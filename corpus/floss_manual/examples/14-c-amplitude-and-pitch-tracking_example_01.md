# 14 C. AMPLITUDE AND PITCH TRACKING - Code Example 2

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 14-c-amplitude-and-pitch-tracking
- **Section:** Dynamic Gating and Amplitude Triggering
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `14`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-dm128 -odac
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1
; this is a necessary definition,
;         otherwise amplitude will be -32768 to 32767

instr    1
 aSig    diskin  "fox.wav", 1        ; read sound file
 kRms    rms     aSig                ; scan rms
 iThreshold =    0.1                 ; rms threshold
 kGate   =       kRms > iThreshold ? 1 : 0  ; gate either 1 or zero
 aGate   interp  kGate ; interpolate to create smoother on->off->on switching
 aSig    =       aSig * aGate        ; multiply signal by gate
         out     aSig, aSig          ; send to output
endin

</CsInstruments>
<CsScore>
i 1 0 10
</CsScore>
</CsoundSynthesizer>
;example by Iain McCurdy
```

---

## Context

This code example is from the FLOSS Manual chapter "14 C. AMPLITUDE AND PITCH TRACKING".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/14-c-amplitude-and-pitch-tracking.md](../chapters/14-c-amplitude-and-pitch-tracking.md)
