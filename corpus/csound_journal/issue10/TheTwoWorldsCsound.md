---
source: Csound Journal
issue: 10
title: "The Two Worlds of Csound"
author: "dozens of different cultures that speak distinctly separate dialects"
url: https://csoundjournal.com/issue10/TheTwoWorldsCsound.html
---

# The Two Worlds of Csound

**Author:** dozens of different cultures that speak distinctly separate dialects
**Issue:** 10
**Source:** [Csound Journal](https://csoundjournal.com/issue10/TheTwoWorldsCsound.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 10](https://csoundjournal.com/index.html)
## The Two Worlds of Csound

### Running Doubles and Floats on The Same Computer
 Jim Bates
 jabates AT onelinkpr DOT net
## Introduction


 Learning Csound is a lot like learning Chinese. Both are languages that have over a thousand different characters, each one of which is capable of being used in different contexts, with a resultant different effect. Both are object-oriented, each in their own fashion and both have written forms that cross many diverse language barriers. While Chinese can be understood by dozens of different cultures that speak distinctly separate dialects, Csound can be understood by computers across a wide range of platforms and it also interfaces with numerous other computer languages. While both could be said to be musical, the similarities end there. While Chinese is many millennia old, Csound is much younger, turning 23 this year; 30 years younger than its older digital brother, Fortran.

 In those 23 years, Csound has matured not only in its capabilities for generating, routing, transforming and analyzing digital audio, but also in the increasing number of computer languages with which to interface. It has been developed to the level of processing digital audio internally at either 32-bit or 64-bit floating point precision, and will do so on either 32-bit or 64-bit computer architecture.

 As it has only been a few years since 64-bit computers became commercially available, there still exists quite a bit of controversy over the issue of *32-bit vs. 64-bit audio.* In fact, if you do a Google search with that exact phrase, you get back 2.3 million sites as a result. Understandably, it is a rather hot issue. The whole issue is that it has been customary to only have one version installed on your computer--until now.
##
 I. Two Versions–Two Views


### A Question of Speed


 The revised Csound Manual for version 5.09 states the following:

 *There is a good deal more *digital signal processing headroom* with double Csound, and therefore it should be used for all music rendered for critical listening. The float version should only be used where its speed advantage of about 15% is critical for real-time performance.*

I beg to differ on that last point. The floats version of Csound has quite a few other uses besides real-time performance. The operative word in the above manual excerpt is *critical*. Not every aspect of sound processing, of sound design or composition, is critical. If you are working out the ratios for an exotic tuning, it has to sound right of course, but Csound floats is adequate for the job. The final composition where that work is put to use would naturally fall into the 'critical' category. Or take synthesizer design: the rough layouts of the synth can just as easily be done in 32-bit, as it has not been refined enough yet for the added bits to do more than overtax your cpu. As the development takes shape and the sound comes into the realm that you are shooting for, then one can move it over to 64-bit.

Personally, I find the 15% speed factor of floats useful in speeding the work flow, even when the final result will be only run in doubles. This includes csd files that have to be rendered, instead of being played live. I was recently designing dither algorithms, and the work was quite intensive, requiring repetitive renders of test files to review the results of different algorithms. I did the first seventy-five percent of the project in floats, and moved it over to the double version for the final honing, only when the algorithms were working well.

Csound compositions would follow the same work flow: initial layout and testing in floats version, with the piece being moved to doubles as it took form and texture and before the final tweaking and the final render was done. But it all hinges on the assumption: that only one version of Csound should be installed. If both versions of Csound were available on the same computer, I doubt the average Csounder would launch doubles for something like checking out a new opcode.
### A Matter of Apps


Then there is the matter of frontend applications for running Csound. I often use the command line for running Csound, sometimes for a different perspective, for a change of pace or just because the mood strikes me. I like to use one of the many frontends to Csound. Some of them, like MacCsound and Qutecsound (pictured below), only run on Csound floats, at least, as of this writing. MacCsound was one of the main Csound apps I started with when I first got into Csound years ago, and Qutecsound is brand new, so both have a certain appeal to me.

 [ ![image](images/TheTwoWorldsCsound_html_30225649.png)](https://csoundjournal.com/images/TheTwoWorldsCsound_html_30225649.png)

**Figure 1:** For years, this was one of the few graphical user interfaces around for the Mac. MacCsound still runs quite well, but only on floats.

[ ![image](images/TheTwoWorldsCsound_html_1746e8ab.png)](https://csoundjournal.com/images/TheTwoWorldsCsound_html_1746e8ab.png)

**Figure 2:** Based on Qt, the C++ toolkit, Qutecsound is currently only available to run under floats.

But, on the other side of the equation there are Csound apps such as Blue, which will only work with the Csound API if you are running doubles.

 [ ![image](images/TheTwoWorldsCsound_html_m1615eaf6.png)](https://csoundjournal.com/images/TheTwoWorldsCsound_html_m1615eaf6.png)

 **Figure 3:** The Csound frontend Blue interfaces with the Csound API only if you use Csound doubles.

I imagine that if I only used Csound for a particular single purpose I might have a very different view of it all. Eight years ago, when I first started with Csound, I considered it was a good composing environment, with possibilities for audio analysis, and an open road for sound synthesis. Then I discovered convolution and salvaged a recording of solo guitar that was badly missing resonance. Along the way I got the idea that Csound had the potential for audio mastering, but fell short of the mark when I tried to do anything along those lines. Shortly after I compiled my first version of Csound doubles, everything I had earlier envisioned began to take on a very real aspect. But it is still a great composing environment, and really without parallel in the digital audio world. For all of these reasons, and many more, I consider that Csound is best approached using both versions precision.
##
 II. Two Worlds–One Screen


### How Do You Like Them Apples


The simplest of ways for running both versions is to use MacOSX, where Csound will run both versions, each as a separate Framework in the /Library/Frameworks folder. On the SourceForge site you can download the package that will install the Csound library framework only, as a separate installation. It only installs the floats version (this is the case as of this writing--though the Csound developers will likely have OSX ppc and intel doubles packages by the time this goes to print). I had to compile the 64-bit doubles version myself, following the detailed instructions on the *Building Csound* part of the Csound manual.

As a note on compiling Csound, whether floats or doubles, the *Building Csound* section of the Csound manual lists the needed libraries and other software dependencies for compiling Csound and following this is crucial. But, there is one point that I gleaned from the Csound developers list, that had not yet been updated in the manual: the version of SCons should be the latest one available, contrary to the manual, which states that "versions later than 0.96.1 do not work". Csound 5.09 will not compile using SCons version 0.96.1. I used SCons version 1.1 and it compiled just fine on OSX.

I also re-compiled the Csound5GUI, giving it a different color for the 64-bit version and renamed it as well to Csound64GUI. That way there would be no confusion while running either version. I also changed the color of the 32-bit version of the Csound5GUI to fit my liking. They look like this:

[![image](images/TheTwoWorldsCsound_html_m6f7180de.png)](https://csoundjournal.com/images/TheTwoWorldsCsound_html_m6f7180de.png)

 **Figure 4:** Here you can see the two versions of Csound with their twin CsoundGUIs running side by side.

I also installed Csound, the doubles version, in the /usr/local directories, so that I can run doubles from the command line for critical tasks. There is also an additional advantage to running from the command line: you see first-hand how smoothly (or unsmoothly) the Csound code you have written actually runs, in ways you can never see when there is a GUI in the way.
##
 III. Csounding Penguins


### The Two Worlds on the Other Side of My Computer


I have five separate installations of Csound on my computer: three on OSX, the other two on Linux. Yes. You guessed it. I have both floats and doubles running on openSUSE LinuxPPC, installed on a separate partition of my hard drive. Due to the fact that my particular computer architecture gets later upgrades, the only version I could install from the package manager was version 5.02. So I installed it. It was, in addition, missing some of the things I was used to, and I almost settled for it as it was; then I decided that just would not do, and set about to compile a new version of Csound. I settled on 5.08 (as I had not yet learned about the SCons version point, and could not get 5.09 to compile...), and compiled an installation of doubles. I included the Csound64GUI, of course.

Then I noticed something: the original floats version I had downloaded with the Linux package manager was installed in the /usr directory. I went ahead and installed the doubles version into the /usr/local directories. And both ran fine, as long as I specified if running from the command line which Csound I was invoking, i.e. typing '/usr/bin/csound' or '/usr/local/bin/csound'. That is when I went ahead and compiled a 5.08 floats version, and modified the install.py file to put everything into the /usr directories (/usr/bin, /usr/include, usr/lib, etc.)

[![image](images/TheTwoWorldsCsound_html_m22c2340c.png)](https://csoundjournal.com/images/TheTwoWorldsCsound_html_m22c2340c.png)

 **Figure 5:** Csound doubles running with Csound floats on openSUSE Linux on the same G4PowerBook .
### Additional Notes on Running Csound Doubles


In addition to running from the command line, you should disable all graphics, unless you are doing audio analysis, where the graphic output would be needed. By actual test, graphics, even of the Fast Light Tool Kit variety, slow things down a bit. This is not to say you should not ever use the GUI. If the Csound orchestra and score files are in their initial stages, it may even be best to start the designing and/or composing process from the GUI (possibly using Csound floats version), and only eliminating it as it approaches completion, with the final run(s) being done from the command line.

For environment variables, on MacOSX, the Library framework sets the OPCODEDIR or OPCODEDIR64 directly. Also the Csound5GUI application has its own panel for entering where the OPCODEDIR resides, and if the Csound5GUI and Csound64GUI are compiled so they have their own separate preferences file, there will not be any 'cross-talk' between them (see my notes on compiling the Csound64GUI, below). As a last resort, you can always edit your .bash_profile file in your home directory. On MacOSX you will need a utility such as Xupport, TinkerTool or OnyX to make the files beginning with '.' visible for editing.
### Notes Compiling the Csound64GUI


There are only a few points you need to know for recompiling the Csound5GUI as the Csound64GUI (although, you do not have to call it that, but whatever name you choose you have to use consistently, or it will not compile properly). In the csound5 source folder there is a folder called *frontends*. In that folder you will find the *fltk_gui* folder. Check every file that has a suffix of .cpp or .hpp, and do a search for the word *csound5gui*. For every entry, replace the '5' with a '64'. You cannot (or should not) do a global *search and replace*, since some of the lines are spelled 'csound5gui', while others are spelled as 'CSOUND6GUI'. You should do the search with the 'ignore case' option enabled.

The file called ConfigFile.cpp needs to be searched for the word '.csound' , which designates a hidden folder that the application stores its preferences in. This needs to be changed to .csound64 (or other name, if you used a different one), otherwise the Csound64gui will automatically take the preferences that are set for the Csound5gui.

To change the color of the interface, open up a terminal window and type *fluid* and hit enter. This will open up the Fluid interface, which you can use to navigate to the /csound5/frontends/fltk_gui folder and open up the xx.fl files and edit them to choose different colors or textures for the app.
##
 IV. Reflections on the Future


### The Open Door


I know that the Csound Developers are hard at work to bring both versions of Csound to the MacOSX platform. By the time this is in print, it may well be an accomplished fact, or even *old news.* But that single fact also opens the door for every other platform as well, for the issues are about having a single brand: the Csound executable files, library files and extension files for both the floats and doubles versions have identical names. It becomes simply a matter of changing the source code, so that instead of compiling a 'csound' executable for the /usr/local/bin directory, it is a 'csound64' executable. Then both versions can smoothly run, side by side on the same system.

I am aware of how much work there is, from the work I did in recompiling the Csound5GUI to Csound64GUI (a relatively simple project by comparison), but I see no reason for not following through, so that any platform can run both floats and doubles. I have been running both versions on both my PowerBook G4 and my studio G5 for several months now and I must say that Csound has never been better! I recently used it to remaster some classical piano performances of a concert pianist with results that left the artist in a state of utter amazement. Using Csound alone, I accomplished, with a single pass on the command line (after some tweaking, to get the csd file just right), what I had not been able to accomplish with many hours of work in both Digital Performer and BIAS PeakPro5. But all speculation aside, Csound5 has made a jump forward that reaffirms its place at the forefront of digital audio.
## Acknowledgements
 I would like to thank all of the Csound developers, for their work in bringing Csound to its current state of power and flexibility. Csound remains on the cutting edge of digital audio solely because of your inspiration, dedication and persistence.
