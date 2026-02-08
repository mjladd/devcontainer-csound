# HOW TO: OPCODES - Code Example 1

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 02-d-opcodes
- **Section:** Why should oscil be used with caution?
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `02`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
ksmps = 32

//create GEN02 table with numbers [0,1,2,3,4,3,2,1]
giTable = ftgen(0,0,8,-2, 0,1,2,3,4,3,2,1)

instr 1
  //let oscil cross the table values once a second
  a1 = oscil:a(1,1,giTable)
  //print the result every 1/10 second
  printks("Time = %.1f sec: Table value = %f\n", 1/10, times:k(), a1[0])
endin

</CsInstruments>
<CsScore>
i 1 0 2.01
</CsScore>
</CsoundSynthesizer>
```

---

## Context

This code example is from the FLOSS Manual chapter "HOW TO: OPCODES".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/02-d-opcodes.md](../chapters/02-d-opcodes.md)
