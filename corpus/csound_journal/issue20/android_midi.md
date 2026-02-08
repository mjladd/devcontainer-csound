---
source: Csound Journal
issue: 20
title: "Android Devices as MIDI Controllers"
author: "the author including TouchOSC"
url: https://csoundjournal.com/issue20/android_midi.html
---

# Android Devices as MIDI Controllers

**Author:** the author including TouchOSC
**Issue:** 20
**Source:** [Csound Journal](https://csoundjournal.com/issue20/android_midi.html)

---

CSOUND JOURNAL[](https://csoundjournal.com/../index.html) | [Issue 20](https://csoundjournal.com/index.html)
## Android Devices as MIDI Controllers
 Art Hunkins
 abhunkin AT uncg.edu
 [http://www.arthunkins.com ](http://www.arthunkins.com)
## Introduction


This article is about the author's work emphasizing Android devices as MIDI controller interfaces for Csound. Problems and solutions for working with Android and MIDI are set forth in this article. Included is also an explanation and available download of a package by the author including TouchOSC[[1]](https://csoundjournal.com/#ref1)layouts as well as a test .csd that verifies communication between the TouchOSC app, TouchOSC Bridge[[2]](https://csoundjournal.com/#ref2) and Csound.
## I. A Bit of Personal Background


As a classically-trained musician, my interest has always been in live performance. To me, performance has a human and ever-changing face, exhibiting both variability and personal interpretation. As a consequence, my Csound works are nearly all realtime and require performance interfaces. Though I have used FLTK and Python widgets (the latter for Sugar activities for children), CsoundAV, Lettuce and Cabbage, and even ASCII keyboards, I favor hardware MIDI devices—particularly control surfaces consisting of sliders and/or buttons. I find these controllers user-friendly. (My music is mostly slow and meditative, so my need for precise, slow-moving control with immediate visual feedback favors long-throw sliders over knobs and other options.)

The challenge of hardware control surfaces, especially compared to mouse-on-screen, is that the widget count is fixed per control device, and often only vaguely corresponds to compositional requirements. Though I have often been tempted to design my music for a particular control surface, doing so drastically reduces the opportunity for performance. This can be also expensive both for composers and potential performers.

I am always on the lookout for configurable performance interfaces that allow for combinations of buttons and sliders. Recently, on eBay, the JazzMutant Lemur caught my eye. Despite its lack of tactile feedback, its ability to configure a plethora of controls is impressive. However, its price tag is way beyond my pay grade (I am a retired college music professor after all). Besides, it is long out of production. However, Lemur[[3]](https://csoundjournal.com/#ref3) has now morphed into an impressive software app for the iPad/iPhone, and costs a more reasonable $24.99.

Unfortunately, Lemur is not available for Android devices. Further investigation managed to unearth several other apps with extensive capability comparable to Lemur. They were less expensive than Lemur, some even free, and like Lemur had their GUI editing facility built into the app. However, these apps were only available for iOS[[4]](https://csoundjournal.com/#ref4)[[5]](https://csoundjournal.com/#ref5). An additional consideration: my work does not require the many tools that Lemur and these other apps provide. The question remains: what more basic (and inexpensive) app might be available for Android?

Two notable events had sent me down the Android path: 1) Csound was ported to the Android OS; 2) my son gifted me with a Samsung Galaxy Tab 2. My son Dave is also an Android developer[[6]](https://csoundjournal.com/#ref6). Currently a complete Csound composing/performance environment is available to recent Android devices, all in a single app. I actually have realtime Csound running solely on a $35 mini-tablet[[7]](https://csoundjournal.com/#ref7) which you can fit in your pocket.

From a performance standpoint, however, there are two main issues: 1) The Android port includes a fixed, limited collection of performance widgets (5 sliders, 5 buttons, one X/Y controller); 2) the performance interface is not MIDI, and involves `chnget` calls. Thus, any .csd must be redone for Android.

Currently there are two ways to change the Android performance interface; one is to create a new Csound Android app. My son and I have done this: we created two enhanced apps - one with an interface of 9 sliders and 12 buttons, the other with (user-selectable) 1-16 sliders and/or buttons[[8]](https://csoundjournal.com/#ref8). Both are modeled after Michael Gogins' Csound6.apk app for Android devices, and represent not only playback, but also .csd development capability. These apps also require a modest reworking of your .csd.

A second method was recently introduced by Gogins in his Csound6.apk based on Csound 6.03. It is the use of HTML5 within a .csd itself to create a custom Android GUI. Csound6.apk is still required to perform the .csd, as is its recoding mentioned above. This method is not for the faint of heart; it requires substantial mastery of HTML5, and writing a considerable amount of additional code. With the presence of HTML5 in your .csd, the markup code overrides the default GUI, creating a layout specific to your composition. An example of this is the code for the simple GUI for Michael's Drone-HTML5.csd[[9]](https://csoundjournal.com/#ref9). Nearly 150 lines of fairly advanced HTML5 were required to create the GUI.

An existing Android app that offers a simple, yet custom, solution to these issues isTouchOSC[[1]](https://csoundjournal.com/#ref1). TouchOSC includes code for MIDI, allowing any recent Android device to act as a MIDI controller for Mac or PC. It permits custom performance GUIs (Layouts) potentially specific to each composition. Perhaps most importantly, the .csd remains exactly the same as for a traditional MIDI controller, and the GUI does not involve writing code or learning a new language.

In researching both Lemur and TouchOSC as possible MIDI controllers, I ran across an important article that compares and contrasts the two apps: "Touch Music Control Choices: TouchOSC Gives Android, iPhone 5 Proper Love"[[10]](https://csoundjournal.com/#ref10). This is required reading for anyone interested in TouchOSC, and includes several instructive videos.
## II. TouchOSC for Android Devices



TouchOSC is available for both iOS and Android. Both versions are available for a reasonable $4.99. Though I have used it only on Android, the excellent documentation[[11]](https://csoundjournal.com/#ref11) is written for iOS, and is nearly identical for Android. Besides the TouchOSC app itself, two other software pieces (free) are required: TouchOSC Editor and TouchOSC Bridge[[2]](https://csoundjournal.com/#ref2). These are used by the Mac or PC computer. Note that TouchOSC does not have in-app GUI editing; a feature that could be viewed as either positive or negative. The Editor program for creating interface layouts (.touchosc files) is also available for Linux too, though TouchOSC Bridge is not; thus presumably eliminating Linux from MIDI control by TouchOSC.
### TouchOSC Setup


There are two ways of setting up TouchOS: one requires a wireless network (a wireless router, but not a modem and internet connection), and the other needs portable hotspot capability on your device (Android devices since version 3.x have it). In either case, your computer must have wireless connectivity (desktop computers can use an inexpensive wireless USB adapter for the connection). Start by downloading and installing TouchOSC, TouchOSC Bridge, and TouchOSC Editor on your computer.
#### The Wireless (WiFi) Network Method

- Open a WiFi network connection on your computer.
- Run (open) TouchOSC Bridge on your computer. (A black icon with a "B" on it should appear in your taskbar).
- On your device, connect to the same wireless network as your computer. (Settings | WiFi ON.)
- On your device, open the TouchOSC app. Click MIDI Bridge. If your desired WiFi network is listed (under Found Hosts), select it. If not, on your PC computer at the command prompt, enter `ipconfig`, and copy the ipaddress found to the Host field in MIDI Bridge on your device. For Macs, this procedure is different. See[[12]](https://csoundjournal.com/#ref12) for a description.
- Back out of MIDI Bridge.
- Select your desired Layout in Settings. If you have created your own .touchosc layouts and copied them to your device, first import them from the file to which you copied them.
- Select Done.
- Open and run your .csd in your computer, from the command prompt or any frontend. Do check that the correct MIDI input device (TouchOSC Bridge) is selected under <CsOptions> in your Csound file.
- Perform on your TouchOSC layout!
#### The Portable Hotspot Method (Android OS 3.x and up)


Note: when available WiFi networks are weak, the portable hotspot method gives better results. Networks with low connectivity are less dependable, and can respond more slowly.
- On your device (Settings | WiFi/More | Portable Hotspot | Select Portable Hotspot), turn on Portable WiFi Hotspot. (Doing so will turn off your usual WiFi connection if it is already on.) If you had not previously created your hotspot, click Set up WiFi Hotspot, select a security type and password. (If you have forgotten your password, check Show Password.) Remember your hotspot's name (SSID) and password (also called network key) for the following step.
- On your computer, select your device's wireless hotspot (SSID) that is now available, using information from step 1.
- Continue with step 4 of the Wireless Network Method.

Note: the computer's ipaddress will not be the same for these two connection methods. However, the address will not change unless the method of connecting changes.
### Layout Samples and .CSD Test File


I have written a .csd test file for user-designed TouchOSC layouts that verifies communication between the TouchOSC app, TouchOSC Bridge and Csound. This .csd tests controller widgets (sliders, rotary knobs, X/Y controller) and MIDI notes (buttons, keys and pads; the latter with velocity sensitivity). This file, an explanatory README.txt, and 18 TouchOSC layouts comprise a zip archive which you can download the file from the following link: [TouchOSC_for_Csound.zip](https://csoundjournal.com/downloads/TouchOSC_for_Csound.zip). Alternatively you can also access the files from my website[[13]](https://csoundjournal.com/#ref13). Any MIDI monitor program for the computer, such as MIDIOx for PC, can also verify proper communication between the mobile device and the computer. Getting your setup just right, however, can be troublesome.

These sample layouts run on all recent smartphones and tablets, both iOS and Android. Some are appropriate for smaller devices, others with more widgets are for larger tablets. Each of the nine sample layouts come with text labels, as well as a parallel set of nine layouts without the text labels. All layouts use default values found in the test file. These values can be changed in any text editor. See the archive's README.txt for further information.
### Alternate App


Of possible related interest is another Android app, MyOSC - BETA[[14]](https://csoundjournal.com/#ref14). Though lacking a version for iOS, it partners with both Mac and PC, and is a near drop-in replacement for TouchOSC. Indeed it promotes itself as an upgrade of TouchOSC, and requires both the latter's MIDI Bridge and GUI editor. Thus it is an alternate interface for GUIs produced by the TouchOSC Editor, displaying its widgets in a cleaner and more highly visible style. Its only modification is to show controller values, which TouchOSC does not. Perhaps best of all it is free. (Warning: MyOSC does not implement advanced TouchOSC widgets and features - even including velocity sensitivity for notes! Its sluggishness with continuous controllers is no doubt due to its display of changing values. Overall I found the app somewhat less dependable than TouchOSC.)

To install MyOSC - BETA, simply follow the instructions for TouchOSC, substituting MyOSC - BETA for TouchOSC. The only departure is that user-designed layouts must be stored in /sdcard/MyOSC (and cannot be directly copied/synced from the TouchOSC Editor).
## Conclusion


TouchOSC is a valuable app that functions as a MIDI controller for realtime Csound on both Macs and PCs. Its positive features include:
- It is available for both iOS and Android platforms.
- It interfaces with both Macs and PCs.
- Latency is minimal, especially with a strong wireless connection.
- It works well on smartphones and tablets of various sizes.
- It is well documented.
- It requires no changes to .csd code.
- Though it uses a wireless connection, it does not require the internet.
- It has a good, standalone editor (for Mac, PC, *and Linux*) that creates custom GUIs.
- The app costs $5 (a one-time charge) and runs on Android tablets that are priced as low as $35. It allows a single smartphone or device to do the work of numerous (and expensive) hardware controllers.
- Unlike many hardware controllers, mobile devices do not require an electrical connection. When paired with a laptop, setups do not require an electrical connection at all.

Given a choice, I will admit, however, to prefering my favorite MIDI hardware controllers to Android devices for performance. My reasons for perefering hardware to software are listed below:
- Hardware is more ergonomic (good tactile feedback and solid control);
- Hardware is ore dependable (Android devices lack MIDI out, so a wired connection is not available. Note, though, that under the right conditions, latency of wireless connections can be remarkably low);
- Hardware devices are somewhat easier to set up.

Of course, I have a multitude of hardware controllers ready to choose from for my performances!
## References


[][1]Hexler.net, "TouchOSC for Android." [Online] Available: [http://hexler.net/software/touchosc-android](http://hexler.net/software/touchosc-android). [Accessed September 21, 2014].

[][2]Hexler.net, "TouchOSC: MIDI Bridge Connection." [Online] Available: [http://www.hexler.net/docs/touchosc-configuration-connections-bridge](http://www.hexler.net/docs/touchosc-configuration-connections-bridge). [Accessed September 21, 2014].

[][3]Line, "Lemur." [Online] Available: [https://liine.net/en/products/lemur/](https://liine.net/en/products/lemur/). [Accessed September 20, 2014].

[][4]Domestic Cat Software, "MIDI Touch." [Online] Available: [http://www.iosmidi.com/](http://www.iosmidi.com/). [Accessed September 20, 2014].

[][5]Confusion Studio LLC, "MIDIDesigner." [Online] Available: [http://mididesigner.com/](http://mididesigner.com/). [Accessed September 20, 2014].

[][6]Dave Hunkins. Zatchu, "Contact." [Online] Available: [http://zatchu.com/](http://zatchu.com/). [Accessed September 20, 2014].

[][7]NewEgg.Inc., "iview." [Online] Available: [http://newegg.com/](http://newegg.com/). [Accessed September 21, 2014].

[][8]Art Hunkins, "Android Csound Apps and Other Android Materials for Csound." [Online] Available: [http://www.arthunkins.com/Android_Csound_Apps.htm](http://www.arthunkins.com/Android_Csound_Apps.htm). [Accessed September 21, 2014].

[][9]Michael Gogins, "Csound6AndroidExamples." [Online] Available: [http://sourceforge.net/projects/csound/files/csound6/Csound6.03/Csound6AndroidExamples.zip](http://sourceforge.net/projects/csound/files/csound6/Csound6.03/Csound6AndroidExamples.zip). [Accessed October 20, 2014].

[][10]Peter Kirn, "Touch Music Control Choices: TouchOSC Gives Android, iPhone 5 Proper Love." [Online] Available: [http://createdigitalmusic.com/2013/05/touch-music-control-choices-touchosc-gives-android-iphone-5-proper-love/](http://createdigitalmusic.com/2013/05/touch-music-control-choices-touchosc-gives-android-iphone-5-proper-love/). [Accessed September 21, 2014].

[][11]Hexler.net, "TouchOSC|Introduction." [Online] Available: [http://www.hexler.net/docs/TouchOSC](http://www.hexler.net/docs/TouchOSC). [Accessed September 21, 2014].

[][12]Hexler.net, "TouchOSC|Appendix." [Online] Available: [http://hexler.net/docs/touchosc-appendix](http://hexler.net/docs/touchosc-appendix). [Accessed October 21, 2014].

[][13]Art Hunkins, "TouchOSC_for_Csound." [Online] Available: [TouchOSC_for_Csound.zip](http://www.arthunkins.com/TouchOSC_for_Csound.zip). [Accessed September 23, 2014].

[][14]Widget, "MyOSC - BETA." [Online] Available: [https://play.google.com/store/apps/details?id=com.widget.myosc](https://play.google.com/store/apps/details?id=com.widget.myosc). [Accessed September 21, 2014].
