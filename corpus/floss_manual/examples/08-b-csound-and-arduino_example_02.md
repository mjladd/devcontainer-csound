# 08 B. CSOUND AND ARDUINO - Code Example 3

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 08-b-csound-and-arduino
- **Section:** The Serial Opcodes
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `08`

---

## Code

```csound
<CsoundSynthesizer>
; Example written by Matt Ingalls
; run with a commandline something like:
; csound --opcode-lib=serialOpcodes.dylib serialdemo.csd -odac -iadc

<CsOptions>
</CsOptions>
;--opcode-lib=serialOpcodes.dylib -odac
<CsInstruments>

ksmps = 500 ; the default krate can be too fast for the arduino to handle
0dbfs = 1

instr 1
        iPort   serialBegin     "/COM4", 9600
        kVal    serialRead      iPort
                printk2         kVal
endin

</CsInstruments>
<CsScore>
i 1 0 3600
</CsScore>
</CsoundSynthesizer>
```

---

## Context

This code example is from the FLOSS Manual chapter "08 B. CSOUND AND ARDUINO".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/08-b-csound-and-arduino.md](../chapters/08-b-csound-and-arduino.md)
