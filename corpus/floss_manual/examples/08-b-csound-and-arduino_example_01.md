# 08 B. CSOUND AND ARDUINO - Code Example 2

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 08-b-csound-and-arduino
- **Section:** Arduino - Processing - Csound
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `08`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-o dac
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 8
nchnls = 1
0dbfs = 1

; handle used to reference osc stream
gihandle OSCinit 12001

 instr 1
; initialise variable used for analog values
gkana0      init       0
; read in OSC channel '/analog/0'
gktrigana0  OSClisten  gihandle, "/analog/0", "i", gkana0
; print changed values to terminal
            printk2    gkana0
 endin

</CsInstruments>
<CsScore>
i 1 0 3600
</CsScore>
</CsoundSynthesizer>
;example by Iain McCurdy
```

---

## Context

This code example is from the FLOSS Manual chapter "08 B. CSOUND AND ARDUINO".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/08-b-csound-and-arduino.md](../chapters/08-b-csound-and-arduino.md)
