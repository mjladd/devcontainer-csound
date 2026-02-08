---
source: Csound Journal
issue: 7
title: "Csound at the Toronto Electroacoustic Symposium 2007"
author: "those in the Emerging Artist Residency who also worked with composers Barry Traux and Trevor Wishart"
url: https://csoundjournal.com/issue7/symposium.html
---

# Csound at the Toronto Electroacoustic Symposium 2007

**Author:** those in the Emerging Artist Residency who also worked with composers Barry Traux and Trevor Wishart
**Issue:** 7
**Source:** [Csound Journal](https://csoundjournal.com/issue7/symposium.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 7](https://csoundjournal.com/index.html)
## Csound at the Toronto Electroacoustic Symposium 2007
 Jim Hearon
 j_hearon AT hotmail.com
## Introduction


The Toronto Electroacoustic Symposium 2007 was held August 9 - 10, 2007 at the University of Toronto. The Symposium Committee included Chair, David Ogborn (Canadian Electroacoustic Community), Dennis Patrick (University of Toronto), and Nadene Thériault-Copeland (New Adventures in Sound Art). The Symposium took place preceding the Sound Travels festival summer program on Toronto Island. The whole Sound Travels event runs from July 1 - October 1, 2007. Sound Travels composers-in-residence Barry Truax and Trevor Wishart were keynote speakers for the Toronto Electroacoustic Symposium, and Kevin Austin, from Concordia University, Montreal, who wrote the charter for the Canadian Electroacoustic Community in 1984, also gave introductory remarks on the Discipline of Electroacoustics.
##  I. Symposium Overview


Soundscapes, sound diffusion, and sound installations played a large role in papers and music presented at the symposium. Csound was included in several interesting presentations. Hector Centeno's presentation *Open Source software and electroacoustic music creation: an overview and personal practices* utilized Csound as a sound generating application. David Ogborn's *Programming As Artistic Practice: The 'Allegory' and 'Analogy' Environments* also dealt with utilizing the Csound API, and Akito Van Troyer and Jim Hearon's *Aspects of Sahnsi and Polos in Balinese Gamelan Instruments* featured analysis of gamelan instruments and a Csound composition.

In addition to the many interesting papers and presentations at the two day Symposium, the Sound Travels concerts on Toronto Island which took place immediately after the Symposium featured live diffusion of up to twelve channels of works by those in the Emerging Artist Residency who also worked with composers Barry Traux and Trevor Wishart. In addition to several works by Traux and Wishart the concerts included a Toronto premiere of *Angel* by Trevor Wishart. There was also a live collaboration, *Bamboo, Silk and Stone* (1994), between Barry Traux and Randy Raine-Reusch. Raine-Reusch specializes in improvisation utilizing world instruments, particularly Asian instruments.

Other activities for symposium participants included a SOUNDwalk and a chance to play on outdoor sculptures on Toronto Island, as well as an Open-mic concert hosted by angelusnovus.net and InterAccess at the InterAccess Media Arts Centre in Toronto.  ![](images/Toronto.jpg) (Toronto skyline from Toronto Island)
##  II. More on Csound


The proceedings of the Symposium are slated to be published in *eContact!*, a magazine devoted to electroacoustic music in Canada and worldwide. See [http://cec.concordia.ca/econtact/](http://cec.concordia.ca/econtact/), for information on electroacoustic music and details of all papers and presentations at the Symposium.

Regarding more details on Csound, Hector Centeno's presentation *Open Source software and electroacoustic music creation: an overview and personal practices* featured Linux open source software, including Steven Yi's *Blue* as a frontend to Csound. In addition to *Blue*, Hector's open source software composing environment featured FLTK graphic widgets to control various parameters of Csound's streaming phase vocoder opcodes, and he utilized Jack patching controls with applications such as *Ardour* for multitracking. In addition to the paper outlining the many benefits of open source applications, *What Is It?*, a soundscape composition by Hector Centeno, utilizing spectral processing instruments programmed with Csound, was also performed on the Sound Travels series with live sound diffusion by the composer.  For composing his piece *What is it?* Hector developed a realtime, phase vocoder analysis/transformation/synthesis instrument using Csound, including a graphic interface (Figures 1 and 2) and utilized the possibility of controlling parameters via MIDI controller. The instrument consisted of a collection of chained processes that included almost all the PVS Csound opcodes. In this instrument there were three simultaneous streaming sources of sound: two PVOC-EX analysis files (identified in the GUI as "A" and "B") and one stereo audio file (identified as "soundscape"). The PVOC-EX files used were standard fixed-overlap frequency/amplitude analysis files, produced by Csound's external utility, Pvanal. The source material for all of the sources, in this particular piece, came from semi-binaural soundscape recordings.

 ![](images/Hector1.png) (Fig. 1. Hector Centeno GUI, main PVS transformation section)
 The playback section of the instrument functioned as follows: the two PVOC-EX files were triggered by a MIDI keyboard and continued streaming for as long as a key was held. The point in time where the analysis file was started depended on the position of the start time for the audio file. An audio file could be started and stopped by using the two buttons on the GUI and could be looped at normal speed. If the sound file was stopped, the PVOC files started streaming from the beginning again. The sound file being played could be chosen from four predefined options accessible through the numbered buttons in the "soundscape" control section of the GUI (Figure 2).

 The speed at which the two PVOC files were streamed was set by two independent sliders in the GUI labeled "speed A", and "speed B". This allowed for time stretching, compression, and change of direction. An envelope could also be applied to the files using the two sets of sliders labeled "time path A" and "time path B". These sliders can be understood as if they were interpolated points in a breakpoint graphic function where the Y-axis represents the position in the analysis file, and the X-axis the total duration of the file (after being scaled by the speed parameter). The envelope could be re-triggered at each key press of the MIDI keyboard.

 After the playback stage, the two PVOC streams passed through a series of 7 transformations:
 - Overrideable pitch shifting according to the MIDI note pressed and a user defined scale, using 3 different modes of formant processing (selectable through the GUI).
 - Variable gain.
 - Variable levels of frequency masking (filtering). These levels were set by a group of 50 sliders (available in the section accessible by clicking the "Mask1" tab) representing the total frequency spectrum divided in 50 bands.
 - Pitch modulation with variable depth and frequency.
 - Variable smoothing (analysis channels frequency/amplitude averaging).
 - Frequency and/or amplitude freezing.
 - Variable cross-synthesis between both A and B by applying the amplitudes of A to the frequencies of B.

 An envelope was applied to the cross-synthesis using the set of sliders named "cross AB envel" where the Y-axis represented PVOC stream A at the top, and stream B at the bottom. The X-axis represented the total duration of the envelope. The duration was determined by the "speed" knob in the middle of the gui. The envelope was also triggered with each MIDI key press and sustained using the setting of the last slider if the note was sustained longer than the total duration. Any point inbetween A and B was a different level of cross-synthesis between the two streams.

 After this chain of PVS processes, the resulting single PVOC stream (product of the cross-synthesis) was re-synthesized into an audio stream and then passed through a convolution processor, reverberation and a granular shuffler processor (Figure 2). This last unit received a stereo input and placed it into a delay line which was max delay in size. A delay line took in grains of various size from the random time positions from both channels utilizing a grain envelope determined by the envelope slider. The grains were spaced randomly using a value in the gap as the maximum gap size. The convolution section in the GUI allowed one to choose, in real-time, between five different impulse response files and also allowed the user to set the level of convolution. The reverb could be adjusted in its feedback amount, cut-off frequency, level of random delay variation, and amount of dry/wet mix. You can listen to *What is it?* by following this link: [http://ea.hcenteno.net/listen.html ](http://ea.hcenteno.net/listen.html ).

 ![](images/Hector2.png) (Fig. 2. Hector Centeno GUI, Reverb, shuffler and wave file playback functions)

 David Ogborn, of the CEC (Canadian electroacoustic Community), Chair and organizer of the symposium, presented a paper *Programming As Artistic Practice: The 'Allegory' and 'Analogy' Environments.* The sourceforge.net description of the *Allegory* project [http://sourceforge.net/projects/allegory/](http://sourceforge.net/projects/allegory/), defines the software as a tool for electronic music which consists of a small library of Haskell definitions that can be used to create, explore, and refine developmental/variation relationships between diverse sound materials. *Allegory* employs Csound as synthesis engine and utilizes the Csound API, as well as Libsndfile to create sounds as sound files, storing them to disk.

One of the interesting modules in *Allegory* is "Montage" which is a mini-language used to describe montages of sounds. There is a data type called "Montage" which represents an instruction in the "Montage" language, and there is also the function "montage" which takes a list of "Montage" instructions and returns the resulting sound.

   {-START-DOC
 <content title="module Montage">
 <p>The module Montage is an (unofficial) example of using the modules Allegory, Sndfile and Csound to create mini-language to describe montages of sounds, i.e. successions, crossfades, overlaps of some number of sounds. The resulting sound can have any number of channels, a parameter determined by the maximum number of channels in the "input" sounds.</p>
 END-DOC-}

 module Montage where

 import Allegory
 import Csound
 import Sndfile
 import Hugs.Quote
 import List

 {-START-DOC
 <p>From the "user's" standpoint, there are just two parts of the module that require attention. The first of these is the datetype Montage. Each 'Montage' represents an instruction in the Montage language. These instructions are the next element in the code, below. The second element to know is the function 'montage' which takes a list of Montage instructions and returns the resulting Sound (which can then be realized with the function 'make').</p>
 END-DOC-}

 data Montage = Sound FilePath |
 Crossfade Double |
 Overlap Double |
 OverlapCrossfade Double Double |
 InsertSilence Double |
 AlignLeft |
 AlignLeftPlus Double |
 MontageList [Montage] |
 Insert FilePath Double |
 SilenceThenFadeIn Double Double |
 ResetToZero |
 NoInstruction

 montage :: [Montage] -> Sound
 montage = (montageComposer) . (fst) . (foldl (montageInterpreter) ([],(0.0,0.0)))

   (data type "Montage" by David Ogborn)
 The following is an implementation of the data structure:

 {-START-DOC
 <p>The remaining code is simply implementation of the above. The module's compact definition and implementation is something of an indication of the advantages of the functional programming paradigm.</p>
 END-DOC-}

 type MontageElement = (FilePath,Double,Double,Double,Double)
 {- path to sound, starttime, duration, attack, release -}

 setRelease :: Double -> MontageElement -> MontageElement
 setRelease r (f,s,d,a,_) = (f,s,d,a,r)

 getStart :: MontageElement -> Double
 getStart (_,s,_,_,_) = s

 type MontageComposition = [MontageElement]

 setLastRelease :: Double -> MontageComposition -> MontageComposition
 setLastRelease r c = (init c) ++ [setRelease r (last c)]

v type MontageState = (MontageComposition,(Double,Double))
 {- composition, time pointer, attack -}

 montageInterpreter :: MontageState -> Montage -> MontageState
 montageInterpreter (c,(tp,a)) (Sound s) = (c ++ [(s,tp,sfDuration s,a,0.0)],
 (tp+(sfDuration s),0.0))
 montageInterpreter (c,(tp,a)) (Crossfade t) = (setLastRelease t c, (tp-t,t))
 montageInterpreter (c,(tp,a)) (Overlap t) = (c, (tp-t,a))
 montageInterpreter (c,(tp,a)) (OverlapCrossfade to tcf) = (setLastRelease tcf c,
 (tp-to-tcf,tcf))
 montageInterpreter (c,(tp,a)) (InsertSilence t) = (c, (tp+t,a))
 montageInterpreter (c,(tp,a)) (AlignLeft) = (c, (getStart (last c),a))
 montageInterpreter (c,(tp,a)) (AlignLeftPlus t) = (c, ((getStart (last c))+t,a))
 montageInterpreter state (MontageList xs) = foldl (montageInterpreter) state xs
 montageInterpreter (c,(tp,a)) (Insert s t) = (c ++ [(s,t,sfDuration s,0.0,0.0)], tp,a))
 montageInterpreter (c,(tp,a)) (SilenceThenFadeIn s t) = (c,(tp+s,t))
 montageInterpreter (c,(tp,a)) (ResetToZero) = (c,(0.0,0.0))
 montageInterpreter (c,(tp,a)) (NoInstruction) = (c,(tp,a))

 montageComposer :: MontageComposition -> Sound
 montageComposer x = csound ((standardHeader nchnls) ++ orchestra ++ score)
 where nchnls = sfChannels (g (x!!0))
 g (f,_,_,_,_) = f
 inputs = listOfBuffers "ain" nchnls
 soundin = stringOfBuffers inputs
 out = "outc " ++ (concat (intersperse "," [i++"*aenv"|i<-inputs]))
 score = "\n\n" ++ (concat [i s d f a r | (f,s,d,a,r) <- x]) ++ "</CsScore>\n</CsoundSynthesizer>\n"
 i s d f 0.0 0.0 = "i1 "++(show s)++" "++(show d)++" \""++f++"\" \n"
 i s d f a 0.0 = "i2 "++(show s)++" "++(show d)++" \""++f++"\" "++(show a)++"\n"
 i s d f 0.0 r = "i3 "++(show s)++" "++(show d)++" \""++f++"\" "++(show r)++"\n"
 i s d f a r = "i4 "++(show s)++" "++(show d)++" \""++f++"\" "++(show a)++" "++(show
 r)++"\n"
 orchestra = ``instr 1
 ; no fadein or fadeout
 aenv = 1.0
 $(soundin) soundin p4
 $(out)
 endin
 instr 2
 ; fadein only
 aedb linseg -120.0, p5, 0.0, p3-p5, -120.0
 aenv = ampdb(aedb)
 $(soundin) soundin p4
 $(out)
 endin
 instr 3
 ; fadeout only
 aedb linseg 0.0, p3-p5, 0.0, p5, -120.0
 aenv = ampdb(aedb)
 $(soundin) soundin p4
 $(out)
 endin
 instr 4
 ; fadein and fadeout
 aedb linseg -120.0, p5, 0.0, p3-p5-p6, 0.0, p6, -120.0
 aenv = ampdb(aedb)
 $(soundin) soundin p4
 $(out)
 endin
 </CsInstruments>''

 {-START-DOC
 </content>
 END-DOC-}  (*Allegory*, "Montage" example code by David Ogborn)

The sourceforge.net description of the *Analogy* project [http://sourceforge.net/projects/analogy](http://sourceforge.net/projects/analogy), describe this software as a scene-based environment for the creation and performance of live electronics pieces, using Csound patches, VST plugins and an assortment of native DSP and GUI elements. Thus while *Allegory* is for storing sound files to disc, *Analogy* if for use in realtime. It requires several external .dlls such as portmidi (pm_dll.dll), libxml2.dll, zlib1.dll, and iconv.dll, as well as csound32.dll. Since Haskell definitions are format sensitive, you can download the formatted example of David Ogborn's Haskell definition code here: [Montage.zip](https://csoundjournal.com/Montage.zip)

*Aspects of Sahnsi and Polos in Balinese Gamelan Instruments* was a paper by Akito Van Troyer and Jim Hearon which described a project to sample, analyze, and create a composition of computer music simulating the gamelan instruments Kemong, Kempli, Jegogan, Gong, Calung, Gangsa, and Reyong. Central to the project was analyzing pitch frequencies, and simulating the harmonic beating which takes place between the male and female of several instruments.

A Csound composition was played which employed spectral analysis data of gamelan instruments to synthesize the basic sound of the instruments using additive synthesis in Csound by summing instances of the oscili opcode. Pitch offsets were employed to simulate the harmonic beating of the gamelan instruments.

It was interesting in Van Troyer's compositional design that rhythms were generated as samples employing f-tables. Table 162, for example, which contains zeros and ones, is read by a phasor. When the phasor encounters a '1', a note is triggered. The speed of the phasor and the number of zeros between the ones determines a micro-rhythm which is repeated as one of the basic rhythmic cells during a formal section of the piece.  gitmap162 ftgen 162, 0, 32, -2, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0

 (example from Van Troyer's *Gamelan_Study1*)

The duration of formal sections, in which different instruments are sounding, or changing tempos, or amplitude over the duration of that section is determined by a hierarchical system of sequencing f-tables. In other words, f-tables call f-tables, which call f-tables which contain values. There are over 600 f-tables employed in the piece. Global control of the tempo of the formal sections of the piece is determined by the linseg opcode which sends terraced envelope step values to instruments which also contain phasors. The speed of the phasors in several instruments, each representing a different gamelan instrument, is controlled globally in that manner. Dynamics are also controlled globally through a k-rate value used as the amplitude input values for the oscili opcodes. You can download an mp3 of Van Troyer's *Gamelan_Study1* here: [Gamelan_Study1.zip](https://csoundjournal.com/Gamelan_Study1.zip)
## III. Conclusion


Csound is a very useful sound synthesis application, and is very practical as open source software. The spectral processing capability, compositional features of the algol-like orchestra and score language, and aspects of the API were much in evidence at the Toronto Electroacoustic Symposium 2007. ![](images/SoundTravels.jpg) (St. Andrews by the Lake Church, Toronto Island)
## Further Interest


THE AUDIOBOXTM sound diffusion system, [http://www.richmondsounddesign.com](http://www.richmondsounddesign.com)

Canadian Electroacoustic Community, [http://cec.concordia.ca.ca](http://cec.concordia.ca), for information on membership, publications and projects.

HaskellWiki. [http://www.haskell.org/haskellwiki/Definition](http://www.haskell.org/haskellwiki/Definition) (18 August 2007)

New Adventures in Sound Art, [http://www.naisa.ca](http://www.naisa.ca), for information on the Sound Travels Emerging Artist Residency and the Sound Travels Festival of Sound Art.

Remus, Bill. "Notes On Playing Gamelan Bali: Gong Kebyar Style". April 5, 1996. [ http://remus.shidler.hawaii.edu/gamelan/balinota.htm](http://remus.shidler.hawaii.edu/gamelan/balinota.htm) (1 August 2007)

Southworth, Christine N."Statistical Analysis of Tunings and Acoustical Beating Rates in Balinese Gamelans". June, 2001. [www.kotekan.com/thesis.html](http://www.kotekan.com/thesis.html) . (12 June 2007)

Traux, Barry. *Acoustic Communication*, 2nd. ed. Ablex Publishing, 88 Post Road West, Westport, CT 06881. 2001. [http://www.sfu.ca/~truax/ac.html](http://www.sfu.ca/~truax/ac.html)

Wishart, Trevor. *Audible Design: A Plain and Easy Introduction to Practical Sound Design*. York: Orpheus and Pantomime Ltd. 1994.

Wishart, Trevor. *On Sonic Art*--New and Rev. ed. -- (Contemporary music studies; V. 12). Overseas Publishers Association, Emmaplein 5, 1075 AW Amsterdam, The Netherlands. 1996.
