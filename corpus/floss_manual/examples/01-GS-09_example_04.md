# 09 Hello If - Code Example 5

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 01-GS-09
- **Section:** If - elseif - else
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

instr If_Elseif_Then
  iPitch = 90   // change to 70 and 50
  if (iPitch > 80) then
	schedule("High",0,0)
  elseif (iPitch > 60) then
    schedule("Middle",0,0)
  else
    schedule("Low",0,0)
  endif
endin

instr High
  prints("Instrument 'High'!\n")
endin

instr Middle
  prints("Instrument 'Middle'!\n")
endin

instr Low
  prints("Instrument 'Low'!\n")
endin

</CsInstruments>
<CsScore>
i "If_Elseif_Then" 0 1
</CsScore>
</CsoundSynthesizer>
```

---

## Context

This code example is from the FLOSS Manual chapter "09 Hello If".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/01-GS-09.md](../chapters/01-GS-09.md)
