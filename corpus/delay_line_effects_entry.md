# Delay Line Effects: Flanging, Chorus, and Variable Delays

## Metadata

- **Title:** Delay Line Effects: Flanging, Chorus, and Variable Delays
- **Category:** Effects Processing / Time-Based Effects / Modulation Effects
- **Difficulty:** Intermediate
- **Tags:** `delay`, `vdelay`, `flanger`, `chorus`, `modulation`, `feedback`, `multitap`, `comb-filter`, `time-based-effects`, `stereo-effects`, `LFO-modulation`
- **Source Files:** `flang.csd`, `vdel.csd`, `pdel.csd`, `powdel.csd`

---

## Description

Delay lines are fundamental building blocks for a vast array of audio effects. By storing audio in a buffer and reading it back after a time offset, delays create everything from simple echoes to complex modulation effects. This entry covers **variable delay** techniques using Csound's `vdelay` opcode, demonstrating how modulating delay time creates flanging, chorus, and other time-based effects.

**Use Cases:**
- Flanging effects (short, modulated delays with feedback)
- Chorus effects (multiple detuned copies of a signal)
- Doppler-like pitch shifting
- Comb filtering and resonance effects
- Slapback and echo effects
- Creating stereo width from mono sources
- Sound design for swooshing, sweeping textures

**Key Concept:**
When delay time changes, the playback speed of the delayed signal varies, causing pitch shifting. Fast modulation = flanging. Slow modulation = chorus. Static short delays = comb filtering.

---

## Complete Code

### Example 1: Classic Flanger with Cascaded Delays

```csound
<CsoundSynthesizer>
<CsOptions>
-o flanger_output.wav
</CsOptions>
<CsInstruments>
sr        = 44100
kr        = 4410
ksmps     = 10
nchnls    = 2
0dbfs     = 1

; Classic flanger using cascaded vdelay lines
          instr     1
; PARAMETERS
iamp      = p4                    ; Input amplitude (0-1)
imaxdel   = p5                    ; Maximum delay time in ms (e.g., 7)
irate     = p6                    ; LFO rate in Hz (e.g., 0.2-2)
idepth    = p7                    ; Modulation depth (0-1)
ifeedback = p8                    ; Feedback amount (0-0.9)

; INPUT SOURCE - white noise for demonstration
ain       rand      iamp

; LFO FOR DELAY TIME MODULATION
; Delay sweeps from near-zero to imaxdel
krate     line      0.1, p3, irate          ; Rate increases over time
amod      oscil     imaxdel * idepth, krate, 1
amod      = amod + (imaxdel * 0.5)          ; Center around half max delay

; FEEDBACK PATH
afeedback init      0

; CASCADED DELAY LINES (creates richer flanging)
adel1     vdelay    ain + (afeedback * ifeedback), amod, imaxdel
adel2     vdelay    adel1, amod * 1.1, imaxdel       ; Slightly different mod
adel3     vdelay    adel2, amod * 0.9, imaxdel       ; Creates complexity
adel4     vdelay    adel3, amod * 1.05, imaxdel

; Mix dry and wet, update feedback
amix      = (ain + adel1 + adel2 + adel3 + adel4) * 0.3
afeedback = adel4

; STEREO OUTPUT - dry left, wet right for comparison
          outs      ain * 0.5, amix
          endin

</CsInstruments>
<CsScore>
; Sine wave for LFO
f1 0 8192 10 1

; p1  p2   p3   p4    p5      p6     p7     p8
; ins strt dur  amp   maxdel  rate   depth  feedback
i1   0    10   0.7   7       0.3    0.8    0.4
i1   11   10   0.7   4       1.5    1.0    0.6
i1   22   10   0.7   10      0.1    0.5    0.7
</CsScore>
</CsoundSynthesizer>
```

### Example 2: Stereo Chorus Effect

