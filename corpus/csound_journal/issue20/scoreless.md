---
source: Csound Journal
issue: 20
title: "Scoreless Csound"
author: "then questionable"
url: https://csoundjournal.com/issue20/scoreless.html
---

# Scoreless Csound

**Author:** then questionable
**Issue:** 20
**Source:** [Csound Journal](https://csoundjournal.com/issue20/scoreless.html)

---

CSOUND JOURNAL[](https://csoundjournal.com/../index.html) | [Issue 20](https://csoundjournal.com/index.html)
## Scoreless Csound

### Running Csound from the orchestra
 Victor Lazzarini
 vlazzarini AT nuim.ie
## Introduction


 Traditionally, the practice has been to supply Csound with two inputs: an orchestra and a score. This is how we have been taught to use Csound in Barry Vercoe's [ A Beginning Tutorial](http://www.csounds.com/tootsother/vercoetut/Vercoe.html)[[1]](https://csoundjournal.com/#ref1). In fact, this is exactly how many users and non-users view Csound: a system based on the paradigm of an orchestra driven by a fixed-pfield numerical score. However, for more than twenty years now, the capability to accept MIDI input, and indeed, line events, has been there, which dilutes, if not obliterates, the idea of an orchestra-score monolith that is believed to be the basis of Csound. Later, the addition of widget controls in the final releases of Csound 4 also added another alternative means of using Csound. With Csound 5 and the firm establishment of the API, the standard numeric score became effectively **only** one of many ways of controlling the system. In fact, even the adjective "numeric" was by then questionable, as strings could be used in pfields instead of numbers.

 In Csound 6, the system has matured not only to allow various means of controls, but also to require only that an orchestra is present in order to make sound. In other words, it is not necessary to have a score to run Csound. In fact, with the --daemon mode, it is possible to start Csound without any input at all, and supply orchestras and control inputs as needed (via the API, frontends, or as UDP data). Since it is possible to recompile orchestra code on-the-fly, new styles of programming using only the orchestra language are possible.

 In this article, I would like to explore a style of programming Csound which employs solely the orchestra to control how instruments are run, without the use of the numerical score. It not only allows a uniform and possibly more elegant means of programming, but also novel forms of using Csound that were not possible with the traditional use of the standard numeric score.

 A note about the examples: all original code used here is orchestra-only and uses the Csound 6 syntax (this of course excludes the first example taken from Vercoe's tutorial). It can be run by placing it in the orchestra section of a CSD file, by compiling it through an API call, by selecting it in CsoundQT and using the command * evaluate selection*, by using the [online compiler](http://csound.github.io/trycsound.html), or by sending it via UDP to a Csound server (`--port=N` option).

(The following references examples you can download for this article from the following link: [scoreless_csound.zip](https://csoundjournal.com/downloads/scoreless_csound.zip))
##
 I. Simple event scheduling


### Traditional scores


 Let us begin by considering Vercoe's tutorial example[[1]](https://csoundjournal.com/#ref1), which has the following orchestra,
```csound

sr = 44100	; audio sampling rate is 44.1 kHz
kr = 4400	; control rate is 4410 Hz
ksmps = 10	; number of samples in a control period (sr/kr)
nchnls = 1	; number of channels of audio output

instr 1
kctrl	line	0, p3, 10000	; amplitude envelope
asig	oscil	kctrl, cpspch(p5), 1	; audio oscillator
out	asig		; send signal to channel 1
endin

```


 which is driven by the following score:
```csound

f1	0	256	10	1	;  a sine wave function table

;  a pentatonic scale
i1	0	.5  	0	8.01
i1 	.5   	.	.	8.03
i1	1.0   	.	.	8.06
i1	1.5   	.	.	8.08
i1	2.0   	.	.	8.10
e

```
 We can translate this into a scoreless code by employing the `schedule` opcode. Each one of the i-statements in the score, below, is mapped into an instance of `schedule` in global space (ie. outside the instruments, also known as `instr 0`).
```csound

schedule 1,   0, .5, 0, 8.01
schedule 1,  .5, .5, 0, 8.03
schedule 1,   1, .5, 0, 8.06
schedule 1, 1.5, .5, 0, 8.08
schedule 1,   2, .5, 0, 8.10

instr 1
 kctrl	linen	10000,0.01,p3,0.1
 asig	oscili	kctrl, cpspch(p5)
 out	asig
endin

```


 Note that we can get rid of the `sr`, `kr`, `ksmps`, `nchnls` lines because they are using the default values. We also do not need to create a sinewave table, because Csound 6 has a default table (-1), which is used by default by the `oscil `opcode. Replacing the `line` for a `linen` also removes the clicks heard in the original example, as the sounds finish more gracefully; we should also use `oscili `instead of `oscil` for a cleaner sound.
### Event generation


 The above example does not really demonstrate any particular advantage over the traditional score. However, we can do better. Consider this: the `schedule` lines above have quite a bit of repetition in their parameters. Surely we can do something to avoid all that longhand coding. This is what we do:
```csound

ipch init 8.01
icnt init 0
start:
if icnt > 5 igoto end
 schedule 1, icnt/2, .5, 0, ipch
 ipch = (icnt == 1 ? ipch+0.03 : ipch+0.02)
 icnt += 1
 igoto start
end:

instr 1
...

```


 With a few lines of orchestra code, we generated the same sequence of events programmatically. This is something that would not be possible to do in the score (after all, the score is not a programming language, even though it has some preprocessing support). Loops are possible in the score, but not very sophisticated ones. Even a simple one like in the example above would not be possible because of the use of branching/conditionals.

 The benefit of this is that we can change the generative patterns by doing simple modifications to the code. For instance, we can create sequences of the same pattern by placing another loop around it. It is also very easy to control the duration and start time of events, by making them depend on a given variable (`idur`).
```csound

idur init 0.1
ipch init 8.01
icnt init 0
icnt2 init 0
until icnt2 > 4 do
start:
if icnt > 5 igoto end
 schedule 1, (icnt2*5 + icnt)*idur,idur, 0, ipch
 ipch = (icnt == 1 ? ipch+0.03 : ipch+0.02)
 icnt += 1
 igoto start
end:
icnt = 0
icnt2 += 1
ipch = 8.01 + icnt2*0.01
od

instr 1
...

```


 In fact, we can think of a number of different ways we can exploit such programmatic capabilities of scoreless Csound. The examples above give us just a glimpse of what is possible.
## II. Extending the range


### Performance time


 We are not limited to using global-space code. By going beyond it to using instruments themselves to run other instruments, we can start moving away from a fixed score. After all, although the examples above were generative, they created finite sets of events. What if we want to generate a pattern to be repeated indefinitely?

 In that case, we will use an instrument that runs indefinitely, and take advantage of the built-in perform loop. An active instrument will be able to schedule events according to a trigger. For this we use the `metro` opcode to generate the trigger at a given rate, and `event` to issue the events. Note that because we are working at performance time, we do not need to write an explicit loop, the code will be running iteratively at the k-rate. We schedule this instrument to run indefinitely.
```csound

schedule 2,0,-1,8.01

instr 2
 idur = 0.1
 kcnt init 0
 kpch init p4
 if metro(1/idur) == 1 then
  event "i",1,0,idur,0,kpch
  if kcnt > 5 then
    kpch = p4
    kcnt = 0
  else
    kpch = (kcnt == 1 ? kpch+0.03 : kpch+0.02)
    kcnt += 1
  endif
 endif
endin

instr 1
...

```


 Interestingly, with this code, if we want to create interlocking patterns, all we need is to schedule other instance(s) of the instrument, starting slightly after the first.
```csound

schedule 2.0,0,-1,8.01
schedule 2.1,0.05,-1,8.07

```


 We have to use different fractional p1 values for `schedule` to make sure two separate indefinitely-running instances would be issued. Otherwise, the second schedule would just replace the instance launched by the first, due to the use of negative p3.
### Data sources


 All previous examples used a simple algorithm to set the pitch of each event: if we are in the second step we jump by three semitones, otherwise we jump by two. We implemented it using conditionals, but we could have ignored the algorithm and stored the parameter data somewhere and source it from there. A simple way of doing this is using a table, and placing the required parameter values there. The table then can be read with the desired index. The example below demonstrates this approach.
```csound

schedule 2.1,0,-1,1
it ftgen 1,0,6,-2,8.01,8.03,8.06,8.08,8.10

instr 2
 idur = 0.1
 kcnt init 0
 if metro(1/idur) == 1 then
  event "i",1,0,idur,0,table:k(kcnt,1)*p4
  kcnt = (kcnt == 4 ? 0 : kcnt+1)
 endif
endin

instr 1
...

```


 In this particular case, it generates a more compact code. Tables are particularly useful if we want to draw a given shape or use a certain function to create a pattern, as some GENs (Generator Routines) can do it very well, with a few parameters.

 We can also use arrays to store data. Below is shown a version that replaces the table using a global array.
```csound

schedule 2.1,0,-1,0
gkpch[] fillarray 8.01,8.03,8.06,8.08,8.10

instr 2
 idur = 0.1
 kcnt init 0
 if metro(1/idur) == 1 then
  event "i",1,0,idur,0, gkpch[kcnt]+p4
  kcnt = (kcnt == 4 ? 0 : kcnt+1)
 endif
endin

instr 1
...

```


 Here we can also depart from the original Vercoe example and add another parameter, amplitude. To make it a slightly more interesting pattern, we will use an array containing 4 values, which will go in and out-of-phase with the 5-pitch pattern. Using a modulus operation, we make sure the index is inside the correct range for each array.
```csound

schedule 2.1,0,-1,0
gkpch[] fillarray 8.01,8.03,8.06,8.08,8.10
gkamp[] fillarray 0.5,0.05,0.6,0.9

instr 2
 idur = 0.1
 kcnt init 0
 i1 lenarray gkpch
 i2 lenarray gkamp
 if metro(1/idur) == 1 then
  event "i",1,0,idur, gkamp[kcnt%i2], gkpch[kcnt%i1]+p4
  kcnt = (kcnt == i1*i2-1 ? 0 : kcnt+1)
 endif
endin

instr 1
 kctrl	linen   p4*0dbfs,0.01,p3,0.1
 asig	oscili	kctrl, cpspch(p5)
 out	asig
endin

```

## III. Recursion


### From head to tail


 Another way of looking at event generation is to think that an instrument can schedule itself to run again at some point. In this case, we have the classic example of recursion used to repeat an action, instead of a loop. In this case, we can actually get rid of the `metro` trigger and the conditional. In fact, we can get rid of instrument 2 altogether and do everything from instr 1. We only need a single schedule from global space to *prime* the process and then the rest is done by recursion, as shown in the following example. (This technique is also known as *temporal recursion*[[2]](https://csoundjournal.com/#ref2).)
```csound

schedule 1,0,0.5,0,0
gipch[] fillarray 8.01,8.03,8.06,8.08,8.10
giamp[] fillarray 0.5,0.05,0.6,0.9

instr 1
 icnt = p5
 i1 lenarray gipch
 i2 lenarray giamp
 kctrl	linen giamp[icnt%i2]*0dbfs,0.01,p3,0.1
 asig	oscil	kctrl, cpspch(gipch[icnt%i1]+p4)
 out	asig
 icnt = (icnt == i1*i2-1 ? 0 : icnt+1)
 schedule 1,p3,p3,p4,icnt
endin

```


 Recursion is a nice programming device that can be used to very good effect, for both sequential instances (as in this example) and also for parallel/chordal textures. The only thing to watch out for, is to make sure we do not enter an eternal recursive path, and lock Csound out. This happens when the next event scheduled falls in the same k-cycle as the calling instrument and there are no conditions set to finish up the recursion. So we should be careful when scheduling sequential events such as the above to make sure the next start event is scheduled for a time that is `ksmps/sr` ahead. It is possible to add in a conditional check for that in the code.
### Randomness


 A great advantage of scheduling events from the orchestra is that we can use all the generating facilities that the huge collection of Csound opcodes provides. For instance, we can use oscillators to read table patterns and produce periodic parameter changes; we can use signal measurement, eg. of amplitude, pitch, centroid, to control how instruments are run; and so on. The possibilities are very wide.

 One particular example of this is worth exploring here: the use of random number generators. Completing the set of examples above, we can introduce random choices of parameters to the recursion process. We can keep the structure of the previous example, but instead of counting up, we calculate a random index into the arrays for each event. In order to give the performance a slight *swing*, we can use another random generator to add small deviations to the event start times and durations:
```csound

schedule 1,0,0.5,0,0
gipch[] fillarray 8.01,8.03,8.06,8.08,8.10
giamp[] fillarray 0.1,0.02,0.2,0.3

instr 1
 indx = p5
 i1 lenarray gipch
 i2 lenarray giamp
 kctrl	linen giamp[indx%i2]*0dbfs,0.01,p3,0.1
 asig	oscil	kctrl, cpspch(gipch[indx%i1]+p4)
 out	asig
 idur = gauss(0.05)+0.25
 schedule 1,idur,idur*2,p4,int(linrand:i(100))
endin

```


 Again, to generate another pattern to interlock with our first one, we can just add one or more "primers". Each one will generate a stream of recursive events, and we can use p4 to transpose it (an octave in this case). Also, using `seed`, we can guarantee a new random sequence every time we run the code, as shown in the code snippit below.
```csound

seed 0
schedule 1,0,0.5,0,0
schedule 1,0.075,0.5,1,0

```


 Depending on the frontend used, it will be possible to modify the recursive instruments and recompile them on-the-fly. This will then produce a change in the patterns that are generated. It is also possible to recompile other "primers" to add new streams and more complexity to the process. The process can be halted by recompiling a blank instrument 1. This type of interactive programming is something that goes hand-in-hand with the scoreless style discussed in this article.
## IV. Conclusion



 This article discussed a programming style that is well supported in Csound 6, but that has so far been not very widely used. Not only does it allow us to harness the power and expressivity of the Csound (orchestra) language, but it also induces approaches such as interactive programming, which can be used to modify running code on-the-fly. In a way, we have only scratched the surface in terms of possibilities enabled by this. However, the methods presented here should provide a good starting point for experimentation.

 The scoreless style has already been used by some composers, most notably by Iain McCurdy in his classic series of [Haiku](http://iainmccurdy.org/csoundhaiku.html)[[3]](https://csoundjournal.com/#ref3) works. It is hoped that this article will encourage others to explore the possibilities provided by the ideas presented here.
## References


[][1] Barry Vercoe, "A Beginning Tutorial."* *[Online] Available: [http://www.csounds.com/tootsother/vercoetut/Vercoe.html](http://www.csounds.com/tootsother/vercoetut/Vercoe.html). [Accessed October 14, 2014].

[][2] Andrew Sorenson, "The Many Faces of Temporal Recursion."* *[Online] Available: [http://extempore.moso.com.au/temporal_recursion.html](http://extempore.moso.com.au/temporal_recursion.html). [Accessed October 16, 2014].

[][3] Ian McCurdy, "Csound Haiku."* *[Online] Available: [http://iainmccurdy.org/csoundhaiku.html](http://iainmccurdy.org/csoundhaiku.html). [Accessed October 15, 2014].
