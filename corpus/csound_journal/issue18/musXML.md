---
source: Csound Journal
issue: 18
title: "Csound and MusicXML"
author: "visualizing the music in terms of common practice notation"
url: https://csoundjournal.com/issue18/musXML.html
---

# Csound and MusicXML

**Author:** visualizing the music in terms of common practice notation
**Issue:** 18
**Source:** [Csound Journal](https://csoundjournal.com/issue18/musXML.html)

---

CSOUND JOURNAL[](https://csoundjournal.com/index.html) | [Issue 18](https://csoundjournal.com/index.html)
## Csound and MusicXML
 Jim Hearon
 j_hearonAT Hotmail.com
## Introduction


This article describes a workflow, beginning with music notation as an input and ending with a Csound .sco file as an output. Drum patterns, drum machines, MIDI, MusicXML, and Csound, along with additional software plugins and programs are covered in the description of the workflow below. Versions used for this article were: Csound 5.19, libmusicxml2, and Fedora 18.


## I. MusicXML and libmusicxml2


MusicXML is an XML file format used to exchange music notation data between programs that support it. Sibelius[[1]](https://csoundjournal.com/#ref1) music notation software supports importing and exporting MusicXML files, and is a good place to begin if entering music using common practice notation. For Csound, there are various methods, languages and meta-languages for entering data which can be compiled and rendered as audio or MIDI. The Score[[2]](https://csoundjournal.com/#ref2) and Csbeats[[3]](https://csoundjournal.com/#ref3) languages are typical ones for entering data to be performed by Csound, and CsoundAC includes support for reading MusicXML files, when compiled with libmusicxml2.

Essentially a set of XML tags that describe music notation elements, MusicXML can be manipulated using functions available in the libmusicxml2 library[[4]](https://csoundjournal.com/#ref4). The MusicXML library is different from generalized XML processors(such as Apache Xerces), and implements tags specifically for sharing digital sheet music between applications[[5]](https://csoundjournal.com/#ref5).

CsoundAC includes a compile-time option to use the MusicXML Library. If entering music notation in Sibelius, for example, the file can then be exported as a MusicXML document and imported into Csound utilizing CsoundAC compiled with libmusicxml2, then saved as a .sco file. This workflow provides the opportunity to begin by visualizing the music in terms of common practice notation. It then allows for shaping the instruments that play the notation utilizing the software synthesis power available through Csound. It can also help incorporate common practice notation elements with samples for an interesting textural combination for composition.


## II. Percussion Notation as MusicXML File


Simple grid-like drum patterns, suitable for drum machines or drum plugins, are the starting point for this workflow. To gain a feeling for the common practice notation, rhythmical qualities of drum machines and drum machine notation, the reader is directed towards The *American Mavericks* website and the virtual Rhythmicon[[6]](https://csoundjournal.com/#ref6) by Henry Cowell. In this example however we will use one of the patterns from "Instant Drum Patterns" from Five Pin Press[[7]](https://csoundjournal.com/#ref7). You can view the short example as a percussion score in the accompanying [.pdf file](https://csoundjournal.com/downloads/2RANDB.pdf), and you can listen to an audio rendering of the file using General MIDI virtual drum sounds. [![](images/musicxml/ex1mp3.png)](https://csoundjournal.com/audio/2RANDB.mp3)

The drum patterns from Five Pin Press are available as MIDI files and can be opened, viewed, and altered in Sibelius or your favorite notation program which includes MusicXML support. These patterns can then be exported as MusicXML files.

Much has been written about the notation for drum patterns and the mapping of the percussion sounds, for example, using General MIDI for playback devices[[8]](https://csoundjournal.com/#ref8). It should be obvious that an alternate workflow at this point would be to utilize a notational drum pattern as a MIDI file to be performed by a virtual drum machine. Another possibility is to use Rewire with Sibelius for performing the notation using another program such as Ableton Live or ProTools. However, the point of this article is utilizing MusicXML to export from Sibelius and import into Csound. Additionally, Csound's sound synthesis and generating methods are much more diverse than the typical drum machine or GM mapping. The possibilities for performing the drum pattern voices utilizing your own new and interesting sounds crafted in Csound might be of interest.

While drum patterns are the focus of this article, many other types of downloadable MusicXML files have been posted on the internet[[9]](https://csoundjournal.com/#ref9). As an alternative to working with percussion notation you might want to experiment with MusicXML files for J.S. Bach's Brandenburg Concertos, for example, creating your own Csound "Switched-On Bach", or utilize any of the other digital sheetmusic examples as MusicXML files.


## III. Compiling with CsoundAC


In Csound vers. 5.19, `#ifdef` statements in the CsoundAC code allow for using portions of libmusicxml2. For this article, you will need a version of Csound with CsoundAC that is linked to libmusicxml2, and you may have to compile it yourself. CsoundAC compile flags for a Linux build are set in SConstruct.py and any custom locations for dependency libs and headers are listed in custom.py. For libmusicxml2 you need the library and header files located on your machine[[4]](https://csoundjournal.com/#ref4), and if those sources are not located in a standard location you also need to list their location in custom.py. You may also need to add to the LD_LIBRARY_PATH variable to include the path to your libmusicxml2. A small script such as the one shown below can help add the path to the variable.
```csound
#!/bin/bash
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/path_to_your/musicxml2
export LD_LIBRARY_PATH
echo $LD_LIBRARY_PATH
```


For a better understanding of the current typical use of CsoundAC, see ["Composing in C++"](http://www.csounds.com/journal/issue17/gogins_composing_in_cpp.html) by Michael Gogins from *Csound Journal*, issue 17. CsoundAC is many things; it evolved from and still includes the concepts from Gogins' Silence and its use of Events. For those curious about how the source code in CsoundAC and libmusicxml2 currently functions, you can download the source files for libmusicxml2[[4]](https://csoundjournal.com/#ref4), use the sample files from libmusicxml2, and look at several . cpp source and .hpp header files from CsoundAC sources such as: `CppSound`, `csound`, `CsoundFile`, `Event`, `MusicModel`, `Score`, and `Silence`. For locating methods and following #includes throughout the various sources, I recommend using the command line utility *grep*.


## IV. Csound Orch and Score


The basic code below, from the example1 folder, will import an XML file and save it as a .sco file, using a single instrument listed in the output .sco file. You can also use the "load" method, `csound->load("myfile.xml")`, instead of `csound->importFile`. This approach is simple and straightforward, but there is no facility for rendering various instruments in the score using this approach. However, the basic code here functions as proof of concept that loading a MusicXML file works in Csound once you have a compiled version of Csound with CsoundAC linked to libmusicxml2. For the full version of all code examples, you can download the code for this article here, [MusicXML_Exs.zip](https://csoundjournal.com/downloads/MusicXML_Exs.zip).
```csound

int main()
{

csound::MusicModel model;
CppSound *csound = model.getCppSound();
csound->importFile("/path to your file/myfile.xml");
csound->save("/path to save your file/myfile.sco");

return 0;
}
```


When exporting a MusicXML file from a host application, the MusicXML library generates XML tags for all aspects of the digital sheet music. The various tags cover elements such as clefs, staffs, number of parts on each staff, instruments, instrument-sound, etc. For the purpose of creating a simple example, this article will focus on a MusicXML file in which there is one part per staff, and where each staff has a different instrument name.

In order to parse the tags in a MusicXML file, the MusicXML project[[4]](https://csoundjournal.com/#ref4) provides simple .cpp example files which can be used as starter files to develop an understanding for using libmusicxml2. These files include the use of the "visitor" concept, which allow for browsing the memory representation of a score[[10]](https://csoundjournal.com/#ref10). Various visitors are provided, but the one which closely matches the elements which are part of CsoundAC API Silence Events is the `midicontextvisitor`.

In order to load or import a MusicXML file that uses various instruments, and then to have those instruments represented in the score output file, one current problem is CsoundAC's Score.cpp includes a load method which calls a nested, unexposed class, ScoreMidiWriter, as midicontextvisitor. Unexposed here means not available as a publicly defined method in the associated header resource file. While there are various approaches to solving this problem, the approach employed here, and the one suggested by Michael Gogins via email to this author, is to create our own local Score and ScoreMidiWriter classes. These classes would then inherit methods from CsoundAC's Score and libmusicxml2's midiwriter classes so that it is possible to customize the load method and make changes to our own custom midicontextvisitor to respond to the instrument tags in the parsed MusicXML file. By creating custom classes which employ inheritance, we have the benefit of also utilizing the existing exposed methods of the CsoundAC API.
```csound
class myMidiWriter : public midiwriter
{
  public:
   long tpq;
   double tempo;
   double myinstNum = 0;

myMidiWriter(Score *score_) : tpq(480), tempo(1.0), score(*score_)
{
  score.clear();
  score.removeArrangement();
}

virtual void startPart (int instrCount)
{ }

virtual void newInstrument (std::string instrName, int chan=-1)
{
  myinstNum++;
}

virtual void endPart (long date)
{ }

virtual void newNote (long start_, int channel_, float key_, int velocity_, int duration_)
{
  double start = double(start_) / double(tpq) * tempo;
  double duration = double(duration_) / double(tpq) * tempo;
  double status = 144.0;
  double channel = myinstNum;
  double key = key_;
  double velocity = velocity_;
  score.append(start, duration, status, channel, key, velocity);
}

virtual void tempoChange (long date, int bpm)
{
  tempo = 60.0 / double(bpm);
}

virtual void pedalChange (long date, pedalType t, int value)
{ }

virtual void volChange (long date, int chan, int vol)
{ }

virtual void bankChange (long date, int chan, int bank)
{ }

virtual void progChange (long date, int chan, int prog)
{ }

public:
  Score &score;
};

```


In the code accompanying this article, you can see the `myscore` and `myMidiWriter` classes which are the local, derived classes using inheritance. The `myMidiWriter` class, shown above, inherits from libmusicxml2's `midiwriter` class, which is an abstract interface found in `midicontextvisitor.h` within the MusicXML source code[[4]](https://csoundjournal.com/#ref4). The interface lists the various virtual void methods, such as `startPart`, `newInstrument`, `endPart`, that is implemented in the custom `myMidiWriter` class, above.

The `myscore` class, shown below, inherits from CsoundAC's `Score` class, and defines a `myload` method which loads the MusicXML file and calls `myMidiWriter` to parse the MusicXML file tags using a `midicontextvisitor`. In other words, for this particular approach we only need to parse the file for typical MIDI elements. For a different type of example you may need a different type of visitor class. While visiting the MusicXML file and parsing tags, the `newInstrument` method from the `myMidiWriter` class is the method which identifies the instrument name tags ("instrument-name" ), and responds by incrementing a `myinstNum` variable (double value) whenever the instrument name changes.

Incrementing a number every time the instrument changes is a very simple approach used in the example for this article. However, you may want to do something more complicated such as get and compare strings of instrument names located within the tags, in order to create instrument numbers or named instruments in the Csound score. This assumes that you are able to generate instrument names when saving or exporting your digital sheetmusic file to MusicXML format. In Sibelius, for example, in addition to the program's included list of instrument names, it is possible to create a custom instrument name, temporarily, and export the MusicXML file using the custom instrument name(s).
```csound
class myscore : public Score
{
  public:
   virtual void myload(std::string filename);
};

void myscore::myload(std::string filename)
{
  System::inform("BEGAN myScore::load(%s)...\n", filename.c_str());
  if (filename.find(".xml") != std::string::npos ||
   filename.find(".XML") != std::string::npos)

 {
   xmlreader xmlReader;
   Sxmlelement sxmlElement;
   SXMLFile sxmlFile = xmlReader.read(filename.c_str());

   if (sxmlFile)
   {
    sxmlElement = sxmlFile->elements();
   }

   if (sxmlElement)
   {
    myMidiWriter scoreMidiWriter(this);
    midicontextvisitor midicontextvisitor_(scoreMidiWriter.tpq, &scoreMidiWriter);
    xml_tree_browser xmlTreeBrowser(&midicontextvisitor_);
    xmlTreeBrowser.browse(*sxmlElement);
   }

 }
   else
   {
    System::error("Unknown file format in myScore::load().\n");
   }
   System::inform("ENDED myScore::load().\n");
}

```


 The following code shows the `main` method, from the example2 folder, which instantiates the myscore class. Since `myscore` inherits from the CsoundAC `Score` class, it is possible to use the publicly available methods from Score such as `getScore`, and `save`, shown in the code for the `main` method below.
```csound
int main()
{
csound::MusicModel model;
CppSound *csound = model.getCppSound();
myscore ms;

ms.myload("/path to your file/myxmlfile.xml");
ms.sort();

cout << ms.getCsoundScore() << end;
model.createCsoundScore(ms.getCsoundScore());
csound->getScore();
csound->save("/path to save your file/myfile.sco);

return 0
}

```


For this article Code::Blocks 10.05 [[11]](https://csoundjournal.com/#ref11) was used as a C++ Integrated Development Environment to compile the example files. It is also possible to work outside of an IDE and compile directly from the command line.

To compile from the command line, you will need to add all dependencies, including Csound headers and libraries. It may be necessary to run initial startup scripts, especially if your Csound build and installation has been placed in a non-standard location, as shown in the include paths below located in the /opt directory. For example you may need to export LD_LIBRARY_PATH, OPCODEDIR, OPCODEDIR64, and RAWWAVE_PATH variables according to your Csound location.

Once the variables to particular paths are set, something close to the commands below, using the g++ compiler with command line flags, should compile the example files if working from the command line outside of an IDE. Adjustments to the include file paths will be required for your system. The second line below shows using g++ to link the various Csound and MusicXML libraries to the object file output (main.o) to create the executable.

`g++ -Wall -fexceptions -O2 -Wall -g -std=gnu++11 -DUSE_DOUBLE -I/opt/csound519/H -I/opt/csound519/interfaces -I/opt/csound519/frontends/CsoundAC -I/opt/csound519 -I/opt/csound519/frontends/CsoundAC -I/opt/csound519/interfaces -I/opt/csound519/interfaces/musicxml2 -I/opt/csound519/interfaces/musicxml2/include -c /opt/csound519/main.cpp -o main.o
 g++ -o /opt/csound519/mytest main.o /opt/csound519/libCsoundAC.a /opt/csound519/libcsnd.so /opt/csound519/libcsound64.so /opt/csound519/interfaces/musicxml2/libmusicxml2.so /opt/csound519/libcsound64.so /usr/lib/libpthread.so /opt/csound519/_CsoundAC.so`

The end goal of the code is to create a program that can open a MusicXML file that has various instrument parts, list those parts as numbers in an output Csound .sco file, and further develop the `myMidiWriter` class methods to respond to various tags in a MusicXML file. Achieving this, you can design your own instruments in Csound to play the various parts listed in the score, or generate score events based on content from the MusicXML file. In addition you may want to experiment with changing the ticks per quarter and tempo parameters in the code (`tpq(480), tempo(1.0)`) in order to save generated parts as audio files. You could then import those audio files as audio tracks to sync and play along with some of the original MIDI parts, creating a mix of virtual drum machine and Csound synthesis generated audio parts for the final mix. Audio example2, below, uses MIDI tracks mixed with audio tracks generated by Csound that use custom percussion sounds designed with variants of the Risset Drum Instrument. [![](images/musicxml/ex2mp3.png)](https://csoundjournal.com/audio/csoundMix.mp3)

Additionally, there are a few issues when exporting MusicXML files using instrument names. One problem is when changing and/or assigning instrument names to staffs in the notation program, the playback sound associated with the instrument name also generates additional MusicXML tags, such as "instrument-sound" and "virtual-instrument" tags, etc. which can cause parser failures if those tags are idiomatic to a particular application. When working between applications, such as Csound and Sibelius, it is best to keep things clear and simple at first. Another problem, mentioned above, is the notation of drum patterns and mapping of percussion sounds. For non-pitched instruments the MIDI pitch number will typically export as a value of -1 instead of a pitch in the normal MIDI pitch range (20-127). You may need to alter your non-pitched and one-line staff percussion notations and convert those to notation using a clef, five-line staff, and a pitch, for better conversion to a Csound .sco file before exporting the MusicXML file.


## V. Conclusion


Currently there are several issues with libmusicxml-3.00 for Linux[[12]](https://csoundjournal.com/#ref12). The libmusicxml API and accessible methods are not user friendly. Many methods are void methods and have no return values. The Linux source code is currently designed for an Ubuntu 64-bit build only.

There are no build instructions for building from sources to build a 32-bit Linux version, and the Linux Makefile is obfuscated with many system header includes from several different operating systems. This makes customizing, and compiling your own version of the library very, very difficult. There will need to be some changes implemented before version 3 of the software library for MusicXML can be widely adopted and utilized.

Many commerical and open source software music applications, however, have included MusicXML as standard, and thus there is more interoperabillity between those applications via importing and exporting files in MusicXML format. Since the definition set for music schemas (Document Type Definition) is small compared to other disciplines, MusicXML stands a good chance of becoming a de facto standard for file use between music applications, eventually perhaps replacing MIDI.


## References


[][1] Sibelius 7. (2013). [Online]. Available: [http://www.sibelius.com/products/sibelius/7/index.html](http://www.sibelius.com/products/sibelius/7/index.html). [Accessed January 29, 2013].

[][2] Barry Vercoe et Al. 2005. "The Standard Numeric Score." *The Canonical Csound Reference Manual*. [Online]. Available: [http://www.csounds.com/manual/html/ScoreTop.html](http://www.csounds.com/manual/html/ScoreTop.html). [Accessed Janurary 29, 2013].

[][3] Barry Vercoe et Al. 2005. "Csbeats." *The Canonical Csound Reference Manual*. [Online]. Available: [http://www.csounds.com/manual/html/CsBeats.html](http://www.csounds.com/manual/html/CsBeats.html). [Accessed Janurary 29, 2013].

[][4] Sourceforge. MusicXML library. (2013). [Online]. Available: [http://sourceforge.net/projects/libmusicxml](http://sourceforge.net/projects/libmusicxml). [Accessed Janurary 30, 2013].

[][5] MakeMusic. "What is MusicXML?" [Online]. Available: [http://www.makemusic.com/musicxml](http://www.makemusic.com/musicxml). [Accessed Janurary 30, 2013].

[][6] American Public Media. "American Mavericks: The Online Rhythmicon." [Online]. Available: [http://musicmavericks.publicradio.org/rhythmicon](http://musicmavericks.publicradio.org/rhythmicon/)/. [Accessed Janurary 30, 2013].

[][7] Joel Sampson. "Five Pin Press." [Online]. Available: [http://www.fivepinpress.com/](http://www.fivepinpress.com/). [Accessed Janurary 30, 2013].

[][8] Tom Rudolph. "Scoring Percussion and Drum Set Parts in Sibelius." [Online]. Available: [http://www.tomrudolph.com/presentations/Drum%20Set%20notation%20Sibelius.pdf](http://www.tomrudolph.com/presentations/Drum%20Set%20notation%20Sibelius.pdf). [Accessed Janurary 30, 2013].

[][9] MakeMusic. "MusicXML Sites." [Online]. Available: http://www.makemusic.com/musicxml/music. [Accessed Janurary 30, 2013].

[][10] LibMusicXML Overview. Sample code. Visiting a score. [Online]. Available: [http://libmusicxml.sourceforge.net/doc/sample.html](http://libmusicxml.sourceforge.net/doc/sample.html). [Accessed July 21, 2013].

[][11] Code::Blocks. [Online]. Available: [http://www.codeblocks.org/](http://www.codeblocks.org/).[Accessed Janurary 30, 2013].

[][12] Google code. libmusicxml. [Online]. Available: [http://code.google.com/p/libmusicxml/downloads/list](http://code.google.com/p/libmusicxml/downloads/list). [Accessed Janurary 30, 2013].
### Additional Resources

- MusicXML DTD (Document Type Definition):


  - MakeMusic. "MusicXML DTD." [Online]. Available: [http://www.makemusic.com/musicxml/specification/dtd](http://www.makemusic.com/musicxml/specification/dtd). [Accessed Janurary 30, 2013].



- MusicXML Encoding, and MusicXML Score DTD Examples:


  - Songs and Schemas. "MusicXML for Notation and Analysis." [Online]. Available: [http://michaelgood.info/publications/music/musicxml-for-notation-and-analysis/](http://michaelgood.info/publications/music/musicxml-for-notation-and-analysis/). [Accessed Janurary 30, 2013].
