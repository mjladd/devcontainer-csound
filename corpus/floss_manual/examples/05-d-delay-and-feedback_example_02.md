# 05 D. DELAY AND FEEDBACK - Code Example 3

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
-odac
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

  instr 1
kEnv    loopseg  0.5,0,0,0,0.0005,1,0.1,0,1.9,0,0
kCps    randomh  400, 600, 0.5
aSig    poscil   a(kEnv), kCps

iFdback =        0.7           ; feedback ratio
aDelay  init     0             ; initialize delayed signal
aDelay  delay    aSig+(aDelay*iFdback), .3 ;delay 0.3 seconds

aOut    =        aSig + (aDelay*0.4)
        out      aOut/2, aOut/2
  endin

</CsInstruments>
<CsScore>
i 1 0 25
</CsScore>
</CsoundSynthesizer>
;example by Iain McCurdy and joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "05 D. DELAY AND FEEDBACK".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/05-d-delay-and-feedback.md](../chapters/05-d-delay-and-feedback.md)
