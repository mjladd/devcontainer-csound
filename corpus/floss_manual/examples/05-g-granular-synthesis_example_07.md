# 05 G. GRANULAR SYNTHESIS - Code Example 8

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 05-g-granular-synthesis
- **Section:** The Granulator Unit
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `05`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-odac -iadc -m128
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

giTable ftgen 0, 0, sr, 2, 0 ;for one second of recording
giHalfSine ftgen 0, 0, 1024, 9, .5, 1, 0
giDelay = 1 ;ms

instr Record
 aIn = inch(1)
 gaWritePointer = phasor(1)
 tablew(aIn,gaWritePointer,giTable,1)
endin
schedule("Record",0,-1)

instr Granulator
 kGrainDur = 30 ;milliseconds
 kTranspos = -300 ;cent
 kDensity = 50 ;Hz (grains per second)
 kDistribution = .5 ;0-1
 kTrig = metro(kDensity)
 if kTrig==1 then
  kPointer = k(gaWritePointer)-giDelay/1000
  kOffset = random:k(0,kDistribution/kDensity)
  schedulek("Grain",kOffset,kGrainDur/1000,kPointer,cent(kTranspos))
 endif
endin
schedule("Granulator",giDelay/1000,-1)

instr Grain
 iStart = p4
 iSpeed = p5
 aOut = poscil3:a(poscil3:a(.3,1/p3,giHalfSine),iSpeed,giTable,iStart)
 out(aOut,aOut)
endin

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "05 G. GRANULAR SYNTHESIS".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/05-g-granular-synthesis.md](../chapters/05-g-granular-synthesis.md)
