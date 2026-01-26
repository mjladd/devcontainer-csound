# Chapter 21

Chapter 21
Steven Yi: Transit
Abstract This chapter discusses the process of composing Transit using Csound
and Blue. It will introduce the Blue integrated music environment and discuss how
it both augments the features of Csound and ﬁts within a composition workﬂow.
21.1 Introduction
The act of music composition has always been an interesting experience to me. A
large part of my musical process is spending time listening to existing material in
a work and making adjustments intuitively. I may be listening and suddenly ﬁnd
myself making a change: a movement of sound to a new place in time, the writing
of code to create new material and so on. At other times, I take a very rational
approach to analysing the material, looking for relationships and calculating new
types of combinations to experiment with. I suppose it is this way for everyone; that
writing music should oscillate between listening and writing, between the rational
and irrational.
The process of developing each work tends to unfold along its own unique path.
In Transit, I was inspired by listening to the music of Terry Riley to create a work
that involved long feedback delay lines. I began with a mental image of performers
in a space working with electronics and worked to develop a virtual system to mimic
what I had in mind. Once the setup was developed, I experimented with improvising
material live and notating what felt right. I then continued this cycle of improvisation
and notation to extend and develop the work.
For Transit, I used both Csound and my own graphical computer music environ-
ment Blue to develop the work. Csound offers so many possibilities but it can be-
come very complex to use without a good approach to workﬂow and project design.
Blue provides numerous features that worked well for my own process of compos-
ing this work. The following will discuss the phases of development that occurred
while developing this piece and how I employed both Csound and Blue to realise
my compositional goals.
© Springer International Publishing Switzerland 2016
V. Lazzarini et al., Csound, DOI 10.1007/978-3-319-45370-5_21
477
478
21 Steven Yi: Transit
21.2 About Blue
Blue is a cross-platform integrated music environment for music composition.1 It
employs Csound as its audio engine and offers users a set of tools for performing
and composing music. It provides a graphical user interface that augments Csound
with additional concepts and tools, while still exposing Csound programming and
all of the features that Csound provides to the user.
Blue is built upon Csound’s audio engine and language. All features in Blue,
even purely visual ones where users are not exposed to any Csound, generate code
using the abstractions available in Csound. For example, a single Blue instrument
may generate multiple Csound instrument deﬁnitions, user-deﬁned opcodes, score
events and function tables. Looking at it from another point of view, Csound pro-
vides a small but versatile set of concepts that can support building large and com-
plex systems such as visual applications like Blue.
Blue users can opt to use as many or as few of Blue’s features as they like. They
can start by working in a traditional Csound way and develop their work using only
Csound orchestra and score code. From here, they can choose to use different parts
of Blue if it serves their needs. For example, some may use the orchestra manager
and convert their text-only instruments into graphical instruments; others may use
the score timeline to organise score material visually using its graphic interface; and
still others may decide to use the Blue mixer and effects system to assemble and
work with their project’s signal graph.
Blue plays a major role in my work and is the primary way through which I
compose with Csound. Figures, 21.1–21.4 show the primary tools in Blue that I
used in writing Transit. I will discuss these tools and my approach to composing
with Blue below.
21.3 Mixer, Effects and the Signal Graph
For most of my works, I usually begin with the search for sounds. Besides my time
spent speciﬁcally on composing, I will spend time just working on developing new
instruments and effects. In my sound development time, I may write new Csound
instruments to try out new designs or I may use previously made designs and explore
their parameters to develop new “patches” for the instrument. It is in this time of
sonic exploration that a sound may catch my attention and I begin to experiment
with it and start to create a foundation for a new piece.
Once composing begins, I develop the signal graph of the piece by routing the
output of instruments used to generate the sounds through Blue’s mixer system. It
is there that I work on signal routing and inserting effects for processing such as
reverberation and equalisation.
1 http://blue.kunstmusik.com
21.3 Mixer, Effects and the Signal Graph
479
Fig. 21.1 Blue’s Mixer interface, used to deﬁne signal routing and effects processing.
In Transit, I used a different approach where I had an image of performers on a
stage in mind and began with developing the signal graph using Blue’s mixer and
effects system. I started by adding Blue Synth Builder instruments (described in
Section 21.4) that I had previously developed to my project. Using known instru-
ments allowed me to develop and test the mixer setup ﬁrst and work on the sounds
for the work later.
The primary processing focus for this work was the feedback delay. This is a
simple delay line where the output of the delay is multiplied and fed back into the
delay. The result is an exponentially decaying echo of any sound fed into the delay
effect. Rather than write this effect from scratch, I used the “Tempo-Sync Stereo
Delay” by William Light (a.k.a. ﬁlterchild) that was contributed to BlueShare —
a built-in, online instrument and effects exchange platform available within Blue.
Blue effects are written using Csound orchestra code and a graphical interface editor
available within the program.
Figure 21.1 shows the mixer setup used for the piece. In Blue, each instrument
within the project’s orchestra has a single mixer channel associated with it. Blue’s
mixer channels are not bound to any number of audio channels: a Blue instrument
may send one or many channels to the mixer and effects will process as many chan-
nels as they are designed to take as inputs. Each channel’s strip has bins for pre-
and post-fader effects and a ﬁnal output channel can be chosen from the dropdown
at the bottom of the channel strip. Channels can either route to sub-channels or the
master channel. Sub-channels in turn can route to other sub-channels or the mas-
ter channel. Blue restricts channel output to prevent feedback within the mixer (i.e.
480
21 Steven Yi: Transit
one cannot route from a channel to a sub-channel and back to the original channel).
Users may also insert sends as an effect within one of the channel’s bins that will
send a user-scaled copy of the audio signal to a sub-channel or the master channel.
For Transit, there are four main channels shown for each of the four instruments
used, a sub-channel named DelayLine that I added and the master channel. Channel
1’s output is primarily routed out to the master channel but it also sends an atten-
uated copy of the signal to the DelayLine sub-channel. Channel 2 and 3’s outputs
are primarily routed to the DelayLine sub-channel. Channel 4 is only routed to the
Master channel and has an additional reverb in its post-fader bin. All of the instru-
ment signals are ultimately routed through the master channel, where a reverb effect
(a thin wrapper to the reverbsc opcode) is used.
While Blue’s mixer and effects system provides the user with a graphical system
for creating signal-processing graphs, the underlying generated code uses standard
Csound abstractions of instruments and user-deﬁned opcodes. First, each Blue in-
strument uses the blueMixerOut pseudo-opcode to output signals to the mixer.
Blue processes instrument code before it gets to Csound and if it ﬁnds any lines
with blueMixerOut, it will auto-generate global audio-rate variables and replace
those lines with ones that assign signal values to the variables. These global vari-
ables act as an audio signal bus.2 Next, each Blue effect is generated as a user-
deﬁned opcode. Finally, all mixing code is done in a single Blue-generated mixer
instrument. Here, the global audio signals are ﬁrst read into local variables, then
processed by calls to effects UDOs. Summing and multiplication of signals is done
where appropriate. The ﬁnal audio signals are written to Csound’s output channels
to be written to the soundcard or to disk, depending upon whether the project is
rendering in real time or non-real time.
Blue’s mixer system proved valuable while developing Transit. I was able to
quickly organise the signal-routing set-up and use pre-developed effects for pro-
cessing. I could certainly have manually written the Csound code for mixing and
effects, but I generally prefer using Blue’s mixer interface to help visualise the sig-
nal graph as well as provide a faster and more intuitive way to make adjustments to
parameters (i.e. fader strengths, reverb times, etc.).
21.4 Instruments
Once the initial signal graph was developed, I turned my attention to the source
sounds to the graph. Blue provides its own instrument system that is an extension
of Csound’s. In Blue, users can write Csound code to write standard Csound instru-
ments, much as one would when using Csound directly. In addition, users can use
completely graphical instruments without writing any Csound code, use the Blue
Synth Builder (BSB) to develop instruments that use both Csound code and graphi-
2 Blue’s mixer system was developed long before arrays were available. Future versions of Blue
may instead use a global audio signal array for bussing, to provide easier to read generated code.
21.4 Instruments
481
Fig. 21.2 Blue’s Orchestra Manager, used to both deﬁne and edits instruments used within the
work as well as organise the user’s personal instrument library
cal widgets (or simply use just the graphical user interface to work with previously
developed instruments), or use scripting languages to develop Csound instruments.
For Transit, I used three types of instruments I had previously developed: two in-
stances of PhaseShaper (a phase-distortion synthesis instrument) and one instance
each of b64 (an instrument design based on the SID synthesis chip, commonly found
in Commodore 64 computers) and Alpha (a three-oscillator subtractive synthesizer).
These instruments are Blue Synth Builder (BSB) instruments where the main code
is written in the Csound orchestra language and a graphical interface is developed
using BSB’s GUI editor. The system lets the user write Csound code using place-
holder values inside angle brackets (shown in listing 21.2) within the Csound or-
chestra code where values from the GUI interface will be used.
While the three instrument types differ in their internal design, the instruments
share a common approach to their external design. By internal design I am referring
to the individual synthesis and processing code within each instrument and by ex-
ternal design I am referring to how the instruments are called through their p-ﬁelds.
For my work, I have developed a basic instrument template using user-deﬁned op-
codes that allows instruments to be called with either a ﬁve- or eight-p-ﬁeld note
statement or event opcode call.
Listing 21.1 Instrument p-ﬁeld format examples
; 5-pfield note format
; p1 - instrument ID
; p2 - start time
482
21 Steven Yi: Transit
; p3 - duration
; p4 - Pitch in Csound PCH format
; p5 - amplitude (decibel)
i1 0 2 8.00 -12
; 8-pfield note format
; p1 - instrument ID
; p2 - start time
; p3 - duration
; p4 - Start PCH
; p5 - End PCH
; p6 - amplitude (decibel)
; p7 - articulation shape
; p8 - stereo space [-1.0,1.0]
i1 0 2 8.00 9.00 -12 0 0.1
Listing 21.1 shows examples of the two different note p-ﬁeld formats. The ﬁve-
pﬁeld format is suitable for simple note writing that maps closely to the values
one would ﬁnd with MIDI-based systems: pitch and amplitude map closely to a
MIDI Note On event’s key and velocity values. I use this format most often when
performing instruments using either Blue’s virtual MIDI keyboard or a hardware
MIDI keyboard.
The eight-p-ﬁeld format allows for more complex notation possibilities such as
deﬁning start and end PCH values for glissandi, articulation shape to use for the note
(i.e. ADSR, swell, fade in and out), as well as spatial location in the stereo ﬁeld. I
use this format most often when composing with Blue’s score timeline as it provides
the ﬂexibility I need to realise the musical ideas I most often ﬁnd myself exploring.
Listing 21.2 Basic instrument template
;; MY STANDARD TEMPLATE
instr x
;; INITIALISE VARIABLES
...
;; STANDARD PROCESSING
kpchline, kamp, kenv, kspace yi_instr_gen \
i(<ampEnvType>), i(<attack>), i(<decay>), \
i(<sustain>), i(<release>), <space>
;; INSTRUMENT-SPECIFIC CODE
...
;; OUTPUT PROCESSING
aLeft, aRight
pan2 aout, kspace
21.5 Improvisation and Sketching
483
blueMixerOut aLeft, aRight
endin
Listing 21.2 shows the basic instrument template I use for my instruments. The
template begins with initialising variables such as the number of p-ﬁelds given for
the event, duration and whether the note is a tied note. Next, the yi instr gen
UDO uses the pcount opcode to determine if a ﬁve- or eight-pﬁeld note is given
and processes according the values of the p-ﬁelds together with the values passed in
to the UDO from BSB’s GUI widgets. yi instr gen returns k-rate values for fre-
quency (kpchline), total amplitude (kamp), amplitude envelope (kenv) and spa-
tial location (kspace). These values are then used by the instrument-speciﬁc code
and an output signal is generated. The ﬁnal signal goes through stereo-output pro-
cessing and the results are sent to Blue’s mixer using the blueMixerOut pseudo-
opcode.
Using a standardised external instrument design has been very beneﬁcial for me
over the years. It allows me to easily change instruments for a work as well as
quickly get to writing scores as I know the design well. I can also revisit older
pieces and reuse score generation code or instruments in new works as I know they
use the same format. For Transit, I was able to reuse instruments I had previously
designed and quickly focus on customising the sounds, rather than have to spend a
lot of time re-learning or writing and adjusting instrument code.
In addition, the use of graphical widgets in my instruments allowed me to both
quickly see as well as modify current settings for parameters. I enjoy writing signal-
processing code using Csound’s orchestra language, but I have found that when it
comes to conﬁguring the parameters of my instruments, I work much better using a
visual interface rather than a textual one. Blue provides me with the necessary tools
to design and use instruments quickly and effectively.
21.5 Improvisation and Sketching
After the initial instrument and effects mixer graph was set up, I started experi-
menting with the various instruments using BlueLive, a feature in Blue for real-time
performance. BlueLive offers two primary modes of operation: real-time instrument
performance using either Blue’s virtual MIDI keyboard or its hardware MIDI sys-
tem; and score text deﬁnition, generation and performance using SoundObjects and
the BlueLive graphical user interface.
BlueLive operates by using the current Blue project to generate a Csound CSD
ﬁle that does not include pre-composed score events from Blue’s score timeline.
Once the Csound engine is running, Blue will either transform incoming MIDI
events into Csound score text or generate score from SoundObjects and send the
event text to the running instance of Csound for performance.
484
21 Steven Yi: Transit
Fig. 21.3 BlueLive, a tool for real-time instrument performance and score generation
When I ﬁrst start to develop a work, I often ﬁnd myself using real-time instrument
performance to improvise. This serves two purposes: ﬁrst, it allows me to explore
the parameters of the instruments and effects I have added to my project to make
adjustments to their settings, and second, it allows me to experiment with score ideas
and start developing material for the piece.
Once a gesture or idea takes a hold of my interest, I notate the idea using the Blue-
Live interface using SoundObjects. SoundObjects are items that generate Csound
code, most typically Csound score. There are many kinds of SoundObjects, each
with their own editor interface that may be textual, graphical or both in nature. For
Transit, I began by using GenericScore and Clojure SoundObjects. The former al-
lows writing standard Csound score text and the latter allows writing code using the
Clojure programming language to generate scores.
Figure 21.3 shows the primary interface for BlueLive. A table is used to organise
SoundObjects; the user can use it to either trigger them one at a time or toggle
to trigger repeatedly. When an object in the table is selected, the user can edit its
contents using the ScoreObject editor window.3
When composing Transit, BlueLive allowed me to rapidly experiment with ideas
and explore sonic possibilities of my instruments and effects. It streamlined my
workﬂow by letting me make adjustments and audition changes live without having
to restart Csound. It is a key tool I use often when sketching musical material for a
work.
3 SoundObjects are a sub-class of a more generalised type of object called ScoreObject. Further
information about differences between the two can be found in Blue’s user manual.
21.6 Score
485
21.6 Score
Fig. 21.4 Blue Score, used to organise objects in time for pre-composed works
After notating a number of SoundObjects and experimenting live, I began the
process of composing the work by transferring SoundObjects from BlueLive to
Blue’s score timeline (shown in Figure 21.4). Blue’s score timeline is organised into
LayerGroups that are are made up of various Layers. Each LayerGroup has its own
kinds of layers and unique interfaces for creating and organising musical ideas in
time. Each LayerGroup is laid out with space between the layers, much like groups
of instruments are organised in orchestral scores.
For Transit, I used only SoundObject LayerGroups and used three kinds of
SoundObjects: the previously mentioned GenericScore and Clojure objects as well
as PianoRolls. PianoRolls offer visual editing of notes in time and are commonly
found in digital audio workstation and sequencer software. The choice to use one
object rather than another was done purely by intuition: I simply reached for the tool
that most made sense at the time while composing.
The ability to choose from a variety of tools for notating scores is an important
feature for me in Blue. Each LayerGroup and SoundObject type has its own advan-
tages for expressing different musical ideas. Just as using only text can feel limiting
to me, I will also feel conﬁned if I can only use visual tools for notating musical
ideas. Sometimes ideas develop more intuitively with one kind of object or another
and I am happy to have many options available and to use different kinds of objects
together in the same visual timeline system.
486
21 Steven Yi: Transit
I ﬁnd that visually organising and manipulating objects on a timeline is the opti-
mal way for me to work. I value Csound’s score format for its ﬂexibility and expres-
siveness and often use it for writing single notes or small gestures. However, once
a piece grows to a certain level of complexity, I ﬁnd it difﬁcult to mentally manage
all of the parts of a piece using text alone. With Blue, I can directly write Csound
score for the parts where it is useful, but I can also leverage all of the other features
of Blue’s score to aid me in my composing.
One ﬁnal note about the score in Transit: in addition to the organisation of ideas
into layers and objects, I also conﬁgured the timeline to divide time into equal four
beat units at a tempo of 76 beats per minute (BPM). Note that the BPM for the
score differs from the BPM for the delay line, which is set to 55 BPM. I found
these values by trial and error to create different temporal layers for the work. This
provided an interesting polyphonic quality between the notes as written and their
processed echoes through time.
21.7 Conclusions
In this chapter, I discussed my own approach to composing using Csound and Blue
in the piece Transit. Using Blue allowed me to build upon my knowledge of Csound
orchestra code to develop and use graphical instruments and effects. These instru-
ments and effects were then used with Blue’s mixer system, which provided a way to
visualise and develop the signal graph. BlueLive and Blue’s score timeline allowed
me to perform real-time sketching of material as well as organise and develop my
composition in time. Overall, Blue provided an efﬁcient environment for working
with Csound that let me focus on my musical tasks and simpliﬁed composing Tran-
sit.
