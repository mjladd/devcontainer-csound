---
source: Csound Journal
issue: 19
title: "Grace, Scheme, and Csound"
author: "Heinrich Taube"
url: https://csoundjournal.com/issue19/grace_scheme_csound.html
---

# Grace, Scheme, and Csound

**Author:** Heinrich Taube
**Issue:** 19
**Source:** [Csound Journal](https://csoundjournal.com/issue19/grace_scheme_csound.html)

---

CSOUND JOURNAL[](https://csoundjournal.com/index.html) | [Issue 19](https://csoundjournal.com/index.html)
## Grace, Scheme, and Csound
 Jim Hearon
 j_hearon AT Hotmail.com
## Introduction


This article is about generating Csound scores from the Grace console (Graphical Realtime Algorithmic Composition Environment), using the extension language Scheme. Common Music[[1]](https://csoundjournal.com/#ref1), available on sourceforge.net by Heinrich Taube, has versions going back to 2004. Earlier versions, such as version 2.4.1, are console versions requiring a Lisp environment and optionally Emacs or XEmacs as text editor. Beginning with version 3.3.0 in 2009, Grace, an alternative graphical interface, became available for using Common Music. The Grace console allows the use of s7, a Scheme implementation by Bill Schottstaedt[[2]](https://csoundjournal.com/#ref2). s7 is also used in other Center for Computer Research in Music and Acoustics (CCRMA) applications such as SND and is closest as a Scheme dialect to Guile 1.8. Dave Phillips has also written about Grace and "The Csound Connection" in his article "Algorithmic Music Composition with Linux, Part 2"[[3]](https://csoundjournal.com/#ref3).

Grace includes functionality for exporting, writing, and playing Csound scores. Thus the use of Scheme for generating expressions, lists, loops, and functions employing Common Music to create Csound note lists is an effective method to assist in Csound score generation. Additional examples and concepts from Heinrich Taube's book "Notes from the Metalevel", first published in 2005, will be cited below. Versions used for this article were Fedora 19, Grace Beta4 vers. 3.9.0 (2013), and Csound 6.01.
##
 I. The CS Message



A simple line of Csound score file algol can be expressed using s7 from Grace in the manner shown below. The six pfields of a line of a Csound score file are represented by an instrument number, start time, duration, frequency, waveform or gen routine, and amplitude.
```csound
(cs:i 1 0 .5 269.9 1 10000)
```


The statement really does not do anything yet, but it does resemble the familiar syntax of a Csound score statement with the addition of a the cs keyword prepended to the syntax, and surrounded by Lisp parentheses. The *Common Music 3 Dictionary*[[4]](https://csoundjournal.com/#ref4) explains that the following calls are equivalent:
```csound

(cs:i 1 0 .5 269.9 1 10000)
(send "cs:i" 1 0 .5 269.9 1 10000)

```


A simple approach to begin coding output to generate a sequence of Csound score statements, as shown below, is to utilize a control loop employing Scheme code. To evaluate this expression in a new Lisp editor (.scm) file, type it, point the cursor past the last parenthesis, and press command plus return on the Mac or control plus enter on Linux. You may also need to click the Audio menu, then Csound, and uncheck "Play Scorefiles", in order to generate a file to disk, since we are not using realtime Csound at this point. The code from example 1, below, outputs to a score file which is playable by Csound, using Csound as a standalone application. You can download all of the Scheme examples shown in this article from the following link: [s7_examples.zip](https://csoundjournal.com/downloads/s7_exs.zip)
```csound

(with-csound ("testsco.sco")
  (loop repeat 2 do
    (cs:i 1 0 .5 269.9 1 10000)))

```


Grace offers a choice of two editors for code: one, a Lisp editor for Scheme code, and the other, a Sal editor for entering Simple Algorithmic Language (SAL) code. There is also a third menu option under the Editing Syntax menu for plain text, too. See Heinrich Taube's book *Notes from The Metalevel*[[5]](https://csoundjournal.com/#ref5)for an explanation of Lisp evaluation. This article is concerned with the Lisp editor for Scheme, but the Grace console Help menu also includes several SAL, as well as the Scheme examples for coding and evaluating Common Music. Some users may prefer the minimalist algorithmic language SAL for coding, while others might use the more Lisp-like syntax of Scheme.

The support for Csound in Grace includes various Csound settings, currently located under the Audio tab. Unchecking "Play Scorefiles" indicates you are not trying to generate sound from Csound in realtime. Selecting the "Write Scorefiles" option will have output written to a file. An *f* statement can be generated for your score by continuing under the Audio/Csound/Settings menus to enter a waveform as a gen routine which can be entered in the Header section of the Csound Settings panel. The code from example 2, below, provides minimal calculation with Scheme, using a for-loop from above, and including "start" here as a variable.
```csound

(with-csound ("testsco.sco")
  (loop for start to 2 by .5
    do (cs:i 1 start .5 (between 269.9 880.0) 1 10000)))

```


The code above generates the following Csound score output:
```csound

; Common Music output 17 Jun 2013 3:40:09pm
f 1 0 1024 10 1 0
s
i 1 0.000 0.5 299.61654510749 1 10000
i 1 0.500 0.5 786.25586610017 1 10000
i 1 1.000 0.5 691.08865104006 1 10000
i 1 1.500 0.5 786.87532075934 1 10000
i 1 2.000 0.5 659.1955933347 1 10000
e

```


## II. Definitions and Using Sprout



`Sprout` schedules processes to run in realtime using the Common Music scheduler. The Csound example below, again, is not designed for realtime, rather to generate a score file in non-realtime, which could then be run by Csound as a standalone application. Employing `sprout`, along with a defined Scheme or Lisp-like process, makes for the beginning of a nucleus of code which can be reused with modifications. Below, from example 3 in the downloadable s7_examples, is a definition of a process, and uses a call to `sprout` to output to a file.
```csound

;; output using a process
(define (simple)
  (process repeat 5 do
    (send cs:i 1 (elapsed()) .5 (between 269.9 880) 1 10000)
    (wait 0.1)))

(sprout (simple) "test.sco")

```


The .sco file generated from the code above could be played by a unique Csound orchestra from Csound. Many Csound scores contain exclusive events that instantiate the orchestras or instruments which employ them, and this is due to the relationship, number and type of pfields, macros, includes, and *f *statements which are part of the processing of Csound scores. Also, related to the concept of algorithmic score generation, is the concept of the global score manipulation and reuse of score files using the Csound utility Cscore is possible from Csound[[6]](https://csoundjournal.com/#ref6). Thus the ability to generate an extensive score file of events employing the algorithmic routines, such as Patterns and Randomness, under the "Composition Toolbox" heading of The *Common Music 3 Dictionary*[[7]](https://csoundjournal.com/#ref7) of Common Music to help drive the creation of Csound score note lists and events can provide interesting new source material for score manipulation. The rich variety of Common Music Patterns, such as Cycle, Line, Heap, Weighting, etc., can be utilized individually or combined using Lisp lists to form composite patterns.

John Ramsdell's "Scheme Score"[[8]](https://csoundjournal.com/#ref8), is a Csound score preprocessor which translates a score file augmented with Scheme code into a Scheme program such that when the generated program is executed by a Scheme interpreter, it produces a processed score file for input to Csound. Ramsdell's application is usable in conjunction with Common Music.

 Below, from example 4, is code using two processes. One process creates the *f* statement and another process creates the i-statement. The score is generated by sprouting a list of the processes.
```csound

(define (fstatement num time size gen str1 str2)
  (process repeat 1 do
    (cs:f num time size gen str1 str2)))
```

```csound

(define (istatement inst start dur freq wav amp)
  (process repeat 1 do
    (cs:i inst start dur freq wav amp)))
```

```csound

(sprout (list (fstatement 1 0 1024 10 1 0)
              (fstatement 2 0 1024 10 1 .5)
              (istatement 1 0 .5 269.9 1 10000)
              (istatement 1 .5 .5 440 2 10000)
              (istatement 1 1 .5 269.9 1 10000)) "test.sco")
```


You can also delay writing to the file, as shown below from example 5, by including `:write #f` with the `sprout` statement. Using this manual export approach, you can select the Grace menu Audio/Csound/Export Score, and then choose to export to Grace's console, to the clipboard, or to a file. This is useful for debugging code by viewing the output on the console before sending it to a file.
```csound

(define (fstatement num time size gen str1 str2)
  (process repeat 1 do
    (cs:f num time size gen str1 str2)))

```

```csound

(define (istatement inst start dur freq wav amp)
  (process repeat 1 do
    (cs:i inst start dur freq wav amp)))

```

```csound

(sprout (list (fstatement 1 0 1024 10 1 0)
              (fstatement 2 0 1024 10 1 .5)
              (istatement 1 0 .5 269.9 1 10000)
              (istatement 1 .5 .5 440 2 10000)
              (istatement 1 1 .5 269.9 1 10000)) "test.sco" :write #f)

```

## III. Realtime and Play Scorefiles



 If the Audio/Csound menu settings for "Write Scorefiles" and "Play Scorefiles" is checked, or you employ the `:write #t` and `:play #t` flags, as shown below in the code from example 6, and if the path is set to your Csound Application, then theoretically Grace should fire Csound and play the .sco file in realtime.
```csound

(sprout (list (fstatement 1 0 1024 10 1 0)
              (fstatement 2 0 1024 10 1 .5)
              (istatement 1 0 .5 269.9 1 10000)
              (istatement 1 .5 .5 440 2 10000)
              (istatement 1 1 .5 269.9 1 10000)) "test.sco" :play #t
                      :orchestra "simp.orc")

```


Issues that may stop this from actually happening are conflicts between the Audio/Csound/Settings menu for soundcard Options (such as `-odac`, or `-odevaudio`) and Grace's Audio/Audio Settings/Audio Type Device settings. If those two are set to the same audio output one will show up as "busy". Additionally you may find Csound will not fire due to the lack of Csound environment variables being set (OPCODE6DIR64, etc), but there is an option to set those from the command line in the Audio/Csound/Settings Options panel.

In the example shown above, the Csound `f` statements are injected into the file using a list. There is however another place to list f statements, which is the AudioCsound/Settings planel slot labeled "Header".

Grace allows you to utilize Csound in non-realtime to generate, for example, a .wav file from the Scheme code. For that approach you would change the Audio/Csound/Settings Options panel to something like: `-W -o test.wav -d`, which is a preset listed in the pull down menu of the panel. Then using the example above, it should write the test.sco then call Csound and generate a test.wav of the example.

Additionally, you may also want to use Bill Schottstaedt's SND application for playing and editing sound files[[9]](https://csoundjournal.com/#ref9). Once a .wav file is generated by Csound from Grace, you can easily open it in SND using the "system" command.
```csound

(system "/home/fedora/Grace/test.sh")

```


The contents of the script file might include something like the commands below:
```csound
#!/bin/sh

cd /opt/snd-13.5
./snd /home/fedora/Grace/test.wav
```

## IV. MIDI



When generating large note lists for a Csound score file, sometimes it is practical to perform a simple MIDI version first, as proof of concept. In order to hear the MIDI results generated by your code, you can setup your MIDI instrument in the Grace console using the Audio/Midi Out menu to select your MIDI player. A good, solid, functional MIDI player for Linux is FluidSynth[[10]](https://csoundjournal.com/#ref10), using Qsynth[[11]](https://csoundjournal.com/#ref11) the QT graphical user interface for FluidSynth, or SimpleSynth[[12]](https://csoundjournal.com/#ref12) for Mac OS. As another alternative to realtime Csound, using MIDI for proof of concepts in order to monitor and listen to your note lists before generating output to a Score file, along with the ability to show the note lists on the console (described above employing `:write #f`), creates powerful debugging tools for correcting problems or solving coding issues when generating large note lists.

The following defines a process, `mypat`, with `stop` (overall duration), `keys ` (pitches), and `rhy` (the duration between pitches). `Shuffle` will return a randomly selected argument from the note list from the group of pitches listed. Notice in the code below, from example 7, `send "mp:midi" ` is employed instead of `send "cs:i"`.
```csound

(define (mypat stop keys rhy)
  (process with pat = (make-heap keys)
    for t = (elapsed #t) ; get elapsed time
           until (>= (elapsed) stop)
           do
           (send "mp:midi" :key (next pat) :dur rhy)
           ;(print "mp:midi" :key (next pat) :dur rhy)
           (wait rhy)))

(let ((notes (shuffle '(e4 fs4 b4 cs5 d5 fs4 e4 cs5 b4 fs4 d5 cs5)))
      (stop 5))
  (sprout (list (mypat stop (key notes) .167))))

```
 Listed below, from example 8, is the same process shown above, but changed to `sprout` a Csound Score file instead of output to MIDI. Another way to print the output to Grace's console is to uncomment the "print" statement shown in both examples.
```csound

(define (mypat stop keys rhy)
  (process with pat = (make-heap keys)
    for t = (elapsed #t) ; get true score time
           until (>= (elapsed) stop)
           do
           ;(print 1 " " t   " " rhy " "  (next pat) " " 10000)
           (cs:i 1 t rhy (next pat) 10000) ;csound version
           (wait rhy)))

(let ((notes (shuffle '(e4 fs4 b4 cs5 d5 fs4 e4 cs5 b4 fs4 d5 cs5)))
      (stop 5))
 (sprout (list (mypat stop (hz notes) .167)) "test.sco"))

```

##
 V. Randomness



The following, from example 9, is a brief look at several of the functions—such as `random`, `vary`, `drunk`, and `odds`—for random processes in Common Music. For a detailed view of each function's parameters please see the *Common Music 3 Dictionary*[[13]](https://csoundjournal.com/#ref13) . For those curious about the nature of random number generators, random seeds, and probability in Common Music and Lisp, Taube has also written about those aspects of Common Music in his book "Notes From the Metalevel"[[14]](https://csoundjournal.com/#ref14). Markov processes, for example, are covered at length in the book as well as in the SAL code examples under the Help menu on the Grace console. Uncomment to test different types of random calls in the example below.
```csound

(define myvalues '(10 100 5 25))

(define (simple2)
  (process repeat 5 do
    ;uncomment for testing
    ;(print 1 (elapsed()) .5 (between 269.9 880) 1 10000)
    ;(print (between 269.9  880))
    (print (random 127))
    ;(print (random (hz 127)))
    ;(print (vary 100 .5 0))
    ;(print (vary myvalues .5 0)) ;;using a list
    ;(print (drunk 100 5 25 95 3 0))
    ;(print (odds .5 25 100))
    ;(print (pick myvalues))
    ;(print (shuffle myvalues))

           (wait 0.1)))

(sprout (simple2))

```


Below, from example 10, is code utilizing `tendency`, which employs tendency masks between upper and lower boundaries for random selection. This example also shows the plot function and graphical capabilities available in Grace, with green as upper boundary or envelope, red as lower envelope, and blue as the resulting random selection which is between the two boundaries, in Figure 1. This example is a reworking of a similar example shown in "Notes From The Metalevel" under "Tendency Masks"[[14]](https://csoundjournal.com/#ref14).
```csound

(define lower '(0 .1 .5 .5 1 .2))   ;;xy pairs
(define upper '(0  1 .5 .7 1 1))

(define (simple3 key1 key2)
  (process repeat 6
    for e = (tendency 100 lower upper)
    for k = (rescale e 0 1 key1 key2)
    do
    (print k)
    (wait 0.1)))

(sprout (simple3 20 100))

;;result 63 48 75 72 88 75
;;then rescale the xy pairs below for printing

(plot :title "My Plots"
      :xaxis '("unit" 0 1 .25 5)
      :yaxis '("unit" 0 1 .25 5)
      :layer '(0 .1 .5 .5 1 .2) :title "baz" :style "envelope"
      :layer '(0  1 .5 .7 1 1) :title "baz" :style "envelope"
      :layer '(.63 .48 .75 .72 .88 .75) :title "baz" :style "envelope")

```

```csound

![image](images/plot1_480x470.png)
```

 **Figure 1. Plotting function in Grace.**



Example 11, below, is likely a more suitable Csound example for generating and saving to Score files. It makes use of random processes (using `pick`) as well as calculating the correct start times for notes based on previous durations.
```csound

(define durs '(1 1.5 .25 .75 .5 2))

(define mynotes '(e4 fs4 b4 cs5 d5 fs4 e4 cs5 b4 fs4 d5 cs5))

(define myamps '(1000 10000 6000 15000 18000 22000))

(define start 0)

(define dur 0)

(define (simple)
(process for x from 1 to 5
  for pitch = (pick (hz mynotes))
  for amp = (pick myamps)
    do
    (if (= x 1)
      (define start 0))
    (if (> x 1)
      (set! start (+ start dur)))
    (set! dur (pick durs))
      ;;(print start  "  " dur "  " pitch "  " 1 "  " amp))) ;;end loop
    (send cs:i 1 start dur pitch 1 amp)))

;;(sprout (simple))
(sprout (simple) "test.sco" :write #f)

```


If using the write flag with boolean false, `:write #f`, shown above, select the Audio/Csound/Export Score/ menu, then export to console, clipboard or file. Recall you can also place an *f *statement (Ex. `f 1 0 1024 10 1 0`) in the header section of the Csound settings box. In that case you may also need to select "Clear Score" on the menu, first.
## Conclusions


Previously using Common Music was complex and involved employing Emacs and setting up a Lisp environment on Linux. The previous complexities have been overcome with the Grace Console allowing users to utilize Common Music in a light-weight, friendly, graphical user environment available on all platforms. The light-weight coding capabilities such as SAL or Scheme, excellent graphics, music notation, MIDI, audio, and Csound support provide needed features for utilizing Grace as a powerful teaching tool for algorithmic composition.

Due to the speed of development involving changes in the console, an update of "Notes from the Metalevel" is needed if the application is really intended to work with the text. However the Help menu and tutorials provided are a good start for those just starting out with Common Music. While Grace, Scheme, and Common Music provide powerful tools for interfacing with Csound, especially for generating unique patterns of note lists, it is up to those who use the tools to help move the results of algorithmic composition beyond postmodernisms and into a new era of computer music.
## References


[][1]University of Illinois Board of Trustees, Julian Storer, William Schottstaedt, and Ross Bencina, "Grace: Graphical Realtime Algorithmic Composition Environment." [Online] Available: [http://commonmusic.sourceforge.net/](http://commonmusic.sourceforge.net/.). [Accessed September 23, 2013].

[][2]Bill Schottstaedt, "s7." [Online] Available: [https://ccrma.stanford.edu/software/snd/](https://ccrma.stanford.edu/software/snd/). [Accessed January 18, 2014].

[][3] Dave Phillips, "Algorithmic Music Composition With Linux, Part 2," in *Linux Journal*, Jun 23, 2010. [Online] Available: [http://www.linuxjournal.com/content/algorithmic-music-composition-linux-part-2](http://www.linuxjournal.com/content/algorithmic-music-composition-linux-part-2). [Accessed October 2, 2013].

[][4] Rick Taube, "Common Music 3 Dictionary." [Online] Available: [http://commonmusic.sourceforge.net/cm/res/doc/cm.html#csound](http://commonmusic.sourceforge.net/cm/res/doc/cm.html#csound). [Accessed September 23, 2013].

[][5] Heinrich Konrad Taube, "Notes from the Metalevel: An Introduction to Computer Composition." [Online] Available: [http://www.moz.ac.at/sem/lehre/lib/bib/software/cm/Notes_from_the_Metalevel/eval.html](http://www.moz.ac.at/sem/lehre/lib/bib/software/cm/Notes_from_the_Metalevel/eval.html).[Accessed September 23, 2013].

[][6] Barry Vercoe et al., 2005. "Cscore." *The Canonical Csound Reference Manual*. [Online] Available: [http://www.csounds.com/manual/html/CscoreTop.html](http://www.csounds.com/manual/html/CscoreTop.html). [Accessed September 23, 2013].

[][7] Rick Taube, "Common Music 3 Dictionary." [Online] Available: [http://commonmusic.sourceforge.net/cm/res/doc/cm.html#patterns](http://commonmusic.sourceforge.net/cm/res/doc/cm.html#patterns). [Accessed September 23, 2013].

[][8] John Ramsdell, "Scheme Score." [Online] Available: [http://www.ccs.neu.edu/home/ramsdell/tools/scmscore-1.0/scmscore.html](http://www.ccs.neu.edu/home/ramsdell/tools/scmscore-1.0/scmscore.html)/. [Accessed October 2, 2013].

[][9] Bill Schottstaedt, "Snd." [Online] Available: [https://ccrma.stanford.edu/software/snd](https://ccrma.stanford.edu/software/snd)/. [Accessed September 23, 2013].

[][10] David Henningsson, Joshua Green, Pedro Lopez-Cabanillas, et. al., "FluidSynth." [Online] Available: [http://sourceforge.net/apps/trac/fluidsynth/](http://sourceforge.net/apps/trac/fluidsynth/). [Accessed January 18, 2014].

[][11] Rui Nuno Capela, Richard Bown, Chris Cannam, and Pedro Lopez-Cabanillas, "Qsynth." [Online] Available: [http://qsynth.sourceforge.net/qsynth-index.html](http://qsynth.sourceforge.net/qsynth-index.html). [Accessed September 23, 2013].

[][12] Not a Hat, "SimpleSynth." [Online] Available: [http://notahat.com/simplesynth/](http://notahat.com/simplesynth/). [Accessed October 1, 2013].

[][13] Rick Taube, "Common Music 3 Dictionary." [Online] Available: [http://commonmusic.sourceforge.net/cm/res/doc/cm.html#randomness](http://commonmusic.sourceforge.net/cm/res/doc/cm.html#randomness). [Accessed September 23, 2013].

[][14] Heinrich Konrad Taube, "Notes from the Metalevel: An Introduction to Computer Composition." [Online] Available: [http://www.moz.ac.at/sem/lehre/lib/bib/software/cm/Notes_from_the_Metalevel/chance.html](http://www.moz.ac.at/sem/lehre/lib/bib/software/cm/Notes_from_the_Metalevel/chance.html).[Accessed September 23, 2013].
