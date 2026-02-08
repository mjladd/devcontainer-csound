# 03 C. CONTROL STRUCTURES - Code Example 23

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 03-c-control-structures
- **Section:** Time Loops by Using a Clock Variable
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `03`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-odac -m0
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

instr TimeLoop
 //set desired time for time loop
 kLoopTime = 1/2
 //set kTime to zero at start
 kTime init 0
 //trigger event if zero has reached ...
 if kTime <= 0 then
  event "i", "Play", 0, .3
  //... and reset time
  kTime = kLoopTime
 endif
 //subtract time for each control cycle
 kTime -= 1/kr
endin

instr Play
 aEnv transeg 1, p3, -10, 0
 aSig poscil .2*aEnv, 400
 out aSig, aSig
endin

</CsInstruments>
<CsScore>
i "TimeLoop" 0 10
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "03 C. CONTROL STRUCTURES".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/03-c-control-structures.md](../chapters/03-c-control-structures.md)
