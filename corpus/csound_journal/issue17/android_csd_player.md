---
source: Csound Journal
issue: 17
title: "Introducing the Android CSD Player"
author: "default are those  with the proper parameters for realtime Android playback"
url: https://csoundjournal.com/issue17/android_csd_player.html
---

# Introducing the Android CSD Player

**Author:** default are those  with the proper parameters for realtime Android playback
**Issue:** 17
**Source:** [Csound Journal](https://csoundjournal.com/issue17/android_csd_player.html)

---

Csound JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 17](https://csoundjournal.com/index.html)
## Introducing the Android CSD Player

### Jam Live with Android and Csound
 Brian Redfern
 brianwredfern AT gmail.com
 http://alum.calarts.edu/~bredfern

## Introduction


 Thanks to the work of the Csound developers we now have what has been for a few years that "impossible dream" - to be able to run Csound on your Android smartphone.

 Until very recently, Android has had terrible audio latency for anything but the loosely timed playback of samples, audio tracks, or music. Developers were hard pressed to build usable apps until the release of Gingerbread (Android 2.3), which introduced the OpenSL library. Now you are finally getting very impressive music apps for Android such as [Eerie Synth](https://play.google.com/store/apps/details?id=com.bv.eeriefull) and [Caustic](https://play.google.com/store/apps/details?id=com.singlecellsoftware.caustic).

 With the new Jellybean version of Android (Android 4.1), you can potentially get far lower audio latency than previous versions; as low as 10ms (a big improvement over 90ms for Android 4.0, "Ice Cream Sandwich" (ICS)). Jellybean also adds support for USB audio devices and multichannel audio output via HDMI.

 The great news though is that even if you have a Gingerbread device, if you have a 1Ghz processor or better, you should still be able to quickly turn your phone into a musical instrument using the CSD Player app.

 While phone apps are difficult to write, the CSD Player makes life easy for musicians who use Csound. Those users may not be Java whiz kids, but they still want to benefit from their experience creating Csound CSD compositions or instruments on their desktop or laptop computers. You can write an instrument tuned to the particular capabilities of your target Android device, rather than worrying about supporting the wide range of mobile devices in general use.

Thanks to the work of Victor Lazzarini[[1]](https://csoundjournal.com/#ref1), we now have a full featured GUI for Android we can use as the front end to our Csound CSD pieces without the requirement of writing an entire app on our own. For those who have no intention of becoming full blown programmers but still want to benefit from mobile Csound on Android, Victor's app is a godsend.
### Download


Examples from Article: [android_csd_player.zip](https://csoundjournal.com/redfern/android_csd_player.zip)
##
 I. Android Composition

###  Writing Note for Note Compositions on Android


 The most basic way you can use the player app is as a preview or render engine for your note for note compositions with CSD files. This sounds like a painful choice for a mobile device, as even with a slideout phone it would hurt to type that much. However, I use a wireless keyboard with my Asus A500 tablet, and using this setup it is not really any different than typing on a netbook to write compositions. It can actually be really handy to be able to use an Android device to write long form, composed pieces. For example, when my laptop died, the CSD Player app was my only tool for composing.

 In the following example, I have a piece with a `repluck` opcode. I do not save the piece to a WAV file on Android because the player can only handle realtime playback. But it is a handy way to preview a file and work on it using my Android tablet. I can later upload it to my online storage account and download it back onto my laptop for rendering to WAV file. In the example, notice that I commented out the wave file render settings in the CsOptions. I leave the code commented out if I want to use this when working on my laptop. However, the settings I leave on by default are those with the proper parameters for realtime Android playback, as it will fail to compile on the player if the settings are not setup correctly. ![](redfern/a500-csound.jpg)

**Figure 1. My Android tablet with wireless keyboard, running a free Android text editor.**
```csound

<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
-o dac -+rtmidi=null -+rtaudio=null -d -+msg_color=0 -M0 -m0
;-iadc    ;;;uncomment -iadc if realtime audio input is needed too
; For Non-realtime ouput leave only the line below:
; -o repluck.wav -W ;;; for file output any platform
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
0dbfs  = 1
nchnls = 2

instr 1

iplk  = 0.75
kamp  = .8
icps  = p6 + rnd(100)
krefl = p4 + rnd(0.5)
kpick = p5 + rnd(0.9)

axcite oscil 1, 1, 1
asig repluck iplk, kamp, icps, kpick, krefl, axcite
asig dcblock2 asig		;get rid of DC offset
     outs asig, asig

endin
</CsInstruments>
<CsScore>
f 1 0 16384 10 1	;sine wave.

r 20
t 0 110
i 1 0 1 0.95 0.75	 441;sounds heavier (=p5)
i 1 + 1  < 821
i 1 + 1  < 661
i 1 + 1  < 567
i 1 + 0.25 0.6 991
s
e
</CsScore>
</CsoundSynthesizer>

```

## II. Let’s Jam!

### Run your CSD on Android
 ![](redfern/image00.jpg)

**Figure 2. Victor's CSD Player on an Ice Cream Sandwich tablet.**

 It is not hard to install Csound on an Android device. You do not need to compile Csound from source or anything difficult like that, you just need to tweak some settings on your device to enable it to install an APK file that comes from outside the marketplace. The procedure for doing this differs for different devices and versions of Android, so you will need to look up how to do this for your device. After this setting has been set, point your mobile browser to [http://sourceforge.net/projects/csound/files/csound5/Android/](http://sourceforge.net/projects/csound/files/csound5/Android/) and download the latest version of CsoundApp.apk. Once downloaded and installed, you should see an icon for the CSD Player app.

 Csound on Android has a couple of special needs. First, in the header of our CSD, we are going to use this setting for audio output:
```csound
-odac -+rtaudio=null -d
```


 On desktop Csound we are used to seeing a flag like this:
```csound
-odac   ;;;realtime audio out
```


 The flag "-d" is used to suppress display, and `+rtaudio=null` is used to tell it we are not using a desktop audio module such as ASIO or ALSA. We are still using `dac` as our output, but the Csound Android library handles configuring and setting up the OpenSL driver.

 Csound CSD files that do not require interaction can be run as is. To use the UI elements in the CSD Player app, the application uses a set of Csound channels that map to a set of user interface elements. It uses the names of the elements, such as "trackpad.x", "trackpad.y", "button1", "button2", etc. Your Csound project can then access the values of the elements using the `chnget` opcode.

 Note: currently, the CSD Player does not use multitouch, although in the Csound Android API Examples you can find an example that uses multitouch. Therefore, this is not a limitation of the Csound API, but rather just the way the player app is designed at the moment.

 As far as the headers go, you have some different options. Android will handle both mono and stereo and you can use `0dbfs` settings if you are using an opcode that calls for that setting.

 The first thing I do is initialize my trackpad. There is no need to initialize the sliders, because those work fine on their own without initialization.
```csound
k1 init 1
```


 Once I set that up, I can set my channels, which are set to `k `type variables.
```csound
k1 chnget "trackpad.x"
k2 chnget "slider1"
k3 chnget "slider2"
k4 chnget "slider3"
```


 As these receive a value between 0.0 to 1.0, I need to scale all of them except for the resonance because that naturally takes a value within default range. I do extra scaling on frequency so I can get some interesting aliasing effects when I use high frequencies, achieving a dubstep-type screech. For the filter rate, I divide the value by 1000 to get a usable value for that parameter. The little bit of scaling math you need to do is going to vary depending upon your choice of opcodes.
```csound
kfreq  = k1*300
kfiltq = k2
kfiltrate = k3/1000
kvibf  = 4*k4
kvamp  = .01
```


 Next we will pass these variables into the generator opcode. It is all very simple, but still pretty easy to break and hard to debug for now.
```csound
;low volume is needed
asig moog .15, kfreq, kfiltq, kfiltrate, kvibf, kvamp, 1, 2, 3

outs asig, asig
```


 Now in our score, we actually need to load impulse files into our wavetables for the Moog model to work. I keep it easy and place my impulse files into the same folder as my CSD so I do not have to figure out the path. (On my Samsung Prevail phone, I do not have enough space for a terminal emulator to find the paths from the command line.)
```csound
f 1 0 8192 1 "mandpluk.aiff" 0 0 0
f 2 0 256 1 "impuls20.aiff" 0 0 0
f 3 0 256 10 1	; sine
```


 For the final part, I add a long duration note so that the project continues to run for long time:
```csound
i1 0 360000
```


 You can experiment with other ways of doing continuous, eventless scores. This method works and is a similar approach to what you would for writing instruments for MIDI control with desktop Csound.


## III. Complex Synths

### Let's Waveguide Anyways


 For a more advanced example, I am going to show you how I setup a waveguide virtual model to run on the player. This has some limitations: if I use more than 2 controls at a time, the audio on my Prevail breaks up, so I limit myself to two controls. I had originally wanted to map these to either the trackpad or accelerometer, but I had some difficulties and could only get the sliders to work with this opcode. In addition, I needed to set the sliders to values before turning on my CSD in order to get sound right from the start. This is to show that some opcodes may be quirky, and that you may have to find a performance strategy that will work for you. Do not worry if you have to adapt: most opcodes will work as expected but some might still be a bit quirky. As of this writing, the Csound Android project is fairly new, and I am sure future versions will smooth out some of these quirks.

 For this project, I start out with setting up my slider channels using k-variables as before.
```csound
k1 chnget "slider1"
k2 chnget "slider2"
k3 chnget "slider3"
```


 Next, I scale the values. In this case the scaling math is totally different because the `wgflute` opcode has a different behavior and expects different values than the `moog` opcode.
```csound
kfreq = k1*440
kjet = k2*2000
iatt = 0.1
idetk = 0.1
kngain = 0.15
kvibf = k3*1000
kvamp = 0.05
```


 Then as before I will pass my k-variables into my opcode call.
```csound
asig wgflute .8, kfreq, kjet, iatt, idetk, kngain, kvibf, kvamp, 1

out asig
```


 In this case my score is even simpler than the previous example. I do not need to load any samples. I just set a basic sine wave f-table and one instrument call which lasts a long time.
```csound
f 1 0 16384 10 1
i1 0 360000
```

##  Conclusion


The CSD Player app allows you to run your Csound CSD projects on Android devices. While not not without its quirks, the CSD Player is a great tool for live performance, even at this early stage of development.

 If you would like hear these CSD’s in action, you can hear a recording of me jamming out on my Atrix 2 plugged into a Korg Monotribe’s analog filter on this [recording](http://soundcloud.com/shams93/spaceborg). ([Alternative OGG link](https://csoundjournal.com/redfern/spaceborg.ogg))


## References


[][1] Victor Lazzarini. "The Audio Programming Blog." *A General-Purpose UI for Csound on Android*. Internet: [http://audioprograming.wordpress.com/2012/03/16/a-general-purpose-ui-for-Csound-on-Android](http://audioprograming.wordpress.com/2012/03/16/a-general-purpose-ui-for-csound-on-android/). [October 3, 2012].
