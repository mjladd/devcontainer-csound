# 15 C. INTENSITIES - Code Example 1

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 15-c-intensities
- **Section:** dB Scale Versus Linear Amplitude
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `15`

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

instr 1 ;linear amplitude rise
kamp      line    0, p3, 1     ;amp rise 0->1
asig      poscil  1, 1000      ;1000 Hz sine
aout      =       asig * kamp
          outs    aout, aout
endin

instr 2 ;linear rise of dB
kdb       line    -80, p3, 0   ;dB rise -80 -> 0
asig      poscil  1, 1000      ;1000 Hz sine
kamp      =       ampdb(kdb)   ;transformation db -> amp
aout      =       asig * kamp
          outs    aout, aout
endin

</CsInstruments>
<CsScore>
i 1 0 10
i 2 11 10
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "15 C. INTENSITIES".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/15-c-intensities.md](../chapters/15-c-intensities.md)
