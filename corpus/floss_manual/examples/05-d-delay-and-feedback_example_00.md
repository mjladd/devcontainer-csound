# 05 D. DELAY AND FEEDBACK - Code Example 1

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 05-d-delay-and-feedback
- **Section:** Basic Delay Line Read-Write Unit
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `05`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-odac ; activates real time sound output
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

  instr 1
; -- create an input signal: short 'blip' sounds --
kEnv    loopseg  0.5, 0, 0, 0,0.0005, 1 , 0.1, 0, 1.9, 0, 0
kCps    randomh  400, 600, 0.5
aEnv    interp   kEnv
aSig    poscil   aEnv, kCps

; -- create a delay buffer --
aBufOut delayr   0.3
        delayw   aSig

; -- send audio to output (input and output to the buffer are mixed)
aOut    =        aSig + (aBufOut*0.4)
        out      aOut/2, aOut/2
  endin

</CsInstruments>
<CsScore>
i 1 0 25
</CsScore>
</CsoundSynthesizer>
;example by Iain McCurdy
```

---

## Context

This code example is from the FLOSS Manual chapter "05 D. DELAY AND FEEDBACK".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/05-d-delay-and-feedback.md](../chapters/05-d-delay-and-feedback.md)
