# MIDI Integration: Real-Time Control and Performance

## Metadata

- **Title:** MIDI Integration: Real-Time Control and Performance
- **Category:** MIDI / Real-Time Control / Live Performance / Input Handling
- **Difficulty:** Beginner/Intermediate
- **Tags:** `midi`, `cpsmidi`, `ampmidi`, `midictrl`, `velocity`, `pitch-bend`, `controllers`, `real-time`, `live-performance`, `keyboard`, `massign`, `note-on`, `note-off`
- **Source Files:** `midi.csd`, `midiguide.csd`, `midify1.csd`, `testmid.csd`

---

## Description

MIDI (Musical Instrument Digital Interface) integration allows Csound instruments to respond in real-time to external controllers like keyboards, wind controllers, drum pads, and DAW automation. This transforms Csound from a score-based renderer into a live performance instrument. MIDI provides note information (pitch, velocity, duration) and continuous control data (mod wheel, expression, pitch bend) that can modulate any synthesis parameter.

**Use Cases:**
- Playing Csound instruments from a MIDI keyboard
- Real-time parameter control via knobs, sliders, and wheels
- Live performance and improvisation
- Integration with DAWs and sequencers
- Building custom software synthesizers
- Interactive installations and sound design
- MIDI-controlled effects processing

**Key Concepts:**
- **MIDI Notes:** Trigger instrument instances, provide pitch and velocity
- **MIDI Controllers (CC):** Continuous control messages (0-127) for modulation
- **Pitch Bend:** Fine pitch control, typically ±2 semitones
- **Channel Messages:** MIDI data targeted to specific channels (1-16)
- **massign:** Routes MIDI channels to specific Csound instruments

---

## Complete Code

### Example 1: Basic MIDI Synthesizer

```csound
<CsoundSynthesizer>
<CsOptions>
; -odac = real-time audio output
; -M = MIDI input device (use -Ma for all devices, or specific device number)
; -m0 = suppress some messages for cleaner output
-odac -Ma -m0
</CsOptions>
<CsInstruments>
sr        = 44100
ksmps     = 32
nchnls    = 2
0dbfs     = 1

; Assign MIDI channel 1 to instrument 1
          massign   1, 1

; =====================================================
; INSTRUMENT 1: Basic MIDI-controlled synthesizer
; Triggered by MIDI note-on, released by note-off
; =====================================================
          instr     1

; ----- PITCH FROM MIDI -----
; cpsmidi: Get frequency in Hz from MIDI note number
; Automatically handles note number to frequency conversion
ifreq     cpsmidi

; Alternative: cpsmidib includes pitch bend
; ifreq   cpsmidib  2              ; 2 = pitch bend range in semitones

; ----- VELOCITY FROM MIDI -----
; ampmidi: Get amplitude scaled from MIDI velocity (0-127)
; Parameters: maximum amplitude to scale to
iamp      ampmidi   0.7            ; Scale velocity to 0-0.7

; Alternative: Get raw velocity value
; ivel    veloc     0, 127         ; Raw velocity 0-127

; ----- AMPLITUDE ENVELOPE -----
; linenr: Envelope with release triggered by note-off
; Note: MIDI note-off sets p3 to negative, triggering release
kenv      linenr    iamp, 0.01, 0.3, 0.01
;                   amp   attack release shape

; ----- OSCILLATOR -----
aosc      vco2      kenv, ifreq, 0         ; Sawtooth

; ----- FILTER -----
; Simple lowpass, cutoff based on velocity (brighter when harder)
kcutoff   = 500 + iamp * 4000
afilt     moogladder aosc, kcutoff, 0.3

; ----- OUTPUT -----
          outs      afilt, afilt
          endin

</CsInstruments>
<CsScore>
; f0 keeps Csound running, waiting for MIDI input
; The number is how many seconds to run (use large value or 0 for indefinite)
f0 3600    ; Run for 1 hour (3600 seconds)

; Alternative: f0 0 runs indefinitely until stopped
; f0 0

</CsScore>
</CsoundSynthesizer>
```

### Example 2: MIDI Controllers for Real-Time Modulation

```csound
<CsoundSynthesizer>
<CsOptions>
-odac -Ma -m0
</CsOptions>
<CsInstruments>
sr        = 44100
ksmps     = 32
nchnls    = 2
0dbfs     = 1

          massign   1, 1

; =====================================================
; INSTRUMENT 1: Synth with CC control
; CC1  (Mod Wheel)    = Vibrato depth
; CC7  (Volume)       = Master volume
; CC74 (Filter Cutoff)= Filter cutoff
; CC71 (Resonance)    = Filter resonance
; CC73 (Attack)       = Envelope attack time
; CC72 (Release)      = Envelope release time
; =====================================================
          instr     1

; ----- MIDI NOTE DATA -----
ifreq     cpsmidib  2              ; Pitch with ±2 semitone bend range
iamp      ampmidi   0.8

; ----- MIDI CONTROLLERS -----
; midictrl ichan, ictlno, imin, imax
; ctrl7    ichan, ictlno, imin, imax  (k-rate version)

; Mod wheel (CC1) - Vibrato depth (0-20 Hz deviation)
kvibdepth ctrl7     1, 1, 0, 20

; Volume (CC7) - Master volume (0-1)
kvolume   ctrl7     1, 7, 0, 1
; Initialize to max if controller not moved yet
kvolume   = (kvolume == 0) ? 1 : kvolume

; Filter cutoff (CC74) - 200-8000 Hz
kcutoff   ctrl7     1, 74, 200, 8000
kcutoff   = (kcutoff == 200) ? 2000 : kcutoff  ; Default

; Resonance (CC71) - 0-0.9
kres      ctrl7     1, 71, 0, 0.9

; Attack (CC73) - 0.01-2 seconds
iattack   midictrl  1, 73, 0.01, 2
iattack   = (iattack == 0.01) ? 0.1 : iattack

; Release (CC72) - 0.05-3 seconds
irelease  midictrl  1, 72, 0.05, 3
irelease  = (irelease == 0.05) ? 0.3 : irelease

; ----- VIBRATO -----
kvib      oscil     kvibdepth, 5, 1      ; 5 Hz vibrato rate
kpitch    = ifreq + kvib

; ----- ENVELOPE -----
kenv      linenr    iamp, iattack, irelease, 0.01

; ----- OSCILLATOR -----
aosc      vco2      1, kpitch, 0

; ----- FILTER -----
afilt     moogladder aosc, kcutoff, kres

; ----- OUTPUT WITH VOLUME -----
aout      = afilt * kenv * kvolume
          outs      aout, aout
          endin

</CsInstruments>
<CsScore>
; Sine wave for vibrato LFO
f1 0 8192 10 1

f0 3600
</CsScore>
</CsoundSynthesizer>
```

### Example 3: Pitch Bend and Aftertouch

```csound
<CsoundSynthesizer>
<CsOptions>
-odac -Ma -m0
</CsOptions>
<CsInstruments>
sr        = 44100
ksmps     = 32
nchnls    = 2
0dbfs     = 1

          massign   1, 1

; =====================================================
; INSTRUMENT 1: Expressive synth with pitch bend & aftertouch
; Pitch bend = pitch control (±12 semitones for lead playing)
; Aftertouch = filter modulation and vibrato
; =====================================================
          instr     1

; ----- BASE PITCH -----
inote     notnum                    ; Raw MIDI note number (0-127)
ibasefreq cpsmidi                   ; Base frequency without bend

; ----- PITCH BEND -----
; pchbend: Returns pitch bend in semitones (or other units)
; Parameters: imin, imax (range to scale to)
kbend     pchbend   -12, 12         ; ±12 semitones (1 octave)

; Calculate bent frequency
; Semitone ratio = 2^(1/12) ≈ 1.0595
kfreq     = ibasefreq * semitone(kbend)

; ----- VELOCITY -----
iamp      ampmidi   0.8
ivel      veloc     0, 127          ; Also get raw velocity

; ----- AFTERTOUCH -----
; aftouch: Channel aftertouch (most keyboards)
; polyaft: Polyphonic aftertouch (per-key, rare)
kafter    aftouch   0, 1            ; Scaled 0-1

; Use aftertouch for:
; 1. Filter modulation
; 2. Vibrato intensity
kfiltmod  = kafter * 3000           ; Up to +3000 Hz cutoff
kvibmod   = kafter * 15             ; Up to 15 Hz vibrato depth

; ----- VIBRATO (aftertouch controlled) -----
kvib      oscil     kvibmod, 5.5, 1
kfreq     = kfreq + kvib

; ----- ENVELOPE -----
; Velocity affects attack character
iattack   = 0.01 + (1 - ivel/127) * 0.1   ; Soft = slower attack
kenv      linenr    iamp, iattack, 0.4, 0.01

; ----- OSCILLATORS (detuned pair) -----
aosc1     vco2      0.5, kfreq, 0
aosc2     vco2      0.5, kfreq * 1.003, 0  ; Slight detune
amix      = aosc1 + aosc2

; ----- FILTER (velocity + aftertouch) -----
ibasecutoff = 300 + ivel * 30       ; Velocity opens filter
kcutoff   = ibasecutoff + kfiltmod  ; Aftertouch adds more
kcutoff   limit kcutoff, 200, 10000

afilt     moogladder amix, kcutoff, 0.4

; ----- OUTPUT -----
aout      = afilt * kenv
          outs      aout, aout
          endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1
f0 3600
</CsScore>
</CsoundSynthesizer>
```

### Example 4: Multi-Timbral Setup (Multiple MIDI Channels)

```csound
<CsoundSynthesizer>
<CsOptions>
-odac -Ma -m0
</CsOptions>
<CsInstruments>
sr        = 44100
ksmps     = 32
nchnls    = 2
0dbfs     = 1

; =====================================================
; MULTI-TIMBRAL SETUP
; Channel 1 = Pad (instrument 1)
; Channel 2 = Bass (instrument 2)
; Channel 3 = Lead (instrument 3)
; Channel 10 = Drums (instrument 10)
; =====================================================

          massign   1, 1           ; Channel 1 → Pad
          massign   2, 2           ; Channel 2 → Bass
          massign   3, 3           ; Channel 3 → Lead
          massign   10, 10         ; Channel 10 → Drums

; ----- INSTRUMENT 1: PAD -----
          instr     1
ifreq     cpsmidib  2
iamp      ampmidi   0.4

kenv      linenr    iamp, 0.5, 1.0, 0.01

aosc1     vco2      0.3, ifreq, 0
aosc2     vco2      0.3, ifreq * 2.001, 2    ; Square, octave up
aosc3     vco2      0.2, ifreq * 0.5, 0      ; Saw, octave down

amix      = aosc1 + aosc2 + aosc3
afilt     butterlp  amix, 2000
aout      = afilt * kenv

          outs      aout, aout
          endin

; ----- INSTRUMENT 2: BASS -----
          instr     2
ifreq     cpsmidib  2
iamp      ampmidi   0.6

; Punchy bass envelope
kenv      expsegr   0.01, 0.01, 1, 0.1, 0.6, 0.3, 0.01

aosc      vco2      1, ifreq, 0
afilt     moogladder aosc, 400 + kenv * 1500, 0.3
aout      = afilt * kenv * iamp

          outs      aout, aout
          endin

; ----- INSTRUMENT 3: LEAD -----
          instr     3
ifreq     cpsmidib  12             ; Wide pitch bend for lead
iamp      ampmidi   0.5

; Mod wheel vibrato
kvibdep   ctrl7     3, 1, 0, 30
kvib      oscil     kvibdep, 5.5, 1
kfreq     = ifreq + kvib

kenv      linenr    iamp, 0.01, 0.2, 0.01

; Bright sawtooth lead
aosc      vco2      1, kfreq, 0
afilt     moogladder aosc, 3000, 0.5
aout      = afilt * kenv

          outs      aout, aout
          endin

; ----- INSTRUMENT 10: DRUMS -----
          instr     10
inote     notnum                    ; Get MIDI note number

; Simple drum mapping
if inote == 36 then               ; C1 = Kick
  aout    drum_kick
elseif inote == 38 then           ; D1 = Snare
  aout    drum_snare
elseif inote == 42 then           ; F#1 = Hi-hat
  aout    drum_hihat
else
  aout    = 0
endif

          outs      aout, aout
          endin

; ----- DRUM SOUND UDOs -----
          opcode    drum_kick, a, 0
kamp      expon     1, 0.3, 0.001
kfreq     expon     150, 0.1, 40
aosc      oscil     kamp * 0.8, kfreq, 1
          xout      aosc
          endop

          opcode    drum_snare, a, 0
kamp      expon     1, 0.15, 0.001
anoise    rand      kamp * 0.5
afilt     butterbp  anoise, 2000, 1000
aosc      oscil     kamp * 0.3, 180, 1
          xout      afilt + aosc
          endop

          opcode    drum_hihat, a, 0
kamp      expon     1, 0.08, 0.001
anoise    rand      kamp * 0.4
afilt     butterhp  anoise, 7000
          xout      afilt
          endop

</CsInstruments>
<CsScore>
f1 0 8192 10 1
f0 3600
</CsScore>
</CsoundSynthesizer>
```

### Example 5: MIDI File Playback with Custom Instruments

```csound
<CsoundSynthesizer>
<CsOptions>
; -F = read MIDI file instead of real-time MIDI
; The MIDI file replaces the score for triggering instruments
-odac -F midifile.mid -m0
</CsOptions>
<CsInstruments>
sr        = 44100
ksmps     = 32
nchnls    = 2
0dbfs     = 1

; Map all 16 MIDI channels to instrument 1
; Or use specific mappings for multi-timbral playback
          massign   0, 1           ; All channels → instrument 1

          instr     1
ifreq     cpsmidi
iamp      ampmidi   0.5
ichan     midichn                  ; Which MIDI channel triggered this

; Different sound per channel (optional)
if ichan == 1 then
  kenv    linenr    iamp, 0.01, 0.3, 0.01
  aosc    vco2      kenv, ifreq, 0
elseif ichan == 2 then
  kenv    linenr    iamp, 0.2, 0.5, 0.01
  aosc    vco2      kenv, ifreq, 2
else
  kenv    linenr    iamp, 0.05, 0.2, 0.01
  aosc    oscil     kenv, ifreq, 1
endif

afilt     butterlp  aosc, 3000
          outs      afilt, afilt
          endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1

; When using -F flag, the MIDI file provides timing
; f0 keeps Csound running until MIDI file ends
f0 300     ; Run up to 5 minutes (will stop when MIDI file ends)
</CsScore>
</CsoundSynthesizer>
```

---

## Detailed Explanation

### MIDI Opcodes Overview

#### Pitch Opcodes

```csound
; cpsmidi - Frequency from MIDI note number
ifreq cpsmidi

; cpsmidib - Frequency with pitch bend applied
; Parameter: pitch bend range in semitones
ifreq cpsmidib 2           ; ±2 semitone bend range
kfreq cpsmidib 12          ; k-rate version, ±12 semitones

; notnum - Raw MIDI note number (0-127)
inote notnum               ; 60 = middle C

; pchbend - Pitch bend value only
kbend pchbend -2, 2        ; Returns bend scaled to range
kbend pchbend 0, 16384     ; Raw 14-bit value
```

**Pitch Bend Range:**
Standard MIDI pitch bend is 14-bit (0-16383, center at 8192). Most keyboards default to ±2 semitones, but the range is often configurable.

#### Velocity and Amplitude Opcodes

```csound
; ampmidi - Velocity scaled to amplitude
iamp ampmidi 0.8           ; Scale velocity (0-127) to 0-0.8
iamp ampmidi 32000         ; Scale to 16-bit range

; veloc - Raw velocity value with custom scaling
ivel veloc 0, 127          ; Raw velocity
ivel veloc 0, 1            ; Normalized 0-1
idb  veloc -40, 0          ; As dB (-40 to 0)
```

**Velocity Curves:**
MIDI velocity (0-127) is typically linear, but perception is logarithmic. For more natural response:

```csound
ivel   veloc   0, 127
iamp   = (ivel / 127) ^ 2  ; Quadratic curve (more natural)
; Or use dB scaling:
idb    veloc   -40, 0
iamp   = ampdb(idb)
```

#### Controller Opcodes

```csound
; midictrl - Get CC value at init time (i-rate)
; Parameters: channel, controller#, min, max
ival  midictrl 1, 74, 0, 10000    ; CC74 scaled 0-10000

; ctrl7 - Get CC value continuously (k-rate)
; Parameters: channel, controller#, min, max
kval  ctrl7   1, 1, 0, 100        ; Mod wheel (CC1) scaled 0-100

; ctrl14 - 14-bit controller (two CCs combined)
; Used for high-resolution control
kval  ctrl14  1, 0, 32, 0, 16383  ; CC0 + CC32 = 14-bit value

; ctrl21 - 21-bit controller (three CCs)
; Rarely used, extreme precision
kval  ctrl21  1, 0, 32, 64, 0, 2097151
```

**Common MIDI CC Numbers:**

| CC# | Standard Name | Typical Use |
|-----|---------------|-------------|
| 1 | Modulation Wheel | Vibrato depth |
| 2 | Breath Controller | Expression |
| 7 | Volume | Channel volume |
| 10 | Pan | Left/right position |
| 11 | Expression | Dynamic volume |
| 64 | Sustain Pedal | Note sustain (on/off) |
| 71 | Resonance | Filter resonance |
| 74 | Cutoff | Filter cutoff |
| 91 | Reverb Send | Effects send |
| 93 | Chorus Send | Effects send |

#### Aftertouch Opcodes

```csound
; aftouch - Channel aftertouch (pressure after key press)
; Most keyboards send this
kpress aftouch 0, 1        ; Scaled 0-1
kpress aftouch 0, 127      ; Raw value

; polyaft - Polyphonic aftertouch (per-key pressure)
; Only high-end keyboards support this
kpress polyaft inote, 0, 1 ; Pressure for specific note
```

#### Channel and Assignment Opcodes

```csound
; massign - Assign MIDI channel to instrument
massign 1, 10              ; Channel 1 → instrument 10
massign 0, 1               ; ALL channels → instrument 1
massign 1, 0               ; Channel 1 → NO instrument (ignore)

; midichn - Get MIDI channel that triggered this instance
ichan midichn              ; 1-16

; pgmassign - Assign program changes to instruments
pgmassign 0, 5             ; Program 0 → instrument 5
pgmassign 0, -5            ; Program 0 → instrument 5, don't allow note-ons
```

### The MIDI Note Lifecycle

**Note-On:**
1. MIDI note-on received (note number + velocity)
2. Csound creates new instance of assigned instrument
3. `cpsmidi` captures pitch, `ampmidi` captures velocity
4. `p3` is set to a large value (note duration unknown)

**During Note:**
- `ctrl7`, `pchbend`, `aftouch` update continuously
- Instrument keeps running

**Note-Off:**
1. MIDI note-off received
2. `p3` becomes negative (signals release)
3. `linenr`/`linsegr`/`expsegr` begin release phase
4. Instrument terminates after release completes

```csound
; Standard release envelope pattern
kenv linenr iamp, 0.01, 0.3, 0.01
;           amp   attack release shape
; When note-off arrives, p3 goes negative, release begins
```

### Score Requirements for MIDI

**The f0 Statement:**
```csound
<CsScore>
f0 3600    ; Keep running for 3600 seconds (1 hour)
f0 0       ; Run indefinitely
</CsScore>
```

Without `f0`, Csound has no events to process and exits immediately. The `f0` statement creates a "dummy" event that keeps the performance running.

**Alternative: i-statement dummy:**
```csound
<CsScore>
i99 0 3600  ; Dummy instrument running for 1 hour
</CsScore>

; In orchestra:
instr 99
  ; Empty instrument, just keeps Csound alive
endin
```

### Command-Line Options for MIDI

```bash
# Real-time MIDI input
csound -odac -Ma myscore.csd      # All MIDI devices
csound -odac -M0 myscore.csd      # First MIDI device
csound -odac -M2 myscore.csd      # Third MIDI device

# List available MIDI devices
csound --midi-devices

# MIDI file playback (not real-time)
csound -odac -F myfile.mid myscore.csd

# Combined real-time audio and MIDI
csound -odac -Ma -iadc myscore.csd  # With audio input too
```

**CsOptions equivalent:**
```csound
<CsOptions>
-odac -Ma -m0
</CsOptions>
```

---

## Key Concepts

### MIDI vs Score-Based Triggering

| Aspect | MIDI | Score (i-statements) |
|--------|------|---------------------|
| Note timing | Real-time, unpredictable | Pre-determined |
| Note duration | Unknown until note-off | Known (p3) |
| Pitch source | `cpsmidi` | `p4` or `p5` |
| Velocity source | `ampmidi` | p-field |
| Continuous control | CC, aftertouch | Line envelopes |
| Use case | Live performance | Composition, rendering |

### Monophonic vs Polyphonic

**Polyphonic (default):**
Each MIDI note creates a new instrument instance. Many notes can sound simultaneously.

**Monophonic (single voice):**
Use `maxalloc` to limit instances:
```csound
maxalloc 1, 1    ; Only one instance of instrument 1 at a time
```

**Legato (connected notes):**
```csound
; Use release envelope that only triggers on actual note-off
; Not on overlapping notes
instr 1
ifreq cpsmidi
iamp  ampmidi 0.5

; Check if this is a legato note (previous note still releasing)
itie  tival             ; Returns 1 if tied note
if itie == 0 then
  kenv linenr iamp, 0.01, 0.3, 0.01
else
  kenv = iamp           ; No attack for legato
endif

; ... rest of instrument
endin
```

### Smoothing Controller Data

MIDI controllers update discretely (128 steps). Smooth them for audio parameters:

```csound
; Raw CC (steppy)
kraw ctrl7 1, 74, 200, 8000

; Smoothed CC (use for filter cutoff, etc.)
ksmooth port kraw, 0.02   ; 20ms smoothing time

; Even smoother for slow parameters
ksmooth port kraw, 0.1    ; 100ms smoothing
```

### Handling Missing Controller Data

CCs start at 0 before first message. Handle defaults:

```csound
kval ctrl7 1, 74, 200, 8000

; Method 1: Check for default and substitute
kval = (kval == 200) ? 2000 : kval

; Method 2: Use initc7 to set initial value
initc7 1, 74, 0.5        ; Set CC74 to middle value at init

; Method 3: Use changed opcode to detect first real message
kchanged changed kval
if kchanged == 0 && kval == 200 then
  kval = 2000            ; Use default until first CC received
endif
```

---

## Common MIDI Controller Mappings

### Standard Synthesizer Layout

```csound
; MODULATION SECTION
kvibrato    ctrl7   1, 1, 0, 50       ; CC1 - Vibrato depth
kvibrate    ctrl7   1, 76, 3, 10      ; CC76 - Vibrato rate

; FILTER SECTION
kcutoff     ctrl7   1, 74, 100, 10000 ; CC74 - Filter cutoff
kresonance  ctrl7   1, 71, 0, 0.95    ; CC71 - Resonance
kfiltenv    ctrl7   1, 79, 0, 1       ; CC79 - Filter env amount

; AMPLITUDE SECTION
kattack     ctrl7   1, 73, 0.01, 2    ; CC73 - Amp attack
krelease    ctrl7   1, 72, 0.05, 5    ; CC72 - Amp release

; EFFECTS
kreverb     ctrl7   1, 91, 0, 1       ; CC91 - Reverb send
kchorus     ctrl7   1, 93, 0, 1       ; CC93 - Chorus send

; MASTER
kvolume     ctrl7   1, 7, 0, 1        ; CC7 - Volume
kpan        ctrl7   1, 10, -1, 1      ; CC10 - Pan
```

### Sustain Pedal Handling

```csound
; CC64 is sustain pedal (on/off)
ksustain ctrl7 1, 64, 0, 1

; Method 1: Extend release when pedal down
if ksustain > 0.5 then
  kreltime = 5.0      ; Long release
else
  kreltime = 0.3      ; Normal release
endif
kenv linenr iamp, 0.01, kreltime, 0.01

; Method 2: Use xtratim to extend note
xtratim ksustain * 5   ; Add up to 5 seconds when pedal down
```

---

## Variations

### MPE (MIDI Polyphonic Expression) Support

```csound
; MPE uses per-note channels for expressive control
; Channel 1 = global, Channels 2-16 = per-note

instr 1
ichan   midichn
ifreq   cpsmidi

; Per-note pitch bend (MPE)
kbend   pchbend -48, 48           ; ±48 semitones (typical MPE)
kfreq   = ifreq * semitone(kbend)

; Per-note pressure (MPE uses CC74 or aftertouch)
kpress  ctrl7   ichan, 74, 0, 1   ; Per-channel CC74

; Per-note slide (CC74 on note's channel)
kslide  ctrl7   ichan, 74, 0, 1

; Apply to sound
kbright = 500 + kpress * 5000
afilt   moogladder aosc, kbright, kpress * 0.5
endin
```

### MIDI Learn Implementation

```csound
; Simple MIDI learn: Print incoming CC values
instr midi_monitor
kcc1  ctrl7 1, 1, 0, 127
kcc2  ctrl7 1, 2, 0, 127
; ... etc for all CCs you want to monitor

kch1  changed kcc1
kch2  changed kcc2

if kch1 == 1 then
  printks "CC1 = %d\\n", 0, kcc1
endif
if kch2 == 1 then
  printks "CC2 = %d\\n", 0, kcc2
endif
endin
```

### Velocity Switching (Multi-Samples)

```csound
instr 1
ivel  veloc 0, 127

; Choose sample/behavior based on velocity layer
if ivel < 40 then
  ; Soft layer
  aosc vco2 0.3, ifreq, 2         ; Soft triangle
  kcutoff = 800
elseif ivel < 90 then
  ; Medium layer
  aosc vco2 0.6, ifreq, 0         ; Medium saw
  kcutoff = 2000
else
  ; Hard layer
  aosc vco2 1, ifreq, 0           ; Loud saw
  kcutoff = 5000
endif

afilt moogladder aosc, kcutoff, 0.3
endin
```

### MIDI Clock Sync

```csound
; Sync to external MIDI clock
; 24 MIDI clocks per quarter note

opcode midi_clock_bpm, k, 0
  ; Count MIDI clock messages
  ktrig  ctrl7  1, 123, 0, 1    ; Use a CC or dedicated timing
  kticks init  0
  ktime  init  0

  if ktrig > 0.5 then
    kticks = kticks + 1
    if kticks >= 24 then
      kbpm = 60 / (timeinsts() - ktime)
      ktime = timeinsts()
      kticks = 0
    endif
  endif
  xout kbpm
endop
```

### Program Change Response

```csound
; Change instrument parameters based on program change
; Use pgmassign or handle in instrument

instr 1
ifreq cpsmidi
iamp  ampmidi 0.5

; Check current program (bank would need sysex handling)
iprog midichn  ; Actually use a global or channel message check

; Simplified: Use CC0 as "program select"
kprog ctrl7 1, 0, 0, 127

if kprog < 32 then
  ; Program 0-31: Sawtooth
  aosc vco2 1, ifreq, 0
elseif kprog < 64 then
  ; Program 32-63: Square
  aosc vco2 1, ifreq, 2
else
  ; Program 64+: Triangle
  aosc vco2 1, ifreq, 4
endif

aout = aosc * iamp
outs aout, aout
endin
```

---

## Common Issues & Solutions

### No Sound from MIDI

**Problem:** Csound runs but no sound when playing MIDI keyboard
**Causes & Solutions:**

```bash
# 1. Check MIDI device is recognized
csound --midi-devices

# 2. Ensure -M flag is set
csound -odac -Ma myfile.csd  # -Ma = all devices

# 3. Check massign in orchestra
massign 1, 1    ; Channel 1 to instrument 1
# Or:
massign 0, 1    ; ALL channels to instrument 1
```

### Notes Don't Stop (Hanging Notes)

**Problem:** Notes keep playing after release
**Cause:** No release envelope or wrong envelope type
**Solution:**
```csound
; WRONG: linen doesn't respond to note-off
kenv linen iamp, 0.1, p3, 0.3

; RIGHT: linenr responds to note-off
kenv linenr iamp, 0.1, 0.3, 0.01

; Also works: linsegr, expsegr
kenv linsegr 0, 0.1, 1, 0.3, 0
kenv expsegr 0.001, 0.1, 1, 0.3, 0.001
```

### Clicks at Note Start/End

**Problem:** Audible clicks when notes begin or end
**Cause:** Missing or too-short attack/release
**Solution:**
```csound
; Ensure minimum attack and release times
iattack = max(0.005, iattack)   ; At least 5ms
irelease = max(0.01, irelease)  ; At least 10ms

kenv linenr iamp, iattack, irelease, 0.01
```

### Pitch Bend Not Working

**Problem:** Pitch bend wheel has no effect
**Cause:** Using `cpsmidi` instead of `cpsmidib`
**Solution:**
```csound
; WRONG: cpsmidi ignores pitch bend
ifreq cpsmidi

; RIGHT: cpsmidib includes pitch bend
ifreq cpsmidib 2    ; ±2 semitones range
; Or for k-rate continuous update:
kfreq cpsmidib 2
```

### Controllers Start at Wrong Value

**Problem:** Filter starts fully closed (or other wrong initial state)
**Cause:** CC values start at 0 before first MIDI message
**Solution:**
```csound
; Initialize CC to sensible default
initc7 1, 74, 0.5    ; CC74 starts at middle

; Or handle in code
kcutoff ctrl7 1, 74, 200, 8000
kcutoff = (kcutoff == 200) ? 2000 : kcutoff  ; Default if unchanged
```

### Csound Exits Immediately

**Problem:** Csound quits right after starting
**Cause:** No events in score (need f0)
**Solution:**
```csound
<CsScore>
f0 3600    ; Keep running for 1 hour
; or
f0 0       ; Run indefinitely
</CsScore>
```

### Steppy/Zipper Noise from Controllers

**Problem:** Audible stepping when moving knobs/sliders
**Cause:** MIDI CC resolution is only 128 steps
**Solution:**
```csound
kraw  ctrl7 1, 74, 200, 8000
ksmooth port kraw, 0.02    ; Smooth with 20ms time constant
afilt moogladder aosc, ksmooth, 0.5
```

### Wrong MIDI Channel

**Problem:** Instrument responds to wrong channel or all channels
**Cause:** massign configuration
**Solution:**
```csound
; Be explicit about channel assignments
massign 1, 1     ; Channel 1 only → instrument 1
massign 2, 0     ; Channel 2 → nothing (ignore)
; etc.

; Check which channel triggered:
ichan midichn
prints "Triggered by channel %d\\n", ichan
```

---

## Performance Considerations

### Latency Optimization

```csound
; Lower ksmps = lower latency but more CPU
ksmps = 32     ; Good balance for MIDI (0.7ms at 44.1kHz)
ksmps = 16     ; Lower latency (0.36ms) for sensitive playing
ksmps = 64     ; Higher latency (1.5ms) but lower CPU

; Buffer settings (command line)
; -b = software buffer, -B = hardware buffer
csound -odac -Ma -b128 -B512 myfile.csd
```

### Polyphony Management

```csound
; Limit maximum voices to prevent CPU overload
maxalloc 1, 16    ; Max 16 simultaneous voices for instrument 1

; Or use voice stealing (newer versions)
; Not directly in Csound, but can implement:
instr 1
  ; Check voice count and potentially steal oldest
endin
```

### Efficient MIDI Processing

```csound
; Don't recalculate expensive operations every k-cycle
instr 1
  ; Calculate once at note start (i-rate)
  ibasefreq cpsmidi
  iamp ampmidi 0.5

  ; Only these need continuous update
  kbend pchbend -2, 2
  kfreq = ibasefreq * semitone(kbend)

  ; Use port for smoothing (efficient)
  ksmooth port kfreq, 0.01
endin
```

---

## Sound Design Applications

### Expressive Lead Synth

```csound
instr expressive_lead
  ifreq cpsmidib 12           ; Wide bend for expression
  iamp  ampmidi 0.6

  ; Mod wheel = vibrato
  kvibdep ctrl7 1, 1, 0, 40
  kvib oscil kvibdep, 5.5, 1

  ; Aftertouch = brightness + vibrato speed
  kafter aftouch 0, 1
  kbright = 1000 + kafter * 6000
  kvibspd = 5 + kafter * 3

  kenv linenr iamp, 0.01, 0.15, 0.01
  kfreq = ifreq + kvib

  aosc vco2 1, kfreq, 0
  afilt moogladder aosc, kbright, 0.4

  outs afilt * kenv, afilt * kenv
endin
```

### Velocity-Sensitive Piano

```csound
instr piano_like
  ifreq cpsmidi
  ivel  veloc 0, 127

  ; Velocity affects: amplitude, brightness, attack
  iamp = (ivel / 127) ^ 1.5 * 0.8  ; Non-linear
  ibright = 500 + ivel * 60
  iattack = 0.001 + (1 - ivel/127) * 0.02

  ; Sustain pedal
  ksustain ctrl7 1, 64, 0, 1
  krelease = 0.3 + ksustain * 4

  kenv linenr iamp, iattack, krelease, 0.01

  ; Piano-like spectrum (detuned oscillators)
  aosc1 oscil 1, ifreq, 1
  aosc2 oscil 0.5, ifreq * 2.001, 1
  aosc3 oscil 0.25, ifreq * 3.002, 1
  amix = aosc1 + aosc2 + aosc3

  afilt butterlp amix * kenv, ibright
  outs afilt, afilt
endin
```

### MIDI-Controlled Effect

```csound
; Effects processor controlled by MIDI CCs
instr midi_effect
  ; Audio input
  ain inch 1

  ; MIDI CC control
  kdrive ctrl7 1, 74, 1, 10        ; Distortion drive
  kmix   ctrl7 1, 71, 0, 1         ; Dry/wet mix
  kdelay ctrl7 1, 12, 0.01, 0.5    ; Delay time
  kfdbk  ctrl7 1, 13, 0, 0.9       ; Delay feedback

  ; Smooth the controls
  kdrive port kdrive, 0.02
  kmix   port kmix, 0.02
  kdelay port kdelay, 0.05

  ; Distortion
  adist tanh ain * kdrive

  ; Delay
  afdbk init 0
  adel  vdelay adist + afdbk * kfdbk, kdelay * 1000, 600
  afdbk = adel

  ; Mix
  aout = ain * (1 - kmix) + adel * kmix

  outs aout, aout
endin
```

---

## Related Opcodes

### Pitch Opcodes
| Opcode | Description |
|--------|-------------|
| `cpsmidi` | Frequency from MIDI note |
| `cpsmidib` | Frequency with pitch bend |
| `notnum` | Raw MIDI note number |
| `pchbend` | Pitch bend value |
| `octmidi` | Octave.pitch from MIDI note |
| `pchmidi` | Pitch-class from MIDI note |

### Velocity/Amplitude
| Opcode | Description |
|--------|-------------|
| `ampmidi` | Scaled velocity |
| `veloc` | Raw or scaled velocity |
| `aftouch` | Channel aftertouch |
| `polyaft` | Polyphonic aftertouch |

### Controllers
| Opcode | Description |
|--------|-------------|
| `midictrl` | CC value (i-rate) |
| `ctrl7` | CC value (k-rate, 7-bit) |
| `ctrl14` | CC value (14-bit) |
| `ctrl21` | CC value (21-bit) |
| `initc7` | Initialize CC value |

### Channel/Assignment
| Opcode | Description |
|--------|-------------|
| `massign` | Map MIDI channel to instrument |
| `pgmassign` | Map program change to instrument |
| `midichn` | Get MIDI channel |
| `midiin` | Raw MIDI input |

### Envelope (Release-Aware)
| Opcode | Description |
|--------|-------------|
| `linenr` | Linear envelope with release |
| `linsegr` | Multi-segment with release |
| `expsegr` | Exponential with release |
| `madsr` | MIDI-style ADSR |
| `mxadsr` | Extended ADSR |
| `xtratim` | Extend note time |

---

## Performance Notes

- **Latency:** ksmps=32 gives ~0.7ms latency at 44.1kHz
- **Polyphony:** Typically 32-128 voices depending on instrument complexity
- **CPU per voice:** Simple synth ~1%, complex ~5-10%
- **MIDI jitter:** Usually <1ms with proper driver setup
- **Real-time safe:** All MIDI opcodes are real-time safe

**Best Practices:**
- Use `-Ma` for all MIDI devices during development
- Test with specific device (`-M0`) for performance
- Lower buffer sizes (`-b128 -B512`) for responsive feel
- Use `port` opcode to smooth CC values
- Always include release envelopes (`linenr`, `linsegr`)
- Initialize CC values with `initc7` or conditional defaults

---

## Extended Documentation

**Official Csound MIDI References:**
- [cpsmidi](https://csound.com/docs/manual/cpsmidi.html)
- [cpsmidib](https://csound.com/docs/manual/cpsmidib.html)
- [ampmidi](https://csound.com/docs/manual/ampmidi.html)
- [ctrl7](https://csound.com/docs/manual/ctrl7.html)
- [midictrl](https://csound.com/docs/manual/midictrl.html)
- [massign](https://csound.com/docs/manual/massign.html)
- [linenr](https://csound.com/docs/manual/linenr.html)
- [aftouch](https://csound.com/docs/manual/aftouch.html)
- [pchbend](https://csound.com/docs/manual/pchbend.html)

**MIDI Specification:**
- [MIDI Association](https://www.midi.org/)
- MIDI 1.0 Specification
- MPE (MIDI Polyphonic Expression) Specification

**Learning Resources:**
- Csound FLOSS Manual: Chapter 7 (MIDI)
- "The Csound Book" - MIDI chapters
- Csound Journal articles on real-time performance
