# Physical Modeling: Waveguide Clarinet Synthesis

## Metadata

- **Title:** Physical Modeling: Waveguide Clarinet Synthesis
- **Category:** Physical Modeling / Waveguide Synthesis / Acoustic Instruments
- **Difficulty:** Advanced
- **Tags:** `waveguide`, `physical-modeling`, `clarinet`, `delay-line`, `feedback`, `reed`, `wind-instrument`, `acoustic-simulation`, `realistic-synthesis`
- **Source File:** `11_waveguideClarinetCode.aiff`

---

## Description

This example implements a physically-modeled clarinet using waveguide synthesis techniques. Unlike sample-based or subtractive synthesis, physical modeling simulates the actual physics of sound production: breath pressure, reed vibration, bore resonance, and bell radiation. The result is a remarkably realistic clarinet sound that responds naturally to parameter changes and can produce expressive, organic performances.

**Use Cases:**
- Realistic acoustic instrument simulation
- Expressive melodic passages requiring natural articulation
- Educational study of physical modeling principles
- Film/game music where authentic woodwind sounds are needed
- Interactive music systems that respond to breath controllers
- Studying acoustics and instrument physics through synthesis

---

## Complete Code

```csound
<CsoundSynthesizer>
<CsOptions>
-o 11_waveguideClarinetCode.aiff
</CsOptions>
<CsInstruments>
 sr = 44100
 ksmps = 1
 nchnls = 1
 0dbfs = 32768
              instr      1903
    areedbell init  	 0
    ifqc      =          cpspch(p5)
    ifco      =          p7
    ibore     =          1/ifqc-15/sr
; AMPLITUDE ENVELOPE
    kenv1     linseg     0, .005, .55+.3*p6, p3-.015, .55+.3*p6, .01, 0
; VIBRATO ENVELOPE
    kenvibr   linseg     0, .1, 0, .9, 1, p3-1, 1
; REED STIFFNESS
    kemboff   =          p8
; BREATH PRESSURE
    avibr     oscil      .1*kenvibr, 5, 3
    apressm   =          kenv1 + avibr
; REFLECTION FILTER FROM THE BELL IS LOWPASS
    arefilt   tone      areedbell, ifco
; THE DELAY FROM BELL TO REED
    abellreed delay     arefilt, ibore
; BACK PRESSURE AND REED TABLE LOOK UP
    asum2     =         -apressm - .95*arefilt - kemboff
    areedtab  tablei    asum2/4+.34, p9, 1, .5
    amult1    =         asum2 * areedtab
; FORWARD PRESSURE
    asum1     =         apressm + amult1
    areedbell delay     asum1, ibore
    aofilt    atone     areedbell, ifco
              out       aofilt*p4
              endin
</CsInstruments>
<CsScore>
; TABLE FOR REED PHYSICAL MODEL
f1 0 256 7 1 80 1 156 -1 40 -1
; SINE
f3 0 16384 10 1
t 0 600
; CLARINET
;   START  DUR    AMP      PITCH   PRESS  FILTER     EMBOUCHURE  REED TABLE
;               (20000) (8.00-9.00) (0-2) (500-1200)   (0-1)
i 1903    0    16     6000      8.00     1.5  1000         .2            1
i 1903    +     4     .         8.01     1.8  1000         .2            1
i 1903    .     2     .         8.03     1.6  1000         .2            1
i 1903    .     2     .         8.04     1.7  1000         .2            1
i 1903    .     2     .         8.05     1.7  1000         .2            1
i 1903    .     2     .         9.03     1.7  1000         .2            1
i 1903    .     4     .         8.00     1.7  1000         .2            1
i 1903    +    16     .         9.00     1.8  1000         .2            1
</CsScore>
</CsoundSynthesizer>
```

---

## Detailed Explanation

### Orchestra Header

```csound
sr = 44100       ; Sample rate
ksmps = 1        ; CRITICAL: Must be 1 for accurate waveguide modeling
nchnls = 1       ; Mono output (clarinet is naturally mono)
0dbfs = 32768    ; 16-bit amplitude reference
```

