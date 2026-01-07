# Chapter 14

Chapter 14
Spectral Processing
Abstract In this chapter, we will explore the fundamentals of the theory of frequency-
domain processing of audio. The text begins by exploring the most relevant tools
for analysis and synthesis: the Fourier transform, the Fourier series and the discrete
Fourier transform. Following this, we look at some applications in ﬁlter design and
implementation. In particular, we show how the fast partitioned convolution algo-
rithm can take advantage of the theory outlined in the earlier sections. The chapter
goes on to discuss the phase vocoder, with analysis and synthesis code examples,
and its various transformation techniques. Finally, it is completed by an overview of
sinusoidal modelling and ATS, and their implementation in Csound.
14.1 Introduction
Spectral processing of sound is based on the principle of manipulating frequency-
domain representations of signals. Here, we are looking at data that is organised
primarily as a function of frequency, rather than time, as in the case of the methods in
previous chapters. Although the primary concern here is the modiﬁcation of spectral
information, we will also consider the time dimension as we process sounds with
parameters that change over time. In many places, because of this combination of
the two domains, these techniques are also called time-frequency methods.
In order to work in the frequency domain, it is necessary to employ an analysis
stage that transforms the waveform into its spectrum [8, 90, 34]. Complementary,
to play back a processed sound it is necessary to employ the reverse operation,
synthesis, which converts spectra into waveforms. This chapter will ﬁrst discuss
the basic techniques for performing the analysis and synthesis stages, and the key
characteristics of the frequency-domain data that they work with. Following this,
we will introduce the application of these and the various methods of modifying
and processing spectral data.
© Springer International Publishing Switzerland 2016 
V. Lazzarini et al., Csound, DOI 10.1007/978-3-319-45370-5_
295
14
296
14 Spectral Processing
14.2 Tools for Spectral Analysis and Synthesis
The spectrum of audio signals can be obtained through a number of methods. The
most commonly used of these are derived from Fourier’s theory [43, 17], which
tells us that a function, such as a sound waveform, can be decomposed into sepa-
rate sinusoidal functions (waves) of different amplitudes, frequencies and phases.
Related to this fundamental principle there are a number of mathematical tools for
analysis and synthesis called transforms that are variations with speciﬁc application
characteristics.
The foundation for all of these is the original continuous-time, continuous-
frequency Fourier transform. Closely related to this, we have the continuous-time,
discrete-frequency Fourier series, which can be used to synthesise a periodic wave-
form from its spectrum. Another related variation is given by the discrete-time,
continuous-frequency z-transform, commonly used in the spectral description of ﬁl-
ters. Finally, we have the discrete-time, discrete-frequency Fourier transform (DFT),
which is widely used in spectral processing, and the basis for other algorithms, such
as the phase vocoder and sinusoidal modelling. In this section, we will outline the
principles and characteristics of the relevant spectral analysis and synthesis tools.
14.2.1 Fourier Transform
The Fourier transform (FT) is the underlying mathematical method for all the pro-
cesses discussed in this chapter [121]. It is deﬁned as continuous in time t, and it
covers all frequencies f, also continuously, from −∞to ∞[90]:
X( f) =
3 ∞
−∞x(t)[cos(2π ft)−jsin(2π ft)]dt
(14.1)
It gives us a spectrum X(f) from a waveform x(t). It does this by multiplying
the input signal by a complex-valued sinusoid at frequency f, and then summing
together all the values of the function resulting from this product (this is indicated by
the integral symbol (
4 ), which means in this case a sum over a continuous interval,
from −∞to ∞).
The result is a pair of spectral coefﬁcients, telling us the amplitudes of a cosine
and a sine wave at that frequency. If there is none to be found, these will be zero. If
a component is detected, then we might have a sinusoid in cosine or sine phase, or
in between these two (this is why a complex multiplication is used, so that the exact
phase can be determined). This operation can be repeated by sliding the sinusoid to
another frequency, to obtain its coefﬁcients.
In other words, we use a sinusoid as a detector. Once it is tuned to the same
frequency as an existing spectral component, it gives a result. If it is not tuned to it,
then the result is zero. This is the fundamental operating principle of the FT. While it
is mostly a theoretical tool, there are some practical applications, for instance when
we restrict the time variable to cover a single cycle of a periodic waveform.
14.2 Tools for Spectral Analysis and Synthesis
297
Another important consideration here is that audio signals are real-valued (a
waveform is single dimensional), and this determines the shape of the spectra we
get from the FT. This fact means each component in a waveform is detected both at
its negative and positive frequency values, with the amplitude of the sine coefﬁcient
with opposite signs on each side (the cosine coefﬁcient is the same). This allows us
to be able to construct the negative side ( f < 0) from the positive one, thus in most
cases we only need to work with non-negative frequencies.
Finally, the form of spectral data in amplitudes of cosines and sines is sometimes
unwieldy to manipulate. We can convert these into the actual sinusoid amplitudes
and phases with the simple relations
A =
(
c2 +s2
and
Ph = arctan
)s
c
*
(14.2)
where A and Ph are the amplitude and phase, respectively, of the detected sinusoid,
and c and s are its cosine and sine amplitudes. The collection of all detected ampli-
tudes is often called the magnitude spectrum. The phases are similarly named. Note
that the expressions in eq. 14.2 mean that an audio waveform will have a magnitude
spectrum that is symmetric at 0, and a phase spectrum that is anti-symmetric. Again,
this allows us to effectively ignore its negative-frequency side.
14.2.2 Fourier Series
The FT has an equivalent inverse transform, also time- and frequency-continuous,
that makes a waveform from a given spectrum [121]. This has a form that is very
similar to eq. 14.1, but with X( f) as input and x(t) as output. If, however, we con-
strain our spectrum to be discrete, then we have a variation that is a sum of (an
inﬁnite number of) sinusoids at frequencies k = {−∞,...,−2,−1,0,1,2,...,∞}:
x(t) = 1
2π
∞
∑
k=−∞
X(k)[cos(2πkt)+ jsin(2πkt)]
(14.3)
This is called the Fourier series (FS), where the continuous frequency f is re-
stricted to a series of integers k. Here, the sinusoids are complex-valued, but the
result is restricted to be real-valued (it is an audio waveform), and thus it can be
simpliﬁed to a real-valued expression using only the non-negative coefﬁcients:
x(t) = 1
π
5
a0
2 +
∞
∑
k=1
ak cos(2πkt)−bk sin(2πkt)
6
= 1
π
5
a0
2 +
∞
∑
k=1
Ak cos(2πkt +Phk)
6
(14.4)
298
14 Spectral Processing
where ak and bk are the sine and cosine amplitudes of each frequency component f,
and in the second form, Ak and Phk are the magnitudes and phases. A key charac-
teristic of the FS is that its output is periodic, repeating every time t increases by 1.
So eq. 14.4 describes a single cycle of a waveform with a possibly inﬁnite number
of harmonics. Its parameters can be determined by analysis, from an existing wave-
form, using the FT limited to the interval of a single cycle. A simpliﬁed version
of the Fourier transform is used, for instance, in GEN 10 (eq. 12.2), whereas more
complete versions are implemented in GEN 9 and GEN 19.
14.2.3 Discrete Fourier Transform
Both the FT and the FS are deﬁned in continuous time, so for digital audio ap-
plications, which are discrete in time, they will remain somewhat theoretical. The
continuous-frequency, discrete-time, variation, called the z-transform, is used in the
study of digital ﬁlters, to determine their frequency response [97]. Although related,
its applications are beyond the scope of this chapter.
The next step is to consider a transform that is discrete in time and frequency.
This is called the discrete Fourier transform [65, 55, 56] and can be expressed by
the following expression:
X(k) = 1
N
N−1
∑
t=0
x(t)[cos(2πkt/N)−jsin(2πkt/N)]
k = 0,1,...,N −1
(14.5)
Comparing it with eq. 14.1, we can see that here both time and frequency are
limited to N discrete steps. Sampling in time makes our frequency content limited
to sr
2 . Given that the frequency spectrum is both negative and positive, the DFT will
produce N values covering the full range of frequencies, −sr
2 to sr
2 .
The ﬁrst N
2 samples will correspond to frequencies from 0 to the Nyquist. The
N
2 point refers both to sr
2 and to −sr
2 . The second half of the DFT result will then
consist of the negative frequencies continuing up to 0 Hz (but excluding this point).
In Fig. 14.1, we see a waveform and its corresponding magnitude spectrum, with the
full positive and negative spectrum. As indicated in Section 14.2.1, we can ignore
the negative side, and there will be N
2 + 1 pairs of spectral coefﬁcients. They will
correspond to equally spaced frequencies between 0 and sr
2 (inclusive).
We can think of each one of these frequency points as a band, channel, or bin.
Here, instead of a sliding sinusoid, we have a stepping one, as a component de-
tector. Another way to see this is that we are analysing one period of a waveform
whose harmonics are multiples of sr
N Hz, the fundamental analysis frequency. If the
input signal is perfectly periodic within N
sr secs, then the analysis will capture these
harmonics perfectly (Fig. 14.1).
If we try to analyse a signal that does not have such characteristics, the analysis
will be smeared, i.e. the component detection will be spread out through the various
14.2 Tools for Spectral Analysis and Synthesis
299
Fig. 14.1 A waveform with three harmonics (top) and its magnitude spectrum (bottom). The wave
period is an integer multiple of the DFT size (N=256), giving a perfect analysis. Note that the full
spectrum shows that the components appear in the positive and negative sides of the spectrum. The
ﬁrst half of the plot refers to positive frequencies (0 to sr
2 ), and the second, to negative ones (from
−sr
2 to 0 Hz)
frequency points (or bins), as shown in Fig. 14.2. This is because the DFT will
always represent the segment analysed as if it were periodic. That is, the input will
always be modelled as made of components whose frequencies are integer multiples
of the fundamental analysis frequency.
This means that if we apply the inverse DFT, we will always recover the signal
correctly:
x(t) =
N−1
∑
k=0
X(k)[cos(2πkt/N)+ jsin(2πkt/N)]
t = 0,1,...,N −1
(14.6)
Comparing eq. 14.6 with the FS in eq. 14.4, we can see that they are very similar.
The IDFT can be likened to a bandlimited, complex-valued, version of the FS.
Windows
The smearing problem is an issue that affects the clarity of the analysis data. By
looking at the cases where it occurs, we see that it is related to discontinuities cre-
ated at the edges of the waveform segment sent to the DFT. This is because to do the
analysis we are effectively just extracting the samples from a signal [49]. The pro-
cess is called windowing [66], which is the application of an envelope to the signal.
300
14 Spectral Processing
Fig. 14.2 A three-component waveform (top) and its magnitude spectrum (bottom). The wave
period is not an integer multiple of the DFT size (N=256), resulting in a smeared analysis. The
spectral peaks are located at the component frequencies, but there is a considerable spread over all
frequency points
In this case, the window shape used is equivalent to a rectangular shape (i.e. zero
everywhere, except for the waveform segment, where it is one).
Fig. 14.3 A Hanning window, which is an inverted cosine, raised and scaled to ﬁt in the range of
0 to 1
There are many different types of window shapes that allow us to minimise the
smear problem. These will tend to smooth the edges of the analysed segment, so
that they are very close to zero. A common type of window used in DFT analysis is
the Hanning window. This shape is created by an inverted cosine wave, that is offset
and scaled to range between 0 and 1, as seen in Fig. 14.3. Its application to an input
14.2 Tools for Spectral Analysis and Synthesis
301
waveform is shown in Fig. 14.4, reducing the amount of smearing by concentrating
the magnitude spectrum around the frequency of its three components.
Fig. 14.4 A waveform windowed with a Hanning shape, and its resulting spectrum with a reduced
amount of smearing
The fast Fourier transform
The DFT as deﬁned by eqs. 14.5 and 14.6 can be quite heavy to compute with
large window (segment) sizes. However, there are fast algorithms to calculate it,
which exploit some properties of these expressions. These are called the fast Fourier
transform (FFT), and they produce outputs that are equivalent to the original DFT
equations. The classic FFT algorithm works with speciﬁc window lengths that are
set to power-of-two sizes.
In addition, with audio signals, it is common to use transforms that are optimised
for real-valued inputs. In Csound, these are represented by the following opcodes
for forward (wave to spectrum) and inverse real-signal DFTs:
xSpec[]
rfft xWave[]
xWave[] rifft xSpec[]
These both work with i-time and k-rate arrays. The xSpec[] will consist of N
pairs of numbers containing the cosine and sine amplitudes for one for each non-
negative point, except for 0 Hz and sr
2 , which are amplitude-only (0 phase), and are
packed together in array positions 0 and 1.
The full (negative and positive) spectrum DFTs are implemented by
302
14 Spectral Processing
xSpec[]
fft xWave[]
xWave[] fftinv xSpec[]
With these, both the inputs and outputs are expected to be complex.
Applications
An application of the DFT has already been shown in Section 13.4.3, where the
inverse transform was employed to generate the FIR ﬁlter coefﬁcients for an am-
plitude response designed in the spectral domain. In listing 13.16, we employed the
rifft opcode to do a real-valued inverse discrete Fourier transform, and were able
to get the IR that deﬁned the desired ﬁlter amplitude response.
This use of the transform is enabled by the fundamental idea that a ﬁlter fre-
quency response is the spectrum of its impulse response (Fig. 14.5). So it is also
possible to a look at the amplitude curve of a ﬁlter by taking the DFT of its impulse
response and converting it into a magnitude spectrum. We can do likewise with the
phases, and see how it affects the different frequencies across the spectrum. This
makes the DFT a very useful tool in the design and analysis of ﬁlters.
impulse
response
-
DFT
-

