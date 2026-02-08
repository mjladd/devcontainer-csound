# McCurdy Additive Synthesis Examples

## Metadata

- **Title:** Additive Synthesis Examples (McCurdy)
- **Category:** Additive Synthesis / Wavetable Synthesis
- **Difficulty:** Beginner to Advanced
- **Tags:** `additive-synthesis`, `harmonics`, `partials`, `inharmonic`, `wavetable`, `ftmorph`, `adsynt`, `modal`, `spectrum`
- **Source:** Iain McCurdy Csound Realtime Examples
- **License:** CC BY-NC-SA 4.0
- **Original Location:** csound_realtime/AdditiveSynthesis/

---

## Overview

Additive synthesis builds complex timbres by combining sine waves of different frequencies, amplitudes, and phases. Based on Fourier theory, any sound can be replicated as a composite of sine waves. These examples demonstrate various approaches from basic harmonic synthesis to advanced modal and wavetable techniques.

---

## Examples

### adsynt / adsynt2

**File:** `adsynt_adsynt2.csd`
**Author:** Iain McCurdy, 2015

**Description:** Demonstrates the `adsynt` and `adsynt2` opcodes for convenient additive synthesis, particularly with inharmonic spectra. The key difference: `adsynt2` employs linear interpolation to smooth amplitude changes.

**Key Opcodes:** `adsynt`, `adsynt2`, `ftmorf`

**Parameters:**

- Amplitude - overall output level
- Frequency - fundamental frequency (20-5000 Hz)
- Morph - morphs between flat and filtered spectrum
- Peak - spectral peak sharpness
- Shift - shifts spectral window position

**Key Technique:** Uses `ftmorf` to morph between amplitude tables, applying a Kaiser window filter curve to shape the spectrum.

---

### Harmonic Additive Synthesis 1 (10 Harmonics)

**File:** `HarmonicAdditiveSynthesis1.csd`
**Author:** Iain McCurdy, 2006

**Description:** Basic harmonic additive synthesis with 10 individually controllable partials following the harmonic series. Demonstrates fundamental concepts of additive synthesis.

**Key Opcodes:** `oscili`, `sum`

**Parameters:**

- Partial Strength 1-10 - amplitude of each harmonic
- Fundamental (Hz) - base frequency (20-10000 Hz)
- Global Amplitude - overall volume
- Warp Partial Spacings - compress/expand harmonic spacing (<1 compress, >1 expand)
- Partial Spacings Random Factor - adds randomness to partial frequencies

**Key Concepts:**

- Harmonic series: each partial is a multiple of the fundamental (100Hz, 200Hz, 300Hz...)
- The fundamental can also be called the 1st partial
- Warp parameter creates inharmonic spectra when != 1

---

### Harmonic Additive Synthesis 2

**File:** `HarmonicAdditiveSynthesis2.csd`
**Author:** Iain McCurdy, 2006

**Description:** Extended version with more partials and additional controls for creating brighter timbres like violin sounds.

**Key Opcodes:** `oscili`, `sum`

---

### Inharmonic Additive Synthesis

**File:** `InharmonicAdditiveSynthesis.csd`
**Author:** Iain McCurdy, 2006

**Description:** Demonstrates inharmonic additive synthesis where partial spacings do not follow the harmonic series. Default preset creates a tubular bell sound.

**Key Opcodes:** `oscili`, `expsegr`, `sum`

**Parameters:**

- Partial Strength 1-10 - amplitude of each partial
- Fundamental (Hz) - base frequency
- Ratio 1-10 - frequency ratio for each partial (e.g., 272/437)
- Attack/Decay/Release 1-10 - independent ADR envelope per partial

**Key Concepts:**

- Perceived fundamental may not match lowest partial (tubular bell at 437Hz has no actual 437Hz partial)
- Higher partials typically decay faster
- Default ratios derived from sonogram analysis of real tubular bell

**Default Tubular Bell Ratios:**

```
Partial 1: 272/437 = 0.622
Partial 2: 538/437 = 1.231
Partial 3: 874/437 = 2.000
Partial 4: 1281/437 = 2.931
...
```

---

### Modal Additive Synthesis

**File:** `ModalAddSyn.csd`
**Author:** Iain McCurdy, 2011

**Description:** Additive synthesis using modal frequency ratio tables derived from the Csound Manual appendix and personal analyses. Focuses on struck resonant objects.

**Key Opcodes:** `oscili`, modal frequency tables

**Included Modal Data:**

