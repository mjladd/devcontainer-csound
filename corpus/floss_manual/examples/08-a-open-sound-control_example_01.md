# 08 A. OPEN SOUND CONTROL - Code Example 2

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 08-a-open-sound-control
- **Section:** Send/Receive more than one data type in a message
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
ksmps = 32
nchnls	= 2
0dbfs	= 1

giPortHandle OSCinit 47120

instr Send
 kSendTrigger = 1
 kFloat = 1.23456789
 Sstring = "bla bla"
 OSCsend kSendTrigger, "", 47120, "/exmp_2/more", "fs", kFloat, Sstring
endin

instr Receive
 kReceiveFloat init 0
 SReceiveString init ""
 kGotIt OSClisten giPortHandle, "/exmp_2/more", "fs",
                  kReceiveFloat, SReceiveString
 if kGotIt == 1 then
  printf "kReceiveFloat = %f\nSReceiveString = '%s'\n",
         1, kReceiveFloat, SReceiveString
 endif
endin

</CsInstruments>
<CsScore>
i "Receive" 0 3 ;start listening process first
i "Send" 1 1    ;then after one second send message
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "08 A. OPEN SOUND CONTROL".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/08-a-open-sound-control.md](../chapters/08-a-open-sound-control.md)
