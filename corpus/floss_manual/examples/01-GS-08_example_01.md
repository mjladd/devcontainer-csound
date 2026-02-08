# 08 Hello Schedule - Code Example 2

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 01-GS-08
- **Section:** Triggering other score events than 'i' from the orchestra code
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `01`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-m128
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

instr Play
  aSine = poscil:a(.2,444)
  outall(linen:a(aSine,p3/2,p3,p3/2))
endin
schedule("Play",0,3)

instr Print
  puts("I am calling now the 'e' statement after 3 seconds",1)
  schedule("Terminate",3,0)
endin
schedule("Print",3,1)

instr Terminate
  event_i("e",0)
endin

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
```

---

## Context

This code example is from the FLOSS Manual chapter "08 Hello Schedule".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/01-GS-08.md](../chapters/01-GS-08.md)
