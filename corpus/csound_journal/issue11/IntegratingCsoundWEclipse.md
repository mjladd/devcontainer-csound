---
source: Csound Journal
issue: 11
title: "Integrating Csound with Eclipse"
author: "subjects in"
url: https://csoundjournal.com/issue11/IntegratingCsoundWEclipse.html
---

# Integrating Csound with Eclipse

**Author:** subjects in
**Issue:** 11
**Source:** [Csound Journal](https://csoundjournal.com/issue11/IntegratingCsoundWEclipse.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 11](https://csoundjournal.com/index.html)
## Integrating Csound with Eclipse

### Listening to Software Under Development
 Lewis Berman and Keith Gallagher
 University of Durham
 l.i.berman@durham.ac.uk
 k.b.gallagher@durham.ac.uk
## Introduction


 Sound has been shown to be useful in understanding a software program. One can run the program and listen to the dynamic operation of the source code in various ways. Algorithms can be heard as they execute through mapping statements such as loop variables to characteristic sounds. Compound sounds such as musical chords can be constructed as greater loop nesting levels occur [[1]](https://csoundjournal.com/#ref1). The static structure of the code can also be heard. That is, sounds can communicate information about elements of the source code in a language such as Java.

 The authors previously utilized Csound to sonify program slices, which are the collections of source code that influence or are influenced by a given point in a program [[2]](https://csoundjournal.com/#ref1). The generated sounds were of a high level of sophistication, including reprocessed musical instrument sounds and granular synthesis. These representations were received favorably by subjects in a qualitative study.

 The authors are currently working on experiments with sound to help software developers identify and describe the static architecture, namely the packages, classes, and methods, of a Java program. One can hear whether a particular element is a package, class, or method. Moreover, one can hear certain measures, such as the size of a class, and attributes such as whether a method is static. A wide variety of sounds is needed in order to meaningfully represent the structure of a program of significant size. Csound is the ideal vehicle for obtaining such variety.

 To this end, the authors have integrated Csound as an audio back-end to the Eclipse software development environment [[3]](https://csoundjournal.com/#ref1). A software developer can select items in the software project being worked on in Eclipse and listen to them. Score statements are sent in real time from Eclipse to Csound, which in turn produces the sounds. This paper discusses how the integration has been accomplished. Section I describes how and why the user interacts with Eclipse to obtain sounds. Section II discusses the architecture of the integrated system. Section III describes the implementation of the Eclipse plug-in, the socket interface between Eclipse and Csound, and the Csound Orchestra and Score.
##
 I. Using Eclipse to Listen to Software



 Eclipse is an open-source, integrated software development environment (IDE), comparable to Microsoft's Visual Studio. Using Eclipse, a developer can bring up a variety of browsers and editors to view and maintain the source code, or the developer can invoke a debugger to perform just-in-time compilation, run the code, and pause at breakpoints. Eclipse supports a variety of languages, including Java.
### Scenario


 Suppose that you are a software developer, and you are told that you must complete an unfamiliar software project in progress. You load the Java source code into an Eclipse IDE. Your initial goal is to gain an overview of the project, namely its lower-level architecture. You have questions such as these: "What is the arrangement of the packages, classes, and methods? Are they grouped into client and server layers? Is there a package or set of packages that strictly deal with database access, or are database accesses distributed throughout the code? Which classes perform active computation, and which are passive repositories of run-time information?"  As you explore the software project, you select various elements: packages, their classes, and the methods within each class, listening to information about each selected element. You may listen to, for example, a method that stores data in a database. A background sound indicates that the element of interest is a method. A foreground pattern of musical notes is the element's signature - it uniquely identifies the method. The musical pattern is one you recognize as indicating that the method performs data storage. (It is an ascending pattern of notes, and you have been trained to recognize this as a storage signature.) The other methods in the encompassing class similarly indicate data storage or retrieval, telling you that the class itself is all about accessing the database. You can garner all this information just by listening, without reading a single line of code.
### The Package Explorer


 Eclipse has a Package Explorer that allows the developer to view the Java packages, classes, interfaces, and methods within each project. Figure 1 shows a simple software project in the Package Explorer. Both packages have been expanded to show the classes and interfaces they contain. The class EnglishLanguage has been expanded to show its two methods. The Package Explorer is the venue for selecting packages, classes, and methods to listen to.

![](images/figure1_explorer.png) **Figure 1.** A software project in the Eclipse Package Explorer.
### The Sonify View


 Eclipse, being modular and extendable, offers the ability to build custom plugins and views. The custom Sonify View has been built to provide control over what is heard. The Sonify View is depicted in Figure 2.

![](images/figure2_sonify_view.png) **Figure 2.** The Sonify View.

 The Eclipse user initializes the sound production system via a pull-down menu item in the Sonify View. The View's buttons, except for the top button, control what is heard: the entity (package, class, or method), that has been selected in the Package Explorer, the selected entity's parent (such as the parent class of a selected method), etc. The top button actually plays the sound pattern. For example, if method retrieveHello() has been selected in the Package Explorer, My parents has been clicked to turn it on, and Play is clicked, the sound representing the EnglishLanguage Class will be heard.
## II. Architecture



 Eclipse is extended by building custom collections of code known as plugins. The Sonification Plugin extends Eclipse to offer user control of what is heard and to send score statements to Csound. The Sonify View introduced above is part of the Sonification Plugin. To produce sounds, Cscore statements are sent from Eclipse to Csound via a TCP/IP socket interface. The score statements are received by a program known as Socketreader, which in turn serves as an input stream to Csound. The system architecture is shown in Figure 3. The system has been implemented under Eclipse Europa, Java 6, and Csound 5 under SuSe Linux 11.1.

![](images/figure3_Architecture2.png) **Figure 3.** System Architecture.

 To start the system, the user brings up Eclipse and invokes the Socketreader/Csound combination via a shell script. Csound waits for input from Socketreader, and Socketreader listens for requests on a designated TCP/IP port. An initialization command from the Sonify View causes a socket connection request to be issued, and a resulting TCP/IP connection is established, remaining active until it is shut down. An orchestra file is loaded, and initialization-time score statements are processed.

 The user proceeds to browse the software project, select packages, classes, and methods, open them in editors, etc., performing typical work in Eclipse. Each time the play button in the Sonify View is clicked with an entity selected in the Package Explorer, an appropriate set of score statements is formulated and sent over the socket interface via Socketreader to Csound.

 To properly shut down the system, the user exits Eclipse and invokes a cleanup shell script to stop the Socketreader program's Java Virtual Machine and the Csound process.
## III. Implementation


### Eclipse Sonification Plugin


 The Sonification Plugin has the following key components:

 1. The Sonify View, with event handlers to process its selections and the Play button

 2. Event handlers to process selections in the Package Explorer

 3. Code that constructs score commands for Csound

 4. The sending socket

 When a button in the Sonify View is clicked, an event handler is activated. If the button controls what is played (Myself, My parent, etc.), the event handler communicates this to the sound system. If the button is the Play button, the event handler invokes a method that causes the appropriate sound to be determined (or constructed) and sent to Csound via the socket interface.

 Event handlers are also invoked when items in the Package Explorer are clicked. The selected item becomes the "current" item, to be played when the Play button is clicked.

 When *Play* is clicked, the plugin consults a stored list that maps each software entity to a set of score statements. Like the initialization statements above, multiple score statements comprising a set may be played at specified intervals. The following Java code associates a given entity, *commonPackage*, with a set of three concatenated score statements:
```csound
e.add(new EntitySoundDescriptor(sonify.languageFeature.PACKAGE,
 "commonPackage", "i10 0.0 5.58 45 1 16 7000\ni11 1.1 0.3 45 1 10000 891
 1\ni11 2.9 0.3 45 1 10000 891 1\n"));

```


 The string containing the three statements is sent through the socket interface. Each individual score statement is terminated by a line break ("\n"). Comment lines cannot be placed in the real-time stream.
### Socket Interface
 The socket interface is straightforward. A Java method, *establishConnection()* in the Sonification Plugin, creates a new socket on a high-numbered port, establishing a connection with the listener socket in Socketreader. Immediately thereafter, *establishConnection()* reads the initialization score file and sends its contents through the connection, establishing Csound functions and starting the global reverberation instrument. Sets of score statements such as that above for *commonPackage* are sent in real-time, the buffer being flushed after every send.
### Csound Programming
 Csound is invoked by a shell script for real-time input and processing of score commands. The key shell script line is shown below:
```csound

java socketreader | /usr/local/bin/csound -h -d -score-in=stdin -o
 devaudio ./SonifEntities.orc &

```


The standard output of Socketreader is piped into the standard input of Csound. The output of Csound is directed to the computer's audio card.

The global reverberation instrument is started and directed to run for many hours, longer than the expected length of any usage of the system. This has the effect of keeping Csound running as well as providing consistent reverberation for participating instruments, giving the listener the impression that they are in one physical space. At initialization time, the external score file is processed. Statements from the beginning and end of the initialization-time score file are shown below:
```csound
f1 0 1025 10 1
f2 0 1025 10 1 1 1 1 1 1 1 1 1 1 1
f3 0 1025 17  0 1  820 0
f4 0 0 1 "anvil.wav" 0 0 0
[...]
i999 0 740000
i520 0.0 2.0  7000   55.0  8.00
i521 1.8 2.6  8000  440.0  1.00
```


Initialization includes function declarations and instrument-play statements. Some of the functions in the f statements are existing sound files for playthrough or further processing, such as "anvil.wav" in the above f statement f4. I999 is the global reverberation instrument, which runs for 740,000 seconds. I520 and 521 are sounds played at initialization 1.8 seconds apart to tell the listener that the system is in correct working order. The two sounds overlap, as the first has a duration of 2.0 seconds. There is no e or s statement at the end of the initialization file; Csound simply waits for more score statements.

After initialization, subsequent sets of score statements are all piped to Csound from Eclipse each time the play button is clicked. The Csound string shown in the Eclipse Sonification Plugin subsection above results in execution of the following sequence of three Csound statements:
```csound
i10 0.0 5.58 45 1 16 7000
i11 1.1 0.3 45 1 10000 891 1
i11 2.9 0.3 45 1 10000 891 1
```


Time 0.0 represents the time the statements are received as input to Csound. Instrument I10 is heard immediately, providing a wind-like background sound for 5.58 seconds, over which two tones are heard. I11, providing the first overlaid tone, is invoked 1.1 seconds after I10, and I11 is again invoked for the second tone 2.9 seconds after I10. The underlying, 5.58 second sound distinguishes the entity as a class, while the superimposed sounds identify the specific class.
### Improvements


The *Play* button could be dispensed with entirely. Instead, a sound could be played upon clicking the item in the Package Explorer. Mouseover events could also be intercepted to result in sound. That may require some decision logic for playing the sounds, as a user could mouse over many items much faster than they could be played.

Sound patterns are preselected from those encoded into the Eclipse extension for the software project at hand. To make the system into a generally usable tool, the sounds must be constructed using more advanced sound construction logic.

The system is currently implemented only under Linux or other Unix-based operating systems. Csound appears to be incapable of using Socketreader as a "standard input" front end under Windows; the real-time score statements do not flush while the system is running. Research must be done to uncover a workable method of receiving the score statements under Windows.
## IV. In Conclusion



The system described above is currently in use to support program comprehension research. Thanks to the level of sophistication that can be achieved via Csound, this research has the potential to determine the effect of overlaid sounds, sequential sounds, and localization on the recognition and comprehension of software objects. Musical, environmental, and abstract sound universes for program comprehension can be explored. The findings can be extrapolated to other domains in which sound may be a useful tool to support comprehension tasks.

Readers interested in sonification research should consult the website of the International Community for Auditory Display [[4]](https://csoundjournal.com/#ref1).
## References



 [][1] Vickers, P. and Alty, J. "Siren Songs and Swan Songs: Debugging with Music." In Communications of the ACM, Vol. 46, No. 7, July 2003, pp. 87-92.

 [][2] Berman, L. and Gallagher, K. "Listening to Program Slices." In Proceedings of the 12th International Conference on Auditory Display (ICAD), London, UK, June 20-23, 2006.

 [][3]] Eclipse Foundation, [ http://www.eclipse.org/](http://www.eclipse.org/")

 [][4]] International Community for Auditory Display (ICAD), [ http://www.icad.org/](http://www.icad.org/)
