# 08 B. CSOUND AND ARDUINO - Code Example 1

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 08-b-csound-and-arduino
- **Section:** Arduino - Pd - Csound
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `08`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr = 44100
nchnls = 2
0dbfs = 1
ksmps = 32

 instr 1
; read in controller data from Pd via the API using 'invalue'
kctrl1  invalue  "ctrl1"
kctrl2  invalue  "ctrl2"
; re-range controller values from 0 - 1 to 7 - 11
koct    =        (kctrl2*4)+7
; create an oscillator
a1      vco2     kctrl1,cpsoct(koct),4,0.1
        outs     a1,a1
 endin
</CsInstruments>
<CsScore>
i 1 0 10000
</CsScore>
</CsoundSynthesizer>
;example by Iain McCurdy
```

---

## Context

This code example is from the FLOSS Manual chapter "08 B. CSOUND AND ARDUINO".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/08-b-csound-and-arduino.md](../chapters/08-b-csound-and-arduino.md)
