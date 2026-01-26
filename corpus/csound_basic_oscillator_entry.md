# Basic Oscillator with Linear Envelope

## Metadata

- **Title:** Basic Oscillator with Linear Envelope (Classic Table-Lookup Synthesis)
- **Category:** Fundamentals / Oscillators
- **Difficulty:** Beginner
- **Tags:** `oscil`, `linen`, `envelope`, `table-lookup`, `sine-wave`, `sawtooth`, `GEN10`, `basic-synthesis`, `additive`
- **Source File:** `01_osc.csd`

---

## Description

This is a foundational Csound example demonstrating simple table-lookup oscillator synthesis with amplitude envelopes. It shows how to create basic waveforms using function tables and shape their amplitude over time. This pattern is the building block for most Csound synthesis techniques.

**Use Cases:**
- Learning basic Csound syntax and structure
- Creating simple tones and musical notes
- Understanding waveform generation through additive synthesis
- Building blocks for more complex instruments

---

## Complete Code

```csound
<CsoundSynthesizer>
<CsOptions>
-o 01_osc.aiff
</CsOptions>
<CsInstruments>
 sr = 44100
 ksmps = 32
 nchnls    =         1					      ; OUTPUT CHANNELS
 0dbfs     =         32768
           instr     1					      ; DEFINE INSTRUMENT 1
 k1        linen     p4, p7, p3, p8		; AMPLITUDE ENVELOPE
 a1        oscil     k1, p5, p6			  ; TABLE-LOOKUP OSCILLATOR
           out       a1					      ; OUTPUT
           endin							        ; END INSTRUMENT 1
</CsInstruments>
<CsScore>
; FUNCTION 1 USES THE GEN10 SUBROUTINE TO COMPUTE A (4096 POINT) SINE WAVE
; FUNCTION 2 USES THE GEN10 SUBROUTINE TO COMPUTE FIRST SIXTEEN PARTIALS OF A SAWTOOTH
 f1  0 4096 10 1
 f2  0 4096 10 1 .5 .333 .25 .2 .166 .142 .125 .111 .1 .09 .083 .076 .071 .066 .062
 ;================================================================
 ; P1   P2     P3        P4      P5      P6       P7      P8
 ; INS  START  DURATION  AMP     FREQ    F-TABLE  ATTACK  RELEASE
 ;================================================================
   i1   0      2         20000   440     1        1       1
   i1   2.5    2         16000   220     2        0.1     1.99
   i1   5      4         11000   110     2        3.9     0.1
   i1   10     10        10000   138.6   2        9       1
   i1   10     10        9000    329.6   1        5       5
   i1   10     10        8000    440     1        1       9
</CsScore>
</CsoundSynthesizer>
```

---

## Detailed Explanation

### Orchestra Header

```csound
sr = 44100      ; Sample rate (44.1kHz, CD quality)
ksmps = 32      ; Control rate: sr/ksmps = ~1378 Hz
nchnls = 1      ; Mono output
0dbfs = 32768   ; 0dB full scale reference (16-bit amplitude range)
```

- **sr (sample rate):** Number of audio samples per second. 44100 is standard CD quality.
- **ksmps (k-rate samples):** How many audio samples per control cycle. Higher = less CPU but lower control resolution.
- **nchnls:** Number of output channels (1=mono, 2=stereo, etc.)
- **0dbfs:** Maximum amplitude before clipping. 32768 is for 16-bit audio range.

### Instrument 1 Breakdown

```csound
k1 linen p4, p7, p3, p8
```
**Linear envelope generator** - Creates amplitude contour over time
- `k1` - k-rate output variable (control rate envelope)
- `p4` - Peak amplitude (maximum volume)
- `p7` - Attack time (rise from 0 to peak, in seconds)
- `p3` - Total duration (from score)
- `p8` - Release time (decay from peak to 0, in seconds)

The sustain portion is: `p3 - (p7 + p8)`

```csound
a1 oscil k1, p5, p6
```
**Table-lookup oscillator** - Reads through waveform table at specified frequency
- `a1` - a-rate output variable (audio rate signal)
- `k1` - Amplitude modulation (from envelope)
- `p5` - Frequency in Hz
- `p6` - Function table number to read

```csound
out a1
```
**Output** - Sends audio signal to the output channel(s)

### Score Section

#### Function Tables

```csound
f1  0 4096 10 1
```
**Sine wave table**
- `f1` - Function table #1
- `0` - Generation time (0 = before performance)
- `4096` - Table size (number of points, power of 2 recommended)
- `10` - GEN10 routine (additive synthesis)
- `1` - Single partial with amplitude 1 (pure sine wave)

```csound
f2  0 4096 10 1 .5 .333 .25 .2 .166 .142 .125 .111 .1 .09 .083 .076 .071 .066 .062
```
**Sawtooth wave table**
- Uses GEN10 with 16 harmonics
- Amplitudes follow 1/n series (1, 1/2, 1/3, 1/4, ...)
- Creates sawtooth-like waveform through additive synthesis
- More harmonics = closer to ideal sawtooth

#### Note Events

**p-field mapping:**
- p1 = Instrument number
- p2 = Start time (seconds)
- p3 = Duration (seconds)
- p4 = Amplitude
- p5 = Frequency (Hz)
- p6 = Function table number
- p7 = Attack time (seconds)
- p8 = Release time (seconds)

**Event Analysis:**

```csound
i1   0      2         20000   440     1        1       1
```
Pure sine tone (table 1), A440, 2 seconds, balanced 1s attack/release

```csound
i1   2.5    2         16000   220     2        0.1     1.99
```
Sawtooth (table 2), A220 (octave lower), quick attack, long release