**Critical Note on ksmps:**
`ksmps = 1` is essential for waveguide synthesis! The delay lines and feedback loops must operate at sample rate for accurate physical modeling. Higher ksmps would introduce quantization errors in the delay times, destroying the acoustic accuracy.

### Instrument 1903 - Physical Clarinet Model

#### Initialization

```csound
areedbell init 0
```
**Initialize feedback path**
Physical models use feedback loops (sound traveling back and forth in the bore). The `areedbell` variable must be initialized to prevent undefined behavior on the first sample.

#### Pitch and Physical Parameters

```csound
ifqc = cpspch(p5)
```
**Convert pitch to frequency**
- `p5` is in Csound pitch notation (8.00 = middle C, 9.00 = C one octave up)
- `cpspch()` converts to Hz (8.00 = 261.63 Hz)
- This determines the fundamental pitch of the clarinet

```csound
ifco = p7
```
**Bell filter cutoff frequency**
- Controls the brightness/darkness of the tone
- Range: 500-1200 Hz typical
- Lower = darker, mellower tone
- Higher = brighter, edgier tone
- Simulates the frequency-dependent radiation pattern of the clarinet bell

```csound
ibore = 1/ifqc - 15/sr
```
**Calculate bore length (delay time)**
This is a key physical modeling equation:
- `1/ifqc` = period of the fundamental frequency
- `15/sr` = compensation factor (15 samples)
- The delay line represents the time for a pressure wave to travel from reed to bell and back
- For a clarinet, the bore acts as a closed-open pipe (closed at reed, open at bell)
- The delay time sets the fundamental resonance

**Physics:**
In a real clarinet, the bore length determines pitch. Here we're calculating the equivalent acoustic delay time.

#### Amplitude Envelope (Breath Pressure Envelope)

```csound
kenv1 linseg 0, .005, .55+.3*p6, p3-.015, .55+.3*p6, .01, 0
```
**Breath pressure control** - Three-segment envelope:

1. **Attack (.005 sec):** 0 → (.55 + .3×p6)
   - Very fast attack (5ms) - clarinet starts quickly
   - Target level depends on p6 (breath pressure parameter)

2. **Sustain (p3-.015 sec):** Holds at (.55 + .3×p6)
   - Most of the note duration
   - Pressure parameter p6 ranges 0-2:
     - p6=0: level = 0.55 (soft)
     - p6=1.5: level = 1.0 (medium)
     - p6=2: level = 1.15 (loud/forced)

3. **Release (.01 sec):** (.55 + .3×p6) → 0
   - Quick release (10ms) - clarinet stops quickly
   - Simulates tongue stopping the reed

**Why these values?**
The base value of 0.55 ensures minimum breath pressure even at p6=0, preventing the reed from closing completely.

#### Vibrato Envelope

```csound
kenvibr linseg 0, .1, 0, .9, 1, p3-1, 1
```
**Vibrato depth control** - Delayed vibrato (natural for wind instruments):

1. **Delay (.1 sec):** 0 → 0
   - No vibrato at note start

2. **Fade-in (.9 sec):** 0 → 1
   - Gradual introduction of vibrato
   - Mimics natural player behavior

3. **Sustain (p3-1 sec):** Full vibrato
   - Continues until release

**Natural playing:**
Real clarinet players don't apply vibrato immediately - it develops during the note.

#### Embouchure (Reed Stiffness)

```csound
kemboff = p8
```
**Embouchure offset** - Reed stiffness parameter
- p8 typically 0.0-1.0
- 0.0 = loose embouchure (softer attack, breathier)
- 0.2 = normal (example value)
- 1.0 = tight embouchure (harder attack, focused)
- Affects reed table lookup offset
- Controls how the reed responds to pressure

#### Vibrato Generation

```csound
avibr oscil .1*kenvibr, 5, 3
```
**Pitch vibrato oscillator**
- `.1*kenvibr` = vibrato depth (controlled by envelope)
- `5` = vibrato rate (5 Hz, typical for clarinet)
- `3` = sine wave table
- Maximum ±0.1 deviation in pressure (creates pitch variation)

```csound
apressm = kenv1 + avibr
```
**Total breath pressure** = envelope + vibrato
- Combines steady breath pressure with vibrato modulation

