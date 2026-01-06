# Granular Synthesis with Dynamic Parameters

## Metadata

- **Title:** Granular Synthesis with Dynamic Parameters
- **Category:** Granular Synthesis / Sound Design
- **Difficulty:** Intermediate
- **Tags:** `grain`, `granular`, `linseg`, `expon`, `line`, `GEN20`, `hanning-window`, `sound-design`, `texture`, `evolving-sound`
- **Source File:** `02_grain.csd`

---

## Description

This example demonstrates granular synthesis using Csound's `grain` opcode with extensive parameter modulation. Granular synthesis creates complex, evolving textures by playing many short "grains" of sound that can vary in density, pitch, amplitude, and duration over time. This instrument showcases how to create dynamic, organic-sounding textures by modulating all grain parameters simultaneously.

**Use Cases:**
- Creating evolving soundscapes and ambient textures
- Sound design for film/game audio
- Experimental electronic music
- Simulating natural phenomena (wind, water, swarms)
- Transforming simple waveforms into complex timbres

---

## Complete Code

```csound
<CsoundSynthesizer>
<CsOptions>
-o 02_grain.aiff
</CsOptions>
<CsInstruments>
 sr = 44100
 ksmps = 100
 nchnls    =         1
 0dbfs = 32768
 
           instr     2
 k2        linseg    p5, p3/2, p9, p3/2, p5
 k3        line      p10, p3, p11
 k4        line      p12, p3, p13
 k5        expon     p14, p3, p15
 k6        expon     p16, p3, p17
 a1        grain     p4, k2, k3, k4, k5, k6, 1, p6, 1
 a2        linen     a1, p7, p3, p8
           out       a2
           endin
 
</CsInstruments>
<CsScore>
;============================================================================================
 ;FUNCTION 1 (f1) USES THE GEN10 SUBROUTINE TO COMPUTE A SINE WAVE
 ;FUNCTION 3 USES THE GEN20 SUBROUTINE TO COMPUTE A HANNING WINDOW FOR USE AS A GRAIN ENVELOPE
 ;============================================================================================
   f1  0   4096   10   1    
   f3  0   4097   20   2  1
 ;============================================================================================
 ; p1  p2   p3  p4   p5   p6  p7  p8  p9   p10   p11   p12    p13    p14    p15    p16   p17  
 ;============================================================================================
 ; INS STRT DUR AMP  FRQ  FN  ATK REL BEND DENS1 DENS2 AMPOF1 AMPOF2 PCHOF1 PCHOF2 GDUR1 GDUR2
 ;============================================================================================
   i2  0    5   1000 440  3   1   .1  430  12000 4000  120    50     .01   .05    .1    .01 
   i2  6    10  4000 1760 3   5   .1  60   5     200   500    1000    10    20000  1    .01
 ;============================================================================================
 
</CsScore>
</CsoundSynthesizer>
```

---

## Detailed Explanation

### Orchestra Header

```csound
sr = 44100      ; Sample rate
ksmps = 100     ; Higher ksmps for granular (reduces CPU load)
nchnls = 1      ; Mono output
0dbfs = 32768   ; 16-bit amplitude reference
```

**Note:** `ksmps = 100` is higher than the previous example (32). Granular synthesis is CPU-intensive, so a higher ksmps reduces the control rate update frequency, making it more efficient while still allowing smooth parameter changes.

### Instrument 2 Breakdown

#### Parameter Modulation Lines

```csound
k2 linseg p5, p3/2, p9, p3/2, p5
```
**Frequency modulation** - Creates a frequency "bend"
- `k2` - Output: modulated frequency
- `p5` - Starting frequency
- `p3/2` - Time to reach midpoint (half the note duration)
- `p9` - Midpoint frequency (the "bend" target)
- `p3/2` - Time to return to start
- `p5` - Ending frequency (back to start)

This creates an arc: start → bend up/down → return to start

```csound
k3 line p10, p3, p11
```
**Grain density modulation** - How many grains per second
- Linear interpolation from `p10` (initial density) to `p11` (final density)
- Higher density = more grains = denser texture
- Typical range: 5-20000 grains/second

```csound
k4 line p12, p3, p13
```
**Amplitude offset modulation** - Random amplitude variation for each grain
- Linear interpolation from `p12` to `p13`
- Controls how much each grain's amplitude can randomly vary
- Creates amplitude "shimmer" or roughness

```csound
k5 expon p14, p3, p15
```
**Pitch offset modulation** - Random pitch variation (exponential)
- Exponential interpolation from `p14` to `p15`
- Exponential is appropriate for pitch (we hear pitch logarithmically)
- Creates pitch "cloud" or spread around the base frequency

