# 07 E. MIDI OUTPUT - Code Example 4

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 07-e-midi-output
- **Section:** _midion_ - Outputting MIDI Notes Made Easier
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `07`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
; amend device number accordingly
-Q999
</CsOptions>
<CsInstruments>

ksmps = 32 ;no audio so sr and nchnls irrelevant

  instr 1
; read values in from p-fields
kchn    =       p4
knum    =       p5
kvel    =       p6
        midion  kchn, knum, kvel ; send a midi note
  endin

</CsInstruments>
<CsScore>
;p1 p2  p3  p4 p5 p6
i 1 0   2.5 1 60  100
i 1 0.5 2   1 64  100
i 1 1   1.5 1 67  100
i 1 1.5 1   1 72  100
f 0 30 ; extending performance time prevents note-offs from being missed
</CsScore>
</CsoundSynthesizer>
;example by Iain McCurdy
```

---

## Context

This code example is from the FLOSS Manual chapter "07 E. MIDI OUTPUT".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/07-e-midi-output.md](../chapters/07-e-midi-output.md)
