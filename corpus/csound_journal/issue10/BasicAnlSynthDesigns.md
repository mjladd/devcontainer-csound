---
source: Csound Journal
issue: 10
title: "Basic Analog Synthesizer Designs"
author: "Jacob Joaquin"
url: https://csoundjournal.com/issue10/BasicAnlSynthDesigns.html
---

# Basic Analog Synthesizer Designs

**Author:** Jacob Joaquin
**Issue:** 10
**Source:** [Csound Journal](https://csoundjournal.com/issue10/BasicAnlSynthDesigns.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 10](https://csoundjournal.com/index.html)
## Basic Analog Synthesizer Designs
 Jim Hearon
 j_hearon AT hotmail DOT com
## Introduction
 This article describes software synthesis implementations of simple analog synthesis designs. The modular nature of analog synthesizer modules allows voltage controlled units to be patched together freely in various combinations, however there are a few standard configurations. Several opcodes of analog synthesizer components, as well as example .csd files of analog synthesizer modules are included in Csound. Previous Csound instruments with Fast Light Toolkit guis by Josep M. Comajuncosas [[1]](https://csoundjournal.com/#ref1) and also examples in "Exploring Analogue Synth Techniques v2" by Jacob Joaquin [[2]](https://csoundjournal.com/#ref2) are referenced and acknowledged. This article is for simple instructive purposes and demonstrates how to create simple software implementations of analog synthesizer module configurations.
##
 I. Basic Configuration



Csound includes several opcodes which model analog synthesizer modules. Modules are modular synthesizer sound generating, control, and processing hardware units, constructed of electrical components, and available in customized configurations. The instruments included with this article model analog modules using different Csound instruments which are communicating via the zak opcodes. The basic components, shown in Figure 1, for a simple modular synthesizer can be configured employing a Voltage Controlled Oscillator, Voltage Controlled Filter, and Voltage Controlled Amplifier. A basic analog synthesizer configuration is easy to implement employing the *lfo*, *vco2*, *noise*, *moogvcf*, *zar*(as mixer), and *zarg*(as VCA) opcodes. See Example1.csd from the files available here. [SynthExs.zip](https://csoundjournal.com/SynthExs.zip).

*The Canonical Csound Reference Manual* contains alternate versions of some of the opcodes listed above. For example *vco*, and *vco2*; also *moogvcf*, and *moogvcf2*, as well as *moogladder*. In general the opcodes differ in terms of input parameters, but also have subtle differences in terms of audio quality as well, especially in frequency spectrum bandlimiting functions. Those features become apparent and useful when selecting various amplitude, waveform, and frequency settings which affect bandwidth based on the overall sample rate. The analog synthesizer is commonly associated with harmonically rich sounds which are sometimes the result of driving or overdriving analog components (resistors, capacitors, tubes, regulators), but in the digital domain, bandwidth and bitdepth limitations can quickly lead to amplitude saturation and clipping.

An additional concern in implementing analog designs, is how to change i-rate input parameters in realtime for some opcodes. In voltage controlled modules, the AC or DC power is usually on. In instrument design some instruments are designed as always on, while others are not; but in the instruments included with this article the instruments are on, or begin sounding once compiled, and continue to sound for the duration of p3. Another strategy would be to include an FLTK (Fast Light Toolkit) button to start the audio [[3]](https://csoundjournal.com/#ref3). In that way i-time variables can be initialized before the audio is started. Yet another approach, such as waveform switching for init-time variables in realtime, could be accomplished using the *reinit* and *rireturn* opcodes for brief reinitialization or slightly pausing the processing, then reinitializing the i-rate variables. In the examples for this article, since the FLTK graphics were kept to a minimum in order to avoid any realtime audio processing overhead, the i-rate variables were simply given an assignment in the .csd file. ![image](images/Synth1.png) **Figure 1.** Simple Modular Synthesizer.

The diagram shown in Figure 1 includes a summing or mixer module post VCO. Although there are several ways to implement mixing of audio signals in Csound, it was decided to use the zak opcodes for this purpose. One reason for the choice of zak opcodes is because of the *zarg* opcode which reads from a-rate space and allows adding additional gain at the k-rate. This opcode can be used to simulate the VCA component which is shown as the last module in the chain, allowing for efficient mixing and filtering when using the always on approach for instrument design.

Another interesting component of the basic configuration for an analog synthesizer is the implementation of a VCA with envelope control. A *phasor* was employed to read through a table containing line segments as envelope functions (*Gen 07*). One concern is that since the audio is always on, or running during the duration of p3, does a change in envelope in realtime simply jump to next k-rate value in the selected envelope or does the processing pause briefly (*reinit*) and then continue while the envelope begins anew or is reinitialized?

Instead of reinitializing the envelope's attack, or simply switching to the next k-value in a newly selected envelope, a "speed" function was added as multiplier to the *phasor* allowing the envelope's duration to be changed becoming longer or shorter in duration.
```csound
instr 4
;VCA with envelope
asig zarg 2, gk10 ;read a-rate from zak space and apply gain

kcps init 1/p3 ;calculate kndx speed from a table
kndx phasor kcps * gk12 ;multiplier increases speed
kenv tablekt kndx, int(gk11), 1, 0, 1 ;read thru table

out asig * kenv ;zak amp * gain from envelope table
zacl 0, 1 ;clear a-rate variables
endin
```


In the example above, "asig" is the audio coming from the VCF module with added gain as necessary. The speed of "phasor" strobing thru "kndx" is increased or decreased by the multiplier, as "kndx" is employed along with "tablekt" to change tables (envelopes) at the k-rate. The speed of an envelope on a VCA unit, as well as a delay, even a pan function are not uncommon on more sophisticated VCAs [[4].](https://csoundjournal.com/#ref4)
## II. Modulation Wheels



Another component common in analog as well as digital synthesizer designs is the modulation wheel. In Example2.csd from the SynthExs.zip, two modulation wheels are added to a simplified basic configuration. A pitch wheel normally changes control voltage and is fed from a keyboard into a Voltage Controlled Oscillator. The pitch range of the pitch bend, on digital synthesizers, is normally programmable, and in the included example a two-octave range is employed above and below a center frequency which is converted from Hertz to Octave Decimal Point using the *octpcs* opcode for ease of adding two-octaves to the given pitch.

In this example a straightforward approach is given employing the *vco2* opcode. Amplitude, frequency, and pulse width input parameters are variable at the k-rate using an *FLknob* gui component, and the audio output is fed to a VCF (Voltage Controlled Frequency) component using a zak opcode, before the audio is output to file or DAC.

The *vco2* opcode is a detailed opcode which includes the ability to add user programmable tables via *vco2init* as waveshapes for the i-mode parameter. The i-mode waveform input parameter was designed to be even numbers (0, 2, 4 – 14), where '14' is a user-programmable waveform. If serious about coding an intricate FLTK synthesizer gui using *vco2*, an interesting aside here is how to employ *FLknob* as a valuator to select only even numbers. For the *iexp* parameter, a positive number beyond '0' for linear or '-1' for exponential, indicates the number of an existing table that is used for indexing. A negative table number suppresses interpolation in the table created using "ftgen" providing discrete numbers. The following will provide the series of even numbers.
```csound
giwave ftgen 200, 0, 8, -2, 0, 1, 2, 3, 4, 5, 6, 7
gk8,ih8  FLknob  "WaveShape", 0, 2, -200, 1, -1,55, 265,45
```


The second wheel component is a modulation wheel. Mod wheels, especially on digital synthesizers, have become quite complicated due to the fact that performers like the ability to connect their mod wheel to all parameters. Standard mod wheel output is normally sent to the VCA module. In some cases mod wheel output is also looped back into the VCO as well[ [5]](https://csoundjournal.com/#ref5). One classical analog synthesizer approach is to employ modulation of the LFO, using the wheel to control the speed or level of the LFO output while it is being fed into a VCO. In example 2 a different approach is employed using a mod wheel to control a filter cutoff frequency for the *moogvcf2* opcode as VCF. The *moogladder* opcode could also be employed for this purpose. ![image](images/Synth2b.png) **Figure 2.** Basic Synthesizer with Mod Wheels.

The mod wheel controls the filter cut-off-frequency in Hertz of the *moogcvf2* opcode. Also an FLTK knob is provided allowing control for the amount of resonance in the filter. This simple algorithm then goes straight to file or DAC output via zak from the VCF.
## III. Portamento



Portamento is the continuous frequency transition from one frequency to the next instead of using discrete steps in the frequency parameter of the VCO. The terms Glide, Lag Processor, and Envelope are sometimes used for the Portamento function. In Example3.csd from the SynthExs.zip, a portamento function was added to the simplified VCO frequency dial by employing the *portk* opcode. Frequently in digital synthesizers the mod wheel can also be mapped to the glissando or portamento function. For modular analog synthesizers it is not uncommon to find a separate module devoted to lag processing[[6].](https://csoundjournal.com/#ref6) ![image](images/Synth3b.png) **Figure 3.** VCO with Portamento.

A more intricate approach to portamento exists as a somewhat accepted Csound practice which is to employ a *linseg* envelope, assign that to an oscillator, and use the oscillator's output as the basis to control the speed of the frequency gliss for a VCO. Csound includes several opcodes and examples which are somewhat score oriented for adding expression from one note to the next. Controlling vibrato, amplitude, tied notes, and speed of portamento or glissando are just some of the expression issues which are able to be solved through the use of opcodes such as *tival*, *lineto*, *tlineto*, *port*, *portk*, *tigoto*. The effective use and handling of expression controls can create a great deal of listener interest in an otherwise static piece of analog synthesizer music.
## IV. Additional Modules



There are numerous additional modules which are often found in modular analog synthesizer configurations. A step sequencer and also a keyboard should also considered part of the group of standard additional modules, and are generally present on most systems. The code below, from Example4.csd from the SynthExs.zip, shows a very simple eight-step sequencer with speed control. *GEN02* is used to hold the frequency of a particular step, and a *phasor* is employed to strobe through the table at a desired speed.
```csound
<CsoundSynthesizer>
<CsOptions>
csound -s -d -odevaudio -b4096 -B4096
</CsOptions>
<CsInstruments>

sr = 44100
kr = 44100
ksmps = 1
nchnls = 2

#include "Example4_FLTK.inc"
zakinit 3, 5
gitemp ftgen 100, 0, 8, -2, 1, 2, 3, 4, 5, 6, 7, 8

instr 1 ;STEP SEQUENCER
if gkButton >= 0 && gkButton <= 7 then
	tablew gk2, gkButton, 100
	endif
if (gkbut1 == 1) then
	kphase phasor gk4
	ilength = ftlen(100)
	kphase = kphase*ilength
	kval table kphase, 100
	a1 vco2 gk1, kval, 2, gk3, 0, .5
	zawm a1, 1, 1 ;write vco to zak space
elseif (gkbut1 ==0) then
	a1 vco2 gk1, gk2, 2, gk3, 0, .5
	zawm a1, 1, 1 ;write vco to zak space
endif
endin

instr 2 ;AUDIO outs
asig zarg 1, 1 ;read a-rate from zak space w/no extra gain
outs asig , asig

zacl 0, 1 ;clear a-rate variables or they will increase and clip
endin

</CsInstruments>
<CsScore>
i1 0 60
i2 0 60
e
</CsScore>
</CsoundSynthesizer>
```


**Figure 4.** Example of a simple 8-Step Sequencer.

Csound has several opcodes for working with sequences including *timedseq*, *seqtime*, *seqtime2*, and *trigseq*. Matt Ingalls also included a nice step sequencer demo as part of MacCsound at one point.

The piano style keyboard, especially for MIDI note entry, has also generally become part of the group of standard additional modules on most synthesizers. Some modular analog synthesizers, however, do not normally use a keyboard for note triggering, notably Buchla synths[[7].](https://csoundjournal.com/#ref7) Others have alternative style keyboards, sometimes featuring capacitance touch sensitive mechanisms. My first exposure to an alternative keyboard was on a Buchla Music Easel which had touch sensitive metal plates instead of a piano style keyboard. Csound features the "Virtual MIDI Keyboard" by Steven Yi, as well as the *sensekey*, and *FLkeyIn* opcodes. In addition you can use your own external MIDI keyboard with Csound.

Example5.csd from the SynthExs.zip, revises the portamento example from above to allow the VCO frequency parameter to be controlled by the computer keyboard. This simple approach uses code shown in the FLkeyIn.csd example by Andrés Cabrera from *The Canonical Csound Reference Manual*, and includes the *FLsetVal* opcode to change the position of the GUI FLknob frequency parameter by employing the global handle variable "gih2". Computer keyboard ASCII values are converted to MIDI values before sending them back to the frequency knob. Not all computer keyboards are mapped the same way, and mappings can be changed, therefore results vary.
```csound
<CsoundSynthesizer>
<CsOptions>
csound -s -d -odevaudio -b4096 -B4096
</CsOptions>
<CsInstruments>

; Initialize the global variables.
sr = 44100
kr = 44100
ksmps = 1
nchnls = 2

#include "Example5_FLTK.inc"
zakinit 3, 5

instr 1
kascii   FLkeyIn
ktrig changed kascii
if (kascii > 0) then
  ;printf "Key Down: %i\n", ktrig, kascii
  FLsetVal ktrig, cpsmidinn(kascii), gih2
endif
if (kascii < 0) then
  ;printf "Key Up: %i\n", ktrig, -kascii
endif

;if portamento unchecked use freq dial without glide
if (gkbut1==0) then
	a1 vco2 gk1, gk2, 2, gk3, 0, .5
	zawm a1, 1, 1 ;write vco to zak space
	endif
;if portamento checked use glide
if (gkbut1==1) then
 		kval portk gk2, gk4
		a1 vco2 gk1, kval, 2, gk3, 0, .5
		zawm a1, 1, 1 ;write vco to zak space
	endif

endin

instr 2
;AUDIO outs
asig zarg 1, 1 ;read a-rate from zak space w/no extra gain
outs asig , asig
zacl 0, 1 ;clear a-rate variables or they will increase and clip
endin

</CsInstruments>
<CsScore>
i1 0 60
i2 0 60
e
</CsScore>
</CsoundSynthesizer>
```


 [**Figure 5.** Example of ASCII keyboard Frequency control.
## V. Conclusion



Basic software synthesizer implementations of simple analog synthesis designs have been shown. The focus of the article was to keep the designs basic and simple, however alternative approaches have been listed which may require more code and resources. Alternative and creative approaches can also result in better sound quality, such as using more than one VCO per voice to gain a richer sound, employing feedback mechanisms, and creating more intricate, useful, and complex graphical interfaces for better control.

The simple designs employ basic modules for sound creation. There are many additional modules which should also be considered standard components for modular analog synthesizers such as Sample and Hold, Reverb, Delay, Chorus, Mixers, Sync Generators, Phasers, Envelope Generators, Filters and Gates to name a few, which could be coded and patched together to form a working modular synthesizer. Several Csounders have done this in more elegant and interesting designs.

Also there are many interesting variations on the standard modules in products such as Applied Acoustics Systems *Tassman 4*, Clavia's *Nord Modular G2 Demo*, Propellerhead's *Reason*, various virtual synthesizers by Arturia, etc., as well as hardware products such as Dave Smith Instruments, or any of the DIY kits or modular analog synthesizer units like those by PAiA Electronics, or Sound Transform Systems (*Serge*), etc. where modular synthesizers, both hardware and virtual, are alive and well and demonstrate creativity of design well beyond the original classical instruments of the 1960s and 70s.

Finally it is always tempting to employ Csound for the purpose of building the world's most versatile and expansive virtual synthesizer; but honestly, in my opinion, if working on the algorithmic orchestra and score level, it is better not to think of Csound as a tool for application building, rather one very powerful for sonic design and creation. What Csound lacks in terms of commercial ease and use of interfaces on the algorithmic level, it more than makes up for in the design and control of sound quality not normally attained simply through using commercial applications.
## Acknowledgements


[][1]] Joseph M Comajuncosas@cSounds.com. [http://www.csounds.com/jmc/](http://www.csounds.com/jmc/) (12 January 2009)

[][2]] Exploring Analogue Synthesis Techniques v2. [http://www.thumbuki.com/csound/articles/east/index.html](http://www.thumbuki.com/csound/articles/east/index.html) (12 January 2009)  The *EAST* tutorial (Exploring Analogue Synthesis Techniques v2) by Jacob Joaquin has excellent examples in a downloadable .zip file which includes basic and advanced analog techniques such as the step sequencer, portamento and glide, and pulse width modulation.

[][3]] Joseph M Comajuncosas@cSounds.com. [http://www.csounds.com/jmc/](http://www.csounds.com/jmc/) (12 January 2009)  These pages were last updated 2003. Many of the FLTK guis on the pages were written for use with CsoundAV, and demonstrate advanced use of FLTK. The *JCN Synthesis Tutorial*, located on the "Instruments" link in the sidebar shows the use of a start function. On the "Processors" sidebar link there is another link of interest to Joseph's reverb collection page for a huge collection of impulse responses.

[][4]] Dave Smith Instruments. [http://www.davesmithinstruments.com/](http://www.davesmithinstruments.com/) (12 January 2009)  The "Prophet '08" product features a sophisticated VCA.

[][5]] MiniMoog Schematic. [http://www.hylander.us/images/schematics/moog/minimoog-schematics.pdf](http://www.hylander.us/images/schematics/moog/minimoog-schematics.pdf) (12 January 2009)  There are several web sites showing schematics and diagrams of popular synthesizer designs. This site has several pages of MiniMoog diagrams. The "mod roller" is shown on page 2.

[][6]] Synthesizers.Com. [http://www.synthesizers.com/q105.html](http://www.synthesizers.com/q105.html) (12 January 2009)

[][7]]BUCHLA AND ASSOCIATES. [http://www.buchla.com/200e/index.html](http://www.buchla.com/200e/index.html) (12 January 2009)  Various configurations of modules listed including the Module 266e "Source of Uncertainty".
### Related Links


] Applied Acoustic Systems. [http://www.applied-acoustics.com/tassman.php](http://www.applied-acoustics.com/tassman.php) (12 January 2009)  The *Tassman 4* virtual modular synthesizer and other products.

]EMS: Electronic Music Studios. [http://www.ems-synthi.demon.co.uk/](http://www.ems-synthi.demon.co.uk/) (12 January 2009)  Advertised as "The World's Longest Established Synthesizer Manufacturer". UK. Interesting portable or so called "suitcase" models.

]Moog. [http://www.moogmusic.com/](http://www.moogmusic.com/) (12 January 2009)  Interesting Moog Guitar with Moog Ladder filter.

] nord®. [http://www.clavia.se/main.asp?tm=Products&clpm=Nord_Modular_G2](http://www.clavia.se/main.asp?tm=Products&clpm=Nord_Modular_G2) (12 January 2009)  The downloadable demo is a standalone modular synthesizer, mono version, with virtual patch chords for connecting modules together. There are several interesting non-standard modules such as the "Scratch" FX module, "Metallic noise oscillator" and various envelope shapers such as the "Wave Wrapper", for example.

]MODULAR SYNTH.COM. [http://www.modularsynth.com/](http://www.modularsynth.com/) (12 January 2009)  A good link for resources and finding additional links and information on modular synthesizer makers including hard to find makers without web pages such as STS.

]SYNTHEDIT. [http://www.synthedit.com/](http://www.synthedit.com/) (12 January 2009)  Interesting gui builder for virtual synthesizer designs on PC. The UML-type flow chart modeling window is similar to the *Tassman 4* patchable schematic "Builder" View.
