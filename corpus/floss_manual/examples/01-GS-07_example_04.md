# 07 Hello p-Fields - Code Example 5

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 01-GS-07
- **Section:** Instrument names and fractional parts
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `01`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-odac -m128
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

//put the message string "Hello ..." in the channel "radio"
chnset("Hello instrument 1.2!","radio")

instr TestInstanceSelection
  iMyInstance = p1 ;get instance as 1.1, 1.2 or 1.3
  print(iMyInstance) ;print it
  //receive the message only if instance is 1.2
  if iMyInstance == 1.2 then
    Smessage = chnget:S("radio")
    prints("%s\n",Smessage)
  endif
endin

</CsInstruments>
<CsScore>
i 1.1 0 3
i 1.2 2 2
i 1.3 5 1
</CsScore>
</CsoundSynthesizer>
```

---

## Context

This code example is from the FLOSS Manual chapter "07 Hello p-Fields".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/01-GS-07.md](../chapters/01-GS-07.md)
