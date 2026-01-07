# 2. With these, we can run the tracking of sinusoidal partials that makes up the

2. With these, we can run the tracking of sinusoidal partials that makes up the
model:
ftrks partials
ffr,fphs,kthresh,imin,igap
The opcode takes two f-sigs containing amplitude, frequency and phase, as
produced by pvsifd, and outputs an f-sig containing sinusoidal track data
(PVS TRACKS format). This is a different format to a normal PV stream and
will only work with track-manipulating opcodes. The input parameters are as
follows: kthresh, an amplitude threshold used to control the partial tracking,
where partials below this will not be considered. It is deﬁned as a fraction of the
loudest partial. The imin determines the minimum number of detected peaks
at successive time points that will make up a track. For instance, imin = 1 will
make every peak make a track, higher values will imply waiting to see whether
a track emerges from a sequence of peaks. The igap parameter allows for a
number of gaps to exist in tracks before it is deﬁned as dead.
Streaming sinusoidal modelling consists of connecting these two opcodes to ob-
tain the track data. This can be further transformed, and then resynthesised using
additive synthesis.
14.5.1 Additive Synthesis
The additive resynthesis of sinusoidal tracks can be performed in various ways.
Csound implements three opcodes for this, which have slightly different character-
istics:
1. sinsyn: this synthesises tracks very faithfully, employing the phases in a cubic
interpolation algorithm to provide very accurate reconstruction. However, it is
not possible to scale frequencies with it. It is also slower than the other opcodes.
2. resyn: this opcode uses phases from track starting points, and cubic interpola-
tion, allowing frequency scaling.
3. tradsyn: an amplitude-frequency-only, linear-interpolation, additive synthe-
siser. It does not use phases, and it is more efﬁcient than its counterparts, although
not as accurate.
The ﬁrst opcode should be used whenever a precise resynthesis of the partial
tracks is required. The other two can be used with transformed data, but tradsyn
is the more ﬂexible of these, as it does not require correct phases to be preserved
anywhere in the stream.
In addition to these opcodes, it is also possible to convert the partial track stream
into a PV signal using the binit opcode:
324
14 Spectral Processing
fsig binit fin, isize
This converts the tracks into an equal-bandwidth bin-frame signal
(PVS AMP FREQ) with DFT size isize, which can be reconstructed with overlap-
add synthesis (pvsynth). It can also be further processed using streaming PV op-
codes. The conversion works by looking for suitable tracks to ﬁll each frequency
bin. If more than one track ﬁts a certain bin, the one with highest amplitude will be
used, and the other(s) discarded. PV synthesis can be more efﬁcient than the additive
methods, depending on the number of partials required.
14.5.2 Residual Extraction
Modelling in terms of sinusoids tends to limit the spectrum to stable components.
More transient and noisy parts are somewhat suppressed. This allows us to separate
the sinusoidal tracks from these other components, which are called the analysis
residual. The separation is done by employing sinsyn to reproduce the track data
accurately, and then performing a time-domain subtraction from the original signal
of its resynthesis. The result is what was not captured by the sinusoidal modelling.
This is implemented in listing 14.8.
Listing 14.8 Residual extraction using sinusoidal modelling of an input signal
/**************************************************
ares,asin Residual ain,kthresh,isize,ifcos
ares - residual output
asin - sinusoidal output
kthr - analysis threshold
isize - DFT size
ihop - hopsize
ifcos - function table containing a cosine wave
**************************************************/
opcode Residual, aa, akiii
ain,kthr,isiz,ihsiz,ifcos
xin
idel = isiz-ihsiz*(isiz/(2*ihsiz)-1)
ffr,fphs pvsifd
ain, isiz, ihsiz, 1
ftrk partials ffr, fphs,kthr, 1, 1, 500
aout sinsyn
ftrk, 2, 500, ifcos
asd
delayr
idel/sr
asig deltapn
idel
delayw
ain
aenv linsegr
0,idel/sr,0,1/sr,1,1,1
xout aout*aenv-asig,aout
endop
This code provides both the residual and the sinusoidal signals as output. The
sinusoidal modelling process places a small latency equivalent to N −h( N
2h −1),
14.5 Sinusoidal Modelling
325
where N is the DFT size, and h, the hopsize. So in order to align the signals (and
more importantly, their phases) correctly, we need to delay the input signal by this
amount. The sinsyn opcode also adds a small onset to the signal, starting before
the actual tracked sinusoids start playing, and so we apply an envelope to avoid any
bleed into the residual output. It is also important to supply the opcode with a cosine
wavetable, instead of a sine, otherwise the phases will be shifted by a quarter of a
cycle. Such a table can be created with GEN 9:
ifn ftgen 1,0,16384,9,1,1,90
The kthresh parameter can be used to adjust the tracking (a value of the order of
0.003 is a good start). The computational load will depend on both the input signal
and the threshold value. An input with many components will increase the resource
requirements, and reducing the kthresh parameter will also produce more par-
tials. In Fig. 14.15, we can see the waveform plot of a piano note sinusoidal model
and its residual. This latter captures very well the moment the hammer strikes the
string at the note onset.
Fig. 14.15 The normalised plots of the sinusoidal model (top) and residual (bottom) of a piano
sound. Note how the energy of the residual part is mostly concentrated at the note onset
326
14 Spectral Processing
14.5.3 Transformation
Various transformation opcodes are present in Csound to manipulate sinusoidal
tracks. They will take and produce f-sig variables in the PVS TRACKS format,
and will work in a similar fashion to the streaming PV opcodes.
trcross: this opcode takes two track signals and performs cross-synthesis of
amplitudes and frequencies. Note that this works in a different way to PV cross-
synthesis, as a search for matching tracks is used (since there are no bins to use
for matching):
trfilter: this implements track ﬁltering using an amplitude response taken
from a function table.
trhighest: the highest-frequency track is extracted from a streaming track
input signal.
trlowest: similarly, the lowest-frequency track is extracted.
trmix: this opcode mixes two partial track streams.
trscale: frequency scaling (transposition) of tracks.
trshift: frequency shifting (offsetting) of partials.
trsplit: this splits tracks into two streams depending on a k-rate frequency
threshold.
Transformations using partial track data can be very different from other spectral
processes. For certain processes, such as ﬁltering and selecting sub-sets of partials,
this data format is very ﬂexible. Also, due to the way the data is stored, synthesis
with limited numbers of tracks will provide a non-linear ﬁltering effect, resulting in
suppression of the shortest-living tracks.
14.6 Analysis Transformation and Synthesis
Each sound can be located on a continuous scale between harmonic and noisy. The
discrete Fourier transform is based upon the paradigm of harmonicity, so conse-
quently it has weaknesses in analysing and resynthesising noisy sounds or noisy
parts of natural sounds. In the previous section, sinusoidal modelling has been ex-
plained as one method to overcome this restriction. Analysis Transformation and
Synthesis (ATS) is another well-established method for the same goal [99]. It sep-
arates the sinusoidal (deterministic) part of a sound from its noisy (stochastic or
residual) part and offers different methods of resynthesis and transformation.
14.6.1 The ATS Analysis
Like in the other techniques which are described in this chapter, the analysis part
of ATS starts with performing a short-time Fourier transform (STFT). As real-time
14.6 Analysis Transformation and Synthesis
327
analysis is beyond the scope of ATS, there is no particular need for the efﬁciency of
the power-of-two FFT algorithm. This means that frames can be of any size, which
can be useful for some cases.2 Following the STFT, spectral peaks are detected for
each frame. Very similarly to the partial-tracking technique, these peaks are now
compared to each other, to extract spectral trajectories. The main difference can
be seen in the application of some psychoacoustic aspects, mainly the Signal-to-
Mask Ratio (SMR). Spectral peaks are compared from frame to frame. For creating
a track, they need to fall into a given maximum frequency deviation, and also ac-
complish other requirements, like not to be masked. The minimal number of frames
required to form a track can be set as an analysis parameter (default = 3), as can the
number of frames which will be used to “look back” for a possible peak candidate.
Tracks will disappear if they cannot ﬁnd appropriate peaks any more, and will be
created if new peaks arise.
These tracks are now resynthesised by additive synthesis, taking into also phase
information. This is important because the main goal of this step is to subtract this
deterministic part in the time domain from the signal as a whole (a process similar to
the one in listing 14.8 above). The residual, as the difference of the original samples
and its sinusoidal part, represents the noisy part of the signal. It is now analysed
using the Bark scale, which divides (again because of psychoacoustic reasons) the
range of human hearing into 25 critical bands.3 Noise analysis is performed, to get
the time-varying energy in each of the 25 bands of a Bark scale. This is done by
STFT again, using the same frame size as in the analysis of the deterministic part.
The full analysis process is outlined in Fig. 14.16. So, for the ATS resynthesis
model, sinusoidal and noise components can be blended into a single representation
as sinusoids plus noise-modulated sinusoids [99]:
Psynth = PampPsin +PnoiPsin
(14.7)
where Psynth is a synthesised partial, Psin its sinusoidal component, Pamp its amplitude
and Pnoi its noise component.
In MUSIC N, Pnoi is deﬁned as randi because it can be represented by a linear-
interpolation random generator. As it generates random numbers at a lower rate, it
can produce band-limited noise. The opcode randi produces a similar output, so
this formula is nearly literally Csound code:
Pnoi = randi(PE,Pbw)
(14.8)
where PE is the time-varying energy of the partial, and Pbw represents the spectral
bandwidth, used as the rate of the randi generator.
2 For instance, if we know the frequency of a harmonic sound, we can choose a window size which
is an integer multiple of the samples needed for the base frequency.
3 See the example in listing 14.12 for the Bark frequencies.
328
14 Spectral Processing
input
?
STFT
?
peaks
?
?
tracking

