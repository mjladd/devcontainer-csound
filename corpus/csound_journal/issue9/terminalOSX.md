---
source: Csound Journal
issue: 9
title: "Working with the terminal in OSX:
An absolute beginner's guide"
author: "utilizing the"
url: https://csoundjournal.com/issue9/terminalOSX.html
---

# Working with the terminal in OSX:
An absolute beginner's guide

**Author:** utilizing the
**Issue:** 9
**Source:** [Csound Journal](https://csoundjournal.com/issue9/terminalOSX.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 9](https://csoundjournal.com/index.html)
## Working with the terminal in OSX:
 An absolute beginner's guide
 Jean-Luc Cohen-Sinclair
 jl AT jeanlucsinclair.com
## I. Introduction


When working with Csound most beginners and many experienced users rely on one of the many available Csound front-ends to compile their code and render their work. While there are some excellent applications available to Csounders, I've recently made the switch to working mostly with the Terminal. Although it might appear a bit daunting at first, working with the Terminal optimizes workflow, opens up possibilities in terms of functionality and boosts Csound's runtime performance significantly. [[1]](https://csoundjournal.com/#ref11)

The purpose of this article is to get you up and running quickly using the BASH shell on OSX, as well as to provide an overview of the basic commands required in order to do so.

This article assumes that you are running OSX version 10.3 or higher and that you have installed the default [Mac OSX Csound package](http://csound.sourceforge.net/#MacOSX) from SourceForge. The Terminal application in earlier versions of OSX does not use the BASH shell.
## II. Working with the Terminal


You could be a life long Mac user and not once open the Terminal. Apple's brilliant operating system has accustomed us to relying on mouse clicks for most tasks. The Terminal however can prove an extremely useful tool and a great time saver.

Simply put, the Terminal is an application that runs Unix shells. It acts as an intermediary between you, the end-user, and the kernel, which manages your computer's resources. There are several types of Unix Shells in use today, but since version 10.3 of OSX, the default Mac shell is the BASH shell [[2]](https://csoundjournal.com/#ref12). Unix is an operating system built for multitasking developed at AT&T Bell Laboratories and has been in use since the early 1970's. Since 1999 and the release of Darwin, the core of Apple computer's operating systems is Unix. While an extensive discussion of Unix is beyond the scope of this article, I strongly recommend spending a few moments with one of the many tutorials available online. [[3]](https://csoundjournal.com/#ref13)

For now, we can think of the Terminal as a real time programming environment where a given command will generate an instantaneous response from the computer.

The Csound OSX package installs the Csound command, `csound`, in `/usr/local/bin`. To run Csound, open up Terminal.app located in your `/Applications/Utilities` folder, and type the follwing at the prompt (the `$` symbol represents the shell prompt):
```csound
$ /usr/local/bin/csound
```


Providing that Csound has been installed correctly, the following message will be output to your terminal window:
```csound
PortMIDI real time MIDI plugin for Csound
PortAudio real-time audio module for Csound
virtual_keyboard real time MIDI plugin for Csound
0dBFS level = 32768.0
Csound version 5.08 (float samples) Feb  4 2008
libsndfile-1.0.16
Usage:  csound [-flags] orchfile scorefile
Legal flags are:
--help  print long usage options
-U unam run utility program unam
-C      use Cscore processing of scorefile
-I      I-time only orch run
-n      no sound onto disk
-i fnam sound input filename
-o fnam sound output filename
-b N    sample frames (or -kprds) per software sound I/O buffer
-B N    samples per hardware sound I/O buffer
-A      create an AIFF format output soundfile
-W      create a WAV format output soundfile
-J      create an IRCAM format output soundfile
-h      no header on output soundfile
-c      8-bit signed_char sound samples
-8      8-bit unsigned_char sound samples
-u      ulaw sound samples
-s      short_int sound samples
-l      long_int sound samples
-f      float sound samples
-3      24bit sound samples
-r N    orchestra srate override
-k N    orchestra krate override
-K      Do not generate PEAK chunks
-v      verbose orch translation
-m N    tty message level. Sum of:
                1=note amps, 2=out-of-range msg, 4=warnings
                0/32/64/96=note amp format (raw,dB,colors)
                128=print benchmark information
-d      suppress all displays
-g      suppress graphics, use ascii displays
-G      suppress graphics, use Postscript displays
-x fnam extract from score.srt using extract file 'fnam'
-t N    use uninterpreted beats of the score, initially at tempo N
-t 0    use score.srt for sorted score rather than a temporary
-L dnam read Line-oriented realtime score events from device 'dnam'
-M dnam read MIDI realtime events from device 'dnam'
-F fnam read MIDIfile event stream from file 'fnam'
-R      continually rewrite header while writing soundfile (WAV/AIFF)
-H#     print heartbeat style 1, 2 or 3 at each soundfile write
-N      notify (ring the bell) when score or miditrack is done
-T      terminate the performance when miditrack is done
-D      defer GEN01 soundfile loads until performance time
-Q dnam select MIDI output device
-z      List opcodes in this version
-Z      Dither output
flag defaults: csound -s -otest -b1024 -B4096 -m135
Csound Command ERROR:   insufficient arguments
```


Typing `/usr/local/bin/csound` is a bit cumbersome if we have to specify `/usr/local/bin` everytime we run Csound. We can streamline this by utilizing the `PATH`, a unix environment variable that specifies all the directories in which the shell will search to find commands. [[4]](https://csoundjournal.com/#ref14)

By adding `/usr/local/bin` to the `PATH`, we can successfully run Csound without typing the full path. This is achieved with the following command:
```csound
$ export PATH="$PATH:/usr/local/bin"
```


You should now be able to run Csound with this:
```csound
$ csound
```


If you were to open a new terminal window however the new window would not recognize your exported path. To make this change permanent, add the `export` to the file `~/.profile`. This file is a script that is executed everytime you open a new terminal window. By placing the `export` within it, you will automatically have direct access to `csound` for every new terminal window.

First, we have to check to see if `.profile` exists:
```csound
$ ls ~/.profile
```


If `.profile` **does not** exist, we can create it and add the `export` with one command:
```csound
$ echo export PATH=\"\$PATH:/usr/local/bin\" > ~/.profile
```


If `.profile` **does** exist, then we'll need to open and alter the existing copy. Since a file with a period prepended to its name is hidden in the OSX Finder by default, opening `.profile` can be a bit tricky. The easiest way to open this file is to type the following:
```csound
$ open -t ~/.profile
```


This will open `.profile` with your default text editor. Copy and paste:
```csound
export PATH="$PATH:/usr/local/bin"
```


at the end of this file, save and exit.

We are now ready to compile our first Csound file from the Terminal. Type the following:
```csound
csound -d -odac yourcsoundfile.csd
```


We can break down the previous line as follow:
- '-d' is a flag used to suppress displays, such as f-table graphics.
- '-odac' is a flag used to direct csound's output to the DAC, effectively running in realtime.
- 'yourcsoundfile.csd' is any Csound file you wish to use to run this example with.

At this point you might still be running into another issue... Csound may not be able to find your csd file and the following message might appear:
```csound
Failed to open csd file: No such file or directory
Reading CSD failed ... stopping
```


This is because by default, Csound will look for the csd file in your current working directory. If your csd file is not in this location, you will either need to specify the proper path to your file, or change your current working directory with the shell command `cd`. A quick method for specifying the proper path is to simply drag the .csd file you wish to use from the finder to the terminal window after the -odac flag. The terminal will automatically write the path to your shell. In my case, running Dr. Boulanger's first tutorial file, my terminal command looks like:
```csound
$ csound -d -odac /Users/jeanlucsinclair/Documents/CsoundClass/Chapter\ 1\ tutor
ial/chapter01/101.csd
```


My efforts are now being rewarded by the simple, yet wonderful sound of a sine wave.

If you are looking for a Unix tutorital, you might want to click [here.](http://www.ee.surrey.ac.uk/Teaching/Unix/index.html)
## III. Csound command line flags


Working with a front-end often shelters the end user from working with command line flags. Flags are a way to specify elements such as file formats and whether to render in real time or save it to disk. It is very important to become familiar with a few of them in order to be efficient. A quick review of some basic flags will prove extremely useful. I have listed a few of them below, but much more information on this topic can be found in the Csound documentation. [[5]](https://csoundjournal.com/#ref15)
- -v: turns verbose mode on. This is a very useful debugging tool, as it will print the details of the job being rendered. Leave it off unless debugging in order to greatly increase performance.
- -A: writes an AIF output file.
- -W: writes a WAV output file
- -3: 24bit sound samples
- -ofilename: Specifies the name of the output file
- -odac: Sends the output to the computer's digital audio converters, running Csound in real time.
- -d: suppress all displays
- -g: suppress graphics, use ascii displays

A few examples might clear things up. For instance:
```csound
csound -d -W 101.csd -o/Users/user/Music/101.wav
```


The above line of code renders the 101.csd file as a wav file, to the Music directory and it will be named 101.wav
```csound
csound -d -A -v 101.csd -o/Users/user/Music/Sine.aif
```


The above line of code renders the 101.csd file to the same directory as previously stated, but as an AIF file named 'Sine.aif', and with the verbose option turned on.

And lastly...
```csound
csound -v -odac 101.csd
```


...will render the same 101.csd file in real time with verbose and displays enabled.

Again, for a much more extensive discussion of command line flags I will refer you to the Csound Documenation.
## IV. Useful Unix Commands


Familiarity with some basic terms and commands is necessary in order to successfully work with the Terminal. The following should help you get up and running:
- A **command** is simply an instruction given by the user to the computer
- A **process** is a computer given ID to a running command
- A **job** is a group of one or more processes

These commands will allow you to navigate between directories as well as perform a few other basic tasks:
- `cd ~` - go to the home directory
- `cd Desktop` - change directory to the desktop
- `cd ..` - go back up a directory
- `ls` - list contents of current directory
- `pwd` - display the working directory
- `jobs` - display a list of currently running jobs
- `locate .csd` - searches for all .csd files
- `makedir myfolder` - creates a directory
- `rm myfile.txt` - removes file 'myfile.txt'

You should also be aware that in Unix white spaces are part of the command lines. White spaces should be enclosed in quotes or escaped with the `\` backslash to avoid any confusion:

For instance: `cd Pando Packages` should be `cd "Pando Packages"` or `cd Pando\ Packages`

Please, do keep in mind that it is very easy to delete files in Unix, so do be careful when in the Terminal! With great powers come great responsibilities!
## V. Optimizing your workflow and closing words


When working from the Terminal you will find yourself using the mouse less and less, which will greatly speed things up. For instance, when in the Terminal, pressing the up and down arrow keys will cycle through the last commands typed, which will allow you to easily re-render the current csd file between code tweaks almost instantaneously. Just make the adjustments to your code, save your csd file, go back to the terminal, press the up key and your new render is only one key press away. Remember that you can switch between applications by pressing the command and tab keys!

Choosing the right text editor is also crucial, and often a matter of personal preferences. On the Mac I would recommend jEdit: http://www.jedit.org/. It is a great text editor and thanks to Jacob Joaquin's work, it now supports Csound syntax highlighting. You will need to install it separately, but it is a rather simple procedure well worth the effort: http://www.thumbuki.com/csound/jedit/ Syntax highlighting benefits both newbies and experienced users and is a great visual help when parsing through pages of code.

You should notice an improvement in performance when using the Terminal compared to a front-end. The Activity Monitor, located in the same directory as the Terminal is a great tool to monitor your computer's overall performance and resource allocation. It will allow you to monitor CPU usage by application, disc and memory usage along with many other aspects of your computer's activity. I would also recommend you drag its icon to the dock for quick access.

Hopefully by now you are starting to realize some of the possibilities and benefits available to you with the Terminal. In this introduction we have barely scratched the surface. There is much, much more to explore... Happy Coding!
## References


I would like to thank Jacob Joaquin for his wonderful work and guidance, Dr. Richard Boulanger for his continued inspiration and support and Steven Yi for being giving me the opportunity to publish in the Csound Journal.

[][1] Joaquin, Jacob.
 [http://www.csounds.com/journal/issue7/commandLineFXProcessing.html](http://www.csounds.com/journal/issue7/commandLineFXProcessing.html)

 [][2] Miller, David.
 [http://www.macdevcenter.com/pub/a/mac/2004/02/24/bash.html](http://www.macdevcenter.com/pub/a/mac/2004/02/24/bash.html)

 [][3] [http://www.unixtools.com/tutorials.html](http://www.unixtools.com/tutorials.html)

 [][4] [http://www.ee.surrey.ac.uk/Teaching/Unix/unix8.html](http://www.ee.surrey.ac.uk/Teaching/Unix/unix8.html)

 [][5] Csounds.com [http://www.csounds.com/manual/html/CommandFlags.html](http://www.csounds.com/manual/html/CommandFlags.html)

 Joaquin, Jacob. [http://www.thumbuki.com/csound/blog/](http://www.thumbuki.com/csound/blog/)

 Jerry Peek, Grace Todino & John Strang.
 [http://www.unix.com.ua/orelly/unix/lrnunix/](http://www.unix.com.ua/orelly/unix/lrnunix/)
