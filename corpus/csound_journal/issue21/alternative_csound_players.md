---
source: Csound Journal
issue: 21
title: "Alternative Csound Players and Composing Environments for Android"
author: "Brian Redfern for the"
url: https://csoundjournal.com/issue21/alternative_csound_players.html
---

# Alternative Csound Players and Composing Environments for Android

**Author:** Brian Redfern for the
**Issue:** 21
**Source:** [Csound Journal](https://csoundjournal.com/issue21/alternative_csound_players.html)

---

CSOUND JOURNAL[](https://csoundjournal.com/../index.html) | [Issue 21](https://csoundjournal.com/index.html)
## Alternative Csound Players and Composing Environments for Android
 Art Hunkins
 abhunkin AT uncg.edu
 http://www.arthunkins.com
## Introduction


The Android apps presented in this article describe expanded user interfaces as compared to the those posted on Sourceforge[[1]](https://csoundjournal.com/#ref1). Otherwise largely identical to the "canonical" apps, these are primarily intended for 7" Android tablets and larger. Csound5a and Csound6a GUIs include a fixed arrangement of 9 sliders, 12 buttons and no trackpad. Csound6b includes up to 16 sliders and buttons, but no trackpad or console output. Csound6c is identical to 6b, except that it adds back a single-line Csound console output. These apps can all coexist with the original Android Csound apps. This article places these enhanced apps within the general context of the development of Android Csound.
## I. Background


In mid-to-late 2012, Csound took a major step forward as it was ported to mobile devices when Victor Lazzarini and Steven Yi ported Csound both to iOS and Android. For the first time, Csound compositions could be performed in the palm of your hand, at a total cost of less than $100US (for Android devices). Until then, a desktop or laptop computer, often tethered to a wall socket—and in the case of live performance, an external MIDI controller—were normally required. See their seminal article, *Csound for Android* [[2]](https://csoundjournal.com/#ref2).

In March 2012, Victor Lazzarini introduced the first "CSD Player" app in his Audio Programming Blog: CsoundApp.apk[[3]](https://csoundjournal.com/#ref3). This app included a simple performance GUI consisting of 5 sliders and buttons, plus an x/y controller or trackpad (essentially two sliders in one). It was the model for the Android apps that followed. Its sliders and buttons conveniently substituted for a MIDI controller in interactive performance. A major limitation was that its only .csd feedback was a general, and somewhat ambiguous, indication of any compile-time error. A basic tutorial on CSD Player, "Introducing the Android CSD Player", was written by Brian Redfern for the *Csound Journal* [[4]](https://csoundjournal.com/#ref4).

Lazzarini and Steven Yi subsequently presented their ideas for Csound on mobile devices in a another paper, *Digital Audio Effects on Mobile Platforms*, in September 2012[[5]](https://csoundjournal.com/#ref5). It described another app, CsoundAndroid.apk, which, though not the same kind of player, demoed nine simple examples that included sliders, buttons, a complete Csound composition[[6]](https://csoundjournal.com/#ref6), waveform display and a multitouch performance controller! The app remains a persuasive demonstration of the power of Csound ported to the Android OS.

Two refinements of CsoundApp.apk led to CsoundApp-5.19.apk, built with the final incarnation of Csound5 (5.19). These versions included limited console output, and did a modest job of reporting compile-time errors—but gave no performance-time information. Serious text editing and .csd development is difficult on mobile devices, especially on smartphones. I have done all my development work on a desktop, with my Android tablets tethered to it via USB cable. In that case the device simply appears as an external drive attached to the computer. If you wished, you could tweak your composition in an external text editor on your device. Nonetheless, these apps were all appropriately identified as "CSD Players." One problem with the CSD Players is that they cannot return sliders all the way to zero - at least on my devices.
## II. MIDI


Eager to try my hand at porting one of my own MIDI compositions to Android, I set about converting my composition, *Chimeplay*, to *ChimePad* (ChimePad.csd)[[7]](https://csoundjournal.com/#ref7)[[8]](https://csoundjournal.com/#ref8), for performance with CsoundApp.apk. It was relatively easy to adapt a minimal version for CsoundApp's GUI. I purposefully used all 5 sliders and buttons, and the x/y controller just to see what was possible. As the computational demands were fairly minimal, the result proved highly workable.

My live-performance Csound compositions were originally conceived for desktop/laptop computer plus hardware MIDI controller, usually consisting of 8 or more sliders. Alternate versions then incorporate different GUIs for presets, as well as diverse platforms and control devices. The hardware slider/fader - especially the long-throw variety - is my preferred controller. I find it infinitely more intuitive than the less user-friendly rotary knob. I had also previously created a version of *Chimeplay*, a "sonic environment" that incorporated a variable number of controllers and samples, for the equally underpowered XO computer. It is a creative activity for children. The sample rate for *Chimeplay* is set to 8000 to accommodate even the lowest-powered devices. Before attempting to perform this work, one should study the accompanying ChimePadReadMe.txt. One drawback of generic Android GUIs is that they do not display any specific labels or performance guidelines.

Most of my MIDI compositions, however, require 8-9 or more sliders, and I wanted to see how adaptable they might be to CsoundApp's modest set of widgets. My compositions *Spiritus Sanctus* and *Spiritus Sanctus 2*—likewise "sonic environments"—required anywhere from 7 to 16 MIDI sliders. Could CsoundApp handle greater complexity? I created fairly minimal versions for CsoundApp's 5 sliders, with two additional sliders handled by the x/y trackpad. It turned out that the Android OS could perform *Spiritus Sanctus* and *Spiritus Sanctus 2 *with little difficulty.

Converting MIDI code from hardware controllers to Android widgets, has not proven a major undertaking. It involves changing `ctrl7` and `midiin` opcodes to `chnget` calls. There are adjustments to make in slider ranges (the Android is 0 to 1), and one must remember that Android buttons are momentary contact (but thankfully much more simply programmed than `midiin` events).

The only major conversion issue was in making the x/y trackpad act as separate sliders.The two problems were: 1) unlike MIDI sliders, there was no visual indication of the last touched value, and so it was difficult to return to the last position; 2) when lifting your finger, the slider returned to zero instead of holding at its last touched value. I found a way to code around the second issue, and dealt with the first by either ending on min or max slider values (0 or 1), or assigning slider parameters whose precise value was not significant. The single advantage to the x/y controller is that it can adjust two parameters simultaneously. This is not possible with other sliders (or buttons) - at least not within the current series of Csound5 and 6 Android apps. Their use is strictly one at a time. This, however, was not an issue for me, as I rarely need to change several parameters simultaneously.

For me, however, additional sliders would clearly be preferable to an x/y controller. The trackpad took up a lot of screen space—space that I thought would be better populated with additional sliders and buttons. I wanted to see how many separate controllers Android could handle, with its limited screen-space and computing power. The idea for my first alternative/enhanced CSD Player was born.

To realize this vision I enlisted the talents of my son Dave, an independent Android developer with a significant interest in sound and music, with whom I had been working on several traditional Android apps involving sound, by furnishing .csds that did the sound generation[[9]](https://csoundjournal.com/#ref9). Together we modified CsoundApp to create Csound5a.apk, with 9 sliders and 12 buttons, but no trackpad. It retained the quite limited console window. We hoped Android could cope with this additional level of musical complexity. The 12 buttons were arranged in 3 rows of 4, similar to a typical modestly-priced MIDI control surface. 8 or 9 sliders or rotary knobs are also the norm for such hardware controllers. The Csound5a GUI also fixed the slider does not return to zero problem.

To test this premise, I converted two recent MIDI pieces for performance by Csound5a: *Spiritus Sanctus* and *Spiritus Sanctus 2*. The former, which required 9 sliders and 12 buttons, became *Spiritus Sanctus alt*. The latter, with 8 sliders only, became *Spiritus Sanctus 2alt*. Those worked well. Any possible dropout issues could be handled by simply reducing Sample Rate. See "A Note about Latency and Dropouts" at the end of this article.
## III. Csound Version 6 for Android OS


A quantum leap forward for Csound took place in mid-2013, when Michael Gogins developed the Csound6 application for Android OS. His application transformed CsoundApp into a complete development system and composing environment for Android. Meanwhile, the app had expanded from under 3MB to 10MB and more: the distribution now included a 4+MB GM soundfont bank, 1+MB of HRTF files, and libraries for fluidsynth, Lua, and signalflow graph opcodes. Also present were a basic Csound tutorial, a built-in link to your choice of text editor and to on-line Csound documentation. The editor link was a real compositional boon; it was now far more practical to make minor changes to a .csd on the device itself.

Again, eager to take advantage of these expanded resources, my son and I collaborated on Csound6a.apk, which duplicated the GUI of our Csound5a.apk. Csound6a.apk was based on the Csound6.01 version of Gogins' Csound6.apk. 6.01 had dealt with several bugs of the original 6.00 and its Android port. Our subsequent alternative .apk's continue to incorporate Csound 6.01. All the works I had ported to 5a now could be worked on and performed in this new development environment. The composer was now no longer necessarily tethered to a traditional computer.

Encouraged by the results of my work with a 9-slider GUI, I wondered whether the more advanced versions of my compositions—which required up to 16 or more sliders—could be accommodated by the Android platform. I decided on a maximum of 16 sliders, as I wanted these works to be performable on smartphones—though larger tablets would clearly be more practical. The display of 16 horizontal sliders is indeed possible on smartphones, if only barely. Performance requires great care, and preferably tiny fingers! It is far from ideal. In addition, given display limitations, I wanted the ability to specify only the number of sliders (and buttons) actually required, and thus for the GUI to be customizable to a certain degree for the specific composition. Thinking too of compositions that employed only buttons (as rudimentary drum pads) an option for buttons only was included. The challenge for Android buttons is one of latency of response - a problem discussed under "A Note about Latency and Dropouts" at the end of this article. In buttons only mode, the up to 16 buttons could be much larger, and be played more like a rudimentary 4-pads-per-row MIDI drum machine. So, Csound6b was born. The challenge for Android buttons is still one of latency of response.

With Csound6b.apk, we reached the limit of what at least the current generation of Android devices could handle. My compositions, fortunately, require neither great computing power nor low latency. They all perform quite well on Android with these alternative apps. It seems clear to me, however, that more complex and computationally demanding works would not work on Android—at least at this time.
## IV. Recent Challenges


My most recent compositions, *Peace be with You* and *Peace be with You 2*, presented an entirely different Android challenge.[](https://csoundjournal.com/#ref17) I additionally put out these two works in a version for Mac or PC that uses an Android device solely as wireless MIDI controller. This was accomplished via the TouchOSC app - with custom templates (layouts) as performance GUIs[[10]](https://csoundjournal.com/#ref10). These versions are included in my list of recent compositions as *Peace be with You* and *Peace be with You 2* for Windows and Mac platforms - alternate editions that enable Android devices as MIDI controller. Besides 9-16 sliders and 9 buttons, they required at least minimal Csound console feedback—both during setup and actual performance. During setup, the buttons select performance options that are clearly disclosed on-screen when other than default values are desired. Also, during performance, specific frequencies must be specified via slider prior to these pitches sounding. Both cases necessitate Console feedback. With the screen maximally chock-full of widgets, there was precious little space remaining for Console output. In fact, there was only room for a single line!

Getting my printed feedback on a single line turned out not to be so difficult. Care needs to be taken for the single-line console output not to overflow the line. This is particularly critical for smartphones. I have found that with a Font size of "Normal" (default Font style), approximately 33 characters can be displayed on these devices. Seven-inch tablets, on the other hand, accommodate 53 characters.

The print-formatting challenges I faced are well demonstrated in PeacealtAndroid.csd - part of the downloadable zip archive, PeacealtAndroid. You can download all the PeaceltAndroid examples from the following link: [PeacealtAndroid.zip](https://csoundjournal.com/downloads/PeacealtAndroid.zip).All the printing to screen is done in instrument 1. (For those interested in printing to the Android console, this instrument is worthy of study.)

 Printing is to the console, it is handled much the same way as with traditional platforms. However, given lower-powered processors, efficiency of printing is crucial, as printing interruptions can cause audio glitches. It is important to observe the following principles:
- Print only when there is an actual change of value;
- Print an entire line at a time, assembling all values into a single print statement. (Note that only the actual printing interrupts audio, not the calculation and assembly of what is printed);
- Print at most once per k-cycle. (Global values can be aggregated from multiple instruments.)

The greater challenge was to get the correct line to appear. The complicating factor was the fact that Android does not recognize "\r" (carriage return alone)—just "\n" (newline)! Fortunately, console output of performance data is always the last line of output, and a one-line console window constantly displays this last line! Normally, no scrolling is evident; the new line simply appears to rewrite the old. This result turns out to be more user-friendly than the multi-line console output of both the Csound6 and Csound6a apps. It has the added advantage of the Font size being able to be set in the "Settings | Display" menu ("Normal" is a good size—larger and more readable than what both CS6 and CS6a put out). This is with Font style set to "Default font."
## V. A Note About Latency and Dropouts


In my informal button tests for latency and dropouts, I achieved results comparable to Victor Lazzarini[[11]](https://csoundjournal.com/#ref11). This is an excellent report. The situation does not seem to have changed much since Victor wrote in late 2012. Latency remains a significant issue in circumstances where precise triggering is required.

With my Samsung Galaxy Tab2 7.0 (Android 4.2.2), I found maximal buffer and sample rate settings with mono to be `SR=44100`and`-b128`and `-B2048`. (Victor cited `-B1024`, but I observed dropout at that number.) As he states, values lower that `-b128` don't get better latency, and values higher than `-B2048` result in greater latency. I agree that, for the most part, the latency of these maximal settings is workable, if hardly ideal.

If, due to textural complexity, these settings do result in dropouts, the best idea is to lower Sample Rate (to 32000, 22050, 11025 or even 8000—all valid values). Be aware, however, that these lower rates are accompanied by higher latency. Finally, `SR=48000` at the recommended settings, is not possible; it will produce dropouts.
## VI. Conclusion


The additional Csound players and composing environments discussed here allow for the performance and composing of realtime Csound works with a greater number of both sliders and buttons (up to 16 each). In some cases the specific number of controls can be chosen by the user. Though generic and limited in nature, they are simple, practical, and user-friendly alternatives to creating complete Android apps, or using HTML5 within Csound to create custom GUIs. Those interested in exploring Michael Gogins' implementation of HTML5 within .csds should study his composition from the file Drone-HTML5.csd[[12]](https://csoundjournal.com/#ref12). This HTML5 GUI option is only available in Csound6.apks based on Csound6.03 and later. Though it is currently unique to Android Csound, Michael Gogins is in the process of making it available to the mainline platforms.

On a related note, Justin Smith has recently found that custom GUIs (Layouts) created by the TouchOSC app[[13]](https://csoundjournal.com/#ref13)[[14]](https://csoundjournal.com/#ref14) can drive Android Csound6; the apps run simultaneously on a single device. Doing so requires the latest build of Csound6 incorporating Csound 6.05 - the first to include the OSC opcodes. An outstanding feature of this arrangement is that, since only one device is involved, there is no need for any network or USB connection! The primary communication requirement is to specify an OSC Host address (in TouchOSC) of 127.0.0.1, and appropriate incoming and outgoing Ports (usually 8000 and 9000). Changes to .csds are anywhere from minimal to more complex - basically exchanging the *chnget* opcode for more elaborate implementations of *OSClisten*. The formatting and handling of variables passed to Csound via *chnget* (or MIDI) and *OSClisten* are significantly different. Two very different conversion challenges - from alternative Android GUIs directly to TouchOSC - can be seen in versions of my compositions *Spiritus Sanctus alt* and *Peace Be With You alt* [[15]](https://csoundjournal.com/#ref15). The differing GUI implementations of each work are presented side by side in explanatory .txt files and their associated .zip archives (which include the TouchOSC Layouts). My conclusion: since I only require sliders and buttons, it seems a lot of additional work in the form of code modification and extra setup just for a fancier GUI.

 The above capability requires a fairly recent OS: it works with Android 4.4.2, but not with 4.2.2, for example. Like the canonical versions, they require only an Android device, a single Android app, no internet connection or wifi router—and, as a bonus, only minimal modification of .csds. The primary changes involve swapping out MIDI button and slider code for *chnget* commands - a process already familiar to many Csound users.
## References


[][1] John ffitch, Steven Yi, Victor Lazzarini, et. Al.., "Csound." [Online] Available: [http://sourceforge.net/projects/csound/files/](http://sourceforge.net/projects/csound/files/). [Accessed August 9, 2015].

[][2] Victor Lazzarini and Steven Yi , "Csound for Android." Proceedings of the 2012 Linux Audio Conference, CCRMA, Stanford University, CA., April 12-15, 2012. [Online] Available: [http://lac.linuxaudio.org/2012/papers/20.pdf](http://lac.linuxaudio.org/2012/papers/20.pdf) . [Accessed August 9, 2015].

[][3] Victor Lazzarini, "A General-Purpose UI for Csound on Android." The Audio Programming Blog, March 16, 2012. [Online] Available: [https://audioprograming.wordpress.com/2012/03/16/a-general-purpose-ui-for-csound-on-android/.](https://audioprograming.wordpress.com/2012/03/16/a-general-purpose-ui-for-csound-on-android/) [Accessed August 9, 2015].

[] [4] Brian Redfern, "Introducing the Android CSD Player, Jam Live with Android and Csound." *The Csound Journal*, Issue 17, Fall 2012. [Online] Available: [http://www.csoundjournal.com/issue17/android_csd_player.html](http://www.csoundjournal.com/issue17/android_csd_player.html) [Accessed August 9, 2015].

[][5] Victor Lazzarini, Steven Yi, and Joseph Timoney, "Digital Audio Effects On Mobile Platforms." Proceedings of the 15th International Conference on Digital Audio Effects (DAFx-12), York, UK, September 17-21, 2012. [Online] Available: [http://eprints.maynoothuniversity.ie/4120/1/dafx12_submission_2.pdf.](http://eprints.maynoothuniversity.ie/4120/1/dafx12_submission_2.pdf) [Accessed August 9, 2015].

[][6] Ian McCurdy, "Csound Haiku."[Online] Available: ][http://iainmccurdy.org/csoundhaiku.html](http://iainmccurdy.org/csoundhaiku.html). [Accessed August 9, 2015].

[][7] Arthur B. Hunkins. [Online]. Available: [Recent Compositions by Arthur B. Hunkins](http://www.arthunkins.com) [Accessed August 8, 2015].

[][8] John ffitch, Steven Yi, Victor Lazzarini, et. Al.,"ChimePad" in Csound6AndroidExamples in "Csound." [Online] Available: [http://sourceforge.net/projects/csound/files/csound6/Csound6.03/](http://sourceforge.net/projects/csound/files/csound6/Csound6.03/). [Accessed August 9, 2015].

[][9] Google play, 2015. "Apps." [Online] Available:[ https://play.google.com/store/search?q=zatchu&c=apps](https://play.google.com/store/search?q=zatchu&c=apps). [Accessed August 8, 2015].

[][10] Art Hunkins, "Android Devices as MIDI Controllers," *The Csound Journal*, Issue 20, Fall 2014. [Online]. Available: [http://www.csoundjournal.com/issue20/android_midi.html](http://www.csoundjournal.com/issue20/android_midi.html). [Accessed August 8, 2015].

[][11] [](https://audioprograming.wordpress.com/2012/12/02/an-update-on-the-latency-issue/) Victor Lazzarini. "An update on the Android audio latency issue." The Audio Programming Blog. December 2, 2012. [Online] Available: [https://audioprograming.wordpress.com/2012/12/02/an-update-on-the-latency-issue/](https://audioprograming.wordpress.com/2012/12/02/an-update-on-the-latency-issue/) [Accessed August 9, 2015].

[][12] Michael Gogins, "Drone-HTML5.csd" in Csound6AndroidExamples in "Csound." [Online] Available:[ http://sourceforge.net/projects/csound/files/csound6/Csound6.03/](http://sourceforge.net/projects/csound/files/csound6/Csound6.03/). [Accessed August 9, 2015].

[][13] Hexler.net, "TouchOSC." [Online] Available: [http://hexler.net/software/touchosc](http://hexler.net/software/touchosc). [Accessed August 8, 2015].

[][14] Google play, 2015. "TouchOSC." [Online] Available: [https://play.google.com/store/apps/details?id=net.hexler.touchosc_a](https://play.google.com/store/apps/details?id=net.hexler.touchosc_a). [Accessed August 8, 2015].

[][15] Arthur B. Hunkins, "Spriitus Sanctus alt" and "Peace Be With You alt" [Online]. Available: [Recent Compositions by Arthur B. Hunkins](http://www.arthunkins.com) [Accessed August 8, 2015].
