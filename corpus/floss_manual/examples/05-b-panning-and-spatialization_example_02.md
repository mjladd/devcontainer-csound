# 05 B. PANNING AND SPATIALIZATION - Code Example 3

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 05-b-panning-and-spatialization
- **Section:** Simple Stereo Panning
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `05`

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

  instr 1
imethod        =         p4 ; read panning method variable from score (p4)
;----------------------- generate a source sound ------------------------
aSig           pinkish   0.1              ; pink noise
aSig           reson     aSig, 500, 30, 2 ; bandpass filtered
;------------------------------------------------------------------------

;---------------------------- pan the signal ----------------------------
aPan           lfo       0.5, 1/2, 1      ; panning controlled by an lfo
aPan           =         aPan + 0.5       ; DC shifted + 0.5
aSigL, aSigR   pan2      aSig, aPan, imethod; create stereo panned output
;------------------------------------------------------------------------

               outs      aSigL, aSigR     ; audio sent to outputs
  endin

</CsInstruments>

<CsScore>
; 3 notes one after the other to demonstrate 3 methods used by pan2
;p1 p2  p3   p4
i 1  0  4.5   0 ; equal power (harmonic)
i 1  5  4.5   1 ; square root method
i 1 10  4.5   2 ; linear
e
</CsScore>
</CsoundSynthesizer>
;example by Iain McCurdy
```

---

## Context

This code example is from the FLOSS Manual chapter "05 B. PANNING AND SPATIALIZATION".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/05-b-panning-and-spatialization.md](../chapters/05-b-panning-and-spatialization.md)
