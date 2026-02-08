---
source: Csound Journal
issue: 18
title: "Csound for Cage's Ryoanji"
author: "Edition Peters"
url: https://csoundjournal.com/issue18/francioni.html
---

# Csound for Cage's Ryoanji

**Author:** Edition Peters
**Issue:** 18
**Source:** [Csound Journal](https://csoundjournal.com/issue18/francioni.html)

---

CSOUND JOURNAL[](https://csoundjournal.com/index.html) | [Issue 18](https://csoundjournal.com/index.html)
## Csound for Cage's Ryoanji

### A possible solution for the Sound System
 Enrico Francioni
 francioni61021 AT libero.it
## Introduction


With this article, I would like to continue the discussion begun in [Issue 13 [Spring]](http://csounds.com/journal/issue13/solo_mv_10_1.html) of the *Csound Journal*, examining another piece for acoustic instrument sounds and supporting sound system. This piece is a version of John Cage's *Ryoanji* for contrabass with percussion obbligato (vocalise ad libitum), published originally by Edition Peters. I hope to please not only the double bass players, but also all of the musicians that use Csound everyday.
##  I. Introduction to Ryoanji


"In 1983 [Cage] started a composition in progress called Ryoanji, named after the rock garden in Kyoto, Japan. This garden is a collection of 15 rocks, placed in a landscape of raked, white sand. In the summer of 1983 Cage started a series of drawings entitled "Where R=Ryoanji", using 15 different stones and drawing around these. Around that time the oboist James Ostryniec asked Cage to write a piece for him, which resulted in the first part of Ryoanji. Between 1983 and 1985 Cage added 4 more parts for voice, flute, double bass and trombone. In July 1992 Cage made sketches (during an interview with Joan Retallack and Michael Bach, described in Musicage - Cage muses on Words, Art, Music.), together with Michael Bach, for a cello part he never completed. The solos (in any combination or as solos) are always accompanied by a percussion part or a similar 20 member orchestral part. Every solo is a series of 8 songs (9 in the voice version). A song is created on 2 pages, each of which contains 2 rectangular systems. In every rectangle Cage traced parts of the perimeters of the given stones. These curves should be played as glissandi, within the given pitch ranges. In some places, contours overlap, thus being impossible to play for a soloist. In these cases, tape recordings are used to allow the soloist to play duets or trios. The percussion part is a single complex of 2 unspecified sounds, played in unison, wood and metal (not metal and metal). The metres for these materials are twelve, thirteen, fourteen or fifteen. The twenty musicians of the orchestra each independently choose a single sound, which they use for the entire performance. They should play in "Korean unison", their attacks being close, but not exactly together. These parts are a series of quarter notes (like in the percussion part) with notations (different for each instrument) to play slightly before, slightly after or more or less on the beat. The soloists represent the stones of the garden, the accompaniment the raked sand." - from the comments on the John Cage Trust site for Ryoanji[[1]](https://csoundjournal.com/#ref1)
## II. Notes


The following subsections are excerpts from the performance instructions for Cage's Ryoanji.
### Contrabass


 Each two pages represent a "garden" of sounds. The glissandi are to be played smoothly and as much as is possible like sound events in nature rather than sounds in music. The dynamics, not given, are to be soft rather than loud, as a rule, a rule that has exceptions. The pieces is for bass solo (shown below in the part as a solid line) ____ , with vocalise ad libitum (the straight horizontal lines, below, represent the staff) and prerecorded parts. These latter are ......, __ __, and _ . _ . Each part is to have its own sound system [[2]](https://csoundjournal.com/#ref2).

![image](images/ryoanji/01_Contrabass_vocalise.jpg)

**Figure 1.** **A page of the score showing the contrabass and vocalise ad libitum**[[2].](https://csoundjournal.com/#ref2)
 Extracts from RYOANJI by John Cage © Copyright 1984 by Henmar Press, Inc., New York. Reprinted by permission of Peters Edition Limited, London.


### Percussion obbligato


 At least two only slightly resonant instruments of different material (wood and metal, not metal and metal) are to be played in unison. The playing begins anywhere about two measures before the instrumentalist or vocalist enters, continuing during silences between two songs or pieces, and ending about two measures after the instrument or voice has stopped. These sounds are the "raked sand" of the garden. They should be played quietly but not as background. They should even be imperceptibly in the foreground. They should have some life (slight changes of imperceptible dynamics) as though the light on them is changing.

![image](images/ryoanji/02_Percussion_obligato.png)

**Figure 2.** **The first page of the Percussion part**[[3]](https://csoundjournal.com/#ref3).
 Extracts from RYOANJI by John Cage © Copyright 1984 by Henmar Press, Inc., New York. Reprinted by permission of Peters Edition Limited, London.


## III. Versions and choice of performance


If we dedicate ourselves to a performance of Cage's Ryoanji, to resolve certain questions of technical equipment, there is nothing more suitable than Csound. This choice is for a few good reasons: the extreme-portability and flexibility of the .csd file for live performance, the ability to manage freely and with great imagination the various elements in the code (the double basses, percussion and vocalise), and the ability to choose execution depending on what are the aims and intentions of a given type.

Being a double bass player, for Cage's Ryoanji, I concentrated mainly in setting the version for contrabass with percussion obbligato (vocalise ad libitum). From the catalog of Edition Peters [[4]](https://csoundjournal.com/#ref4) we can see that there are also other possible versions of Ryoanji written for the following instrumental ensembles: Contrabass and Percussion, Flute and Percussion, Oboe and Percussion, Trombone and Percussion, and Voice and Percussion. It is also possible to apply some interpretive license, regarding the "freedom" allowed by the author which is described in the introductory notes to this version.

Setting the interpretation of the version is the second stage of the work. This involves the choice of a performance mode as mentioned above, where a performance mode is just one of a number of possible approaches to the implementation of technical and musical performance. Csound can be employed in various ways on the basis of this choice. Here are some of the possible performance modes of Ryoanji with the use of Csound:
- A performance with all the performers employing live double bass soloist, three double basses recorded, percussion and vocalise "ad libitum"
- A performance with the live soloist (a double bass in our case) and support or background sounds which include three double basses, percussion and vocalise ad libitum
- Another mode which is an interpretive "hybrid" approach
- A performance totally in playback mode providing only sound direction
## IV. Preparation of material

### The musical score


There is no original overall score showing all parts together. After a quick look at the detached parts of Ryoanji - the contrabass (with vocalise ad libitum) and percussion [see previous score, Figure 2, above] - the need arises to see a combined, single score in order to obtain an overview of the entire work (duration: 17:35, assuming a tactus of percussion equals 60 bpm per quarter note) and to have complete control over the material.

![image](images/ryoanji/03_myScore.jpg)

**Figure 3.** **A page of the score (overlapping parts: Contrabass/Vocalise and Percussion)**[[2]](https://csoundjournal.com/#ref2)[[3]](https://csoundjournal.com/#ref3).
Extracts from RYOANJI by John Cage © Copyright 1984 by Henmar Press, Inc., New York. Reprinted by permission of Peters Edition Limited, London.

This is true because Cage himself left undefined elements, such as the point of initial overlap of the parts of the contrabass with the percussion. In fact the author [Cage] writes that the percussion should begin about two beats before, accompany the whole piece and cease their intervention (approximately) two strokes after the last entry of contrabass.

Strictly speaking all logic may be conceived and rewritten using the time domain (the one given to the crotchet percussion) borrowing from Cage the rectangles (or garden) of the contrabass. In fact this betrays some intentions that aims instead more towards an interpretation of the score (contrabass and vocalise) and a proportional system that is bringing back the parts to the whole duration of the piece. Any forcing, however, must be interpreted as a need for rationalization aimed at the implementation of the project. However, it is preserved as a micro-proportionality in the relationship between the glissando basses, being almost impossible to measure those within a strict time schedule. This can be refined in a detailed representation as shown in Figure 4, below, because of the objective characteristics of the musical nature of the glissando.

![image](images/ryoanji/04_Glissando.png)

**Figure 4.** **Detail of the score of the basses**[[2]](https://csoundjournal.com/#ref2)[[3]](https://csoundjournal.com/#ref3).
Extracts from RYOANJI by John Cage © Copyright 1984 by Henmar Press, Inc., New York. Reprinted by permission of Peters Edition Limited, London.

This element, namely the indefiniteness of the frequency of glissando at a given instant in time, is a characteristic thought of Cage. This can be traced back to the concept of alea and of indeterminacy in his musical writings. On the other hand when an overlay time grid is placed on the rectangles of the glissando, that activates a process of rationalization which is not entirely arbitrary or part of chance, but necessary for the realization of performance.

Among other things we can note that Cage, for a greater determination of timbre in score, indicates the string (contrabass) on which to engage the sound. We also see that for vocals, noted with lengths of horizontal lines of various styles, Cage implies a certain freedom of interpretation, especially regarding pitch. For basses, pitch is indicated in the extension notation at the top left corner, and the range of the horizontal staves are listed on the grid to the left at the beginning of each garden, as in Figure 5, below.



![image](images/ryoanji/05_Score.jpg)

**Figure 5.** **The elements of the original score**[[2]](https://csoundjournal.com/#ref2).
Extracts from RYOANJI by John Cage © Copyright 1984 by Henmar Press, Inc., New York. Reprinted by permission of Peters Edition Limited, London.
## V. The project

### The double bass soloist (live)


In the case of employing a live, solo, double bass there would be one of two solutions:
- The execution occurs totally in acoustic environments designed for a small-sized space, which requires a low level of overall intensity, without any correction of the sound.
- A live performance that is partially or fully amplified in the case of execution in a medium or large space. In this case the signal is acoustic as well as amplified - a maquillage of sound (reverberation, spatialization, etc.) that can mix with the source of other instruments.

For either case, there will be no particular problems with the code of Csound for realizing each way for live performance.

Thinking of a one-man performance, it is also important for the soloist to have simultaneous control of the various elements of the performance. For this reason it is essential to have the help of a GUI for a preliminary calibration, execution, and for control of its direct metronomic live performance. It is not essential, but at least desirable, to have a minimum of sound direction control.

Things are different if the bass solo is prerecorded and and played back. In this case the strategy of preparation of the patch will be similar to that of the other three recorded contrabasses. It is recommend to those who want to deal with this version of Ryoanji for contrabass be ready to employ both methods (live and playback), and then have the ability to execute the first double bass playback while preparing in advance the sound system.
### The three contrabasses (on support)


The realization of the three contrabass parts for the support material, as well as that of the soloist in the case of a playback performance, may be organized according to various strategies:
- Make a studio recording using an audio track for each double bass, then import it into our algorithm rendered with Csound in real time. Then, realize a patch which allows for making an analysis (also in deferred time) and a resynthesis in real-time.
- Use a recording of audio samples (in deferred time) and a stretching in real time of the recording . It is essential to be aware that this mode still requires a considerable amount of CPU resources from our machine.
- Use a mixture of 1 and 2, realizing a preparation for the work in deferred time and then save the result as audio files which are then imported back into our algorithm, rendered with Csound in real time.
- There may also be another method to save resources by realizing the parts of the three basses using a synthetic route (eg. with the use of semi-physical models in Csound), but that hasthe problem, however, of having no actual acoustic instrumental sound.
### Percussion (on support)


In the mode chosen for the realization of the pulses for the required percussion that accompanies the whole piece, audio samples that are a compound of the sound of metal overlaid with a sound of wood were used. In addition to the patch for percussion there were two additional items:
- The ability of the performer to choose the sound of the drums using two small libraries (via a menu): metal (or metal + wood) and wood taken from the collection of some semi-physical models provided to us with Csound and other samples from audio
- Scanning the first beat of each "measure" with another percussion instrument (wood).

It would be possible to opt for a live performance of percussion, thus saving many lines of code, but these are part of the choices that will be made by an interpreter realizing the score.
### Vocalise ad libitum (on support)


For voice we can give free rein to the imagination. Cage in fact gives us no indication on the implementation of vocalise; between the lines he wrote only that it is noted on the score with differentiated horizontal lines . Also for Vocalise we are led to think that the solid line ______ indicates the vocalise live, while the other three types of notation: ____ /. . . . . / _. _. _. refer to vocalise on the digital background.

In my version, however, all four lines of vocalise are realized in the support part in order to facilitate even more of a one-man performance. Now let us see what we have to do for the project as it applies to the operation and code of Csound.
## VI. The patch for Ryoanji (Orchestra, Score and GUI)

### Hardware


To play the .csd file, we will need to connect a multichannel audio card (four channels) to our computer. From there we will need to connect four monitors (Ch1: Left Front; Ch2: Right front; Left rear Ch3; Ch4 Right rear) to the outputs of the card, and two microphones into inputs 1 and 2 of the card. We will the set the preferences of our frontend to match this configuration.
### Software


Be sure the the .csd folder is located within the main folder of code for Csound, which is necessary for a successful execution of .wav, .mp3, .pvx, and .txt types. The code for this project was written using Csound version 5.13. For successful execution and conservation of resources, after launching the .csd (Ryoanji_1.5.3b.csd), we will need to check that the following defaults are in the .csd options tag and in the orchestra:
- Real-time buffer frames: 1024
- Disabling Output listing in I/O object
- Disabling Display Functions in I/O object

Set the header for playback to the values as shown below.
```csound
sr        =    44100
ksmps     =    120
nchnls    =    4
```


These are the the options to be used instead for recording, listed below.
```csound
sr        =    44100
ksmps     =    260
nchnls    =    4
```

### Score


With regard to the score, it was limited to only a few lines of code. The score will keep the algorithm switched on for a time equal to 3600 seconds, manage the reading speed, perform the `skiptime` (advance) and manage the GUI (GUI_reset, GUI_in, GUI_out) in realtime.
```csound
f0	3600 		; active for one hour
; AGOGICA
t0	60
; skiptime (advance)
a0	0	0
; [ section:  I=32 ; II=156 ; III=280 ; IV=404 ; V=528 ; VI=652 ; VII=776 ; VIII=900 ]
; RESET GUI
i300		0	.1
; GUI IN
i301		.1	-1
; GUI OUT
i302		.1	-1
```

### Orchestra


As can be seen in the flow chart at the end of this article (Figure 18.), this patch is concentrated mainly in the orchestra and is divided into two parts: sample registration and performance. The first lines of code in the head of the orchestra concern `prealloc` tools, initialization of global variables (types a, k and i) and functions (`ftgen`). Regarding the description of the code of the orchestra, some images of the GUI controls can help with your understanding. These were written using MacCsound 1.5, but you should also be able to open the .csd with CsoundQt.
## VII. Recording


The .csd has been prepared for all the files types needed to run the project, such as .wav, .mp3, .pvx, and .txt. See the link below for downloading all files needed to run this project. This section was added to allow the interpreter to customize the performance by making use of its material (as far as the contrabass register and vocalise). This tool, shown in Figure 6, below, has the task of recording and saving audio samples (.wav) of double bass (four C2 on all four strings), as well as audio samples (.wav) and analysis files (.pvx) of voice (vowels I, O, A, E which correspond to the four parts of the Vocalise). The selection and order of the voice is only a suggestion for performance.    ![image](images/ryoanji/06.Recording_01.png)   ![image](images/ryoanji/07.Recording_02.png)           Panel for the control of the recording    Choosing the type of sample to be recorded

**Figure 6.** **Recording panel GUIs.**

Before recording, you can turn on a count-down display(cntdwn), punctuated by the LED light, as well as decide the length of the recording (dur). After triggering the Start Render and setting the controls, the REC button will activate the count-down and the subsequent recording (be sure to attach a microphone on Channel 1).

The code for this is listed below.
```csound
instr irec			; call recording
gkirec 	= 1 - gkirec
		schedkwhen		gkirec, -1, 1, "rec", 	 gkwhen, gkdur
		schedkwhen		gkirec, -1, 1, "Timout", 0, 	   gkwhen
		turnoff
		endin
instr	Timout		; count-down recording
if gkirec != 0 goto cont
turnoff
cont:
idur	= 	1
p5	=	.01
p6	=	.4
p7	=	.01
daqua:
gknvTmout 	linseg	0, p5, 1, p6, 1, p5, 0, idur - ((2 * p5) + p6), 0
timout	0, idur, continua
reinit	daqua
continua:
rireturn
endin
instr	rec			; recording file wav and pvx (one track at a time)
if gkirec != 0 goto cont
turnoff
cont:
aIn		inch	1
gktmRec	timeinsts
if		i(gkrec)	==	1 	then
Sfile		=	"/Users/enrico/Desktop/Ryoanji/myCbC3_I.wav"
fout		Sfile, 2, aIn
elseif	i(gkrec)	==	2	then
Sfile		=	"/Users/enrico/Desktop/Ryoanji/myCbC3_II.wav"
fout		Sfile, 2, aIn
elseif	i(gkrec)	==	3	then
Sfile		=	"/Users/enrico/Desktop/Ryoanji/myCbC3_III.wav"
fout		Sfile, 2, aIn
elseif	i(gkrec)	==	4	then
Sfile		=	"/Users/enrico/Desktop/Ryoanji/myCbC3_IV.wav"
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

## VIII. Performance (Play)


For performance playback there are at least four areas of code: double bass solo, the three basses in the background, the percussion, and the vocalise (ad libitum). As mentioned above, each element of performance is manageable in an almost independent manner of the other. For further simplification there are also some pre-defined settings for execution available from the Preset menu (in GUI).
### Contrabass soloist


The settings shown in Figure 7, below, are available as performance options: *off*, *live*, *file*, and *samples*.

![image](images/ryoanji/09.Soloist_02.png)

**Figure 7.** **Control panel for double bass soloist.**
- *off* - playback totally acoustic without any correction of the sound.
- *live* - playback with the correction signal (microphone channel 1) - width/mute, reverb and spatialization.
- *file* - playback (mp3 file); you can adjust amplitude/mute, reverb and spatialization. The interpreter for playback can also use their own audio files that will be loaded with MacCsound in a .csd such as below.
```csound
gaCB1 soundinmac "/Users/enrico/Desktop/Ryoanji/CB_01-mn.mp3", 1, i(gkskiptim) or with the opcode: mp3in
```

- *samples* - for playback with the ability to choose from the library of audio samples that will be imported from `itab`, using the opcode `mincer` (dedicated to stretching) shown below:
```csound
gaCB1	mincer atime, kamp, kpitch, itab, ilock
```


In stretching the sample number, it is each time re-modeled in the pitch by the argument `kpitch` through the `transeg` opcode (based on the performance track in the score - glissando).

The options available for samples (through the menu on the right), shown in Figure 8 below, are from the first library of audio samples (lib_smp) which refer to the existing library in the directory of the .csd (CbC3_I.wav, CbC3_II.wav, CbC3_III.wav, CbC3_IV.wav). The second library (rec_smp) calls the custom and pre-recorded samples (samples labeled: myCbC3_I.wav, myCbC3_II.wav, myCbC3_III.wav, myCbC3_IV.wav).

![image](images/ryoanji/10.Soloist_03.png)

**Figure 8.** **Choice of sample libraries for the bass soloist.**
### Contrabass (on support)


This is concerning the three basses which are the fixed parts in the execution of Ryoanji. We can see that this time the menu, shown in Figure 9, below, has two options: file and samples.

![image](images/ryoanji/11.Contrabass_01.png)

**Figure 9.** **Contrabass panel for support, with the file/samples menu**.

The *file* option invokes three previously recorded mp3 audio tracks (one for each part of the bass). The *samples* option (such as the double bass soloist) in turn provides us with access to the side menu to import the sample data or use pre-recorded samples.

As in the code for the bass soloist, a dedicated Csound instrument for each contrabass part is used, as well as the option for what type of execution, which calls (`schedule`) for the instrument that performs stretching. The following is an excerpt of code for the double bass 2 instrument:.
```csound
instr CB2
if gkiPlay != 0 goto cont
turnoff
cont:
if 		i(gkCB234) = 1 then
gaCB2		soundinmac	"/Users/enrico/Desktop/Ryoanji/CB_02-mn.mp3", 1, i(gkskiptim)
gkled2=0
elseif 	i(gkCB234) = 2 then
clear	gaCB2
gkled2 = 1
;		p1		p2		p3		p4	p5	p6	p7	p8	p9	p10	p11	p12	p13	p14	p15	p16	p17	p18	p19
schedule	"cb2",	57.85,	7.85,		3,	1,	2,	1,	0,	1,	1,	2,	.3,	.3,	2,	4,	4,	10,	8,	1
schedule	"cb2",	82.50,	4.4,		2,	4,	1.5,	-.5,	-1,	-1,	-1,	-1,	.3,	.3,	2,	4,	4,	10,	8,	1
schedule	"cb2",	88.45,	7.25,		2,	1,	-2,	-1,	.5,	-1,	-1,	-1,	.3,	.3,	3,	3,	3,	9,	9,	1
schedule	"cb2",	147.55,	2.77,		3,	-1,	-1.5,	-2.5,	-3,	-1,	-1,	-1,	.3,	.3,	3,	3,	3,	10,	10,	1
schedule	"cb2",	422.00,	5.1,		3,	2.5,	.5,	-.5,	0,	-1,	-1,	-1,	.3,	.3,	4,	2,	4,	10,	12,	1
schedule	"cb2",	427.40,	3.9,		3,	2.6,	3.2,	2.3,	1.4,	1,	1,	2,	.3,	.3,	3,	3,	3,	10,	12,	1
schedule	"cb2",	443.40,	3.9,		2,	0.85,	.85,	1.5,	2.7,	-1,	-1,	-1,	.3,	.3,	3,	3,	3,	10,	12,	1
schedule	"cb2",	455.40,	3.4,		4,	-1.3,	1,	2,	2.6,	1,	1,	1,	.3,	.3,	4,	4,	2,	10,	50,	1
schedule	"cb2",	458.80,	5.95,		4,	.8,	1.2,	1.8,	.8,	1,	1,	2,	.3,	.3,	3,	3,	3,	50,	10,	1
schedule	"cb2",	470.70,	7.1,		3,	.4,	1.4,	1.9,	1.2,	1,	1,	1,	.3,	.3,	3,	3,	3,	10,	10,	1
schedule	"cb2",	515.20,	7.6,		2,	1.2,	.7,	1.8,	1.3,	0,	1,	2,	.3,	.3,	3,	3,	3,	10,	12,	1
endif
endin
```


The arguments to `schedule` (from `p4` to `p19`) refer to the values destined for the opcode `mincer`, which in this case is located in the instrument cb2.

As for the soloist there are controls for amplitude/mute and reverb (`nreverb`), which also influence the sound of the bass soloist. There are sliders for the duration in seconds (`ktime`) and the amount of diffusion at high frequency (`khdif`) for the reverb.
### Percussion


![image](images/ryoanji/12.Percussion_01.png)

**Figure 10.** **Panel for Percussion.**

The Percussion panel, Figure 10, is shown above. The Impulse panel is dedicated to all the quarter notes, while the First panel is dedicated to just the first quarter note of each bar. In both percussion panels we can manipulate the type of sound, amplitude/mute and reverb. In addition, through a menu there are several options available:
- *off* - turns off both Impulse and First (with `turnoff`);
- *live* - is an option exclusively dedicated to Impulse, to enable a live performance with the effects signal (microphone, channel 2) that controls width/mute, reverb and spatialization, while the First tool continues to play the selected samples;
- *samples* - with this choice in both tools (Impulse and First), shown in Figure 10, below, we can select sounds from a library of percussion samples.

![image](images/ryoanji/13.Percussion_02.png)

**Figure 11.** **Panel of Impulse, off/live/samples**.

When selecting the *samples *menu option (in PERCUSSIONS panel, see Figure 10), the instruments `PC12` and `PC3` from Ryonji_1.5.3b.csd activate timing (utilizing values written in a table as .txt files) for instruments `pc1`, `pc2`, and `pc3`, which determine the type of samples. The instruments `pc1`, `pc2`, and `pc3` will in turn send the audio signal output to instruments `pc12out` and instrument `pc3out`. The following is the model code for PERCUSSIONS (First panel, see Figure 10), utilizing the `schedule` opcode along with the opcode `loop_le`.
```csound
istart = 0
iend	 = 77
looppoint:
ip2  table  istart, gir27
schedule "pc3", ip2, 10
loop_le istart,1,iend,looppoint
```


As mentioned above, for both the First percussion tool and for Impulse, shown below in Figure 12, there are two distinct percussion libraries: one for Impulse (percussion of metal + wood) and another for First (percussion of wood).     ![image](images/ryoanji/14.Percussion_03.png)   ![image](images/ryoanji/15.Percussion_04.png)

**Figure 12.** **Percussion tools, menu access to the sounds.**

Here are some of the percussion sounds used in the patch (as samples or semi-physical models of Csound):
```csound
asig_01	tambourine	30000, .1
asig_02	cabasa	30000, .01
asig_03	sleighbells 20000, 0.01
asig_04	diskin2	"scod_perc-mn_03.wav", 1
```


and
```csound
asig_01	guiro		25000, p3
asig_02	bamboo	9000, .1, 0, .035, 0, 1000, 3000, 10000
asig_03	cabasa	20000, .01
asig_04	diskin2	"30-prc01-gaml1-mn.wav", 1
```


Also for Percussion, controls for amplitude/mute, reverb and spatialization (the latter inside the .csd) are also utilized.
### Vocalise (ad libitum)


For Vocalise (ad libitum), we can choose between these possibilities of execution: *off*, *mnc*, or *pvx*, as shown in Figure 13, below.

![image](images/ryoanji/16.Vocalise_01.png)

**Figure 13.**** Panel Vocalise (ad libitum).**
- *off* - the tools associated with Vocalise are suppressed (`turnoff`).
- *mnc* - activates stretching of audio samples, similar to the double bass soloist.
- *pvx *- resynthesis is activated, using the `pvsfread`, `pvscale`, and `pvsynth` opcodes with .pvx files. This alternative requires more cpu resources than using the `mincer` opcode.

With both *mnc* and *pvx* there is access to two corresponding libraries: the first is the default one and the second is a custom one.

Below, in Figure 14, is shown the library selection for *mnc*. The lib_smp selection is the sample library of audio data and the rec_smp selection is for the custom library of sound samples.

![image](images/ryoanji/17.Vocalise_02.png)

**Figure 14.** **Sound sample selection options.**

 Below, in Figure 15, is shown the library selection for pvx. The lib_pvx selection is for the default library and rec_pvx is for the custom library.

![image](images/ryoanji/18.Vocalise_03.png)

**Figure 15.** **pvx selection options.**

For Vocalise there are also controls for amplitude/mute, reverb and spatialization (the latter inside the .csd).

Within the Play panel shown below, we have the ability to perform several functions:
- enable/disable the *rms* signal (either in code or in the GUI) for further savings on the CPU
-  reset the controls in the GUI (reset)
-  perform the *skiptime* for the choice of the point of execution of the file
- see the scan rate of the metronome through the two *LEDS*
-  check the *timer* number that marks the second.

You can choose the value of `skiptime` with the menu section that will start running from one of the eight gardens in the following times (in seconds): I = 32; II = 156; III = 280; IV = 404; V = 528; VI = 652; VII = 776; VIII = 900.

To start the playback, after using Start Render and choosing the type of performance, we will select the Play button.
## IX. Spatialization and Localization


In spatialization/localization of sound, four channels are utilized: (Channel 1: Left front - Channel 2: Right front - Channel 3: Left rear - Channel 4: Right rear). This implies the use of a quadraphonic system for the four basses or four types of vocalise. In the code, each part is given a location and a basic movement within the acoustic space. The parts are generally assigned to channels as described below:
- Contrabass I: Left front (In the case of a live performance without microphone, the soloist will be placed with the double bass near the monitor Channel 1-Left front)
- Contrabass II: Right front
- Contrabass III: Left rear
- Contrabass IV: Right rear
- Percussion (Impulse and First): Linear from the Left front, Right front and back
- Vocalise (ad libitum) I: circular movement and returning to the starting position Left front
- Vocalise (ad libitum) II: circular movement and returning to the starting position Right front
- Vocalise (ad libitum) III: circular movement and returning to the starting position Left rear
- Vocalise (ad libitum) IV: circular movement and returning to the starting position Right rear

The opcode `space` was employed for the spatialization, with parameters as shown below:
```csound
a1, a2, a3, a4  space asig, ifn, ktime, kreverbsend, kx, ky
```


For the four basses `ifn` changes movement through the function (GEN28), shown below.
```csound
gir9	ftgen	9,	0,	0,	-28,	"CB01.txt"
```


Above, `ftgen` reads the values in a text file (.txt) that contains a time-tagged trajectory, using an example shown below. In this example the track of the movement of the bass soloist is in the area of the Left front space.
```csound
0		-1	1
39.30		-1	1
47.00		-4	4
52.30		-1	1
55.60		-1	1
62.00		-3	3
82.50		-1	1
84.35		-2	2
etc...
```


Also for Percussion (Impulse and First), two f-tables (`ifn)` are used for `space`, which are loaded via GEN28 (PC12.txt and PC3.txt).

In Vocalise I-II-III-IV, circular spatializations are utilized (different for each type of vowel) expressed in code as shown below. This example is taken from the code used for Vocalise I. In the code below, with the value 3.14159 the signal path starts from the left, but with the value of 3.14159 / 4 the signal starts from the right front. With the value 6.2832 panning tends to be complete - this calculation determines the values that define each point of the circle . The multiplier `kr` determines the number of laps around the speakers (this can be less than 1 or a fraction of 1).
```csound
kangolo init	3.14159/4
incr		=	6.2832 / p3 / kr * 1
kx		=	cos(kangolo) - 1
ky		=	sin(kangolo) + 1
kangolo	=	kangolo + incr
```


Shown below, in Figure 16, is the graphical interface as a whole.

![image](images/ryoanji/19.GUI.png)

**Figure 16.** **GUI of Ryoanji.**

Below, in Figure 17, is a list of active Csound instruments utilized.

![image](images/ryoanji/20.List.png)

**Figure 17.** **Active Csound instruments.**

Below, in Figure 18, is shown an overall algorithmic design for the composition.

![image](images/ryoanji/21.Diagram.png)

**Figure 18.** **Overall algorithmic design.**
## X. Conclusion


This algorithm offers a technical solution for a one-man-performance of Ryoanji by John Cage in the version for contrabass, percussion and vocalise ad libitum. This fills a gap in the literature of sound systems dedicated to historical works for acoustic instrument sounds and background playback. It also gives us the opportunity to choose a performance version more suitable to the performer thanks to the various options proposed: acting directly on the presets, using the GUI controls, or controlling other specific parameters directly in the code of a .csd. This also allows the performer to use their own concrete material, giving an impression of a somewhat customized performance.

The patch can be easily modified and adapted to other frontends (CsoundQt, WinXound, Cabbage), as well as modified and expanded as desired by the performer. All the code for the GUIs and examples use Csound, a software synthesis application which is free and widely available for use by all. Csound continues to demonstrate increasing portability and adaptability for the most varied applications.

You can download a compressed folder containing the algorithm Ryoanji_1.5.3.csd and all the files needed for this project at [Ryoanji.zip.](https://csoundjournal.com/downloads/Ryoanji.zip) See below for a complete list of files in this archive. Also there is an audio realization of the piece available online at SoundCloud, for contrabass with percussion obbligato and vocalise ad libitum, featuring the author on contrabass and original four channel playback system(the recording is from 2008). See below in "Essential Sitography".


## Further Developments


I believe that with a good preparation and appropriate changes to the code, it will be possible to to interpet the values of pitch (in time) much more faithfully to the score by Cage. I think there is an opportunity to use graphic sequencers such as IanniX ([http://www.iannix.org/](http://www.iannix.org/)), or GeoSoniX ([http://www.geosonix.com/top/](http://www.geosonix.com/top/)), which, through the OSC protocol, are able to communicate data to Csound in real time or in deferred time. In this case, we would be able to read and communicate values of pitch in time directly from the graphs that represent the glissando. Of course, the reading of values of real-time pitch is more complex to implement in terms of code and will likely require more CPU resources.

This possible solution is without a doubt very laborious, especially in the first phase. For the transformation of the graphics into vectors (remember that the glissando concern all four basses and that the piece has a life of respect), a number of software options are possible. We could use Adobe Illustrator or, to remain open-source, use programs such as Plot Digitizer ([http://plotdigitizer.sourceforge.net/](http://plotdigitizer.sourceforge.net/)). However, in return for this work, we would no doubt get good results in the extraction of pitch values.

It must be said finally, and it is almost taken for granted, that to get a higher sound quality for the project when working with sampling, it would be necessary to use a small sample library of bass sounds diversified in pitch and timbre.


## Acknowledgments


I thank Steven Yi, James Hearon, Eugenio Giordani, Victor Lazzarini, Francesco Porta and *Csound Journal* for helping me in various ways on the realization of this project.
## References


[][1]]John Cage Trust. (2013). [Online]. Available: [ http://johncage.org/pp/John-Cage-Works.cfm ](https://csoundjournal.com/  http://johncage.org/pp/John-Cage-Works.cfm). [Accessed May 27, 2013].

[][2]]John Cage. (2013). "Ryoanji, Contrabass with percussion or orchestra obbligato and ad libitum with other pieces of the same title - Edition Peters, 1984 - 66986e," (used by permission) in Edition Peters [Online]. Available: [ http://www.edition-peters.com/search.php?keyword=ryoanji&searchby=ryoanji](http://www.edition-peters.com/search.php?keyword=ryoanji&searchby=ryoanji ). [Accessed May 27, 2013].

[][3]]John Cage. (2013). "Ryoanji, Percussion - for Percussion (or played with songs of the same title or other pieces of the same title for oboe) - Edition Peters, 1983 - 66986a ," (used by permission) in Edition Peters [Online]. Available: [ http://www.edition-peters.com/search.php?keyword=ryoanji&searchby=ryoanji](http://www.edition-peters.com/search.php?keyword=ryoanji&searchby=ryoanji ). [Accessed May 27, 2013].

[][4]]Edition Peters. (2013). [Online Catalog]. Available: [ http://www.edition-peters.com/search.php?keyword=ryoanji&searchby=ryoanji](http://www.edition-peters.com/search.php?keyword=ryoanji&searchby=ryoanji ). [Accessed May 27, 2013].
## Bibliography


Andrea Cremaschi and Francesco Giomi, "Rumore bianco, Introduzione alla musica digitale," (In Italian). Bologna, IT: Zanichelli, 2008.

Charles Dodge and Thomas A. Jerse, "Computer Music: Synthesis, Composition and Performance, " second edition. Stamford, CT: Cengage Learning, 1997.

Giorgio Zucco, "Sintesi digitale del suono, Laboratorio pratico di Csound," (In Italian). Torino, IT: G.Zedde Edizioni, 2012.

J. Heintz, J. Aikin, and I. McCurdy, et. al. *FLOSS Manuals, Csound*. Amsterdam, Netherlands: Floss Manuals Foundation, [online document]. Available: [http://www.flossmanuals.net/csound/ ](http://www.flossmanuals.net/csound/) [Accessed May 25, 2013].

Riccardo Bianchini and Alessandro Cipriani, "Il Suono Virtuale," (Italian Edition). Roma, IT: ConTempo s.a.s., 1998.
## Discography


Joëlle Léandre, "John Cage." *Ryoanji*, with J.Léandre, double bass, voice, tape realisation, and N.Lê Quan, percussion . Auvidis Montaigne MO 782076, 1996

Stefano Scodanibbio, "Dream, John Cage." Includes *Ryoanji*. Mainz —Wergo WER 6713 2, 2009.
## Essential Sitography


A. Cabrera, et. al. "QuteCsound." Internet: [http://qutecsound.sourceforge.net/index.html ](https://csoundjournal.com/ http://qutecsound.sourceforge.net/index.html), [Accessed May 25, 2013].

E. Francioni. "Cage-Ryoanji_(stereo_version)_[selection]," (on SoundCloud). Internet: [https://soundcloud.com/kolox/cage-ryoanji-stereo_version ](https://soundcloud.com/kolox/cage-ryoanji-stereo_version), [Accessed May 26, 2013].

E. Kohler. "Indeterminacy." Internet: [http://www.lcdf.org/indeterminacy/ ](http://www.lcdf.org/indeterminacy/), [Accessed May 25, 2013].

J. Clements and R. Boulanger. "Csounds.com." Internet: [http://www.csounds.com/](http://www.csounds.com/), [Accessed May 25, 2013].

J. Heintz. "Live Csound, Using Csound as a Real-time Application in Pd and CsoundQt." in* Csound Journal*, Issue 17. Internet: [http://www.csounds.com/journal/issue17/heintz.html ](http://www.csounds.com/journal/issue17/heintz.html ) , Nov. 10, 2012 [Accessed May 25, 2013].

J. Hiam. "John Cage unbound, A Living Archive." Internet: [ http://exhibitions.nypl.org/johncage/](http://exhibitions.nypl.org/johncage/), [Accessed May 26, 2013].

J. Léandre. "Joëlle Léandre." Internet: [http://www.joelle-leandre.com/ ](http://www.joelle-leandre.com/ ), [Accessed May 26, 2013].

 J. Pritchett. "James Pritchett: Writings on John Cage (and others)." Internet: [http://www.rosewhitemusic.com/cage/ ](http://www.rosewhitemusic.com/cage/), Sept. 8, 2007 [Accessed May 26, 2013].

J. Ronsen. "John Cage Online." Internet: [http://www.ronsen.org/cagelinks.html ](http://www.ronsen.org/cagelinks.html), April 23, 2013 [Accessed May 26, 2013].

J. Zitt. "silence@virginia.edu." Internet: [https://lists.virginia.edu/sympa/info/silence ](https://lists.virginia.edu/sympa/info/silence), 2013 [Accessed May 26, 2013].

John Cage Trust. "John Cage." Internet: [ http://johncage.org/](http://johncage.org/), 2013 [Accessed May 25, 2013].

John Cage Trust. "John Cage: Database of Works." Internet: [ http://johncage.org/pp/John-Cage-Works.cfm](http://johncage.org/pp/John-Cage-Works.cfm), 2013 [Accessed May 25, 2013].

K. Ervik and Ø. Brandsegg, "Creating reverb effects using granular synthesis," in *Csound Conference 2011*, Hanover, GR., 2011, [online document]. Available: [http://www.incontri.hmtm-hannover.de/fileadmin/www.incontri/Csound_Conference/Ervik_Brandtsegg2.pdf ](http://www.incontri.hmtm-hannover.de/fileadmin/www.incontri/Csound_Conference/Ervik_Brandtsegg2.pdf), [Accessed May 26, 2013].

M. Ingalls. "MacCsound." Internet: [http://www.csounds.com/matt/MacCsound/ ](http://www.csounds.com/matt/MacCsound/), July 27, 2010 [Accessed May 25, 2013].

P. van Emmerik, et. al. "A John Cage Compendium." Internet: [http://cagecomp.home.xs4all.nl/ ](http://cagecomp.home.xs4all.nl/), Jan. 7, 2013 [Accessed May 26, 2013].

R. Walsh, et. al. "Cabbage." Internet: [ http://www.thecabbagefoundation.org/home.php](http://www.thecabbagefoundation.org/home.php), [Accessed May 25, 2013].

S. Bonetti. "WinXound." Internet: [http://winxound.codeplex.com/](http://winxound.codeplex.com/), Dec. 7, 2010 [Accessed May 25, 2013].

S. Pocci. "John Cage In Italy." Internet: [http://www.johncage.it/en/index.html ](http://www.johncage.it/en/index.html), [Accessed May 26, 2013].

S. Scodanibbio "Contributions - Cage." Internet: [http://www.stefanoscodanibbio.com/contributions/1.htm ](http://www.stefanoscodanibbio.com/contributions/1.htm), [Accessed May 26, 2013].

Wikipedia. "John Cage," (in Italian). Internet: [http://it.wikipedia.org/wiki/John_Cage ](http://it.wikipedia.org/wiki/John_Cage ), [Accessed May 26, 2013].
### List of Files in the download for this project, "Ryoanji.zip":


**contrabass:**
 CB_01-mn.mp3, CB_02-mn.mp3, CB_03-mn.mp3, CB_04-mn.mp3,
 CbC3_I.wav, CbC3_II.wav, CbC3_III.wav, CbC3_IV.wav,
 **percussion:**
 scod_perc-mn_03.wav, scod_perc-mn_04.wav, 30-prc01-gaml1-mn.wav
 **vocalise:**
 Vx_I.wav, Vx_O.wav, Vx_A.wav, Vx_E.wav,
 Ryoanji_01.pvx
 **spatialization:**
 CB01.txt, CB02.txt, CB03.txt, CB04.txt,
 CBS01.txt, CBS02.txt, CBS03.txt, CBS04.txt,
 PC12.txt, PC3.txt

The recorded files will have these names:

**contrabass:**
 myCbC3_I.wav, myCbC3_II.wav, myCbC3_III.wav, myCbC3_IV.wav,
 **vocalise:**
 myVx_I.wav, myVx_O.wav, myVx_A.wav, myVx_E.wav,
 myVx_I.pvx, myVx_O.pvx, myVx_A.pvx, myVx_E.pvx
