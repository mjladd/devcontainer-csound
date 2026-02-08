# 03 A. INITIALIZATION AND PERFORMANCE PASS - Code Example 14

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 03-a-initialization-and-performance-pass
- **Section:** Named Instruments
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `03`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-nd
</CsOptions>
<CsInstruments>

instr Grain_machine
prints " Grain_machine\n"
endin

instr Fantastic_FM
prints "  Fantastic_FM\n"
endin

instr Random_Filter
prints "   Random_Filter\n"
endin

instr Final_Reverb
prints "    Final_Reverb\n"
endin

</CsInstruments>
<CsScore>
i "Final_Reverb" 0 1
i "Random_Filter" 0 1
i "Grain_machine" 0 1
i "Fantastic_FM" 0 1
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "03 A. INITIALIZATION AND PERFORMANCE PASS".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/03-a-initialization-and-performance-pass.md](../chapters/03-a-initialization-and-performance-pass.md)
