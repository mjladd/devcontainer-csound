# 05 C. FILTERS - Code Example 4

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 05-c-filters
- **Section:** Comb Filtering
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `05`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-odac ;activates real time sound output
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 1
0dbfs = 1

  instr 1
; -- generate an input audio signal (noise impulses) --
; repeating amplitude envelope:
kEnv         loopseg   1,0, 0,1,0.005,1,0.0001,0,0.9949,0
aSig         pinkish   kEnv*0.6                     ; pink noise pulses

; apply comb filter to input signal
krvt    linseg  0.1, 5, 2                           ; reverb time
alpt    expseg  0.005,5,0.005,6,0.0005,10,0.1,1,0.1 ; loop time
aRes    vcomb   aSig, krvt, alpt, 0.1               ; comb filter
        out     aRes                                ; audio to output
  endin

</CsInstruments>
<CsScore>
i 1 0 25
</CsScore>
</CsoundSynthesizer>
;example by Iain McCurdy
```

---

## Context

This code example is from the FLOSS Manual chapter "05 C. FILTERS".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/05-c-filters.md](../chapters/05-c-filters.md)
