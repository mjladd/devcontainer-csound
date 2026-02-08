---
source: Csound Journal
issue: 9
title: "Flutes in Orbit"
author: ""
url: https://csoundjournal.com/issue9/FlutesInOrbit.html
---

# Flutes in Orbit

**Author:** Unknown
**Issue:** 9
**Source:** [Csound Journal](https://csoundjournal.com/issue9/FlutesInOrbit.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 9](https://csoundjournal.com/index.html)
## Flutes in Orbit
 Brian Redfern

 brianwredfern AT gmail.com
## Introduction


The `planet` opcode is a fun effect: it provides a filter that models a planet orbiting around a binary star. What does that sound like? Well the orbit can get really unstable and the sound can go into escape velocity, all sorts of strange things can happen! This opcode is a member of the same family as `moogvcf` and `pareq`. It is a filter model that does some of the calculation within the opcode and some of the work within the Csound code to make it actually generate sound.
## I. Basic Description


Here is the basic call you make to invoke the opcode:
```csound
ax, ay, az planet kmass1, kmass2, ksep, ix, iy, iz, ivx, ivy, ivz,
	  idelta [, ifriction] [, iskip]
```


These are the notes on the variables for this opcode, taken from the Csound documentation:
#### Initialization


 *ix, iy, iz* -- the initial x, y and z coordinates of the planet

 *ivx, ivy, ivz* -- the initial velocity vector components for the planet.

 *idelta* -- the step size used to approximate the differential equation.

 *ifriction* (optional, default=0) -- a value for friction, which can used to keep the system from blowing up

 *iskip* (optional, default=0) -- if non zero skip the initialization of the filter. (New in Csound version 4.23f13 and 5.0)
##  Performance


 *ax, ay, az* -- the output x, y, and z coordinates of the planet

 *kmass1* -- the mass of the first star

 *kmass2* -- the mass of the second star
## II. Use of Planet Opcode


The description above from the *Csound Manual* is not everything we need. To make this opcode work we have to go through four phases:
-  **Setup an initial tone.** This can be any sound generator I want to use. The example in the *Csound Manual* uses a simple oscillator, but since I am using this for music rather than for a sound effect, I will use the waveguide flute (`wgflute`)to produce my basic tone.
-  **Figure out x, y, z coordinates.** This section processes the x, y, z coordinates of the 3D location of our sound through the `planet` opcode, which does some neat calculus on them.
-  **Place the tone within 3D space.** We can use the numbers output by Planet, using x y z, and pass those into the `spat3d` opcode, a 3D sound spatializer to actually make the numbers sonically useful. This renders the abstract output of `planet` into a 3D sound rendering.
-  **Convert to stereo.** Then we need to take the output from the 3D sound spatializer and convert it to a stereo signal so that your can hear it with normal headphones.
-  **Output the sound.** I use the clip filter here to keep the tone from distorting, mostly because the flute will tend to clip without this. It is useful to put a limiter on any output when you use more than one note at a time, as their amplitudes are additive.

In this example I use the `wgflute` opcode to create a basic tone. I am using this for a musical effect, so the rotation is almost like bowing, or like hearing a person playing a really big and loud flute while swinging on a swing set! If you set the *ifriction* level really high you can even use `planet` for a kind of tremolo autopan effect. In my example I have three notes. They start off with a one second delay between them so you get a nice beating between the tones. You can also use Planet for sound effects. If you tweak the settings you can turn the flute into the sound of a laser blaster or space debris.
```csound

<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
; Audio out   Audio in    No messages
-odac          
-iadc     -d     ;;;RT audio I/O
; For Non-realtime ouput leave only the line below:
; -o planet.wav -W ;;; for file output any platform
</CsOptions>
<CsInstruments>

; Initialize the global variables.
sr = 44100
kr = 44100
ksmps = 1
nchnls = 2

; Instrument #1 - a planet oribiting in 3D space.
instr 1
; Create our basic tone, using the waveguide flute opcode
; to generate an interesting tone, adding 200 to our random
; pitch to make sure you can hear it.
kamp = 20000
kfreq = rnd(700)+100
kjet = 0.32
iatt = 0.1
idetk = 0.1
kngain = 0.15
kvibf = 5.925
kvamp = 0.05
ifn = 1

asnd wgflute kamp, kfreq, kjet, iatt, idetk, kngain, kvibf, kvamp, ifn

;Figure out its X, Y, Z coordinates.
km1 init 0.55
km2 init 0.535
ksep init 0.72
ix = 0
iy = 0.1
iz = 0
ivx = 0.5
ivy = 0
ivz = 0
ih = 0.0001
ifric = -0.01
ax1, ay1, az1 planet km1, km2, ksep, ix, iy, iz, ivx, ivy, ivz, ih, ifric

; Place the basic tone within 3D space.
kx downsamp ax1
ky downsamp ay1
kz downsamp az1
idist = 1
ift = 0
imode = 1
imdel = 1.018853416
iovr = 2
aw2, ax2, ay2, az2 spat3d asnd, kx, ky, kz, idist, ift, imode, imdel, iovr

;Convert the 3D sound to stereo.
aleft = aw2 + ay2
aright = aw2 - ay2

;Clip the output to prevent distortion
a1 clip aleft, 2, 40000
a2 clip aright, 2, 40000
outs a1,a2
endin
</CsInstruments>
<CsScore>
; Table #1 a sine wave.
f 1 0 16384 10 1
; Play Instrument #1 for 10 seconds.
i 1 0 100
i 1 1 100
i 1 2 100
e
</CsScore>
</CsoundSynthesizer>

```


So that is a pretty large chunk of code! However `planet` is a fairly complex opcode. It is not a normal generator or filter. You do not have to use it for its original intended purpose. It is useful for lots of game effects, especially Space Invaders or other types of space games. You can simulate the movement of objects around the field. You could also use it as an auto-panner, or even for creating sounds that can manipulate brain waves with very tight and rapid orbits.
## III. Conclusion


One last word on the *ifric* parameter: besides simply keeping the opcode from "blowing up" it can also be used to change the "tightness" of the effect. This lets you tweak the sound to go from a real orbit sound to something like a tremolo autopanner.

 There are some VST plugins out there that attempt to do the same thing as Planet, but I have not found anything quite this powerful that you could buy. This opcode has been around since 1998, so it just goes to show how Csound continues to be ahead of everyone else, even when the opcode is ten years old!
## Acknowledgements


Barry Vercoe. *The Canonical Csound Reference Manual*.
 [http://sourceforge.net/projects/csound](http://sourceforge.net/projects/csound)
## Downloads

- [OrbitFlute.mp3](https://csoundjournal.com/OrbitFlute.mp3)
- [OrbitFlute.csd](https://csoundjournal.com/OrbitFlute.csd)
