# McCurdy Delay Examples

## Metadata

- **Title:** Delay Examples (McCurdy)
- **Category:** Delays / Time-Based Effects
- **Difficulty:** Beginner to Intermediate
- **Tags:** `delay`, `echo`, `feedback`, `chorus`, `flanger`, `ping-pong`, `multitap`, `doppler`, `pitch-shift`
- **Source:** Iain McCurdy Csound Realtime Examples
- **License:** CC BY-NC-SA 4.0
- **Original Location:** csound_realtime/Delays/

---

## Overview

Delay effects create copies of the input signal at various time offsets. From simple echoes to complex pitch-shifters, delays form the basis of many effects including chorus, flanging, and even reverb. This collection demonstrates Csound's delay opcodes and common delay-based effects.

---

## Basic Delay Implementation

### delayw_delayr_deltap
**File:** `delayw_delayr_deltap.csd`
**Author:** Iain McCurdy, 2006

**Description:** Foundation delay implementation using the three core delay opcodes.

**Key Opcodes:** `delayr`, `delayw`, `deltap`

**Parameters:**
- Delay Time (0.001-5 seconds)
- Dry/Wet Mix
- Output Gain

**Key Technique:**
```csound
abuf delayr 5          ; Create 5-second delay buffer
adel deltap kdlytime   ; Read from buffer at variable time
     delayw asig       ; Write to buffer
```

**Note:** Low ksmps values needed for short, modulated delays.

---

### Delays
**File:** `Delays.csd`
**Author:** Iain McCurdy

**Description:** Overview of basic delay concepts and implementations.

**Key Opcodes:** `delay`, `delayr`, `delayw`, `deltap`

---

### delayfeedback
**File:** `delayfeedback.csd`
**Author:** Iain McCurdy

**Description:** Delay with feedback - output fed back to input for repeating echoes.

**Key Opcodes:** `delayr`, `delayw`, `deltap`

**Parameters:**
- Delay Time
- Feedback Amount (0-1, careful >1 builds infinitely)

**Key Concept:** Feedback creates multiple decaying repeats from single input.

---

## Stereo and Multi-Tap Delays

### StereoPingPongDelay
**File:** `StereoPingPongDelay.csd`
**Author:** Iain McCurdy

**Description:** Classic ping-pong delay bouncing between left and right channels.

**Key Opcodes:** `delayr`, `delayw`, `deltap`

**Key Concept:** Two delay lines with cross-feedback create alternating L/R echoes.

---

### MultitapDelay
**File:** `MultitapDelay.csd`
**Author:** Iain McCurdy

**Description:** Multiple taps from single delay buffer at different times.

**Key Opcodes:** `delayr`, `deltap` (multiple), `delayw`

**Key Concept:** Multiple `deltap` reads from one buffer create complex rhythmic patterns.

---

### DoubleDelayCrossedFeedback
**File:** `DoubleDelayCrossedFeedback.csd`
**Author:** Iain McCurdy

**Description:** Two delays with cross-feedback - each feeds into the other.

**Key Opcodes:** `delayr`, `delayw`, `deltap`

---

## Modulated Delays (Chorus/Flanger)

### delayStereoChorus
**File:** `delayStereoChorus.csd`
**Author:** Iain McCurdy

**Description:** Stereo chorus effect using modulated short delays.

**Key Opcodes:** `delayr`, `delayw`, `deltap3`, `oscili`

**Key Concept:** Small delay (10-30ms) modulated by LFO creates chorus thickening.

---

### delayflanger
**File:** `delayflanger.csd`
**Author:** Iain McCurdy

**Description:** Flanger effect using modulated very short delay with feedback.

**Key Opcodes:** `delayr`, `delayw`, `deltap3`

**Key Concept:** Very short delay (0-10ms) with LFO modulation and feedback creates flanging.

---

### delayThruZeroFlanger
**File:** `delayThruZeroFlanger.csd`
**Author:** Iain McCurdy

