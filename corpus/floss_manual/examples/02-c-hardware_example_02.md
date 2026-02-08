# HOW TO: HARDWARE - Code Example 3

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 02-c-hardware
- **Section:** How can I get a simple printout of all MIDI input with plain Csound?
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `02`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
//it might be necessary to add -Ma here if you use plain Csound
-odac
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 1

instr 1
  kStatus, kChan, kData1, kData2 midiin

  if kStatus != 0 then ;print if any new MIDI message has been received
    printk 0, kStatus
    printk 0, kChan
    printk 0, kData1
    printk 0, kData2
  endif

endin

</CsInstruments>
<CsScore>
i 1 0 -1
</CsScore>
</CsoundSynthesizer>
;Example by Andrés Cabrera
```

---

## Context

This code example is from the FLOSS Manual chapter "HOW TO: HARDWARE".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/02-c-hardware.md](../chapters/02-c-hardware.md)
