# Ring Modulation with Frequency Sweeps

## Metadata

- **Title:** Ring Modulation with Frequency Sweeps
- **Category:** Effects Processing / Modulation / Audio Transformation
- **Difficulty:** Intermediate
- **Tags:** `ring-modulation`, `amplitude-modulation`, `frequency-sweep`, `audio-effects`, `stereo-processing`, `soundfile-processing`, `spectral-transformation`, `inharmonic`, `sci-fi-effects`
- **Source File:** `16_ringMod.aiff`

---

## Description

Ring modulation is a classic audio effect that multiplies two signals together, creating sum and difference frequencies. This example applies ring modulation to a vocal sample with independent frequency sweeps in the left and right channels, creating dramatic metallic, robotic, and otherworldly transformations. The effect can range from subtle chorusing to extreme inharmonic distortion depending on the modulation frequency.

**Use Cases:**
- Creating robot/Dalek voices
- Sci-fi sound effects
- Metallic/bell-like timbres from acoustic sources
- Experimental vocal processing
- Sound design for film/games/music
- Creating harmonic/inharmonic variations
- Stereo movement and spatial effects

**What is Ring Modulation?**
Ring modulation multiplies an input signal (carrier) by an oscillator (modulator). The output contains only the sum and difference of the input and modulator frequencies - the original frequencies disappear. This creates inharmonic, metallic sounds.

---

## Complete Code

```csound
<CsoundSynthesizer>
<CsOptions>
-o 16_ringMod.aiff
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 100
nchnls = 2
0dbfs = 1
instr    1 ; Ring Modulator
ilevl    = p4                          ; Output level
ifreq1   = (p5 < 19 ? cpspch(p5) : p5) ; L start frequency in cpspch or Hz
ifreq2   = (p6 < 19 ? cpspch(p6) : p6) ; L end frequency in cpspch or Hz
ifreq3   = (p7 < 19 ? cpspch(p7) : p7) ; R start frequency in cpspch or Hz
ifreq4   = (p8 < 19 ? cpspch(p8) : p8) ; R end frequency in cpspch or Hz
idepth   = p9                          ; Depth
iwave    = p10                         ; Waveform
ain      soundin  "scores/samples/female.aiff"
ksweep1  expon  ifreq1, p3, ifreq2
ksweep2  expon  ifreq3, p3, ifreq4
aosc1    oscili  1, ksweep1, iwave, -1
aosc2    oscili  1, ksweep2, iwave, -1
outch    1, ain*(aosc1*idepth + 1*(1 - idepth))
outch    2, ain*(aosc2*idepth + 1*(1 - idepth))
endin
</CsInstruments>
<CsScore>
f1 0 8193 10 1                      ; Sine
f2 0 8193 7 0 2048 1 4096 -1 2048 0 ; Triangle
f3 0 8193 10 1 1                    ; 1st and 2nd harmonics
f4 0 8193 10 1 0 0 0 1              ; 1st and 5th harmonics
;Freq: >19=Hz <19=Pitch
;                     -----L----- -----R-----
;   Strt  Leng  Levl  Freq1 Freq2 Freq1 Freq2 Depth Wave
i1  0.00  7     1.00  75    1000  4000   75    1.00  3
s
i1  0.00  7     1.00  777   10000 400    7005  1.00  2
s
i1  0.00  7     1.00  7     70    40     375   1.00  1
s
i1  0.00  7     1.00  1775  170   2400   5375   1.00  4
s
i1  0.00  7     1.00  77     2170  57    3375   1.00  1
e
</CsScore>
</CsoundSynthesizer>
```

---

## Detailed Explanation

### Orchestra Header

```csound
sr = 44100
ksmps = 100
nchnls = 2       ; Stereo for independent L/R processing
0dbfs = 1        ; Normalized amplitude
```

### Instrument 1 - Ring Modulator

#### Output Level

```csound
ilevl = p4
```
**Output level** (not used in this implementation, but defined)
- p4 = 1.00 in all examples (full level)
- Could be used to scale final output
- Currently output level controlled by depth parameter instead

#### Frequency Parameters with Flexible Input

