# 08 Hello Schedule - Code Example 1

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 01-GS-08
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

sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 1

//same instrument code as in tutorial 07
instr Hello
  iMidiStart = p4
  iMidiEnd = p5
  kDb = linseg:k(-10,p3/2,-20)
  kMidi = linseg:k(iMidiStart,p3,iMidiEnd)
  aSine = poscil:a(ampdb:k(kDb),mtof:k(kMidi))
  aOut = linen:a(aSine,0,p3,1)
  outall(aOut)
endin
//followed by schedule statements rather than score lines
schedule("Hello", 0, 2, 72, 68)
schedule("Hello", 4, 3, 67, 73)
schedule("Hello", 9, 5, 74, 66)
schedule("Hello", 11, .5, 72, 73)
schedule("Hello", 12.5, .5, 73, 73.5)


</CsInstruments>
<CsScore>
//the score is empty here!
</CsScore>
</CsoundSynthesizer>
```

---

## Context

This code example is from the FLOSS Manual chapter "08 Hello Schedule".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/01-GS-08.md](../chapters/01-GS-08.md)
