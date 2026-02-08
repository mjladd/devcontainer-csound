# 07 B. TRIGGERING INSTRUMENT INSTANCES - Code Example 3

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 07-b-triggering-instrument-instances
- **Section:** Using Multiple Triggering
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `07`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-Ma
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 1
0dbfs = 1

          massign   0, 1 ;assign all incoming midi to instr 1
instr 1 ;global midi instrument, calling instr 2.cc.nnn
          ;(c=channel, n=note number)
inote     notnum    ;get midi note number
ichn      midichn   ;get midi channel
instrnum  =         2 + ichn/100 + inote/100000 ;make fractional instr number
     ; -- call with indefinite duration
           event_i   "i", instrnum, 0, -1, ichn, inote
kend      release   ;get a "1" if instrument is turned off
 if kend == 1 then
          event     "i", -instrnum, 0, 1 ;then turn this instance off
 endif
  endin

  instr 2
ichn      =         int(frac(p1)*100)
inote     =         round(frac(frac(p1)*100)*1000)
          prints    "instr %f: ichn = %f, inote = %f%n", p1, ichn, inote
          printks   "instr %f playing!%n", 1, p1
  endin

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
;Example by Joachim Heintz, using code of Victor Lazzarini
```

---

## Context

This code example is from the FLOSS Manual chapter "07 B. TRIGGERING INSTRUMENT INSTANCES".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/07-b-triggering-instrument-instances.md](../chapters/07-b-triggering-instrument-instances.md)
