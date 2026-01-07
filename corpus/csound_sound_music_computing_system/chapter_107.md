# Chapter 20

Chapter 20
John fﬁtch: Se’nnight
Abstract In this chapter, the background and processes are explored that were used
in the composition of Se’nnight, the seventh work in a sequence Drums and Different
Canons that explores the onset of chaos in certain sequences.
20.1 Introduction
I have been interested for a long time in sequences of notes that never repeat, but are
very similar, thereby combining familiarity and surprise. This led me to the areas of
the onset of chaos. Quite separately I get an emotional reaction to small intervals,
much less than a semitone. I started a series of pieces with these two interests un-
der the umbrella title Drums and Different Canons. The ﬁrst of this family used a
synthetic marimba sound with added bell sounds governed by the H´enon and torus
maps (see Section 20.2).
This was followed by ﬁve further pieces as shown in Table 20.1. But the seventh
piece owes much to the ﬁrst, which was described in [38].
Table 20.1 Drums and Different Canons Series
#
Date
Title
Style
Main Map
Length
1
1996
Drums & Different Canons#1 Tape
H´enon/Torus 07:00
2
2000
Stalactite
Tape
Lorenz
07:37
3
2001
For Connie
Piano
Lorenz
04:00
4
2002
Unbounded Space
Tape
H´enon
06:50
5 2002/2003 Charles `a Nuit
Tape
H´enon
05:02
6
2010
Universal Algebra
Quad
H´enon
05:22
7 2011-2015 Se’nnight
Ambisonic H´enon
13:40
In this chapter I present the background in near-chaos that is central to the series,
describe the initial idea, and how it developed into the ﬁnal work.
© Springer International Publishing Switzerland 2016 
V. Lazzarini et al., Csound, DOI 10.1007/978-3-319-45370-5_20
469
470
20 John fﬁtch: Se’nnight
20.2 H´enon Map and Torus Map
The underlying mathematical idea in the whole series of pieces is the use of recur-
rence relations to generate a sequence of numbers that can be mapped to things such
as frequency and duration, these sequences showing near self-similarity.
Central to this is the H´enon map, which is a pair of recurrence equations
xn+1 = 1−ax2
n +yn
yn+1 = bxn
with two parameters a and b. For values a = 1.4, b = 0.3 the behaviour is truly
chaotic, and those are the values I used in the ﬁrst piece in this series. Starting from
the point (0,0) the values it delivers look as in Fig. 20.1.
-0.4
-0.3
-0.2
-0.1
0
0.1
0.2
0.3
0.4
-1.5
-1
-0.5
0
0.5
1
1.5
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+ +
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
Fig. 20.1 Chaotic H´enon map
This picture shows the values but not the order, which is illustrated in Fig. 20.2.
The paths are similar but never repeat; that is its attraction to me. I will use it as
a score generator.
The other map used in the development of Se’nnight is the Chirikov standard
map, which is on a torus (so I sometimes call it the torus map):
In+1 = In +K sin(Θn)
Θn+1 = Θn +In+1
20.3 Genesis of Se’nnight
471
-0.4
-0.3
-0.2
-0.1
0
0.1
0.2
0.3
0.4
-1.5
-1
-0.5
0
0.5
1
1.5
Fig. 20.2 Path of H´enon points
with I and Θ reduced to the range [0,2π). Values from this map have been used as
gestures in Drums and Different Canons. In the ﬁnal version of Se’nnight this was
not used but remains a potential component and an inspiration.
20.3 Genesis of Se’nnight
I often ﬁnd titles, and then they generate the ideas or structure of a piece. In the case
of Se’nnight the title came from a calendar adorned with archaic or little-used words,
and this was one of the words that took my attention as one that eventually might
become a title. Much later and independently, it occurred to me that a multiple-
channel piece might be possible, in the sense that I knew of two locations that had
eight speakers, and I might be able to persuade them to play something — I had been
somewhat reserved in trying this after hearing the piece Pre-Composition by Mark
Applebaum which, among other things, mocks the problem of getting an eight-
channel piece performed. My personal studio became equipped with quad sound
about this time so I decided on a two-dimensional surround sound model.
I did spend a little time wondering about VBAP or ambisonics, or just eight
sources; knowing ambisonic pieces and how they affected me I decided on this
format, with a HRTF version to assist in the creative process.
The other idea was to revisit the ﬁrst of the series as it remains one of my favourite
works, and seems to have more possibilities in it.
472
20 John fﬁtch: Se’nnight
20.4 Instruments
The main instrument in Number 1 was a synthetic marimba built in a modal-
modelling way, that originally I found in a set of Csound examples written by Jon
Nelson. I have loved the sound of the marimba since hearing one played on Santa
Monica Pier. For Se’nnight I updated the original instrument a bit, and made pro-
vision to position the sound at an angle round the midpoint. Actually two versions
were eventually made; one for ambisonics and one for HRTF, but more about that
later. Each note is static in space and presumed to be at equal distance.
The other main instrument, reused from the second movement of the ﬁrst piece,
Gruneberg, is a synthetic drum, also originating from Jon Nelson, which I tweaked
a little.
The third instrument is new, just a use of the fmbell with the attack removed.
As one can see the instruments are few in number but my interest is largely in
investigating the range of sounds and pitches they can produce with parameters
driven by the near-chaos sequences. It could be said that this is a minimal method
but the whole series does this in different ways. Any complexity is in the score.
20.5 Score Generation
The score is generated by three C programs.
20.5.1 Score1
The ﬁrst program uses the H´enon map to create a sequence of the drum instrument,
using the constants a = 1.5, b = 0.2. The x values are used to select a pitch (in hun-
dredths of an octave) and location, and y for time intervals between events. The raw
values are scaled, pitch=5.7+x*2.4; duration=fabs(10.0*y). There
is also code to vary the other parameters of the drum. This mapping was achieved
after a great deal of experimentation. The location mapping mainly follows the pitch
with some global movement.
The amplitude of the notes is different and, in a strange way, regular. The time
between events is quantised to 500 beats per minute, but there is no regular beat. The
piece is in 5/4 time with a beat every 7/500 of a minute. The 5/4 time, actually based
on the ﬁrst half of the Hindustani jhaptaal rhythm pattern1, is manifest as amplitude
variations of the ﬁrst note on or after the beat. This generates a stuttering beat which
I like:
/* Jhaptaal */
#define beats_per_bar (5)
1 dhin na | dhin dhin na | tin na | din din na
20.5 Score Generation
473
double vol[beats_per_bar] = { 1.5, 0.5, 1.0, 0.5, 0.0};
int pulse = 7;
int next_beat = 0;
double volume(int tt)
{
double amp = -6.0;
/* Base amplitude */
if (tt >= next_beat) { /* If first event after beat */
/* increase amplitude
*/
amp += vol[(tt/pulse) % beats_per_bar];
next_beat += pulse;
/* and record next beat time */
}
return amp;
}
The program generate 1,700 events, again chosen after much listening and many
variants. The later part of the events has a narrowed location.
int main(int argc, char *argv)
{
double x = 0.0,
y = 0.0;
int i;
initial();
for (i=0; i<1700; i++) {
/* Some iterations */
output(x, y);
henon(&x, &y);
if (tt>1240) {
minloc = (tt-1240)*135.0/(1500.0-1240.0);
maxloc = 360.0-minloc;
}
}
tail();
}
For an early version that was all there was, but the wider possibilities beckoned.
20.5.2 Score2 and Score3
The second score section uses much of the structure of the ﬁrst, but uses a modiﬁed
bell sound at ﬁxed locations as well as the marimba, using the Henon function in
a number of shortish sequences. Again the ﬁnal form came after many trials and
changes, adjusting sounds as well as timings.
474
20 John fﬁtch: Se’nnight
I named and archived two further versions of the work before ﬁxing on the ﬁnal
form.
20.6 Start and End
I like my music to have a recognisable ending, and to a lesser extent a start. In
the case of the ﬁrst piece in the series this was a strict cannon of falling tones, as
both start and end. For Se’nnight I took the same cannon but repeated it from eight
different directions around the space. The ending was originally the same, but after
consideration and advice the ending was made more reverberant and noticeable.
Rather than synthesise this sequence I took the original output, resampled it to 48
kHz, and just used a playback instrument. This was something of a short cut as I
usually do everything in Csound.
The other global component that was added to the ﬁnal assembly was an ampli-
tude envelope for the whole work, mainly for a fade at the end:
instr 1
gaenv
transeg
1, p3-15, 0, 1, 15, -1, 0
endin
....
i1
0
1500
20.7 Multichannel Delivery
Part of the design was to create a two-dimensional circle around any listener, and
ultimately to use ambisonics. But for some of the development in a small studio
environment I used the HRTF opcodes; so for the marimba
al, ar
hrtfstat a7, p7, 0, "h48-l.dat","h48-r.dat",
9, 48000
out
al, ar
In the ambisonic rendering these lines read
aw,ax,ay,az,ar,as,at,au,av,ak,al,
am,an,ao,ap,aq
bformenc1 a7,p7,0
out
aw, ax,ay,ar,au,av,al,am,ap,aq
There are 16 outputs in second-order ambisonics, but six of them relate to height
positions which, as I am not using them, are perforce zero. Hence the output is
a ten-channel WAV ﬁle. Because there is to be further processing this is saved in
ﬂoating-point format.
20.8 Conclusions
475
There are then simple orchestras to read this high-order audio and output as
stereo, quad or octal ﬁles:
<CsoundSynthesizer>
<CsInstruments>
sr
=
48000
kr
=
4800
ksmps
=
10
nchnls
=
8
gis init 1.264
instr 1
aZ
init
0
aw,ax,ay,ar,au,av,
al, am, ap, aq diskin2
"ambi.wav", 1
ao1, ao2, ao3, ao4,
ao5, ao6, ao7, ao8
bformdec1 4,
aw, ax, ay, aZ, ar, aZ, aZ, au,
av, aZ, al, am, aZ, aZ, ap, aq
out
gis*ao1,gis*ao2,gis*ao3,
gis*ao4,gis*ao5,gis*ao6,
gis*ao7,gis*ao8
endin
</CsInstruments>
<CsScore>
i1 0 821
</CsScore>
</CsoundSynthesizer>
The variable gis is a scaling factor that was determined experimentally, and
differs for the various speaker conﬁgurations. I have not yet looked into the theory
of this, but rendering to ﬂoats and using the scale utility is a simple pragmatic way
to determine suitable scales. As a programmer I wrapped up all the computational
details via a Makefile mechanism.
20.8 Conclusions
In this chapter I have tried to give some notion of my compositional methods. I rely
heavily on small C programs to generate sound sequences, often with a near-chaos
component. I also rely on Csound and its commitment to backward compatibility as
the software platform.
476
20 John fﬁtch: Se’nnight
This piece is rather longer than most of my works but it needed the space, and
true to its name it has seven loose sections. To save you looking it up, Se’nnight is
archaic Middle English for a week.