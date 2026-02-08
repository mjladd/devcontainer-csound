# 14 D. PYTHON IN CSOUNDQT - Code Example 1

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 14-d-python-in-csoundqt
- **Section:** Run, Pause or Stop a _csd_ File
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `14`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
0dbfs = 1
nchnls = 1

giSine     ftgen      0, 0, 1024, 10, 1

instr 1
kPitch     expseg     500, p3, 1000
aSine      poscil     .2, kPitch, giSine
           out        aSine
endin
</CsInstruments>
<CsScore>
i 1 0 10
</CsScore>
</CsoundSynthesizer>
```

---

## Context

This code example is from the FLOSS Manual chapter "14 D. PYTHON IN CSOUNDQT".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/14-d-python-in-csoundqt.md](../chapters/14-d-python-in-csoundqt.md)
