# 15 A. DIGITAL AUDIO - Code Example 1

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 15-a-digital-audio
- **Section:** Aliasing
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

//wave form with harmonics 1, 11 and 22
giHarmonics ftgen 0, 0, 8192, 9, 1,.1,0, 11,.1,0, 22,1,0

instr 1
 asig poscil .1, p4
 out asig, asig
endin

instr 2
 asig poscil .2, p4, giHarmonics
 out asig, asig
endin

</CsInstruments>
<CsScore>
i 1 0 2 1000 ;1000 Hz sine
i 1 3 2 43100 ;43100 Hz sine sounds like 1000 Hz because of aliasing
i 2 6 4 1990 ;1990 Hz with harmonics 1, 11 and 22
             ;results in 1990*22=43780 Hz so aliased 320 Hz
             ;for the highest harmonic
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "15 A. DIGITAL AUDIO".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/15-a-digital-audio.md](../chapters/15-a-digital-audio.md)