```csound
ifreq1 = (p5 < 19 ? cpspch(p5) : p5)  ; L start frequency
ifreq2 = (p6 < 19 ? cpspch(p6) : p6)  ; L end frequency
ifreq3 = (p7 < 19 ? cpspch(p7) : p7)  ; R start frequency
ifreq4 = (p8 < 19 ? cpspch(p8) : p8)  ; R end frequency
```

**Clever ternary operator usage:**
```
(p5 < 19 ? cpspch(p5) : p5)
```
**Translation:** If p5 < 19, interpret as pitch notation; otherwise, use as Hz directly

**Why?**
- Csound pitch notation: 8.00 = middle C ≈ 261 Hz (always < 19)
- Hz values for audible range: 20-20000 Hz (always ≥ 19)
- This allows flexible input in score: `7.00` or `440` both work!

**Example conversions:**
- p5 = 7.00 → cpspch(7.00) → ~130 Hz (pitch notation)
- p5 = 75 → 75 Hz (direct Hz)
- p5 = 1000 → 1000 Hz (direct Hz)

**Four frequency parameters create stereo sweep:**
- **ifreq1:** Left channel start frequency
- **ifreq2:** Left channel end frequency
- **ifreq3:** Right channel start frequency
- **ifreq4:** Right channel end frequency

This allows completely independent modulation in each channel!

#### Effect Parameters

```csound
idepth = p9
```
**Modulation depth** (0.0-1.0)
- 0.0 = no effect (dry signal)
- 0.5 = 50% wet/50% dry
- 1.0 = 100% ring modulation (full effect)

```csound
iwave = p10
```
**Modulator waveform** (function table number)
- f1 = sine (smooth, musical)
- f2 = triangle (brighter than sine)
- f3 = 1st + 2nd harmonics (complex)
- f4 = 1st + 5th harmonics (hollow, fifth interval)

#### Audio Input

```csound
ain soundin "scores/samples/female.aiff"
```
**Load audio file**
- Reads from soundfile (vocal sample)
- Mono or stereo source (automatically handled)
- This is the "carrier" signal to be modulated

**File path:**
- Relative path from Csound execution directory
- Replace with your own audio file

#### Frequency Sweeps

```csound
ksweep1 expon ifreq1, p3, ifreq2
ksweep2 expon ifreq3, p3, ifreq4
```

**Exponential frequency sweeps** (k-rate)
- `expon` = exponential interpolation
- `ifreq1` → `ifreq2` over duration `p3`
- **Exponential is critical for pitch** - we hear pitch logarithmically
- Linear sweep would sound unnatural

**Why two separate sweeps?**
Independent L/R creates:
- Stereo movement
- Complex spatial effects
- Different timbral evolution per channel

#### Modulator Oscillators

```csound
aosc1 oscili 1, ksweep1, iwave, -1
aosc2 oscili 1, ksweep2, iwave, -1
```

**Two oscillators for L/R channels**
- Amplitude = 1 (full scale for multiplication)
- Frequency = swept frequency (k-rate modulation)
- Table = user-selected waveform
- `-1` = no initial phase (default behavior)

**Output:** Audio-rate modulators for ring modulation

#### Ring Modulation with Wet/Dry Mix

```csound
outch 1, ain*(aosc1*idepth + 1*(1 - idepth))
outch 2, ain*(aosc2*idepth + 1*(1 - idepth))
```

**This is the key ring modulation formula!**

Let's break it down:

**Left channel (outch 1):**
```
output = ain * (aosc1*idepth + 1*(1 - idepth))
```

**Expanding:**
```
output = ain * (aosc1*idepth + (1 - idepth))
output = ain*aosc1*idepth + ain*(1 - idepth)
output = wet_signal*idepth + dry_signal*(1 - idepth)
```

**Components:**
- `ain*aosc1*idepth` = **wet signal** (ring modulated)
- `ain*(1 - idepth)` = **dry signal** (original)

**At different depth values:**
- idepth = 0.0: `output = ain*1 = ain` (completely dry)
- idepth = 0.5: `output = ain*aosc1*0.5 + ain*0.5` (50/50 mix)
- idepth = 1.0: `output = ain*aosc1` (pure ring modulation)

