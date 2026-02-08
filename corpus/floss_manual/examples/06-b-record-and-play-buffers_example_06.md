# 06 B. RECORD AND PLAY BUFFERS - Code Example 7

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 06-b-record-and-play-buffers
- **Section:** Encapsulating Record and Play Buffer Functionality to a UDO
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `06`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-i adc -o dac -m128
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 1
0dbfs = 1

/****** UDO definitions ******/
opcode createBuffer, i, i
 ilen xin
 ift ftgen 0, 0, ilen*sr, 2, 0
 xout ift
endop
opcode recordBuffer, 0, aik
 ain, ift, krec  xin
 setksmps  1 ;k=a here in this UDO
 kndx init 0 ;initialize index
 if krec == 1 then
  tablew ain, a(kndx), ift
  kndx = (kndx+1) % ftlen(ift)
 endif
endop
opcode keyPressed, k, kki
 kKey, kDown, iAscii xin
 kPrev init 0 ;previous key value
 kOut = (kKey == iAscii || (kKey == -1 && kPrev == iAscii) ? 1 : 0)
 kPrev = (kKey > 0 ? kKey : kPrev)
 kPrev = (kPrev == kKey && kDown == 0 ? 0 : kPrev)
 xout kOut
endop
opcode playBuffer, a, ik
 ift, kplay  xin
 setksmps  1 ;k=a here in this UDO
 kndx init 0 ;initialize index
 if kplay == 1 then
  aRead table a(kndx), ift
  kndx = (kndx+1) % ftlen(ift)
 endif
endop


instr RecPlay
 iBuffer = createBuffer(3) ;buffer for 3 seconds of recording
 kKey, kDown sensekey
 recordBuffer(inch(1), iBuffer, keyPressed(kKey,kDown,114))
 out playBuffer(iBuffer, keyPressed(kKey,kDown,112))
endin

</CsInstruments>
<CsScore>
i 1 0 1000
</CsScore>
</CsoundSynthesizer>
;example written by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "06 B. RECORD AND PLAY BUFFERS".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/06-b-record-and-play-buffers.md](../chapters/06-b-record-and-play-buffers.md)
