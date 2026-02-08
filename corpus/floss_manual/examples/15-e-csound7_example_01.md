# 15 E. NEW FEATURES IN CSOUND 7 - Code Example 2

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 15-e-csound7
- **Section:** Arrays
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

instr ArrayDef

  freq:i[] = [500,600,700]
  vals:k[] = [3,5,7,8]
  ser:i[] = [1 ... 10] //shortcut
  files:S[] = ["bla.wav","blu.flac"]
  sound:a[] = diskin("fox.wav")
  printarray(ser)
  turnoff

endin

instr ArrayExample

  // two random k-rate envelopes in an array
  env:k[] = [randomi:k(-20,0,15,3),randomi:k(-20,0,15,3)]

  // two mono sound streams
  a1 = diskin:a("fox.wav",randomi:k(.7,1.1,1,3),0,1)
  a2 = diskin:a("ClassGuitMono.wav",randomi:k(.8,1.3,1,3),0,1)

  // apply envelopes and put into array
  audio:a[] = [a1*ampdb(env[0]), a2*ampdb(env[1])]

  // sometimes swap the audio channels (clicks may occur)
  if (randomh:k(0,2,1,3) > 1) then
    audio = [audio[1], audio[0]]
  endif

  // output
  out(audio)

endin

</CsInstruments>
<CsScore>
i 1 0 1
i 2 0 10
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "15 E. NEW FEATURES IN CSOUND 7".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/15-e-csound7.md](../chapters/15-e-csound7.md)
