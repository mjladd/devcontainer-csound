# 3. Run the perf-time subroutine, if it exists, in the performance loop, repeating it at

3. Run the perf-time subroutine, if it exists, in the performance loop, repeating it at
every k-period. Again, the opcode state will be updated as required every time
this subroutine is run.
66
3 Fundamentals
Each opcode that is placed in an instrument will have its own separate state, and
will use the subroutines that have been assigned to it.
3.4.2 Syntax
There is a straightforward syntax for opcodes, which is made up of output variable(s)
on the left-hand side of the opcode name, and input arguments (parameters) on the
right-hand side. Multiple output variables and arguments are separated by commas
[var, ...]
opname
[arg, ...]
The number and types of arguments and outputs will depend on the opcode. Some
opcodes might have optional inputs, and allow for a variable number of outputs. The
Reference Manual provides this information for all opcodes in the system. In any
case, expressions that can be evaluated to a given argument type are accepted as
inputs to opcodes.
An alternative syntax allows some opcodes to be used inline inside expressions:
[var =]
opname[:r]([arg, ...])
In this case, we see that the opcode arguments, if any, are supplied inside paren-
theses, and its output needs to be assigned to an output variable (if needed). The
whole opcode expression can now be used as one of the arguments to another op-
code, or as part of an expression. If it is used on its own and it produces an output,
we need to use the assignment operator (=) to store it in a variable. If used as an
input to an opcode, we might need to explicitly determine the output rate (r) with
:i, :k or :a after the opcode name (see Sec. 3.4.4). It is also important to note that
this syntactical form is only allowed for opcodes that have either one or no outputs.
Table 3.1 shows some examples of equivalence between the original and alternative
syntax forms.
Table 3.1 Comparison between original and alternative syntaxes for opcodes
original
alternative
print 1
print(1)
printk 0,kvar
printk(0,kvar)
schedule 1,0,1
schedule(1,0,1)
out asig
out(asig)
a1 oscili 0dbfs, 440
a1 = oscili(0dbfs, 440)
Both forms can be intermixed in a program, provided that their basic syntax rules
are observed correctly. In this book, we will use these liberally, so that the reader
can get used to the different ways of writing Csound code.
3.4 Opcodes
67
3.4.3 Functions
Csound also includes a set of functions. Functions do not have state like op-
codes. A function is strictly designed to produce an output in response to given in-
puts, and nothing else. Opcodes, on the other hand, will store internal data to manage
their operation from one execution time to another. Function syntax is similar to the
second opcode syntax shown above:
var =
function(arg[, ...])
The main difference is that functions will have at least one argument and produce
one output. They can look very similar to opcodes in the alternative (‘function-like’)
usage, but the fact that they operate slightly differently will be important in some
situations.
A typical example is given by trigonometric functions, such as sin() and
cos(). We can use these in an instrument to generate sinusoidal waves, which
are a fundamental type of waveform. This is easily done by adapting the audio ex-
ample in listing 3.12, where we created a ramp waveform. We can use this ramp as
an input to the sin() function, and make it generate a sine wave. For this, we only
need to keep the ramp ranging from 0 to 1, and scale it to a full cycle in radians
(2π).
Listing 3.13 A sine wave synthesis instrument
instr 1
i2pi = 6.28318530
aramp init 0
out(sin(aramp*i2pi)*p4)
aramp += a(1/kr)*p5
aramp = aramp%1
endin
schedule(1,0,10,0dbfs/2,440)
As the input to sin() rises from 0 to 2π, a sine waveform is produced at the
output. This will be a clean sinusoidal signal, even though we are using very basic
means to generate it. A plot of the output of instr 1 in listing 3.13 is shown in Fig.3.2.
3.4.4 Initialisation and Performance
Opcodes can be active at the init-pass and/or performance time. As noted before,
some will be exclusively working at i-time. Usually an opcode that is used at perf-
time will also include an initialisation stage that is used to set or reset its internal
state to make it ready for operation. Some of them have options to skip this initiali-
sation, if the state from a previously running instance is to be preserved as the new
one takes over its space. There are some cases, however, where there is no activity
at the init-pass. In general, we should not expect that a k-var output of an opcode
68
3 Fundamentals
Fig. 3.2 A sinusoidal wave, the output of the instr 1 in listing 3.13
has any meaningful value at i-time, even if an opcode has performed some sort of
initialisation procedure.
There are many opcodes that are polymorphic [40], meaning that they can have
different forms depending on their output or input types. For instance, an opcode
such as oscili will have four different implementations:
1. k oscili k,k: k-rate operation
2. a oscili k,k: a-rate operation, both parameters k-rate
3. a oscili k,a: ﬁrst parameter k-rate, second a-rate
4. a oscili a,k: ﬁrst parameter a-rate, second k-rate
5. a oscili a,a: both parameters a-rate.
These forms will be selected depending on the input and output parameters. In
normal opcode syntax, this is done transparently. If we are using the alternative
function-like syntax, then we might need to be explicit about the output we want to
produce by adding a rate hint (:r, where r is the letter indicating the required form).
Many functions will also be polymorphic, and specifying the correct input type is
key to make them produce output of a given rate, as demonstrated for rnd() in
listings 3.10 and 3.11.
3.5 Fundamental Opcodes
69
3.5 Fundamental Opcodes
The core of the Csound language is its opcode collection, which is signiﬁcantly
large. A small number of these are used ubiquitously in instruments, as they perform
fundamental signal processing functions that are widely used. We will discuss here
the syntax and operation of these key opcodes, with various examples of how they
can be employed.
3.5.1 Input and Output
A number of opcodes are designed to get audio into and out of an instrument. De-
pending on the number of channels, or how we want to place the audio, we can use
different ones. However, it is possible to just use a few general purpose opcodes,
which are
asig in
; single-channel input
ain1[, ...] inch kchan1[,...]
; any in channels
out asig[,...]
;
any number of out channels
outch kchan1, asig1 [,...,...] ; specify out channel
For input, if we are using channel 1 only, we can just use in. If we need more
input channels, and/or switch between these at k-time (using the kchan parame-
ter), we can use inch. For audio output, out will accept any number of signals up
to the value of nchnls. All the examples in this chapter used the default number
of channels (one), but if we want to increase thia, we can set the system constant
nchnls, and add more arguments to out. A speciﬁc output channel can be as-
signed with outch, for easy software routing. Refer to Section 2.8 for more details
on the audio IO subsystem.
3.5.2 Oscillators
Oscillators have been described as the workhorse of sound synthesis, and this is
particularly the case in computer music systems. It is possible to create a huge vari-
ety of instruments that are solely based on these opcodes. The oscillator is a simple
unit generator designed to produce periodic waveforms. Given that many useful sig-
nals used in sound and music applications are of this type, it is possible to see how
widespread the use of these opcodes can be. The oscillator works by reading a func-
tion that is stored in a table (see Section 2.7) repeatedly at a given frequency. This
allows it to produce any signal based on ﬁxed periodic shapes.
There are four operational stages in an oscillator [67]:
1. table lookup: read a sample of a function table at a position given by an index n.
70
3 Fundamentals
2. scaling: multiply this sample by a suitable amplitude and produce an output.
3. increment: increment the position of index n for a given frequency f0 depending
on the sampling rate (sr) and table size (l). This means adding incr to n for each
sample:
incr = l
sr × f0
(3.3)
This step is called phase or sampling increment (phase is another name for index
position).
4. wrap-around: when n exceeds the table size it needs to be wrapped back into its
correct range [0,l). This a modulus operation, which needs to be general enough
to work with positive and negative index values.
It is possible to see that we have effectively implemented an oscillator in our ﬁrst
two audio examples (listings 3.12 and 3.13), without a table lookup but using all
the other steps, 2, 3 and 4. In these instruments, the increment is calculated at the
k-rate, so we use kr as the sampling rate, and its maximum value is 1 (l = 1 and
sr = kr makes eq. 3.3 the same as eq. 3.1). In the ﬁrst example, the process is so
crude that we are replacing step 1 by just outputting the index value, which is one of
the reasons it sounds very noisy. In the second case, we do a direct sin() function
evaluation. This involves asking the program to compute the waveform values on
the spot. Table lookup replaces this by reading a pre-calculate sine function that is
stored on a table.
There are three types of original oscillator opcodes in Csound. They differ in the
way the table-lookup step is performed. Since table positions are integral, we need
to decide what to do when an index is not a whole number, and falls between two
table positions. Each oscillator type treats this in a different way:
1. oscil: this opcode truncates its index position to an integer, e.g index 2.3 be-
comes 2.
2. oscili: performs a linear interpolation between adjacent positions to ﬁnd the
output value. Index 2.3 then makes the table lookup step take 70% (0.7) of the
value of position 2 and 30% (0.3) of the next position, 3.
3. oscil3: performs a cubic interpolation where the four positions around the
index value are used. The expression is a fourth-order polynomial involving the
values of these four positions. So, for index 2.3, we will read positions 1,2,3 and
4 and combine them, with 2 and 3 contributing more to the ﬁnal lookup value
than 1 and 4.
There are two consequences to using these different types: (a) the lookup pre-
cision and quality of the output audio increase with interpolation [89]; (b) more
computation cycles are used when interpolating. It is a consensus among users that
in modern platforms the demands of low-order interpolation are not signiﬁcant, and
that we should avoid using truncating oscillators like oscil, because of their re-
duced audio quality.2
2 In addition to these oscillators, Csound offers poscil and poscil3, discussed later in the
book.
3.5 Fundamental Opcodes
71
The full syntax description of an oscillator is (using oscili as an example):
xsig
oscili
xamp, xfreq [,ifn, iph]
or, using the alternative form:
[xsig
=]
oscili[:r](xamp, xfreq [,ifn, iph])
Oscillators are polymorphic. They can work at audio or control rates (indicated
by the xsig in the description), and can take amplitude (xamp) and frequency
(xfreq) as i-time, k-rate or a-rate values (however the output cannot be a rate
lower than its input). Amplitudes, used in step 2 above, will range between 0 and
0dbfs. Frequencies are given in Hz (cycles per second). There are two optional
arguments: ifn, which is an optional table number, and iph the oscillator starting
phase, set between 0 and 1. The default values for these are -1 for ifn, which is
the number of a table containing a sine wave created internally by Csound, and 0
for phase (iph). With an oscillator, we can create a sine wave instrument that is
equivalent to the previous example in listing 3.13, but more compact (and efﬁcient).
Listing 3.14 A sine wave synthesis instrument, using oscili
instr 1
out(oscili(p4, p5))
endin
schedule(1,0,10,0dbfs/2,440)
Connecting oscillators: mixing, modulating
Opcodes can be connected together in a variety of ways. We can add the output of a
set of oscillators to mix them together.
Listing 3.15 Mixing three oscillators
instr 1
out((oscili(p4, p5) +
oscili(p4/3,p5*3) +
oscili(p4/5,p5*5))/3)
endin
schedule(1,0,10,0dbfs/2,440)
The oscillators are set to have different amplitudes and frequencies, which will
blend together at the output. This example shows that we can mix any number of
audio signals by summing them together. As we do this, it is also important to pay at-
tention to the signal levels so that they do not exceed 0dbfs. If that happens, Csound
will report samples out of range at the console, and the output will be distorted
(clipped at the maximum amplitude). In listing 3.15, we multiply the mix by 1/3, so
that it is scaled down to avoid distortion.
We can also make one oscillator periodically modify one of the parameters of
another. This is called amplitude or frequency modulation, depending on which pa-
72
3 Fundamentals
rameter the signal is applied to. Listing 3.16 shows two instruments, whose ampli-
tude (1) and frequency (2) are modulated. The resulting effects are called tremolo
and vibrato, respectively.
Listing 3.16 Two modulation instruments
instr 1
out(oscili(p4/2 + oscili:k(p4/2, p6), p5))
endin
schedule(1,0,5,0dbfs/2,440,3.5)
instr 2
out(oscili(p4, p5 + oscili:k(p5/100,p6)))
endin
schedule(2,5,5,0dbfs/2,440,3.5)
Note that we are explicit about the rate used for the modulation opcodes. Here
we are using the control rate since we have low-frequency oscillators (LFOs), whose
output can be classed as control signals. LFOs are widely used to modulate param-
eters of sound generators3. When modulating parameters with audio-range frequen-
cies (> 20 Hz), we are required to use a-rate signals. This is the case of frequency
modulation synthesis, studied in Chapter 12.
Phasors
Steps 3 and 4 in the oscillator operation, the phase increment and modulus, are
so fundamental that they have been combined in a speciﬁc unit generator, called
phasor:
xsig
phasor
xfreq [,iph]
The output of this opcode is a ramp from 0 to 1, repeated at xfreq Hz (similar to
the code in listing 3.12). Phasors are important because they provide a normalised
phase value that can be used for a variety of applications, including constructing
an oscillator from its constituent pieces. For example, yet another version of a sine
wave oscillator (cf. listing 3.14) can be created with the following code:
instr 1
i2pi = 6.28318530
out(p4*sin(i2pi*phasor(p5)))
endin
3 However, you should be careful with zipper noise as discussed in a previous chapter. If ksmps is
large (e.g. above 64 samples), then it is advisable to use audio signals as modulators. For a clean
result that is independent of the control rate, always use audio-rate modulators and envelopes.
3.5 Fundamental Opcodes
73
3.5.3 Table Generators
Oscillators can read arbitrary functions stored in tables. By default, they read table
-1, which contains a sine wave. However, Csound is capable of generating a variety
of different function types, which can be placed in tables for oscillators to use. This
can be done with the opcode ftgen:
ifn ftgen inum, itime, isize, igen, ipar1 [, ipar2, ...]
This generator executes at init-time to compute a function and store it in the
requested table number. It can take several arguments:
inum: table number
itime: generation time
isize: table size
igen: function generator routine (GEN) code
ipar1,...: GEN parameters.
It returns the number of the table created (stored in ifn). If the inum argument
is 0, Csound will ﬁnd a free table number and use it, otherwise the table is placed in
the requested number, replacing an existing one if there is one. The generation time
can be 0, in which case the table is created immediately, or it can be sometime in
the future (itime > 0). Most use cases will have this parameter set to 0.
The table size determines how many positions (points, numbers) the table will
hold. The larger the table, the more ﬁnely deﬁned (and precise) it will be. Tables
can be constructed with arbitrary sizes, but some opcodes will only work with table
lengths that are set to power-of-two or power-of-two plus one. The oscil, oscili
and oscil3 opcodes are examples of these.
The size will also determine how the table guard point (see Section 2.7) is set. For
all sizes except power-of-two plus one, this is a copy of the ﬁrst point of the table
(table[N] = table[0], where N is the size of the table), otherwise the guard point
is extended, a continuation of the function contour. This distinction is important
for opcodes that use interpolation and read the table in a once-off fashion, i.e. not
wrapping around. In these cases, interpolation of a position beyond the length of
the table requires that the guard point is a continuation of the function, not its ﬁrst
position. In listing 3.17, we see such an example. The table is read in a once-off way
by an oscillator (note the frequency set to 1
p3, i.e. the period is equal to the duration
of the sound), and is used to scale the frequency of the second oscillator. The table
size is 16,385, indicating an extended guard point, which will be a continuation of
the table contour.
Listing 3.17 Two modulation instruments
ifn ftgen 1,0,16385,-5,1,16384,2
instr 1
k1 oscili 1,1/p3,1
a1 oscili p4,p5*k1
out a1
74
3 Fundamentals
endin
schedule(1,0,10,0dbfs/2,440)
The type of function is determined by the GEN used. The igen parameter is a
code that controls two aspects of the table generation: (a) the function generator; (b)
whether the table is re-scaled (normalised) or not. The absolute value of igen (i.e.
disregarding its sign) selects the GEN routine number. Csound has over thirty types
of this, which are described in the Reference Manual. The sign of igen controls re-
scaling: positive turns it on, negative suppresses it. Normalisation scales the created
values to the 0 to 1 range for non-negative functions, and -1 to 1 for bipolar ones.
The table in listing 3.17 uses GEN 5, which creates exponential curves, and it is not
re-scaled (negative GEN number).
The following arguments (ipar,...) are parameters to the function generator,
and so they will be dependent on the GEN routine used. For instance, GEN 7 creates
straight lines between points, and its arguments are (start value, length in points,
end value) for each segment required. Here is an example of a trapezoid shape using
three segments:
isize = 16384
ifn ftgen 1, 0,
isize,
7,
0, isize*0.1, 1,isize*0.8, 1, isize*0.1, 0
Fig. 3.3 Plot of a function table created with GEN 7 in listing 3.18
This function table goes from 0 to 1 in 10% (0.1) of its length, stays at 1 for a
further 80%, and goes back down to 0 in the ﬁnal 10% portion. Since tables can be
used freely by various instrument instances, we should create them in global space.
Listing 3.18 shows an example of an instrument that uses this function table. We
will use an oscillator to read it and use its output to control the amplitude of a sine
wave.
Listing 3.18 An instrument using a function table to control amplitude
isize = 16384
ifn ftgen 1, 0,
isize,
7,
0, isize*0.1, 1,isize*0.8, 1, isize*0.1, 0
instr 1
kenv
oscili
p4, 1/p3, 1
3.5 Fundamental Opcodes
75
asig
oscili
kenv, p5
out
asig
endin
schedule(1,0,10,0dbfs/2,440)
This example shows how oscillators can be versatile units. By setting the fre-
quency of the ﬁrst oscillator to
1
p3, we make it read the table only once over the
event duration. This creates an amplitude envelope, shaping the sound. It will elim-
inate any clicks at the start and end of the sound. The various different GEN types
offered by Csound will be introduced in later sections and chapters, as they become
relevant to the various techniques explored in this book.
3.5.4 Table Access
Another fundamental type of unit generator, which also uses function tables, is the
table reader. These are very basic opcodes that will produce an output given an index
and a table number. Like oscillators, they come in three types, depending on how
they look up a position: table (non-interpolating), tablei (linear interpolation)
and table3 (cubic interpolation). Table readers are more general-purpose than
oscillators, and they can produce outputs at i-time, k-rate and a-rate, depending
on what they are needed for. Their full syntax summary is (using table as an
example).
xvar
table
xndx, ifn[, imode, ioff, iwrap]
The ﬁrst two arguments are required: the index position (xndx) and function
table number (ifn) to be read. The optional arguments deﬁne how xndx will be
treated:
imode sets the indexing mode: 0 for raw table positions (0 to size-1), 1 for
normalised (0-1).
ioff adds an offset to xndx, making it start from a different value.
iwrap switches wrap-around (modulus) on. If 0, limiting is used, where index
values are pegged to the ends of the table if they exceed them.
All optional values are set to 0 by default.
Table readers have multiple uses. To illustrate one simple use, we will use it to
create an arpeggiator for our sine wave instrument. The idea is straightforward: we
will create a table containing various pitch values, and we will read these using a
table reader to control the frequency of an oscillator.
The pitch table can be created with GEN 2, which simply copies its arguments to
the respective table positions. To make it simple, we will place four interval ratios
desired for the arpeggio: 1 (unison), 1.25 (major third), 1.5 (perfect ﬁfth) and 2 (oc-
tave). The table will be set not to be re-scaled, so the above values can be preserved.
This function table is illustrated by Fig 3.4.
76
3 Fundamentals
ifn ftgen
2,0,4,-2,1,1.25,1.5,2
Fig. 3.4 Function table created with GEN2 in listing 3.19
We can read this function table using a phasor to loop over the index at a given
rate (set by p6), and use a table opcode. Since this truncates the index, it will
only read the integral positions along the table, stepping from one pitch to another.
If we had used an interpolating table reader, the result would be a continuous slide
from one table value to another. Also because phasor produces an output between
0 to 1, we set imode to 1, to tell table to accept indexes in that range:
kpitch table phasor(p6), 2, 1
Now we can insert this code into the previous instrument (listing 3.18), and con-
nect kpitch to the oscillator frequency.
Listing 3.19 An arpeggiator instrument
isize = 16384
ifn ftgen 1, 0,
isize,
7,
0, isize*0.1, 1,isize*0.8, 1, isize*0.1, 0
ifn ftgen
2,0,4,-2,1,1.25,1.5,2
instr 1
kenv
oscili
p4, 1/p3, 1
kpitch
table
phasor:k(p6), 2, 1
asig
oscili
kenv, p5*kpitch
out
asig
endin
schedule(1,0,10,0dbfs/2,440,1)
If we replace the means we are using to read the table, we can change the arpeg-
giation pattern. For instance, if we use an oscillator, we can speed up/slow down the
reading, according to a sine shape:
kpitch
table
oscil:k(1,p6/2), 2, 1, 0, 1
Note that because the oscillator produces a bipolar signal, we need to set table
to wrap-around (iwrap=1), otherwise we will be stuck at 0 for half the waveform
period.
3.5 Fundamental Opcodes
77
Table writing
In addition to being read, any existing table can be written to. This can be done at
perf-time (k-rate or a-rate ) by the tablew opcode:
tablew xvar, xndx, ifn [, ixmode] [, ixoff] [, iwgmode]
xvar holds the value(s) to be written into the table. It can be an i-time variable,
k-rate or a-rate signal.
xndx is the index position(s) to write to, its type needs to match the ﬁrst argu-
ment.
imode sets the indexing mode: 0 for raw table positions (0 to size -1), 1 for
normalised (0-1).
ioff adds an offset to xndx.
iwgmode controls the writing. If 0, it limits the writing to between 0 and table
size (inclusive); 1 uses wrap-around (modulus); 2 is guard-point mode where
writing is limited to 0 and table size -1, and the guard point is written at the same
time as position 0, with the same value.
Note that tablew only runs at perf-time, so it cannot be used to write a value at
i-time to a table. For this, we need to use tableiw, which only runs at initialisation.
3.5.5 Reading Soundﬁles
Another set of basic signal generators is the soundﬁle readers. These are opcodes
that are given the name of an audio ﬁle in the formats accepted by Csound (see Sec-
tion 2.8.4), and source their audio signal from it. The simplest of these is soundin,
but a more complete one is provided by diskin (and diskin2, which uses the
same code internally):
ar1[,ar2,ar3, ... arN] diskin Sname[,kpitch, iskipt,
iwrap,ifmt,iskipinit]
where Sname is the path/name of the requested soundﬁle in double quotes. This
opcode can read ﬁles from multiple channels (using multiple outputs), and will re-
sample if the ﬁle sr differs from the one used by Csound (which soundin cannot
do). It can also change the playback pitch (if kpitch != 1) like a varispeed tape
player, negative values allow for reverse readout. The iwrap parameter can be used
to wrap-around the ends of the ﬁle (if set to 1). The number of channels and duration
of any valid soundﬁle can also be obtained with
ich
filenchnls Sname
ilen filen Sname
An example of these opcodes is shown below in listing 3.20.
78
3 Fundamentals
Listing 3.20 A soundﬁle playback instrument
nchnls=2
instr 1
p3 = filelen(p4)
ich = filenchnls(p4)
if ich == 1 then
asig1 diskin
p4
asig2 = asig1
else
asig1, asig2 diskin p4
endif
out asig1,asig2
endin
schedule(1,0,1,"fox.wav")
Note that we have to select the number of outputs depending on the ﬁle type
using a control-of-ﬂow construct (see Chapter 5). The duration (p3) is also taken
from the ﬁle.
3.5.6 Pitch and Amplitude Converters
Csound provides functions to convert different types of pitch representation to fre-
quency in cycles per second (Hz), and vice-versa. There are three main ways in
which pitch can be notated:
1. pch: octave point pitch class
2. oct: octave point decimal
3. midinn: MIDI note note number.
The ﬁrst two forms consist of a whole number, representing octave height, fol-
lowed by a specially interpreted fractional part. Middle-C octave is represented as 8;
each whole-number step above or below represents an upward or downward change
in octave, respectively. For pch, the fraction is read as two decimal digits represent-
ing the 12 equal-tempered pitch classes from .00 for C to .11 for B.
With oct, however, this is interpreted as a true decimal fractional part of an oc-
tave, and each equal-tempered step is equivalent to
1
12, from .00 for C to 11
12 for B.
The relationship between the two representations is then equivalent to the factor 100
12 .
The concert pitch A 440 Hz can be represented as 8.09 in pch notation and 8.75
in oct notation. Microtonal divisions of the pch semitone can be encoded by using
more than two decimal places. We can also increment the semitones encoded in
the fractional part from .00 to .99 (e.g. 7.12 => 8.00; 8.24 => 10.00). The third
notation derives from the MIDI note number convention, which encodes pitches
between 0 and 127, with middle C set to 60.
These are the functions that can be used to convert between these three notations:
3.5 Fundamental Opcodes
79
octpch(pch): pch to oct.
cpspch(pch): pch to cps (Hz).
pchoct(oct): oct to pch.
cpsoct(oct): oct to cps (Hz).
octcps(cps): cps (Hz) to oct.
cpsmidinn(nn): midinn to cps (Hz).
pchmidinn(nn): midinn to pch.
octmidinn(nn): midinn to oct.
The following code example demonstrate the equivalence of the three pitch rep-
resentations:
instr 1
print cpspch(8.06)
print cpsoct(8.5)
print cpsmidinn(66)
endin
schedule(1,0,1)
When we run this code, the console prints out the same values in Hz:
new alloc for instr 1:
instr 1:
#i0 = 369.994
instr 1:
#i1 = 369.994
instr 1:
#i2 = 369.994
It is worth noting that while the majority of the pitch converters are based on
a twelve-note equal temperament scale, Csound is not so restricted. The opcode
cps2pch convert from any octave-based equal temperament scale to Hertz, while
cpsxpch and cpstun provide for non-octave scales as well as table-provided
scales. Details can be found in the reference manual.
For amplitudes, the following converters are provided for transforming to/from
decibel (dB) scale values:
ampdb(x): dB scale to amplitude.
ampdb(x) = 10
x
20
(3.4)
dbamp(x): amplitude to dB
dbamp(x) = 20log10 x
(3.5)
ampdbfs(x): dB scale to amplitude, scaled by 0dbfs
ampdbfs(x) = ampdb(x)×0dbfs
(3.6)
These converters allow the convenience of setting amplitudes in the dB scale,
and frequencies in one of the three pitch scales, as shown in the example below:
80
3 Fundamentals
instr 1
out(oscili(ampdbfs(p4),cpspch(p5)))
endin
schedule(1,0,1,-6,8.09)
3.5.7 Envelope Generators
The ﬁnal set of fundamental Csound opcodes are the envelope generators. As we
have seen earlier, function tables can be used to hold shapes for parameter control.
However, these suffer from a drawback: they will expand and contract, depending on
event duration. If we create an envelope function that rises for 10% of its length, this
will generally get translated in performance to 10% of the sound duration, unless
some more complicated coding is involved. This rise time will not be invariant,
which might cause problems for certain applications.
Envelope generators can create shapes whose segments are ﬁxed to a given dura-
tion (or relative, if we wish, the ﬂexibility is there). These can be applied at control
or audio rate to opcode parameters. Csound has a suite of these unit generators, and
we will examine a few of these in detail. The reader is then encouraged to look at
the Reference Manual to explore the others, whose operation principles are very
similar.
The basic opcode in this group is the trapezoid generator linen, which has three
segments: rise, sustain and decay. Its syntax is summarised here:
xsig linen
xamp,irise,idur,idec
The four parameters are self-describing: irise is the rise time, idur is the total
duration and idec the decay time, all of these in seconds. The argument xamp can
be used as a ﬁxed maximum amplitude value, or as an audio or control signal input.
In the ﬁrst case, linen works as a signal generator, whose output can be sent to
control any time-varying parameter of another opcode. If, however, we use a signal
as input, then the opcode becomes a processor, shaping the amplitude of its input.
This envelope makes a signal or a value rise from 0 to maximum in irise
seconds, after which it will maintain the output steady until dur −idec seconds.
Then it will start to decay to 0 again. Listing 3.21 shows an example of its usage, as
a signal generator, controlling the amplitude of an oscillator. Its arguments are taken
from instrument parameters, so they can be modiﬁed on a per-instance basis.
Listing 3.21 Linen envelope generator example
instr 1
kenv
linen
ampdbfs(p4),p6,p3,p7
asig
oscili
kenv, cpspch(p5)
out
asig
endin
schedule(1,0,10,-6,8.09,0.01,0.1)
3.5 Fundamental Opcodes
81
Alternatively, we could employ it as a signal processor (listing 3.22). One impor-
tant difference is that in this arrangement linen works at the audio rate, whereas
in listing 3.21, it produces a k-rate signal. Depending on how large ksmps is, there
might be an audible difference, with this version being smoother sounding.
Listing 3.22 Linen envelope processor example
instr 1
aosc
oscili ampdbfs(p4),cpspch(p5)
asig
linen aosc,p6,p3,p7
out
asig
endin
schedule(1,0,10,-6,8.09,0.01,0.1)
Another form of envelope generators are the line segment opcodes. There are
two types of these: linear and exponential. The ﬁrst creates curves based on constant
differences of values, whereas the other uses constant ratios. They are available as a
simple single-segment opcodes, or with multiple stages:
xsig line
ipos1,idur,ipos2
xsig expon ipos1,idur,ipos2
xsig linseg ipos1,idur,ipos2,idur2,ipos3[,...]
xsig expseg ipos1,idur,ipos2,idur2,ipos3[,...]
The exponential opcodes cannot have 0 as one of its ipos values, as this would
imply a division by 0, which is not allowed. These unit generators are very useful
for creating natural-sounding envelope decays, because exponential curves tend to
match well the way acoustic instruments work. They are also very good for creating
even glissandos between pitches. A comparison of linear and exponential decay-
ing envelopes is shown in Fig. 3.5. Listing 3.23 shows two exponential envelopes
controlling amplitude and frequency.
Fig. 3.5 Linear (dots) and exponential (solid) decaying curves.
82
3 Fundamentals
Listing 3.23 Exponential envelope example
instr 1
kenv
expon 1, p3, 0.001
kpit
expon 2,p3,1
asig
oscili kenv*ampdbfs(p4),kpit*cpspch(p5)
out
asig
endin
schedule(1,0,1,-6,8.09)
In addition to these two types of curves, the transeg opcode can produce linear
and exponential (concave or convex) curves, deﬁned by an extra parameter for each
segment.
3.5.8 Randomness
Another class of opcodes provided random values from a variety of distributions.
They have many uses but a major one is in providing control signals, especially for
humanising a piece. For example, in an envelope deﬁnition it might be desirable
for the durations of the segments to vary a little to reduce the mechanical effect of
the notes. This can be achieved by adding a suitable random value to the average
value desired. All the opcodes described here are available at initialisation, control
or audio rate, but the commonest uses are for control.
The simplest of these opcodes is random, which uses a pseudo-random number
generator to deliver a value in a range supplied with a uniform distribution; that is
all values within the range are equally likely to occur. A simple example of its use
might be as shown in listing 3.24, which will give a pitch between 432 Hz and 452
Hz every time an instance of instrument 1 is started.
Listing 3.24 Random pitch example
instr 1
aout oscili 0.8, 440+random(-8, 12)
outs aout
endin
More realistic would be to be to think about a performer who tries to hit the cor-
rect pitch but misses, and then attempts to correct it when heard. The pitch attempts
are not too inaccurate from the target, and it is unlikely that the performer will stray
far away. A simple model would be that the error is taken from a normal distribu-
tion (also called a Gaussian distribution or bell curve), centred on the target pitch.
A normal distribution looks like Fig. 3.6.
The scenario can be coded as in listing 3.25. A similar method can thicken a
simple oscillation by adding normally distributed additional oscillations as shown
in instrument 2. The gauss opcode takes an argument that governs the spread of
the curve, all effective values being within ± that value from zero.
3.5 Fundamental Opcodes
83
Fig. 3.6 Normal distribution.
Listing 3.25 Normal distribution of error pitch
instr 1
kerr gauss
10
aout oscili 0.8, 440+kerr
outs aout
endin
instr 2
kerr1 gauss 10
kerr2 gauss 10
a0
oscili 0.6, 440
a1
oscili 0.6, 440+kerr1
a2
oscili 0.6, 440+kerr2
outs
a0+a1+a2
endin
Different distribution curves can be used for different effects. In addition to the
uniform distribution of random and the normal distribution of gauss Csound pro-
vides many others [80]:
•
Linear: The distribution is a straight line from 2 at zero to zero at 1. The
linrand opcode delivers this scaled so values come from zero to krange,
and small values are more likely. It could for example be used for adding a tail
to a note so durations were non-regular as in instrument 1 in listing 3.26.
•
Triangular: Centred on zero the distribution goes to zero at ±krange. A simple
example is shown as instrument 2 in listing 3.26.
84
3 Fundamentals
•
Exponential: The straight lines of the uniform, linear and triangular distribution
are often unnatural, and a curved distribution is better. The simplest of these is the
exponential distribution λe−λx which describes the time between events which
occur independently at a ﬁxed average rate. Random values from this distribution
(Fig. 3.7) are provided by the exprand opcode, with an argument for λ. The
larger the value of λ the more likely that the provided value will be small. The
average value is 1
λ and while theoretically the value could be inﬁnite in practice
it is not. The value is always positive. A version of this distribution symmetric
about zero is also available as bexprand.
•
Poisson: A related distribution gives the probability that a ﬁxed number of events
occur within a ﬁxed period. The opcode poisson returns an integer value of
how many events occurred in the time-window, with an argument that encodes
the probability of the event. Mathematically the probability of getting the integer
value j is e−λ( λ j
j! ).
•
Cauchy: Similarly shaped to the normal distribution, the cauchy distribution
make values away from zero more likely; that is the distribution curve is ﬂatter.
•
Weibull: A more variable distribution is found in the weibull opcode, which
takes two parameters. The ﬁrst, σ, controls the spread of the distribution while
the second, τ, controls the shape. The graphs are shown in Fig. 3.8, for three
values of τ. When the second parameter is one this is identical to the exponential
distribution; smaller values favour small values and larger delivers more large
values.
•
Beta: Another distribution with a controllable shape is the beta distribution
(betarand). It has two parameters, one governing the behaviour at zero and
the other at one, xa−1(1−x)b−1/B where B is just a scale to ensure the distribu-
tion gives a probability in the full range (area under the curve is one). This gives
bell-curve-like shapes when a and b are both greater than 1 (but with a ﬁnite
range), when both are 1 this is a uniform distribution, and with a and b both less
than 1 it favours 0 or 1 over intermediate values.
Listing 3.26 Example of use of linrand
instr 1
itail linrand 0.1
p3 += itail
a1
oscili
0.8, 440
out
a1
endin
instr 2
itail trirand 0.1
p3 += itail
a1
oscili
0.8, 440
out
a1
endin
All these opcodes use a predictable algorithmic process to generate pseudo-
random values which is sufﬁcient for most purposes, and has the feature of being
3.5 Fundamental Opcodes
85
Fig. 3.7 Exponential distribution, with λ = 0.5 (solid), 1.0 (dash) and 1.5 (dots)
Fig. 3.8 Weibull distribution, with τ = 0.5 (solid), 1.0 (dash) and 2.0 (dots)
86
3 Fundamentals
repeatable. If a better chance of being random is required the uniformly distributed
opcode urandom can be used; it uses other activity on the host computer to inject
more randomness.
When considering any process that derives from random values there is the ques-
tion of reproducibility. That is, if one synthesises it again does one want or expect
the results to be identical or different. Both are reasonable expectations, which is
why Csound provides a seed opcode. This allows control over the sequence of
pseudo-random numbers, by selecting a starting value, or seeding from the com-
puter clock which is at least difﬁcult to predict. It is also possible to ﬁnd the current
state of the PRN generator with the getseed opcode.
3.6 The Orchestra Preprocessor
Csound, like other programming languages, includes support for preprocessing of
its orchestra code. This allows the user to make a number of modiﬁcations to text,
which are made before compilation. There are seven preprocessor statements in
Csound, all starting with #:
#include
#define
#undef
#ifdef
#ifndef
#else
#end
Include
The include statement copies the contents of an external text ﬁle into the code, at
the exact line where it is found. For instance, the following code
#include "instr1.inc"
schedule(1,1,2,-12,8.00)
where the ﬁle instr1.inc contains listing 3.23, will play two sounds with instr 1 (the
ﬁrst one corresponding to the schedule line in the included ﬁle). The ﬁle name
should be in double quotes. If the included ﬁle is in the same directory as the code,
or the same working directory as a running Csound program, then its name will be
sufﬁcient. If not, the user will need to pass the full path to it (in the usual way used
by the OS platform in which Csound is running).
3.6 The Orchestra Preprocessor
87
Deﬁne
The Csound preprocessor has a simple macro system that allows text to be replaced
throughout a program. We can use it in two ways, with or without arguments. The
ﬁrst form, which is the simplest, is
#define
NAME
#replacement text#
where $NAME will be substituted by the replacement text, wherever it is found. This
can be used, for instance to set constants that will be used throughout the code.
Listing 3.27 Macro example
#define
DURATION #p3#
instr 1
kenv
expon 1, $DURATION, 0.001
kpit
expon 2, $DURATION, 1
asig
oscili kenv*ampdbfs(p4),kpit*cpspch(p5)
out
asig
endin
schedule(1,0,1,-6,8.09)
Macros replace the text where it is found, so we can concatenate it with other
text characters by terminating its call with a full stop, for instance
#define
OCTAVE
#8.#
schedule(1,0,1,-6,$OCTAVE.09)
Macros can be used for any text replacement. For instance, we could use it to
deﬁne what type of envelopes we will use:
#define
ENV #expon#
instr 1
kenv
$ENV 1, p3, 0.001
kpit
$ENV 2, p3, 1
asig
oscili kenv*ampdbfs(p4),kpit*cpspch(p5)
out
asig
endin
Using full capitals for macro names is only a convention, but it is a useful one to
avoid name clashes. The second form of #define allows for arguments:
#define
NAME(a’ b’)
#replacement text#
where the parameters a, b etc. can be referred to in the macro as $a, $b etc. For
instance, listing 3.28 shows how a macro can take arguments to replace a whole
opcode line.
Listing 3.28 Macro example, with arguments
#define
OSC(a’b) #oscili $a, $b#
instr 1
88
3 Fundamentals
kenv
expon 1, p3, 0.001
kpit
expon 2, p3, 1
asig
OSC(kenv*ampdbfs(p4) ’ kpit*cpspch(p5))
out
asig
endin
schedule(1,0,1,-6,8.09)
Csound also includes a number of internally deﬁned numeric macros that are
useful for signal processing applications, e.g. the value of π, e etc. (see Table 3.2).
Table 3.2 Numeric macros in Csound
macro
value
expression
$M E
2.7182818284590452354
e
$M LOG2E
1.4426950408889634074
log2(e)
$M LOG10E
0.43429448190325182765
log10(e)
$M LN2
0.69314718055994530942
loge(2)
$M LN10
2.30258509299404568402
loge(10)
$M PI
3.14159265358979323846
π
$M PI 2
1.57079632679489661923
π/2
$M PI 4
0.78539816339744830962
π/4
$M 1 PI
0.31830988618379067154
1/π
$M 2 PI
0.63661977236758134308
2/π
$M 2 SQRTPI
1.12837916709551257390
2/√π
$M SQRT2
1.41421356237309504880
√
2
$M SQRT1 2
0.70710678118654752440
1/√π
Finally, a user deﬁned macro can be undeﬁned:
#undefine
NAME
Conditionals
To complement the preprocessor functionality, Csound allows for conditionals.
These control the reading of code by the compiler. They use a token deﬁnition via
#define, a check for it, and an alternative branch:
#define
NAME
#ifdef NAME
#else
#end
A negative check is also available through #ifndef. We can use these condi-
tionals to switch off code that we do not need at certain times. By using #define
PRINTAMP in listing 3.29, we can make it print the amplitudes rather than the fre-
quencies.
3.7 Conclusions
89
Listing 3.29 Preprocessor condititionals
#define PRINTAMP #1#
instr 1
iamp = ampdbfs(p4)
ifreq = cpspch(p5)
#ifdef PRINTAMP
print iamp
#else
print ifreq
#end
out(oscili(iamp,ifreq)
endin
schedule(1,0,1,-6,8.09)
3.7 Conclusions
This chapter explored the essential aspects of Csound programming, from instru-
ment deﬁnitions to basic opcodes. We started the text without any means of mak-
ing sound with the software, but at the end we were to create some simple music-
generating instruments. As the scope of this discussion is not wide enough to include
synthesis techniques (that is reserved for later), the types of sounds we were able to
produce were very simple. However, the instrument designs showed the principles
that underlie programming with Csound in a very precise way, and these will be
scaled up as we start to cover the various sound processing applications of the sys-
tem.
With a little experimentation and imagination, the elements presented by this
chapter can be turned into very nice music-making tools. Readers are encouraged to
explore the Csound Reference Manual for more opcodes to experiment with and add
to their instruments. All of the principles shown here are transferable to other unit
generators in the software. As we progress to more advanced concepts, it is worth
coming back to some of the sections in this chapter, which explore the foundations
on which the whole system is constructed.
