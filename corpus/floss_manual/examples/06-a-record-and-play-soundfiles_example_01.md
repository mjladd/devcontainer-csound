# 06 A. RECORD AND PLAY SOUNDFILES - Code Example 2

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 06-a-record-and-play-soundfiles
- **Section:** Writing Audio to Disk
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `06`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
; audio output destination is given as a sound file (wav format specified)
; this method is for deferred time performance,
; simultaneous real-time audio will not be possible
-oWriteToDisk1.wav -W
</CsOptions>
<CsInstruments>
sr     =  44100
ksmps  =  32
nchnls =  1
0dbfs  =  1

  instr 1 ; a simple tone generator
aEnv    expon    0.2, p3, 0.001           ; a percussive envelope
aSig    poscil   aEnv, cpsmidinn(p4)      ; audio oscillator
        out      aSig                     ; send audio to output
  endin
</CsInstruments>

<CsScore>
; two chords
i 1   0 5 60
i 1 0.1 5 65
i 1 0.2 5 67
i 1 0.3 5 71

i 1   3 5 65
i 1 3.1 5 67
i 1 3.2 5 73
i 1 3.3 5 78
</CsScore>
</CsoundSynthesizer>
; example written by Iain McCurdy
```

---

## Context

This code example is from the FLOSS Manual chapter "06 A. RECORD AND PLAY SOUNDFILES".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/06-a-record-and-play-soundfiles.md](../chapters/06-a-record-and-play-soundfiles.md)
