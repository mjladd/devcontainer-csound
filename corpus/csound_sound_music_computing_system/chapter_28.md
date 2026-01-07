# Chapter 5

Chapter 5
Control of Flow and Scheduling
Abstract In this chapter, we will examine the language support for program ﬂow
control in various guises. First, the text discusses conditional branching at initialisa-
tion and performance times, and the various syntactical constructs that are used for
that. This will be followed by a look at loops, and their applications. The chapter
continues with an examination of instrument scheduling at i-time and k-rate. Re-
cursive instruments are explored. MIDI scheduling is introduced, and the supports
for event duration control are outlined, together with an overview of the tied-note
mechanism. The text is completed with a discussion of instrument reinitialisation.
5.1 Introduction
Instrument control consists of a speciﬁc set of opcodes and syntactical constructs
that is essential to Csound programming. These allow us to control how and when
unit generators are run, and to plan the performance of instruments to a very ﬁne
level of detail. This chapter will outline the main elements of program control of-
fered by the language, such as branching, loops, instantiation, duration manipula-
tion, ties and reinitialisation.
5.2 Program Flow Control
Csound has a complete set of ﬂow control constructs, which can do various types
of branching and iteration (looping). These work both at initialisation and perfor-
mance times, and it is very important to keep the distinction between these two
stages of execution very clear when controlling the ﬂow of a program. As we will
see, depending on the choice of opcodes, the jumps will occur only at i-time or at
perf-time, or both. As before, the advice is to avoid intermixing of lines containing
distinct initialisation and performance code so that the instrument can be read more
© Springer International Publishing Switzerland 2016 
V. Lazzarini et al., Csound, DOI 10.1007/978-3-319-45370-5_5
105
106
5 Control of Flow and Scheduling
easily. This is a simple means of avoiding making the mistake of assuming that the
code will or will not execute at a given time.
5.2.1 Conditions
The ﬂow of control in an instrument (or in global space) can be controlled by check-
ing the result of conditions. These involve the checking of a variable against another,
or against a constant, using a comparison operator, which yields a true or false re-
sult. They are also called Boolean expressions:
a < b: true if a is smaller than b
a <= b: true if a is smaller than or equal to b
a > b: true if a is bigger than b
a <= b: true if a is bigger than or equal to b
a == b: true if a is equal to b
a != b: true if a is not equal to b
In this case, a and b are either both scalar variables (i or k), or a variable and
a constant. Furthermore, these operations can be combined into larger expressions
with logical operators that work speciﬁcally with Boolean results:
a && b: true only if a AND b are true, false otherwise
a || b: true if a OR b is true, false if both are false
where a and b are Boolean expressions using comparison or logical operators. The
execution of these at i- or k-time will depend on the type of branching employed.1
5.2.2 Branching
Csound allows branches to be created that depend on the value of Boolean expres-
sions. These can be evaluated at initialisation or performance time, or both. Many
of the branching constructs in Csound will use labels, which are names, placed any-
where in the code, that work as markers. The syntax for labels is:
label: ...
Labels are tokens composed of characters, numerals or both, and followed by a
colon (:). They can be inserted at the beginning of any code line, or at a blank line.
1 Also note that the conditional expression will not be evaluated at i-time at all if a k-variable is
employed in it. In this case, any branching will be perf-time only. See Section 5.2.2 for details.
5.2 Program Flow Control
107
Initialisation-time only
The basic branching statement for init-time-only execution is
if
<condition>
then igoto label
It can also be written in an opcode form:
cigoto condition, label
These statements provide an i-time jump to a label if the condition evaluates to
true. It allows the program to bypass a block of code, for instance
seed 0
ival = linrand(1)
if irnd
> 0.5 igoto second
schedule(1,0,1)
second:
schedule(2,0,1)
In this case, depending on the value of the ival variable, the code will schedule
instruments 1 and 2 (false), or instrument 2 only (true). Another typical case is to
select between two exclusive branches, for true and false conditions, respectively.
In this case, we need to employ a second label, and an igoto statement,
igoto label
which always jumps to label (no condition check). So, if we were to select instru-
ment 1 or 2, we could use the following code:
seed 0
ival = linrand(1)
if irnd
> 0.5 igoto second
schedule(1,0,1)
igoto end
second:
schedule(2,0,1)
end:
By inserting the end label after the second schedule line, we can jump to it if the
condition is false. In this case, the code will instantiate instrument 1 or 2, but never
both. Initialisation-time branching can be used in global space as in the example
here, or inside instruments.
Note that placing perf-time statements inside these branching blocks might cause
opcodes not to be initialised, which might cause an error, as the statements are ig-
nored at performance time, and all branches are executed. For this reason, i-time-
only branching has to avoid involving any perf-time code. One exception exists,
which is when the tied-note mechanism is invoked, and we can deliberately bypass
initialisation.
108
5 Control of Flow and Scheduling
Initialisation and performance time
A second class of branching statements work at both i- and perf-time. In this case,
we can mix code that is executed at both stages inside the code blocks, without
further concerns. In this case, we can use
if
<condition>
then goto label
or
cggoto condition, label
with the limitation that the Boolean expression needs to be i-time only (no k-vars
allowed). The jump with no conditions is also
goto label
The usage of these constructs is exactly the same as in the i-time-only case,
but now it can involve perf-time code. An alternative to this, which sometimes can
produce code that is more readable, is given by the form
if
<condition>
then
...
[elseif <condition> then
...]
[else
...]
endif
which also requires the condition to be init-time only. This form of branching syntax
is closer to other languages, and it can be nested as required. In listing 5.1, we see
the selection of a different sound source depending on a random condition. The
branching works at i-time, where we see the printing to the console of the selected
source name, and at perf-time, where one of the unit generators produces the sound.
Listing 5.1 Branching with if - then - else
seed 0
instr 1
if linrand:i(1) < 0.5 then
prints "oscillator \n"
avar = oscili(p4,cpspch(p5))
else
prints "string model \n"
avar = pluck(p4,cpspch(p5),cpspch(p5),0,1)
endif
out avar
endin
schedule(1,0,1,0dbfs/2,8.00)
5.2 Program Flow Control
109
Performance-time only
The third class of branching statements is composed of the ones that are only effec-
tive at performance time, being completely ignored at the init-pass. The basic form
is
if
<condition>
then kgoto label
or
ckgoto condition, label
and
kgoto label
The alternative if - then - endif syntax is exactly as before, with the dif-
ference that the perf-time-only form uses k-rate conditions. In programming terms,
this makes a signiﬁcant difference. We can now select code branches by checking
for values that can change during performance. This allows many new applications.
For instance, in the next example, we monitor the level of an audio signal and mix
the audio from another source if it falls below a certain threshold.
Listing 5.2 Branching with k-rate conditions
instr 1
avar init 0
avar2 = pluck(p4,cpspch(p5),cpspch(p5),0,1)
krms rms avar2
if krms < p4/10 then
a1 expseg 0.001,1,1,p3-1,0.001
avar = oscili(a1*p4,cpspch(p5))
endif
out avar+avar2
endin
schedule(1,0,5,0dbfs/2,8.00)
Note that we initialise avar to 0 since it always gets added to the signal, whether
a source is ﬁlling it or not. The only way to guarantee that the variable does not con-
tain garbage left over by a previous instance is to zero it. Various other uses of k-rate
conditions can be devised, as this construct can be very useful in the design of in-
struments. When using performance-time branching it is important to pay attention
to the position of any i-time statements in the code, as these will always be executed,
regardless of where they are placed.
Time-based branching
Csound provides another type of performance-time branching that is not based on a
conditional check, but on time elapsed. This is performed by the following opcode:
110
5 Control of Flow and Scheduling
timout istart, idur, label
where istart determines the start time of the jump, idur, the duration of the
branching and label is the destination of the jump. This relies on an internal clock
that measures instrument time. When this reaches the start time, execution will jump
to the label position, until the duration of the timeout is reached (the instrument
might stop before that, depending, of course, on p3). The example below is a mod-
iﬁcation of the instrument in listing 5.2, making the addition of the second source
time based. Note that the duration of the jump is for the remainder of the event.
Listing 5.3 Branching based on elapsed time
instr 1
avar init 0
avar2 = pluck(p4,cpspch(p5),cpspch(p5),0,1)
timout 1,p3-1,sec
kgoto end
sec:
a1 expseg 0.001,1,1,p3-2,0.001
avar = oscili(a1*p4,cpspch(p5))
end:
out avar+avar2
endin
schedule(1,0,5,0dbfs/2,8.00)
Since many aspects of Csound programming are based on the passing of time,
this type of branching can be very useful for a variety of applications. Note, how-
ever, that Csound offers many ways of time-based branching. So the code above
could also be written using timeinsts(), to get the elapsed time of an instru-
ment instance.
Listing 5.4 Another option for time-based branching
instr 1
avar init 0
avar2 = pluck(p4,cpspch(p5),cpspch(p5),0,1)
if timeinsts() > 1 then
a1 expseg 0.001,1,1,p3-3,0.001
avar = oscili(a1*p4,cpspch(p5+.04))
endif
out avar+avar2
endin
schedule(1,0,5,0dbfs/2,8.00)
Also scheduling an instrument at a certain start time from inside another instru-
ment is an option for time-based branching. This will be explained in Section 5.3.1.
5.2 Program Flow Control
111
Conditional assignment
Finally, Csound also provides a simple syntax for making assignments conditional:
xvar =
<condition> ?
true-expression : false-expression
This works at i- and perf-time:
avar = ivar > 0.5 ?
pluck(p4,ifr,ifr,0,1) : oscili(p4,ifr)
or at perf-time only:
kvar = rms(avar) > 0dbfs/10 ? 1 : 0
This statement can also be nested freely with multiple depth levels:
instr 1
kswitch line 2,p3,-1
avar =
kswitch <= 0 ?
oscili(p4,p5) : (kswitch <= 1 ?
vco2(p4,p5) :
pluck(p4,p5,p5,0,1))
out avar
endin
5.2.3 Loops
Csound allows the creation of iterative structures, called loops. As with branching,
these can be i-, perf-time or both. The simplest types of loops can be created with
goto etc. statements that make a jump to an earlier code line. Of course, in order
to avoid eternal repetition, we also need a condition to be placed somewhere. For
instance, an i-time loop to create 10 events with instrument 1 can be created with:
icnt init 0
loop:
if icnt == 10 igoto end
schedule(1,icnt,2,0dbfs/2,8.00 + icnt/100)
icnt += 1
igoto loop
end:
Similarly, loops on both init-pass and perf-time, or the latter alone, can be created
with goto, kgoto and their associated conditional statements.
The loop xx facility follows the same paradigm but simpliﬁes the code, as it
sets the increment and the break condition in a compact way:
icnt init 0
loop:
112
5 Control of Flow and Scheduling
schedule(1,icnt,2,0dbfs/2,8.00 + icnt/100)
loop_lt icnt, 1, 10, loop
Until and while
Csound also offers the more common forms of until and while loops. These
have the following syntax:
until <condition>
do
...
od
and
while <condition>
do
...
od
The difference between them is that until will loop when the condition is not
true, whereas while keeps repeating if the condition is true. For instance, the same
example given to create ten events on instrument 1 has the following form with
while:
icnt init 0
while icnt < 10 do
schedule(1,icnt,2,0dbfs/2,8.00 + icnt/100)
icnt += 1
od
If we want to use until, then the condition test is icnt >= 10. These loops
will work at initialisation and performance time if the condition is i-time, and at
performance time only if the condition is k-rate.
Control-rate loops
The possibility of control-rate loops also opens up a number of interesting avenues,
but a lot of care needs to be taken with these. Very often they can lead to code that
misrepresent the underlying processes. For this reason, it is worth examining this
mechanism in some detail.
Firstly, it is important to understand that a running opcode is an object with a
state. In Csound programming, the syntax simpliﬁes the process for the user, hiding
the complexities of dealing with these objects. This bundles opcode creation, which
involves allocating memory for its state (if needed), with the execution of its init-
and perf-time subroutines in one single code entity. The following line,
a1 oscili
p4, p5
5.2 Program Flow Control
113
means three things: