---
source: Csound Journal
issue: 19
title: "Csound synthesizers in muO"
author: "itself does nothing"
url: https://csoundjournal.com/issue19/csound_synthesizers_in_muO.html
---

# Csound synthesizers in muO

**Author:** itself does nothing
**Issue:** 19
**Source:** [Csound Journal](https://csoundjournal.com/issue19/csound_synthesizers_in_muO.html)

---

CSOUND JOURNAL[](https://csoundjournal.com/index.html) | [Issue 19](https://csoundjournal.com/index.html)
## Csound synthesizers in muO

### A bare bones introduction
 Stéphane Rollandin
 hepta AT zogotounga.net
## Introduction


MuO[[1]](https://csoundjournal.com/#ref1) (or muO, or μO) is a system for musical composition.

There are several ways to work with Csound in muO. In this paper `CsoundSynthesizers`, which are objects able to convert a `MusicalPhrase` into a Csound score, will be introduced.

A `MusicalPhrase` is basically a collection of notes, which are objects with a channel, a pitch, an amplitude, a pan position and a duration. Both pitch and amplitude can continuously change over a note duration.

It will be shown how to implement a `CsoundSynthesizer` from a given orchestra, and how to use it to play a `MusicalPhrase`, or compile it into an audio file, using only very simple Smalltalk commands.

The aim here is only to demonstrate how easy it is. The overall framework in muO/Surmulot[[2]](https://csoundjournal.com/#ref2) for MusicalPhrase composing, editing and interfacing with Csound is extremely rich and way out of the scope for this paper. Moreover, it is completely extendable and can be configured, modified and otherwise programmed in depth, all interactively. The very point of muO/Surmulot is to provide an environment for expressing one's own view of computer music; the downside is that it is a somewhat overwhelming system. Here we will stick to the bare bones of the subject, and some pointers will be provided for going further.
## I. Installing muO


MuO is implemented in Squeak Smalltalk[[3]](https://csoundjournal.com/#ref3), which is a programming environment running on top of a virtual machine. The virtual machine (the actual executable binary, or application) by itself does nothing, but when given what is called an image file, it wakes it up and gives life to the image. While that description my sound weird, it is an accurate description of what is actually happening.

For muO to run we need the Squeak executable (the virtual machine), and a specific Squeak image with muO in it, asleep and ready to wake up.
### Getting Squeak virtual machine and a muO image

- Download the ready-to-go muO archive from the muO homepage[[4]](https://csoundjournal.com/#ref4).
- Extract the archive contents.
  - On Windows, that is it.
  - On Linux, you will need to install the Squeak VM; in Ubuntu it is as simple as doing:
```csound
sudo apt-get install squeak-vm
```

  - On MacOSX, you will need to install the Squeak VM. You can get one at [http://www.squeakvm.org/mac/](http://www.squeakvm.org/mac/)
- Start muO:
  - On Windows, double-click the image file from the archive.
  - On Linux, use the following command:
```csound
squeak the-image-file-path
```

  - On MacOSX, double-click the Squeak.app. This will then ask you what image file to load. Navigate to the muO folder and choose the .image file.

You should see something like Figure1, below:  ![image](images/muO_0.png)

**Figure 1.** **MuO startup image. **
### Configuring the Squeak image


Out of the box, muO does not know if Csound is available, so its support is deactivated. We have to switch it on, and this will be the first Smalltalk expression we have to deal with.

To inform muO of the existence and location of Csound, we need to evaluate the expression:
```csound
MuO enableCsound: csound-binary-path withOptions: some-options.
```


A Windows example would be:
```csound
MuO enableCsound: 'C:/csound/bin/csound.exe' withOptions: '-d'.
```


A Linux example would be:
```csound
MuO enableCsound: '/usr/bin/csound' withOptions: '-d'.
```


An OSX example would be:
```csound
MuO enableCsound: '/usr/local/bin/csound' withOptions: '-d'.
```


How do we use the above? Let us proceed to part II.
## II. The bare bones

### A simple interaction


Squeak is a full-fledged programming language including its own IDE. It is a wild environment. To simplify, and so that you do not have to learn it, we will use a very primitive and simple form of interaction: the workspace.

Left-click in the background of the Squeak display, and select item "Workspace" from the menu that appears to see the Workspace shown below in Figure 2.  ![image](images/muO_1.png)

**Figure 2.** **MuO Workspace. **

 You are presented with a new window, appropriately titled "Workspace", where you can evaluate arbitrary Smalltalk code. To do so, type the code, select it with the mouse, and press alt-d or alt-p:
- *alt-d* means "do-it": it only evaluates the expression
- *alt-p* means "print-it": it evaluates the expression, plus it prints the result right after it, as selected text.

Note: On OSX, the commands are cmd-d and cmd-p, respectively.

Now is the time to type the expression from part I and evaluate it:
```csound
MuO enableCsound: *...the rest according to your system, as described above.*
```


To see if it worked, evaluate:
```csound
Csound playTest.
```


If you hear some tones, congratulations. The system is ready to go. If not, please check again all previous steps, as the rest of this paper will then remain very much theoretical.

At this stage you can save the Squeak image, by selecting the "save" item at the bottom of the menu you see by left-clicking in the background. Next time you start muO, it will restore this saved state, so there will be no need to configure it again.

That is what an image is, which is by the way, as far as dynamic systems such as Lisp or Smalltalk are concerned: a snapshot of the system memory.

What is coming next will not be any more complex than what we did so far. We will not program in Smalltalk (we will not implement new classes or methods), nor will we play with the many available GUI's (Graphical User Interfaces). We will simply evaluate expressions in a workspace.
### A few muO objects


Squeak is an object-oriented system; everything is an object. If this seems confusing, think about it as very specific data structures that can answer requests.

We will deal with very few types of objects: `MusicalPhrase`, `CsoundSynthesizer` and `CsoundScoreFormat`.

They are articulated as follows: we define a `CsoundSynthesizer` by giving it an orchestra (as a file or as a string containing its code) and a `CsoundScoreFormat`, which is an object describing the meaning of the p-fields for each intrument in the orchestra.

Once we have a `CsoundSynthesizer`, it can interpret any `MusicalPhrase` we give it, either by playing it or by compiling it to an audio file.
## III. A very simple synthesizer

### Using CsoundScoreFormat


A `CsoundScoreFormat` is an object responsible for translating the notes in a `MusicalPhrase` into a Csound score.

It is composed of multiple `CsoundScoreIFormat` objects, each one describing the p-fields of a specific instrument in the orchestra.

Let us start with a simple orchestra:
```csound

orc := 'sr = 44100
ksmps = 100
nchnls = 2
instr 97
  a1 wgflute p5*0dbfs*.5, p4, 0.25, 0.1, 0.1, p7*(0.5+rnd(1)), p6, 0.05, 1
  outs a1,a1
endin'.

```


It features the single instrument 97 which accepts the following p-fields: `p4` is the pitch in cps format, `p5` is the amplitude (ranging from 0 to 1), `p6` is the vibrato frequency, and `p7` the average noise gain.

We can define the corresponding `CsoundScoreFormat` as follows:
```csound
scoreFormat := CsoundScoreFormat new.
scoreI97Format := CsoundScoreIFormat new
                  instrument: 97;
                  pitchField: 4; pitchFormat: #cps;
                  ampField: 5; ampRange: (0.0 to: 1.0);
                  iTemplate: 'i 0 0 0 0 0 3 0.1'.
scoreFormat channel: 1 useIFormat: scoreI97Format.
```


I hope the above is self-explanatory. The sixth line provides a template for p-fields that do not have a counterpart in a musical note: it sets the vibrato to 3 and the noise gain to 0.1.

The last line tells that all notes in channel 1 will be mapped to instrument 97.

There is one thing missing however; instrument 97 needs a sine table for shaping the vibrato. We put it in the score header part:
```csound
scoreFormat header: 'f 1 0 16384 10 1'.
```


We can now define the synthesizer:
```csound
flute := CsoundSynthesizer orchestra: orc scoreFormat: scoreFormat.
```


Evaluate the preceding lines (select all of them, then alt-d), and that is it. The synthesizer is ready to play. Try a major arpeggio:
```csound
flute playPhrase: 'c4,e,g' kphrase.
```


Or try something more playful:
```csound
flute playPhrase: '/fractal/ c4::sus4' kphrase.
```


Elaborating on this, we can do:
```csound

flute playPhrase: '/end1.6;pp/ {/rit2.5;dis;cresc;legato;to/ {/fractal;end0.25/
c4::sus4},{/fractal;end0.2/ d4"::sus2},{/fractal/ c5."",d4^::h7}}@motif, {/revm/
@motif}' kphrase.

```
  ![image](images/muO_2.png)



**Figure 3.** **MuO Graphics Output. **    [Audio File: fractal.mp3](https://csoundjournal.com/muO/fractal.mp3)

**Audio File: ** **fractal.mp3. **
### Mapping multiple channels


The notes in a `MusicalPhrase` can belong to different channels. As we just saw how a channel is mapped to an instrument via a `CsoundScoreIFormat`. Multiple channels can be mapped to the same instrument. In this way it is possible to play the instrument with different i-statement templates, that is, different values for its exotic p-fields.

Let us have our synthesizer play notes in channel 2 with more noise:
```csound

noisy97 := scoreI97Format deepCopy.
noisy97 iTemplate: 'i 0 0 0 0 0 3 0.4'.
scoreFormat channel: 2 useIFormat: noisy97.
flute playPhrase: 'do4c1::min,do4c2' kphrase.

```


In the first line above we copy the `CsoundScoreIFormat` previously defined for channel 1. In the second line we change the template in the new `CsoundScoreIFormat` so that p7 is now 0.4 instead of 0.1. Finally, in the third line we associate it with channel 2.

The last line plays a D minor arpeggio first on channel 1, then on channel 2.
### Interacting with a CsoundSynthesizer


In order to play a phrase, a synthesizer first computes the corresponding CSD code, which it then passes over to Csound. It is also possible to just ask for the .csd. Evaluate the following line with a "print it" (select then use alt-p):
```csound
flute codePhrase: 'do4c1::min,do4c2' kphrase.
```


The string containing the .csd will be printed right after the cursor. You can then do a standard ctrl-x to copy it into the clipboard.

To compile the phrase to a sound file, evaluate the following code:
```csound
flute asyncCompilePhrase: 'do4c1::min,do4c2' kphrase asWAVFileNamed: 'test.wav'.
```


In this example the "test.wav" file will be written in the same directory as the Squeak image. (On OSX it is not the case: use a fully qualified file name instead).
## IV. A more comprehensive synthesizer


As stated earlier a musical note in muO can have a variable pitch, which is then described by a base pitch plus an envelope defining the pitch variation from the base in cents. We will now build a second synthesizer able to play such inflected notes. It is a simple oscillator to which I have added reverb in order to demonstrate the handling of effects (more about this below).

Below is the orchestra:
```csound
orc2 := '
  sr	    =  44100
  kr	    =  4410
  ksmps	    =  10
  nchnls    =  2

instr 1 ;; basic oscillator
  kamp	    =  p6
  ifn	    =  1
  gamixL    init      0
  gamixR    init      0

  kcps      =  p4
if p5=0 goto noPitchBend
  kndx      line      0, p3, 1
  kpbend    table     kndx, p5, 1
  kcps      =  p4*cent(kpbend)
noPitchBend:

  a1	    poscil    kamp, kcps, ifn
  kdclk	linseg 0,0.01,1,p3-0.02,1,0.01,0
  gamixL    =  a1*kdclk
  gamixR    =  a1*kdclk
endin

    instr 100 ;; reverb
  gkmix     =  .3
            denorm    gamixL, gamixR
  arvbL, arvbR freeverb   gamixL, gamixR, .05, .05 , sr
  amixL     ntrpol    gamixL, arvbL, gkmix
  amixR     ntrpol    gamixR, arvbR, gkmix
            outs      amixL, amixR
  gamixL    =  0
  gamixR    =  0
    endin'.

```


Let us write the code for the corresponding synthesizer. You may want to do this in a second workspace:
```csound

oscilScoreFormat := CsoundScoreFormat new.
oscilScoreFormat header: 'f 1 0 16384 10 1'.

```


So far so good, this is the same as what we did before; we create a new `CsoundScoreFormat` and we give it a header defining the table required by the orchestra.
### Effect instruments


In this orchestra we have an instrument that has to be active over the duration of the piece. This is an "effect" as far as `CsoundScoreFormat` is concerned. It is registered as an instrument reference that will be called in the score for the piece duration plus a tail value.

In our example, we will have instrument 100 play until 2 seconds after the last note is done:
```csound

oscilScoreFormat addEffectInstrument: 100 tailDuration: 2.

```

### Pitch inflexion


A musical note with pitch inflexion takes two p-fields in the score. The first one is the same as before, with the base pitch in cps format. The second one will hold a table number; the corresponding table will be written in the score along with the i-statement for the note. This table describes the continous pitch variation, in cents, from the base pitch.

Let us discuss the code for the `CsoundScoreIFormat` for intrument 1, the oscillator.
```csound

i1Format := CsoundScoreIFormat new
        instrument: 1; pitchField: 4; pitchFormat: #cps;
        ampField: 6; ampRange: (0.0 to: 20000.0);
        pitchInflexionField: 5.
oscilScoreFormat channel: 1 useIFormat: i1Format.

```


The code above is very similar to the previous code for the flute, but a new parameter, *pitchInflexionField*, for the table number p-field (here it is `p5`) has been included.

If you look in the orchestra code, you can see how the pitch is computed by the instrument:
```csound

  kcps      =  p4
if p5=0 goto noPitchBend
  kndx      line      0, p3, 1
  kpbend    table     kndx, p5, 1
  kcps      =  p4*cent(kpbend)
noPitchBend:

```


If `p5` is zero, the pitch is constant and there is nothing to do. Otherwise, it is a table number so we use it to correct the base pitch in `p4`.

Now we just have to create our `CsoundSynthesizer`.
```csound
poscil := CsoundSynthesizer orchestra: orc2 scoreFormat: oscilScoreFormat.
```


Let us try it on a plain phrase with plain, non-inflected notes:
```csound
poscil playPhrase: '/fractal;rit/ g.::h7' kphrase.
```


And now let us try the previous phrase transformed into a single, inflected note:
```csound
poscil playPhrase: '{/fractal;rit;stacc/ g.::h7}~' kphrase.
```


Here is a wandering single inflected note:
```csound
poscil playPhrase: '/scale3;st-10/ {/revm/ {/fractal;dots/ co5&,d!,e&&} {/r2;stacc;delay0.1/ do4::sus9}}~' kphrase.

```
    [Audio File: inflected.mp3](https://csoundjournal.com/muO/inflected.mp3)

**Audio File: ** **inflected.mp3. **
## V. Examples of musical phrases


The point of this article is to show how easy it is to interpret musical phrases with Csound.

Why is that interesting ? Because muO provides a wide variety of ways to create musical phrases, so that working on a `MusicalPhrase` is a fine way to compose part or all of a Csound score.

In this section I will introduce different manners to create musical phrases. I developed these examples incrementally, tweaking and evaluating each expression in the workspace until it was somewhat musical.

I will not go into any technical detail, as this would be too long. The point is to give you an idea of what is possible. See the "Further Information" section below for more in-depth documentation.
### Tonality


Some western music theory is implemented in muO. It knows about modes, scales and chords which makes it easy to instantiate musical phrases. (Note that when interpreting the code below, you may have to confirm that E4 is indeed what you want. This is just the workspace warning that it does not know that particular method name. We will not discuss this here).
```csound
flute playPhrase: ((Mode E harmonicMinor asMusicalPhrase, (Mode E lydian I: #sus4) arpeggiate, (Mode E lydian IV: #h7) arpeggiate, Mode E4 pelog asMusicalPhrase reverse) scale: 0.5).
```
    [Audio File: tonal.mp3](https://csoundjournal.com/muO/tonal.mp3)

**Audio File: ** **tonal.mp3. **
### Just intonation


Microtonality and just intonation are straighforward. A pitch can be described as a plain frequency, and ratios or interval names can define subsequent tones.
```csound
flute playPhrase: 'h240,(JP5)^,(JP4)""&,(7/4)!,(5/4)^^!,(4/7)"&&.' kphrase.
```
    [Audio File: ji.mp3](https://csoundjournal.com/muO/ji.mp3)

**Audio File: ** **ji.mp3. **
### Mixing algebra


Musical phrases can be combined via different operators, all based on a consistent underlying algebra.
```csound

motif1 := 'M[E mixolydian] 1"",3"!!,2^&' kphrase.
motif2 := 'M[E minor] 1"",3!^,4&&' kphrase.
flute playPhrase: motif1,motif2,(motif1,,,motif2),(motif1&motif2),
(motif2|motif1),(motif1//motif2),((motif1&motif2)&(motif1//motif2)),motif2.

```
    [Audio File: mix.mp3](https://csoundjournal.com/muO/mix.mp3)

**Audio File: ** **mix.mp3. **
### 13TET serialism


In the code below, the musical phrase is composed in Smalltalk by evaluating a generator block.
```csound

sig := #(4 4) sig bpm: 80.
mode := Mode ET: 13.
phraseBlock := [| dgen vgen series |
      dgen := #(quarter quarter sixteenth eighth eighth eighth) shuffled generator.
      vgen := #(p p mp mp mf f) shuffled generator.
      series := #(1 2 3 5 8 10) shuffled.
      MusicalPhrase newAppendNotes: (series collect: [:i |
      ((mode noteAt: i) length: (sig perform: dgen next)) perform: vgen next])].
```


You will get a different result everytime you run the following code:
```csound
flute playPhrase: phraseBlock value, phraseBlock value, phraseBlock value.
```
    [Audio File: serial.mp3](https://csoundjournal.com/muO/serial.mp3)

**Audio File: ** **serial.mp3. **
### Curve-shaped melody


Mathematical functions can be used to directly draw a melody on a rhythmic and harmonic base. This can be done graphically as well as interactively in muO, and in the code below we do it programmatically.
```csound

curve := (NFunction x sqrt fractionPart * 20).
signature := #(1 (3 8) 2 ((1 -1) 16) 1 (2 8) 1 (1 4)) sig repeat: 8.
mode := Mode E harmonicMinor.
phrase := MusicalPhrase streamContents: [:str |
    signature on: #nonVoidBeats do: [:b | | cv |
        cv := (curve valueAt: b time) floor.
        str nextPut:
            (((mode noteAt: cv) syncWith: b) midiVolume: cv * 2 + 50)]].
flute playPhrase: (phrase disturb at0 endNoteLength: 1.3).
```
    [Audio File: curve.mp3](https://csoundjournal.com/muO/curve.mp3)

**Audio File: ** **curve.mp3. **
### Random surgery


It is easy to access the notes in a phrase. Here we just delete some of them.
```csound

phrase := Mode A4 yoScale asMusicalPhrase repeat: 10.
25 timesRepeat: [phrase removeANote].
phrase := ((phrase staccato: 0.9) at0 pp scaleToDuration: 8) endNoteLength: 1.3 .
flute playPhrase: phrase accelerando moltoCrescendo.

```
    [Audio File: surgery.mp3](https://csoundjournal.com/muO/surgery.mp3)

**Audio File: ** **surgery.mp3. **
### Data mining


In the code below, we search for specific melodic contours in a musical phrase and convert them into inflected notes.
```csound

mode := Mode D iwato.
phrase := MusicalPhrase newAppendNotes:
  ((1 to: 50) collect: [:n | mode noteAt: 10 atRandom]).
phrase inflectMotives: [:m | m hasParsonsCode: '*UDU']
  style: #meend articulation: 0.1 .
phrase inflectMotives: [:m | m hasParsonsCode: '*UD']
  style: #circular articulation: 0.6 .
poscil playPhrase: (phrase endNoteLength: 2).

```
    [Audio File: data.mp3](https://csoundjournal.com/muO/data.mp3)

**Audio File: ** **data.mp3. **
### Traditional Irish music


One can implement any musical representation on top of muO; for example an extensible ABC parser is available out of the box, as shown in the code below.
```csound

abc := ABCParser read:
'X:1
T:Denis Doody''s
C:Traditional
Z:Gordon Turnbull, Edinburgh
Z:gturnbull@theflow.org.uk
Z:http://www.theflow.org.uk
R:Polka
M:2/4
L:1/8
K:D
D>E FA | d3 c | B>A Bc | BA FA |\
D>E FA | d3 c | BA B/c/d | ed d2 :||
fA eA | dA cA | B>A Bc | BA FA |\
fA eA | dA cA | B>A B/c/d | ed d2 |
fA eA | dA cA | B>A Bc | BA FA |\
D>E FA | d3 c | BA B/c/d | ed d2 ||'.

flute playPhrase: abc tune asMusicalPhrase.

```
    [Audio File: abc.mp3](https://csoundjournal.com/muO/abc.mp3)

**Audio File: ** **abc.mp3. **
## References


[][1] Stéphane Rollandin, "musical objects for squeak." [Online] Available: [http://www.zogotounga.net/comp/squeak/sqgeo.htm.](http://www.zogotounga.net/comp/squeak/sqgeo.htm)[Accessed January 22, 2014].

[][2] Stéphane Rollandin, "Surmulot: open software for music composition." [Online] Available: [http://www.zogotounga.net/surmulot/surmulot.html.](http://www.zogotounga.net/surmulot/surmulot.html) [Accessed January 22, 2014].

[][3] Dan Ingalls, Alan Kay, Ted Kaehler, and Scott Wallace, "Squeak." [Online] Available: [http://www.squeak.org/.](http://www.squeak.org/) [Accessed January 22, 2014].

[][4] Stéphane Rollandin, "muO archive." [Online] Available: [http://www.zogotounga.net/comp/squeak/muo/muO290.zip.](http://www.zogotounga.net/comp/squeak/muo/muO290.zip) [Accessed January 22, 2014].

[][5] Stéphane Rollandin, "Csound-x for Emacs." [Online] Available: [http://www.zogotounga.net/comp/csoundx.html.](http://www.zogotounga.net/comp/csoundx.html) [Accessed January 22, 2014].
## Further Information

### Reference documentation for muO


Several reference papers are available in PDF format:
-  "[High-level Musical Concepts in μO](http://www.zogotounga.net/surmulot/High-level%20Musical%20Concepts%20in%20muO.pdf)" describes in detail how a short piece for piano has been written; this paper is intended to give the reader a taste of what it's like to compose in muO.
-  "[The String Representation of Musical Phrases in μO](http://www.zogotounga.net/surmulot/String%20representation%20of%20musical%20phrases%20in%20muO.pdf)" is a must-read if you want to build upon what we saw in this paper. It details the format for writing musical phrases via string expressions, which is what we did in parts III and IV. The string format is actually an extensible domain-specific language closely linked to some methods implemented by specific Smalltalk classes such as `MusicalPhrase`.
- "[The Mixing Algebra of Musical Elements in μO](http://www.zogotounga.net/surmulot/The%20Mixing%20Algebra%20of%20Musical%20Elements%20in%20muO.pdf)" describes the fundamental paradigm used in muO for mixing different musical elements; it notably describes the operators we have seen in part IV.
-  "[Modes and Scales in μO](http://www.zogotounga.net/surmulot/Modes%20and%20Scales%20in%20muO.pdf)" discusses the implementation and usage of musical scales in muO.
-  "[The Representation of Rhythmic Structures in μO](http://www.zogotounga.net/surmulot/The%20Representation%20of%20Rhythmic%20Structures%20in%20muO.pdf)" describes how rhythmic matters are dealt with in muO.
### Surmulot


MuO is part of a larger system for musical composition called Surmulot, which includes Csound-X for Emacs[[5]](https://csoundjournal.com/#ref5).

The "[Surmulot overview](http://www.zogotounga.net/surmulot/Surmulot%20overview.pdf)" PDF describes the overall architecture of this system.
```
