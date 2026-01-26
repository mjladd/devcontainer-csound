# 3. The audio-rate oscillator takes the values in #k2 and kfc as its amplitude and

3. The audio-rate oscillator takes the values in #k2 and kfc as its amplitude and
frequency and produces a vector of ksmps samples that is stored in asig.
Note that the order is determined line by line. So, if the instrument were written
as
k1 init 0
asig oscili k1+p4,kfc
k1 oscili kndx, kfm
then the execution order would be different, with the audio oscillator (the carrier)
producing its output before the modulator runs in the same k-cycle. Note that in
order for the compiler to accept this, we need to explicitly initialise the variable k1.
This also means that the modulator will be delayed in relation to the carrier. This
is not a natural way to set up an instrument, but in some situations we might want
to re-order the signal graph to realise a speciﬁc effect. For instance, if we want to
create a feedback path, we need to order things in a precise way:
asig init 0
asig oscili asig+p4,kfc
In this case, we are feeding the output of the oscillator into its own amplitude
input, a set up that is called feedback amplitude modulation (FBAM) [59]. There
will always be a one-ksmps block delay in the feedback path. In Csound, it is easy
to be very clear about how the signal path and execution sequence are constructed,
with the language generally helping us to use the most natural order of operations
without any extra effort.
6.3 Execution Order
All active instances of instruments will perform once in each k-cycle. While the
execution order of unit generators in an instrument is determined by their place
in the code, the performance of instruments and their instances is organised in a
different way, although this is also clear and well deﬁned. The sequence of execution
is particularly important when we start connecting one instrument to another via the
various types of busses.
128
6 Signal Graphs and Busses
6.3.1 Instances
When two or more instances of the same instrument are running at the same time,
their order of performance is deﬁned by the following rules:
1. if the value of their p1 is the same, then they are ordered by their instantiation
time; if that is the same, then they are performed according to the event order.
2. if the value of their p1 differs (in the case of fractional values for p1, which can
be used to identify speciﬁc instances), then the order is determined by ascending
p1.
For instance, the following events with p4 set to 1, 2, 3 (to label their instances)
schedule(1,0,1,1)
schedule(1,0,2,2)
schedule(1,1,1,3)
will be performed in order 1, 2 (0-1 seconds), and then 2, 3 (1-2 seconds). However,
the following events with different p1 values
schedule(1.03,0,1,1)
schedule(1.02,0,2,2)
schedule(1.01,1,1,3)
will execute in the order (p4 labels) 2, 1 and 3, 2. So a fractional p1 value can also
be used to control the sequence in which instances are performed.
Note that these rules apply only to performance-time execution, which is nor-
mally where they matter more. The init-time sequence, in the case of events of the
same instrument starting at the same time, is always determined by their instantia-
tion order, and disregards any difference in the values of their p1.
6.3.2 Instruments
The execution sequence of instruments at performance time is determined by their
number, in ascending order. So in a k-cycle, lower-number instrument instances are
performed ﬁrst. For this reason, if we have an instrument that is supposed to receive
input from others, then we should try to give it a high number. If an instance of
one instrument receives audio or control signals from a higher-order source, then
there will always be a one-k-period delay in relation to it. While this might not be
signiﬁcant at times, it can be crucial in some applications, and so it is important to
make sure the order of performance is exactly as we want it.
Again, these rules are only relevant to performance time. The order of init-pass
execution is determined by the time/sequence in which events are scheduled, re-
gardless of instrument order. In summary, within one k-cycle, opcodes, functions
and operators are executed in the order they appear in an instrument (and according
6.4 Busses
129
to speciﬁc precedence rules in the case of arithmetic); instances of the same instru-
ment are ordered by schedule time and sequence, or by ascending p1; instances of
different instruments are executed in ascending order.
Named instruments
Named instruments are transformed internally into numbers, in the order in which
they appear in the orchestra. To achieve a desired sequence of execution, we must
take notice of this and organise them by their line numbers. We should also avoid
mixing named and numbered instruments.
6.4 Busses
An extension of the patch-cord metaphor, the bus is an element used to take signals
from one or more sources and deliver them to one or more destinations. The end
points of a bus are different instrument instances, and so they work as global patch-
cords between different parts of the code. The role of a bus is very important if we
want to implement things such as global effects and various types of modulation
connections. Busses can be implemented in a variety of ways. In this section, we
will examine the different possibilities and their applications.
6.4.1 Global Variables
Global variables are the original means of connecting instruments. Any internal type
can be made global by adding a g in front of its name, including arrays:
gasig, gavar[]
gksig, gkvar[]
gival, givar[]
gfsig, gfsp[]
gStr, gSname[]
As with local variables, before global variables are used as input, they need to
be explicitly declared or used as an output. In many cases, this means we need to
initialise them in global space, before they can be used as busses:
gasig init 0
The usual practice is to add the source signal to the bus, possibly with a scaling
factor (p6 in this case):
instr 1
asrc oscili p4, p5
130
6 Signal Graphs and Busses
out asrc
gasig += asrc*p6
endin
where the += operator adds the right-hand side to the contents of the left-hand side.
The reason for doing this is to avoid an existing source signal being overwritten by
another. By summing into the bus, instead of assigning to it, we can guarantee that
multiple sources can use it. At a higher-order instrument, we can read the bus, and
use the signal:
instr 100
arev reverb gasig, 3
out arev
endin
The bus signal can feed other instruments as required. Once all destinations have
read the bus, we need to clear it. This is very important, because as the signals are
summed into it, the bus will accumulate and grow each k-cycle, if left uncleared.
We can do this inside the last instrument using it, or in one with the speciﬁc purpose
of clearing busses:
instr 1000
gasig = 0
endin
In addition to audio variables, it is also possible to send other types of signals
in global variable busses, including controls, spectral signals and strings. Arrays
of global variables can also be very useful if we want to create ﬂexible means of
assigning busses. Listing 6.1 shows how we can use an array to route signals to
different effects, depending on an instrument parameter (p6).
Listing 6.1 Using an array to route signals to two different effects
gabuss[] init 2
instr 1
aenv expseg 0.001,0.01,1,p3,0.001
asig oscili aenv*p4,p5
out asig
gabuss[p6] = asig*0.5 + gabuss[p6]
schedule(1,0.1,0.3,
rnd(0.1)*0dbfs,
500+gauss(100),
int(rnd(1.99)))
endin
schedule(1,0,0.5,
0dbfs*0.1,
500,0)
6.4 Busses
131
instr 100
arev reverb gabuss[0],3
out arev
gabuss[0] = 0
endin
schedule(100,0,-1)
instr 101
adel comb gabuss[1],4,0.6
out adel
gabuss[1] = 0
endin
schedule(101,0,-1)
The sound-generating instrument 1 calls itself recursively, randomly selecting
one of the two effect busses. Note that we have to explicitly add the signal to the
bus, with the line
gabuss[p6] = asig*0.5 + gabuss[p6]
as the += operator is not deﬁned for array variables.
6.4.2 Tables
Function tables are another type of global objects that can be used to route signals
from instrument to instrument. Because they can store longer chunks of data, we can
also use them to hold signals for a certain amount of time before they are consumed,
and this can allow the reading and writing to the bus to become decoupled, asyn-
chronous. In listing 6.2, we have an application of this principle. A function table is
allocated to have a 5-second length, rounded to a complete number of ksmps blocks.
Instrument 1 writes to it, and instrument 2 reads from it, backwards. The result is
a reverse-playback effect. The code uses one source and one destination, but it is
possible to adapt for multiple end points.
Listing 6.2 Using a function table to pass audio signals asynchronously from one instrument to
another
idur = 5
isamps = round(idur*sr/ksmps)*ksmps
gifn ftgen 0,0,-isamps,2,0
instr 1
kpos init 0
asig inch 1
tablew asig,a(kpos),gifn
kpos += ksmps
132
6 Signal Graphs and Busses
kpos = kpos == ftlen(gifn) ? 0 : kpos
endin
schedule(1,0,-1)
instr 2
kpos init ftlen(gifn)
asig table a(kpos),gifn
kpos -= ksmps
kpos = kpos == 0 ? ftlen(gifn) : kpos
out asig
endin
schedule(2,0,-1)
Tables can also be used to route conveniently control signals, as these consist of
single variables and so each table slot can hold a control value. Using tablew and
table opcodes, we can write and read these signals. A more complex approach is
provided by the modmatrix opcode, which uses function tables to create complex
routings of modulation signals. It uses three tables containing the input parameters,
the modulation signals and the scaling values to be applied. It writes the resulting
control signals into another table:
R = I +M ×S
(6.1)
where I is a vector of size n containing the input parameters, M is a vector of size
m containing the modulation values, and S is a scaling matrix of size m × n with
the scaling gains for each modulation signal. The resulting vector R contains the
combined modulation sources and inputs for each parameter n. For example, let’s
say we have two modulation sources, three parameters and a modulation matrix to
combine these:
#
0.4 0.6 0.7
$
+
#
0.75 0.25
$
×
!
0.1 0.5 0.2
0.5 0.1 0.3
"
=
#
0.6 1.0 0.925
$
(6.2)
The vectors and matrix are deﬁned as function tables. In the case of eq. 6.2, we
would have:
ipar ftgen 1,0,3,-2, 0.4, 0.6, 0.7
imod ftgen 2,0,2,-2, 0.75, 0.25
iscal ftgen 3,0,6,-2,0.1,0.5,0.2,0.5,0.1,0.3
ires
ftgen 4,0,3,2, 0,0,0
where ipar, imod, and iscal are the tables for input parameters, modulation
sources and scaling matrix, respectively. Note that the matrix is written in row,
column format. The results are held in a table of size three, which is represented
by ires. Tables can be initialised using any GEN routine (here we used GEN 2,
which just copies its parameter values to each table position). The modmatrix
opcode itself is deﬁned as:
6.4 Busses
133
modmatrix ires, imod, ipar, iscal, inm, inn, kupdt
The ﬁrst four parameters are the table numbers for results, modulation, parame-
ters and scaling matrix. The arguments inm and inn are the number of sources and
parameters, respectively. The kupdt parameter is set to non-zero to indicate that
the scaling matrix has changed. This should be zero otherwise, to make the opcode
run efﬁciently. It is expected that the modulation signals and input parameters will
be written into the table as necessary (using tablew), and that the results will be
read using table at every k-cycle. Only one instance of the opcode is needed to
set a modulation matrix, and the sources and destinations can be spread out through
the instruments in the code. A simple example using the tables above is shown in
listing 6.3
Listing 6.3 Modulation matrix example using two sources and three destinations
gipar ftgen 1, 0, 3, -2, 0.4, 0.6, 0.7
gimod ftgen 2, 0, 2, -2, 0, 0
giscal ftgen 3, 0, 6, -2,0.1,0.5,0.2,0.5,0.1,0.3
gires ftgen 4, 0,3,2,0,0,0
instr 1
k1 oscili p4,p5
tablew k1,p6,gimod
endin
schedule(1,0,-1,1,0.93,0)
schedule(1,0,-1,1,2.05,1)
instr 2
kenv linen p4,0.01,p3,0.1
k1 table p6,gires
a1 oscili k1*kenv,p5
out a1
schedule(2,0.5,1.5,
rnd(0.1)*0dbfs,
500+gauss(400),
int(rnd(2.99)))
endin
schedule(2,0,1.5,0dbfs*0.1,500,0)
instr 10
kupdt init 1
modmatrix gires,gimod,gipar,giscal,2,3,kupdt
kudpt = 0
endin
schedule(10,0,-1)
In this example, we have two modulation sources (low-frequency oscillators,
LFOs, at 0.93 and 2.05 Hz), and distribute a combination of these modulations to
134
6 Signal Graphs and Busses
three independent destinations, modulating their amplitude. The sound generating
instrument 2 is recursively called, randomly picking a different destination (from
gires) number out of three choices (p6). In this example, we do not update the
scaling matrix, and also keep the parameter offset values ﬁxed (in gipar). Note
that the modulation table values will change every k-cycle (0.75 and 0.25 were only
used as sample values for eq. 6.2), as the LFOs oscillate, so we just initialise the
gimod table with zeros.
6.4.3 Software Bus
Csound also includes a very powerful software bus, which can be used by frontends
and hosts to connect with external controls and audio signals, via API calls. It is
also available to be used internally by instruments to communicate with each other.
In these applications, it can replace or add to the other methods discussed above. It
can be used freely with i-, k-, a- and S-variables.
The software bus works with a system of named channels, which can be opened
for reading, writing and bidirectionally. When used internally, they always work in
bidirectional mode (as we will be both sending and receiving data inside a Csound
orchestra). These channels can optionally be declared and initialised using the fol-
lowing opcodes for audio, strings and control data, respectively:
chn_a Sname, imode
chn_S Sname, imode
chn_k Sname, imode
Channels are given an Sname, which will identify them, and set read-only
(imode = 1), write-only (2), or both (3). To set the value of a channel, we use
chnset xvar, Sname
where the type of xvar will depend on the kind of channel being set (string, audio,
or control). For audio channels, we also have
chnmix avar, Sname
for summing into a channel, rather than overwriting it. Once we have consumed the
audio, we need to clear it (as we have seen with global variables):
chnclear Sname
Once a channel exists, data can be read from it using
xvar chnget Sname
The software bus can be used instead of global variables. Listing 6.4 shows an
example where a source instrument copies its output to a channel called reverb,
which is then read by an instrument implementing a global reverberation effect.
6.4 Busses
135
Listing 6.4 Using the software bus to send signals to a reverb effect
instr Sound
aenv linen p4, 0.01,p3,0.1
asrc oscili aenv, p5
out asrc
chnmix asrc*p6, "reverb"
endin
schedule("Sound",0,0.5, 0dbfs/4, 400, 0.1)
schedule("Sound",1,0.5, 0dbfs/4, 500, 0.2)
schedule("Sound",2,0.5, 0dbfs/4, 300, 0.4)
instr Reverb
asig chnget "reverb"
arev reverb asig, 3
out arev
chnclear "reverb"
endin
schedule("Reverb",0,-1)
It is also possible to access the software bus from global variables, by linking
them together through the chnexport opcode:
gxvar chnexport Sname, imode
This mechanism allows a channel to be accessible directly through a global vari-
able.
As channels can be created dynamically, with unique names which are generated
on the ﬂy, they offer an easy way to communicate between instrument instances
whose number is not yet deﬁned at the beginning of the performance. Listing 6.5
demonstrates this by dynamically generating channel names.
Listing 6.5 Generating channel names dynamically
seed 0
giCount init 0
instr Create_Sender
kCreate metro randomh:k(1,5,1,3)
schedkwhen kCreate,0,0,"Sender",0,p3
endin
schedule("Create_Sender",0,2.5)
instr Sender
giCount += 1
S_chn sprintf "channel_%d", giCount
schedule "Receiver",0,p3,giCount
chnset randomh:k(1,100,1,3),S_chn
endin
136
6 Signal Graphs and Busses
instr Receiver
kGet chnget sprintf("channel_%d",p4)
if changed(kGet)==1 then
printks "time = %.3f, channel_%d = %d\n",0,times:k(),
p4,kGet
endif
endin
The printout will show something like this:
time = 0.006, channel_1 = 50
time = 0.215, channel_2 = 23
time = 0.424, channel_3 = 95
time = 0.630, channel_4 = 95
time = 0.839, channel_5 = 44
time = 1.007, channel_1 = 77
time = 1.112, channel_6 = 25
time = 1.216, channel_2 = 63
time = 1.425, channel_3 = 30
time = 1.631, channel_4 = 83
time = 1.646, channel_7 = 41
time = 1.840, channel_5 = 61
time = 2.009, channel_1 = 62
time = 2.113, channel_6 = 65
time = 2.125, channel_8 = 94
time = 2.218, channel_2 = 59
time = 2.426, channel_3 = 84
time = 2.485, channel_9 = 85
time = 2.633, channel_4 = 26
time = 2.647, channel_7 = 30
time = 2.842, channel_5 = 64
time = 3.114, channel_6 = 24
time = 3.126, channel_8 = 25
time = 3.486, channel_9 = 57
time = 3.648, channel_7 = 91
time = 4.127, channel_8 = 61
time = 4.487, channel_9 = 9
The schedkwhen opcode is used to generate events at performance time, de-
pending on a non-zero trigger (its ﬁrst argument), which can be taken conveniently
from a metro instance that produces such values periodically.
6.5 Conclusions
In this chapter, we reviewed the principles underlying the construction of signal
graphs for instruments. We saw that inside each instrument, execution is sequential,
6.5 Conclusions
137
line by line, and that, in some cases, operations are unwrapped by the compiler into
separate steps. Variables are used as patch-cords to link unit generators together,
explicitly, in the case of the ones declared in the code, and implicitly, when the
compiler creates hidden, synthetic variables. We have also noted how the language
coerces the user into employing the most natural connections, but there is full con-
trol of the execution sequence, and we can easily program less usual signal paths,
such as feedback links.
The order of execution of instruments was also detailed. In summary, same-
instrument instances will be performed by event and start time order, unless they
use fractional p1 values, in which case this will be used as the means to determine
the execution sequence inside a k-cycle. Different instruments are ordered by as-
cending p1, so higher-numbered ones will always come last in the sequence. We
have also noted that this only applies to performance time, and the init-pass is al-
ways executed in event order.
The chapter concluded with a look at different ways we can connect instruments
together, concentrating on global variables, function tables and the software bus.
We saw how global variables can be used as busses, which can be fed from several
sources and have multiple destinations. These are very ﬂexible means of connect-
ing instruments, but care needs to be taken to clear the variables after use. Function
tables are also global code objects that can be used to connect instruments, in partic-
ular if we want to do it in a decoupled way. They can also hold control signals, and
the modmatrix opcode provides an added facility to distribute modulation sources
around instruments. Finally, we introduced the software bus, which can be used to
connect Csound with external controls provided by hosts or frontends, and also to
link up instruments internally, implementing busses to send signals from different
sources to various destinations.
