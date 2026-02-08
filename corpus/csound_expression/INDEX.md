# csound-expression Tutorials - Corpus Index

**Source:** https://github.com/spell-music/csound-expression
**Fetched:** 2026-01-06
**Total Tutorials:** 32
**Categories:** 7

## About

csound-expression is a Haskell library that provides a high-level interface
to Csound. While the code examples are in Haskell, the tutorials contain
excellent explanations of synthesis concepts, signal processing, and
sound design principles that apply to Csound programming in general.

## Why This is Valuable

- Clear explanations of synthesis techniques
- Well-structured approach to sound design
- Covers oscillators, envelopes, filters, effects
- Explains signal flow and modulation
- Good examples of combining techniques

## Concepts Covered

adsr, delay, distortion, echo, envelope, fft, filter, frequency, granular, lfo, midi, modulation, noise, note, osc, oscillator, random, reverb, sample, sampler, spectral, spectrum, subtractive

## Tutorials by Category

### Effects (11 tutorials)

- [02-play-notes](effects/02-play-notes.md) - In Csound we can trigger instruments with notes. A note has three components:
- [BasicTypesTutorial](effects/BasicTypesTutorial.md) - What is the size of the table? We can create the table of the given size. By default it's 8196. The more size the better is precision. For efficiency reason the tables size in most cases should be equ
- [CsoundAPI](effects/CsoundAPI.md) - With channel we can update specific value inside Csound code. We can create a global channel and then send write or read values with another program.
- [EventsTutorial](effects/EventsTutorial.md) - Event stream is a `Monoid`. The `mempty` is an event stream that has no events and `mappend` combines to event streams into a single event stream that contains events from both streams. Reminder: `mco
- [FxFamily](effects/FxFamily.md)
- [LiveWidgetsTutorial](effects/LiveWidgetsTutorial.md)
- [Patches](effects/Patches.md) - The Gen-prefix for instruments and effects refers to one peculiarity of the Patch data type. I'd like to be able to change some common parameters of the instrument after it's already constructed. Righ
- [ProducingTheOutputTutorial](effects/ProducingTheOutputTutorial.md)
- [Quickstart-guide](effects/Quickstart-guide.md)
- [ScoresTutorial](effects/ScoresTutorial.md) - Let's start with primitive functions:
- [SignalSegmentsTutorial](effects/SignalSegmentsTutorial.md) - Let's create a mini mix board for a DJ. The first thing we need is a cool dance drone:

### Events and Scores (1 tutorials)

- [Arrays](events_and_scores/Arrays.md) - Arrays can be global and local. Local arrays are accessible only within the body of single Csound instrument where they are created. The scope translated to Haskell is somewhat obscure. The global arr

### General (5 tutorials)

- [01-play-file](general/01-play-file.md) - The most simple way to play a file is to use `diskin` function:
- [CabbageTutorial](general/CabbageTutorial.md)
- [ImperativeInstruments](general/ImperativeInstruments.md) - There is a special opaque data type for instrument names (or references). It's called `InstrRef`:
- [Tuning](general/Tuning.md)
- [UpcomingReleaseNotes](general/UpcomingReleaseNotes.md)

### Introduction (2 tutorials)

- [00-Intro](introduction/00-Intro.md) - We are going to work with library `csound-core` and compiler `csound`. The Csound is an audio programming language. It's super powerful and great for our needs. It is a language and compiler.  The com
- [Intro](introduction/Intro.md) - ~~~ > cabal update > cabal install csound-expression --lib ~~~

### Sampling (1 tutorials)

- [SamplesTutorial](sampling/SamplesTutorial.md)

### Signal Processing (1 tutorials)

- [Spectrums](signal_processing/Spectrums.md)

### Synthesis (11 tutorials)

- [GranularSynthesisTutorial](synthesis/GranularSynthesisTutorial.md)
- [Index](synthesis/Index.md)
- [InstrumentsShowCase](synthesis/InstrumentsShowCase.md)
- [Library-overview](synthesis/Library-overview.md) - ~~~ double :: Double -> D int    :: Int    -> D text   :: String -> Str sig    :: D -> Sig ~~~
- [ModArg](synthesis/ModArg.md) - Sometimes we want the modulation to start aftter some initial delay. Take the vibrato for instance. Often there s no vibrato at the attack and then it starts to rise. We can simulate it with the funct
- [Padsynth](synthesis/Padsynth.md) - There are versions of standard audio waves: pure sine, triangle, square, sawtooth that are enriched by padsynth algorithm. They have the same prefix `bw`:
- [README](synthesis/README.md)
- [SignalTfm](synthesis/SignalTfm.md) - By default `newRef` or `newGlobalRef` create placeholders for audio-rate signals. But if we want them to hold control-rate signals we have to use special variants:
- [SoundFontsTutorial](synthesis/SoundFontsTutorial.md) - We can read soundfonts that are encoded in sf2 format. The function `sfMsg` can turn sound font file in midi instrument:
- [SynthTutorial](synthesis/SynthTutorial.md) - Envelope generators produce piecewise functions. Most often they are linear or exponential. In csound-expression we can produce piecewise functions with two function: `linseg` and `expseg`.
- [UserInteractionTutorial](synthesis/UserInteractionTutorial.md) - So far every midi-instrument has triggered the instrument in the separate note instance. In the end we get the sum of all notes. It's polyphonic mode. But what if we want to use synth in monophonic mo