**Why this matters:**
Pure ring modulation (idepth=1.0) can sound very unnatural. Mixing in dry signal provides:
- Reference to original pitch
- More musical results
- Control over effect intensity

**Right channel identical but uses aosc2:**
Independent modulation creates stereo width and movement.

### Score Section

#### Function Tables - Modulator Waveforms

```csound
f1 0 8193 10 1
```
**Sine wave** (GEN10)
- Single partial (pure sine)
- Smoothest modulation
- Most "musical" ring mod effect
- Creates sum and difference frequencies cleanly

```csound
f2 0 8193 7 0 2048 1 4096 -1 2048 0
```
**Triangle wave** (GEN07 - linear segments)
- 0 → 1 (2048 points)
- 1 → -1 (4096 points) 
- -1 → 0 (2048 points)
- Brighter than sine (contains odd harmonics)
- More complex ring mod spectrum

```csound
f3 0 8193 10 1 1
```
**Two harmonics** (GEN10)
- Fundamental + 2nd harmonic (octave)
- Amplitude 1 each
- Creates octave-related sidebands
- Richer, more complex modulation

```csound
f4 0 8193 10 1 0 0 0 1
```
**1st and 5th harmonics** (GEN10)
- Fundamental + 5th harmonic (two octaves + major third)
- Creates "hollow" interval
- Unusual harmonic content
- Very distinctive ring mod character

**Table size 8193:**
Power of 2 + 1 (2^13 + 1) - optimal for interpolation

#### Note Events - Five Different Sweeps

**Event 1:**
```csound
i1  0.00  7  1.00  75  1000  4000  75  1.00  3
```
- **Left:** 75 Hz → 1000 Hz (upward sweep)
- **Right:** 4000 Hz → 75 Hz (downward sweep)
- **Depth:** 1.00 (full ring mod)
- **Wave:** f3 (1st+2nd harmonics)
- **Effect:** Opposite sweeps create dramatic stereo motion

**Event 2:**
```csound
i1  0.00  7  1.00  777  10000  400  7005  1.00  2
```
- **Left:** 777 Hz → 10000 Hz (very high sweep)
- **Right:** 400 Hz → 7005 Hz (different upward sweep)
- **Wave:** f2 (triangle)
- **Effect:** Both sweeping up at different rates, high-frequency content

**Event 3:**
```csound
i1  0.00  7  1.00  7  70  40  375  1.00  1
```
- **Left:** 7 Hz → 70 Hz (very low, sub-audio to low audio)
- **Right:** 40 Hz → 375 Hz (low to mid)
- **Wave:** f1 (sine)
- **Effect:** Low frequencies create tremolo-like effects, growling

**Event 4:**
```csound
i1  0.00  7  1.00  1775  170  2400  5375  1.00  4
```
- **Left:** 1775 Hz → 170 Hz (downward sweep)
- **Right:** 2400 Hz → 5375 Hz (upward sweep)
- **Wave:** f4 (1st+5th harmonics)
- **Effect:** Opposite directions again, hollow harmonic content

**Event 5:**
```csound
i1  0.00  7  1.00  77  2170  57  3375  1.00  1
```
- **Left:** 77 Hz → 2170 Hz (wide upward sweep)
- **Right:** 57 Hz → 3375 Hz (wider upward sweep)
- **Wave:** f1 (sine)
- **Effect:** Both sweeping up but at different rates and ranges

**'s' separator:**
Each 's' creates a section break - separates events for clarity

---

## Key Concepts

### Ring Modulation Theory

**Mathematical operation:**
```
output = carrier × modulator
```

**Frequency domain result:**
If carrier has frequency fc and modulator has frequency fm:
```
output contains: (fc + fm) and (fc - fm)
```

**Example:**
- Carrier: 440 Hz (A4)
- Modulator: 100 Hz
- Output: 540 Hz (440+100) and 340 Hz (440-100)
- **Original 440 Hz disappears!**

**Multiple frequency components:**
If carrier has harmonics (fc, 2fc, 3fc...) and modulator has harmonics (fm, 2fm, 3fm...):
```
All combinations: (nfc ± mfm) where n, m = 1, 2, 3...
```
This creates complex, often inharmonic spectra.

