# Chapter 15

Chapter 15
Granular Synthesis
Abstract In this chapter, we will look at granular synthesis and granular effects
processing. The basic types of granular synthesis are discussed, and the inﬂuence
of parameter variations on the resulting sound is shown with examples. For gran-
ular effects processing on a live input stream, we write the input sound to a buffer
used as a source waveform for synthesising grains, enabling granular delays and
granular reverb designs. We proceed to look at manipulations of single grains by
means of grain masking, and look at aspects of gradual synchronisation between
grain-scheduling clocks. The relationship between regular amplitude modulation
and granular synthesis is studied, and we use pitch synchronous granular synthesis
to manipulate formants of a recorded sound. Several classic types of granular syn-
thesis are known from the literature, originally requiring separate granular synthesis
engines for each type. We show how to implement all granular synthesis types with
a single generator (the partikkel opcode), and a parametric automation to do
morphing between them.
15.1 Introduction
Granular synthesis (or particle synthesis as it is also called) is a very ﬂexible form of
audio synthesis and processing, allowing for a wide range of sounds. The technique
works by generating small snippets (grains) of sound, typically less than 300∼400
milliseconds each. The grains may have an envelope to fade each snippet in and out
smoothly, and the assembly of a large number of such grains makes up the resulting
sound. An interesting aspect of the technique is that it lends itself well to gradual
change between a vast range of potential sounds. The selection and modiﬁcation of
the sound fragments can yield highly distinctive types of sounds, and the large num-
ber of synthesis parameters allows very ﬂexible control over the sonic output. The
underlying process of assembling small chunks of sound stays basically the same,
but the shape, size, periodicity and audio content of grains may be changed dynam-
ically. Even if the potential sounds can be transformed and gradually morphed from
© Springer International Publishing Switzerland 2016
V. Lazzarini et al., Csound, DOI 10.1007/978-3-319-45370-5_15
337
338
15 Granular Synthesis
one type to another, it can be useful to describe some of the clearly deﬁned types
of sound we can attain. These types represent speciﬁc combinations of parameter
settings, and as such represent some clearly deﬁned locations in the multidimen-
sional sonic transformation space. Curtis Roads made a thorough classiﬁcation of
different granular techniques in his seminal book Microsound [109]. Roads’ book
inspired the design of the Csound opcode partikkel, as a uniﬁed generator for
all forms of time-based granular sound [22]. We will come back to Roads’ classi-
ﬁcation later, but will start with a more general division of the timbral potential of
granular techniques. The one aspect of the techniques that has perhaps the largest
impact on the resulting sound is the density and regularity of the grains. Because of
this, we will do a coarse classiﬁcation of the types of sounds based on this criteria.
This coarse division is based on the perceptual threshold between rhythm and tone:
below approximately 20 Hz, we tend to hear separate events and rhythm; when the
repetition rate is higher the events blend together and create a continuous tone. The
boundary is not sharp, and there are ways of controlling the sound production so
as to avoid static pitches even with higher grain rates. Still it serves us as a general
indication of the point where the sound changes function.
15.1.1 Low Grain Rates, Long Grains
When we have relatively few grains per second (< 50) and each grain is relatively
long (> 50 milliseconds), then we can clearly hear the timbre and pitch of the sound
in each grain. In this case the output sound is largely determined by the waveform in-
side each grain. This amounts to quickly cross-fading between segments of recorded
sound, and even though the resulting texture may be new (according to the selec-
tion and combination of sounds), the original sounds used as source material for
the grains are clearly audible. Csound has a large selection of granular synthesis
opcodes. The partikkel opcode has by far the highest ﬂexibility, as it was de-
signed to enable all forms of time-based granular synthesis. There are also simpler
opcodes available that might be easier to use in speciﬁc use cases. The following
two examples accomplish near identical results, showing granular synthesis ﬁrst
with syncgrain, then with partikkel.
Listing 15.1 Example using syncgrain
giSoundfile ftgen 0,0,0,1,"fox.wav",0,0,0
giSigmoWin ftgen 0,0,8193,19,1,0.5,270,0.5
instr 1
kprate linseg 1,2.3,1,0,-0.5,2,-0.5,0,1,1,1
kGrainRate = 25.0
kGrainDur = 2.0
kgdur = kGrainDur/kGrainRate
kPitch = 1
15.1 Introduction
339
a1 syncgrain ampdbfs(-8),kGrainRate,kPitch,kgdur,
kprate/kGrainDur,giSoundfile,giSigmoWin,100
out a1
endin
schedule(1,0,5.75)
Listing 15.2 Example using partikkel
giSoundfile ftgen 0,0,0,1,"fox.wav",0,0,0
giSine ftgen 0,0,65536,10,1
giCosine ftgen 0,0,8193,9,1,1,90
giSigmoRise ftgen 0,0,8193,19,0.5,1,270,1
giSigmoFall ftgen 0,0,8193,19,0.5,1,90,1
instr 1
asamplepos1 linseg 0,2.3,0.84,2,0.478,1.47,1.0
kGrainRate = 25.0
async = 0.0 ; (disable external sync)
kGrainDur = 2.0
kgdur = (kGrainDur*1000)/kGrainRate
kwavfreq = 1
kwavekey1 = 1/(tableng(giSoundfile)/sr)
awavfm = 0 ; (FM disabled)
a1 partikkel kGrainRate,0,-1,async,0,-1,
giSigmoRise,giSigmoFall,0,0.5,kgdur,
ampdbfs(-13),-1,kwavfreq,0.5,-1,-1,awavfm,
-1,-1,giCosine,1,1,1,-1,0,\
giSoundfile,giSoundfile,giSoundfile,giSoundfile,-1,
asamplepos1,asamplepos1,asamplepos1,asamplepos1,
kwavekey1,kwavekey1,kwavekey1,kwavekey1,100
out a1
endin
schedule(1,0,5.75)
As can be seen from the two above examples, syncgrain requires less code
and may be preferable for simple cases. The partikkel opcode provides more
ﬂexibility and thus also requires a bit more code. One notable difference between
the two opcodes for this simple case is that the time pointer into the source waveform
is handled differently. Syncgrain uses a rate of time pointer movement speciﬁed
in relation to grain duration. Partikkel uses a time pointer value as a fraction
of the source waveform duration. Syncgrain’s method can be more convenient if
the time pointer is to move at a determined rate through the sound. Partikkel’s
time pointer is more convenient if one needs random access to the time point. For the
340
15 Granular Synthesis
remaining examples in this chapter, partikkel will be used due to its ﬂexibility
to do all different kinds of granular synthesis.
The next example shows a transition from a time pointer moving at a constant
rate, then freezing in one spot, then with increasingly random deviation from that
spot. The global tables from listing 15.2 are used.
Listing 15.3 Example with random access time pointer
instr 1
asamplepos1 linseg 0,1.2,0.46,1,0.46
adeviation rnd31 linseg(0,1.3,0,2,0.001,2,
0.03,1,0.2,1,0.2),1
asamplepos1 = asamplepos1 + adeviation
kGrainRate = 30.0
async = 0.0 ; (disable external sync)
kGrainDur = 3.0
kgdur = (kGrainDur*1000)/kGrainRate
kwavfreq = 1
kwavekey1 = 1/(tableng(giSoundfile)/sr)
awavfm = 0 ; (FM disabled)
a1 partikkel kGrainRate,0,-1,async,0,-1,
giSigmoRise,giSigmoFall,0,0.5,kgdur,
ampdbfs(-13),-1,kwavfreq,0.5,-1,-1,awavfm,
-1,-1,giCosine,1,1,1,-1,0,
giSoundfile,giSoundfile,giSoundfile,giSoundfile,-1,
asamplepos1,asamplepos1,asamplepos1,asamplepos1,
kwavekey1,kwavekey1,kwavekey1,kwavekey1,100
out a1
endin
15.1.2 High Grain Rates, Periodic Grain Clock
When the grain rate is high (> 30∼50 Hz) and strictly periodic, we will in most
cases hear a pitch with fundamental frequency equal to the grain rate. Any sound
that is periodic (the exact same thing happening over and over again at regular in-
tervals) will constitute a clearly deﬁned pitch, and the pitch is deﬁned by the rate
of repetition. If the contents of our individual grains are identical, the output wave-
form will have a repeating pattern over time (as illustrated in Fig 15.1), and so also
constitute a clearly perceptible pitch. It is noteworthy that very precise exact repeti-
tion is a special case that sounds very different from cases where repetitions are not
exact. The constitution of pitch is quite fragile, and deviations from the periodicity
will create an unclear or noisy pitch (which of course might be exactly what we
want sometimes). In the case of high grain rate with short grains, the audio content
of each grain is not perceivable in and as itself. Then the waveform content of the
15.1 Introduction
341
grain will affect the timbre (harmonic structure), but not the perceived pitch since
pitch will be determined by the rate of repetition (i.e. the grain rate). More details
on this are given in Section 15.5. The following example shows the use of a high
grain rate to constitute pitch.
Listing 15.4 Example with high grain rate, pitch constituted by grain rate
instr 1
kamp adsr 0.0001, 0.3, 0.5, 0.5
kamp = kamp*ampdbfs(-6)
asamplepos1 = 0
kGrainRate = cpsmidinn(p4)
async = 0.0 ; (disable external sync)
kGrainDur = 1.0
kgdur = (kGrainDur*1000)/kGrainRate
ka_d_ratio = p5
kwavfreq line 200, p3, 500
kwavekey1 = 1
awavfm = 0 ; (FM disabled)
a1 partikkel kGrainRate, 0, -1, async, 0, -1,
giSigmoRise, giSigmoFall, 0, ka_d_ratio, kgdur,
kamp, -1, kwavfreq, 0.5, -1, -1, awavfm,
-1, -1, giCosine, 1, 1, 1, -1, 0,
giSine, giSine, giSine, giSine, -1,
asamplepos1,asamplepos1,asamplepos1,asamplepos1,
kwavekey1, kwavekey1, kwavekey1, kwavekey1, 100
out
a1
endin
schedule(1,0,1,48,0.5)
schedule(1,1,1,51,0.5)
schedule(1,2,1,53,0.5)
schedule(1,3,1,55,0.5)
schedule(1,4,3,58,0.5)
schedule(1,8,1,48,0.1)
schedule(1,9,1,51,0.1)
schedule(1,10,1,53,0.1)
schedule(1,11,1,55,0.1)
schedule(1,12,3,58,0.1)
342
15 Granular Synthesis
Fig. 15.1 Close-up of a grain waveform, repeating grains constitute a stable pitch
15.1.3 Grain Clouds, Irregular Grain Clock
When the grain generation is very irregular, usually also combined with ﬂuctuations
in the other parameters (e.g. pitch, phase, duration) the resulting sound will have tur-
bulent characteristics and is often described as a cloud of sound. This is a huge class
of granular sound with a large scope for variation. Still, the irregular modulation
creates a perceptually grouped collection of sounds.
Listing 15.5 Example of a sparse grain cloud
instr 1
kamp
adsr 2, 1, 0.5, 2
kamp
= kamp*ampdbfs(-10)
asamplepos1 = 0
kGrainRate = randh(30,30)+32
async = 0.0 ; (disable external sync)
kGrainDur = randh(0.5,30)+0.7
kgdur = (kGrainDur*1000)/kGrainRate
ka_d_ratio = 0.2
kwavfreq = randh(300,30)+400
kwavekey1 = 1
awavfm = 0 ; (FM disabled)
a1 partikkel kGrainRate, 0, -1, async, 0, -1,
giSigmoRise, giSigmoFall, 0, ka_d_ratio, kgdur,
kamp, -1, kwavfreq, 0.5, -1, -1, awavfm,
-1, -1, giCosine, 1, 1, 1, -1, 0,
giSine, giSine, giSine, giSine, -1,
asamplepos1,asamplepos1,asamplepos1,asamplepos1,
kwavekey1, kwavekey1, kwavekey1, kwavekey1, 100
out a1
endin
schedule(1,0,6)
Listing 15.6 If we change these lines of code, we get a somewhat denser grain cloud
kGrainRate = randh(80,80)+100
15.2 Granular Synthesis Versus Granular Effects Processing
343
kgdur = 30 ; use static grain size (in millisecs)...
;...so we comment out the relative
;
grain dur calculation
; kgdur = (kGrainDur*1000)/kGrainRate;
kwavfreq = randh(100,80)+300
15.2 Granular Synthesis Versus Granular Effects Processing
By granular synthesis, we usually mean a granular technique applied to synthesised
or pre-recorded source sounds. If we use a live audio stream as the source of our
grains, we use the term granular effects processing. Technically, the creation of au-
dio grains is the same in both cases, only the source material for grains differs.
Applying granular techniques to a live audio stream allows us the rich transforma-
tional potential of granular synthesis while retaining the immediacy and interactivity
of a live audio effect. To record live audio into a table for use as a source waveform,
we use the tablewa opcode, as outlined in listing 15.7. This is a circular buffer,
and to control the delay time incurred by the difference between record (write) and
playback (read) positions in the table, we write the record pointer to a global k-rate
variable (gkstartFollow). We will reference this value when calculating the read po-
sition for creating grains. Also note that the global variable 0dbfs must be set to 1,
otherwise the system will blow up when using feedback in the granular processing.
Listing 15.7 Record live audio to table, for use as a source waveform for granular processing
0dbfs = 1
; audio buffer table for granular effects processing
giLiveFeedLen = 524288 ; 11.8 seconds buffer at 44.1
giLiveFeedLenSec = giLiveFeedLen/sr
giLiveFeed ftgen 0, 0, giLiveFeedLen+1, 2, 0
instr 1
a1 inch 1
aFeed chnget "partikkelFeedback"
kFeed = 0.4
a1 = a1 + (aFeed*kFeed)
iLength = ftlen(giLiveFeed)
gkstartFollow tablewa giLiveFeed, a1, 0
; reset kstart when table is full
gkstartFollow = (gkstartFollow > (giLiveFeedLen-1) ?
0 : gkstartFollow)
; update table guard point (for interpolation)
tablegpw giLiveFeed
endin
344
15 Granular Synthesis
15.2.1 Grain Delay
For all the granular-processing effects, the live stream is recorded into a circular
buffer (listing 15.7), from which the individual grains are read. The difference be-
tween the record and playback positions within this buffer will affect the time it
takes between sound being recorded and played back, and as such allows us to con-
trol the delay time. With partikkel the read position is set with the samplepos
parameter. This is a value in range 0.0 to 1.0, referring to the relative position within
the source audio waveform. A samplepos value of 0.5 thus means that grains will
be read starting from the middle of the source sound. Delay time in seconds can be
calculated as samplepos × buffer length in seconds. We must make sure not to
read before the record pointer (which could easily happen if we use random devia-
tions from zero delay time with the circular buffer). Otherwise we will create clicks
and also play back audio that is several seconds (buffer length) delayed in relation
to what we expected. Crossing the record pointer boundary will also happen if we
use zero delay time and upwards transposition in the grains. In this situation, we
start reading at the same table address as where we write audio, but we read faster
than we write, and the read pointer will overtake the write pointer. To avoid this, we
need to add a minimum delay time as a factor of pitch × duration for the grains we
want to create. When manipulating and modulating the time pointer into this circular
buffer, we may want to smooth it out and upsample to a-rate at the ﬁnal stage before
processing. This requires special care, as we do not want to ﬁlter the ramping signal
when it resets from 1.0 to 0.0. For this purpose we can use a UDO (listing 15.8), do-
ing linear interpolation during upsampling of all sections of the signal except when
it abruptly changes from high to low. If we did regular interpolation, the time pointer
would sweep fast through the whole buffer on phase reset, and any grains scheduled
to start during this sweep would contain unexpected source audio (see Fig 15.2)
Listing 15.8 UDO for interpolated upsampling of the time pointer in the circular buffer
gikr = kr
opcode UpsampPhasor, a,k
kval xin
setksmps 1
kold init 0
if (abs(kold-kval)<0.5) && (abs(kold-kval)>0) then
reinit interpolator
elseif abs(kold-kval)>0.5 then; when phasor restarts
kold = kold-1
reinit interpolator
endif
interpolator:
aval linseg i(kold), 1/gikr, i(kval), 1/gikr, i(kval)
rireturn
kold = kval
xout aval
15.2 Granular Synthesis Versus Granular Effects Processing
345
endop
Fig. 15.2 Upsampling a k-rate time pointer (samplepos), we need to disable interpolation on
phase reset to avoid reading the table quickly backwards when the phase wraps around
For granular effects processing, the grain rate is usually low, as we are interested
in hearing the timbral content of the live audio stream. One interesting aspect of
granular delays is that a change in the delay time does not induce pitch modulation,
as is common with traditional delay techniques. This allows us separate control over
delay time and pitch, and also to scatter grains with differing time and pitch relations
into a continuous stream of echo droplets. Writing the output of the grain delay
process back into the circular buffer (mixed with the live input) allows for grain
delay feedback, where the same transformational process is applied repeatedly and
iteratively on the same source material. This can create cascading effects.
Listing 15.9 Simple grain delay with feedback and modulated delay time
instr 2
; grain clock
kGrainRate = 35.0
async
= 0.0
; grain shape
kGrainDur = 3.0
kduration = (kGrainDur*1000)/kGrainRate
; grain pitch (transpose, or "playback speed")
kwavfreq = 1
kfildur1 = tableng(giLiveFeed) / sr
kwavekey1 = 1/kfildur1
awavfm = 0
; automation of the grain delay time
ksamplepos1 linseg 0, 1, 0, 2, 0.1, 2,
346
15 Granular Synthesis
0.1, 2, 0.2, 2, 0, 1, 0
kpos1Deviation randh 0.003, kGrainRate
ksamplepos1 = ksamplepos1 + kpos1Deviation
; Avoid crossing the record boundary
ksamplepos1 limit ksamplepos1,
(kduration*kwavfreq)/(giLiveFeedLenSec*1000),1
; make samplepos follow the record pointer
ksamplepos1
=
(gkstartFollow/giLiveFeedLen) - ksamplepos1
asamplepos1 UpsampPhasor ksamplepos1
asamplepos1 wrap asamplepos1, 0, 1
a1
partikkel kGrainRate, 0, -1, async, 0, -1,
giSigmoRise, giSigmoFall, 0, 0.5, kduration, 0.5, -1,
kwavfreq, 0.5, -1, -1, awavfm,
-1, -1, giCosine, 1, 1, 1,
-1, 0, giLiveFeed, giLiveFeed,
giLiveFeed, giLiveFeed, -1,
asamplepos1,asamplepos1,asamplepos1,asamplepos1,
kwavekey1, kwavekey1, kwavekey1, kwavekey1, 100
; audio feedback in granular processing
aFeed dcblock a1
chnset aFeed, "partikkelFeedback"
out a1*ampdbfs(-6)
endin
Listing 15.10 Grain delay with four-voice pitching and scattered time modulations
instr 2
; grain clock
kGrainRate = 35.0
async
= 0.0
; grain shape
kGrainDur = 2.0
kduration = (kGrainDur*1000)/kGrainRate
; different pitch for each source waveform
kwavfreq = 1
kfildur1 = tableng(giLiveFeed) / sr
kwavekey1 = 1/kfildur1
15.2 Granular Synthesis Versus Granular Effects Processing
347
kwavekey2 = semitone(-5)/kfildur1
kwavekey3 = semitone(4)/kfildur1
kwavekey4 = semitone(9)/kfildur1
awavfm = 0
; grain delay time, more random deviation
ksamplepos1 = 0
kpos1Deviation randh 0.03, kGrainRate
ksamplepos1 = ksamplepos1 + kpos1Deviation
; use different delay time for each source waveform
; (actually same audio, but read at different pitch)
ksamplepos2 = ksamplepos1+0.05
ksamplepos3 = ksamplepos1+0.1
ksamplepos4 = ksamplepos1+0.2
; Avoid crossing the record boundary
#define RecordBound(N)#
ksamplepos$N. limit ksamplepos$N.,
(kduration*kwavfreq)/(giLiveFeedLenSec*1000),1
; make samplepos follow the record pointer
ksamplepos$N.
=
(gkstartFollow/giLiveFeedLen) - ksamplepos$N.
asamplepos$N. UpsampPhasor ksamplepos$N.
asamplepos$N. wrap asamplepos$N., 0, 1
#
$RecordBound(1)
$RecordBound(2)
$RecordBound(3)
$RecordBound(4)
; activate all 4 source waveforms
iwaveamptab ftgentmp 0, 0, 32, -2, 0, 0, 1,1,1,1,0
a1
partikkel kGrainRate, 0, -1, async, 0, -1,
giSigmoRise, giSigmoFall, 0, 0.5, kduration, 0.5, -1,
kwavfreq, 0.5, -1, -1, awavfm,
-1, -1, giCosine, 1, 1, 1,
-1, 0, giLiveFeed, giLiveFeed, giLiveFeed, giLiveFeed,
iwaveamptab, asamplepos1, asamplepos2,
asamplepos3, asamplepos4,
kwavekey1, kwavekey2, kwavekey3, kwavekey4, 100
; audio feedback in granular processing
aFeed dcblock a1
chnset aFeed, "partikkelFeedback"
348
15 Granular Synthesis
out a1*ampdbfs(-3)
endin
15.2.2 Granular Reverb
We can use granular techniques to create artiﬁcial reverberant effects [37]. These
are not necessarily directed towards modelling real acoustic spaces, but provide a
very ﬂexible tool for exploring novel and imaginary reverberant environments. As
traditional artiﬁcial reverb techniques are based on delay techniques, so are granular
reverbs based on granular delays. In addition to complex delay patters, we can also
exploit the independence of time and pitch in granular synthesis to create forms of
time stretching of the live stream. Time stretching is something that would be highly
unlikely to occur in an acoustic space, but since reverberation can also be heard as a
certain prolongation of the sound, we can associate this type of transformation with
a kind of reverb. When time stretching a live signal we quickly run into a practical
problem. Time stretching involves gradually increasing the delay time between input
and output, and if the sound is to be perceived as a “immediately slowed down”,
there is a limit to the actual delay we want to have before we can hear the slowed
down version of the sound. To alleviate this increasing delay time, we use several
overlapping time stretch processes, fading a process out when the delay has become
too large for our purposes and simultaneously fading a new process in (resetting the
delay to zero for the new process). See Fig. 15.3 and listing 15.11.
Fig. 15.3 Time pointers and source wave amps for time stretching real-time input. Each of the four
stretched segments constitutes a granular process on a source waveform for partikkel
Listing 15.11 Granular reverb skeleton: four-voice overlapping time stretch
instr 2
15.2 Granular Synthesis Versus Granular Effects Processing
349
; grain clock
kGrainRate = 110.0
async
= 0.0
; grain shape
kGrainDur = 7.0
kduration = (kGrainDur*1000)/kGrainRate
; same pitch for all source waveforms
kwavfreq = 1
kfildur1 = tableng(giLiveFeed) / sr
kwavekey1 = 1/kfildur1
awavfm = 0
; grain delay time,
; gradually increasing delay time
; to create slowdown effect.
kplaybackspeed = 0.25 ; slow down
koverlaprate = 0.8 ; overlap rate
koverlap = 1 ; amount of overlap between layers
; four overlapping windows of slowdown effect,
; fading in and out,
; reset delay time to zero on window boundaries
#define Overlaptime(N’P)#
koverlaptrig$N. metro koverlaprate, $P.
if koverlaptrig$N. > 0 then
reinit timepointer$N.
endif
timepointer$N.:
ksamplepos$N. line 0, i(kfildur1),
1-i(kplaybackspeed)
itimenv$N. divz i(koverlap), i(koverlaprate), .01
kampwav$N. oscil1i itimenv$N.*0.1, 1,
itimenv$N., giSigmoWin
rireturn
#
$Overlaptime(1’0.0)
$Overlaptime(2’0.25)
$Overlaptime(3’0.50)
$Overlaptime(4’0.75)
ktimedev = 4/(giLiveFeedLenSec*1000)
#define TimeDeviation(N)#
kdevpos$N. rnd31 ktimedev, 1
350
15 Granular Synthesis
ksamplepos$N. = ksamplepos$N.+kdevpos$N.
#
$TimeDeviation(1)
$TimeDeviation(2)
$TimeDeviation(3)
$TimeDeviation(4)
; Avoid crossing the record boundary
#define RecordBound(N)#
ksamplepos$N. limit ksamplepos$N.,
(kduration*kwavfreq)/(giLiveFeedLenSec*1000),1
; make samplepos follow the record pointer
ksamplepos$N.
=
(gkstartFollow/giLiveFeedLen) - ksamplepos$N.
asamplepos$N. UpsampPhasor ksamplepos$N.
asamplepos$N. wrap asamplepos$N., 0, 1
#
$RecordBound(1)
$RecordBound(2)
$RecordBound(3)
$RecordBound(4)
; channel masking table, send grains alternating to
; left and right output, for stereo reverb
ichannelmasks ftgentmp 0, 0, 16, -2, 0, 1, 0, 1
; activate all 4 source waveforms
iwaveamptab ftgentmp 0, 0, 32, -2, 0, 0, 1,1,1,1,0
; write amp envelope for overlapping
; slowdown windows to wave mix mask table
tablew kampwav1, 2, iwaveamptab
tablew kampwav2, 3, iwaveamptab
tablew kampwav3, 4, iwaveamptab
tablew kampwav4, 5, iwaveamptab
a1, a2
partikkel kGrainRate, 0, -1, async, 0, -1,
giSigmoRise, giSigmoFall, 0, 0.5, kduration, 1, -1,
kwavfreq, 0.5, -1, -1, awavfm,
-1, -1, giCosine, 1, 1, 1, ichannelmasks,
0, giLiveFeed, giLiveFeed, giLiveFeed, giLiveFeed,
iwaveamptab, asamplepos1, asamplepos2,
asamplepos3, asamplepos4,
kwavekey1, kwavekey1, kwavekey1, kwavekey1, 100
15.2 Granular Synthesis Versus Granular Effects Processing
351
; audio feedback in granular processing
aFeed dcblock a1
; empirical adjustment of feedback
; scaling for stability
aFeed = aFeed*0.86
chnset aFeed, "partikkelFeedback"
outs a1*ampdbfs(-6), a2*ampdbfs(-6)
endin
Adding feedback, i.e. routing the output from the granular slowdown process
back into the live recording buffer, we get a longer and more diffuse reverb tail.
In the following example, we used a somewhat less extreme slowdown factor, and
also increased the random deviation to the time pointer. As is common in artiﬁcial
reverb algorithms, we’ve also added a low-pass ﬁlter in the feedback path, so high
frequencies will decay faster than lower spectral components.
Listing 15.12 Granular reverb with feedback and ﬁltering: listing only the differences from list-
ing 15.11
kFeed = 0.3
...
kplaybackspeed = 0.35 ; slow down
...
ktimedev = 12/(giLiveFeedLenSec*1000)
...
aFeed butterlp aFeed, 10000
We can also add a small amount of pitch modulation to the reverb. This is a
common technique borrowed from algorithmic reverb design, to allow for a more
rounded timbre in the reverb tail.
Listing 15.13 Granular reverb with pitch modulation: listing only the differences from list-
ing 15.12. Of the partikkel parameters, only the four wavekeys have been changed
kFeed = 0.5
...
kpitchmod = 0.005
#define PitchDeviation(N)#
kpitchdev$N. randh kpitchmod, 1, 0.1
kwavekey$N. = 1/kfildur1*(1+kpitchdev$N.)
#
$PitchDeviation(1)
$PitchDeviation(2)
$PitchDeviation(3)
$PitchDeviation(4)
...
a1, a2
partikkel kGrainRate, 0, -1, async, 0, -1,
352
15 Granular Synthesis
giSigmoRise, giSigmoFall, 0, 0.5, kduration, 1, -1,
kwavfreq, 0.5, -1, -1, awavfm,
-1, -1, giCosine, 1, 1, 1, ichannelmasks,
0, giLiveFeed, giLiveFeed, giLiveFeed, giLiveFeed,
iwaveamptab, asamplepos1, asamplepos2,
asamplepos3, asamplepos4,
kwavekey1, kwavekey2, kwavekey3, kwavekey4, 100
Exploiting the independence of time and pitch transformations in granular syn-
thesis, we can also create reverb effects with shimmering harmonic tails or we can
create tails that have a continually gliding pitch. The design will normally need at
least one granular process for each pitch-shifted component. In our example we are
still using a single (four-voice) grain generator, creating a simple and raw version of
the effect at a very low computational cost. We do pitch shifting on a grain-by-grain
basis (with pitch masking, every third grain is transposed, see Section 15.3) instead
of using a separate granular voice for each pitch. As a workaround to get a rea-
sonably dense reverb with this simple design, we use very long grains. To get ﬁner
control over the different spectral components and also denser reverb, we could use
several granular generators, feeding into each other.
Listing 15.14 Granular reverb, some grains are pitch shifted up an octave, creating a shimmering
reverb tail: listing only the differences from listing 15.13. Of the partikkel parameters, only
the iwavfreqstarttab and iwavfreqendtab values have been changed
kFeed = 0.7
...
kGrainDur = 12.0
...
kplaybackspeed = 0.25 ; slow down
...
; pitch masking tables
iwavfreqstarttab ftgentmp 0, 0, 16, -2, 0, 2, 1,1,2
iwavfreqendtab ftgentmp 0, 0, 16, -2, 0, 2, 1,1,2
...
a1, a2
partikkel kGrainRate, 0, -1, async, 0, -1,
giSigmoRise, giSigmoFall, 0, 0.5, kduration, 1, -1,
kwavfreq, 0.5, iwavfreqstarttab, iwavfreqendtab,
awavfm, -1, -1, giCosine, 1, 1, 1, ichannelmasks,
0, giLiveFeed, giLiveFeed, giLiveFeed, giLiveFeed,
iwaveamptab, asamplepos1, asamplepos2,
asamplepos3, asamplepos4,
kwavekey1, kwavekey2, kwavekey3, kwavekey4, 100
...
aFeed butterlp aFeed, 8000
aFeed = aFeed*0.6
The observant reader may have noticed that we have a speciﬁcation of feedback
level in two different places in the code. Also, that these two operations essentially
15.3 Manipulation of Individual Grains
353
do the same thing (effecting the level of audio feedback in the granular process). The
rationale for this is to provide an intuitive control over the feedback level, affecting
the reverberation time, much like in FDN reverbs (see Section 13.2.3). We assume
that one would expect such a reverb algorithm to have (an approximation of) inﬁnite
reverb time when feedback is set to 1.0. This intuitive feedback level control is the
ﬁrst one (kFeed = 0.7). The second adjustment (aFeed = aFeed*0.6) can
be viewed as a system parameter that needs to be recalculated when the reverb
design changes. The speciﬁcs of the granular processing can signiﬁcantly change
the gain of the signal. No automatic method for adjustment has been provided here,
but we can state that the gain structure is mainly dependent on the amount of grain
overlap, as well as pitch and time deviations for single grains. The grain overlap is
easily explained due to more layers of sound generally creating a higher amplitude.
The pitch and time deviations affect the feedback potential negatively, e.g. changing
the pitch of the signal in the feedback loop effectively lowers the potential for sharp
resonances. For the reverb designs presented here, the feedback scaling was adjusted
empirically by setting kFeed = 1.0 and then adjusting aFeed = X until an
approximation of inﬁnite reverb time was achieved. Due to the presence of random
elements (for time and pitch modulation) the effective feedback gain will ﬂuctuate,
especially so in the design we have used here with only one granular generator.
Using more generators will make a more complex delay network, and the resulting
effect of random ﬂuctuations of parameters will be more even.
15.3 Manipulation of Individual Grains
In a regular granular synthesis situation, we may generate tens or hundreds of grains
per second. For precise control over the synthesis result, we may want to modify
each of these grains separately. To facilitate this, we can use a technique called
grain masking. In Microsound [109] the term is used to describe selective muting
of individual grains, implying an amplitude control that may also be gradual. By
extending the notion of grain masking to also include pitch trajectories, frequency
modulation, output channel and source waveform mixing, we can also extend the
range of control possibilities over the individual grains. At high grain rates, any kind
of masking will affect the perceived pitch. This is because masking even a single
grain affects the periodicity of the signal (see listing 15.15). Masking single grains
intermittently will add noise to the timbre; masking every second grain will let the
perceived pitch drop by one octave, as the repetition period doubles (listing 15.17).
Further subharmonics may be generated by dropping every third, fourth or ﬁfth
grain and so on. These pitch effects will occur regardless of which grain parameter
is masked, but the timbral effect will differ somewhat with the masking of different
parameters (listing 15.19). At lower grain rates, the masking techniques can be used
to create elaborate rhythmic, spatial and harmonic patterns. If we use different mask
lengths, we can achieve polyrhythmic relationships between the masking patterns
of different parameters. This is quite effective to add vividness and complexity to a
354
15 Granular Synthesis
timbral evolution. In Csound’s partikkel opcode, grain masking is speciﬁed by
a masking table (ﬁgs. 15.4 and 15.5). The masking table is read incrementally when
generating grains, so values next to each other in the table will apply to neighbouring
grains successively. As most grain-masking patterns are periodic, the masking table
index can be looped at user-speciﬁed indices. For non-periodic patterns, we can
simply use arbitrarily large masking tables or rewrite the table values continuously.
Fig. 15.4 Amplitude masking table, the two ﬁrst indices control loop start and end, the remaining
indices are amplitude values for each successive grain. Table values can be modiﬁed in real time
to create dynamically changing patterns
Fig. 15.5 Amplitude masking using the mask table shown in Fig. 15.4
Listing 15.15 Synchronous granular synthesis with high grain rate and increasing amount of ran-
dom masking during each note
instr 1
kamp adsr 0.0001, 0.3, 0.5, 0.5
kamp = kamp*ampdbfs(-6)
asamplepos1 = 0
kGrainRate = cpsmidinn(p4)
async
= 0.0 ; (disable external sync)
kGrainDur = 1.0
kgdur
= (kGrainDur*1000)/kGrainRate
ka_d_ratio = 0.5
15.3 Manipulation of Individual Grains
355
kwavfreq = kGrainRate*4
kwavekey1 = 1
awavfm = 0 ; (FM disabled)
krandommask line 0, p3, p5
a1 partikkel kGrainRate, 0, -1, async, 0, -1,
giSigmoRise, giSigmoFall, 0, ka_d_ratio, kgdur,
kamp, -1, kwavfreq, 0.5, -1, -1, awavfm,
-1, -1, giCosine, 1, 1, 1, -1, krandommask,
giSine, giSine, giSine, giSine, -1,
asamplepos1,asamplepos1,asamplepos1,asamplepos1,
kwavekey1, kwavekey1, kwavekey1, kwavekey1, 100
out a1
endin
Listing 15.16 Score for the instrument in listing 15.15
i1 0 2 48 0.3
i1 2 . 51 .
i1 4 . 53 .
i1 6 4 60 .
s
i1 0 2 48 1.0
i1 2 . 51 .
i1 4 . 53 .
i1 6 4 60 .
Listing 15.17 Synchronous granular synthesis with high grain rate, gradually decreasing the am-
plitude of every second grain during each note, creating an octaviation effect
instr 1
kamp adsr 0.0001, 0.3, 0.5, 0.5
kamp = kamp*ampdbfs(-6)
asamplepos1 = 0
kGrainRate = cpsmidinn(p4)
async = 0.0 ; (disable external sync)
kGrainDur = 0.5
kgdur = (kGrainDur*1000)/kGrainRate
ka_d_ratio = 0.5
kwavfreq = kGrainRate*2
kwavekey1 = 1
awavfm = 0 ; (FM disabled)
krandommask = 0
igainmasks ftgen 0, 0, 4, -2, 0, 1, 1, 1
koctaviation linseg 1, 0.5, 1, p3-0.5 , 0
tablew koctaviation, 2, igainmasks
a1 partikkel kGrainRate, 0, -1, async, 0, -1,
356
15 Granular Synthesis
giSigmoRise, giSigmoFall, 0, ka_d_ratio, kgdur,
kamp, igainmasks, kwavfreq, 0.5, -1, -1, awavfm,
-1, -1, giCosine, 1, 1, 1, -1, krandommask,
giSine, giSine, giSine, giSine, -1,
asamplepos1,asamplepos1,asamplepos1,asamplepos1,
kwavekey1, kwavekey1, kwavekey1, kwavekey1, 100
out a1
endin
Listing 15.18 Score for the instrument in listing 15.17
i1 0 2 48
i1 2 . 51
i1 4 . 53
i1 6 4 60
Listing 15.19 As above (listing 15.17), but this time using pitch masks to create the octaviation
effect. The pitch of every second grain is gradually changed, ending at an octave above. Still, the
perceived pitch drops by one octave, since the rate of repetition is doubled when every second grain
is different. Use the score in listing 15.18
instr 1
kamp adsr 0.0001, 0.3, 0.5, 0.5
kamp = kamp*ampdbfs(-6)
asamplepos1 = 0
kGrainRate = cpsmidinn(p4)
async = 0.0 ; (disable external sync)
kGrainDur = 0.5
kgdur = (kGrainDur*1000)/kGrainRate
ka_d_ratio = 0.5
kwavfreq = kGrainRate*2
kwavekey1 = 1
awavfm = 0 ; (FM disabled)
krandommask = 0
; pitch masking tables
iwavfreqstarttab ftgentmp 0, 0, 16, -2, 0, 1, 1,1
iwavfreqendtab ftgentmp 0, 0, 16, -2, 0, 1, 1,1
koctaviation linseg 1, 0.5, 1, p3-0.5 , 2
tablew koctaviation, 2, iwavfreqstarttab
tablew koctaviation, 2, iwavfreqendtab
a1 partikkel kGrainRate, 0, -1, async, 0, -1,
giSigmoRise, giSigmoFall, 0, ka_d_ratio, kgdur,
kamp, -1, kwavfreq, 0.5,
iwavfreqstarttab, iwavfreqendtab, awavfm,
15.3 Manipulation of Individual Grains
357
-1, -1, giCosine, 1, 1, 1, -1, krandommask,
giSine, giSine, giSine, giSine, -1,
asamplepos1, asamplepos1, asamplepos1, asamplepos1,
kwavekey1, kwavekey1, kwavekey1, kwavekey1, 100
out a1
endin
15.3.1 Channel Masks, Outputs and Spatialisation
Using masking techniques with parameters such as amplitude, pitch and modulation
is unambiguous: we can always describe exactly what effect they will have on the
resulting sound. With channel masking, the situation is somewhat different. Channel
masking describes which output channel (of the grain generator) this grain should
be sent to. The partikkel opcode in Csound can use up to eight audio outputs,
and the masking values can also be fractional, distributing the sound between two
outputs. Now, what we do with the sound at each output is arbitrary. We may dis-
tribute the audio signals to different locations in the listening space, or we might
process each output differently. As an example, we might send every ﬁfth grain to a
reverb while we pan every other grain right and left, and create a bank of ﬁlters and
send grains to each of the ﬁlters selectively (listing 15.20). We could also simply
route the eight outputs to eight different speakers to create a granular spatial im-
age in the room. If we need more than eight separate outputs, several instances of
partikkel can be linked and synchronised by means of the partikkelsync
opcode. See Section 15.4 for more details.
Listing 15.20 Example of channel masking, every second grain routed to stereo left and right,
every ﬁfth grain to reverb, and routing of random grains to a high-pass and a low-pass ﬁlter
nchnls = 2
giSine ftgen 0, 0, 65536, 10, 1
giCosine ftgen 0, 0, 8193, 9, 1, 1, 90
; (additive) saw wave
giSaw ftgen 0, 0, 65536, 10, 1, 1/2, 1/3, 1/4, 1/5,
1/6, 1/7, 1/8,
1/9, 1/10, 1/11, 1/12, 1/13,
1/14, 1/15, 1/16, 1/17, 1/18, 1/19, 1/20
giSigmoRise ftgen 0, 0, 8193, 19, 0.5, 1, 270, 1
giSigmoFall ftgen 0, 0, 8193, 19, 0.5, 1, 90, 1
instr 1
kamp = ampdbfs(-12)
asamplepos1 = 0
kGrainRate transeg p4, 0.5, 1, p4, 4, -1, p5, 1, 1, p5
async = 0.0 ; (disable external sync)
358
15 Granular Synthesis
kGrainDur = 0.5
kgdur = (kGrainDur*1000)/kGrainRate
ka_d_ratio = 0.5
kwavfreq = 880
kwavekey1 = 1
awavfm = 0 ; (FM disabled)
krandommask = 0
; channel masking table,
; output routing for individual grains
; (zero based, a value of 0.0 routes to output 1)
; output 0 and 1 are used for stereo channels L and R,
; output 2 and 3 for reverb left and right
; output 4 and 5 is sent to two different filters
ichannelmasks ftgentmp 0, 0, 16, -2, 0, 9,
0, 1, 0, 1, 2, 1, 0, 1, 0, 3
; randomly route some grains (mask index 4 or 5)
; to the first filter
kfilt1control randh 1, kGrainRate, 0.1
kfilt1trig = (abs(kfilt1control) > 0.2 ? 4 : 0)
kfilt1trig =
(abs(kfilt1control) > 0.6 ? 5 : kfilt1trig)
if kfilt1trig > 0 then
tablew 4, kfilt1trig, ichannelmasks ; send to output 4
else
tablew 0, 4, ichannelmasks ; reset to original values
tablew 1, 5, ichannelmasks
endif
; randomly route some grains (mask index 9 or 10)
; to the second filter
kfilt2control randh 1, kGrainRate, 0.2
kfilt2trig = (abs(kfilt2control) > 0.2 ? 9 : 0)
kfilt2trig =
(abs(kfilt2control) > 0.6 ? 10 : kfilt2trig)
if kfilt2trig > 0 then
tablew 5, kfilt2trig, ichannelmasks ; send to output 5
else
tablew 1, 9, ichannelmasks ; reset to original values
tablew 0, 10, ichannelmasks
endif
a1,a2,a3,a4,a5,a6 partikkel kGrainRate, 0, -1, async,
0, -1, giSigmoRise, giSigmoFall, 0, ka_d_ratio,
15.3 Manipulation of Individual Grains
359
kgdur, kamp, -1, kwavfreq, 0.5, -1, -1, awavfm,
-1, -1, giCosine, 1, 1, 1, ichannelmasks,
krandommask, giSaw, giSaw, giSaw, giSaw, -1,
asamplepos1, asamplepos1, asamplepos1,asamplepos1,
kwavekey1, kwavekey1, kwavekey1, kwavekey1, 100
outs a1,a2
chnset a3, "reverbLeft"
chnset a4, "reverbRight"
chnset a5, "filter1"
chnset a6, "filter2"
endin
instr 11
a1 chnget "reverbLeft"
a2 chnget "reverbRight"
ar1,ar2 freeverb a1,a2, 0.8, 0.3
idry = 0.2
ar1 = ar1+(a1*idry)
ar2 = ar2+(a2*idry)
outs ar1,ar2
a0 = 0
chnset a0, "reverbLeft"
chnset a0, "reverbRight"
endin
instr 12
a1 chnget "filter1"
a2 chnget "filter2"
afilt1 butterlp a1, 800
afilt2 butterhp a2, 2000
asum = afilt1+afilt2
outs asum, asum
a0 = 0
chnset a0, "filter1"
Listing 15.21 Score for the instrument in listing 15.20
i1 0 20 330 6
360
15 Granular Synthesis
15.3.2 Waveform Mixing
We can also use grain masking to selectively alter the mix of several source sounds
for each grain. With partikkel, we can use ﬁve source sounds: four sampled
waveforms and a synthesised trainlet (see section 15.7.3 for more on trainlets). Each
mask in the waveform mix masking table will then have ﬁve values, representing the
amplitude of each source sound. In addition to the usual types of masking effects, the
waveform mixing technique is useful for windowed-overlap-type techniques such
as we saw in granular reverb time stretching. In that context we combine waveform
mixing with separate time pointers for each source waveform, so we can fade in
and out the different layers of time delay (in the source waveform audio buffer) as
needed.
Listing 15.22 Example of source waveform mixing, rewriting the amplitude values for each source
wave in a single wave mask
giSoundfile ftgen 0, 0, 0, 1,"fox.wav",0,0,0
giSine ftgen 0, 0, 65536, 10, 1
giCosine ftgen 0, 0, 8193, 9, 1, 1, 90
; (additive) saw wave
giSaw ftgen 0, 0, 65536, 10, 1, 1/2, 1/3, 1/4, 1/5,
1/6, 1/7, 1/8,
1/9, 1/10, 1/11, 1/12, 1/13,
1/14, 1/15, 1/16, 1/17, 1/18, 1/19, 1/20
giNoiseUni ftgen 0, 0, 65536, 21, 1, 1
giNoise ftgen 0, 0, 65536, 24, giNoiseUni, -1, 1
giSigmoRise ftgen 0, 0, 8193, 19, 0.5, 1, 270, 1
giSigmoFall ftgen 0, 0, 8193, 19, 0.5, 1, 90, 1
instr 1
kamp = ampdbfs(-3)
kwaveform1 = giSine
kwaveform2 = giSaw
kwaveform3 = giNoise
kwaveform4 = giSoundfile
asamplepos1 = 0.0 ; phase of single cycle waveform
asamplepos2 = 0.0
asamplepos3 = 0.0
asamplepos4 = 0.27; start read position in sound file
kGrainRate = 8
async = 0.0 ; (disable external sync)
kGrainDur = 1.0
kgdur = (kGrainDur*1000)/kGrainRate
ka_d_ratio = 0.5
kwavfreq = 1 ; set master transposition to 1
; source 1 and 2 are single cycle source waveforms,
15.3 Manipulation of Individual Grains
361
; so the pitch is determined by cycles per second
kwavekey1 = 440 ; (a single cycle sine)
kwavekey2 = 440 ; (a single cycle saw)
; source 3 and 4 are tables with audio sample data,
; so the playback frequency should be relative to
; table length and sample rate
kwavekey3 = 1/(tableng(kwaveform3)/sr); (noise at sr)
kwavekey4 = 1/(tableng(kwaveform4)/sr); (soundfile)
awavfm = 0 ; (FM disabled)
krandommask = 0
; wave mixing by writing to the wave mask table
iwaveamptab ftgentmp 0, 0, 32, -2, 0, 0, 1,0,0,0,0
kamp1 linseg 1, 1, 1, 1, 0, 5, 0, 1, 1, 1, 1
kamp2 linseg 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0
kamp3 linseg 0, 3, 0, 1, 1, 1, 1, 1, 0, 1, 0
kamp4 linseg 0, 5, 0, 1, 1, 1, 1, 1, 0, 1, 0
tablew kamp1, 2, iwaveamptab
tablew kamp2, 3, iwaveamptab
; we do additional scaling of source 3 and 4,
; to make them appear more equal in loudness
tablew kamp3*0.7, 4, iwaveamptab
tablew kamp4*1.5, 5, iwaveamptab
a1 partikkel kGrainRate, 0, -1, async, 0, -1,
giSigmoRise, giSigmoFall, 0, ka_d_ratio,
kgdur, kamp, -1, kwavfreq, 0.5, -1, -1,
awavfm, -1, -1, giCosine, 1, 1, 1, -1,
krandommask, kwaveform1, kwaveform2,
kwaveform3, kwaveform4, iwaveamptab,
asamplepos1, asamplepos2, asamplepos3,
asamplepos4,
kwavekey1, kwavekey2,
kwavekey3, kwavekey4, 100
out a1
endin
schedule(1,0,10)
Listing 15.23 Example of source waveform masking, changing to a new source waveform for each
new grain
giSoundfile ftgen 0, 0, 0, 1,"fox.wav",0,0,0
giSine ftgen 0, 0, 65536, 10, 1
giCosine ftgen 0, 0, 8193, 9, 1, 1, 90
; (additive) saw wave
362
15 Granular Synthesis
giSaw ftgen 0, 0, 65536, 10, 1, 1/2, 1/3, 1/4, 1/5,
1/6, 1/7, 1/8,
1/9, 1/10, 1/11, 1/12, 1/13,
1/14, 1/15, 1/16, 1/17, 1/18, 1/19, 1/20
giNoiseUni ftgen 0, 0, 65536, 21, 1, 1
giNoise ftgen 0, 0, 65536, 24, giNoiseUni, -1, 1
giSigmoRise ftgen 0, 0, 8193, 19, 0.5, 1, 270, 1
giSigmoFall ftgen 0, 0, 8193, 19, 0.5, 1, 90, 1
instr 1
kamp = ampdbfs(-3)
kwaveform1 = giSine
kwaveform2 = giSaw
kwaveform3 = giNoise
kwaveform4 = giSoundfile
asamplepos1 = 0.0 ; phase of single cycle waveform
asamplepos2 = 0.0
asamplepos3 = 0.0
asamplepos4 = 0.27; start read position in sound file
kGrainRate transeg 400, 0.5, 1, 400, 4,
-1, 11, 1, 1, 11
async = 0.0 ; (disable external sync)
kGrainDur = 1.0
kgdur = (kGrainDur*1000)/kGrainRate
ka_d_ratio = 0.5
kwavfreq = 1
kwavekey1 = 440
kwavekey2 = 440
kwavekey3 = 1/(tableng(kwaveform3)/sr)
kwavekey4 = 1/(tableng(kwaveform4)/sr)
awavfm = 0 ; (FM disabled)
krandommask = 0
; wave masking, balance of source waveforms
; specified per grain
iwaveamptab ftgentmp 0, 0, 32, -2, 0, 3, 1,0,0,0,0,
0,1,0,0,0,
0,0,1,0,0,
0,0,0,1,0
a1 partikkel kGrainRate, 0, -1, async, 0, -1,
giSigmoRise, giSigmoFall, 0, ka_d_ratio,
kgdur, kamp, -1, kwavfreq, 0.5, -1, -1,
awavfm, -1, -1, giCosine, 1, 1, 1, -1,
krandommask, kwaveform1, kwaveform2,
15.4 Clock Synchronisation
363
kwaveform3, kwaveform4, iwaveamptab,
asamplepos1, asamplepos2, asamplepos3,
asamplepos4,
kwavekey1, kwavekey2,
kwavekey3, kwavekey4, 100
out a1
endin
15.4 Clock Synchronisation
Most granular synthesisers use an internal clock to trigger generation of new
grains. To control the exact placement of grains in time, we might sometimes
need to manipulate this clock. Grain displacement can be done simply with the
kdistribution parameter of partikkel, offsetting individual grains in time
within a period of 1/grainrate.
Listing 15.24 Using the kdistribution parameter of partikkel, individual grains are dis-
placed in time within a time window of 1/grainrate. The stochastic distribution can be set with
the idisttab table. The following is an excerpt of code that can be used for example with the
example in listing 15.4. See also Figure 15.6 for an illustration
...
kdistribution line 0, p3-1, 1
idisttab ftgen 0, 0, 32768, 7, 0, 32768, 1
...
a1 partikkel kGrainRate, kdistribution, idisttab, ...
For more elaborate grain clock patterns and synchronisations we can manipulate
the internal clock directly. The partikkel opcode uses a sync input and sync
output to facilitate such clock manipulation, and these can also be used to synchro-
nise several partikkel generators if need be. The internal clock is generated by
a ramping value, as is common in many digital metronomes and oscillators. The
internal ramping value is updated periodically, and the exact increment determines
the steepness of the ramp. The ramping value normally starts at zero, and when it
exceeds 1.0 a clock pulse is triggered, and the ramp value is reset to zero. The sync
input to partikkel lets us directly manipulate the ramping value, and offsetting
this value directly affects the time until the next clock pulse. Figure 15.7 provides an
illustration of this mechanism. Sync output from partikkel is done via the helper
opcode partikkelsync. This opcode is linked to a particular partikkel in-
stance by means of an opcode ID. The partikkelsync instance then has in-
ternal access to the grain scheduler clock of a partikkel with the same ID. It
outputs the clock pulse and the internal ramping value, and these can be used to
directly drive other partikkel instances, or to synchronise external clocks using
the same ramping technique. The ramping value is the phase of the clock, and this
364
15 Granular Synthesis
Fig. 15.6 Grain distribution, showing periodic grain periods on top, random displacements at bot-
tom
can be used to determine whether we should nudge the clock up or down towards
the nearest beat.
Listing
15.25 Soft
synchronisation
between
two
partikkel
instances,
using
partikkelsync to get the clock phase and clock tick, then nudging the second clock
up or down towards the nearest clock tick from partikkel instance 1
instr 1
iamp = ampdbfs(-12)
kamp linen iamp, 0.01, p3, 1
asamplepos1 = 0
kGrainRate1 = 7
async = 0.0 ; (disable external sync)
kGrainDur = 1.0
kgdur1 = (kGrainDur*1000)/kGrainRate1
ka_d_ratio = 0.1
kwavfreq1 = 880
kwavekey1 = 1
awavfm = 0 ; (FM disabled)
id1 = 1
a1 partikkel kGrainRate1, 0, -1, async, 0, -1,
giSigmoRise, giSigmoFall, 0, ka_d_ratio, kgdur1,
15.4 Clock Synchronisation
365
1, -1, kwavfreq1, 0.5, -1, -1, awavfm,
-1, -1,
giCosine, 1, 1, 1, -1, 0, giSine, giSine, giSine,
giSine, -1, asamplepos1, asamplepos1, asamplepos1,
asamplepos1, kwavekey1, kwavekey1, kwavekey1,
kwavekey1, 100, id1
async1, aphase1 partikkelsync, id1
kphaSyncGravity line 0, p3, 0.7
aphase2 init 0
asyncPolarity limit (int(aphase2*2)*2)-1, -1, 1
asyncStrength =
abs(abs(aphase2-0.5)-0.5)*asyncPolarity
; Use the phase of partikkelsync instance 2 to find
; sync polarity for partikkel instance 2.
; If the phase of instance 2 is less than 0.5,
; we want to nudge it down when synchronizing,
; and if the phase is > 0.5 we
; want to nudge it upwards.
async2in = async1*kphaSyncGravity*asyncStrength
kGrainRate2 = 5
kgdur2 = (kGrainDur*1000)/kGrainRate2
kwavfreq2 = 440
id2 = 2
a2 partikkel kGrainRate2, 0, -1, async2in, 0, -1,
giSigmoRise, giSigmoFall, 0, ka_d_ratio, kgdur2,
1, -1, kwavfreq2, 0.5, -1, -1, awavfm, -1, -1,
giCosine, 1, 1, 1, -1, 0, giSine, giSine, giSine,
giSine, -1, asamplepos1, asamplepos1 asamplepos1,
asamplepos1, kwavekey1, kwavekey1, kwavekey1,
kwavekey1, 100, id2
async2, aphase2 partikkelsync, id2
; partikkel instance 1 outputs to the left
; instance 2 outputs to the right
Listing 15.26 Gradual synchronisation. As in listing 15.25, but here we also adjust the grain rate
of partikkel instance 2 to gradually approach the rate of clock pulses from instance 1. This
leads to a quite musical rhythmic gravitation, attracting instance 2 to the pulse of instance 1.
instr 1
iamp = ampdbfs(-12)
kamp linen iamp, 0.01, p3, 1
asamplepos1 = 0
366
15 Granular Synthesis
Fig. 15.7 Soft synchronisation between two clocks, showing the ramp value of each clock and
sync pulses from clock 1 nudging the phase of clock 2. Sync pulses are scaled by sync strength, in
this case increasing strength, forcing clock 2 to synchronise with clock 1
kGrainRate1 = 7
async = 0.0 ; (disable external sync)
kGrainDur = 1.0
kgdur1 = (kGrainDur*1000)/kGrainRate1
ka_d_ratio = 0.1
kwavfreq1 = 880
kwavekey1 = 1
awavfm = 0 ; (FM disabled)
id1 = 1
a1 partikkel kGrainRate1, 0, -1, async, 0, -1,
giSigmoRise, giSigmoFall, 0, ka_d_ratio, kgdur1,
1, -1, kwavfreq1, 0.5, -1, -1, awavfm,
-1, -1,
giCosine, 1, 1, 1, -1, 0, giSine, giSine, giSine,
giSine, -1, asamplepos1, asamplepos1, asamplepos1,
asamplepos1, kwavekey1, kwavekey1, kwavekey1,
kwavekey1, 100, id1
async1, aphase1 partikkelsync, id1
kphaSyncGravity linseg 0, 2, 0, p3-5, 1, 1, 1
aphase2 init 0
ksync2 init 0
asyncPolarity limit (int(aphase2*2)*2)-1, -1, 1
asyncStrength =
abs(abs(aphase2-0.5)-0.5)*asyncPolarity
; Use the phase of partikkelsync instance 2 to find
; sync polarity for partikkel instance 2.
; If the phase of instance 2 is less than 0.5,
; we want to nudge it down when synchronizing,
; and if the phase is > 0.5
; we want to nudge it upwards.
async2in = async1*kphaSyncGravity*asyncStrength
15.4 Clock Synchronisation
367
; adjust grain rate of second partikkel instance
; to approach that of the first instance
krateSyncGravity = 0.0005
ksyncPulseCount init 0
ksync1 downsamp async1, ksmps
ksync1 = ksync1*ksmps
; count the number of master clock pulses
; within this (slave)clock period
ksyncPulseCount = ksyncPulseCount + ksync1
ksyncRateDev init 0
ksyncStrength downsamp asyncStrength
; sum of deviations within this (slave)clock period
ksyncRateDev = ksyncRateDev + (ksyncStrength*ksync1)
; adjust rate only on slave clock tick
if ksync2 > 0 then
; if no master clock ticks, my tempo is too high
if ksyncPulseCount == 0 then
krateAdjust = -krateSyncGravity
; if more than one master clock tick,
; my tempo is too low
elseif ksyncPulseCount > 1 then
krateAdjust = krateSyncGravity
; if exactly one master clock tick,
; it depends on the phase value at the time
; when the master clock tick was received
elseif ksyncPulseCount == 1 then
krateAdjust = ksyncRateDev*krateSyncGravity*0.02
endif
; Reset counters on (slave)clock tick
ksyncPulseCount = 0
ksyncRateDev = 0
endif
kGrainRate2 init 2
kGrainRate2 = kGrainRate2 +
(krateAdjust*kGrainRate2*0.1)
kgdur2 = (kGrainDur*1000)/kGrainRate2
kwavfreq2 = 440
id2 = 2
a2 partikkel kGrainRate2, 0, -1, async2in, 0, -1,
giSigmoRise, giSigmoFall, 0, ka_d_ratio, kgdur2,
1, -1, kwavfreq2, 0.5, -1, -1, awavfm, -1, -1,
giCosine, 1, 1, 1, -1, 0, giSine, giSine, giSine,
368
15 Granular Synthesis
giSine, -1, asamplepos1, asamplepos1, asamplepos1,
asamplepos1, kwavekey1, kwavekey1, kwavekey1,
kwavekey1, 100, id2
async2, aphase2 partikkelsync, id2
ksync2 downsamp async2, ksmps
ksync2 = ksync2*ksmps
15.5 Amplitude Modulation and Granular Synthesis
Amplitude modulation is inherent in all granular processing, because we fade in-
dividual snippets of sound in and out, i.e. modulating the amplitude of the grains.
Under certain speciﬁc conditions, we can create the same spectrum with granular
synthesis as we can with amplitude modulation (AM) (ﬁgs. 15.8 and 15.9). This
goes to show an aspect of the ﬂexibility of granular synthesis, and can also help us
understand some of the artefacts that can occur in granular processing. Let’s look
at a very speciﬁc case: if the grain envelope is sinusoidal and the grain duration is
exactly 1/grainrate (so that the next grain starts exactly at the moment where the
previous grain stops), and the waveform inside grains has a frequency which has
an integer ratio to the grain rate (so that one or more whole cycles of the wave-
form ﬁt exactly inside a grain), the result is identical to amplitude modulation with
a sine wave where the modulation frequency equals the grain rate and the carrier
frequency equals the source waveform frequency. For illustrative purposes, we call
denote grain rate by gr and waveform frequency by wf. We observe a partial at gr,
with sidebands at gr+wf and gf-wf.
Now, if we dynamically change the frequency of the source waveform, the clean
sidebands of traditional AM will start to spread, creating a cascade of sidebands
(Fig. 15.10)
At the point where the waveform frequency attains an integer multiple of the
grain rate, the cascading sidebands will again diminish, approaching a new steady
state where granular synthesis equals traditional AM (see listing 15.27 and Fig.
15.11). The non-integer ratio of gr:wf amounts to a periodic phase reset of the AM
carrier. This may seem like a subtle effect since the phase reset happens when the
carrier has zero amplitude. The difference is signiﬁcant, as can be heard in the output
of listing If we want to avoid these artefacts, we can create an equivalent effect by
cross-fading between two source waveforms, each being of a frequency in integer
relationship to the grain rate (listing 15.28 and Fig. 15.12).
Listing 15.27 Granular synthesis equals traditional AM when the ratio of grain rate to source
waveform frequency is of an integer ratio (grain rate 200 Hz, waveform frequency 400 Hz). Here
we gradually go from an integer to a non-integer ratio (sweeping the waveform frequency from
400 Hz to 600 Hz, then from 600 Hz to 800 Hz), note the spreading of the sidebands. The example
ends at an integer ratio again (source waveform frequency 800 Hz)
instr 1
15.5 Amplitude Modulation and Granular Synthesis
369
Fig. 15.8 FFT of AM with modulator frequency 200 Hz and carrier frequency 400 Hz
Fig. 15.9 Granular synthesis with grain rate 200 Hz and source waveform frequency 400 Hz. We
use a sine wave as the source waveform and a sinusoid grain shape
kamp linen 1, 0.1, p3, 0.1
kamp = kamp*ampdbfs(-3)
asamplepos1 = 0
370
15 Granular Synthesis
Fig. 15.10 Granular synthesis with grain rate 200 Hz and source waveform frequency 500 Hz. We
use a sine wave as the source waveform and a sigmoid grain shape. Note the extra sidebands added
due to the non-integer relationship between grain rate and source waveform frequency
kGrainRate = p4
async = 0.0 ; (disable external sync)
kGrainDur = 1.0
kgdur = (kGrainDur*1000)/kGrainRate
ka_d_ratio = 0.5
ipitch1 = p4*2
ipitch2 = p4*3
ipitch3 = p4*4
kwavfreq linseg ipitch1, 1, ipitch1, 2,
ipitch2, 1, ipitch2, 2, ipitch3, 1, ipitch3
kwavekey1 = 1
iwaveamptab ftgentmp 0, 0, 32, -2, 0, 0, 1,0,0,0,0
awavfm = 0 ; (FM disabled)
a1 partikkel kGrainRate, 0, -1, async, 0, -1,
giSigmoRise, giSigmoFall, 0, ka_d_ratio, kgdur,
kamp, -1, kwavfreq, 0.5, -1, -1, awavfm,
-1, -1, giCosine, 1, 1, 1, -1, 0,
giSine, giSine, giSine, giSine, iwaveamptab,
asamplepos1,asamplepos1,asamplepos1,asamplepos1,
kwavekey1, kwavekey1, kwavekey1, kwavekey1, 100
out a1
endin
15.5 Amplitude Modulation and Granular Synthesis
371
Fig. 15.11 Spectrogram of the waveform produced by listing 15.27, note the extra sidebands dur-
ing source waveform frequency sweep.
Listing 15.28 Similar to the previous example, but avoiding the spreading sidebands by cross-
fading between source waveforms of integer frequency ratios (crossfading a source waveform of
frequency 400 Hz with a waveform of frequency 600 Hz, then cross-fading with another waveform
with frequency 800 Hz)
instr 1
kamp linen 1, 0.1, p3, 0.1
kamp = kamp*ampdbfs(-3)
asamplepos1 = 0
; invert phase to retain constant
; power during crossfade
asamplepos2 = 0.5
asamplepos3 = 0
kGrainRate = p4
async = 0.0 ; (disable external sync)
kGrainDur = 1.0
kgdur = (kGrainDur*1000)/kGrainRate
ka_d_ratio = 0.5
awavfm = 0 ; (FM disabled)
kwavfreq = 1
kwavekey1 = p4*2
kwavekey2 = p4*3
kwavekey3 = p4*4
; crossface by using wave mix masks
iwaveamptab ftgentmp 0, 0, 32, -2, 0, 0, 0,0,0,0,0
kamp1 linseg 1, 1, 1, 2, 0, 4, 0
kamp2 linseg 0, 1, 0, 2, 1, 1, 1, 2, 0, 2, 0
372
15 Granular Synthesis
kamp3 linseg 0, 4, 0, 2, 1, 1, 1
tablew kamp1, 2, iwaveamptab
tablew kamp2, 3, iwaveamptab
tablew kamp3, 4, iwaveamptab
a1 partikkel kGrainRate, 0, -1, async, 0, -1,
giSigmoRise, giSigmoFall, 0, ka_d_ratio, kgdur,
kamp, -1, kwavfreq, 0.5, -1, -1, awavfm,
-1, -1, giCosine, 1, 1, 1, -1, 0,
giSine, giSine, giSine, giSine, iwaveamptab,
asamplepos1,asamplepos2,asamplepos3,asamplepos1,
kwavekey1, kwavekey2, kwavekey3, kwavekey1, 100
out a1
Fig. 15.12 Spectrogram of the waveform produced by listing 15.28, cleaner transition with no
extra sidebands
15.6 Pitch Synchronous Granular Synthesis
In this section we will look at the technique pitch synchronous granular synthesis
(PSGS) and use this for formant shifting of a sampled sound. As we have seen in
Section 15.1.2, we can use a high grain rate with a periodic grain clock to con-
stitute pitch. We have also seen that the pitch of the waveform inside grains can
be used to create formant regions. Here we will use pitch tracking to estimate the
fundamental frequency of the source waveform, and link the grain clock to this fun-
damental frequency. This means that the pitch constituted by the granular process
15.6 Pitch Synchronous Granular Synthesis
373
will be the same as for the source sound, while we are free to manipulate the grain
pitch for the purpose of shifting the formants of the synthesised sound. Shifting
the formants of a sampled sound is perceptually similar to changing the size of the
acoustic object generating the sound, and in this manner we can create the illusion
of a “gender change” (or change of head and throat size) for recorded vocal sounds.
The amplitude modulation effects considered in Section 15.5 can be minimised by
using a slightly longer grain size. In our example, we use a grain size of 2/grainrate,
although this can be tuned further.
Listing 15.29 Pitch synchronous granular synthesis used as a formant shift effect
giSoundfile ftgen 0, 0, 0, 1,"Vocphrase.wav",0,0,0
instr 1
kamp adsr 0.0001, 0.3, 0.5, 0.5
kamp = kamp*ampdbfs(-6)
isoundDur = filelen("Vocphrase.wav")
asamplepos1 phasor 1/isoundDur
aref loscil 1, 1, giSoundfile, 1
kcps, krms pitchamdf aref, 100, 800
kGrainRate limit kcps, 100, 800
async = 0.0 ; (disable external sync)
kGrainDur = 2.0
kgdur = (kGrainDur*1000)/kGrainRate
ka_d_ratio = 0.5
kwavfreq = semitone(p4)
kwavekey1 = 1/isoundDur
awavfm = 0 ; (FM disabled)
a1 partikkel kGrainRate, 0, -1, async, 0, -1,
giSigmoRise, giSigmoFall, 0, ka_d_ratio, kgdur,
kamp, -1, kwavfreq, 0.5, -1, -1, awavfm,
-1, -1, giCosine, 1, 1, 1, -1, 0, giSoundfile,
giSoundfile, giSoundfile, giSoundfile, -1,
asamplepos1,asamplepos1,asamplepos1,asamplepos1,
kwavekey1, kwavekey1, kwavekey1, kwavekey1, 100
out a1
endin
schedule(1,0,7,0)
schedule(1,7,7,4)
schedule(1,14,7,8)
schedule(1,21,7,-4)
schedule(1,28,7,-8)
374
15 Granular Synthesis
15.7 Morphing Between Classic Granular Synthesis Types
Many of the classic types of granular synthesis described by Roads [109] originally
required a specialised audio synthesis engine for each variant of the technique. Each
granular type has some speciﬁc requirements not shared with other varieties of the
technique. For example, a glisson generator needs the ability to create a speciﬁc
pitch trajectory during the span of each grain; a pulsar generator needs grain mask-
ing and parameter linking; a trainlet generator needs an internal synthesiser to pro-
vide the desired parametrically controlled harmonic spectrum of the source wave-
form; and so on. The partikkel opcode in Csound was designed speciﬁcally to
overcome the impracticalities posed by the need to use a different audio generator
for each granular type. All of the speciﬁc needs associated with each granular type
were implemented in a combined super-generator capable of all time-based gran-
ular synthesis types. Due to a highly optimised implementation, this is not overly
processor intensive, and a high number of partikkel generators can run simul-
taneously in real-time. The following is a brief recounting of some classic granular
synthesis types not already covered in the text, followed by a continuous parametric
morph through all types.
15.7.1 Glissons
Glisson synthesis is a straightforward extension of basic granular synthesis in which
the source waveform for each grain has an independent frequency trajectory. The
grain or glisson creates a short glissando (see Fig. 15.13).
Fig. 15.13 A glisson with a downward glissando during the grain
With partikkel, we can do this by means of pitch masking, with inde-
pendent masks for the start and end frequencies (the iwavfreqstarttab and
iwavfreqendtab parameters of the opcode). Since grain masking gives control
over individual grains, each grain can have a separate pitch trajectory. Due to this
ﬂexibility we can also use statistical control over the grain characteristics.
15.7 Morphing Between Classic Granular Synthesis Types
375
15.7.2 Grainlets
Grainlet synthesis is inspired by ideas from wavelet synthesis. We understand a
wavelet to be a short segment of a signal, always encapsulating a constant num-
ber of cycles. Hence the duration of a wavelet is always inversely proportional to
the frequency of the waveform inside it. Duration and frequency are thus linked
(through an inverse relationship). Grainlet synthesis as described by [109] allows a
generalisation of the linkage between different synthesis parameters. Some exotic
combinations mentioned by Roads are duration/space, frequency/space and ampli-
tude/space. The space parameter refers to the placement of a grain in the stereo ﬁeld
or the spatial position in a 3D multichannel set-up.
15.7.3 Trainlets
Trainlets differ from other granular synthesis techniques in that they require a very
speciﬁc source waveform for the grains. The waveform consists of a bandlimited
impulse train as shown in Figure 15.14.
Fig. 15.14 Bandlimited trainlet pulse
A trainlet is speciﬁed by:
•
Base frequency.
•
Number of harmonics.
•
Harmonic balance (chroma): the energy distribution between high- and low-
frequency harmonics.
The partikkel opcode has an internal impulse train synthesiser to enable cre-
ation of these speciﬁc source waveforms. This is controlled by the ktraincps,
knumpartials and kchroma parameters. To enable seamless morphing be-
tween trainlets and other types of granular synthesis, the impulse train generator
has been implemented as a separate source waveform, and the mixing of source
waveforms is done by means of grain masks (the iwaveamptab parameter to
partikkel). See Section 15.3.2 for more details about waveform mixing.
376
15 Granular Synthesis
15.7.4 Pulsars
Pulsar audio synthesis relates to the phenomenon of fast-rotating neutron stars (in
astronomy, a pulsar is short for a pulsating radio star), which emit a beam of elec-
tromagnetic radiation. The speed of rotation of these stars can be as high as sev-
eral hundred revolutions per second. A stationary observer will then observe the
radiation as a pulse, appearing only when the beam of emission points toward the
observer. In the context of audio synthesis, Roads [109] uses the term pulsar to de-
scribe a sound particle consisting of an arbitrary waveform (the pulsaret) followed
by a silent interval. The total duration of the pulsar is called the pulsar period, while
the duration of the pulsaret is called the duty cycle (see Fig. 15.15. The pulsaret
itself can be seen as a special kind of grainlet, where pitch and duration are linked.
A pulsaret can be contained by an arbitrary envelope, and the envelope shape af-
fects the spectrum of the pulsaret due to the amplitude modulation effects inherent
in applying the envelope to the signal. Repetitions of the pulsar signal form a pulsar
train. We can use parameter linkage to create the pulsarets and amplitude masking
of grains to create a patterned stream of pulsarets, making a pulsar train).
Fig. 15.15 A pulsar train consisting of pulsarets with duty cycle d, silent interval s and pulsar
period p. Amplitude masks are used on the pulsarets
15.7.5 Formant Synthesis
As we have seen in Sections 15.1.2 and 15.5, we can use granular techniques to
create a spectrum with controllable formants. This can be utilised to simulate vo-
cals or speech, and also other formant-based sounds. Several variants of particle-
based formant synthesis (FOF, Vosim, Window Function Synthesis) have been pro-
posed [109]. As a generalisation of these techniques we can say that the base pitch
is constituted by the grain rate (which is normally periodic), the formant position
is determined by the pitch of the source waveform inside each grain (commonly
a sine wave), and the grain envelope controls the formant’s spectral shape. The
Csound manual for fof2 contains an example of this kind of formant synthesis.
We can also ﬁnd a full listing of formant values for different vowels and voice types
15.7 Morphing Between Classic Granular Synthesis Types
377
at http://csound.github.io/docs/manual/MiscFormants.html. With partikkel we
can approximate the same effect by using the four source waveforms, all set to sine
waves, with a separate frequency trajectory for each source waveform (Fig. 15.16).
The formant frequencies will be determined by the source waveform frequencies.
We can use waveform-mixing techniques as described in Section 15.3.2 to adjust
the relative amplitudes of the formants. We will not have separate control over the
bandwidth of each formant, since the same grain shape will be applied to all source
waveforms. On the positive side, we only use one grain generator instance so the
synthesiser will be somewhat less computationally expensive, and we are able to
gradually morph between formant synthesis and other types of granular synthesis.
Listing 15.30 Formant placement by transposition of source waveforms, here moving from a bass
‘a’ to a bass ‘e’
kwavekey1 linseg 600, 1, 600, 2, 400, 1, 400
kwavekey2 linseg 1040, 1, 1040, 2, 1620, 1, 1620
kwavekey3 linseg 2250, 1, 2250, 2, 2400, 1, 2400
kwavekey4 linseg 2450, 1, 2450, 2, 2800,
1, 2800
Listing 15.31 Relative level of formants controlled by wave-mix masking table. We use ftmorf
to gradually change between the different masking tables
iwaveamptab ftgentmp 0, 0, 32, -2, 0, 0,
1, 0, 0, 0, 0
iwaveamptab1 ftgentmp 0, 0, 32, -2, 0, 0,
1, ampdbfs(-7), ampdbfs(-9), ampdbfs(-9), 0
iwaveamptab2 ftgentmp 0, 0, 32, -2, 0, 0,
1, ampdbfs(-12), ampdbfs(-9), ampdbfs(-12), 0
iwavetabs ftgentmp 0, 0, 2, -2,
iwaveamptab1, iwaveamptab2
kwavemorf linseg 0, 1, 0, 2, 1, 1, 1
ftmorf kwavemorf, iwavetabs, iwaveamptab
Fig. 15.16 Sonogram of the formants created by listings 15.30 and 15.31
378
15 Granular Synthesis
15.7.6 Morphing Between Types of Granular Synthesis
To show how to move seamlessly between separate granular types, we will give
an example that morphs continuously through: sampled waveform - single cycle
waveform - glissons - trainlets - pulsars - formant synthesis - asynchronous granular
- waveform mixing. The morph is done in one single continuous tone where only
the parameters controlling the synthesis change over time. The best way to study
this example is to start listening to the produced sound, as the code to implement it
is necessarily somewhat complex. The main automated parameters are:
•
source waveform
•
source waveform pitch
•
phase (time pointer into the source waveform)
•
amplitude
•
grain rate
•
clock sync
•
grain shape
•
pitch sweep
•
trainlet parameters
•
grain masking (amplitude, channel, wave mix).
Listening to the sound produced by listing 15.32, we can hear the different gran-
ular types at these times (in seconds into the soundﬁle):
•
0 s: sampled waveform
•
5 s: single cycle waveform
•
7 s: glissons
•
14 s: trainlets
•
25 s: pulsars
•
35 s: formant synthesis
•
42 s: asynchronous granular
•
49 s: waveform mixing.
Listing 15.32 Morphing through different variations of granular synthesis
nchnls = 2
0dbfs = 1
; load audio files
giVocal ftgen 0, 0, 0, 1, "Vocphrase.wav", 0, 0, 0
giChoir ftgen 0, 0, 0, 1, "Choir.wav", 0, 0, 0
giCello ftgen 0, 0, 0, 1, "Cello.wav", 0, 0, 0
giVibLine ftgen 0, 0, 0, 1, "VibDist.wav", 0, 0, 0
; classic waveforms
giSine ftgen 0,0,65537,10,1
giCosine ftgen 0,0,8193,9,1,1,90
15.7 Morphing Between Classic Granular Synthesis Types
379
giTri ftgen 0,0,8193,7,0,2048,1,4096,-1,2048,0
; grain envelope tables
giSigmoRise ftgen 0,0,8193,19,0.5,1,270,1
giSigmoFall ftgen 0,0,8193,19,0.5,1,90,1
giExpFall ftgen 0,0,8193,5,1,8193,0.00001
giTriangleWin ftgen 0,0,8193,7,0,4096,1,4096,0
; asynchronous clock UDO
opcode probabilityClock, a, k
kdens xin
setksmps 1
krand rnd31 1, 1
krand = (krand*0.5)+0.5
ktrig = (krand < kdens/kr ? 1 : 0)
atrig upsamp ktrig
xout atrig
endop
instr 1
; * use instrument running time
; as the morphing "index"
kmorftime timeinsts
; * source waveform selection automation
; single-cycle waveforms must
; be transposed differently
; than sampled waveforms,
; hence the kwaveXSingle variable
kwaveform1 = (kmorftime < 30 ? giVocal : giSine)
kwave1Single = (kmorftime < 30 ? 0 : 1)
kwaveform2 = (kmorftime < 51 ? giSine : giChoir)
kwave2Single = (kmorftime < 51 ? 1 : 0)
kwaveform3 = (kmorftime < 51 ? giSine : giCello)
kwave3Single = (kmorftime < 51 ? 1 : 0)
kwaveform4 = (kmorftime < 51 ? giSine : giVibLine)
kwave4Single = (kmorftime < 51 ? 1 : 0)
kwaveform1 = (kmorftime > 49 ? giVocal : kwaveform1)
kwave1Single = (kmorftime > 49 ? 0 : kwave1Single)
; * get source waveform length
; (used when calculating transposition
;
and time pointer)
kfildur1 = tableng(kwaveform1) / sr
380
15 Granular Synthesis
kfildur2 = tableng(kwaveform2) / sr
kfildur3 = tableng(kwaveform3) / sr
kfildur4 = tableng(kwaveform4) / sr
; * original pitch for each waveform,
; use if they should be transposed individually
kwavekey1 linseg 1, 30, 1, 4, 600, 3, 600, 2,
400, 11, 400, 0, 1
kwavekey2 linseg 440, 30, 440, 4, 1040, 3, 1040, 2,
1620, 12, 1620, 1, semitone(-5)
kwavekey3 linseg 440, 30, 440, 4, 2250, 3, 2250, 2,
2400, 12, 2400, 1, semitone(10)
kwavekey4 linseg 440, 30, 440, 4, 2450, 3, 2450, 2,
2800, 12, 2800, 1, semitone(-3)
; set original key dependant on waveform length
; (only for sampled waveforms,
;
not for single cycle waves)
kwavekey1 = (kwave1Single > 0 ?
kwavekey1 : kwavekey1/kfildur1)
kwavekey2 = (kwave2Single > 0 ?
kwavekey2 : kwavekey2/kfildur2)
kwavekey3 = (kwave3Single > 0 ?
kwavekey3 : kwavekey3/kfildur3)
kwavekey4 = (kwave4Single > 0 ?
kwavekey4 : kwavekey4/kfildur4)
; * time pointer (phase) for each source waveform.
isamplepos1 = 0
isamplepos2 = 0
isamplepos3 = 0
isamplepos4 = 0
; phasor from 0 to 1,
; scaled to the length of the source waveform
kTimeRate = 1
asamplepos1 phasor kTimeRate / kfildur1
asamplepos2 phasor kTimeRate / kfildur2
asamplepos3 phasor kTimeRate / kfildur3
asamplepos4 phasor kTimeRate / kfildur4
; mix initial phase and moving phase value
; (moving phase only for sampled waveforms,
; single cycle waveforms use static samplepos)
asamplepos1 = asamplepos1*(1-kwave1Single) +
15.7 Morphing Between Classic Granular Synthesis Types
381
isamplepos1
asamplepos2 = asamplepos2*(1-kwave2Single) +
isamplepos2
asamplepos3 = asamplepos3*(1-kwave3Single) +
isamplepos3
asamplepos4 = asamplepos4*(1-kwave4Single) +
isamplepos4
; * amplitude
kdb linseg -3, 8, -3, 4, -10, 2.5, 0, 0.5, -2, 10,
-2, 3, -6, 2, -6, 1.3, -2, 1.5, -5, 4, -2
kenv expseg 1, p3-0.5, 1, 0.4, 0.001
kamp = ampdbfs(kdb) * kenv
; * grain rate
kGrainRate linseg 12, 7, 12, 3, 8, 2, 60, 5,
110, 22, 110, 2, 14
; * sync
kdevAmount linseg 0, 42, 0, 4, 1, 2, 1, 2, 0
async probabilityClock kGrainRate
async = async*kdevAmount
; * distribution
kdistribution = 0.0
idisttab ftgentmp 0, 0, 16, 16, 1, 16, -10, 0
; * grain shape
kGrainDur linseg 2.5, 2, 2.5, 5, 1.0, 5, 5.0, 4,
1.0, 1, 0.8, 5, 0.2, 10, 0.8, 7, 0.8, 3,
0.1, 5, 0.1, 1, 0.2, 2, 0.3, 3, 2.5
kduration = (kGrainDur*1000)/kGrainRate
ksustain_amount linseg 0, 16, 0, 2, 0.9,
12 ,0.9, 5, 0.2
ka_d_ratio linseg 0.5, 30, 0.5, 5, 0.25, 4, 0.25, 3,
0.1, 7, 0.1, 1, 0.5
kenv2amt linseg 0, 30, 0, 5, 0.5
; * grain pitch
kwavfreq = 1
awavfm = 0 ;(FM disabled)
; * pitch sweep
ksweepshape = 0.75
iwavfreqstarttab ftgentmp 0, 0, 16, -2, 0, 0, 1
382
15 Granular Synthesis
iwavfreqendtab ftgentmp 0, 0, 16, -2, 0, 0, 1
kStartFreq randh 1, kGrainRate
kSweepAmount linseg 0, 7, 0, 3, 1, 1, 1, 4, 0
kStartFreq = 1+(kStartFreq*kSweepAmount)
tablew kStartFreq, 2, iwavfreqstarttab
; * trainlet parameters
; amount of parameter linkage between
; grain dur and train cps
kTrainCpsLinkA linseg 0, 17, 0, 2, 1
kTrainCpsLink = (kGrainDur*kTrainCpsLinkA)+
(1-kTrainCpsLinkA)
kTrainCps = kGrainRate/kTrainCpsLink
knumpartials = 16
kchroma linseg 1, 14, 1, 3, 1.5, 2, 1.1
; * masking
; gain masking table, amplitude for
; individual grains
igainmasks ftgentmp 0, 0, 16, -2, 0, 1, 1, 1
kgainmod linseg 1, 19, 1, 1, 1, 3, 0.5, 1,
0.5, 6, 0.5, 7, 1
; write modified gain mask,
; every 2nd grain will get a modified amplitude
tablew kgainmod, 3, igainmasks
; channel masking table,
; output routing for individual grains
; (zero based, a value of 0.0
;
routes to output 1)
ichannelmasks ftgentmp 0, 0, 16, -2, 0, 3,
0.5, 0.5, 0.5, 0.5
; create automation to modify channel masks
; the 1st grain moving left,
; the 3rd grain moving right,
; other grains stay at centre.
kchanmodL linseg 0.5, 25, 0.5, 3, 0.0, 5, 0.0, 4, 0.5
kchanmodR linseg 0.5, 25, 0.5, 3, 1.0, 5, 1.0, 4, 0.5
tablew kchanmodL, 2, ichannelmasks
tablew kchanmodR, 4, ichannelmasks
; amount of random masking (muting)
; of individual grains
krandommask linseg 0, 22, 0, 7, 0, 3, 0.5, 3, 0.0
15.7 Morphing Between Classic Granular Synthesis Types
383
; wave mix masking.
; Set gain per source waveform per grain,
; in groups of 5 amp values, reflecting
; source1, source2, source3, source4,
; and the 5th slot is for trainlet amplitude.
iwaveamptab ftgentmp 0, 0, 32, -2, 0, 0, 1,0,0,0,0
; vocal sample
iwaveamptab1 ftgentmp 0, 0, 32, -2, 0, 0, 1,0,0,0,0
; sine
iwaveamptab2 ftgentmp 0, 0, 32, -2, 0, 0, 0,1,0,0,0
; trainlet
iwaveamptab3 ftgentmp 0, 0, 32, -2, 0, 0, 0,0,0,0,1
; formant ’a’
iwaveamptab4 ftgentmp 0, 0, 32, -2, 0, 0,
1, ampdbfs(-7), ampdbfs(-9), ampdbfs(-9), 0
; formant ’e’
iwaveamptab5 ftgentmp 0, 0, 32, -2, 0, 0,
1, ampdbfs(-12), ampdbfs(-9), ampdbfs(-12), 0
iwavetabs ftgentmp 0, 0, 8, -2,
iwaveamptab1, iwaveamptab2, iwaveamptab3,
iwaveamptab4, iwaveamptab5, iwaveamptab1,
iwaveamptab2, iwaveamptab1
kwavemorf linseg 0, 4, 0, 3, 1, 4, 1, 5, 2, 14, 2, 5,
3, 2, 3, 2, 4, 8, 4, 1, 5, 1, 6, 1, 6, 1, 7
ftmorf kwavemorf, iwavetabs, iwaveamptab
; generate waveform crossfade automation
; (only enabled after 52 seconds, when we
; want to use the 2D X/Y axis
; method to mix sources)
kWaveX linseg 0, 52,0, 1,0, 1,1, 1,1
kWaveY linseg 0, 52,0, 1,1, 1,1, 1,0
if kmorftime < 52 kgoto skipXYwavemix
; calculate gain for 4 sources from XY position
kwgain1 limit ((1-kWaveX)*(1-kWaveY)), 0, 1
kwgain2 limit (kWaveX*(1-kWaveY)), 0, 1
kwgain3 limit ((1-kWaveX)*kWaveY), 0, 1
kwgain4 limit (kWaveX*kWaveY), 0, 1
tablew kwgain1, 2, iwaveamptab
tablew kwgain2, 3, iwaveamptab
tablew kwgain3, 5, iwaveamptab
tablew kwgain4, 4, iwaveamptab
384
15 Granular Synthesis
skipXYwavemix:
a1,a2,a3,a4,a5,a6,a7,a8 partikkel kGrainRate,
kdistribution, idisttab, async, kenv2amt,
giExpFall, giSigmoRise, giSigmoFall,
ksustain_amount, ka_d_ratio,
kduration, kamp, igainmasks, kwavfreq, ksweepshape,
iwavfreqstarttab, iwavfreqendtab, awavfm,
-1, -1,
giCosine, kTrainCps, knumpartials, kchroma,
ichannelmasks, krandommask, kwaveform1, kwaveform2,
kwaveform3, kwaveform4, iwaveamptab,
asamplepos1, asamplepos2, asamplepos3, asamplepos4,
kwavekey1, kwavekey2, kwavekey3, kwavekey4, 100
outs a1, a2
endin
schedule(1,0,56.5)
15.8 Conclusions
This chapter has explored granular synthesis, and the combinations of synthesis pa-
rameters that most strongly contribute to the different types of granular synthesis.
Most signiﬁcant among these are the grain rate and pitch along with grain enve-
lope and source waveform. We can also note that the perceptual effect of changing
the value of one parameter sometimes strongly depends on the current value of
another parameter. One example is the case with grain pitch, which gives a pitch
change when the grain rate is low, and a formant shift when the grain rate is high.
We have also looked at the application of granular techniques for processing a live
audio stream, creating granular delays and reverb effects. Furthermore we looked
at manipulation of single grains to create intermittencies, ﬁltering, subharmonics,
spatial effects and waveform mixing. Techniques for clock synchronisation have
also been shown, enabling soft (gradual) or hard synchronisation between different
partikkel instances and/or other clock sources. The relationship between AM
and granular synthesis was considered, and utilised in the pitch synchronous granu-
lar synthesis technique. Finally, a method of parametric morphing between different
types of granular synthesis was shown. Hopefully, the potential of granular synthesis
as an abundant source of sonic transformations has been sketched out, encouraging
the reader to further experimentation.
