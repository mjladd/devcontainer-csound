# McCurdy GEN Routine Examples

## Metadata

- **Title:** GEN Routine Examples (McCurdy)
- **Category:** Function Tables / GEN Routines
- **Difficulty:** Beginner to Intermediate
- **Tags:** `gen`, `function-tables`, `waveforms`, `envelopes`, `windows`, `random`, `polynomials`, `breakpoints`
- **Source:** Iain McCurdy Csound Realtime Examples
- **License:** CC BY-NC-SA 4.0
- **Original Location:** csound_realtime/GEN/

---

## Overview

GEN routines generate function tables (f-tables) that store data for oscillators, envelopes, windows, and other purposes. Tables are fundamental to Csound - oscillators read waveforms from tables, granular opcodes use window tables, and many other opcodes reference table data. This collection demonstrates the most important GEN routines.

---

## Waveform Generators

### GEN10
**File:** `GEN10.csd`
**Author:** Iain McCurdy, 2011

**Description:** Creates waveforms from harmonic sine partials. The most common way to create oscillator waveforms.

**Key GEN:** `GEN10`

**Syntax:**
```csound
f1 0 4096 10 1           ; sine wave (1st harmonic only)
f2 0 4096 10 1 0.5 0.33  ; first 3 harmonics
f3 0 4096 10 1 1 1 1 1   ; 5 equal harmonics
```

**Parameters:** Each value is the amplitude of successive harmonics (1st, 2nd, 3rd, etc.)

**Common Waveforms:**
- Sine: `10 1`
- Sawtooth: `10 1 0.5 0.33 0.25 0.2 ...` (1/n series)
- Square: `10 1 0 0.33 0 0.2 0 0.14 ...` (odd harmonics only)
- Triangle: `10 1 0 0.11 0 0.04 ...` (odd harmonics, 1/n² amplitude)

---

### GEN09
**File:** `GEN09.csd`
**Author:** Iain McCurdy

**Description:** Creates waveforms with control over partial number, amplitude, AND phase. More flexible than GEN10.

**Key GEN:** `GEN09`

**Syntax:**
```csound
f1 0 4096 9 pnum1 amp1 phase1 pnum2 amp2 phase2 ...
```

**Key Use:** Inharmonic spectra (partials at non-integer ratios).

---

### GEN11
**File:** `GEN11.csd`
**Author:** Iain McCurdy

**Description:** Creates waveforms with specified number of harmonics and harmonic spacing.

**Key GEN:** `GEN11`

---

### GEN19
**File:** `GEN19.csd`
**Author:** Iain McCurdy

**Description:** Similar to GEN09 but includes DC offset control per partial.

**Key GEN:** `GEN19`

---

## Envelope/Breakpoint Generators

### GEN05_07
**File:** `GEN05_07.csd`
**Author:** Iain McCurdy

**Description:** Creates breakpoint envelopes with segments.
- **GEN05:** Exponential segments (never reaches zero)
- **GEN07:** Linear segments

**Key GEN:** `GEN05`, `GEN07`

**Syntax:**
```csound
; GEN07: value1, duration1, value2, duration2, value3...
f1 0 4096 7 0 1024 1 2048 0.5 1024 0  ; linear ADSR-like

; GEN05: value1, duration1, value2... (no zeros!)
f2 0 4096 5 0.001 1024 1 2048 0.5 1024 0.001
```

---

### GEN06
**File:** `GEN06.csd`
**Author:** Iain McCurdy

**Description:** Cubic spline interpolation between breakpoints - smooth curves.

**Key GEN:** `GEN06`

---

### GEN08
**File:** `GEN08.csd`
**Author:** Iain McCurdy

**Description:** Cubic spline with explicit slope control at each point.

**Key GEN:** `GEN08`

---

### GEN16
**File:** `GEN16.csd`
**Author:** Iain McCurdy

**Description:** Creates breakpoint curves with adjustable curvature per segment.

**Key GEN:** `GEN16`

---

### GEN25_27
**File:** `GEN25_27.csd`
**Author:** Iain McCurdy

**Description:**
- **GEN25:** Reads breakpoints from external file
- **GEN27:** Breakpoints with exponential interpolation

**Key GEN:** `GEN25`, `GEN27`

---

## Window Functions

### GEN20
**File:** `GEN20.csd`
**Author:** Iain McCurdy

**Description:** Creates standard window functions for granular synthesis, FFT, etc.

**Key GEN:** `GEN20`

**Window Types:**
1. Hamming
2. Hanning
3. Bartlett (triangle)
4. Blackman
5. Blackman-Harris
6. Gaussian
7. Kaiser
8. Rectangle
9. Sync

**Usage:**
```csound
f1 0 4096 20 2  ; Hanning window
f2 0 4096 20 6  ; Gaussian window
```

---

## Polynomial Generators

