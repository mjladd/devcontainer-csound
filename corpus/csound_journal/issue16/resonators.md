---
source: Csound Journal
issue: 16
title: "Resonators Plug-in for Ableton"
author: ""
url: https://csoundjournal.com/issue16/resonators.html
---

# Resonators Plug-in for Ableton

**Author:** Unknown
**Issue:** 16
**Source:** [Csound Journal](https://csoundjournal.com/issue16/resonators.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 16](https://csoundjournal.com/index.html)
## Resonators Plug-in for Ableton
 Giorgio Zucco
 Conservatorio G.Verdi, Torino, Italy
 giorgiozucco AT teletu.it
## Introduction


Resonators is a small application to be used as a plug-in for Ableton Live. It is based on a series of resonators built using the Csound opcode `mode`, and the GUI uses Max/MSP together with the `csound~` object. Software tools required are:
- Csound 5
- Max for Live
- The csound~ object for Max
- Ableton Live or Ableton Suite (8.1 or higher)
## I. Resonators UDO


The first step is to build the individual resonators based on modal frequencies taken from the Csound Manual[[1]](https://csoundjournal.com/#ref1). The project uses the `mode` opcode, a filter that simulates a mass-spring-damper system, which has the following syntax: ` aout **mode** ain, kfreq, kQ [, iskip] `

The file [resonatori.h](https://csoundjournal.com/resonators/files/resonatori.h) contains the code for resonators of various materials such as:
- Chladni plates
- Tibetan bowl
- Small Handbell
- Spinel sphere
- Vibraphone
- Wine Glass
- Membrane
- Dahina tabla
- Bayan tabla
- Red Cedar
- Redwood
- Douglas Fir wood
- Wooden bar
- Aluminum bar
- Xylophone
- Jegogan bars
- Chime tube
- Pot lid

The idea of the plug-in is to use a sound source from a track in Ableton (such as a drum loop) as the excitation signal for a resonator model. A simple resonator UDO (User-defined Opcode) example—using several instances of `mode` employing modal frequencies ratios—is shown below:
```csound

;Dahina tabla
;modal ratios [1, 2.89, 4.95, 6.99, 8.01, 9.02]

opcode Dahina_tabla,a,akk
asig,kpitch,kq xin

kfreq1 = 1
kfreq2 = 2.89
kfreq3 = 4.95
kfreq4 = 6.99
kfreq5 = 8.01
kfreq6 = 9.02

a1 mode  asig,kpitch*kfreq1,kq
a2 mode  asig,kpitch*kfreq2,kq
a3 mode  asig,kpitch*kfreq3,kq
a4 mode  asig,kpitch*kfreq4,kq
a5 mode  asig,kpitch*kfreq5,kq
a6 mode  asig,kpitch*kfreq6,kq

asum  sum  a1,a2,a3,a4,a5,a6
aout  balance  asum,asig
xout aout ; write output
endop

```

## II. Resonators Instrument


In the tool for Csound resonators, a simple conditional routine to choose the model of the resonator is shown below:
```csound

if (kreso == 6) kgoto Jegoganbars
if (kreso == 7) kgoto Aluminumbar
if (kreso == 8) kgoto Woodenbar

```


The complete resonators instrument, [resonators2.csd](https://csoundjournal.com/resonators/files/resonators2.csd), shows how input and output will be connected with the Max/MSP object csound~ :
```csound

<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr = 44100
kr = 4410
ksmps = 10
nchnls = 2
0dbfs = 1

#include	"resonatori.h"
	instr	1
a1,a2	ins
kreso	chnget	"select"	;to receive value from Max/MSP
kdamp	chnget	"damp"
kfrq	chnget	"freq"

if (kreso == 0) kgoto Membrane
if (kreso == 1) kgoto Chimetube1
if (kreso == 2) kgoto Chimetube2
if (kreso == 3) kgoto Chimetube3
if (kreso == 4) kgoto Chimetube4
if (kreso == 5) kgoto Potlit
if (kreso == 6) kgoto Jegoganbars
if (kreso == 7) kgoto Aluminumbar
if (kreso == 8) kgoto Woodenbar
if (kreso == 9) kgoto DouglasFirwood
if (kreso == 10) kgoto Redwood
if (kreso == 11) kgoto RedCedar
if (kreso == 12) kgoto Bayantabla
if (kreso == 13) kgoto Dahinatabla
if (kreso == 14) kgoto WineGlass
if (kreso == 15) kgoto Vibraphone1
if (kreso == 16) kgoto Vibraphone2
if (kreso == 17) kgoto Spinelsphere
if (kreso == 18) kgoto SmallHandbell
if (kreso == 19) kgoto Tibetanbowl
if (kreso == 20) kgoto Tibetanbowl2
if (kreso == 21) kgoto Tibetanbowl3

Membrane:

afilt1 Membrane a1,kfrq,kdamp
afilt2 Membrane a2,kfrq,kdamp
kgoto output

Chimetube1:
afilt1 Chime_tube1 a1,kfrq,kdamp
afilt2 Chime_tube1 a2,kfrq,kdamp
kgoto output

Chimetube2:
afilt1 Chime_tube2 a1,kfrq,kdamp
afilt2 Chime_tube2 a2,kfrq,kdamp
kgoto output

Chimetube3:
afilt1 Chime_tube3 a1,kfrq,kdamp
afilt2 Chime_tube3 a2,kfrq,kdamp
kgoto output

Chimetube4:
afilt1 Chime_tube4 a1,kfrq,kdamp
afilt2 Chime_tube4 a2,kfrq,kdamp
kgoto output

Potlit:
afilt1 Pot_lit a1,kfrq*0.8,kdamp
afilt2 Pot_lit a2,kfrq*0.8,kdamp
kgoto output

Jegoganbars:
afilt1 Jegogan_bars a1,kfrq,kdamp
afilt2 Jegogan_bars a2,kfrq,kdamp
kgoto output

Aluminumbar:
afilt1 Aluminum_bar a1,kfrq*0.6,kdamp
afilt2 Aluminum_bar a2,kfrq*0.6,kdamp
kgoto output

Woodenbar:
afilt1 Wooden_bar a1,kfrq,kdamp
afilt2 Wooden_bar a2,kfrq,kdamp
kgoto output

DouglasFirwood:
afilt1 Douglas_Fir_wood a1,kfrq,kdamp
afilt2 Douglas_Fir_wood a2,kfrq,kdamp
kgoto output

Redwood:
afilt1 Redwood a1,kfrq,kdamp
afilt2 Redwood a2,kfrq,kdamp
kgoto output

RedCedar:
afilt1 Red_Cedar a1,kfrq,kdamp
afilt2 Red_Cedar a2,kfrq,kdamp
kgoto output

Bayantabla:
afilt1 Bayan_tabla a1,kfrq,kdamp
afilt2 Bayan_tabla a2,kfrq,kdamp
kgoto output

Dahinatabla:
afilt1 Dahina_tabla a1,kfrq,kdamp
afilt2 Dahina_tabla a2,kfrq,kdamp
kgoto output

WineGlass:
afilt1 Wine_Glass a1,kfrq,kdamp
afilt2 Wine_Glass a2,kfrq,kdamp
kgoto output

Vibraphone1:
afilt1 Vibraphone1 a1,kfrq*0.3,kdamp
afilt2 Vibraphone1 a2,kfrq*0.3,kdamp
kgoto output

Vibraphone2:
afilt1 Vibraphone2 a1,kfrq*0.3,kdamp
afilt2 Vibraphone2 a2,kfrq*0.3,kdamp
kgoto output

Spinelsphere:
afilt1 Spinel_sphere a1,kfrq,kdamp
afilt2 Spinel_sphere a2,kfrq,kdamp
kgoto output

SmallHandbell:
afilt1 Small_Handbell a1,kfrq,kdamp
afilt2 Small_Handbell a2,kfrq,kdamp
kgoto output

Tibetanbowl:
afilt1 Tibetan_bowl a1,kfrq*0.7,kdamp
afilt2 Tibetan_bowl a2,kfrq*0.7,kdamp
kgoto output

Tibetanbowl2:
afilt1 Tibetan_bowl2 a1,kfrq*0.7,kdamp
afilt2 Tibetan_bowl2 a2,kfrq*0.7,kdamp
kgoto output

Tibetanbowl3:
afilt1 Tibetan_bowl3 a1,kfrq*0.7,kdamp
afilt2 Tibetan_bowl3 a2,kfrq*0.7,kdamp
kgoto output

output:
outs	afilt1,afilt2
endin

</CsInstruments>
<CsScore>

i1 0 99999
</CsScore>
</CsoundSynthesizer>

```

## III. Max for Live


Max for Live is a tool kit for building new devices for Ableton Live with the Max/MSP language. The Max object csound~ enables communication between Max and Csound. Now examine the implementation of the Csound instrument in Max for Live. The simple GUI, shown in figure 1, will allow the choice of the model of the resonator through a menu. Two sliders will send frequency and damping values for the model chosen.

 In M4L, the object plugin~ sends the audio stream to csound~, which then sends the processed stereo audio to the object plugout~. Output values of the GUI communicate with the instrument through Csound modules using the `chnget` opocde. Input M4L variables, shown in figure 1, are "select" to choose the type of resonator, "freq" for frequency of the resonator, and "damp" for the quality factor of the filter. The object "pattrforward csound~" , shown in figure 1, receives the values and sends them to csound~.

![image](images/Resonators_1.png)

** Figure 1. Max for Live implementation of Resonators interface.**

In figure 2, the final presentation mode interface is used as an audio track plug-in in Live.

![image](images/Resonators_2.png)

** Figure 2. Ableton Live, showing Resonators as an audio track plug-in.**
## Conclusion


To use the plug-in you need to place the files resonators.amxd, resonatori.h, and resonators2.csd all in the same folder within the Ableton library. This was tested using Mac OSX and Windows 7, 64bit. You can download the files resonatori.h, resonators.amxd, and resonators2.csd here: [CsoundM4L.zip](https://csoundjournal.com/resonators/files/ResonatorsM4L.zip). Also several sound examples for listening to the resonators are available: [Original Loop (MP3)](https://csoundjournal.com/resonators/original loop.mp3), [Small Handbell (MP3)](https://csoundjournal.com/resonators/small handbell.mp3), [Membrane (MP3)](https://csoundjournal.com/resonators/membrane.mp3), and [Multiple Resonators (3 instances) (MP3)](https://csoundjournal.com/resonators/multiple resonators (3 instances).mp3).
## Reference


[][1]]Scott Lindroth. "Modal Frequency Ratios," *The Canonical Csound Reference Manual*, Appendix E. [Online]. Available: [http://csounds.com/manual/html/MiscModalFreq.html](http://csounds.com/manual/html/MiscModalFreq.html). [Accessed December 7, 2011].
## Related Links


Ableton AG, "Max for Live,"* ableton.com*. [Online]. Available: [http://www.ableton.com/maxforlive](http://www.ableton.com/maxforlive). [Accessed December 7, 2011].

Barry Vercoe et Al. 2005. *The Canonical Csound Reference Manual*. [Online]. Available: [http://www.csounds.com/manual/html/index.html](http://www.csounds.com/manual/html/index.html). [Accessed December 7, 2011].

Davis Pyon, "csound~," davixology.com. [Online]. Available: [http://davixology.com/csound~.html](http://davixology.com/csound~.html). [Accessed December 7, 2011].
