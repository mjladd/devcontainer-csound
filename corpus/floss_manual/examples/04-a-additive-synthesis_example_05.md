# 04 A. ADDITIVE SYNTHESIS - Code Example 6

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
-o dac -Ma
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

          massign   0, 1 ;all midi channels to instr 1

instr 1 ;master instrument
ibasfreq  cpsmidi       ;base frequency
iampmid   ampmidi   20 ;receive midi-velocity and scale 0-20
inparts   =         int(iampmid)+1 ;exclude zero
ipart     =         1 ;count variable for loop
;loop for inparts over the ipart variable
;and trigger inparts instances of the sub-instrument
loop:
ifreq     =         ibasfreq * ipart
iamp      =         1/ipart/inparts
          event_i   "i", 10, 0, 1, ifreq, iamp
          loop_le   ipart, 1, inparts, loop
endin

instr 10 ;subinstrument for playing one partial
ifreq     =         p4 ;frequency of this partial
iamp      =         p5 ;amplitude of this partial
aenv      transeg   0, .01, 0, iamp, p3-.01, -3, 0
apart     poscil    aenv, ifreq
          outs      apart/3, apart/3
endin

</CsInstruments>
<CsScore>

</CsScore>
</CsoundSynthesizer>
;Example by Joachim Heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "04 A. ADDITIVE SYNTHESIS".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/04-a-additive-synthesis.md](../chapters/04-a-additive-synthesis.md)
