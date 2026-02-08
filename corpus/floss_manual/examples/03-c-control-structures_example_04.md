# 03 C. CONTROL STRUCTURES - Code Example 5

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
-odac
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

  instr 1
Sfile     =          "ClassGuit.wav"
ifilchnls filenchnls Sfile
 if ifilchnls == 1 goto mono
  goto stereo
mono:
aL        soundin    Sfile
aR        =          aL
          goto      continue
stereo:
aL, aR    soundin    Sfile
continue:
          outs       aL, aR
  endin

</CsInstruments>
<CsScore>
i 1 0 5
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "03 C. CONTROL STRUCTURES".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/03-c-control-structures.md](../chapters/03-c-control-structures.md)
