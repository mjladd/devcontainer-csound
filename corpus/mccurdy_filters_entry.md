# McCurdy Filter Examples

## Metadata

- **Title:** Filter Examples (McCurdy)
- **Category:** Filters / Sound Modification
- **Difficulty:** Beginner to Intermediate
- **Tags:** `filters`, `lowpass`, `highpass`, `bandpass`, `resonance`, `moog`, `butterworth`, `state-variable`, `formant`, `eq`
- **Source:** Iain McCurdy Csound Realtime Examples
- **License:** CC BY-NC-SA 4.0
- **Original Location:** csound_realtime/Filters/

---

## Overview

Filters are fundamental tools for shaping sound by attenuating or boosting specific frequency ranges. This collection demonstrates Csound's extensive filter opcodes, from simple tone controls to resonant synthesizer filters and precise equalizers.

---

## Simple Filters (First-Order)

### tone
**File:** `tone.csd`
**Author:** Iain McCurdy

**Description:** First-order lowpass filter - simple one-pole design with 6dB/octave rolloff.

**Key Opcodes:** `tone`

**Parameters:**
- Cutoff Frequency - half-power point (-3dB)

---

### tonex
**File:** `tonex.csd`
**Author:** Iain McCurdy

**Description:** Cascaded `tone` filters for steeper rolloff. Each additional stage adds 6dB/octave.

**Key Opcodes:** `tonex`

---

### atone
**File:** `atone.csd`
**Author:** Iain McCurdy

**Description:** First-order highpass filter - compliment to `tone`.

**Key Opcodes:** `atone`

---

### atonex
**File:** `atonex.csd`
**Author:** Iain McCurdy

**Description:** Cascaded `atone` filters for steeper highpass rolloff.

**Key Opcodes:** `atonex`

---

## Butterworth Filters

### butterlp
**File:** `butterlp.csd`
**Author:** Iain McCurdy

**Description:** Second-order Butterworth lowpass - maximally flat passband response.

**Key Opcodes:** `butterlp`

**Parameters:**
- Cutoff Frequency

**Key Concept:** Butterworth filters have no ripple in passband, 12dB/octave rolloff.

---

### butterhp
**File:** `butterhp.csd`
**Author:** Iain McCurdy

**Description:** Second-order Butterworth highpass filter.

**Key Opcodes:** `butterhp`

---

### butterbp
**File:** `butterbp.csd`
**Author:** Iain McCurdy

**Description:** Second-order Butterworth bandpass filter.

**Key Opcodes:** `butterbp`

**Parameters:**
- Center Frequency
- Bandwidth

---

### butterbr
**File:** `butterbr.csd`
**Author:** Iain McCurdy

**Description:** Second-order Butterworth band-reject (notch) filter.

**Key Opcodes:** `butterbr`

---

## Resonant Filters

### reson
**File:** `reson.csd`
**Author:** Iain McCurdy

**Description:** Second-order resonant bandpass filter with controllable bandwidth.

**Key Opcodes:** `reson`

**Parameters:**
- Center Frequency
- Bandwidth
- Scaling Mode (0=none, 1=peak response, 2=RMS)

---

### reson_resonr_resonz
**File:** `reson_resonr_resonz.csd`
**Author:** Iain McCurdy

**Description:** Compares three related resonant filters with different characteristics.

**Key Opcodes:** `reson`, `resonr`, `resonz`

**Differences:**
- `reson` - standard IIR bandpass
- `resonr` - recursive version with impulse response
- `resonz` - bidirectional recursive, different phase response

---

### resony
**File:** `resony.csd`
**Author:** Iain McCurdy

**Description:** Bank of resonant bandpass filters in parallel - useful for formant-like effects.

**Key Opcodes:** `resony`

---

### areson
**File:** `areson.csd`
**Author:** Iain McCurdy

**Description:** Notch filter version of reson - attenuates at center frequency.

**Key Opcodes:** `areson`

---

### lowres / lowresx
**Files:** `lowres.csd`, `lowresx.csd`
**Author:** Iain McCurdy

**Description:** Resonant lowpass filter with Q control. `lowresx` is a cascaded version.

**Key Opcodes:** `lowres`, `lowresx`

---

### vlowres
**File:** `vlowres.csd`
**Author:** Iain McCurdy

**Description:** Variable resonance lowpass filter - resonance can create self-oscillation.

**Key Opcodes:** `vlowres`

---

### lowpass2
**File:** `lowpass2.csd`
**Author:** Iain McCurdy

**Description:** Second-order lowpass filter implementation.

**Key Opcodes:** `lowpass2`

---

### bandpass
**File:** `bandpass.csd`
**Author:** Iain McCurdy

**Description:** General bandpass filter implementation.

**Key Opcodes:** Various bandpass implementations

---

## Analog-Style Filters

### moogladder
**File:** `moogladder.csd`
**Author:** Iain McCurdy, 2006

**Description:** Emulation of the classic Moog ladder lowpass filter with 24dB/octave rolloff and resonance.

**Key Opcodes:** `moogladder`

**Parameters:**
- Cutoff Frequency (20-20000 Hz)
- Resonance (0-1)
- Keyboard Tracking option

**Key Features:**
- Virtual keyboard interface
- Waveform selection (sawtooth, square, noise)
- Classic subtractive synthesis sound

---

### moogvcf
**File:** `moogvcf.csd`
**Author:** Iain McCurdy

