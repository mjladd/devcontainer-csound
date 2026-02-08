---
source: Cabbage Examples
category: Utilities
file: examples/Miscellaneous/CabbageOSCSend.csd
title: "CabbageOSCSend"
type: cabbage_example
widgets: [form, rslider]
---

# CabbageOSCSend

**Category:** Utilities
**Source File:** `examples/Miscellaneous/CabbageOSCSend.csd`
**Cabbage Widgets:** form, rslider

## Description

sr is set by the host

## Code

```csound
<Cabbage>
form caption("OSCSend"), size(270, 160), pluginId("OSCS"), guiRefresh(10)
rslider bounds(10, 10, 110, 110), channel("rslider1"), range(0, 1, 0, 1, 0.01)
rslider bounds(140, 10, 110, 110), channel("rslider2"), range(0, 1, 0, 1, 0.01)

</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-dm0 -n
</CsOptions>
<CsInstruments>
;sr is set by the host
ksmps 	= 	32
nchnls 	= 	2
0dbfs	=	1


instr 1
kData1 chnget "rslider1"
kData2 chnget "rslider2"


OSCsend   kData1+kData2, "localhost", 7770, "/foo/bar", "ff", kData1, kData2

endin

</CsInstruments>
<CsScore>
i 1 0 [3600*24*7]
</CsScore>
</CsoundSynthesizer>


```
