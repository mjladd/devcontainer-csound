# 02 Hello Frequency - Code Example 2

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 01-GS-02
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

instr Hello
  kFreq = linseg:k(500,0.5,400)
  aSine = poscil:a(0.2,kFreq)
  outall(aSine)
endin

</CsInstruments>
<CsScore>
i "Hello" 0 2
</CsScore>
</CsoundSynthesizer>
```

---

## Context

This code example is from the FLOSS Manual chapter "02 Hello Frequency".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/01-GS-02.md](../chapters/01-GS-02.md)
