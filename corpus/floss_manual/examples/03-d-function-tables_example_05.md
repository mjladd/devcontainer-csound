# 03 D. FUNCTION TABLES - Code Example 6

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 03-d-function-tables
- **Section:** GEN01: Importing a Soundfile
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `03`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-odac --env:SSDIR=../SourceMaterials
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

gS_file = "fox.wav"
giSample ftgen 0, 0, 0, 1, gS_file, 0, 0, 1

instr PlayOnce
 p3 filelen gS_file ;play whole length of the sound file
 aSamp poscil3 .5, 1/p3, giSample
 out aSamp, aSamp
endin

</CsInstruments>
<CsScore>
i "PlayOnce" 0 1
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "03 D. FUNCTION TABLES".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/03-d-function-tables.md](../chapters/03-d-function-tables.md)
