# 5. The symbol ! will block the implicit carry of blank p-ﬁelds in a statement and

5. The symbol ! will block the implicit carry of blank p-ﬁelds in a statement and
subsequent ones.
In listing 8.2 we see these features being employed and their interpretation in the
comments.
Listing 8.2 Carry examples and their interpretation
i 1 0 5 10000 440
i . + 2 . 330
;i1 5 2 1000 440
i . + 1
;i1 7 1 1000 330
i 2 0 1 55.4 22.1
i . ˆ+1 . 67.1
;i2 1 1 67.1 22.1
i . ˆ+2 . !
;i2 3 1 [no p4 or p5 are carried]
160
8 The Numeric Score
8.4.2 Tempo
A powerful feature of the score is tempo processing. Each section can have an in-
dependent tempo setting, which can also be time-varying. Tempo is controlled by a
t-statement:
t
p1
p2
[p3
p4
...]
p1 should be 0 to indicate beat 0
p2 beat 0 tempo
p3, p5, ... odd p-ﬁelds indicate optional times in beats
p4, p6, ... even p-ﬁelds are the tempi for each beat in the preceding p-ﬁeld.
Tempo processing can create accelerandos, ritardandos and abrupt tempo changes.
Each pair of p-ﬁelds, indicating beats and tempi, will determine how the p2 and p3
ﬁelds in each i-statement are interpreted. Tempo values are deﬁned in beats per
minute. For instance, a ritardando is created with the following tempo pattern:
t 0 60 20 30
Tempo at the start is set at 60 bpm and by beat 20 it is 30 bpm. The tempo remains
at the last-deﬁned value until the end of the section. Equally, an accelerando can be
determined by a t-statement such as:
t 0 120 20 180
Any number of time-tempo pairs can be used. A single pair determines a ﬁxed
tempo for the section; if no tempo statements are provided, beats are interpreted as
seconds (60 bpm). Only one such statement is valid per section. The -t N option
can be used to override the score tempi of all sections, which will be set to N bpm.
The v-statement can be used as a local time warp of one or more i-statements:
v p1
where p1 is a time warp factor that will affect only the subsequent lines, multiplying
their start times (p2) and durations (p3). It can be cancelled or modiﬁed by another
v-statement. This has no effect on carried p2 and p3 values.
8.4.3 Sort
Following carry and tempo processing, the section i-statements are sorted into as-
cending time order according to their p2 value. If two statements have the same p2
value, they are sorted in ascending order according to p1. Likewise, if both p2 and p1
coincide, sorting is performed in p3 order. Sorting affects both i- and f-statements,
and if these two have the same creation time, the f-statement will take precedence.
8.4 Preprocessing
161
8.4.4 Next-p and Previous-p
The score also supports the shorthand symbols npN and ppN, where N is an inte-
ger indicating a p-ﬁeld. These are used to copy values from other p-ﬁelds: the ﬁrst
indicates the source of the p-ﬁeld to the next i-statement, and the second refers to
the previous i-statement. Since these are interpreted after carry, tempo and sort, they
can be carried and will affect the ﬁnal sorted list. Listing 8.3 shows some examples
with their interpretation in the comments. Note if there is no previous or next line,
the result is 0.
Listing 8.3 Next-p and previous-p examples
i 1 0 5 10000 440
pp5 np4 ; i 1 0 5 10000 0 30000
i 1 1 2 30000 330
pp4
; i 1 1 2 30000 330 10000 20000
i 1 2 1 20000 55 . pp5 ; i 1 2 1 20000 55 30000 330
These symbols are recursive and can reference other existing np and pp sym-
bols. Next-p and previous-p cannot be used in p1, p2 and p3, but can refer to these.
References do not cross section boundaries.
8.4.5 Ramping
A ﬁnal preprocessing offered by a score for i-statements can make values ramp up
or down from an origin to a given target. This is p-ﬁeld-oriented manipulation. The
symbol < is used for a linear ramp between two values, and ( or ) can be used to
create an exponential curve. A tilde symbol (∼) can be used to generate random
values in a uniform distribution between two values. Ramping is not allowed in p1,
p2 or p3.
Listing 8.4 Ramping example
i 1 0 1
100 ; 100
i 1 0 1
<
; 200
i 1 0 1
<
; 300
i 1 0 1
<
; 400
i 1 0 1
500 ; 500
8.4.6 Expressions
Ordinarily, p-ﬁelds accept only constant values. However, using square brackets ([
and ]), we can invoke a special preprocessing mode that can evaluate arithmetic
expressions and place the result in the corresponding p-ﬁeld. The common opera-
tors used in the Csound languages can be used here (+, -, *, / , ˆ, and %). The
162
8 The Numeric Score
usual rules of precedence apply, and parentheses can be used to group expressions.
Bitwise logical operators (& for AND,| for OR and # for exclusive-OR) can also
be used. The ∼symbol can be used to mean a random number between 0 and 1. A
y-statement can be used to seed the random number generator with a starting value:
y [p1]
The value of p1 is used as the seed, but it can be omitted, in which case the
system clock is used. The following examples use expressions in p-ﬁeld 4:
i 1 0 1
[2*(4+5)] ; 18
i 1 0 1
[10 * ˜] ; random (0 - 10)
i 1 0 1
[ 5 ˆ 2 ] ; 25
Expressions also support a special @N operator that evaluates to the next power-
of-two greater or equal to N. The @@N operator similarly yields the next power of
two plus one.
8.4.7 Macros
The preprocessor is responsible for macro substitution in the score; it allows text
to be replaced all over the score. As in the Csound language, we can use it in two
ways, with or without arguments. The simplest form is
#define
NAME
#replacement text#
where $NAME will be substituted by the replacement text, wherever it is found. This
can be used, for instance, to set constants that will be used throughout the code.
Listing 8.5 Score macro example
#define FREQ1 #440#
#define FREQ2
#660#
i1 0 1 1000 $FREQ1 ; i1 0 1 1000 440
i1 0 1 1500 $FREQ2 ; i1 0 1 1000 660
i1 0 1 1200 $FREQ1
i1 0 1 1000 $FREQ2
When a space does not terminate the macro call, we can use a full stop for this
purpose.
#define
OCTAVE
#8.#
i1 0 1 1000
$OCTAVE.09
; 8.09
i1 2 1 1000
$OCTAVE.00
; 8.00
Another form of #define speciﬁes arguments:
#define
NAME(a’b)
#replacement text#
8.5 Repeated Execution and Loops
163
where the parameters a and b are referred to in the macro as $a and $b. More
arguments can be used. In listing 8.6 we use arguments to replace a whole score
line.
Listing 8.6 Macro example, with arguments
#define
FLUTE(a’b’c’d) #i1 $a $b $c $d#
#define
OBOE(a’b’c’d) #i2 $a $b $c $d#
FLUTE(0 ’ 0.5 ’ 10000 ’ 9.00)
OBOE(0 ’ 0.7 ’ 8000 ’ 8.07)
Score macros can also be undeﬁned with:
#undef
NAME
8.4.8 Include
The preprocessor also accepts an include statement, which copies the contents of an
external text ﬁle into the score. For instance, the text
#include "score.inc"
where the ﬁle score.inc contains a series of statements, will include these to the
score in the point where that line is found. The ﬁle name can be in double quotes or
any other suitable delimiter character. If the included ﬁle is in the same directory as
the code, or the same working directory as a running Csound, then its name will be
sufﬁcient. If not, the user will need to pass the full path to it (in the usual way used
by the OS platform in which Csound is running). A ﬁle can be included multiple
times in a score.
8.5 Repeated Execution and Loops
The execution of sections can be repeated by the use of the r-statement
r p1
p2
where p1 is the number of times the current section is to be repeated, and p2 is the
name of a macro that will be substituted by the repetition number, starting from 1.
For example:
r
3
REPEAT
i1 0 1 1000 $REPEAT
i1 1 1 1500 $REPEAT
s
164
8 The Numeric Score
will be expanded into:
i1 0 1 1000 1
i1 1 1 1500 1
s
i1 0 1 1000 2
i1 1 1 1500 2
s
i1 0 1 1000 3
i1 1 1 1500 3
s
Another way to repeat a section is to place a named marker on it, which can then
be referred to later. This is done with the m-statement
m p1
where p1 is a unique identiﬁer naming the marker, which can contain numerals
and/or letters. This can then be referenced by an n-statement to repeat the section
once:
n p1
The n-statement uses p1 as the name of the marker whose section is to be played
again.
Listing 8.7 Section repeats in score
m arpeg
i1 0 1 10000 8.00
i1 1 1 10000 8.04
i1 2 1 10000 8.07
i1 3 1 10000 9.00
s
m chord
i1 0 4 10000 7.11
i1 0 4 10000 8.02
i1 0 4 10000 8.07
i1 0 4 10000 9.02
s
n arpeg
n chord
n arpeg
n chord
n chord
n arpeg
The example in listing 8.7 will alternate the ﬁrst two sections twice, then repeat
the second and ﬁnish with the ﬁrst.
Finally, the score supports a non-sectional loop structure to repeat any statements
deﬁned inside it. It uses the following syntax:
8.6 Performance Control
165
{ p1 p2
...
}
where p1 is the number of repeats required, and p2 is the name of a macro that will
be replaced by the iteration number, this time starting from 0. This is followed by
the score statements of the loop body, which is closed by a } placed on its own line.
Multiple loops are possible, and they can be nested to a depth of 39 levels.
The following differences between these loops and section repeats are important
to note:
•
Start times and durations (p2, p3) are left untouched. In particular, if p3 does not
reference the loop repeat macro, events will be stacked in time.
•
Loops can be intermixed with other concurrent score statements or loops.
The following example creates a sequence of 12 events whose p5 goes from 8.00
to 8.12 in 0.01 steps. The event start times are set from 0 to 11.
Listing 8.8 Score loop example
{ 12 N
i1 $N 1 10000 [8. + $N/100]
}
8.6 Performance Control
Two statements can be used to control playback of a score section. The ﬁrst one is
the a-statement:
a p1 p2 p3
This advances the score playback by p3 beats, beginning at time p2 (p1 is ig-
nored). It can be used to skip over a portion of a section. These statements are also
subject to sorting and tempo modiﬁcations similarly to i-statements.
The ﬁnal performance control statement is:
b p1
This speciﬁes a clock reset. It affects how subsequent event start times are inter-
preted. If p1 is positive, it will add this time to the following i-statements p2 times,
making them appear later; if negative, it will make the events happen earlier. To set
the clock back to normal, we need to set p1 to 0. If the clock effect on the next
i-statement makes p2 negative, then that event will be skipped.
166
8 The Numeric Score
8.6.1 Extract
Csound also allows a portion of the score to be selected for performance using its
extract feature. This is controlled by a text ﬁle containing three simple commands
that will determine the playback:
1. i <num> – selects the required instruments (default: all)
2. f <section>:<beat> – sets the start (from; default: beginning of score)
3. t <section>:<beat> – sets the end (to; default: end of score)
If a command is not given, its default value is used. An example extract ﬁle looks
like this:
i 2
f 1:0
t 1:5
This will select instrument 2 from section 1 beat 0 to section 1 beat 5. The extract
feature is enabled by the option
-x fname
where fname is the name of the extract ﬁle.
8.6.2 Orchestra Control of Score Playback
In the Csound language, three unit generators can issue score i-statements, which
will be sent to the engine as real-time events. These are the opcodes scoreline,
scoreline i and readscore. The ﬁrst two accept strings with i- and f-
statements (multiple lines are allowed) at performance and initialisation time, re-
spectively. The third also works only at i-time, but allows carry, next-p, previous-p,
ramping, expressions and loops to be preprocessed (although tempo warping and
section-based processing are not allowed).
In addition to these, the loaded score can be controlled with two init-time op-
codes:
rewindscore
which takes no parameters and rewinds the score to the beginning, and
setscorepos ipos
This can be used as a general transport control of the score, moving forwards
or backwards from the current position. The parameter ipos sets the requested
score position in seconds. These two opcodes can be very useful, but care must
be taken not to create problematic skips, when using them in instruments that can
themselves be called by a score. It is possible, for instance, to create a never-ending
loop playback by calling rewindscore in an instrument as the last event of a
score.
8.7 External Score Generators
167
8.6.3 Real-Time Events
Score events can be sent to Csound in real-time from external sources. The most
common use of this is via the API, where hosts or frontends will provide various
means of interacting with Csound to instantiate instruments. In addition to this,
Csound has a built-in facility to take events from a ﬁle or a device by using the -L
dname option, where dname is the name of a source. We can, for instance, take
events from the standard input (which is normally the terminal), by setting dname
to stdin:
<CsoundSynthesizer>
<CsOptions>
-L stdin -o dac
</CsOptions>
<CsInstruments>
instr 1
out oscili(p4*expon(1,p3,0.001),p5)
endin
</CsInstruments>
</CsoundSynthesizer>
Similarly, It is also possible to take input from a text ﬁle, by setting dname to the
ﬁle name. Finally, in Unix-like systems, it is possible to pipe the output of another
program that generates events. For instance the option
-L " | python score.py"
will run a Python program (score.py) and take its output as real-time events for
Csound. It is also possible to run a language interpreter, such as the Python com-
mand, in an interactive mode, outputting events to Csound. In this case we would
take the input from stdin, and pipe the output of the interpreter into Csound. For
instance, the terminal command
python -u | csound -L stdin -o dac ...
will open up the Python interpreter, which can be used to generate real-time events
interactively.
8.7 External Score Generators
A full numeric score is very easily generated by external programs or scripts. Its
straightforward format allows composers and developers to create customised ways
to manipulate scores. Csound supports this very strongly. A powerful feature is the
possibility to invoke external score generators from inside a CSD ﬁle. These can be
given parameters or a complete code, which they can use to write a score text ﬁle
that is then read directly by Csound.
168
8 The Numeric Score
This is provided as an optional attribute in the <CsScore> tag of a CSD ﬁle:
<CsScore bin="prog" >
...
</CsScore>
where prog is an external program that will be used to generate or preprocess the
score. The contents of the <CsScore> section in this case will not be interpreted
as a numeric score, but as input to prog. They will be written to a ﬁle, which is then
passed as the ﬁrst argument to prog. The external generator will write to a text ﬁle
whose name is passed to it as the second argument. This is then loaded by Csound
as the score. So this program needs to be able to take two arguments as input and
output ﬁles, respectively. Any such generator capable of producing valid score ﬁles
can be used.
As an example, let’s consider using the Python language to generate a minimal
score. This will create 12 events, with increasing p2, p4 and p5 (similar to the loop
example in listing 8.8).
Listing 8.9 External score generator using Python
<CsScore bin="python">
import sys
f = open(sys.argv[1], "w")
stm = "i 1 %f 1 %f %f \n"
for i in range(0,12):
f.write(stm % (i,1000+i*1000,8+i/100.))
</CsScore>
In listing 8.9 we see the relevant CSD section. The command python is selected
as the external binary. A simple script opens up the output ﬁle (argv[1], since
argv[0] is the input, the actual program ﬁle), and writes the twelve statements
using a loop. If we ran this example on the terminal, using the Python command,
the output ﬁle would contain the following text:
i 1 0.000000 1 1000.000000 8.000000
i 1 1.000000 1 2000.000000 8.010000
i 1 2.000000 1 3000.000000 8.020000
i 1 3.000000 1 4000.000000 8.030000
i 1 4.000000 1 5000.000000 8.040000
i 1 5.000000 1 6000.000000 8.050000
i 1 6.000000 1 7000.000000 8.060000
i 1 7.000000 1 8000.000000 8.070000
i 1 8.000000 1 9000.000000 8.080000
i 1 9.000000 1 10000.000000 8.090000
i 1 10.000000 1 11000.000000 8.100000
i 1 11.000000 1 12000.000000 8.110000
When Csound runs this script as an external generator, it uses temporary ﬁles
that get deleted after they are used. This mechanism can be used with a variety
8.8 Alternatives to the Numeric Score
169
of scripting languages, just by observing the simple calling convention set by the
system.
8.8 Alternatives to the Numeric Score
As we have pointed out at the outset, the score is but one of the many optional ways
we can control Csound. The score-processing features discussed in this chapter can
be replaced, alternatively, by code written in the Csound orchestra language. We can
demonstrate this with a simple example, in which two score-processing elements,
tempo statement (ritardando) and ramping, are integrated directly in the program.
The score calls an instrument from beat 0 to beat 10. The tempo decreases from
metronome 240 to 60, whilst the pitch decreases in equal steps from octave 9 (C5)
to octave 8 (C4).
Listing 8.10 Tempo and ramping score
t 0 240 10 60
i 2 0 1 9
i . + . <
i . + . <
i . + . <
i . + . <
i . + . <
i . + . <
i . + . <
i . + . <
i . + . <
i . + . 8
The scoreless version in listing 8.11 uses a UDO that calculates an interpolation
value. This is used for both pitch ramping and tempo (time multiplier) modiﬁcation.
The events themselves are generated by a loop.
Listing 8.11 Csound language realisation of score in listing 8.10
opcode LinVals,i,iiii
iFirst,iLast,iNumSteps,iThisStep xin
xout iFirst-(iFirst-iLast)/iNumSteps*iThisStep
endop
instr 1
iCnt,iStart init 0
until iCnt > 10 do
iOct = LinVals(9,8,10,iCnt)
schedule 2,iStart,1,iOct
iCnt += 1
170
8 The Numeric Score
iStart += LinVals(1/4,1,10,iCnt+0.5)
od
endin
schedule(1,0,0)
instr 2
out mode(mpulse(1,p3),cpsoct(p4),random:i(50,100))
endin
8.9 Conclusions
The Csound numeric score was the original method for controlling the software,
prior to the introduction of real-time and interactive modes. It has been used widely
in the composition of computer music works, and, for many users, it provides an
invaluable resource. Although the score is not a complete programming language in
a strict sense, it has a number of programmable features.
As we have seen, the score is best regarded as a data format, that is simple and
compact, and can be very expressive. It allows the use of external software and
languages to construct compositions for algorithmic music, and this feature is well
integrated into the Csound system, via the CSD <CsScore> tag bin attribute.
Scores can also be included from external ﬁles, and their use can be integrated with
real-time controls and events.