```csound
<CsoundSynthesizer>
<CsOptions>
-o chorus_output.wav
</CsOptions>
<CsInstruments>
sr        = 44100
kr        = 4410
ksmps     = 10
nchnls    = 2
0dbfs     = 1

; Stereo chorus - different delay modulations for L/R
          instr     2
; PARAMETERS
iamp      = p4                    ; Input amplitude
ibase     = p5                    ; Base delay time in ms (15-30 typical)
idepth    = p6                    ; Modulation depth in ms (1-5)
irate     = p7                    ; LFO rate in Hz (0.5-3)

; INPUT - sawtooth oscillator
kenv      linen     iamp, 0.1, p3, 0.2
ain       vco2      kenv, cpspch(p8)

; CHORUS LFOs - different rates for stereo width
amodL     oscil     idepth, irate, 1
amodR     oscil     idepth, irate * 1.13, 1    ; Slightly different rate
amodL     = amodL + ibase
amodR     = amodR + ibase

; DELAY LINES
imaxdel   = ibase + idepth + 5    ; Ensure buffer is large enough
adelL     vdelay    ain, amodL, imaxdel
adelR     vdelay    ain, amodR, imaxdel

; SECOND VOICE (richer chorus)
amod2L    oscil     idepth * 0.7, irate * 0.83, 1
amod2R    oscil     idepth * 0.7, irate * 0.97, 1
amod2L    = amod2L + ibase * 1.3
amod2R    = amod2R + ibase * 1.3
adel2L    vdelay    ain, amod2L, imaxdel * 1.5
adel2R    vdelay    ain, amod2R, imaxdel * 1.5

; MIX - dry center, delays panned
aoutL     = ain * 0.5 + adelL * 0.35 + adel2L * 0.25
aoutR     = ain * 0.5 + adelR * 0.35 + adel2R * 0.25
          outs      aoutL, aoutR
          endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1

; p1  p2   p3   p4    p5     p6     p7    p8
; ins strt dur  amp   base   depth  rate  pitch
i2   0    4    0.4   20     3      1.2   8.00
i2   5    4    0.4   25     5      0.8   8.07
i2   10   6    0.4   15     2      2.0   7.07
</CsScore>
</CsoundSynthesizer>
```

### Example 3: Variable Delay with Pitch Effects

```csound
<CsoundSynthesizer>
<CsOptions>
-o vdelay_pitch.wav
</CsOptions>
<CsInstruments>
sr        = 44100
kr        = 4410
ksmps     = 10
nchnls    = 1
0dbfs     = 1

; Demonstrates pitch-shifting effect of changing delay time
          instr     3
iamp      = p4
ifreq     = p5
imaxdel   = 100                   ; 100ms max delay

; INPUT TONE
ain       oscil     iamp, ifreq, 1

; DELAY TIME ENVELOPE - creates pitch bend
; When delay INCREASES: pitch goes DOWN (slower playback)
; When delay DECREASES: pitch goes UP (faster playback)
kdel      linseg    10, p3/2, 80, p3/2, 10    ; Sweep up then down

; Nonlinear delay curve for more dramatic effect
kpow      pow       kdel/imaxdel, 2           ; Square the normalized value
kdel2     = kpow * imaxdel

adel      vdelay    ain, kdel2, imaxdel

; Mix original and delayed
          out       (ain * 0.5 + adel * 0.5)
          endin

; Simple vibrato using vdelay
          instr     4
iamp      = p4
ifreq     = p5
ivibrate  = p6                    ; Vibrato rate in Hz
ivibdepth = p7                    ; Vibrato depth in ms

; INPUT
ain       oscil     iamp, ifreq, 1

; VIBRATO via delay modulation
amod      oscil     ivibdepth, ivibrate, 1
amod      = amod + ivibdepth + 1  ; Offset to keep positive

adel      vdelay    ain, amod, ivibdepth * 3

          out       adel
          endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1

; Pitch sweep effect
i3 0 4 0.5 440

; Vibrato effect
; p1  p2  p3  p4   p5   p6      p7
; ins st  dur amp  freq vibrate vibdepth
i4  5   4   0.5  440  6       1.5
i4  10  4   0.5  440  2       3
</CsScore>
</CsoundSynthesizer>
```

### Example 4: Multitap Delay (Echo/Reverb Building Block)

