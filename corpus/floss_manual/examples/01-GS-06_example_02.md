# 06 Hello Decibel - Code Example 3

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 01-GS-06
- **Section:** Can I use positive dB values?
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

instr Amplify
  //get dB value from fourth score parameter
  iDb = p4
  //create a very soft pink noise
  aNoise = pinkish(0.01)
  //amplify
  aOut = aNoise * ampdb(iDb)
  outall(aOut)
endin

</CsInstruments>
<CsScore>
i "Amplify" 0 2 0  //soft sound as it is
i "Amplify" 2 2 10 //amplification by 10 dB
i "Amplify" 4 2 20 //amplification by 20 dB
</CsScore>
</CsoundSynthesizer>
```

---

## Context

This code example is from the FLOSS Manual chapter "06 Hello Decibel".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/01-GS-06.md](../chapters/01-GS-06.md)
