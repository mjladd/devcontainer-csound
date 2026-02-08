# FOF Tutorial (Clarke)

## Metadata

- **Title:** FOF Synthesis Tutorial - Parameter Exploration Guide
- **Category:** Formant Synthesis / Vocal Synthesis / Tutorial
- **Difficulty:** Intermediate to Advanced
- **Tags:** `fof`, `formant-synthesis`, `vocal-synthesis`, `parameter-exploration`, `grains`, `formants`, `tutorial`, `granular`, `singing-voice`
- **Source:** J.M. Clarke, University of Huddersfield (CSound Manual 3.48b1 Tutorial)
- **Original URL:** https://www.classes.cs.uchicago.edu/archive/1999/spring/CS295/Computing_Resources/Csound/CsManual3.48b1.HTML/Tutorial/foftut.html

---

## Description

This tutorial by J.M. Clarke from the University of Huddersfield provides a systematic introduction to FOF (Function-On-Frequency) synthesis in Csound through methodical parameter exploration. It focuses on understanding how each FOF parameter affects the resulting sound, making it an excellent resource for learning the opcode through experimentation.

**Key Focus Areas:**
- Understanding each FOF parameter's role
- Parameter rate differences (audio, control, initialization)
- Granule behavior at different frequency ranges
- Practical synthesis insights

---

## FOF Opcode Syntax

The complete FOF specification:

```csound
ar fof xamp xfund xform koct kband kris kdur kdec iolaps ifna ifnb itotdur [iphs] [ifmode]
```

### Parameter Rate Types

| Parameter | Rate | Description |
|-----------|------|-------------|
| xamp | a/k/i | Amplitude |
| xfund | a/k/i | Fundamental frequency |
| xform | a/k/i | Formant frequency |
| koct | k/i | Octaviation index |
| kband | k/i | Bandwidth |
| kris | k/i | Rise time |
| kdur | k/i | Grain duration |
| kdec | k/i | Decay time |
| iolaps | i | Number of overlap spaces |
| ifna | i | Amplitude function table |
| ifnb | i | Frequency function table |
| itotdur | i | Total duration |
| iphs | i (opt) | Initial phase |
| ifmode | i (opt) | Formant mode |

---

## Detailed Parameter Explanations

### Amplitude Control (xamp)

Varies output loudness. Can use line functions for dynamic amplitude changes over time. Higher values produce louder output.

### Fundamental Frequency (xfund)

Controls both the perceived pitch and the granule creation speed.

**Important behavior:**
- Extremely low fundamental values produce audible individual granules rather than continuous pitch perception
- At higher fundamentals, granules merge into a continuous timbre
- The fundamental determines the grain repetition rate

### Octaviation Index (koct)

Each unit increase drops pitch by one octave through fading alternate excitations.

**Note:** This is NOT a traditional glissando - it works by progressively silencing alternating grain excitations, creating octave divisions.

### Formant Frequency (xform) and Mode (ifmode)

Creates the spectral peak above the fundamental frequency.

**Mode behavior:**
- **Mode 0:** Formant frequency changes occur at excitation start (stepped, discontinuous)
- **Non-zero mode:** Allows continuous glissandi of the formant frequency

Use non-zero mode when smooth formant transitions are required.

### Bandwidth (kband)

Controls the width of the formant peak:
- Narrow bandwidth = sharp, well-defined formant
- Wide bandwidth = diffuse, broader formant

**Spectral relationship:** Bandwidth relates inversely to the local envelope length.

### Envelope Parameters (kris, kdur, kdec)

These three parameters shape each individual grain:

| Parameter | Function |
|-----------|----------|
| kris | Rise/attack segment duration |
| kdur | Overall grain length |
| kdec | Terminating decay duration |

**Perceptual effects:**
- At low fundamentals: These affect the perceived amplitude envelope of individual grains
- At higher frequencies: They primarily affect the timbre character

**Important:** Proper decay values (kdec) prevent discontinuities in the output signal.

### Overlaps (iolaps)

The number of simultaneous grains that can overlap.