#### Waveguide Feedback Loop

This is the heart of the physical model - a feedback loop simulating the acoustic bore:

```csound
arefilt tone areedbell, ifco
```
**Bell reflection filter** (lowpass)
- `areedbell` = pressure wave returning from the bell
- `ifco` = cutoff frequency
- Simulates frequency-dependent radiation from the bell
- High frequencies radiate more efficiently (absorbed by filter)
- Low frequencies reflect back more strongly

```csound
abellreed delay arefilt, ibore
```
**Acoustic delay from bell to reed**
- `ibore` = calculated bore length/delay time
- Simulates the physical time for pressure wave to travel through the bore
- This delay sets the fundamental pitch

#### Reed Nonlinearity (The Key to Realistic Sound)

```csound
asum2 = -apressm - .95*arefilt - kemboff
```
**Calculate pressure differential across reed**
- `-apressm` = negative breath pressure (pushing reed closed)
- `-.95*arefilt` = reflected pressure from bore (0.95 = slight damping)
- `-kemboff` = embouchure bias
- This sum determines how much the reed opens/closes

```csound
areedtab tablei asum2/4+.34, p9, 1, .5
```
**Reed response lookup table**
- `asum2/4+.34` = scale and offset pressure to table index range
- `p9` = reed table number (f1)
- Table shape determines reed nonlinearity
- This is what makes the sound "clarinet-like" vs. other woodwinds
- The nonlinear response creates characteristic harmonics

**Reed physics:**
Real reeds don't open/close linearly with pressure - the table models this nonlinearity.

```csound
amult1 = asum2 * areedtab
```
**Flow through reed opening**
- Pressure difference × reed opening area = airflow
- This is the sound injected into the bore

#### Forward Propagation

```csound
asum1 = apressm + amult1
```
**Total forward pressure**
- Breath pressure + reed-modulated flow
- This propagates down the bore toward the bell

```csound
areedbell delay asum1, ibore
```
**Delay from reed to bell** (completes the feedback loop)
- Same delay time as bell-to-reed
- The output of this feeds back to `arefilt` (top of loop)
- **This feedback loop is the essence of waveguide synthesis**

#### Output Filtering

```csound
aofilt atone areedbell, ifco
```
**High-pass filter output**
- `atone` = high-pass filter (removes DC and very low frequencies)
- `ifco` = cutoff matches the bell filter
- Prevents DC buildup in the feedback loop
- Shapes the final tone

```csound
out aofilt*p4
```
**Scale and output**
- `p4` = amplitude scaling
- Final clarinet sound

### Score Section

#### Function Tables

```csound
f1 0 256 7 1 80 1 156 -1 40 -1
```
**Reed response table** (GEN07 - linear segments)
- Size: 256 points
- Structure:
  - Points 0-80: Value = 1 (reed fully open)
  - Points 80-236 (80+156): Value = 1 → -1 (linear transition)
  - Points 236-256 (40 points): Value = -1 (reed closed/reversed)

**Physical meaning:**
- Positive pressure → positive flow (normal)
- Very high pressure → negative flow (reed closes against the mouthpiece)
- This S-shaped nonlinearity is characteristic of single-reed instruments

**Why this shape matters:**
- The sharp transition creates the odd harmonics characteristic of clarinets
- Different reed table shapes = different woodwind instruments (oboe, saxophone, etc.)

```csound
f3 0 16384 10 1
```
**Sine wave for vibrato**
- Standard sine wave
- 16384 points for smooth vibrato

```csound
t 0 600
```
**Tempo:** 600 beats per minute (fast tempo for demonstration)

#### Note Events - Clarinet Melody

**p-field mapping:**
- p1 = Instrument (1903)
- p2 = Start time
- p3 = Duration
- p4 = Amplitude
- p5 = Pitch (Csound notation)
- p6 = Breath pressure (0-2)
- p7 = Filter cutoff (500-1200 Hz)
- p8 = Embouchure (0-1)
- p9 = Reed table number

**Score shortcuts:**
- `+` in p2 = start after previous note
- `.` in p3 = same as previous
- `.` in other fields = same as previous

