# 08 Hello Schedule - Code Example 5

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 01-GS-08
- **Section:** Three Particular Durations: 0, -1 and z
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `01`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-o dac -m128
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

instr Zett
  prints("I am there!\n")
  iMidiNote = p4
  aSound = poscil:a(.1,mtof:i(iMidiNote))
  aOut = linenr:a(aSound,0,3,.01)
  outall(aOut)
endin

instr Turnoff
  turnoff2_i("Zett",0,1)
endin

</CsInstruments>
<CsScore>
i "Zett" 0 z 70
i "Zett" 1 z 76
i "Zett" 4 z 69
i "Turnoff" 10 0
</CsScore>
</CsoundSynthesizer>
```

---

## Context

This code example is from the FLOSS Manual chapter "08 Hello Schedule".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/01-GS-08.md](../chapters/01-GS-08.md)
