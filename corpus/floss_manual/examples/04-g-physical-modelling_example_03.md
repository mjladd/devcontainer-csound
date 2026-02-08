# 04 G. PHYSICAL MODELLING - Code Example 4

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 04-g-physical-modelling
- **Section:** Introducing excitation
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `04`

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
nchnls = 1
0dbfs = 1

opcode  lin_reson, a, akk
setksmps 1
avel    init    0               ;velocity
ax      init    0               ;deflection x
ain,kf,kdamp    xin
kc      =       2-sqrt(4-kdamp^2)*cos(kf*2*$M_PI/sr)
aacel   =       -kc*ax
avel    =       avel+aacel+ain
avel    =       avel*(1-kdamp)
ax      =       ax+avel
        xout    ax
endop

instr 1
aexc    rand    p4
aout    lin_reson       aexc,p5,p6
        out     aout
endin

</CsInstruments>
<CsScore>
;               p4              p5      p6
;               excitaion       freq    damping
i1 0 5          .0001           440     .0001
</CsScore>
</CsoundSynthesizer>
;example by martin neukom
```

---

## Context

This code example is from the FLOSS Manual chapter "04 G. PHYSICAL MODELLING".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/04-g-physical-modelling.md](../chapters/04-g-physical-modelling.md)
