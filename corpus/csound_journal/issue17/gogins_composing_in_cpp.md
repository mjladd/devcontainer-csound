---
source: Csound Journal
issue: 17
title: "Composing in C++"
author: "notating or overdubbing but"
url: https://csoundjournal.com/issue17/gogins_composing_in_cpp.html
---

# Composing in C++

**Author:** notating or overdubbing but
**Issue:** 17
**Source:** [Csound Journal](https://csoundjournal.com/issue17/gogins_composing_in_cpp.html)

---

Csound JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 17](https://csoundjournal.com/index.html)
## Composing Music for Csound in C++


Michael Gogins
 michael.gogins AT gmail.com

## Introduction


 This article describes how (and why) I write algorithmic compositions for Csound [[1]](https://csoundjournal.com/#ref1) in C++.

*Why*: I make music on computers, and C++ is the best way I have found to automate everything not directly related to composing, so I can concentrate fully on the music itself.

*How*: for each new piece, I write a C++ program in one .cpp file. It includes:
-

A score generator.
-

A Csound orchestra, embedded in the C++ code.
-

A graphical user interface, defined in the Csound orchestra, for controlling instrument parameters during performance, which helps to customize the instruments for the piece and to determine the best parameters for mastering it.
-

The Csound library, for actually rendering the piece.
-

Code for automatically applying ID tags, normalizing the high-resolution soundfile, and translating it to CD-Audio and MP3 format.

In addition, I have customized my text editor so I can compile a piece, render it, post-process it, and listen to it with one keystroke (see below, Appendix A).

I have been thinking about composing purely in C++ for years. I even tried it from time to time. However, until the C++ standard [[2]](https://csoundjournal.com/#ref2) was changed to allow multi-line string constants, it was too tedious to embed a Csound orchestra in C++ code.

This single feature is why I switched from composing in Python or Lua to composing in C++. But there are other reasons C++ makes more sense now. Free C++ compilers are available on all platforms. With faster computers, compiling takes less time. The new features of C++ (such as the `auto` keyword and lambdas) make it easier to write C++. And the open source tools and libraries I use, like the Eigen library for linear algebra [[3]](https://csoundjournal.com/#ref3), also have improved.

In the following I will explain my motivation for using C++, outline my working method, show the skeleton code for a typical piece, discuss a simple piece including its Csound orchestra, and present the code for a real piece with explanations of the new features of C++ that I used to write it.

This way of composing is my way, and would not be everyone's way. Still, if you do algorithmic composition, and if you are comfortable with C++, you may find parts of this essay useful.
##
 I. Motivation



My motivations for choosing C++ over Java, Python, Lua, Basic, and Lisp – all of which I have used – are speed, simplicity, archival stability, and the user interface. It is true that C++ is more complex than Python or Lua, but there are excellent reasons why many critical systems and consumer applications are written in C++.

I became a composer because I saw, in Martin Gardner's 1978 *Scientific American *column “White and brown music, fractal curves and one-over-f fluctuations” [[4]](https://csoundjournal.com/#ref4), how recursive functions can generate fractal patterns that are beautiful. I am still primarily an algorithmic composer. I have sometimes composed by notating or overdubbing but, to date, results along these lines are strictly mediocre. Only with algorithms have I managed to make a few pieces that I enjoy hearing more than once.

I write many sketches until something sounds promising. Then I tweak the piece through a repetitive cycle of edit, compile, render, listen; edit, compile, render, listen – dozens or hundreds of times. Working speed is of the essence. This includes both the speed of writing the piece and the speed of rendering it. C++ is one of the fastest languages, so the appeal of C++ is obvious.

Simplicity is another motivation. Some of my pieces have included a mixture of Csound code, C++ code, and Python or Lua code. Others have depended upon Csound “front ends” such as CsoundQt. The fewer languages and programs I must contend with, the simpler life is for me. I like LuaJIT/FFI, a version of Lua that has a runtime compiler and a C foreign function interface, and it runs almost as fast as C or C++, but I find LuaJIT too fragile. In any event, with LuaJIT, FFI, and Csound, I was having to think in three different languages for the same piece. So C++, in spite of being a more complex language, has actually turned out to provide the simplest working environment.

Writing pieces in the form of source code – text files – means they are archival. This is important. It means the pieces will still work into the indefinite future assuming you have Csound and C++ (and nothing else), and that the pieces can be read and understood by a human being so that, in case things finally do break, repairs can be made. I have made pieces using commercial software, or using my own software but with binary file formats. When I wanted to go back to pieces I had made years ago and change them....I could not! Fortunately, both C++ and Csound can be counted upon to stick around and maintain backwards compatibility.

Finally, I appreciate and sometimes use the various “front ends” with which Csound has been graced, but I have my own requirements that are not best satisfied by them. For example, I need more widgets on the screen than CsoundQt supports; several for each of dozens of instruments and then dozens for mastering.

Writing my own user interfaces enables me to get what I require. I have tried both the open source Qt widget toolkit, and Csound's built-in FLTK opcodes. The FLTK opcodes do all I need and simplify the code, so that is what I describe here.
##
 II. Method



I have contributed various features to Csound designed to speed up algorithmic composition: the Csound API, the C++ version of the Csound API, and the CsoundAC classes for algorithmic composition [[5]](https://csoundjournal.com/#ref5).

In particular, CsoundAC's MusicModel class encapsulates a music model. This is a directed acyclical graph of musical objects with local transformations of coordinate system that is rendered as a Score object. The MusicModel class also contains Csound and a Csound orchestra for rendering the Score as sound. The Score can reassign the Csound instrument numbers, balance levels, and perform static panning positions in a piece. The MusicModel also can manage the post-processing and translation of the output soundfile [[6]](https://csoundjournal.com/#ref6).

Each composition is a single C++ program in its own directory, where I keep many variations on the original idea. When a piece has been finished, its code can be used as the template for a new piece. Often the only change I make to the code is in the score generating section. Other times I add new Csound instruments to the built-in orchestra, or change details of the instruments. With the score generator and the orchestra removed, a typical composition is shown in the skeleton code, below, for a piece. There is not much to this skeleton, and that is the point. It identifies the composer and the piece, and has places to insert the score generator (line 17) and the orchestra (line 26).
```csound
#include <MusicModel.hpp>
/**
 * All composition and synthesis code is defined in the main function.
 * There is no need for any of this code to be in a separate file.
 */
int main(int argc, const char **argv)
{
    // The MusicModel is... a composition, a model of some music.
    csound::MusicModel model;
    // These fields determine the output filenames and ID 3 tags.
    model.setTitle("\"My Title I\"");
    model.setFilename("My_Title/My_Title_I");
    model.setAlbum("\"My Album\"");
    model.setArtist("\"A. B. Composer\"");
    model.setCopyright("\"(C) 2012 by A. B. Composer\"");

    **// Generate the score here... notes must end up in the MusicModel's Score object.**

    csound::Score &score = model.getScore();

    // The Csound orchestra is embedded as a c++0x multi-line string constant,
    // and of course goes into the Orchestra of the Model.

    model.setCsoundOrchestra(R"(

**; The whole Csound orchestra goes here...**

                             )");
    // This convenience function calls the score generator,
    // renders the output with Csound (or as MIDI),
    // and possibly post-processes the output,
    // all according to the command-line arguments.
    model.processArgv(argc, argv);
}

```


My composing environment is the open source text editor SciTE [[7]](https://csoundjournal.com/#ref7). It is available on Windows, Linux, and OS X. I do everything in SciTE. I have customized it so I can compile a composition, run it, post-process the output soundfile, and hear it in a soundfile editor, all with a single keystroke. Alternatively, I can compile the composition only; compile it and hear a MIDI preview; compile it and hear a MIDI preview on the estimable Pianoteq, a physically modeled grand piano instrument [[8]](https://csoundjournal.com/#ref8); or compile it and hear a Csound rendering in real time. The SciTE editor customization is not extensive, and is included verbatim in this article, below, in Appendix A. You could easily modify it for your own environment, or do much the same thing in another customizable text editor.

To make a new piece, I make a new directory, copy the C++ file and snapshot file for an old piece into the new directory, rename the files and the piece, and rewrite the score generating code. Then I press Control-2 to hear a MIDI preview of the piece. If I don't like it, I change the score generation code and listen again. Then I move to Control-4 to hear the piece in real time (if the computer is able to reproduce it in real time) and to adjust the instrument control and mastering parameters. Finally, I move to Control-5 to produce the final rendering.

 When I finally hear a soundfile I like, I am completely finished with the piece. It comes in normalized mastering quality format, CD audio format, and MP3 format, and each file is appropriately tagged with composer, title, year and copyright, and album.
##
 III. A Very Simple Piece



Example1.cpp, from the downloadable examples, shows the skeleton piece fleshed out with a basic score generator and Csound orchestra. This example does not show off anything fancy about algorithmic composition, but only how to get a generated score into Csound and render it. You can download the code examples for this article, [Gogins_examples.zip](https://csoundjournal.com/Gogins_examples.zip), here.
### The Score Generator


The score generator shown in lines 15 through 36 is the logistic map, a simple chaotic dynamical system. This equation has played an important role in developing our understanding of chaos [[9]](https://csoundjournal.com/#ref9).

Musical events of all kinds are represented as Event objects, which are basically variable-size vectors of real numbers. The semantics of these objects are loosely based on MIDI, with the following extensions:
-

All fields are real numbers, not integers, for greater precision.
-

The event type (or status) is separated from the channel.
-

The channel (or instrument number) can take on any value, and is not limited to the range [0, 15]. Channel 1 corresponds to Csound's `instr 1`.
-

Note On events (status 144) can have durations, in which case a matching Note Off event is not required (this is the case in most audio/MIDI sequencers as well). Status 144 corresponds to Csound's i statement. (MIDI controller events can also be represented.)
-

Event objects know how to translate themselves into Csound i statements.

The MusicModel class itself has a built-in Score object (line 15) whose contents are automatically rendered by Csound. Please note, the Score class has a convenient append method that automatically creates an Event object when passed a list of fields (as in line 34).

The final step in generating this particular score is to call on the Score object to tie overlapping notes (line 36). This is not the same thing as tied notes in Csound. Rather, if an earlier Note On event has an ending time later than the beginning time of a later Note On event with the same channel and pitch, the later note is deleted and the earlier note extended in time.
### The Csound Orchestra


I use the same Csound orchestra in most of my pieces. It keeps growing as I add instruments. It is designed for composition in pitch and time, more than for spectral or sample-based composition. This orchestra is highly modular.

In this piece, the orchestra (lines 38 through 422) contains only one instrument, but everything else is the same as it would be in a more complex orchestra.

All Csound code is embedded directly into the C++ code. This is made possible by the new C++11 feature of raw string literals, which can extend over multiple lines (without escapes, quoting each line, or other tedious and error-prone workarounds). Instead of opening with " and closing with ", a raw literal opens with R"( and closes with )". The orchestra is passed directly to the MusicModel object like this: model.setCsoundOrchestra(R"( ...as much text and as many lines as you like.. )").

At the top of the orchestra (line 44) is the name of the snapshot file that will record the user's adjustments to the graphical user interfaces which some instruments have.

Lines 45 through 55 calculate and print values to help the user manage the dynamics of the piece. The idea is that the user can adjust the master gain, either using a slider widget or by editing the 0dbfs parameter in the orchestra, so that the peak output level is about -6 dBFS, or “normal.” To assist the user in monitoring levels, Csound is configured to print output levels as dBFS, and each instrument definition prints the level specified by its score events as dBA.

Lines 57 through 74 set up the main window for the user interface. In addition, this code calculates the size of a typical tab for an individual instrument user interface, as well as the sizes and spacings of the widgets. These variables make it easier to lay out each widget.

I found that the code for widgets can be interspersed throughout the orchestra code, and even between instrument definitions, as long as the end statements for the widget containers and the final `Flrun` statement follow the last widget definition. This greatly simplifies writing modular orchestras. All user interface code for each instrument definition is written directly above that instrument definition.

For example, the `ModerateFM` instrument in this piece (lines 97 through 160) begins by declaring an FLGROUP container (lines 106 through 120), which will appear as a tab in the FLTABS container that encloses the entire orchestra. Then four FLSLIDERS are declared, with predefined sizes and spacings. Note that the sliders send values to global krate variables, which must be named sensibly to avoid colliding with widget variables in other instruments. Widgets are assigned default values, which take effect only if the snapshot file is missing.

It is a good idea to define a user interface for almost any Csound instrument that has adjustable parameters, even when the objective is a soundfile and not a live performance. That is because every difference in parameter values makes a difference in the sound; every difference in sound makes the piece as a whole either better or worse; and it is faster and more precise to adjust the parameters as a piece is playing in real time, than it is to edit the parameters, render the whole piece, listen to a part of the piece, and repeat. When satisfied with the adjustments, the user can click on the `Save snapshot` button and the values of all FL parameters will be saved in a file that is automatically associated with the piece, and automatically loaded when the piece runs again. If necessary, the values of the widgets in the snapshot file can be edited manually; in some cases this is preferable, e.g., it can be more precise.

The `MasterOutput` instrument in lines 364 through 399 has buttons for saving and loading a single snapshot of the widgets. The instruments that actually do the saving and loading are defined in lines 401 through 416. Notice that the `MasterOutput` instrument, which is always on, contains code for automatically loading the snapshot file, if it exists, at the start of the performance (line 385 through 393).

To return to the `ModerateFM` instrument, global widget variables are used to control the FM carrier frequency ratio relative to the note frequency, the FM modulator ratio, the FM index value, and a value that increases or decreases the effect of the amplitude envelope upon the FM index envelope (lines 142 through 150). This is a rather simple-minded instrument, but a surprising variety of sounds can be created by playing with the sliders.

 Like all my instruments, this one sends or receives audio signals only through the `Signal Flow Graph` opcodes (lines 156 and 157), and it defines all required function tables within the instrument itself, using the `ftgenonce` opcode (line 147). I do not use user-defined opcodes. As a result, all code that executes when an instrument runs is defined by the instrument itself, and this is what enables the instrument and its interface code to be treated as a modular unit that can be cut, pasted, and moved within the orchestra or between orchestras.

In response to the exhortations of Dominique Bassal, who has been insisting for years that even electroacoustic pieces need to be mastered [[10]](https://csoundjournal.com/#ref10), I experimented and found that, indeed, small adjustments to equalization, reverberation, or compression can significantly improve a piece. Therefore, all my Csound orchestras now incorporate a mastering section (lines 162 through 416).

In the orchestra header, the `connect` opcode routes audio signals (lines 79 through 89): from `ModerateFM` to the mastering effects, i.e., from `ModerateFM` to `Reverb`, from `Reverb` to `Compressor`, from `Compressor` to `ParEq1`, from `ParEq1` to `ParEq2`, and from `ParEq2` to `MasterOutput`. The `alwayson` opcode (lines 91 through 95) instantiates the mastering section and keep it running throughout the performance; no score events are needed for this. Each mastering effect has its own user interface.

At the very end of the orchestra (lines 418 through 420), the enclosing FL containers are ended, and the FL opcode starts the FLTK event dispatching thread.
### How it Works


The generation, rendering, and post-processing of the piece is completely controlled by the composition program. Either, or both, of the following methods can be used to actually generate the score:
-

The user may write C++ code of any kind to generate Events and append them to the `MusicModel's Score` object. (The examples in this essay do this.)
-

The user may write C++ code to define a `music graph` in the `MusicModel` object. Music graphs are analogous to scene graphs in three-dimensional computer graphics [[11]](https://csoundjournal.com/#ref11). If there is a music graph, its nodes are traversed depth first to generate and/or transform an `Event` produced by child nodes. (Most of my actual pieces have been done this way.)

The composition program must end by calling the `MusicModel::processArgs` function, which accepts a number of flags and applies the following logic:
-  The command line arguments are parsed into key-value pairs.

- If the --dir <pathname> flag is given, the program changes to the indicated directory and performs all output and post-processing there.

- The `MusicModel::generate` method is called, to actually generate the score. Any Events generated by the music graph are added to any Events that already exist in the `Score` object.

- If the `--midi` flag is given, the composition is saved as a MIDI file. The filename is automatically derived from the root filename of the piece, with a filename extension denoting the format of the file. The same pattern is used for other filenames.

- If the `--playmidi` <application> option is given, the MIDI file is loaded into the indicated application for playback or editing.

- If the `--pianoteq ` option is given, the MIDI file is loaded into Pianoteq for the user to play or render.

- If the `--pianoteq-wav` option is given, the MIDI file is loaded into Pianoteq, which renders it, without a user interface, as a soundfile.

- If the `--csound` flag is given, the generated Score is saved to a Csound .sco file, the embedded orchestra is saved to a Csound .orc file, and Csound is used to render the composition to a high-resolution soundfile.

- If the `--audio` <system> `--device` <id> flags are given, the generated Score is saved to a Csound .sco file, the embedded orchestra is saved to a Csound .orc file, and Csound is used to render the composition to audio, using the appropriate `-+rtaudio=`<system> and `-o`<id> options.

- If the `--post` flag is given, the program automatically translates the high-resolution output soundfile to a normalized high-resolution soundfile, then translates that in turn to a CD-Audio format soundfile and an MP3 format soundfile. All of these files are tagged with the information set in the code.

- If the `--playwav` <application> option is given, the program automatically loads the output soundfile into the indicated application for playback or editing.


During the rendering, Csound's messages are printed to the standard output, which in turn appears in SciTE's output panel. It is possible to end rendering at any time using SciTE's `Stop executing `command.

This automates most all of the housekeeping I need for algorithmic composition, but of course, since pieces are C++ programs, additional features can be added to any piece at any time.
##
 IV. A Real Piece



Example2.cpp, from the downloadable examples, is one of my recent compositions of a real piece of music. The code demonstrates some of the new features of C++11.

 As with the first example, the score is generated directly into the MusicModel's `Score` object.

 The score is generated by a recurrent iterated function system (IFS) [[12]](https://csoundjournal.com/#ref12). A metaphor that has been used to explain such systems is the multiple copy reduction system (MCRM) [[13]](https://csoundjournal.com/#ref13). Imagine a Xerox machine where, instead of a single fixed lens to take the image of the original, there are multiple lenses. Each lens can be adjusted to move, magnify, shrink or stretch, or rotate its image of the original, and each lens can do all of these things at once. When a copy of the original is made, each of the lenses prints its possibly distorted image of the original onto the same copy. Now, imagine that the copy is copied in the same way, the copy of the copy is copied, and so on to infinity. If the lenses tend on the whole to produce smaller images than the original, then after an infinite number of copies, the copied image is fixed. Producing another copy makes no further change to the image. Mathematically, each lens is an affine transformation of the original, and the image after infinite copies is the fixed point or attractor of the system.

 Michael Barnsley's Collage Theorem proves that such IFS can approximate any image or form at all as closely as desired [[14]](https://csoundjournal.com/#ref14), by the simple expedient of covering the target form with a collage of transformed copies of itself. And IFS can produce quite complex forms using only a few affine transformations – this piece is an example.

Here the IFS is not iterated to infinity, but only 11 times. Also, some of the transformations are not simple affine transformations, but also operate upon the harmony of the piece by adjusting notes to fit specific chords. Finally, this IFS is recurrent – that is, there is a table that specifies which transformations can be applied after which transformations. This means different regions of the final score are produced by different sequences of transformations.

Each transformation is implemented using a lambda. A lambda is an anonymous function, that is, a variable that can take any name or no name, but which executes a function when called. The virtues of lambdas are considerable, especially when used with currying (or “captures” in C++ lingo), but it is easier to demonstrate these virtues than to explain them. A lambda with a capture is one kind of “closure.” The use of closures constitutes much of what is meant by “functional programming.”

The code excerpt below, from Example2.cpp, lines 55 through 69 define a lambda that will be used as one of the transformations in the IFS. The `auto` keyword at the beginning of the definition is another new feature of C++: if the type of an object on the right-hand side of an assignment is known to the compiler, then the `auto` keyword declares a variable of that type. In this case, the object on the right-hand side of the assignment operator is a lambda, and the `auto g1 `variable on the left-hand side is automatically of the type of the lambda, and receives its definition as a value. The brackets after the equal sign declare the lambda and define its capture. Any object that is declared within the capture brackets will be in scope of the lambda function when it executes. In this case, the special character "&" indicates that all objects in scope at the time the lambda is defined will be in scope for the lambda, and not only that but by reference, so that changes made to any one of these objects are made to the original object, not a copy of it. This is an enormously powerful feature; in essence, a lambda can act like a member function of a class whose fields consist of every value on the stack. (Allowing references in captures is, perhaps, foreign to the spirit of functional programming, as this permits a closure to execute with side effects.)
```csound

auto g1 = [&](const csound::Event &cursor_, int depth) {
csound::Event cursor = cursor_;
if (depth <= 1) {
return cursor;
}
cursor[csound::Event::TIME] = cursor[csound::Event::TIME] * .66667 + 1.0;
cursor[csound::Event::KEY] = cursor[csound::Event::KEY] *  .66667;
cursor[csound::Event::INSTRUMENT] = 4.0 * 1.0 + double(depth % 4);
cursor[csound::Event::VELOCITY] =  1.0;
score.append(cursor);
if (depth > 2) {
chordsForTimes[cursor[csound::Event::TIME]] = CM9;
}
return cursor;
};
transformations.push_back(g1);
```


 Certain objects are defined above the lambdas, so they will be in scope for the lambdas when they execute. In this case, we want the lambdas to be able to generate notes into a score. The score needs to be in the capture of the lambdas; so the score variable needs to be defined before the lambdas. We also need the chords used by two of the transformations to be defined before the lambdas.

 After the capture, there is an argument list for the function, just as there would be for any other function definition, but there is no function name. That is why a lambda is called an *anonymous* function. The return type of a lambda does not need to be declared.

Each of the lambdas used in the score generator has the same signature. Each lambda takes an `Event `object, *i.e.* a note, and an integer depth; the lambda transforms the note, adds it to the score, and returns a value copy of the transformed note.

Note that a lambda, unlike a regular function, can be defined inside another function, or even inside another lambda. This again increases the expressive power of C++. In fact, the combination of the `auto` keyword, lambdas, and captures give C++ most of the power of a functional programming language like Lisp. The only restriction on functional programming in C++ is that types must be known at compile time, whether by declaration or by inference. It is quite possible to write a complete program in C++ without any regular functions at all except for main, using lambdas inside of lambdas inside of lambdas, just like a Lisp program.

The recurrent IFS itself is defined in the eponymous function `recurrent` (lines 12 through 29). It takes a `std::vector` of transformations, a transition matrix, a depth, the index of the prior transformation, an `Event` representing the current state of the IFS, and a `Score` in which to store the generated notes (Events). The vector of transformations actually contains `std::function` objects with the same signature as the lambdas. Such `std::function` objects can hold either lambdas or regular function pointers, or indeed any callable C++ object, and can be invoked as functions taking arguments and returning values.

What `recurrent` does is decrement the depth of recursion (line 19), then iterate over the list of transformations (line 23). Each transformation, if the transition matrix permits (line 24), is invoked (line 25) to transform (or not) the cursor, which is then recursively passed to recurrent (line 26). This sequence of recursions, filtered by the transition matrix, produces a ramified tree of iterated applications of the transformations and, consequently, a ramified tree of transformed and copied notes.

There are four transformations. Each one shrinks and moves the score onto a corner of itself. This ensures a more or less even distribution of notes in the generated score. In the first transformation (`g1,` in lines 55 through 69), the transformation is not applied on the final layer of recursion. In other words, some of the transformations are applied more often than others. The score is shrunk by 2/3 and moved 1 second forward in time (lines 60 and 61), which copies the score over its later lower corner. The instrument assignment of the notes is mangled (line 62). The loudness of the note is set to 1 (line 63).

The other transformations are similar, but tweaked in various ways. The first copies the score to its later lower corner, the second copies the score to its earlier lower corner, the third to its later higher corner, and the fourth to its earlier higher corner. But these transformations are varied a little in scale to ensure a more elaborate final pattern, and tweaked in other ways. In particular, some transformations produce louder notes than others; this is quite audible in the finished piece. Obviously, these tweaks are made, the score is rendered and heard as a MIDI sketch, more tweaks are made, the score is rendered and heard again.

The first transformation applies the C major 9th chord to the generated notes (lines 65 through 67). The fourth transformation applies the D minor 9th chord to the generated notes (lines 109 through 111). Each chord applies until another chord is scheduled, so not applying any chords in the final two iterations of the IFS has the effect of slowing down the harmony. Again, I experimented to determine the choice of chords, how often to apply them, in which transformations to place them.

The chords are not in any obvious temporal sequence, because the sequence of iteration is not the same thing as the sequence of time; the generated notes are being written into the score at various times as the IFS iterates. So the chords are stored in a `std::map` of chords for times, to be applied to the generated score after `recurrent` has returned. The chords chosen, C major 9th and D minor 9th, can be heard as parts of the C major scale, or as being tonic and subdominant, either of which can follow the other, so the generated harmony is (a) going to sound well-formed in a modal sort of way, and (b) not necessarily be something I would have imagined.

The transition matrix, shown in the code excerpt below from Example2.cpp, is defined in lines 43 through 46 using an Eigen matrix (the Eigen library is currently the leading C++ library for matrix/vector arithmetic and linear algebra; in fact, the `Chord` class itself is derived from an Eigen matrix). Once all the transformation lambdas are defined and stored in the vector of transformations, the `recurrent` function is called and computes the IFS (line 116). The generated score does not come out in a particularly usable tempo or range of pitch, so it is rescaled in lines 119 through 124. Then the chord progression is applied to the score (lines 126 through 132, note the use of the `auto` keyword to declare a reverse iterator for the map). The `apply` function defined in ChordSpace.hpp conforms the pitches in any temporal segment of a score to fit the pitch-classes in a chord.
```csound
void recurrent(std::vector< std::function<csound::Event(const csound::Event &,int)> > &transformations,
	Eigen::MatrixXd &transitions,
	int depth,
	int transformationIndex,
	const csound::Event cursor,
	csound::Score &score)
{
depth = depth - 1;
if (depth == 0) {
	return;
	}
for (int transitionIndex = 0, transitionN = transitions.rows(); transitionIndex < transitionN; ++transitionIndex) {
	if (transitions(transformationIndex, transitionIndex)) {
		auto newCursor = transformations[transitionIndex](cursor, depth);
		recurrent(transformations, transitions, depth, transitionIndex, newCursor, score);
		}

	}

}
```


After the chord progression has been applied, the score is rescaled in time (line 140). Any overlapping notes are tied or combined in line 138. Again, I determined the duration/tempo of the piece and the degree of legato by experiment.

Finally, the new random number facilities of the C++ standard library, which are considerably more sophisticated than those of the C runtime library, are used to randomize the stereo pan of the notes in the score (lines 142 through 146).

The score is now complete.

The all-in-one Csound orchestra complete with mastering section that I mentioned earlier is now embedded in the C++ code, and assigned to the `MusicModel`, in lines 148 through 3593. An arrangement that assigns specific instruments from this orchestra to instruments in the score, and sets their loudnesses, is defined in lines 3595 through 3606.

Finally, at the end of the program, `MusicModel::processArgv` is called to execute the sequence of processing discussed above in **"How it Works"**, to render and post-process the piece.

The first runs were done to MIDI and heard via Pianoteq; when it began to sound like a piece, I rendered to real-time audio and adjusted the widgets in the user interface to optimize the sounds of the instruments, the loudness, the reverb, and so on; then I rendered many times, with many tweaks to the score generating code and the instrument levels, to a high-resolution soundfile with automatic post-processing.

The result can be heard on SoundCloud at [http://soundcloud.com/michael-gogins/example2](http://soundcloud.com/michael-gogins/example2).
##
 Appendix A: SciTE Customization



I have added all necessary customization to the SciTE editor in my .SciTEUser.properties file, which defines a number of custom commands in SciTE's **Tools ** menu. Each menu command actually consists of several sub-commands, separated by semicolons.
```csound
# Custom tools for composing in C++ with SciTE: edit, then hear with one command.

command.name.1.*=Make composition
command.1.*=cd $(FileDir);g++ $(FileName).cpp -o $(FileName) -O2 -g -mtune=native -std=c++0x -I/home/mkg/csound5/H -I/home/mkg/csound5/interfaces -I/home/mkg/csound5/frontends/CsoundAC -L/home/mkg/csound5 -lCsoundAC -lcsnd -lcsound64 -lpthread -lm
command.subsystem.1.*=0

command.name.2.*=Make composition and play MIDI
command.2.*=cd $(FileDir);g++ $(FileName).cpp -o $(FileName) -O2 -g -mtune=native -std=c++0x -I/home/mkg/csound5/H -I/home/mkg/csound5/interfaces -I/home/mkg/csound5/frontends/CsoundAC -L/home/mkg/csound5 -lCsoundAC -lcsnd -lcsound64 -lpthread -lm;./$(FileName) --midi --playmidi timidity
command.subsystem.2.*=0

command.name.3.*=Make composition and play MIDI with Pianoteq
command.3.*=cd $(FileDir);g++ $(FileName).cpp -o $(FileName) -O2 -g -mtune=native -std=c++0x -I/home/mkg/csound5/H -I/home/mkg/csound5/interfaces -I/home/mkg/csound5/frontends/CsoundAC -L/home/mkg/csound5 -lCsoundAC -lcsnd -lcsound64 -lpthread -lm;./$(FileName) --midi --pianoteq
command.subsystem.3.*=0

command.name.4.*=Make composition and render with Csound to audio
command.4.*=cd $(FileDir);g++ $(FileName).cpp -o $(FileName) -O2 -g -mtune=native -std=c++0x -I/home/mkg/csound5/H -I/home/mkg/csound5/interfaces -I/home/mkg/csound5/frontends/CsoundAC -L/home/mkg/csound5 -lCsoundAC -lcsnd -lcsound64 -lpthread -lm;./$(FileName) --dir /home/mkg/Dropbox/music/ --audio alsa --device dac
command.subsystem.4.*=0

command.name.5.*=Make composition and render with Csound and post-process
command.5.*=cd $(FileDir);g++ $(FileName).cpp -o $(FileName) -O2 -g -mtune=native -std=c++0x -I/home/mkg/csound5/H -I/home/mkg/csound5/interfaces -I/home/mkg/csound5/frontends/CsoundAC -L/home/mkg/csound5 -lCsoundAC -lcsnd -lcsound64 -lpthread -lm;./$(FileName) --csound --post --playwav audacity
command.subsystem.5.*=0
```


 The first sub-command changes to the directory containing the composition file.

The second sub-command compiles the composition file. The compiler command assumes that there is one and only one C++ source file, which has the name of the composition plus .cpp, and that the executable output file is simply the name of the composition.

All the necessary compiler options, include paths, library paths, and libraries are specified in the compiler command. There is no makefile because there is no need for a makefile. It would be a completely unnecessary complication.

Note that with current compilers and current computers, you can essentially write your whole piece in one single file, no matter how complex it might be. Creating a bunch of files where one will do fine would also be a completely unnecessary complication.

Note that the composition is built specifically for the native target architecture and optimized. Such code is essentially as fast as possible. The code is also built with debugging information so that, if something goes wrong that I cannot figure out with a few print statements, I can simply debug the composition in Emacs. There is no need for separate debug and release builds – again, that would be a completely unnecessary complication.

Finally, note the `-std=c++0x` option. This enables the compiler to use the new C++11 standard including lambdas, the `auto` keyword, and so on. Doing this makes writing C++ code significantly easier, and I highly recommend it.

The third sub-command actually invokes the composition program. In addition to generating the Csound score, the composition program can do other things, as can be seen from the various options passed to the composition. That is because the `MusicModel` class used by the composition has various built-in options for rendering. But if the built-in options do notsuffice, you can simply add your own sub-commands to the customization.
##  References


 [][1]]Barry Vercoe, John ffitch, et al., *Csound*. Csounds.com, [](http://www.csounds.com/)[Online]. Available: [http://www.csounds.com/](http://www.csounds.com/). [Accessed August 21, 2012].

 [][2]]ISO IEC JTC1/SC22/WG21, 2011. *Standard for Programming Language C++*.[](http://www.csounds.com/) [Online]. Available: [http://www.open-std.org/jtc1/sc22/wg21/docs/standards#14882](http://www.open-std.org/jtc1/sc22/wg21/docs/standards#14882). [Accessed September 29, 2012].

 [][3]]Benoit Jacob, Gael Guennebaud, et al., *Eigen is a C++ template library for linear algebra: matrices, vectors, numerical solvers, and related algorithms*. [Online]. Available: [http://eigen.tuxfamily.org/](http://eigen.tuxfamily.org/index.php?title=Main_Page). [Accessed August 21, 2012].

 [][4]]Martin Gardner, “White Music, Brown Music, Fractal Curves, and 1/f Fluctuations.” Mathematical Recreations, *Scientific American*, pp. 16-32, 1978.

 [][5]]Michael Gogins, *The Csound API Reference Manual*, 2006. [Online]. Available: [http://sourceforge.net/projects/csound/](http://sourceforge.net/projects/csound/). [Accessed September 29, 2012].

 [][6]]Michael Gogins, *A Csound Algorithmic Composition Tutorial*. [Online]. Available: [http://michael-gogins.com/archives/Csound_Algorithmic_Composition_Tutorial.pdf](http://michael-gogins.com/archives/Csound_Algorithmic_Composition_Tutorial.pdf). [Accessed August 21, 2012].

 [][7]]Scintilla, *Scintilla* and *SciTE*. [Online]. Available: [http://www.scintilla.org/](http://www.scintilla.org/). [Accessed August 21, 2012].

 [][8]]Modartt S.A.S, *Pianoteq*. [Online]. Available: [http://www.pianoteq.com/](http://www.pianoteq.com/). [Accessed October 6, 2012].

 [][9]]Marcel Ausloos and Michel Dirickx (Eds.), *The Logistic Map and the Route to Chaos : From the Beginnings to Modern Applications*. Springer, 2006.

 [][10]]Dominique Bassal, Ed., “Mastering en electroacoustique: un etat des lieux.”* eContact!9.3, *2009, [Online]. Available: [http://cec.sonus.ca/econtact/9_3](http://cec.sonus.ca/econtact/9_3)/. [Accessed September 29, 2012].

 [][11]]Michael Gogins, “Music Graphs for Algorithmic Composition and Synthesis with an Extensible Implementation in Java,” In Proceedings of the International Computer Music Conference, September, 1998.

 [][12]]Michael F. Barnsley, *Fractals Everwhere*, 2nd edition. Academic Press, pp. 379 ff., 1993.

 [][13]]Heinz-Otto Pietgen, Hartmut Jurgens, and Deitmar Saupe, *Chaos and Fractals: New Frontiers of Science*. Springer, pp. 23-26, 1992.

 [][14]]Michael F. Barnsley, *Fractals Everwhere*, 2nd edition. Academic Press, pp. 94-104, 392-403, 1993.