?
SMR
?
tracks
processing
psychoacoustic
?
tracks
synthesis

?
i

noise
?
analysis

?
bands
distribution
?
noise
Fig. 14.16 ATS analysis [99], taking in an input audio signal and producing noise in 25 perceptual
bands, sinusoid tracks containing amplitude, frequency and phase, and the signal-to-mask ratio
(SMR)
14.6.2 The ATS Analysis File Format
Both parts of the analysis are stored in the analysis ﬁle. The sinusoidal trajectories
are stored in the usual way, specifying the amplitude, frequency and phase of each
partial. In the corresponding frame, the residual energy is analysed in 25 critical
bands which represent the way noisy sounds are recognised in pitch relations. So
one frame stores this information for N partials:
amp 1 freq 1 phase 1
amp 2 freq 2 phase 2
...
amp N freq N phase N
residual energy for critical band 1
residual energy for critical band 2
...
residual energy for critical band 25
The number of partials very much depends on the input sound. A sine wave
will produce only one partial, a piano tone some dozen, and complex sounds some
hundreds, depending on the analysis parameters.
In Csound, ATS analysis is performed with the utility ATSA. The various anal-
ysis parameters differ from the usual STFT settings in many ways and should be
tweaked by the analysis to really “meet” an individual sound. They have been de-
14.6 Analysis Transformation and Synthesis
329
scribed implicitly above and are in detail described in the manual. Not setting these
sixteen parameters but using the defaults instead, the command line for analysing
the “fox.wav” looks like this:
$ csound -U atsa fox.wav fox.ats
The content of the “fox.ats” analysis ﬁle can be queried by the ATSinfo opcode,
which returns:
Sample rate = 44100 Hz
Frame Size = 2205 samples
Window Size = 8821 samples
Number of Partials = 209
Number of Frames = 58
Maximum Amplitude = 0.151677
Maximum Frequency = 15884.540555 Hz
Duration = 2.756667 seconds
ATS file Type = 4 (footnote)
The default value of 20 Hz for the minimum frequency leads to the huge frame
size of 2,205 samples, which in the case of “fox.ats” results in smeared transitions.
Setting the minimum frequency to 100 Hz and the maximum frequency to 10,000
Hz has this effect:
$ csound -U atsa -l 100 -H 10000 fox.wav fox.ats
Frame Size =
441 samples
Window Size =
1765 samples
Number of Partials = 142
Number of Frames = 278
Maximum Amplitude = 0.407017
Maximum Frequency = 9974.502118 Hz
The time resolution is better now and will offer better results for the resynthesis.
We will use this ﬁle (“fox.ats”) in the following examples as basic input to show
some transformations.
14.6.3 Resynthesis of the Sinusoidal Part
There are basically two options to resynthesise the deterministic part of the sound:
ATSread and ATSadd. The opcode ATSread returns the amplitude and fre-
quency of one single partial. This is quite similar to using the pvread opcode
(or for streaming use, the pvsbin opcode), which returns a single FFT bin. The
difference between the two can be seen clearly here: the frequency of the bin moves
rapidly, whilst a partial in ATS stays at a certain pitch, just fading in or out.4
4 The maximum frequency deviation is 1
10 of the previous frequency as default.
330
14 Spectral Processing
kfreq, kamp ATSread ktimepnt, iatsfile, ipartial
The following example uses the frequency and amplitude output of ATSread to
create an arpeggio-like structure. The frequencies of the tones are those from partials
5, 7, 9, ..., 89. The start of one note depends on the maximum of a single partial track.
This maximum amplitude is queried ﬁrst by the check max instrument and written
to the appropriate index of the gkPartMaxAmps array. A note is then triggered
by p trigger when this maximum minus idBdiff (here 2 dB) is crossed. In
case this threshold is passed again from below later, a new tone is triggered. The
result will very much depend on the threshold: for idBdiff = 1 we will only
get one note per partial, for idBdiff = 6 already several. Both check max and
p trigger are called by partial arp in as many instances as there are partials
to be created. The percussive bit, played by the pling instrument, is nothing more
than one sample which is fed into a mode ﬁlter. The amplitude of the sample is the
amplitude returned by ATSread at this point. The frequency is used as the resonant
frequency of the ﬁlter, and the quality of the ﬁlter is inversely proportional to the
amplitude, thus giving the soft tones more resonance than the stronger ones.
Listing 14.9 ATS partials triggering an arpeggio-like structure
gS_ats = "fox.ats"
giDur ATSinfo gS_ats, 7 ;duration
giLowPart = 5 ;lowest partial used
giHighPart = 90 ;highest partial used
giOffset = 2 ;increment
gkPartMaxAmps[] init giHighPart+1
instr partial_arp
p3 = giDur*5 ;time stretch
iCnt = giLowPart
while iCnt <= giHighPart do
;check maximum in each partial and write in array
schedule "check_max", 0, 1, iCnt
;call instr to play a note if threshold is crossed
schedule "p_trigger", 0, p3, iCnt
iCnt += giOffset
od
;create time pointer for all instances of p_trigger
gkTime line 0, p3, giDur
endin
instr check_max
kMaxAmp, kTim init 0
while kTim < giDur do
kFq,kAmp ATSread kTim, gS_ats, p4
kMaxAmp = kAmp > kMaxAmp ? kAmp : kMaxAmp
kTim += ksmps/sr
14.6 Analysis Transformation and Synthesis
331
od
gkPartMaxAmps[p4] = dbamp(kMaxAmp)
turnoff
endin
instr p_trigger
idBdiff = 2
kMax = gkPartMaxAmps[p4] ;get max of this partial (dB)
kPrevAmp init 0
kState init 0 ;0=below, 1=above thresh
kFq,kAmp ATSread gkTime, gS_ats, p4
if kAmp > kPrevAmp &&
dbamp(kAmp) > kMax-idBdiff &&
kState == 0 then
event "i", "pling", 0, p3*2, kFq, kAmp
kState = 1
elseif kAmp < kPrevAmp &&
dbamp(kAmp) < kMax-idBdiff &&
kState == 1 then
kState = 0
endif
kPrevAmp = kAmp
endin
instr pling
aImp mpulse p5*3, p3
aFilt mode aImp, p4, 1/p5*50
out aFilt
endin
schedule("partial_arp",0,1)
Rather than creating a number of sound generators on our own, we can use the
opcode ATSadd to perform additive resynthesis by driving a number of interpolat-
ing oscillators. We can choose how many partials to use, starting at which offset and
with which increment, and a gate function can be applied to modify the amplitudes
of the partials.
ar ATSadd ktimepnt, kfmod, iatsfile, ifn, ipartials
[,ipartialoffset, ipartialincr, igatefn]
Like ATSread and similar opcodes, ktimepnt requires a time pointer (in
seconds) and iatsfile the ATS analysis ﬁle. The kfmod parameter offers a
transposition factor (1 = no transposition), and ipartials is the total num-
ber of partials which will be resynthesised by a bank of interpolating oscillators.
Setting ipartialoffset to 10 will resynthesise starting at partials 11, and
ipartialincr = 2 will skip partial 12, 14, ... . The optional gate function
igatefn scales the amplitudes in the way that the x-axis of the table represents
332
14 Spectral Processing
analysed amplitude values (normalised 0 to 1), and the y-axis sets a multiplier which
is applied. So this table will leave the analysis results untouched:
giGateFun ftgen
0, 0, 1024, 7, 1, 1024, 1
The next table will only leave partials with full amplitude unchanged. It will
reduce lower amplitudes progressively, and eliminate partials with amplitudes below
0.5 (-6 dB relative to the maximum amplitude):
giGateFun ftgen
0, 0, 1024, 7, 0, 512, 0, 512, 1
The next table will boost amplitudes from 0 to 0.125 by multiplying by 8, and
then attenuate partials more and more from 0.125 to 1:
giGateFun ftgen
0, 0, 1024, -5, 8, 128, 8, 896, 0.001
So, similarly to the pvstencil opcode, a mask can be laid on a sound by the
shape of this table. But unlike pvstencil, this will only affect the sinusoidal part.
14.6.4 Resynthesis of the Residual Part
The basic opcodes to resynthesise the residual part of the sound are ATSreadnz
and ATSaddnz. Similarly to the ATSread/ATSadd pair, ATSreadnz returns
the information about one single element of the analysis, whilst ATSaddnz offers
access to either the whole noisy part, or a selection of it. The main difference to
ATSread is that we now deal with the 25 noise bands, instead of partials.
The ATSreadnz opcode returns the energy of a Bark band at a certain time:
kenergy ATSreadnz ktimepnt, iatsfile, iband
The kenergy output represents the intensity; so following the relation I = A2
following A =
√
I we will use the square root of the kenergy output to obtain
proper amplitude values. This code resynthesises the noise band using randi.
Listing 14.10 ATS resynthesis of one noise band
gS_ats = "fox.ats"
giDur ATSinfo gS_ats, 7 ;duration
instr noise_band
iBand = 5 ;400..510 Hz
p3 = giDur
ktime line 0, giDur, giDur
kEnergy ATSreadnz ktime, gS_ats, iBand
aNoise randi sqrt(kEnergy), 55
aSine poscil .25, 455
out aNoise*aSine
endin
schedule("noise_band",0,1)
14.6 Analysis Transformation and Synthesis
333
And this resynthesises all noise bands together:
Listing 14.11 ATS resynthesis of all noise bands in standard manner
gS_ats = "fox.ats"
giDur ATSinfo gS_ats, 7
giBark[] fillarray 0,100,200,300,400,510,630,770,920,
1080,1270,1480,1720,2000,2320,2700,
3150,3700,4400,5300,6400,
7700,9500,12000,15500,20000
instr noise_bands
p3 = giDur
gktime line 0, giDur, giDur
iBand = 1
until iBand > 25 do
iBw = giBark[iBand] - giBark[iBand-1]
iCfq = (giBark[iBand] + giBark[iBand-1]) / 2
schedule "noise_band", 0, giDur, iBand, iBw, iCfq
iBand += 1
od
endin
instr noise_band
kEnergy ATSreadnz gktime, gS_ats, p4
aNoise randi sqrt(kEnergy), p5
out aNoise * poscil:a(.2, p6)
endin
schedule("noise_bands",0,1)
The ATS analysis data can be used for other noise generators, and further trans-
formations can be applied. In the following example, we change the way the time
pointer moves in the noise bands master instrument. Instead of a linear pro-
gression processed by the line opcode, we use transeg to get a concave shape.
This leads to a natural ritardando, in musical terms. The noise band gauss in-
strument, one instance of which is called per noise band, uses a gaussian random
distribution to generate noise. This is then ﬁltered by a mode ﬁlter, which simulates
a mass-spring-damper system. To smooth the transitions in proportion to the tempo
of the time pointer, the portk opcode is applied to the kEnergy variable, thus
creating a reverb-like effect at the end of the sound.
Listing 14.12 ATS resynthesis noise bands with modiﬁcations
gS_ats = "fox.ats"
giDur ATSinfo gS_ats, 7 ;duration
giBark[] fillarray 0,100,200,300,400,510,630,770,920,
1080,1270,1480,1720,2000,2320,2700,
3150,3700,4400,5300,6400,7700,9500,
334
14 Spectral Processing
12000,15500,20000
instr noise_bands
p3 = giDur*5
gkTime transeg 0, p3, -3, giDur
iBand = 1
until iBand > 23 do ;limit because of mode max freq
iBw = giBark[iBand] - giBark[iBand-1]
iCfq = (giBark[iBand] + giBark[iBand-1]) / 2
schedule "noise_band_gauss", 0, p3, iBand, iBw, iCfq
iBand += 1
od
endin
instr noise_band_gauss
xtratim 2
kEnergy ATSreadnz gkTime, gS_ats, p4
aNoise gauss sqrt(portk(kEnergy,gkTime/20))
aFilt mode aNoise, p6, p6/p5
out aFilt/12
endin
schedule("noise_bands",0,1)
So, like ATSread, ATSreadnz has its own qualities as it gives us actual access
to the analysis data, leaving the application to our musical ideas.
ATSaddnz is designed to resynthesise the noise amount of a sound, or a selec-
tion of it. The usage is very similar to the ATSadd opcode. The total number of
noise bands can be given (ibands), as well as an offset (ibandoffset) and an
increment (ibandincr):
ar ATSaddnz ktimepnt, iatsfile, ibands[, ibandoffset,
ibandincr]
The resynthesis works internally with the randi facility as described above, so
the main inﬂuence on the resulting sound is the number and position of noise bands
we select.
14.6.5 Transformations
We have already seen several transformations based on an ATS analysis ﬁle. The
time pointer can be used to perform time compression/expansion or any irregular
movement. We can select partials and noise bands by setting their number, offset
and increment, and we can transpose the frequencies of the deterministic part by
a multiplier. The ATSsinnoi opcode combines all these possibilities in a very
compact way, as it adds the noise amount of a speciﬁc Bark region to the partials
14.6 Analysis Transformation and Synthesis
335
which fall in this range. Consequently, we do not specify any noise band, but only
the partials; but the sinus/noise mix can be controlled via the time-varying variables
ksinlev and knzlev:
ar ATSsinnoi ktimepnt, ksinlev, knzlev, kfmod,
iatsfile, ipartials[, ipartialoffset, ipartialincr]
Cross-synthesis is a favourite form of spectral processing. ATS offers cross-
synthesis only for the deterministic part of two sounds. The ﬁrst sound has to be
given by an ATSbufread unit. So the syntax is:
ATSbufread ktimepnt1, kfmod1, iatsfile1,
ipartials1 [, ipartialoffset1, ipartialincr1]
ar ATScross ktimepnt2, kfmod2, iatsfile2, ifn,
klev2, klev1,
ipartials2 [, ipartialoffset2, ipartialincr2]
ATSbufread has the same qualities as ATSadd, except that it reads an .ats
analysis ﬁle in a buffer which is then available to be used as ﬁrst sound by
ATScross. In the example below, its time pointer ktimepnt1 reads the
iatsfile1 “fox.ats” from 1.67 seconds to the end: “over the lazy dog” are
the words here. Extreme time stretching is applied (about 100:1) and the pitch
(kfmod1) moves slowly between factor 0.9 and 1.1, with linear interpolation and a
new value every ﬁve seconds. This part of the sound is now crossed with a slightly
time-shifted variant of itself, as the ATScross opcode adds a random deviation
between 0.01 and 0.2 seconds to the same time pointer. This deviation is also slowly
moving by linear interpolation. Both sounds use a quarter of the overall partials;
the ﬁrst with a partial offset of 1 and an increment of 3, the second sound with-
out offset and an increment of 2. The level of the ﬁrst (kLev1) and the second
(kLev2) sound are also continuously moving, between 0.2 and 0.8 as maxima. The
result is an always changing structure of strange accords, sometimes forming quasi-
harmonic phases, sometimes nearly breaking into pieces.
Listing 14.13 ATS cross-synthesis with a time-shifted version of the same sound
gS_file = "fox.ats"
giPartials ATSinfo gS_file, 3
giFilDur ATSinfo gS_file, 7
giSine ftgen 0, 0, 65536, 10, 1
instr lazy_dog
kLev1 randomi .2, .8, .2
kLev2 = 1 - kLev1
kTimPnt linseg 1.67, p3, giFilDur-0.2
ATSbufread kTimPnt, randi:k(.1,.2,0,1),
gS_file, giPartials/4, 1, 3
aCross ATScross kTimPnt+randomi:k(0.01,0.2,0.1), 1,
gS_file, giSine, kLev2,
kLev1, giPartials/4, 0, 2
336
14 Spectral Processing
outs aCross*2
endin
schedule("lazy_dog",0,100)
14.7 Conclusions
In this chapter, we have explored the main elements of spectral processing supported
by Csound. Starting with an overview of the principles of Fourier analysis, and a tour
of the most relevant tools for frequency-domain analysis and synthesis, we were able
to explore the fundamental bases on which the area is grounded. This was followed
by a look at how ﬁlters can take advantage of Fourier transform theory, for their
design and fast implementation. The technique of partitioned convolution was also
introduced, with an example showing the zero-latency use of multiple partitions.
The text dedicated signiﬁcant space to the phase vocoder and its streaming imple-
mentation in Csound. We have detailed how the algorithm is constructed by imple-
menting the analysis and synthesis stages from ﬁrst principles. The various different
types of transformations that can be applied to PV data were presented, with exam-
ples of Csound opcodes that implement these.
A discussion of the principles of sinusoidal modelling completed the chapter.
We introduced the frequency analysis and partial-tracking operations involved, as
well as the variants of additive synthesis available to reconstruct a time-domain
signal. Residual extraction was demonstrated with an example, and a suite of track
manipulation opcodes was presented. In addition to this, ATS, a specialised type of
spectral modelling using sinusoidal tracking, was introduced and explored in some
detail. Spectral processing is a very rich area for sonic exploration. It provides a
signiﬁcant ground for experimentation in the design of novel sounds and processes.
We hope that this chapter provides an entry point for readers to sample the elements
of frequency-domain sound transformation.