**Melody analysis:**
```csound
i 1903  0   16  6000  8.00  1.5  1000  .2  1   ; Long C, medium pressure
i 1903  +    4    .   8.01  1.8  1000  .2  1   ; C# (shorter), more pressure
i 1903  .    2    .   8.03  1.6  1000  .2  1   ; D# (even shorter)
i 1903  .    2    .   8.04  1.7  1000  .2  1   ; E
i 1903  .    2    .   8.05  1.7  1000  .2  1   ; F
i 1903  .    2    .   9.03  1.7  1000  .2  1   ; D# (octave higher)
i 1903  .    4    .   8.00  1.7  1000  .2  1   ; Back to C
i 1903  +   16    .   9.00  1.8  1000  .2  1   ; High C (long)
```

**Musical gesture:**
- Starts with a long, sustained low C
- Ascending scale with increasing pressure
- Jumps up an octave
- Returns to starting pitch
- Ends on high C (octave above start)

---

## Key Concepts

### Waveguide Synthesis Fundamentals

**What is a waveguide?**
A digital delay line representing the physical medium (air column) in which sound waves propagate.

**Core principle:**
Sound in a tube travels at the speed of sound. A digital delay simulates the travel time:
```
delay_time = tube_length / speed_of_sound
```

In our model:
```
ibore = 1/ifqc - 15/sr
```
This gives the delay time that produces the desired pitch.

**Feedback loop:**
```
Reed → Bore (delay) → Bell (filter + reflection) → Bore (delay) → Reed
```

This circular path creates:
- Standing waves at resonant frequencies
- Sustained oscillation
- Natural harmonics of the instrument

### Physical Modeling vs. Other Synthesis Methods

**Sample playback:**
- Pro: Realistic timbres
- Con: Static, limited expressiveness, large memory

**Subtractive synthesis:**
- Pro: Flexible, efficient
- Con: Doesn't sound like real instruments

**Physical modeling:**
- Pro: Expressive, responds naturally to parameters, small memory
- Con: CPU intensive, requires understanding of physics

**Key advantage:**
Parameters have physical meaning (breath pressure, embouchure) making them intuitive and expressive.

### Reed Instruments - Clarinet Specifics

**Clarinet acoustics:**
- Cylindrical bore (unlike conical oboe/saxophone)
- Closed-open pipe (closed at reed, open at bell)
- Odd harmonics dominate (1st, 3rd, 5th... harmonics strong)
- Even harmonics weak (characteristic clarinet hollow sound)

**Why odd harmonics?**
The reed acts like a closed end, and a closed-open pipe resonates at:
```
f, 3f, 5f, 7f... (odd multiples only)
```

The reed table nonlinearity generates these harmonics naturally.

### The Importance of ksmps = 1

**Why sample-rate accuracy matters:**

At 44100 Hz, one sample = 0.0227 ms

For a 440 Hz clarinet:
- Period = 2.27 ms = 100 samples
- Error of 1 sample = 1% pitch error

With ksmps > 1:
- Delay times quantized to k-rate
- Pitch becomes unstable
- Feedback loop becomes inaccurate
- Physical modeling breaks down

**Trade-off:**
ksmps=1 is CPU intensive but essential for accuracy.

---

## Parameter Exploration

### Breath Pressure (p6)

- **0.0-1.0** - Soft playing (pp to mf)
  - Lower harmonics
  - More fundamental
  - Subdued tone

- **1.0-1.5** - Normal playing (mf to f)
  - Balanced harmonics
  - Characteristic clarinet sound
  - Good for melody

- **1.5-2.0** - Loud playing (f to ff)
  - More upper harmonics
  - Brighter, more aggressive
  - Risk of overblowing (multiphonics)

- **> 2.0** - Overblowing
  - Can jump to higher register
  - Unstable, squeaks
  - Musically useful for effects

### Filter Cutoff (p7)

- **500-700 Hz** - Dark, mellow
  - Jazz clarinet sound
  - Chalumeau register character
  - Woody tone

- **800-1000 Hz** - Balanced (example uses 1000)
  - Classical clarinet
  - Clear but not harsh
  - Most versatile

- **1100-1200 Hz** - Bright
  - Modern/contemporary sound
  - More edge and presence
  - Good for cutting through ensemble

