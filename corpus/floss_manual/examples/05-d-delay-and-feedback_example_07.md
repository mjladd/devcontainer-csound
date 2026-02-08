# 05 D. DELAY AND FEEDBACK - Code Example 8

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 05-d-delay-and-feedback
- **Section:** Custom Delay Line
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `05`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-odac ; activates real time sound output
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

instr CustomDelayLine

  ;; 0.25 second delay
  idel_size = 0.25 * sr
  kdelay_line[] init idel_size
  kread_ptr init 1
  kwrite_ptr init 0

  asig = vco2(0.3, 220 * (1 + int(lfo:k(3, 2, 2))) * expon(1, p3, 4), 10)
  asig = zdf_ladder(asig, 2000, 4)

  kindx = 0
  while (kindx < ksmps) do
    kdelay_line[kwrite_ptr] = asig[kindx]
    adel[kindx] = kdelay_line[kread_ptr]

    kwrite_ptr = (kwrite_ptr + 1) % idel_size
    kread_ptr = (kread_ptr + 1) % idel_size

    kindx += 1
  od

  out(linen:a(asig,0,p3,1),linen:a(adel,0,p3,1))

endin

</CsInstruments>
<CsScore>
i "CustomDelayLine" 0 10
</CsScore>
</CsoundSynthesizer>
;example by Steven Yi
```

---

## Context

This code example is from the FLOSS Manual chapter "05 D. DELAY AND FEEDBACK".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/05-d-delay-and-feedback.md](../chapters/05-d-delay-and-feedback.md)
