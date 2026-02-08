# 03 G. USER DEFINED OPCODES - Code Example 8

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 03-g-user-defined-opcodes
- **Section:** Recursive User Defined Opcodes
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `03`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-o dac -m 128
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1
seed 0

opcode Recursion, a, iip
  //input: frequency, number of partials, this partial (default=1)
  iFreq, iNumParts, iThisPart xin
  //amplitude decreases for higher partials
  iAmp = 1/iNumParts/iThisPart
  //apply small frequency deviation except for the first partial
  iFreqMult = (iThisPart == 1) ? 1 : iThisPart*random:i(0.95,1.05)
  //create this partial
  aOut = poscil:a(iAmp,iFreq*iFreqMult)
  //add the other partials via recursion
  if (iThisPart < iNumParts) then
    aOut += Recursion(iFreq,iNumParts,iThisPart+1)
  endif
  xout(aOut)
endop

instr I_can_do_the_same
  //call a sound with 7 partials based on 400 Hz
  aPartials = Recursion(400,7)
  aOut = linen:a(aPartials,0.01,p3,0.5)
  outall(aOut)
  //call this instrument again for p4 times
  if (p4 > 1) then
    schedule(p1,p3,p3,p4-1)
  endif
endin

</CsInstruments>
<CsScore>
i "I_can_do_the_same" 0 3 3
e 9
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "03 G. USER DEFINED OPCODES".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/03-g-user-defined-opcodes.md](../chapters/03-g-user-defined-opcodes.md)
