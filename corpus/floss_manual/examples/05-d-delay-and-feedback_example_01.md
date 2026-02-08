# 05 D. DELAY AND FEEDBACK - Code Example 2

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 05-d-delay-and-feedback
- **Section:** Delay with Feedback
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `05`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-odac ;activates real time sound output
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

  instr 1
; -- create an input signal: short 'blip' sounds --
kEnv    loopseg  0.5,0,0,0,0.0005,1,0.1,0,1.9,0,0 ; repeating envelope
kCps    randomh  400, 600, 0.5                    ; 'held' random values
aEnv    interp   kEnv                             ; a-rate envelope
aSig    poscil   aEnv, kCps                       ; generate audio

; -- create a delay buffer --
iFdback =        0.7                    ; feedback ratio
aBufOut delayr   0.3                    ; read audio from end of buffer
; write audio into buffer (mix in feedback signal)
        delayw   aSig+(aBufOut*iFdback)

; send audio to output (mix the input signal with the delayed signal)
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
