# Chapter 11

Chapter 11
Scripting Csound
Abstract In this chapter, we will discuss controlling Csound from applications writ-
ten in general-purpose scripting languages. This allows users to develop music pro-
grams that employ Csound as an audio engine, for speciﬁc uses.
11.1 Introduction
Throughout this book we’ve discussed what can be done within the Csound system
itself. In this chapter, we will discuss embedding Csound into applications, includ-
ing how to externally control Csound, as well as communicate between the host
application and Csound. The examples provided will be shown using the Python
programming language. However, Csound is available for use in C, C++, Java (in-
cluding JVM languages, such as Scala and Clojure), C#, Common Lisp and others.
11.2 Csound API
As discussed in Part I, Csound provides an Application Programming Interface
(API) for creating, running, controlling, and communicating with a Csound engine
instance. Host applications, written in a general-purpose programming language,
use the API to embed Csound within the program. Such applications can range from
a fully ﬂedged frontend to small, dedicated programs designed for speciﬁc uses (e.g.
an installation, a composition, prototyping, research).
The core Csound API is written in C. In addition, a C++ wrapper is available, and
bindings for other programming languages (Python, Java, Lua) are generated using
SWIG1. Each version of the API differs slightly to accommodate differences in each
programming language, but they all share the same basic design and functionality.
1 http://www.swig.org
© Springer International Publishing Switzerland 2016
V. Lazzarini et al., Csound, DOI 10.1007/978-3-319-45370-5_11
195
196
11 Scripting Csound
In this chapter, we will provide an overview of the use of Csound in a scripting-
language environment, Python. Such scripts can be constructed to provide various
means of interaction with the software system.
11.3 Managing an Instance of Csound
At the heart of a script that uses Csound through the API lies an instance of the
whole system. We can think of it as an object that encapsulates all the elements
that are involved in the operation of the software, e.g. compilation, performance,
interaction etc. A number of basic actions are required in this process: initialising,
compiling, running the engine, managing threads, stopping and cleaning up. In this
section, we will look at each one of these.
11.3.1 Initialisation
There are two initialisation steps necessary for running Csound in Python. The ﬁrst
one of these is to load the Python module, so that the functionality is made available
to the interpreter. There are two components in the csnd6 module:
1. the Python wrapper code (csnd6.py)
2. the binary library module ( csnd6.so).
In any regular installation of Csound, these would be placed in the default loca-
tions for Python. The ﬁrst one contains all the Python-side API code that is needed
for the running of the system, and the second contains the binary counterparts to it
that talk directly to the Csound C library.
When using Csound from Python, it is possible either to write the code into a text
ﬁle and then run it using the interpreter, or else to type all commands interactively at
the interpreter prompt. Csound can also be run from specialised Python shells such
as IPython and its Notebook interface.
In order to load Csound, the import command is used, e.g.
from csnd6 import Csound
This will load speciﬁcally the Csound class of the API, whereas
import csnd6
will load all the classes, including some other utility ones that allow the user to
access some parts of the original C API that are not idiomatically adapted to the
Python language. In this text, we will use this full-package import style. If you are
using Python interactively you can use the following commands to get a listing of
everything available in the API:
11.3 Managing an Instance of Csound
197
>> import csnd6
>> help(csnd6)
The next step is to create in memory a Csound object. After using the full-
package form of the import command shown above, we can instantiate it with
the following line:
cs = csnd6.Csound()
Once this is done, we should see the following lines printed to the console (but
the reported version and build date will probably be different):
time resolution is 1000.000 ns
virtual_keyboard real time MIDI plugin for Csound
0dBFS level = 32768.0
Csound version 6.07 beta (double samples) Dec 12 2015
libsndfile-1.0.25
We can then conﬁgure options for Csound using the SetOption method. This
allows us to set ﬂags for Csound. It employs the same ﬂags as one would use
when executing Csound from the command line directly, or in the CsOptions
tags within a CSD project ﬁle. For example
cs.SetOption('-odac')
will set the output to the digital-to-analogue converter (i.e., real-time audio output).
Note that SetOption allows for setting only one option at a time. Options can
also be set at ﬁrst compilation, as shown in the next section.
11.3.2 First Compilation
In order to run Csound, the next required stage is to compile the Csound code, which
we can do by passing a string containing the name of a CSD ﬁle to the Compile()
method of the Csound class:
err = cs.Compile('test.csd')
Up to four separate options can be passed to Csound as string arguments to
Compile(), in addition to the CSD ﬁle name:
err = cs.Compile('test.csd', '-odac', '-iadc','-dm0')
In this example, the input and output are set to real-time, and both displays and
messages are suppressed. Alternatively, we can use the utility class CsoundArgV-
List() to compose a variable list of arguments and pass it to Compile(), using
its argc() and argv() methods which hold the number and array of arguments,
respectively:
198
11 Scripting Csound
args = csnd6.CsoundArgVList()
args.Insert(0, 'test.csd')
args.Insert(0, '-odac')
args.Insert(0, '-idac')
args.Insert(0, '-dm0')
err = cs.Compile(args.argc(), args.argv())
In this case, any number of options can be passed to the compilation by inserting
these as strings in the argument list.
Once the CSD is compiled with no errors (err == 0), it is possible to start
making sound. Note that by compiling a ﬁrst CSD in this way, the engine is started
and placed in a ready-to-go state. Additional code can be further compiled by
Csound at any point with CompileOrc(). Note that Compile() can only be
called on a clean instance (either a newly created one, or one that has been reset, as
will be discussed later).
11.3.3 Performing
At this stage, we can start performance. A high-level method can be used to run the
Csound engine:
cs.Perform()
Note that this will block until the performance ends (e.g. at the end of an existing
score) but if Csound is set to run in real-time with no score, this stage might never
be reached in our lifetime. In that case, we would need to ﬁnd a different way of
performing Csound.
The API also allows us to perform one k-cycle at a time by calling the Perform
Ksmps() method of the Csound class. Since this performs only a single ksmps
period, we need to call it continuously, i.e. in a loop:
while err == 0:
err = cs.PerformKsmps()
At the end of performance, err becomes non-zero. However, this will still block
our interaction with the code, unless we place some other event-checking function
inside the loop.
Performance thread
Another alternative is to run Csound in a separate thread. This is cumbersome in
pure Python as the global interpreter lock (GIL) will interfere with performance.
The best way to do it is to use a Csound performance thread object, which uses a
separate native thread for performance. We can access it from the csnd6 package
to create a thread object by passing our Csound engine (cs) to it:
11.3 Managing an Instance of Csound
199
t = csnd6.CsoundPerfomanceThread(cs)
At this point, we can manipulate the performance simply by calling Play(),
Pause(), and Stop() on the thread object, e.g.
t.Play()
Note that each one of these methods does not block, so they work very well in
interactive mode. When using these in a script, we will have to make sure some sort
of event loop or a sleep function is used, otherwise the interpreter will fall through
these calls and close before we are able to hear any sound. Also in order to clear
up the separate thread properly, on exiting we should always call Join() after
Stop().
Real-time performance and ﬁle rendering
As with other modes of interaction with Csound, it is possible to run Csound as a
real-time performance or to render its output to a ﬁle. There is nothing speciﬁc to
Python or to scripting in general with regards to these modes of operation. They
can be selected as described in Part I, by employing the -o option. As discussed
before, by default, Csound renders to ﬁle (called test.wav or test.aif depending on
the platform), and to enable real-time output, the -o dac option is required.
11.3.4 Score Playback Control and Clean-up
If we are using the numeric score, performance will stop at the end of this score. In
order to reuse the Csound instance, we need to either rewind it or set its position to
some other starting point. There are two methods that can be used for this:
cs.SetScoreOffsetSeconds(time)
cs.RewindScore()
Note that these can be used at any point during performance to control the score
playback. We can also get the current score position with:
cs.GetScoreTime()
Alternatively, we can clean up the engine so that it becomes ready for another
initial compilation. This can be accomplished by a reset:
cs.Reset()
This can also be done, optionally, by recreating the object. In this case, Python’s
garbage collection will dispose of the old Csound instance later, and no resetting is
needed.
200
11 Scripting Csound
11.4 Sending Events
One of the main applications for Python scripts that run Csound is to enable a high
level of interactivity. The API allows external triggering of events (i.e. instantiation
of instruments), in a ﬂexible way. While the engine is performing, we can call meth-
ods in the Csound class that will schedule instruments for us. This is thread-safe,
which means that it can be called from a different thread to the one where the engine
is running, and calls can be made at any time.
There are two main methods for this, InputMessage() and ReadScore.
The ﬁrst one of these dispatches real-time events with no further processing,
whereas the second one can take advantage of most of the score-processing ca-
pabilities (except for tempo warping) as expected for a score ﬁle (or section of a
CSD ﬁle). The syntax of both methods is the same; they are passed strings deﬁning
events in the standard score format:
cs.InputMessage('i 1 0 0.5 8.02')
Events with start time (p2) set to 0 are played immediately, whereas a non-zero
p2 would schedule instances to start sometime in the future, relative to the current
time in the engine. Multiple events in multi-line strings are allowed, and the Python
string conventions (single, double and triple quoting) apply.
11.5 The Software Bus
Csound provides a complete software bus to pass data between the host and the en-
gine. It allows users to construct various means of interaction between their software
and running instruments. The bus uses the channel system as discussed in Chapter 6,
and it provides means of sending numeric control and audio data through its named
channels. In the speciﬁc case of Python, given the nature of the language, we will
tend to avoid passing audio data in strict real-time situations, as the system is not
designed for efﬁcient number crunching. However, in other situations, it is perfectly
feasible to access an audio stream via the bus.
Data sent or received to Csound is processed once per k-cycle, so if two or more
requests to a bus channel are sent inside one single k-period, the ﬁnal one of these
will supersede all others. All calls to the software bus are thread-safe, and can be
made asynchronously to the engine.
11.5.1 Control Data
The most common use of the software bus is to pass numeric control data to and
from Csound. The format is a scalar ﬂoating-point value, which can be manipulated
via two methods:
11.5 The Software Bus
201
var = cs.GetChannel('name')
cs.SetChannel('name', var)
The ﬁrst parameter is a string identifying the name of the channel. The counter-
parts for these functions in Csound code are
kvar chnget
"name"
chnset kvar, "name"
These opcodes will work with either i- or k-rate variables for control data. Thus,
when passing data from Python to Csound, we use SetChannel() and chnget,
and when going in the other direction, chnset and GetChannel(). These func-
tions are also thread-safe, and will set/get the current value of a given channel.
11.5.2 Audio Channels
As we have learned before, audio data in Csound is held in vectors, which will
have ksmps length. So, if we want to access audio data, we will need to use a
special Python object to handle it. The csnd6 package offers a utility class to han-
dle this, CsoundMYFLTArray, which can then be used in conjunction with the
GetAudioChannel() and SetChannel() methods of the Csound class. For
instance, in order to get the data from a channel named "audio", we can use this
code:
aud = csnd6.CsoundMYFLTArray(cs.GetKsmps())
cs.GetAudioChannel('audio', aud.GetPtr(0))
Each one of the elements in the vector can be accessed using GetValue():
for i in range(0,cs.GetKsmps()):
print aud.GetValue(i)
To pass data in the other direction, using the same object, we can do
cs.SetChannel('audio', aud.GetPtr(0))
The GetPtr() method is needed to allow the channel to access the vector mem-
ory created in the Python object. Its parameter indicates which starting position in
the vector we will pass to the channel (0, the beginning, is the usual value).
11.5.2.1 Input and Output Buffers
A similar method used for audio channels can be used to access the input and/or
output buffers of Csound, which hold the data used by the in and out (and related)
opcodes.
As discussed earlier in Section 2.8.2, Csound has internal buffers that hold a
vector of ksmps audio frames. These are called spin and spout. We can access
them from the API using a CsoundMYFLTArray object:
202
11 Scripting Csound
spout = csnd6.CsoundMYFLTArray()
spout.SetPtr(cs.GetSpout())
spin = csnd6.CsoundMYFLTArray()
spin.SetPtr(cs.GetSpin())
As discussed above, the SetValue() and GetValue() methods of the
CsoundMYFLTArray class can then be used to manipulate the audio data. The
size of these vectors will be equivalent to ksmps*nchnls (if nchnls i has been
deﬁned, then the size of spin is ksmps*nchnls i).
Likewise, we can access the actual input and output software buffers, which are
larger, and whose size in frames is set by the -b N option:
inbuffer = csnd6.CsoundMYFLTArray()
inbuffer.SetPtr(cs.GetInputBuffer())
outbuffer = csnd6.CsoundMYFLTArray()
outbuffer.SetPtr(cs.GetOutputBuffer())
Note that all of these buffers are only available after the ﬁrst compilation, when
the engine has started.
11.6 Manipulating Tables
Function tables are also accessible through the API. It is possible to read and/or
write data to existing tables. The following methods can be used:
•
TableLength(tab): returns the length of a function table, tab is the table
number.
•
TableGet(tab, index): reads a single value from a function table, tab is
the table number and index is the position requested.
•
TableSet(tab, index, value): writes a single value of a function ta-
ble, tab is the table number and index is the position to be set with value.
•
TableCopyIn(tab, src): copies all values from a vector into a table. The
src parameter is given by a GetPtr() from a CsoundMYFLTArray created
with the same size as the requested function table. It holds the values to be copied
into the table.
•
TableCopyOut(tab, dest): copies all values from a table into a vector.
The dest parameter is given by a GetPtr() from a CsoundMYFLTArray
created with the same size as the requested function table. It will hold a copy of
the values of the function table after the function call.
The CsoundMYFLTArray object used in the data copy should have a least the
same size as the requested table. Trying to copy data to/from a destination or source
with insufﬁcient memory could lead to a crash.
11.8 A Complete Example
203
11.7 Compiling Orchestra Code
It is possible to compile orchestra code straight from a Python string using the
CompileOrc() method of the Csound class. This can be done at any time, and
it can even replace the Compile() method that reads a CSD from ﬁle. However,
in this case, we will need to start the engine explicitly with a call to Start().
Consider the following example (listing 11.1).
Listing 11.1 Compiling directly from a string containing Csound code
cs = csnd6.Csound()
cs.SetOption('-odac')
if cs.CompileOrc('''
instr 1
a1 oscili p4, p5
out a1
endin
schedule(1,0,2,0dbfs,440)
''') == 0:
cs.Start()
t = csnd6.CsoundPerformanceThread(cs)
t.Play()
while(t.isRunning() == 1):
pass
Here, we create a Csound engine and set it to real-time audio output. Then we
send it the initial code to be compiled. Following this, if the compilation is success-
ful, we start the engine, set up a performance thread and play it. The inﬁnite loop at
the end makes sure the script does not fall through; it can be ignored if the code is
typed at the Python shell, and it should be replaced by an event listener loop in an
interactive application.
Any number of calls to CompileOrc() can be issued before or after the engine
has started. New instruments can be added, and old ones replaced using this method.
This method is thread-safe and may be called at any time.
11.8 A Complete Example
To complement this chapter, we will show how Csound can be combined with a
graphical user interface package to create a simple program that will play a sound
in response to a button click. There are several Python GUI packages that can be
used for this purpose. We will provide an example using the Tkinter module, which
is present in most platforms under which Python can be run.
The application code, in listing 11.2, can be outlined as follows:
