# 03 F. LIVE EVENTS - Code Example 8

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 03-f-live-events
- **Section:** Using i-Rate Loops for Calculating a Pool of Instrument Events
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `03`

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
nchnls = 2
0dbfs = 1

          seed      0; random seed different each time

  instr 1 ;master instrument with event pool
          scoreline_i {{i 2 0 2 7.09
                        i 2 2 2 8.04
                        i 2 4 2 8.03
                        i 2 6 1 8.04}}
  endin

  instr 2 ;plays the notes
asig      pluck     .2, cpspch(p4), cpspch(p4), 0, 1
aenv      transeg   1, p3, 0, 0
          outs      asig*aenv, asig*aenv
  endin

</CsInstruments>
<CsScore>
i 1 0 7
e
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "03 F. LIVE EVENTS".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/03-f-live-events.md](../chapters/03-f-live-events.md)
