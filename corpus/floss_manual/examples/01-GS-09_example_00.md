# 09 Hello If - Code Example 1

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 01-GS-09
- **Section:** One Instance Calls the Next ...
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

instr InfiniteCalls
  //play a simple tone
  aSine = poscil:a(.2,415)
  aOut = linen:a(aSine,0,p3,p3)
  outall(aOut)
  //call the next instance after 3 seconds
  schedule("InfiniteCalls",3,2)
endin
schedule("InfiniteCalls",0,2)

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
