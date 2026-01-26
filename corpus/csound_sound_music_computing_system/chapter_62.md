# Chapter 12

Chapter 12
Classic Synthesis
Abstract In this chapter, we will explore a variety of classic synthesis designs,
which have been developed throughout the history of computer music. These are
organised into three families: source-modiﬁer methods (also known as subtractive),
distortion techniques, and additive synthesis. The text begins by introducing some
fundamental concepts that underpin all classic approaches, relating to the duality of
waveform and spectrum representations. Following this, source-modiﬁer methods
are explored from their basic components, and two design cases are offered as ex-
amples. Distortion synthesis is presented from the perspective of the various related
techniques that make up this family, with ready-to-use UDOs for each one of them.
Finally, we introduce the principle of additive synthesis, with examples that will link
up to the exploration of spectral techniques in later chapters.
12.1 Introduction
Synthesis techniques have been developed over a long period since the appearance
of the ﬁrst electronic instruments, and then through the history of computer music.
Of these, a number of classic instrument designs have emerged, which tackled the
problem of making new sounds from different angles. In this chapter, we will ex-
plore these in detail, providing code examples in the Csound language that can be
readily used or modiﬁed, in the form of user-deﬁned opcodes (UDOs). The three
families of classic sound synthesis will be explored here: source-modiﬁer methods,
distortion and additive synthesis. Our approach will be mostly descriptive, although
we will provide the relevant mathematical formulae for completeness, wherever this
is relevant.
© Springer International Publishing Switzerland 2016
V. Lazzarini et al., Csound, DOI 10.1007/978-3-319-45370-5_
209
12
210
12 Classic Synthesis
12.1.1 Waveforms and Spectra
The principle that joins up all classic synthesis techniques is the idea that in order to
realise a given waveform, we need to specify, or at least approximate, its spectrum.
This is another way to represent sound. While audio waves give us a picture of how
a given parameter (e.g. air pressure at a point) varies over time, a spectral plot shows
the components of the signal at a point in time. These components, also known as
partials, are very simple waveforms, which can be described by a sinusoidal function
(such as sin() and cos()) with three parameters: amplitude, frequency and phase.
They can be thought of as the building blocks of a given sound, sometimes called,
informally, pure frequencies. Theoretically, any waveform can be broken down into
such components, although in some cases this might involve an inﬁnite number of
them.
Mathematically stated, we can represent a target signal s(t) as [63]
s(t) =
N
∑
k=1
Ak cos(ωk +θk)
(12.1)
where Ak is the amplitude of partial k, ωk = 2π fkt, with fk its frequency in Hz,
and θk, its phase. This representation allows us to look for the best way to gener-
ate a given sound. Depending on how large the number of components N is, and
how complicated the conﬁguration of the amplitudes, frequencies and phases is, we
will prefer certain methods to others. For instance, with small numbers of compo-
nents, it is simpler to create the sound by generating the components separately and
mixing them up (this is the principle of additive synthesis). As N gets larger, there
are more efﬁcient ways, through distortion techniques or source-modiﬁer methods.
In the case of noisy sounds, which might have a (statistically) inﬁnite number of
components, distributed across large frequency bands, adding components together
is not feasible. The idea that complex functions can be decomposed into sinusoidal
partials was originally explored by Joseph Fourier [43], and methods employing this
principle often bear his name (e.g. Fourier series, Fourier transform).
Once we can describe the components of a signal in terms of its parameters, we
might then choose one of the classic methods to synthesise it. For some sounds,
it is possible to have a clear picture of what the spectrum looks like. For instance,
Fig. 12.1 shows a waveform and its corresponding amplitude spectrum. Each com-
ponent in the waveform is shown as a vertical line, whose height indicates its (rel-
ative) amplitude (or weight). The horizontal axis determines the frequency of the
component, from 0 Hz upwards (phase is not plotted). The spectral plot refers to
a given moment in time, but as the wave is ﬁxed, it is a valid description for this
particular shape. For each line in the spectral plot, we have a sinusoidal wave in
the signal, and if we start with this recipe, we could reproduce the sound by adding
these simples sounds together.
When partial frequencies are connected by a simple integer relationship (e.g. 1,
2, 3, 4,...), they form a harmonic spectrum. In the example of Figure 12.1, this is
the case, as we can see that the partials are spaced evenly apart. They are multiples
12.1 Introduction
211
Fig. 12.1 Waveform (top) and amplitude spectrum (bottom) of an audio signal (sr = 40 kHz)
of a fundamental frequency, which determines the perceived pitch of the sound.
In this case we can call these partials by the name of harmonics. Fig. 12.2 shows
these components as sinusoidal waves that add up to make a complex waveform.
Harmonic spectra can have gaps in it (missing harmonics), as long as the existing
partials are closely aligned to a series of integers of a fundamental frequency. This
is also called the harmonic series. If the partials are not closely related to this series,
then the spectrum is inharmonic, and the sense of pitch less deﬁned (as there is
no fundamental frequency to speak of). In this case we have inharmonic partials.
However, it is important to note that small deviations from the harmonic series can
still evoke the feeling of a fundamental (and pitch). In fact, some instruments often
have partials that deviate slightly from the harmonic series, but produce recognisable
pitched notes.
More generally, spectra of different sounds are signiﬁcantly more complex than
the example in Fig. 12.1. In particular, interesting sounds tend to vary in time, and
generating time-varying spectra is particularly important for this. In this case, the
amplitude Ak and frequency fk parameters of each partial can change over time,
and the chosen synthesis method will need to try and emulate this. In the following
sections, we will explore the three classic methods that can be used for creating
different types of spectra.
212
12 Classic Synthesis
Fig. 12.2 One cycle of a complex periodic waveform (solid) and its sinusoidal components (har-
monics, in dots)
12.2 Source-Modiﬁer Methods
Source-modiﬁer is the most common of all the classic synthesis methods, which is
ubiquitously present in hardware synthesisers, their software emulations, and music
programming systems. It is commonly called subtractive synthesis, which does not
accurately describe it, since there is no actual subtraction involved in it. That term is
used with reference to the fact that this method is complementary to additive synthe-
sis, which involves actual summation of single-source signals. Here, we start with
component-rich sounds, and modify them. However, this process is not necessarily
a subtraction, although in some cases it involves removal of parts of the original
spectrum.
12.2.1 Sources
In order to allow for further modiﬁcation, a source needs to be complex, i.e. it needs
to have a good number of partials in its spectrum. This means that in this case, a
sinusoidal oscillator, which contains a single component, is not a very good choice.
Waveforms of various other shapes can be used, and also recordings of real instru-
ments, voices and other component-rich sounds. Non-pitched sources can also be
12.2 Source-Modiﬁer Methods
213
used, and a variety of noise generators are available in Csound for this. In this sec-
tion, we will examine these possibilities in detail.
Oscillators
The basic wavetable oscillators in Csound provide the most immediate types of
sound sources for further modiﬁcation. There are two types of simple oscillators:
the oscil and poscil families. The former employs an indexing algorithm writ-
ten using ﬁxed-point (or integer) mathematics, whereas the latter uses ﬂoating-point
(decimal-point) arithmetic. In earlier computing platforms, an integral index was
signiﬁcantly faster to calculate, making oscil and derived opcodes much more
efﬁcient. The limitations were twofold: function tables were required to be power-
of-two size, and with large table sizes indexing errors would occur, which resulted
in loss of tuning accuracy at lower frequencies. In modern platforms, very little dif-
ference exists in performance between ﬁxed- and ﬂoating-point operation. Also, in
64-bit systems, the indexing error in the former method has been minimised sig-
niﬁcantly. So the difference between these two oscillator families is very small. In
practical terms, it mainly involves the fact that poscil and derived opcodes do not
require tables to have a power-of-two size, whereas the others do.
Both families of oscillators have a full complement of table-lookup methods,
from truncation (oscil), to linear (oscili, poscil) and cubic interpolation
(oscil3, poscil3) [67]. They can work with tables containing one or more
waveform cycles (but the most common application is to have a single period of
a wave stored in the table). Csound provides the GEN9, GEN10, and GEN19 rou-
tines to create tables based on the additive method. GEN10 implements a simple
Fourier Series using sine waves,
ftable[n] =
N
∑
k=1
Pk sin(2πkn/L)
(12.2)
where L is the table length, N the number of harmonics (the number of GEN param-
eters), Pk is parameter k and n the table index. GEN9 and GEN19 have more generic
parameters that include phase and relative frequencies, as well as amplitudes. For
instance, with GEN10, a wave containing ten harmonics can be created with the
following code:
gifun
ftgen
0, 0, 16384, 10, 1, 1/2, 1/3, 1/4, 1/5,
1/6, 1/7, 1/8, 1/9
The required parameters are the different amplitudes (weights) of each harmonic
partial, starting from the ﬁrst. In this case, the harmonics have decreasing ampli-
tudes, 1 through to 1
10 (Fig. 12.3 shows a plot of the function table). The main dis-
advantage of using such simple oscillators is that the bandwidth of the source cannot
be controlled directly, and is dependent on the fundamental frequency. For instance,
the above waveform at 100 Hz will contain components up to 900 Hz, whereas an-
214
12 Classic Synthesis
Fig. 12.3 Function table created with GEN10, containing ten harmonics with amplitudes 1
n, where
n is the harmonic number
other one at 1000 Hz will extend until 9000 Hz. So we will have be careful with our
range of fundamentals, so that they do not go beyond a certain limit that would push
the 10th harmonic (9 × f0) over the Nyquist frequency. The other difﬁculty is that
low-frequency sounds will lack brightness, as they are severely bandlimited.
A solutions to this can be to supply a variety of tables, which would be selected
depending on the oscillator fundamental. This is a good way of implementing a
general table-lookup system, but can be complex to realise in code. An alternative
is to use a ready-made solution provided by bandlimited oscillators. In Csound,
there are four basic opcodes for this: buzz, gbuzz, vco, and vco2. The ﬁrst two
implement different forms of bandlimited waveforms (see Section 12.3.1 for an idea
of how these algorithms work), with buzz providing all harmonics with the same
amplitude, and gbuzz allowing for some control of partial weights.
The other two offer two different ﬂavours of virtual analogue modelling, pro-
ducing various types of classic waveforms. The typical shapes produced by these
oscillators are
•
sawtooth: contains all harmonics up to the Nyquist frequency with weights de-
termined by 1
n (where n is the harmonic number).
•
square: odd harmonics only, with weights deﬁned by 1
n.
•
pulse: all harmonics with the same weight.
•
triangle: odd harmonics only, with weights deﬁned by 1
n2 .
Plots of the waveforms and spectra of two classic waves generated by vco2 are
shown in Figs. 12.4 and 12.5, where we see that their spectra are completed all the
way up to the Nyquist frequency. In addition to the waveshapes listed above, it is
also possible to produce intermediary forms between pulse and square by modify-
ing the width of a pulse wave (its duty cycle). This can be changed from a narrow
impulse to a square wave (50% duty cycle).
12.2 Source-Modiﬁer Methods
215
Fig. 12.4 A plot of the waveform (top) and spectrum (bottom) of a sawtooth wave generated by
vco2, with sr = 44,100 Hz
Fig. 12.5 A plot of the waveform (top) and spectrum (bottom) of a square wave generated by
vco2, with sr = 44,100 Hz
216
12 Classic Synthesis
Sampling
Yet another set of sources for modiﬁcation can be provided by sampling. This can be
achieved by recording sounds to a soundﬁle and then loading these into a table for
playback. These tables can be read by any of the simple oscillators (with some limi-
tations if power-of-two sizes are required), or a specialised sample-playback opcode
can be used. The GEN 1 routine is used to load soundﬁles into tables. Any of the ﬁle
formats supported by Csound are allowed here (see Section 2.8.4). For sounds that
are not mono, it is possible to read each channel of the soundﬁle separately, or to
load the whole ﬁle with all the channels into a single table. In this case, samples are
interleaved (see Section 2.4.3 for a detailed explanation), and ordinary oscillators
cannot be used to read these. Here is a code example showing GEN1 in use to load
a mono ﬁle (“fox.wav”) into a function table:
gifun
ftgen
0, 0, 0, 1,"fox.wav", 0, 0, 0
Fig. 12.6 Function table created with GEN1, containing the samples of a soundﬁle
Note that the table size is set to 0, which means that the soundﬁle size will deter-
mine how long the table will be. A plot of this function table can be seen in Fig. 12.6.
When using a simple oscillator to read this, we will need to adjust the frequency to
depend on the table size and the sampling rate. If we want to read the table at the
original speed, we set the sampling (or phase) increment (si) (see Section 3.5.2) to
