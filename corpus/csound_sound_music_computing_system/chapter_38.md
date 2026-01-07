# 2. User-deﬁned opcodes (UDOs): new opcodes written in the Csound language

2. User-deﬁned opcodes (UDOs): new opcodes written in the Csound language
proper, which can be used in instruments in a similar way to existing unit gener-
ators.
The ﬁrst method is used in situations where there is a real efﬁciency requirement,
or in the very few occasions where some programming device not supported by the
Csound language is involved. It is generally straightforward to create new plug-in
opcodes, but this topic is beyond the scope of this book (an introduction to it is
found in the Reference Manual). In this chapter we would like, instead, to explore
the various ways in which opcodes can be created using Csound code. This is often
called the composability element of a language, by which smaller components can
be put together and used as a single unit elsewhere.
© Springer International Publishing Switzerland 2016 
V. Lazzarini et al., Csound, DOI 10.1007/978-3-319-45370-5_
139
7
140
7 User-Deﬁned Opcodes
7.2 Syntax
As with instruments, UDOs are deﬁned by a code block, which is set between two
keywords opcode and endop. The general form is shown in listing 7.1.
Listing 7.1 Deﬁning a new UDO
opcode <name>,<outargs>,<inargs>
endop
A UDO has an identiﬁcation name, <name> in listing 7.1, which is textual. Ad-
ditionally, it requires lists of output and input arguments, which follow the name
after the comma. Csound allows an unspeciﬁed number of UDO deﬁnitions, and
unique names are only required if the UDO has the same arguments as another ex-
isting opcode. This allows polymorphic opcodes to be deﬁned. The keyword endop
closes a UDO deﬁnition. Both opcode and endop need to be placed on their own
separate lines. UDOs cannot be nested and need to be deﬁned in global space. In or-
der to perform computation, the opcode needs to be instantiated in code somewhere
(instruments or global space). UDOs can call any other existing UDOs, provided of
course that they have already been deﬁned earlier in the code.
7.2.1 Arguments
The argument list for opcodes allows for all internal data types. It is composed of
letters indicating the type, with added brackets ([]) to indicate the case of arrays.
There are some extra input types to indicate optional parameters, and whether init-
pass is performed on the argument:
a: audio-rate input.
a[]: audio-rate array.
k: control-rate, only used at perf-time.
k[]: control-rate array.
J: optional control-rate, defaults to -1.
O: optional control-rate, defaults to 0.
P: optional control-rate, defaults to 1.
V: optional control-rate, defaults to 0.5.
K: control-rate, used at both init-time and performance.
i: i-time.
i[]: i-time array.
j: optional i-time, defaults to -1.
o: optional i-time, defaults to 0.
p: optional i-time, defaults to 1.
S: string.
S[]: string array.
7.2 Syntax
141
f: frequency-domain.
f[]: frequency-domain array.
0: no inputs.
For example, an input argument list with three inputs of audio, control and init-
time types would be represented by the characters aki. Variables are copied into
UDO arguments, which are accessed through the xin opcode:
var[,var2,...]
xin
Arguments will accept only inputs of their own type, except for k-rate parame-
ters, which take k- and i-vars and constants, and i-time, which take i-vars and con-
stants. For output types, the list is similar, but shorter:
a: audio-rate output.
a[]: audio-rate array.
k: control-rate.
k[]: control-rate array.
i: i-time.
i[]: i-time array.
S: string.
S[]: string array.
f: frequency-domain.
f[]: frequency-domain array.
0: no outputs.
Outputs are similarly copied from opcode variables, through the xout opcode:
xout var[,var2,...]
In other aspects, UDOs are very similar to instruments. It is very simple to adapt
existing instruments for this. However, there are a number of speciﬁc aspects to
UDO operation that are important to note. While the actual code might look the
same, there are important distinctions between these two program structures. In list-
ing 7.2, we see an example of a basic UDO that combines an envelope and an oscil-
lator.
Listing 7.2 Envelope + oscillator combined into a UDO
opcode EnvOsc,a,aaiiij
amp,afr,iri,
idur,idec,ifn xin
a1 oscili amp,afr,ifn
a2 linen a1,iri,idur,idec
xout a2
endop
This UDO can be used multiple times in an instrument, wherever the oscillator
and envelope arrangement is required. For instance, if we want to implement an FM
142
7 User-Deﬁned Opcodes
synthesis instrument (see Chapter 12), with double modulation, and envelopes con-
trolling timbre and amplitude, we simply need to connect the UDOs appropriately
(listing 7.3).
Listing 7.3 Double modulator FM synthesis using the EnvOsc UDO
instr 1
amod1 EnvOsc a(p6*p5),a(p5),0.1,p3,0.1
amod2 EnvOsc a(p7*p5),a(p5*3),0.2,p3,0.4
asig
EnvOsc a(p4),amod1+amod2+p5,0.01,p3,0.1
out asig
endin
schedule(1,0,1,0dbfs/2,440,2.5,1.5)
Note that, as discussed before, a-rate inputs in UDOs can only accept audio sig-
nals. For this reason, in listing 7.3 we needed to employ conversion for i-time pa-
rameters using a(). Alternatively, we could have implemented other versions of the
same opcode that allowed for ak, ka, and kk for the ﬁrst two parameters, and this
polymorphic set would cover all basic input types.
The next example in listing 7.4 demonstrates how array parameters are used in
UDOs. In this case, the ﬁrst argument is an audio-rate array, so the local variable also
has to be deﬁned as an array. Conveniently, the UDO is able to deal with different
input array sizes.
Listing 7.4 Array parameters
gisinetab = ftgen(0, 0, 4097, 10, 1)
opcode SinModulate, a, a[]i
asigs[], ifreq xin
icount = lenarray(asigs)
iphaseAdj = 1 / icount
aphs = phasor(ifreq)
aout = 0
kndx = 0
until (kndx >= icount) do
aphsAdj = ((kndx / icount) * aphs) % 1.0
amod = tablei:a(aphsAdj, gisinetab, 1)
aout += asigs[kndx] * ((amod + 1) / 3)
kndx += 1
od
xout aout
endop
instr 1
ipch = cps2pch(p4,12)
iamp = ampdbfs(p5)
asigs[] init 3
aenv linsegr 0,0.01,.5,0.01,.45,2.25,0
7.3 Instrument State and Parameters
143
asigs[0] vco2 iamp, ipch
asigs[1] vco2 iamp, ipch * 2
asigs[2] vco2 iamp, ipch * 3
out moogladder(SinModulate(asigs,
0.75)*aenv,
2000,.3)
endin
icnt = 0
while icnt < 6 do
schedule(1,icnt,10-icnt,8+2*icnt/100,-12)
icnt += 2
od
7.3 Instrument State and Parameters
Parameters are passed to and received from UDOs by value; this means that they
cannot change an instrument variable indirectly. In other words, a UDO receives a
copy of the value of its input arguments, which resides in its local variables. It passes
a value or values out to its caller, which copies each one into the variable receiving
it. UDOs can access global variables following the normal rules, which allow any
part of the code to modify these.
However, some elements of instrument state are shared between the calling in-
strument and its UDO(s):
•
parameters (p-variables): these are accessible by the UDO and can modify the
caller instrument’s duration.
•
extra time: this is accessible here, affecting opcodes that are dependent on it.
•
MIDI parameters: if an instrument is instantiated by a MIDI NOTE message,
these are available to UDOs.
This shared state can be modiﬁed by the UDO, affecting the instrument that uses
the opcode. For instance if any envelope used here uses a longer extra time duration
than the one set by the calling instrument, then this will be the new duration used
by the instrument instance. Likewise the total duration of an event can be modiﬁed
by assigning a new duration to p3 inside the UDO. For instance, we can create an
opcode that reads a soundﬁle from beginning to end, by checking its duration and
making the event last as long as it needs to. This is shown in listing 7.5, where
regardless of the original event duration, it will play the soundﬁle to the end.
Listing 7.5 A UDO that controls the calling event’s duration
opcode FilePlay,a,S
Sname xin
p3 = filelen(Sname)
144
7 User-Deﬁned Opcodes
a1 diskin Sname,1
xout a1
endop
instr 1
out FilePlay("fox.wav")
endin
schedule(1,0,1)
7.4 Local Control Rate
It is possible to set a local control rate for the UDO which is higher than the system
control rate. This is done by deﬁning a local ksmps value that is an even subdivi-
sion of the calling-instrument block size. All UDOs have an extra optional i-time
argument in addition to the ones that are explicitly deﬁned, which is used to set
a ksmps value for any opcode instance. The following example demonstrates this
(listing 7.6); we call the same counting opcode with three different ksmps values
(system is set at ksmps=10, the default).
Listing 7.6 Local control rates in UDO performance
opcode Count,k,i
ival xin
kval init ival
print ksmps
kval += 1
printk2 kval
xout kval
endop
instr 1
kval Count 0,p4
printf "Count output = %d\n",kval,kval
endin
schedule(1,0,1/kr,1)
schedule(1,1/kr,1/kr,2)
schedule(1,2/kr,1/kr,5)
The console printout shows the difference in performance between these three
opcode calls (each event is only one k-cycle in duration):
SECTION 1:
new alloc for instr 1:
instr 1:
ksmps = 1.000
i1
1.00000
7.4 Local Control Rate
145
i1
2.00000
i1
3.00000
i1
4.00000
i1
5.00000
i1
6.00000
i1
7.00000
i1
8.00000
i1
9.00000
i1
10.00000
Count output = 10
rtevent:
T
0.000 TT
0.000 M:
0.0
instr 1:
ksmps = 2.000
i1
1.00000
i1
2.00000
i1
3.00000
i1
4.00000
i1
5.00000
Count output = 5
rtevent:
T
0.000 TT
0.000 M:
0.0
instr 1:
ksmps = 5.000
i1
1.00000
i1
2.00000
Count output = 2
In addition to this, it is possible to ﬁx the control rate of an opcode explicitly by
using the setksmps opcode. This can be used in UDOs and in instruments, with
the same limitation that the local ksmps has to divide the calling-instrument (or
system, in the case of instruments) block size. It is important to place it as the ﬁrst
statement in an instrument or UDO, in case any opcodes depend on a correct ksmps
value for their initialisation. The following example shows this, with ksmps=1 and
2 for the UDO and instrument, respectively.
Listing 7.7 Local control rates in UDO and instrument performance
opcode Count,k,i
setksmps 1
ival xin
kval init ival
print ksmps
kval += 1
printk2 kval
xout kval
endop
instr 1
setksmps 2
kval Count 0
146
7 User-Deﬁned Opcodes
printf "Count output = %d\n",kval,kval
endin
schedule(1,0,1/kr)
In this case, in one system k-period the instrument has ﬁve local k-cycles. The
opcode divides these into two k-cycles for each one of the caller’s. This example
prints the following messages to the console:
SECTION 1:
new alloc for instr 1:
instr 1:
ksmps = 1.000
i1
1.00000
i1
2.00000
Count output = 2
i1
3.00000
i1
4.00000
Count output = 4
i1
5.00000
i1
6.00000
Count output = 6
i1
7.00000
i1
8.00000
Count output = 8
i1
9.00000
i1
10.00000
Count output = 10
B
0.000 ..
1.000 T
1.000 TT
1.000 M:
0.0
The possibility of a different a-signal vector size (and different control rates) is
an important aspect of UDOs. This enables users to write code that requires the
control rate to be the same as the audio rate, for speciﬁc applications. This is the
case when ksmps = 1. This enables Csound code to process audio sample by sample
and to implement one-sample feedback delays, which are used, for instance, in ﬁlter
algorithms.
For instance, we can implement a special type of process called leaky integration,
where the current sample is the sum of the current sample and the output delayed
by one sample and scaled by a factor close to 1. This requires the sample-by-sample
processing mentioned above.
Listing 7.8 Sample-by-sample processing in a leaky integrator UDO
opcode Leaky,a,ak
setksmps 1
asum init 0
asig,kfac xin
asum = asig + asum*kfac
xout asum
endop
7.5 Recursion
147
instr 1
a1 rand p4
out Leaky(a1,0.99)
endin
schedule(1,0,1,0dbfs/20)
This is a very simple example of how a new process can be added to Csound by
programming it from scratch. UDOs behave very like internal or plug-in opcodes.
Once deﬁned in the orchestra code, or included from a separate ﬁle via a #include
statement, they can be used liberally.
7.5 Recursion
A powerful programming device provided by UDOs is recursion [2], which we have
already explored in Chapter 5 in the context of instruments. It allows an opcode
to instantiate itself an arbitrary number of times, so that a certain process can be
dynamically spawned. This is very useful for a variety of applications that are based
on the repetition of a certain operation. Recursion is done in a UDO by a call to itself,
which is controlled by conditional execution. A minimal example, which prints out
the instance number, is show below.
Listing 7.9 Minimal recursion example
opcode Recurse,0,io
iN,icnt xin
if icnt >= iN-1 igoto cont
Recurse iN,icnt+1
cont:
printf_i "Instance no: %d\n",1,icnt+1
endop
instr 1
Recurse 5
endin
schedule(1,0,0)
Note that as the o argument type is set by default to 0, so icnt starts from 0 and
goes up to 4. This will create ﬁve recursive copies of Recurse. Note that they
execute in the reverse order, with the topmost instance running ﬁrst:
SECTION 1:
new alloc for instr 1:
Instance no: 5
Instance no: 4
Instance no: 3
148
7 User-Deﬁned Opcodes
Instance no: 2
Instance no: 1
B
0.000 ..
1.000 T
1.000 TT
1.000 M:
0.0
This example is completely empty, as it does not do anything but print the in-
stances. A classic example of recursion is the calculation of a factorial, which can
be deﬁned as N! = N ∗(N −1)! (and 0! = 1,1! = 1). It can be implemented in a
UDO as follows:
Listing 7.10 Factorial calculation by recursion
opcode Factorial,i,ip
iN,icnt xin
ival = iN
if icnt >= iN-1 igoto cont
ival Factorial iN,icnt+1
cont:
xout
ival*icnt
endop
instr 1
print Factorial(5)
endin
schedule(1,0,0)
this prints
SECTION 1:
new alloc for instr 1:
instr 1:
#i0 = 120.000
Recursion is a useful device for many different applications. One of the most
important of these, as far as Csound is concerned, is the spawning of unit generators
for audio processing. There are two general cases of this, which we will explore
here. The ﬁrst of these is for sources/generators, where the audio signal is created in
the UDO. The second is when a signal is processed by the opcode. In the ﬁrst case,
we need to add the generated signal to the output, which will be a mix of the sound
from all recursive instances.
For instance, let’s consider the common case where we want to produce a sum of
oscillator outputs. In order to have individual control of amplitudes and frequencies,
we can use arrays for these parameters, and look up values according to instance
number. The UDO structure follows the simple example of listing 7.9 very closely.
All we need is to add the audio signals, control parameters and oscillators:
Listing 7.11 Spawning oscillators with recursion
opcode SumOsc,a,i[]i[]ijo
iam[],ifr[],iN,ifn,icnt xin
if icnt >= iN-1 goto syn
asig SumOsc iam,ifr,iN,ifn,icnt+1
7.5 Recursion
149
syn:
xout asig + oscili(iam[icnt],ifr[icnt],ifn)
endop
gifn ftgen 1,0,16384,10,1,1/2,1/3,
1/4,1/5,1/7,1/8,1/9
instr 1
ifr[] fillarray 1,1.001,0.999,1.002,0.998
iam[] fillarray 1,0.5,0.5,0.25,0.25
a1 SumOsc iam,ifr*p5,lenarray(iam),gifn
out a1*p4/lenarray(iam) * transeg:k(1,p3,-3,0)
endin
schedule(1,0,10,0dbfs/2,440)
The principle here is that the audio is passed from the lowermost to the topmost
instance, to which we add all intermediary signals, until it appears at the output of
the UDO in the instrument. In the case of audio processing instruments, the signal
has to originate outside the instrument, and be passed to the various instances in turn.
For instance, when implementing higher-order ﬁlters from a second-order section
(see Chapters 12 and 13), we need to connect these in series, the output of the ﬁrst
into the input of the second, and so on. A small modiﬁcation to the layout of the
previous example allows us to do that.
Listing 7.12 Higher-order ﬁlters with recursive UDO
opcode ButtBP,a,akkio
asig,kf,kbw,iN,icnt xin
if icnt >= iN-1 goto cont
asig ButtBP asig,kf,kbw,iN,icnt+1
cont:
xout butterbp(asig,kf,kbw)
endop
instr 1
a1 rand p4
a2 ButtBP a1,1500,100,4
out a2
endin
schedule(1,0,1,0dbfs/2)
We can characterise these two general cases as parallel and cascade schemes.
In listing 7.11, we have a series of oscillators side by side, whose output is mixed
together. In the case of listing 7.12, we have a serial connection of opcodes, with
the signal ﬂowing from one to the next. To make a parallel connection of processors
receiving the same signal, we need to pass the input from one instance to another,
and then mix the ﬁlter signal with the output, as shown in listing 7.13.
150
7 User-Deﬁned Opcodes
Listing 7.13 Parallel ﬁlter bank with recursive UDO
opcode BPBnk,a,ai[]kio
asig,ifc[],kQ,iN,icnt xin
if icnt >= iN-1 goto cont
afil BPBnk asig,ifc,kQ,iN,icnt+1
cont:
xout afil +
butterbp(asig,ifc[icnt],ifc[icnt]/kQ)
endop
instr 1
a1 rand p4
ifc[] fillarray 700, 1500, 5100, 8000
a2 BPBnk a1,ifc,10,lenarray(ifc)
out a2
endin
schedule(1,0,10,0dbfs/2)
7.6 Subinstruments
Another way of composing Csound code is via the subinstr mechanism. This allows
instruments to call other instruments directly as if they were opcodes. The syntax is
a1[,...]
subinstr id[, p4, p5, ...]
where id is the instrument number or name (as a string). This shares many of the
attributes of a UDO, but is much more limited. We are limited to i-time arguments,
which are passed to the instrument as parameters (p-vars). An advantage is that
there is no need to change our code to accommodate the use of an instrument in this
manner. In listing 7.14, we see an example of instrument 1 calling instrument 2, and
using its audio output.
Listing 7.14 A subinstrument example
instr 1
iamp = p4
ifreq = p5
a1 subinstr 2,iamp,ifreq,0.1,p3,0.9,-1
out
a1
endin
schedule(1,0,1,0dbfs/2,440)
instr 2
a1 oscili p4,p5,p9
a2 linen a1,p6,p7,p8
7.7 Conclusions
151
out a2
endin
In addition to subinstr, which runs at init- and perf-time (depending on the
called instrument code), we can also call an instrument to run only at the initialisa-
tion pass. The syntax is:
subinstrinit id[, p4, p5, ...]
In this case, no performance takes place and no audio output is present. The
subinstrument is better understood as another way of scheduling instruments, rather
than as a regular opcode call. In this way, it can be a useful means of reusing code
in certain applications.
7.7 Conclusions
This chapter explored a number of ways in which Csound can be extended, and
code can be composed into larger blocks. The UDO mechanism allows users to
implement new processing algorithms from scratch or to package existing opcodes
that can be used in instrument-like ordinary unit generators. With these possibilities,
it is simpler to organise our code into components that can be combined later in
different ways. UDOs can be saved in separate ﬁles and included in code that uses
them. They can also be very handy for showing the implementation of synthesis and
transformation processes, and we will be using them widely for this purpose in later
chapters of this book.
Part III
Interaction