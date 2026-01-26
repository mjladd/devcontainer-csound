# Chapter 3

Chapter 3
Fundamentals
Abstract This chapter will introduce the reader to the fundamental aspects of
Csound programming. We will be examining the syntax and operation of instru-
ments, including how statements are executed and parameters passed. The principle
of variables and their associated data types will be introduced with a discussion
of update rates. The building block of instruments, opcodes, are explored, with a
discussion of traditional and function-like syntax. Selected key opcodes that imple-
ment fundamental operations are detailed to provide an introduction to synthesis
and processing. The Csound orchestra preprocessor is introduced, complementing
this exploration of the language fundamentals.
3.1 Introduction
The Csound language is domain speciﬁc. In distinction to a general-purpose lan-
guage, it attempts to target a focused set of operations to make sound and music,
even though it has capabilities that could be harnessed for any type of computation,
and it is a Turing-complete language [29]. Because of this, it has some unique fea-
tures, and its own way of operating. This chapter and the subsequent ones in Part II
will introduce all aspects of programming in the Csound language, from ﬁrst prin-
ciples. We do not assume any prior programming experience, and we will guide the
reader with dedicated examples for each aspect of the language. In this chapter, we
will start by looking at the fundamental elements of the system, and on completion,
we will have covered sufﬁcient material to enable the creation of simple synthesis
and processing programs.
The code examples discussed here can be typed using any plain text (ASCII)
editor, in the <CsInstruments> section of a CSD ﬁle (see Section 2.2). Csound
code is case sensitive, i.e. hello is not the same as Hello. It is important that only
ASCII text, with no extra formatting data, is used, so users should avoid using word
processors that might introduce these. Alternatively, users can employ their Csound
© Springer International Publishing Switzerland 2016
V. Lazzarini et al., Csound, DOI 10.1007/978-3-319-45370-5_
53
3
54
3 Fundamentals
IDE/frontend of choice. The examples presented in this chapter are not dependent
on any particular implementation of the system.
3.2 Instruments
The basic programming unit in Csound is the instrument. In Part I, we have already
explored the history of the concept, and looked at some operational aspects. Now
we can look closely at its syntax. Instruments are deﬁned by the keywords instr
and endin. The general form is shown in listing 3.1.
Listing 3.1 Instrument syntax
instr <id>[,<id2>, ...]
endin
An instrument has an identiﬁcation name, <id> in listing 3.1, which can be
either numeric or textual. Optionally, as indicated in square braces in the example,
it can have alternative names. Csound allows an unspeciﬁed number of instrument
deﬁnitions, but each instrument in a single compilation has to have unique names. In
subsequent compilations, if an existing name is used, it replaces the old deﬁnition.
The keyword endin closes an instrument deﬁnition. They cannot be nested, i.e.
one instrument cannot be deﬁned inside another. Both instr and endin need to
be placed on their own separate lines. In order to perform computation, an event
needs to be scheduled for it. The opcode schedule can be used for this purpose,
and its syntax is
schedule(id,istart,idur, ...)
where id is the instrument name, istart the start time and idur the duration of
the event. Times are deﬁned in seconds by default. Extra parameters to instruments
may be used.
3.2.1 Statements
Csound code is made of a series of sequentially executed statements. These will
involve either a mathematical expression, or an opcode, or both. Statements are ter-
minated by a newline, but can extend over multiple lines in some cases, where mul-
tiple opcode parameters are used. In this case, lines can be broken after a comma, a
parenthesis or an operator. Execution follows line order, from the topmost statement
to endin. Any number of blank lines are allowed, and statements can start at any
column. For code readability,we recommend to indent by one or more columns any
code inside instruments (and keep the statements aligned to this). Listing 3.2 shows
an example of three legal statements in a instrument, which is then scheduled to run.
3.2 Instruments
55
Listing 3.2 Statements in an instrument
instr 1
print 1
print 1+1
print 3/2
endin
schedule(1,0,1)
This instrument will print some numbers to the console, in the order the state-
ments are executed:
SECTION 1:
new alloc for instr 1:
instr 1:
1 = 1.000
instr 1:
#i0 = 2.000
instr 1:
#i1 = 1.500
The print opcode prints the name of the argument (which can be a variable,
see Sec. 3.3) and its value. The ﬁrst print statement has 1 as argument, and the
subsequent ones are expressions, which get calculated and put into synthetic (and
hidden) variables that are passed as arguments (#i0, #i1). It is possible to see that
the statements are executed in line order.
3.2.2 Expressions
Csound accepts expressions of arbitrary size combining constants, variables (see
Sec. 3.3) and a number of arithmetic operators. In addition to the ordinary addition,
subtraction, multiplication and division (+, -, * and /), there is also exponentia-
tion (ˆ) and modulus (or remainder, %). Normal precedence applies, from highest to
lowest exponentiation: multiplication, division and modulus; addition and subtrac-
tion. Operators at the same level will bind left to right. Operations can be grouped
with parentheses, as usual, to control precedence. The following operators are also
available for short hand expressions:
a += b
=> a = a + b
a -= b
=> a = a - b
a *= b
=> a = a * b
a /= b
=> a = a / b
56
3 Fundamentals
3.2.3 Comments
Csound allows two forms of comments, single and multiple line. The former, which
is the traditional way of commenting code, is demarcated by a semicolon (;) and
runs until the end of the line. A multiple-line comment is indicated by the /*
and
*/ characters, and includes all text inside these. These comments cannot be nested.
Listing 3.3 shows an example of these two types of comment. Csound can also use
C++ style single-line comments introduced by //.
Listing 3.3 Comments in an instrument
instr 1
/*
the line below shows a
statement and a single-line comment.
*/
print 1 ; this is a print statement
; print 2
; this never gets executed
endin
schedule(1,0,1)
When this code is run, as expected, only the ﬁrst statement is executed:
SECTION 1:
new alloc for instr 1:
instr 1:
1 = 1.000
3.2.4 Initialisation Pass
The statements in an instrument are actually divided into two groups, which get
executed at different times. The ﬁrst of these is composed of the initialisation state-
ments. They are run ﬁrst, but only once, or they can be repeated explicitly via a
reinitialisation call. These statements are made up of expressions, init-time opcodes,
or both. In the example shown in listings 3.2 and 3.3, the code consists solely of
init-time statements, which, as shown by their console messages, are only executed
once.
3.2.5 Performance Time
The second group of statements are executed during performance time. The main
difference is that these are going to be iterated, i.e. repeated, for the duration of
the event. We call a repetitive sequence of statements a loop. In Csound, there is
3.2 Instruments
57
a fundamental operating loop that is implicit to performance-time statements in an
instrument, called the k-cycle. It repeats at
1
kr seconds of output audio (kr is the
control rate, see Chapter 2), which is called a k-period. Performance-time statements
are executed after init-pass, regardless of where they are in an instrument. Listing 3.4
shows an example.
Listing 3.4 Performance-time and init-pass statements
instr 1
printk 0, 3
print 1
print 2
printk 0, 4
endin
schedule(1,0,1)
If we run this code, we will see the messages on the console show the two init-
time statements ﬁrst, even though they come after the ﬁrst printk line. This op-
code runs at performance time, printing its second argument value at regular times
given by the ﬁrst. If this is 0, it prints every k-period. It reports the times at which it
was executed:
SECTION 1:
new alloc for instr 1:
instr 1:
1 = 1.000
instr 1:
2 = 2.000
i
1 time
0.00023:
3.00000
i
1 time
0.00023:
4.00000
i
1 time
0.00045:
3.00000
i
1 time
0.00045:
4.00000
...
For clarity of reading, sometimes it might be useful to group all the init-pass
statements at the top of an instrument, and follow that with the performance-time
ones. This will give a better idea of the order of execution (see listing 3.4)
Listing 3.5 Performance-time and init-pass statements, ordered by execution time
instr 1
print 1
print 2
printk 0, 3
printk 0, 4
endin
Note that many opcodes might produce output at performance time only, but they
are actually run at initialisation time as well. This is the case with unit generators
that need to reset some internal data, and run single-pass computation, whose results
are used at performance time. This is the case of the majority of opcodes, with
only a small set being purely perf-time. If, for some reason, the init-time pass is
58
3 Fundamentals
bypassed, then the unit generators might not be initialised properly and will issue a
performance error.
3.2.6 Parameters
An instrument can be passed an arbitrary number of parameters or arguments. Min-
imally, it uses three of these, which are pre-deﬁned as instrument number (name),
start time and duration of performance. These are parameters 1, 2 and 3 respectively.
Any additional parameters can be used by instruments, so that different values can
be set for each instance. They can be retrieved using the p(x) opcode, where x is
the parameter number. An example of this is shown in listing 3.6.
Listing 3.6 Instrument parameters
instr 1
print p(4)
print p(5)
endin
schedule(1,0,1,22,33)
schedule(1,0,1,44,55)
This example runs two instances of instrument 1 at the same time, passing dif-
ferent parameters 4 and 5. The console messages show how the parameters are set
per instance:
SECTION 1:
new alloc for instr 1:
instr 1:
#i0 = 22.000
instr 1:
#i1 = 33.000
new alloc for instr 1:
instr 1:
#i0 = 44.000
instr 1:
#i1 = 55.000
3.2.7 Global Space Code
Code that exists outside instruments is deemed to be in global space. It gets executed
only once straight after every compilation. For this reason, performance-time code
is not allowed at this level, but any i-pass code is. In the examples above, we have
shown how the schedule opcode is used outside an instrument to start events.
This is a typical use of global space code, and it is perfectly legal, because the
operation of schedule is strictly i-time. It is also possible to place the system
constants (sr, kr, ksmps, 0dbfs, nchnls, and nchnls i) in global space, if
we need to override the defaults, but these are only effective in the ﬁrst compilation
3.3 Data Types and Variables
59
(and ignored thereafter). Global space has been called instr 0 in the past, but that
term does not deﬁne its current uses appropriately.
3.3 Data Types and Variables
Data types are used to distinguish between the different objects that are manipulated
by a program. In many general-purpose languages, types are used to select different
numeric representations and sizes, e.g. characters, short and long integers, single-
and double-precision ﬂoating-point numbers. In Csound all numbers are ﬂoating
point (either single- or double-precision, depending on the platform). The funda-
mental distinction for simple numeric types is a different one, based on update rates.
As we have learned above, code is executed in two separate stages, at initialisation
and performance times. This demands at least two data types, so that the program
can distinguish what gets run at each of these stages. Furthermore, we have also
seen in Chapter 2 that Csound operates with two basic signal rates, for control and
audio. The three fundamental data types for Csound are designed to match these
principles: one init-pass and two perf-time types.
We give objects of these types the name variables, or sometimes, when referring
to perf-time data, signals. In computing terms, they are memory locations that we
can create to store information we computed or provided to the program. They are
given unique names (within an instrument). Names can be arbitrary, but with one
constraint: the starting letter of a variable name will determine its type. In this case,
we will have i for init time, k for control rate, and a for audio rate (all starting
letters are lower case). Some examples of variable names:
i1, ivar, indx, icnt
k3, kvar, kontrol, kSig
a2, aout, aSig, audio
Before variables are used as input to an expression or opcode, they need to be
declared by initialising them or assigning them a value. We will examine these ideas
by exploring the three fundamental types in detail.
3.3.1 Init-Time Variables
Csound uses the i-var type to store the results of init time computation. This is done
using the assignment operator (=), which indicates that the left-hand side of the op-
erator will receive the contents of the right-hand side. The computation can take the
form of opcodes or expressions that work solely at that stage. In the case of expres-
sions, only the ones containing constants and/or i-time variables will be executed at
that stage. The code in listing 3.7 shows an example of i-time expressions, which are
stored in the variable ires and printed. Note that variables can be reused liberally.
60
3 Fundamentals
Listing 3.7 Using i-time variables with expressions
instr 1
ires = p(4) + p(5)
print ires
ires = p(4)*p(5)
print ires
endin
schedule(1,0,1,2,3)
In the case of opcodes, some will operate at i-time only, and so can store their
output in an i-variable (the Reference Manual can be consulted for this). For exam-
ple, the opcode date, which returns the time in seconds since the Epoch (Jan, 1
1970) is an example of this.
Listing 3.8 Using i-time variables with opcodes
instr 1
iNow date
print iNow
endin
schedule(1,0,0)
This example will print the following to the console:
SECTION 1:
new alloc for instr 1:
instr 1:
iNow = 1441142199.000
Note that the event duration (p3) can be set to 0 for i-time-only code, as it will
always execute, even if performance time is null.
A special type of i-time variable, which is distinct to i-vars, is the p-type. These
are used to access instrument parameter values directly: p1 is the instrument name,
p2 its start time, p3 the duration and so on. Further pN variables can be used to
access other parameters used. This is an alternative to using the p() opcode, but
it also allows assignment at i-time. So an instrument can modify its parameters on
the ﬂy. In the case of p1 and p2, this is meaningless, but with p3, for instance, it is
possible to modify the event’s duration. For instance, the line
p3 = 10
makes the instrument run for 10 seconds, independently of how long it was sched-
uled for originally. The p-type variables can be used liberally in an instrument:
Listing 3.9 Using p-variables
instr 1
print p4 + p5
endin
schedule(1,0,1,2,3)
3.3 Data Types and Variables
61
3.3.2 Control-Rate Variables
Control-rate variables are only updated at performance time. They are not touched
at init-time, unless they are explicitly initialised. This can be done with the init
operator, which operates only at i-time, but it is not always necessary:
kval init 0
At performance time, they are repeatedly updated, at every k-cycle. Only expres-
sions containing control variables will be calculated at this rate. For instance,
kval = 10
kres = kval*2
will execute at every k-cycle, whereas the code
ival = 10
kres = ival*2
will be executed mostly at i-time. The ﬁrst line is an assignment that will be run at
the i-pass. The second is an expression involving an i-var and a constant, which is
also calculated at i-time, and the result stored in a synthetic i-var. The assignment
happens at every k-cycle. Synthetic variables are created by the compiler to store
the results of calculations, and are hidden from the user.
The i-time value of a k-var can be obtained using the i() operator:
ivar = i(kvar)
This only makes sense if the variable has a value at that stage. There are two
situations when this can happen with instrument variables:
1. the k-var has been initialised:
kvar init 10
ivar = i(kvar)
2. the current instance is reusing a slot of an older instance. In that case, the values
of all variables at the end of this previous event are kept in memory. As the new
instance takes this memory space up, it also inherits its contents.
There is no restriction in assigning i-var to k-var, as the former is available (as
a constant value) throughout performance. However, if an expression is calculated
only at i-time, it might trigger an opcode to work only at i-time. Sometimes we need
it to be run at the control rate even if we are supplying an unchanging value. This
is the case, for instance, for random number generators. In this case, we can use the
k() converter to force k-time behaviour.
Listing 3.10 Producing random numbers at i-time
instr 1
imax = 10
printk 0.1, rnd(imax)
62
3 Fundamentals
endin
schedule(1,0,1)
For instance, the code on listing 3.10, using the rnd() function to produce ran-
dom numbers, produces the following console output:
i
1 time
0.00023:
9.73500
i
1 time
0.25011:
9.73500
i
1 time
0.50000:
9.73500
i
1 time
0.75011:
9.73500
i
1 time
1.00000:
9.73500
This is a ﬁxed random number calculated at i-time.
Listing 3.11 Producing random numbers at k-rate
instr 1
imax = 10
printk 0.1, rnd(k(imax))
endin
schedule(1,0,1)
If we want it to produce a series of different values at control rate, we need the
code in listing 3.11, which will print:
i
1 time
0.00023:
9.73500
i
1 time
0.25011:
9.10928
i
1 time
0.50000:
3.58307
i
1 time
0.75011:
8.77020
i
1 time
1.00000:
7.51334
Finally, it is important to reiterate that k-time variables are signals, of the control
type, sampled at kr samples per second. They can also be called scalars, as they
contain only a single value in each k-period.
3.3.3 Audio-Rate Variables
Audio-rate variables are also only updated at performance time, except for initiali-
sation (using init, as shown above). The main difference to k-vars is that these are
vectors, i.e. they contain a block of values at each k-period. This block is ksmps
samples long. These variables hold audio signals sampled at sr samples per second.
Expressions involving a-rate variables will be iterated over the whole vector ev-
ery k-period. For instance, the code
a2 =
a1*2
will loop over the contents of a1, multiply them by 2, and place the results in a2,
ksmps operations every k-period. Similarly, expressions involving k- and a-vars
will be calculated on a sample-by-sample basis. In order to go smoothly from a
3.3 Data Types and Variables
63
scalar to a vector, k-rate to a-rate, we can interpolate using the interp opcode,
or the a() converter. These interpolate the k-rate values creating a smooth line
between them, placing the result in a vector. This upsamples the signal from kr to
sr samples per second. It is legal to assign a k-rate variable or expression directly
to an a-rate, in which case the whole vector will be set to a single scalar value. The
upsamp opcode does this in a slightly more efﬁcient way.
With audio-rate variables we can ﬁnally design an instrument to make sound.
This example will create a very noisy waveform, but it will demonstrate some of
the concepts discussed above. The idea is to create a ramp that goes from −A to A,
repeating at a certain rate to give a continuous tone. To do this, we make the audio
signal increment every k-cycle by incr, deﬁned as:
incr = 1
kr × f0,
(3.1)
recalling that
1
kr is one k-period. If f0 = 1, starting from 0 we will reach 1 after
kr cycles, or 1 second. The ramp carries on growing after that, but if we apply a
modulo operation (%1), it gets reset to 0 when it reaches 1. This makes the ramp
repeat at 1 cycle per second (Hz). Now we can set f0 to any frequency we want, to
change the pitch of the sound.
The ramp goes from 0 to 1, but we want to make it go from −A to A, so we need
to modify it. First, we make it go from -1 to 1, which is twice the original range,
starting at -1. Then we can scale this by our target A value. The full expression is:
out = (2×ramp−1)×A
(3.2)
The resulting instrument is shown in listing 3.12. We use the out opcode to place
the audio in the instrument output. Two parameters, 4 and 5 are used for amplitude
(A) and frequency, respectively. Note the use of the a() converter to smooth out the
ramp. Without it, the ﬁxed value from the i-time expression (1/kr)*p5 would be
used. The converter creates a vector containing a ramp from 0 to its argument, which
is scaled by p5 and added to the aramp vector, creating a smoothed, rather than
a stepped output (see Fig. 3.1). The other statements translate the other elements
discussed above. The pitch is set to A 440 Hz, and the amplitude is half-scale (the
constant 0dbfs deﬁnes the full scale value).
Listing 3.12 A simple sound synthesis instrument
instr 1
aramp init 0
out((2*aramp-1)*p4)
aramp += a(1/kr)*p5
aramp = aramp%1
endin
schedule(1,0,10,0dbfs/2,440)
This example shows how we can apply the principles of audio and control rate,
and some simple mathematical expressions to create sounds from scratch. It is noisy
64
3 Fundamentals
because the ramp waveform is not bandlimited and causes aliasing. There are more
sophisticated means of creating similar sounds, which we will examine later in this
book.
Fig. 3.1 Two plots comparing ramp waves generated with the control to audio-rate converter a()
(top), and without it (bottom). The typical control-rate stepping is very clear in the second example
Finally, audio variables and expressions cannot be assigned directly to control
variables. This is because we are going from many values (the vector), to a single
one (a scalar). For this, we can apply the k() converter, which downsamples the
signal from sr to kr samples per second.1
3.3.4 Global Variables
All variables looked at so far were local to an instrument. That means that their
scope is limited to the instrument where they appear, and they cannot be seen out-
side it. Csound allows for global variables, which, once declared, exist outside in-
struments and can be seen by the whole program. These can be ﬁrst declared in an
instrument or in global space, remembering that only init-pass statements can be
used outside instruments. In this case, the declaration uses the init opcode. To
deﬁne a variable as global, we add a g to its name:
1 Other converters also exist, please see the Reference Manual for these.
3.4 Opcodes
65
gi1, givar, gindx, gicnt
gk3, gkvar, gkontrol, gkSig
ga2, gaout, gaSig, gaudio
Only one copy of a global variable with a given name will exist in the engine, and
care should be taken to ensure it is handled properly. For instance, if an instrument
that writes to a global audio signal stops playing, the last samples written to it will be
preserved in memory until this is explicitly cleared. This can lead to garbage being
played repeatedly if another instrument is using this variable in its audio output.
Global variables are useful as a means of connecting signals from one instrument
to another, as patch-cords or busses. We will examine this functionality later on in
