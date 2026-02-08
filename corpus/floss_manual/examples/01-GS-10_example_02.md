# 10 Hello Random - Code Example 3

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 01-GS-10
- **Section:** Random Walks
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `01`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-o dac -m 128
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 1
seed(54321)

instr RandomWalk
  //receive pitch and volume
  iMidiPitch = p4
  iDecibel = p5
  //create tone with fade-out and output
  aSine = poscil:a(ampdb:i(iDecibel),mtof:i(iMidiPitch))
  aOut = linen:a(aSine,0,p3,p3)
  outall(aOut)

  //get count
  iCount = p6
  //only continue if notes are left
  if (iCount > 1) then
    //notes are always following each other
    iStart = p3
    //next duration is plusminus half of the current maximum/minimum
    iDur = p3 + random:i(-p3/2,p3/2)
    //next pitch is plusminus a semitone maximum/minimum
    iNextPitch = iMidiPitch + random:i(-1,1)
    //next volume is plusminus 2dB maximum/minimum but
    //always in the range -50 ... -6
    iNextDb = iDecibel + random:i(-3,3)
    if (iNextDb > -6) || (iNextDb < -50) then
      iNextDb = -25
    endif
    //start the next instance
    schedule("RandomWalk",iStart,iDur,iNextPitch,iNextDb,iCount-1)
  //otherwise turn off
  else
    event_i("e",0,0)
  endif

  //print the parameters of this instance to the console
  prints("Note # %2d, Duration = %.3f, Pitch = %.2f, Volume = %.1f dB\n",
         50-iCount+1, p3, iMidiPitch, iDecibel)
endin
schedule("RandomWalk",0,2,71,-20,50)

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
```

---

## Context

This code example is from the FLOSS Manual chapter "10 Hello Random".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/01-GS-10.md](../chapters/01-GS-10.md)
