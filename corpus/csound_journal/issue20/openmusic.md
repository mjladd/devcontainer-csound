---
source: Csound Journal
issue: 20
title: "OpenMusic: The Csound Connection"
author: "researchers and musicians at IRCAM for the purpose of facilitating various aspects of advanced music composition"
url: https://csoundjournal.com/issue20/openmusic.html
---

# OpenMusic: The Csound Connection

**Author:** researchers and musicians at IRCAM for the purpose of facilitating various aspects of advanced music composition
**Issue:** 20
**Source:** [Csound Journal](https://csoundjournal.com/issue20/openmusic.html)

---

CSOUND JOURNAL[](https://csoundjournal.com/../index.html) | [Issue 20](https://csoundjournal.com/index.html)
## OpenMusic: The Csound Connection
 Dave Phillips
 dave AT linux-sound.org
## Introduction


This article focuses on the use of Csound in the OpenMusic environment. OpenMusic is a software package designed by researchers and musicians at IRCAM for the purpose of facilitating various aspects of advanced music composition, including algorithmic methods, microtonal output, and multi-modal music notation. Thanks to special libraries, Csound adds a general purpose audio synthesizer to OpenMusic's many formidable capabilities.
## I. Brief Introduction To OpenMusic


OpenMusic (OM) is a Lisp-based visual programming environment with a rich set of classes and libraries designed for music composition. A program in OM is an arrangement of graphic objects in a data processing network called a patch, shown below in Figure 1. Typically a patch is designed to generate and/or massage data in one or more of the supported input/output formats, including standard music notation (MusicXML), audio (WAV and AIFF), MIDI, and SDIF analysis files.  [ ![image](openmusic/01-om-patch.png) ](https://csoundjournal.com/openmusic/01-om-patch.png)

 **Figure 1. An OpenMusic Patch.**

Out of the box, OM includes more than fifty classes and close to two hundred functions for generating and processing music-related material. The system also supports extension libraries for adding new capabilities such as audio synthesis and digital signal processing.

A patch is made by selecting class and function objects from the patch window menus and dropping them into the patch window. Objects are then virtually wired together in the desired order of processing, ending typically by producing an output target in one or more of the file formats mentioned above.

With a large number of objects a patch can become visually and conceptually confusing. For the sake of clarity OM supports sub-patching, a process similar to Pure Data's "abstraction", in which a process is encapsulated into a patch embedded within the parent patch. When the parent is saved the sub-patch is saved along with it.

A patch may be an entity complete in itself, or it may be one of many objects in a maquette, OM's time-line sequencer. A maquette is a container into which various objects - OM patches, audio files, text, other maquettes - can be placed in order of performance. Objects can function alone or upon other objects in the maquette, revealing the maquette as both container and program. OM's structural hierarcy continues with a tool for higher-order arrangement called a Sheet to provides even more flexibility in the arrangement of musical materials and their potential communications. Alas, space forbids further discussion of these features, please consult the OM documentation for more information regarding patches, maquettes, and sheets.

OpenMusic's capabilities can also be significantly expanded with user-coded abstract functions and classes. Lisp code can be incorporated easily into a patch; in fact, all the power of Lisp is available directly in OM, with no need to recompile or link the new code; a powerful feature indeed.

Although OM provides basic playback facilities for its generated audio and MIDI data, it is not primarily an environment for audio synthesis or signal processing. However, thanks to its support for dynamically loadable extensions the system is flexible enough to accommodate such an environment. This article describes OM's accommodations for Csound. I have assumed that the reader is familiar with the basic use of Csound, whether at the command prompt or from a GUI. I have not provided a tutorial on using either Csound or OM, though some detailed description has been necessary. For more information on installing, configuring, and using OpenMusic please see the relevant materials listed in the Additional Resources at the end of this article.
## II. Csound with OpenMusic


Csound's integration with OM joins a formidable synthesis environment to a powerful system for music composition. With the appropriate libraries OM can be used as a unique integrated development environment for the creation and edition of Csound scores and instrument designs. In this article I have considered four libraries which have a relationship to Csound. One of the libraries, OM2Csound, is required by the other three. Thus, we begin our considerations with OM2Csound.
### OM2Csound


OM2Csound evolved from a Csound score generation library written by Laurent Pottier and Mikhail Malt for Patchwork, IRCAM's predecessor to OpenMusic. Karim Haddad ported the library to OpenMusic and added its Csound instrument design capabilities. OM2Csound provides the essential interface for OM's connection to Csound. This library includes functions for score generation, instrument design, and audio synthesis. It is also a required dependency for other OpenMusic extension libraries.

The current contents of the library can be viewed by opening the Library window and double-clicking in the bottom half of the suitcase icon labeled "om2csound" (double-clicking in the top half loads the library into an OM session). An adjacent display will open with two panels listing the classes and functions contained in the library. Figure 2 reveals that the OM2Csound library includes no new classes, but it adds more than thirty Csound-related functions.  ![image](openmusic/02-om2csound-library.png)

 **Figure 2. OM2Csound library contents**.

Given that Csound has hundreds of opcodes, the OM2Csound library represents only a small set of Csound's capabilities. However, as in all things Csound, much creative work can be accomplished with only a few resources. The following examples demonstrate the integration of the two systems, progressing from a simple arrangement to a considerably more complex network. Hopefully, the examples will also point towards the creative potential of the OpenMusic/Csound alliance.

Figure 3 shows a patch taken from the "OM2Csound tutorial 01". The patch demonstrates OM2Csound's simplest capabilities. Two `TEXTFILE` class boxes send data to a csound-synth object to generate a soundfile displayed in the `SOUND` box at the bottom of the patch. Both of the text boxes contain predefined data, i.e. a score and an instrument already written and formatted for processing by a Csound synthesizer. In this example only the `csound-synth` object is borrowed from the OM2Csound library. The other elements in the patch are core components of OpenMusic.  [ ![image](openmusic/03-om2csound-1st-tutorial.png) ](https://csoundjournal.com/openmusic/03-om2csound-1st-tutorial.png)

 **Figure 3. A simple OM2Csound patch.**

Each object in the network has a documentation file accessible by selecting the object and pressing the "d" key. The documentation for the `csound-synth` indicates the function of each visible and optional I/O port. In the patch itself a brief definition and default value pops up by positioning the mouse pointer on a port while holding the Control key.

The `csound-synth` object has two default and three optional input ports. In the example only the optional port for the output file name has been activated. The default inputs receive the Csound score and orchestra files. The object collects and processes the input data and finally generates the soundfile displayed in the `SOUND` box attached the synth's single output port.

In fact the example could be rendered more quickly at the command prompt, but that misses most of its purpose. The example demonstrates some fundamental aspects of OM - class boxes, functional objects, data entry, virtual wiring, data flow - that should be understood clearly before building a more complex patch.

Unfortunately, the screenshot does not show how objects in the patch can be evaluated individually. I can retrieve the value of an object's computation at any time, before or after my entire patch is completed, by holding the Ctrl key (Cmd key on Mac OSX) while left-clicking the output node of a function or class box. The momentary value will be displayed in the `Listener`, a very Lisp-ish and helpful feature.

The user can run the patch with custom Csound orc/sco files. In Figure 3 we see that each file box has a small "x" in its top left corner, indicating that the box is locked. Select the box and press the "b" key to unlock it. Press the "v" key to evaluate the box and summon a file dialog. Import the orc or sco file you want, then exit the dialog. The box will automatically re-lock itself, and the data is ready for transmission to the synthesizer. As long as the orc/sco files are valid, the synthesizer object will process them and render a correctly-formed soundfile. OM will normalize the file automatically if the option has been set in the "Preferences" dialog.

The next example is more complicated, with no predefined files to provide instrument and score definitions. Instead, networks of classes and functions process data to create a Csound score file (sco), its instrument (orc), and the soundfile rendered by compiling those orc/sco files. More of the power of OM2Csound is brought into play here, so we will look at this patch in some detail.

The score generator is built from two function table generators and a note-event factory. The tables store functions used for the instrument's oscillator and envelope. The factory begins with a `pulsemaker` object - an OM rhythm-tree function - and a `triang-seq` object borrowed from the OM-Alea library. The `pulsemaker` creates a pattern from three arrays representing beats per measure, the units receiving the bpm (eighth-note, quarter-note, etc), and the number of pulses per measure. Meanwhile, the `triang-seq` object randomly selects numbers between the default values of 4800 minimum and 8400 maximum, one hundred times in a triangular distribution. OM represents pitch in midicents (midic) values, where midic == midiNoteNumber * 100. Thus a MIDI note number of 48 becomes 4800 midic. The supplementary digits - the 00 in 4800 - provide support for microtonal specification.

The two generators send their data to the appropriate input ports of a `VOICE` class box. The `VOICE` class blends the pitches and rhythms, presents the results in standard music notation, shown in Figure 4, and makes its data available for export to MIDI, MusicXML, Finale ETF, and other output formats. Alas, the Csound score format is not an export target. The data requires further treatment, so the `VOICE` class box sends a copy of itself to the first input of a `CHORD-SEQ` box. The `CHORD-SEQ `formats the received data for processing by the `make-obj-snd` function which then sends the processed output to the `write-csound-score` object. The tables and note-events are formatted into a Csound score and sent to a `TEXTFILE` box and a `csound-synth` object.   [ ![image](openmusic/04-om2csound-orc-sco.png) ](https://csoundjournal.com/openmusic/04-om2csound-orc-sco.png)

 **Figure 4. A complex OM2Csound patch.**

The orchestra network starts with a `header `object and a subpatch containing a simple Csound instrument definition. The subpatch is exposed in Figure 4, at the right of the orchestra network. The `write-csound-orc` object receives data from the header and subpatch, formats it for a Csound orc file, and sends the formatted date to a `TEXTFILE` box and the `csound-synth` object.

At last, our data arrives at its final destination. The `csound-synth` object receives and organizes the output from `write-csound-orc` and `write-csound-sco` gives a user-specified name to the output, and sends it all to a `SOUND` box for display and playback.

This detailed description lacks not only the immediate visual clarification of the patch itself, it also misses the presence of the many points at which new functions can be interpolated into the patch or new values entered for varying the output. OM patches are designed for experimentation - in fact, the patches shown here have been assembled from various OM tutorials, copying and pasting individual items or whole sections between patches, freely editing things to fit the users preference. As in all good music software, the OpenMusic UI invites particpation and experimentation.
## III. Beyond OM2Csound


Csound's powers are employed by other specialized libraries for OpenMusic. I have selected three to profile for this article: OMChroma, OMPrisma, and Chant-lib. These extensions require the OM2Csound library, and by that dependencey it requires Csound as well. Each library has its own relationship to Csound, and each provides deeper access to Csound's capabilities, presenting composers with unique concepts and tools for the greater integration of synthesis, composition, and performance.
### OMChroma


OMChroma is the latest manifestation in a series of programs developed by composer Marco Stroppa, beginning with subroutines in FORTRAN written for Music V. His original concept for this software includes the notion of "sound potential"; a regard for the compositional possibilities inherent to a given sound source. Thus OMChroma has been designed to provide a deep connection between synthesis and composition. The library was designed originally to control Csound and the Chant synthesis engine. The Chant support was eventually moved to the OMChant library, and OMChroma currently supports only Csound.

OMChroma brings more than thirty functions and almost sixty classes into OpenMusic. Functions include a variety of filters, transposition and stretching processors, special Lisp routines, and so forth. The additional classes include Csound-derived objects for synthesis methods (`FM`, `additive synthesis`, `FOF`, Karplus-Strong, et cetera), GEN table generation, and channelization to multi-speaker arrays.  [ ![image](openmusic/05-omchroma-cmj5.png) ](https://csoundjournal.com/openmusic/05-omchroma-cmj5.png)

 **Figure 5. An OMChroma patch.**

Figure 5 shows a simple patch inspired by an example from [[1]](https://csoundjournal.com/#ref1). An `ADD-1` box receives data for preparation in an additive synthesis network, the results of which are displayed in a `SOUND` box. The patch is trivial but it demonstrates some fundamental characteristics of OpenMusic. Values are multimodal, presented as presets, breakpoint functions, and products resulting from a number generator. A single `BPF` box provides separate data sets for event onset (e-del) and duration. The random number generator here is a simple construction, but far more complex systems can be devised with extension libraries such as OM-Alea and OM-Chaos. Great variety can be rendered with only a few changes to the available variables.   [ ![image](openmusic/06-omchroma-chordseq.png) ](https://csoundjournal.com/openmusic/06-omchroma-chordseq.png)

 **Figure 6. OMChroma MIDI -> soundfile.**

Figure 6 illustrates a conversion from an OpenMusic `CHORD-SEQ` box to a soundfile, with help from OMChroma. In Figure 6, the contents of `CHORD-SEQ` were created by importing a MIDI file. From the `CHORD-SEQ` a network of OpenMusic functions massage the data before feeding it to an `ADD-1` box, where it is processed for audio rendering by the synthesis object and displayed in a `SOUND` box.  [ ![image](openmusic/07-omchroma-cmj10.png) ](https://csoundjournal.com/openmusic/07-omchroma-cmj10.png)

 **Figure 7. An advanced OMChroma patch.**

These examples show some of the most basic uses of OMChroma. In Figure 7 we see an advanced example with more elements from OMChroma, including the `CR-MODEL` class and various related functions. The patch has been built from two patches in OMChroma, where the programmer explains their concepts in these quotes[[1]](https://csoundjournal.com/#ref1): "Chroma models are abstract data structures used as reservoirs of forms and parameters for sound synthesis. They are made of a time structure ... and a sequence of Vertical Pitch Structures (VPS) ... polymorphic structures ... [that] represent spectral material as abslolute, relative, or pivot-based symbolic pitches or frequencies, and are meant to bridge the gap between a symbolic melody- or harmony-oriented approach to composition and numeric, spectral materials."

Musicians familiar with spectral composition methods will recognize these and other design concepts in common with OMChroma. However, the library certainly has application beyond the designer's own creative domains, but this article is not intended to be a tutorial. Excellent documentation comes with the OMChroma package and can be read online[[2]](https://csoundjournal.com/#ref2). I also recommend the video of Marco Stroppa's presentation[[3]](https://csoundjournal.com/#ref3). The composer is an engaging speaker, and the musical examples are most persuasive.

OMChroma is still evolving. New releases will bring new functions and classes, and of course users can expand the software's capabilities with their own Csound-based classes. OMChroma is proprietary software available through an IRCAM Forumnet subscription. For more information see this article's Additional Resources, below, for a link to the OMChroma page at IRCAM.
### OMPrisma


The location and movement of sounds through acoustic space is a fascinating and complex study. If your Spanish language skills are up to the task I recommend reading "Musica y espacio: ciencia, tecnologia y estetica" (Basso, di Liscia, and Pampin. 2009) for a full introduction to the topic. If you have a multispeaker array you might also want to try OMPrisma.

The OMPrisma library provides tools for designing and displaying complex arrangements for the spatial projection of multiple sound sources through multispeaker audio systems. At the final stage Csound renders your design to a multichannel soundfile. Csound is capable of multichannel audio output in various formats up to hardware limits, making it the perfect engine for sending your sounds into space.

OMPrisma's features include a variety of tools for designing graphic displays for accurately tracking sound movement in 2D and 3D space. Figure 8 shows off a colorful set of displays that define trajectories of movement from one or more sound sources. The displays can be created by calculation, free-hand drawing, or by importing a graphics file with OM's `PICTURE` class and Jean Bresson's Pixels library. SDIF files containing audio descriptors or data recorded from remote sensors and control devices provide another source for trajectory data.  [ ![image](openmusic/08-omprisma-trajectories.png) ](https://csoundjournal.com/openmusic/08-omprisma-trajectories.png)

 **Figure 8. OMPrisma trajectory plots.**

On the rendering side, OMPrisma implements various panning methods, higher-order Ambisonics, Csound's `spat` opcode, the `BABO` reverberator, and the `ViMiC` virtual microphone control class. To adapt to different speaker configurations, OMPrisma scripts Csound instruments dynamically using user-defined opcodes (UDOs) and macros. Do not worry if the possibilities are a bit overwhelming. The well-written tutorials will provide an acquaintance with basic concepts, and practice will perfect your skills. Figure 9 is a screenshot of a patch that mixes classes from OMChroma and OMPrisma, thus involving spatial considerations at the synthesis level. The patch provides a comprehensible demonstration of the the effects of the spatialization classes on various Csound-based synthesis classes. The user can freely reconnect classes to the `chroma-prisma` function to test the multitude of combinations of the synthesis method, spatialization class, and speaker/panning setup.  [ ![image](openmusic/09-omchroma-omprisma-merge.png) ](https://csoundjournal.com/openmusic/09-omchroma-omprisma-merge.png)

 **Figure 9. OMChroma + OMPrisma.**

OMPrisma is developed primarily by Marlon Schumacher in collaboration with McGill/CIRMMT. A development version is freely available from SourceForge, while a stable public version is available through IRCAM's forum subscription. Both versions require OM2Csound and some tutorial examples also require OMChroma.
### Chant-lib


Chant-lib is a freely available replacement for IRCAM's well-known CHANT software. Originally designed for synthesis of a singing voice, CHANT has become a general-purpose synthesis environment. IRCAM's OM-Chant external library adds CHANT's capabilities to OpenMusic, but its synthesis engine is proprietary and unavailable for Linux. Chant-lib corrects that omission by providing an implementation of the CHANT synthesis method powered by Csound, again by way of the OM2Csound library.  [ ![image](openmusic/10-om-chantlib.png) ](https://csoundjournal.com/openmusic/10-om-chantlib.png)

 **Figure 10. A chant-lib patch.**

The details of CHANT synthesis and the use of chant-lib are beyond the scope of the present article. CHANT synthesis is well-documented, see especially [[4]](https://csoundjournal.com/#ref4) for an in-depth presentation. If the method is new to you I suggest reading the cited article. Chant-lib's documentation is available as an on-line manual and as function help in OpenMusic, but you will need a reading knowledge of French or access to an on-line translator. Fortunately the help provides many instructive examples, and once OM2Csound is loaded you can work with chant-lib without another thought for Csound. Csound performs only the final FOF synthesis routines, otherwise its presence is completely transparent. Figure 10 illustrates an example of chant-lib's `CHANT` class working in tandem with a fractal numbers generator from the OM-Chaos library. The example is a relatively simple patch, but again users can freely combine classes and functions from other libraries - including OMChroma and OMPrisma - to create complex patches with chant-lib.

Chant-lib was developed by Romain Michon at the Université of Saint Etienne in France. The current version is available from CCRMA at Stanford University (see the Additional Resources below).
## IV. Of Related Interest


Though not specifically Csound-oriented, IRCAM's OM-SuperVP and OM-pm2 libraries offer access to the institute's phase vocoder and additive synthesis capabilities. Hans Tutschku's OM-ASX generates parameter files usable directly with the SuperVP and pm2 engines, extending OpenMusic into the signal processing domain of IRCAM's AudioSculpt. See the documentation for the original OM-AS (sic) library for numerous examples in OpenMusic, along with command strings for using SuperVP and pm2 at the terminal prompt.

The SDIF file format provides another common channel for OpenMusic and Csound. OpenMusic requires IRCAM's libSDIF for a wide variety of read/write functions on SDIF files. Csound provides no integrated support, but its hetro utility will produce SDIF files readable by OpenMusic's `SDIFFILE` class. Conversely, SDIF files produced in OpenMusic can be used by Csound's `adsyn` and `Loris` opcodes.

OM-ASX and libSDIF are freely available. OM-SuperVP and OM-pm2 are available through the IRCAM Forumnet subscription.
### Documentation and The OM Book Series


Copious documentation exists for OM in a user's manual, on-line tutorials, and example patches. Tutorial videos are available from IRCAM and 3rd-party producers. Numerous articles and reports have been published by the OM developers - see the link below to Jean Bresson's repmus page - and the OM Book series currently includes three volumes dedicated to describing the use of OpenMusic in real-world music composition, often referring to Csound as a final stage audio synthesis target. IRCAM's Forumnet provides another connection node for developers and users. The OpenMusic forum is an active and helpful group, recommended for users at all levels.
## V. Into The Future


Csound has a long history of deployment at IRCAM. The list of notable users includes composers Hubert Howe, Tristan Murail, James Tenney, Jean-Claude Rissett, and many others. Despite the evident popularity of Max/MSP, Csound remains the most powerful and cost-effective general-purpose audio synthesis environment. Its development proceeds forward at a steady pace, thanks to its team of talented and dedicated programmers. As long as it evolves I suspect that IRCAM's musicians and researchers will continue to use Csound frequently and for various remarkable purposes.
## Acknowledgements


Grateful thanks to Anders Vinjar, Jean Bresson, Marlon Schumacher, and Marco Stroppa for their assistance during my research for this article. I also thank the community of Csound users and developers for their help and for their dedication to the evolution of the Csound environment.
## References


[[1]]Carlos Agon, Jean Bresson, and Marco Stroppa. "OMChroma: Compositional Control of Sound Synthesis." *Computer Music Journal*, 35(2):67-83, 2011.

[[2]]Luca Richelli, Nov. 25, 2013. "OMChroma User Manual," [Online] Available: [http://support.ircam.fr/docs/om-libraries/omchroma/co/OMChroma.html/ ](http://support.ircam.fr/docs/om-libraries/omchroma/co/OMChroma.html). [Accessed September 28, 2014].

[[3]]Marco Stroppa, "The compositional control of sound synthesis: From Traiettoria to OMChroma," [Online] Available: [http://www.youtube.com/watch?v=6B4CsSwAyqE](http://www.youtube.com/watch?v=6B4CsSwAyqE). [Accessed September 28, 2014].

[[4]] Xavier Rodet, Yves Potard, and Jean-Baptiste Barrière. "The CHANT Project: From the Synthesis of the Singing Voice to Synthesis in General." *Computer Music Journal*, 8(3):15-31, 1984.
## Additional Resources


Carlos Agon, Gérard Assayag, and Jean Bresson. "Open Music." [Online] Available: [http://repmus.ircam.fr/openmusic/home](http://repmus.ircam.fr/openmusic/home). [Accessed September 30, 2014].

Anders Vinjar. "OM Linux." [Online] Available: [http://repmus.ircam.fr/openmusic/linux](http://repmus.ircam.fr/openmusic/linux). [Accessed September 30, 2014].

Arshia Cont, Karim Haddad, et. al. "Forumnet: OpenMusic Libraries." [Online] Available: [http://forumnet.ircam.fr/product/openmusic-libraries/](http://forumnet.ircam.fr/product/openmusic-libraries/). [Accessed October 1, 2014].

Karim Haddad, Mikhail Malt, Laurent Pottier, and Jean Bresson. "Open Music Libraries: OM2Csound." [Online] Available: [http://support.ircam.fr/docs/om-libraries/main/co/OM2Csound.html](http://support.ircam.fr/docs/om-libraries/main/co/OM2Csound.html). [Accessed October 1, 2014].

Carlos Agon, Jean Bresson, and Marco Stroppa. "OMChroma: High-level Control Structures for Sound Synthesis." [Online] Available: [http://repmus.ircam.fr/cao/omchroma](http://repmus.ircam.fr/cao/omchroma). [Accessed October 1, 2014].

Marlon Schumacher. "OMPrisma." [Online] Available: [http://sourceforge.net/projects/omprisma/](http://sourceforge.net/projects/omprisma/). [Accessed October 1, 2014].

Romain Michon. "The Chant-lib Library." [Online] Available:[ https://ccrma.stanford.edu/~rmichon/chantLib/](https://ccrma.stanford.edu/~rmichon/chantLib/). [Accessed October 1, 2014]. [](http://sourceforge.net/projects/omprisma/)

Jean Bresson. "Jean Bresson." [Online] Available: [http://repmus.ircam.fr/bresson](http://repmus.ircam.fr/bresson). [Accessed October 1, 2014]. [](https://ccrma.stanford.edu/~rmichon/chantLib/)

Carlos Agon, Jean Bresson, and Marco Stroppa. "The OM Composer's Book." [Online] Available: [http://repmus.ircam.fr/openmusic/ombook](http://repmus.ircam.fr/openmusic/ombook). [Accessed October 1, 2014].

[](http://repmus.ircam.fr/openmusic/ombook) Ircam. "Éditions." [Online] Available: [http://www.ircam.fr/598.html](http://www.ircam.fr/598.html). [Accessed October 1, 2014].
##
