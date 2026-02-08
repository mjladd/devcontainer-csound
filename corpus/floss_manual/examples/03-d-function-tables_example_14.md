# 03 D. FUNCTION TABLES - Code Example 15

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 03-d-function-tables
- **Section:** Reading a Text File in a Function Table
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
nchnls = 2
0dbfs = 1

//create a function table with the drawing data from a file
giDrawing = ftgen(0,0,0,-23,"drawing_data.txt")

//sound file to be played
gS_file = "fox.wav"

instr ReadTable

  //index as pointer from start to end of the table over duration (p3)
  kIndx = linseg:k(0,p3,100)
  //values are read at k-rate with interpolation as a global variable
  gkDrawVals = tablei:k(kIndx,giDrawing)

endin

instr PlayWithData

  //calculate the skiptime for the sound file compared to the duration
  kFoxSkip = (timeinsts:k() / p3) * filelen(gS_file)

  //trigger the grains in the frequency of the drawing (density)
  kTrig = metro(gkDrawVals)

  //if one grain is triggered
  if kTrig==1 then

    //calculate the grain duration as half the reciprocal of the density
    kGrainDuration = 0.5/gkDrawVals

    //call the grain and send the skiptime
    schedulek("PlayGrain",0,kGrainDuration,kFoxSkip)

  endif

endin

instr PlayGrain

  //get the skiptime from the calling instrument
  iSkip = p4
  //read the sound from disk at this point
  aSnd diskin gS_file,1,iSkip
  //apply triangular envelope
  aOut = linen:a(aSnd,p3/2,p3,p3/2)
  //output
  outall(aOut)

endin

</CsInstruments>
<CsScore>
i "ReadTable" 0 10
i "PlayWithData" 0 10
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "03 D. FUNCTION TABLES".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/03-d-function-tables.md](../chapters/03-d-function-tables.md)
