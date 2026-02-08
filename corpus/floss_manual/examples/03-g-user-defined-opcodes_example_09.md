# 03 G. USER DEFINED OPCODES - Code Example 10

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 03-g-user-defined-opcodes
- **Section:** Change the Content of a Function Table
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `03`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

giSine ftgen 0, 0, 256, 10, 1; sine wave

opcode TabDirtk, 0, ikk
 ;"dirties" a function table by applying random deviations at a k-rate trigger
 ;input: function table, trigger (1 = perform manipulation),
 ;deviation as percentage
 ift, ktrig, kperc xin
 if ktrig == 1 then ;just work if you get a trigger signal
  kndx      =         0
  while kndx < ftlen(ift) do
   kval table kndx, ift; read old value
   knewval = kval + rnd31:k(kperc/100,0); calculate new value
   tablew knewval, kndx, giSine; write new value
   kndx += 1
  od
 endif
endop

  instr 1
kTrig metro 1 ;trigger signal once per second
kPerc linseg 0, p3, 100
TabDirtk giSine, kTrig, kPerc
aSig poscil .2, 400, giSine
out aSig, aSig
  endin

</CsInstruments>
<CsScore>
i 1 0 10
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "03 G. USER DEFINED OPCODES".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/03-g-user-defined-opcodes.md](../chapters/03-g-user-defined-opcodes.md)
