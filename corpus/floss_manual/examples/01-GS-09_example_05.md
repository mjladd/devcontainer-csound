# 09 Hello If - Code Example 6

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 01-GS-09
- **Section:** Nested 'if's
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

instr Nested_If
  // input situation (1 = yes)
  iSun = 1
  iNeedFruits = 1
  iAmHungry = 1
  iAmTired = 1
  // nested IFs
  if (iSun == 1) then        //sun is shining:
    if (iNeedFruits == 1) then  //i need fruits
      prints("I will go to the market\n")
    else                        //i do not need fruits
      prints("I will go to the woods\n")
    endif                       //end of the 'fruits' clause
  else                      //sun is not shining:
    if (iAmHungry == 1) then    //i am hungry
      prints("I will cook some food\n")
    else                        //i am not hungry
      if (iAmTired == 0) then       //i am not tired
        prints("I will learn more Csound\n")
      else                          //i am tired
        prints("I will have a rest\n")
      endif                         //end of the 'tired' clause
    endif                       //end of the 'hungry' clause
  endif                     //end of the 'sun' clause
endin

</CsInstruments>
<CsScore>
i "Nested_If" 0 0
</CsScore>
</CsoundSynthesizer>
```

---

## Context

This code example is from the FLOSS Manual chapter "09 Hello If".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/01-GS-09.md](../chapters/01-GS-09.md)
