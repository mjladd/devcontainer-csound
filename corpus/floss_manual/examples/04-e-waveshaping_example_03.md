# 04 E. WAVESHAPING - Code Example 4

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
0dbfs =    1

giSine    ftgen    1,0,1025,10,1
giTanh    ftgen   2,0,257,"tanh",-10,10,0

instr 1
 kAmt  line     0, p3, 1                 ; rising distortion amount
 aSig  poscil   1, 200, giSine           ; a sine
 aSig2 poscil   kAmt*0.8,400,giSine      ; a sine an octave above
 aDst  distort  aSig+aSig2, kAmt, giTanh ; distort a mixture of the two sines
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
