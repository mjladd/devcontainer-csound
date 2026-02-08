---
source: Csound Journal
issue: 17
title: "Interfacing Cscore Part II"
author: "the
          function"
url: https://csoundjournal.com/issue17/InterfacingCscore2.html
---

# Interfacing Cscore Part II

**Author:** the
          function
**Issue:** 17
**Source:** [Csound Journal](https://csoundjournal.com/issue17/InterfacingCscore2.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 17](https://csoundjournal.com/index.html)
## Interfacing Cscore Part II
 Jim Hearon
 j_hearon AT hotmail.com
## Introduction


This article is a follow-up or companion article to the previous article "Interfacing Cscore" from *Csound Journal,* issue 16[[1]](https://csoundjournal.com/#ref1). Included in this article is a description of code linking to libgsl (GNU Scientific Library), employing GSL random distributions and probability density functions, as well as modified code sources from libsmf for saving to standard MIDI file format employing PPQN (pulses per quarter note). Also included in this article is a brief audio example extracting a portion of the Csound score file for output. Software versions used for this article were Fedora 16, Csound5.16, GSL-1.15-3, and libsmf-1.3 sources.
##  I. GSL


The GNU Scientific Library, or GSL, provides numerous C code numerical routines and can be used to help with Csound score file generation. The code included with this article demonstrates an approach for employing GSL random number distributions as well as probably density functions, but there are also many other types of numerical routines available in the GSL package. You can download the code which uses GSL for this article, [gsl.c.zip](https://csoundjournal.com/gsl.c.zip), here. Like the previous article, the code for this article only draws upon the random distribution functions for the purpose of demonstrating just one approach to developing score files utilizing the Cscore preprocessor.

To use the GSL functions for random distribution, you will need to include `<gsl/gsl_rng.h>,`and `<gsl/gsl_randist.h> `in your code. To compile your project, you will need to include the GSL headers and link to the GSL library. For example, with GCC, you would use `-I/usr/include/gsl,` when compiling, and `-lgsl,` when linking (assuming the headers are installed in `/usr/include/gsl`).

The number of distribution functions available in GSL is large, depending upon which version of GSL you employ. The previous article showed a custom approach to creating your own distribution functions but there are at least two benefits to using GSL's library of distributions: 1.) the work of coding the distribution functions is already done for you, and 2.) cumulative and probability density functions are also included for almost all distributions.

 However there are a couple of downsides to using GSL. The code is in the C language and if using C++ you probably want to use Math and Math/Statistical Distributions from Boost. Boost is utilized as a Csound source level header and gets inlined in compilation for CsoundAC as well as CsoundVST. One thing to be aware about when using GSL routines is that many functions are prone to returning NAN (not a number) and you need to account for that in your own code.

 Using GSL's probability density functions, one is able to control the probability that a number sent to the preprocessor falls statistically within a particular distribution. For example the Gaussian Distribution, defined in the library and *GNU Scientific Library --Reference Manual,*[[2]](https://csoundjournal.com/#ref2) is shown below

Function: `double gsl_ran_gaussian (const gsl_rng * r, double sigma) `

`p(x) dx = {1 \over \sqrt{2 \pi \sigma^2}} \exp (-x^2 / 2\sigma^2) dx`

 Function: `double gsl_ran_gaussian_pdf (double x, double sigma)`

In the function prototype above, the double value returned by the function `gsl_ran_gaussian` can be utilized in the parameter list for the function `gsl_ran_gaussian_pdf` as the double value x. The probabilities returned by the function `gsl_ran_gaussian_pdf` provide an indication of a goodness of fit using the standard deviation `sigma`. Low probabilities (such as 0.01, 0.02 etc.) indicate results which have a smaller probability of falling within the distribution's expected curve or region.

 Besides the library and headers, installations of GSL includes two programs: gsl-randist, a program for generating random distributions into a .dat file, and gsl-histogram, a program for visualizing .dat files using the plotutils 'graph' utility. These two programs are helpful for visualizing on a graph the fit of a distribution.
## II. SCORE


 As in the previous article, the current code utilizes a Csound API method to initialize Cscore: `int csoundInitializeCscore(CSOUND *, FILE *insco, FILE *outsco).`

 A custom function in the accompanying code creates a score file employing the Cscore API preprocessor. The Cscore API [[3]](https://csoundjournal.com/#ref3) , from `cscore.h`, contains functions for working with single notes, event lists, working with memory, and multiple input score files. It can do all of the work of creating and manipulating score files given the data it needs to create and populate various p-fields. There are many good score generation applications written for Csound, but the purpose of the code with this article is to simply demonstrate an approach to feeding the score generating preprocessor API using the C language. Cscore and score files (along with SCOT, SCSORT, EXTRACT, and CSBEATS) are important tools for the production and creation of music using Csound.
## III. Standard Midi File


 In addition to feeding the preprocessor and creating a .sco file, the code in this article also demonstrates saving to standard MIDI file using PPQN (pulses per quarter note). Saving to standard MIDI file is a good intermediate step in the creative process when generating .sco files. On Linux for example, one is able to quickly do a sound check importing a MIDI file into Rosegarden, utilizing Qsynth with Soundfonts, Jack and QjackCtl. Rosegarden, an audio and MIDI sequencing environment, also includes an option to save a file to a Csound .sco format. (See [Additional Resources](https://csoundjournal.com/#additionalResources), below, for URLs for Rosegarden, Qsynth, Jack and QjackCtl.)

 There at least two good open source C code MIDI file packages available for saving to standard to MIDI file. Portmedia has a Portsmf body of code [[4]](https://csoundjournal.com/#ref4) , but it does not exist in library format and the sources, which are intricately connected, are difficult to integrate with custom applications. Libsmf, which does have a compiled library [[5]](https://csoundjournal.com/#ref5) , is easier to work with, but the library does not include functions for setting MIDI meta events such as time signature, time scale, and system clock speed. When the libsmf source code is modified however, libsmf does a good job of saving to smf format using variable PPQN settings so that the MIDI file is able to be opened by standard commercial applications such as Cubase, Sibelius, and ProTools. The code example utilizes a modified version libsmf; the modified source files are included in [gsl.c.zip](https://csoundjournal.com/gsl.c.zip) and are used for the project, rather than linking in the standard version of libsmf.
## IV. Audio Examples


 Utilizing the code included with this article, an example has been created generating 256 notes in the range of MIDI pitch numbers 20 to 127, using the GSL t-distribution. The result is the listening example below, which by itself is not very musical. However you may be able to hear an interesting development in the distribution spin from 16 to 21 seconds or beginning measure 5 if calculating the quarter note equals 60 bpm. You can hear the numbers returned from the distribution have slightly changed at this point, and thus we might want to exploit this change in the distribution and extract this portion of the score for use at a later time.  [![](images/intCscore/ex1mp3.png)](https://csoundjournal.com/audio/t-dist_full.mp3)

 The Csound API includes the method `csoundScoreExtract(csound, inFile, outFile, extractFile)` which allows using the features of extract.exe from within a host [[6]](https://csoundjournal.com/#ref6) . In this case the example host from Csound/frontends/csound/c will work for us with only slight modifications. The C code host example from frontends is designed for initializing and compiling with Csound using command line arguments, but in this case we only need to use Csound long enough to call to the API score extract method. You can download the extract code example for this article, [extract.c.zip](https://csoundjournal.com/extract.c.zip), here. The host example is modified slightly from the original by commenting out `csoundInitialize(&argc, &argv, 0)`, by adding the call to `csoundScoreExtract`, as well as including a pointer to a `const char vector[]` to list the string names of the inFile, outFile, and extractFile utilized by `csoundScoreExtract`. The following audio example is the extracted portion from the t-distribution example, above. [![](images/intCscore/ex2mp3.png)](https://csoundjournal.com/audio/t-dist_short.mp3)

 For a different approach, you could also perform note extraction from event lists by running the external standalone Csound utility EXTRACT if your Csound distribution was compiled with the include utilities flag set in sconstruct while building Csound. There are several approaches available for manipulating score file note lists using Csound, once you have your note lists in score format.
## V. Conclusion


 Score files (along with SCOT, SCSORT, EXTRACT, and CSBEATS) are an important component of Csound for the production and creation of making music. The GNU Scientific Library, GSL, provides numerous C code numerical routines and can be used to help with Csound score file generation. Saving score file output also to standard MIDI file, SMF, using PPQN (pulses per quarter note) is a good intermediate step for creativity since this allows you to test files in standard commercial applications which read and play MIDI files. With a few modifications to include setting MIDI meta events, libsmf works well for this purpose. Another Csound API method, `csoundScoreExtract`, is also useful for extracting portions of score files.
## References


[][1]]Jim Hearon. "Interfacing Cscore." *Csound Journal*, issue 16, January 24, 2012. [Online] Available: [http://www.csounds.com/journal/issue16/index.html](http://www.csounds.com/journal/issue16/index.html). [Accessed March 9, 2012].

[][2]]"The Gaussian Distribution," in *GNU Scientific Library --Reference Manual*. [Online] Available: [http://www.gnu.org/software/gsl/manual/html_node/The-Gaussian-Distribution.html](http://www.gnu.org/software/gsl/manual/html_node/The-Gaussian-Distribution.html). [Accessed March 9, 2012].

[][3]]Barry Vercoe et Al. 2005. "Cscore. Event, Lists, and Operations." *The Canonical Csound Reference Manual*. [Online]. Available: [http://www.csounds.com/manual/html/CscoreTop.html#CscoreEvents](http://www.csounds.com/manual/html/CscoreTop.html#CscoreEvents). [Accessed March 10, 2012].

[][4]]*PortMedia APIs.* "Platform Independent Libraries for Sound and MIDI." [Online] Available: [http://portmedia.sourceforge.net](http://portmedia.sourceforge.net)/. [Accessed March 10, 2012].

[][5]]*Standard MIDI file format library.* [Online] Available: [http://sourceforge.net/projects/libsmf/](http://sourceforge.net/projects/libsmf/). [Accessed March 10, 2012].

[][6]]Barry Vercoe et Al. 2005. "Score File Preprocessing. The Extract Feature." *The Canonical Csound Reference Manual*. [Online]. Available: [http://www.csounds.com/manual/html/CommandPreproc.html#commandpreextract](http://www.csounds.com/manual/html/CommandPreproc.html#commandpreextract). [Accessed March 10, 2012].
### Additional Resources

- Two, from the list of many, applications which help with Csound score generation:


  - Bill Beck, Phil Sobolik, Hans-Steiner, and Jean Piché. *Cecelia*. [http://www.csounds.com/cecilia/](http://www.csounds.com/cecilia/)


  - Andre Bartetzki, and Anthony Kozar. *CMask*.[ http://www.bartetzki.de/en/software.html](http://www.bartetzki.de/en/software.html)


- More information on gsl-randist.c and gsl-histogram.c:
  - "randist/gsl-randist.c", also included as part of *GNU Scientific Library*. [http://uncwddas.googlecode.com/svn/trunk/other/gsl-1.8/gsl-randist.c](http://uncwddas.googlecode.com/svn/trunk/other/gsl-1.8/gsl-randist.c)


  - "View of /truck/packages/gsl/gsl-histogram.c", also included as part of *GNU Scientific Library*. [https://accserv.lepp.cornell.edu/cgi-bin/view.cgi/trunk/packages/gsl/gsl-histogram.c?logsort=rev&revision=19918&view=markup&sortdir=down](https://accserv.lepp.cornell.edu/cgi-bin/view.cgi/trunk/packages/gsl/gsl-histogram.c?logsort=rev&revision=19918&view=markup&sortdir=down)


- *The plotutils Package.* [http://www.gnu.org/software/plotutils/ ](http://www.gnu.org/software/plotutils/)


- *man@planet.CCRMA. * "gsl-randist (1)." [http://mirror1.atrpms.net/ccrma/man/man1/gsl-randist.1.html](http://mirror1.atrpms.net/ccrma/man/man1/gsl-randist.1.html)


- The planet CCRMA page shows the command line syntax for using gsl-randist and gsl-histogram:
```csound
gsl-randist 0 10000 tdist 0.6 | gsl-histogram -100 100 200 > tdist.dat
awk '{print $1, $3 ; print $2, $3} ' tdist.dat | graph -T X
```

- The so called "Student's T Distribution": William S. Gosset, a statistician at the Guiness Brewing Company, created the distribution in 1908. [http://www-stat.stanford.edu/~naras/jsm/TDensity/TDensity.html](http://www-stat.stanford.edu/~naras/jsm/TDensity/TDensity.html)


- Rosegarden: http://www.rosegardenmusic.com/


- Qsynth, Qt GUI Interface for FluidSynth: http://qsynth.sourceforge.net/qsynth-index.html


-  Jack Audio Connection Kit: http://jackaudio.org/


- QjackCtl JACK Audio Connection Kit - Qt GUI Interface: http://qjackctl.sourceforge.net/
