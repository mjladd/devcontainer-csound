# 14 B. METHODS OF WRITING CSOUND SCORES - Code Example 1

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 14-b-methods-of-writing-csound-scores
- **Section:** Calling a binary without a script
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `14`

---

## Code

```csound
<CsoundSynthesizer>
<CsInstruments>
instr 1
endin
</CsInstruments>
<CsScore bin="python3">
from sys import argv
print("File to read = '%s'" % argv[0])
print("File to write = '%s'" % argv[1])
</CsScore>
</CsoundSynthesizer>
```

---

## Context

This code example is from the FLOSS Manual chapter "14 B. METHODS OF WRITING CSOUND SCORES".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/14-b-methods-of-writing-csound-scores.md](../chapters/14-b-methods-of-writing-csound-scores.md)
