# 05 G. GRANULAR SYNTHESIS - Code Example 1

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 05-g-granular-synthesis
- **Section:** The Grain Unit
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

instr Grain
 //input parameters
 Sound = "fox.wav"
 iStart = p4 ;position in sec to read the sound
 iSpeed = p5
 iVolume = -3 ;dB
 iPan = .5 ;0=left, 1=right
 //perform
 aSound = diskin:a(Sound,iSpeed,iStart,1)
 aOut = linen:a(aSound,p3/2,p3,p3/2)
 aL, aR pan2 aOut*ampdb(iVolume), iPan
 out(aL,aR)
endin

</CsInstruments>
<CsScore>
;              start speed
i "Grain" 0 .05 .05    1
i .       1 .   .2     .
i .       2 .   .42    .
i .       3 .   .78    .
i .       4 .   1.2    .
i .       6 .   .2     1
i .       7 .   .      2
i .       8 .   .      0.5
i .       9 .   .      10
i .      10 .   .25    -1
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "05 G. GRANULAR SYNTHESIS".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/05-g-granular-synthesis.md](../chapters/05-g-granular-synthesis.md)