**Calculation formula:**
```
required_overlaps = fundamental_frequency × grain_duration
```

**Critical warning:** Insufficient overlap spaces will terminate the note prematurely. Always allocate enough overlap spaces for the expected fundamental and duration ranges.

### Duration (itotdur)

The total duration for grain generation. Should typically match or exceed the instrument's p3 duration.

---

## Practical Synthesis Insights

### Complex Vocal Imitation

**Key insight:** Complex, realistic vocal imitations require **five or more FOF generators** running simultaneously, each with slightly varied parameters:
- Different formant frequencies (F1, F2, F3, F4, F5)
- Varied amplitude weightings
- Slight detuning for richness

### Granule Perception Thresholds

- **Very low fundamentals (< 20 Hz):** Individual granules become audible as discrete events
- **Mid-range fundamentals (50-500 Hz):** Granules fuse into continuous pitched tones
- **Higher fundamentals:** Granules merge completely, affecting only timbre

### Bandwidth-Envelope Relationship

The spectral bandwidth of a formant is inversely related to the grain envelope length:
- Longer grain envelopes = narrower spectral bandwidth
- Shorter grain envelopes = wider spectral bandwidth

This follows from Fourier analysis principles.

---

## Example: Basic FOF Exploration

```csound
<CsoundSynthesizer>
<CsOptions>
-o fof_exploration.wav
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 10
nchnls = 2
0dbfs = 1

; Basic FOF exploration instrument
instr 1
    iamp = p4
    ifund = p5
    iform = p6

    ; Amplitude envelope
    aamp linseg 0, 0.1, iamp, p3-0.2, iamp, 0.1, 0

    ; Generate FOF
    ; xamp  xfund  xform  koct kband kris  kdur  kdec  iolaps ifna ifnb itotdur
    a1 fof aamp,  ifund, iform, 0,   40,   0.003, 0.02, 0.007, 100,  1,   2,   p3, 0, 1

    outs a1, a1
endin

</CsInstruments>
<CsScore>
; Function tables for FOF
f1 0 4096 19 0.5 0.5 270 0.5    ; Sinusoidal grain
f2 0 4096 19 0.5 0.5 270 0.5    ; Frequency envelope

; Explore different formant frequencies
;     start dur  amp   fund  formant
i1    0     2    0.3   220   500      ; Low formant
i1    2.5   2    0.3   220   800      ; Mid formant
i1    5     2    0.3   220   1200     ; High formant
i1    7.5   2    0.3   220   2000     ; Very high formant

; Explore different fundamentals
i1    10    2    0.3   100   700      ; Low pitch
i1    12.5  2    0.3   220   700      ; Mid pitch
i1    15    2    0.3   440   700      ; High pitch

; Very low fundamental - hear individual grains
i1    17.5  3    0.3   10    500      ; Audible granules
</CsScore>
</CsoundSynthesizer>
```

---

## Key Concepts Summary

1. **Rate flexibility:** Many FOF parameters accept audio, control, or init-rate inputs, allowing various modulation approaches

2. **Octaviation vs. pitch:** Octaviation parameter creates octave drops through grain silencing, not pitch gliding

3. **Formant mode:** Mode 0 gives stepped formant changes; non-zero mode allows continuous formant glides

4. **Overlap calculation:** Always ensure iolaps >= fundamental × duration to prevent premature note termination

5. **Multi-generator approach:** Realistic vocals require 5+ parallel FOF generators with different formant frequencies

6. **Spectral bandwidth:** Controlled by grain envelope length (inverse relationship)

---

## Related Examples

- `csound_fof_formant_synthesis_entry.md` - Comprehensive FOF synthesis with complete code examples
- `csound_granular_synthesis_entry.md` - Related grain-based synthesis techniques
- `csound_additive_synthesis_entry.md` - Alternative approach to spectral construction

---

## References

- Clarke, J.M. - FOF Tutorial, University of Huddersfield
- CSound Manual 3.48b1 Tutorial Documentation
- Rodet, Xavier - Original FOF synthesis research at IRCAM
