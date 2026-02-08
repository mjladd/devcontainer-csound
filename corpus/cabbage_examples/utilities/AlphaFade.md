---
source: Cabbage Examples
category: Utilities
file: examples/Miscellaneous/AlphaFade.csd
title: "AlphaFade"
type: cabbage_example
widgets: [form, rslider]
---

# AlphaFade

**Category:** Utilities
**Source File:** `examples/Miscellaneous/AlphaFade.csd`
**Cabbage Widgets:** form, rslider

## Description

sr is set by the host Rory. 2014 the alpha identifier allows one to control the alpha blend for an entire widget. 0 will make the widget insible while 1 will make it visible

## Code

```csound
<Cabbage>
form caption("Alpha") size(385, 220), guiMode("queue") pluginId("AlpF")
rslider bounds(14, 10, 160, 160), channel("slider1")
rslider bounds(200, 10, 160, 160), channel("slider2")
</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-d -n
</CsOptions>
<CsInstruments>
;sr is set by the host
ksmps 		= 	32
nchnls 		= 	2
0dbfs		=	1
;Rory. 2014

;the alpha identifier allows one to control the alpha
;blend for an entire widget. 0 will make the widget insible
;while 1 will make it visible

instr	1
kTrig metro 10
kLeft oscili 1, .5, -1, .5
kRight oscili 1, .5, -1
cabbageSet kTrig, "slider1", "alpha", (kLeft+1)/2
cabbageSet kTrig, "slider2", "alpha", (kRight+1)/2

cabbageSetValue "slider1", (kLeft+1)/2
cabbageSetValue "slider2", 1-(kLeft+1)/2
endin

</CsInstruments>
<CsScore>
i1 0 [3600*24*7]
</CsScore>
</CsoundSynthesizer>

```
