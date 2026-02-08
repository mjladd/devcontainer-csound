---
source: Csound Journal
issue: 13
title: "Add_Synth"
author: "mixing multiple sine waves of various frequencies"
url: https://csoundjournal.com/issue13/add.html
---

# Add_Synth

**Author:** mixing multiple sine waves of various frequencies
**Issue:** 13
**Source:** [Csound Journal](https://csoundjournal.com/issue13/add.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 13](https://csoundjournal.com/index.html)
## Add_Synth

### F-Table Based Additive Synthesizer
 Jacob Joaquin
 jacobjoaquin AT gmail.com
## Introduction


In The Computer Music Tutorial, Curtis Roads writes about additive synthesis as being, *"a class of sound synthesis techniques based on the summation of elementary waveforms to create a more complex waveform[[1](https://csoundjournal.com/#ref1)]."* A simple concept with complex ramifications.

In digital synthesis, there are two primary issues that have historically plagued the proliferation of building sounds from sine waves. The first is processing power. In order to design complex additive timbres where each partial changes over time, one needs a large number audio oscillators with supporting unit generators for modulation. This issue continues to fade as faster processors make it to market.

The second is the issue of practicality. In order to fully take advantage of additive synthesis, a sound designer needs to be able to modulate the frequency, the amplitude, and in some cases, the phase for each individual partial. Describing multiple multi-point envelopes is highly time consuming if done by hand. However, various techniques introduced over the years have provided several paths for a sound designer to compose evolving additive timbres quickly and efficiently.

This article presents three additive synthesis techniques designed for Csound that utilize f-tables as a way to design additive timbres. These are designed more for user-practicality rather than processor efficiency. Since Csound can render sounds in non-realtime to a file, the issue of the processor power is side-stepped, freeing people to get hands on experience with additive synthesis.
### Download
 The Csound example file: [Add_Synth.csd](https://csoundjournal.com/./Add_Synth.csd).
## I. Concepts


The information presented in this article is dependent on various other Csound techniques. To avoid re-inventing of the wheel, a brief synopsis for each of these techniques is provided below and linked to other sources on the web.
### Additive Synthesis


In sine wave additive synthesis, a sound designer constructs sounds by mixing multiple sine waves of various frequencies, amplitudes and phases. An individual sine wave is referred to a partial through out the article.

For more on additive synthesis, read Wikipedia's [entry](http://en.wikipedia.org/wiki/Additive_synthesis) as well as Sound On Sound's [SYNTH SECRETS Part 14: An Introduction To Additive Synthesis](http://www.soundonsound.com/sos/jun00/articles/synthsec.htm)[[2](https://csoundjournal.com/#ref2),[3](https://csoundjournal.com/#ref3)].
### User-Defined Opcodes


The three additive techniques are grouped into a single User-Defined Opcode (UDO) called Add_Synth. To learn about UDOs, refer to the Csound Canonical Manual. For more in depth information about UDOs, read Steven Yi's articles Control Flow -- [Part I](http://www.csounds.com/journal/2006spring/controlFlow.html) and [Part II](http://www.csounds.com/journal/2006summer/controlFlow_part2.html)[[4](https://csoundjournal.com/#ref4),[5](https://csoundjournal.com/#ref5),[6](https://csoundjournal.com/#ref6)].
### Recursion
 [Wikipedia](http://en.wikipedia.org/wiki/Recursion) defines recursion as *"a process of repeating objects in a self-similar way[[7](https://csoundjournal.com/#ref7)]."* The additive synthesizer engine utilizes a recursive loop to generate each partial in an additive voice. The technique is based on Steven Yi's recursive additive synthesizer (UDO) in his article [Control Flow -- Part II](http://www.csounds.com/journal/2006summer/controlFlow_part2.html)[[5](https://csoundjournal.com/#ref5),[6](https://csoundjournal.com/#ref6)].
### Gen Instruments


A Gen Instrument is a Csound instrument designed for the sole purpose of creating or manipulating f-tables. They allow users to generate data in ways not supported by the current line of GEN opcodes. Gen Instruments are used as a convenient way to generate and retrieve data for RAP f-tables. To learn more, read the author's article [Gen Instruments](http://www.csounds.com/journal/issue12/genInstruments.html)[[8](https://csoundjournal.com/#ref8)].
## II. Add_Synth User-Defined Opcode


The additive synth engine is written as a User-Defined Opcode called *Add_Synth*. This UDO works recursively, calling itself for every partial in an additive timbre. The following lists the order in which an additive voice is generated.
- Call *Add_Synth* UDO from within an instrument
- Get RAP data for the current partial
- Modify amplitude with the body transfer function
- Modulate amplitude with the dynamic 'filter' transfer function
- Generate audio with *oscil*
- Recursively call *Add_Synth* UDO (repeat as necessary)
### The Interface


The *Add_Synth* UDO requires 12 inputs, as seen here:
```csound

kfreq_base,  \  ; Base frequency
kfreq_mod,   \  ; Frequency modulation
ifreq_min,   \  ; Minimum frequency
ifreq_max,   \  ; Maximum frequency
irap,        \  ; RAP table (ratio, amplitude, phase)
ibody_curve, \  ; Body frequency curve
ibody_tune,  \  ; Body tuning table
ibody_amp,   \  ; Body amplitude table
iflt,        \  ; Filter table
kflt_freq,   \  ; Frequency of filter
kflt_width,  \  ; Width of filter
i_index      \  ; Index of current harmonic
xin

```


There is only one quirk to this interface that requires special attention. The *i_index* should always be set to 0 in the calling instrument, as it keeps track of the current partial being generated. The other parameters set the conditions, choose f-tables, or modulate parts of the *Add_Synth* engine.
### The RAP Table


A RAP table is a custom data structure that describes each partial that is to be generated. RAP is an acronym for ratio, amplitude and phase; These three qualities are used to define the characteristics for each partial of an additive timbre, and must be serialized in the table in that order.

A RAP table by itself does nothing as it merely describes an additive timbre, and cannot be passed directly to an oscillator. In order to hear the described sound, its content is unpacked into individual partial data, consisting of a ratio of the fundamental frequency, amplitude and phase, then fed to an oscillator.

Though a GEN10 function produces a waveform constructed from a list of harmonic strengths, the two approaches differ greatly. The GEN10 function constructs a single-cycle waveform from harmonic partials, where as a RAP stores data that must later be translated then fed to an oscillator to make sound. Only a single oscillator is required for a GEN10 single-cylce wave. A RAP requires an oscillator for each generated partial. A single cycle wave does not produce inharmonic frequencies, with the exception of aliasing. A RAP additive synthesizer can define inharmonic partials.

The following score event creates an f-table and stores the data for a band-limited square wave with three partials:
```csound

f 1 0 -6 -2 1 1 0 3 0.333333 0 5 0.2 0

```


The elements for each of the three partials is as follows:
- Partial 1: Ratio=1, Amplitude=1, Phase=0
- Partial 2: Ratio=3, Amplitude=0.333333, Phase=0
- Partial 3: Ratio=5, Amplitude=0.2, Phase=0

The *Get_RAP* UDO pulls the ratio, amplitude and phase for a single partial in a RAP table by index. The following line 5, 0.2 and 0 to iratio, iamp and iphase from the third partial of f-table 1:
```csound

iratio, iamp, iphase Get_RAP 1, 3

```


For convenience, three Gen Instruments have been included in the examples that auto-generate band-limited versions of three classic wave forms in the RAP format: *GEN_Saw*, *GEN_Square* and *GEN_Triangle*. The following score event creates a 16 band-limited saw wave RAP table and stores it as f-table 20.
```csound

i $GEN_Saw 0 1 20 16

```

### The Body


The body section of the *Add_Synth* UDO is composed of two user-supplied transfer functions that control frequency warping and amplitude shaping, loosely modeling an acoustic body.

The first stage of the body is creating a frequency curve from a user supplied table. The curve influences the distribution of the data points across the frequency spectrum. For example, a curve that increments linearly from 0 to 1 linearly distributes the data across the frequency spectrum of 0 to 22050 Hz. The range of values of a curve table should fall between 0 to 1. Here, the input frequency extracts a value from the curve table:
```csound

kcurve tablei kfreq / 22050, ibody_curve, 1, 0, 0  ; Frequency curve

```


The frequency-to-curve value then extracts an interpolated value from the frequency warp table and re-tunes the frequency:
```csound

ktune tablei kcurve, ibody_tune, 1, 0, 0           ; Warp frequency
kfreq = kfreq * ktune

```


The curve value is used again to extract an amplitude value from the body transfer table. This is multiplied with the amplitude value extracted from the RAP table.
```csound

kbody_amp tablei kcurve, ibody_amp, 1, 0, 0        ; Amplitude
kamp = kamp * kbody_amp

```


There is great potential for interesting effects by supplying a table filled with wild curves and/or random data.
### The Filter


The filter of the *Add_Synth* UDO is technically not a filter at all, but a dynamic transfer function designed to model classic filter processes, such as a low pass filter.

Filtering is done with three elements. The first is a table that defines the characteristics of the filter. For example, a "fall" shaped table emulates a low-pass filter, while a "rise" acts as a high-pass filter. The second element is the frequency of the filter, which is mapped to the first index of the table. The final is the width of the filter, which determines the slope. The frequency and width parameters can be optionally modulated.

Here is the code that drives the filter:
```csound

kflt init 0
iflt_size = ftlen(iflt)
kflt_transfer = (kfreq - kflt_freq) / kflt_width

if (kflt_transfer < 0 || kflt_width <= 0) then  ; Transfer function
    kflt tab 0, iflt
elseif (kflt_transfer >= 1) then
    kflt tab iflt_size - 1, iflt
else
    kflt tablei kflt_transfer, iflt, 1, 0, 0
endif

kamp = kamp * kflt
endif

```


A partial's frequency value is run through a three segment transfer function. If the partial's frequency is lower than the filter's frequency, then the value of the first table index is returned. If the partial's frequency is higher than the filter's frequency plus the filter's width, than the value of the last table index is returned. Everything in between returns an interpolated value from the table. The value is multiplied with the partial's amplitude value.

Much like the body, tables filled with wild curves and/or random values can cause some interesting effects, especially as *kflt_freq* and *kflt_width* are modulated.
### Sound Generation


At this point, data for a single partial has been grabbed from a RAP table and processed with the body and filter transfer functions. The data is now ready to be fed to an oscillator, or rejected if the frequency does not fall within the range set by the UDO's *ifreq_max* and *ifreq_min* inputs.
```csound

a1 init 0

if (kfreq >= ifreq_min && kfreq < ifreq_max) then
    a1 oscil kamp, kfreq, $Sine, iphase
else
    a1 = 0
endif

```

### Recursion


If there are partials that have yet to be generated, and the frequency is less than the ifreq_max, then *Add_Synth* calls *Add_Synth*:
```csound

a2 init 0

if (i_index < (ftlen(irap) / 3) - 1 && i(kfreq) < ifreq_max) then
    a2 Add_Synth kfreq_base, kfreq_mod, ifreq_min, ifreq_max, irap,   \
                 ibody_curve, ibody_tune, ibody_amp, iflt, kflt_freq, \
                 kflt_width, i_index + 1
endif

```


If you look at the parameters supplied to *Add_Synth*, you'll notice that they are the unmodified inputs at the top of the UDO, with one exception. The last input, *i_index*, is incremented by 1. This init variable keeps track of the current partial being processed from the RAP table. When the index exceeds the number of partials in the RAP table, the if expression returns false, and *Add_Synth* stops being called.

At this point, the following xout expression starts returning the audio generated from the oscillator, and does so for every active Add_Synth process in the recursive chain.
```csound

xout a1 + a2

```

## Instruments


Two example instruments are included in the CSD: *Simple* and *String*. These are a good starting point for exploring *Add_Synth*.
### Simple


The *Simple* instrument is a near bare-bones patch that uses *Add_Synth* as its audio generator. There are only two optional p-fields that the user must pass in from the score: amplitude and pitch. The f-tables for *Add_Synth* are hardwired to the instrument in the 'Fixed Add_Synth Attributes' section. A triangle LFO modulates the frequency, while the *expon* opcode modulates the filter.
```csound

instr $Simple
    idur = p3          ; Duration
    iamp = p4          ; Amplitude
    ipch = cpspch(p5)  ; Pitch

    ; Fixed Add_Synth Attributes
    irap        = $RAP_Square_16
    ibody_curve = $Lin
    ibody_tune  = $Flat
    ibody_amp   = $Comb_64
    iflt        = $Rise

    ; Frequency Modulation
    kfreq_mod oscil 0.01, 5, $Tri

    ; Filter
    kflt_freq expon ipch * 8, idur, ipch
    kflt_width = kflt_freq * 4

    ; Generate Audio
    a1 Add_Synth ipch, kfreq_mod, 20, 22050, irap, ibody_curve, ibody_tune, \
                 ibody_amp, iflt, kflt_freq, kflt_width, 0

    ; Amp
    aenv linseg 0, 0.05, iamp, idur - 0.1, iamp, 0.05, 0
    a1 = a1 * aenv
    a1 limit a1, -1, 1  ; Prevent audio explosions

    ;Output
    outs a1, a1
endin

```


The *Simple* instr is designed to allow you to easily swap out various f-tables so you can hear the results. If you look at the top of the orchestra or score, you will see various macro definitions ready-to-use in Simple:
```csound

; RAP
# define RAP_Triangle_8 # 100 #
# define RAP_Square_16  # 101 #
# define RAP_Saw_32     # 102 #
# define RAP_Buzz_32    # 103 #

; Curves
# define Lin    # 200 #
# define Exp    # 201 #
# define Custom # 202 #

; Body
# define Flat         # 300 #
# define SawDown      # 301 #
# define TriNoise_512 # 302 #
# define Comb_64      # 303 #
# define TriNoise_8   # 304 #

; Tune
# define Slight  # 400 #
# define Extreme # 401 #

; Shapes
# define Rise # 500 #
# define Fall # 501 #
# define Peak # 502 #
# define Dip  # 503 #

```


Once you have a general understanding of how the f-tables influence the sound, play with the modulation sources, and definitely create your own f-tables. Be creative and inventive.
### String


The *String* instrument is an example of a completed *Add_Synth* patch. It is similar to the *Simple* instrument, but makes liberal use of modulation. The defining quality of the sound is created by using a triangle noise table for the resonant body.
```csound

instr $String
    idur = p3          ; Duration
    iamp = p4          ; Amplitude
    ipch = cpspch(p5)  ; Pitch in octave point pitch-class
    ipan = p6          ; Pan position

    irap = $RAP_Saw_32
    ibody_curve = $Custom
    ibody_amp = $TriNoise_512
    ibody_tune = $Flat
    iflt = $Flat

    ; Pitch vibrato
    k2 linsegr 0, 0.4, 0, 0.7, 1, 1, 1, 1, 0.3, 0.01, 1
    klfo oscil k2, 4.8 + rnd(0.4), $Tri
    krand randh rnd(0.9) + 0.1, 0.125 + rnd(0.25)
    kvibrato = (klfo + krand) * (0.003 + rnd(0.007)) * 2

    ; Pitch
    kpch expseg 2 ^ (-1 / 12), 0.05 + rnd(0.05), 2 ^ (0 / 12), 0.001, \
                2 ^ (0 / 12)

    ; Generate audio
    a1 Add_Synth ipch, kvibrato + kpch, 20, 22050, irap, ibody_curve, \
                 ibody_tune, ibody_amp, iflt, 0, 22050, 0

    ; Amp
    aenv linsegr 0, 0.1 + rnd(0.105), 0.2 + rnd(0.3), 0.1, 0.5, 2, 0.333, \
                 0.2 + rnd(0.1), 0
    asig = a1 * aenv * iamp * (0.9 + rnd(0.1))
    aleft limit asig * sqrt(1 - ipan), -1, 1
    aright limit asig * sqrt(ipan), -1, 1

    outs aleft, aright
endin

```

## Conclusion


Using f-tables is a practical solution for additive synthesis. As demonstrated in this article, they give sound designers a higher level of control over large banks of oscillators, and they can be applied in various ways. Applications include, but are not limited to, defining band-limited waveforms, modeling an acoustic body, and the modeling of classic filtering processes.
## References


[[1]]Roads, Curtis. *The Computer Music Tutorial*: The M.I.T. Press, 1996.

[[2]]Wikipedia contributors, "Additive synthesis," *Wikipedia*, The Free Encyclopedia, [http://en.wikipedia.org/w/index.php?title=Additive_synthesis&oldid=353376399](http://en.wikipedia.org/w/index.php?title=Additive_synthesis&oldid=353376399) (accessed April 26, 2010).

[[3]]Sound On Sound. "SYNTH SECRETS Part 14: An Introduction To Additive Synthesis." *SoundOnSound.com* June 2000, [http://www.soundonsound.com/sos/jun00/articles/synthsec.htm](http://www.soundonsound.com/sos/jun00/articles/synthsec.htm)

[[4]]Barry Vercoe et Al. 2005. *The Canonical Csound Reference Manual*. [http://www.csounds.com/manual/html/index.html](http://www.csounds.com/manual/html/index.html)

[[5]]Yi, Steven. "Control Flow - Part I." *The Csound Journal* Issue Spring 2006, (2006). [http://www.csounds.com/journal/2006spring/controlFlow.html](http://www.csounds.com/journal/2006spring/controlFlow.html)

[[6]]Yi, Steven. "Control Flow - Part II." *The Csound Journal* Issue Summer 2006, (2006). [http://www.csounds.com/journal/2006summer/controlFlow_part2.html](http://www.csounds.com/journal/2006summer/controlFlow_part2.html)

[[7]]Wikipedia contributors, "Recursion," *Wikipedia*, The Free Encyclopedia, [http://en.wikipedia.org/w/index.php?title=Recursion&oldid=358299477](http://en.wikipedia.org/w/index.php?title=Recursion&oldid=358299477) (accessed April 26, 2010).

[[8]]Joaquin, Jacob. "[GEN Instruments -- Methods for Designing Function Table Routines.](https://csoundjournal.com/../issue12/genInstruments.html)" *The Csound Journal* Issue 12, (December 2009).