### Embouchure (p8)

- **0.0-0.1** - Loose
  - Breathy attacks
  - Less focused pitch
  - Softer tone

- **0.2** - Normal (example value)
  - Clean attacks
  - Stable pitch
  - Controlled tone

- **0.3-0.5** - Tight
  - Sharp attacks
  - Very focused
  - Can sound strained

- **> 0.5** - Very tight
  - Hard, percussive attacks
  - Risk of squeaks
  - Unnatural if too high

### Pitch Ranges

**Csound pitch notation:**
- 8.00 = C4 (middle C) ≈ 261.63 Hz
- 9.00 = C5 (octave up) ≈ 523.25 Hz
- 8.01 = C#4
- 8.02 = D4
- etc.

**Clarinet practical ranges:**
- **Chalumeau (low):** 7.02-7.11 (D3-B3)
- **Throat tones:** 8.00-8.04 (C4-E4) - can be weak
- **Clarion (mid):** 8.05-9.07 (F4-G5) - strongest register
- **Altissimo (high):** 9.08+ (Ab5+) - requires higher pressure

---

## Variations

### Adding Tonguing Articulation

```csound
; Simulate tongue attacks
ktongue linseg 0, 0.002, 1, 0.003, 0.8, p3-0.005, 0.8
kenv1 = ktongue * kenv1  ; Modulate breath with tongue
```

### Breath Noise (More Realistic)

```csound
; Add subtle breath turbulence
anoise rand 0.02
apressm = kenv1 + avibr + anoise*kenv1
```

### Dynamic Vibrato Rate

```csound
; Vibrato rate increases with pressure
kvibrrate = 4 + kenv1  ; 4-5.5 Hz range
avibr oscil .1*kenvibr, kvibrrate, 3
```

### Altissimo Register (Overblowing)

```csound
; Jump to higher register with increased pressure
if p6 > 1.8 then
  ibore = 1/(ifqc*3) - 15/sr  ; Third harmonic (altissimo)
endif
```

### Stereo Clarinet with Room Simulation

```csound
nchnls = 2
; ... (clarinet model as before)
al, ar freeverb aofilt*p4, aofilt*p4, 0.8, 0.5
outs al, ar
```

### Adjustable Vibrato Depth and Rate

```csound
; p10 = vibrato depth, p11 = vibrato rate
avibr oscil p10*kenvibr, p11, 3
```

### Portamento Between Notes

```csound
; Smooth pitch glide
ioldpitch init 8.00
inewpitch = p5
kpitch linseg cpspch(ioldpitch), 0.1, cpspch(inewpitch)
ifqc = kpitch
ioldpitch = inewpitch
```

### Multi-Stage Attack Envelope

```csound
; More realistic attack with initial "pop"
kenv1 linseg 0, 0.001, 0.9, 0.004, 0.6, p3-0.015, .55+.3*p6, .01, 0
```

### Saxophone from Clarinet (Change Reed Table)

```csound
; Conical bore instrument - different reed table
; f2 0 256 7 0.8 80 0.8 156 -0.8 40 -0.8
; Use f2 instead of f1 for more "saxlike" response
```

---

## Common Issues & Solutions

### No Sound or Very Quiet
**Problem:** Model produces little or no output
**Cause:**
- ksmps > 1 (destroys waveguide)
- Breath pressure too low
- Reed table not loaded

**Solution:**
```csound
; Ensure these settings:
ksmps = 1                    ; MUST be 1
0dbfs = 32768               ; Match amplitude range
p6 = 1.0-1.8                ; Adequate breath pressure
; Verify reed table exists: f1 0 256 7 1 80 1 156 -1 40 -1
```

### Unstable Pitch or Squeaks
**Problem:** Pitch wavers or jumps to harmonics unexpectedly
**Cause:** Breath pressure too high or embouchure too tight
**Solution:**
```csound
; Reduce parameters:
p6 = 1.0-1.5                ; Lower pressure
p8 = 0.1-0.3                ; Looser embouchure
; Or add damping:
arefilt tone areedbell, ifco*0.8  ; Lower filter cutoff
```