**Description:** Alternative Moog filter emulation.

**Key Opcodes:** `moogvcf`

---

### lpf18
**File:** `lpf18.csd`
**Author:** Iain McCurdy

**Description:** 18dB/octave lowpass filter emulation - distinctive character.

**Key Opcodes:** `lpf18`

---

### tbvcf
**File:** `tbvcf.csd`
**Author:** Iain McCurdy

**Description:** Emulation of the TB-303 resonant lowpass filter - classic acid bass sound.

**Key Opcodes:** `tbvcf`

---

### rezzy
**File:** `rezzy.csd`
**Author:** Iain McCurdy

**Description:** Resonant lowpass filter similar to synthesizer voltage-controlled filters.

**Key Opcodes:** `rezzy`

---

### bqrez
**File:** `bqrez.csd`
**Author:** Iain McCurdy

**Description:** Biquad resonant filter with various filter types available.

**Key Opcodes:** `bqrez`

---

## Multi-Output Filters

### svfilter
**File:** `svfilter.csd`
**Author:** Iain McCurdy, 2009

**Description:** State-variable filter with simultaneous lowpass, highpass, and bandpass outputs.

**Key Opcodes:** `svfilter`

**Parameters:**
- Filter Cutoff (20-20000 Hz)
- Q / Resonance (1-500)
- Low/High/Band output gains
- Scaling option

**Key Concept:** One filter providing three different response types simultaneously.

**Note:** Can become unstable at high cutoff frequencies with low Q values.

---

### statevar
**File:** `statevar.csd`
**Author:** Iain McCurdy

**Description:** Another state-variable filter implementation with multiple outputs.

**Key Opcodes:** `statevar`

---

### clfilt
**File:** `clfilt.csd`
**Author:** Iain McCurdy

**Description:** Attempt to create a combination lowpass/highpass filter.

**Key Opcodes:** `clfilt`

---

## Equalizers

### pareq
**File:** `pareq.csd`
**Author:** Iain McCurdy

**Description:** Parametric equalizer section - boost or cut with adjustable bandwidth.

**Key Opcodes:** `pareq`

**Parameters:**
- Center Frequency
- Gain (boost/cut in dB)
- Q / Bandwidth

---

### eqfil
**File:** `eqfil.csd`
**Author:** Iain McCurdy

**Description:** Peaking/notch equalizer filter.

**Key Opcodes:** `eqfil`

---

### rbjeq
**File:** `rbjeq.csd`
**Author:** Iain McCurdy

**Description:** Robert Bristow-Johnson equalizer - high-quality parametric EQ algorithm.

**Key Opcodes:** `rbjeq`

---

## Special Filters

### FormantFilter
**File:** `FormantFilter.csd`
**Author:** Iain McCurdy

**Description:** Filter bank configured for vocal formant resonances - creates vowel sounds from input.

**Key Opcodes:** Filter banks (reson, etc.)

---

### hilbert
**File:** `hilbert.csd`
**Author:** Iain McCurdy

**Description:** Hilbert transform - produces quadrature outputs (90° phase difference) for single-sideband modulation effects.

**Key Opcodes:** `hilbert`

---

### compare_standard_filters
**File:** `compare_standard_filters.csd`
**Author:** Iain McCurdy

**Description:** Side-by-side comparison of different filter types to hear their characteristics.

**Key Opcodes:** Multiple filter types for comparison

---

## Filter Concepts

### Filter Types
- **Lowpass (LP):** Passes frequencies below cutoff
- **Highpass (HP):** Passes frequencies above cutoff
- **Bandpass (BP):** Passes frequencies around center frequency
- **Band-reject/Notch (BR):** Attenuates frequencies around center
- **Allpass:** Passes all frequencies, changes phase only

### Key Parameters
- **Cutoff Frequency:** Where filter begins attenuating
- **Resonance/Q:** Peak at cutoff frequency
- **Slope:** Rolloff steepness (6dB, 12dB, 24dB per octave)
- **Bandwidth:** Width of bandpass/notch (often specified in Hz or Q)

### Filter Order and Slope
| Order | Poles | Slope |
|-------|-------|-------|
| 1st | 1 | 6 dB/octave |
| 2nd | 2 | 12 dB/octave |
| 4th | 4 | 24 dB/octave |

---

## Key Opcodes Reference

| Opcode | Type | Description |
|--------|------|-------------|
| `tone` | LP | First-order lowpass |
| `atone` | HP | First-order highpass |
| `butterlp` | LP | Butterworth lowpass |
| `butterhp` | HP | Butterworth highpass |
| `butterbp` | BP | Butterworth bandpass |
| `butterbr` | Notch | Butterworth band-reject |
| `reson` | BP | Resonant bandpass |
| `areson` | Notch | Resonant notch |
| `moogladder` | LP | Moog 4-pole lowpass |
| `moogvcf` | LP | Alternative Moog filter |
| `lpf18` | LP | 18dB/octave lowpass |
| `tbvcf` | LP | TB-303 style filter |
| `svfilter` | Multi | State-variable (LP/HP/BP) |
| `statevar` | Multi | State-variable filter |
| `pareq` | EQ | Parametric equalizer |
| `hilbert` | Special | Hilbert transform |

---

## Related Corpus Entries

- `csound_filters_entry.md` - Filter theory and concepts
- `mccurdy_physical_models_entry.md` - Filters in physical modeling
- `mccurdy_fft_entry.md` - Spectral filtering