### Ring Modulation vs. Amplitude Modulation

**Amplitude Modulation (AM):**
```
output = carrier × (1 + modulator)
```
Output contains: fc, (fc + fm), (fc - fm)
- **Preserves carrier frequency**
- Sidebands added

**Ring Modulation:**
```
output = carrier × modulator
```
Output contains: (fc + fm), (fc - fm)
- **Carrier frequency suppressed**
- Only sidebands remain
- More dramatic transformation

**This example uses a hybrid:**
```
output = carrier × (modulator*depth + (1-depth))
```
- At depth=1.0: Pure ring mod
- At depth=0.0: Pure AM (no modulation)
- In between: Blend of both

### Why Exponential Frequency Sweeps?

**Human pitch perception is logarithmic:**
- Doubling frequency = +1 octave (constant musical interval)
- Linear sweep: uneven musical intervals
- Exponential sweep: even musical intervals

**Example - Linear sweep 100→1000 Hz:**
- 100→200: +1 octave (first 100 Hz)
- 500→1000: +1 octave (last 500 Hz)
- Sounds slow at start, fast at end

**Exponential sweep 100→1000 Hz:**
- Each octave takes same proportion of time
- Sounds even and musical

**In this example:**
`expon ifreq1, p3, ifreq2` creates musically natural sweeps

### Stereo Processing Strategies

**Independent L/R modulation creates:**
1. **Spatial movement** - Sweeps moving opposite directions feel like motion
2. **Width** - Different frequencies in each channel = wider stereo image
3. **Complexity** - Two different timbral evolutions prevent monotony

**Example 1 analysis:**
- L: 75→1000 Hz (sweeping up)
- R: 4000→75 Hz (sweeping down)
- They "cross" somewhere in the middle
- Creates sense of rotation/movement through space

---

## Parameter Exploration

### Modulation Frequency Effects

**Sub-audio (< 20 Hz):**
- Example 3: 7 Hz → 70 Hz
- Creates tremolo/amplitude modulation at very low freqs
- Growling, pulsating effects
- Can create rhythmic patterns

**Low audio (20-200 Hz):**
- Thick, rumbling timbres
- Creates bass-frequency sidebands
- Can sound like pitch shifting or detuning

**Mid-range (200-2000 Hz):**
- Most "ring mod" character
- Metallic, bell-like tones
- Strong pitch transformation
- Can still perceive original content

**High frequencies (2000-10000 Hz):**
- Example 2: up to 10000 Hz
- Bright, sizzling, crystalline
- Can add sparkle or harshness
- Original content heavily masked

**Ultra-high (> 10000 Hz):**
- Near Nyquist (22050 Hz at 44.1kHz)
- Risk of aliasing
- Creates high-frequency artifacts
- Usually too bright/harsh

### Depth Parameter (idepth)

**0.0 - Dry (no effect):**
```csound
idepth = 0.0  ; output = ain
```
Completely bypassed

**0.1-0.3 - Subtle:**
```csound
idepth = 0.2  ; 20% wet, 80% dry
```
- Slight detuning/chorusing
- Adds harmonics without destroying original
- Natural enhancement

**0.4-0.6 - Moderate:**
```csound
idepth = 0.5  ; 50/50 mix
```
- Clear ring mod effect
- Original still recognizable
- Good for musical applications

**0.7-0.9 - Heavy:**
```csound
idepth = 0.8  ; 80% wet, 20% dry
```
- Strong transformation
- Original barely present
- Aggressive effect

**1.0 - Full ring modulation:**
```csound
idepth = 1.0  ; 100% wet
```
- Complete spectral transformation
- Original pitch/content unrecognizable
- Extreme, metallic, robotic

### Waveform Selection Impact

**Sine (f1):**
- Produces only sum and difference frequencies
- Cleanest, most predictable
- Musical, tonal results
- Best for subtle effects

**Triangle (f2):**
- Adds odd harmonics to modulator
- Each harmonic creates its own sidebands
- Brighter, more complex
- Still relatively clean

