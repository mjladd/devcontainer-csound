# 06 B. RECORD AND PLAY BUFFERS - Code Example 1

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 06-b-record-and-play-buffers
- **Section:** Playing Audio from RAM - _flooper2_
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `06`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-odac ; activate real-time audio
</CsOptions>
<CsInstruments>
sr      =       44100
ksmps   =       32
nchnls  =       2
0dbfs   =       1

; STORE AUDIO IN RAM USING GEN01 FUNCTION TABLE
giSoundFile   ftgen   0, 0, 0, 1, "loop.wav", 0, 0, 0

  instr 1 ; play audio from function table using flooper2 opcode
kAmp         =         1   ; amplitude
kPitch       =         p4  ; pitch/speed
kLoopStart   =         0   ; point where looping begins (in seconds)
kLoopEnd     =         nsamp(giSoundFile)/sr; loop end (end of file)
kCrossFade   =         0   ; cross-fade time
; read audio from the function table using the flooper2 opcode
aSig         flooper2  kAmp,kPitch,kLoopStart,kLoopEnd,kCrossFade,giSoundFile
             out       aSig, aSig ; send audio to output
  endin

</CsInstruments>
<CsScore>
; p4 = pitch
; (sound file duration is 4.224)
i 1 0 [4.224*2] 1
i 1 + [4.224*2] 0.5
i 1 + [4.224*1] 2
e
</CsScore>
</CsoundSynthesizer>
; example written by Iain McCurdy
```

---

## Context

This code example is from the FLOSS Manual chapter "06 B. RECORD AND PLAY BUFFERS".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/06-b-record-and-play-buffers.md](../chapters/06-b-record-and-play-buffers.md)
