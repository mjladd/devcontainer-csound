---
source: Csound Journal
issue: 13
title: "Using the Signal Flow Graph Opcodes"
author: "Csound
instrument definitions"
url: https://csoundjournal.com/issue13/signalFlowGraphOpcodes.html
---

# Using the Signal Flow Graph Opcodes

**Author:** Csound
instrument definitions
**Issue:** 13
**Source:** [Csound Journal](https://csoundjournal.com/issue13/signalFlowGraphOpcodes.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 13](https://csoundjournal.com/index.html)
## Using the Signal Flow Graph Opcodes
 Michael Gogins
michael.gogins AT gmail.com
## Introduction


This article introduces the new signal flow graph opcodes in Csound, and demonstrates several ways of using them, including routing through effects chains for mastering, and creating a library of re-usable instrument patches.

I created these opcodes because I was not happy with existing means of routing signals in Csound: the `*zak*` opcodes, the numbered control busses, the named control busses, the *table* opcodes, the *mixer* opcodes (also created by me), and plain old global variables.

I was unhappy not because these other solutions do not work – they all work – but because of my exposure to Buzz, the freeware tracker [[1]](https://csoundjournal.com/#ref1). Although I have never completed a piece of music in Buzz, the minute I began playing around with it, I had that "ah-ha" sensation, "this is a really good piece of software. This is the way this kind of software should work." In Buzz, the user puts down "machines" on a canvas and connects them with lines, which represent signal flow. The machines can be "effects" or "generators" and they can be connected in any manner desired – as long as there are no feedback loops. (The notes and other events that drive the patch are stored in "tracks," and normally there is one track per machine.) ![image](UsingTheSignalFlowGraphOpcodes/signalFlowGraphOpcodes_html_m4e9e5aa.png)

**Figure 1.** Buzz Signal Flow Graph.

Technically this is known as a “signal flow graph”, which is another name for “synchronous data flow language." Mathematically speaking, it is a “directed acyclical graph”. I was very impressed with the sound design and complexity of various example Buzz songs. I was even more impressed at how easy it was to edit and change the arrangement of instruments and the effects routing in the examples, while they were playing, in comparison with working in Cubase, with which I was much more familiar.

It became obvious to me that signal flow graphs are far more flexible than mixers with channel strips, busses, submasters, and masters. I was not surprised to find many other examples of music software using signal flow graphs, including Max/MSP[[2]](https://csoundjournal.com/#ref2) and Pure Data[[3]](https://csoundjournal.com/#ref3), the many Buzz clones[[4]](https://csoundjournal.com/#ref4), Linux synthesizers such as gAlan[[5]](https://csoundjournal.com/#ref5) and SpiralSynthModular[[6]](https://csoundjournal.com/#ref6), the nice Analog Box[[7]](https://csoundjournal.com/#ref7) program on Windows, the Linux audio routing system Jack[[8]](https://csoundjournal.com/#ref8), and so on.

Still, Buzz still turns out to be easier to use for audio routing than any of these, as Buzz only has one kind of wire, and Buzz machines accept any number of connections.

Frankly, I do not know why the mixer paradigm continues to dominate commercial studio software. Perhaps it is just tradition. Perhaps it saves time for producers in a hurry, though I really doubt that.

Csound internally does not use a pure signal flow graph design, although it probably should be changed to do so. The signal flow graph model is in fact used by Csound instrument definitions; the connections between nodes in the graph are created by variables, which serve as the wires that connect the outputs of source opcodes to the inputs of sink opcodes. But globally, in the Csound orchestra, each instrument definition functions like a channel strip in a mixer that feeds, usually, directly into the master outputs. This is partly because krate and arate opcodes cannot be used in the orchestra header, and partly because Csound would not know what to do with automatically allocated instances of instrument definitions.

All the various signal routing facilities in Csound have been created to make this default routing scheme more flexible.

The signal flow graph opcodes are designed to bring the signal flow graph model of sound processing up into the Csound orchestra header, where it can be used to arrange instrument definitions that feed into each other in any way that does not involve feedback, and will handle multiple instances of the same instrument. I have also designed the system of opcodes in such a way as to make it easy for instruments to be defined in files that can then be `#included` in a master orchestra file.
## I. Example of Use


It is probably best to begin with an example, which I adapted from the Csound manual:
```csound

<CsoundSynthesizer>
<CsOptions>
-Wfo SignalFlowGraph1.wav
</CsOptions>
<CsInstruments>

; Initialize the global variables.

sr 	= 44100
ksmps 	= 100
nchnls = 2

; Connect up instruments and effects to create the signal flow graph.

connect "SimpleSine",   	"leftout",     "Reverberator",     	"leftin"
connect "SimpleSine",   	"rightout",    "Reverberator",     	"rightin"

connect "Moogy",        	"leftout",     "Reverberator",     	"leftin"
connect "Moogy",        	"rightout",    "Reverberator",     	"rightin"

connect "Reverberator", 	"leftout",     "Compressor",       	"leftin"
connect "Reverberator", 	"rightout",    "Compressor",       	"rightin"

connect "Compressor",   	"leftout",     "Soundfile",       	"leftin"
connect "Compressor",   	"rightout",    "Soundfile",       	"rightin"

; Turn on the "effect" units in the signal flow graph.

alwayson "Reverberator", 0.91, 12000
alwayson "Compressor"
alwayson "Soundfile"

; Define instruments and effects in order of signal flow.

			instr SimpleSine
                	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			; Default values:   p1  p2  p3  p4  p5  p6  p7  p8  p9  p10
			pset			0,  0,  10, 0,  0,  0,  0.5
iattack		=			0.015
idecay			=			0.07
isustain		=			p3
irelease		=			0.3
p3			=			iattack + idecay + isustain + irelease
adamping		linsegr		0.0, iattack, 1.0, idecay + isustain, 1.0, \
						irelease, 0.0
iHz 			= 			cpsmidinn(p4)
                	; Rescale MIDI velocity range to a musically usable range of dB.
iamplitude 		= 			ampdb(p5 / 127 * 15.0 + 60.0)
			; Use ftgenonce instead of ftgen, ftgentmp, or f statement.
icosine		ftgenonce 		0, 0, 65537, 11, 1
aoscili		oscili 		iamplitude, iHz, icosine
aadsr 			madsr 			iattack, idecay, 0.6, irelease
asignal 		= 			aoscili * aadsr
aleft, aright	pan2	asignal, p7
			; Stereo audio output to be routed in the orchestra header.
			outleta 		"leftout", aleft
			outleta 		"rightout", aright
			endin

			instr Moogy
                	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			; Default values:   p1  p2  p3  p4  p5  p6  p7  p8  p9  p10
			pset			0,  0,  10, 0,  0,  0,  0.5
iattack		=			0.003
isustain		=			p3
irelease		=			0.05
p3			=			iattack + isustain + irelease
adamping		linsegr		0.0, iattack, 1.0, isustain, 1.0, irelease, 0.0
iHz 			= 			cpsmidinn(p4)
                	; Rescale MIDI velocity range to a musically usable range of dB.
iamplitude 		= 			ampdb(p5 / 127 * 20.0 + 60.0)
			print 			iHz, iamplitude
			; Use ftgenonce instead of ftgen, ftgentmp, or f statement.
isine 			ftgenonce 		0, 0, 65537, 10, 1
asignal 		vco 			iamplitude, iHz, 1, 0.5, isine
kfco 			line 			2000, p3, 200
krez 			= 			0.8
asignal 		moogvcf 		asignal, kfco, krez, 100000
asignal		=			asignal * adamping
aleft, aright	pan2	asignal, p7
			; Stereo audio output to be routed in the orchestra header.
			outleta 		"leftout", aleft
			outleta 		"rightout", aright
			endin

			instr Reverberator
                	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			; Stereo input.
aleftin 		inleta 		"leftin"
arightin 		inleta 		"rightin"
idelay 		= 			p4
icutoff 		= 			p5
aleft, aright 	reverbsc 	    	aleftin, arightin, idelay, icutoff
			; Stereo output.
			outleta 	    	"leftout", aleft
			outleta 	    	"rightout", aright
			endin

			instr Compressor
                	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			; Stereo input.
aleftin 		inleta 		"leftin"
arightin 		inleta 		"rightin"
kthreshold 		= 		      	25000
icomp1 		= 		       0.5
icomp2 		= 		       0.763
irtime 		= 		       0.1
iftime 		= 		       0.1
aleftout 		dam 	aleftin, kthreshold, icomp1, icomp2, irtime, iftime
arightout 		dam 	arightin, kthreshold, icomp1, icomp2, irtime, iftime
			; Stereo output.
			outleta 	      	"leftout", aleftout
			outleta 	     	"rightout", arightout
			endin

			instr Soundfile
                	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			; Stereo input.
aleftin 		inleta 		"leftin"
arightin 		inleta 		"rightin"
			outs 		      	aleftin, arightin
			endin

</CsInstruments>
<CsScore>

; It is not necessary to activate "effects" or create f-tables in the score!
; Overlapping notes create new instances of instruments with proper connections.

i "SimpleSine" 1 5 60 85
i "SimpleSine" 2 5 64 80
i "Moogy" 3 5 67 75
i "Moogy" 4 5 71 70
e 1

</CsScore>
</CsoundSynthesizer>
```


 This example is fairly self-explanatory, but I will continue with further explanation.

The `*connect*` opcode declares that an outlet in one `instr` block is connected to an inlet in another `instr` block. This opcode is used first in the orchestra to establish the topology of the signal flow graph. For any given connection, all outlets and inlets must carry the same type of signal.

Inside the instrument definitions, the *inlet* and *outlet* opcodes receive and send signals of the appropriate type from the outlets and inlets, respectively, to which they have been connected. There may be any number of inlets feeding an outlet, and any number of outlets feeding an inlet. In fact, connections are copied when new instances of instruments are allocated by Csound. For example, when the `SimpleSine` instrument is copied to begin playing the second note in the score, the second copy of the instrument also gets copies of the connections to the `Reverberator` effect. Inlets and outlets work with arate, krate, or fsig variables such as *inleta* and *outleta*, *inletk* and *outletk*, and *inletf* and *outletf*.

An instrument such as `SimpleSine` or `Moogy` in the example normally has only outlets, which are used for audio output instead of the regular opcodes such as *outs* or *outc*. An "effect" such as `Reverberator` normally has inlet opcodes at the beginning of the instrument definition, and outlet opcodes at the end (although in fact they can go anywhere in the code).

The key to the signal flow graph concept is that inlets and outlets are abstract. They have no meaning until instrument definitions are hooked up with the *connect* opcode.

Note the *alwayson* opcodes in the orchestra header. These can be used to activate an instrument from the orchestra header instead of from the score. To me, this seems like a more natural way of defining "effects" in Csound. The *alwayson* opcode functions just like an `i` statement in the score, even accepting pfields just as `i` statements do, but it turns on the instrument at the beginning of performance, and the instrument stays on until the end of performance.

Finally, note the *ftgenonce* opcode inside the instrument definitions. These are used in place of function table statements in the score. The function table is generated once by the opcode and reused by all copies of the opcode in different instances of the instrument. If any of the arguments to the *ftgenonce* opcode change, the table is regenerated.

Again, with the inlet, outlet, and *ftgenonce* opcodes, instrument definitions become completely self-contained, and therefore completely abstracted from the score.

The next section shows how such instruments can be defined outside an orchestra and then combined in various arrangements and mixing topologies by different master orchestras.
## II. Patch Libraries


Suppose we want to develop a consistent schema for maintaining a large library of patches. Rather than having a separate copy of each instrument definition in the orchestra for each new piece, we will create one central definition of each instrument which can then be shared by any number of pieces.

Whenever we want to use an instrument in a new piece, we can simply `#include` that patch. Whenever we refine an instrument definition for a new piece, we can go back and simply rerender all older pieces that use that patch to obtain the improved sound. Whenever we want to change the arrangement of instruments or the order or type of effects processing for a composition, we can simply edit the orchestra header.

To implement the approach outlined above we need to:
-

Use the *ftgenonce* opcode for all function table definitions in our instruments.
-

Use only the inlet and outlet opcodes for all signal routing to and from our instruments and effects.
-

Use one consistent scheme of pfields for all instrument definitions.
-

Place all instrument definitions in separate patch files that contain no orchestra header code.
-

In each actual composition, in the orchestra header, use the *connect* opcode to establish the signal flow routing, `#include` all required instruments from separate patch files in the order of processing, and use the *alwayson* opcode to turn on and configure all “effects.”

The following scheme of pfields is used in all examples below:
-

Instrument number (Csound requirement).
-

Time (Csound requirement).
-

Duration (Csound requirement).
-

Pitch as MIDI key number (60 is middle C).
-

Loudness as MIDI velocity number (0 is silence, 127 is loudest).
-

Phase (could be used e.g. to specify the phase of a grain, not used here).
-

X coordinate of spatial location (i.e. stereo pan).

Note that additional pfields, with meanings specific to a given instrument definition, may also be used, so long as they are not sent to an instrument for which they are not appropriate.
### Instrument Library


First, all the existing instrument definitions will be taken out of our example `.csd` and then each instrument definition will be placed into its own separate patch library file (`.ins` for instrument), such as below in the `SimpleSine.ins`:
```csound

			instr SimpleSine
                	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			; Default values:   p1  p2  p3  p4  p5  p6  p7  p8  p9  p10
			pset			0,  0,  10, 0,  0,  0,  0.5
iattack		=			0.015
idecay			=			0.07
isustain		=			p3
irelease		=			0.3
p3			=			iattack + idecay + isustain + irelease
adamping		linsegr		0.0, iattack, 1.0, idecay + isustain, 1.0, \
					irelease, 0.0
iHz 			= 			cpsmidinn(p4)
                	; Rescale MIDI velocity range to a musically usable range of dB.
iamplitude 		= 			ampdb(p5 / 127 * 15.0 + 60.0)
			; Use ftgenonce instead of ftgen, ftgentmp, or f statement.
icosine		ftgenonce 		0, 0, 65537, 11, 1
aoscili		oscili 		iamplitude, iHz, icosine
aadsr 			madsr 			iattack, idecay, 0.6, irelease
asignal 		= 			aoscili * aadsr
aleft, aright	pan2	asignal, p7
			; Stereo audio output to be routed in the orchestra header.
			outleta 		"leftout", aleft
			outleta 		"rightout", aright
			endin
```


We will also create a patch library file for the following`PluckedStringGogins.ins`:
```csound

                    instr PluckedStringGogins
                    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
iattack		=			0.002
isustain		=			p3
irelease		=			0.05
p3				=			iattack + isustain + irelease
adamping		linsegr		0.0, iattack, 1.0, isustain, 1.0, irelease, 0.0
iHz 				= 			cpsmidinn(p4)
iamplitude 		= 			ampdb(p5)
				print 			iHz, iamplitude
aenvelope           transeg            1.0, p3, -3.0, 0.1
				; Use ftgenonce instead of ftgen, ftgentmp, or f statement.
isine 			ftgenonce 		0, 0, 4096, 10, 1
aexcite             poscil             1.0, 1, isine
asignal1		wgpluck2 		0.1, 1.0, iHz,         0.25, 0.22
asignal2		wgpluck2 		0.1, 1.0, iHz * 1.003, 0.20, 0.223
asignal3		wgpluck2 		0.1, 1.0, iHz * 0.997, 0.23, 0.224
apluckout           =                  (asignal1 + asignal2 + asignal3) * aenvelope
aleft, aright		pan2			apluckout * iamplitude * adamping, p7
				outleta		"rightout", aright
				outleta		"leftout", aleft
                    endin
```


The reason for putting each instrument definition into its own file is to enable the easy rearrangement of pieces. The instrument definitions are named, but when Csound runs it also assigns a number to each named instrument. These numbers are generated in the order in which the instruments are defined. Therefore, if the score uses numbers to indicate instruments, the arrangement of instruments can be changed by changing the order in which the patch files are included in the master `.csd` file.

For example:
```csound

#include "SimpleSine.ins"
#include "PluckedStringGogins.ins"
```


 assigns `SimpleSine` to instrument 1, and `PluckedStringGogins` to instrument 2; whereas:
```csound
#include "PluckedStringGogins.ins"
#include "SimpleSine.ins"
```


 assigns `PluckedStringGogins` to instrument 1, and `SimpleSine` to instrument 2.
### Effects Library


Next we can take all the existing effects definitions out of our example .csd and put them into an independent file as well, such as the `Effects.ins` below:
```csound

			instr Reverberator
                	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			; Stereo input.
aleftin 		inleta 		"leftin"
arightin 		inleta 		"rightin"
idelay 		= 			p4
icutoff 		= 			p5
aleft, aright 	reverbsc 	    	aleftin, arightin, idelay, icutoff
			; Stereo output.
			outleta 	    	"leftout", aleft
			outleta 	    	"rightout", arigh
			endin

			instr Compressor
                	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			; Stereo input.
aleftin 		inleta 		"leftin"
arightin 		inleta 		"rightin"
kthreshold 		= 		      	25000
icomp1 		= 		       0.5
icomp2 		= 		       0.763
irtime 		= 		       0.1
iftime 		= 		       0.1
aleftout 		dam 	   aleftin, kthreshold, icomp1, icomp2, irtime, iftime
arightout 		dam 	   arightin, kthreshold, icomp1, icomp2, irtime, iftime
			; Stereo output.
			outleta 	      	"leftout", aleftout
			outleta 	     	"rightout", arightout
			endin

			instr Soundfile
                	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			; Stereo input.
aleftin 		inleta 		"leftin"
arightin 		inleta 		"rightin"
			outs 		      	aleftin, arightin
			endin
```


 It is not so important to put each effect into its own independent patch file, although that certainly is possible, because the effects are controlled solely by the *alwayson* and *connect* opcodes in the orchestra header, and the number assigned by Csound to the effect is not so useful.
### Using Libraries in Master Orchestras


Now we can write a new master orchestra file to use these library files (`SignalFlowGraph2.csd`):
```csound

<CsoundSynthesizer>
<CsOptions>
-Wfo SignalFlowGraph2.wav
</CsOptions>
<CsInstruments>

; Initialize the global variables.

sr 		= 44100
ksmps 	= 100
nchnls = 2

; Connect up instruments and effects to create the signal flow graph.

connect "SimpleSine",   		"leftout",     "Reverberator",     	"leftin"
connect "SimpleSine",   		"rightout",    "Reverberator",     	"rightin"

connect "Moogy",        		"leftout",     "Reverberator",     	"leftin"
connect "Moogy",        		"rightout",    "Reverberator",     	"rightin"

connect "PluckedStringGogins",  "leftout",     "Compressor",     	"leftin"
connect "PluckedStringGogins",  "rightout",    "Compressor",     	"rightin"

connect "Reverberator", 		"leftout",     "Compressor",       	"leftin"
connect "Reverberator", 		"rightout",    "Compressor",       	"rightin"

connect "Compressor",   		"leftout",     "Soundfile",       	"leftin"
connect "Compressor",   		"rightout",    "Soundfile",       	"rightin"

; Turn on the "effect" units in the signal flow graph.

alwayson "Reverberator", 0.88, 12000
alwayson "Compressor"
alwayson "Soundfile"

; Define instruments and effects in order of signal flow.

#include "SimpleSine.ins"
#include "Moogy.ins"
#include "PluckedStringGogins.ins"
#include "Effects.ins"

</CsInstruments>
<CsScore>

; It is not necessary to activate "effects" or create f-tables in the score!
; Overlapping notes create new instances of instruments with proper connections.

i "SimpleSine" 1 5 60 85
i "SimpleSine" 2 5 64 80
i "PluckedStringGogins" 3 5 67 75
i "Moogy" 4 5 71 70
i "PluckedStringGogins" 5 5 71 79
e 1

</CsScore>
</CsoundSynthesizer>
```


In this case, note that the plucked string sound is not routed through the `Reverberator` effect, but directly to the `Compressor`. Note also that the `Reverberator` delay time has been reduced.

The whole point of this exercise is that now the same instruments and effects can be used again without change to realize a completely different arrangement and score such as in `SignalFlowGraph3.csd`, in this case a Csound rendering of J.S. Bach's *Passacaglia and Fugue in C# Minor *(BWV 582):
```csound

<CsoundSynthesizer>
<CsOptions>
--midi-key=4 --midi-velocity=5 -F bwv582.mid -WRfo SignalFlowGraph3.wav
</CsOptions>
<CsInstruments>

; Initialize the global variables.

sr 		= 44100
ksmps 		= 100
nchnls = 2


; Connect up instruments and effects to create the signal flow graph.

connect "PluckedStringGogins",  "leftout",     "Reverberator",     	"leftin"
connect "PluckedStringGogins",  "rightout",    "Reverberator",     	"rightin"

connect "Reverberator", 	    "leftout",     "Compressor",       	"leftin"
connect "Reverberator", 	    "rightout",    "Compressor",       	"rightin"

connect "Compressor",   	    "leftout",     "Soundfile",       	"leftin"
connect "Compressor",   	    "rightout",    "Soundfile",       	"rightin"

; Turn on the "effect" units in the signal flow graph.

alwayson "Reverberator", 0.8, 15000
alwayson "Compressor"
alwayson "Soundfile"

; Define instruments and effects in order of signal flow.

#include "PluckedStringGogins.ins"
#include "Effects.ins"

</CsInstruments>
<CsScore>

; It is not necessary to activate "effects" or create f-tables in the score!
; Overlapping notes create new instances of instruments with proper connections.

f 0 690

</CsScore>
</CsoundSynthesizer>
```


## Download


Download the example files [here](https://csoundjournal.com/UsingTheSignalFlowGraphOpcodes/UsingTheSignalFlowGraphOpcodes.zip).
## References


 [[1]] Buzzmachines.com. [http://www.buzzmachines.com](http://www.buzzmachines.com/)(15 April 2010)

 Jeskola.[http://www.jeskola.net](http://www.jeskola.net/)(15 April 2010)

 [[2]] Cycling '74. [http://cycling74.com/products/maxmspjitter](http://cycling74.com/products/maxmspjitter)(15 April 2010)

 [[3]] Pure Data -- Community Site. [http://puredata.info](http://puredata.info/)(15 April 2010)

 [[4]] Buzztard Related Software Packages. [http://www.buzztard.org/index.php/Related_Software_Packages](http://www.buzztard.org/index.php/Related_Software_Packages)(15 April 2010)

 [[5]] gAlan. The Graphical Audio Language. [http://galan.sourceforge.net](http://galan.sourceforge.net/) (15 April 2010)

 [[6]] SpiralSynthModular. [http://www.pawfal.org/Software/SSM](http://www.pawfal.org/Software/SSM)(15 April 2010)

 [[7]] Analog Box 2. [http://www.andyware.com/abox2](http://www.andyware.com/abox2)(15 April 2010)

 [[8]] Jack Audio Connection Kit. [http://jackaudio.org](http://jackaudio.org/)(15 April 2010)
