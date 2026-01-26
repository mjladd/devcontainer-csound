# Chapter 19

Chapter 19
Joachim Heintz: Knuth and Alma, Live
Electronics with Spoken Word
Abstract This chapter exempliﬁes the usage of Csound in a live electronics setup.
After introducing the general idea, two branches of working with spoken word as
live input are shown. Knuth analyses the internal rhythm and triggers events at
recognised accents, whereas Alma analyses sounding units of different sizes and
brings them back in different modes. The concept is shown as a work in progress,
with both realisations for improvisation and sketches for possible compositions.
19.1 Introduction
To compose a piece of music and to write a computer program seem to be rather
different kinds of human activity. For music and composition, inspiration, intuition
and a direct contact with the body1 seem to be substantial, whereas clear (“cold”)
thinking, high abstraction and limitless control seem to be essential for writing a
computer program. Arts must be dirty, programs must be clean. Arts must be imme-
diate, programs are abstractions and formalisms.
Yet actually, there are various inner connections between composing and pro-
gramming2. Programming should not be restricted to an act of technical application.
Writing a program is a creative act, based on decisions which are at least in part intu-
itive ones. And on the other hand, the way contemporary music thinks, moves, forms
is deeply connected to terms like parameters, series, permutations or substitutions.
Whether it may be welcomed or not, abstractions and concepts are a substantial part
of modern thinking in the arts, where they appear in manifold ways.
To program means to create a world in which the potential for change is in-
scribed. One of the most difﬁcult choices in programming can be to decide on this
shape instead of so many other possible shapes. Programming is always “on the
1 Composing music, singing or playing an instrument is “embodied” in a similar way as reacting
to rhythm, harmonies etc. on the listener’s part.
2 I have described some of these links in my article about composing before and with the computer
[50].
© Springer International Publishing Switzerland 2016
V. Lazzarini et al., Csound, DOI 10.1007/978-3-319-45370-5_19
455
456
19 Joachim Heintz: Knuth and Alma, Live Electronics with Spoken Word
way”; it is not the one perfect form, but it articulates one of many possible expres-
sions. Changes and transformations are the heart of programming; programs do not
only allow change, they demand it.
So I would like to discuss here a compositional case study which is very much
related to a concept rather than to a piece, and which is at the time of writing (De-
cember 2015) still at the beginning. I don’t know myself whether it will evolve fur-
ther, and if so, where to. I will show the basic idea ﬁrst, then two different branches,
and I will close with questions for future developments.
19.2 Idea and Set-up
There is a German children’s song, called “Ich geh mit meiner Laterne”. Children
sing it in the streets in autumn, when dusk falls early, parading a paper-built lantern,
with a candle in it. The song tells of the child going with the lantern in the same way
as the lantern goes with the child, and establishes a relation between the stars in the
sky and the lanterns here on earth.
I remembered this song after I wrote a couple of texts3 and wondered how texts
could be read in a different way, using live electronics. The set-up for this should be
simple: in the same way as the children go anywhere with their lantern, the person
who reads a text should be able to go anywhere with her live-electronics set-up. So
I only use a small speaker, a microphone and a cheap and portable computer. The
human speaker sits at a table, the loudspeaker is put on the table, too, and the human
speaker goes with his electronics companion as his companion goes with him.
Within this set-up, I have worked on two concepts which focus on two different
aspects of the spoken word. The one which I called Knuth deals with the inter-
nal rhythm of the language. The other, Alma, plays with the sounding units of the
speaker’s exclamations and thereby brings different parts of the past back into the
present.
19.3 Knuth
At the core of Knuth, rhythmic analysis of speech is employed to provide its musical
material. This triggers any pre-recorded or synthesised sound, immediately or with
any delay, and feeds the results of the analysis into the way the triggered sounds are
played back.
3 www.joachimheintz.de/laotse-und-schwitters.html
19.3 Knuth
457
19.3.1 Rhythm Analysis
The most signiﬁcant rhythmical element of speech is the syllable. Metrics counts
syllables and distinguishes marked and unmarked, long and short syllables. Drum-
mers in many cultures learn their rhythms and when to beat the drums by speaking
syllables together with drumming. Vinko Globokar composed his piece Toucher
[47] as a modiﬁcation of this practice, thereby musicalising parts of the Galileo
piece of Bertolt Brecht [23].
But how can we analyse the rhythm of spoken words, for instance the famous
Csound community speech example (Fig. 19.1), the “Quick Brown Fox”4? What
we would like to get out is similar to our perception: to place a marker as soon as a
vowel is recognised.
Fig. 19.1 “The quick brown fox jumps over the lazy dog” with desired recognition of internal
rhythm
I chose a certain FFT application to get there. The Csound opcode pvspitch
attempts to analyse the fundamental of a signal in the frequency domain [96]. Con-
sidering that a vowel is the harmonic part of speech, this should coincide with the
task at hand. If no fundamental can be analysed, pvspitch returns zero as fre-
quency. A threshold can be fed directly into the opcode to exclude everything which
is certainly no peak because it is too soft. We only have to add some code to avoid
repetitive successful analyses.
Listing 19.1 Rhythm detection by Knuth
/* get input (usually live, here sample) */
aLiveIn soundin "fox.wav"
/* set threshold (dB) */
kThreshDb = -20
4 http://csound.github.io/docs/manual/examples/fox.wav
458
19 Joachim Heintz: Knuth and Alma, Live Electronics with Spoken Word
/* set minimum time between two analyses */
kMinTim = 0.2
/* initialise time which has passed since
last detection */
kLastAnalysis init i(kMinTim)
/* count time since last detection */
kLastAnalysis += ksmps/sr
/* initialise the previous state of frequency
analysis to zero hz */
kFreqPrev init 0
/* set fft size */
iFftSize = 512
/* perform fft */
fIn pvsanal aLiveIn,iFftSize,iFftSize/4,iFftSize,1
/* analyse input */
kFreq, kAmp pvspitch fIn, ampdb(kThreshDb)
/* ask for the new value being the first
one jumping over kthresh */
if kFreqPrev == 0 &&
kFreq > 0 &&
kLastAnalysis > kMinTim then
/* trigger subinstrument and pass
analysed values */
event "i", "whatever", 0, 1, kFreq, kAmp
/* reset time */
kLastAnalysis = 0
endif
/* update next previous freq to this freq */
kFreqPrev = kFreq
The result is shown in Fig. 19.2).
19.3.2 Possibilities
This analysis of rhythm internal to speech may not be sufﬁcient for scientiﬁc pur-
poses; yet it is close enough to the human recognition of emphases to be used in an
19.3 Knuth
459
Fig. 19.2 “The quick brown fox jumps over the lazy dog” analysed by Knuth
artistic context. A basic implementation which I realised in CsoundQt (see Figure
19.3) offers an instrument for improvisation. The performer can select sounds which
are triggered by Knuth in real time via MIDI. It is possible to mix samples and to
vary their relative volumes. The basic analysis parameters (threshold, minimal time
between two subsequent vowels, minimum/maximum frequency to be analysed) can
be changed, too. And by request of some performers I introduced a potential delay,
so that a detected vowel does not trigger a sound before a certain time. The detected
base frequency is used to play back the samples at different speeds. In a similar
way, a reverberation is applied, so that a vowel with a high frequency results in
an upwards-transposed and more dry sound, whereas a low frequency results in a
downwards-transposed and more reverberative sound.
Fig. 19.3 Knuth as an instrument for improvisation in CsoundQt
For a composition, or a conceptual piece, instead of an improvisation, an ap-
proach similar to Globokar’s Toucher could already be implemented using an instru-
ment based on the described one. Besides, instead of distinguishing vowels, Knuth
could distinguish base frequencies, and/or the intensities of the accents. This could
be linked with sounds, mixtures and structures, and all linkings could be changed in
time.
460
19 Joachim Heintz: Knuth and Alma, Live Electronics with Spoken Word
19.4 Alma
Alma looks at the body of spoken words from a different perspective, playing with
the speaker’s vocalisations to recover elements of the past into the present.
19.4.1 Game of Times
Imagine someone who is reading a text. While they are reading, parts of what has
already been read come back, in speciﬁc forms or modes. Parts of the past come
back, thus confusing the perception of time as a ﬂow, or succession. A Game of
Times begins, and the text changes its face. Instead of a stream, always proceeding
from past to future, it becomes a space in which all that has gone can come back and
be here, in this moment, in the present. A line becomes a collection of fragments,
and the fragments build up a new space, in which no direction is preferred. You can
go back, you can go ahead, you can cease to move, you can jump, you can break
down, you can rise again in a new mode of movement. But deﬁnitely, the common
suggestion of a text as succession will experience strong irritations.
19.4.2 Speech as Different-Sized Pieces of Sounding Matter
So Alma is about the past, and she only works with the material the speaker has
already uttered. But this material is not equivalent to all that has been recorded in
a buffer. It would be unsatisfactory to play back some part of this past randomly:
sometimes a syllable, sometimes the second half of a word, sometimes silence.
Moreover, the sounding matter must be analysed and selected. The choice for
Alma is this: start by recognising sounding units of different sizes. A very small
size of such a sounding unit approximately matches the phonemes; a middle size
matches the syllables; a larger size matches whole words or even parts of sentences.
The number of sizes or levels is not restricted to three; there can be as many as
desired, as many as are needed for a certain Game of Times. The method used to
distinguish a unit is very easy: a sounding unit is considered as something which
has a pause before and afterwards. The measurement is simply done by rms: if
sounding material is below a certain rms threshold, it is considered as a pause. So
the two parameters which determine the result are the threshold and the time span
over which the rms value is measured. Figures 19.4–19.6 show three different results
of sounding units in the “Quick Brown Fox” example, depending on threshold and
time span.
19.4 Alma
461
Fig. 19.4 Sounding units analysed with -40 dB threshold and 0.04 seconds rms time span: four
large units
Fig. 19.5 Sounding units analysed with -40 dB threshold and 0.01 seconds rms time span: eleven
units of very different sizes
Fig. 19.6 Sounding units analysed with -20 dB threshold and 0.04 seconds rms time span: eight
units of medium size
462
19 Joachim Heintz: Knuth and Alma, Live Electronics with Spoken Word
The basic code to achieve this is quite simple, reporting whether the state deﬁned
as silence has changed. Usually, these changes are then written in a table or array,
indicating the start and end of sounding units.5
Listing 19.2 Analysis of sounding units by Alma
opcode IsSilence, k, akkj
aIn, kMinTim, kDbLim, iHp xin
/* rms */
iHp = iHp == -1 ? 5 : iHp
kRms rms aIn, iHp
/* time */
kTimeK init 0
kTimeK += 1
kTime = kTimeK/kr
/* analyse silence as rms */
kIsSilence = dbamp(kRms) < kDbLim ? 1 : 0
/* reset clock if state changes */
if changed(kIsSilence) == 1 then
kNewTime = kTime
endif
/* output */
if kIsSilence == 1 &&
kTime > kNewTime+kMinTim then
kOut = 1
else
kOut = 0
endif
xout kOut
endop
/* minimal silence time (sec) */
giMinSilTim = .04
/* threshold (dB) */
giSilDbThresh = -40
/* maximum number of markers which can be written */
giMaxNumMarkers = 1000
/* array for markers */
gkMarkers[] init giMaxNumMarkers
instr WriteMarker
/* input (usually live) */
aIn soundin "fox.wav"
/* initialise marker number */
5 To be precise, the units start and end a bit earlier, so half of the rms time span is subtracted from
the current time.
19.4 Alma
463
kMarkerNum init 0
/* analyse silence */
kSil IsSilence aIn, giMinSilTim,
giSilDbThresh, 1/giMinSilTim
/* store pointer positions */
if changed(kSil) == 1 then
kPointer = times:k() - giMinSilTim/2
gkMarkers[kMarkerNum] = kPointer
kMarkerNum += 1
endif
endin
In Figs. 19.4–19.6, we observe that the results only roughly correspond to the
above-mentioned distinction between phonemes, syllables and words. As humans,
we recognise these through complex analyses, whereas Alma deals with the spoken
language only in relation to one particular aspect: sounding units, separated by “si-
lence”. It very much depends on the speaker, her way of connecting and separating
the sounds, whether or not expected units are detected by Alma, or unexpected ones
are derived. I like these surprises and consider them to be an integral part of the
game.
19.4.3 Bringing Back the Past: Four Modes
Currently Alma can bring back the past in four different modes. None of these modes
is a real “playback”. All change or re-arrange the sounding past in a certain way.
This is a short overview:
