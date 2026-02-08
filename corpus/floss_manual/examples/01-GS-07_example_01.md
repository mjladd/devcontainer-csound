# 07 Hello p-Fields - Code Example 2

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 01-GS-07
- **Section:** Example
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `01`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-o dac
</CsOptions>
<CsInstruments>

/* CONSTANTS IN THE INSTRUMENT HEADER*/
sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 1

/* INSTRUMENT CODE */
instr Hello ;Hello is written here without double quotes!
  //receive MIDI note at start and at end from the score
  iMidiStart = p4 ;this is a MIDI note number
  iMidiEnd = p5
  //create a glissando over the whole duration (p3)
  kMidi = linseg:k(iMidiStart,p3,iMidiEnd)
  //create a decay from -10 dB to -20 dB in half of the duration (p3 / 2)
  kDb = linseg:k(-10,p3/2,-20)
  //sine tone with ampdb and mtof to convert the input to amp and freq
  aSine = poscil:a(ampdb:k(kDb),mtof:k(kMidi))
  //apply one second of fade out
  aOut = linen:a(aSine,0,p3,1)
  //output to all channels
  outall(aOut)
endin

</CsInstruments>
<CsScore>
/* SCORE LINES*/
//score parameter fields
//p1      p2 p3   p4 p5
i "Hello" 0  2    72 68 ;here we need "Hello" with double quotes!
i "Hello" 4  3    67 73
i "Hello" 9  5    74 66
i "Hello" 11 .5   72 73
i "Hello" 12.5 .5 73 73.5
</CsScore>
</CsoundSynthesizer>
```

---

## Context

This code example is from the FLOSS Manual chapter "07 Hello p-Fields".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/01-GS-07.md](../chapters/01-GS-07.md)
