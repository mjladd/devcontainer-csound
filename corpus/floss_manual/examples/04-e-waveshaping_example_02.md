# 04 E. WAVESHAPING - Code Example 3

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 04-e-waveshaping
- **Section:** Distort
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `04`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-dm0 -odac
</CsOptions>

<CsInstruments>

sr = 44100
ksmps =32
nchnls = 1
0dbfs = 1

giSine  ftgen   1,0,1025,10,1           ; sine function
giTanh  ftgen   2,0,257,"tanh",-10,10,0 ; tanh function

instr 1
 aSig  poscil   1, 200, giSine          ; a sine wave
 kAmt  line     0, p3, 1                ; rising distortion amount
 aDst  distort  aSig, kAmt, giTanh      ; distort the sine tone
       out      aDst*0.1
endin

</CsInstruments>
<CsScore>
i 1 0 4
</CsScore>
</CsoundSynthesizer>
;example by Iain McCurdy
```

---

## Context

This code example is from the FLOSS Manual chapter "04 E. WAVESHAPING".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/04-e-waveshaping.md](../chapters/04-e-waveshaping.md)
