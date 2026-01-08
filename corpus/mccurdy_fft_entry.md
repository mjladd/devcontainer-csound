# McCurdy FFT/Spectral Processing Examples

## Metadata

- **Title:** FFT and Spectral Processing Examples (McCurdy)
- **Category:** FFT / Spectral Processing / Phase Vocoder
- **Difficulty:** Intermediate to Advanced
- **Tags:** `fft`, `spectral`, `phase-vocoder`, `pvs`, `fsig`, `time-stretch`, `pitch-shift`, `cross-synthesis`, `vocoder`, `spectral-freeze`
- **Source:** Iain McCurdy Csound Realtime Examples
- **License:** CC BY-NC-SA 4.0
- **Original Location:** csound_realtime/FFT/

---

## Overview

FFT (Fast Fourier Transform) processing allows manipulation of sound in the frequency domain. Csound's streaming phase vocoder (PVS) system provides real-time spectral analysis and resynthesis with many transformation opcodes. This collection demonstrates spectral pitch shifting, time stretching, cross-synthesis, spectral freezing, and more.

---

## Core PVS Opcodes

### pvsanal_pvsynth
**File:** `pvsanal_pvsynth.csd`
**Author:** Iain McCurdy, 2007

**Description:** Foundation example demonstrating the core analysis/resynthesis pair. Audio → fsig → Audio with no modification (pass-through).

**Key Opcodes:** `pvsanal`, `pvsynth`

**Key Concept:**
- `pvsanal` converts audio to streaming FFT (fsig)
- `pvsynth` converts fsig back to audio
- These are the bookends for all PVS processing chains

**Default Settings:**
- FFT size: 1024
- Overlap: 256
- Window: Hanning

---

## Pitch and Time Manipulation

### pvscale
**File:** `pvscale.csd`
**Author:** Iain McCurdy

**Description:** Spectral pitch shifting - scales all frequencies in the spectrum by a ratio without changing duration.

**Key Opcodes:** `pvsanal`, `pvscale`, `pvsynth`

**Parameters:**
- Scale Factor - pitch multiplier (0.5 = octave down, 2 = octave up)

**Key Concept:** Unlike resampling, spectral pitch shift preserves duration.

---

### pvshift
**File:** `pvshift.csd`
**Author:** Iain McCurdy

**Description:** Spectral frequency shift - adds a fixed Hz offset to all frequencies rather than multiplying.

**Key Opcodes:** `pvsanal`, `pvshift`, `pvsynth`

**Parameters:**
- Shift Amount (Hz) - frequency offset to add

**Key Concept:** Unlike pitch scaling, this creates inharmonic spectra (ring modulation-like effects).

---

### temposcal
**File:** `temposcal.csd`
**Author:** Iain McCurdy

**Description:** Time stretching using `temposcal` opcode for independent tempo and pitch control.

**Key Opcodes:** `temposcal`

---

### mincer
**File:** `mincer.csd`
**Author:** Iain McCurdy

**Description:** High-quality time-stretch and pitch-shift using `mincer` - combines both in one opcode.

**Key Opcodes:** `mincer`

---

### pvswarp
**File:** `pvswarp.csd`
**Author:** Iain McCurdy

**Description:** Spectral warping - non-linear frequency scaling for formant-shifting effects.

**Key Opcodes:** `pvsanal`, `pvswarp`, `pvsynth`

---

## Cross-Synthesis and Morphing

### pvscross
**File:** `pvscross.csd`
**Author:** Iain McCurdy, 2009

**Description:** Cross-synthesis between two signals - applies spectral content of source to amplitude envelope of destination.

**Key Opcodes:** `pvsanal`, `pvscross`, `pvsynth`

**Parameters:**
- Source Amplitude (amp1) - blend of source spectral content
- Destination Amplitude (amp2) - blend of destination envelope
- Octave/Semitone transpose for source

**Key Concept:** Use harmonically rich source (synth pad, voice) with percussive destination (drums, speech) for classic vocoder-like effects.

---

### pvsmorph
**File:** `pvsmorph.csd`
**Author:** Iain McCurdy

**Description:** Spectral morphing between two signals with independent control of amplitude and frequency interpolation.

**Key Opcodes:** `pvsanal`, `pvsmorph`, `pvsynth`

---

### pvsvoc
**File:** `pvsvoc.csd`
**Author:** Iain McCurdy

**Description:** Vocoder-style cross-synthesis - spectral envelope of one signal applied to harmonics of another.

**Key Opcodes:** `pvsanal`, `pvsvoc`, `pvsynth`

---

### pvsfilter
**File:** `pvsfilter.csd`
**Author:** Iain McCurdy

**Description:** Uses one fsig as a spectral filter mask for another - creates dynamic spectral filtering effects.

**Key Opcodes:** `pvsanal`, `pvsfilter`, `pvsynth`

---

## Spectral Effects

### pvsfreeze
**File:** `pvsfreeze.csd`
**Author:** Iain McCurdy

**Description:** Freezes spectral content - captures a moment and sustains it indefinitely.

**Key Opcodes:** `pvsanal`, `pvsfreeze`, `pvsynth`

**Parameters:**
- Freeze toggle - captures current spectrum when activated

**Key Concept:** Creates drone/sustain from any transient sound.

---

### pvsblur
**File:** `pvsblur.csd`
**Author:** Iain McCurdy

**Description:** Spectral blurring - averages spectrum over time for smoothing/smearing effects.

**Key Opcodes:** `pvsanal`, `pvsblur`, `pvsynth`

---

### pvsmooth
**File:** `pvsmooth.csd`
**Author:** Iain McCurdy

