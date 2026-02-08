---
source: Csound Journal
issue: 15
title: "Phrase Loops: A Beginner's Guide"
author: "opcodes such as"
url: https://csoundjournal.com/issue15/phrase_loops.html
---

# Phrase Loops: A Beginner's Guide

**Author:** opcodes such as
**Issue:** 15
**Source:** [Csound Journal](https://csoundjournal.com/issue15/phrase_loops.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 15](https://csoundjournal.com/index.html)
## Phrase Loops: A Beginner's Guide
 Jim Aikin
 midiguru23 AT sbcglobal.net
## Introduction


Some styles of music make extensive use of loops (repeating patterns or phrases, with or without alterations in the repeats). Csound provides a number of ways to generate and manipulate such phrase loops. In this article we will introduce many of the possibilities We will be looking strictly at looped phrases consisting of discrete note events. Manipulating sampled loops is also a fruitful area for exploration, but the techniques are entirely different.

In this article I will use the words "event" and "note" more or less interchangeably to refer to what happens when an i-statement in the score causes a sound to play. You should note, however, that i-statements actually entered into a score (in a .sco file or the <CsScore> section of a .csd file) are sorted before the beginning of a performance, while events added to the score during performance by opcodes such as `event`, `scoreline`, and `schedule` are handled by Csound in a slightly different manner. For instance, t-statements (which adjust the tempo of score playback) will have no effect on events of the latter type.

In the interest of clarity and simplicity, all of the examples in this article use a very simple melodic fragment. The techniques we will discuss can easily be adapted in various ways to produce more complex phrases, even polyphonic phrases using several different instruments at once.


## I. The r Score Statement


The easiest way to create a loop in Csound is to precede a series of notes in the score with an r-statement and end it with an s-statement. The r-statement takes two parameters. The first is the number of times to repeat the loop, and the other is an optional macro, which is incremented (increased by 1) for each repetition of the loop.

Here is a simple .csd that uses the r-statement in this way. It plays a seven-note melodic fragment (from Haydn's Surprise Symphony) four times.
```csound
<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 4
nchnls = 2
0dbfs = 1

giSine ftgen 0, 0, 4096, 10, 1

; a sine wave with a plucked envelope:
instr 1

idur = p3
iamp = p4
ifrq cps2pch p5, 12

kamp line iamp, idur, 0
asig oscili kamp, ifrq, giSine

outs asig, asig
endin

</CsInstruments>
<CsScore>

r 4
t 0 120

i1 0 1 0.25 9.00
i1 +
i1 + . . 9.04
i1 +
i1 + . . 9.07
i1 +
i1 + 2 . 9.04
s

</CsScore>
</CsoundSynthesizer>
```


If we like, we can elaborate the r-statement slightly by using a macro. Here is the same loop again, but this time with a half-step upward transposition on each repeat:
```csound
r 4 HSTP
t 0 120
i1 0 1 0.25 [9.00 + (($HSTP. - 1) * 0.01)]
i1 +
i1 + . . [9.04 + (($HSTP. - 1) * 0.01)]
i1 +
i1 + . . [9.07 + (($HSTP. - 1) * 0.01)]
i1 +
i1 + 2 . [9.04 + (($HSTP. - 1) * 0.01)]
s
```


The value of `HSTP` is 1 the first time the loop is played, 2 the second time, and so on. Take a look at how the macro is used in the i statements. It is preceded by the '`$`' character and followed by a period. The formula being used in the p-field is surrounded by square brackets. I have subtracted 1 from `HSTP` so that the first repetition will be at the same pitch as in the previous version.

This implementation is adequate for simple music, but it suffers from a non-trivial limitation: the phrase enclosed between the r- and s-statements is the only thing that can be going on in the score at that moment. It is not possible to run several simultaneous loops of different lengths using this technique, nor to run a loop alongside a changing, non-looped part, because sections within a Csound score can not overlap. (You can, however, use an r-statement loop to create a phrase, render the phrase to your hard drive as audio, and then play back the audio file in a different .csd.)

Another problem is that the loop will not start a new repetition until the last (or longest) note in the phrase has finished and been shut off. So if you happen to use an envelope opcode that ends in `-r` (to create a release segment), you will notice a gap at the end of each repetition, before the start of the next repetition. To see what I mean, try running the .csd above after replacing the line in the instrument definition containing the line opcode (that is, the amplitude envelope) with this code:
```csound
kamp linsegr iamp, idur, 0.1, 0.5, 0
```


 Fortunately, there are other alternatives.


## II. The { Score Statement


A more flexible way to introduce looped phrases into the score is to use the { statement. This statement, as explained in "[The Canonical Csound Reference Manual](http://www.csounds.com/manual/html)", takes two parameters: the number of times to repeat the loop, and a macro name. The macro can (and should) be used as described above, to change what happens in the loop in each repetition. Note, however, that the value of the macro on the first pass through a { loop is zero, not one.

A loop that begins with { ends with the symbol }, which should appear on a line by itself.

Loops defined with { and } can be nested within one another, and several can be running at once. The end of a { loop is not necessarily the end of a section. Another important difference between an r loop and a { loop is that the { loop takes no notice of advancing time. If you want the iterations of the loop to be strung out over time, it is up to you to use the loop macro to adjust `p2`.

Returning to the previous example, replace the <CsScore> section of the file with this pair of loops:
```csound
{ 3 BUMP
i1 [$BUMP * 7]	1	0.25	9.00
i1 +
i1 +			.	.	9.04
i1 +
i1 +			.	.	9.07
i1 +
i1 +			2	.	9.04
}
{ 4 NUDGE
i1 [$NUDGE * 5.5]	1.5	0.25	7.00
i1 +				.	.	7.07
i1 +				.	.	7.00
i1 +				2.5	.	7.08
}
```


These two loops run concurrently. They are of different lengths, and each of them has an overlap between the end of one iteration and the beginning of the next one. The loop macros (BUMP and NUDGE) are being used to increase the first `p2` value on each pass through the loop.

For many musical purposes, the { statement may be all you need to generate musically useful loops. But more possibilities remain to be explored.


## III. Defining Phrases as Macros


Instead of using the score elements of our looping phrase directly, we can turn them into a macro. Having done this, we can use b-statements in the score to play the phrase wherever we like, while keeping the score tidy. Here is a new version of the original score that you can paste into the version of the .csd shown above.
```csound
#define PHRASE_01 #
i1 0 1 0.25 9.00
i1 +
i1 + . . 9.04
i1 +
i1 + . . 9.07
i1 +
i1 + 2 . 9.04
#
#define PHRASE_LEN # 8 #

$PHRASE_01
b $PHRASE_LEN
$PHRASE_01
b [$PHRASE_LEN * 2]
$PHRASE_01
b [$PHRASE_LEN * 3]
$PHRASE_01
```


The actual score that will be heard is generated entirely by the lines in which the macros are used. This method has the advantage that, as with the { statement, the phrases can overlap if desired. (Try setting the PHRASE_LEN to 6 to hear this.) And again, other music can be layered with the phrase. All you need to do is set `b` back to 0 (or whatever other value you like) when you are finished looping the phrase, and you can add whatever additional score statements you like.

A score macro can take up to five arguments. This lets us vary the repetitions of the loop with considerably more flexibility than if we were using the simple incrementing macro value provided by an r or { statement. Here is the same phrase shown above, with an argument (VOL) that makes each repetition quieter than the previous one:
```csound
#define PHRASE_01(VOL) #
i1 0 1 $VOL 9.00
i1 +
i1 + . . 9.04
i1 +
i1 + . . 9.07
i1 +
i1 + 2 . 9.04
#
#define PHRASE_LEN # 8 #

$PHRASE_01(0.25)
b $PHRASE_LEN
$PHRASE_01(0.2)
b [$PHRASE_LEN * 2]
$PHRASE_01(0.15)
b [$PHRASE_LEN * 3]
$PHRASE_01(0.1)
```


In the first repetition, the value in p4 will be 0.25. In the second repetition, it will be 0.2, and so on. This gives us a powerful way of repeating a looped phrase in the score. For our next examples, we turn to a different concept: generating score events from within a master instrument — essentially, a step sequencer instrument.
## IV. The Scoreline Opcode


Using the scoreline opcode, we can pass an arbitrary series of i-statements to the score while the score is playing. Note that the use of double curly braces in scoreline statements — that is, {{ and }} — is completely different from the use of curly braces in a Csound score. Here is a .csd that demonstrates the use of scoreline:
```csound
<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 4
nchnls = 2
0dbfs = 1

giSine ftgen 0, 0, 4096, 10, 1

; a phrase player:
instr 1
ktrig init 1
scoreline {{
i11 0 1 0.25 9.00
i11 1 1 0.25 9.00
i11 2 1 0.25 9.04
i11 3 1 0.25 9.04
i11 4 1 0.25 9.07
i11 5 1 0.25 9.07
i11 6 2 0.25 9.04
}}, ktrig
ktrig = 0
endin

; a sine wave with a plucked envelope:
instr 11
idur = p3
iamp = p4
ifrq cps2pch p5, 12
kamp linsegr iamp, idur, 0.1, 0.5, 0
asig oscili kamp, ifrq, giSine
outs asig, asig
endin

</CsInstruments>
<CsScore>

i1 0 1
i1 8 1
i1 16 1
i1 24 1

</CsScore>
</CsoundSynthesizer>
```


The notes in the melody are now embedded in a scoreline statement. However, when you play this example, you will hear that the notes are proceeding at a stately 60 bpm, rather than at the more bouncy 120 bpm we set up in the previous example (using a t statement in the score to control the tempo). The events in scoreline are always inserted in the score with an implicit tempo of 60. That is, a value of 1 for `p2` will always equate to one second. Putting a t-statement into the data within scoreline is illegal, and a t-statement in the score itself will be ignored by the events being generated by scoreline, because the t-statement has been used by Csound at an earlier stage, while sorting the i-statements in the score.

In addition, some of the syntactic shortcuts that can be used in a Csound score (such as using a '+' in `p2`) won't work in scoreline. Each event has to be spelled out in full.

To get our tempo back up to 120 bpm, we would need to edit the scoreline statement like this:
```csound
scoreline {{
i11 0	0.5	0.25	9.00
i11 0.5	0.5	0.25 9.00
i11 1	0.5	0.25 9.04
i11 1.5	0.5	0.25	9.04
i11 2	0.5	0.25	9.07
i11 2.5	0.5	0.25	9.07
i11 3	1	0.25	9.04
}}, ktrig
```


This will let us generate a loop, provided we are willing to write out each iteration of the loop as a new event in the score, calling our step sequencer instrument like this:
```csound
t 0 120
i1 0 1
i1 8 1
i1 16 1
i1 24 1
```


What if we want to use a macro within a scoreline, so that the repetitions will not be identical? The macro syntax used in Csound score cannot be used with scoreline, so instead we need to create some string (text) data first using the `sprintf` opcode and then pass it to scoreline. Here is an example that shows how to do that:
```csound
<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 4
nchnls = 2
0dbfs = 1

giSine ftgen 0, 0, 4096, 10, 1

; a phrase player:
instr 1
ktrig init 1

ip1 = 9.00 + (p4 * 0.01)
ip2 = 9.04 + (p4 * 0.01)
ip3 = 9.07 + (p4 * 0.01)
ip4 = 9.04 + (p4 * 0.01)

; create some text and assign it to the Sscoreblock variable:

Sscoreblock sprintf {{i11 0 0.5 0.25 %f
i11 0.5 0.5 0.25 %f
i11 1 0.5 0.25 %f
i11 1.5 0.5 0.25 %f
i11 2 0.5 0.25 %f
i11 2.5 0.5 0.25 %f
i11 3 1 0.25 %f}}, ip1, ip1, ip2, ip2, ip3, ip3, ip4

scoreline Sscoreblock, ktrig
ktrig = 0
endin

; a sine wave with a plucked envelope:

instr 11
idur = p3
iamp = p4
ifrq cps2pch p5, 12
kamp linsegr iamp, idur, 0.1, 0.5, 0
asig oscili kamp, ifrq, giSine
outs asig, asig
endin

</CsInstruments>
<CsScore>

t 0 120
i1 0 1 0
i1 8 1 2
i1 16 1 4
i1 24 1 3

</CsScore>
</CsoundSynthesizer>
```


This code is starting to look a little complicated, so let us examine it in more detail to see what is going on. Starting at the end, we have added a new p-field to our score events. This value controls how far upward we want the pitch of each repetition to be transposed. We are no longer limited to a linear series of alterations, as we were when we used the r-statement macro. (However, due to the way `cps2pch` interprets its inputs, negative values for this parameter would need more specialized handling.)

In `instr 1`, we are using a series of values (`ip1` through` ip4`) to denote the pitches we want to be played by `instr 11`. We then pass these as arguments to the `sprintf` opcode. The output of `sprintf` is the string variable named `Sscoreblock`. This will be used by the scoreline statement. The arguments to `sprintf` (`ip1`, `ip1`, `ip2`, and so forth) will be placed within the text block at the positions marked by the characters `%f`.

This method works nicely with simple loops. But as the length of the loop increases, and as we think of more p-fields within those score events that we might want to vary, handling the data using `sprintf` will get unwieldy. To loop more complex patterns, we may want to use a different approach.
## V. Looping with the Schedule Opcode


The `schedule` opcode inserts a new event into the score (as does the event opcode, in a slightly different way). In the page that discusses schedule in "The Canonical Csound Reference Manual" for Csound version 5.11, reference is made to a parameter called ktrigger. However, this parameter is not used in the opcode. In fact, schedule runs at i-time, which means that it does not need a trigger. Each schedule line will fire only once per instance of the instrument in which it is used.

Here is our familiar sequenced phrase, built using schedule. Again, note that schedule always assumes that the tempo is 60 bpm, because its events are inserted into the score after any t statements have been used to adjust the time data in the actual score. So we have to shorten our desired p2 and p3 times accordingly.
```csound
instr 1
schedule 11, 0, 0.5, 0.25, 9.00
schedule 11, 0.5, 0.5, 0.25, 9.00
schedule 11, 1, 0.5, 0.25, 9.04
schedule 11, 1.5, 0.5, 0.25, 9.04
schedule 11, 2, 0.5, 0.25, 9.07
schedule 11, 2.5, 0.5, 0.25, 9.07
schedule 11, 3, 1, 0.25, 9.04
endin
```


Substituting new values for the arguments to schedule is much simpler than with `sprintf`, because we do not need to build a text string — we can replace the values directly. We might, for instance, do something like this:
```csound
ibasepitch = p4
schedule 11, 0, 0.5, 0.25, ibasepitch
schedule 11, 0.5, 0.5, 0.25, ibasepitch
schedule 11, 1, 0.5, 0.25, ibasepitch + 0.04
schedule 11, 1.5, 0.5, 0.25, ibasepitch + 0.04
schedule 11, 2, 0.5, 0.25, ibasepitch + 0.07
schedule 11, 2.5, 0.5, 0.25, ibasepitch + 0.07
schedule 11, 3, 1, 0.25, ibasepitch + 0.04
```


... and in the score:
```csound
t 0 120
i1 0 1 9.00
i1 8 1 9.02
i1 16 1 8.10
i1 24 1 9.01
```


In this version we are able to transpose downward safely with the values in `p4`, because `cps2pch` knows how to interpret values like 8.17, even when the scale has only 12 steps per octave. More to the point, we can send several values to `instr 1` in p-fields, and use them however we like in the schedule lines.
## VI. Sequencing Using Tables


In an analog sequencer, you may find several parallel rows of knobs in a rectangular grid. Using patch cords connected to the row outputs, you can modulate various parameters, changing their values from step to step as the master clock driving the sequencer advances from one column of knobs to the next. One row might control pitch, another the length of the clock step, and so on. The overall length of the sequence might also be controllable, its internal clock resetting to zero when some step is reached.

A natural way to imitate this design in Csound is using GEN routines to create tables of data. The code in the next example is very different from what we have seen so far — and yet the musical result is the same.
```csound
<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 4
nchnls = 2
0dbfs = 1

giSine ftgen 0, 0, 4096, 10, 1
giPitches ftgen 0, 0, 8, -2, 9.00, 9.00, 9.04, 9.04, 9.07, 9.07, 9.04, 8.00
giStepLen ftgen 0, 0, 8, -2, 1, 1, 1, 1, 1, 1, 2, 4
giDurations ftgen 0, 0, 8, -2, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1, 1
gkMetro init 0

; a metronome:
instr 1
gkMetro metro p4
endin

; a phrase player:
instr 2
iseqlength = p4
kstepnum init 0
ksteplen init 1
kpitch init 9.00
kdur init 0.5
kwait init 1
if (gkMetro == 1) then
	if (kwait == 0) then
		kpitch table kstepnum, giPitches
		kdur table kstepnum, giDurations
		event "i", 11, 0, kdur, 0.25, kpitch
		ksteplen table kstepnum, giStepLen
		kwait = ksteplen - 1
		kstepnum = kstepnum + 1
		if (kstepnum >= iseqlength) then
			kstepnum = 0
		endif
	else
		kwait = kwait - 1
	endif
endif
endin

; a sine wave with a plucked envelope:
instr 11
idur = p3
iamp = p4
ifrq cps2pch p5, 12
kamp linsegr iamp, idur, 0.1, 0.5, 0
asig oscili kamp, ifrq, giSine
outs asig, asig
endin

</CsInstruments>
<CsScore>

; run the metronome for 16 seconds
i1 0 16 2
; play the sequence:
i2 0 16 7

</CsScore>
</CsoundSynthesizer>
```


This is not a spectacularly sophisticated implementation, but it illustrates the concept. The sequence data is now stored ahead of time, just below the orchestra header, using ftgen routines. A global metronome (`gkMetro`) is set up. This is run by `instr 1`. The sequencer itself is now in `instr 2`.

With this simple example, the metronome could be incorporated into the step sequencer instrument itself. The advantage of making the metronome a separate instrument and its trigger signals a global variable is that several step sequencers can run at the same time and remain in sync with one another.

`Instr 2` tests whether the value of `gkMetro` is 1; if so, it may be time to start the next note. But because some notes may be longer than others, we also need to check whether the value of `kwait` has dropped to 0. If it hasn't, we are still in the middle of a long note, so we will just decrement the value of `kwait` and then sit back and wait for another metronome tick to arrive. Once we receive a metronome trigger and `kwait` is also 0, we will use event to fire off a new note, using values read from the appropriate tables using the `table` opcode.

Values in the `giStepLen` table are assumed to be integers; this simple sequencer will break if we try to use a step length of 1.5. To make more complex rhythms, you would need to double (or quadruple) the speed of the metronome and then adjust the table data accordingly.

In this example, the final step in the tables is never used. It is included because each table created with GEN02 needs eight values — or at least, that is what it says on the GEN02 page of "The Canonical Csound Reference Manual". If you click through to the page on f-statements, however, you will find a hint that the size of a table need be a power of 2 or a power of 2 plus one only if the p-field value for size is positive. Because we need only seven steps in our simple test sequence, we can use a value of -7 for the size, and delete the final data value:
```csound
giPitches ftgen 0, 0, -7, -2, 9.00, 9.00, 9.04, 9.04, 9.07, 9.07, 9.04
giStepLen ftgen 0, 0, -7, -2, 1, 1, 1, 1, 1, 1, 2
giDurations ftgen 0, 0, -7, -2, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1
```


The main limitation of the algorithm shown here is that it is monophonic. It only plays one note at a time. To create a polyphonic loop phrase, you might want to run several instances of the phrase player at once, passing values to them in the p-fields so as to trigger different instruments, use different tables, and so on.

To change the sound of the loop interactively while it plays, you can create a separate instrument whose sole function is to use the tableiw opcode to edit the existing tables. Another refinement would involve letting the table of pitches be a different length than a table of amplitude accents, durations, or whatever. That is, the counter that increments through the table of pitches would be separate from the counter incrementing through another table, so that a complex cycle was produced from simple data sets.

To go a bit further in this all-too-brief tour of step sequencing options, we will add a couple of LFOs to our step sequencer. The output of the first LFO will be sent, via the `event` opcode, to `instr 11`, which will use it to pan the sound to some point in the stereo field. Add these lines to `instr 2`:
```csound
kpan lfo 0.5, 2.3
kpan = kpan + 0.5
```


...and also add `kpan` as an argument to the event line:
```csound
event "i", 11, 0, kdur, 0.25, kpitch, kpan
```


Then edit `instr 11`, adding an input for `p6`, so that it looks like this:
```csound
instr 11
idur = p3
iamp = p4
ifrq cps2pch p5, 12
ipan = p6
kamp linsegr iamp, idur, 0.1, 0.5, 0
asig oscili kamp, ifrq, giSine
aoutL, aoutR pan2 asig, ipan
outs aoutL, aoutR
endin
```


The `p6` value sent from the `event` opcode is assigned to `ipan`, and is then used by the `pan2` opcode to adjust the relative levels of `aoutL` and `aoutR`.

Needless to say, much more complex results than this are easy to achieve. Global k-rate values can be used to modulate the sequenced notes while they're sounding, which may be more interesting than the i-rate panning changes shown above. If your sequenced instrument uses a filter, for instance, you might want to use a global k-rate variable to sweep the filter up and down. Here is a .csd that does that:
```csound
<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 4
nchnls = 2
0dbfs = 1

giSine ftgen 0, 0, 4096, 10, 1
giPitches ftgen 0, 0, 8, -2, 9.00, 9.00, 9.04, 9.04, 9.07, 9.07, 9.04, 8.00
giStepLen ftgen 0, 0, 8, -2, 1, 1, 1, 1, 1, 1, 2, 4
giDurations ftgen 0, 0, 8, -2, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1, 1
gkMetro init 0
gkFiltLFO init 0

; a metronome:
instr 1
gkMetro metro p4
endin

; a phrase player:
instr 2
iseqlength = p4
kstepnum init 0
ksteplen init 1
kpitch init 9.00
kdur init 0.5
kwait init 1

kpan lfo 0.5, 2.3
kpan = kpan + 0.5

kfiltlfo lfo 1000, 0.4
gkFiltLFO = kfiltlfo + 1000

if (gkMetro == 1) then
	if (kwait == 0) then
		kpitch table kstepnum, giPitches
		kdur table kstepnum, giDurations
		event "i", 11, 0, kdur, 0.25, kpitch, kpan
		ksteplen table kstepnum, giStepLen
		kwait = ksteplen - 1
		kstepnum = kstepnum + 1
		if (kstepnum >= iseqlength) then
			kstepnum = 0
		endif
	else
		kwait = kwait - 1
	endif
endif
endin

; a filtered sawtooth:
instr 11
idur = p3
iamp = p4
ifrq cps2pch p5, 12
ipan = p6

kamp linsegr iamp, idur, 0.1, 0.5, 0
asig vco2 kamp, ifrq, 0
afilt moogvcf asig, gkFiltLFO + 500, 0.4

aoutL, aoutR pan2 afilt, ipan
outs aoutL, aoutR
endin

</CsInstruments>
<CsScore>

; run the metronome for 16 seconds
i1 0 16 2
; play the sequence:
i2 0 16 7

</CsScore>
</CsoundSynthesizer>
```


If you have been following along with the examples, you only need to replace a few lines in your existing .csd to produce the code above. First, add this to your orchestra header to create a global bus for the LFO signal:
```csound
gkFiltLFO init 0
```


Then add two lines to `instr 2` to generate an LFO sweep and send it to the global bus:
```csound
kfiltlfo lfo 1000, 0.4
gkFiltLFO = kfiltlfo + 1000
```


Finally, change `instr 11` to use a `vco2 `and a `moogvcf` . Use the global LFO signal to control the filter cutoff, and send the filter's output to `pan2`:
```csound
asig vco2 kamp, ifrq, 0
afilt moogvcf asig, gkFiltLFO + 500, 0.4
aoutL, aoutR pan2 afilt, ipan
```

## Conclusions


Which loop sequencing technique or techniques you use will depend on what you want to achieve. Personally, I like using the `event` opcode, tables, and global LFOs, because it reminds me of analog step sequencing. Using phrase macros is more like working in a pattern-based multitrack sequencer, such as Image-Line FL Studio.

Another very interesting tack has been developed by Jacob Joaquin. He uses text strings in his score to create a very clever drum-machine-style grid of note triggers. You will find a working example at [http://www.thumbuki.com/csound/files/thumbuki20070502.csd](http://www.thumbuki.com/csound/files/thumbuki20070502.csd).
