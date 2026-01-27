# McCurdy Reverb Examples

## Metadata

- **Title:** Reverb Examples (McCurdy)
- **Category:** Reverbs / Spatial Effects
- **Difficulty:** Beginner to Intermediate
- **Tags:** `reverb`, `room`, `hall`, `freeverb`, `schroeder`, `comb`, `allpass`, `convolution`, `spatial`
- **Source:** Iain McCurdy Csound Realtime Examples
- **License:** CC BY-NC-SA 4.0
- **Original Location:** csound_realtime/Reverbs/

---

## Overview

Reverb simulates the acoustic reflections of enclosed spaces. From small rooms to cathedrals, reverb adds depth and space to sounds. This collection demonstrates various reverb algorithms and building blocks in Csound.

---

## High-Level Reverb Opcodes

### freeverb

**File:** `freeverb.csd`
**Author:** Iain McCurdy, 2006

**Description:** Implementation of the Freeverb algorithm - popular, efficient room reverb.

**Key Opcodes:** `freeverb`

**Parameters:**

- Room Size (0-1) - controls reverb time
- High Frequency Damping (0-1) - darkens reverb tail
- Dry/Wet Mix

**Key Features:**

- Stereo output
- Initialization skip option
- Efficient algorithm

**Note:** Reverb placed in separate always-on instrument from source.

---

### reverb

**File:** `reverb.csd`
**Author:** Iain McCurdy

**Description:** Classic Csound reverb opcode - simple but effective.

**Key Opcodes:** `reverb`

---

### nreverb

**File:** `nreverb.csd`
**Author:** Iain McCurdy

**Description:** Network reverb - more sophisticated than basic reverb.

**Key Opcodes:** `nreverb`

---

### babo

**File:** `babo.csd`
**Author:** Iain McCurdy

**Description:** Physical room model reverb - simulates rectangular room acoustics with source/listener positioning.

**Key Opcodes:** `babo`

**Key Features:**

- Room dimensions (width, depth, height)
- Source position in 3D space
- Listener position
- Wall absorption coefficients

---

### screverb

**File:** `screverb.csd`
**Author:** Iain McCurdy

**Description:** Sean Costello reverb - high-quality algorithmic reverb.

**Key Opcodes:** `screverb` (if available) or equivalent

---

## Building Block Opcodes

### comb_combinv

**File:** `comb_combinv.csd`
**Author:** Iain McCurdy

**Description:** Comb filter - fundamental reverb building block creating resonant feedback delay.

**Key Opcodes:** `comb`, `combinv`

**Parameters:**

- Loop Time - sets resonant frequency
- Reverb Time - decay of resonance

**Key Concept:**

- `comb` - feedforward + feedback (positive feedback)
- `combinv` - inverted feedback (negative feedback)

Comb filters create series of equally-spaced resonances.

---

### vcomb

**File:** `vcomb.csd`
**Author:** Iain McCurdy

**Description:** Variable comb filter with time-varying loop time.

**Key Opcodes:** `vcomb`

---

### alpass

**File:** `alpass.csd`
**Author:** Iain McCurdy

**Description:** Allpass filter - delays signal while passing all frequencies equally.

**Key Opcodes:** `alpass`

**Key Concept:** Allpass filters add density to reverb without coloring frequency response. Used in series with comb filters.

---

### valpass

**File:** `valpass.csd`
**Author:** Iain McCurdy

**Description:** Variable allpass filter with time-varying delay.

**Key Opcodes:** `valpass`

---

## Reverb Algorithms

### SchroederReverb

**File:** `SchroederReverb.csd`
**Author:** Iain McCurdy

**Description:** Implementation of Manfred Schroeder's classic digital reverb algorithm.

**Key Opcodes:** `comb`, `alpass`

**Algorithm:**

```
Input → [4 parallel combs] → sum → [2 series allpass] → Output
```

**Key Concept:** Schroeder reverb uses:

- Parallel comb filters for density
- Series allpass filters for diffusion
- Prime-number delay times to avoid flutter

---

### GatedReverb

**File:** `GatedReverb.csd`
**Author:** Iain McCurdy

**Description:** Gated reverb - reverb tail cut off abruptly for dramatic 80s drum sound.

**Key Opcodes:** Reverb + gate/envelope

**Key Concept:** Reverb signal multiplied by envelope that cuts to zero after set time.

---

## Key Reverb Opcodes Reference

| Opcode | Type | Description |
|--------|------|-------------|
| `reverb` | Complete | Basic reverberator |
| `nreverb` | Complete | Network reverb |
| `freeverb` | Complete | Freeverb algorithm |
| `reverbsc` | Complete | Sean Costello reverb |
| `babo` | Physical | Room model with positioning |
| `comb` | Building block | Comb filter (resonator) |
| `combinv` | Building block | Inverted comb filter |
| `vcomb` | Building block | Variable comb |
| `alpass` | Building block | Allpass filter |
| `valpass` | Building block | Variable allpass |

---

## Reverb Concepts

### Reverb Parameters

- **Room Size / Reverb Time:** How long reflections persist
- **Pre-delay:** Gap before reverb starts (room size cue)
- **Damping:** High-frequency absorption (room material)
- **Density:** How quickly reflections build up
- **Diffusion:** Smoothness of reverb tail
- **Wet/Dry Mix:** Balance of effect vs. original

### Schroeder Algorithm Components

1. **Parallel Comb Filters:** Create dense, colored resonances
2. **Series Allpass Filters:** Add diffusion without coloring
3. **Prime Delay Times:** Avoid flutter echoes

### Room Simulation

- Small rooms: Short RT60, brighter
- Large halls: Long RT60, more damping
- Plates/Springs: Metallic, dense

---

## Implementation Tips

### Separate Always-On Instrument

Best practice: reverb in separate instrument using global audio variables:

```csound
; Instrument 1: Sound source
gaRvbSend = gaRvbSend + asig * krvbsend

; Instrument 99: Always-on reverb
aRvbL, aRvbR freeverb gaRvbSend, gaRvbSend, kroom, khfdamp
outs aRvbL, aRvbR
gaRvbSend = 0  ; Clear for next k-cycle
```

### Avoiding DC Buildup

Long reverbs can accumulate DC offset. Use `dcblock` on output:

```csound
aout dcblock aRever
```

---

## Related Corpus Entries

- `mccurdy_delays_entry.md` - Delays (reverb building blocks)
- `csound_reverbs_entry.md` - Reverb theory
- `mccurdy_convolution_entry.md` - Convolution reverb