```csound
k6 expon p16, p3, p17
```
**Grain duration modulation** - Length of each grain (exponential)
- Exponential interpolation from `p16` to `p17`
- Longer grains = smoother, more sustained sound
- Shorter grains = granular, "dusty" texture
- Typical range: 0.001 - 1.0 seconds

#### Grain Generator

```csound
a1 grain p4, k2, k3, k4, k5, k6, 1, p6, 1
```
**grain opcode** - The core granular synthesis engine

Parameters in order:
1. `p4` - Overall amplitude
2. `k2` - Base frequency (modulated)
3. `k3` - Grain density (grains per second, modulated)
4. `k4` - Amplitude offset (random variation, modulated)
5. `k5` - Pitch offset (random variation, modulated)
6. `k6` - Grain duration (modulated)
7. `1` - Source waveform function table (f1 = sine wave)
8. `p6` - Grain envelope function table (f3 = Hanning window)
9. `1` - Maximum grain overlap (conservative setting)

#### Output Envelope

```csound
a2 linen a1, p7, p3, p8
```
**Overall amplitude envelope** - Shapes the entire granular cloud
- `p7` - Attack time (fade in)
- `p8` - Release time (fade out)
- Applied to the entire grain stream

```csound
out a2
```
Send to output

### Score Section

#### Function Tables

```csound
f1  0   4096   10   1
```
**Grain source waveform** - Sine wave
- Each grain reads from this table
- Simple sine wave creates pure, smooth grains
- Could use any waveform (sawtooth, noise, samples, etc.)

```csound
f3  0   4097   20   2  1
```
**Grain envelope** - Hanning window
- `GEN20` - Window function generator
- `2` - Hanning window type
- `1` - Normalization flag
- Size 4097 (power of 2 + 1, recommended for windows)

**Why Hanning?** Smooth rise and fall prevents clicks when grains start/stop

#### Note Events

**p-field mapping:**
- p1 = Instrument (2)
- p2 = Start time
- p3 = Duration
- p4 = Amplitude
- p5 = Starting frequency
- p6 = Grain envelope function table
- p7 = Attack time
- p8 = Release time
- p9 = Frequency bend target
- p10 = Initial grain density
- p11 = Final grain density
- p12 = Initial amplitude offset
- p13 = Final amplitude offset
- p14 = Initial pitch offset
- p15 = Final pitch offset
- p16 = Initial grain duration
- p17 = Final grain duration

**Event 1 Analysis:**
```csound
i2  0    5   1000 440  3   1   .1  430  12000 4000  120    50     .01   .05    .1    .01
```
- **0-5 seconds**, moderate amplitude (1000)
- **Frequency:** 440Hz → 430Hz (slight downward bend) → 440Hz
- **Density:** 12000 → 4000 grains/sec (thinning out)
- **Amp offset:** 120 → 50 (less amplitude variation)
- **Pitch offset:** 0.01 → 0.05 (increasing pitch spread/detuning)
- **Grain duration:** 0.1 → 0.01 sec (shorter grains = grainier texture)
- **Result:** Dense cloud that becomes sparser and grainier with wider pitch spread

**Event 2 Analysis:**
```csound
i2  6    10  4000 1760 3   5   .1  60   5     200   500    1000    10    20000  1    .01
```
- **6-16 seconds** (10 sec duration), louder (4000)
- **Frequency:** 1760Hz (A6, two octaves up) → 60Hz (extreme downward bend) → 1760Hz
- **Density:** 5 → 200 grains/sec (sparse to moderate)
- **Amp offset:** 500 → 1000 (increasing amplitude variation)
- **Pitch offset:** 10 → 20000 (HUGE pitch spread - from tight to extremely wide)
- **Grain duration:** 1 → 0.01 sec (from smooth to very granular)
- **Attack:** 5 seconds (slow fade in)
- **Result:** Dramatic transformation from sparse, smooth grains to dense, chaotic cloud with extreme pitch variation

---

## Key Concepts

### Granular Synthesis Fundamentals

**What is a grain?**
A grain is a short burst of sound (typically 1-100ms) with:
1. A waveform (from a function table)
2. An envelope (usually a window function to avoid clicks)
3. A specific pitch and amplitude

**Grain Parameters:**
- **Density** - How many grains per second (5 = sparse, 10000+ = very dense)
- **Duration** - Length of each grain (longer = smoother, shorter = grainier)
- **Pitch offset** - Random pitch variation around the base frequency
- **Amplitude offset** - Random amplitude variation

### Envelope Types for Parameter Modulation

**linseg** - Multi-segment linear envelope
```csound
k2 linseg p5, p3/2, p9, p3/2, p5
; start → midpoint → end with linear interpolation
```

