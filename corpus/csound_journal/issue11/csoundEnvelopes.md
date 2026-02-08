---
source: Csound Journal
issue: 11
title: "A Beginner's Guide to Volume Envelopes in Csound"
author: "giving the release more than enough time to finish"
url: https://csoundjournal.com/issue11/csoundEnvelopes.html
---

# A Beginner's Guide to Volume Envelopes in Csound

**Author:** giving the release more than enough time to finish
**Issue:** 11
**Source:** [Csound Journal](https://csoundjournal.com/issue11/csoundEnvelopes.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 11](https://csoundjournal.com/index.html)
## A Beginner's Guide to Volume Envelopes in Csound
 Jack Langmead
 jacklang AT froggy.com.au
## Introduction


If you are experienced with a 'traditional' synthesizer/sampler setup, you will be familiar with a volume envelope that has at least attack, decay, sustain and release controls. In this case smoothing and shaping a sound is a simple case of moving faders until the sound is satisfactory. What follows is a guide to the significantly more involved process of doing the same thing using code in Csound. The main difference is that Csound allows you to specify envelopes to a very fine degree, where traditional synthesizers really only interpret the instructions given to it by a user. Csound also offers an initially bewildering array of envelope options, and each option is suited for different uses and effects. The aim here is is to offer a guide to the options available and give the new user enough knowledge to begin using them. I also hope to spare the new user the hours of experimentation often required to work out why the envelopes do not seem to be doing what they should be doing.
##
 I. Envelopes for Score-Controlled Instruments


### linen


 When creating sounds in Csound, one of your first tasks is to get rid of the click that accompanies any raw unenveloped sound. The simplest tool available for de-clicking work is the `linen` opcode.

 The `linen` opcode requires four arguments:
- *iamp* or amp level (think of it as sustain level)
- *irise* time (attack)
- *idur* time (similar to sustain time, but the actual sustain time works out to *irise* + *idec* subtracted from the value placed here)
- *idec* time (release)  All times are entered in seconds.

 First, to see how this opcode does not work, let us use it in a less than ideal manner. So we create an envelope:
```csound
kenv linen 1, .1, 2, .3
```


then plug it in to an oscillator's amp argument:
```csound
a1 oscil iamp*kenv, inote, 1
```


and play it from the score:
```csound
;inst no	start	 duration       amp     pitch
i1 		0        2              70      7.00
```


 The note sounds fine. It comes in smoothly and finishes smoothly. But what happens if we change the score duration to 1? Not so smooth now, a very noticeable click at the end. Now try lengthening the note; give it a duration of 4. The note actually gets louder at the end—it fades back in after it fades out. The problem is that the envelope in this example will reach zero at a fixed time; that is, it will fade in, sustain, and fade out for a time equal to that specified in the *idur* argument. If the score plays the envelope for less than *idur*, it will suddenly cut off and create the click. This is the main problem that you will face with volume envelopes. If a note finishes before its release segment is finished, then it does not matter how smoothly you have programmed the fade out, it will instantly drop from wherever it is at to zero.

 On the other hand, if the note is played for longer than *idur* then it will have faded to zero before the note is finished playing. This might seem to solve the problem by giving the release more than enough time to finish, but the fade does not stop at 0, it keeps going past zero. This produces increasingly negative values, which has the effect of amplifying the sound. The reasons why increasing negative values create increasing amplitude are outside the scope of this article but will become clearer to anyone who continues study of how Csound produces waveforms.

 Obviously using a fixed value for *idur* is not a good idea, as the envelope can then only be used with instruments whose note duration can be known ahead of time. A more workable value for *idur* is 'p3':
```csound
kenv linen 1, .1, p3, .3
```


 Now try this envelope with a range of different note lengths in the score. It will not click or get unexpectedly louder, unless you use extremely small values for p3.
### adsr


 The `adsr` opcode is much more useful if you want to create more traditional synthesizer effects, as it has a decay segment as well as attack and release. With this opcode there is no need to specify a sustain/duration time, as this information is taken from the duration time specified in the orchestra. The arguments to the `adsr` opcode are:
- *iatt* (attack time)
- *idec* (decay time)
- *islev* (sustain level)
- *irel* (release time)  The times are specified in seconds, however you need to keep in mind that Csound will truncate some of these times if the note is shorter than the total of *iatt* + *idec* + *irel*. The opcode will first give preference to the release, the attack, then the decay. Any time left over is allocated to the sustain portion. To put it in simpler terms: if the note is shorter than the total `adsr` times, there is a good chance it will click, and an even better chance to that it will not sound the way you intended it to sound. The easiest solution to this problem is to always use notes longer than the total duration of the `adsr` envelope. Unlike the linen opcode, adsr does not 'go negative'; when the release portion hits zero. It stays at zero.

 A more effective solution is to specify the times as fractions of the duration given in the score:
```csound
kenv adsr p3*.1, p3*.3, .4, p3*.4
```


 Make sure that all the fractions add up to a value of 1.0 or less.

While this is an effective way of preventing unwanted noises, and you won't be restricted in the length of note with which it can be used, it is not an ideal solution. Using relative values means that the character of the envelope will change with the length of the note. One obvious problem is that it may create extremely long attack and fade times on very long notes. You will need to experiment with a mixture of relative and absolute values depending on how you want to use your note.

 One other thing to be aware of with the `adsr` opcode is that if *iatt* is set to zero, the whole envelope will be zero, and will produce nothing but silence. Of course if any part of the envelope is set to zero this also increases the chances that it will click.
### linseg


 In the manual, `linseg` is classified as a line segment generator, but it is very well suited for use as an envelope. `linseg` basically creates a pattern of rising and falling lines between points, which can be used as a control signal. The arguments to `linseg` run as follows:
- *ia* (level 1)
- *idur1* (duration 1)
- *ib* (level 2)
- *idurb* (duration 2)
- ...
-  plus as many subsequent levels and durations as you need, but there must be an odd number of arguments, and the final argument should define the final level

 The fact that you can have as many segments as you like means you can use `linseg` to create some very unique and finely crafted sounds. But it does take some work to get it right. The main problem with `linseg` is that it is not sensitive to the length of the note, and it is up to you to make sure that the times you specify don't total any more or less than the total duration of the note. If the envelope is too short it will click, and if longer than the note may 'go negative'.

 Again, the most reliable approach is to make each segment's duration a fraction of p3:
```csound
kenv linseg 0, p3*.2, 1, p3*.55, .5, p3*.25, 0
```

## II. Envelopes for MIDI-controlled Instruments


 Both the `linen` and `adsr` envelopes are dependent on information from the score to work properly, and cannot be used very effectively on MIDI-controlled instruments. When triggering a note from a MIDI sequencer or keyboard, the sustain portion is the result of a spontaneous decision by the composer or player. Therefore an envelope which is to work with a real-time instrument must be ready to react to the note's end at any time. All the envelope and envelope-like opcodes are available in a real-time version, mostly with an 'r' appended to the name of the opcode. The main feature of real-time envelope opcodes is that the release portion is only triggered when it receives a MIDI note-off message.
### linenr


 `linenr` takes four arguments as does the `linen` opcode:
- *xamp* (sustain level)
- *irise* (attack)
- *idec* (release time)
- *iatdec*  For `linenr` there is no duration argument, and there is a new argument, *iatdec* which interacts with the decay to produce a release segment. With `linenr`, *idec* is not triggered until a note-off message is received. *idec* behaves exactly as you would expect a release segment to behave. The *iatdec* value modifies idec so that the fade out is exponential rather than linear. To explain in simple terms, the idea is to drop the level as quickly and as low as is possible without a click, then when it is close to zero, create a slower fade to zero. The manual says *iatdec* is "normally in the order of .01. A large or excessively small value is apt to produce a cutoff that is audible." A few more things I have noticed:
- An *iatdec* value of between 1 and .4, produces a release with a linear fade out which tends to cut off abruptly
- Values of between .1 and .04 produce a more curved fade-out, but are susceptible to click
- Sounds with longer attacks (>.5) seem to work better with an *iatdec* in the order of .001  Try different values and look at the resultant waveform in a sound-editor if you want to see the effect of *iatdec*.
### madsr


 The `madsr` opcode is almost identical to `adsr` except:
- the sustain period lasts as long as the note is held
- the release segment is triggered as soon as the note is released
- all segments play for as long as the time allocated to them, unless the note is released before it starts or finishes  All this really means is that a `madsr` envelope behaves as you would expect an ADSR envelope found in a typical subtractive synthesizer setup to behave.
### linsegr


 The `linsegr` opcode is actually quite convenient for use as a real-time envelope. As with `linseg`, you can define as many levels and durations as you require, but in this case the final three arguments operate differently:
- the third-last argument is the sustain level
- the second last argument is the release time
- the final argument is the level at which the release terminates  Obviously you will need to make the final argument zero, or at least very small in order to get a smooth fade-out when using linsegr for volume shaping. The ability to define the release's resting level as something other than zero is more useful when the envelope is utilized for something like a filter, where a sudden drop in level does not necessarily cause a click, or can be smoothed out with a volume envelope. As with `linseg`, `linsegr` must have an a odd number of arguments and a minimum of three employed. However if you define the envelope with three arguments, you will have a slightly bizarre instrument that makes no sound while the key is held, and produces a single fade when released.
## III. Exponential Envelopes


Csound also makes the `linseg` and `linsegr` opcodes available as `expseg` and `expsegr`. Using these opcodes produces exponentially curved, rather than linear, fades between levels, producing a less even and more dynamic shift in volume over the course of a note. These opcodes work in exactly the same way as their equivalent linear versions, except that you may not use a zero value for any of the levels. If you need an exponential envelope to fade into, or down from silence, you need to use a very small value which produces virtual silence (ex. .001). You also need all the level arguments to agree in sign, that is, if one level is negative they all must be negative, and if one level is positive, they all must be positive. The `adsr` and `madsr` opcodes are also available in exponential versions — `xadsr` and `mxadsr`.
### Getting the Smoothest Possible Quality with an Exponential Envelope


 When you test out the exponential envelopes, you may notice that when the volume quickly drops to, or rises from, a very small level, it can sometimes create a quiet, but noticeable aliasing sound. I call this sound a 'tickle'. Tickle will be most noticeable when:
- the sound is relatively harmonically pure (sine wave or filtered with a cutoff of <250hz)
- the sound is played solo
- the sound is amplified  Most of the time surrounding audio will mask the tickle, but when it can be heard it does create an impression of low quality audio, so you may find it is worth the trouble to fix it. Tickle occurs when the control rate resolution is too low to smoothly change the volume at extremely low levels. For most envelopes the default control rate of 10 samples per control period is adequate, but when creating short, exponential fades from, or to, very small values, it just is not enough to accurately reconstruct the waveform, thus creating aliasing.

 The easiest solution is to simply calculate the envelope at audio rate. To do this, just change the variable pre-fix from 'k' to 'a'. So if you named the envelope 'kenv', rename it to 'aenv', and the tickle should disappear. If you are going to use this solution with `expseg`, use the `expsega` opcode, which is `expseg` optimized for use at audio rate. Another solution is to double the control rate to 8820 instead of the usual 4410, bringing the control resolution down to 5 samples per control period. To do this you will need to include the following statement at the beginning of your orchestra, just before the 'instr 1' statement:
```csound

sr = 44100
kr = 8820
ksmps = 5
```


I have found this will usually reduce the tickle to an acceptable level. You can also simply change `kr` to the same as `sr` and `ksmps` to one for the finest possible resolution on all instruments' control rates.

 You can test out the above suggestions using the file `ticklekick.csd` (linked at the end of this article).
## IV. More Interesting Envelopes.

### transeg


 This opcode gives you the ability to not only define as many segments as you like, but to define the type of curve, and its steepness, for each individual segment. The `transeg` opcode requires you define a minimum of four arguments:
- *ia* (starting level for first segment)
- *idur* (time taken to reach next level)
- *itype* (type of curve)
- *ib* (destination level/starting level for next segment) ...
- plus as many subsequent segments as you require  The *itype* argument works roughly like this:
- a value of zero produces a linear fade
- if the segment is a rising value (fades up from smaller to larger value):
  - a positive value will produce a concave (slow rate to start, gets faster) curve
  - a negative value will produce a convex (fast rate to start, becomes slower) curve
- if the segment is a falling value the opposite is true:
  - a positive value will produce a convex curve
  - a negative value will produce a concave curve

 The greater the *itype* argument, the steeper the curve. The effect of different values depends on the length of the segment, but I have found that the useful range is from around 0-70.
### loopseg


This opcode allows you to define an envelope of unlimited linear segments which loop at a specified rate. The creative potential of this opcode lies in the fact that each one of it's arguments is controllable at the k-rate. This means that `loopseg` can morph from a repetitive LFO-like effect to an ever-changing envelope—in real-time. The arguments for loopseg are:
- *kfreq* (the rate at which the envelope will loop, given in cycles-per-second)
- *ktrig* (defines how much of the envelope will 'play' before the loop restarts - usually set to zero so that the whole envelope is looped)
- *ktime0* (time for first segment)
- *kvalue0* (starting value for first segment
- *ktime1* (time for second segment)
- *kvalue1* (starting time for second segment/finishing time for first segment)
- ...
- plus as many subsequent segments as you require  The confusing thing here is that, unlike the other line generator opcodes, the time argument comes before the level argument. Just remember that each time argument defines the duration between the two level arguments that follow it. The next thing that may confound the new user is the fact that the times are all relative. Here the manual is fairly transparent in explaining how this works. Basically each segment will run for a portion of the cycle given in *kfreq*, and the size of that portion depends on what portion that time is of the total times. So if the envelope has 3 segments, the first having a time of 5, the second one of 10, and the third of 5, the first will run for a quarter of a cycle, the second for half a cycle, and the third for a quarter cycle. It is best to experiment to see how this works in practice.

 The minimum number of segments you must define is one, and so long as that requirement is satisfied the opcode will work regardless of how many arguments you put into it after that. By 'work' I mean simply that the compiler will not flag it as an error, but the envelope may do nothing, or it may do something unexpected.
## Conclusion


 The envelope used on a sound's volume, pitch or timbral parameters, is in many ways the equivalent to the playing style used to create sound with an acoustic instrument. Designing an envelope can be compared to an individual player's way of plucking a guitar string or sliding a bow across a violin. As you can see now, Csound offers vast resources to allow the sound designer to develop highly unique signature sounds if they willing to move beyond the comfort of ADSR sliders. Experiment and have fun.
### Further Reading.


 Vercoe, B et al, *The Canonical Csound Reference Manual*.

 The opcodes discussed in this article are found under: Part II: Opcodes Overview > Signal Generators > Linear and Exponential Generators/Envelope Generators.

 Bianchini, R & Cipriani, A, *Virtual Sound: sound synthesis and signal processing, theory and practice with Csound*, ConTempo, Rome, 2000.

This is an easy but thorough introduction to the mechanics of Csound, and digital sound in general.
### Downloads

- [tryenv.csd](https://csoundjournal.com/csoundEnvelopes/tryenv.csd) —Use this instrument to try out the various score-controlled envelopes.

- [ticklekick.csd](https://csoundjournal.com/csoundEnvelopes/ticklekick.csd) —This demonstrates "tickle".
