# 09 Hello If - Code Example 3

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 01-GS-09
- **Section:** Example
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `01`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-o dac -m 128
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 1

instr Hello
  iMidiStart = p4
  iMidiEnd = p5
  kDb = linseg:k(-10,p3/2,-20)
  kMidi = linseg:k(iMidiStart,p3/3,iMidiEnd)
  aSine = poscil:a(ampdb(kDb),mtof(kMidi))
  aOut = linen:a(aSine,0,p3,1)
  outall(aOut)

  iCount = p6
  print(iCount)
  if (iCount > 1) then
	schedule("Hello",p3,p3+1,iMidiStart-1,iMidiEnd+2,iCount-1)
  endif
endin
schedule("Hello", 0, 2, 72, 68, 6)

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
```

---

## Context

This code example is from the FLOSS Manual chapter "09 Hello If".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/01-GS-09.md](../chapters/01-GS-09.md)
