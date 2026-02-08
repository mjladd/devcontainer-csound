# 15 E. NEW FEATURES IN CSOUND 7 - Code Example 4

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 15-e-csound7
- **Section:** New UDO Syntax and Pass-by-reference
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
ksmps = 32
nchnls = 2
0dbfs = 1

// new UDO definition which implicitely changes the input array

opcode Destructive(arr:i[]):()
  for v,i in arr do
    arr[i] = -v
  od
endop

instr TestDestructive

  myarr:i[] = [1,2,3,4,5]
  printarray(myarr)
  Destructive(myarr)
  printarray(myarr)
  turnoff
endin


// old UDO definition does not change the input array as it is copied

opcode NonDestructive, 0, i[]
  arr:i[] xin
  for v,i in arr do
    arr[i] = -v
  od
endop

instr TestNonDestructive

  myarr:i[] = [1,2,3,4,5]
  printarray(myarr)
  NonDestructive(myarr)
  printarray(myarr)
  turnoff

endin


// routing an array of audio signals to hardware outputs
// /practical use case is for multichannel not stereo)

opcode Route(asigs:a[],hwouts:k[]):()
  for h,i in hwouts do
    outch(h,asigs[i])
  od
endop

instr ArrayRouting

  // array of hardware output channels (starting at 1)
  hw_out_chnls:k[] = [2,1]

  // array of audio signals
  audio_sigs:a[] = [poscil:a(.2,500),poscil:a(.2,400)]

  // output
  Route(audio_sigs,hw_out_chnls)

endin

</CsInstruments>
<CsScore>
i 1 0 1
i 2 0.1 1
i 3 0.2 3
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "15 E. NEW FEATURES IN CSOUND 7".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/15-e-csound7.md](../chapters/15-e-csound7.md)
