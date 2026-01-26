# Chapter 17

Chapter 17
Iain McCurdy: Csound Haiku
Abstract This chapter examines the set of pieces Csound Haiku and describes the
most interesting features of each one. The Csound code is intentionally written with
a clarity, simplicity and concision that hopefully allows even those with no knowl-
edge of the Csound language to garner some insight into the workings of the pieces.
This is intended to confront the conscious esotericism of some live-coding perfor-
mances. The pieces are intended to be run in real time thereby necessitating the
use of efﬁcient synthesis techniques. Extensive use of real-time event generation is
used, in fact the traditional Csound score is not used in any of the pieces. It was my
preference in these pieces to devise efﬁcient synthesis cells that would allow great
polyphony rather than to create an incredibly complex and CPU-demanding, albeit
possibly sonically powerful, synthesis engine that would only permit one or two si-
multaneous real-time instances. The pieces’ brevity in terms of code should make
their workings easily understandable. These illustrations will highlight the beauty
to be found in simplicity and should also provide technical mechanisms that can be
easily transplanted into other projects.
17.1 Introduction
Csound Haiku is a set of nine real-time generative pieces that were composed in
2011 and which are intended to be exhibited as a sound installation in the form of
a book of nine pages. Each page represents one of the pieces and turning to that
piece will start that piece and stop any currently playing piece. The pages them-
selves contain simple graphical elements reﬂecting compositional processes in the
piece overlaid with the code for the piece typed using a mechanical typewriter onto
semi-transparent paper. The use of a typewriter is intended to lend the code greater
permanence than if it were stored digitally and to inhibit the speed of reproduction
that is possible with digitally held code through copy and paste. Each of the pieces
can be played for as long or as short a time as desired. The experience should be like
tuning in and out of a radio station playing that piece indeﬁnitely. The ﬁrst moment
© Springer International Publishing Switzerland 2016
V. Lazzarini et al., Csound, DOI 10.1007/978-3-319-45370-5_
409
17
410
17 Iain McCurdy: Csound Haiku
we hear is not the beginning of the piece and the last moment we hear is not the
ending – they are more like edit points. None of the nine pieces make use of the
Csound score but instead they generate note events from within the orchestra. The
Csound score has traditionally been a mainstay of Csound work so this approach
is more reﬂective of modern approaches to how Csound can be used and allows
Csound to compete in the area of event generation and the use of patterns with soft-
ware more traditionally associated with this style of working such as SuperCollider
[86] and Pure Data [103]. To be able to print the complete code for each piece on a
single side of paper necessitated that that code be concise and this was in fact one of
the main compositional aims of the project. Running each piece comfortably in real
time also demanded that restrictions were employed in the ambitions of the Csound
techniques used. This spilled over into a focussing of the musical forces employed:
great orchestrations of disparate sound groups were ruled out.
17.2 Groundwork
The ﬁrst task was to identify simple and economic, yet expressive synthesising
‘cells’ that would characterise each piece. Techniques that proved to be too expen-
sive in their CPU demands or that would limit polyphony were quickly rejected. In
addition a reasonable degree of CPU headroom was sought in order to accommodate
the uncertainty inherent in a generative piece. When the set of pieces was combined
as an installation a brief overlapping of pieces was allowed as pages were turned.
This period of time when two pieces were brieﬂy playing would inevitably produce
a spike in CPU demand. Across the nine pieces synthesis techniques that suggest
natural sounds have been employed, machine-like and overly synthetic-sounding
synthesis was avoided. Similarly, when sound events are triggered, their timings,
durations and densities have been controlled in such a way as to suggest natural ges-
tures and perhaps activation by a human hand. In particular the opcodes rspline
and jspline were found to be particularly useful in generating natural gestures
with just a few input arguments. The various random number generators used in
the pieces are seeded by the system clock, which means that each time a piece is
run the results will be slightly different. This is an important justiﬁcation for the
pieces to be played live by Csound and not just to exist as ﬁxed renderings. Csound
Haiku was written using Csound 5. A number of syntactical innovations in Csound
6 would allow further compression of the code for each piece but the code has not
since been updated. In fact the clarity of traditional longhand Csound code is pre-
ferred as this helps fulﬁl the pieces’ dictatic aim. A large number of synthesiser
cells proved to be of interest but ultimately this number was whittled down to nine.
The next stage involved creating ‘workbenches’ for each of the synthesiser cells.
A simple GUI was created using Csound’s FLTK opcodes (see Fig. 17.1) so the
range of timbres possible for each cell could be explored. The FLTK opcodes are
not recommended for real-time use on account of threading issues that can result in
interruptions in real-time audio, besides there are now more reliable options built in
17.3 The Pieces
411
to a number of Csound’s frontends. Nonetheless they are still useful for sketching
ideas and remaining independent of a frontend.
Fig. 17.1 An example of one of the FLTK ‘workbenches’ that were used to explore ideas for
synthesiser cells
For each synthesis idea that proved capable of a range of interesting sounds,
a set of critical values was created establishing the useful ranges for parameters
and combinations of parameters that would produce speciﬁc sounds. These sets of
values provided the starting points for the construction of the ﬁnal pieces, sometimes
deﬁning initialisation values for opcodes and at other times deﬁning range values for
random functions.
17.3 The Pieces
In this section, we will consider each piece separately, looking at its key elements,
and how they were constructed.
412
17 Iain McCurdy: Csound Haiku
17.3.1 Haiku I
The two principle elements in this piece are the rich tone quality of the basic syn-
thesis cell and the design of the glissandi that recur through the piece. The synthesis
cell used comes more or less ready-made within Csound. The gbuzz opcode pro-
duces a rich tone derived from a stack of harmonically related cosine waves. The
overall spectral envelope can be warped dynamically using the opcode’s kmul pa-
rameter which musically provides control over timbre or brightness. The user can
also deﬁne the number of harmonic partials to be employed in the stack and the
partial number from which to begin the harmonic stack. These options are merely
deﬁned then left static in this piece; 75 partials are used and they begin from partial
number 1: the fundamental. These two settings characterise the result as brass-like:
either a trombone or trumpet depending on the fundamental frequency used. Essen-
tial to how this sound generator is deployed is the humanisation: applied the random
wobble to various parameters and the slow changes in expression created through
the use of gradual undulations in amplitude and timbre.
The piece uses six instances of the gbuzz opcode which sustain indeﬁnitely.
Each voice holds a pitch for a period of time and after that time begins a slow glis-
sando to a new pitch at which time the sequence of held note/glissando repeats. The
glissandi for the six voices will not fully synchronise; the six notes begin, not at the
same time, but one after another with a pause of 1 second separating each entrance
from the next. Each time a glissando is triggered its duration can be anything from
22.5 to 27 seconds. This will offset possible synchrony and parallel motion between
the six coincident glissandi. Glissando beginnings will maintain the 1 second gap
established at the beginning but their conclusions are unlikely to follow this pat-
tern. Each time a new glissando is triggered a new pitch is chosen randomly in the
form of a MIDI note number with a uniform probability within the range 12 to 54.
The glissando will start from the current note and move to the new note following
the shape of an inﬂected spline: a stretched ‘z’ shape if rising and a stretched ‘s’
shape if falling. Glissandi can therefore cover a large or small or even a zero inter-
val. This further contributes to undermining any synchrony between the six voices
and provides varying beating effects as the six glissandi weave across one another.
When the piece begins ﬁrstly the reverb instrument is triggered to be permanently
active using the alwayson opcode. An instrument called start long notes plays
for zero performance-time seconds, so therefore only acts at its initialisation time
to trigger six iterations of the instrument “trombone” that synthesises sound. This
arrangement is shown in Fig. 17.2.
The glissandi are created using the transeg opcode. This opcode generates a
breakpoint envelope with the curvature of each segment being user-deﬁnable. Each
glissando is constructed as a two-segment envelope. The curvature of the ﬁrst seg-
ment will always be 2 and the curvature of the second segment -2. This ensures
that, regardless of start and end pitches, each glissando will begin slowly, pick-
ing up speed to a maximum halfway through its duration before slowing again and
smoothly drawing to a halt at its destination pitch. This can be observed graphically
in Fig. 17.3.
17.3 The Pieces
413
Fig. 17.2 The instrument schematic of Haiku I. The six connections between “START LONG
NOTES” and “TROMBONE” represent six real-time score events being sent
Fig. 17.3 A snapshot of the pitches of the six voices across one minute of the piece. Note that
sometimes voices coalesce onto a unison pitch. Independent modulations of the ﬁne tuning of each
voice will prevent these being in absolute unison
The timbre of each note experiences random modulation by means of rspline
random spline generators using the following line:
kmul rspline 0.3,0.82,0.04,0.2
The ﬁrst two input arguments deﬁne the amplitude limits of the random func-
tion and the third and fourth terms deﬁne the limits of the rate of modulation. The
function produced will actually exceed the amplitude limits slightly but in this in-
stance this will not be a catastrophic problem. When kmul is around its minimum
value the timbre produced will resemble that of a brass instrument played softly,
at its maximum the timbre will more closely resemble the brilliance and raspiness
of a brass instrument played fortissimo. Once pitch glissando is added the listener
will probably relate the tone produced to that of a trombone. The rspline func-
tion generator for each voice will follow its own independent path. This means that
individual voices will rise out of the texture whenever their timbre brightens and
submerge back into it when their timbre darkens. This is an important feature in
providing each voice with its own personality, the sense that each voice is an in-
414
17 Iain McCurdy: Csound Haiku
dividual player rather than a note of a chord played on a single instrument. The
independence of the glissandi from voice to voice also reinforces this individuality.
Amplitude, ﬁne pitch control (detuning) and panning position are also modulated
using random spline functions:
kamp rspline 0.02,3,0.05,0.1
kdtn jspline 0.05,0.4,0.8
kpan rspline 0,1,0.1,1
The combined result of these random modulations enriched by also being passed
through the screverb reverb opcode provides timbral interest on a number of
levels. Faster random modulations, those of 0.2 Hz or higher, provide a wobble
that could be described as “humanising”. Slower modulations of 0.1 Hz or less are
perceived as an intentional musical expression such as crescendo.
Listing 17.1 Csound Haiku I
ksmps = 32
nchnls = 2
0dbfs = 1
seed
0
gicos ftgen 0,0,131072,11,1
gasendL,gasendR init
0
event_i
"i", "start_long_notes", 0, 0
alwayson "reverb"
instr start_long_notes
event_i "i","trombone",0,60*60*24*7
event_i "i","trombone",1,60*60*24*7
event_i "i","trombone",2,60*60*24*7
event_i "i","trombone",3,60*60*24*7
event_i "i","trombone",4,60*60*24*7
event_i "i","trombone",5,60*60*24*7
endin
instr trombone
inote
random
54,66
knote
init
int(inote)
ktrig
metro
0.015
if ktrig==1 then
reinit
retrig
endif
retrig:
inote1
init
i(knote)
inote2
random
54, 66
inote2
=
int(inote2)
inotemid =
inote1+((inote2-inote1)/2)
17.3 The Pieces
415
idur
random
22.5,27.5
icurve
=
2
timout
0,idur,skip
knote
transeg inote1,idur/2,icurve,inotemid,
idur/2,-icurve,inote2
skip:
rireturn
kenv
linseg
0,25,0.05,p3-50,0.05,25,0
kdtn
jspline 0.05,0.4,0.8
kmul
rspline 0.3,0.82,0.04,0.2
kamp
rspline 0.02,3,0.05,0.1
a1
gbuzz
kenv*kamp,\
cpsmidinn(knote)*semitone(kdtn),75,1,kmulˆ1.75,gicos
kpan
rspline 0,1,0.1,1
a1, a2
pan2
a1,kpan
outs
a1,a2
gasendL =
gasendL+a1
gasendR =
gasendR+a2
endin
instr reverb
aL, aR reverbsc
gasendL,gasendR,0.85,10000
outs
aL,aR
clear
gasendL, gasendR
endin
17.3.2 Haiku II
This piece explores polyrhythms and fragmentation and diminution of a rhythmic
theme. The source rhythmic theme is deﬁned in a function table as
giseq ftgen 0,0,-12,-2,1,1/3,1/3,1/3,1,1/3,1/3,1/3,
1/2,1/2,1/2,1/2
This rhythmic theme translates into conventional musical notation as shown in
Fig. 17.4.
Fig. 17.4 The rhythmic motif stored in the GEN 2 function table giseq. Note that the GEN
routine number needs to be preﬁxed by a minus sign in order to inhibit normalisation of the values
it stores
416
17 Iain McCurdy: Csound Haiku
Fragments of the motif are looped and overlaid at different speeds in simple ratio
with one another. The index from which the loop will begin will be either 0, 1, 2,
3, 4 or 5 as deﬁned by istart. An index of zero will point to the ﬁrst crotchet
of the motif as a start point. A value of 6 from the random statement will be very
unlikely. The fractional part of all istart values will be dumped in the seqtime
line to leave an integer. The index value at which to loop back to the beginning of
the loop is deﬁned in a similar fashion by iloop. iloop will be either 6, 7, 8,
9, 10, 11 or 12. An iloop value of 12 will indicate that looping back will occur
on the ﬁnal quaver of the motif. Finally the tempo of the motivic fragment can be
scaled via the itime unit variable using an integer value of either 2, 3 or 4. This
modiﬁcation is largely responsible for the rhythmic complexity that is generated;
without this feature the rhythmic relationships between layers are rather simple.
Listing 17.2 Mechanism for reading loop fragments from the rhythmic theme.
itime_unit random
2,5
istart
random
0,6
iloop
random
6,13
ktrig_in
init
0
ktrig_out
seqtime int(itime_unit)/3,int(istart),
int(iloop),0,giseq
The synthesis cell for this piece uses additive synthesis complexes of harmon-
ically related sinusoids created through GEN 9 function tables. What is different
is that the lower partials are omitted and the harmonics that are used are non-
sequential. These waveforms are then played back as frequencies that assume the
lowermost partial is the fundamental. This will require scaling down of frequen-
cies given to an oscillator, for example the ﬁrst partial of one of the function tables,
giwave6, is partial number 11; if we desire a note of 200 Hz, then the oscillator
should be given a frequency of 200/11.
Listing 17.3 GEN 9 table used to create a pseudo-inharmonic spectrum
giwave6 ftgen 0,0,131072,9, 11,1,0, 19,1/10,0,
28,1/14,0, 37,1/18,0, 46,1/22,0,
55,1/26,0, 64,1/30,0, 73,1/34,0
If wavetables are played back at low frequencies this raises the possibility of
quantisation artefacts, particularly in the upper partials. This can be obviated by
using large table sizes and interpolating oscillator opcodes such as poscil or
poscil3. The resulting timbre from this technique is perceived as being more
inharmonic than harmonic, perhaps resembling a resonating wooden or metal bar.
These sorts of timbres can easily be creating using techniques of additive synthesis
using individual oscillators, but the method employed here will prove to be much
more efﬁcient as each iteration of the timbre will employ just one oscillator. Seven
wavetables are created in this way which describe seven different timbral variations.
Each time a rhythmic loop begins, one of these seven wavetables will be chosen at
random for that loop. The durations of the notes played are varied from note to note.
This creates a sense of some note being damped with the hand and others being
17.3 The Pieces
417
allowed to resonate. This is a technique common when playing something like a
cowbell. The duration values are derived from a probability histogram created using
GEN 17. The following table produces the histogram shown in Fig. 17.5.
gidurs ftgen 0,0,-100,-17,0,0.4,50,0.8,90,1.5
Fig. 17.5 The length of a horizontal line corresponding to a particular value deﬁnes the probability
of that value. A duration of 0.4 s will be most common, a duration of 1.5 s least common
The instrument named “start sequences” triggers a new rhythmic loop every 4
seconds. Each rhythmic loop then sustains for 48 seconds, itself generating note
events used to trigger the instrument “play note”. The complete schematic is shown
in Fig. 17.6.
Fig. 17.6 The connections leading out of “START SEQUENCES” and “PLAY SEQUENCE” are
real-time event triggers. Only “PLAY NOTE” generates audio.
Listing 17.4 Csound Haiku II
ksmps = 64
nchnls = 2
0dbfs = 1
418
17 Iain McCurdy: Csound Haiku
giampscl ftgen 0,0,-20000,-16,1,20,0,1,19980,-5,1
giwave1 ftgen 0,0,131073,9, 6,1,0, 9,1/10,0, 13,1/14,0,
17,1/18,0, 21,1/22,0, 25,1/26,0, 29,1/30,0, 33,1/34,0
giwave2 ftgen 0,0,131073,9, 7,1,0, 10,1/10,0, 14,1/14,0,
18,1/18,0, 22,1/22,0, 26,1/26,0, 30,1/30,0, 34,1/34,0
giwave3 ftgen 0,0,131073,9, 8,1,0, 11,1/10,0, 15,1/14,0,
19,1/18,0, 23,1/22,0, 27,1/26,0, 31,1/30,0, 35,1/34,0
giwave4 ftgen 0,0,131073,9, 9,1,0, 12,1/10,0, 16,1/14,0,
20,1/18,0, 24,1/22,0, 28,1/26,0, 32,1/30,0, 36,1/34,0
giwave5 ftgen 0,0,131073,9, 10,1,0, 13,1/10,0, 17,1/14,0,
21,1/18,0, 25,1/22,0, 29,1/26,0, 33,1/30,0, 37,1/34,0
giwave6 ftgen 0,0,131073,9, 11,1,0, 19,1/10,0, 28,1/14,0,
37,1/18,0, 46,1/22,0, 55,1/26,0, 64,1/30,0, 73,1/34,0
giwave7 ftgen 0,0,131073,9, 12,1/4,0, 25,1,0, 39,1/14,0,
63,1/18,0, 87,1/22,0, 111,1/26,0, 135,1/30,0, 159,1/34,0
giseq ftgen 0,0,-12,-2, 1,1/3,1/3,1/3,1,1/3,1/3,1/3,1/2,
1/2,1/2,1/2
gidurs
ftgen
0,0,-100,-17, 0,0.4, 50,0.8, 90,1.5
gasendL
init
0
gasendR
init
0
gamixL
init
0
gamixR
init
0
girescales ftgen 0,0,-7,-2,6,7,8,9,10,11,12
alwayson
"start_sequences"
alwayson
"sound_output"
alwayson
"reverb"
seed
0
opcode tonea,a,aii
setksmps
1
ain,icps,iDecay xin
kcfenv
transeg
icps*4,iDecay,-8,1,1,0,1
aout
tone
ain, kcfenv
xout
aout
endop
instr start_sequences
ktrig
metro
1/4
schedkwhennamed ktrig,0,0,"play_sequence",0,48
endin
instr
play_sequence
itime_unit random 2, 5
istart
random
0, 6
17.3 The Pieces
419
iloop
random
6, 13
ktrig_in
init
0
ktrig_out seqtime int(itime_unit)/3, int(istart),
int(iloop), 0, giseq
inote
random
48, 100
ienvscl =
((1-(inote-48)/(100-48))*0.8)+0.2
ienvscl limit
ienvscl,0.3,1
icps
=
cpsmidinn(int(inote))
ipan
random
0, 1
isend
random
0.3, 0.5
kamp
rspline 0.007, 0.6, 0.05, 0.2
kflam
random
0, 0.02
ifn
random
0, 7
schedkwhennamed ktrig_out,0,0,"play_note",kflam,0.01,
icps,ipan,isend,kamp,int(ifn),ienvscl
endin
instr
play_note
idurndx
random
0, 100
p3
table
idurndx, gidurs
ijit
random
0.1, 1
acps
expseg
8000, 0.003, p4, 1, p4
aenv
expsega 0.001,0.003,ijitˆ2,(p3-0.2-0.002)*p9,
0.002,0.2,0.001,1,0.001
adip
transeg 1, p3, 4, 0.99
iampscl
table
p4, giampscl
irescale
table
p8, girescales
idtn
random
0.995,1.005
a1
oscili
p7*aenv*iampscl,
(acps*adip*idtn)/(6+irescale),
giwave1+p8
adlt
rspline 1, 10, 0.1, 0.2
aramp
linseg
0, 0.02, 1
acho
vdelay
a1*aramp, adlt, 40
icf
random
0, 2
kcfenv
transeg p4+(p4*icfˆ3), p9, -8, 1, 1, 0, 1
a1
tonex
a1, kcfenv
a1, a2
pan2
a1,p5
outs
a1,a2
gamixL
=
gamixL + a1
gamixR
=
gamixR + a2
gasendL
=
gasendL + (a1*(p6ˆ2))
gasendR
=
gasendR + (a2*(p6ˆ2))
endin
420
17 Iain McCurdy: Csound Haiku
instr
sound_output
a1,a2 reverbsc gamixL, gamixR, 0.01, 500
a1
=
a1*100
a2
=
a2*100
a1
atone
a1, 250
a2
atone
a2, 250
outs
a1, a2
clear
gamixL, gamixR
endin
instr
reverb
aL, aR reverbsc gasendL, gasendR, 0.75, 4000
outs
aL, aR
clear
gasendL, gasendR
endin
17.3.3 Haiku III
This piece uses for its synthesis cell the wguide2 opcode which implements a
double waveguide algorithm with ﬁrst-order low-pass ﬁlters applied to each delay
line (Fig. 17.7). The simple algorithm employed by the wguide1 opcode tends to
produce plucked-string-like sound if excited by a short impulse. The Csound manual
describes the sound produced by wguide2 as being akin to that of a struck metal
plate, but perhaps it is closer to the sound of a plucked piano or guitar string with the
string partially damped somewhere along its length by, for example, a ﬁnger. This
arrangement of waveguides produces resonances on a timbrally rich input signal that
express inharmonic spectra when the frequencies of the two individual waveguides
from which it is formed are not in simple ratio with one another. Care must be taken
that the sum of the two feedback factors does not exceed 0.5; the reason this ﬁgure
is not 1 is because the output of each waveguide is fed back into the input of both
waveguides.
At the beginning of each note, a short impulse sound is passed into the wguide2
network. This sound is simply a short percussive harmonic impulse. Its duration is
so short that we barely perceive its pitch, instead we hear a soft click or a thump
– this is our model of a ‘pluck’ or a ‘strike’. The pitch of the impulse changes
from note to note and this imitates the hardness of the strike, with higher pitches
imitating a harder strike. Note events are triggered using a metronome but the rate
of this metronome is constantly changing as governed by a function generated by
the rspline opcode. A trick is employed to bias the function in favour of lower
values: a random function between zero and 1 is ﬁrst created, then it is squared
(resulting in the bias towards lower values) and ﬁnally this new function is re-scaled
according to the desired range of values. This sequence is shown in the code snippet
below:
17.3 The Pieces
421
Fig. 17.7 The wguide2 opcode implements a double waveguide with the output of each delay
line being passed through a low-pass ﬁlters before begin fed back into the input. Crucially the
feedback from each waveguide is fed back into both waveguides, not just itself.
krate
rspline 0,1,0.1,2
krate
scale
krateˆ2,10,0.3
Natural undulations of pulsed playing will result provided that the four input
arguments for rspline are carefully chosen (Fig. 17.8).
Simultaneously with this, rspline random functions generate frequencies for
the two waveguides contained within wguide2, These frequencies are only applied
as initialisation-time values at the beginning of note events. This method is chosen
as the sound of continuous glissando throughout each note was not desired. The
shapes of the rsplines are still heard in how the spectra of note events evolve
note to note. Panning and amplitude are also modulated by rspline functions and
by combining all these independent rsplines we create movements in sound that
are strongly gestural.
Listing 17.5 Csound Haiku III
ksmps = 32
nchnls = 2
0dbfs = 1
giImpulseWave
ftgen
0,0,4097,10,1,1/2,1/4,1/8
gamixL,gamixR,gasendL,gasendR init 0
seed
0
gitims
ftgen
0,0,128,-7,1,100,0.1
422
17 Iain McCurdy: Csound Haiku
Fig. 17.8 The continuous curve shows the frequency value that is passed to the metro opcode,
the vertical lines indicate where note triggers occur.
alwayson
"start_sequences"
alwayson
"spatialise"
alwayson
"reverb"
instr
start_sequences
krate
rspline
0, 1, 0.1, 2
krate
scale
krateˆ2,10,0.3
ktrig
metro
krate
koct
rspline
4.3, 9.5, 0.1, 1
kcps
=
cpsoct(koct)
kpan
rspline
0.1, 4, 0.1, 1
kamp
rspline
0.1, 1, 0.25, 2
kwgoct1 rspline
6, 9, 0.05, 1
kwgoct2 rspline
6, 9, 0.05, 1
schedkwhennamed ktrig,0,0,"wguide2_note",0,4,kcps,
kwgoct1,kwgoct2,kamp,kpan
endin
instr
wguide2_note
aenv
expon
1,10/p4,0.001
aimpulse poscil
aenv-0.001,p4,giImpulseWave
ioct1
random
5, 11
17.3 The Pieces
423
ioct2
random
5, 11
aplk1
transeg
1+rnd(0.2), 0.1, -15, 1
aplk2
transeg
1+rnd(0.2), 0.1, -15, 1
idmptim
random
0.1, 3
kcutoff
expseg
20000,p3-idmptim,20000,idmptim,200,1,200
awg2
wguide2
aimpulse,cpsoct(p5)*aplk1,
cpsoct(p6)*aplk2,kcutoff,kcutoff,0.27,0.23
awg2
dcblock2 awg2
arel
linseg
1, p3-idmptim, 1, idmptim, 0
awg2
=
awg2*arel
awg2
=
awg2/(rnd(4)+3)
aL,aR
pan2
awg2,p8
gasendL
=
gasendL+(aL*0.05)
gasendR
=
gasendR+(aR*0.05)
gamixL
=
gamixL+aL
gamixR
=
gamixR+aR
endin
instr
spatialise
adlytim1 rspline 0.1, 5, 0.1, 0.4
adlytim2 rspline 0.1, 5, 0.1, 0.4
aL
vdelay
gamixL, adlytim1, 50
aR
vdelay
gamixR, adlytim2, 50
outs
aL, aR
gasendL
=
gasendL+(aL*0.05)
gasendR
=
gasendR+(aR*0.05)
clear
gamixL, gamixR
endin
instr
reverb
aL, aR
reverbsc gasendL,gasendR,0.95,10000
outs
aL, aR
clear
gasendL,gasendR
endin
17.3.4 Haiku IV
This piece focusses on forming periodic gestural clusters within which the sound
spectra morphs in smooth undulations. Its synthesis cell is based on Csound’s
hsboscil opcode. This opcode generates a tone comprising of a stack of partials,
each spaced an octave apart from its nearest neighbour. The scope of the spectrum
above and below the fundamental is deﬁned in octaves (up to a limit of eight) and
this complex of partials is then shaped by a spectral window function typically pro-
424
17 Iain McCurdy: Csound Haiku
viding emphasis on the central partial (fundamental). The spectral window can be
shifted up or down, thereby introducing additional higher partials when shifted up
and additional lower partials when shifted down. In this piece the spectral window is
shifted up and down quite dramatically and quickly once again using an rspline
function and it is this technique that lends the piece a shifting yet smooth and glassy
character. A sonogram of an individual note is shown in Fig. 17.9. Using a loga-
rithmic scale, octaves appear equally spaced and it is clearly observable how the
spectral envelope descends from its initial position, ascends slightly then descends
again before ascending for a second time.
Fig. 17.9 Spectrogram of an hsboscil gesture
On its own this sound is rather plain, so it is ring-modulated. Ring modulation
adds sidebands – additional partials – which undermine the pure organ-like quality
of hsboscil’s output. The ring-modulated version and the unmodulated source
are mixed using a dynamic cross-fade. Microtonal pitch and panning are modulated
using LFOs following sine shapes to evoke a sense of spinning or vibrato, but the
amplitudes and rates of these LFOs are continuously varied using rspline func-
tions so that the nature of this rotational movement constantly changes, suggesting
acceleration or deceleration and expansion or contraction of the rotational displace-
ment. Notes are triggered in groups of four on average every 12 seconds to create
the desired density of texture. The actual time gap between clusters varies about this
mean and note onsets within each cluster can temporally smear by as much as 2
seconds. These steps ensure a controlled amount of variation in how the piece pro-
gresses and sustains interest while not varying excessively from the desired textural
density and pace.
Listing 17.6 Csound Haiku IV
17.3 The Pieces
425
ksmps
= 32
nchnls = 2
0dbfs
= 1
gisine
ftgen
0, 0, 4096, 10, 1
gioctfn
ftgen
0, 0, 4096, -19, 1,0.5,270,0.5
gasendL,gasendR init
0
ginotes
ftgen
0,0,-100,-17,0,8.00,10,8.03,
15,8.04,25,8.05,50,8.07,60,8.08,73,8.09,82,8.11
seed
0
alwayson "trigger_notes"
alwayson "reverb"
instr
trigger_notes
krate
rspline
0.05, 0.12, 0.05, 0.1
ktrig
metro
krate
gktrans trandom
ktrig,-1, 1
gktrans =
semitone(gktrans)
idur
=
15
schedkwhen ktrig, 0, 0, "hboscil_note", rnd(2), idur
schedkwhen ktrig, 0, 0, "hboscil_note", rnd(2), idur
schedkwhen ktrig, 0, 0, "hboscil_note", rnd(2), idur
schedkwhen ktrig, 0, 0, "hboscil_note", rnd(2), idur
endin
instr
hboscil_note
ipch
table
int(rnd(100)),ginotes
icps = cpspch(ipch)*i(gktrans)*semitone(rnd(0.5)-0.25)
kamp
expseg
0.001,0.02,0.2,p3-0.01,0.001
ktonemoddep jspline
0.01,0.05,0.2
ktonemodrte jspline
6,0.1,0.2
ktone
oscil
ktonemoddep,ktonemodrte,gisine
kbrite
rspline
-2,3,0.0002,3
ibasfreq
init
icps
ioctcnt
init
2
iphs
init
0
a1
hsboscil kamp,ktone,kbrite,ibasfreq,gisine,
gioctfn,ioctcnt,iphs
amod
oscil
1, ibasfreq*3.47, gisine
arm
=
a1*amod
kmix expseg
0.001, 0.01, rnd(1),
rnd(3)+0.3, 0.0018
a1
ntrpol
a1, arm, kmix
a1
pareq
a1/10, 400, 15, .707
a1
tone
a1, 500
426
17 Iain McCurdy: Csound Haiku
kpanrte
jspline
5, 0.05, 0.1
kpandep
jspline
0.9, 0.2, 0.4
kpan
oscil
kpandep, kpanrte, gisine
a1,a2
pan2
a1, kpan
a1
delay
a1, rnd(0.1)
a2
delay
a2, rnd(0.1)
kenv
linsegr
1, 1, 0
a1
=
a1*kenv
a2
=
a2*kenv
outs
a1, a2
gasendL
=
gasendL+a1/6
gasendR
=
gasendR+a2/6
endin
instr
reverb
aL, aR reverbsc gasendL,gasendR,0.95,10000
outs
aL, aR
clear
gasendL,gasendR
endin
17.3.5 Haiku V
This piece is formed from two simple compositional elements: a continuous motor
rhythm formed from elements resembling struck wooden bars, and periodic punctu-
ating gestures comprising of more sustained metallic sounds. The two sound types
are created from the same synthesising instrument. The differences in their char-
acter are created by their dramatically differing durations and also by sending the
instrument a different set of p-ﬁeld values which govern key synthesis parameters.
The synthesis cell is based around the phaser2 opcode. This opcode implements
a series of second-order all-pass ﬁlters and is useful in creating a stack of inhar-
monically positioned resonances. Higher frequencies will decay more quickly than
lower ones and this allows phaser2 to imitate struck resonating objects which
would display the same tendency. The ﬁlters are excited by a single-cycle wavelet
of a sine wave. The period of this excitation signal (the reciprocal of the frequency)
can be used to control the brightness of the ﬁltered sound – a wavelet with a longer
period will tend to excite the lower resonances more than the higher ones. The du-
ration of time for which the synthesis cell will resonate is controlled mainly by the
phaser2’s feedback parameter. The more sustained metallic sounds are deﬁned by
having a much higher value for feedback (0.996) than the shorter sounds (0.9). The
continuous motor rhythm is perceived as a repeating motif of four quavers with the
pitches of the four quavers following their own slow glissandi. This introduces the
possiblity of contrary motion between the different lines traced by the four quavers
of the motif.
17.3 The Pieces
427
Listing 17.7 Csound Haiku V
ksmps = 32
nchnls = 2
0dbfs = 1
gisine
ftgen
0, 0, 4096, 10, 1
gasendL init
0
gasendR init
0
seed
0
alwayson "start_sequences"
alwayson "reverb"
instr
start_sequences
iBaseRate random
1, 2.5
event_i "i","sound_instr",0,3600*24*7,iBaseRate,0.9,
0.03,0.06,7,0.5,1
event_i "i","sound_instr",1/(2*iBaseRate),3600*24*7,
iBaseRate,0.9,0.03,0.06,7,0.5,1
event_i "i","sound_instr",1/(4*iBaseRate),3600*24*7,
iBaseRate,0.9,0.03,0.06,7,0.5,1
event_i "i","sound_instr",3/(4*iBaseRate),3600*24*7,
iBaseRate,0.9,0.03,0.06,7,0.5,1
ktrig1
metro
iBaseRate/64
schedkwhennamed ktrig1,0,0,"sound_instr",1/iBaseRate,
64/iBaseRate,iBaseRate/16,0.996,0.003,0.01,3,0.7,1
schedkwhennamed ktrig1,0,0,"sound_instr",2/iBaseRate,
64/iBaseRate,iBaseRate/16,0.996,0.003,0.01,4,0.7,1
ktrig2
metro
iBaseRate/72
schedkwhennamed ktrig2,0,0,"sound_instr",3/iBaseRate,
72/iBaseRate,iBaseRate/20,0.996,0.003,0.01,5,0.7,1
schedkwhennamed ktrig2,0,0,"sound_instr",4/iBaseRate,
72/iBaseRate,iBaseRate/20,0.996,0.003,0.01,6,0.7,1
endin
instr
sound_instr
ktrig
metro
p4
if ktrig=1 then
reinit PULSE
endif
PULSE:
ioct
random
7.3,10.5
icps
init
cpsoct(ioct)
aptr
linseg
0,1/icps,1
rireturn
428
17 Iain McCurdy: Csound Haiku
a1
tablei
aptr, gisine, 1
kamp
rspline
0.2, 0.7, 0.1, 0.8
a1
=
a1*(kampˆ3)
kphsoct
rspline
6, 10, p6, p7
isep
random
0.5, 0.75
ksep
transeg
isep+1, 0.02, -50, isep
kfeedback rspline
0.85, 0.99, 0.01, 0.1
aphs2 phaser2 a1,cpsoct(kphsoct),0.3,p8,p10,isep,p5
iChoRate
random
0.5,2
aDlyMod
oscili
0.0005,iChoRate,gisine
acho vdelay3 aphs2+a1,(aDlyMod+0.0005+0.0001)*1000,100
aphs2
sum
aphs2,acho
aphs2
butlp
aphs2,1000
kenv
linseg
1, p3-4, 1, 4, 0
kpan
rspline
0, 1, 0.1, 0.8
kattrel
linsegr
1, 1, 0
a1, a2
pan2
aphs2*kenv*p9*kattrel, kpan
a1
delay
a1, rnd(0.01)+0.0001
a2
delay
a2, rnd(0.01)+0.0001
ksend
rspline
0.2, 0.7, 0.05, 0.1
ksend
=
ksendˆ2
outs
a1*(1-ksend), a2*(1-ksend)
gasendL
=
gasendL+(a1*ksend)
gasendR
=
gasendR+(a2*ksend)
endin
instr
reverb
aL, aR
reverbsc
gasendL,gasendR,0.85,5000
outs
aL, aR
clear
gasendL, gasendR
endin
17.3.6 Haiku VI
This piece imagines an instrument with six resonating strings as the sound-producing
model. The strings are modelled using the wguide1 opcode (Fig. 17.10), which
provides a simple waveguide model consisting of a delay line fed into a ﬁrst-order
low-pass ﬁlter with a feedback loop encapsulating the entire unit.
The waveguides are excited by sending short-enveloped impulses of pink noise
into them. This provides a softer and more realistic ‘pluck’ impulse than would be
provided by a one-sample click. When a trigger ktrig is generated a new pluck
impulse is instigated by forcing a reinitialisation of the envelope that shapes the pink
noise.
17.3 The Pieces
429
Fig. 17.10 The schematic of the wguide1 opcode
Listing 17.8 Mechanism to create a retriggerable soft ‘pluck’ impulse
ktrig
metro
krate
if ktrig==1 then
reinit
update
endif
update:
aenv
expseg
0.0001,0.02,1,0.2,0.0001,1,0.0001
apluck pinkish
aenv
rireturn
The six waveguides are essentially sent the same impulse, but for each waveguide
the audio of the pluck is delayed by a randomly varying amount between 50 and 250
milliseconds. This offsetting will result in a strumming effect as opposed to the six
waveguides being excited in perfect sync. The strumming occurs periodically at a
rate that varies between 0.005 and 0.15 Hz. The initial pitches of each waveguide
follow the conventional tuning of a six-string guitar (E-A-G-D-B-E) but they each
experience an additional and continuous detuning determined by rspline opcodes
as if each string is being continuously and independently detuned. The detuning of
the six waveguides in relation to when pluck impulses occur is shown in Fig. 17.11.
Each waveguide output then experiences a slowly changing and random auto-
panning before being fed into a reverb. The full schematic of steps is shown in Fig.
17.12. The use of a large amount of reverb with a long reverberant tail effectively
creates pitch clusters as the waveguides slowly glissando, and therefore results in
interesting ‘beating’ effects.
Listing 17.9 Csound Haiku VI
ksmps
= 32
nchnls = 2
0dbfs
= 1
gasendL init
0
gasendR init
0
430
17 Iain McCurdy: Csound Haiku
Fig. 17.11 The slow modulations of the pitches of the six waveguides are shown by the six continu-
ous curves. The occurrence of the pluck impulses is shown by the vertical lines. Their misalignment
indicates the strumming effect that has been implemented
Fig. 17.12 Schematic showing the ﬂow of audio through the main elements used in Haiku VI
seed
0
alwayson "trigger_6_notes_and_plucks"
alwayson "reverb"
instr
trigger_6_notes_and_plucks
event_i "i","string",0,60*60*24*7,40
event_i "i","string",0,60*60*24*7,45
event_i "i","string",0,60*60*24*7,50
event_i "i","string",0,60*60*24*7,55
event_i "i","string",0,60*60*24*7,59
17.3 The Pieces
431
event_i "i","string",0,60*60*24*7,64
krate
rspline
0.005, 0.15, 0.1, 0.2
ktrig
metro
krate
if ktrig==1 then
reinit
update
endif
update:
aenv
expseg
0.0001, 0.02, 1, 0.2, 0.0001, 1, 0.0001
apluck
pinkish
aenv
rireturn
koct
randomi
5, 10, 2
gapluck butlp
apluck, cpsoct(koct)
endin
instr
string
adlt
rspline 50, 250, 0.03, 0.06
apluck
vdelay3 gapluck, adlt, 500
adtn
jspline 15, 0.002, 0.02
astring wguide1 apluck,cpsmidinn(p4)*semitone(adtn),\
5000,0.9995
astring
dcblock astring
kpan
rspline 0, 1, 0.1, 0.2
astrL, astrR pan2
astring, kpan
outs
astrL, astrR
gasendL
=
gasendL+(astrL*0.6)
gasendR
=
gasendR+(astrR*0.6)
endin
instr
reverb
aL, aR
reverbsc gasendL,gasendR,0.85,10000
outs
aL, aR
clear
gasendL, gasendR
endin
17.3.7 Haiku VII
This piece shares a method of generating rhythmic material with Haiku II. Again
a sequence of durations is stored in a GEN 2 function table and a loop fragment
is read from within this sequence. These durations are converted into a series of
triggers using the seqtime opcode. The key difference with the employment of
this technique in this piece, besides the rhythmic sequence being different, is that
the tempo is much slower to the point where the gaps between notes become greatly
dramatised. This time the rhythmic sequence stored in a function table is
432
17 Iain McCurdy: Csound Haiku
giseq ftgen 0,0,-12,-2,
3/2,2,3,1,1,3/2,1/2,3/4,5/2,2/3,2,1
The duration values start from the ﬁfth parameter ﬁeld, 3/2. The duration value
of 2/3 is inserted to undermine the regularity and coherence implied by other val-
ues which are more suggestive of ‘simple’ time. Two synthesis cells are used; the
ﬁrst uses a similar technique to that used in Csound Haiku II – the use of a GEN
9 table to imitate an inharmonic spectrum – but this time the sound has a longer
duration and uses a stretched percussive amplitude and low-pass ﬁlter envelope to
imitate a resonating bell sound. The second synthesis cell mostly follows the pitch
of the ﬁrst and is generally much quieter, functioning as a sonic shadow of the ﬁrst.
It is generated using a single instance of gbuzz whose pitch is modulated by a
high-frequency jspline function, making the pitch less distinct and adding an
‘airiness’. This type of sound is often described as a ‘pad’ although in this example
it could more accurately be described as a distant screech. To add a further sense of
space the gbuzz sound passes entirely through the reverb before reaching Csound’s
audio output. In performance the piece will slowly randomly cross-fade between the
GEN 9 bell-like sound and the gbuzz pad sound. The ﬂow of instruments is shown
in Fig. 17.13.
Fig. 17.13 Instrument schematic of Csound Haiku VII: “TRIGGER SEQUENCE” triggers notes
in “TRIGGER NOTES” which in turn triggers notes in “LONG BELL” and “GBUZZ LONG
NOTE” which then synthesise the audio
The long bell sounds are triggered repeatedly using schedkwhen whereas the
gbuzz long note is triggered by event i and only plays a single note during the
same event. The rhythm of events that the long bell follows will be determined by
looping a fragment of the values in the giseq table but the pitch can change owing
to the inﬂuence of the k-rate function kSemiDrop upon kcps:
kSemiDrop line rnd(2), p3, -rnd(2)
kcps
=
cpsmidinn(inote+int(kSemiDrop))
The use of the int() function upon kSemiDrop means that changes in pitch
will only occur in semitone steps and the choice of values in deﬁning the line
function means that kSemiDrop can only be a falling line. rnd(2) creates a
fractional value in the range 0 to 2 and rnd(-2) creates a value in the range 0 to
-2. This sense of a descending chromatic scale is key to the mood of this piece and
can also be observed in the representation of pitch shown in Fig. 17.14. This balance
between the use of descending chromaticism and its undermining through the use
17.3 The Pieces
433
of other intervals leaves the internal workings of the piece tantalising but slightly
enigmatic to the listener.
Fig. 17.14 The pitches of six voices are indicated by the six lines. The predominance of descending
semitone steps can be seen. The larger intervals are produced when the start of a new sequence
occurs
Listing 17.10 Csound Haiku VII
ksmps = 32
nchnls = 2
0dbfs = 1
giampscl ftgen 0,0,-20000,-16,1,20,0,1,19980,-30,0.1
giwave ftgen 0,0,4097,9, 3,1,0, 10,1/10,0, 18,1/14,0,\
26,1/18,0, 34,1/22,0, 42,1/26,0, 50,1/30,0, 58,1/34,0
gicos
ftgen
0,0,131072, 11, 1
giseq
ftgen
0,0,-12, \
-2,3/2,2,3,1,1,3/2,1/2,3/4,5/2,2/3,2,1
gasendL
init
0
gasendR
init
0
seed
0
alwayson "trigger_sequence"
alwayson "reverb"
434
17 Iain McCurdy: Csound Haiku
instr
trigger_sequence
ktrig
metro
0.2
schedkwhennamed ktrig,0,0,"trigger_notes",0,30
kcrossfade
rspline
0, 1, 0.01, 0.1
gkcrossfade =
kcrossfadeˆ3
endin
instr
trigger_notes
itime_unit random
2, 10
istart
random
0, 6
iloop
random
6, 13
ktrig_out
seqtime
int(itime_unit),int(istart),
int(iloop),0,giseq
idur
random
8, 15
inote
random
0, 48
inote
=
(int(inote))+36
kSemiDrop
line
rnd(2), p3, -rnd(2)
kcps
=
cpsmidinn(inote+int(kSemiDrop))
ipan
random
0, 1
isend
random
0.05, 0.2
kflam
random
0, 0.02
kamp
rspline
0.008, 0.4, 0.05, 0.2
ioffset
random
-0.2, 0.2
kattlim
rspline
0, 1, 0.01, 0.1
schedkwhennamed ktrig_out,0,0,"long_bell",kflam,idur,
kcps*semitone(ioffset), ipan, isend, kamp
event_i
"i","gbuzz_long_note",0,30,cpsmidinn(inote+19)
endin
instr
long_bell
acps
transeg
1, p3, 3, 0.95
iattrnd random
0, 1
iatt
=
(iattrnd>(p8ˆ1.5)?0.002:p3/2)
aenv expsega 0.001,iatt,1,p3-0.2-iatt,0.002,0.2,0.001
aperc
expseg
10000, 0.003, p4, 1, p4
iampscl table
p4, giampscl
ijit
random
0.5, 1
a1
oscili
p7*aenv*iampscl*ijit*(1-gkcrossfade),
(acps*aperc)/2,giwave
a2
oscili
p7*aenv*iampscl*ijit*(1-gkcrossfade),
(acps*aperc*semitone(rnd(.02)))/2,giwave
adlt
rspline
1, 5, 0.4, 0.8
acho
vdelay
a1, adlt, 40
a1
=
a1-acho
acho
vdelay
a2, adlt, 40
17.3 The Pieces
435
a2
=
a2-acho
icf
random
0, 1.75
icf
=
p4+(p4*(icfˆ3))
kcfenv
expseg
icf, 0.3, icf, p3-0.3, 20
a1
butlp
a1, kcfenv
a2
butlp
a2, kcfenv
a1
butlp
a1, kcfenv
a2
butlp
a2, kcfenv
outs
a1, a2
gasendL =
gasendL+(a1*p6)
gasendR =
gasendR+(a2*p6)
endin
instr
gbuzz_long_note
kenv
expseg
0.001, 3, 1, p3-3, 0.001
kmul
rspline 0.01, 0.1, 0.1, 1
kNseDep rspline 0,1,0.2,0.4
kNse
jspline kNseDep,50,100
agbuzz
gbuzz
gkcrossfade/80,p4/2*semitone(kNse),
5,1,kmul*kenv,gicos
a1
delay
agbuzz, rnd(0.08)+0.001
a2
delay
agbuzz, rnd(0.08)+0.001
gasendL =
gasendL+(a1*kenv)
gasendR =
gasendR+(a2*kenv)
endin
instr
reverb
aL,aR
reverbsc gasendL,gasendR,0.95,10000
outs
aL,aR
clear
gasendL, gasendR
endin
17.3.8 Haiku VIII
This piece creates waves of pointillistic gestures within which individual layers and
voices are distinguishable by the listener. The principal device for achieving this
is the use of aleatoric but discrete duration values for the note events. This means
that there are very long note events and very short note events but not a continuum
between them; this allows the ear to group events into streams or phrases emanating
from the same instrument. Radical modulation of parameters that could break this
perceptive streaming, such as pitch, is avoided. A sequence of note triggering from
instrument to instrument is employed. The instrument ‘start layers’ is triggered from
within instrument 0 (the orchestra header area) using an event i statement for
436
17 Iain McCurdy: Csound Haiku
zero seconds meaning that it will carry out initialisation-time statements only and
then cease. The i-time statements it carries out simply start three long instances of
the instrument “layer”. Adding or removing streams of notes in the piece can easily
be achieved by simply adding or removing iterations of the event i statement
in the instrument “start layers”. Each layer then generates streams of notes using
schedkwhen statements which trigger the instrument “note”. The synthesis cell in
this piece again makes use of the gbuzz opcode but the sound is more percussive.
The fundamental pitch of a stream of notes generated by a layer changes only very
occasionally as dictated by a random sample and hold function generator:
knote randomh 0,12,0.1
The frequency with which new values for knote will be generated is 0.1 Hz;
each note will persist for 10 seconds before changing. The number of partials em-
ployed by gbuzz in each note of the stream and the lowest partial present are cho-
sen randomly upon each new note. The number of partials can be any integer from
1 to 500 and the lowest partial can be any integer from 1 to 12. This generates quite
a sense of angularity from note to note but the perceptual grouping from note to
note is maintained by virtue of the fact that the fundamental frequency changes so
infrequently. The waveform used by gbuzz is not the usual cosine wave but instead
is a sine wave with a weak ﬁfth partial:
giwave ftgen 0,0,131072,10,1,0,0,0,0.05
A distinctive colouration is added by employing occasional pitch bends on notes.
The likelihood that a note will bend is determined using interrogation of a random
value, the result of which will dictate whether a conditional branch implementing
the pitch bend should be followed:
iprob
random
0,1
if iprob<=0.1 then
irange
random
-8,4
icurve
random
-4,4
abend
linseg
1,p3,semitone(irange)
aperc
=
aperc*abend
endif
The range of random values is from 0 to 1 and the conditional threshold is 0.1.
A similar approach is employed to apply a frequency-shifting effect to just some of
the notes. The frequency shifting is carried out using the hilbert transformation
opcode. This effect is reserved for the longer notes for reasons of efﬁciency – the
effect would be less perceivable in shorter notes. The code that conditionally adds
frequency shifting is shown below:
iprob2
random
0,1
if iprob2<=0.2&&p3>1 then
kfshift
transeg 0,p3,-15,rnd(200)-100
ar,ai
hilbert a1
asin
oscili
1, kfshift, gisine, 0
17.3 The Pieces
437
acos
oscili
1, kfshift, gisine, 0.25
amod1
=
ar*acos
amod2
=
ai*asin
a1
=
((amod1-amod2)/3)+a1
endif
Using GEN 17 we create a step function that deﬁnes the possible time gaps be-
tween consecutive notes in a layer and their probabilities. The table given below will
create the distribution shown in Fig. 17.15:
gigaps ftgen 0,0,-100,-17, 0,32,5,2,45,1/2,70,1/8,90,2/9
Fig. 17.15 Time gap distribution: the length of a horizontal line corresponding to a particular value
deﬁnes the probability of that value
A new time gap value between consecutive events will be chosen once every
second using an indexing variable created using a random sample and hold function.
Normalised indexing is used with the table opcode so that the indexing range for the
entire table ranges from 0 to 1. A trigger that will trigger notes is created using
metro, the frequency of which will be the reciprocal of the time gap. Random
values are selected and triggers are generated using the code snippet shown below:
kndx
randomh
0,1,1
kgap
table
kndx,gigaps,1
ktrig metro
1/kgap
438
17 Iain McCurdy: Csound Haiku
From the GEN 17 distribution table gigaps we can see that the majority of time
gaps will be 2 seconds. 5% of the time the gap duration value will be 32 seconds but
it is very unlikely this gap value will persist for an entire trigger period as new gap
values are generated every second. The instrument “layer” triggers the instrument
“note” and it determines its own duration, again by randomly selecting a value from
the distribution table gidurs (Fig. 17.16):
gidurs ftgen 0,0,-100,-17, 0,0.4, 85,4
Fig. 17.16 Note duration distribution
85% of note durations will be 0.4 seconds and only 15% will be 4 seconds but the
but the longer notes’ predominance will seem more signiﬁcant simply on account
of their longer persistence.
Listing 17.11 Csound Haiku VIII
ksmps = 32
nchnls = 2
0dbfs = 1
gigaps ftgen 0,0,-100,-17,0,32,5,2,45,1/2,70,1/8,90,2/9
gidurs
ftgen
0,0,-100,-17, 0,0.4, 85,4
giwave
ftgen
0,0,131072,10,1,0,0,0,0.05
gisine
ftgen
0,0,4096,10,1
gasendL init
0
gasendR init
0
seed
0
17.3 The Pieces
439
event_i
"i","start_layers",0,0
alwayson "reverb"
instr
start_layers
event_i "i","layer",0,3600*24*7
event_i "i","layer",0,3600*24*7
event_i "i","layer",0,3600*24*7
endin
instr
layer
kndx
randomh
0,1,1
kgap
table
kndx,gigaps,1
ktrig metro
1/kgap
knote randomh
0,12,0.1
kamp
rspline
0,0.1,1,2
kpan
rspline
0.1,0.9,0.1,1
kmul
rspline
0.1,0.9,0.1,0.3
schedkwhen ktrig,0,0,"note",rnd(0.1),0.01,int(knote)*3,\
kamp,kpan,kmul
endin
instr
note
iratio
=
int(rnd(20))+1
p3
table
rnd(1), gidurs, 1
aenv
expseg
1, p3, 0.001
aperc
expseg
5, 0.001, 1, 1, 1
iprob
random
0, 1
if iprob<=0.1 then
irange
random
-8, 4
icurve
random
-4, 4
abend
linseg
1, p3, semitone(irange)
aperc
=
aperc*abend
endif
kmul
expon
abs(p7), p3, 0.0001
a1
gbuzz
p5*aenv, cpsmidinn(p4)*iratio*aperc,\
int(rnd(500))+1,rnd(12)+1,kmul,giwave
iprob2
random
0,1
if iprob2<=0.2\&&p3>1 then
kfshift transeg 0, p3, -15, rnd(200)-100
ar,ai
hilbert a1
asin
oscili
1, kfshift, gisine, 0
acos
oscili
1, kfshift, gisine, 0.25
amod1
=
ar*acos
amod2
=
ai*asin
a1
=
((amod1-amod2)/3)+a1
440
17 Iain McCurdy: Csound Haiku
endif
a1
butlp
a1, cpsoct(rnd(8)+4)
a1,a2
pan2
a1, p6
a1
delay
a1, rnd(0.03)+0.001
a2
delay
a2, rnd(0.03)+0.001
outs
a1, a2
gasendL =
gasendL+a1*0.3
gasendR =
gasendR+a2*0.3
endin
instr
reverb
aL,aR
reverbsc gasendL, gasendR, 0.75, 10000
outs
aL, aR
clear
gasendL, gasendR
endin
17.3.9 Haiku IX
This piece is based around sweeping arpeggios that follow the intervals of the har-
monic series. The overlapping of steps of these arpeggios and the long attack and
decay times of their amplitude envelopes means that the result is more that of a
shifting spectral texture. The sequence of instruments used to generate arpeggios
and notes is shown in Fig. 17.17.
Fig. 17.17 Instrument schematic of Csound Haiku IX
The waveform used by the partials of these harmonic series sweeps is not a pure
sine wave but is itself a stack of sinusoidal elements from the harmonic series. The
notes of the arpeggios will often overlap so this use of a rich waveform will pro-
vide dense clustering of partials as the arpeggio sweeps. Each arpeggio plays for 25
seconds and the fundamental frequency ibas of this arpeggio is chosen randomly
at the start of this 25 seconds and does not change thereafter. The fundamental is
deﬁned using the following steps:
ibas
random
0,24
ibas
=
cpsmidinn((int(ibas)*3)+24)
Before conversion to a value in hertz, ibas can be an integer value within the
set 24, 27, 30, 96. As these are MIDI note numbers the interval between adjacent
17.3 The Pieces
441
possible fundamentals is always a minor third. This arrangement partly lends the
piece the mood attributed to a diminished arpeggio. The values for the frequency of
generation of arpeggios (krate in instrument “trigger arpeggio”), the rate of note
generation within an arpeggio (krate in instrument “arpeggio”) and the duration
of individual notes within an arpeggio have been carefully chosen to allow for the
generation of rich textures with many overlapping notes but also for the occasional
possibility of signiﬁcant pauses and silence between arpeggios. To permit these ex-
tremes, but rarely in close succession, allows the piece to maintain interest over a
number of minutes.
Listing 17.12 Csound Haiku IX
ksmps
= 32
nchnls = 2
0dbfs
= 1
gasendL
init
0
gasendR
init
0
giwave
ftgen
0,0,128, 10, 1, 1/4, 1/16, 1/64
giampscl1 ftgen
0,0,-20000,-16,1,20,0,1,19980,-20,0.01
seed
0
alwayson "trigger_arpeggio"
alwayson "reverb"
instr
trigger_arpeggio
krate
randomh
0.0005, 0.2, 0.04
ktrig
metro
krate
schedkwhennamed ktrig,0,0,"arpeggio",0,25
endin
instr
arpeggio
ibas
random
0, 24
ibas
=
cpsmidinn((int(ibas)*3)+24)
krate
rspline
0.1, 3, 0.3, 0.7
ktrig
metro
krate
kharm1 rspline
1, 14, 0.4, 0.8
kharm2 random
-3, 3
kharm
mirror
kharm1+kharm2, 1, 23
kamp
rspline
0, 0.05, 0.1, 0.2
schedkwhen ktrig,0,0,"note",0,4,ibas*int(kharm),kamp
endin
instr
note
aenv
linsegr
0, p3/2, 1, p3/2, 0, p3/2, 0
iampscl
table
p4, giampscl1
442
17 Iain McCurdy: Csound Haiku
asig
oscili
p5*aenv*iampscl, p4, giwave
adlt
rspline
0.01, 0.1, 0.2, 0.3
adelsig
vdelay
asig, adlt*1000, 0.1*1000
aL,aR
pan2
asig+adelsig, rnd(1)
outs
aL, aR
gasendL
=
gasendL+aL
gasendR
=
gasendR+aR
endin
instr
reverb
aL, aR
reverbsc gasendL,gasendR,0.88,10000
outs
aL, aR
clear
gasendL,gasendR
endin
17.4 Conclusions
The Csound Haiku pieces provide a demonstration of Csound’s ability to jettison the
traditional score in favour of notes being generated in the orchestra in real time. In-
struments no longer need be regarded merely as individual synthesisers; their roles
can be as generators of notes for other instruments or as generators of global vari-
ables for use by multiple iterations of later instruments. It has also been shown
that these note-generating instruments can be chained in series to multiply the note
structures formed. Some of the techniques used for note generation can be described
as algorithmic composition and to this end a number of Csound’s opcodes for ran-
dom value and function generation have been employed. Extensive use was made
of rspline and jspline for the generation of random spline functions. These
opcodes were found to be particularly strong at generating natural ﬂowing gestures
when applied to a wide range of synthesis and note generation parameters. These
pieces also exemplify the richness of some of Csound’s opcodes for sound synthesis
and also the brevity of code with which they can be deployed.