**Complex waveforms (f3, f4):**
- Multiple harmonics = multiple sideband pairs
- Dense, inharmonic spectra
- More "noise-like" or "metallic"
- Creative, experimental sounds

**Square wave (could add):**
```csound
f5 0 8193 10 1 0 .333 0 .2 0 .143  ; Approximated square
```
- Very bright, harsh
- Many odd harmonics
- Extremely dense sidebands
- Buzzy, aggressive

---

## Variations

### Tremolo Effect (Low-Frequency AM)

```csound
; Use very low frequency for tremolo instead of ring mod
ksweep1 line 4, p3, 8      ; 4-8 Hz sweep
aosc1 oscili 1, ksweep1, 1
; Full depth creates tremolo
outch 1, ain*(aosc1*0.8 + 1*0.2)  ; Gentle tremolo
```

### Vibrato via Ring Mod

```csound
; Very low frequency + low depth = vibrato-like pitch variation
ksweep1 line 5, p3, 7      ; 5-7 Hz
aosc1 oscili 1, ksweep1, 1
outch 1, ain*(aosc1*0.1 + 1*0.9)  ; Subtle pitch wobble
```

### Harmonizer Effect

```csound
; Fixed frequency ratios create pitch shifting
ifreq1 = cpspch(p5) * 1.5   ; Perfect fifth interval
aosc1 oscili 1, ifreq1, 1
outch 1, ain*(aosc1*0.5 + 1*0.5)  ; Mixed with dry
```

### Dynamic Depth Control

```csound
; Depth varies over time
kdepth linseg 0, p3/2, 1, p3/2, 0  ; Fade in and out
outch 1, ain*(aosc1*kdepth + 1*(1 - kdepth))
```

### Feedback Ring Modulation

```csound
; Ring mod the ring mod (extreme effect)
afeed init 0
aring = ain*(aosc1*idepth + 1*(1 - idepth))
afeed = aring*(aosc2*0.3)    ; Feedback with different modulator
outch 1, aring + afeed*0.3   ; Mix feedback in
```

### LFO-Modulated Frequency

```csound
; Modulation frequency varies with LFO
klfo lfo 500, 0.3, 0         ; LFO ±500 Hz, 0.3 Hz rate
ksweep1 = ifreq1 + klfo
aosc1 oscili 1, ksweep1, 1
```

### Crossfading Waveforms

```csound
; Morph between different modulator waveforms
aosc_sine oscili 1, ksweep1, 1
aosc_tri oscili 1, ksweep1, 2
kcrossfade linseg 0, p3, 1
aosc_mix = aosc_sine*(1-kcrossfade) + aosc_tri*kcrossfade
outch 1, ain*(aosc_mix*idepth + 1*(1 - idepth))
```

### Parallel Multi-Band Ring Mod

```csound
; Split input into bands, ring mod each differently
alow butterlp ain, 500
amid butterbp ain, 1500, 1000
ahigh butterhp ain, 3000

alow_mod = alow*(aosc1*idepth + 1*(1-idepth))
amid_mod = amid*(aosc2*idepth + 1*(1-idepth))  ; Different freq
ahigh_mod = ahigh*(aosc1*0.5*idepth + 1*(1-idepth))

outch 1, alow_mod + amid_mod + ahigh_mod
```

---

## Common Issues & Solutions

### Aliasing at High Frequencies
**Problem:** Harsh digital artifacts when modulator frequency is high  
**Cause:** Sum frequencies exceed Nyquist (sr/2 = 22050 Hz)  
**Solution:**
```csound
; Limit modulator frequency
ifreq2 = (ifreq2 > 8000 ? 8000 : ifreq2)  ; Cap at 8kHz
; Or oversample
sr = 88200  ; Double sample rate
; Or low-pass filter output
aout tone aout, 18000
```

### Too Much/Too Little Effect
**Problem:** Effect too subtle or too extreme  
**Cause:** Depth parameter not optimal  
**Solution:**
```csound
; Try different depth values
idepth = 0.3   ; Subtle
idepth = 0.7   ; Moderate
idepth = 1.0   ; Extreme

; Or make it variable
kdepth linseg 0.3, p3, 0.9  ; Increase over time
```

