# 03 G. USER DEFINED OPCODES - Code Example 12

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 03-g-user-defined-opcodes
- **Section:** A Recursive User Defined Opcode for Additive Synthesis
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `03`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-odac -m128
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 128
nchnls = 2
0dbfs = 1
seed 0

opcode Partials, aa, iiip
  //plays iNumParts partials with frequency deviation and own envelopes and
  //own durations for each partial
  //iBasFreq: base frequency of sound mixture
  //iNumParts: total number of partials
  //iPan: panning
  //iThisPart: which partial is this (1-N, default=1)
  iBasFreq, iNumParts, iPan, iThisPart xin
  //this partial's frequency
  iFreq = iBasFreq * iThisPart * semitone(random:i(-3,3))
  //additional time for this partial
  iDur = random:i(p3/3,p3*3)
  //volume with random deviation of 6 dB maximum (and the higher the softer)
  iAmp = (1/iNumParts) * ampdb(random:i(-6,0)-iThisPart)
  //partial envelope and tone
  aEnv = transeg:a(0,0.005,0,iAmp,iDur-0.005,-10,0)
  aTone = poscil:a(aEnv,iFreq)
  //panning with slight deviations arount the iPan input
  aL,aR pan2 aTone, iPan+random:i(-0.1,0.1)
  //recursion
  if (iThisPart < iNumParts) then
    aL2,aR2 Partials iBasFreq,iNumParts,iPan,iThisPart+1
    aL += aL2
    aR += aR2
  endif
  p3 = iDur
  xout(aL,aR)
endop

instr Walk
  p3 = random:i(1,5)
  iNumPartials = int(random:i(8,14))
  iBasFreq = mtof:i(random:i(24,84))
  iPan = random:i(0.2,0.8)
  aL,aR Partials iBasFreq, iNumPartials, iPan
  outs(aL,aR)
  //play for 60 seconds
  if (times:i() < 60) then
    schedule(p1,random:i(1,4),1)
  //then exit gently (= after 10 seconds)
  else
    schedule("Turnoff",10,1)
  endif
endin
schedule("Walk",0,1)

instr Turnoff
  event_i("e",0)
endin

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
;Example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "03 G. USER DEFINED OPCODES".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/03-g-user-defined-opcodes.md](../chapters/03-g-user-defined-opcodes.md)