```csound
<CsoundSynthesizer>
<CsOptions>
-o multitap_output.wav
</CsOptions>
<CsInstruments>
sr        = 44100
kr        = 4410
ksmps     = 10
nchnls    = 2
0dbfs     = 1

; Rhythmic multitap delay
          instr     5
iamp      = p4

; IMPULSE INPUT (percussive hit)
kenv      linseg    1, 0.01, 0, p3-0.01, 0
anoise    rand      iamp
ain       = anoise * kenv

; MULTITAP DELAY
; multitap asig, itime1, igain1, itime2, igain2, ...
; Creates multiple echoes at specific time intervals with specific gains
ataps     multitap  ain, 0.125, 0.8, 0.25, 0.6, 0.375, 0.4, 0.5, 0.3, 0.625, 0.2, 0.75, 0.15

; Additional rhythmic pattern
ataps2    multitap  ain, 0.167, 0.5, 0.333, 0.4, 0.5, 0.3, 0.667, 0.2

; Pan the two tap patterns
          outs      ain + ataps * 0.5, ain + ataps2 * 0.5
          endin

; Feedback delay with filtering
          instr     6
iamp      = p4
idelay    = p5                    ; Delay time in seconds
ifeedback = p6                    ; Feedback amount (0-0.95)
icutoff   = p7                    ; Lowpass cutoff for feedback

; INPUT
kenv      linen     iamp, 0.1, p3, 0.3
ain       vco2      kenv, cpspch(p8)

; FEEDBACK DELAY with filtering
afdbk     init      0
adel      delay     ain + afdbk * ifeedback, idelay
afilt     tone      adel, icutoff           ; Lowpass in feedback path
afdbk     = afilt                           ; Darker with each repeat

; MIX
          outs      ain + adel * 0.5, ain + adel * 0.5
          endin

</CsInstruments>
<CsScore>
; Multitap rhythmic delays
i5 0 3 0.8
i5 4 3 0.8

; Feedback delay with darkening repeats
; p1  p2  p3  p4   p5     p6    p7     p8
; ins st  dur amp  delay  fdbk  cutoff pitch
i6  8   6   0.4  0.3    0.7   3000   8.00
i6  15  6   0.4  0.5    0.8   1500   7.07
</CsScore>
</CsoundSynthesizer>
```

---

## Detailed Explanation

### The vdelay Opcode

```csound
adel vdelay ain, adeltim, imaxdel
```

**vdelay** = Variable Delay - The core opcode for modulated delay effects

**Parameters:**
1. `ain` - Input audio signal
2. `adeltim` - Delay time in **milliseconds** (can be audio-rate for smooth modulation)
3. `imaxdel` - Maximum delay time in ms (sets internal buffer size)

**Critical Notes:**
- `adeltim` must NEVER exceed `imaxdel`
- `adeltim` should always be positive (>0)
- Buffer size = `imaxdel * sr / 1000` samples
- Modulating `adeltim` causes pitch shifting

### Why Delay Modulation Creates Pitch Shift

**The Doppler Effect Principle:**

When you read from a delay line at a changing position:
- **Increasing delay time** = reading position moves backward = stretched playback = **pitch DOWN**
- **Decreasing delay time** = reading position moves forward = compressed playback = **pitch UP**

**Pitch deviation formula:**
```
pitch_ratio = 1 - (d(delay_time) / dt)
```

For a 1ms/second change in delay:
- 1ms delay increase per second = pitch drops ~0.1%
- Fast modulation (flanger) = more dramatic pitch wobble

### Cascaded Delays for Richer Effects

```csound
adel1 vdelay ain, amod, imaxdel
adel2 vdelay adel1, amod * 1.1, imaxdel
adel3 vdelay adel2, amod * 0.9, imaxdel
```

**Why cascade?**
- Each delay stage adds its own comb filtering
- Slightly different modulation rates create complex interference patterns
- Richer, more animated sound than single delay
- Classic analog flanger behavior

**Signal path:**
```
Input → Delay1 → Delay2 → Delay3 → Delay4 → Output
                                      ↓
                              (feedback loop)
```

### Flanger vs. Chorus: Parameter Differences

| Parameter | Flanger | Chorus |
|-----------|---------|--------|
| **Base Delay** | 1-10 ms | 15-35 ms |
| **Modulation Depth** | 1-8 ms | 1-5 ms |
| **LFO Rate** | 0.1-5 Hz | 0.5-3 Hz |
| **Feedback** | 0.3-0.9 | 0 (none) |
| **Character** | Metallic, sweeping | Thickening, doubling |

**Key insight:**
- Flanger: Short delay + feedback = resonant comb filter sweep
- Chorus: Longer delay + no feedback = pitch detuning without resonance

### The Multitap Opcode

```csound
aout multitap ain, itime1, igain1, itime2, igain2, ...
```

**multitap** creates multiple fixed taps from a single delay line:
- Each pair: `time_in_seconds, amplitude`
- Maximum 32 taps
- Times must be positive and less than max (depends on sr)
- Efficient for rhythmic echo patterns

**Applications:**
- Rhythmic delay patterns
- Early reflections in reverb
- Building block for Schroeder reverb designs
- Ping-pong effects

### Feedback Delay with Filtering

```csound
afdbk init 0
adel  delay ain + afdbk * ifeedback, idelay
afilt tone adel, icutoff
afdbk = afilt
```

