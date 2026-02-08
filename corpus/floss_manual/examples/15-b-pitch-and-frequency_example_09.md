# 15 B. PITCH AND FREQUENCY - Code Example 10

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 15-b-pitch-and-frequency
- **Section:** Tuning Systems
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `15`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-o dac -m128
</CsOptions>
<CsInstruments>

sr = 44100
nchnls = 2
0dbfs = 1
ksmps = 32

instr Pythagorean
 giScale[] fillarray 1, 9/8, 81/64, 4/3, 3/2
 schedule("LetPlay",0,0)
 puts "Pythagorean scale",1
endin

instr Meantone
 giScale[] fillarray 1, 10/9, 5/4, 4/3, 3/2
 schedule("LetPlay",0,0)
 puts "Meantone scale",1
endin

instr Quartertone
 giScale[] fillarray 1, 2^(1/24), 2^(2/24), 2^(3/24), 2^(4/24)
 schedule("LetPlay",0,0)
 puts "Quartertone scale",1
endin

instr Partials
 giScale[] fillarray 1, 2, 3, 4, 5
 schedule("LetPlay",0,0)
 puts "Partials scale",1
endin

instr LetPlay
 indx = 0
 while indx < 5 do
  schedule("Play",indx,2,giScale[indx])
  indx += 1
 od
endin

instr Play
 iFreq = mtof:i(60) * p4
 print iFreq
 aSnd vco2 .2, iFreq, 8
 aOut linen aSnd, .1, p3, p3/2
 out aOut, aOut
endin

</CsInstruments>
<CsScore>
i "Pythagorean" 0 10
i "Meantone" 10 10
i "Quartertone" 20 10
i "Partials" 30 10
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "15 B. PITCH AND FREQUENCY".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/15-b-pitch-and-frequency.md](../chapters/15-b-pitch-and-frequency.md)
