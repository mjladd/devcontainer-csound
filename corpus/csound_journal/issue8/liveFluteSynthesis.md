---
source: Csound Journal
issue: 8
title: "Live Flute Synthesis with Linux and Csound5"
author: "extending the sustain"
url: https://csoundjournal.com/issue8/liveFluteSynthesis.html
---

# Live Flute Synthesis with Linux and Csound5

**Author:** extending the sustain
**Issue:** 8
**Source:** [Csound Journal](https://csoundjournal.com/issue8/liveFluteSynthesis.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 8](https://csoundjournal.com/index.html)
## Live Flute Synthesis with Linux and Csound5


![Csound Flute](images/csoundFlute.jpg) Brian Redfern
 brianwredfern AT gmail.com

Let's examine a Csound file that will allow me to control its pitch with my USB MIDI keyboard. Normally now with Csound you use a score file to set the pitches and parameter controls, but nowadays even entry level PCs are powerful enough to run at least one Csound instrument in real-time.

In this example I use the waveguide flute model to create a haunting synthetic flute. I'm using a combination of three real-time controllers and some randomness to give it a fresh and lively sound. Now the first part to note is the set of flags I'm using to setup my real-time control.

First I set audio output to `-+rtaudio=jack` instead of the default of ALSA. On Linux this tells Csound to use the Jack audio server to handle real time audio. This allows me to record my output from Csound directly into Ardour2, or I could use JackRack to process the audio output with [LADSPA](http://www.ladspa.org/) plugins. Using `-o dac` tells Csound to route the audio to the real time output rather than write it to a sound file. The `-+rtMIDI=alsa` flag tells csound to use alsa for realtime MIDI, since jack is only used for audio. The next flag `-M hw:1` tells Csound to use my second MIDI device (my USB keyboard controller) as the MIDI input device. If I wanted to use my first ALSA MIDI device, I would use -M hw:0 instead.

The first part of the instrument captures the action of my pitch bend. If you have knobs on your keyboard, you could also capture them here using a generic MIDI controller. But for now I'm just capturing the key note, the velocity and pitch bend. The `ikoct` variable is set to a 4 octave range, and the `kfratio` connects to `midic7` to capture the pitch bend. Then I use `cpsmidi` to convert the MIDI note to a standard pitch. To use the pitch bend I then multiply `i1` by the `kfratio`. I use an envelope to shape the attack and sustain; you can get crazy effects by extending the sustain, set here to 3 seconds. You can also randomize the sustain for some weird looping effects.

I simply run the instrument for 9999 seconds to run it effectively in real time.
```csound

<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
-+rtaudio=jack -i adc -o dac -+rtmidi=alsa -M hw:1
</CsOptionsv
<CsInstruments>

; Initialize the global variables.
sr = 44100
ksmps = 128
nchnls = 2


; Instrument #1.
instr 1
  ikoct     =     8     ;4 octave range
  kfratio     midic7     1, 1, ikoct ;mod.wheel controls transposition
  ifn = 1
  i1 cpsmidi
  ivel veloc
  kamp = ivel*500
  kfreq = i1*kfratio
  kjet = rnd(0.5)
  iatt = 0.1
  idetk = 0.1
  kngain = rnd(0.05)
  kvibf = kfratio
  kvamp = 0.05

  kenv linsegr 0,0.001,ivel/128, 3, 0
  a1 wgflute kamp, kfreq, kjet, iatt, idetk, kngain, kvibf, kvamp, ifn

  outs a1*kenv,a1*kenv
endin
</CsInstruments>
<CsScore>
; Table #1, a sine wave.
f 1 0 16384 10 1
i 1 9999
e
</CsScore>
</CsoundSynthesizer>

```


 Now let's see how we can microtune our instrument to go beyond the standard Western pitches.

We use `ftgen` to generate a table of pitch values which sets up our micro-tuned scale. In this case instead of the normal 12 tones of the Western scale, we have a 14 tone scale developed by the microtonal composer Kraig Grady. Instead of `cpsmid`, which converts the MIDI input into a standard Western tuning, we use `cpstmid`, which allows us to convert the MIDI input pitches into the microtuned scale set by `gitemp`. I'm using the same MIDI controls as before, but this time I have my own custom scale so that I'm not limited to the Western tuning. `` You can take the notes you play from a standard keyboard and convert the pitches into the microtonal scale you specify using `gitemp`, thus you can stretch tunings all the way across a standard MIDI keyboard and Csound will handle the pitch conversion for you.
```csound

<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
; Audio out   Audio in    No messages
; -odac           -iadc     -d     ;;;RT audio I/O
; For Non-realtime ouput leave only the line below:
; -o wgflute.wav -W ;;; for file output any platform
-+rtaudio=jack -i adc -o dac -+rtmidi=alsa -M hw:1
</CsOptions>
<CsInstruments>

; Initialize the global variables.
sr = 44100
ksmps = 128
nchnls = 2

; Table #1 Kraig Grady's 14 tone mictotuned scale
; numgrades = 14 (fourteen tones)
; interval = 2 (one octave)
; basefreq = 261.659 (Middle C)
; basekeymidi = 60 (Middle C)
  gitemp ftgen 2, 0, 64, -2, 14, 2, 261.659, 60, 1.05, 1.125, \
             1.166666666666666667, 1.25, 1.3125, 1.333333333333333333, 1.4, \
             1.5, 1.575, 1.6875, 1.75, 1.875, 1.96875, 2

; Instrument #1.
instr 1
  ikoct     =     8     ;4 octave range
  kfratio     midic7     1, 1, ikoct ;mod.wheel controls transposition
  i1 cpstmid ifn
  ivel veloc
  kamp = ivel*200
  kfreq = i1*kfratio
  kjet = rnd(0.5)
  iatt = 0.1
  idetk = 0.1
  kngain = 0.15
  kvibf = kfratio
  kvamp = 0.05

  kenv linsegr 0,0.001,ivel/128, 3, 0
  a1 wgflute kamp, kfreq, kjet, iatt, idetk, kngain, kvibf, kvamp, ifn

  outs a1*kenv,a1*kenv
endin
</CsInstruments>
<CsScore>
; Table #1, a sine wave.
f 1 0 16384 10 1
i 1 9999
e
</CsScore>
</CsoundSynthesizer>

```

## Downloads



- [flute_standard.csd](https://csoundjournal.com/liveFluteSynthesis/flute_standard.csd)
- [flute_micro.csd](https://csoundjournal.com/liveFluteSynthesis/flute_micro.csd)
- [flute_standard.mp3](https://csoundjournal.com/liveFluteSynthesis/flute_standard.mp3)
- [flute_micro.mp3](https://csoundjournal.com/liveFluteSynthesis/flute_micro.mp3)