**Why filter in feedback path?**
- Simulates natural echo decay (high frequencies absorbed)
- Each repeat becomes darker/warmer
- Prevents harsh buildup at high feedback levels
- More musical, tape-echo-like character

**Feedback coefficient:**
- 0.0 = no feedback (single echo)
- 0.5 = moderate decay
- 0.9 = long, sustained echoes
- >1.0 = DANGER! Runaway feedback, clip/distort

---

## Key Concepts

### Comb Filtering from Static Delays

A static delay mixed with the original creates a **comb filter**:

```csound
adel delay ain, idelay
aout = ain + adel    ; Comb filter!
```

**Frequency response:**
- Peaks at: f = n / delay_time (n = 1, 2, 3, ...)
- Notches at: f = (n + 0.5) / delay_time

**Example:** 5ms delay = peaks at 200, 400, 600, 800 Hz...

**Implications:**
- Short delays create audible coloration
- Moving the delay time sweeps the comb teeth through the spectrum
- This IS the flanging sound!

### All-Pass Delays

```csound
aout, adel delayr imaxdel
aout alpass ain, idelay, ifeedback    ; Flat frequency response
```

All-pass filters maintain **flat amplitude response** but alter **phase**. Used in reverb to add density without coloration.

### Buffer Size and Memory

**Memory calculation:**
```
buffer_samples = imaxdel_ms * sr / 1000
buffer_memory = buffer_samples * 4 bytes (32-bit float)
```

**Example:** 1000ms max delay at 44100 Hz:
- 44100 samples
- 176,400 bytes ≈ 172 KB per delay line

**Best practice:** Set `imaxdel` to actual maximum needed, not arbitrary large value.

---

## Parameter Exploration

### LFO Rate Effects

| Rate (Hz) | Perceived Effect |
|-----------|------------------|
| 0.05-0.2 | Slow, sweeping movement |
| 0.2-0.5 | Classic flanger sweep |
| 0.5-2.0 | Vibrato-like wobble |
| 2-5 | Fast warble, less smooth |
| >5 | Ring modulation territory |

### Delay Time Ranges

| Delay Range | Effect Type |
|-------------|-------------|
| 0.1-1 ms | Comb filtering, subtle |
| 1-10 ms | Flanging |
| 10-30 ms | Chorus, doubling |
| 30-100 ms | Slapback echo |
| 100-500 ms | Discrete echoes |
| >500 ms | Rhythmic delays |

### Feedback Character

| Feedback | Sound Character |
|----------|-----------------|
| 0.0 | Single delay tap |
| 0.3 | Subtle resonance |
| 0.5 | Moderate ringing |
| 0.7 | Strong resonance, metallic |
| 0.9 | Long decay, near self-oscillation |
| 0.95+ | Dangerous! Can self-oscillate |

---

## Variations

### Negative Feedback (Inverted Comb)

```csound
; Invert feedback signal for different comb response
afdbk init 0
adel  vdelay ain - afdbk * ifeedback, kdeltim, imaxdel  ; Note: minus!
afdbk = adel
```

**Effect:** Notches become peaks, peaks become notches. Different tonal color.

### Stereo Flanger with Cross-Feedback

```csound
; Left and right channels feed into each other
afdbkL init 0
afdbkR init 0

adelL vdelay ainL + afdbkR * 0.3, amodL, imaxdel
adelR vdelay ainR + afdbkL * 0.3, amodR, imaxdel

afdbkL = adelL
afdbkR = adelR

outs ainL + adelL, ainR + adelR
```

**Effect:** Creates swirling, spacious stereo movement.

### Tape-Style Wow and Flutter

```csound
; Simulate tape machine irregularities
kwow   oscil  2, 0.5, 1           ; Slow wow
kflut  randi  0.3, 10             ; Random flutter
kdel   = 20 + kwow + kflut        ; Combine for tape-like pitch drift

adel   vdelay ain, kdel, 30
```

### Sample-and-Hold Delay Modulation

```csound
; Stepped delay changes for glitchy effects
ktrig  metro  4                   ; 4 Hz trigger
krand  random 5, 50               ; Random delay 5-50ms
kdel   samphold krand, ktrig      ; Hold until next trigger

adel   vdelay ain, kdel, 60
```

### Pitch Shifter (Simple)