**line** - Simple two-point linear envelope
```csound
k3 line p10, p3, p11
; start → end, linear
```

**expon** - Exponential envelope
```csound
k5 expon p14, p3, p15
; start → end, exponential curve
; Better for pitch and duration (logarithmic perception)
; WARNING: Cannot use 0 or negative values!
```

### GEN20 - Window Functions

GEN20 generates various window functions useful for grain envelopes:
- **Type 1** - Hamming window
- **Type 2** - Hanning window (most common for grains)
- **Type 3** - Bartlett (triangular)
- **Type 4** - Blackman
- **Type 5** - Blackman-Harris

Hanning (type 2) is most common because it:
- Smooth rise and fall
- Good frequency response
- Prevents clicks at grain boundaries

---

## Understanding the Grain Parameters

### Grain Density (grains/second)

- **< 10** - Individual grains audible, rhythmic
- **10-100** - Granular texture, still somewhat discrete
- **100-1000** - Dense cloud, pitch starts to emerge
- **1000+** - Very dense, smooth sustained tone
- **10000+** - Extremely dense, can sound like continuous tone

### Grain Duration (seconds)

- **0.001-0.01** - Very short, noisy/sandy texture
- **0.01-0.05** - Classic granular sound
- **0.05-0.1** - Smooth grains, clearer pitch
- **0.1-1.0** - Long grains, almost continuous
- **> 1.0** - Overlapping sustained tones

### Pitch Offset

- **0.01** - Subtle detuning, chorus-like
- **0.1** - Noticeable pitch cloud
- **1-10** - Wide pitch spread, inharmonic
- **100+** - Extreme randomization, noise-like
- **10000+** - Complete pitch chaos

### Amplitude Offset

- **< 50** - Subtle amplitude variation
- **50-500** - Noticeable shimmer
- **500-1000** - Strong amplitude variation
- **> 1000** - Extreme dynamics, sputtering effect

---

## Variations

### Reverse Grain Playback

```csound
; Negative grain duration for backwards grains
k6 expon -p16, p3, -p17
```

### Stereo Granular Cloud

```csound
nchnls = 2
a1 grain p4, k2, k3, k4, k5, k6, 1, p6, 1
a2 grain p4*0.8, k2*1.01, k3, k4, k5, k6, 1, p6, 1  ; Slightly detuned
outs a1, a2
```

### Using Recorded Sound as Grain Source

```csound
; Load a sound file into a table
f1 0 0 1 "soundfile.wav" 0 0 0

; Use grain3 for more control over playback position
a1 grain3 k2, k3, k4, k5, k6, k7, 100, 1, p6, 0.5
```

### Dynamic Density Based on Frequency

```csound
; Higher pitches have higher density
k3 = k2 * 10  ; Density proportional to frequency
```

### Adding Vibrato to Grain Frequency

```csound
kvib oscil 5, 4, 1  ; 4Hz vibrato, ±5Hz depth
k2 linseg p5+kvib, p3/2, p9+kvib, p3/2, p5+kvib
```

### Using Different Window Functions

```csound
; Hamming window (slightly different character)
f3 0 4097 20 1 1

; Blackman window (smoother, less artifacts)
f3 0 4097 20 4 1
```

### Exponential Density Changes

```csound
k3 expon p10, p3, p11  ; Exponential density curve
; Creates more dramatic density shifts
```

---

## Common Issues & Solutions

### Clicking or Popping Sounds
**Problem:** Audible clicks between grains  
**Cause:** Grain envelope not smooth enough or grain duration too short  
**Solution:** 
- Use Hanning or Blackman window (GEN20 types 2 or 4)
- Increase minimum grain duration to at least 0.01s
- Ensure grain envelope table size is power of 2 + 1 (4097, 8193, etc.)

### CPU Overload
**Problem:** Audio dropouts, "can't keep up" errors  
**Cause:** Too many grains or too low ksmps  
**Solution:**
- Increase ksmps (try 128 or 256 for granular)
- Reduce grain density (< 5000 grains/sec)
- Limit number of simultaneous grain instruments
- Use simpler source waveforms

### Inaudible or Very Quiet Output
**Problem:** Little or no sound produced  
**Cause:** Grain parameters outside usable ranges  
**Solution:**
- Check amplitude (p4) is reasonable (500-5000)
- Ensure grain duration > 0.001s
- Verify frequency is in audible range (20-20000 Hz)
- Make sure density > 5 grains/second

### Harsh or Noisy Texture
**Problem:** Output sounds too harsh or distorted  
**Cause:** Excessive amplitude offset or pitch offset  
**Solution:**
- Reduce amplitude offset (try < 200)
- Reduce pitch offset (try < 1.0 for smoother sound)
- Ensure grain envelope is properly normalized