### Distortion/Clipping
**Problem:** Output exceeds 0dbfs, distorts  
**Cause:** Ring mod can increase amplitude  
**Solution:**
```csound
; Scale output
outch 1, ain*(aosc1*idepth + 1*(1 - idepth)) * 0.7
; Or use limiter
aout = ain*(aosc1*idepth + 1*(1 - idepth))
aout limit aout, -0dbfs, 0dbfs
outch 1, aout
```

### Unnatural Sweep Sound
**Problem:** Sweep sounds uneven or strange  
**Cause:** Should use exponential, not linear  
**Solution:**
```csound
; Use expon instead of line
ksweep1 expon ifreq1, p3, ifreq2  ; Correct (exponential)
; NOT: ksweep1 line ifreq1, p3, ifreq2  ; Wrong for musical sweeps
```

### Input File Not Found
**Problem:** "can't open scores/samples/female.aiff"  
**Cause:** File path incorrect or file missing  
**Solution:**
```csound
; Use full path
ain soundin "/Users/username/csound/samples/female.aiff"
; Or use your own audio file
ain soundin "myvoice.wav"
; Or generate test signal instead
ain oscili 0.3, 200, 1  ; Test tone instead of file
```

### Loss of Stereo Image
**Problem:** Output sounds too centered, not wide enough  
**Cause:** L/R sweeps too similar  
**Solution:**
```csound
; Use more different frequencies
i1 0 7 1.00 100 2000 5000 200 1.00 1  ; More contrast
; Or opposite directions
i1 0 7 1.00 100 5000 5000 100 1.00 1  ; Opposite sweeps
```

---

## Sound Design Applications

### Robot Voice (Classic Ring Mod)

```csound
; Fixed low frequency for classic robot effect
ksweep1 = 120   ; Constant 120 Hz
ksweep2 = 120
idepth = 0.9    ; Heavy but not complete
iwave = 1       ; Sine for cleaner robot
```

### Dalek Voice (Doctor Who)

```csound
; Metallic, modulated voice
ksweep1 lfo 30, 30, 0    ; 30 Hz ± 30 Hz variation
ksweep1 = 30 + ksweep1
aosc1 oscili 1, ksweep1, 2  ; Triangle for brightness
idepth = 1.0    ; Full ring mod
```

### Telephone/Radio Effect

```csound
; Band-limited with subtle ring mod
aband butterbp ain, 1200, 1000  ; Telephone bandwidth
ksweep1 = 900   ; Fixed frequency
aosc1 oscili 1, ksweep1, 1
aout = aband*(aosc1*0.3 + 1*0.7)  ; Subtle depth
```

### Bell/Metallic Resonance

```csound
; High frequency with complex waveform
ksweep1 expon 2000, p3, 200  ; Descending like bell strike
aosc1 oscili 1, ksweep1, 4   ; Complex harmonics (f4)
idepth = 0.8
```

### Experimental Vocal Transformation

```csound
; Extreme stereo sweeps
ksweep1 expon 50, p3, 5000
ksweep2 expon 5000, p3, 50   ; Opposite direction
aosc1 oscili 1, ksweep1, 2
aosc2 oscili 1, ksweep2, 2
idepth = 1.0
; Add reverb for space
```

---

## Advanced Topics

### Sideband Frequency Calculation

For input frequency fc and modulator fm:

**Sum and difference:**
```
f_sum = fc + fm
f_diff = |fc - fm|
```

**Example with voice:**
- Voice fundamental: 200 Hz
- Modulator: 300 Hz
- Output: 500 Hz (200+300) and 100 Hz (|200-300|)
- Original 200 Hz disappears!

**With harmonics (n=1,2,3...):**
- Voice harmonics: 200, 400, 600, 800 Hz...
- For each harmonic h and modulator m:
  - h+m: 200+300=500, 400+300=700, 600+300=900...
  - |h-m|: 100, 100, 300, 500...

**Result:** Dense, inharmonic spectrum

### Preventing Aliasing

**Nyquist limit:** sr/2 (22050 Hz at 44.1kHz)

**Aliasing occurs when:**
```
fc + fm > Nyquist
```

