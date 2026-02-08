---
source: Csound Journal
issue: 11
title: "Making Beats with Blue"
author: "simply copying one line of score code
into the template box"
url: https://csoundjournal.com/issue11/MakingBeatsWithBlue.html
---

# Making Beats with Blue

**Author:** simply copying one line of score code
into the template box
**Issue:** 11
**Source:** [Csound Journal](https://csoundjournal.com/issue11/MakingBeatsWithBlue.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 11](https://csoundjournal.com/index.html)
## Making Beats With Blue

### Digital Dance Music with Csound and Blue
 Brian W. Redfern
 brianwredfern@gmail.com
##  I. An introduction to Blue



 With Blue, making beats with Csound is easy. Blue [[1]](https://csoundjournal.com/#ref1) is a frontend for Csound5 that gives you a combination of scripting and graphic interface tools that make it easy to work with Csound.

 You need to know something about Csound to work with Blue, but the familiar timeline interface makes it easy to organize your scores. With Blue, the options to generate score data using a pattern editor, a microtonal capable piano roll, and the familiar tracker interface, make for a great collection of tools which help make it easy to create "beats" or digital dance music using Blue as a frontend to Csound.
### Getting Started


 Since [Blue](http://www.csounds.com/stevenyi/blue/) runs on [Java](http://java.sun.com/javase/downloads/index.jsp) and [Csound5](http://csounds.com) is cross platform, you can use the combination of the two on a wide variety of systems. For this article I am using Csound 5.08 and JDK 1.6 on the 3.0 beta of 64 Studio Linux. I also use the combination on Windows XP and Mac OSX, but for my own purposes prefer to use Linux.

 Installation is easy. Just run the jar file with the command java -jar and it will install to the location of your choice. I just use the default location. Then you need to go into the Blue/bin folder and edit the start script that corresponds to your operating system. Since I use Linux I edit the blue.sh file to add in the location of my Java Csound Library, which for me is set to:
```csound
CSND_JAR=/usr/share/java/csnd-5.08.0.jar

```

### Using my Example


 Now you should be ready to run Blue and try out my [Blue example file](https://csoundjournal.com/MakingBeatsWithBlue/MakingBeatsWithBlue.blue). In my example I am using the drum sounds from [Hans Mikelson's](http://www.csounds.com/mikelson/) drum machine example. We do not use the actual sequencer code because we are going to use the pattern editor to handle sequencing our beats. I created the other two instruments from the example code in the Csound documentation.

You can also download new instruments from BlueShare, a server that holds a library of instruments made just for Blue. There are a wide variety of instruments to play with there, but you can also load any kind of Csound code into Blue as well as SoundFonts, and also even midi files.

 Once you load the example Blue file, click the orchestra tab to take a look at the list of instruments:

 ![Screen Shot of Orchestra tab](MakingBeatsWithBlue/Screen1.jpg)

 Each instrument is a snippet of Csound code, you do not have to add the "endin" statement on these snippets, or the instrument number, as Blue handles that for you. If you load an instrument from BlueShare it will be placed in your instrument library. You can also save your instruments in the Blue instrument library and use them in other compositions. You can develop your own personal pallet of orchestras that you can then use with the Blue score tools to compose new pieces without having to "reinvent the wheel" adding new orchestra code every time.

Now take a look at the timeline. You can see one poly object. A poly object is a special kind of Blue sound object that is a container to group logical parts. Since I want to slow down and speed up the performance of the drums separately from the rest of the parts, it makes sense to put all my drum parts together into one poly object.


Then I use the piano roll object to sequence one synth, and the tracker object to sequence the other. Both of these are powerful tools for sequencing an orchestra. If you do not do any coding, they make it a lot easier to write out parts using a familiar interface such as the piano roll object.

 ![Screen Shot of Timeline tab](MakingBeatsWithBlue/Screen2.jpg)

## II. Using the Editors


### Pattern Editor


The pattern editor is what I use to make my drum beats. This editor is great for non-melodic triggered percussion parts. First I create a poly object to hold my drum parts. Then I can change the length of the poly object in the main timeline, and this will speed up or slow down the tempo of my drum parts.

 The interface is fairly simple. It is just a simple grid that allows you to build basic patterns. However it provides all you need to write nice drum parts. Regarding the number of notes you can squeeze into a pattern, there are only four notes per part, so its not as flexible perhaps as making up a beat pattern in Hydrogen [[2]](https://csoundjournal.com/#ref1) and then exporting a midi file to load into Blue, but it is surprisingly powerful and simple to use.

 You can assign a note template to the pattern part by simply copying one line of score code into the template box. This allows the pattern editor to drive a wide variety of instruments. Ultimately it is meant for either drum parts or other percussive sounds that do not need to be pitched.

 ![Screen Shot of pattern editor](MakingBeatsWithBlue/Screen3.jpg)
### Piano Roll Editor


 The piano roll editor is useful for creating melodic or harmonic parts. You can even assign a Scala scale to use it for microtonal editing. For this example I use standard Western tuning. You set a note template for the piano roll and then all your graphic edits follow the template. The basic template comes with standard p fields and then you can add in other p field values to use it to drive a wide variety of instruments.

 In this example I am using the piano roll tool to set a bunch of visually random notes. It is fun to paint your score part using this tool. You hold down the shift key and then left click on your notes. It is also easy to setup complex harmonies using this tool.

 You can also use it to produce more complex drum patterns than might be possible with a simpler pattern editor. This is also the most familiar interface for anyone who comes from a midi sequencing background. It is very similar to a midi step sequencer, but the ability to use note templates for any instrument makes it much more powerful than simply using a midi sequencer to drive Csound.

 ![Screen Shot of pattern editor](MakingBeatsWithBlue/Screen4.jpg)
### Tracker Editor


 The tracker editor is similar to the classic tracker interface, the only difference being that you can track other p fields for an instrument. It is also possible to use a Scala scale file to give it microtonal capabilities. It is useful for drum parts or other percussive sections, but it is flexible enough to handle a lot of complex music.

 In this example tied several notes together to keep the part from being too "blippy". You can use control-t to add in a Csound tie to a tracker note. In this case I am also using standard tuning.

 Users who are used to making music with a tracker interface may find that this is the most familiar way to write scores with Blue.

 You can also click the "use keyboard notes" checkbox in order to use your computer keyboard to enter notes into the tracker. To see the note template you click the little > arrow next to the scroller on the right side to open up the note template for the tracker. Here you can add in new columns to add more p fields to the tracker template.

 ![Screen Shot of pattern editor](MakingBeatsWithBlue/Screen5.jpg)
### In Conclusion


 Blue is a great tool for composers. Instead of having to laboriously write scores by hand or manage a ton of text files, Blue makes it easy to dive into Csound using more familiar interfaces. Its easy for me to use the more familiar tracker interface than to write a long score by hand. The power of Blue is not limited to the GUI tools. The tools are a great aid for the beginner who may not yet have the coding skills to write algorithmic Python or Rhino scripts, but who wants to dive right in and start making music with Csound.
## Acknowledgements


 Thanks to [Steven Yi](http://www.csounds.com/stevenyi/) for writing the wonderful Blue software. Thanks to [Hans Mikelson](http://www.csounds.com/mikelson/) for sharing his compositions on the Csounds.com site.

[][1]] Steven Yi. *blue*. [http://www.csounds.com/stevenyi/blue/](http://www.csounds.com/stevenyi/blue/) (28 June 2009)

[][2]] Alessandro Cominu, et al. *Hydrogen*. [http://www.hydrogen-music.org/](http://www.hydrogen-music.org/) (28 June 2009)
