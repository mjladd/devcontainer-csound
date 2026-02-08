# 03 D. FUNCTION TABLES - Code Example 8

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 03-d-function-tables
- **Section:** GEN10: Creating a Waveform
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
ksmps = 64
0dbfs = 1
nchnls = 2
seed 13 ;try other values here

// create an array containing the number of four tables
gifn[ ] init 4

// create an array for 40 harmonics
ihar[ ] init 40

// for each table ...
ii = 0
while ii < 4 do

  // ... put 40 random amplitudes for the harmonics in it
 ik = 1
 while ik < 40 do
   // generate random values between 0 and 1
   irnd = abs(random:i(-1,1))
   // use only the ones above 0.8 and scale
   ihar[ik-1] = irnd < 0.8 ? 0 : irnd/ik
   ik += 1
 od
 // here the array is inserted as argument to GEN10
 gifn[ii] = ftgen(0,0,8192,10,ihar)
 ii += 1
od

instr Wavetable

  // set volume and base frequency
  iAmp = 0.2
  iFreq = 133

  // go table 1 -> 2 -> 3 -> 4 -> 1, then to a mix of all
  kh = linseg:k(0,10,1,10,1,10,0,10,0,10,0.5)
  kv = linseg:k(0,10,0,10,1,10,1,10,0,10,0.5)

  // read the four tables ...
  a1 = poscil:a(iAmp,iFreq,gifn[0])
  a2 = poscil:a(iAmp,iFreq,gifn[1])
  a3 = poscil:a(iAmp,iFreq,gifn[2])
  a4 = poscil:a(iAmp,iFreq,gifn[3])

  // ... and mix according to kh and kv
  aMix = (a1*(1-kh)+a2*kh)*(1-kv) + (a3*(1-kh)+a4*kh)*kv

  // fades and output
  aOut = linen:a(aMix,1,p3,10)
  outall(aOut)

endin

</CsInstruments>
<CsScore>
i "Wavetable" 0 60
</CsScore>
</CsoundSynthesizer>
;Example by Victor Lazzarini, adapted by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "03 D. FUNCTION TABLES".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/03-d-function-tables.md](../chapters/03-d-function-tables.md)