### Pitch Not Clear or Recognizable
**Problem:** Cannot hear clear pitch  
**Cause:** Pitch offset too high or density too low  
**Solution:**
- Reduce pitch offset to < 0.1 for clearer pitch
- Increase grain density to > 100 grains/second
- Use longer grain durations (> 0.05s)

### Expon Opcode Errors
**Problem:** "error: expon: invalid start or end value"  
**Cause:** expon cannot interpolate to/from zero or negative values  
**Solution:**
- Use small positive values instead of 0 (e.g., 0.001 instead of 0)
- Use line instead of expon if zero values needed
```csound
; WRONG: k5 expon 0.01, p3, 0    ; Cannot end at 0
; RIGHT: k5 expon 0.01, p3, 0.001  ; End at very small value
; OR:    k5 line 0.01, p3, 0       ; Use line for zero
```

---

## Sound Design Applications

### Creating Different Textures

**Sparse, Pointillistic:**
```
Density: 5-50
Duration: 0.01-0.05
Pitch offset: 0.1-1.0
```

**Dense Clouds:**
```
Density: 1000-10000
Duration: 0.05-0.2
Pitch offset: 0.01-0.1
```

**Smooth, Sustained:**
```
Density: 500-2000
Duration: 0.1-0.5
Pitch offset: 0.01-0.05
Amplitude offset: 50-200
```

**Chaotic, Evolving:**
```
Density: varying rapidly (50-5000)
Duration: varying (0.01-0.5)
Pitch offset: high (10-1000)
Amplitude offset: high (500-2000)
```

---

## Related Examples

**Progression Path:**
1. **Current:** Basic grain opcode with parameter modulation
2. **Next:** `grain2` - Asynchronous granular synthesis with separate grain rate
3. **Then:** `grain3` - Full control over grain playback position (for time-stretching)
4. **Advanced:** `partikkel` - Ultimate granular synthesis control

**Related Techniques:**
- `Time-stretching with grain3` - Play audio slower/faster without pitch change
- `Granular Freeze Effect` - Loop small section of audio infinitely
- `Granular Reverb` - Using grains to create reverberation
- `Particle System Synthesis` - Multiple grain streams with spatial distribution

**Related Opcodes:**
- `grain2` - Pitch-shifted granular synthesis
- `grain3` - Granular synthesis with waveform scanning
- `fof` - Formant wave function (singing synthesis)
- `partikkel` - Advanced granular synthesis with per-grain control
- `sndwarp` - Time-stretching with grain-based technique

---

## Performance Notes

- **CPU Usage:** High - granular synthesis is computationally expensive
- **Polyphony:** Limit to 5-10 simultaneous instances depending on grain density
- **Real-time Safe:** Yes, but requires careful parameter ranges
- **Latency:** Determined by ksmps (100 samples ≈ 2.3ms at 44.1kHz)
- **Optimization Tips:**
  - Use higher ksmps (128-256) for granular
  - Keep density < 5000 for real-time performance
  - Use simple source waveforms (sine > complex tables)
  - Limit simultaneous grain instruments

---

## Advanced Topics

### Mathematical Relationships

**Grain Duration vs Density:**
For smooth textures, ensure grains overlap:
```
grain_duration > 1 / grain_density
```
Example: At 100 grains/sec, use duration > 0.01s

**Pitch Offset Range:**
The actual frequency range for each grain is:
```
frequency ± (frequency * pitch_offset)
```
Example: 440Hz with offset 0.1 = 396-484 Hz range

### Memory Considerations

Each active grain uses memory. At high densities:
```
max_grains = grain_density * grain_duration
```
Example: 1000 grains/sec × 0.1s duration = 100 simultaneous grains

---

## Extended Documentation

**Official Csound Opcode References:**
- [grain](https://csound.com/docs/manual/grain.html)
- [grain2](https://csound.com/docs/manual/grain2.html)
- [grain3](https://csound.com/docs/manual/grain3.html)
- [linseg](https://csound.com/docs/manual/linseg.html)
- [expon](https://csound.com/docs/manual/expon.html)
- [GEN20](https://csound.com/docs/manual/GEN20.html)

**Learning Resources:**
- Csound FLOSS Manual: Chapter 5.6 (Granular Synthesis)
- The Csound Book: "Granular Synthesis" by Barry Truax
- Roads, Curtis: "Microsound" (seminal text on granular synthesis)

**Historical Note:**
Granular synthesis was pioneered by Iannis Xenakis and Curtis Roads. The technique is based on Gabor's quantum theory of sound, treating sound as composed of "sound quanta" or grains.
