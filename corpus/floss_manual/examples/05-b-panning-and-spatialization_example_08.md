# 05 B. PANNING AND SPATIALIZATION - Code Example 9

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 05-b-panning-and-spatialization
- **Section:** Different Orders
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `05`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-odac
--env:SSDIR+=../SourceMaterials
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
0dbfs = 1
nchnls = 8

  instr 1 ;first order
aSnd[]     diskin     "ClassGuit.wav"
kAzim      line       0, p3, 360
iSetup     =          4 ;octogon
aw, ax, ay, az bformenc1 aSnd[0], kAzim, 0
a1, a2, a3, a4, a5, a6, a7, a8 bformdec1 iSetup, aw, ax, ay, az
           out        a1, a2, a3, a4, a5, a6, a7, a8
  endin

  instr 2 ;second order
aSnd[]     diskin     "ClassGuit.wav"
kAzim      line       0, p3, 360
iSetup     =          4 ;octogon
aw, ax, ay, az, ar, as, at, au, av bformenc1 aSnd, kAzim, 0
a1, a2, a3, a4, a5, a6, a7, a8 bformdec1 iSetup,
                      aw, ax, ay, az, ar, as, at, au, av
           out        a1, a2, a3, a4, a5, a6, a7, a8
  endin

  instr 3 ;third order
aSnd[]     diskin     "ClassGuit.wav"
kAzim      line       0, p3, 360
iSetup     =          4 ;octogon
aw,ax,ay,az,ar,as,at,au,av,ak,al,am,an,ao,ap,aq bformenc1 aSnd, kAzim, 0
a1, a2, a3, a4, a5, a6, a7, a8 bformdec1 iSetup,
        aw, ax, ay, az, ar, as, at, au, av, ak, al, am, an, ao, ap, aq
           out        a1, a2, a3, a4, a5, a6, a7, a8
  endin
</CsInstruments>
<CsScore>
i 1 0 6
i 2 7 6
i 3 14 6
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "05 B. PANNING AND SPATIALIZATION".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/05-b-panning-and-spatialization.md](../chapters/05-b-panning-and-spatialization.md)