### Sound Cuts Off or Doesn't Sustain
**Problem:** Note dies away instead of sustaining
**Cause:** Insufficient feedback gain or too much damping
**Solution:**
```csound
; Increase feedback:
asum2 = -apressm - 0.98*arefilt - kemboff  ; Was 0.95, now 0.98
; Or increase breath pressure:
p6 = 1.5-1.8
```

### Harsh, Unrealistic Tone
**Problem:** Sound too bright or buzzy
**Cause:** Filter cutoff too high or attack too fast
**Solution:**
```csound
p7 = 600-800                ; Lower cutoff
; Slower attack:
kenv1 linseg 0, .01, .55+.3*p6, p3-.02, .55+.3*p6, .01, 0
```

### DC Offset or Rumble
**Problem:** Very low frequency build-up, meter shows DC
**Cause:** Feedback loop not balanced
**Solution:**
```csound
; Ensure high-pass on output:
aofilt atone areedbell, ifco
; Or stronger high-pass:
aofilt atone areedbell, 20  ; Remove <20 Hz
```

### CPU Overload
**Problem:** Dropouts, "can't keep up" errors
**Cause:** ksmps=1 is very demanding
**Solution:**
- Limit polyphony (5-10 simultaneous notes max)
- Increase hardware buffer size (-b flag)
- Simplify envelope generators
- Use simpler vibrato (or remove it)
- Consider `wguide1` or `wguide2` opcodes (more efficient)

### Wrong Pitch
**Problem:** Pitch doesn't match p5 value
**Cause:** Bore calculation error or sr mismatch
**Solution:**
```csound
; Verify:
ifqc = cpspch(p5)           ; Correct conversion
ibore = 1/ifqc - 15/sr      ; Correct formula
sr = 44100                   ; Matches audio hardware
```

---

## Sound Design Applications

### Expressive Solo Clarinet

```csound
; Detailed expressive control
kenv1 linseg 0, 0.01, 0.7, 0.1, 0.6, p3-0.2, 0.65, 0.1, 0
kenvibr linseg 0, 0.5, 0, 0.5, 1, p3-1, 1
kvibrrate = 4.5 + kenv1*0.5  ; Dynamic vibrato
avibr oscil .08*kenvibr, kvibrrate, 3
```

### Jazz Clarinet (Growl Effect)

```csound
; Add subharmonic growl
agrowl rand 0.15*kenv1
apressm = kenv1 + avibr + agrowl
ifco = 700  ; Darker filter for jazz tone
```

### Multiphonic Effects

```csound
; Intentional overblowing for two simultaneous pitches
p6 = 2.0-2.5  ; High pressure
; Reed oscillates between fundamental and overtone
```

### Clarinet Ensemble (Multiple Instances)

```csound
; Score with slightly detuned clarinets
i1903 0 4 6000 8.00 1.5 1000 0.2 1
i1903 0 4 5800 8.001 1.48 1010 0.21 1  ; Slightly detuned
i1903 0 4 5900 8.002 1.52 990 0.19 1   ; More detuning
; Creates chorus/ensemble effect
```

---

## Advanced Topics

### The Mathematics of Waveguides

**Wave equation in 1D:**
```
∂²p/∂t² = c² ∂²p/∂x²
```
Where:
- p = pressure
- c = speed of sound
- t = time
- x = position

**D'Alembert's solution:**
Traveling waves in both directions:
```
p(x,t) = f(x - ct) + g(x + ct)
```
- f = wave traveling right (+x direction)
- g = wave traveling left (-x direction)

**Digital waveguide:**
Two delay lines simulate these bidirectional waves:
```
delay_right[n] = f[n - D]
delay_left[n] = g[n - D]
```
Where D = delay in samples

### Scattering Junctions

At discontinuities (reed, bell, finger holes), waves partially:
- **Reflect** back toward source
- **Transmit** through discontinuity

**Reflection coefficient:**
```
r = (Z2 - Z1) / (Z2 + Z1)
```
Where Z1, Z2 are acoustic impedances

In our model:
- Reed: Strong reflection (closed end, r ≈ -1)
- Bell: Partial reflection (open end, r ≈ +0.95 from `.95*arefilt`)
- Filter simulates frequency-dependent impedance