```csound
i1   5      4         11000   110     2        3.9     0.1
```
Sawtooth, A110 (two octaves down), slow swell then sudden cut

```csound
i1   10     10        10000   138.6   2        9       1
i1   10     10        9000    329.6   1        5       5
i1   10     10        8000    440     1        1       9
```
Three-note chord starting at t=10:
- 138.6 Hz (≈C#3) - sawtooth, slow attack
- 329.6 Hz (≈E4) - sine, balanced envelope
- 440 Hz (A4) - sine, slow release

---

## Key Concepts

### P-fields (Score Parameters)
Score parameters are passed to instruments via p-fields:
- **p1** - Always instrument number
- **p2** - Always start time
- **p3** - Always duration
- **p4+** - Custom parameters defined by the instrument

Access in orchestra with `p4`, `p5`, etc.

### Signal Rate Types

**k-rate (control rate):**
- Updated every ksmps samples
- Used for envelopes, LFOs, parameter control
- Less CPU intensive
- Variable names start with `k`

**a-rate (audio rate):**
- Updated every sample
- Used for audio signals
- More CPU intensive but necessary for sound
- Variable names start with `a`

### GEN Routines

**GEN10 - Additive Synthesis:**
- Builds waveforms from sine wave partials
- Each number after GEN10 is a partial amplitude
- First number = fundamental, second = 2nd harmonic, etc.
- `f1 0 4096 10 1` = sine wave (fundamental only)
- `f2 0 4096 10 1 0.5 0.333 0.25` = sawtooth approximation (4 partials)

### Envelope Types

**linen** - Linear envelope with attack and release
- Simple, predictable
- Can sound "mechanical" for natural instruments
- Good for: synthetic sounds, learning, precise control

---

## Variations

### Exponential Envelope (More Natural)

```csound
k1 linenr p4, p7, p8, 0.01  ; r = exponential release
```

### ADSR Envelope

```csound
k1 madsr 0.1, 0.2, 0.7, 0.5  ; Attack, Decay, Sustain, Release
a1 oscil k1*p4, p5, p6
```

### Better Interpolation Oscillator

```csound
a1 poscil k1, p5, p6  ; Phase-locked, better for pitch modulation
```

### Add Vibrato

```csound
kvib oscil 5, 6, 1           ; 6Hz vibrato, ±5Hz depth
a1 oscil k1, p5+kvib, p6
```

### Stereo Output

```csound
nchnls = 2
outs a1, a1  ; Send same signal to both channels
; or
outs a1*0.7, a1*0.3  ; Pan left
```

### Modern Amplitude Reference

```csound
0dbfs = 1.0   ; Modern normalized amplitude
; Then use p4 values like 0.5, 0.8, etc.
```

---

## Common Issues & Solutions

### Clicks at Note Boundaries
**Problem:** Audible clicks when notes start/stop
**Cause:** Envelope attack/release times too short or zero
**Solution:** Use minimum 0.01s for release, 0.001s for attack
```csound
k1 linen p4, 0.01, p3, 0.05  ; Safe minimum times
```

### Amplitude Too Loud/Quiet
**Problem:** Output clipping or barely audible
**Cause:** 0dbfs and p4 values mismatch
**Solution:** With `0dbfs=32768`, keep p4 between 10000-30000. With `0dbfs=1.0`, keep p4 between 0.0-1.0

### Wrong Waveform Sound
**Problem:** Unexpected timbre
**Cause:** p6 pointing to wrong function table
**Solution:** Verify p6 matches intended table (1=sine, 2=sawtooth in this example)

### No Sound Output
**Problem:** Csound runs but no audio
**Cause:** nchnls mismatch with audio hardware
**Solution:** Check audio device channel count, try `-odac` option for real-time instead of file output

### Distortion/Artifacts
**Problem:** Harsh, distorted sound
**Cause:** Amplitude exceeding 0dbfs
**Solution:** Reduce p4 values or increase 0dbfs

---

## Related Examples

**Progression Path:**
1. **Current:** Basic oscillator with linear envelope
2. **Next:** Exponential envelopes with `expseg` or `expon`
3. **Then:** Multi-segment envelopes with `linseg`/`expseg`
4. **Advanced:** ADSR with `madsr`, complex envelopes with `transeg`

**Related Techniques:**
- `FM Synthesis with oscil` - Frequency modulation using multiple oscillators
- `Filtered Noise Instrument` - Subtractive synthesis basics
- `Wavetable Scanning` - Dynamic waveform morphing
- `Multiple Oscillator Detuning` - Creating rich timbres

**Related Opcodes:**
- `poscil` - Phase-locked oscillator (better for FM)
- `oscili` - Interpolating oscillator (smoother at low frequencies)
- `vco2` - Virtual analog oscillator with multiple waveforms
- `expseg` - Exponential envelope (more natural decay)
- `madsr` - MIDI-style ADSR envelope

---

## Performance Notes

- **CPU Usage:** Very light - this instrument is highly efficient
- **Polyphony:** Can easily run 100+ simultaneous instances
- **Real-time Safe:** Yes, suitable for live performance
- **Latency:** Determined by ksmps (32 samples ≈ 0.7ms at 44.1kHz)

---

## Extended Documentation

**Official Csound Opcode References:**
- [oscil](https://csound.com/docs/manual/oscil.html)
- [linen](https://csound.com/docs/manual/linen.html)
- [GEN10](https://csound.com/docs/manual/GEN10.html)

**Learning Resources:**
- Csound FLOSS Manual: Chapter 3 (Basic Synthesis)
- The Csound Book: Chapter 1 (Getting Started)
