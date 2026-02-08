# 04 A. ADDITIVE SYNTHESIS - Code Example 5

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 04-a-additive-synthesis
- **Section:** Triggering Instrument Events for the Partials
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `04`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-o dac
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

instr 1 ;master instrument
inumparts =         p4 ;number of partials
ibasfreq  =         200 ;base frequency
ipart     =         1 ;count variable for loop
;loop for inumparts over the ipart variable
;and trigger inumpartss instanes of the subinstrument
loop:
ifreq     =         ibasfreq * ipart
iamp      =         1/ipart/inumparts
          event_i   "i", 10, 0, p3, ifreq, iamp
          loop_le   ipart, 1, inumparts, loop
endin

instr 10 ;subinstrument for playing one partial
ifreq     =         p4 ;frequency of this partial
iamp      =         p5 ;amplitude of this partial
aenv      transeg   0, .01, 0, iamp, p3-0.1, -10, 0
apart     poscil    aenv, ifreq
          outs      apart, apart
endin

</CsInstruments>
<CsScore>
;         number of partials
i 1 0 3   10
i 1 3 3   20
i 1 6 3   2
</CsScore>
</CsoundSynthesizer>
;Example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "04 A. ADDITIVE SYNTHESIS".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/04-a-additive-synthesis.md](../chapters/04-a-additive-synthesis.md)