**Description:** Smooths spectral amplitude and frequency changes over time with independent control.

**Key Opcodes:** `pvsanal`, `pvsmooth`, `pvsynth`

---

### pvsarp
**File:** `pvsarp.csd`
**Author:** Iain McCurdy

**Description:** Spectral arpeggiation - creates rhythmic effects by gating spectral bins.

**Key Opcodes:** `pvsanal`, `pvsarp`, `pvsynth`

---

## Spectral Filtering

### pvsbandp
**File:** `pvsbandp.csd`
**Author:** Iain McCurdy

**Description:** Spectral bandpass filter - passes frequencies within specified range.

**Key Opcodes:** `pvsanal`, `pvsbandp`, `pvsynth`

---

### pvsbandr
**File:** `pvsbandr.csd`
**Author:** Iain McCurdy

**Description:** Spectral band-reject (notch) filter - removes frequencies within specified range.

**Key Opcodes:** `pvsanal`, `pvsbandr`, `pvsynth`

---

### pvstencil
**File:** `pvstencil.csd`
**Author:** Iain McCurdy

**Description:** Spectral gating using a function table as threshold template.

**Key Opcodes:** `pvsanal`, `pvstencil`, `pvsynth`

---

## Buffer-Based Processing

### pvsbufread / pvsbufread2
**Files:** `pvsbufread.csd`, `pvsbufread2.csd`
**Author:** Iain McCurdy

**Description:** Records fsig to buffer for later playback with variable speed/position.

**Key Opcodes:** `pvsbuffer`, `pvsbufread`, `pvsbufread2`

**Key Concept:** Allows scrubbing through recorded spectral data.

---

## Analysis File Processing

### pvoc
**File:** `pvoc.csd`
**Author:** Iain McCurdy

**Description:** Classic phase vocoder using pre-analyzed .pvx files.

**Key Opcodes:** `pvoc`

---

### pvadd
**File:** `pvadd.csd`
**Author:** Iain McCurdy

**Description:** Additive resynthesis from phase vocoder analysis files.

**Key Opcodes:** `pvadd`

---

### pvsadsyn
**File:** `pvsadsyn.csd`
**Author:** Iain McCurdy

**Description:** Additive resynthesis from streaming fsig with control over partial selection.

**Key Opcodes:** `pvsanal`, `pvsadsyn`

---

### pvsfread
**File:** `pvsfread.csd`
**Author:** Iain McCurdy

**Description:** Reads pre-analyzed .pvx files into fsig for PVS processing chain.

**Key Opcodes:** `pvsfread`

---

### pvswrite
**File:** `pvswrite.csd`
**Author:** Iain McCurdy

**Description:** Writes fsig data to analysis file for later use.

**Key Opcodes:** `pvswrite`

---

## Advanced Analysis

### pvstanal
**File:** `pvstanal.csd`
**Author:** Iain McCurdy

**Description:** Streaming transient analysis for detecting onsets in spectral domain.

**Key Opcodes:** `pvstanal`

---

### pvspitch
**File:** `pvspitch.csd`
**Author:** Iain McCurdy

**Description:** Pitch detection from fsig - extracts fundamental frequency from spectral analysis.

**Key Opcodes:** `pvsanal`, `pvspitch`

---

### pvsifd_partials_resyn
**File:** `pvsifd_partials_resyn.csd`
**Author:** Iain McCurdy

**Description:** Instantaneous frequency distribution analysis with partial tracking and resynthesis.

**Key Opcodes:** `pvsifd`, `partials`, `resyn`

---

## ATS Processing

### ATSadd
**File:** `ATSadd.csd`
**Author:** Iain McCurdy

**Description:** Resynthesis from ATS (Analysis-Transformation-Synthesis) analysis files - high-quality spectral model representation.

**Key Opcodes:** `ATSread`, `ATSadd`, `ATSaddnz`

---

## Key Concepts

### fsig Signal Type
The `fsig` is Csound's streaming FFT data type:
- Carries both amplitude and frequency for each bin
- Flows through PVS processing chain
- Cannot be directly mixed with audio signals

### FFT Parameters
- **FFT Size:** Analysis window size (power of 2: 512, 1024, 2048)
  - Larger = better frequency resolution, worse time resolution
  - Smaller = better time resolution, worse frequency resolution
- **Overlap:** How much windows overlap (typically 1/4 of FFT size)
- **Window Type:** Usually Hanning or Hamming

### Processing Chain
```
Audio → pvsanal → [PVS Opcodes] → pvsynth → Audio
```

---

## Key Opcodes Reference

| Opcode | Purpose |
|--------|---------|
| `pvsanal` | Audio to fsig analysis |
| `pvsynth` | fsig to audio resynthesis |
| `pvscale` | Pitch scaling |
| `pvshift` | Frequency shift |
| `pvscross` | Cross-synthesis |
| `pvsmorph` | Spectral morphing |
| `pvsfreeze` | Spectral freeze |
| `pvsblur` | Spectral blur |
| `pvsmooth` | Spectral smoothing |
| `pvsbandp` | Spectral bandpass |
| `pvsbandr` | Spectral band-reject |
| `pvsbuffer` | Record fsig to buffer |
| `pvsbufread` | Read from fsig buffer |
| `mincer` | Time-stretch/pitch-shift |
| `temposcal` | Tempo scaling |

---

## Related Corpus Entries

- `floss_manual/chapters/05-k-ats-resynthesis.md` - ATS resynthesis
- `csound_fft_entry.md` - FFT processing theory
- `mccurdy_granular_synthesis_entry.md` - Alternative time-stretch techniques

