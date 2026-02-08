# 15 D. RANDOM - Code Example 11

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 15-d-random
- **Section:** Random Processes
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `15`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 128
nchnls = 1
0dbfs = 1

; random frequency
instr 1
kx      random  -p6, p6
kfreq   =       p5*2^kx
aout    oscil   p4, kfreq, 1
out     aout
endin

; random change of frequency
instr 2
kx      init    .5
kfreq   =       p5*2^kx
kv      random  -p6, p6
kv      =       kv*(1 - p7)
kx      =       kx + kv
aout    oscil   p4, kfreq, 1
out     aout
endin

; random change of change of frequency
instr 3
kv      init    0
kx      init    .5
kfreq   =       p5*2^kx
ka      random  -p7, p7
kv      =       kv + ka
kv      =       kv*(1 - p8)
kx      =       kx + kv
kv      =       (kx < -p6 || kx > p6?-kv : kv)
aout    oscili  p4, kfreq, 1
out     aout

endin

</CsInstruments>
<CsScore>

f1 0 32768 10 1
; i1    p4      p5      p6
; i2    p4      p5      p6      p7
;       amp     c_fr    rand    damp
; i2 0 20       .1      600     0.01    0.001
;       amp     c_fr    d_fr    rand    damp
;       amp     c_fr    rand
; i1 0 20       .1      600     0.5
; i3    p4      p5      p6      p7      p8
i3 0 20         .1      600     1       0.001   0.001
</CsScore>
</CsoundSynthesizer>
;example by martin neukom
```

---

## Context

This code example is from the FLOSS Manual chapter "15 D. RANDOM".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/15-d-random.md](../chapters/15-d-random.md)
