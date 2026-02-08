# 05 Hello MIDI Keys - Code Example 6

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 01-GS-05
- **Section:** The same is not the same ...
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `01`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-o dac
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 1
nchnls = 2
0dbfs = 1

instr Compare

  kMidi = linseg:k(81,12,57)
  kFreqLine_1 = mtof:k(kMidi)

  iFreqStart = mtof:i(81)
  iFreqEnd = mtof:i(57)
  kFreqLine_2 = linseg:k(iFreqStart,12,iFreqEnd)
  kMidiLine_2 = ftom:k(kFreqLine_2)

  prints("Time   Pitches_1  Freqs_1      Freqs_2  Pitches_2\n")
  prints("(sec)   (MIDI)     (Hz)          (Hz)     (MIDI)\n")
  printks("%2d      %.2f     %.3f      %.3f    %.2f\n", 1,
          timeinsts(), kMidi, kFreqLine_1, kFreqLine_2, kMidiLine_2)

  aOut_1 = poscil:a(0.2,kFreqLine_1)
  aOut_2 = poscil:a(0.2,kFreqLine_2)
  aFadeOut = linen:a(1,0,p3,1)
  out(aOut_1*aFadeOut,aOut_2*aFadeOut)

endin

</CsInstruments>
<CsScore>
i "Compare" 0 13
</CsScore>
</CsoundSynthesizer>
```

---

## Context

This code example is from the FLOSS Manual chapter "05 Hello MIDI Keys".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/01-GS-05.md](../chapters/01-GS-05.md)
