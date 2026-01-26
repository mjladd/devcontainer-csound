# 3. Perform audio computation by calling its perf-time subroutine repeatedly, pro-

3. Perform audio computation by calling its perf-time subroutine repeatedly, pro-
ducing vectors of ksmps samples and placing them in the output variable a1.
While this helps to keep code tidy and objective, it can lead to a crucial misread-
ing of the program. For instance, these lines in pseudocode
while kcnt < N do
asig[kcnt] opcode kinput[kcnt]
kcnt += 1
od
will instantiate one single copy of opcode and will run it repeatedly for N times
each k-cycle. This is not the same as having N separate instances of the opcode,
which are initialised and performed in succession, placing their output in an audio-
rate array, which is often the intended and expected result.
There are occasions when we want to achieve the effect of running an opcode
repeatedly, and loops can be used for that. To create sets of parallel opcodes, such as
oscillator or ﬁlter banks, loops are not appropriate. For these applications, we should
look to employ recursion, which will be explored later in this and other chapters.
Note that functions do not have state, by deﬁnition, and thus can be used without
any concerns in a k-rate loop. They are invoked according to the rate of their input,
and so can run exclusively at perf-time. With these, it is possible, with a bit more
code, to realise designs such as a bank of sinusoidal oscillators. In the example
shown in listing 5.5, we break down an oscillator into its components and recreate
it from scratch so that we can generate a sound by adding sine waves of different
amplitudes and frequencies. See also Section 3.5.2 for details on oscillators.
Listing 5.5 Control-rate loops for a bank of oscillators
instr 1
apha init 0
kph[] fillarray 0,0,0
kamp[] fillarray 1,0.1,0.5
kfr[] fillarray p5,p5*2.7,p5*3.1
kcnt = 0
asig = 0
while kcnt < lenarray(kph) &&
kcnt < lenarray(kamp) &&
kcnt < lenarray(kfr) do
ksmp = 0
kpha = kph[kcnt]
kf = kfr[kcnt]
while ksmp < ksmps do
kpha += (2*$M_PI*kf/sr)%(2*$M_PI)
114
5 Control of Flow and Scheduling
vaset(kpha,ksmp,apha)
ksmp += 1
od
asig += kamp[kcnt]*sin(apha)
kph[kcnt] = kpha
kcnt += 1
od
k1 expseg p4,p3,0.001*p4
out asig*k1
endin
schedule(1,0,1,0dbfs/2,300)
In this example, there is one loop nested inside another. The outer loop iterates
over the number of oscillators needed, which is determined by the sizes of the phase,
amplitude and frequency arrays. Each oscillator is made up of a phase update, a sine
function lookup and amplitude scaling. The inner loop takes care of updating the
phase. Since we are generating an audio signal, we need to create a phase vector
apha sample by sample, which will contain the phases corresponding to the fre-
quency of the oscillator. We use the opcode vaset to set the values of each sample
in apha, so the loop iterates over ksmps. Once this is done, we can generate the sig-
nal by calling the sin() function and scaling its output. Note that we have avoided
using all but one opcode in this loop. The one we employed is safe because it is ac-
tually stateless (it only copies a scalar k-var value into a position in an a-var vector),
and so it works like a function. The example uses an envelope to create a decay to
make it a percussive sound.
5.3 Scheduling
As we have already seen in earlier chapters, for instruments to execute and produce
sound, they need to be instantiated in the engine. Csound has two main mechanisms
for scheduling instances: real-time events and the numeric score. In this chapter, we
will concentrate on the former, and the latter will be discussed in Chapter 8.
With regards to the output audio stream, events are scheduled at k-period bound-
aries. Their start time and duration are rounded to the nearest control block time.
This means that there is a maximum quantisation error of 0.5
kr . At the default value
for kr (=4410, ksmps=10), this is equivalent to 0.11 ms, which is negligible. Even
at the more common setting of ksmps = 64, the error is less than one millisecond.
However, if this is not good enough, it is possible to run Csound at ksmps=1, or
use the special --sample-accurate option (with ksmps > 1), for sample-level
time event quantisation.
It is possible to issue new real-time events during performance in an instrument.
When these are scheduled, their start time is relative to the next k-cycle, for the
same reason as above, since Csound will sense new events in the intervals between
computation. So, time 0 refers to this, even in sample-accurate mode, as the process-
5.3 Scheduling
115
ing of a k-cycle is not interrupted when a new event is scheduled midway through
it. This is also the behaviour if events are placed from an external source (e.g. a
frontend through an API call).
5.3.1 Performance-Time Event Generation
So far, we have been using i-time scheduling in global space. But it is equally pos-
sible to place these schedule calls in an instrument and use them to instantiate other
instruments. This can be done also at performance time, as indicated above, using
the following opcode:
event Sop, kins, kst, kdur, [, kp4, ...]
Sop - a string containing a single character identifying the event type. Valid
characters are i for instrument events, f for function table creation and e for
program termination.
kins - instrument identiﬁer, can be a number, i- or k-var, or a string if the in-
strument uses a name instead of a number for ID. This is parameter 1 (p1).
kst - start time (p2).
kdur - duration (p3).
kp4, ... - optional parameters (p4, ...)
This line will execute at every k-period, so it might need to be guarded by a
conditional statement, otherwise new events will be ﬁred very rapidly. In listing
5.6, we can see an example of an instrument that plays a sequence of events on
another instrument during its performance time.
Listing 5.6 Performance-time event scheduling
instr 1
ktime = timeinsts()
k1 init 1
if ktime%1 == 0 then
event "i",2,0,2,p4,p5+ktime/100
endif
endin
instr 2
k1 expon 1,p3,0.001
a1 oscili p4*k1,cpspch(p5)
out a1
endin
schedule(1,0,10,0dbfs/2,8.00)
116
5 Control of Flow and Scheduling
In addition to event, we also have its init-time-only version event i, which
follows the same syntax, but does not run during performance. Finally, another op-
tion for perf-time scheduling is given by schedkwhen, which responds to a trigger,
and can also control the number of simultaneously running events.
5.3.2 Recursion
Since we can schedule one instrument from another, it follows that we can also
make an instrument schedule itself. This is a form of recursion [2], and it can be
used for various applications. One of these is to create multiple parallel copies of
instruments that implement banks of operators. For instance, we can implement the
bank of sinusoidal oscillators in listing 5.5 with recursive scheduling of instruments,
using a loop.
Listing 5.7 Bank of oscillators using recursion
instr 1
if p6 = 0 then
iamp[]fillarray p4*0.1,p4*0.5
ifr[] fillarray p5*2.7,p5*3.1
icnt = 0
while icnt < lenarray(iamp) &&
icnt < lenarray(ifr) do
schedule(1,0,p3,iamp[icnt],ifr[icnt],1)
icnt += 1
od
endif
k1 expon
1,p3,0.001
a1 oscili p4,p5
out a1*k1
endin
schedule(1,0,2,0dbfs/4,300,0)
We can also use recursion to create streams or clouds of events with very little
effort, by giving a start time offset to each new recursive instance. In this case, there
is no actual need for conditional checks, as long as we set the value of p2 no smaller
than one control period (otherwise we would enter an inﬁnite recursion at i-time).
Here’s a minimal instrument that will create a stream of sounds with random pitches
and amplitudes (within a certain range).
Listing 5.8 Bank of oscillators using recursion
seed 0
instr 1
k1 expon
1,p3,0.001
a1 oscili p4,p5
5.3 Scheduling
117
out a1*k1
schedule(1,.1,.5,
linrand(0dbfs/10),
750+linrand(500))
endin
schedule(1,0,1,0dbfs/4,300)
Each new event comes 0.1 seconds after the previous and lasts for 0.5 seconds.
The sequence is never-ending; to stop we need to either stop Csound or compile a
new instrument 1 without the recursion. It is possible to create all manner of sophis-
ticated recursive patterns with this approach.
5.3.3 MIDI Notes
Instruments can also be instantiated through MIDI NOTE ON channel messages.
In this case, the event duration will be indeterminate, and the instance is killed by
a corresponding NOTE OFF message. These messages carry two parameters, note
number and velocity. The ﬁrst one is generally used to control an instrument pitch,
while the other is often mapped to amplitude. The NOTE ON - NOTE OFF pair is
matched by a share note number. More details on the operation of Csound’s MIDI
subsystem will be discussed in Chapter 9.
5.3.4 Duration Control
Instruments can be scheduled to run indeﬁnitely, in events of indeterminate duration
that are similar to MIDI notes. We can do this by setting their duration (p3) to a
negative value. In this case, to kill this instance, we need to send an event with a
negative matching p1.
Listing 5.9 Indeterminate-duration event example
instr 1
a1 oscili p4,cpspch(p5)
out a1
endin
schedule(1,0,-1,0dbfs/2,8.00)
schedule(-1,5,1,0dbfs/2,8.00)
It is possible to use fractional instrument numbers to mark speciﬁc instances, and
kill them separately by matching their p1 with a negative value. The syntax for this
is num.instance:
schedule(2.1,0,-1,0dbfs/2,8.00)
schedule(-2.1,5,1,0dbfs/2,8.00)
118
5 Control of Flow and Scheduling
schedule(2.2,1,-1,0dbfs/2,8.07)
schedule(-2.2,4,1,0dbfs/2,8.07)
The important thing to remember is that in these situations, p3 is invalid as a
duration, and we cannot use it in an instrument (e.g. as the duration of an envelope).
For this purpose, Csound provides a series of envelope generators with an associ-
ated release segment. These will hold their last-generated value until deactivation
is sensed, and will enter the release phase at that time. In this case the instrument
duration is extended by this extra time. Most opcode generators will have a release-
time version, which is marked by an ‘r’ added to the opcode name: linsegr is the
r-version of linseg, expsegr of expseg, linenr of linen etc. Note that
these can also be used in deﬁnite-duration events, and will extend the p3 duration
by the release period deﬁned for the envelope.
For instance, the envelope
k1 expsegr 1,1,0.001,0.1,0.001
goes from 1 to 0.001 in 1 s, and holds that value until release time. This extends the
instrument duration for 0.1 s, in which the envelope goes to its ﬁnal value 0.001.
The two ﬁnal parameters determine release time and end value. If the instance is
deactivated before 1 s, it jumps straight into its release segment. It can be used in
the instrument in 5.6, to shape the sound amplitude.
Listing 5.10 Using a release-time envelope with an indeﬁnite-duration event
instr 1
k1 expsegr 1,1,0.001,0.1,0.001
a1 oscili p4*k1,cpspch(p5)
out a1
endin
schedule(1,0,-1,0dbfs/2,8.00)
schedule(-1,1,1,0dbfs/2,8.00)
Similarly, the other release time will add a ﬁnal segment to the envelope, which
extends the duration of the event. If multiple opcodes of this type are used, with
different release times, the extra time will be equivalent to the longest of these. The
Reference Manual can be consulted for the details of r-type envelope generators.
5.3.5 Ties
Together with negative (held) durations, Csound has a mechanism for tied notes. The
principle here is that one instance can take the space of, and replace, an existing one
that has been held indeﬁnitely. This happens when an event with matching (positive)
p1 follows an indeﬁnite duration one. If this new note has a positive p3, then it will
be the end of the tie, otherwise the tie can carry on to the next one.
In order to make the new event ‘tie’ to the previous one, it is important to avoid
abrupt changes in the sound waveform. For instance, we need to stop the envelope
5.3 Scheduling
119
cutting the sound, and also make the oscillator(s) continue from their previous state,
without resetting their phase. Other opcodes and sound synthesis methods will also
have initialisation steps that might need to be bypassed.
For this purpose, Csound provides some opcodes to detect the existence of a tied
note, and to make conditional jumps in the presence of one:
ival tival
will set ival to one on a tied event, and zero otherwise, whereas
tigoto label
executes a conditional jump at i-time (like igoto) only on a tie. This is used to
jump the initialisation of some opcodes, such as envelopes, which allow it. There
are, however, other opcodes that cannot be run without initialisation, so this mecha-
nism cannot be used with them. They will report an error to alert the user that they
need to be initialised.
The following example in listing 5.11 demonstrates the tied-note mechanism
with a very simple instrument consisting of an envelope, a sawtooth oscillator
(vco2) and a ﬁlter (moogladder). The tied note is detected in itie, and this
value is used to skip parts of the oscillator and ﬁlter initialisation. These opcodes
have optional parameters that can be set to the tival value to control when this is
to be done (check the Reference Manual for further information on this).
We also use the conditional jump to skip the envelope initialisation. This means
that the duration parameters are not changed. Additionally, its internal time count is
not reset and continues forward. Since we set the original envelope duration to the
absolute value of the p3 in the ﬁrst event, this should be used as the total duration
of all of the tied events. We set the p3 of whatever is the ﬁnal note to the remaining
duration after these. If no time remains, we close the tie with an event of 0 duration.
Listing 5.11 Tied event example
instr 1
itie tival
tigoto dur
env:
ist = p2
idur = abs(p3)
k1 linen 1,0.2,idur,2
dur:
if itie == 0 igoto osc
iend = idur + ist - p2
p3 = iend > 0 ? iend : 0
osc:
a1 vco2 p4*k1,cpspch(p5),0,itie
a2 moogladder a1,1000+k1*3000,.7,itie
out a1
endin
schedule(1,0,-6,0dbfs/2,8.00)
120
5 Control of Flow and Scheduling
schedule(1,2,-1,0dbfs/2,8.07)
schedule(1,3,-1,0dbfs/2,8.06)
schedule(1,4,1,0dbfs/2,8.05)
Note that treating ties often involves designing a number of conditional branches
in the code (as in the example above). In order to make multiple concurrent tied
streams the fractional form for p1 can be used to identify speciﬁc instances of a
given instrument.
5.4 Reinitialisation
The initialisation pass of an instrument can be repeated more than once, through
reinitialisation. This interrupts performance while the init-pass is executed again.
This can be done for selected portions of an instrument code, or for all of it:
reinit label
will start a reinitialisation pass from label to the end of the instrument or the
rireturn opcode, whichever is found ﬁrst. The next example illustrates reinitial-
isation. During performance, timout jumps to the end for 1
4 of the total duration.
After this, a reinitialisation stage starts from the top, and the timout counter is
reset. This makes it start jumping to the end again for the same length, followed by
another reinit-pass. This is repeated yet another time:
instr 1
icnt init 1
top:
timout 0, p3/4,end
reinit top
print icnt
icnt += 1
rireturn
end:
endin
schedule(1,0,1)
The printout to the console shows how the i-time variables get updated during
reinitialisation:
SECTION 1:
new alloc for instr 1:
instr 1:
icnt = 0.000
instr 1:
icnt = 1.000
instr 1:
icnt = 2.000
instr 1:
icnt = 3.000
5.4 Reinitialisation
121
Another example shows how reinit can be used to reinitialise k-time vari-
ables:
instr 1
puts "start", 1
top:
puts "reinit", 1
kcnt init 0
if kcnt > 10 then
reinit top
endif
printk2 kcnt
kcnt += 1
endin
schedule(1,0,0.005)
This will print out the following:
start
reinit
i1
0.00000
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
reinit
i1
0.00000
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
Csound also offers a special goto jump, active only at reinit time:
rigoto label
122
5 Control of Flow and Scheduling
Any perf-time opcodes inside a reinit block will be reinitialised, as shown in the
example above, with timout.
5.5 Compilation
In addition to being able to instantiate, initialise, perform and reinitialise, the
Csound language is also capable of compiling new code on the ﬂy. This can be
done via a pair of init-time opcodes:
ires compilestr Sorch
ires compileorc Sfilename
The ﬁrst opcode takes in a string containing the code to compiled, and the second
the name of a plain text ﬁle containing the Csound program, returning a status code
(0 means successful compilation). These opcodes allow new instruments to be added
to an existing performance. Once they are compiled, they can be scheduled like any
other existing instrument. If an instrument has the same number as an existing one,
it will replace the previous version. New events will use the new deﬁnition, but any
running instance will not be touched.
In listing 5.12, we show a simple example of how an instrument can be compiled
by another. Instrument 1 contains code to run at i-time only, which will compile a
string provided as an argument, and then schedule the new instrument, if successful.
Listing 5.12 Compiling code provided as a string argument
instr 1
S1 = p4
if compilestr(S1) == 0 then
schedule(2,0,1,p5,p6)
endif
endin
schedule(1,0,0,
{{
instr 2
k1 expon 1,p3,0.001
a1 oscili p4*k1,p5
out a1
endin
}}, 0dbfs/2, 440)
Although in this case we have a more complicated way of doing something that
is quite straightforward, the code above demonstrates a powerful feature of Csound.
This allows new instruments, provided either as strings or in a text ﬁle, to be dy-
namically added to a running engine.
5.6 Conclusions
123
5.6 Conclusions
This chapter explored the many ways in which we can control instruments in a
Csound program. We have explored the standard ﬂow control structures, such as
branching and looping, and saw how they are implemented within the language, in
their initialisation and performance-time forms. In particular, we saw what to expect
when opcodes are used inside loops, and that we need to be especially careful not to
misread the code.
The various details of how instruments are scheduled were discussed. We ex-
plored how instruments can instantiate other instruments at both init and perfor-
mance time. The useful device of recursion, when an instrument schedules itself,
was explored with two basic examples. The text also studied how event durations
can be manipulated, and how the tied-note mechanism can be used to join up
sequences of events. The possibility of reinitialisation was introduced as another
means of controlling the execution of Csound instruments.
