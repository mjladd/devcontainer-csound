# HOW TO: HARDWARE - Code Example 1

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 02-c-hardware
- **Section:** How can I connect a MIDI keyboard with a Csound instrument?
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `02`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
//it might be necessary to add -Ma here if you use plain Csound
-odac
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 1

//assign all MIDI channels to instrument "Play"
massign(0,"Play")

instr Play
  //get the frequency from the key pressed
  iCps = cpsmidi()
  //get the amplitude
  iAmp = ampmidi(0dbfs * 0.3)
  //generate a sine tone with these parameters
  aSine = poscil:a(iAmp,iCps)
  //apply fade in and fade out
  aOut =linenr:a(aSine,0.01,0.1,0.01)
  //write it to the output
  outall(aOut)
endin

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
;Example by Andrés Cabrera and joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "HOW TO: HARDWARE".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/02-c-hardware.md](../chapters/02-c-hardware.md)
