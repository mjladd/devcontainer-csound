# 05 B. PANNING AND SPATIALIZATION - Code Example 7

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 05-b-panning-and-spatialization
- **Section:** Different VBAP Layouts in one File
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `05`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
0dbfs = 1
nchnls = 8

vbaplsinit 2.01, 7, -40, 40, 70, 140, 180, -110, -70
vbaplsinit 2.02, 4, -40, 40, 120, -120
vbaplsinit 2.03, 3, -70, 180, 70

  instr 1
aNoise     pinkish    0.5
aVbap[]    vbap       aNoise, line:k(0,p3,-360), 0, 0, 1
           out        aVbap ;layout 1: 7 channel output
  endin

  instr 2
aNoise     pinkish    0.5
aVbap[]    vbap       aNoise, line:k(0,p3,-360), 0, 0, 2
           out        aVbap ;layout 2: 4 channel output
  endin

  instr 3
aNoise     pinkish    0.5
aVbap[]    vbap       aNoise, line:k(0,p3,-360), 0, 0, 3
           out        aVbap ;layout 3: 3 channel output
  endin

</CsInstruments>
<CsScore>
i 1 0 6
i 2 6 6
i 3 12 6
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "05 B. PANNING AND SPATIALIZATION".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/05-b-panning-and-spatialization.md](../chapters/05-b-panning-and-spatialization.md)
