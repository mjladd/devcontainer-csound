# 09 B. CSOUND IN MAXMSP - Code Example 4

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 09-b-csound-in-maxmsp
- **Section:** MIDI
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `09`

---

## Code

```csound
<CsoundSynthesizer>
<CsInstruments>
sr     = 44100
ksmps  = 32
nchnls = 2
0dbfs  = 1

massign 0, 0 ; Disable default MIDI assignments.
massign 1, 1 ; Assign MIDI channel 1 to instr 1.

giSine ftgen 1, 0, 16384, 10, 1 ; Generate a sine wave table.

instr 1
iPitch cpsmidi
kMod   midic7 1, 0, 10
aFM    foscil .2, iPitch, 2, kMod, 1.5, giSine
       outch 1, aFM, 2, aFM
endin
</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
;example by Davis Pyon
```

---

## Context

This code example is from the FLOSS Manual chapter "09 B. CSOUND IN MAXMSP".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/09-b-csound-in-maxmsp.md](../chapters/09-b-csound-in-maxmsp.md)
