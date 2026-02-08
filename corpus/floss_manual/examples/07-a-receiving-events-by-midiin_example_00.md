# 07 A. RECEIVING EVENTS BY MIDIIN - Code Example 1

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 07-a-receiving-events-by-midiin
- **Section:** 07 A. RECEIVING EVENTS BY MIDIIN
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `07`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-Ma -m128
; activates all midi devices, suppress note printings
</CsOptions>
<CsInstruments>
; no audio so 'sr' or 'nchnls' aren't relevant
ksmps = 32

; using massign with these arguments disables default instrument triggering
massign 0,0

  instr 1
kstatus, kchan, kdata1, kdata2  midiin            ;read in midi
ktrigger changed kstatus, kchan, kdata1, kdata2 ;trigger if midi data change
 if ktrigger=1 && kstatus!=0 then          ;if status byte is non-zero...
; -- print midi data to the terminal with formatting --
 printks "status:%d%tchannel:%d%tdata1:%d%tdata2:%d%n",
          0,kstatus,kchan,kdata1,kdata2
 endif
  endin

</CsInstruments>
<CsScore>
i 1 0 3600 ; instr 1 plays for 1 hour
</CsScore>
</CsoundSynthesizer>
;example by Iain McCurdy
```

---

## Context

This code example is from the FLOSS Manual chapter "07 A. RECEIVING EVENTS BY MIDIIN".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/07-a-receiving-events-by-midiin.md](../chapters/07-a-receiving-events-by-midiin.md)
