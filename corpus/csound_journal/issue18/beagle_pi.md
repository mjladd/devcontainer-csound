---
source: Csound Journal
issue: 18
title: "BeaglePi"
author: "pinging the Csound website"
url: https://csoundjournal.com/issue18/beagle_pi.html
---

# BeaglePi

**Author:** pinging the Csound website
**Issue:** 18
**Source:** [Csound Journal](https://csoundjournal.com/issue18/beagle_pi.html)

---

CSOUND JOURNAL[](https://csoundjournal.com/index.html) | [Issue 18](https://csoundjournal.com/index.html)
## BeaglePi

### An Introductory Guide to Csound on the BeagleBone and the Raspberry Pi, as well other Linux-powered tinyware
 Paul Batchelor and Trev Wignall
 pbatchelor AT berklee.edu
 wwignall AT berklee.edu
## Introduction


The Raspberry Pi and the BeagleBone are two very popular computers about the size of a deck of cards. These so-called "tinyware" devices contain USB ports, onboard ethernet, and audio/visual output capabilities. Both devices use Linux as an operating system, which allows them to utilize a large array of programming languages and applications available on the Linux platform, including Csound.

The goal of this article is to provide a brief introduction to using Csound on either one of these devices to create a real-time performance device. No prior experience is necessary with Linux, but some familiarity with basic Unix commands is recommended.

It should be noted that while many concepts for running Csound on both the BeagleBone and the Raspberry Pi overlap (enough to warrant a joint article on the two devices), there are a few notable differences between them. The Pi is built so that it works out-of-the-box as a functional desktop computer. The BeagleBone, on the other hand, has a modular approach to hardware, where one has to buy and configure external attachments (called "capes") for the utilization of audio and video. These differences will be addressed more in the article.

This article assumes that you have already flashed an SD card and we will not cover that aspect, as there is plenty of documentation readily available on the subject of SD cards.

For help in setting up the Raspberry Pi SD card, follow the link listed here:
- [http://elinux.org/RPi_Easy_SD_Card_Setup#Copying_an_image_to_the_
 SD_card_in_Mac.C2.A0OS.C2.A0X_.28command_line.29](http://elinux.org/RPi_Easy_SD_Card_Setup#Copying_an_image_to_the_SD_card_in_Mac.C2.A0OS.C2.A0X_.28command_line.29)

For help in setting up the BeagleBone SD card, follow the link listed here:
- [http://hack-beagle.blogspot.com/2012/06/getting-started-with-beaglebone.html](http://hack-beagle.blogspot.com/2012/06/getting-started-with-beaglebone.html)


## I. About Debian Linux


This article was written running versions of Debian Linux specifically built for both the Pi and the BeagleBone. Debian is a distribution, or "distro" of Linux. A distribution can be thought of as a flavor of Linux, and is often made for a specific audience or task. Debian is one of the older and more stable Linux distributions and is very general-purpose. While it is the default Linux distribution for the Raspberry Pi, it is not for the BeagleBone. The BeagleBone ships with the Angstrom distribution, specifically made for the BeagleBone. This article will be using the Debian image found at the link listed here:
- [http://hack-beagle.blogspot.com/2012/09/debian-on-beaglebone_7.html](http://hack-beagle.blogspot.com/2012/09/debian-on-beaglebone_7.html)


## II. Setting Up

### Installing Csound


The easiest way to install Csound is to use the package manager named `apt`. A package manager automatically maintains and updates software and all the libraries that software package requires. These required packages are called dependencies. Usually the version of Csound accessed from the repositories is an earlier version than the most recent release of Csound. For this reason, many Linux users choose to compile Csound. Compilation, due to the large number of variables involved, is beyond the scope of this article, but there is help for building Csound located in [The Canonical Csound Reference Manual.](http://www.csounds.com/manual/html)

Once you have started your device, you can test the internet connection by pinging the Csound website (a wired ethernet connection is preferred). To do this, open a terminal and execute the command:
```csound
ping www.csounds.com
```


If an error is returned like "server not found", the internet connection needs to be checked. If successful, a series of lines will print out indicating that packets of data are being sent and received. Csound can then be installed on the device with the commands below, executed from the command line.

To install Csound, run:
```csound
sudo apt-get install csound
```


To update the package manager, run:
```csound
sudo apt-get update
```


The package manager will download the required packages and install them on the device automatically. These packages are pre-compiled binaries specifically for the ARM platform.
### Setting up QuteCsound


Qutecsound (now known as CsoundQt) is a valuable cross-platform front-end for designing and testing CSDs. It is a user friendly interface complete with a console, the Csound manual, and more. You can develop CSD's on the tinyware itself, sidestepping any problems that arise from porting it from a foreign system. To use QuteCsound you will need a desktop environment. The Raspberry Pi's SD card comes with one preinstalled. BeagleBone users will need to install one. For this article LXDE will be used because it is a relatively lightweight desktop environment with a low CPU footprint.

To install LXDE, enter:
```csound
sudo apt-get install lxde
```


Installing LXDE takes quite a while. Once the desktop environment is installed, you can install QuteCsound (CsoundQT) with the following command:
```csound
sudo apt-get install qutecsound
```


After installation, reboot the device with:
```csound
sudo reboot
```


BeagleBone users will be prompted with a graphical login screen for LXDE. Raspberry Pi users need to login and then start LXDE with the command `startx`. QuteCsound should be available in the menu after it is installed.
### Executing Csound from the command line


For real-time performance, Csound should be invoked from the command line. A typical CSD file could be run using these arguments[[1]](https://csoundjournal.com/#ref1):
```csound
csound -odac -+rtaudio=alsa -B2048 -b2048 /path/to/file.csd
```


Alternatively, the command line flags can be placed in the CsOptions section of the CSD instead, allowing you to just run the following command:
```csound
csound /path/to/file.csd
```


Linux offers a few dedicated text editors, all of which can be used to edit CSD files. An easy one to get started with is *nano*. Another, called *Vim*, is much more sophisticated. With the [csound-vim](http://www.eumus.edu.uy/docentes/jure/csound/vim/) plugins by Luis Jure, Vim becomes a very powerful tool. However, Vim's learning curve is beyond the scope of this article.


## III. Creating Csound Instruments

### Setting Up Audio


A USB-powered soundcard is strongly recommended for any serious audio use. Unfortunately, it is quite difficult to find high-quality Linux-compatible soundcards. The ALSA wiki has a list of sound cards reported to work under Linux[[2]](https://csoundjournal.com/#ref2). The best soundcard that has been known to work with the Bone/Pi is the Behringer UCA202. In addition to RCA input/output, there is also headphone output with adjustable volume control.

By default, Csound uses the PortAudio module to communicate with the hardware device. However, we prefer using ALSA (the Advanced Linux Sound Architecture) on Linux systems. BeagleBone users will need to install ALSA using the command:
```csound
sudo apt-get install alsa-utils
```


Raspberry Pi users should already have ALSA installed. To use ALSA instead of PortAudio, use the flag `-odac -+rtaudio=alsa` as part of the Csound command.

To specify a specific audio device, you can utilize the command:
```csound
aplay -l
```


The above command will list the available soundcards[[3]](https://csoundjournal.com/#ref3) such as those shown below:
```csound

**** List of PLAYBACK Hardware Devices ****
card 0: EVM [AM335X EVM], device 0: AIC3X tlv320aic3x-hifi-0 []
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 1: CODEC [USB Audio CODEC], device 0: USB Audio [USB Audio]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

```


Using the Csound flag `-odac:hw:1` will select card 1, which is the Berhinger USB audio soundcard.

Specifying Csound input is done by typing `-i adc`. The same procedure that is used for selecting specific cards for `-o` applies to `-i` as well. For example: `-iadc:hw:`

To test your speakers and to make sure audio is working, run the following ALSA command, which will play white noise out of the speakers:
```csound
speaker-test
```


To adjust the volume of your speakers, run the ALSA command below, which will provide a set of "faders" with which you can use the arrow keys to move up or down:
```csound
alsamixer
```



### Setting up Audio hardware for the BeagleBone


Lacking the Raspberry Pi's built in analogue audio and video outputs, the BeagleBone requires an external attachment called a *cape*. The "DVI-D with audio" cape is a more integrated alternative for the platform than using a USB soundcard. In addition to having two channels of audio input and output, it provides HDMI video output as well which is essential for using a Csound frontend. Using this cape also frees the BeagleBone's single USB port.

If the audio cape is to be fitted onto the BeagleBone with no capes in between, then it is imperative to leave as much space as possible between the boards. The input audio jack is situated directly above the 5V power jack. Forcing both cables into their jacks when the boards are too close together will gradually weaken the audio input jack's connection to the cape. Should this happen, it can be carefully soldered back onto the board again using a soldering iron with a fine point tip.

In order to initialize the cape during boot-up and to restore alsamixer settings, open the file `/etc/rc.local` in nano:
```csound
sudo nano /etc/rc.local
```


Type these following lines into `/etc/rc.local`[[4]](https://csoundjournal.com/#ref4):
```csound

# Load DVI-D w/ Audio Cape.
modprobe snd_soc_davinci_mcasp
modprobe snd_soc_davinci
modprobe snd_soc_evm
modprobe snd_soc_tlv320aic3x

# Now restore alsamixer settings.
alsactl restore

```


Since there are many parameters that require adjusting, we will use a script. Create and copy the following into a script file named `cape_config.h`:
```csound

amixer set PCM 100%
amixer set HP unmute
amixer set 'HP DAC' 100%
amixer set 'Left HP Mixer DACL1' unmute
amixer set 'Left PGA Mixer Line1L' unmute
amixer set 'Right HP Mixer DACR1' unmute
amixer set 'Right PGA Mixer Line1R' unmute
amixer set 'AGC' mute
amixer set 'Left HP Mixer DACR1' mute
amixer set 'Left PGA Mixer Line1R' mute
amixer set 'Right HP Mixer DACL1' mute
amixer set 'Right PGA Mixer Line1L' mute
amixer set 'PGA' 0%

```


Then run the script using the following command:
```csound
    sh cape_config.sh
```


To save the alsamixer settings, enter the following code:
```csound
    sudo alsactl store
```


The `/etc/rc.local` file will prompt the BeagleBone to detect the cape and restore alsamixer settings on boot before logging in.
### Setting Up MIDI for the Raspberry Pi/BeagleBone


Most standard MIDI controllers should work on a Linux system without any issues. By default, Csound uses PortMIDI, but we recommend to use ALSA. To use ALSA, use `-+rtmidi=alsa` when running Csound.

MIDI device selection with Csound is done using the `-M` flag. To use all available MIDI devices as input, use the Csound flag `-Ma`.

To use a specific MIDI controller, you can list all the available MIDI devices using the Linux command below[[5]](https://csoundjournal.com/#ref5):
```csound
cat /proc/asound/cards
```


The output will look something like this:
```csound

0 [EVM            ]: AM335X_EVM - AM335X EVM
                     AM335X EVM
1 [O25            ]: USB-Audio - Oxygen 25
                     M-Audio Oxygen 25 at usb-musb-hdrc.1-1, full speed

```


Each listed MIDI controller will have a specific number assigned to it. For instance, to use the Oxygen 25 (device number 1), you would use the Csound command-line flag `-+rtmidi=alsa -M hw:1`.


## IV. Optimizing Csound Instruments


The Raspberry Pi and BeagleBone have a fraction of the processing power that a modern computer has. A real-time Csound instrument that runs well on a Macbook Pro may run quite poorly on a Raspberry Pi or BeagleBone, and therefore some modifications to the instrument must be made to prevent unwanted clicks and drop-outs. There is a true art to making good-sounding instruments on platforms with limited CPU resources, and below are some quick tricks that can help optimize realtime instruments created on other computers.

The first thing that should be changed is the buffer size in the CsOptions. The hardware buffer size (`-B`) specifies the size of the buffer used by the audio hardware connected or built into the device and is especially important[[1]](https://csoundjournal.com/#ref1). The software buffer size dictates the buffer size used by Csound[[1]](https://csoundjournal.com/#ref1). These should be set as low as possible without causing dropouts in the rendered audio. On the BeagleBone, optimal performance can be achieved by defining a hardware buffer size of 512 samples. On the Raspberry Pi, software buffer sizes in the range of 1024-4096 will bring good results. Some experimentation may be required for optimal performance on your particular system. Bear in mind that raising the buffer size will introduce more latency. It should also be noted that on the BeagleBone, the software buffer size has to be 1/16th of the hardware buffer size. In fact, Csound will not allow it to exceed this if a BeagleBone audio cape is being used.

Lowering the sample rate (`sr`) of an orchestra can also be quite a beneficial optimization for real-time performance. Many CPU-intensive instruments can run smoothly at a samplerate as low 24 kHz. Be mindful about sample rate when using audio input: aliasing effects will be much more audible with sample rates lower than 44.1 kHz. Some frequency dependent opcodes will crash Csound if values above the sampling rate are used.

The third option that dramatically affects performance is the control rate (`ksmps`). This should be set so that the CSD runs without errors and dropouts. Try to get this as low as possible; it is not uncommon to have a `ksmps` value at around 40. However, be aware that using larger ksmps values can introduce more apparent "stair-stepping" distortion into the control signal.

Limiting the number of voices that an instrument can play is also a good way to prevent CPU overloads. The `maxalloc` opcode will limit the number of voices that can be played at once, reducing the likelihood of crashing by pressing too many keys down at once, for example from a keyboard controller. Also, be careful with release times, because long releases may negatively affect the playability of the instrument.

Changing the length of your GEN routines can also be a easy way to dramatically optimize the instrument. Since most GEN routines only take power of two, this will require halving lengths. For instance, a `GEN 10` sine wave with a size of 8192 can be too CPU-expensive for a Pi/BeagleBone. You may want to try a value of 4096, 2048, or even 1024 instead. Be aware that with smaller GEN routine lengths, the fidelity of the wave form will be reduced, and you will need to find an acceptable balance between sound quality and performance.

When control over the above options still do not bring the desired results, there is another powerful tool: the `--sched` flag. This flag gives the system's computational priority to Csound. This requires root privileges so you will need to run Csound with `sudo csound --sched FLAGS foo.csd`. The user will also need to be careful as the --sched flag may lock up the system!


## V. Running Headless (Standalone)


This section will illustrate how to set up a BeagleBone/Raspberry Pi to run as a Csound instrument without the aid of a computer screen. This is also known as running "headless."
### Configuring Auto-Login


To set it up your device so that it automatically logs in at start-up, edit the `/etc/inittab` file with administrative privileges.

Run nano to edit the file `/etc/inittab` with administrative privilages:
```csound
sudo nano /etc/inittab
```


Scroll down using the arrow keys to this line:
```csound

1:2345:respawn:/sbin/getty 115200 tty1

```


Comment it out with the # character so that it looks like this:
```csound

#1:2345:respawn:/sbin/getty 115200 tty1

```


Write this line underneath it, substituting "USERNAME" with the name of the user to be logged in [[7]](https://csoundjournal.com/#ref7):
```csound

1:2345:respawn:/bin/login -f USERNAME tty1 /dev/tty1 2>&1

```


Enter `ctrl-X` to exit nano. Enter `Y` to save the changes, and then press `Enter` to overwrite the file. When the device is rebooted it will login automatically, and this can be verified by connecting a monitor to the Raspberry Pi, or to the BeagleBone with a video output cape. If a mistake is made and the device hangs on boot, entering `ctrl-alt-f2` will allow you to login using the next virtual terminal window, where `/etc/inittab` can be repaired. Note that if the screen application is being used to monitor the device, it will not recognize the automatic login and login will still need to be performed manually.
### Execute Csound at Boot


When using your device as a musical instrument, Csound will need to start automatically. Once automatic log-in is setup for your device, commands can be added to the file in `~/.bash_profile`, which will be executed after the login process. To do this, run the command:
```csound

nano ~/.bash_profile

```


Then add the following line:
```csound

csound foo.csd

```


"foo.csd" should be the name of the .csd file to be executed at boot. If the directory is not explicitly navigated to with the `cd` command, Csound will automatically look for the .csd in the home (~) directory. If all the necessary command-line flags are added in the CsOptions part of the .csd, then there is no need to set any flags in `~/.bash_profile`. The next time the device reboots, the .csd will automatically execute after automatically logging in.

To run Csound in the background, thus enabling other programs to be executed concurrently, add an ampersand to the end of the command in `~/.bash_profile`:
```csound

csound foo.csd &

```


To stop Csound from running, execute the following command:
```csound

sudo killall csound

```


Csound can also be executed from the file `/etc/rc.local`, but `~/.bash_profile` is more convenient because it does not need root privileges.
### Setting up SSH


SSH is a network protocol that allows users to remotely access another computer through a network. It is also a way of sending files from one computer to another. SSH is a convenient way of accessing your headless Pi/BeagleBone without having to utilize an external screen and keyboard.

Please note that these steps have only been tested on Linux and Mac OSX computers. Windows users may have to do some additional research to get SSH working properly.

By default, SSH is enabled on the device, but it needs to be configured to have a static IP address. Open the file `/etc/network/interfaces` in nano or another text editor:
```csound

sudo nano /etc/network/interfaces

```


Find a line that says the following:
```csound

iface eth0 inet dhcp

```


And comment it out with the # key:
```csound

#iface eth0 inet dhcp

```


Below it add these lines, including the indentation as indicated[[6]](https://csoundjournal.com/#ref6):
```csound

iface eth0 inet static:
	address 169.254.0.1

```


Save the file and exit. This will be the IP address that other computers will use to connect to the Pi. Note that the address is somewhat arbitrary, but it will be the one used for this article. Reboot the device. Plug one end of a standard ethernet cable into the network port on the device, and the other into the port of a Linux or OSX computer. On the Linux or Mac, open up the terminal and test that the connection works with `ping 169.254.0.1`. This should output the same result as pinging csounds.com. If not, check to make sure you have configured everything correctly and try again.

After successfully pinging the device, remote log in can be done with the command `ssh USER@169.254.0.1`, where "USER" should be substituted with whatever the username is on the device. On the Raspberry Pi, the default is `pi`, and on the BeagleBone the default is `debian`. Enter the password. On the Raspberry Pi it is `raspberry` and on BeagleBone it is `temppwd`. Once logged in, the command line of the device will be directly accessed. To exit, simply enter the command `exit`.

Sending files to and from the device via SSH is done with `scp`, which is short for "Secure CoPy". To send a file called foo.csd to the device, change to the directory that foo.csd is in, and run the command `scp foo.csd USER@169.254.0.1:foo.csd`. As above, change "USER" to whatever the username on the target device is. This will copy foo.csd into the home directory (/usr/home/USER) of the device. To copy a folder `foo` onto the device, run the same command with the `-r` (recursive) flag: `scp -r foo USER@169.254.0.1`.

Remembering "169.254.0.1" can be inconvenient, especially when using multiple devices with unique IP addresses. On the computer accessing the device, give the IP address a host name that will be easier to remember by adding this line to the end of `/etc/hosts`:
```csound
169.254.0.1 tinyware
```


Now run `ssh USER@tinyware` and it will log into the device.


## VI. Example Instruments


Below are four example instruments which have been created and/or optimized to run well on the BeagleBone and the Pi, and these are freely available for use and modification. You can download the code for these examples here: [pi_bone.zip](https://csoundjournal.com/downloads/pi_bone.zip). The sound generation and synthesis techniques utilized in these instruments are frequency modulation and sampling. Historically those techniques have proven to be CPU-efficient which is why they are utilized as examples.

The `Pangelis` instrument utilizes a single FM operator pair to create a plucked timbre, which is then fed through the `reverbsc` opcode. MIDI CC values 11, 12, 13, 14, and 18 control pitch bend, vibrato, attack time, modulation index, and reverb level, respectively. Also noteworthy is the `maxalloc` opcode that limits the maximum number of notes played at once to be eight. This is an easy way to prevent the user from overloading the audio by playing too many notes.
```csound

Pangelis:
A vangelis inspired synthesizer built specifically for the Raspberry Pi.
By Paul Batchelor
March 2013
<CsoundSynthesizer>
<CsOptions>
-odac:hw:0 -+rtaudio=alsa -B 2048 -b 2048 -+rtmidi=alsa -Ma
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 256
0dbfs = 1
nchnls = 2

alwayson 1
alwayson 999
gisine ftgen 0, 0, 4096, 10, 1

garvbL init 0
garvbR init 0

initc7 1, 11, 0
initc7 1, 18, 1
initc7 1, 12, 0
initc7 1, 13, 0
initc7 1, 14, 0

maxalloc 1, 12

instr 1 ;Pangelis
iamp = .2
icps cpsmidi

kbend linseg 1, 6, .75
kbend port kbend, 0.001

;vibratro level CC 12
klev ctrl7 1, 12, 0, 0.02
;manual bend amount CC 11
kbend2 ctrl7 1, 11, 1, 1.3
;modulation index CC 14
kmod ctrl7 1, 14, 1, 5
;attack time CC 13
iatk ctrl7 1, 13, 0.01, 1.1
kvib oscil klev, 5, gisine
kjit jitter 0.002, 6, 3
kenv expsegr .1, iatk, 1, 2, 0.0001, 2, 0.0001
a1 foscil iamp*kenv, icps*kbend*(1+kjit)*(1+kvib)*kbend2, 2, 3, kenv*kmod, gisine
outs a1, a1
garvbL = garvbL + (a1 * .5)
garvbR = garvbR + (a1 * .5)
endin

instr 999 ;reverb
;reverb level 18
krev ctrl7 1, 18, 0, 1
aL, aR reverbsc garvbL, garvbR, .95, 15000
outs aL * krev, aR * krev
garvbL = 0
garvbR = 0
endin
</CsInstruments>
<CsScore>

t 0 180
f 0 999

</CsScore>
</CsoundSynthesizer>

```


`Lorenz FM` is an instrument that consists of another FM operator pair, but what makes it interesting is that the famous Lorenz Strange Attractor influences its parameters. The Prandtl number influences the attack behavior, the ratio of the box width and length control its timbre, and the Rayleigh number causes the sound to behave chaotically. This example also uses the `reverbsc` opcode. MIDI CC values of 11, 12, 13, 14, 15 ,16, 17, and 18 control the Prandtl Number, modulator, the ratio of width and length of the box, the Raleigh number, attack, decay, sustain, and reverb amount respectively.
```csound

<CsoundSynthesizer>
<CsOptions>
-+rtaudio=alsa  -B1024 -+rtmidi=alsa -M hw:1 -odac
</CsOptions>
<CsInstruments>
sr 		= 		24000
ksmps 	= 		45
0dbfs	=		1

gisin	ftgen   8, 0, 512, 10, 1
garvbL init 0
garvbR init 0

ctrlinit  1, 7,64,  11,52,12,30,13,11, 14,47, 15,0, 16,64, 17,64, 18,64

;=============================================================================
maxalloc 1, 6
	instr 1	; Lorenz FM

icps		cpsmidi
iamp		ampmidi	1

ihtim	=	.01		;port time


kvol		midic7 7, 0, .5
kpvol		port kvol, ihtim

ksv      	midic7  	11,.1,8    			; The Prandtl Number or Sigma
kpsv		port ksv, ihtim

kmod		midic7	12,0,24
kpmod		port kmod, ihtim

kbv      	midic7  	13, .1,1.667 		; Ratio Of the Length And Width
kpbv		port kbv, ihtim					; of the box

krv      	midic7  	14, 2, 10 			; The Rayleigh Number
kprv		port krv, ihtim

ax,ay,az 	lorenz   	kpsv, kprv, kpbv, .01, .6, .6, .6, 1
kx   		downsamp  ax
ky  	 	downsamp  ay
kz  		downsamp  az

imatk    	midic7  	15,.001, 4
imdec    	midic7  	16,.001, 1
imsus    	midic7  	17, 0, 1

kenv		madsr	imatk, imdec, imsus, .01
afm		foscil	kenv*iamp, icps+kx, 1, 1+kz, kpmod*ky, gisin
 		out		afm * kpvol
garvbL = garvbL + (afm * .5)
garvbR = garvbR + (afm * .5)

endin

;=============================================================================

instr 999 ;Reverb
;vibrato amount
krev ctrl7 1, 18, 0, .5
aL, aR reverbsc garvbL, garvbR, .8 + .15*krev, 15000
outs aL * krev, aR * krev
garvbL = 0
garvbR = 0
endin

;=============================================================================

</CsInstruments>
<CsScore>

f0  600
i999 0 600

</CsScore>
</CsoundSynthesizer>

```


`Diskin Looper` uses the `diskin2` opcode to load a drum loop from BT's (aka Brian Transeau) freely available OLPC drum loop library. The playback speed can be controlled with MIDI CC value 11. A toggle has been created so that when the user presses the space bar, it toggles the manual playback speed on/off.
```csound

<CsoundSynthesizer>
<CsOptions>
-odac -Ma -+rtmidi=alsa -+rtaudio=alsa -B 2048 -b 2048
</CsOptions>
; ==============================================
<CsInstruments>

sr	=	44100
ksmps	=	10
nchnls	=	2
0dbfs	=	1

initc7 1, 11, 0.75

instr 1
key sensekey

ktog_pch init 1
printk2 key
printk2 ktog_pch

;MIDI CC1 controls pitch
kcps ctrl7 1, 11, -2, 2
kcps portk kcps, 0.01

;midi controlled diskin loop
a1 diskin2 "FunkSoulSista.wav", kcps, 0, 1
;normal diskin loop
a2 diskin2 "FunkSoulSista.wav", 1, 0, 1

;space bar toggles the normal and midi controlled loop
if(key == 32) then
	if(ktog_pch == 0) then
		ktog_pch = 1
	elseif(ktog_pch == 1) then
		ktog_pch = 0
	endif
endif

if(ktog_pch == 1) then
	;send midi controlled loop to outputs
	aout = a1
elseif(ktog_pch == 0) then
	;send normal loop to outputs
	aout = a2
endif

outs aout, aout

endin

</CsInstruments>
; ==============================================
<CsScore>

i1 0 10000

</CsScore>
</CsoundSynthesizer>

```


`Monophonic Synth `is a modified instrument from the OLPC collection. It is particularly due to it being strictly monophonic. It is a very stable instrument for performance because it is impossible to overload it by playing too many notes at once.
```csound

<CsoundSynthesizer>
<CsOptions>
-odac -Ma -b 2048 -B 2048 -+rtaudio=alsa -+rtmidi=alsa
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 10
nchnls	=	2

; MidiMonoSyn, Version A: 1 osc, 1 filter, pitch and vel portamento

#define ON 		#1#
#define OFF 		#0#
#define NOTEON		#144#	; midi status num for note on
#define NOTEOFF	#128# 		; midi status num for note off

; values for synthstate to keep track of what's happening
#define NEWDETACHED #1#
#define DETACHED	#2#
#define NEWLEGATO   #3#
#define LEGATO		#4#
#define NEWRELEASE  #5#
#define RELEASING	#6#

gaSig init 0
initc7 1, 18, .5
	instr 128
; dummy instr to catch the annoyning default midi routing
; if this is not here, instr 130 gets turned on and off by the keyboard
	endin

	instr 130

; Control variable initialization. Change these as desired

; The stuff here can be turned into real time controls in later versions

iampatt		init		0.001
iampdec		init		0.3
iampsus		init		0.8
iamprel		init		0.01
iampmute	init		0.0005		; time to damp previous note

idetfrqprt	init		0.001		; pitch portamento for non legato
ilegfrqprt	init		0.05		; pitch portamento time for legato

kvolume		init		20000			; amp value for full velocity. ( 1 )

ichan		init		1			; which midi channel to pay attention to

;******************************************************************************
; Variable initialization. This only happens once. Don't change these.

kactive		init		0			; number of active midi notes
ksynstate	init		$NEWRELEASE ; starts as playing with envelopes closed

kampenv		init		0			; amp env starts at 0
kamprelenv	init		0.0001		; rel env starts at 0 so we hear silence
kamp			init		0.0001	; final kamp (either main env or rel env)
kfrq			init		440		; need some dummy starting pitch

ifrqprt		init		0.001		; meaningless initialization

; Note, ksynstate tells us what is happening.
; It only lasts for one kpass for new notes.

;******************************************************************************
; Midi Parser section.

; This section receives midi input and decides what state the synth is in.
; You can change this section to change how midi input is interpreted.
; In this version any held note will keep the synth in legato and playing
; the most recently played note.

; Get any waiting midi message
kstat, kchan, kdata1, kdata2	midiin

; ignore messages on other channels
if ( kchan != ichan ) kgoto DoneMidiIn

; if we get a note on and vel is not 0, goto note on section
if ( ( kstat == $NOTEON ) && ( kdata2 != 0 ) ) kgoto NoteOn

; if we get a note off or note on vel 0, goto note off section
if (( kstat == $NOTEOFF )||( ( kstat==$NOTEON )&&(kdata2 == 0))) kgoto NoteOff

; any other incoming midi messages are ignored for now
kgoto DoneMidiIn

; Note on section
NoteOn:

	; increment kactive ( active note counter )
	kactive = kactive + 1

	; if this is the only active note, we have a new detached note
	ksynstate = ( kactive == 1 ? $NEWDETACHED : ksynstate )

	; if there are other active notes, we have a new legato note
	ksynstate = ( kactive > 1 ? $NEWLEGATO : ksynstate )

	kgoto DoneMidiIn


; Note off section
NoteOff:

; if there is more than one note playing, ignore this note off
; or if no notes are playing, ignore the note off (in case of panic button)
	if ( ( kactive > 1 ) || ( kactive == 0 ) ) kgoto IgnoreNoteOff

	; otherwise, decrement kactive
	kactive = kactive - 1

	; and set ksynstate to $NEWRELEASE
	ksynstate = $NEWRELEASE

	kgoto DoneMidiIn


IgnoreNoteOff:

	; we update the active note counter, but don't do anything else
	; the note counter is held at minimum 0
	kactive = ( kactive <= 0 ? 0 : kactive - 1 )

DoneMidiIn:

;******************************************************************************
; New Note section:

;For a new detached note we need to restart the envelopes and portamento ramps.
;For a new legato note we restart the portamento ramps, but not the envelopes.

;The reinit code only affects anything on a reinit pass, else it is ignored.
;However the reinit section must also enclose the envelope code so it restarts.
;When we are not actually reiniting, we pass through the envelope code as well.

;******************************************************************************
; Amp env section

; if we are in a release stage, skip to release env section
if ( ksynstate == $NEWRELEASE || ksynstate == $RELEASING ) kgoto ReleaseSection

; If this is the first kpass of a new detached note, kgoto to the NewAmpEnv
; reinit
; On all other passes we must continue to the AmpEnv section

if ( ksynstate == $NEWDETACHED ) kgoto NewAmpEnv
	kgoto AmpEnv

; The reinit section. We only get here on a new detached note.
NewAmpEnv:

	; on a new detached note we must reinit the envelopes
	reinit NewAmpEnv

	; freezing of any controls for detached notes goes here, ie env values

	; freeze last amp value, new env starts from there.
	iampstrt		init		i( kamp )


; The actual amp env section, we get here on both reinit and continuing passes
; However, the reinit pass *restarts* the envelope.
AmpEnv:

	; Amp envelope section, we must hit this on all passes

	; Envelope starts from the last value used, 0.001 if a note finished the
	; release
	; Envelope just ends parked on the sus level.
	; Uncomment whichever version of the env you want to use

	; "String damping" version of the env
	; quickly goes to 0.001 before the attack
	kampenv	linseg iampstrt,iampmute,0.001,iampatt,1,iampdec,iampsus,1,iampsus

	; "Continuous sound" version of the env
	; env starts from last value. long release time will change slope of attack
	;kampenv	linseg	iampstrt, iampatt, 1, iampdec, iampsus, 1, iampsus

	; End the reint pass for the NewAmpEnv
	; ( This has no effect during non reinit passes )
	rireturn

; skip the release section
kgoto DoneAmpControl

;******************************************************************************
;The Release Envelope section.

;The release env starts from the last amp value used, and closes to 0.0001
;Between notes ( after release time ) it is held at 0.0001 so we hear silence.

;On the first kpass of a release we do the reinit section and the release
;env code.
;On subsequent kpasses we hop ahead to the release env code.

ReleaseSection:

if ( ksynstate == $NEWRELEASE ) kgoto NewRelease
	kgoto Releasing

NewRelease:

	; reinit the release env, only happens on $NEWRELEASE passes
	reinit NewRelease

	; freeze the ampenv starting points here
	iampstrt	init	i( kamp )


Releasing:

	; release env starts from last amp value used and parks on 0.0001
	kamprelenv	expseg	iampstrt, iamprel, 0.0001, 0.2, 0.00001

	; end the reinit pass, this has no effect on $RELEASING passes
	rireturn

; ( label we hop to when skipping the release code )
DoneAmpControl:

;******************************************************************************
; Pitch and Velocity portamento section

; We have finished the env code. Now we do the pitch ramp code
; Note: we should be here on all passes, even release passes, as we might
; play a very short note with a long port time, and have the pitch still
; be gliding during the release stage.

; On either new detached or new legato notes, we must reinit the frq ramps
; We merely choose which port time to use based on detached or legato
if ( ksynstate == $NEWDETACHED || ksynstate == $NEWLEGATO ) kgoto NewFrq

	; on all other passes continue the pitch ramps
	kgoto FrqRamp

NewFrq:

	; start the reinit pass from NewFrq
	reinit NewFrq

	; freeze the starting pitch for the portamento
	; the start pitch is the last used pitch from the previous note
	; this is working
	ifrqstrt 	init		i( kfrq )

	; choose which portamento speed to use
	isynstate	init		i( ksynstate )
	ifrqprt	= 		( isynstate == $NEWDETACHED ? idetfrqprt : ilegfrqprt )

	; freeze the destination pitch from the midi note number
	inotenum	init		i( kdata1 )

	; convert the midi note num to cps, ( thanks Istvan! )
	ifrqdest	init		cpsoct( inotenum * 0.08333333 + 3 )

; we get here on all passes, including the reinit ones
FrqRamp:

	; the pitch ramp straightens out on the destination pitch
	kfrq		expseg	ifrqstrt, ifrqprt, ifrqdest, 1, ifrqdest

	; end the NewFrq reinit pass
	rireturn

;******************************************************************************
; Sound Section

; The envelopes and pitch ramps have been generated, now we make some noise.

; Three detuned oscillators so we can hear beating

; Add jitter to simulate analogue oscillators
kjit jitter 1.5, 1, 8
kjit2 jitter 1.5, 1, 8
kjit3 jitter 1.5, 1, 8

asig1 vco2 0.33, kfrq + kjit
asig2 vco2 0.33, kfrq * 0.995 + kjit
asig3 vco2 0.33, kfrq * 1.005 + kjit

; Combine the oscillators
asigcomp	=		asig1 + asig2 + asig3

; Keyboard-scaled
asigfilt moogvcf asigcomp, 2000 + kfrq, 0.2

asigcomp balance asigfilt, asigcomp

; choose which envelope we should use based on ksynstate
kamp=(ksynstate==$NEWRELEASE || ksynstate==$RELEASING ? kamprelenv : kampenv)

;amplify using linear interpolation of the envelope for smoothness \
;(and MIDI volume control)
asigout	=		asigcomp * a(kamp) * kvolume

; output the signal
		outs		asigout, asigout
		gaSig = asigout*0.8 + gaSig

;******************************************************************************
; Update the synstate.

; $NEWRELEASE will change to $RELEASING
; $NEWDETACHED and $NEWLEGATO will change to $PLAYING

ksynstate = ( ksynstate == $NEWDETACHED ? $DETACHED : ksynstate )
ksynstate = ( ksynstate == $NEWLEGATO ? $LEGATO : ksynstate )
ksynstate = ( ksynstate == $NEWRELEASE ? $RELEASING : ksynstate )

		endin

	instr 999 ;Reverb with MIDI control
klev ctrl7 1, 18, 0, 1
aoutL, aoutR reverbsc gaSig, gaSig, .7, 10000
outs aoutL*klev, aoutR * klev
gaSig = 0
	endin

</CsInstruments>
<CsScore>

;sawtooth wave with gen 7
f4	0 4096 7 -1 4096 1

; turn on the instrument, for some reason ihold won't work with reinits
i130 0 1000
i999 0 1000

e

</CsScore>

</CsoundSynthesizer>

```



## VII. Conclusion


It is an unexpected surprise to see the world of tiny Linux computers (so-called "tinyware") become popular so quickly amongst the DIY and tech community. The open source platform is an ideal medium for ideas to be shared and spread quickly, and a very large Raspberry Pi/BeagleBone community has grown as a result of this. The Csound community is fortunately open source as well, and can participate in this exponential growth of inexpensive computing devices. It is the hope of both authors that more interesting sounds, beautiful music, and mini, musical, interactive instruments will be created on both the Raspberry Pi and the BeagleBone. These new platforms should provide a new and unique twist on the constantly changing musical language, as well as help draw a new audience to Csound.
## References


[][1] Barry Vercoe et Al.. 2005. "Csound Command Line," *The Canonical Csound Reference Manual*. [Online]. Available: [http://www.csounds.com/manual/html/CommandFlags.html](http://www.csounds.com/manual/html/CommandFlags.html) [Accessed March 19, 2013].

[][2] AlsaProjet Wiki. "Alsa SoundCard Matrix". [Online], Available: [http://www.alsa-project.org/main/index.php/Matrix:Main](http://www.alsa-project.org/main/index.php/Matrix:Main) [Accessed March 19, 2013].

[][3] Barry Vercoe et Al.. 2005, "Real-Time Audio," *The Canonical Csound Reference Manual*. [Online]. Available: [http://www.csounds.com/manual/html/UsingRealTime.html#RealTimeLinux](http://www.csounds.com/manual/html/UsingRealTime.html#RealTimeLinux) [Accessed March 19, 2013].

[][4] Google Groups. "BeagleBone Audio Cape". [Online]. Available: [https://groups.google.com/forum/?fromgroups=#!topic/beagleboard/qdLcceqH3ms](http://www.csounds.com/manual/html/UsingRealTime.html#RealTimeLinux) [Accessed March 19, 2013].

[][5] Barry Vercoe et Al.. 2005. "Real-time MIDI Support," *The Canonical Csound Reference Manual*. [Online]. Available: [http://www.csounds.com/manual/html/MidiTop.html](http://www.csounds.com/manual/html/MidiTop.html) [Accessed March 19, 2013].

[][6] Cyberciti. "Linux Static IP Address Configuration". [Online]. Available: [http://www.cyberciti.biz/faq/linux-configure-a-static-ip-address-tutorial/](http://www.cyberciti.biz/faq/linux-configure-a-static-ip-address-tutorial/) [Accessed March 19, 2013]

[][7] eLinux.og. "RPi Debian Auto Login". [Online]. Available: [http://elinux.org/RPi_Debian_Auto_Login](http://elinux.org/RPi_Debian_Auto_Login) [Accessed March 19, 2013]
### Additional Resources
  Audio optimizations for the Raspberry Pi:   Linuxaudio.org. "Linux Audio Wiki". [http://wiki.linuxaudio.org/wiki/raspberrypi](http://wiki.linuxaudio.org/wiki/raspberrypi)   BeagleBone and Raspberry Pi accessories:    Adafruit Industries. [http://www.adafruit.com](http://www.adafruit.com)    BeagleBone DVI-Audio Cape:    Beagle Board Toys. [http://beagleboardtoys.info/index.php?title=BeagleBone_DVI-D_with_Audio](http://beagleboardtoys.info/index.php?title=BeagleBone_DVI-D_with_Audio)
