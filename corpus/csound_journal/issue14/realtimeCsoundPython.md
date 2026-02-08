---
source: Csound Journal
issue: 14
title: "Real-time Coding Using the Python API: Score Events"
author: "the user"
url: https://csoundjournal.com/issue14/realtimeCsoundPython.html
---

# Real-time Coding Using the Python API: Score Events

**Author:** the user
**Issue:** 14
**Source:** [Csound Journal](https://csoundjournal.com/issue14/realtimeCsoundPython.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 14](https://csoundjournal.com/index.html)
## Real-time Coding Using the Python API: Score Events
 François Pinot
 fggpinot AT gmail.com
## Introduction


The Csound Python API provides classes and functions to use the Csound API from Python. An interesting issue with Python is that we can use an enhanced version of the Python shell, IPython [[1]](https://csoundjournal.com/#ref1), for interactive sessions. In this paper, a basic class encapsulating commands to run a Csound session is presented, and examples are given of a real-time session with score events. The reader is expected to be comfortable with the Python programming language [[2]](https://csoundjournal.com/#ref2) and to have a basic knowledge of Csound [[3]](https://csoundjournal.com/#ref3).
##
I. IPython



For this article we will need the following installed: *Csound*, *Python*, the interactive Python shell *IPython*, and the Python modules *numpy*, *scipy* and *matplotlib*. On most Linux distributions there are prebuilt packages of all these components. On Windows, the simplest way to setup these is to install binaries. For example with Python 2.6, you can get an msi file [here](http://www.python.org/download/releases/2.6.6/), the Csound installer from the [Csound Page at SourceForge](http://sourceforge.net/projects/csound/files/), an IPython binary from the [IPython site](http://ipython.scipy.org/moin/Download), *numpy* and *scipy* binaries from [SciPy.org](http://www.scipy.org/Download), and *matplotlib* from its [SourceForge](http://matplotlib.sourceforge.net/) page (the *download* link on the right side). Windows users also need to install the [pyreadline](https://launchpad.net/pyreadline/+download) module to have a console with colors.

The *IPython* shell offers some goodies for an interactive use of Python: TAB-completion, exploring your objects, the %run command, input and output cache, %hist command, and a lot of other facilities. When launched with the *pylab* flag and the *scipy* profile (ipython -pylab -p scipy), *IPython* offers a ready-to-go interactive environment similar to MATLAB® but with the scripting power of Python. Finally if we add to this environment access to *Csound* via its API, we get a very powerful system for interactive experimentation.

Note: All of the examples presented in this article have been tested on Linux and on Windows XP with Csound 5.12 and Python 2.6. While I could not test these examples on Mac OS X, they should be able to work. One can find instructions to install *SciPy* for Mac OS X [here.](http://www.scipy.org/Installing_SciPy/Mac_OS_X) Note that they *strongly* recommend installing the [offical Python distribution](http://www.python.org/download/) instead of using the one shipped by Apple.
##
II. CsoundSession



In this article, a Csound session consists of a running Csound engine with a Python interpreter listening for user input. Our basic class for running a session is called *CsoundSession*. It inherits from the *Csound* class which is an interface to the Csound API. We will also use the *CsoundPerformanceThread* class to perform a CSD file [[4]](https://csoundjournal.com/#ref4) in a separate thread. Initially it might make sense to make our class inherit from both the *Csound* and the *CsoundPerformanceThread* classes as Python allows multiple inheritance. However, doing so would put both classes on the same level. In fact, the *Csound* class is tied to a whole session while the *CsoundPerformanceThread* class corresponds to a single performance within a session. We want to be able to perform successive CSD files during a single session. Therefore our *CsoundSession* class is designed to have an attribute of type *CsoundPerformanceThread*.

![image](realtimeCsoundPython/images/csoundSession.png) **Figure 1.** The CsoundSession class.
### Launching a session


To start a session, open up a terminal (Command Prompt on Windows), change directories to the directory in which there is a copy of the [csoundSession.py](https://csoundjournal.com/realtimeCsoundPython/csoundSession.py) file, and then launch an IPython shell:
```csound
~$ **cd 'our working directory'**
~$ **ipython -pylab -p scipy**
Python 2.6.5 (r265:79063, Apr 16 2010, 13:09:56)
Type "copyright", "credits" or "license" for more information.

IPython 0.10 -- An enhanced Interactive Python.
?         -> Introduction and overview of IPython's features.
%quickref -> Quick reference.
help      -> Python's own help system.
object?   -> Details about 'object'. ?object also works, ?? prints more.

IPython profile: scipy

  Welcome to pylab, a matplotlib-based Python environment.
  For more information, type 'help(pylab)'.

In [1]:
```
 (In the IPython shell, the default prompt is In [n]: where n is the number of the command line typed by the user. The answer to the user command is displayed with an Out[n]: prompt).

To begin, first import everything from the csoundSession module and then create a CsoundSession object. Please note that the first letter of the module name is a lowercase 'c' while the first letter of the class name is an uppercase 'C'.
```csound
In [1]: from csoundSession import *

In [2]: cs = CsoundSession()

In [3]:
```
 Next, we can display the methods and attributes of our object with the *dir()* command. We can also print some information about Csound using those API functions which work even if no CSD file is loaded.
```csound
In [3]: dir(cs)
Out[3]:
['AddSpinSample',
 'AppendOpcode',
 'ChanIASet',
 'ChanIASetSample',
 'ChanIKSet',
 'ChanIKSetValue',
 'ChanOAGet',
 'ChanOAGetSample',
 'ChanOKGet',
 'ChanOKGetValue',
 'Cleanup',
 'Compile',
 'CreateConfigurationVariable',
 'CreateGlobalVariable',
 'DeleteChannelList',
 'DeleteConfigurationVariable',
 'DeleteUtilityList',
 'DestroyGlobalVariable',
 'DestroyMessageBuffer',
 'DisposeOpcodeList',
 'EnableMessageBuffer',
 'Get0dBFS',
 'GetChannel',
 'GetChannelPtr',
 'GetControlChannelParams',
 'GetCsound',
 'GetDebug',
 'GetEnv',
 'GetFirstMessage',
 'GetFirstMessageAttr',
 'GetInputBuffer',
 'GetInputBufferSize',
 'GetKr',
 'GetKsmps',
 'GetMessageCnt',
 'GetMessageLevel',
 'GetNchnls',
 'GetOutputBuffer',
 'GetOutputBufferSize',
 'GetOutputFileName',
 'GetRtPlayUserData',
 'GetRtRecordUserData',
 'GetSampleFormat',
 'GetSampleSize',
 'GetScoreOffsetSeconds',
 'GetScoreTime',
 'GetSpin',
 'GetSpout',
 'GetSpoutSample',
 'GetSr',
 'GetStrVarMaxLen',
 'GetTable',
 'GetUtilityDescription',
 'InitializeCscore',
 'InputMessage',
 'IsScorePending',
 'KeyPressed',
 'ListChannels',
 'ListConfigurationVariables',
 'ListUtilities',
 'Message',
 'MessageS',
 'NewOpcodeList',
 'ParseConfigurationVariable',
 'Perform',
 'PerformBuffer',
 'PerformKsmps',
 'PerformKsmpsAbsolute',
 'PopFirstMessage',
 'PreCompile',
 'PvsinSet',
 'PvsoutGet',
 'QueryConfigurationVariable',
 'QueryGlobalVariable',
 'QueryGlobalVariableNoCheck',
 'Reset',
 'RewindScore',
 'RunUtility',
 'ScoreEvent',
 'ScoreExtract',
 'ScoreSort',
 'SetChannel',
 'SetChannelIOCallback',
 'SetConfigurationVariable',
 'SetControlChannelParams',
 'SetDebug',
 'SetExternalMidiInCloseCallback',
 'SetExternalMidiInOpenCallback',
 'SetExternalMidiReadCallback',
 'SetHostData',
 'SetHostImplementedAudioIO',
 'SetInputValueCallback',
 'SetMessageCallback',
 'SetMessageLevel',
 'SetOutputValueCallback',
 'SetScoreOffsetSeconds',
 'SetScorePending',
 'Stop',
 'TableGet',
 'TableLength',
 'TableSet',
 '__class__',
 '__del__',
 '__delattr__',
 '__dict__',
 '__doc__',
 '__format__',
 '__getattr__',
 '__getattribute__',
 '__hash__',
 '__init__',
 '__module__',
 '__new__',
 '__reduce__',
 '__reduce_ex__',
 '__repr__',
 '__setattr__',
 '__sizeof__',
 '__str__',
 '__subclasshook__',
 '__swig_destroy__',
 '__swig_getmethods__',
 '__swig_setmethods__',
 '__weakref__',
 'CSD',
 'getCsdFileName',
 'note',
 'pt',
 'pydata',
 'resetSession',
 'scoreEvent',
 'startThread',
 'stopPerformance',
 'this']

In [4]: cs.GetSr()
Out[4]: 44100.0

In [5]: cs.GetKr()
Out[5]: 4410.0

In [6]: cs.GetNchnls()
Out[6]: 1

In [7]: cs.GetScoreTime()
Out[7]: 0.0

In [8]: cs.getCsdFileName()

In [9]:
```
 The *dir(cs)* command returns a list of strings that are the method names of the *Csound* class (the parent class of our *CsoundSession* class), followed by the attribute and method names of the *object* class that was inherited by the *Csound* class (from '__class__' to '__subclasshook__'), then some method names provided by the SWIG wrapper and finally our own attributes and method names. Note that the *Csound* class method names begin with an uppercase letter while our own method names begin with a lowercase letter. Therefore our *scoreEvent* method is different from its parent class *ScoreEvent* method.
### Performing a CSD file


To produce some music, Csound needs an orchestra and a score. We load both of them from a CSD file named [simple.csd](https://csoundjournal.com/realtimeCsoundPython/simple.csd). It contains a single intrument (instr 1) and a score including a single f0 event with of duration of 14400 seconds (four hours). The -d -m0 flags are used to minimize the amount of messages displayed by Csound. (Note: If your sound card does not support a sampling rate of 96000 Hz, try with a lower sr)
```csound
<CsoundSynthesizer>

<CsOptions>
  -d -o dac -m0
</CsOptions>

<CsInstruments>
sr     = 96000
ksmps  = 100
nchnls = 2
0dbfs  = 1

          instr 1
idur      =         p3
iamp      =         p4
icps      =         cpsoct(p5)
ifn       =         p6
irise     =         p7
idec      =         p8
ipan      =         p9
kenv      linen     iamp, irise, idur, idec
asig      oscili    kenv, icps, ifn
a1, a2    pan2      asig, ipan
          outs      a1, a2
          endin
</CsInstruments>

<CsScore>
f 0 14400
</CsScore>
</CsoundSynthesizer>
```
 The file is loaded and started with the *resetSession* method which takes the file name as argument:
```csound
In [9]: cs.resetSession("simple.csd")
PortAudio real-time audio module for Csound
PortMIDI real time MIDI plugin for Csound
virtual_keyboard real time MIDI plugin for Csound
0dBFS level = 32768.0
Csound version 5.12 (double samples) Jul 29 2010
libsndfile-1.0.21
Reading options from $HOME/.csoundrc
UnifiedCSD:  simple.csd
STARTING FILE
Creating options
Creating orchestra
Creating score
orchname:  /tmp/csound-16QorA.orc
scorename: /tmp/csound-Xdi5rI.sco
RAWWAVE_PATH: /usr/local/share/csound/rawwaves/
rtmidi: PortMIDI module enabled
rtaudio: ALSA module enabled
orch compiler:
	instr	1
sorting score ...
	... done
Csound version 5.12 (double samples) Jul 29 2010
displays suppressed
0dBFS level = 1.0
orch now loaded
audio buffered in 1024 sample-frame blocks
writing 4096-byte blks of shorts to dac
SECTION 1:

In [10]:
```
 This method compiles the orchestra and the score and starts the performance in a separate thread using a *CsoundPerformanceThread* object. Note that the lines displayed by Csound (from 'Portaudio... to 'SECTION 1:') are not preceded by an Out[10]: prompt because those lines are not a value returned by the *resetSession* method, but a direct output from Csound. As the performance is running in a separate thread, we still can enter commands from the top level:
```csound
In [10]: cs.GetSr(), cs.GetKr(), cs.GetNchnls()
Out[10]: (96000.0, 960.0, 2)

In [11]: cs.GetScoreTime()
Out[11]: 9.6229166666666668

In [12]: cs.getCsdFileName()
Out[12]: 'simple.csd'

In [13]:
```
 Note that the three values returned in the tuple are from after loading the CSD file, and that these are different from the default values we received when the CSD file was not loaded.

We could also have started the session and the performance in a single operation, giving the CSD file name as argument to our object constructor. In the following display, we stop the performance and leave the interactive shell. We then launch a shell and start a new Csound session:
```csound
In [13]: cs.stopPerformance()
inactive allocs returned to freespace
end of score.		   overall amps:  0.00000
	   overall samples out of range:        0
0 errors in performance
181552 2048-byte soundblks of shorts written to dac

In [14]: quit()
Do you really want to exit ([y]/n)? y
~$**ipython -pylab -p scipy**
...
In [1]: from csoundSession import *

In [2]: cs = CsoundSession("simple.csd")
PortAudio real-time audio module for Csound
...
SECTION 1:

In [3]:
```
 Now that a CSD file is being performed, we can send score events to Csound using the *scoreEvent* and *note* methods of our *cs* object .
##
III. Sending Score Events



The *scoreEvent* method takes two or three arguments:
- *eventType* -- a character denoting the event type: 'a', 'e', 'i', 'f', or 'q'.
- *pvals* -- an iterable (tuple, list or array) containing the pfields for that event.
- *absp2mode* (optional, default=0) -- a flag indicating how to interpret the event start time. The second element of the *pvals* sequence is as usual the event start time. This time is measured in beats relatively to the time when the event was sent to csound. If the value of *absp2mode* is different from 0, the event start time is counted from the beginning of the performance instead. In this latter case, if the performance time counter is already beyond the absolute start time given, the event will be ignored.


###  'a' Statement


The 'a' score statement is used to advance the score time by a specified amount:
```csound
In [3]: cs.GetScoreTime()
Out[3]: 6.5708333333333337

In [4]: cs.scoreEvent('a', (0, 0, 6000))

In [5]: time advanced 6000.000 beats by score request
#return key hit to get the right prompt

In [6]: cs.GetScoreTime()
Out[6]: 6025.260416666667

In [7]:
```


In [3]: we display the current score time in beats, which means seconds here because the default tempo is 60 beats per second.
 In [4]: the score time is advanced 6000 beats. The 3 values in the tuple are respectively p1 (no meaning here), p2 (start time), p3 (number of beats to advance). A start time of 0 means executing the 'a' statement as soon as it is received.
 In [5]: the message returned by Csound is displayed mixed with the prompt from IPython for the next command. We hit the <return> key to get an empty prompt line.
 In [6]: we verify that the current score time has been advanced.
```csound
In [7]: cs.scoreEvent('a', (0, 6100, 500), 1)

In [8]: cs.GetScoreTime()
Out[8]: 6057.0249999999996

In [9]: time advanced 500.000 beats by score request
#return key hit to get the right prompt

In [10]: cs.GetScoreTime()
Out[10]: 6629.1750000000002

In [11]:
```


In [7]: we ask Csound to advance the score time 500 beats when it will have reached the absolute score time of 6100 beats (the *absp2mode* argument is different from 0).
 In [8]: we verify that the score is still running and that it has not yet reached the advance point.
 In [9]: after a few seconds, Csound tells us it has advanced the score time (at beat 6100).
 In [10]: the score time is now more than 6600 beats.
```csound
In [11]: cs.RewindScore()
end of section 1	 sect peak amps:  0.00000
SECTION 1:

In [12]: cs.GetScoreTime()
Out[12]: 8.0416666666666661

In [13]:
```


In [11]: we rewind the score time to zero.
###  'e' Statement


The 'e' statement is used to mark the end of the score:
```csound
In [13]: cs.GetScoreTime()
Out[13]: 376.04166666666669

In [14]: cs.scoreEvent('e', ())

In [15]: Score finished in csoundPerformKsmps().
inactive allocs returned to freespace
end of score.		   overall amps:  0.00000
	   overall samples out of range:        0
0 errors in performance
24694 2048-byte soundblks of shorts written to dac
#return key hit to get the right prompt

In [16]:
```


In [14]: we send an 'e' statement to Csound. As there is no pfield (empty tuple), the effect is immediate.
 In [15]: Csound displays messages denoting the end of the performance.
```csound
In [16]: cs.resetSession()
PortAudio real-time audio module for Csound
...
SECTION 1:

In [17]: cs.GetScoreTime()
Out[17]: 7.4249999999999998

In [18]: cs.scoreEvent('e', (0, 15))

In [19]: cs.GetScoreTime()
Out[19]: 25.729166666666668

In [20]: Score finished in csoundPerformKsmps().
inactive allocs returned to freespace
end of score.		   overall amps:  0.00000
	   overall samples out of range:        0
0 errors in performance
1340 2048-byte soundblks of shorts written to dac
#return key hit to get the right prompt

In [21]:
```


In [16]: we start a performance of the last loaded CSD file ('simple.csd').
 In [17]: the performance is running.
 In [18]: we ask Csound to end the performance in 15 beats from now.
 In [19]: the performance is still running.
 In [20]: Csound tells us that it has finished the performance.
```csound
In [21]: cs.resetSession()
PortAudio real-time audio module for Csound
...
SECTION 1:

In [22]: cs.GetScoreTime()
Out[22]: 2.6666666666666665

In [23]: cs.scoreEvent('e', (0, 20), 1)

In [24]: cs.GetScoreTime()
Out[24]: 18.987500000000001

In [25]: Score finished in csoundPerformKsmps().
inactive allocs returned to freespace
end of score.		   overall amps:  0.00000
	   overall samples out of range:        0
0 errors in performance
938 2048-byte soundblks of shorts written to dac
#return key hit to get the right prompt

In [26]: cs.resetSession()
PortAudio real-time audio module for Csound
...
SECTION 1:

In [27]:
```


In [21]: new performance...
 In [23]: we ask Csound to end the performance when it will have reached the absolute time 20 beats.
 In [24]: still running...
 In [25]: score finished.
 In [26]: ready for new adventures!
###  'f' Statement


We can use the function table statement to generate function tables.
```csound
In [27]: cs.scoreEvent('f', [1, 0, 4096, 10, 1])

In [28]: cs.note([1, 0, 1, 0.5, 8.75, 1, 0.05, 0.3, 0.5])

In [29]: cs.TableLength(1)
Out[29]: 4096

In [30]: cs.TableLength(2)
Out[30]: -1

In [31]: cs.TableGet(1, 1024)
Out[31]: 1.0

In [32]: cs.TableSet(1, 1024, -1.0)

In [33]: cs.note([1, 0, 1, 0.5, 8.75, 1, 0.05, 0.3, 0.5])

In [34]: cs.TableSet(1, 1024, 1.0)

In [35]: cs.note([1, 0, 1, 0.5, 8.75, 1, 0.05, 0.3, 0.5])

In [36]:
```


In [27]: ftable 1 is generated with a single sine wave. The second argument is a list containing the pfields for the 'f' statement: p1=1, ftable number. p2 = 0, generate the ftable right now. p3 = 4096, length of the ftable in samples. p4 = 10, use *GEN10*. p5 = 1, only the first partial.
 In [28]: we play a one second 440 Hz note using ftable 1. The *note* method of the *CsoundSession* class will be discussed in the next section.
 In [29]: we can get the table length from the API.
 In [30]: if the ftable does not exist, *TableLength* returns an error value (-1).
 In [31]: we can read a single value from within an ftable. Here we get the value of the 1025th sample of ftable 1. Indexes of an ftable are in the range [0, length[.
 In [32]: we write the value -1.0 to the 1025th location of ftable 1. This causes a discontinuity in the sine wave.
 In [33]: we can ear clicks in the note due to the discontinuity.
 In [34]: we write back the original value to the 1025th location of ftable1.
 In [35]: no more discontinuity, pure sine wave...

In the next examples, we will see how to use directly the data from an ftable through a *numpy* array. A *numpy* array is a data structure that can support indexing and slicing operations. If the data in the array are contiguous as in a C array, we should be able to create a *numpy* array with its buffer pointing to the data of the ftable. Thus we can manipulate the ftable data from their *Csound* buffer without copying them, thanks to the addons of *numpy* arrays.

First we must obtain a pointer to the ftable data. This is done with the *CsoundMYFLTArray* class of the API. This class wraps a Csound MYFLT array. It has a *GetPtr* method. When called without argument, this method returns a pointer to a pointer to a MYFLT. Creating a *CsoundMYFLTArray* object and passing its *GetPtr* method without argument to the *GetTable* API function, fills the internal pointer of the *CsoundMYFLTArray* object with a MYFLT pointer to the ftable data:
```csound
In [36]: tbl = csnd.CsoundMYFLTArray()

In [37]: tblSize = cs.GetTable(tbl.GetPtr(), 1)

In [38]: tblSize
Out[38]: 4096

In [39]: tbl.GetValue(1024)
Out[39]: 1.0

In [40]: tbl.SetValue(1024, -1.0)

In [41]: cs.note([1, 0, 1, 0.5, 8.75, 1, 0.05, 0.3, 0.5])

In [42]: tbl.SetValue(1024, 1.0)

In [43]: cs.note([1, 0, 1, 0.5, 8.75, 1, 0.05, 0.3, 0.5])

In [44]:
```


In [36]: we create an empty *CsoundMYFLTArray* object.
 In [37]: we make our object point to ftable 1 data, and we get ftable 1 length as a return value.
 In [39] .. In [43]: click test to verify that we have a direct access to ftable 1 data.

Once our *CsoundMYFLTArray* object is pointing to the ftable data, we can get a pointer to any value inside the ftable by using its *GetPtr* method with an index within the ftable range as argument. Thus calling *GetPtr(0)* returns a pointer to the ftable buffer. With this pointer, we can initialize a float or a double array using the appropriate Csound Python API function. Assuming that we're using a double version of Csound we would have:
```csound
In [44]: tblDoubleArray = csnd.doubleArray_frompointer(tbl.GetPtr(0))

# If the float version of Csound is used,
# the following line should be typed instead:
# tblArray = csnd.**float**Array_frompointer(tbl.GetPtr(0))

In [45]: tblDoubleArray[1024]
Out[45]: 1.0

In [46]: tblDoubleArray[1024] = -1.0

In [47]: cs.note([1, 0, 1, 0.5, 8.75, 1, 0.05, 0.3, 0.5])

In [48]: tblDoubleArray[1024] = 1.0

In [49]: cs.note([1, 0, 1, 0.5, 8.75, 1, 0.05, 0.3, 0.5])

In [50]: tblDoubleArray[1022:1027]
---------------------------------------------------------------------------
TypeError                                 Traceback (most recent call last)

/home/pinot/Articles/console-python/<ipython console> in <module>()

/usr/local/lib/python2.6/dist-packages/csnd.py in __getitem__(self, *args)
    211     __swig_destroy__ = _csnd.delete_doubleArray
    212     __del__ = lambda self : None;
--> 213     def __getitem__(self, *args): return _csnd.doubleArray___getitem__(self, *args)
    214     def __setitem__(self, *args): return _csnd.doubleArray___setitem__(self, *args)
    215     def cast(self): return _csnd.doubleArray_cast(self)

TypeError: in method 'doubleArray___getitem__', argument 2 of type 'size_t'

In [51]: len(tblDoubleArray)
---------------------------------------------------------------------------
TypeError                                 Traceback (most recent call last)

/home/pinot/Articles/console-python/<ipython console> in <module>()

TypeError: object of type 'doubleArray' has no len()

In [52]:
```


In [44]: we create a double array pointing to ftable 1 data. (If the float version of Csound is used, the line in the comment should be typed instead)
 In [45] .. In [49]: our click test is successful. Moreover, we can now access the ftable samples by indexing the array instead of using get or set functions.
 In [50]: slicing does not work.
 In [51]: neither do the *len* function. A bit more work is needed to get full Python functionalities.

Fortunately, Python provides a "swiss knife" for accessing C shared libraries from pure Python code: the *ctypes* module.
```csound
In [52]: import ctypes

In [53]: bufAdr = tbl.GetPtr(0).__long__()

In [54]: tblBuffer = ctypes.ARRAY(ctypes.c_double, tblSize).from_address(bufAdr)

# If the float version of Csound is used,
# the following line should be typed instead:
# tblBuffer = ctypes.ARRAY(ctypes.c_**float**, tblSize).from_address(bufAdr)

In [55]: tblBuffer[1024]
Out[55]: 1.0

In [56]: tblBuffer[1024] = -1

In [57]: cs.note([1, 0, 1, 0.5, 8.75, 1, 0.05, 0.3, 0.5])

In [58]: tblBuffer[1024] = 1

In [59]: cs.note([1, 0, 1, 0.5, 8.75, 1, 0.05, 0.3, 0.5])

In [60]: tblBuffer[1022:1027]
Out[60]:
[0.99999529380957619,
 0.99999882345170188,
 1.0,
 0.99999882345170188,
 0.99999529380957619]

In [61]: len(tblBuffer)
Out[61]: 4096

In [62]:
```


In [53] : we get the pointer to the ftable data as a long integer, which is the usual format for pointers in C.
 In [54] : we create a ctypes array with elements of type *c_double*, length equal to *tblSize*, and buffer pointing to ftable 1 data. This array presents the *buffer* interface which allows slicing operations. (If the float version of Csound is used, the line in the comment should be typed instead)
 In [55] .. In [59]: our click test is OK.
 In [60]: slicing now works...
 In [61]: and the *len* function as well.

The preceding example (from In [27]: to In [61]: ) has been presented for pedagogical purposes. Our *CsoundSession* class has a method called *getTableBuffer* that does the same job: it takes an ftable number as argument and it returns a ctypes array with the appropriate *c_float* or *c_double* type depending on the version of Csound that is used (float or double). Thus we can replace our last examples with the two following commands:
```csound
In [62]: cs.scoreEvent('f', [1, 0, 4096, 10, 1])

In [63]: tblBuffer = cs.getTableBuffer(1)

In [64]:
```


All the material presented until now was core Python stuff. *CsoundSession* itself is written to be used with core Python. But remember, we use an environment with *numpy* and *matplotlib*. It's time now to take advantage of those tools.
```csound
In [64]: tblArray = numpy.frombuffer(tblBuffer)

# If the float version of Csound is used,
# the following line should be typed instead:
# tblArray = numpy.frombuffer(tblBuffer**, float32**)

In [65]: plot(tblArray)
Out[65]: [<matplotlib.lines.Line2D object at 0xa69bb6c>]

In [66]: axis([0, tblArray.size, -1.1, 1.1])
Out[66]: [0, 4096, -1.1000000000000001, 1.1000000000000001]

In [67]: cs.note([1, 0, 1, 0.5, 8.75, 1, 0.05, 0.3, 0.5])

In [68]:
```


In [64]: we turn our buffer into an *numpy* array. Note, because IPython was started with the *scipy* profile, we could have also simply written  tblArray = frombuffer(tblBuffer), without mentioning the *numpy* namespace. (If the float version of Csound is used, the line in the comment should be typed instead)
 In [65]: a simple command lets us plot our data.
 In [66]: we define some extra vertical space for a nicer drawing (see below).
 In [67]: listen to our familiar sine note.

![image](realtimeCsoundPython/images/sine.png) **Figure 2.** Sine wave plotted from ftable 1.

We can now alter ftable 1 in a more interesting way than putting a single discontinuity: we'll insert a notch into the first half of the sine wave.
```csound
In [68]: tblArray[512]
Out[68]: 0.70710678118654746

In [69]: m = (-0.5 - tblArray[512]) / (1024.0 - 512.0)

In [70]: b = tblArray[512] - 512.0 * m

In [71]: x = arange(512,1025)

In [72]: tblArray[512:1025] = m*x + b

In [73]: tblArray[1024]
Out[73]: -0.5

In [74]: tblArray[1025]
Out[74]: 0.98825700000000005

In [75]: tblArray[1025:1537] = tblArray[1023:511:-1]

In [76]: plot(tblArray)
Out[76]: [<matplotlib.lines.Line2D object at 0x95e0ccc>]

In [77]: axis([0, tblArray.size, -1.1, 1.1])
Out[77]: [0, 4096, -1.1000000000000001, 1.1000000000000001]

In [78]: cs.note([1, 0, 1, 0.5, 8.75, 1, 0.05, 0.3, 0.5])

In [79]:
```


In [69], In [70]: we define the slope *m* and the y-intercept *b* of the equation of a straight-line going down from point (512, tblArray[512]) to point (1024, -0.5).
 In [71]: we define an array of abscissa values.
 In [72]: we fill the ordinate values in the ftable 1 data by applying our straight line formula to the abcissa values array.
 In [75]: positions 1025 to 1536 of the array are filled with the same values than positions 1023 downto 512 (symetric pattern around a vertical axis at position 1024)
 In [76], In [77]: we plot the altered sine wave (green lines) over the original one (blue lines) (see below).
 In [78]: listen to the new sound.

![image](realtimeCsoundPython/images/modifiedSine.png) **Figure 3.** Modified sine wave plotted from ftable 1.


```csound
In [79]: cs.scoreEvent('f', [1, 0, 4096, 10, 1])

In [80]: tblArray = frombuffer(cs.getTableBuffer(1))

# If the float version of Csound is used,
# the following line should be typed instead:
# tblArray = frombuffer(cs.getTableBuffer(1)**, float32**)

In [81]: cs.note([1, 0, 1, 0.5, 8.75, 1, 0.05, 0.3, 0.5])

In [82]:
```


In [79]: back to our sine wave.
 In [80]: make sure that *tblArray* points to the right data.

For the next section, we generate three ftables containing classical waveforms. ftable 101 is a band limited triangle wave, ftable 111 is a band limited square wave, and ftable 121 is a band limited impulse. The latter one is built with sine waves so that it starts with a zero value. We wrote some functions in a python script called [sessionUtils.py](https://csoundjournal.com/realtimeCsoundPython/sessionUtils.py), so that we can play with them by changing their arguments. The script is loaded with the IPython magic command *%run*. Each time we modify the script, we can reload the modified script with the *%run* command. The script includes comments about some traps to avoid. If you fixed the orchestra sampling rate to a lower value than 96000 Hz you'll have to change the last argument of the *blTriangle, blSquare, and blImpulse* functions to a lower number of harmonics to avoid foldover:
```csound
In [82]: %run sessionUtils.py

In [83]: blTriangle(cs, 101, 4096, 25)

In [84]: blSquare(cs, 111, 4096, 25)

In [85]: blImpulse(cs, 121, 4096, 25)

In [86]: clf(); drawTable(cs, 101); drawTable(cs, 111); drawTable(cs, 121)

# If the float version of Csound is used,
# the following line should be typed instead:
# clf(); drawTable(cs, 101**, float32**); drawTable(cs, 111**, float32**); drawTable(cs, 121**, float32**)

In [87]: cs.note([1, 0, 1, 0.5, 6.75, 101, 0.05, 0.3, 0.5])

In [88]: cs.note([1, 0, 1, 0.5, 6.75, 111, 0.05, 0.3, 0.5])

In [89]: cs.note([1, 0, 1, 0.5, 6.75, 121, 0.05, 0.3, 0.5])

In [90]:
```


![image](realtimeCsoundPython/images/tbl101-111-121.png) **Figure 4.** ftable 101 (blue), 111 (green), and 121 (red).

Then we generate interpolated ftables between ftable 101 and ftable 111, and between ftable 111 and ftable 121. We have now 21 ftables to play with:
```csound
In [90]: interpolateTables(cs, 101, 111)

# If the float version of Csound is used,
# the following line should be typed instead:
# interpolateTables(cs, 101, 111**, float32**)

In [91]: interpolateTables(cs, 111, 121)

# If the float version of Csound is used,
# the following line should be typed instead:
# interpolateTables(cs, 111, 121**, float32**)

In [92]:
```


![image](realtimeCsoundPython/images/tbl102to110.png) **Figure 5.** ftables 102 to 110.

![image](realtimeCsoundPython/images/tbl112to120.png) **Figure 6.** ftables 112 to 120.

We can listen to two series of 110 Hz notes using successively our ftables:
```csound
In [92]: for i in range(101, 112):
    cs.note([1, i-101, 0.7, 0.4, 6.75, i, 0.05, 0.3, 0.5])
   ....:
   ....:

In [93]: for i in range(111, 122):
    cs.note([1, i-111, 0.7, 0.4, 6.75, i, 0.05, 0.3, 0.5])
   ....:
   ....:

In [94]:
```

###  'i' Statement


The 'i' score statement sends a note to the orchestra to be played by an instrument. Because this statement is used very often during a session, the *CsoundSession* class provides a *note* method which is a syntactic sugar for a *scoreEvent('i', ...)* call. We already used it in the examples of the last section. It has an argument of type tuple, list or array, representing the *pfields* for the note to be played.

To illustrate the use of the *note* method, we will build a musical structure based on a ruled surface: a hyperbolic paraboloid. This idea was introduced by Iannis Xenakis in 1954 in his first orchestra piece *Metastasis*. He used string glissandi as interlaced straight lines to obtain sonic spaces of continuous evolution [[5]](https://csoundjournal.com/#ref2).

To draw a hyperbolic paraboloid in a 3D space, we use two non-coplanar lines (the blue lines in figure 7), and we join them by straight lines intersecting the two base lines at equally spaced points on them (the red lines in figure 7). Those lines run along a ruled surface called a hyperbolic paraboloid:
```csound
In [94]: from mpl_toolkits.mplot3d import Axes3D

In [95]: fig = figure()

In [96]: ax = Axes3D(fig)

In [97]: nlines = 41

In [98]: l1 = array([linspace(1, -1, nlines), ones(nlines)*(-1),
                      linspace(-1, 1, nlines)])

In [99]: l2 = array([linspace(1, -1, nlines), ones(nlines),
                      linspace(1, -1, nlines)])

In [100]: sl = skewlines(l1, l2, 100, ax)

In [101]:
```


In [94] to In [97]: we initialize a 3D figure in *matplotlib*.
 In [97]: We will generate 41 skew lines.
 In [98], In [99]: our two base lines are the non parallel diagonals of two opposite faces of a cube with length 2 sides.
 In [100]: the ruled surface is drawn by the *skewlines* function of our *sessionUtils.py* script. The figure can be rotated by dragging the mouse on it (in the figure window, not on the fixed picture of this article). Due to a bug in the *show* routine, Windows user will have to close the figure window before entering further commands. So, each call to *skewline* from Windows has to be preceded by the fig = figure() and ax = Axes3D(fig) commands. Linux users do not need to do this.

![image](realtimeCsoundPython/images/hp01.png) **Figure 7.** Hyperbolic paraboloid.

For our example, we use 17 skew lines on a hyperbolic paraboloid (figure 8), but instead of playing glissandi, we play 400 overlapping notes (grains) along each line. The values along the 'x' axis are interpreted as pan values, the 'y' axis represents time, and the values along the 'z' axis are pitches. Each grain uses one of the ftables (101 to 121) defined in the last section. All the work is done by the *playHP* function of our *sessionUtils.py* script. The whole example has a duration of two minutes, playing 400 * 17 = 8600 notes:
```csound
In [101]: nlines = 17

In [102]: l1 = array([linspace(1, -1, nlines), ones(nlines)*(-1),
                       linspace(-1, 1, nlines)])

In [103]: l2 = array([linspace(-1, 1, nlines), linspace(1, -0.25, nlines),
                       zeros(nlines)])

In [104]: sl = skewlines(l1, l2, 400, ax)

In [105]: playHP(cs, sl, 4.00, 8.75, 120, 101, 121)

In [106]:
```


![image](realtimeCsoundPython/images/hp02.png) **Figure 8.** The hyperbolic paraboloid used for our example.

The above call to *playHP* should produce sounds like [this](https://csoundjournal.com/realtimeCsoundPython/hypa.ogg).
###  'q' Statement


The 'q' score statement is used to quiet an instrument:
```csound
In [106]: cs.note([1, 0, 30, 0.5, 6.875, 101, 0.05, 0.3, 0.5])

In [107]: cs.scoreEvent('q', (1, 0, 0))

In [108]: Setting instrument 1 off
#return key hit to get the right prompt

In [109]: cs.note([1, 0, 10, 0.5, 7.875, 101, 0.05, 0.3, 0.5])

In [110]: cs.scoreEvent('q', (1, 0, 1))

In [111]: Setting instrument 1 on
#return key hit to get the right prompt

In [112]: cs.note([1, 0, 10, 0.5, 7.875, 101, 0.05, 0.3, 0.5])

In [113]:
```


In [106]: we start a long 110 Hz note.
 In [107]: we ask *Csound* to quiet instrument 1: *p1* = 1 (instrument number), *p2* = 0 (immediatly), *p3* = 0 (mute).
 In [108]: *Csound* tells us that instrument 1 is off. Note that this does not affect the note actually played.
 In [109]: we try to play a 220 Hz note. It is not heard.
 In [110]: we ask *Csound* to unmute instrument 1.
 In [112]: we try again to play a 220 Hz note and this time we hear it.
###  Coda


*Csound*, *Python*, and the *SciPy* suite form together an incredibly powerful set of tools to experiment with. This paper has only surveyed a small part of what is possible. These tools may seem complex (and they surely are!) but one can find a lot of documentation available. High level mathematics languages like Matlab, Octave or Scilab can give examples and ideas. Some ideas: modify the orchestra in a text editor while it is performed by a *CsoundSession* object, and then load it into another *CsoundSession* object so that there is no sound interrruption. Modify the *CsoundSession* class so that the *scoreEvent* method can store into a text file a line in score format for each event it sends to *Csound*. Thus when the session ends, we can use this text file to copy and paste events into a *<CsScore>* section of a CSD file.
##
IV. Conclusion



This article presents some mechanisms of the Csound API: launching a Csound session, performing a CSD file, getting information from Csound, using multithreading, accessing Csound internal buffers, and playing with score events. The Csound API offers many more possibilities such channel I/O, callback functions, and MIDI control. Using Python and the Csound API allows the musician-programmer to explore these new territories in realtime.
### References


[][1] Fernando Perez, Brian E. Granger, "IPython: A System for Interactive Scientific Computing," *Computing in Science and Engineering*, vol. 9, no. 3, pp. 21-29, May/June 2007.

[][2] Python Software Foundation, *The Python Tutorial*, Release 2.7, December 28, 2010.

[][3] Richard Boulanger, *An Instrument Design TOOTorial*, Boston, Massachusetts, March, 1991.

[][4] Barry Vercoe et Al. 2005. *The Canonical Csound Reference Manual*. [http://www.csounds.com/manual/html/index.html](http://www.csounds.com/manual/html/index.html). [Accessed Dec. 27, 2010].

[][5] Iannis Xenakis, *FORMALIZED MUSIC: Thought and Mathematics in Music*, Pendragon Revised Edition, Pendragon Press, 1992.
### Links


[IPython](http://ipython.scipy.org/)

[The Python Tutorial](http://docs.python.org/tutorial/)

[An Instrument Design TOOTorial](http://www.csounds.com/toots/)

[Writing your own .csd files](http://www.csounds.com/manual/html/PrefaceGettingStarted.html#id2733331)