### Reed Table Design

The reed table f1 models the **volume velocity** through the reed opening as a function of **pressure difference**.

**Physical behavior:**
1. Low pressure: Linear opening (proportional flow)
2. Medium pressure: Nonlinear saturation (reed reaching limits)
3. High pressure: Closure (reed pressed against mouthpiece, negative flow)

**Different instruments:**
- **Clarinet:** Sharp nonlinearity (strong odd harmonics)
- **Saxophone:** Smoother curve (more even harmonics)
- **Oboe/Bassoon:** Double reed (different table shape)

### Bore Geometry Effects

**Cylindrical bore** (clarinet):
```
ibore = 1/ifqc - 15/sr
```
Produces odd harmonics

**Conical bore** (saxophone, oboe):
Different delay calculations, all harmonics present

**Flared bell:**
Simulated by frequency-dependent radiation filter

---

## Related Examples

**Progression Path:**
1. **Current:** Basic waveguide clarinet
2. **Next:** `wguide1` / `wguide2` opcodes (more efficient)
3. **Then:** Multi-section waveguides (tone holes, complex bores)
4. **Advanced:** Complete wind controller with MIDI breath input

**Related Techniques:**
- `Flute Physical Model` - Different excitation (edge tone vs reed)
- `Bowed String Model` - Different excitation, similar waveguide principle
- `Plucked String (Karplus-Strong)` - Simplest waveguide model
- `Brass Instrument Model` - Lip reed instead of cane reed

**Related Opcodes:**
- `wguide1` - Efficient single waveguide
- `wguide2` - Stereo waveguide with loss filter
- `repluck` - Simplified waveguide for plucked strings
- `prepiano` - Physical model piano (similar principles)
- `barmodel` - Struck bar (percussion physical model)

---

## Performance Notes

- **CPU Usage:** High (ksmps=1 is demanding)
- **Polyphony:** Limit to 5-10 simultaneous notes
- **Real-time Safe:** Yes, but requires low-latency setup
- **Latency:** Minimal (ksmps=1 = 0.023ms per sample)
- **Memory:** Very low (just delay lines and one small table)
- **Expressiveness:** Extremely high - responds naturally to parameter changes

**Optimization Tips:**
- Use `-b` and `-B` flags to set buffer sizes appropriately
- Consider `wguide2` opcode for better efficiency
- Cache constant calculations outside the loop
- Limit vibrato oscillator update rate if needed

---

## Historical Context

**Karplus-Strong (1983):**
First practical waveguide synthesis (plucked string) - showed that simple feedback delay could produce realistic instruments.

**Julius O. Smith III (1980s-90s):**
Developed the mathematical framework for digital waveguide synthesis, showing how to model complex instruments with simple delay lines and filters.

**Physical Modeling in Csound:**
- Early implementations in the 1990s
- `wguide` opcodes added for efficiency
- Now standard technique for acoustic instrument simulation

**Impact:**
Physical modeling revolutionized computer music by providing:
- Expressive, controllable synthesis
- Realistic acoustic instrument emulation
- Small memory footprint (vs samples)
- Musical understanding through physics

---

## Extended Documentation

**Official Csound Opcode References:**
- [delay](https://csound.com/docs/manual/delay.html)
- [tone](https://csound.com/docs/manual/tone.html)
- [atone](https://csound.com/docs/manual/atone.html)
- [wguide1](https://csound.com/docs/manual/wguide1.html)
- [wguide2](https://csound.com/docs/manual/wguide2.html)

**Academic References:**
- Smith, Julius O. III: "Physical Modeling Using Digital Waveguides"
- Cook, Perry R.: "Real Sound Synthesis for Interactive Applications"
- Välimäki et al.: "Physical Modeling of Plucked String Instruments"

**Acoustics References:**
- Benade, Arthur: "Fundamentals of Musical Acoustics"
- Fletcher & Rossing: "The Physics of Musical Instruments"

**Learning Resources:**
- Csound FLOSS Manual: Chapter 4.6 (Physical Modeling)
- The Csound Book: "Physical Models" chapter by Perry Cook
- Stanford CCRMA: Digital Waveguide Archive (online resources)
