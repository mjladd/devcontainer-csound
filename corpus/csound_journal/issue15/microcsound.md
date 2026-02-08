---
source: Csound Journal
issue: 15
title: "Microcsound"
author: "hand in the standard Csound score format"
url: https://csoundjournal.com/issue15/microcsound.html
---

# Microcsound

**Author:** hand in the standard Csound score format
**Issue:** 15
**Source:** [Csound Journal](https://csoundjournal.com/issue15/microcsound.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 15](https://csoundjournal.com/index.html)
## Microcsound

### a plain-text score language and interactive real-time Csound front-end for microtonalists (and others)
 Aaron Krister Johnson
 aaron AT akjmusic.com
## Introduction


*Microcsound* is a command-line tool that serves as a general purpose Csound score-generation front-end, as well as a real-time interactive performance shell. It started life as an early ASCII-notation to MIDI parser/compiler called *et_compose*, which later became *micro_composer*. I finally decided to take MIDI out of the picture and focus on Csound-centric functionality; hence the latest evolutionary branch being called Microcsound.

Microcsound was developed to ease the pain of writing contrapuntal and harmonic music by hand in the standard Csound score format, where each event follows the next in a non-musician friendly vertical page fashion. The standard Csound score format makes the confluence of different musical layers difficult to parse, since most most musicians read layers of music within a score with time laid out horizontally across the page rather than vertically. The solution is a front-end which would translate these more intuitively seen, horizontal text layers, called a *Microcsound score*, into the SCO format that Csound works with, bridging a communication gap between human composer and computer friendly formats.

Microcsound is used in four modes from the command line:
- translate a user-given Microcsound score file and output Csound score text to screen
-  translate a user-given Microcsound score file and call Csound to render a WAV file
- translate a user-given Microcsound score file and call Csound to render in real-time (provided the instruments are not too complex for real-time rendering for the processor)
- use as an interactive shell which interprets Microcsound score events in a read-eval-output type loop, calling Csound between reads to render in realtime

A special feature of Microcsound that is particularly useful for microtonalists (which explains the name of the script) is that one can represent just intonation in ratio notation, as well as having two modes of symbolic notation to express any arbitrary equal division of the octave (or even non-octave). Possible uses of this feature include generating fully realized microtonal or justly-intoned musical works, creating test tones for guide tracks of acoustic instruments, demonstrating principles of musical tuning in a straightforward way using a friendly syntax, experimenting with flexibly tuned sonorities and auditioning microtonal intervals and chords, and tuning a real-world acoustic instrument to an alternate tuning. (The author has done precisely this with his kalimbas).

Since Microcsound is simply a Python script designed to function in a command-line environment and avoids a GUI, it might appeal to those who like lean shell environments to work from without the overhead of a GUI, or even to those who would just want a clean and simple way to do their Csound work. Also, using Microcsound's interactive shell mode is a quick, convenient and easy to understand a way of auditioning any arbitrary microtonal sonority, one which transcends the limitations of more traditional ways such as setting up and retuning standard MIDI software synthesizers. This is true for those who do not have or are not interested in generalized keyboard setups for microtonal experiments and composition, and for whom dragging and dropping operations slow down their flow. Nevertheless, for those who want the features of a full GUI front-end environment, Microcsound can be adapted (as hinted to me by Csound guru Steven Yi) in the future to integrate with Yi's *blue* composition environment, giving users both GUI and quick non-GUI advantages simultaneously.

 For composers who want to script algorithmic compositions,�Microcsound's syntax should make it easy to do so. With modest programming experience, it is fairly trivial to implement any number of designs that output valid Microcsound score. The author has experimented along such lines many times using the Python language.


## I. Basics of use

### Downloading and Installing


Microcsound is available at [http://www.untwelve.org/microcsound](http://www.untwelve.org/microcsound). There is a choice between a gzipped-tarball (.tgz) for use with Linux or OSX, and a ZIP (.zip) file for use with Windows. The Linux version is the primary version developed by the author; the ZIP version has small changes to the source code to conform to the Windows system. Mac users should use the Linux version, since they will share a very similar Unix-type base code. Anyone with questions, suggestions, comments, or needs help with installation can contact the author for further assistance.

After uncompressing the chosen archive file, Linux and OSX users must edit the `microcsoundYYYYMMDD.py` script to set some system variables. You will need to edit the values of `orc_dir` and possibly some other variables towards the top of the script between where it says "EDIT DEFAULTS HERE" and "END USER EDITING". Microcsound, among other things, needs to know where to find Csound orchestras and whether or not to use the supplied `microcsound.orc`. In addition, you may set command-line settings when calling Csound from Microcsound (i.e what buffer settings you would typically use, etc.).

On the Linux version, after editing the values in the Microcsound script itself, you can try the `install.py` script by typing the following at the command-line prompt:
```csound
./install.py
```


This script will ask some questions interactively. (You may find that the script's defaults do not work well for your setup and that it needs editing to reflect variables and assumptions true for your operating system and file-system.) Once answered, these questions serve to fill in certain install variables. The script will then install Microcsound and some optional files based on the data provided.

Windows users should use the `microcsoundYYYYMMDD_windows.py` script. Windows version users will still have to edit the defaults at the top of the file in the same fashion as mentioned for the Linux version above, but there are slight differences that make it easier for you: there are no references to the readline library, which does not exist in Windows, and the temporary directory is named `"/temp"` instead of the Linux version's `"/tmp`".

Supplied with the program is a starter Csound orchestra `microcsound.orc` that allows you to get up and running with some decent-sounding instruments right away. The script also serves to show some stepping off points for exploring your own instrument designs. It is beyond the scope of this article to fully explain each instrument in the supplied orchestra. The orchestra code is reasonably well commented, and anyone familiar with the basics of Csound orchestra files and instrument design should be ready to grasp what is immediately available for use with Microcsound.
### Invoking the program


Using the program involves invoking the Microcsound script from a command line shell—typically, a BASH terminal in Linux or Mac, or a CMD shell in Windows. As mentioned there are four modes of operation: score-only render, WAV render, real-time render, and interactive. You can get some helpful usage information by typing `microcsound -h` at the prompt:
```csound
akj@myhost:~$ microcsound -h
Usage: microcsound [options] [input_file.mc]
This is microcsound version 20110407
Options:
-h, --help            show this help message and exit
-o OUTPUT_WAVE_FILE, --output=OUTPUT_WAVE_FILE
optional wave file output name
-s, --score-only      only generate a score to stdout, do not post-process
it with csound
-r, --real-time        render audio in real-time
-i, --interactive     use an interactive prompt, render audio in real-time as
well, does not work when -s is also specified
-t, --stdin           read text from stdin
-v, --debug           turn on debug mode
--orc=ORC_FILE        specify an orchestra file for csound to use, which is
                      not the default (microcsound.orc)
```


The options are somewhat self-explanatory, but I will clarify: the normal mode of operation is to invoke Microcsound followed by the name of a given `.mc` file, a text file that contains Microcsound score. Microcsound will take the `.mc` file, generates a temporary Csound .SCO file, and then run Csound with the .SCO file with the default or designated Csound .ORC file. The output will be saved as a WAV file in the the current directory, using the same pre-extension basename of the `.mc` file, but replacing `.mc` with `.wav`. For example, running `"microcsound mypiece.mc"` will produce a WAV file called `mypiece.wav` in the same directory as where the Microcsound script is called. To do the same thing, but hearing the audio from your soundcard rather than saved to a wave file, use the `-r` switch (real-time), e.g. `"microcsound -r mypiece.mc"`. If the variables at the top of the Microcsound script are correctly configured for the setup of your system, the result will be a real-time performance of your `.mc` file.

If you would rather see the Csound score yourself and not have Microcsound do the final compilation to audio, use the `-s` switch. This will print the generated Csound score to the screen. On Linux/Unix, you can then capture this output to a file using a pipe redirect, e.g. `"microcsound -s mypiece.mc > mypiece.sco"`. You can then compile the captured .SCO file yourself with Csound, using an orchestra of your choice, e.g. `"csound myorc.orc mypiece.sco"` along with whatever Csound options you want. This is useful if you need to further process a score in ways other than Microcsound provides, or to debug the output of Microcsound itself if you are running into difficulties.

The use of the interactive shell by invoking `"microcsound -i`" deserves special mention. The only difference between this and the standard syntax for Microcsound scores is that the prompt needs to know when to stop expecting input and to actually process your commands into real-time audio. This is done by typing "`done`" and hitting ENTER or RETURN at the prompt as soon as all the musical information has already been entered. You will see then the Csound command being called from within the shell, and start realizing the performance. Some examples that follow the explanation of Microcsound syntax will suffice to get you up to speed in understanding how this works.
### Understanding the syntax of Microcsound


Microcsound scores are comprised of *voices*. These are best thought of as layers of a texture, similar to the idea of a *channel* in one of the 16 channels of MIDI. Everything that happens in Microcsound happens in the context of a voice, including setting up variables (such as tempo) and mixer values. (Note: All variables in Microcsound are somewhat global in their scope. If a voice does not explicitly set a variable, it will use the value that was previously set the previous voice, i.e. voice 2 will use the values of voice 1 unless set explicitly.) A good practice is to use voice 1 to set up variables that all other voices will share. One exception, however, is the case of setting tempo. If you need to implement a gradual tempo change between note events, it might be best to use whatever voice of the texture that has the fastest-moving rhythmic values to put your `t=` tempo settings.

The beginning of every line in a Microcsound score has a *voice indicator*. This is simply the integer number of the voice (1 or greater) followed by a colon then a space, for example:
```csound
1: div=31 i=1 c d e f g
```


This line begins with a voice indicator for voice 1 (indicated by "1: "), then indicates to use a 31-edo (equal division of the octave) scale and perform with Csound instrument 1 a single 5-note scale.

Multiple simultaneous voices are indicated by using a new higher number. The Microcsound rendering engine scans the file, looking for the first "1: ", merges all events that fall under this voice, interprets them and generates the Csound score. After reaching the end of the last event in that voice, the engine starts over with the next highest number, "2: ". You can skip voice numbers and for example next use "3: ", as Microcsound will always count in order and will simply skip voice numbers it does not find. Once it finds the next voice, the clock is reset to time "0", and it will interpret all of the events for the next voice and generate the Csound score. After the final voice is interpreted, all the voices are sorted and written to a temporary Csound score, which is then compiled with the appropriate orchestra of instruments to either produce a WAV file output, real-time audio output, or a Csound score for further processing elsewhere.

There are 4 types of commands or syntactical elements in the Microcsound language that can happen in any voice: comments, variable setting commands, events, and time-stamp manipulations.

**1. Comments** are simply lines which begin with '`#`'. Comments are ignored by Microcsound and can contain any information that helps the composer. Comments end when a carriage return or newline of text is found. For example:
```csound
#This is an EXAMPLE of a Microcsound comment
```


In addition to comments, a bar line (indicated by "|", the pipe character) is also ignored:
```csound
1: div=31 i=6 "0.02%0.02%4%0.5" 1/8 c2 de f2 1/12 gab | 1/8 c'2 g2 e2 g2 | c4 z4 ||
```


Composers may find it useful to use barlines to visually group parts of their music into measures for ease of human-readability.

**2. Variables** are important in setting up parameters for your performance. There are two types of variables: *set* variables that are defined with `x=y` syntax and those that use a special syntax. Variables that use the `x=y` syntax include include:   Variable Description  ttempo divdivision of the octave to use for microtones iCsound instrument number panstereo panning mixinstrument volume in the mix gvGaussian (random distribution) variance of volume grGaussian (random distribution) variance of rhythm gsstoccato articulation

Setting these variables is simple: in the Microcsound score, surround the left and right of the statement with white space, and write `variable=value`, for instance:
```csound
1: i=1 t=110 div=31 pan=0.4 gv=0.01
```


declares that voice 1 will use instrument 1, set the tempo (globally for all voices, since that is the nature of tempo) to 110 BPM, set the octave to be divided into 31 equal pitches, sets the instrument just left of center (pan is 0-1, hard left to hard right), and declares that we want a little randomness in the attack volumes, the effect of which varies according to the design of the instrument.

Variables that use special syntax are: *default running rhythmic values* (8th notes, quarter notes, etc.), *attack volume defaults*, and *extra p-field variables*.

*Default rhythmic values* are indicated by typing a fraction surrounded by white space. For example, typing `1/8` will indicate that the next events are running 8th notes. Typing any numerator and denominator works, so rather complex rhythmic structures are at your disposal. However, Microcsound will not keep track for you how things line up if you get crazy with this--it is your job to do the math and not get lost! Typing `7/15` is perfectly legal for your Nancarrow-esque experiments in tied groups of 7 15th notes, but take care that you know where you will end up with regard to other voices, if this is a concern.

*Attack values* are indicated by `@` immediately followed by a floating-point number between zero and one, e.g. `@0.6` or just `@.6`. There are ways to crescendo and decrescendo using ramps, but this will be discussed later in this article.

Finally, it should be explained that an instrument's *extra p-field variables* (p8 and above) can also be accessed from within Microcsound using a special syntax. P-fields 1-7 are reserved by Microcsound for instrument, onset, duration, attack, pitch, pan, and mix values. The rest of an instrument's p-fields, if they exist at all, must be set using a double quote statement with the values separated by a "%" character, e.g. I might have a classic ADSR envelope values being set with pfields 8-11, and would use "0.02%3.7%0.01%0.4". Once an extra p-field variable is set, it remains in use until set by another value or a ramp is found("<"). Currently, all of the extra p-fields must be set at once, and individual extra p-fields may not be accessed individually for manipulation. Fortunately, none of my work has ever needed such a feature, but it may be crucial for others, so it is a planned TODO in a future version.

Expanding on our previous example, we can add some new set variables:
```csound
1: i=1 t=110 div=31 pan=0.4 gv=0.01 1/8 @0.67 "0.02%3.6%0%0.3"
```


The above statement, in addition to what was already explained, sets the default running rhythmic value to an 8th note, the default attack to 0.67, and sets a hypothetical set of p-fields 8-11 (such as values for an ADSR envelope) in instrument 1 (remember, the 'i=1' statement earlier) to 0.02, 3.6, 0 and 0.3.

**3. Events ** are the heart of Microcsound and consist of *notes, chords, rests, *and* triggers*. When working with equal divisions of the octave (or non-octave, for that matter), notes can be indicated freely by an `octave.degree` syntax, or a standard diatonic-letter syntax closely akin but not freely interchangeable to the ABC standard. These two standards, numeric or diatonic-letter, can be mixed and matched, but it is probably best to stick with one or the other to avoid confusion.

When working with just intonation, one simply uses a `N:D` notation scheme, where N and D are integers, regardless of the value of the `div` variable, which is ignored for all `N:D` events.

*Notes* are explained below in the subsections according to the 3 styles one may indicate them. After every note event, the clock is advanced by the currently set rhythmic length (indicated by a fraction, 1/8 being the default) multiplied by the optional length or tie indicators attached to any given note event.

*Chords* are really best understood as a way of stopping the default advancement of the clock by the use of brackets. This allows an accumulation of sonorities that would otherwise follow one another in time to happen simultaneously, which we commonly understand as a chord. A opening bracket, "[" stops the clock, while a closing bracket "]" starts it again. Thus, a C-major chord is indicated: [ceg], or with optional spaces: [c e g]

*Rests* are simply indicated by `r` or `z` followed immediately (without white space, that is) by an optional integer multiplier.

*Triggers* are special cases where one sets `div=0`. When triggers are used, Microcsound will generate Csound notes without pitch information, instead passing on the designated values as p5 in the generated notes. This is useful when you want to simply turn on a mixer with a dummy p5 variable (as is the case in the provided `microcsound.orc` mixer instrument), use a percussion-based instrument as a drum set, trigger a MIDI note number in a special instrument, etc. A typical way to use drum tracks from Microcsound would be to set `div=0` and have a helper percussion instrument function as a virtual drum set, where the p5 values are sent to trigger a given percussive instrument. See the code for instrument 120 in the `microcsound.orc` file for an example of how this is done.

*4. Time-stamp manipulations* involve being able to set, or reset, the beat number that Microcsound is currently on. More is explained on this in the subsection below "Using the time pointer for one-off counterpoint".
### Note-event syntax within Microcsound and choosing the right one for the job


Explaining the various note syntaxes is important, as this is the heart of using Microcsound for musical work. Here we will expound the various ways of symbolically representing pitch available to you when using Microcsound.
#### i. Traditional diatonic letters


Perhaps simplest from the traditional point-of-view is the use of standard diatonic-letter notation. The format for such an event is:
```csound
[articulation][accidental(s)]note_letter[octave][length][dash4tie][possible_legato_closer]
```


where anything in brackets is optional (only the note base letter, a-g is absolutely required). The optional parts of a note's parameters occur in the above order.
- Articulation can either be "`.`" for staccato or "`(`" to start a legato phrase. Staccato must be indicated for every note where staccato is wanted, and staccato status will not hold for followup notes. However, legato, indicated by "`(`" will start a phrase grouping where the duration will be converted to negative values in the actual Csound score, for use by legato instruments. It is beyond the scope of this article to explain how to use or design legato instruments in Csound, but I refer the reader to two excellent articles: one in the Csound book[[1]](https://csoundjournal.com/#ref2), the other in the Csound Journal[[2]](https://csoundjournal.com/#ref3).

- Accidentals are as per below:
  - = is a natural
  - ^ is a sharp
  - _ is a flat
  - __ is a double flat
  - ^^ is a double sharp
  - ^/2 is a half-sharp
  - _/2 is a half-flat (for quarter-tone manipulations, results vary depending on the setting of `div`)

In addition, there are microtonal accidentals that can additionally modify the pitch:
- / is up a syntonic (81/80) comma
- \ is down a syntonic (81/80) comma
- > is up a septimal (64/63) comma
- < is down a septimal (64/63) comma
- ! is up an undecimal (33/32) comma
- ¡ is down an undecimal (33/32) comma (upside down exclamation point)
- ? is up a tridecimal (1053/1024) comma
- ¿ is down a tridecimal (1053/1024) comma (upside down question mark)

The above modifiers are an alternative way to compose in (quasi-) just intonation besides the use of rational notation, which will be explained later, provided that one uses an appropriate `div` with high enough frequency resolution, or a medium sized EDO (equal division of the octave) number that well-represents the just intonation ratios one is interested in. For instance, the author has composed little works in virtual 7-limit just intonation using Microcsound by setting `div=171`, because 171-edo contains excellent approximations to all just intervals with prime factors of 7 and under.
- notes are simply the diatonic note letters, in lower case, a-g. (e.g. 'a' or 'g')
- the octave is present when the note in question needs to be outside the middle C octave. Commas are used for pitches below that octave, and apostrophes are used for above. So for example, a 5-octave span of different C pitches might be, from bottom to top: `c,, c, c c' c''`
- the length of the note, rhythmically speaking, may be modified by a use of an integer immediately appended to it without white space, and this value is multiplied by the running rhythmic length to produce the final note length, e.g. `^g''4` would mean "g-sharp two octaves above middle-g held for 4 counts of the current running value"
- a tie to the next pitch is indicated by a dash, e.g. `_g3-_g2` would be a g-flat held for 5 counts total
- an optional closing parenthesis indicates the end of a legato phrase, e.g. (cdef) (gabc') would indicate two legato phrases of 4 notes each.

Further examples are given within the next section, with comparison to Numerical syntax; in addition, you can refer to the larger [score example](https://csoundjournal.com/#microcsoundExample) at that end of this article.
### ii. Numerical syntax


Numerical syntax is simpler from a certain point of view: all pitches are numerals. Middle-C is given the number 0, and the behavior of all other numbers is dependent on how the `div` variable is set and whether the octave has been set by previous "`oct.deg`" events. Numbers lower than middle-C are negative, e.g. -7, and optionally, one may use an "`[oct.]deg`" syntax that is also fairly simple: one indicates a pitch with a number (positive or negative), preceded by an optional octave plus decimal point (middle C is octave number 5).

In more formal terms, this syntax is:
```csound
[articulation][octave]deg[optional legato end][ties, using 't', spaces allowed]
```

- Similar to diatonic notation, we have "`.`" for staccato or "`(`" for legato, otherwise non-legato is default.
- The `octave` is optional, and is an integer showing which C to C octave the pitch should sound at, middle-C starting octave number 5.
- `deg` is the only mandatory indicator in numeric syntax; it indicates which degree of an EDO scale should sound, 0 being middle-C. The value can be negative, indicating a scale degree below middle-C. This parameter can be un-interpreted as an EDO pitch as need be by setting `div=0`; as mentioned, this is useful for things like setting mixer levels, triggering MIDI notes in special instruments, etc.
- The optional legato ending mark, "`)`", unlike in diatonic notation, must come next, before any tied length modifiers. In future versions of Microcsound, this may not be necessary, but for now, this syntax greatly simplifies the underlying work the software has to do.
- Finally, one can extend the number of beats in a given note by writing any number of "`t`" characters, with or without spaces between them. Think of this as a way to extend the note length analogous to making the rectangle bigger in piano-roll type sequencer software. Each "`t`" character extends the previous note by one (current default) beat. For example "`5 t t t`" is a note event on the fifth degree of the tuning and of 4 beats length total since there are three "`t`" characters following the original note.

Putting it all together with examples, here is a simple C-major scale in different syntax standards (notice the occasional use of staccato and legato articulation:

Standard diatonic-letter syntax:
```csound
1: i=1 t=110 div=31 pan=0.4 gv=0.01 1/8 @0.67 "0.02%3.6%0%0.3"
1: c d .e .f .g a b (c' d' e' f' g' a' b' c'')t t t
```


or numerical syntax:
```csound
1: i=1 t=110 div=31 pan=0.4 gv=0.01 1/8 @0.67 "0.02%3.6%0%0.3"
1: 0 5 .10 .13 .18 23 28 (31 36 41 44 49 54 59 62)t t t
```


or numerical syntax w/use of `oct.deg` helpers:
```csound
1: i=1 t=110 div=31 pan=0.4 gv=0.01 1/8 @0.67 "0.02%3.6%0%0.3"
1: div=31 5.0 5 10 13 18 23 28 (6.0 5 10 13 18 23 28 7.0)t t t
```


Taking out the now-understood first line, which sets up variables, and just illustrating now the note-events, coming down from middle C, we could do:
```csound
1: c b, a, g, f, e, d, c, b,, a,, g,, f,, e,, d,, c,,,
```


or
```csound
1: 0 -3 -8 -13 -18 -21 -26 -31 -34 -39 -44 -49 -52 -57 -62
```


or
```csound
1: 5.0 4.28 23 18 13 10 5 0 3.28 23 18 13 10 5 0
```


Notice that the octave before the decimal point, once set, becomes optional, until we want to switch to a different octave.
###  iii. Rational notation


Rational notation allows the user to compose and experiment with just intonation and rational intonation quite easily. The syntax is similar to numerical notation in its ordering, except that one doesn't have octave decimals: to get above or below the middle-C octave, you multiply the first number (the *numerator*) of a given ratio by a power of 2 (2, 4, 8, 16....) to get a higher octave, or do the same to the 2nd number (the *denominator*) to get a pitch from a lower octave. For instance, middle-C is `1:1`, so c' above middle-C is `2:1` and the octave below middle-C is `1:2`.

The syntax, more formally, is:
```csound
[articulation]N:D[legato end][ties]
```

- Again, articulation can be "`.`" for staccato and "`(`" for legato start.
- N:D indicates a frequency ratio to middle-C, which is assumed to be 1:1. To change to a different pitch to use as 1:1, one can use a special variable called the *key* variable. One can set the reference tone to 2:3 (exactly a perfect 4th below middle-C) by issuing the command `key=2:3` right before writing any more rational note events.
- The `legato end`, "`)`" again signifies the end of a legato-slurred phrase. Like in diatonic notation, it must come before any ties indicated with a "`t`".
- Finally, one or more "`t`'s" can occur to lengthen the note, again like lengthening the rectangle on a piano-roll style sequencer interface.

As before, we can illustrate rational notation using a simple example again, this time a scale in the virtual key of 'D', which we arrive at by using the "`key=`" variable setting:
```csound
# below we see the selection of a harpsichord soundfont preset
# eighth notes are used
1: i=12 "7%.01%.03" 1/8 key=9:8 1:1 9:8 5:4 4:3 3:2 5:3 15:8 2:1 t t t
# now we rest for four bests and then hit a full D-major chord with 6 notes.
# it's still D-major b/c we haven't reset the 'key=' statement to equal "1:1"
# we use a whole note value to make the chord a bit longer:
1: r4 1/1 [1:2 3:4 1:1 5:4 3:2 2:1]
```

### A note on ramping


One of the nice features of the Csound score is the use of the "`<`" character to set a p-field value to to the value interopolated between a starting and ending value found in other notes. This allows behavior such as smooth interpolations of parameters for crescendi/diminuendi, signal panning, etc. Ramping is available for all of the p-fields except for p5, which by the architecture of Microcsound, actually triggers the instrument and causes the time-line itself to advance. To do ramping of any p-field parameter, you must ensure that you supply a defined starting and ending value, as the rest is taken care of by Csound. There are a couple of things to remember as well: although p4 (attack) can be ramped by using "`@<`", pan and mix must use the less-than sign surrounded by double quotes: e.g. `pan="<"`'. A simple C-major scale below demonstrates simultaneously a crescendo as well as ramped panning:
```csound
#below is the setup for a chip-tune instrument from 'microcsound.orc'
1: div=12 i=6 ".02%.02%2%.6" mix=0.65 t=90
#now we pan left to right and crescendo simultaneously
#csound performs all the interpolation for us.
1: @0.3 pan=0.1 c, @< pan="<" d, e, f, g, a, b, @0.8 pan=0.9 c4
```

### Using the time pointer for one-off counterpoint


Time in Microcsound by default marches along by beats, advancing whenever an event (*note, chord, rest *or* trigger*) is found in the score. However, there are certain instances where one may wish to modify the onset time so that one may go back and add additional layers of counterpoint, or set the clock to zero, etc.

For example, suppose we have a piece where a monophonic voice sometimes need to split off into dyads. We could set the time pointer to return N beats back by using "`&-N`", for example, to go three beats back and add an addiontal line of notes, we would type "`&-3`" (without quotes) in our `.mc` score.

Here is an example of the beginning of the melody "For the Beauty of the Earth", set to contain a bit of 2-voice counterpoint towards the end, but "embedded" in one voice:
```csound
#example showing resetting the time pointer
1: div=19 i=10.1 "0.02" (g2 ^fg a2g2 c'2 c'2 b4) | e2 ^f2 g2 e2 d2 .d2 d4
1: &-16 i=10.2 "0.02" (c4 b,4 a,b,c2 b,2 g,2) ||
```


Notice the use of fractional instruments so that Csound understands how to handle multiple instances of legato ties using the same instrument within the orchestra.

The time pointer can be set to the beginning of the piece by using "`&0`", and if you need to advance the clock for any reason (typically, there are not many reasons for doing so) you can use "`&+N`" where N is the number of beats of the current rhythmic time value (set with the fraction, as explained earlier). In addition, one can go to any arbitrary beat number based on the default rhythmic length times the value of N. For instance, if the current rhythmic value is `"1/8"`, to go to the 17th eighth note in the piece, you could write "`&17`".


## II. Odds and Ends

### More on Interactive mode (calling the script with "microcsound -i")


The use of interactive mode by calling Microcsound from the command line with the "`-i`" switch is helpful for various situations, including making quick sketches, performing acoustic demonstrations or tuning demonstrations, creating droning sonorities, tuning an acoustic instrument with a suite of test tones, etc. The difference as far as the script is concerned is that all the input data flows in a classic read/eval/output loop familiar to anyone who has used an interpreted programming language from LISP onwards, such as Python, Scheme, PERL, Basic, Lua, etc. To end the read cycle and have Microcsound evaluate and output sound based on the text entered from the live interpretive loop, you must write "`done`" followed by a return all alone on a single line. The example below illustrates a C-major chord being played by one voice while a 2nd voice descends a scale at the same time. You will also get a feel for the kind of output you are likely to see from Microcsound, and from the background engine messages from Csound, which is ultimately being called to process the sound:
```csound
akj@myhost:~$ microcsound -i
microcsound--> 1: div=1 i=12 "7%.01%.02" t=90 1/1 [1:2 3:4 1:1 5:4 3:2 2:1]
microcsound--> 2: i=12 "7%.01%.02"  1/16 1:1 t 15:16 5:6 3:4 2:3 5:8 9:16 1/2 1:2
microcsound--> done
microcsound--> done
ok...processing sound now
aha, a ratio!
aha, a ratio!
aha, a ratio!
aha, a ratio!
aha, a ratio!
aha, a ratio!
aha, a ratio!
aha, a ratio!
aha, a ratio!
aha, a ratio!
aha, a ratio!
aha, a ratio!
aha, a ratio!
aha, a ratio!
executing csound command...
PortMIDI real time MIDI plugin for Csound
virtual_keyboard real time MIDI plugin for Csound
dBFS level = 32768.0
Csound version 5.13 (float samples) Jan 19 2011
libsndfile-1.0.21
orchname:  /home/akj/audio_and_midi/csound_files/microcsound.orc
scorename: /tmp/Microcsound.sco
rtmidi: PortMIDI module enabled
rtaudio: ALSA module enabled
orch compiler:
	opcode	tieStatus	i
	opcode	AllPass	a	a
	instr
	instr
	instr
	instr
	instr
	instr
	instr
	instr
	instr
	instr
	instr
	instr
	instr
	instr
	instr
	instr
	instr
	instr
	instr
	instr
	instr
	instr
	instr
	instr
	instr
	instr
	instr
	instr
	instr
	instr
	instr
	instr
	instr
	instr
sorting score ...
	... done
Csound version 5.13 (float samples) Jan 19 2011
displays suppressed
dBFS level = 1.0
del: -11959.000000
del: -11959.000000
del: -11959.000000
del: -11959.000000
del: -11959.000000
del: -11959.000000
del: -4870.000000
del: -2346.000000
del: -4308.000000
del: 1902.000000
del: 1902.000000
del: 1902.000000
del: 1902.000000
del: 1902.000000
del: -12000.000000
del: -12000.000000
del: -12000.000000
del: -12000.000000
del: -12000.000000
del: -12000.000000
del: -12000.000000
del: -12000.000000
del: -12000.000000
del: -12000.000000
del: -12000.000000
del: -12000.000000
del: -619.000000
del: -8154.000000
del: -8154.000000
del: -10057.000000
del: -10057.000000
del: -10057.000000
del: -10057.000000
del: -10057.000000
del: -10057.000000
del: -10057.000000
del: -10057.000000
del: -10057.000000
orch now loaded
audio buffered in 2048 sample-frame blocks
ALSA: -B 4096 not allowed on this device; using 3763 instead
ALSA: -b 1881 not allowed on this device; using 940 instead
writing 8192-byte blks of shorts to dac
SECTION 1:
Score finished in csoundPerform().
inactive allocs returned to freespace
end of score.		overall amps:  0.73753  0.73753
	overall samples out of range:        0        0
errors in performance
8192-byte soundblks of shorts written to dac
microcsound-->
```


The example above shows an interactive session in Microcsound, displaying a mixture of Microcsound text output followed by text output from Csound itself. As you can see, anything that can be done in Microcsound's normal compilation mode can be accomplished in real-time interactive mode as well, provided that the computer processor and memory can handle the real-time audio processing power required.
### Tips for creating instruments that work with Microcsound


When designing Csound instruments that will work with Microcsound, all of the p-fields from 1-7 must be reserved for the following values:
- p1 - instrument number
- p2 - onset

- p3 - duration (becomes negative for legato articulation)
- p4 - attack
- p5 - pitch (supplied in HZ by the interpretation of notation within Microcsound)
- p6 - pan
- p7 - mix

You should always start with these in mind when designing new instruments or modifying old ones to integrate into a Microcsound orchestra. As mentioned in the section regarding *extra p-field variables*, you can optionally use p8 and up for any number of additional instrument parameters. Here is a list of tips to remember when designing instruments:
- Make your instrument expect any pitch from p5 to be in hertz (HZ), or cycles-per-second. Microcsound converts all note pitch values to HZ itself, and no conversion will need to be done in your Csound code, such as using `cps2pch`.
- The instruments should accept (expect) an `attack` value between 0.0 and 1.0. This is typical for `0dbfs` type design, anyway.
- When designing a legato instrument, remember that Microcsound will send a negative duration to p3. Please refer to Steven Yi's excellent tutorial regarding legato instruments in Csound ("[Exploring Tied Notes in Csound](https://csoundjournal.com/#ref3)"--listed in the references) to know what kinds of code (including user-defined opcodes) to use to handle legato without glitches. Another point to remember is to *use fractional instruments from the Microcsound score when you have multiple parts using the same instrument, and at least one of them is legato.* Csound needs to know that each instrument is a unique voice, and it must know what legato ties belong to what voices. An example of using a fractional instrument in Microcsound would be setting the instrument variable like so: "`i=3.1`" .... note the decimal point setting this instance of instrument 3 apart from all others.
- Pan and Mix are also designed to use a range of 0.0-1.0, so please design all instruments accordingly for that range of values.
- One tip for using percussion instruments with Microcsound: use *helper* instruments. For example, if you look at the code of `microcsound.orc`, you will find instrument 120, a virtual drum kit. This instrument reads p5 from Microcsound and triggers another instrument in the orchestra which corresponds with the value of p5 plus some constant (remember, this is possible due to using `div=0`). This allows actions analogous to MIDI key numbers to trigger certain drums. Anyone familiar with MIDI GM drum kits will find such a paradigm comfortable.
### Using a mixer or effect instrument from within Microcsound


One of the things we often use in our music work is a mixer. In Csound, mixers are often implemented using the ZAK patching system or one of the newer channel opcodes. The author is more familiar with the former means and as a result the default orchestra file, `microcsound.orc`, uses the ZAK patching system to set up a default mixer and reverb effect. When you look at the `microcsound.orc` file, you will find that instrument 200 is a mixer, instrument 201 is a helper instrument that triggers the mixer instrument (instrument 200) to turn on, and instrument 202 provides the user the ability to modify the 4 variables that are used in the mixer instrument: dry volume, wet (reverb) volume, reverb amount and reverb cutoff frequency. These variables are accessed via p8-p11 for instrument 202, and are modifiable from Microcsound by using the percent sign syntax, as discussed above. For example, setting the dry volume to 1, wet volume to 0.5, reverb amount to 0.75 and reverb cutoff frequency to 7430 would mean writing the following extra p-field string before any trigger event: "`1%0.5%0.75%7430`" (double quotes here are literal--they must be typed!)

***Note:** the use of instrument 201 to turn on the ZAK mixer in `microcsound.orc` is no longer necessary and deprecated as of Microcsound version 20100803--there is a default score trigger for this instrument within Microcsound.*

The following example assumes the use of `microcsound.orc` and illustrates the changing of the default settings for the mixer/reverb global ZAK instrument from within Microcsound:
```csound
1: div=0 i=202 "1%0.5%0.8%5500" 1
1: &0 i=11 1:1 2:1 t t 7:4 t 1/16 3:2 7:4 5:3 7:4 t t 1/8 3:2 5:4 9:8 1/2 1:1
```

### []An example of Microcsound at work


Users interested in digging deeper into how Microcsound works in a larger piece than the examples shown here can look at the source file for the author's own work, *Puhlops and Laugua's Big Adventure*, written in 17-edo back in summer of 2009. You can find the .mc source file at:

[http://untwelve.org/static/microcsound/PuhlopsAndLaugua.mc](http://untwelve.org/static/microcsound/PuhlopsAndLaugua.mc)

A pre-rendered version is available for listening at:

[https://soundcloud.com/aaron-krister-johnson/puhlops-and-lauguas-big-adventure](https://soundcloud.com/aaron-krister-johnson/puhlops-and-lauguas-big-adventure)

The nice thing about this example is that it not only illustrates using microtonality with typical synth instruments one might design in Csound; it also illustrates using drum techniques from within Microcsound.


## Conclusion


I hope you will try Microcsound and find, as I have, that it is a useful and flexible front-end that speeds up and eases the process of using and interacting with Csound. While Microcsound is designed for composers interested in microtonality and Csound, I do hope that there is sufficient evidence that this program is general enough to serve the needs of many others, including those interested in didactic demonstrations, algorithmic music, creating musical sketches, and using reference pitches easily from the command line.


## Acknowledgments


I would like to thank Steven Yi for inviting me to write about my software for the Csound Journal. Also, a big thank you to the once, current and future developers of Csound itself, for your magnificent and generous code, code that creates one of the most powerful pieces of audio software the planet has yet seen.


## References

-  []Richard Dobson, "Designing Legao Instruments,"�The Csound Book: Perspectives in Software Synthesis, Sound Design, Signal Processing, and Programming, 2nd Edition, pp. 171-186, 2001.
- []Steven Yi, "Exploring Tied Notes in Csound", [Csound Journal](https://csoundjournal.com/../2005fall/tiedNotes.html), Issue 1, 2005.
-  Microcsound Homepage: [http://www.untwelve.org/microcsound](http://www.untwelve.org/microcsound)
