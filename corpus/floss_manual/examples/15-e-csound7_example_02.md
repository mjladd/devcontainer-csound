# 15 E. NEW FEATURES IN CSOUND 7 - Code Example 3

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 15-e-csound7
- **Section:** For-Loops
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

instr K_loop_due_to_var

  // num is k so the loop runs at k-rate
  num:k init 0
  for num in [1,2,3,5,8] do
    printk(0,num)
  od
  turnoff

endin

instr I_Loop_Simple

  // num is not specified: i-rate because of the i-rate array
  for num in [1,2,3,5,8] do
    print(num)
  od

endin

instr I_Loop_With_Counter

  // the same but with loop counter
  for num,i in [1,2,3,5,8] do
    print(num,i)
  od

endin

instr Short

  strt:i init 0
  for freq in [200 ... 2000, 100] do // = [200, 300, ..., 2000]
    schedule(PlaySine,strt,5-strt,freq)
    strt += 1/8
  od

endin

instr PlaySine

  env:a = transeg(.1,p3,-3,0)
  outall(poscil:a(env,p4))

endin


</CsInstruments>
<CsScore>
i 1 0 1
i 2 0.1 0
i 3 0.2 0
i 4 0.3 1
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
```

---

## Context

This code example is from the FLOSS Manual chapter "15 E. NEW FEATURES IN CSOUND 7".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/15-e-csound7.md](../chapters/15-e-csound7.md)
