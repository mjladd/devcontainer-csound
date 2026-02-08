---
source: Csound Journal
issue: 21
title: "ChuckSound"
author: "clicking the link for example files shown further down in this article"
url: https://csoundjournal.com/issue21/chuck_sound.html
---

# ChuckSound

**Author:** clicking the link for example files shown further down in this article
**Issue:** 21
**Source:** [Csound Journal](https://csoundjournal.com/issue21/chuck_sound.html)

---

CSOUND JOURNAL[](https://csoundjournal.com/../index.html) | [Issue 21](https://csoundjournal.com/index.html)
## ChuckSound

### A Chugin for running Csound inside of ChucK
 Paul Batchelor
 thisispaulbatchelor AT gmail.com
## Introduction


ChuckSound is a plugin for ChucK (otherwise known as a “chugin”) that allows Csound to run inside of ChucK. Prior to ChuckSound, a typical setup for getting Csound + ChucK working together would be to start ChucK and Csound as separate applications, and to use OSC and/or JACK to communicate. With ChuckSound, Csound is spawned inside of ChucK's audio engine via the Csound API. This approach allows Csound to work seamlessly with ChucK objects without any sort of latency that OSC would produce. ChuckSound has the ability to evaluate Csound orchestra code inside of ChucK as well as send score events.
## I. Installation and Setup


The latest version of ChuckSound can be found on GitHub at [https://www.github.com/PaulBatchelor/ChuckSound.git](https://www.github.com/PaulBatchelor/ChuckSound.git). Follow the instructions for your specific platform to install ChuckSound. Example files are included in the repository above, and they can also be downloaded from here by clicking the link for example files shown further down in this article.
## II. Chuck and Csound

###  A brief summary of ChucK for Csounders


ChucK is aptly described as a “Strongly-Timed, Concurrent, On-The-Fly Music programming language”[[1]](https://csoundjournal.com/#ref1). Each of these components makes for a very strong counterpart to Csound.

Firstly, ChucK is strongly-timed. Time and timing is a very important feature to ChucK. In fact, time and duration are primitive types in ChucK [[2]](https://csoundjournal.com/#ref2). Chuck supports many human-readable units of time: samples, milliseconds, seconds, minutes, hours, days, and weeks [[3]](https://csoundjournal.com/#ref3). The concept of a “control rate” is non-existent in ChucK; most ChucK patches are built up of while loops that pause for an arbitrary period of time using the “time => now” paradigm. Csound users should be encouraged to explore time in Chuck, as the language has a very expressive syntax for this domain.

ChucK has a strong emphasis on concurrency, or running processes that occur at the same time. In Chuck, a single program is known as a “shred”, and shreds can be “sporked” together to be played simultaneously. While Csound can run simultaneous instrument instances together to achieve things like instrument polyphony, ChucK is able to run multiple files together that are unrelated by running something like `chuck foo.ck bar.ck` .

ChucK is designed to write code on-the-fly. “On-the-fly” or “live” coding is an important design feature in Chuck. When using ChucK, coding is expected to be part of a performance. Shreds in ChucK can be added and recompiled during a performance without having to stop Chuck from running. While Csound evolved into having real-time capabilities, ChucK has been designed with modern hardware and real-time performance from the beginning. It is still easier to do offline rendering in Csound.

Due to its resemblance to C-like languages, ChucK could be certainly be classified as a programming language. ChucK supports C/C++ types like floats, ints, and strings. There are also similar control structures in ChucK such as for- and while-loops and if-statements. There is support for OOP, with classes, methods, and single inheritance. Writing ChucK code looks and feels like writing a program, whereas Csound looks and feels more like making a patch on a modular synthesizer.

ChucK differs from C-like languages in the way assignment and operators are handled. While C-like languages handle assignment right-to-left, ChucK handles variable assignment left-to-right using the `=>` operator (e.g: `int x = 3` in C would be `3 => int x` in ChucK. For arrays, the `@=>` operator is used (e.g: ` [1, 2, 3] @=> int foo ` ). For audio domain programming, this decision makes sense; more often than not, left-to-right is how signal flow is depicted in diagrams. Nevertheless, this particular syntax can take some adjustment.
### Intended Use Cases


ChuckSound is a wrapper for Csound, and while the Csound API is used under the hood, it is not a wrapper for the API. The design of ChuckSound is the author's best attempt to merge the best parts of both languages. Csound in this instance is approached as an event-based signal processor, using a modular synthesizer paradigm for sound and instrument design. ChucK's time granularity and concurrency is used to precisely control Csound events.
## III. Usage


Before Csound can run inside of ChucK, ChuckSound must compile a CSD. In order for the CSD to sound properly, it must have the following attributes:
- Realtime audio must be enabled, but any audio drivers should be disabled so that the main audio callback is being handled by ChucK. This can be accomplished with the flags `-onull -+rtaudio=null`
- The buffer size `-b` must match ksmps
- The Csound samplerate matches the samplerate in ChucK (this is typically set system-wide)
- The Csound file is mono (`nchan = 1`)

While requiring a CSD file is a clumsy implementation in some cases, there are several advantages to this approach. For one, it leverages the several CsOptions flags that can allow for features like sending code over OSC, buffer size tweaks, and MIDI. It is also conceivably easier to integrate existing Csound projects into ChucK for live remixing and performing.

Listed below are several ChuckSound examples, included with this paper. You can download all the ChuckSound examples shown in this article from the following link: [ChuckSound_exs.zip](https://csoundjournal.com/downloads/chucksound_exs.zip).
### CSD Player


The simplest usage case is to compile an existing CSD file and to let it run without interruption. Using ChuckSound, the code from example file trapped.ck shows how this would be accomplished:
```csound
Csound c => dac;
c.compileCsd("trapped.csd");
283::second => now;
```

### Note Launcher


With ChuckSound, one has the ability to send score events. One could leverage ChucK's strong sense of timing and C-like control structures to build very complex sequencers and event generators this way. Also featured in the example file, pluck.ck, below is ChuckSound's ability to evaluate orchestra code on the fly. This is possible thanks to the new improvements in Csound Version 6 and the *Csound API*:
```csound

Csound c => dac;

c.compileCsd("tmp.csd");

"
instr 1
aout = pluck(0.1, p4, p4, 0, 1) * linseg(1, p3, 0)
out aout
endin
"
=> string orc;

c.eval(orc);

string message;
float freq;

while(1) {
    "i1 0 3 " => message;
    Std.rand2(80, 800) => freq;
    freq +=> message;
    c.inputMessage(message);
    0.5::second => now;
}

```


Evaluating orchestra code inside of ChucK is ideal because it allows multiple ChucK files to use a single template CSD instead of needing to rewriting a new CSD over and over again. All the examples below will use a single file, named tmp.csd, for this purpose:
```csound

<CsoundSynthesizer>
<CsOptions>
;disable audio output and let ChucK handle it all
-d -onull -+rtaudio=null
-b 100
</CsOptions>
<CsInstruments>

sr =	44100
ksmps	= 100
nchnls = 1
0dbfs	= 1

</CsInstruments>
<CsScore>
f 0 $INF
</CsScore>
</CsoundSynthesizer>

```

### ChucK audio inside of Csound


ChuckSound is able to process ChucK audio with Csound opcodes. Any audio routed to the Chugin gets sent to an audio-rate channel called `Chuck_Out`. In the example file below, waveset.ck, a Chuck *SawOsc* object is being processed by Csound's *waveset* opcode.
```csound

SawOsc s => LPF l => Csound c => dac;

c.compileCsd("tmp.csd");
l.set(1000, 0.1);

"
alwayson 2
instr 2
a1 chnget \"Chuck_Out\"
out waveset(a1, 5) * 0.5
endin
"
=> string orc;

c.eval(orc);

float freq;

while(1) {
    Std.rand2(50, 1000) => s.freq;
    500::ms => now;
}

```


Many exciting concepts can arise from this: all of ChucK can be processed through any of Csound's hundreds of opcodes!
### Csound across multiple shreds


Much of ChucK's power is leveraged through running and recompiling several shreds. It is not practical to have an instance of Csound on every shred. A better solution would be to utilize public classes and static variables to generate a single instance of Csound that can be accessed across multiple shreds. Such a class, from example file csEngine.ck, is shown below.
```csound

public class CSEngine
{
    static Csound @ c;

    fun void compile(string filename)
    {
        c.compileCsd(filename);
    }

    fun void eval(string orc)
    {
        c.eval(orc);
    }

    fun void message(string message)
    {

        c.inputMessage(message);
    }

}

Csound c => Gain g => dac;

CSEngine cs;

c @=> cs.c;
cs.compile("tmp.csd");

/* Avoid clicks */
0 => g.gain;
1::ms => now;
1 => g.gain;

while(1){
    500::ms => now;
}

```


The following example file shown below, launcher1.ck, demonstrates how the csEngine class would be used.
```csound

CSEngine cs;

"
instr 1
aout = pluck(0.1, p4, p4, 0, 1) * linseg(1, p3, 0)
out aout
endin
"
=> string orc;

cs.eval(orc);

string message;
float freq;

while(1) {
    "i1 0 3 " => message;
    Std.rand2(80, 300) => freq;
    freq +=> message;
    cs.message(message);
    0.5::second => now;
}

```


Another example file shown below, launcher2.ck, demonstrates how the csEngine class can be used to run on another shred.
```csound

CSEngine cs;

"
instr 2
aout = moogvcf(vco2(0.1, p4) * linseg(1, p3, 0), 1000, 0.1)
out aout
endin
"
=> string orc;

cs.eval(orc);

string message;
float freq;

while(1) {
    "i2 0 3 " => message;
    Std.rand2(300, 1000) => freq;
    freq +=> message;
    cs.message(message);
    0.9::second => now;
}

```


To see this in action, one could simply run `chuck csEngine.ck launcher1.ck launcher2.ck` from the supplemental file directory. Note that the file csEngine.ck must go before launcher1.ck and launcher2.ck in order to work.
## IV. Future Plans


ChuckSound is still very early in development. Current plans for ChuckSound include better cross-platform support, stereo and multi-channel output, as well as the ability to read/write channels from Csound.
## Acknowledgements


Special thanks goes out to Alexander Tape, Ni Cai, and Nick Arner for testing out ChuckSound.
## References


 [][1] Ge Wang, Perry Cook et. al., “ChucK: Strongly-timed, Concurrent, and On-the-fly Music Programming Language.” [Online] Available: [http://chuck.cs.princeton.edu/](http://chuck.cs.princeton.edu/). [Accessed July 30th, 2015].

 [][2] Ge Wang, Perry Cook et. al., “Chuck: Language Specification.” [Online] Available: [http://chuck.cs.princeton.edu/doc/language/](http://chuck.cs.princeton.edu/doc/language/). [Accessed July 30th, 2015].

 [][3] Ge Wang, Perry Cook et. al., 2002. “Chapter 21: Time and timing.” in *Floss Manuals ChucK*, [Online] Available: [ http://en.flossmanuals.net/chuck/ch021_time-and-timing/](http://en.flossmanuals.net/chuck/ch021_time-and-timing/). [Accessed July 30th, 2015].