IDFT

frequency
response
Fig. 14.5 The relationship between impulse response and frequency response of a digital ﬁlter
The DFT can also be used to determine the harmonic amplitudes and phases of
any periodic waveforms. This allows us to be able to reproduce these by applying
the Fourier series, or indeed the IDFT, to generate wavetables for oscillators. More
generally, if we use a sequence of DFTs, we will be able to determine time-varying
spectral parameters. For instance, a sequence of magnitude spectra taken at regular
intervals yields a time-frequency representation called a spectrogram. In Fig. 14.6,
we see a 2D plot of a sequence of magnitudes over time, where the darker lines
indicate the spectral peaks. Another way to show a spectrogram is through a 3D
graph called a waterfall plot (Fig. 14.7), where the three dimensions of frequency,
time and amplitude are placed in separate axes.
14.3 Fast Convolution
Another direct application of the DFT that is related to ﬁlters is fast convolution
[65, 90]. As we have seen in Chapter 13, direct calculation of convolution using
14.3 Fast Convolution
303
Fig. 14.6 The spectrogram of a C4 viola sound. The dark lines indicate the harmonic partials
detected by the analysis
Fig. 14.7 A 3D plot of the spectrogram of a C4 viola sound, showing the sequence of magnitude
spectra taken at regular interval.
tapped delay lines, multiplications and additions can be computationally expensive
for large IR sizes. The DFT offers a fast method, taking advantage of the following
principles: