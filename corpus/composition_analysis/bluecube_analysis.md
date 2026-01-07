---
source: Original Composition Analysis
title: "BLUECUBE"
composer: Kim Cascone
file: scores/bluecube.csd
type: composition_analysis
duration: ~190 seconds
instruments: 9
techniques: [ring_modulation, fm_synthesis, sample_and_hold, risset_beating, filter_sweep, constant_power_panning, global_effects]
---

# BLUECUBE - Composition Analysis

**Composer:** Kim Cascone
**Duration:** ~190 seconds
**Channels:** Stereo
**Sample Rate:** 44100 Hz
**Control Rate:** 4410 Hz

## Overview

BLUECUBE is an electroacoustic composition demonstrating a variety of classic computer music synthesis techniques. The piece employs nine instruments plus two global effects processors (reverb and delay), creating layered textures through ring modulation, FM synthesis, sample-and-hold randomness, and Risset beating effects.

## Architecture

### Global Effects Bus

The composition uses a classic global effects architecture with two buses:

```csound
garvbsig  init      0    ; Reverb send bus
gasig     init      0    ; Delay send bus
```

All instruments contribute to the reverb bus at varying levels, while only instrument 6 (clicky filter) feeds the delay.

### Instruments

#### Instrument 1: Three-Branch Synthesizer

A complex instrument combining three parallel synthesis branches:

1. **Noise Branch**: Filtered noise using `randi` through an oscillator
2. **Ring Modulation Branch**: Two oscillators multiplied together with linen envelope
3. **Low Sine Branch**: Simple sine tone for bass foundation

Output is mixed, filtered through `butterlp` with sweeping cutoff, and panned.

**Key Parameters:**
- p4: Base frequency
- p5: Amplitude
- p6-p7: Ring mod frequencies
- p8: Ring mod amplitude
- p9: Noise frequency

#### Instrument 2: Noise Band Glissando

Generates swept noise bands using `randi` fed through an oscillator, then processed with `reson` filter. The filter sweep is controlled by the panning oscillator offset.

#### Instrument 3: Simple Sine Instrument

Basic sine wave instrument with ADSR envelope and score-controlled panning. Used for punctuating melodic gestures throughout the piece.

#### Instrument 4: Sample & Hold

Classic sample-and-hold circuit using `randh`, `samphold`, and a clock oscillator with duty cycle waveform (f14). Creates stepped random pitch sequences controlling a sine oscillator.

**Signal Flow:**
```
randh → samphold (clocked by pulse) → oscil frequency
```

#### Instrument 5: FM with Reverse Envelope

FM synthesis using `foscili` with reverse exponential envelope (f18), creating "backwards" FM timbres.

**Notable Feature - Constant Power Panning:**
```csound
krtl = sqrt(2)/2*cos(kpan)+sin(kpan)  ; CONSTANT POWER PANNING
krtr = sqrt(2)/2*cos(kpan)-sin(kpan)  ; FROM C.ROADS "CM TUTORIAL" pp460
```

This technique maintains consistent loudness across the stereo field, unlike simple linear panning.

#### Instrument 6: Clicky Filter Sweep

Generates percussive clicks by:
1. Creating spikes with exponential envelope waveform
2. Bandpass filtering for "click" character
3. Applying resonant filter sweep (1800→180 Hz)
4. Enveloping and panning the output

Sends to both reverb and delay buses.

#### Instrument 7: Noise Band Glissando (Commented Out)

An alternative noise glissando instrument that was disabled. Contains constant-power panning code similar to instrument 5.

#### Instrument 8: Cascade Harmonics (Risset Beating)

**Borrowed from Jean-Claude Risset's techniques.** Nine oscillators with slightly detuned frequencies create interference patterns and beating effects:

```csound
i1 = p6          ; offset values
i2 = 2*p6
i3 = 3*p6
i4 = 4*p6

a1 oscili ampenv, p4, 20
a2 oscili ampenv, p4+i1, 20    ; slightly sharp
a3 oscili ampenv, p4+i2, 20
...
a6 oscili ampenv, p4-i1, 20    ; slightly flat
```

The waveform f20 is "approaching square" with selected harmonics for rich timbre.

#### Instrument 9: "Water" S&H

Another sample-and-hold instrument, but with the S&H controlling a resonant filter's center frequency rather than oscillator pitch. Creates bubbling, water-like textures.

#### Instrument 98: Global Delay

Parallel stereo delay with two tap times (p4 and p4*2):

```csound
a1 delay gasig, p4      ; Left: 0.66s
a2 delay gasig, p4*2    ; Right: 1.32s
```

#### Instrument 99: Global Reverb

Uses `reverb2` opcode with 6-second reverb time and 0.2 high-frequency diffusion.

## Function Tables

| Table | Size | Type | Purpose |
|-------|------|------|---------|
| f1 | 512 | GEN09 | Sine wave (low-res) |
| f2 | 512 | GEN05 | Exponential envelope |
| f3 | 512 | GEN09 | Inharmonic wave |
| f4 | 512 | GEN09 | Sine wave |
| f8 | 512 | GEN05 | Exponential envelope (shorter) |
| f9 | 512 | GEN05 | Constant value of 1 |
| f10 | 512 | GEN07 | ADSR envelope |
| f11 | 2048 | GEN10 | Sine wave (high-res) |
| f13 | 1024 | GEN07 | Triangle wave |
| f14 | 512 | GEN07 | Pulse for S&H clock |
| f15 | 512 | GEN07 | Ramp up (L→R pan) |
| f16 | 512 | GEN07 | Ramp down (R→L pan) |
| f17 | 1024 | GEN07 | Triangle with offset (0.5-1-0.5-0-0.5) |
| f18 | 512 | GEN05 | Reverse exponential envelope |
| f20 | 1024 | GEN10 | Approaching square (selected harmonics) |

## Compositional Structure

The piece unfolds over approximately 190 seconds with overlapping layers:

- **0-60s**: Noise band glissandos (i2) with punctuating sines (i3) and three-branch synthesis (i1)
- **30-80s**: Sample & hold sequences (i4) enter
- **60-80s**: FM synthesis gestures (i5)
- **80-160s**: Risset cascade harmonics (i8) provide sustained harmonic texture
- **100-180s**: Clicky filter sweeps (i6) and "water" S&H textures (i9)
- **175-190s**: Final S&H sequence and closing gestures

## Key Techniques Demonstrated

1. **Ring Modulation**: Multiplication of two audio signals creating sum and difference frequencies
2. **FM Synthesis**: Frequency modulation with carrier/modulator ratios and index control
3. **Sample & Hold**: Classic analog synth technique for stepped random control signals
4. **Risset Beating**: Multiple detuned oscillators creating interference patterns
5. **Constant-Power Panning**: Trigonometric panning maintaining consistent loudness
6. **Global Effects Routing**: Centralized reverb/delay with instrument-level send controls
7. **Filter Sweeps**: Resonant filter automation for timbral evolution
8. **Noise Shaping**: Using noise through oscillators and filters for texture

## References

- Curtis Roads, "The Computer Music Tutorial" p.460 (constant-power panning)
- Jean-Claude Risset (cascade harmonics technique)
- Dodge & Jerse book referenced in comments (sqrt panning, Fig. 7.20)

## Learning Value

This composition serves as an excellent reference for:

- Combining multiple synthesis techniques in a single work
- Proper use of global effects buses
- Various panning strategies and their implementations
- Score organization with parameter documentation
- Classic electroacoustic composition structure
