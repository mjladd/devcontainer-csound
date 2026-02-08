# WELCOME TO CSOUND! - Code Example 1

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 00-a-preface
- **Section:** WELCOME TO CSOUND!
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `00`

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

instr TryMe
  //some code here ...
endin
schedule("TryMe",0,-1)

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
```

---

## Context

This code example is from the FLOSS Manual chapter "WELCOME TO CSOUND!".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/00-a-preface.md](../chapters/00-a-preface.md)