- Tibetan Bowl (180mm) - default
- Various struck/resonant object presets

**Key Features:**

- Minimal GUI with maximum sonic range
- MIDI keyboard control intended
- Modal ratios from acoustic measurements

---

### Wavetable Synthesis (ftmorph)

**File:** `ftmorph.csd`
**Author:** Iain McCurdy, 2011

**Description:** Wavetable synthesis using `ftmorph` to morph between GEN10 waveform tables. More efficient than multi-partial additive synthesis.

**Key Opcodes:** `ftmorph`, `oscili`

**Modes:**

- Single Table - read from one waveform
- Multi Table - morph between multiple waveforms

**Key Concepts:**

- Based on additive synthesis but uses pre-computed waveforms
- Mapping waveforms across keyboard (like sampler keygroups)
- Much more efficient than controlling individual partials
- GEN10, GEN9, or GEN19 tables are appropriate sources

---

### GEN09 Inharmonic Table

**File:** `GEN09InharmonicTable.csd`
**Author:** Iain McCurdy, 2011

**Description:** Uses GEN09 to create imitations of inharmonic spectra by approximating inharmonic partials as selected upper partials of a harmonic waveform, then scaling oscillator frequency.

**Key Opcodes:** `oscili` with GEN09 tables

**Key Technique:**

- Higher harmonic partials approximating inharmonic ratios
- Oscillator frequency scaling to achieve desired partial frequencies
- Amplitude and filter envelopes per-voice

---

### Stretched Harmonic Partials

**File:** `StretchedHarmonicPartials.csd`
**Author:** Iain McCurdy, 2011

**Description:** Simulates piano string inharmonicity where partials are increasingly stretched above their expected harmonic frequencies due to string stiffness.

**Key Opcodes:** `oscili`

**Key Concepts:**

- Real piano strings don't produce exact harmonic ratios
- Stiffness causes warping: 1:2:3 becomes 1:2.01:3.02...
- Different string thicknesses/tensions = different warping amounts
- Effect varies across keyboard range

---

### Additive Synthesis Spectral Sketching

**File:** `AdditiveSynthesisSpectralSketching.csd`
**Author:** Iain McCurdy

**Description:** Interactive tool for drawing/sketching spectral content.

---

### Partial Strengths Envelope

**File:** `PartialStrengthsEnvelope.csd`
**Author:** Iain McCurdy

**Description:** Demonstrates time-varying partial amplitude envelopes for dynamic spectral evolution.

---

### Spectrum Analyser

**Files:** `SpectrumAnalyser.csd`, `SpectrumAnalyser100.csd`
**Author:** Iain McCurdy, 2011

**Description:** Captures waveforms and displays GEN10 partial strengths. The 100-partial version provides higher resolution analysis.

**Key Features:**

- Real-time spectrum visualization
- Waveform capture and analysis
- GEN10 coefficient extraction

---

## Common Patterns in These Examples

### FLTK Interface Structure

All examples use FLTK for GUI with consistent patterns:

```csound
FLcolor 255, 255, 255, 0, 0, 0
FLpanel "Panel Name", width, height, x, y
; ... widgets ...
FLpanel_end
FLrun
```

### MIDI/FLTK Dual Control

```csound
iMIDIActiveValue = 1
iMIDIflag = 0
mididefault iMIDIActiveValue, iMIDIflag
if gkOnOff==0 && iMIDIflag==0 then
    turnoff
endif
```

### Portamento for Smooth Control Changes

```csound
kporttime linseg 0, 0.01, 0.05
kfund portk gkfund, kporttime
```

### Anti-Click Envelope

```csound
aenv linsegr 0, 0.01, 1, 0.1, 0
outs amix*aenv, amix*aenv
```

---

## Key Opcodes Reference

| Opcode | Purpose |
|--------|---------|
| `oscili` | Interpolating oscillator for partials |
| `adsynt` | Additive synthesis with amplitude/frequency tables |
| `adsynt2` | Like adsynt with amplitude interpolation |
| `ftmorph` | Morph between function tables |
| `sum` | Mix multiple audio signals |
| `expsegr` | Exponential envelope with release |
| `linsegr` | Linear envelope with release |

---

## Related Corpus Entries

- `csound_additive_synthesis_entry.md` - Basic additive synthesis theory
- `mccurdy_physical_models_entry.md` - Physical modeling (related modal concepts)
- `mccurdy_fm_pm_rm_am_entry.md` - FM synthesis (alternative to additive)
