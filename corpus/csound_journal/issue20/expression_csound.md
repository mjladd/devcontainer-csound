---
source: Csound Journal
issue: 20
title: "Csound and Music Expression"
author: "implementing expressive features"
url: https://csoundjournal.com/issue20/expression_csound.html
---

# Csound and Music Expression

**Author:** implementing expressive features
**Issue:** 20
**Source:** [Csound Journal](https://csoundjournal.com/issue20/expression_csound.html)

---

CSOUND JOURNAL[](https://csoundjournal.com/../index.html) | [Issue 20](https://csoundjournal.com/index.html)
## Csound and Music Expression
 Jim Hearon
 j_hearon AT Hotmail.com
## Introduction


This article is about developing aspects of musical expression, utilizing a number of existing Csound opcodes. Csound has many features through opcodes which provide controls to manipulate the sound at a detailed level, allowing for expressive and dynamic music making. By implementing expressive features, the rendered audio can have qualities which evolve and change over time, in order to achieve a result which can help with the gestures of expression. Versions used for this article were Csound 6.03.1, Fedora 20, and *The Canonical Csound Reference Manual*, version 6.00.1, available online.
##  I. Music Expression



The general subject of musical expression is a large area for study and research because it also includes the psychological aspects of the listener's perception. De Poli had proposed the notion of "complete" and "partial" computation models for observing music expression [[1]](https://csoundjournal.com/#ref1), where the partial model is that which aims to only explain what can be explained by a robust set of rules such as the note level. Following that idea, the descriptions below, at the opcode level, provide guidelines and code for help with the gestures of musical expression.

In computer music, because there is often no common practice notation score, expression can include just about any aspect beyond the given pitches of a piece of music. Approaches to expression include aspects such as signal generation and modifiers, audio and MIDI control, and real-time features, all of which can all be controlled at a detailed level using Csound opcodes. Because the code often takes the place of the common practice score, expression in computer music can also be extended to include ideas of the elegance of code's expression, such as "expressions", macros, UDOs, and functions. These are just a few of the ways of achieving expression in the design of the code.

When working with code, compared to the live performer's neuro-muscular responses, the process is magnified, prolongated, and mathematically and scientifically calculated and adjusted to achieve the desired result. This is without the sense of touch, pressure, vibration, sound location, and level of intensity that the live performer feels and reacts to immediately. If expression in the music we are creating is our goal, then we want our code to represent, on some level, the same expressive quality that a live performer is able to instill in the music.
##  II. Csound Features and Opcodes


In one sense, the ability of computers, through audio applications, to recreate the broad range capable of human musical expression is an aspired goal. While sampling and realtime applications with human computing interfaces have helped solved the challenge of creating expression to a great extent, achieving expression or expressivity still remains arduous in many audio applications. The level of detail with which the user is able to manipulate sound in Csound is a tribute to the application's longevity and the willingness of opcode developers to continue to provide tools that are flexible under a wide range of conditions for producing computer music. With time and patience it is possible to develop musical gestures over which one has extensive control using Csound.

(The following references examples you can download for this article from the following link: [expression_exs.zip](https://csoundjournal.com/downloads/expression_exs.zip))

Envelopes provide help with expression in several important ways. Nuance or shaping the sound, by controlling the amplitude over time, is a primary function of envelopes. Because envelopes take place over time, they can also be used to create articulation expressiveness such as legato, portamento, staccato, sforzando, and more (see staccato_ex1.csd) . Oscillators can also be used as envelopes as well (see oscenvl_ex2.csd). Shown below is an oscillator as envelope expressed using Csound's function syntax[[2]](https://csoundjournal.com/#ref2).
```csound
out(oscili (oscili (p5,1/p3,2), cpsMIDInn(p4), 1))
```


For a legato sound, in the standard numeric score, a negative p3 value for duration implies a held note. The negative p3 field in the score may also be recognized by a conditional statement in the instrument to branch conditionally and apply envelopes. For example, this could use the *port* or *portk* opcodes in order to create portamento or glissando sounds, creating a drift or glide by a certain amount to an indicated target pitch (see legato_ex3.csd, and glide_ex4.csd). For a thorough description of tied notes, please see Steven Yi's article ["Exploring Tied Notes in Csound"](https://csoundjournal.com/../2005fall/tiedNotes.html), *Csound Journal*, Volume 1 Issue 1, Fall 2005.

Csound is a modular software synthesizer in that it contains specialized modules, opcodes, and a number of different variable types utilized as input and output variables for opcodes that can be used to control instruments. An understanding of Csound update rates (setup only, i-rate, k-rate, or a-rate) for variables, and how `ksmps` functions to set the number of samples in a control period for the resolution of the updates, are practical and helpful when crafting signals that may change over time [[3]](https://csoundjournal.com/#ref3). A number of opcodes show the maturity or evolution of the opcode's development to include more control, for example *port* and *portk*, *oscili* and *oscilikt*, and *jitter* and *jitter2*. (See oscilikt_ex5.csd).

Opcodes are often employed in various combinations to produce an output. If an opcode accepts arguments at different rates, it is called polymorphic [[4]](https://csoundjournal.com/#ref4). Primarily utilizing an opcode alone for sound generation, for lack of a better word, we might call "monousance". "Polyusance", for example would be, say applying a filter to the instrument, modulating the sound by a second instrument, or mixing the output with additional sounds, all of which can provide variation of the sound and also help with aspects of expression. See lfo_ex6.csd for summing or multiplication of signals.

In general, when an opcode has more input variables, of various types, it signifies a greater potential for expressivity. A very simple vibrato, for example, is achieved by employing a low frequency oscillator at a given amplitude, and summing that with a nominal frequency. The ability to have greater control over the vibrato for expressivity has resulted in a more intricate opcode, such as *vibrato* by Gabriel Maldanado. The syntax for *vibrato*, which is a key component in music expressivity, and available in the *Csound Manual*, is shown below.
```csound
 kout *vibrato* kAverageAmp, kAverageFreq, kRandAmountAmp, kRandAmountFreq,
  kAmpMinRate, kAmpMaxRate, kcpsMinRate, kcpsMaxRate, ifn [, iphs]
```


Most of the input variables are k-rate variables, and allow for changing the function of the vibrato over time. Amplitude and frequency components are all separated, and ordered by random, average, or minimum and maximum amounts. A brief look at two of the MYFLT variables from the opcode's source code for *vibrato* shown in ugab.c in Csound's source code, shows the non-trivial nature of the input variables `kRandAmountAmp` and `kRandAmountFreq`. The phase amplitude or frequency are summed with a beginning amplitude or frequency, and those are multiplied times a target amplitude or frequency, then the whole phrase is multiplied times a default random amplitude or frequency. These values are able to update based on the instrument's `ksmps` or control rate which helps provide the means for a very powerful and expressive vibrato.
```csound
RandAmountAmp = (p->num1amp + (MYFLT)p->phsAmpRate * p->dfdmaxAmp) *
*p->randAmountAmp
```

```csound
RandAmountFreq = (p->num1freq + (MYFLT)p->phsFreqRate * p->dfdmaxFreq) *
*p->randAmountFreq

```


Csound's FM instrument models and STK models also have a large number of input control variables, many of which are designed to simulate aspects of the physical nature of the sound. They easily allow for the implementation of expressivity. Shown below are the syntax from the *Csound Manual* for *wgflute* by John ffitch (after Perry Cook), and *STKFlute* by Michael Gogins (after Perry Cook). See more informatin on the STK opcodes, below.
```csound
ares *wgflute* kamp, kfreq, kjet, iatt, idetk, kngain, kvibf, kvamp, ifn
   [, iminfreq] [, ijetrf] [, iendrf]
```

```csound
asignal *STKFlute* ifrequency, iamplitude, [kjet, kv1[, knoise, kv2[, klfo,
   kv3[, klfodepth, kv4[, kbreath, kv5]]]]]
```

### Realtime and MIDI


The human performer's approach to expression in music can become an artful mix of the inner emotion, intuition, and impulses for the instantaneous outward creation of sound. Expression, by the performer, in realtime performance, is implemented as a neuro-muscular response and an interaction between the live performer and his or her instrument as the music is sounding. The feelings or urges of expression are combined with years of careful study and neuromuscular feedback to master the extent of expression possible on an instrument or voice. Playing a live instrument allows you to make a change instantaneously, and you can see, hear, feel, the result immediately. Murray-Browne et. al. have called this relationship between performer and instrument a "mapping", and state that it is the mapping which is performed [[5]](https://csoundjournal.com/#ref5).

Working with realtime properties for live performance, utilizing controllers, GUIs, and instruments, is a very strong method of achieving a human feel and expressivity when working with computer music. The ability of the performer to interact instantaneously with an instrument, making decisions which affect the musical outcome, involves a multitude of data, conditions, branches, and decisions, which can possibly be represented by many lines of code in attempting the same level of decision making in a computer music code-driven approach. The STK (Synthesis Toolkit) opcodes contain up to 8 k-rate controller pairs which consists of a controller number or `kc`, followed by a controller value, or `kv`. These parameters can be implemented with code such as a simple *line* opcode to change controller values over time, or they can also be assigned as MIDI controller messages, using for example the *outkc* opcode to send MIDI controller messages at the k-rate. See hevymetl_ex7.csd for an example which utilizes the controllers from the Virtual MIDI Keyboard in Csound.
### Tempo and Rhythm


Tempo and rhythmic analysis are often used to measure expressivity in performance and to differentiate between peformances. Words such as interpretation, groove, feel, stretch etc. are often used to describe tempo and rhythmic variance. On the code level, Csound has opcodes which allow for dynamic changes in tempo and rhythm as output values which can be utilized as control input values for sound producing opcodes. The *loopseg*, *loopsegp*, *looptseg*, and *loopxseg * opcodes generate control signals between two or more spcified points. The main differences are that *loopsegp* allows for changing phase at the k-rate, *looptseg* contains a k-rate trigger, and *loopxseg *employs exponential segments between points. See the metro_ex8.csd example for a metronome-like pulse in one instrument set against rhythmic variation in another instrument utilizing the *lpsholdp* opcode for envelope looping.
### An Alternative Instrument


As an alternative example of longevity and maturity in instrument building, consider the input variation available on the computer music instrument shown below. The input variables, many of which are envelopes, are from the *FM Violin* which as stated in CLM (Common Lisp Music) "...is the result of nearly 30 years of use in 3 or 4 very different environments"[[6]](https://csoundjournal.com/#ref6). This instrument was available on the Peter Samson Sambox at CCRMA during the 1980s. The extent of variation available in this instrument is not unlike when a human performer plays the violin, where various choices must be made, and random events occur, when producing the sound.
```csound

(fm-violin dur frequency amplitude :fm-index 1.0
   :amp-env '(0 0  25 1  75 1  100 0):periodic-vibrato-rate 5.0
   :random-vibrato-rate 16.0 :periodic-vibrato-amplitude 0.0025
   :random-vibrato-amplitude 0.005 :noise-amount 0.0
   :noise-freq 1000.0 :ind-noise-freq 10.0
   :ind-noise-amount 0.0 :amp-noise-freq 20.0 :amp-noise-amount 0.0
   :gliss-env '(0 0  100 0):glissando-amount 0.00
   :fm1-env '(0 1  25 .4  75 .6  100 0) :fm2-env '(0 1  25 .4  75 .6  100 0)
   :fm3-env '(0 1  25 .4  75 .6  100 0) :fm1-rat 1.0 :fm2-rat 3.0
   :fm3-rat 4.0 :fm1-index nil :fm2-index nil :fm3-index nil :base nil
   :frobber nil :reverb-amount 0.01 :index-type :violin :degree nil
   :distance 1.0 :degrees nil :no-waveshaping nil :denoise nil
   :denoise-dur .1 :denoise-amp .005)

```



## III. Opcode building


Extending Csound by building your own custom expressive opcode can be done as a plugin library or in the manner of a new unit generator. Building a plugin library can be accomplished by compiling your code and the required header with the Csound source code using CMake which will generate the plugin library, or compiling just your code and the required header to a shared library using a command line or an IDE, and linking the generated library to Csound via libcsound [[7]](https://csoundjournal.com/#ref7).

Unit generators, as well as other standard opcodes and various Engine and Top Level functions, are compiled as part of libcsound or libcsound64. These modules are listed as arrays which include among other aspects, their ins, outs, and rates in entry1.c under the Csound Engine source code folder. They are also listed as libcsound sources in CMakeLists.txt for compiling Csound using CMake.

If one designs an original expressive opcode, then creating a user-defined opcode helps as a guide or proof of concept for how the opcode should function. Creating a user-defined opcode helps with being able to view the inputs and outputs to the opcode clearly which will become part of the of OENTRY that defines the opcode when the code is compiled and built as a shared library to become a plugin opcode.
```csound

<CsoundSynthesizer>
<CsOptions>
csound -s -d -+rtaudio=ALSA -odevaudio -b1024 -B16384
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs  = 1

  opcode tremelo, k, kki
kintensity, krate, iwaveform   xin
kout lfo kintensity, krate, iwaveform
xout kout
  endop

  instr 1
asig poscil .5, p4, 1
outs asig, asig
  endin

  instr 2
kintensity = .3
krate = .9
iwaveform = 1
kval tremelo kintensity, krate, iwaveform
asig poscil kval, p4, 1
outs asig, asig
  endin
</CsInstruments>
<CsScore>
; sine wave.
f 1 0 32768 10 1
; Square Wave
f02     0       512     10      1   0   .3   0   .2    0  .14    0 .11
i1  0  2  300
i2  3  4  400
e
</CsScore>
</CsoundSynthesizer>
```


The C code for compiling and building the *tremelo* plugin opcode is located with the example files for this article. The code and UDO shown above, both utilize John ffitch's *lfo* opcode from schedule.c, available from the Csound source code, as a model to demonstrate building an opcode to utilize for expression. In this example the frequency modulation employing a low frequency oscillator is changed to amplitude modulation, creating the tremelo effect.
## IV. Conclusion


In this article, the usefulness of utilizing Csound for the creation of expressive musical gestures has been shown, with emphasis on descriptions at the opcode level. Opcode development in Csound has provided tools which are flexible under a wide range of conditions, and make it possible to develop musical gestures over which one has extensive control.
### Proposal


The following is a brief conceptual idea for smart instruments that are semaphore-like, global instruments which analyze, adapt, and change other instruments based on the acoustic environment and conditions. The concept includes aspects of existing approaches to computer music such as analysis, filtering, and mixing or summing, and also the use of existing opcodes in Csound which allow one to assign variables for input. Not unlike a filter with a feedback loop, the difference would be instead of affecting the sound as a filter does, the smart instrument would contain a plug or hook back to the original sound producing instrument and would send it data to notify it to change its variable values, affecting the way it is producing sound at a particular point in time. Thus smart instruments are a kind of watch dog instrument, monitoring thru analysis, and notifying instruments to adapt and change their behaviors. In terms of expression, monitoring for averages, and statistical variances above and below the norms at critical temporal and amplitude points could provide adjustments in say for example vibrato, envelope, tempo, timbre, etc. -- really everything beyond the basic frequency and content of the music. The inputs to the semaphore instrument might include various envelopes and instrument hooks, where there would be an envelope to analyze and send back data to the instruments on the state of vibrato, or global amplitudes for example. The semaphore instruments would function on a meta-level adding a kind of polishing or mastering to the music. Interestingly this is something most live performers are not able to do and they leave the overall sound to the sound engineer running the sound system. The difference here, is the semaphore instruments do not change the sound or level of expression, but notify the instruments to change their behavior. Many of the audio analysis features available in the MPEG-7 ISO standard might provide possible solutions for helping to analyze audio content[[8]](https://csoundjournal.com/#ref8).
## References


[][1] Giovanni De Poli, "Methodologies For Expressiveness Modeling Of And For Music Performance," in* Journal of New Music Research*, vol. 33, n.3, pp. 189-202, 2004. [Online] Available: [http://www.enactivenetwork.org/download.php?id=34](http://www.enactivenetwork.org/download.php?id=34). [Accessed June 13, 2014].

[][2] Barry Vercoe et al., 2005. "Function Syntax in Csound6." *The Canonical Csound Reference Manual, *Version 6.00.1. [Online] Available: [http://www.csounds.com/manual/html/functional.html](http://www.csounds.com/manual/html/functional.html). [Accessed June 12, 2014].

[][3] Barry Vercoe et al., 2005. "Types, Constants and Variables." *The Canonical Csound Reference Manual, *Version 6.00.1. [Online] Available: [http://www.csounds.com/manual/html/functional.html](http://www.csounds.com/manual/html/functional.html). [Accessed June 13, 2014].

[][4] Barry Vercoe et al., 2005. "Extending Csound." *The Canonical Csound Reference Manual, *Version 5.14. [Online] Available: [http://www.ecmc.rochester.edu/ecmc/docs/csound-manual-5.14/](http://www.ecmc.rochester.edu/ecmc/docs/csound-manual-5.14/). [Accessed June 13, 2014].

[][5] Tim Murray-Browne, et. al., 2011. "The medium is the message: Composing instruments and performing mappings." [Online] Available: [http://www.eecs.qmul.ac.uk/~nickbk/papers/murray-browne_nime_2011.pdf](http://www.eecs.qmul.ac.uk/~nickbk/papers/murray-browne_nime_2011.pdf). [Accessed June 14, 2014].

[][6] Bill Schottstaedt, "CLM." [Online] Available: [https://ccrma.stanford.edu/software/clm](https://ccrma.stanford.edu/software/clm)/. [Accessed June 14, 2014].

[][7] Victor Lazzarini, April 2, 2014. "Developing Plugin Opcodes." in *FLOSS Manuals Csound*, v. 5, 2014. [Online] Available: [http://en.flossmanuals.net/csound/extending-csound/](http://en.flossmanuals.net/csound/extending-csound/). [Accessed June 15, 2014].

[][8] Giovanni De Poli and Luca Mion, "From audio to content," in* Algorithms for Sound and Music Computing, for Computer Science class in Sound and Music Computing*, Chapter 5, 2006. [Online] Available: [http://www.dei.unipd.it/~musica/IM06/Dispense06/5_audio2content.pdf](http://www.dei.unipd.it/~musica/IM06/Dispense06/5_audio2content.pdf). [Accessed June 15, 2014].
