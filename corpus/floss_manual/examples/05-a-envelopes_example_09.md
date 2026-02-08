# 05 A. ENVELOPES - Code Example 10

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 05-a-envelopes
- **Section:** Envelopes with release segment
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
ksmps = 64
nchnls = 2
0dbfs = 1
seed 0

instr Generate
 //create and start 10 instances of instr Play
 indx = 0
 while indx < 10 do
  schedule "Play", 0, 15
  indx += 1
 od
endin

instr Play
 iMidiNote random 60, 72
 //use the following line instead when using midi input
 ;iMidiNote notnum
 ;                 attack-|sustain-|-release
 aEnv     linsegr  0, 0.01,  0.1,    0.5,0; envelope that senses note releases
 aSig     poscil   aEnv, mtof:i(iMidiNote); audio oscillator
          out      aSig, aSig             ; audio sent to output
endin

instr TurnOff_noRelease
 //turn off the ten instances from instr Play starting from the oldest one
 //and do not allow the release segment to be performed (result: clicks)
 kTrigFreq init 1
 kTrig metro kTrigFreq
 if kTrig == 1 then
  kRelease = 0 ;no release allowed
  turnoff2 "Play", 1, kRelease
 endif
endin

instr TurnOff_withRelease
 //turn off the ten instances from instr Play starting from the oldest one
 //and do allow the release segment to be performed (no clicks any more)
 kTrigFreq init 1
 kTrig metro kTrigFreq
 if kTrig == 1 then
  kRelease = 1 ;release allowed
  turnoff2 "Play", 1, 1
 endif
endin

</CsInstruments>
<CsScore>
//for real-time midi input, comment out all score lines
i "Generate" 0 0
i "TurnOff_noRelease" 1 11
i "Generate" 15 0
i "TurnOff_withRelease" 16 11
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "05 A. ENVELOPES".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/05-a-envelopes.md](../chapters/05-a-envelopes.md)
