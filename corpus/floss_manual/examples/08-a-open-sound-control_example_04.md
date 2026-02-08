# 08 A. OPEN SOUND CONTROL - Code Example 5

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 08-a-open-sound-control
- **Section:** Send/Receive audio
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `08`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-m 128
</CsOptions>
<CsInstruments>

sr	= 44100
ksmps = 128
nchnls	= 2
0dbfs	= 1

giPortHandle OSCinit 47120

instr Send
 kSendTrigger init 1
 aSend poscil .2, 400
 OSCsend kSendTrigger, "", 47120, "/exmp_5/audio", "a", aSend
 kSendTrigger += 1
endin

instr Receive
 aReceive init 0
 kGotIt OSClisten giPortHandle, "/exmp_5/audio", "a", aReceive
 out aReceive, aReceive
endin

</CsInstruments>
<CsScore>
i "Receive" 1 3
i "Send" 0 5
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "08 A. OPEN SOUND CONTROL".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/08-a-open-sound-control.md](../chapters/08-a-open-sound-control.md)