### GEN03
**File:** `GEN03.csd`
**Author:** Iain McCurdy

**Description:** Generates polynomial curves - useful for waveshaping.

**Key GEN:** `GEN03`

---

### GEN13
**File:** `GEN13.csd`
**Author:** Iain McCurdy

**Description:** Chebyshev polynomials for waveshaping - creates specific harmonic distortion.

**Key GEN:** `GEN13`

---

## File-Based Generators

### GEN01
**File:** `GEN01.csd`
**Author:** Iain McCurdy

**Description:** Loads sound file into function table for playback or granular processing.

**Key GEN:** `GEN01`

**Syntax:**
```csound
f1 0 0 1 "soundfile.wav" 0 0 0
; size 0 = auto-size to file length
```

---

### GEN02
**File:** `GEN02.csd`
**Author:** Iain McCurdy

**Description:** Stores list of explicit values directly in table.

**Key GEN:** `GEN02`

**Syntax:**
```csound
f1 0 8 -2 0.5 0.7 0.9 1.0 0.9 0.7 0.5 0.3
```

---

## Random/Noise Generators

### GEN21
**File:** `GEN21.csd`
**Author:** Iain McCurdy

**Description:** Fills table with random values from various distributions.

**Key GEN:** `GEN21`

**Distributions:**
1. Uniform
2. Linear
3. Triangular
4. Exponential
5. Biexponential
6. Gaussian
7. Cauchy
8. Positive Cauchy
9. Beta
10. Weibull
11. Poisson

---

## Specialized Generators

### GEN12
**File:** `GEN12.csd`
**Author:** Iain McCurdy

**Description:** Generates log of modified Bessel function - used for FM synthesis index scaling.

**Key GEN:** `GEN12`

---

### GEN17
**File:** `GEN17.csd`
**Author:** Iain McCurdy

**Description:** Creates step functions from x-y coordinate pairs.

**Key GEN:** `GEN17`

---

### GEN18
**File:** `GEN18.csd`
**Author:** Iain McCurdy

**Description:** Writes sections of a composite waveform from multiple source tables.

**Key GEN:** `GEN18`

---

### GEN30
**File:** `GEN30.csd`
**Author:** Iain McCurdy

**Description:** Generates band-limited waveforms - reduces aliasing at high frequencies.

**Key GEN:** `GEN30`

---

### GEN31
**File:** `GEN31.csd`
**Author:** Iain McCurdy

**Description:** Mixes sinusoids controlled by another table.

**Key GEN:** `GEN31`

---

### GEN33
**File:** `GEN33.csd`
**Author:** Iain McCurdy

**Description:** Generates waveform from separate amplitude/frequency tables.

**Key GEN:** `GEN33`

---

### GEN41 / GEN42
**Files:** `GEN41.csd`, `GEN42.csd`
**Author:** Iain McCurdy

**Description:** Random selection generators.
- **GEN41:** Weighted random selection
- **GEN42:** Discrete random distribution

**Key GEN:** `GEN41`, `GEN42`

---

## GEN Routine Summary

| GEN | Purpose |
|-----|---------|
| 01 | Load sound file |
| 02 | Store explicit values |
| 03 | Polynomial curves |
| 05 | Exponential segments |
| 06 | Cubic spline |
| 07 | Linear segments |
| 08 | Cubic spline with slopes |
| 09 | Partials with phase control |
| 10 | Harmonic partials (simple) |
| 11 | Harmonic series generator |
| 12 | Bessel function |
| 13 | Chebyshev polynomial |
| 16 | Breakpoints with curvature |
| 17 | Step function |
| 18 | Composite waveform |
| 19 | Partials with DC offset |
| 20 | Window functions |
| 21 | Random distributions |
| 25 | Breakpoints from file |
| 27 | Exponential breakpoints |
| 30 | Band-limited waveforms |
| 31 | Table-controlled sinusoids |
| 33 | Amp/freq table waveform |
| 41 | Weighted random |
| 42 | Discrete random |

---

## Function Table Basics

### Creating Tables
```csound
; In score:
f1 0 4096 10 1  ; table 1, time 0, size 4096, GEN10, sine

; In orchestra (runtime):
giSine ftgen 1, 0, 4096, 10, 1
```

### Table Size
- Must be power of 2 (or power of 2 + 1)
- Common sizes: 256, 512, 1024, 2048, 4096, 8192
- Size 0 = auto-size (GEN01 sound files)

### Negative GEN Number
Negative GEN number disables normalization:
```csound
f1 0 4096 -7 0 4096 1  ; ramp 0 to 1, not normalized
```

---

## Related Corpus Entries

- `mccurdy_additive_synthesis_entry.md` - Uses GEN10 tables
- `mccurdy_granular_synthesis_entry.md` - Uses GEN20 windows
- `csound_gen_routines_entry.md` - GEN routine theory

