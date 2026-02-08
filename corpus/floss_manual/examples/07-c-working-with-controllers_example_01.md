# 07 C. WORKING WITH CONTROLLERS - Code Example 2

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 07-c-working-with-controllers
- **Section:** Scanning Pitch Bend and Aftertouch
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `07`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-odac -Ma
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 1
0dbfs = 1

giSine  ftgen  0,0,2^10,10,1  ; a sine wave

  instr 1
; -- pitch bend --
kPchBnd  pchbend  0,4               ;read in pitch bend (range -2 to 2)
kTrig1   changed  kPchBnd           ;if 'kPchBnd' changes generate a trigger
 if kTrig1=1 then
printks "Pitch Bend:%f%n",0,kPchBnd ;print kPchBnd to console when it changes
 endif

; -- aftertouch --
kAfttch  aftouch 0,0.9              ;read in aftertouch (range 0 to 0.9)
kTrig2   changed kAfttch            ;if 'kAfttch' changes generate a trigger
 if kTrig2=1 then
printks "Aftertouch:%d%n",0,kAfttch ;print kAfttch to console when it changes
 endif

; -- create a sound --
iNum     notnum                     ;read in MIDI note number
; MIDI note number + pitch bend are converted to cycles per seconds
aSig     poscil   0.1,cpsmidinn(iNum+kPchBnd),giSine
         out      aSig              ;audio to output
  endin

</CsInstruments>
<CsScore>
</CsScore>
<CsoundSynthesizer>
;example by Iain McCurdy
```

---

## Context

This code example is from the FLOSS Manual chapter "07 C. WORKING WITH CONTROLLERS".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/07-c-working-with-controllers.md](../chapters/07-c-working-with-controllers.md)
