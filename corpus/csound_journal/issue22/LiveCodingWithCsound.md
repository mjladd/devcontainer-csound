---
source: Csound Journal
issue: 22
title: "Live Coding with Csound"
author: "default the keyboard shortcut for this is
ctrl"
url: https://csoundjournal.com/issue22/LiveCodingWithCsound.html
---

# Live Coding with Csound

**Author:** default the keyboard shortcut for this is
ctrl
**Issue:** 22
**Source:** [Csound Journal](https://csoundjournal.com/issue22/LiveCodingWithCsound.html)

---

CSOUND JOURNAL[](http://csoundjournal.com/index.html) | [Issue 22](http://csoundjournal.com/issue22/index.html)
## Live coding with Csound
 Hl�dver Sigurdsson
 hlolli AT gmail.com
## Introduction


This article will focus on musical performance where computer code is the only user interface, i.e. live-coding. The practice of live-coding as a means of performance has been existence for over a decade. The early adoptors of this practice established the TOPLAP organisation in 2004[[1]](https://csoundjournal.com/#ref1). Their slogan: "show us your screens", has had a great impact on laptop performers, encouraging them to project their code for the audience as they perform. During the summer of 2015, the first International Conference of Live Coding was held in Leeds, UK. The second one is scheduled for October 2016 and will be held in Hamilton, Canada[[2]](https://csoundjournal.com/#ref2). Live coding with Csound is a relatively new feature and, mainly for this reason, Csound has not yet become the first choice for musicians seeking to perform music with code. Since January 2013, as a student in Reykjavik, Iceland, I have performed around a dozen times with Csound, both through CsoundQt, and with Clojure, using the CsoundAPI. This article will focus on live-coding in CsoundQt, but I hope to write about live-coding using the CsoundAPI directly in a later article. I hope this overview can serve as an inspiration for current and future Csound users to take the leap and connect their monitors to a projector and start coding with Csound, live in front of an audience.
## I. Live Evaluations


 The easiest way to begin live-coding with Csound is to use the ready-made "Evaluate section" command within CsoundQt. By default the keyboard shortcut for this is ctrl+shift+w. To get a quick idea of how this works, open the Csound FLOSS Manual example, located under section 03 Csound Language, F. Live Csound, 03F15_Recompile_in_CsoundQt.csd from [[3]](https://csoundjournal.com/#ref3).
```csound
; 03F15_Recompile_in_CsoundQt.csd
<CsoundSynthesizer>
<CsInstruments>
sr = 44100
nchnls = 1
ksmps = 32
0dbfs = 1

instr 1
a1 oscils .2, 500, 0
out a1
endin

</CsInstruments>
<CsScore>
r 1000
i 1 0 1
</CsScore>
</CsoundSynthesizer>

```


 While playing with this example, the frequency value of 500 can be changed to any other number by evaluating the changes with ctrl+shift+w. The important thing to note here is that the Csound language can only mutate local variables through the initialisation pass, which in this case is the 1 second score event that gets repeated 1000 times. This means that in the 1000 ms time period between two score events, any changes that are evaluated will not take effect until the new score event is sent and the resulting re-initialisation pass is performed. With this simple setup, the live-coder can perform live sound design, add schedulers and, from there, add new instruments. Despite this being a rather primitive method of live-coding, live-coding from scratch in an audio programming language, and with no pre-made functions is nicknamed "Mexican style live-coding". This can still be regarded as representing good practice through imposing an artistic limitation. At the same time there remain dangers for the live coder such as the program crashing, of abusing eardrums, or having to spend too much time typing instead of making music, all of which make this method a poor choice for beginners.


Building upon of the idea of re-initialising every second, it is possible to create a basic sequencer as shown below in Example01. You can download all the Live Coding examples from the following link: [HSLiveCoding1Examples.zip](https://csoundjournal.com/downloads/HSLiveCoding1Examples.zip).
```csound
;Example01.csd
<CsoundSynthesizer>
<CsInstruments>

sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 1.0

#include "perc_set.udo"  ;some predefined instruments
#include "synths.udo"

giIndex init 0 ;despite being called index, it is actually a counter.

instr 1
giIndex += 1
iPattern1[] fillarray 1/2, 1/4, 1/6, 1  ;play around with these values
iPattern2[] fillarray 1,   1,   1/4, 1
iPattern3[] fillarray 1/4, 1/2, 1/4, 1/2
iFreqs[]    fillarray 195, 120, 190, 100

kMetro1 metro 1/iPattern1[giIndex % lenarray(iPattern1)] ;Leave these as it is,
kMetro2 metro 1/iPattern2[giIndex % lenarray(iPattern2)] ;but make sure that the
kMetro3 metro 1/iPattern3[giIndex % lenarray(iPattern3)] ;idea of modulo '%' is
kMetro4 metro 1/iPattern1[int(rnd(lenarray(iPattern1)))] ;firmly understood.

schedkwhen kMetro1, 0, 0, "hihat", 0, 0.1  ;play around with p2 and p3 fields
schedkwhen kMetro2, 0, 0, "kick", 0, 0.2
schedkwhen kMetro3, 0, 0, "snare", 1/2, 0.2
schedkwhen kMetro4, 0, 0, "synth", 0, 0.1, iFreqs[giIndex % lenarray(iFreqs)]
endin

instr hihat
aout perc_set -22, "hihat" ;in the perc_set opcode there is defined "hihat"
outs aout, aout            ;but it should not be confused with the instrument
endin                      ;definition of hihat, same goes for kick and snare.

instr kick
aout perc_set -13, "kick"
outs aout, aout
endin

instr snare
;aout perc_set -13, "snare"  ;uncomment and comment snare3 and evaluate.
aout perc_set -13, "snare3"
outs aout, aout
endin

instr synth
;aout phmod -20, p4       ;uncomment and comment sawtooth and evaluate.
aout sawtooth -24, p4
;aout moogvcf2 aout, 300, 0.9  ;adding filters live can be effective.
outs aout, aout
endin

</CsInstruments>
<CsScore>
t 0 120  ;let's choose 120BPM (that will be a fixed tempo)
;Repeating this way
;seems to solve some
;unwanted bugs.
{1000 x
i 1 $x 1
}
</CsScore>
</CsoundSynthesizer>

```


 This example demonstrates a way of reducing the amount of typing for the live-coder by including instruments in UDOs using the `#include` statements for the files perc_set.udo and synths.udo. By doing this, the live-coder can include his or her instruments and invoke them with a scheduler, in this case using the opcode `schedkwhen`. An important thing to notice in this example is that the global variable `giIndex` helps to bring a global state from one initialisation pass to the next. Without it, iteration via indices through the arrays would not be possible. Randomness, as seen in `kMetro4`, will continue to be a possibility without any global state. Furthermore, every event that takes place in-between the initialisation passes needs to be running at performance rate (k-rate). Therefore the `metro` is assigned to k-rate and `schedkwhen` is used instead of `schedwhen`. This example still has its limitations: in spite of the possibility for designing polyrhythmic patterns, the fact that the example is relying on a metronome to trigger the scheduler means that the live-coder cannot expect precise control over exactly when he or she wants his or her events to take place, or to create complicated event structures. By the nature of this design, everything is limited to how fast the score events are being sent (twice every second equates to 120 beats per minute), so multi-tempo patterns are not an option. These limitations mean that the following scheduler design presents a more accurate method.
```csound
;UDO included in patternizer.udo
;along with required Stray opcodes
;by Joachim Heinz
opcode patternizer, kkk,iiS
; Give it a string with numbers and it outputs trigger 1 or no-trigger 0
; Example ktrigger patternizer 4, 120, "0 1 2 3"
; Made by Hl�dver Sigurdsson 2016
iTimeSignature, iBPM, Spattern xin
  kOffTrigger init -1
  kPatLen StrayLen2 Spattern
  kPatMax StrayGetNum Spattern, kPatLen - 1
  krate_counter timek
  iOneSecond =  kr
  iBeatsPerSecond = iBPM / 60
  iTicksPerBeat = iOneSecond / iBeatsPerSecond
  if iTimeSignature != 0 then
  kBeatCounts = (ceil(kPatMax) >= iTimeSignature ? ceil((kPatMax+0.00001)/iTimeSignature)*iTimeSignature : iTimeSignature)
  endif
  kPatternLength = (iTimeSignature < 1 ? ceil(kPatMax+0.00001) * iTicksPerBeat : kBeatCounts * iTicksPerBeat)
  kIndex init 0
  kNextEvent StrayGetNum Spattern, kIndex % kPatLen
  kLastEvent StrayGetNum Spattern, (kPatLen - 1)
    if int(krate_counter % kPatternLength) == int(iTicksPerBeat * kLastEvent) then
       kOffTrigger += 1
    endif
    if int(krate_counter % kPatternLength) == int(iTicksPerBeat * kNextEvent) then
      kTrigger = 1
      kIndex += 1
    else
      kTrigger = 0
    endif
xout kTrigger, kOffTrigger, kIndex
endop

```


 First we will break the `patternizer` UDO down a bit. (This UDO file is also included with the downloadable examples files.) The scheduler is running entirely using the opcode `timek`; this opcode has an advantage over the `times` opcode both in terms of accuracy and in terms of design. Particularly important when using the API is to use the performance thread to drive the scheduler. In some of my calculations I calculated a delay of less than 3 ms, but that of course depends on the value of `ksmps`. What `timek` does is that it counts every performance pass, which means that for `sr=44100` and `ksmps=10` the number returned by `timek` should be 4410 after 1 second, or stated more simply, the value of `kr`. As this opcode is essentially a looping event sequencer, it can accept a variety of meter/time signatures. For a meter value of 4 (which can be regarded as 4/4), the opcode patterniser will only act in a 4 beat manner; that is to say: if we give it a value of 0 with a time signature value of 4, then an event is sent only on beat number 0 and the scheduler rests on beats 1, 2 and 3. This gives the live-coder the power to organise polyrhythmic patterns with an understanding of where each beat will align to the beats of the other patterns. The `xout` values of `kTrigger`, `kOffTrigger` and `kIndex` provide first the "on" trigger that starts an event by using, for example, the `schedkwhen` opcode, and second the "off" trigger which will return 1 when one pattern cycle is over, and also the index, which is very important for iterating arrays accordingly with each new event.
```csound
;Example02.csd
<CsoundSynthesizer>
<CsInstruments>
sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 1.0

#include "patternizer.udo"
#include "synths.udo"

instr 1
reviver 2 ;revive instrument 2 when 1 pattern round has ended
reviver 3 ;same for instrument 3
endin

instr 2
kTrigger, kOffTrigger, kIndex patternizer 4, 120, "0 1 2 3 3.5"
kFreqs[] fillarray 400, 500, 500, 700
kDurs[]  fillarray 0.1, 0.1, 0.5, 2
schedkwhen kTrigger, 0, 0, 100, 0, kDurs[kIndex % lenarray(kDurs)], kFreqs[kIndex % lenarray(kFreqs)], -24
if kOffTrigger == 1 then
turnoff
endif
endin

instr 3
kTrigger, kOffTrigger, kIndex patternizer 4, 120, "0 5 9 13"
kFreqs[] fillarray 90, 120, 150, 95
kDurs[]  fillarray 5, 4, 3, 6
schedkwhen kTrigger, 0, 0, 100, 0, kDurs[kIndex % lenarray(kDurs)], kFreqs[kIndex % lenarray(kFreqs)], -16
if kOffTrigger == 1 then
turnoff
endif
endin

instr 100 ;giving it a named instrument in this particular example causes instrument number conflicts
aout sweet p5, p4
outs aout, aout
endin
</CsInstruments>
<CsScore>
;Repeating this way
;seems to solve some
;unwanted bugs.
{1000 x
i 1 $x 1
}
</CsScore>
</CsoundSynthesizer>

```


 In spite of offering increased power, this is still rather a lot of code for a fairly simple process. In the middle of a performance, executing fast musical changes will become easier if the text can be reduced to just a few lines of code�ideally without losing power. One method that has proved very powerful for me when using the LISP dialect Clojure is meta-programming�or macros. One way in which Csound provides such an approach is when using the opcode `compilestr`, which allows for the compilation of strings. This gives the live-coder the power of real-time creation of instruments that can function as nodes of patterns. As an example of this, I have written the UDO `live_loop`, included with the downloadable examples. First a few important notes on this UDO: I wrote this UDO more as an example of the possibilities of technology and design, and particularly with the aim of minimising typing. It was developed with Csound 6.07 and CsoundQt 0.9.0 and for it to work properly you will probably need these two specific versions installed on your computer, however there is still no guarantee that it will work properly. I should also mention that the way in which this UDO suits me for live-coding may not suit others, therefore I encourage experimentation in its design. That said, let us look at this UDO design. On account of its large size, owing to the number of string operations it perfo rms, I have simplified its operation in the following flowchart, shown below in Figure 1.

**Figure 1. UDO `live_loop` flowchart.**

Below is a description or the manual entry for the UDO `live_loop`.
```csound
*SPatternName:* A unique name for a pattern. After a pattern is assigned to an
instrument, it can't be reassigned to a another instrument.

*Schedule:* An empty string means the pattern is turned-off. Event calculation starts
at 0 and end just before the value of iMeter. If equal or larger than the value
of iMeter, then a new bar is calculated. Since this is based on an indexed array,
the value must be written linearly (e.g. '0 1 2 3'). In case iMeter = 0, then
the pattern length is equal to the next integer of the last (and the greatest)
value.

*SParameters:* Is a string that operates on the p-fields for the events, that is
to say, all the p-fields except p2. For this UDO to work, the instrument must be
defined using a name and not a number. For each parameter (not including p1) the
numbers can be stored in square brackets which for each event will iterate through
(i.e Loop).

*iMeter:* Optional and defaults to 4. Meter value of 0 indicates a pattern without
meter, or a pattern that loops from the last and greatest value of the Schedule
string.
*
iBPM:* Optional, and defaults to 120. Controls the tempo of the pattern, measured
in beats per minute.

**live_loop** SPatternName, Schedule, SParameters,[iMeter, iBPM]

```


 The line of code below shows the process for evaluating the pattern "foo". As can be seen on the generated strings from the flowchart in Figure 1, this code uses the patternizer from the downloadable Example02.
```csound
live_loop "foo", "0 0.25 0.5 0.75", "synth1 [0.1 0.3] -25 [90 92 94 96]", 1, 140

```
 The callback from the flowchart in Figure 1 above is included in Example03, below.
```csound
;Example03.csd
<CsoundSynthesizer>
<CsInstruments>
sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 1.0

#include "live_loop.udo"
#include "perc_set.udo"
#include "synths.udo"

instr 1
;opcode  loop-name     schedule         instr-name  p3-field  p4(dbamp)  p5(frequencies) bar-size BPM
live_loop "foo",    "0 0.25 0.5 0.75",  "synth1    [0.1 0.3]   -25      [90 92 94 96]",  1,     140
live_loop "bar",    "0 1 1.5",          "drum1     [0.01 0.5 0.05] -31",                  2,     280
live_loop "fux",    "0 1 2 3 3.5",      "kick 0.3 -26 [80 80 95] [0.3 0.5]",              4,     140
endin

instr synth1
aout sweet p4, p5
outs aout, aout
endin

instr drum1
aout perc_set p4, "snare3"
outs aout, aout
endin

instr kick
 idur   = p3
 iamp   = ampdb(p4)
 ifreq  = p5
 ifreqr = p6 * ifreq
 afreq expon ifreq, idur, ifreqr
 aenv   line iamp, idur, 0
 aout poscil aenv, afreq, giSaw, 0.25
 outs aout, aout
endin

</CsInstruments>
<CsScore>
{10000 x
i 1 $x 1
}
</CsScore>
</CsoundSynthesizer>

```


 Example03 offers an idea for how to generate short rhythmical patterns with different meters and BPMs. It is possible to create these rhythmical patterns in a variety of ways. I recommend keeping things simple in order to reduce thinking time when performing live. For example, to keep the flow running, it is often better just to double the BPM Value of a "0, 1, 2, 3" pattern rather than writing out "0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5" with the same BPM. With more percussive instruments, FX and cool patterns, it is possible to produce more creative drum and bass patterns than those that I have assembled in this example. On account of the fact that it is possible to create new patterns by manipulating p-fields from p3 onwards, instruments can sound different on each beat, making the resulting music more organic and less basic sample playback.
## Add (a)tonality


 The UDO `live_loop` can be used to loop named instruments. With seperate instruments we can store global states and control them from an instrument 1 using our live loops. An example of a problem a live-coder may encounter when producing algorithmic music is controlling many instruments at once. When transposing C major riffs to say F major we may need to change the key of each pattern one at a time, but with global variables we can have many instruments reading the state of the same global variable. It is possible therefore to have an instance of `live_loop` for changing the root note for the chords and scales which all the other instruments can read.
```csound
;Example04.csd
<CsoundSynthesizer>
<CsInstruments>
sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 1.0

#include "live_loop.udo"

instr 1
;Key control                                            root-midi-note scale-type
live_loop "key_change", "0 1 2 3", "example_tonality 0.1 [48 50 51 47] [0 0 1 2]", 4, 15
;Instruments                                                             scale arr-indx
live_loop "sopr", "0 1 2 3 3.5",  "synth_soprano [2.2 2.2 1.9 1.7 4] -32 [2 1 0 5 4 3 2]", 8, 120
live_loop "alto", "0 0.5 1.5 2.5 3.5",  "synth_alto [0.5 0.3 0.3 0.3] -27 [4 2 4 2 0 7]", 4, 120
;                                                               chord-note-indx
live_loop "basso", "0 1 2 3",  "synth_alberti [0.5 0.4 0.3] -25 [0 3 2 1 5 4]", 4, 240
endin

instr example_tonality
if p5 == 0 then
giChord[] fillarray 0, 4, 7, 12, 16, 19 ;Major Chord
giScale[] fillarray 0, 2, 4, 5, 7, 9, 11, 12 ;Major Scale
elseif p5 == 1 then
giChord[] fillarray 0, 3, 7, 12, 15, 19 ;Minor
giScale[] fillarray 0, 2, 3, 5, 7, 8, 11, 12 ;Harmonic Minor
elseif p5 == 2 then
giChord[] fillarray 0, 4, 7, 10, 12, 16 ;Dominant
giScale[] fillarray 0, 2, 4, 7, 9, 10, 12 ;Mixolydian
endif
giChordLen lenarray giChord
giScaleLen lenarray giScale
giGlobalRoot = p4
endin

instr synth_soprano
iamp = ampdb(p4)
ifreq = cpsmidinn(giGlobalRoot+giScale[p5 % giScaleLen]+12)
asig vco2 iamp, ifreq
aenv adsr 0.1, 0.3, 0.1, 0.1
afilt moogvcf2 asig, ifreq*2.001, 0.3
outs afilt*aenv, afilt*aenv
endin

instr synth_alto
iamp = ampdb(p4)
ifreq = cpsmidinn(giGlobalRoot+giScale[p5 % giScaleLen])
asig vco2 iamp, ifreq*1.01
asig2 vco2 iamp, ifreq*0.98
aenv adsr 0.3, 0.1, 0.8, 0.3
afilt moogvcf2 (asig+asig2)/2, ifreq*1.7, 0.9
outs afilt*aenv, afilt*aenv
endin

instr synth_alberti
iamp = ampdb(p4)
;ifreq = p5
ifreq = cpsmidinn(giGlobalRoot+giChord[p5 % giChordLen]-12)
asig vco2 iamp, ifreq
aenv expon 1, p3, 0.1
afilt moogvcf2 asig, 310, 0.9
outs afilt*aenv, afilt*aenv
endin

</CsInstruments>
<CsScore>
{10000 x
i 1 $x 1
}
</CsScore>
</CsoundSynthesizer>

```


 The challenge of live-coding tonal music can be solved in a variety of ways. Algorithms can be created and saved as UDOs that will suit the particular compositional style of the performer. In my own algorithms I normally have instruments choose a position from within a scale or chord from which the root, third or fifth are usually selected more often than other non-chord notes. The task of creating a sense of real-time counterpoint is, for me, still in development.
## Conclusion


 Live-coding is, in my opinion, far from being a technology; rather it is something that combines the craft of composition, performance, improvisation and computer music. It can therefore be anything that the live-coder wants it to be. Csound is only an example of a technology amongst many that enable musicians to interact with his or her laptop in a manner similar to that in which a pianist interacts with a piano. Nonetheless, Csound happens to be a great piece of technology and it offers possibilities for live-coding that other audio based applications cannot. Unlike Supercollider, Csound is not based on a server design (*scsynth*), nor is it by nature a functional programming language (*sclang*). This may be a shortcoming in terms of the Csound language itself from the perspective of the live-coder but of course Csound's new functional syntax represents an improvement, and other features that are in development promise even greater streamlining. In terms of Csound itself, this is not really a shortcoming, as the CsoundAPI offers portability to many other programming languages, enabling the live-coder to extend the functionality of Csound into a whole new dimension. An example of using the CsoundAPI would be my system Panaeolus[[4]](https://csoundjournal.com/#ref4), based on Clojure, and Anton Kholomiov's spell-music/csound-expression, a Haskell Framework for Electronic Music[[5]](https://csoundjournal.com/#ref5). Both of these applications employ functional programming languages. In spite of Csound's old-school object-oriented syntax, live-coding in Csound is well within the reach of reasonably experienced Csound users. Live coding within the CsoundQt editor may pave the way for a deeper understanding of Csound and computer music in general and it represents a challenge every student of Csound should try at least once!
## References


[[1] TOPLAP, *About* (2011). [Online] Available: ][http://toplap.org/about/](http://toplap.org/about/) [accessed January 21, 2016].

[[2] Alex McLean, * International Conference on Live Coding 2016* (2016). [Online] Available: ][http://www.livecodenetwork.org/international-conference-on-live-coding-2016/](http://www.livecodenetwork.org/international-conference-on-live-coding-2016/) [accessed February 8, 2016].

[][3]Joachim Heintz, Iain McCurdy, et. al. *FLOSS Manuals, Csound*. Amsterdam, Netherlands: Floss Manuals Foundation, [online document]. Available: [http://write.flossmanuals.net/csound/f-live-events/ ](http://write.flossmanuals.net/csound/f-live-events/) [Accessed March 7, 2016].

[[4] Hl�dver Sigurdsson, * hlolli/panaeolus, *Live code csound with Clojure. [Online] Available: ][https://github.com/hlolli/panaeolus](https://github.com/hlolli/panaeolus) [accessed March 9, 2016].

[[5] Anton Kholomiov, *spell-music/csound-expression*, Haskell Framework for Electronic Music. [Online] Available: ][https://github.com/spell-music/csound-expression](https://github.com/spell-music/csound-expression) [accessed March 9, 2016].
