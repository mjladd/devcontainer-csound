# 03 C. CONTROL STRUCTURES - Code Example 1

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 03-c-control-structures
- **Section:** i-Rate Examples
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `03`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-o dac
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

  instr 1
Sfile     =          "ClassGuit.wav"
ifilchnls filenchnls Sfile
 if ifilchnls == 1 then ;mono
aL        soundin    Sfile
aR        =          aL
 else   ;stereo
aL, aR    soundin    Sfile
 endif
          outs       aL, aR
  endin

</CsInstruments>
<CsScore>
i 1 0 5
</CsScore>
</CsoundSynthesizer>
;Example by Joachim Heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "03 C. CONTROL STRUCTURES".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/03-c-control-structures.md](../chapters/03-c-control-structures.md)
