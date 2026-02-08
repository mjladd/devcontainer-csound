---
source: Csound Journal
issue: 23
title: "Building Csound based Systems for Real-time Chamber Music Performance: Part I"
author: "Enrico Francioni"
url: https://csoundjournal.com/issue23/RealtimeSystems1.html
---

# Building Csound based Systems for Real-time Chamber Music Performance: Part I

**Author:** Enrico Francioni
**Issue:** 23
**Source:** [Csound Journal](https://csoundjournal.com/issue23/RealtimeSystems1.html)

---

[CSOUND JOURNAL ISSUE 23](https://csoundjournal.com/index.html)

 [INDEX](http://www.csoundjournal.com/) | [ABOUT](https://csoundjournal.com/about.html) | [LINKS](https://csoundjournal.com/links.html)



     ![image](images/RealtimeSystems1Square.png)
# Building Csound based Systems for Real-time Chamber Music Performance

### Part I


by Enrico Francioni

## Introduction


Working with live electronics and real-time in Csound is a large subject area. In a way, all creative and performance practice with Csound can be said to fall within the area of live electronics —from simple playback of audio files, to the use of the same audio signal to trigger other events. When designing Csound systems for live performance, we must consider an number of issues and context-dependent requirements. This article discusses these issues and showcases a number of professional, and commercially released, solutions that were developed to realize two classic compositions: one by John Cage and another by Karlheinz Stockhausen. These complex working systems, whose requirements were set by their composers a long time before Csound existed, will help the reader to better understand how to manage their own real-time performance systems using Csound.
 A number of tutorials have been prepared that demonstrate many of the techniques that are described in this article. They can be downloaded as a zip archive [here](https://csoundjournal.com/downloads/Francioni_tutorials_Part1.zip).
## I. Field of Intervention Csound-based Systems for Real-Time Interactive Chamber Music Performance


In recent years I have been researching some of the possibilities of utilizing Csound for signal routing in real-time in the concert hall, and I realized that there are several applications for this research. Considering my training and also as I am basically an interpreter of music, I am particularly attracted to the idea of the use of an audio signal that has been produced by a musical instrument and coming from a microphone, being used to set in motion a kind of one-man performance.

Wanting to define this more clearly, I saw and I experienced some possible areas of the application of Csound in live electronics:

I. The signal captured with one or more microphones, and optionally:
 A. a returned unaltered signal (but perhaps with some routing to direct the sound output).


![](images/RealtimeSystems1Extra_image_01.png)

**Figure 1. Unaltered returned signal.** B. Signal synchronization with other events, perhaps with suitably prepared sounds.

![](images/RealtimeSystems1Extra_image_02.png)

**Figure 2. Signal mixed with auxiliary events.**

II. The signal captured with one or more microphones, which is passed into Csound and then utilized or changed by molding and shaping through:
 A. the application of effects (FX), such as: ring modulation, phaser, flanger, amplitude following filter, chorus, harmonizer, reverb, stretching, pvs opcodes, glitching, distortion, spatial processing, granulation, pitch change and others, or


![](images/RealtimeSystems1Extra_image_03.png)

**Figure 3. Signal processed.** B. the application of effects (FX) on the signal repeated at various time intervals with delay, utilizing opcodes such as *fout*, or *diskin2* in this task.

![](images/RealtimeSystems1Extra_image_04.png)

**Figure 4. Delayed processing.**

III. The signal captured with one or more microphones, analyzed for its basic parameters (mainly the amplitude and frequency) and employed as:
 A. a monitoring tool to trigger other events,
 B. or used as a switch, which could be defined as a choice of possible options in the sequence or path to an algorithm; something similar to a switch or to a switch that opens the door to different choices in real-time.

![](images/RealtimeSystems1Extra_image_05.png)

**Figure 5. Switched processing.**

IV. The mix of the various fields utilizing those from the above (I, II, or III).

![](images/RealtimeSystems1Extra_image_06.png)

**Figure 6. Combined strategy processing.**

We can leave out the operation of sound location in real-time. I personally believe both in acousmatic music, and when the instrumentalist or singer is merely superimposed on a musical event (on the sounds of support, or on tape), crystallized and already decided in advance, that it is less sensible to speak of live electronics. Because in that case in fact there is no reaction, and the attention is unbalanced on the executioner, that behaves almost like an automaton to synchronize (more or less freely within the constraints imposed in the score) its interventions on what, in principle, remains unchangeable. I believe more in a concept of live electronics in which the relationship between performer and machine is focused on interactivity, and not only on technology. Thus the performance is based on an intelligent musical reaction as well as one technological.

Examples from the literature of live electronics will be discussed in this article (and some with tutorials), with more or less detailed reference to the Csound language adopted. These are: *Solo* [Nr.19] by K.Stockhausen (digital setup in Csound by E.Francioni) based on delay lines, *Ryoanji* by J.Cage (digital setup in Csound by E.Francioni) based on synchronization with sound support, *Cluster* by E.Francioni - based on the timeline (*timeinsts*) and the delay-lines, *eSpace* by E.Francioni , an example of spatial signal quadraphonic, *Accompanist* by J.Fitch, based on the reaction to rhythmic impulses, *Claire* by M. Ingalls, based on the pitch and the randomness of the reaction, *Etude 3*, an experiment of B. McKinney, based on *pvspitch*, and *Im Rauschen, cantabile* by L.Antunes Pena, based on keyboard commands (*sensekey*).
## II. Some general questions on Live Csound


Before doing any live electronics with Csound you need to know, and keep in mind some basic settings. These are settings used to optimize the system. For all frontends commonly used (such as CsoundQt, Cabbage, WinXound, Blue, etc...) we propose preliminary settings that must be met for a successful performance in terms of the rationalization of operating system resources, and reducing signal latency.

In addition to the general settings, there are specific settings dedicated, in detail, to what we are trying to achieve.

It is also necessary to respect the basic norms of coding efficiency for compiling Csound. This will contribute greatly to the rationalization of resources, and the smoothness and speed of reading the code by Csound.

For this purpose, it seemed particularly important what Heintz[[1]](https://csoundjournal.com/#ref1) also suggests about the settings and precautions to keep in mind for a success in live performance.

1. Instruments are the main building blocks in Csound. For a good design of Live Csound, it is important to decide which task should be assigned to each instrument. If an instrument has to receive any control message, like MIDI or OSC, it usually has to be always on for listening. If a trigger signal is received and another instrument is turned on, which may just flash some light in the GUI, or set some value, the called instrument should be turned off immediately after having done its job[[1]](https://csoundjournal.com/#ref1).

2. It is crucial for this design to understand one idiosyncrasy of Csound instruments which is not always transparent, even for experienced Csound users: the difference between the initialization and the performance passes. Briefly, this means once an instrument is called, all i- and k-variables are initialized. While the i-variables stay as they are, the k-variables will be updated in every performance cycle, i.e. every ksmps samples[[1]](https://csoundjournal.com/#ref1).

This list from [[1]](https://csoundjournal.com/#ref1) continues also with guidelines below for Live Csound:

3. "Use different instruments for the different jobs which are to be done in your live configuration"[[1]](https://csoundjournal.com/#ref1).

4. "Use the init pass of an instrument for setting values whenever possible, and turn off any instrument as soon as its job is done"[[1]](https://csoundjournal.com/#ref1).

5. "Split jobs if the instrument becomes too complex"[[1]](https://csoundjournal.com/#ref1).

6. "Use User-Defined Opcodes (UDO’s) and macros to modularize your code"[[1]](https://csoundjournal.com/#ref1).

7. "Tweak the performance and the latency with the vector size (ksmps) and the buffer size settings using the command line flags -B, and -b"[[1]](https://csoundjournal.com/#ref1).

8. Avoid some opcodes which are not intended for real-time use. For example, do not use the old pv opcodes for Fourier transform/phase vocoding, like *pvoc* or *pvcross*. Use the pvs opcodes instead (*pvsvoc*, or *pvcscross*, etc). For another example, do not use opcodes for convolution which are not good for real-time performance, like *convolve* or *dconv*. Use *pconvolve* or *ftconfv* instead[[1]](https://csoundjournal.com/#ref1).

9. Csound’s performance for live applications depends mainly on its vector and buffer sizes. As mentioned above, the `ksmps` constant defines the internal vector size. A value of `ksmps = 32` should be adequate for most live situations. The software and hardware buffer sizes must not be kept at Csound’s defaults, but should be set to lower values to avoid audio latency. CsoundQt offers an easy way to adjust the Buffer settings in the configuration panel[[1]](https://csoundjournal.com/#ref1).

In terms of a one-man-performance it is also of considerable importance to use an effective and functional graphical user interface (GUI) that allows the performer some basic controls such as prior checking of parameters, a Play/Stop/Pause control during the performance (if it is made possible by the one-man performance), the ability to view useful parameters (metronomes, chronometers, lines to display, etc.), synchronization space/time with other events, the possibility to test only parts or sections of the piece under study, the ability to modify the speed of the execution of the code under study, and the possibility to insert presets on the type of execution to be used.
## III. Csound for Cage’s *Ryoanji* - A possible solution for the Sound System. The generation and management of the Sound System: in deferred-time and real-time


Among the historical works dedicated to live electronics one cannot forget *Ryoanji* by John Cage, a work already described in my article *Csound for Cage’s Royanji* in *Csound Journal*[[2]](https://csoundjournal.com/#ref2), in which reference is made especially for the part relating to the description of historical and interpretive aspects. The article also features several pages of the original score. The following paragraphs illustrate the basic steps for thinking of a possible solution for the installation of the sound system, as well as the design, implementation and use for Cage’s work. While I have not yet created an App of this algorithm, it is my intention to do this in the near future.
### The project


In this discussion we will analyze the version for a live contrabass and sound support. Sound support, is simply a tape, made up of three double basses, percussion and vocalise ad libitum. Considering that the reader is probably already familiar with this piece by Cage, the first question is "What do we want?". The answer is simple. We want to set up the sound system for *Ryoanji* but include the use of Csound. How is the sound system set up with the use of Csound? The performer needs a patch and a graphical interface to prepare the exhibition. He has the control of the preparatory material and then he performs the piece! What are the problems we face and what things do we need to know for doing that? The way I develop this project, regardless of the version that we have decided to set up, is that Csound cannot be reduced to a simple player for playing sound support (tape). Csound can be used instead in a more creative and imaginative way especially for the choice of materials and the type of control over the sound that we want to activate. We could write an algorithm that allows us to perform at least two activities: a preparatory performance (in deferred time) to be followed, and one dedicated to real-time.

In any case the patch that I propose for *Ryoanji* that I will comment on below in some basic steps, has been prepared to satisfy both needs from above. Basically the larger task will be the preparation of the sounds of support, and we can decide to carry out that task in various ways.

For working with a live contrabass soloist there will be particular issues with the coding for Csound. Thinking of a one-man performance, it is important that the soloist has control of the various elements before and during the performance. For this reason it is essential to have the help of a GUI for a preliminary calibration of execution and access to some basic controls such as the tools to carry out the preparation phase, a Timer (to understand where you are in execution), the metronome (in this case set to 60 MM), the skiptime (which under study allows us to be able to perform the song from chosen points), and the possibility of excluding some controls to save cycles in the CPU.

The patch may be set in the way that the three parts of the contrabass of support can be implemented, at the discretion of the interpreter, using one of the following methods:

• recording studio audio tracks of bass (2, 3 and 4) for later import into the algorithm in real-time (for example with *diskin2*, *soundin* or *mp3in*),
 • recording of audio samples in deferred time, and stretching it in real-time,
 • or analysis of audio samples in deferred time, and resynthesis timed and stretched in real-time.

It is very important to be aware that the last two methods above, if using the algorithm in real-time. That is, during the performance, those willrequire a significant amount of resources in terms of CPU .

For the realization of the pulses of the necessary percussion, accompanying the whole piece, you could used two separate libraries of audio samples of sounds of metal and sounds of a timber (as shown by the author), perhaps bringing into play a collection of physical models utilizing Csound.

The vocalise ad libitum is notated in the score with horizontal lines graphically differentiated as shown below in figure 1.

______ / _ _ _ _ / . . . . . / _ . _ . _ .

**Figure 7. example ad libitum notation in Cage’s *Ryoanji*.**

These could be realized by following the strategy adopted for the three basses, then loaded and recalled also as sounds for support in order to facilitate a one-man performance.

At a higher level of observation, presented here is a design for the basics of an algorithm in the following block diagram.

![](images/RealtimeSystems1Extra_image_07.png)

**Figure 8. Basic design for *Ryanoji* algorithm.**

For the realization of the successful execution of our dedicated algorithms in real-time and using live electronics, it is essential to keep in mind the points already set out in the second Section of this article, to which I would add, in this case, the following recommendations:

 • all files retrieved from the code (wav, mp3, pvx, txt) necessary for performance, are in the same folder as the csd,
 • and in this case it is recommended to set the header during record, using the following values:
```csound

sr = 44100
ksmps = 260
```


Then set the header during the playback to the follow values, omitting the `kr`.
```csound

sr = 44100
ksmps = 64
```


 The patch can be thought of as divided into two parts: one part of the code for recording, and the other for playback. This will appear to the user as two different types of operation. A record tool has the task of recording and saving the audio samples (.wav) of the bass where the pitch C2 is on all four strings, as well as audio samples (.wav), and simultaneously files pvx, such as voice (vowels I, O, A, E corresponding to the four parts of the vocalise). Below is the fundamental body of the code.
```csound

instr	rec	; recording file wav and pvx (one track at a time)

aIn		inch	1

if		i(gkrec)	==	1 	then
Sfile		=	"/Users/enrico/Desktop/Ryoanji/myCbC2_I.wav"
fout		Sfile, 2, aIn
elseif	i(gkrec)	==	2	then
Sfile		=	"/Users/enrico/Desktop/Ryoanji/myCbC2_II.wav"
fout		Sfile, 2, aIn
elseif	i(gkrec)	==	3	then
Sfile		=	"/Users/enrico/Desktop/Ryoanji/myCbC2_III.wav"
fout		Sfile, 2, aIn
elseif	i(gkrec)	==	4	then
Sfile		=	"/Users/enrico/Desktop/Ryoanji/myCbC2_IV.wav"
fout		Sfile, 2, aIn

elseif	i(gkrec)	==	5	then
Sfile		=	"/Users/enrico/Desktop/Ryoanji/myVx_I.wav"
fout		Sfile, 2, aIn
fss pvsanal  aIn, 1024,256,1024,0
pvsfwrite fss, "/Users/enrico/Desktop/Ryoanji/myVx_I.pvx"
elseif	i(gkrec)	==	6	then
Sfile		=	"/Users/enrico/Desktop/Ryoanji/myVx_O.wav"
fout		Sfile, 2, aIn
fss pvsanal  aIn, 1024,256,1024,0
pvsfwrite fss, "/Users/enrico/Desktop/Ryoanji/myVx_O.pvx"
elseif	i(gkrec)	==	7	then
Sfile		=	"/Users/enrico/Desktop/Ryoanji/myVx_A.wav"
fout		Sfile, 2, aIn
fss pvsanal  aIn, 1024,256,1024,0
pvsfwrite fss, "/Users/enrico/Desktop/Ryoanji/myVx_A.pvx"
elseif	i(gkrec)	==	8	then
Sfile		=	"/Users/enrico/Desktop/Ryoanji/myVx_E.wav"
fout		Sfile, 2, aIn
fss pvsanal  aIn, 1024,256,1024,0
pvsfwrite fss, "/Users/enrico/Desktop/Ryoanji/myVx_E.pvx"
endif

endin

```


It is recommended that the dialogue between the performer and the various parts of the orchestra always happen through the Widgets Panel, not only for this but also generally in works dedicated to real-time.

For playback (Play) there at least four sectors of code:

• the soloist contrabass,
 • the three basses of support,
 • percussion and
 • the vocalise (ad libitum)

Regarding the bass solo part, it is "suggested" to be employed in the live performance, perhaps with signal corrections, but the three basses of support are required or fixed parts of* Ryoanji*. It was decided to choose two possibilities among the choices for the intended audio material to realize the three audio tracks, utilizing one mp3 for each part of bass as previously recorded. This approach will resemble more a performance like solo + sound support.

By implementing this option the work of the algorithm becomes much more complex, challenging and creative. Code is required for every bass’s dedicated calls (*schedule*) of another instrument that performs stretching of the samples and passing all the values needed to do it. Below is shown this step in regards to the code for the contrabass 2 part.
```csound

instr CB2

if 	i(gkCB234) = 1 then
gaCB2		soundinmac	"/Users/enrico/Desktop/Ryoanji/CB_02-mn.mp3", \
		1, i(gkskiptim)
gkled2=0
elseif 	i(gkCB234) = 2 then
clear	gaCB2
gkled2 = 1

;	       p1	p2	p3	p4	p5	p6	p7	p8	p9	p10	p11	p12	p13	p14	p15	p16	p17	p18	p19
schedule	"cb2",	57.85,	7.85,  3,	1,	2,	1,	0,	1,	1,	2,	.3,	.3,	2,	4,	4,	10,	8,	1
schedule	"cb2",	82.50,	4.4,	2,	4,	1.5,	-.5,	-1,	-1,	-1,	-1,	.3,	.3,	2,	4,	4,	10,	8,	1
;[omissis]

endif

```


The parameters of *schedule* (from p4 to p19) refer to the actual values for the arguments of the opcode *mincer* that will implement the real-time stretching of the samples and the resulting sound output.
```csound

gaCB1	mincer atime, kamp, kpitch, itab, ilock
```


As we said above regarding the sounds of percussion, Csound gives us some choices of semi-physical models present between opcodes, such as *tambourine*, *cabasa*, *sleighbells*, *guiro*, *bamboo*, *cabasa*. The performer should be given a chance to access these (in addition to their own samples) with a menu in the Widgets Panel. I have suggested a solution that seems effective to invoke samples of the percussion at intervals of time set out in the score. The code uses the opcode *loop_le*, for making timed calls connected to the instrument `pc3` required for the output of the sound of the percussion.
```csound

gir27 ftgen 27, 0, -77, -2, 0,14,26,38,51,64,76,88,101,115,130,143,157,171,186,198,211,226,241,255,269,284,297,310,324,339,351,
365,378,392,407,422,434,447,461,475,490,505,519,534,546,561,574,589,604,619,634,647,662,676,691,704,719,734,749,762,775,787,801,813,827,842,854,866,880,895,908,923,937,951,963,977,991,1003,1017,1029,
1043
; function values gir27 mark the actions-time (p2) of the \
	percussion, then past a table and then to schedule

istart	= 0 	; i-rate variable to count loop.
incr	= 1	; value to increment the loop
iend	= 77	; maximum value of loop index

looppoint:
ip2  table  0, gir27
schedule "pc3", ip2, 10
loop_le istart,incr,iend,looppoint

```


For the four double basses, one live and three from the sounds of support, and the four lines of the ad libitum part, I suggest a spatial quadraphonic setup, that could be implemented with the knowledge and use of the opcode *space*. In the specific case for the location of the signals of support, it seems practical that the locations of the signal are already established before the performance employing the function set in `ifn`.
```csound

gir1	ftgen	1,	0,	0,	-28,	"CB01.txt"
; GEN 28 delegated to the move, which refers to the text file "CB01.txt" \
	which are written in the movements of the signal in time

ifn	=	1
ktime	line	0, idur1, idur1
kreverbsend	= .5
kx	= 	0
ky	=	0
a1, a2, a3, a4	 space	asig, ifn, ktime, kreverbsend, kx, ky

```

## IV. Inside SOLO [Nr.19] , the Digital setup for Stockhausen’s Composition


Another important work to which you can apply the term "historic" and one dedicated to the production of live electronics is certainly *Solo* für Melodieninstrument mit Rückkopplung by Karlheinz Stockhausen (1966) . Published by Universal Vienna, this composition has unique importance. From the 80s to today, there were numerous approaches to solve transposition in the digital environment (Max/MSP, Pd, Kyma/Capybara, and even with the use of multitrack editors), the original analog layout, and the use of magnetic tape to obtain delays of the signal included between 6 and 45.6 seconds.

![](images/RealtimeSystems1Extra_image_08.png)

**Figure 9. Setup for Stockhausen's *Solo*.**
### Analog Setup


Before becoming an App, the csd file for *SOLO [Nr.19]* went through a long period of trial. The App for iPad, iPod and iPhone, realized thanks to the valuable contribution of Alessandro Petrolati - apeSoft - and distributed on the App Store, is devoted mainly to the performer who wants to deal with the performance of the piece, but also for the student who wishes to examine carefully the point of view of style and composition . This App can provide away for various performers to create more personal versions dedicated to different solo instruments (violin, saxophone, contrabass) and also to voice, with a certain aptitude in the resolution of the initial difficulties of the technical setup .

Also in this Section of *SOLO*, and the same for *Ryoanji*, I will assume that the reader has already acquired a certain familiarity with the score and the technical setup[[3]](https://csoundjournal.com/#ref3). After a careful observation of the flow chart and the Form-Schema of the original, it is necessary to understand that in the digital transfer of the original technical setup, some basic requirements should be met, such as listed below.

 • Implement delay-line delays programmed in time.
 • Implement the automated system of envelopes of the four Assistants.
 • Create the possibility of entering the FX signal (Timbres).
 • Create a useful graphical performance tool that contains controls needed before and during the performance (metronomes, time-line, count-down, timers, etc).

 On a more refined level of program, we should also take care with the items listed below.

 • Ensure that the user can perform with the same app for all six SOLO Versions.
 • Insert a master metro control as general time keeper and also for skiptime for the purposes of the preparatory study of the performance.
 • Include the possibility to change the Beats per Period.
 • Enter the system of random perforations.

Below we can summarize the technical setup of *SOLO* simply thinking of a signal that passes through a delay-line with the addition of a feedback as well as adding temporal envelopes.

![](images/RealtimeSystems1Extra_image_09.png)

**Figure 10. Summary of the technical setup for *Solo*.**

A simplification of the algorithm is shown below, which is an incomplete code example. This represents a possible solution for the Form-Schema (only the left channel) in which the incoming signal is subjected to a delay-line in feedback, also adding envelopes for Assistants 1, 2, 3 and 4: Microphone (1) Feedback (2), Playback (3) and Delay (4).
```csound

gkenl1 init 0	;line envelope Assistant 1 \
	(at instr en_L1 for envelopes of Assistant 1 left channel)
gkenl2 init 0	;line envelope Assistant 2 \
	(at instr en_L2 for envelopes of Assistant 2 left channel)
gkenl3 init 0	;line envelope Assistant 3 (at instr en_L3 \
	for envelopes of Assistant 3 left channel)
gk_tdel init 0	;variable delay time gk_tdel \
	(at instr Tdel - Assistant 4 - for left and right channels)
;===========
instr setup
;===========
imax =	p4		; maximum value of the delay-line; for the \
			Version I p4 = 25.3 (seconds)
igain_A	= .8	; attenuation value (g), before delay-line
amic inch 1		; audio signal from the microphone
asig = amic*gkenL1 	; microphone signal \
			* line envelope Assistant 1 (left channel)
adummyl delayr imax ; reads the maximum value of the delay-line
adeL deltapi gk_tdel ; tapped signal, the variable delay time \
			gk_tdel - Assistant 4
awrite = (asig+(adeL*gkenL2))*igain_A ; signal + (delayed signal \
			* envelope line Assistant 2 left channel) * attenuation value (g)
	delayw awrite ; write in the delay line awrite

aoutL = adeL*gkenL3 ; delayed signal * line envelope Assistant 3 (left channel)
aleft = aoutL + amic ; processed signal + direct-line
out	aleft ; output
endin

```


Shown below, in the partial example, is the left channel - First Assistant (Microphone) with times of only Cycle A.
```csound

gi1	ftgen	1,	0,	4,	-2,	18,	18,	30	; etc.
gi2	ftgen	2,	0,	4,	-2,	6,	6,	18	; etc.

; instantaneous values by score
ia 	= p4
ib 	= p5
ifn1 	= p6
ifn2 	= p7

indx	init	- 1		; initialization of the index table
ilen	=	ftlen(ifn1)	; here you get the length of the table ifn1
reset:					; label attached to reinit
indx		=	indx + 1		; increase in the index
; conditional step: if the index is less than or equal to -1 ilen then go to the label again
if	indx <= ilen - 1  goto forth
turnoff				; or, if the condition occurs, turn off
forth:				; label attached to goto, if the condition is satisfied
idur	 table	indx, ifn1	; reading the values idur from the table
idur_env table	indx, ifn2	; reading the values idur_env from the table
; it performs another conditional jump: from time 0 will jump to label continue and continue to cook for idur seconds
		timout 0, idur, continue
		reinit reset
; at this point csound temporarily stops the execution and executes a further step initialization

continue:		; label attached to timout, if the condition is satisfied
; generation line of envelope, as a global variable
gkenl1	linseg 0, ia, 1, idur_env - (ia + ib), 1, ib, 0

endin

```


 As for the Timbres, or the FX signal, I suggest the use of a UDO (User-Defined opcode). The example below is the code that will be called as a spectral arpeggiator as opcode *SpecArp*.
```csound

opcode SpecArp, a, akkk
setksmps 64

asigL, klfo, krange, kdepth xin
ifftsize	=		512
ioverlap	=		ifftsize / 4
iwinsize	=		ifftsize
iwinshape	=		1	; von-Hann window

fftinL	pvsanal	 asigL, ifftsize, ioverlap, iwinsize, iwinshape
kbin  	oscili	 krange, klfo, gifn510, 0	; ftable 0-1
ftpsL  	pvsarp  fftinL, kbin, kdepth, 3  	; arpeggiate it (range 220.5 - 2425.5)
aOutL 	pvsynth ftpsL				; synthesise it
	xout aOutL
endop

```


Obviously for the Timbres to be applied to the signal the programmer can feel free to choose within the opcodes of Csound, UDO libraries available online, or by using totally customized patches. Now let us look at some aspects of the GUI . As mentioned above, it is essential to provide the interpreter with at least some essential controls for the initial setting for the one-man performance.

• Metronomes which candisplay and scan Beats, Periods and Cycles.

The latter instrument of control is important during the study phase for partial executions, and to apply a skiptime with a pitch for Cycles (a kind of advance statement).

• Display of the time-line of Periods and Cycles.

• Management of Beats per Period and the master meter.

On an advanced level, one of the major efforts that will have to be made by the Csounder is to set the algorithm for performing all six Versions of *SOLO*. In this case, I prefer talking about a multi-version.

What follows is an outline, very brief, of the entire csd.

![](images/RealtimeSystems1Extra_image_10.png)

**Figure 11. Overview of csd for *Solo*.**

The process of integration of the orchestra for *SOLO* is simple. It is necessary to make only a few minor changes to make it compatible with the Csound API (i.e. Application Programming Interface).

The first improvement concerning the flags of Csound, as you can see, is to disable `rtaudio` and `rtmidi` since the IO audio is managed by iOs.
```csound

-o dac
-+rtmidi=null
-+rtaudio=null
-d
-+msg_color=0
--expression-opt
-M0
-m0
-i adc

```


The second improvement concerns the use of utilizing the opcodes *chnget* and *chnset* instead of the opcodes *invalue* and *outvalue* due to better Csound API support.

Since the architecture of *SOLO* requires the extensive use of the control structure (i.e. k-rate variables), and since all the processes related to the servers are automated for reasons of optimizing the performance of the first generation of iDevices, it is best to set the `ksmps` of Csound identical to bufferFrame of the iOs. Since Csound does not allow the dynamic setting of these general parameters (`sr` and `ksmps`), it was necessary to introduce a workaround that is to place a textual level of values on `sr` and `ksmps`. The implementation is in Objective-C and will not be discussed in this text.

For clarification, in the orchestra’s header for *SOLO* we can see the placeholders for the `sr` and `ksmps`.
```csound

sr    = 44100
ksmps = 512

;;;;SR;;;;    //strings replaced from app with own values
;;;;KSMPS;;;;

nchnls	= 2
0dbfs 	= 1
```


The interaction between the UI in Objective-C and the Csound orchestra code is simple. We are using the methods for `set` and `get` for writing a value from the UI in Csound (`set`) or the other way to read a value from Csound (`get`). Since most of the interactions is of type `get`, to obtain values from Csound, it was utilized to implement the mechanism of the timer pulling, using the methods of the protocol `csoundObjStarted` and `csoundObjCompleted` for activating and deactivating a timer accordingly. The last calls for regular time intervals is a function delegated to sample values by the software bus Csound, using *chnset*, which also works with the display and updates the graphical interface.
```csound

-(void)csoundObjStarted {

//…
    /* Enable Pull Timer */
    if (!pullCsoundTimer) {
        pullCsoundTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
         target:self
         selector:@selector(pullValuesFromCsound)
         userInfo:nil
         repeats:YES];
    }
//…
}

-(void)csoundObjStarted {

//…
    /* Disable Pull Timer */
   if (pullCsoundTimer) {

        [pullCsoundTimer invalidate];
        pullCsoundTimer = nil;
    }
//…
}

```


Finally, with the function call from the NSTimer, values are read from the software bus by Csound. The address of the software bus is expressed as a string. Therefore, in the example, NSString @ "time" refers to instrument 5, and in particular to the code shown below.
```csound

ktinst	timeinsts
chnset ktinst, "time"

```


As you can see by the opcode *chnset* the value is written to the `ktinst` software bus "time" which is read by the function `csoundGetChannelPtr`. This function in the C programming language of the Csound API copies the pointer `MYFLT` to the variable `channelPtr_time`. Now `channelPtr_time`, the pointer, points to the value of `ktinst`. Since `channelPtr_time` is a pointer, according to the syntax of the C programming language, it must be de-referenced in order to read the actual data in memory `*channelPtr_time`.
```csound

-(void)pullValuesFromCsound {
//…

	MYFLT* channelPtr_time = nil;
	csoundGetChannelPtr(_cs, &channelPtr_time,
                            [@"time" cStringUsingEncoding:NSASCIIStringEncoding],
                            CSOUND_CONTROL_CHANNEL | CSOUND_OUTPUT_CHANNEL);

	if (channelPtr_time) {
		MYFLT timeValue = *channelPtr_time / 66.0;
		time.progress = timeValue;
		[time_label setText:[NSString stringWithFormat:@"Time = %d", (int) *channelPtr_time]];
   }
//…
}

```


In the example above, the value is used to update the native object `UIProgressView` and to update the text of a `UILabel`. Here is how the interface of the latest version of the App SOLO [No. 19].

![](images/RealtimeSystems1Extra_image_11.png)

**Figure 12. GUI interface for *SOLO*.**
## V. Exploiting the Characteristics of the Signal in Real-time


The signal can become an element that can be used to do anything. A simple approach is processing the same signal. You can take advantage of the characteristics of the analyzed signal and use that in turn to do something else. The `k` values output relative to amplitude and to pitch of the signal are valuable data and information to be referenced to make subsequent choices in the path of the algorithm.

Csound provides opcodes which in addition to being exploited to achieve tonal effects or FX directly on the signal, can also be allocated to capture essential components of a signal such as amplitude, frequency, or spectrum.

*ptrack* — Tracks the pitch of a signal pitch.
 *pitchamdf* — Follows the pitch of a signal based on the AMDF method.
 *pvspitch* — Track the pitch and amplitude of a PVS signal.
 *follow* — Envelope follower unit generator.
 *follow2* — Another controllable envelope extractor.


We will look at a patch employing some of these opcodes to exploit the signal.

Some time ago I heard *Three Breaths* in three movements by Iain McCurdy[[4]](https://csoundjournal.com/#ref4) and I was captivated by the interest aroused in me in this direction. After contacting the author about his composition, he replied[[5]](https://csoundjournal.com/#ref5):

"In the 2nd movement I used pitch tracking so that different sound files would be triggered depending upon what note the player played. The sound files used were short recordings of the player making vocal sounds.

In the 3rd movement I used pitch tracking to control the interval of a pvs pitch shifter - by doing this I could have a pitch shifted version of the input sound that sustained a constant pitch even while the source sound was playing different notes. There were actually up to three of these pitch shifters running simultaneously so i could create drones and chords.

(The 1st movement did not use pitch tracking.) […].

I think the challenge when using *pitchamdf *and *pitch* (and *pvspitch*) is to get a steady reading for pitch. Noise artefacts, very often present at the onset of the note, can ‘confuse’ the pitch tracker. There are ways in which you can try and address this, like lowpass filtering the input sound before the pitch tracker or delaying reading the input signal to ‘miss out’ the note attack.

I did find using pitch tracking in this piece quite a challenge! I might in the future do some deeper research in comparing Csound’s pitch trackers (*pitch*, *pitchamdf*, *pvspitch*, there may be others?). […] If you are using a bass guitar it might be quite a good source for pitch tracking as the sound is quite pure.

Also think about what you could do with just amplitude tracking - this can be very expressive and is much less temperamental than pitch tracking."

Regarding pitch tracking, in the case of using opcodes such as *pitchamdf* or *ptrack*, but also with *follow *and *follow2*, utilize the last two opcodes where you want to extract only the profile amplitude of the signal.

McCurdy also provides some valuable example .csds[[6]](https://csoundjournal.com/#ref6). Utilizing those, it is interesting to analyze the opcodes *pitchamdf* and *ptrack* which I also transcribed for use in CsoundQt.

I experimented withthese long .csds utilizing signals of different types: synthetic, audio files, or from a microphone, but these tests focused on some problems.

•After the release of the microphone signal, or the signal from audio files, the CPU is being exploited to the maximum and then remained stable. However this does not happen if you are using a synthesis signal.

•If after the start of the algorithm, there is no stress from the signal, the CPU immediately falls to normal values.

• If you are using a synthesis signal with amplitude = 0, the variable `kcps` omits a maximum value (`ihmaxcps`).

To avoid these three issues, I considered it appropriate to never put the amplitude of the signal equal to 0. Instead, I add a small amount (offset) to the signal’s amplitude.

The code snippet below shows the case for the synthesis signal.
```csound

aL	oscili	kamp+.01, 440, 1
;and in the case of the audio signal (or from the microphone):
aSig = (aL*kgateport) + .00001
```


The next example is a very good one to show the use of the *port* opcode to prevent the annoying clicks for opening and closing of the signal threshold.

For the opcode *ptrack *[Syntax: `kcps, kamp ptrack asig, ihopsize[,ipeaks]`] you can start from the example by Victor Lazzarini[[7]](https://csoundjournal.com/#ref7) (which appears in the Csound Manual) to help with understanding the real meaning of its potential functions.
```csound

<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
; Audio out   Audio in    No display
-odac           -iadc     -d     ;;;RT audio I/O
</CsOptions>
<CsInstruments>

sr	= 44100
ksmps	= 16
nchnls	= 1

;Example by Victor Lazzarini 2007

instr 1
  a1 inch 1              ; take an input signal
  kf,ka ptrack a1, 512   ; pitch track with winsize=1024
  kcps port kf, 0.01     ; smooth freq
  kamp port ka, 0.01     ; smooth amp

  ; drive an oscillator
  aout oscili ampdb(kamp)*0dbfs, kcps, 1

  out  aout
endin

</CsInstruments>
<CsScore>
; simple sine wave
f 1 0 4096 10 1

i 1 0 3600
e
</CsScore>
</CsoundSynthesizer>

```


McCurdy also provides an example of using the opcode *ptrack*[[8]](https://csoundjournal.com/#ref8) , similar to the one dedicated to the opcode *pitchamdf*[[9]](https://csoundjournal.com/#ref9). This opcode is noteworthy for greater effectiveness in achieving the result and employs a simpler syntax .

In general when using *pitch* and *pitchamdf*, but also the use of *pvspitch*, to obtain a reading as constant as possible for the values of frequency, it is necessary to adopt certain strategies of intervention to try to overcome such problems as external noise when employed with a microphone and signal characteristics in the initial phase of the reading.

Below are a listed a few principles, in that case.

• Apply lowpass filters before tracking pitch.
 • Delay the reading of the attack of the note, which is the most critical phase and in which the pitch tracking does not know what decisions to make, given the impurities and the frequency of tone that characterizes this instant.

In the last section below, let us make a list that will help to make a summary of what was said about the use of the two opcodes (*ptrack* and *pitchamdf*).
## VI. Strong Points and Remedies for Weaknesses


The opcode *ptrack* no signal values kcps stationed at the last value given.

The opcode *ptrack* is faster to use than *pitchamdf*.

There is no need to use frequency bands as in *pitchamdf*, requiring more data for input to the opcode.

The opcode *pitchamdf* can restrict the frequency range and has a greater success and accuracy.

Just after start and render, *pitchamdf* produces values (i.e. 147, 0), and then is given `ihmaxcps` to ensure delayed output values of the `kcps`.

If the code is running with no signal (`asig = 0`), the `kcps` position is on the maximum value of *pitchamdf* (`ihmaxcps`). In this situation the temporal values of `kcps` should be ignored by a jump execution and then stabilized at the last value of `kcps`.

When the `kgateport` passes 1, and then opens for a few milliseconds, `kcps` still passes the maximum value (`ihmaxcps`). It then passes the value of the incoming signal. We should delay the output of the values of `kcps `of a few milliseconds, because the `kcps` is slower than `kgateport` .

With attention to these details I tried to write a few examples that exploited the pitch of the signal. This has given rise to a patch showing that with calibrating the parameters well and adopting some measures, it is possible to achieve good results aimed at live electronics. Hoping to bring forth some curiosity in the reader, the following provides examples of those patches where the first patch is designed for the contrabass as a solo instrument and uses the opcode *ptrack*.
```csound

gaMc	init	0 	; global variable of the audio signal
gkint	init	1	; on/off switch (managed by the tool/event that will be triggered)
gkcps	init	0	; frequency ptrack

;===========================
instr 1				; signal - microphone
;===========================

aMc	inch	1		; MICROPHONE
gaMc	=	aMc		; global
endin

;===========================
instr 2				; with ptrack
;===========================

; FILTRO

icpsmin	= cpspch(5.00)		; frequency of the lowest tone of the contrabass (V chord C1)
aFlt1	butterbp gaMc*gkint, gkcps, 30	; applying a band-pass filter
aFlt	atonex	aFlt1, icpsmin, 5	; application of a high-pass filter

; RESCALE

kMcIn	port	gkMcIn, .2		; smooth
aL	= aFlt * kMcIn * gkint		; rescale the amplitude and/or turn off the signal

; AUDIO_GATE

afollow  follow2 aL, .0001, .03	; profile amplitude; attack = .0001, decay = .03 seconds
kfollow	downsamp afollow		; creates version k-rate profile of signal amplitude
gksoglia invalue	"soglia"	; value from 0 to 1 that is set in the GUI
kgate	= (kfollow< i(gksoglia)?0:1)	; creates a signal GATE
kgateport port	kgate,.05		; smooth
aSig = aL * kgateport * gkint		; I apply the gating signal

; PTRACKING

iSize	pow	2, 10			; 1024
gkcps,kA 	ptrack 	aSig, iSize 	; pitch track with winsize...

In the final part of instr 2,  I joined this other patch that has the function of making a mean (average) every N samples; creating a buffer of N samples to k, that makes a sum and then divides by the number of samples:

kindex	init	0
kfreq	init	0		; ...first pitch-detector
gkfreq	init	100

kindex = kindex + 1

kfreq = kfreq + gkcps

icps	 = (2^7)+1		; samples (128 + 1)
if kindex == icps then
kindex = 0			; kindex reset to 0
gkfreq = kfreq / icps		; It gkfreq be the average of icps samples - in this case we have a resolution of ksmps * icps
kfreq	  = 0			; kfreq = 0, reset to 0
endif
	endin

```


The variable `gkfreq` constitutes useful data for subsequent choices, creating the conditions to turn on (trigger) various planned events.

In the second patch I compared three types of signals using *pitchamdf* employing microphone, synthetic and audio files. The test was also performed on the audio signal with *ptrack*.
```csound

gktrigger	init	0

;=======================
instr 1
;=======================

ksig	invalue	"signal"

if 	ksig	= 1	then		; SIGNAL #1 ‐ MICROPHONE
a1		inch		1
ap		butterbp 	a1, 250, 200	; filter
apf1		tonex		ap, 20, 4	; filter (Smoothing dell'inviluppo)

; Extraction of the pitch and the rms signal (very important to hit the limits)
;				sig	min	max	icps	imedi	idwns	iexcps
kcps, krms	pitchamdf  	apf1,	150,	350,	150,	51,	1, 	56
apf2		=	0
apf3		=	0
apf4		=	0
;=======================

elseif	ksig	= 2	then
apf2	soundin	"test4.wav"		; SIGNAL #2 ‐ AUDIO FILE

; Extraction of the pitch and the rms signal
;				sig	min	max	icps	imedi	idwns	iexcps
kcps, krms	pitchamdf  	apf2,	150,	350,	150,	51,	1, 	0
apf1		=	0
apf3		=	0
apf4		=	0
;=======================

elseif	ksig	= 3	then		; SIGNAL #3 ‐ SYNTHETIC SOUND
kfr linseg 150, p3/2, 350, p3/2, 150
apf3	oscili	.5, kfr, 2

; Extraction of the pitch and the rms signal
;				sig	min	max	icps	imedi	idwns	iexcps
kcps, krms	pitchamdf  	apf3,	150,	350,	150,	51,	1, 	0
apf1		=	0
apf2		=	0
apf4		=	0
;=======================

elseif	ksig = 4	then		; SIGNAL #2 - AUDIO FILE
apf4 soundin "test4.wav"		; signal

; Extraction of the pitch, the signal
kcp, krms ptrack apf4,	2^12		; size 4096
kcps delayk kcp, .1
; delayk has the function of delaying the values kcps not to \
	have a frequency of 100 at the beginning (arbitrarily defined)

apf1		=	0
apf2		=	0
apf3		=	0
endif
;=======================

```

```csound

apf	sum	apf1, apf2, apf3, apf4, a1	; sum of the audio signals

At this point the algorithm shows us  how  could be the call of other events:

First possibility:

if kcps > 250 then
gktrigger	= 1
else
gktrigger	= 0
endif

; CALL TOOLS / EVENTS

schedkwhen gktrigger, -1, 1, 2, 0, -1

; OUTPUT

ken	linen		.1, 1, p3, 1
	outs		apf*ken, apf*0
	endin

```

```csound

Second possibility:

; WITH THE TRIGGER

isoglia	= 250					; trigger threshold
kmode	= 2
; remember the three ways in which works trigger:
; kmode = 0 turns on ascending /
; kmode = 1 turn descending \
; kmode = 2 turns on both ascending to descending / \

ktrig	trigger	 abs(kcps), isoglia, kmode	; absolute value of kcps \
						and trigger

; FOLLOWING LINES NEED TO TURN (PASS 1) WHEN VALUES GO BEYOND THE PITCH \
	FOR THE FIRST TIME (in ascending) and OFF (0 PASS) WHEN VALUES PITCH \
	GO ON FOR THE SECOND TIME (in descending order)

kInverter init -1

if (ktrig != 0) then			; if ktrig is not 0 then ...
kInverter = -1 * kInverter		;kInverter = -1 * (-1) kInverter (that is 1)
gktrigger = (kInverter == -1 ? 0 : kInverter)

;if the condition is true and that is that kInverter equals -1, \
	gktrigger assumes value 0 if the condition is false gktrigger \
	assumes that value kInverter 1

endif

```

```csound

; CALL TOOLS / EVENTS

schedkwhen gktrigger, -1, 1, 2, 0, -1

; OUTPUT

ken	linen		.1, 1, p3, 1
	outs		apf*ken, apf*0
	endin

Now schedkwhen call instr 2 will produce any other events

;=======================
instr 2
;=======================

if	gktrigger	!= 0 goto cont
turnoff
cont:

kamp 	linsegr 0, .05, 1, p3, 1, .2, 0
a1 	oscili kamp, 600, 1
	outs 	a1*0, a1
endin

```


By making a debugging variable for `kcps`, we can note that once the algorithm is started, with the opcode *ptrack* there is delay in the transmission of values of pitch. This translates into a greater accuracy and security for the interpreter stage of the code.

Finally there are some new opcodes that we should also take into account and take advantage of the analysis and management of real-time signals for those opcodes with Csound:

*plltrack* - Tracks the pitch of a signal.
 *pvscent* - Calculate the spectral centroid of a signal.
 *centroid* - Calculate the spectral centroid of a signal.

## Acknowledgments


I would like to thank John Fitch, Eugenio Giordani, Joachim Heintz, Matt Ingalls, Iain McCurdy, Bruce McKinney, Alessandro Petrolati, Luis Antunes Pena, Vittoria Verdini, and Rory Walsh for helping me in various ways on the realization of this article.
## References


[][1]]Joachim Heintz, 2012. "Using Csound as a Real-time Application in Pd and CsoundQt." [Online]. Available: [http://csoundjournal.com/issue17/heintz.html](http://csoundjournal.com/issue17/heintz.html). [Accessed May 16, 2016]].

[][2]]Enrico Francioni, August 3, 2013. "Csound for Cage’s Ryoanji A possible solution for the Sound System," in* Csound Journal*, Issue 18. [Online]. Available: [http://www.csoundjournal.com/issue18/francioni.html](http://www.csoundjournal.com/issue18/francioni.html). [Accessed October 17, 2016].

[][3]]Enrico Francioni, 2008. *Omaggio a Stockhausen, * in "ATTI dei Colloqui di Informatica Musicale", XVII CIM Proceedings, Venezia, October 15-17, 2008 (it). [Online]. Available: [http://smc.dei.unipd.it/cim_proceedings/2008_CIM_XVII_Atti.pdf](http://smc.dei.unipd.it/cim_proceedings/2008_CIM_XVII_Atti.pdf). [Accessed October 19, 2016].

[][4]]Iain McCurdy, 2009. *Three Breaths.* [Online]. Available: [http://iainmccurdy.org/compositions.html](http://iainmccurdy.org/compositions.html). [Accessed October 21, 2016].

[][5]]Iain McCurdy, February 2011. [e-mail]. Communication on *Three Breaths*.

[][6]]Iain McCurdy, 2011. *Realtime Score Generation*. [Online]. Available: [http://iainmccurdy.org/csound.html#RealtimeScoreGeneration](http://iainmccurdy.org/csound.html#RealtimeScoreGeneration). [Accessed October 22, 2016].

[][7]]Barry Vercoe, et. al. "ptrack." *The Canonical Csound Reference Manual*, Version 6.07. [Online]. Available: [http://csound.github.io/docs/manual/ptrack.html]. [Accessed October 21, 2016].

[][8]]Iain McCurdy, 2011. "ptrack.csd." *Realtime Score Generation*. [Online]. Available: [http://iainmccurdy.org/CsoundRealtimeExamples/PitchTracking/ptrack.csd](http://iainmccurdy.org/CsoundRealtimeExamples/PitchTracking/ptrack.csd). [Accessed October 21, 2016].

[][9]]Iain McCurdy, 2011. "pitchamdf.csd." *Realtime Score Generation*. [Online]. Available: [http://iainmccurdy.org/CsoundRealtimeExamples/PitchTracking/pitchamdf.csd](http://iainmccurdy.org/CsoundRealtimeExamples/PitchTracking/pitchamdf.csd). [Accessed October 22, 2016].
## Bibliography


J. Heintz, J. Aikin, and I. McCurdy, et. al. *FLOSS Manuals, Csound*. Amsterdam, Netherlands: Floss Manuals Foundation, [online document]. Available: [http://www.flossmanuals.net/csound/ ](http://www.flossmanuals.net/csound/) [Accessed May 25, 2013].

Riccardo Bianchini and Alessandro Cipriani, "Il Suono Virtuale," (Italian Edition). Roma, IT: ConTempo s.a.s., 1998.

Richard Boulanger, *The Csound Book*, The MIT Press-Cambridge, 2000.

Enrico Francioni, *Omaggio a Stockhausen, *technical set-up digitale per una performance di "Solo für Melodieninstrument mit Rückkopplung, Nr. 19", in AIMI (Associazione Informatica Musicale Italiana), "ATTI dei Colloqui di Informatica Musicale", XVII CIM Proceedings, Venezia, October 15-17, 2008 (it).

Karlheinz Stockhausen, *Solo, für Melodieinstrument mit Rückkopplung. Nr. 19*, , UE 14789, Universal Edition-Wien, 1969.
## Essential Sitography


AIMI (Italian Association of Computer Music). Internet: [http://www.aimi-musica.org/](http://www.aimi-musica.org/), 2015 [Accessed October 16, 2016].

A. Cabrera, et. al. "QuteCsound." Internet: [http://qutecsound.sourceforge.net/index.html](http://qutecsound.sourceforge.net/index.html), [Accessed May 16, 2016].

apeSoft. Internet: [www.apesoft.it](http://www.apesoft.it/), 2016 [Accessed October 16, 2016].

Boulanger Labs. cSounds.com. [CSOUNDS.COM: The Csound Community](http://www.csounds.com/), 2016 [Accessed May 16, 2016].

I. McCurdy and J. Hearon, eds. "Csound Journal". Internet: [csoundjournal.com](http://csoundjournal.com/) [Accessed May 16, 2016].

E. Francioni. "Csound for Cage’s Ryoanji A possible solution for the Sound System," in* Csound Journal*, Issue 18. Internet: [http://www.csoundjournal.com/issue18/francioni.html ](http://www.csoundjournal.com/issue18/francioni.html) , August 3, 2013 [Accessed October 17, 2016].

E. Francioni. "Cage-Ryoanji_(stereo_version)_[selection]," (on SoundCloud). Internet: [https://soundcloud.com/enrico_francioni/cage-ryoanji-stereo_version](https://soundcloud.com/enrico_francioni/cage-ryoanji-stereo_version), [Accessed October 17, 2016].

E. Francioni: "Francioni-CLUSTER V (demo-2ch)," (for a percussionist, live electronics and sound support). Internet: [https://soundcloud.com/enrico_francioni/cluster-v-demo-2ch](https://soundcloud.com/enrico_francioni/cluster-v-demo-2ch), [Accessed October 17, 2016].

E. Francioni. "Stockhausen-SOLO_[Nr.19]_für_Melodieninstrument_mit_Rückkopplung," (Version I). Internet: [ https://soundcloud.com/enrico_francioni/kstockhausen-solo_nr19_fur_melodieninstrument_mit_ruckkopplung](https://soundcloud.com/enrico_francioni/kstockhausen-solo_nr19_fur_melodieninstrument_mit_ruckkopplung), [Accessed October 17, 2016].

E Francioni. "SOLO_MV_10.1 Solo Multiversion for Stockhausen’s Solo [N.19]," in* Csound Journal*, Issue 13. Internet: [http://www.csoundjournal.com/issue13/solo_mv_10_1.html ](http://www.csoundjournal.com/issue13/solo_mv_10_1.html) , May 23, 2010 [Accessed October 17, 2016].

iTunes. "SOLO [Nr.19]," by apeSoft. Internet: [https://itunes.apple.com/us/app/solo-nr.19/id884781236?mt=8](https://itunes.apple.com/us/app/solo-nr.19/id884781236?mt=8), [Accessed October 17, 2016].

J. Heintz. "Live Csound, Using Csound as a Real-time Application in Pd and CsoundQt." in* Csound Journal*, Issue 17. Internet: [http://www.csounds.com/journal/issue17/heintz.html ](http://www.csounds.com/journal/issue17/heintz.html ) , Nov. 10, 2012 [Accessed October 17, 2016].
## Biography


![Francioni image](images/EnricoFrancioni.jpeg)Enrico Francioni graduated in Electronic Music and double-bass at the Rossini-Pesaro. His works are in Oeuvre-Ouverte, Cinque Giornate per la Nuova Musica, FrammentAzioni, CIM, EMUfest, VoxNovus, ICMC, Bass2010, and Acusmatiq, etc.
 He performed the world premiere of the *Suite I* by F.Grillo. As author and soloist he has awards in national and international competitions. He has recorded for Dynamic, Agora, Orfeo and others. He is dedicated to teaching and has taught double-bass at the Rossini-Pesaro.

 email: francioni61021 AT libero dot it