**Description:** Through-zero flanging - delay passes through zero creating phase cancellation effects.

**Key Opcodes:** `delayr`, `delayw`, `deltap3`

**Key Concept:** When modulated delay crosses zero, creates distinctive jet-plane flanger sound.

---

## Pitch Shifting Delays

### delaySimplePitchShifter
**File:** `delaySimplePitchShifter.csd`
**Author:** Iain McCurdy

**Description:** Basic pitch shifting using variable delay - demonstrates the principle.

**Key Opcodes:** `delayr`, `delayw`, `deltap3`

**Key Concept:** Continuously changing delay time shifts pitch (Doppler effect).

---

### delayCompletedPitchShifter
**File:** `delayCompletedPitchShifter.csd`
**Author:** Iain McCurdy

**Description:** Complete pitch shifter with crossfading windows to hide discontinuities.

**Key Opcodes:** `delayr`, `delayw`, `deltap3`

**Key Concept:** Two overlapping windows with crossfade create smooth pitch shift.

---

### Delay_PitchShiftInLoop
**File:** `Delay_PitchShiftInLoop.csd`
**Author:** Iain McCurdy

**Description:** Pitch shifting within feedback loop - creates rising/falling pitch spirals.

**Key Opcodes:** `delayr`, `delayw`, `deltap3`

---

### delayportamento
**File:** `delayportamento.csd`
**Author:** Iain McCurdy

**Description:** Portamento (pitch glide) implemented with variable delay.

**Key Opcodes:** `delayr`, `delayw`, `deltap3`, `portk`

---

## Special Effects

### DelayDoppler
**File:** `DelayDoppler.csd`
**Author:** Iain McCurdy

**Description:** Doppler effect simulation - pitch shift and amplitude changes for moving source.

**Key Opcodes:** `delayr`, `delayw`, `deltap3`

**Key Concept:** As delay time changes, pitch shifts (approaching = higher, receding = lower).

---

### delayfiltersinloop
**File:** `delayfiltersinloop.csd`
**Author:** Iain McCurdy

**Description:** Filters placed in delay feedback loop - each echo is filtered, creating evolving timbre.

**Key Opcodes:** `delayr`, `delayw`, `deltap`, `tone`/`butterlp`

---

### pvsdelay
**File:** `pvsdelay.csd`
**Author:** Iain McCurdy

**Description:** Spectral delay - FFT-domain delay for frequency-dependent timing effects.

**Key Opcodes:** `pvsanal`, `pvsdelay`, `pvsynth`

---

## Key Delay Opcodes

| Opcode | Purpose |
|--------|---------|
| `delay` | Simple fixed delay |
| `delayr` | Initialize delay buffer (returns delayed signal) |
| `delayw` | Write to delay buffer |
| `deltap` | Read from buffer at specified time |
| `deltap3` | Read with cubic interpolation (for modulation) |
| `deltapi` | Read with linear interpolation |
| `deltapn` | Read at sample precision |
| `vdelay` | Variable delay line |
| `vdelay3` | Variable delay with interpolation |

---

## Delay Concepts

### Delay Time Ranges
- **Doubling:** 1-30ms - slight thickening
- **Chorus:** 10-30ms modulated - swirling thickness
- **Flanger:** 0-10ms modulated with feedback - metallic sweep
- **Slapback:** 30-100ms - rockabilly echo
- **Echo:** 100ms+ - distinct repeats

### Feedback
- **0:** Single repeat
- **0.5:** Multiple decaying repeats
- **0.9:** Long decay, near-infinite
- **>1:** Builds to distortion (use with caution/limiting)

### Interpolation
Use `deltap3` (cubic) or `deltapi` (linear) when modulating delay time to avoid zipper noise.

---

## Related Corpus Entries

- `mccurdy_reverbs_entry.md` - Reverb effects (based on multiple delays)
- `mccurdy_filters_entry.md` - Filters often used in delay loops
- `csound_delays_entry.md` - Delay theory

