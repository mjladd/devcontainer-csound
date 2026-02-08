---
source: Csound Journal
issue: 11
title: "Processing and csnd.jar"
author: "Gabriel Maldanado in CsoundAV"
url: https://csoundjournal.com/issue11/Processing.html
---

# Processing and csnd.jar

**Author:** Gabriel Maldanado in CsoundAV
**Issue:** 11
**Source:** [Csound Journal](https://csoundjournal.com/issue11/Processing.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 11](https://csoundjournal.com/index.html)
## Processing and csnd.jar
 Jim Hearon
 j_hearon AT hotmail dot com
## Introduction
 This article is about the Java interface classes to the Csound Application Programming Interface, and csnd.jar with Processing-1.0.1. Previous work with graphics in Csound by Gabriel Maldanado in CsoundAV, as well as current work by Jean-Pierre Lemoine in AVSynthesis are noted. A description on how to use the binary library csnd.jar within Processing is provided. Examples using the CsoundAPI employing the chnget and chnset Opcodes from within Processing's sketchbook are included. Also a brief example employing OSC is included. The example files for the code shown below are available here. [Examples.zip](https://csoundjournal.com/ProcessingExamples.zip).
##
 I. About Processing-1.0.1



Software employed for the examples below include Linux Fedora 10, Csound 5.10, JDK1.6.0_02, and Processing-1.0.1. Processing , which is open source software, is described as a programming language, and also as a development environment [[1]](https://csoundjournal.com/#ref1). The programming or development environment for Processing (PDE) includes a text editor, a compiler, and a display window. When the code, called a sketchbook, which is a subset of Java, is compiled it opens a display window for 2D and 3D graphics.

Processing employs JOGL, Java bindings for the OpenGL API, and is extensible by means of additional libraries packaged as .jar files for video, networking, audio, OSC control and interfacing. Since the PDE was not designed for library development, but rather for coding simple sketches, most library development for Processing is done separately from an IDE (Integrated Development Environment) such as Eclipse or Netbeans, and the Processing website also includes a template, and guidelines for how to build your own library for Processing [[2]](https://csoundjournal.com/#ref1). The purpose of this article, however, is about the use of csnd.jar as an available library for Processing.

For Csound users who have worked with Max/MSP and Jitter, or Pure Data (Pd) and Gem, the use of csnd.jar with Processing seems initially promising as an application for 2 and 3D graphics which is able to work well with Csound. While Processing is still young in terms of development, and will no doubt grow and change as Java's media capabilities continue to expand, the program's ability to interface with Csound should make it useful for those interested in graphics interactivity.

Long-time Csound users have also no doubt worked with CsoundAV which includes embedded OpenGL and has the ability to employ OpenGL statements in the .csd file. Java programmers interested in an integrated approach employing Csound and graphics should also see Jean Pierre Lemoine's AVSynthesis which uses JOGL, and is a composition tool application employing Csound and graphics. The Processing website also provides guidelines for library building in Eclipse, and it is possible to include JOGL, the Processing core library, csnd.jar, and additional media libraries and frameworks to build your own application which employs the Processing PApplet or base class[[3]](https://csoundjournal.com/#ref1).
## II. csnd.jar



On Linux, the Java interface classes for the CsoundAPI are created using the SCons build option from Sconstruct includes the option below.
```csound
commandOptions.Add('buildJavaWrapper','
Set to 1 to build Java wrapper for the interface library.','1')
```


Also the build file Custom.py should include the path to Java, if Java is not installed in the usual places. More information on how to build Csound is available from The Csound Manual, various websites, and the Csound mailing lists. Once Csound is built successfully you should have available the Java interface classes both as .java files, and as a packaged binary csnd.jar which can be used as a library in Processing. One Fedora issue with Java is the use of GCJ, the GNU Compiler for Java, instead of the Sun JDK. Fedora normally uses GCJ, thus the Sun JDK should be installed and environment variables set to point to the JDK.

Once you have built Csound, or have obtained csnd.jar from an installer, then copy and paste the jar file into a folder named "csnd" within the Processing libraries folder. Ex. Processing-1.0.1/libraries/csnd/library/cnsd.jar. You should then be able to import csnd.jar into your Processing sketch using the java command:
```csound
import csnd.*;
```


On Linux, while trying to compile code which accesses Csound libraries, frequently the lib_jcsound.so is not found due to installing Csound in a non-standard location, and an error message is displayed when in Processing which imports the csnd.jar.
```csound
_jcsound native code library failed to load.
java.lang.UnsatisfiedLinkError: no _jcsound in java.library.path
```


One way around this problem is to use the LD_LIBRARY_PATH variable, setting the path to lib_jcsound.so. A small shell script, run before starting processing should help solve the problem.
```csound
#! /bin/bash
LD_LIBRARY_PATH=/home/csound510
export LD_LIBRARY_PATH
echo $LD_LIBRARY_PATH
```


From the linux bash prompt:
```csound
$ cd processing-1.0.1
$. ./LoadLib.sh
```


then
```csound
$ bash processing
```


 When changing Csound versions be sure to also update the csnd.jar. Changes in Csound versions and/or the CsoundAPI will generally obsolete the previous Csound version wrappers which are bundled as binary files in the csnd.jar. This caveat also applies to code which uses the CsoundAPI.
## III. OSC



OscP5, and netP5 libraries can be added and imported into Processing for working with OSC (Open Sound Control)[[4]](https://csoundjournal.com/#ref1). Processing makes the images or graphics, and Csound creates the audio; and the two applications are able to communicate with each other via OSC.

Since OSC communicates via networking protocols, there can be many foibles when attempting to see OSC working properly. Therefore a good idea is to get OSC working between two instances of Csound first, then try communicating from Csound to Processing. On Linux you can open two terminal windows and run the examples osclisten.csd in one terminal and the oscsend.csd in the other terminal via Csound to make sure OSC is at least working between instances of Csound.

The next step is to establish a Csound to Processing communication using OSC messages. In Processing's Discourse it was suggested that employing an array in Processing to hold OSC messages was a best practices approach to programming. Thus the example files includes an oscarray.pde showing the use of arrays.

The use of OSC to trigger or control Processing from Csound involves making esthetic decisions for design of using such an approach. The speed of OSC in Processing may be something to consider, or users may simply need to periodically set events in motion; in which case OSC should work fine. There are several example videos on Vimeo using Csound, OSC, Processing, as well as AVSynthesis, and one can gain an idea of the types of events which can be accomplished using OSC.
## IV. Csound to Processing



In terms of speed, the Csound bus opcodes, and working with CsoundAPI may provide more direct control at the k-rate, as well as a-rate for Processing. In most .csd examples the k-rate is much faster than the typical .pde video frame rate, ex. 30 fps, therefore esthetic concerns are once again important in the decision making process regarding the relationship of audio with image.

On a very basic level audio either has a one-to-one relationship with image, an endless counterpoint with image which may sometimes nevertheless result in no relationship, and also an occasional or supporting relationship with image. The simple simultaneous sharing of perception space, in a manner such that sound and image together rise above what either could attain separately contributes to the perception of of those events as multimedia[[5]](https://csoundjournal.com/#ref1).

For the one-to-one correspondence, the ability to control image at the k-rate and a-rate can prove to be a very powerful method for creativity. In terms of using the Csound bus opcodes, the user should be able to create many interesting, different scenarios employing control or audio rate to manipulate images.

Contemporary art with sound and image includes many interesting relationships well beyond the basic ones listed above, such as placing video data in an OpenGL texture, converting video to pixels, crossfading between video streams, collage between simultaneous video streams, seeking and setting video playback speeds including backwards video, user interactivity with video, scrubbing video, video to audio FFT (Fast Fourier Transform), and employing external controllers and robotics. Artists working with multimedia tools such as Max/MSP & Jitter with MakingThings controller boards, lasers and Lemurs have been working with contemporary multimedia techniques on an advanced level for many years now. While Processing does not offer a completely happy marriage for audio and image with Csound, it does at least allow the dialog to begin for how to have Jitter-like capability for Csound.

The simple example below shows how to implement basic control of video, on a simple scale, in Processing using audio from Csound. In the example, Figure 1, the audio from Csound is controlling the image via the Csound bus using the chnset Opcode. Not shown below, but included in the example files, chnset.csd includes code for a linseg function, and an assignment to write data to the software bus which is assigned the string "envel".
```csound
kenv linseg 0, p3*0.25, 2.0, p3*0.75, 0
...
chnset kenv, "envel"
```


 The Java code for the Processing sketch below, consists of keywords which are referenced in the Processing core library, and the Processing PApplet or base class. Thus Sketchbook examples normally consist of inner classes to the larger PApplet base class which is invoked during Sketchbook compilation. It is the inner class programming approach which causes Sketchbook code to have differences with pure Java, or even pure JOGL programming. A good example of that difference is trying to use threads within the PApplet class.

 The draw() method below is called directly after setup() and continuously executes until the program is stopped or a noLoop() method is called. The draw() method reads the double values "mynum" which are returned from the try statement of the run() method as part of the CsoundThread inner class. The thread class employs the wrapped CsoundAPI function GetChannelPtr, as well as the csound.hpp virtual method GetChannel to read the "envel" data from software bus. A cosine function is applied to the linseg values to rotate a cube.
```csound

import csnd.*;

Csound               csoundInstance;
CsoundThread         csoundPerformanceThread = null;
SWIGTYPE_p_void      myvoid;
SWIGTYPE_p_CSOUND_   mycsound;
CsoundMYFLTArray     myfltarray;
double               mynums = 0.0;
float                cosine;
float                myfloat;

void setup ()
{
  size(200, 200);
  noStroke();
  frameRate(30);

  if ( csoundInstance == null )
  {
    csnd.csoundInitialize(null, null, csnd.CSOUNDINIT_NO_SIGNAL_HANDLER);
    csoundInstance = new Csound();
    myfltarray = new CsoundMYFLTArray();
    mycsound = csnd.csoundCreate(myvoid);
  }

  if ( csoundPerformanceThread != null )
  {
    if ( csoundPerformanceThread.isRunning() == true )
    {
      csoundInstance.Stop();
    }
  }

  CsoundFile d = new CsoundFile();
  d.load("/home/JCH/sketchbook/CsndChnsetRotateCube/chnset.csd");
  boolean b = d.exportForPerformance();
  int rc = csoundInstance.Compile("/home/JCH/sketchbook/
  				CsndChnsetRotateCube/chnset.csd");
  if ( rc == 0 )
  {
    CsoundThread  csoundPerformanceThread = new CsoundThread();
    csoundPerformanceThread.startCsound();
  }
}

void draw()
{
 background(0);

 myfloat = (float) mynums;
 cosine = cos(myfloat);

  translate(width/2, height/2);
  rotate(cosine);
  rectMode(CENTER);
  fill(204, 102, 0);
  rect(0, 0, 115, 115);

}

void drawRender1(){
  color inside = color(204, 102, 0);
  color middle = color(204, 153, 0);
  color outside = color(153, 51, 0);

  fill(outside);
  rect(0, 0, 200, 200);
  fill(middle);
  rect(40, 60, 120, 120);
  fill(inside);
  rect(60, 90, 80, 80);

}

void drawRender2(){
  color inside2 = color(20, 102, 0);
  color middle2 = color(20, 153, 0);
  color outside2 = color(15, 51, 0);

  fill(outside2);
  rect(0, 0, 200, 200);
  fill(middle2);
  rect(40, 60, 120, 120);
  fill(inside2);
  rect(60, 90, 80, 80);
}


class CsoundThread extends Thread
{
  private boolean running = false;
  int x = 0;

  public void startCsound()
  {
    running = true;
    start();
  }

  public void run()
  {
    try {
      int myoutputch = csndConstants.CSOUND_OUTPUT_CHANNEL;
      int mycontch = csndConstants.CSOUND_CONTROL_CHANNEL;
      SWIGTYPE_p_p_double myptr = myfltarray.GetPtr();

      while (csoundInstance.PerformKsmps() == 0) {
        if (csnd.csoundGetChannelPtr(mycsound, myptr, "envel",
				mycontch | myoutputch) == 0)
        {
          mynums = csoundInstance.GetChannel("envel");
        }
      }
    }
    catch (Exception e) {
    }
    csoundInstance.Stop();
    csoundInstance.Reset();
  }
  public synchronized boolean isRunning() {
    return running;
  }
  public synchronized void  setRunning( boolean running ) {
    this.running = running;
  }
}
```


 [**Figure 1.** Basic Processing video control from Csound.
## V. Processing to Csound



Utilizing images from Processing to control Csound audio can be accomplished via the Csound bus using the chnget Opcode. In terms of esthetic decisions, aspects of image, and how those may or may not correspond to sound, again represents many interesting possibilities for creativity. The small paperback "What Color Does a Sound Make?", by Kathleen Forde, et al makes for interesting reading and includes historical and contemporary references on the relationship of sound and image[[6]](https://csoundjournal.com/#ref1), and discusses the phenomenon commonly known as synesthesia.

One particular contemporary area of interest with image and sound is interactive video, or so called "rich media" [[7]](https://csoundjournal.com/#ref1) and the idea of sound and video interactivity can be extended to include improvisation. Many interesting aspects of image such as hue, texture, dimension, deformation, rotation, density, plane, geometry; all aspects which form the basis for more advanced computer graphics applications, have similar relationships in terms of sound.

 The example below, Figure 2, shows how to control sound via mouse manipulation of the image using the Csound bus and the chnget Opcode. The implementation of audio properties, and how those may or may not respond to the manipulation of images are areas for further development and creativity. In the example below, mouse values using the X axis for frequency, and Y for amplitude are employed for simple demonstration purposes.

The draw() method, below, which executes continuously, is passing mouse coordinates to the float values "myfloatpitch", and "myfloatamp". The try statement of the run() method, as part of the CsoundThread inner class, assigns those updated float values to the named buses "pitch", and "amp", which are read by the chnget.csd file . The chnget.csd file, included in the example files, assigns the string functions "amp", and "pitch" to identify the channels of the software bus to be read by Csound.
```csound
kval chnget "amp"
kval2 chnget "pitch"
```


OpenGL calls "pushMatrix", "fill", and "vertex", from the OpenGL API via the JOGL bindings, are also used in the draw() method below.
```csound

import csnd.*;

Csound               csoundInstance;
CsoundThread         csoundPerformanceThread = null;
SWIGTYPE_p_void      myvoid;
SWIGTYPE_p_CSOUND_   mycsound;
CsoundMYFLTArray     myfltarray;
float                myfloatpitch = 0;
float                myfloatamp = 0;
float                xmag, ymag = 0;
float                newXmag, newYmag = 0;

void setup()
{
  size(640, 360, P3D);
  noStroke();
  colorMode(RGB, 1);
  if ( csoundInstance == null )
  {
    csnd.csoundInitialize(null, null, csnd.CSOUNDINIT_NO_SIGNAL_HANDLER);
    csoundInstance = new Csound();
    myfltarray = new CsoundMYFLTArray();
    mycsound = csnd.csoundCreate(myvoid);
  }

  if ( csoundPerformanceThread != null )
  {
    if ( csoundPerformanceThread.isRunning() == true )
    {
      csoundInstance.Stop();
    }
  }

  CsoundFile d = new CsoundFile();
  d.load("/home/JCH/sketchbook/CsndChngetRGBCube/chnget.csd");
  boolean b = d.exportForPerformance();
  int rc = csoundInstance.Compile("/home/JCH/sketchbook/
  				CsndChngetRGBCube/chnget.csd");
  if ( rc == 0 )
  {
    CsoundThread  csoundPerformanceThread = new CsoundThread();
    csoundPerformanceThread.startCsound();
  }
}

void draw()
{
  background(0.5);
  pushMatrix();
  translate(width/2, height/2, -30);

  newXmag = mouseX/float(width) * TWO_PI;
  newYmag = mouseY/float(height) * TWO_PI;

  float diff = xmag-newXmag;
  if (abs(diff) >  0.01) { xmag -= diff/4.0; }

  diff = ymag-newYmag;
  if (abs(diff) >  0.01) { ymag -= diff/4.0; }

  rotateX(-ymag);
  rotateY(-xmag);

  myfloatpitch = xmag * 200;
  myfloatamp = (6.27 - ymag) * 4000;

  scale(90);
  beginShape(QUADS);

  fill(0, 1, .2); vertex(-1,  1,  1);
  fill(0, 1, .2); vertex( 1,  1,  1);
  fill(0, 1, .2); vertex( 1, -1,  1);
  fill(0, 1, .2); vertex(-1, -1,  1);

  fill(1, .1, 0); vertex( 1,  1,  1);
  fill(1, .1, 0); vertex( 1,  1, -1);
  fill(1, .1, 0); vertex( 1, -1, -1);
  fill(1, .1, 0); vertex( 1, -1,  1);

  fill(.1, 0, 1); vertex( 1,  1, -1);
  fill(.1, 0, 1); vertex(-1,  1, -1);
  fill(.1, 0, 1); vertex(-1, -1, -1);
  fill(.1, 0, 1); vertex( 1, -1, -1);

  fill(.7, 0, .7); vertex(-1,  1, -1);
  fill(.7, 0, .7); vertex(-1,  1,  1);
  fill(.7, 0, .7); vertex(-1, -1,  1);
  fill(.7, 0, .7); vertex(-1, -1, -1);

  fill(0, 1, .5); vertex(-1,  1, -1);
  fill(0, 0, .5); vertex( 1,  1, -1);
  fill(0, 0, .5); vertex( 1,  1,  1);
  fill(0, 1, .5); vertex(-1,  1,  1);

  fill(0, .2, .2); vertex(-1, -1, -1);
  fill(1, .2, .2); vertex( 1, -1, -1);
  fill(1, .2, .2); vertex( 1, -1,  1);
  fill(0, .2, .2); vertex(-1, -1,  1);

  endShape();
  popMatrix();
}


class CsoundThread extends Thread
{
  private boolean running = false;
  int x = 0;

  public void startCsound()
  {
    running = true;
    start();
  }

  public void run()
  {
    try {
      int myinputch = csndConstants.CSOUND_INPUT_CHANNEL;
      int mycontch = csndConstants.CSOUND_CONTROL_CHANNEL;
      SWIGTYPE_p_p_double myptr = myfltarray.GetPtr();

      while (csoundInstance.PerformKsmps() == 0) {
        if (csnd.csoundGetChannelPtr(mycsound, myptr, "pitch",
				mycontch | myinputch) == 0)
        {
          csoundInstance.SetChannel("pitch", myfloatpitch);
        }

         if (csnd.csoundGetChannelPtr(mycsound, myptr, "amp",
		 		mycontch | myinputch) == 0)
        {
          csoundInstance.SetChannel("amp", myfloatamp);
        }
      }
    }
    catch (Exception e) {
    }
    csoundInstance.Stop();
    csoundInstance.Reset();
  }

  public synchronized boolean isRunning() {
    return running;
  }
  public synchronized void  setRunning( boolean running ) {
    this.running = running;
  }
}
```


 [**Figure 2.** Example of using Processing to control Csound via mouse manipulation.
## VI. Conclusion



The use of Processing and Csound offers interesting possibilities for combining sound and image for creative applications. The fact that csnd.jar can be employed as a Processing library directly from a Csound build is useful when the csnd.jar is imported with Java code written in the Processing Sketchbook . This approach is for accessing the CsoundAPI via Csound's SWIG generated Java wrappers which are bundled as a binary file in the csnd.jar.

A more powerful approach exists using the underlying concepts of Processing's implementation, employing the Processing core library, the Processing PApplet or base class, JOGL, an IDE such as Eclipse or NetBeans, csnd.jar, and additional media libraries and frameworks. All elements are open source, easily available, and offer interesting possibilities for advanced application development.

When working with Linux, Java, and Csound, compatibility and constant upgrades and are issues which force users to think seriously about development options. For example CsoundAPI version 2 recently replaced version 1. Also Java 7 supposedly will contain advanced multimedia features. As written in earlier articles for Csound Journal, C++ remains a more direct route to the CsoundAPI since it does not involve the use of Java SWIG generated wrappers. Commercial and open source OpenGL applications available for the C/C++ programmer such as Coin3D which can be combined with QT using GUI bindings such as SoWin, SoXt and SoQt, are able to run OpenInventor examples and demos, as well as OpenGL Redbook and Glut examples.

The simple example files included with this article are for demonstration purposes only. Readers interested in utilizing csnd.jar within Processing should be able to build upon the basic concepts outlined in this article in order to enhance and expand the examples for more advanced practical creative applications.
## Acknowledgements
 Special thanks to Jean-Pierre Lemoine for help with code and examples to utilize a working thread class within Processing.
## References



 [][1]] Basics. A short introduction to the Processing software and projects from the community. [ http://processing.org/about](http://processing.org/about) (29 June 2009)

 [][2]] Eclipse Library Template. [ http://dev.processing.org/libraries/template.html](http://dev.processing.org/libraries/template.html) (29 June 2009)

  This is the Eclipse Library Template specific for Processing.   For general help with libraries in Processing see: Processing\Hacks, Libraries [ http://processing.org/hacks/](http://processing.org/hacks/) (29 June 2009)

 [][3]] Package processing.core. [ http://dev.processing.org/reference/core/](http://dev.processing.org/reference/core/) (29 June 2009)   See also the JOGL API Project site: [ https://jogl.dev.java.net/](https://jogl.dev.java.net/) (29 June 2009)

 [][4]] oscP5. [ http://www.sojamo.de/libraries/oscP5/](http://www.sojamo.de/libraries/oscP5/) (29 June 2009)

 [][5]] Multimedia. From Wager to Virtual Reality. http://www.artmuseum.net/w2vr/contents.html (22 February 2009)   See also the teacher's guide from this series, and the syllabus for week 3 "integration", and week 9 "immersion": http://www.artmuseum.net/w2vr/Teachers.html (22 February 2009)

 [][6]] amazon.com. [ http://www.amazon.com/What-Sound-Does-Color-Make/dp/0916365719](http://www.amazon.com/What-Sound-Does-Color-Make/dp/0916365719) (29 June 2009)   See also: What Sound Does a Color Make? [ http://www.hawaii.edu/artgallery/sound/welcome.html](http://www.hawaii.edu/artgallery/sound/welcome.html) (29 June 2009)

 [][7]] Wikipedia article on Multimedia. [ http://en.wikipedia.org/wiki/Multimedia](http://en.wikipedia.org/wiki/Multimedia) (29 June 2009)
## Related Links



 AVSynthesis Composition Tool. [ http://docs.google.com/Doc?id=dfq5sj5w_80f9z8tb](http://docs.google.com/Doc?id=dfq5sj5w_80f9z8tb) (29 June 2009)

 Coin3D. [ http://www.coin3d.org/](http://www.coin3d.org/) (29 June 2009)   Open Source OpenGL applications available for the C/C++ programmer which can be combined with QT using GUI bindings such as SoWin, SoXt and SoQt, are able to run OpenInventor examples and demos, as well as OpenGL Redbook and Glut examples.

 Csound AV. [ http://www.csounds.com/csoundav/index.html](http://www.csounds.com/csoundav/index.html) (29 June 2009)   Gabriel Maldonado's site for CsoundAV which includes embedded OpenGL.

 MakingThings. "How to use the Make Controller with the Processing language and environment." [ http://www.makingthings.com/documentation/tutorial/processing/tutorial-all-pages](http://www.makingthings.com/documentation/tutorial/processing/tutorial-all-pages) (29 June 2009)

 Vimeo. AVSynthesis. [ http://www.vimeo.com/tag:avsynthesis](http://www.vimeo.com/tag:avsynthesis) (29 June 2009)

 Vimeo. Processing->Csound Test. [ http://www.vimeo.com/2172394](http://www.vimeo.com/2172394) (29 June 2009)
