---
source: Csound Journal
issue: 10
title: "Composing With Csound In AVSynthesis"
author: "direct value or by range"
url: https://csoundjournal.com/issue10/avs-cs-composition.html
---

# Composing With Csound In AVSynthesis

**Author:** direct value or by range
**Issue:** 10
**Source:** [Csound Journal](https://csoundjournal.com/issue10/avs-cs-composition.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 10](https://csoundjournal.com/index.html)
## Composing With Csound In AVSynthesis
 Dave Phillips
 dave AT linux-sound DOT org
## Introduction
 Jean-Pierre Lemoine's [AVSynthesis](http://docs.google.com/View?docid=dfq5sj5w_80f9z8tb) combines the graphics processing power of OpenGL with the audio synthesis and processing capabilities of Csound to create fantastic audio/visual animations. This article focuses on AVSynthesis solely as an environment for composing with Csound.
##
 I. Preliminaries

 For details regarding the requirements, installation, and configuration of AVSynthesis I refer readers to the program's web site. However, AVSynthesis has specific requirements for Csound that must be described here.

 AVSynthesis needs Csound 5.09 compiled with support for the Java interface (AVSynthesis employs the [JOGL](https://jogl.dev.java.net/) software for its OpenGL operations) and double-precision sample resolution. For my Linux builds of Csound I run the *SCons* build manager with the following options :
```csound

    useDouble=1 install=1 buildInterfaces=1 buildJavaWrapper=1
    dynamicCsoundLibrary=1 buildPythonOpcodes=1

```


 I add the Word64=1 option when building for my 64-bit system. Although AVSynthesis does not need the Python opcodes, I do add them for use with Steven Yi's [blue](http://csounds.com/stevenyi/).

 This article assumes AVSynthesis version 23_5_09 running on a Linux machine, but the program also runs on Windows XP and Vista systems. Windows users will need the appropriate packages for their system; please see the AVSynthesis Web pages for further details.
### Setting Up AVSynthesis For Csound


 AVSynthesis passes its performance options to Csound through the data/config.xml file. That file sets up Csound with its familiar command-line options, as seen in this example :
```csound

   config csound="-+rtmidi=alsa -Mhw:1,0
                  -+rtaudio=jack
                  -d -m0 -g -f
                  -odac:system:playback_
                  -iadc:system:capture_
                  --expression-opt
                  temp.orc temp.sco"
          ksmps="64"
          width="1280" height="1024"
          fullscreen="true"
          linux="true"
          fontSize="14"
          videoWidth="640" videoHeight="480"
          FPS="30" FPSRecorder="30"
          OSCHost="localhost"
          OSCPort="7770"
          MIDICtrl="85"

```


 In the first section of that configuration, Csound is set up for realtime audio I/O through the JACK server (with autoconnection) and for realtime MIDI via an ALSA device. The --expression-opt term optimizes Csound expressions for the compiler, resulting in improved realtime audio performance. The ksmps value is likewise an important factor for audio I/O, it must be evenly divisible into JACK's frame rate (e.g. 128 or 256). The MIDICtrl value determines which MIDI continuous controller will be the base for the layer master volume. In the example, controller 85 is designated to affect layer 1. Layer 2 will use controller 86, layer 3 will use controller 87, and so on. Note that the -+rtmidi option must be correctly defined in order to activate the AVSynthesis MIDI control functions.

 The OSC options are not specific to Csound, but OSC control via Csound is possible.

 Two buttons are located at the right end of each layer in the AVSynthesis Performance display, both active by default. Unselect the top button to configure the program for audio-only performance. No visuals will be displayed, but the audio output will play in the usual manner.
### Synthesizers And Processors


 AVSynthesis includes ten synthesizers and fourteen processing modules, all pre-built from Csound unit generators. These components are described fully on the AVSynthesis Web pages, and their synthesis methods will be familiar to most Csound users. FM, subtractive synthesis, wavetable synthesis, plucked-string, and noise generators are included, along with some less familiar generators such as the Vosim, WaveCycle, and AudioLoop modules. The AVSynthesis processing modules are similarly pre-constructed and include familiar effects such as chorus, phaser, and ring modulation as well as some unique processors built from Csound's pvoc and spectral opcodes. Two filter modules (Moog and state variable) round out the program's processing collection.

 Each synthesizer and processing module is represented in a GUI with sliders and switches. Sliders set parameter values, switches determine the parameter control source. Parameter values can be determined by direct value or by range. When a range is set further control is possible with OSC or MIDI. Additionally, each range is assigned one of the eight envelopes from the AVSynthesis envelope page. Each envelope can have a unique shape and a timeframe for its application (i.e. a simple 3-stage envelope for 20 seconds). As we shall see, AVSynthesis provides some interesting flexibility with regards to time.
### The AVSynthesis Sequencer


 AVSynthesis divides audio event production into two separate pages, one for sequencing pitch values and one for sequencing amplitudes.

 Pitch values are determined and controlled by a 12-step monophonic/4-step polyphonic sequencer. Parameters include the base pitch (key-note), the step pitch, an added random value (optional), and the sequencer mode (mono/poly). The amplitude sequencer works in similar fashion, and the parameters of both sequencers are subject to control by MIDI, OSC, or predefined envelope.
### The Audio Mixer


 The audio mixer page provides level controls for each synthesizer used in a layer. A separate slider sets the dry/wet balance for the effects. Two other controls set the track reverb type and amount, and an RMS adjustment slider rounds out the controls on this page. Only the dry/wet balance is subject to a controller (envelope, MIDI, or OSC).
## II. Composing With Csound In AVSynthesis



 Composition in AVSynthesis includes these stages :
-  Synthesizer selection and definition (Synthesizer page)
-  Sequencer configuration (Pitch and amplitude sequencer pages)
-  Audio output settings (Audio mixer page)
-  Tracks layout and balancing (Performance page)
-  Rendering to WAV (Render button)

 In this order sound design has been placed first, but of course the user is free to begin where he or she prefers. I prefer to design my sounds first, but in the course of that work I also start to design the audio event production.

 Stages 1 and 2 work in tandem. In order to test the synthesis method some sequence needs to be written (or you can leave the sequencer at its defaults). Step 3 balances the active instruments and effects with a track, and each track and each instrument within a track has its own audition button for easy testing at any point in your composition and/or instrument design.

 Stage 4 is the major mixing step. The AVSynthesis Performance window can be used as a rudimentary track mixer with hard-coded cross-fades and with global controls for volume and reverb levels. Tracks can be muted, but there is no solo switch. AVSynthesis is not a realtime interactive system, so plan on switching between screens frequently.

 Stage 5 runs AVSynthesis in render mode. During this mode the entire performance is rendered to TGA images (if graphics are enabled), a WAV audio file, and a standard Csound CSD file. From this point the user can create an animation with the sound and graphics files. This process requires external software: see the program documentation for details regarding animation production.

 AVSynthesis has only a few large-scale editing amenities. Layers can be copied to a clipboard, and performances can be copied to the next available empty performance slot. Alas, parameter and control data can not be copied from one location to another, but each performance is saved in the data/save directory as pNN.xml (where N equals a digit from 0 to 9). This file can be edited off-line with any text editor and will include any and all edits when invoked after re-opening AVSynthesis.
### The Composition Of *Ascensio Nudae Beatae*


 [*Ascensio Nudae Beatae* (5MB MP3)](https://csoundjournal.com/avs/ascensio_nudae_beatae.mp3) is a short piece (~4 minutes) composed of seven layers in AVSynthesis (Figure 1). Some layers are reserved for only graphics or sound, other layers combine the two facets. The following breakdown indicates what each layer does for the performance :
-  Layer 1 graphics & sound
-  Layer 2 graphics & sound
-  Layer 3 graphics
-  Layer 4 graphics
-  Layer 5 sound
-  Layer 6 graphics & sound
-  Layer 7 graphics & sound

 Figure 1 illustrates the coordination of the layers/tracks in the Performance display. I will return to that display later, but first I will describe the configuration of the audio generators and effects processors used in the piece.

[![image](images/1-ascensio-perf.png)](https://csoundjournal.com/images/1-ascensio-perf.png)

Figure 1: The AVSynthesis Performance screen (click to enlarge)

 The top two layers are related. The second layer is a copy of the first, with various alterations to both graphics and sound processing. Both layers use the same instrument (CycleWave) and effects processing (PVSBlur). Figure 2 shows off the control panel for the CycleWave synthesizer in Layer 1, Figure 3 displays the PvsBlur processor. The synthesis and effects parameters were determined by repeatedly listening to various settings. The AVSynthesis audition controls were very helpful at this stage, complementing my empirical approach to sound creation, and I quickly decided on the optimal settings for those layers.

[![image](images/2-ascensio-layer1-synth.png)](https://csoundjournal.com/images/2-ascensio-layer1-synth.png)

Figure 2: The CycleWave control panel (click to enlarge)

[![image](images/3-ascensio-layer1-fx.png)](https://csoundjournal.com/images/3-ascensio-layer1-fx.png)

Figure 3: Controls for PvsBlur (click to enlarge)

 Layers 3 and 4 are graphics-only tracks accompanied by the audio-only Layer 5. Layer 5's configuration includes two audio generators (Analog and Vosim synthesizers) and one effects processing module (SpectralArp, a spectral arpeggiator). Again, I arrived at the final settings for this section by repeatedly testing various values for each parameter.

 As Figure 1 shows, Layers 6 and 7 supply bridge material to connect the main sections. Both layers use the Pluck generator, but Layer 6 employs the SpectralDrone processor while Layer 7 utilizes the PvsSmooth effect.

 At the macro-level the composition is organized into three sections with these divisions :
-  Section I -- Layers 1 and 2
-  Bridge 1 -- Layers 6 and 7
-  Section II -- Layers 3, 4, and 5
-  Bridge 2 -- Layers 1, 6 and 7
-  Section III -- Layers 2, 4, and 5

 Sequencer configuration varies for each audio-enabled layer. To illustrate each layer's settings would take too much space, but Figure 4 is indicative. That screenshot (Figure 4) shows off the blend of deterministic and random elements used for the pitch factors in Layer 1. The other layers are similarly designed, with more or less determinism or randomization as the music required, and the pitch collections are intended to create tonal references. Some layers create chords, others produce single lines from the indicated pitch selections and ranges. Finally, the tempo of the sequenced events varies between layers (the Master clock was not used in this piece).

[![image](images/4-ascensio-layer1-sequencer.png)](https://csoundjournal.com/images/4-ascensio-layer1-sequencer.png)

Figure 4: The AVSynthesis Sequencer page (click to enlarge)

 Final balances were set in the Audio Mixer page. Each generator has its own amplitude control and each layer includes a control for the combined generators. Global amplitude and reverberation levels were set in the Performance screen.

 A few more words regarding the Performance screen: layers can be separated or overlapped in time, with cross-fades strictly defined by the fixed timeline (10 seconds in either direction). Canon-like structures are simple to set up, but of course the layers can be arranged freely anywhere within the timeline. Output levels for global amplitude and reverb can also be controlled from the Performance screen.
### The Wish-list


 AVSynthesis is already a very powerful program, but of course there is always room for improvement. A cut/copy/paste mechanism within the application would be helpful, realtime track solo/mute would be a wonderful addition, and I would like to see the sequencer and synthesizer sections organized into a standalone Csound composer. I love the program as it is, but I suspect its appeal would be broadened if it provided an environment without the graphics requirements.
## Credits and Acknowledgments



 Special thanks go to Steven Yi. Many previous releases of AVSynthesis suffered from a disastrous bug under Linux that caused unpredictable crashes and forced me to save my work after every change I made. Steven found and fixed the problem, and AVSynthesis now runs with perfect stability. Thanks also to the entire Csound community, from whom I continue to learn so much, and especially to the developers who continue to enhance and extend Csound and its environment. Greatest thanks go to Jean-Pierre Lemoine for his on-going work with AVSynthesis and for his generosity towards its users.
###  Resources:

-  [*Ascensio Nudae Beatae*](https://csoundjournal.com/avs/ascensio_nudae_beatae.mp3)
-  [Csound CSD file for *Ascensio Beatae Nudae*](https://csoundjournal.com/avs/ascensio_beatae_nudae.csd)
-  [AVSynthesis Performance file for *Ascensio Beatae Nudae*](https://csoundjournal.com/avs/p43.xml)