```csound
; Constant pitch shift via sawtooth delay modulation
ipitch = 0.5                      ; Pitch ratio (0.5 = octave down)
iwin   = 50                       ; Window size in ms

; Sawtooth resets create seamless looping
amod   phasor  sr / (iwin * ipitch * sr / 1000)
amod   = amod * iwin

adel   vdelay ain, amod, iwin + 5

; Crossfade two offset phasors for smoother result
; (Full pitch shifter needs overlap-add technique)
```

### Reverse Delay (Granular Approach)

```csound
; Pseudo-reverse using buffer manipulation
; True reverse requires delayr/delayw with reversed read
idelay = 0.5

; Write to delay line
abuf   delayr  idelay
       delayw  ain

; Read backwards using phasor (simplified concept)
; Full implementation needs grain-based approach
```

---

## Common Issues & Solutions

### Clicks and Pops at Delay Time Changes

**Problem:** Audible clicks when delay time jumps
**Cause:** Discontinuity in the delay buffer read position
**Solutions:**
```csound
; Use audio-rate modulation for smooth changes
amod  oscil  10, 1, 1        ; a-rate, not k-rate
adel  vdelay ain, amod, 20   ; Smooth interpolation

; Or use portk for k-rate smoothing
kdel  portk  ktarget, 0.01   ; 10ms glide time
adel  vdelay ain, kdel, maxdel
```

### Delay Time Exceeds Maximum

**Problem:** Csound error or garbage output
**Cause:** Modulated delay exceeds `imaxdel` parameter
**Solution:**
```csound
; Ensure modulation stays within bounds
imaxdel = 50
idepth  = 20
ibase   = 20                ; base + depth = 40 < 50 OK

; Or clamp the value
amod   oscil  idepth, 1, 1
amod   limit amod + ibase, 1, imaxdel - 1
```

### Feedback Runaway

**Problem:** Signal grows to infinity, massive distortion
**Cause:** Feedback coefficient >= 1.0 or positive feedback loop
**Solutions:**
```csound
; Keep feedback below 1.0
ifeedback = 0.85             ; Safe maximum

; Add limiting in feedback path
afilt tone afdbk, 4000       ; Filter removes energy
afdbk limit afilt, -0.9, 0.9 ; Hard limit

; Or use tanh for soft saturation
afdbk tanh afilt * 0.9
```

### Metallic/Harsh Flanging

**Problem:** Flanger sounds too harsh or resonant
**Cause:** Too much feedback, too short delays
**Solutions:**
```csound
; Reduce feedback
ifeedback = 0.3              ; More subtle

; Add lowpass in feedback
afilt butterlp afdbk, 3000   ; Remove harsh highs

; Increase minimum delay time
amod  = amod + 2             ; Never goes below 2ms
```

### Chorus Sounds Like Flanger

**Problem:** Chorus effect has unwanted resonance
**Cause:** Delay time too short, or feedback present
**Solutions:**
```csound
; Increase base delay
ibase = 25                   ; 25ms minimum for chorus

; Ensure NO feedback for chorus
ifeedback = 0

; Use multiple voices instead of feedback
adel1 vdelay ain, amod1, 50
adel2 vdelay ain, amod2, 50
aout  = ain * 0.5 + adel1 * 0.25 + adel2 * 0.25
```

### Phase Cancellation in Mix

**Problem:** Mixed dry+wet signal sounds thin
**Cause:** Comb filter notches cancel frequencies
**Solutions:**
```csound
; Offset delay to avoid worst cancellation
ioffset = 0.3                ; Add fixed offset
amod   = amod + ioffset

; Use wider stereo spread
; Dry center, wet sides
outs ain, adel              ; Hard L/R

; Or invert wet signal polarity
aout = ain + adel * -0.5    ; Inverted mix
```

---

## Sound Design Applications

### Jet Plane Flyby

```csound
; Swooping flanger for jet/whoosh effect
kdel   expon   1, p3, 30         ; Exponential sweep
kdel2  expon   30, p3, 1         ; Reverse sweep
kenv   linen   1, 0.1, p3, 0.3   ; Amplitude envelope

ain    rand    0.5 * kenv        ; Filtered noise
ain    butterlp ain, 2000

adel1  vdelay  ain, kdel, 35
adel2  vdelay  ain, kdel2, 35

aout   = ain * 0.3 + adel1 * 0.5 + adel2 * 0.5
```

### Underwater/Swimming Effect

```csound
; Slow modulation with filtering
amod   oscil   15, 0.2, 1
amod   = amod + 20

ain    ; your input signal
adel   vdelay  ain, amod, 40
afilt  butterlp adel, 1500       ; Muffled
aout   = afilt + ain * 0.2       ; Mostly wet
```

