# 03 E. ARRAYS - Code Example 4

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 03-e-arrays
- **Section:** Strings
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `03`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

instr Files
 S_array[] directory "."
 iNumFiles lenarray S_array
 prints "Number of files in %s = %d\n", pwd(), iNumFiles
 printarray S_array
endin

</CsInstruments>
<CsScore>
i "Files" 0 0
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "03 E. ARRAYS".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/03-e-arrays.md](../chapters/03-e-arrays.md)
