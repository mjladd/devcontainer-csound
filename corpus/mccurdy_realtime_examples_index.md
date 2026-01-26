# Iain McCurdy Csound Realtime Examples - Index

## Metadata

- **Title:** Iain McCurdy Csound Realtime Examples Collection
- **Category:** Index / Reference
- **Source:** Iain McCurdy (http://iainmccurdy.org/csound.html)
- **License:** CC BY-NC-SA 4.0
- **Location:** csound_realtime/

---

## Overview

This is a comprehensive collection of approximately 580 Csound examples by Iain McCurdy, covering virtually every aspect of Csound synthesis and sound processing. Each example includes:
- Working .csd file with FLTK GUI
- Detailed comments explaining concepts
- MIDI integration where appropriate
- Practical, musical applications

---

## Category Index

### Synthesis Methods

| Category | Files | Corpus Entry |
|----------|-------|--------------|
| **Additive Synthesis** | 12 | `mccurdy_additive_synthesis_entry.md` |
| **Granular Synthesis** | 17 | `mccurdy_granular_synthesis_entry.md` |
| **Physical Models** | 30 | `mccurdy_physical_models_entry.md` |
| **FM/PM/RM/AM** | 21 | `mccurdy_fm_pm_rm_am_entry.md` |
| **Sound Generators** | ~20 | Various oscillator and noise generators |

### Signal Processing

| Category | Files | Corpus Entry |
|----------|-------|--------------|
| **FFT/Spectral** | 28 | `mccurdy_fft_entry.md` |
| **Filters** | 32 | `mccurdy_filters_entry.md` |
| **Delays** | 16 | `mccurdy_delays_entry.md` |
| **Reverbs** | 11 | `mccurdy_reverbs_entry.md` |
| **Distortion** | ~15 | Waveshaping, clipping, saturation |
| **Dynamics** | ~10 | Compressors, limiters, gates |

### Utilities and Control

| Category | Files | Corpus Entry |
|----------|-------|--------------|
| **GEN Routines** | 23 | `mccurdy_gen_entry.md` |
| **MIDI** | 23 | MIDI input, controllers, routing |
| **FLTK** | ~30 | GUI widget demonstrations |
| **Live Audio** | ~15 | Real-time audio input processing |
| **UDOs** | ~20 | User-defined opcodes |

### Specialized

| Category | Files | Description |
|----------|-------|-------------|
| **Cabbage** | 181 | Cabbage plugin versions |
| **Miscellaneous** | 50 | Various utilities and experiments |
| **3D Audio** | ~10 | Spatial audio, HRTF |
| **Convolution** | ~5 | Impulse response processing |

---

## Directory Structure

```
csound_realtime/
├── AdditiveSynthesis/      # Additive, wavetable, modal synthesis
├── GranularSynthesis/      # grain, syncgrain, fof, fog, sndwarp
├── PhysicalModels/         # Waveguide, STK, bar models
├── FM_PM_RM_AM/            # Modulation synthesis
├── FFT/                    # Spectral processing (PVS)
├── Filters/                # All filter types
├── Delays/                 # Delay effects
├── Reverbs/                # Reverb algorithms
├── GEN/                    # Function table generators
├── MIDI/                   # MIDI handling
├── FLTK/                   # GUI widgets
├── LiveAudioIn/            # Real-time input
├── LiveSampling/           # Buffer recording/playback
├── Distortion/             # Waveshaping, clipping
├── DynamicsProcessing/     # Compression, limiting
├── Convolution/            # Impulse responses
├── 3DAudio/                # Spatial audio
├── SoundFilePlayback/      # File reading
├── SoundGenerators/        # Basic oscillators
├── PitchTracking/          # Pitch detection
├── RandomNumberGenerators/ # Random/noise
├── RealtimeScoreGeneration/# Algorithmic composition
├── SpecializedFilters/     # Unusual filter types
├── Time/                   # Tempo, scheduling
├── UDOs/                   # User-defined opcodes
├── Waveguides/             # Waveguide basics
├── Cabbage/                # Cabbage plugin versions
└── Miscellaneous/          # Other examples
```

---

## Common Patterns Across Examples

### FLTK Interface Structure
```csound
FLcolor 255, 255, 255, 0, 0, 0
FLpanel "Example Name", width, height, x, y
; ... widgets ...
FLpanel_end
FLrun
```

### MIDI Integration
```csound
mididefault 1, 0  ; Enable MIDI with FLTK fallback
if gkOnOff==0 && iMIDIflag==0 then
    turnoff
endif
```

### Anti-Click Envelope
```csound
aenv linsegr 0, 0.01, 1, 0.1, 0
outs asig*aenv, asig*aenv
```

### Portamento Smoothing
```csound
kporttime linseg 0, 0.01, 0.05
kparam portk gkparam, kporttime
```

---

## Key Teaching Progressions

### Learning Synthesis
1. `SoundGenerators/` - Basic oscillators
2. `AdditiveSynthesis/` - Building timbre from partials
3. `FM_PM_RM_AM/` - Modulation techniques
4. `GranularSynthesis/` - Microsound
5. `PhysicalModels/` - Instrument modeling

### Learning Effects
1. `Filters/` - Basic filtering
2. `Delays/` - Time-based effects
3. `Reverbs/` - Spatial effects
4. `FFT/` - Spectral processing
5. `Distortion/` - Nonlinear processing

### Learning Csound
1. `GEN/` - Function tables
2. `FLTK/` - Building GUIs
3. `MIDI/` - MIDI control
4. `UDOs/` - Code organization
5. `RealtimeScoreGeneration/` - Algorithmic control

---

## About the Author

**Iain McCurdy** is a Csound expert and educator who has contributed extensively to the Csound community. His realtime examples collection has been a primary learning resource for Csound users worldwide since the mid-2000s.

---

## Related Resources

- Original website: http://iainmccurdy.org/csound.html
- Csound FLOSS Manual (co-authored)
- Csound Book Chapter 17: Csound Haiku