### Robotic/Metallic Voice

```csound
; Short delay + high feedback for metallic resonance
imaxdel = 10
kmod    oscil   3, 4, 1          ; Fast modulation
kdel    = kmod + 5

afdbk   init 0
adel    vdelay  ain + afdbk * 0.8, kdel, imaxdel
afdbk   = adel
```

### Ambient Pad Thickening

```csound
; Multiple chorus layers for lush pads
adel1  vdelay  ain, 20 + amod1, 30
adel2  vdelay  ain, 25 + amod2, 35
adel3  vdelay  ain, 30 + amod3, 40
adel4  vdelay  ain, 22 + amod4, 35

aout   = ain * 0.4 + (adel1 + adel2 + adel3 + adel4) * 0.2
```

---

## Related Opcodes

### Delay Family

| Opcode | Description |
|--------|-------------|
| `delay` | Fixed delay time (i-rate) |
| `vdelay` | Variable delay (a-rate time, interpolating) |
| `vdelay3` | Variable delay with cubic interpolation |
| `vdelayx` | High-quality variable delay |
| `delayr/delayw` | Delay line read/write (most flexible) |
| `deltap/deltapi/deltap3` | Tap delay line with various interpolations |
| `multitap` | Multiple fixed taps from single line |

### Related Effects

| Opcode | Description |
|--------|-------------|
| `flanger` | Dedicated flanger opcode |
| `chorus` | Dedicated chorus opcode |
| `comb` | Comb filter (delay + feedback) |
| `alpass` | All-pass filter |
| `reverb/reverb2` | Built-in reverb algorithms |
| `freeverb` | Freeverb algorithm |

---

## Performance Notes

- **CPU Usage:** Low - delay lines are very efficient
- **Memory:** Proportional to max delay time × sample rate
- **Polyphony:** Can run 100+ delay effects simultaneously
- **Real-time Safe:** Yes, excellent for live performance
- **Latency:** vdelay adds no extra latency beyond the delay itself
- **Quality:** vdelay uses linear interpolation; use vdelay3 or vdelayx for higher quality pitch shifting

**Optimization Tips:**
- Use smallest `imaxdel` that accommodates your modulation range
- Share delay lines across instruments using global variables
- For simple fixed delays, `delay` is slightly more efficient than `vdelay`
- Consider `delayr/deltapi` for advanced delay line manipulation

---

## Historical Context

**Analog Flanging (1960s):**
Originally created by playing two tape machines with the same material and pressing on one reel flange to slow it down. The phase relationship between the two signals created the sweeping comb filter effect.

**Electric Mistress (1976):**
Electro-Harmonix's flanger pedal brought the effect to guitarists, defining the classic flanging sound of late 70s rock.

**Roland Dimension D (1979):**
Pioneered the modern chorus effect with multiple BBD (bucket brigade device) delay lines, becoming the reference for lush chorus sounds.

**Digital Delays (1980s):**
Eventide, Lexicon, and others brought precise digital delay with modulation capabilities, enabling new creative possibilities.

**Impact on Music:**
- Pink Floyd, "The Wall" - extensive flanging
- The Police, Andy Summers - signature chorus sound
- Van Halen, "Unchained" - phase/flanger effects
- Ambient and shoegaze genres - heavy delay modulation

---

## Extended Documentation

**Official Csound Opcode References:**
- [vdelay](https://csound.com/docs/manual/vdelay.html)
- [vdelay3](https://csound.com/docs/manual/vdelay3.html)
- [delay](https://csound.com/docs/manual/delay.html)
- [delayr/delayw](https://csound.com/docs/manual/delayr.html)
- [deltap/deltapi](https://csound.com/docs/manual/deltap.html)
- [multitap](https://csound.com/docs/manual/multitap.html)
- [flanger](https://csound.com/docs/manual/flanger.html)
- [comb](https://csound.com/docs/manual/comb.html)

**Learning Resources:**
- Csound FLOSS Manual: Chapter 5.2 (Delay and Feedback)
- "The Audio Programming Book" by Boulanger & Lazzarini
- Dattorro, Jon: "Effect Design Part 2: Delay-Line Modulation and Chorus"
- Dodge & Jerse: "Computer Music" - Chapter on Signal Processing

**Design References:**
- Schroeder, M.R.: "Natural Sounding Artificial Reverberation" (1962)
- Smith, Julius O.: "An Introduction to Digital Filter Theory"
- Steiglitz, Ken: "A Digital Signal Processing Primer"
