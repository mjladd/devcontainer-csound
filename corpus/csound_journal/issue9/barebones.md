---
source: Csound Journal
issue: 9
title: "A minimal realtime algorithmic system: "Barebones""
author: "the system"
url: https://csoundjournal.com/issue9/barebones.html
---

# A minimal realtime algorithmic system: "Barebones"

**Author:** the system
**Issue:** 9
**Source:** [Csound Journal](https://csoundjournal.com/issue9/barebones.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 9](https://csoundjournal.com/index.html)


## A minimal realtime algorithmic system: "Barebones"
 Øyvind Brandtsegg
 obrandts AT gmail.com

This article is the third in the series "Building a modular system for realtime algorithmic composition and improvisation". The articles in this series can justly be described as a "work in progress", as the topic (the modular system) has been developed alongside the writing of the articles. The first article appeared in the *Csound Journal* in the Fall 2005 issue, and describes in a general manner the modular approach to building the system. The second article (Spring 2006 issue) describes an example application using the Csound API and Python. In hindsight, I realize that the second article actually centers more around a specific composition module ("ruleChorale", later named "intervalMelody") than it does describe the actual composition system in which the composition module is used.

The main focus of this article is to show a minimal system for realtime algorithmic composition using Python and Csound. Effort has been made to make it as simple as possible while retaining the essential functionality needed to compose music in realtime. This barebones system does not provide a graphical user interface and no midi input, it is intended to be used with a text-based interface as this is technically the simplest implementation. Using the text interface also forces the user to think about what commands are actually processed by the system, and as such it may provide a pedagogical aspect. Keep in mind that this system in its current state is not able to make interesting music, but it provides a technical framework for realtime composition. The musically interesting bits are to be added by you, dear reader. As will be shown, implementing the actual compositional modules is pretty easy, once you understand how the modular system works. An added bonus when implementing new compositional modules, is that they will most probably be useable "as is" in the much larger and more complex realtime system "ImproSculpt" [[1]](https://csoundjournal.com/#ref1), as ImproSculpt uses the same modular structure [[2]](https://csoundjournal.com/#ref2) (essentially, the Barebones system is ImproSculpt stripped down to the absolute minimum).

The audio output routing of Barebones has been simplified (only a stereo master audio out, and one effects send), and the audio instruments has been simplified to use only a sine wave generator and a simple sample playback instrument. The reader is encouraged to include their own instrument designs, along with their own compositional modules.

This article will give a general description of the system, followed by a more detailed view of the parts of the source code that the reader might want to modify. The source code can be downloaded [here](https://csoundjournal.com/barebones.zip). Some knowledge of Python will help in understanding the issues described, as the article will refer to the Barebones source code.


- [Overview](https://csoundjournal.com/#_Toc201339558)
- [The Directories and Modules of the System](https://csoundjournal.com/#_Toc201339559)
  - [Directory Structure](https://csoundjournal.com/#_Toc201339560)
  - [Modules](https://csoundjournal.com/#_Toc201339561)
    - [main](https://csoundjournal.com/#_Toc201339562)
    - [eventCaller](https://csoundjournal.com/#_Toc201339563)
    - [theTime](https://csoundjournal.com/#_Toc201339564)
    - [csModule](https://csoundjournal.com/#_Toc201339565)
    - [csMessages](https://csoundjournal.com/#_Toc201339566)
- [randMelody � an Example Composition Module](https://csoundjournal.com/#_Toc201339567)
- [The Csound Orchestra](https://csoundjournal.com/#_Toc201339568)
- [The Csound Score](https://csoundjournal.com/#_Toc201339569)
- [System Requirements](https://csoundjournal.com/#_Toc201339570)
- [Running the Application](https://csoundjournal.com/#_Toc201339571)
- [Documentation](https://csoundjournal.com/#_Toc201339572)
- [The Key to the System: Implementing Your Own Composition Modules](https://csoundjournal.com/#_Toc201339573)
    - [The Composition Algorithm](https://csoundjournal.com/#_Toc201339574)
    - [Changing the Compositional Variables](https://csoundjournal.com/#_Toc201339575)
  - [Test Routine for the Composition Class](https://csoundjournal.com/#_Toc201339576)
  - [Integrating the New Composition Module into the Barebones System](https://csoundjournal.com/#_Toc201339577)
    - [Testing Your New Composition Module](https://csoundjournal.com/#_Toc201339578)
- [Interface to Other Libraries for Algorithmic Composition](https://csoundjournal.com/#_Toc201339579)
- [Conclusion](https://csoundjournal.com/#_Toc201339580)
- [Thanks](https://csoundjournal.com/#_Toc201339581)
- [References](https://csoundjournal.com/#references)
## []Overview


The system "composes" by calculating the parameters for one event (e.g. a note) at a time. A brief explanation of the signal flow through the system might provide a key to understanding how it all fits together. A compositional process is initiated by the user by a typed statement at the command prompt (terminal style text interface to the main module, see Fig 1). Typically, this statement will call a method of the eventCaller, initiating the performance of a composition process. A composition process is an iteration on the event level, generating one event (e.g. a note) at a time. The basic functionality for this iterative process is provided by a base composition class (baseComp.py), and specific compositional techniques should be implemented by subclassing (e.g. randMelody.py). An iteration of the composition process can be explained in a simplified manner like this:

The composition module's `perform()` method calls the `playEvent()` method, which in turn calls the getData() method. The specifics of the `getData()` method will vary according to the compositional technique used, but in general we can say that some parameter data (e.g. pitch, amplitude and so on) is generated. The event data is returned to playEvent, which in turn sends the event to Csound. Then, a "next" event is placed into the timed queue with an appropriate delta time (time until the next event in our composition). When the next event is due, the timed queue will dispatch the event to eventCaller.parseEvent(), which in turn calls the composition module's perform method and the iteration loop starts over. This constitutes the typical processing loop of the barebones system.

![image](images/barebones/image001.gif)

 **Figure 1.** Basic flow of calls in the Barebones system.

After the call from theTime to eventCaller (the arrow number 6), the loop may start over with another call to the composition module (arrow number 2).
##
[The Directories and Modules of the System]



The following describes the directory structure of the source code, and briefly explains the task of each module of the Barebones system.
### [Directory Structure]


*/root*

The directory (name of your choice) where you've unpacked the source code. This directory contains the main.py file, the Csound orchestra and score files, and the file csoundCommandline.py (containing the Csound commandline options, e.g. for setting the audio output device). It also contains the file constants.py, defining some global constants.

*/comp*

This directory contains all composition modules.

*/control*

This directory contains the eventCaller module and the timing modules (theTime.py and theTime2.py).

*/cs*

This directory contains the module for running Csound (csModule.py), and the module collecting all communication with Csound (csMessages.py).

*/docs*

This directory contains documentation for the barebones system. The current documentation is an API style source code documentation, autogenerated with Epydoc.

*/samples*

This directory contains any and all audio samples needed by the Csound orchestra.
### [Modules]

#### [main]


The main module instantiates other modules (eventCaller, theTime, csound), and runs the command line text interface. The text interface has a few predefined shortcut commands (perform and setParameter) for controlling he composition processes, and it can also send instrument events to Csound directly (if the command starts with an "i"). Finally, if the typed command is "stop", the application will exit. If the typed command does not comply with any of the predefined shortcut commands, Barebones will try to interpret the command as a Python code object and execute it.
#### [eventCaller]


The eventCaller module provides the modular centerpiece for the application, in that it is responsible for communication with composition module, sending events to the Csound module for playback, and putting future events into the timed queue.
#### [theTime]


The time module contains basic clock and tempo functions, and polls the timed queue for events periodically. Several timed queues can coexist (as instances of theTime), each running at a separate tempo, for example we could have one "clock" queue (one beat per second) and one "bpm" queue with a variable beats per minute tempo. These are instantiated in the eventCaller module. Actually, two types of timing (clock functions) can be used; one relaxed clock and one precise clock (synchronized to Csound's k-rate). Although this dual clock implementation complicates the system a little bit, I do feel it is needed to provide several alternatives for the clock functions as there is a conceptual problem related to realtime composition event scheduling [[3]](https://csoundjournal.com/#ref3). Complex compositional algorithms may be implemented using the relaxed clock module (theTime.py), so as not to interfere with the audio processing loop. Obviously, simpler compositional modules will benefit from better timing by using the more precise clock (theTime2.py).
#### [csModule]


The csModule sets up Csound with the appropriate orchestra, score and command line options. Csound will run in its own thread, controlled from this module. The only thing out of the ordinary in this module is that a clock tick will be sent to theTime module once every Csound k-period pass, effectively synchronizing theTime module to Csound's k-rate clock.
#### [csMessages]


The csMessages module acts as a "collector" module for all communication between Python and Csound. Basically, the module only contains wrapper functions for csoundAPI calls.
## [randMelody � an Example Composition Module]


This is a very simple composition module, just as a technical demonstration of how a composition module might be accessed in the Barebones system. It generates melodies with a limited random selection of pitch, delta and duration.

The method `getData()` will return the parameters for the next note in the melody. To modify parameters of the composition module instance, the method `setParameter()` can be used.
## [The Csound Orchestra]


The orchestra contains two simple audio generator instruments, a global reverb effect, a master audio output instrument, and an instrument for recording audio to a file during a realtime session.

The two audio generating instruments use 7 p-fields (as in the standard Csound score notation), these are: instrument number, start time, duration, amplitude, pitch, pan and reverb send amount. We will normally use a start time of zero for realtime performance, meaning that the event should be played "now", i.e. as soon as Csound receives the event.� Amplitude is given in negative dB (where 0dB is maximum amplitude). Pitch is given as a note number, similar to a midi note number (where 60 is middle C). The pan parameter has a range of 0.0 to 1.0, with 0.0 being hard left and 1.0 being hard right. The reverb send amount is usually listed in the range 0.0 to 1.0, but higher values are not illegal.

The audio generating instruments do not output audio directly to the sound card, rather they send audio to mixing and effects processing instruments via the chn bus [[4]](https://csoundjournal.com/#ref4). The chn bus is also used for audio transport to the file recording instrument.

The "reverb" and "master audio out" instruments should always be active. In the Barebones system, such "always on" instruments are activated in the eventCaller.initValues() method by sending instrument events to Csound from there.

The "record to file" instrument will record the master audio out signal to a file (the output file will be placed in the root directory of the Barebones system). This instrument can be enabled by typing
```csound
eventCaller.recordAudio(START, 'filename.wav')
```
 on the command line. The filename must be written in single quotes (as it is a string), though the name can be freely chosen as long as it ends with ".wav". You can stop recording by typing the following command.
```csound
eventCaller.recordAudio(STOP)
```
 Beware, *recording audio will always overwrite an existing file without asking*. If you want to make sure the recording is safe, create a copy of it somewhere else on your hard drive.
## [The Csound Score]


The score only contains a dummy event to keep Csound running for the specified amount of time. The total running time is defined by changing the value assigned to $scorelen.
## [System Requirements]


You need Python (2.5) and Csound (5.08) installed on your computer to run the application.

Python is available from [www.python.org](http://www.python.org/).

Csound is available from [www.csounds.com](http://www.csounds.com/)

To update the documentation (not strictly needed, but it is useful if you edit the source code by adding composition modules etc), you will also need Epydoc installed on your system. Epydoc is available from [http://epydoc.sourceforge.net/](http://epydoc.sourceforge.net/)
## [Running the Application]


Download and unpack [the source code](https://csoundjournal.com/barebones.zip) to a directory of your choice.

Selection of audio and midi devices, as well as buffer sizes and other Csound related flags must be done in the "csoundCommandline.py" file located in the root directory of the Barebones system. Edit this file in any text editor. The file contains the Csound command line flags, for a description of the different flags see the *Csound Manual* at [http://www.csounds.com/manual/html/CommandFlagsCategory.html](http://www.csounds.com/manual/html/CommandFlagsCategory.html)

To run the application, type the following in a terminal window and hit enter:
```csound
python main.py
```


To test the application, type an example command:
```csound
perform(rMelody1, START)
```


Wait for a while, hear a few melodic notes played, then change the pitches used for the melody by typing:
```csound
setParameter(rMelody, 'pitches', [73,74,75,76])
```


Hear a few more notes, and change the pitches again:
```csound
setParameter(rMelody, 'pitches', [60,63,65,67])
```


Wait for a while, hear a few melodic notes played, then type:
```csound
perform(rMelody1, STOP)
```


to stop the melody generator.

Then type:
```csound
stop

```


to exit the application.
## [Documentation]


Source code documentation for Barebones exists in HTML format in the directory /docs. The documentation was autogenerated using [Epydoc](http://epydoc.sourceforge.net/). To update the documentation (e.g. after you have edited the source code and documentation), simply enter the following in a terminal window:
```csound
python epydoc.py --config epydoc_config.txt
```


On some platforms you might be required to enter the full path to the Epydoc file, on Windows this is usually something like `C:\Python25\Scripts\epydoc.py`, and the full command will look like this:
```csound
python C:\Python25\Scripts\epydoc.py --config epydoc_config.txt
```


The file epydoc_config.txt sets the options for generating the documentation. You do not need to edit this file unless you want to customize the look of the generated HTML files.

When editing the Barebones source code, it is strongly recommended that you document your code using triple-quote strings. The docstring should be placed *after* the item to be documented, like this:
```csound
���
def setParameter(self, parameter, value):��
    """
    Set a class variable.��

    @param self: The object pointer.��
    @param parameter: The variable name.��
    @param value: The value to set the variable to.
    """
```


It is also customary to document each file with a short description of its contents, for example:
```csound
"""
RandMelody.

A test composition module, as a simple example of how to use the software
architecture "barebones".

@author: Øyvind Brandtsegg
@contact: obrandts@gmail.com
@license: GPL
"""
```


You may use epytext "tags" (e.g. @author, @param, @return etc.) to document specific features or arguments. For an overview of epytext syntax, see:

[http://epydoc.sourceforge.net/manual-epytext.html](http://epydoc.sourceforge.net/manual-epytext.html)
## [The Key to the System: Implementing Your Own Composition Modules]


The included composition module "randMelody" provides a template for implementing your own composition module in Barebones. You should write your module in a separate file (e.g. myCompositionModule.py), and implement it by subclassing BaseComp (of the module baseComp.py) in the same manner as the RandMelody class.

A composition module will in most circumstances generate some data on the basis of some sound which is being produced. This is facilitated by the `getData()` method of the composition class. This could for example be used to generate new audio events, or to modify the timbral characteristics of one long sustained audio event. The composition base class (baseComp.py) uses the following parameters for note events: instrument number, duration, amp, pitch, pan, reverb. In case you want to change this parameter configuration, you can override the `playEvent()` method when implementing your own composition class.

Take a look at the source code for the included composition module, in the file "randMelody.py". It should be relatively easy to understand if you know Python and know how to implement and instantiate classes. You should also take a look at the BaseComp class of the "baseComp" module, from which the RandMelody class inherits by way of subclassing.
#### []The Composition Algorithm


The getData() method of a composition module is where you will implement the specifics of the composition algorithm you want to use. As you can see, the RandMelody.getData() method is very simple, choosing randomly from a list of values for each different parameter (for pitch, duration and delta). Some parameters are static (amp, pan and reverb).

For some types of composition algorithms, you might need to generate a list of several values and then read these values one at a time (one per note event). In this case, you could store the list of values in a temporary class variable, and generate a new set of values when the temporary list has been exhausted. I have provided another simple example (serialMelody.py) to show how this can be done.

 The following example shows a getData() method, using only static parameter variables.
```csound

def getData(self):
    """
    Get parameter values for the next event in the composition.

    @param self: The object pointer.
    """
    instrument = 1 # csound instrument number
    amp = -5 # amplitude (in decibel)
    pitch = 60 # pitch (in note number)
    delta = # time until the next event after this one (in beats)
    duration = 1 # legato (duration equals delta time)
    pan = 0.5 # center panning
    reverb = 0.3 # add a touch of reverb
    return instrument, amp, pitch, delta, duration, pan, reverb
```

#### []Changing the Compositional Variables


At any time (even in the middle of a melodic phrase), you may change the variables governing the composition process. These variables are stored in the composition module. For example, you might want to change the collection of pitches that are used to generate the melody. This is the purpose of the eventCaller.setParameter() method. Basically, the call is just forwarded to a method of the composition class, where the variable (parameter) is set to a new value. The parameter argument to this method is a string giving the name of the parameter we want to change. The name must correspond to a parameter name implemented in the composition class's `setParameter()` method. Do take a look at the source code at line 62 in the file comp/randMelody.py to see how the method `setParameter()` is implemented in the composition class. When implementing your own composition module, this method should have one line (an if-statement) for each parameter you want to change. The parameter name is arbitrary, it is just a string that we can use to parse the call correctly, setting the right variable to a new value. I did use, for example, 'pitches' to refer to the variable self.pitches in the composition class.
### []Test Routine for the Composition Class]


I do recommend writing a simple test routine for your new composition module, where it can be tested when run as "main". To run it as main means to execute the python file as a program, as opposed to importing it into another program. You run it as main simply by executing the myCompositionModule.py file with python, e.g.:
```csound
python myCompositionModule.py
```


Writing such a test is a small task, the main point of the test is to see that your composition class works the way you intended. Testing it separately like this makes it much easier to isolate a potential bug or error in your code. For an example, see the randMelody.py file. Basically, you put this test at the end of the file, first checking if it is run as main:
```csound

if __name__ == '__main__':

```


Then instantiate the composition class
```csound

    r = RandMelody()
```


and call
```csound

    r.nextNote()
```


 a few times, printing the result to see if the output fits your expectations. Again, refer to the source code of "randMelody.py" to see how a simple test routine can be implemented, and try to run randMelody.py as main to see how it works.
### []Integrating the New Compositon Module into the Barebones System]


The composition module should be saved to the directory /comp, and it will be available for use in the same manner as other composition modules of the system. You will have to make some small additions to the file /control/eventCaller.py to actually load and use your new composition module. These additions can be summed up as follows:
- Import the composition module into the eventCaller
- Instantiate the composition module's composition class

 Take a look at the source code for eventCaller.py, on line 17:
```csound

import comp.randMelody
```


This imports the randMelody module (the file /comp/randMelody.py). To import your composition module you should add something like:
```csound

import comp.myCompositionModule
```


Next, look at line 40 of eventCaller.py:
```csound

    self.rMelody1 = comp.randMelody.RandMelody()
    """Instance of the RandMelody composition class."""

    self.rMelody2 = comp.randMelody.RandMelody()
    """Instance of the RandMelody composition class."""
```


 Here we make two instances of the RandMelody composition class, in this case we use two instances as we want to be able to generate two independent simultaneous voices using this composition class. When implementing your own composition module, you must make an instance of your composition class by adding something like:
```csound

    self.myMelody = comp.myCompositionModule.MyCompositionClass()
    """Instance of the MyCompositionClass composition class."""
```

#### []Testing Your New Composition Module


Start the Barebones system (run the main.py file). When the system is ready, type:
```csound

perform(myMelody, START)
```


 to start generating notes with your new composition module, then type
```csound

perform(myMelody, STOP)
```


to stop the composition module.
## []Interfacing to Other Libraries for Algorithmic Composition


Using the current architecture, it will be possible to create interfaces to existing libraries for algorithmic composition. Christopher Ariza's excellent article "Python at the Control Rate: athenaCL Generators as Csound Signals" (in this issue of the Csound Journal) on using athenaCL [[5]](https://csoundjournal.com/#ref5) with Csound's python opcodes might be a good starting point to create an interface to some of athenaCL's compositional methods. In a similar manner, I expect it will be possible to interface to Michael Gogins' algorithmic composition library for Csound (CsoundAC [[6]](https://csoundjournal.com/#ref6)). Obviously, some algorithmic composition techniques are not suitable for realtime composition, so it might be conceptually impossible to exploit the full potential of such libraries/applications/toolboxes as AthenaCL and CsoundAC in a realtime system like Barebones. However, I'm sure there's a lot to be gained by borrowing bits and pieces, possibly assembling them in new ways to accommodate a realtime strategy.

For simplicity (and I must admit, also for lack of time), such interfaces have been left out of this article. Unless someone beats me to it, I will write a later article about interfacing Barebones to AthenaCL and CsoundAC.
## []Conclusion
 The article shows a description and an implementation of a modular software system for a minimal realtime algorithmic composition using Python and Csound. The source code for the system is available for download here, and since Python is an interpreted language, the source code is all you need to run the application. A description on how to extend the system by adding new compositional modules has been provided, and interfacing to other compositional libraries has been suggested.
## []Thanks


I'm indebted to the Csound developers for making it all possible. I'm also grateful towards the Csound user community, for asking and answering questions, and for making lots of interesting stuff happen.

Thanks to Eirik Blekesaunet for helping with revision and testing of the Barebones system during spring 2008. Also, thanks to the students at "Sound in public spaces II" 2008 (Music technology / NTNU) for being the first test developers using the Barebones system to create compositional modules. Special thanks to Steven Yi for helpful suggestions on implementation specific issues.

## []References


[[1]] [http://sourceforge.net/projects/improsculpt](http://sourceforge.net/projects/improsculpt)

[[2]] Some minor modifications to ImproSculpt are underway to facilitate easy plugin of custom composition modules. It is possible to use your custom composition modules in the current ImproSculpt architecture too, but it will become even easier in the upcoming version.

[[3]] The problem of realtime event scheduling: A composition module generates data on the basis of the current "environment" (what the other simultaneously playing voices of the system are doing, possibly also analyzing external audio input for parameters). The selection procedure in a composition module should optimally be done at the time a new event is to be played, if it is done earlier, the composition decision is based on data that may no longer have the same values when the event is to be played back and it might simply sound wrong in that context. So, back to the problem: at the appropriate clock tick, an event is triggered, polling a composition module for some data, upon return of this data, a Csound event is generated. We can clearly see that any processing delays in this chain of events may lead to one out of two outcomes:
- The Csound event is delayed by a small amount, in most cases enough to be perceived as a rhythmical offset. This is not desirable if the music to be composed contains anything faster than 16th notes as a tempo of 150 bpm (and even this might be stretching the limits).


-  The other alternative is to create a tight synchronization between the Csound k-rate and the clock function responsible for triggering events. This will avoid the loose interpretation of rhythm seem in 1), but it might lead to audio dropouts if the compositional algorithm is so complex as to spend more time than one k-rate tick in Csound to complete its calculation.

[][4] [http://www.csounds.com/manual/html/chnset.html](http://www.csounds.com/manual/html/chnset.html) | [http://www.csounds.com/manual/html/chnget.html](http://www.csounds.com/manual/html/chnget.html)

[][5] [http://www.flexatone.net/athena.html](http://www.flexatone.net/athena.html)

[][6] [http://www.csounds.com/manual/html/featuresOfCsoundAC.html](http://www.csounds.com/manual/html/featuresOfCsoundAC.html)