**Aliased frequency appears at:**
```
f_alias = sr - (fc + fm)
```

**Example:**
- Voice component: 3000 Hz
- Modulator: 20000 Hz
- Sum: 23000 Hz (above Nyquist!)
- Aliases to: 44100 - 23000 = 21100 Hz (incorrect frequency)

**Prevention:**
1. Limit modulator frequency to < 10000 Hz
2. Low-pass filter input before ring mod
3. Oversample (higher sr)
4. Low-pass filter output

### Depth Parameter Mathematics

The formula:
```
output = input × (modulator×depth + (1-depth))
```

Expanded:
```
output = input × (m×d + 1 - d)
output = input×m×d + input×(1-d)
output = wet×d + dry×(1-d)
```

**This is a crossfade:**
- Linear interpolation between dry (input) and wet (input×modulator)
- Preserves overall amplitude
- No volume jump when switching depth

**Alternative (not used here):**
```
output = input × modulator  ; Pure ring mod (no dry mix)
```
More extreme but can lose all original character.

---

## Related Examples

**Progression Path:**
1. **Current:** Ring modulation with frequency sweeps
2. **Next:** Amplitude modulation (preserves carrier)
3. **Then:** Single-sideband modulation (one sideband only)
4. **Advanced:** Frequency shifting (non-harmonic pitch shift)

**Related Techniques:**
- `Amplitude Modulation` - Similar but preserves carrier
- `Frequency Shifting` - Uses Hilbert transform for smooth shifts
- `Vocoding` - Multi-band amplitude modulation
- `Pitch Shifting` - Time-domain or frequency-domain methods

**Related Opcodes:**
- `oscili` / `oscil` - Oscillators used for modulation
- `balance` - Matching amplitude of processed vs dry
- `hilbert` - For single-sideband / frequency shifting
- `pvscross` - Spectral cross-synthesis (related concept)

---

## Performance Notes

- **CPU Usage:** Light - just oscillators and multiplication
- **Polyphony:** Many simultaneous instances possible
- **Real-time Safe:** Yes, very efficient
- **Latency:** Minimal (just ksmps)
- **Memory:** Low (just audio buffer + function tables)

---

## Historical Context

**Origins (1930s):**
Ring modulation discovered in telephone transmission systems (hence "ring" from ring circuits used in telecom).

**Musical adoption (1950s-60s):**
- Karlheinz Stockhausen: "Mixtur" (1964) - Ring mod on orchestral instruments
- Electronic music studios: Used for generating inharmonic spectra
- Synthesizers: Included in modular synths (Moog, etc.)

**Popular culture:**
- **Daleks (Doctor Who, 1963):** Ring-modulated voice = iconic sound
- **Sci-fi:** Standard for robot/alien voices
- **Music:** Pink Floyd, Kraftwerk, electronic music widely

**Modern use:**
Still common in:
- Guitar/bass effects pedals
- Synthesizers (modular and virtual)
- Audio processing software
- Sound design for media

**Legacy:**
Ring modulation demonstrated how simple mathematics (multiplication) could create complex, otherworldly sounds - influencing all electronic music.

---

## Extended Documentation

**Official Csound Opcode References:**
- [oscili](https://csound.com/docs/manual/oscili.html)
- [soundin](https://csound.com/docs/manual/soundin.html)
- [expon](https://csound.com/docs/manual/expon.html)
- [outch](https://csound.com/docs/manual/outch.html)

**Theoretical References:**
- Dodge & Jerse: "Computer Music" - Chapter on Modulation
- Roads, Curtis: "The Computer Music Tutorial" - Amplitude Modulation section
- Chowning, John: "The Synthesis of Complex Audio Spectra by Means of Frequency Modulation"

**Learning Resources:**
- Csound FLOSS Manual: Chapter 5.3 (Modulation Synthesis)
- The Csound Book: "Effects Processing" section
- Sound On Sound: "Synth Secrets" - Ring Modulation articles

**Fun fact:**
The first musical use of ring modulation was accidental - Harald Bode discovered the sound while working on ring circuits for telephone systems in the 1930s and realized its musical potential!
