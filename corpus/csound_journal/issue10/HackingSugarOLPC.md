---
source: Csound Journal
issue: 10
title: "Hacking with csndsugui and Sugar"
author: ""
url: https://csoundjournal.com/issue10/HackingSugarOLPC.html
---

# Hacking with csndsugui and Sugar

**Author:** Unknown
**Issue:** 10
**Source:** [Csound Journal](https://csoundjournal.com/issue10/HackingSugarOLPC.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 10](https://csoundjournal.com/index.html)
## Hacking with csndsugui and Sugar

### Building Csound GUIs for the OLPC
 Brian Redfern
 brianwredfern AT gmail DOT com
## Introduction


The OLPC is a unique kind of computer. At first glance its just a laptop for kids. When I first heard about it I thought it was cool because it used Linux, but I did not think much of it otherwise. Then I found out that it actually uses Csound as its built in audio layer. What is unique about this approach is that instead of having to code C++ to write audio applications as with windows and VST, you can write interesting applications with scripted languages, and there is no need to get into pointers or other low level madness. This makes it accessible to children, but more importantly also accessible for us, the "lazy" programmers who prefer writing our programs with Python rather than C++.
##  I. The Python Code


 So you want to write a gui application for Csound and Sugar? You might have an actual OLPC, or you might be running a "virtual" OLPC, using something like Fedora 10 where it comes as a desktop option, and allows you to install all the Csound OLPC libraries. Actually emulating the OLPC is beyond the scope of this article, but you can find out how to emulate it from the [wiki page](http://wiki.laptop.org/go/Emulating_the_XO/Quick_Start#Getting_started_with_QEMU). Then you need to go to Victor Lazzarini's [project page for csndsugui](http://dev.laptop.org/git/activities/csndsugui), which will enable even the laziest programmer to easily write a Sugar activity for Csound with minimal coding. Victor makes it very easy to setup channels which are name based connections between a Python script that sets up the pygtk gui and the csd file where you can make use of the GUI activities to make changes in the sound or trigger fragments of scores.
### Getting Started


To start, we are going to build the basic Python script which will define our GUI interface. First you want to import the csndsugui library. Then you import the activity library from Sugar. Then you define an activity class. In this case I am calling it the OLPCDemo class. Then you do a standard Python initialization. Next you setup your background and text colors.

The next step is crucial, for if the csd file is unable to run successfully under Csound, the activity will fail to work. The win.csd() function then compiles your csd file and runs it, so it is ready to receive channel input from the Python gui. Next you define the title text for the gui. Now you create an empty box to hold a button. Then you create a frame to hold that box, and finally you define the button and you run the win.play() function to make the channels go live.
```csound

import csndsugui
from sugar.activity import activity

class OLPCDemo(activity.Activity):

    def __init__(self, handle):
        activity.Activity.__init__(self, handle)

        # colours
        red = (0xFFFF,0,0)
        bg  = (0xF000, 0xFF00, 0xFFFF)
        win = csndsugui.CsoundGUI(self,bg)

        win.csd("olpcdemo.csd")
        txt = win.text("OLPC Csound Example")
        ButtonBox = win.box(False)
        GUIBox = win.framebox("beep", False, ButtonBox, red, 40)

        win.buttonbank(1,GUIBox)

        win.play()



```

## II. Creating the CSD

### Using the Channels


Now you are ready to define the csd file that will take the channel signals and do interesting things with them. First you setup the audio output, using a relatively large buffer to keep the sound from breaking up. Then we setup the button channels. This gives us access to the command "1" coming from a button click. This is what Victor refers to as a "message button" since it sends a score command to Csound. There is also a callback button which runs Python code when triggered, and the special play, pause, and reset functions which control the actual playback of Csound.

Now we have two instruments, one which handles the button commands and converts them to trigger i-rate code in the score, and the other is the synthesizer that produces the sound. The actual instrument is just a simple oscillator with an envelope for smooth playback.

When Csound detects that the button has not been clicked, instrument 11 is turned off and you do not hear sound. When you click the button, playback of instrument 11 is turned on. You can download examples here for the Python script and the .csd file. [OLPCexamples.zip.](https://csoundjournal.com/olpc/OLPCexamples.zip)
```csound

<CsoundSynthesizer>
<CsOptions>
-odac -B2048 -b1024 -d
</CsOptions>
<CsInstruments>

/* button channels */
gkb1  chnexport "B1", 1


/* this instrument just triggers instr 2 depending on
the status of buttons B1 */

instr 1

k1 init 1

if gkb1 == 1 then
    if k1 == 1 then
        event "i", 11.1, 0, -1, 1
        k1=0
    endif
else
    if k1 == 0 then
        event "i", -11.1, 0, -1,1
        k1=1
    endif
endif

endin


/* This is the synthesis instrument */
instr 11

/* amplitude envelope */
ka  linenr  20000,0.1,0.1,0.05
/* oscillator */
a1      oscili  ka, k1, 1
        out     a1
endin

</CsInstruments>
<CsScore>
f1 0 1024 10 1 0.5 0.3 0.25 0.2 0.18 0.15 0.13 0.11 0.1 0.09
i1 0 3600

</CsScore>
</CsoundSynthesizer>

```


## Acknowledgements


Thanks to Victor Lazzarini for creating csndsugui as well as the demo code that this article is based upon. Although I simplified it a good deal, check out his full examples to see all the different kinds of widgets you can use with csndsugui.
## References

- [csndsugui page on OLPC wiki](http://wiki.laptop.org/go/Emulating_the_XO/Quick_Start#Getting_started_with_QEMU)
-  [Project page for csndsugui](http://dev.laptop.org/git/activities/csndsugui)
