# 10 Hello Random - Code Example 2

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 01-GS-10
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
seed(12345)

instr Hello
  //MIDI notes between 55 and 80 for both start and end
  iMidiStart = random:i(55,80)
  iMidiEnd = random:i(55,80)
  //decibel between -30 and -10 for both start and end
  iDbStart = random:i(-30,-10)
  iDbEnd = random:i(-30,-10)
  //calculate lines depending on the random choice
  kDb = linseg:k(iDbStart,p3/2,iDbEnd)
  kMidi = linseg:k(iMidiStart,p3/3,iMidiEnd)
  //create tone with fade-out and output
  aSine = poscil:a(ampdb(kDb),mtof(kMidi))
  aOut = linen:a(aSine,0,p3,p3/2)
  outall(aOut)

  //trigger next instance with random range for start and duration
  iCount = p4
  if (iCount > 1) then
    iStart = random:i(1,3)
    iDur = p3 + random:i(-p3/2,p3)
    schedule("Hello",iStart,iDur,iCount-1)
  endif
endin
schedule("Hello", 0, 2, 15)

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
```

---

## Context

This code example is from the FLOSS Manual chapter "10 Hello Random".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/01-GS-10.md](../chapters/01-GS-10.md)
