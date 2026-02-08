---
source: Csound Journal
issue: 16
title: "Routing audio and MIDI between Csound and a DAW"
author: "naming your instruments instr"
url: https://csoundjournal.com/issue16/audiorouting.html
---

# Routing audio and MIDI between Csound and a DAW

**Author:** naming your instruments instr
**Issue:** 16
**Source:** [Csound Journal](https://csoundjournal.com/issue16/audiorouting.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 16](https://csoundjournal.com/index.html)
## Routing audio and MIDI between Csound and a DAW

### Setting up an audio/MIDI router with OS X's IAC driver, Soundflower, and Logic
 Andreas Russo
 arusso1 AT berklee.edu
## Introduction


This article provides the necessary steps for setting up an audio/MIDI routing system for Logic and Csound. While this article covers using Logic, Csound, and Soundflower, the information in this article can be applied to other programs (i.e. other DAW software, MIDI Pipe or JACK in place of the IAC Driver, or other synthesizer).
## I. MIDI Router

### Setting up the IAC driver


The Inter-Application Connection driver in OS X is a virtual router which allows the streaming of MIDI data among different applications. The setup requires a few simple steps: ![image](audiorouting/images/img1.jpg)
 **Figure 1: IAC Driver Properties**
- Launch the Audio MIDI setup application located in `/Applications/Utilities` and from the MIDI window, double click the IAC Driver icon to see the window shown above in figure 1.
- Add a Bus port. Make sure to check the "Device is online" box and click apply. Both the Device and the Bus can be renamed any way you like.
### Sending MIDI data from Logic


You can now send MIDI data from Logic to the IAC driver. First, add an External MIDI track to your Logic session. Then in the Inspector column, click next to the Port and select your IAC driver bus. Logic will now send MIDI from that track to Csound on the channel specified in the Inspector. An alternative path would be clicking the Media icon in the upper right corner of Logic, selecting the Library tab and choosing the IAC driver bus channel through which you want to stream MIDI data. ![image](audiorouting/images/img2.jpg)
 **Figure 2: Selecting the IAC Driver Bus Channel in Logic**

There is a potential problem to solve before you start streaming MIDI: due to a bug in Logic, the current setup is going to create a MIDI loop that will make your instruments completely inoperable. This is easily fixed with a little workaround in the Environment window:  ![image](audiorouting/images/img3.png)
 **Figure 3: Logic Environment Window **

Open the Environment window (using cmd+8) and, in the upper left corner, select Clicks and Ports. Create an object of any kind (a Monitor will do the trick) and connect the IAC bus to it. Logic is now ready to stream MIDI to Csound.

Think of the IAC driver as a generic MIDI router (like a Motu MIDI TimePiece): what you did up until now was connect your MIDI controllers (i.e. Logic instruments tracks) to the router’s MIDI input ports (i.e. the IAC driver bus channels you selected from the Inspector). It is now time to patch the router’s MIDI output ports to your Csound instruments' MIDI inputs.
### Receiving MIDI in Csound


Let us now go ahead and set up Csound so that it can receive MIDI. The process using CsoundQT will be covered, however, the procedure should be much the same for whatever front-end you are using. Open up the CsoundQT Preferences window and select the Run tab. Then set the RT MIDI Module to portmidi and choose your IAC Driver Bus from the Input Device drop-down list. **WARNING:** your audio output device in Logic must be different from the one in CsoundQT or you will not be able to hear any sound coming out of Csound except for annoying feedback. After hitting OK, Csound should be ready to receive MIDI. All you need to do now is make sure that your instruments can all be controlled via MIDI.
### Controlling a Csound instrument with MIDI


Every single parameter of an opcode can be controlled by MIDI. The `cpsmidi` opcode will get the note number of a MIDI event and translate it into cycles-per-second. Therefore, as you can imagine, it is perfect for controlling the frequency of an oscillator.

Start by naming your instruments instr 1 and instr 2: by default Csound will pair each instrument with a MIDI channel of the same number (i.e. MIDI channel 1 with instr 1, MIDI channel 7 with instr 7, ...) . To override this behavior you can use the `massign` opcode. Assign a cpsmidi opcode to control the frequency of your oscillator. It will carry Note On, Note Number and Note Off, but not Velocity.

 In the .csd example below, for the score section, f0 is a dummy function table serving the simple purpose of running the score for 999 seconds. Run the Csound score and play the Logic sequence. You should now be able to hear your Csound instruments triggered by the MIDI regions from Logic.
```csound
<CsoundSynthesizer>
<CsInstruments>
sr = 44100
kr = 4410
nchnls = 1
0dbfs = 1

instr 1
icps cpsmidi
kenv linsegr 0, .001, .3, .1, 0
abip buzz kenv, icps, 1,1
     out abip
endin

instr 2
icps cpsmidi
kenv linsegr 0, .001, .4, .1, 0
abass oscil kenv, icps, 1
      out abass
endin
</CsInstruments>
<CsScore>
f1 0 4096 10 1
f0 999
</CsScore>
</CsoundSynthesizer>
```


If no audio is generated, first check the CsoundQT console. If you see `rtevents`, that means the MIDI connection is working but the problem is somewhere in the audio section. You will need to troubleshoot that problem to make sure your audio input/output is setup correctly.

The next step will be streaming audio from Csound to Logic. A simple tool for that purpose is Soundflower which will be explained below.
## II. Audio Router

### Bussing multiple audio tracks from Csound to Logic


Streaming audio from Csound to Logic on multiple channels is a fairly simple operation. The only difference from an ordinary Csound orchestra would be the use of the `outch` opcode rather than the more common `outs` opcode. According to *The Canonical Csound Reference Manual*, the `outch` opcode writes multi-channel audio data, with user-controllable channels, to an external device or stream [[1]](https://csoundjournal.com/#ref1). The output device is Soundflower, which according to code.google.com is a MacOS system extension that allows applications to pass audio to other applications. Soundflower operates by presenting itself as an audio device, allowing any audio application to send and receive audio with no other support needed[[2]](https://csoundjournal.com/#ref2). Soundflower has the same role as a patchbay in the hardware domain. We will see how to implement that concept below.

In CsoundQT, open the Preferences window and set Soundflower (16ch) as your output device. The `outch` opcode is defined in [[1]](https://csoundjournal.com/#ref1) as:
```csound
outch kchan1, asig1, [, kchan2] [, asig2] [...]
```


The `kchan` input paramter number for `outch` is going to be the number representing the channel towards which you will send the audio signal. Soundflower supports a maximum of 16 channels, hence `kchan` must be a number ranging from 1 to 16. It is also possible to use multiple channels for a single Csound instrument. Keep in mind that `nchnls` in the header has to be equal or greater than the number of channels you will eventually end up utilizing. Next be sure to inspect the orchestra for any `outs` opcode and make sure to turn each one of them into `outch`. Finally assign a single output per instrument, cascading from 1 to 3.
```csound

<CsoundSynthesizer>
<CsInstruments>
sr = 44100
kr = 4410
nchnls = 3
0dbfs = 1

instr 1
icps cpsmidi
kenv linsegr 0, .001, .3, .1, 0
abip buzz kenv, icps, 1, 1
     outch 1, abip
endin

instr 2
icps cpsmidi
kenv linsegr 0, .001, .4, .1, 0
abass oscil kenv, icps, 1
      outch 2, abass
endin

instr 3
icps cpsmidi
kenv linsegr 0, 1, .5, .4, 0
astrings pluck kenv, icps, icps/16, 1, 6
         outch 3, astrings
endin

</CsInstruments>
<CsScore>
f1 0 4096 10 1
f0 999
</CsScore>
</CsoundSynthesizer>
```


As you might have noticed, the code above features one more instrument than the previous example. Make sure to update the number of MIDI tracks in Logic.

We will now finalize the Logic setup by following these last steps. First, choose either the built-in output or your audio interface as the output device and select Soundflower (16ch) as your input device. When adjusting the buffer size keep in mind that this will sum up with the one in Csound. Next, create three mono audio tracks and assign them to inputs 1 to 3 as well as record enable them all. Also create MIDI regions for each track. Finally, run Csound, then start the sequence in Logic. You should now be hearing sounds coming from your Logic audio tracks, going to your speakers, and seeing realtime events from Logic in the Csound console, shown below in figure 4. ![image](audiorouting/images/img6.jpg)
 **Figure 4: Csound console showing realtime events from Logic **
### Signal flow diagram


The diagram in figure 5 shows the overall signal flow for the audio routing setup. ![image](audiorouting/images/img7.jpg)
 **Figure 5: Signal Flow Diagram **
## III. Advanced Applications


This section will give you a more hands-on approach in order to demonstrate advanced capabilities of this audio routing setup.
### Reverb Aux


One of the many useful applications for bussing multiple tracks is the creation of an effect aux:
- In order to accomplish this task, first change `nchnls` from 3 to 16.
- In the space between the .csd header and instrument name (also known as instr 0 space), initialize a global variable named `garvb`. This global variable will be your reverb bus.
- Create a send from instr 1 and instr 3 to `garvb`; the code below should serve as a reference:
```csound
garvb = garvb+(abip*irvbsnd)
```
 In the code above, the variable `abip` is the output of instr 1 and `irvbsnd` is a multiplier used to control the amount of the output signal to feed into the reverb (it should not exceed 1.0).
- Create `instr 55` and add a stereo reverb using the opcode `reverbsc`. Patch the reverb output into channels 15 and 16.
- Remember to set `garvb = 0` inside instr 55 to clear the reverb bus or feedback will result. Also, start instr 55 from the score section using a negative p3 duration. Using a negative number for p3 will cause the note to be *held*: the instrument will only stop when Csound completes rendering of all non-held notes.
```csound

<CsoundSynthesizer>
<CsInstruments>
sr = 44100
kr = 4410
nchnls = 16
0dbfs = 1

garvb init 0

instr 1
icps cpsmidi
kenv linsegr 0, .001, .3, .1, 0
abip buzz kenv, icps, 1, 1
     outch 1, abip
irvbsnd = .6
garvb = garvb+(abip*irvbsnd)
endin

instr 2
icps cpsmidi
kenv linsegr 0, .001, .4, .1, 0
abass oscil kenv, icps, 1
      outch 2, abass
endin

instr 3
icps cpsmidi
kenv linsegr 0, 1, .5, .4, 0
astrings pluck kenv, icps, icps/16, 1, 6
         outch 3, astrings
irvbsnd = .8
garvb = garvb+(astrings*irvbsnd)
endin

instr 55
aL,aR reverbsc garvb, garvb, .5, 12000
     outch 15, aL, 16, aR
garvb = 0
endin

</CsInstruments>
<CsScore>
f1 0 4096 10 1
f0 999
i55 0 -1
</CsScore>
</CsoundSynthesizer>
```


We will now add a stereo aux track in Logic and set the inputs as channels 15 and 16. The track will output a 100% wet reverb signal.
### Signal Splitter


Using multiple outputs for a single instrument can serve many purposes that go beyond the simple need for a stereo track. The `outch` opcode accepts as many channels as your device will allow. It could be interesting to use it as a dry/wet splitter. This allows you to blend the signals together until you reach the desired mix.
- In `instr 2` add a `distort1` opcode, patch it into `adist` and use `abass` as its `asig` argument.
- Modify `outch` to accommodate the new signal that you are going to patch into channel 4.
- Create a new audio track in Logic and feed it with input 4. This is where the 100% distorted bass will go. You can now blend the two signals together, choosing how much low-end, and how much distortion your mix needs.
```csound
instr 2
icps cpsmidi
kenv linsegr 0, .001, .4, .1, 0
abass oscil kenv, icps, 1
adist distort1 abass, 40, .2, .7, 0
      outch 2, abass, 4, adist
endin
```

### Controlling parameters via MIDI


As mentioned before, any Csound variable can be controlled by CC (continuous controller) messages sent from Logic. The `midic7` opcode allows you to scale a 7-bit MIDI signal and assign it to a desired parameter. The first argument sets the MIDI controller number, the second and third arguments set the minimum and maximum output values, allowing you to scale from 0-128 to a new Min-Max range.
- In `instr 1` erase the value of `irvbsnd` (get rid of the = sign as well) and replace it with `midic7`.
- Assign it to controller number 1 (i.e. modulation wheel) with a range of 0 to .6.
- Repeat the operation in instr 3 with `kmax` = .8.
- Draw a CC1 automation in your tracks in Logic. This will adjust the reverb for `instr 1` and `instr 2`.
```csound
instr 1
icps cpsmidi
kenv linsegr 0, .001, .3, .1, 0
abip buzz kenv, icps, 1, 1
     outch 1, abip
irvbsnd midic7 1, 0, .6
garvb = garvb+(abip*irvbsnd)
endin
```

## Conclusion


This audio/MIDI setup offers many more patching possibilities to be explored, allowing you to use Csound with advantages similar to the ones given by the ReWire protocol. You can try out the .csd example files for this article by downloading the following ZIP file: [audioroutingExs.zip](https://csoundjournal.com/audiorouting/csds/audioroutingExs.zip). Finally, listed below are additional links to the software you will need for the whole setup described in this article.
## References


[][1]]Barry Vercoe et Al.. "outch," *The Canonical Csound Reference Manual*, [Online]. Available: [http://csounds.com/manual/html/outch.html](http://csounds.com/manual/html/MiscModalFreq.html). [Accessed December 11, 2011].

[][2]]Google Project Hosting. *soundflower*, [Online]. Available: [http://code.google.com/p/soundflower/](http://code.google.com/p/soundflower/). [Accessed December 11, 2011].
## Related Links


Cycling '74, * Soundflower*. [Online]. Available: [Soundflower](http://cycling74.com/products/soundflower/). [Accessed December 11, 2011].

Jack OS X, * a Jack audio connection kit implementation for Mac OS X *. [Online]. Available: [Jack](http://jackosx.com). [Accessed December 11, 2011].

SubtleSoft -- Mac OS X Software by Nico Wald, * MidiPipe V1.4.3 *. [Online]. Available: [MidiPipe](http://web.mac.com/nicowald/SubtleSoft/MidiPipe.html). [Accessed December 11, 2011].

Musiclab Music Software Developers, * Mididoverlan cp*. [Online]. Available: [MIDIoverLAN CP](http://www.musiclab.com/products/rpl_info.htm). [Accessed December 11, 2011].
