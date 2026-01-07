# 3. The result is an IR for our ﬁlter, but it is still not quite ready to be used. To avoid

3. The result is an IR for our ﬁlter, but it is still not quite ready to be used. To avoid
rounding errors, we need to swap the ﬁrst and second halves of it, which will not
affect the amplitude response, but will make the ﬁlter work properly.
while icnt < iflen2 do
itmp = iIR[icnt]
1 The passband is the region of the spectrum whose amplitude is not affected by the ﬁlter. The
stopband is the region whose amplitude gets reduced by the ﬁlter.
13.4 Filters
287
iIR[icnt] = iIR[icnt + iflen2]
iIR[icnt + iflen2] = itmp
icnt +=1
od
This process is illustrated by Fig. 13.14. From top to bottom, we have the original
amplitude curve, the resulting IR, and the amplitude response of the resulting ﬁlter.
Fig. 13.14 Finite impulse response design. From top to bottom: the original amplitude curve, the
resulting IR, and the amplitude response of the resulting ﬁlter
Listing 13.16 shows the complete code. It takes a signal and a function table with
a given amplitude response, calculates the IR at i-time using a dedicated UDO and
then uses it with a direct convolution opcode to produce the output sound.
Listing 13.16 A pair of FIR ﬁlter design and performance opcodes, taking an amplitude response
from an input function table
/*****************************************************
irn IR ifn
irn - impulse response output function table number
ifn - amplitude response function table number
*****************************************************/
288
13 Time-Domain Processing
opcode IR,i,i
ifn xin
iflen2 = ftlen(ifn)
iflen = 2*iflen2
iSpec[] init iflen2
icnt init 0
copyf2array iSpec,ifn
iIR[] rifft r2c(iSpec)
irn ftgen 0,0,iflen,7,0,iflen,0
while icnt < iflen2 do
itmp = iIR[icnt]
iIR[icnt] = iIR[icnt + iflen2]
iIR[icnt + iflen2] = itmp
icnt +=1
od
copya2ftab iIR,irn
xout irn
endop
/*****************************************************
asig FIR ain,ifn
ain - input audio
ifn - amplitude response function table number
*****************************************************/
opcode FIR,a,ai
asig,ifn xin
irn IR ifn
xout dconv(asig,ftlen(irn),irn)
endop
Filters such as this one can work very well to block a part of the spectrum. Figure
13.15 shows the result of putting a full-spectrum pulse waveform through the ﬁlter
designed as shown in Fig. 13.14. As can be seen from the plot, the ﬁlter is very
selective, cutting high frequencies in an effective way.
FIR ﬁlters of this kind are ﬁxed, i.e. they cannot be made time-varying as we have
done with the more musical IIR designs. It is possible however to have more than
one ﬁlter running at the same time and cross-fade the output from one to the other.
Another aspect to note is that direct convolution can be computationally expensive.
This can be replaced with fast convolution, which will be discussed in the next
chapter.
13.4 Filters
289
Fig. 13.15 The spectra of a pulse waveform (top) and output of a brickwall FIR ﬁlter designed as
shown in Fig. 13.14
13.4.4 Head-Related Transfer Functions
Another application of FIR ﬁlters is in the simulation of spatial positions through
the use of head-related transfer functions (HRTFs) [10]. These are ﬁlter frequency
responses that model the way our head and outer ears modify sounds before these are
transmitted through the middle and inner ear to the brain. With them, it is possible
to precisely place sounds on a sphere around the listener, playing the sound directly
via headphones, depending on the accuracy of the transfer functions used.
An HRTF encodes the effect of the head and pinna on the incoming sound. As
it comes from different directions, the spectrum of a sound is shaped in a particular
way, in time (delays) and amplitude. A pair of these, one for each ear, will match
every source direction on a sphere. The combination of ﬁltering, inter-aural time de-
lays (ITDs) and inter-aural intensity differences (IIDs) that is encoded in the HRTFs
will give the listener’s brain the necessary cues to place a sound at a given location
[13].
HRTFs are obtained from head-related impulse responses (HRIRs) that are gen-
erally measured at spaced points on this sphere, via recordings using dummy heads
or real subjects with special in-ear microphones. Once the HRIRs are obtained, we
can use a convolution method to implement the ﬁlter. In some cases, IIR designs
modelled on HRTFs are used, but it is more common to apply them directly in
FIR ﬁlters. As audio is delivered directly to the two ears and localisation happens
through these functions, this process is called binaural audio.
It is very common to use generic measurements of HRIRs for binaural appli-
cations, but the quality of the localisation effect will vary from person to person,
290
13 Time-Domain Processing
according to how close the functions are to the listener’s own. It is well known
that HRTFs can be extremely individual, and ideally these should be designed or
measured for each person for an accurate effect. However, it is not easy to obtain in-
dividualised HRIRs, so most systems providing binaural audio rely on some general
set measured for an average person.
This is the case with Csound, where we ﬁnd a whole suite of opcodes dedicated to
different types of HRTF processing [25]. These rely on a very common set measured
at MIT, which has also been used in other systems. Here, however there are some
clever algorithms that allow for smooth movement of sound sources in space, which
are not found elsewhere, as well as high-quality binaural reverb effects.
The HRTF opcodes in Csound are
hrtfmove and hrtfmove2: unit generators designed to move sound sources
smoothly in 3D binaural space, based on two different algorithms.
hrtfstat: static 3D binaural source placement.
hrtfearly: high-ﬁdelity early reﬂections for binaural reverb processing.
hrtfreverb: binaural diffuse-ﬁeld reverb based on an FDN design, which can
be used in conjuction with hrtfearly, or on its own as a standalone effect.
These opcodes rely on two spectral data ﬁles, for left and right channels, which
have been constructed from the MIT HRTF database specially for these opcodes.
They are available in three different sampling rates: 44.1, 48 and 96 kHz and are
labelled accordingly in the Csound software distribution. The correct pair of ﬁles is
required to match the required sr, otherwise the opcodes will not operate correctly.
13.5 Multichannel Spatial Audio
Complementing the discussion of spatial placement of sounds, we will brieﬂy ex-
plore two essential methods of multichannel audio composition and reproduction.
The ﬁrst one of these is based on the principle of encoding the sound ﬁeld in a single
description of a sound source’s directional properties. The encoded signals then re-
quire a separate decoding stage to be performed to obtain the multichannel signals.
The other method provides a generalised panning technique for multiple channels,
where the output is made up of the actual feeds for loudspeaker reproduction. Both
techniques are fully supported by Csound and allow both horizontal and vertical
placement of audio sources (2D or 3D sound).
13.5.1 Ambisonics
A classic method of audio spatialisation is provided by ambisonics. It encapsulates
many models of auditory localisation, except for pinna and speciﬁc high-frequency
ITD effects, in one single package [51]. The principle of ambisonics, ﬁrst developed
13.5 Multichannel Spatial Audio
291
by Michael Gerzon for periphony (full-sphere reproduction, 3D) [46], is to encode
the sound direction on a sphere surrounding the listener, and then provide methods
of decoding for various loudspeaker arrangements.
The encoded signals are carried in a multiple channel signal set called b-format.
This set can be constructed in increasing orders of directivity [46] by the use of
more channels. Order-0 systems contain only omni directional information; order-1
encodes the signal in three axes, with two horizontal and one vertical component;
order-2 splits these into more directions; and so-on. The number of b-format chan-
nels required for a system of order n is (n+1)2. These form a hierarchy, so that we
can move from one order to the next up by adding 2n+1 channels to the set.
Encoding of signals is performed by applying the correct gains for each direction.
In the case of ﬁrst-order ambisonics, for sounds on a sphere with constant distance
from the subject, we generally have
W =
√
2
2
X = cos(θ)sin(φ)
Y = sin(θ)sin(φ)
Z = cos(φ)
(13.26)
where X and Y are the horizontal, and Z is the vertical component. W is the omni di-
rectional signal. The parameters θ and φ are the angles in the horizontal and vertical
planes (azimuth and elevation), respectively. Higher orders will have more channels,
with different gain conﬁgurations, than these four. In any order, channels involving
the height component might be eliminated if 2D-only (pantophonic) reproduction is
used.
Decoding is generally more complex, as a number of physical factors, including
the spatial conﬁguration of the loudspeakers, will play a part. In particular, non-
regularly spaced speakers, e.g. 5.1 surround sound set-ups, have to be treated with
care. Other important considerations are the need for near-ﬁeld compensation, to
avoid certain low-frequency effects in reproduction, and dual-band decoding, to ac-
count for the fact that ITD and IID perception dominate different areas of the spec-
trum [51]. In other words, a straight decoding using an inversion of the encoding
process might not work well in practice.
Csound includes support for encoding into ﬁrst-, second- and third-order am-
bisonics b-format, via the bformenc1 opcode. This takes a mono signal, an az-
imuth, and an elevation, and produces an output signal for the order requested. These
b-format signals can be mixed together before decoding. Some manipulations, such
as rotations, can also be performed, using the correct expressions in UDOs. The
process of using ambisonics is often one of producing an encoded mix of several
sources, which allows each one of these a separate spatial placement, as a b-format
signal, which can then be decoded for speciﬁc loudspeaker layouts.
The ambisonic decoder bformdec1 can be used to decode signals for a variety
of conﬁgurations. It takes care of ﬁnding the correct gains for each one of these, and
292
13 Time-Domain Processing
includes the important features mentioned above, dual-band decoding and near-ﬁeld
compensation. It is also important to note that specialised decoders can be written
as UDOs, if any particular requirements that are not met by bformdec1 are identi-
ﬁed. Finally, a combination of decoding and the HRTF opcodes from Section 13.4.4
can be used to provide headphone listening of ambisonic audio. In listing 13.17, we
see an example of this for horizontal-plane decoding of order-2 b-format signals.
Listing 13.17 An example of ambisonic to binaural decoding
/*****************************************************
al,ar Bf2bi aw,ax,ay,az,ar,as,at,au,av
aw,ax ... = 2nd-order bformat input signal
===================================
adapted from example by Brian Carty
*****************************************************/
opcode Bf2bi, aa, aaaaaaaaa
aw,ax,ay,az,ar,as,at,au,av xin
if sr == 44100 then
Shl = "hrtf-44100-left.dat"
Shr = "hrtf-44100-right.dat"
elseif sr == 48000 then
Shl = "hrtf-48000-left.dat"
Shr = "hrtf-48000-right.dat"
elseif sr == 96000 then
Shl = "hrtf-96000-left.dat"
Shr = "hrtf-96000-right.dat"
else
al, ar bformdec1 1,aw,ax,ay,az,ar,as,at,au,av
goto end
endif
a1,a2,a3,a4,a5,a6,a7,a8 bformdec1 4,
aw, ax, ay, az,
ar, as, at, au, av
al1,ar1 hrtfstat a2,22.5,0,Shl,Shr
al2,ar2 hrtfstat a1,67.5,0,Shl,Shr
al3,ar3 hrtfstat a8,112.5,0,Shl,Shr
al4,ar4 hrtfstat a7,157.5,0,Shl,Shr
al5,ar5 hrtfstat a6,202.5,0,Shl,Shr
al6,ar6 hrtfstat a5,247.5,0,Shl,Shr
al7,ar7 hrtfstat a4,292.5,0,Shl,Shr
al8,ar8 hrtfstat a3,337.5,0,Shl,Shr
al = (al1+al2+al3+al4+al5+al6+al7+al8)/8
ar = (ar1+ar2+ar3+ar4+ar5+ar6+ar7+ar8)/8
end:
xout al,ar
endop
13.6 Conclusions
293
The separation between decoding and encoding can be very useful. For instance,
composers can create the spatial design for their pieces independently of the par-
ticular details of any performance location. Different decoded versions can then be
supplied for the speciﬁc conditions of each venue.
13.5.2 Vector Base Amplitude Panning
The simple amplitude panning of sources in stereo space (two channels), as imple-
mented for instance by the pan2 opcode, is extended for multiple channel setups
by the vector base amplitude panning (VBAP) method [104]. In amplitude panning,
the gains of each channel are determined so that the intensity difference (IID) causes
the sound to be localised somewhere between the loudspeakers (the active region).
VBAP uses a vector formulation to determine these gains based on the directions
of the speakers and the intended source position. One important aspect is that, for
a given source, localised at a given point, only two (horizontal plane only) or three
(horizontal and vertical planes) loudspeaker channels will be employed at one time.
In the former case (2D), the pair around the point, and in the latter case (3D), the
triplet deﬁning the active triangle within which the source is to be located will be
used.
In Csound, VBAP is implemented by the vbap and vbaplsinit opcodes. The
latter is used to deﬁne a loudspeaker layout containing the dimensions used (two or
three), the number of speakers, and their directional location in angles with respect
to the listener (or the centre of the circle/sphere):
vbaplsinit idim, inum, idir1, idir2[, idir3, ...]
The vbap opcode can then be used to pan a mono source sound:
ar1, ar2, [ar3,...] vbap asig,kazim[,kelev,
kspread,ilayout]
where kazim and kelev are the horizontal and vertical angles. An optional pa-
rameter kspread can be used to spread the source, causing more loudspeakers to
be active (the default 0 uses only the pair or triplet relative to the active region).
Note that loudspeaker positions can be set arbitrarily, and do not necessarily need to
conform to regular geometries.
13.6 Conclusions
In this chapter, we have explored the classic techniques of time-domain processing
in detail. We saw how the fundamental structure of the digital delay line is imple-
mented, and the various applications of ﬁxed delays, from echoes to component
reverberators, such as comb and all-pass ﬁlters. The design of a standard reverb was
294
13 Time-Domain Processing
outlined, and the principles of feedback delay networks and convolution reverb were
examined.
The various applications of variable delays were also detailed. The common LFO
modulation-based effects such as ﬂanger, chorus, and vibrato were presented to-
gether with their reference implementation as UDOs. The principle of the Doppler
effect and its modelling as a variable delay process was also explored. The discus-
sion of this class of effects was completed with a look at a standard delay-based
pitch-shifting algorithm.
The next section of the chapter was dedicated to the study of some aspects of
ﬁltering. We looked at an IIR design example, the second-order all-pass ﬁlter, and
its application in the phaser effect. This was complemented with an introduction to
equalisation, where a variable-band graphic equaliser UDO was discussed. The text
concluded with the topic of FIR ﬁlters and the principles behind their design, with
the application of some tools, such as the Fourier transform, that will be explored
further in the next chapter. We also saw how these types of ﬁlters can be used to
give spatial audio through binaural processing. An overview of basic techniques for
multichannel audio completed the chapter.
Time-domain techniques make up an important set of processes for the com-
puter musician’s arsenal. They provide a great variety of means to transform sounds,
which can be applied very effectively to music composition, sound design and pro-
duction. Together with the classic synthesis methods, they are one of the fundamen-
tal elements of computer music.