---
source: Cabbage Examples
category: Synthesizers
file: examples/Miscellaneous/FirstSynth.csd
title: "FirstSynth"
type: cabbage_example
widgets: [form, keyboard]
---

# FirstSynth

**Category:** Synthesizers
**Source File:** `examples/Miscellaneous/FirstSynth.csd`
**Cabbage Widgets:** form, keyboard

## Description

sr is set by the host

## Code

```csound
<Cabbage>
form size(380, 160), caption("Simple synth"), pluginId("1Syn")
keyboard bounds(12, 6, 360, 100)
</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 --midi-key-cps=4 --midi-velocity-amp=5
</CsOptions>
<CsInstruments>
;sr is set by the host
ksmps = 64
nchnls = 2
0dbfs=1

instr 1
kEnv madsr .1, .2, .6, .1
a1 oscili kEnv*p5, p4, 1
outs a1, a1
endin

</CsInstruments>
<CsScore>
f1 0 1024 10 1
f0 3600
</CsScore>
```
