# 05 B. PANNING AND SPATIALIZATION - Code Example 2

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 05-b-panning-and-spatialization
- **Section:** Simple Stereo Panning
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `05`

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
imethod  =         p4 ; read panning method variable from score (p4)

;---------------- generate a source sound -------------------
a1       pinkish   0.1            ; pink noise
a1       reson     a1, 500, 30, 2 ; bandpass filtered
aPan     lfo       0.5, 1, 1      ; panning controlled by an lfo
aPan     =         aPan + 0.5     ; offset shifted +0.5
;------------------------------------------------------------

 if imethod=1 then
;------------------------ method 1 --------------------------
aPanL    =         1 - aPan
aPanR    =         aPan
;------------------------------------------------------------
 endif

 if imethod=2 then
;------------------------ method 2 --------------------------
aPanL    =       sqrt(1 - aPan)
aPanR    =       sqrt(aPan)
;------------------------------------------------------------
 endif

 if imethod=3 then
;------------------------ method 3 --------------------------
aPanL    =       cos(aPan*$M_PI_2)
aPanR    =       sin(aPan*$M_PI_2)
;------------------------------------------------------------
 endif

 if imethod=4 then
;------------------------ method 4 --------------------------
aPanL   =  cos((aPan + 0.5) * $M_PI_2)
aPanR   =  sin((aPan + 0.5) * $M_PI_2)
;------------------------------------------------------------
 endif

         outs    a1*aPanL, a1*aPanR ; audio sent to outputs
  endin

</CsInstruments>

<CsScore>
; 4 notes one after the other to demonstrate 4 different methods of panning
; p1 p2  p3   p4(method)
i 1  0   4.5  1
i 1  5   4.5  2
i 1  10  4.5  3
i 1  15  4.5  4
e
</CsScore>
</CsoundSynthesizer>
;example by Iain McCurdy
```

---

## Context

This code example is from the FLOSS Manual chapter "05 B. PANNING AND SPATIALIZATION".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/05-b-panning-and-spatialization.md](../chapters/05-b-panning-and-spatialization.md)
