# 09 A. CSOUND IN PD - Code Example 4

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 09-a-csound-in-pd
- **Section:** Score Events
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `09`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 8
nchnls = 2
0dbfs = 1
seed 0; each time different seed

instr 1
iDur      random    0.5, 3
p3        =         iDur
iFreq1    random    400, 1200
iFreq2    random    400, 1200
idB       random    -18, -6
kFreq     linseg    iFreq1, iDur, iFreq2
kEnv      transeg   ampdb(idB), p3, -10, 0
aTone     poscil    kEnv, kFreq
          outs      aTone, aTone
endin

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "09 A. CSOUND IN PD".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/09-a-csound-in-pd.md](../chapters/09-a-csound-in-pd.md)
