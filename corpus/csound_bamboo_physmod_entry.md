# Physical Modeling: Bamboo Percussion

## Metadata

- **Title:** Physical Modeling: Bamboo Percussion (Semi-Physical Model)
- **Category:** Physical Modeling / Percussion Synthesis / Stochastic Models
- **Difficulty:** Beginner/Intermediate
- **Tags:** `bamboo`, `physical-modeling`, `percussion`, `physmod`, `stochastic`, `shaker`, `idiophone`, `world-percussion`, `organic-sounds`, `resonant-objects`
- **Source File:** `bamboo.aiff`

---

## Description

The `bamboo` opcode is a semi-physical model that simulates the sound of bamboo wind chimes, sticks, or similar hollow wooden percussion instruments. Part of Perry Cook's PhISEM (Physically Informed Stochastic Event Modeling) family, it combines physical acoustics principles with stochastic (random) processes to create realistic percussive sounds. Unlike detailed waveguide models, PhISEM opcodes use simplified physical models with randomness to efficiently generate natural-sounding percussion.

**Use Cases:**
- World music and ethnic percussion
- Bamboo wind chimes and natural soundscapes
- Idiophonic percussion (struck bamboo, wood blocks)
- Foley and sound design for film/games
- Minimalist and ambient music textures
- Creating organic, non-electronic percussive sounds

**What is PhISEM?**
Physically Informed Stochastic Event Modeling combines:
1. **Physical principles** - Basic acoustic properties (resonances, decay)
2. **Stochastic processes** - Random events (individual bamboo pieces rattling)
3. **Efficient computation** - Simplified models for real-time use

**Result:** Realistic percussion sounds with organic variation, computed efficiently.

---

## Complete Code

```csound
<CsoundSynthesizer>
<CsOptions>
-o bamboo.aiff
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
instr 1
; bamboo is a semi-physical model of a bamboo sound
;            kamp  idettack  inum  idamp imaxshake ifreq  ifreq1
asig  bamboo p4,   0.01,     0,    0,    .25,      p5,    p6
      out    asig, asig
endin
</CsInstruments>
<CsScore>
0dbfs = 32768
;inst start  dur  amp    freq  freq2
i1    0      1    20000  2000  2300
i1    2      1    20000  1200  1500
i1    4      1    20000  800   3000
e
</CsScore>
</CsoundSynthesizer>
```

---

## Detailed Explanation

### Orchestra Header

```csound
sr = 44100
ksmps = 32      ; Standard control rate
nchnls = 2      ; Stereo output
```

**Note on ksmps:**
Unlike waveguide synthesis (ksmps=1), PhISEM models don't require sample-rate precision. `ksmps = 32` is efficient and sufficient.

### Instrument 1 - Bamboo Model

```csound
asig  bamboo p4, 0.01, 0, 0, .25, p5, p6
```

**bamboo opcode** - Semi-physical percussion model

**Parameter breakdown:**

#### 1. `kamp = p4` - Amplitude
- Controls output level
- p4 = 20000 in examples (moderate level at 0dbfs=32768)
- Can be k-rate for dynamic control

#### 2. `idettack = 0.01` - Decay Time Attack
- Initial burst decay rate
- 0.01 = fast attack/decay (quick strike)
- Range: 0.01-1.0
- **Lower values** (0.01-0.05): Sharp, crisp attack
- **Higher values** (0.5-1.0): Slower, more sustained

**Physical meaning:**
How quickly the initial strike energy dissipates. Real bamboo has very fast attack.

#### 3. `inum = 0` - Number of Beads/Pieces
- Number of individual bamboo tubes/beads simulated
- 0 = use default (~10-20 internal)
- Can specify 1-100+
- **More beads** = denser, more complex timbre
- **Fewer beads** = sparser, clearer sound

**Physical meaning:**
Bamboo wind chimes have multiple tubes. Each tube contributes to the overall sound.

#### 4. `idamp = 0` - Damping Amount
- Damping coefficient (energy loss)
- 0 = use default damping (natural decay)
- Range: 0-1
- **Low (0-0.3)**: Longer resonance, ringing
- **High (0.7-1.0)**: Shorter, more damped

**Physical meaning:**
Air resistance and material damping in real bamboo.

#### 5. `imaxshake = 0.25` - Maximum Shake Energy
- Controls randomness/intensity of rattling
- Range: 0-1
- 0.25 = moderate shake (example value)
- **Low (0-0.2)**: Subtle, gentle rattling
- **High (0.5-1.0)**: Vigorous, chaotic

**Physical meaning:**
How hard the bamboo pieces are shaken/struck together.

#### 6. `ifreq = p5` - Main Resonant Frequency
- Primary resonance in Hz
- p5 values: 2000, 1200, 800 Hz
- **Lower** (100-500 Hz): Deeper, larger bamboo
- **Mid** (500-2000 Hz): Standard bamboo tubes
- **Higher** (2000-5000 Hz): Small, bright bamboo

**Physical meaning:**
Fundamental resonance of the bamboo tubes. Larger tubes = lower frequency.

#### 7. `ifreq1 = p6` - Secondary Resonant Frequency
- Second resonance in Hz
- p6 values: 2300, 1500, 3000 Hz
- Usually **higher** than ifreq
- Creates inharmonic timbre (characteristic of bamboo)

**Physical meaning:**
Bamboo has multiple resonant modes. Two resonances create the hollow, woody timbre.

**Relationship between ifreq and ifreq1:**
- **Close together** (ifreq=1000, ifreq1=1100): More tonal, bell-like
- **Far apart** (ifreq=800, ifreq1=3000): Inharmonic, more bamboo-like
- **Ratio matters**: Non-integer ratios = more natural

### Output

```csound
out asig, asig
```
**Mono to stereo:**
Same signal to both channels. Could pan or process differently for stereo width.

### Score Section

```csound
0dbfs = 32768   ; 16-bit amplitude range
```

#### Note Events

**Event 1:**
```csound
i1  0  1  20000  2000  2300
```
- **0-1 seconds**
- Amplitude: 20000
- **Freq1:** 2000 Hz (high, bright)
- **Freq2:** 2300 Hz (close interval, 300 Hz apart)
- **Sound:** High-pitched bamboo, relatively tonal

**Event 2:**
```csound
i1  2  1  20000  1200  1500
```
- **2-3 seconds**
- **Freq1:** 1200 Hz (mid-range)
- **Freq2:** 1500 Hz (300 Hz apart again)
- **Sound:** Medium bamboo, warmer than event 1

**Event 3:**
```csound
i1  4  1  20000  800  3000
```
- **4-5 seconds**
- **Freq1:** 800 Hz (low)
- **Freq2:** 3000 Hz (2200 Hz apart!)
- **Sound:** Large bamboo with very inharmonic spectrum, most bamboo-like

**Pattern:**
Three descending strikes (high→mid→low) but with increasing inharmonicity (300→300→2200 Hz separation).

---

## Key Concepts

### PhISEM (Physically Informed Stochastic Event Modeling)

**Philosophy:**
Instead of modeling every detail of the physics (like waveguide synthesis), PhISEM uses:

1. **Simplified physics** - Basic resonances, decay rates
2. **Stochastic (random) events** - Individual rattles/strikes
3. **Perceptual modeling** - "Sounds like" bamboo vs. perfect physics

**Advantages:**
- **Efficient:** Real-time capable, low CPU
- **Natural variation:** Randomness creates organic quality
- **Simple control:** Few parameters for complex sounds

**PhISEM family opcodes:**
- `bamboo` - Bamboo wind chimes/sticks
- `cabasa` - Afro-Cuban shaker
- `guiro` - Scraped gourd
- `sekere` - Beaded shaker
- `shaker` - Generic shaker
- `sleighbells` - Sleigh bells
- `tambourine` - Tambourine
- All share similar parameter structure

### Physical Model vs. Semi-Physical Model

**Full physical model** (like waveguide clarinet):
- Simulates actual physics equations
- Sample-accurate processing
- High CPU cost
- Deterministic output (same input = same output)

**Semi-physical model** (PhISEM/bamboo):
- Abstracts physics to key parameters
- Uses randomness for detail
- Low CPU cost
- Stochastic output (same input ≈ similar but not identical output)

**Bamboo characteristics:**
- **Resonant frequencies:** Physical property
- **Decay time:** Physical property
- **Number of tubes:** Physical property
- **Exact collision timing:** Stochastic (random)

### Resonant Frequencies and Timbre

**Two resonances create bamboo timbre:**

**Harmonic (tonal):**
If ifreq1 = 2 × ifreq (octave):
- More musical, bell-like
- Less "woody"

**Inharmonic (bamboo-like):**
If ifreq1 and ifreq are not simple ratios:
- Characteristic bamboo sound
- Hollow, woody timbre
- More realistic

**Example 3 analysis:**
- ifreq = 800 Hz
- ifreq1 = 3000 Hz
- Ratio: 3000/800 = 3.75 (not a simple integer)
- Result: Strong inharmonic character, very bamboo-like

### Stochastic Behavior

Each trigger creates slightly different sound:
- Random collision times between bamboo pieces
- Variation in energy distribution
- Natural irregularity

**This is a feature, not a bug!**
Real bamboo never sounds exactly the same twice. The randomness creates realism.

---

## Parameter Exploration

### Main Resonant Frequency (ifreq)

**Low (100-500 Hz):**
- Large, thick bamboo tubes
- Deep, resonant
- Wind chimes with big tubes
- More "wooden" than "rattly"

**Mid (500-2000 Hz):**
- Standard bamboo tubes
- Balanced timbre
- Most recognizable bamboo sound

**High (2000-5000 Hz):**
- Small, thin bamboo
- Bright, tinkling
- Delicate wind chimes
- More "glassy" quality

**Very High (5000+ Hz):**
- Tiny bamboo or wooden beads
- Bright, almost metallic
- Less realistic bamboo

### Secondary Frequency (ifreq1) Relationship

**Close to ifreq (within 20%):**
```csound
ifreq = 1000, ifreq1 = 1100  ; 10% apart
```
- More tonal
- Bell-like quality
- Less bamboo character

**Moderate separation (50-100% higher):**
```csound
ifreq = 1000, ifreq1 = 1500  ; 50% higher
```
- Good bamboo character
- Balanced inharmonicity

**Wide separation (2-4× higher):**
```csound
ifreq = 800, ifreq1 = 3000  ; 3.75× higher
```
- Strong inharmonic character
- Most realistic bamboo
- Hollow, woody timbre

**Very wide (>4× higher):**
```csound
ifreq = 500, ifreq1 = 3000  ; 6× higher
```
- Extremely inharmonic
- Can sound less coherent
- Experimental timbres

### Decay Time (idettack)

**Very fast (0.01-0.05):**
- Sharp, percussive attack
- Quick decay
- Struck bamboo sticks
- Clear articulation

**Fast (0.05-0.1):**
- Crisp but not too short
- Good for rhythmic patterns

**Medium (0.1-0.5):**
- Sustained resonance
- Hanging wind chimes
- More "singing" quality

**Slow (0.5-1.0):**
- Long, sustained
- Less percussive
- Atmospheric textures
- Can lose bamboo character

### Maximum Shake (imaxshake)

**Gentle (0.05-0.2):**
- Subtle rattling
- Delicate wind chimes
- Soft breeze

**Moderate (0.2-0.4):**
- Clear bamboo sound
- Normal striking force
- Good for most applications

**Vigorous (0.4-0.7):**
- Strong rattling
- Hard strikes
- Dense texture

**Violent (0.7-1.0):**
- Chaotic
- Very dense
- Can sound harsh
- Experimental/aggressive

### Number of Beads (inum)

**Few (1-5):**
- Sparse texture
- Individual pieces audible
- Simple, clean

**Moderate (10-20):**
- Balanced density
- Realistic bamboo chimes
- Default behavior (inum=0)

**Many (30-100):**
- Dense, complex
- Rich timbre
- Can sound more like shaker than bamboo

**Note:** Default (0) usually gives best results. Explicit values for special effects.

---

## Variations

### Wind Chimes (Gentle, Sustained)

```csound
asig bamboo 15000, 0.3, 0, 0.1, 0.15, 1200, 1800
; Slower decay, low shake, low damping = gentle chimes
```

### Struck Bamboo Sticks (Percussive)

```csound
asig bamboo 25000, 0.02, 0, 0.5, 0.4, 800, 2500
; Fast decay, higher shake, more damping = sharp strike
```

### Large Bamboo Tubes (Deep)

```csound
asig bamboo 20000, 0.08, 0, 0.2, 0.25, 200, 450
; Low frequencies, moderate settings = large tubes
```

### Bamboo Ensemble (Multiple Sizes)

```csound
a1 bamboo 10000, 0.02, 0, 0.3, 0.3, 400, 1200   ; Small
a2 bamboo 10000, 0.03, 0, 0.2, 0.3, 800, 1800   ; Medium
a3 bamboo 10000, 0.05, 0, 0.1, 0.3, 1200, 2500  ; Large
asig = a1 + a2 + a3
out asig, asig
```

### Dynamic Shake Intensity

```csound
kshake linseg 0.1, p3/2, 0.6, p3/2, 0.1  ; Crescendo then diminuendo
asig bamboo 20000, 0.02, 0, 0, kshake, 1000, 1500
```

### Frequency Sweep (Morphing Bamboo Sizes)

```csound
kfreq expseg 2000, p3, 400      ; High to low
kfreq1 expseg 3000, p3, 800     ; Proportional sweep
asig bamboo 20000, 0.02, 0, 0, 0.25, kfreq, kfreq1
```

### Stereo Wind Chimes (Spatial)

```csound
a1 bamboo 15000, 0.2, 0, 0, 0.15, 1200, 1850
a2 bamboo 15000, 0.22, 0, 0, 0.17, 1180, 1820  ; Slightly different
outs a1, a2  ; Different L/R for spatial width
```

### Bamboo with Reverb (Ambient)

```csound
asig bamboo 20000, 0.1, 0, 0, 0.2, 1000, 1600
awet, awet2 reverbsc asig, asig, 0.85, 8000
amix = asig*0.3 + awet*0.7
outs amix, awet2
```

### Randomized Bamboo Pattern

```csound
; In score, randomize frequencies
ifreq random 400, 2000
ifreq1 random ifreq*1.2, ifreq*3
asig bamboo 20000, 0.02, 0, 0, 0.25, ifreq, ifreq1
```

---

## Common Issues & Solutions

### Too Harsh or Noisy
**Problem:** Sound is too chaotic, lacks bamboo character  
**Cause:** `imaxshake` too high or frequencies too high  
**Solution:**
```csound
; Reduce shake intensity
asig bamboo 20000, 0.02, 0, 0, 0.15, p5, p6  ; Lower shake (was 0.25)
; Or lower frequencies
; ifreq = 800 instead of 2000
```

### Sounds Too Tonal/Musical (Not Bamboo-Like)
**Problem:** Sounds more like bells than bamboo  
**Cause:** ifreq and ifreq1 too close (harmonic relationship)  
**Solution:**
```csound
; Increase frequency separation (inharmonicity)
asig bamboo 20000, 0.02, 0, 0, 0.25, 800, 2500  ; Was 800, 1000
; Use non-integer ratios
```

### Too Short/No Resonance
**Problem:** Sound dies immediately, no sustain  
**Cause:** `idettack` too low or `idamp` too high  
**Solution:**
```csound
; Increase decay time
asig bamboo 20000, 0.1, 0, 0, 0.25, p5, p6  ; Was 0.01, now 0.1
; Reduce damping
asig bamboo 20000, 0.02, 0, 0.05, 0.25, p5, p6  ; Lower idamp
```

### Not Enough Variation/Too Static
**Problem:** Each strike sounds identical  
**Cause:** Stochastic seed or lack of parameter variation  
**Solution:**
```csound
; Use k-rate parameters with slight randomness
kshake random 0.2, 0.3
asig bamboo 20000, 0.02, 0, 0, kshake, p5, p6
; Or vary frequencies slightly each note in score
```

### Too Quiet or Too Loud
**Problem:** Amplitude issues  
**Cause:** `kamp` parameter or 0dbfs scaling  
**Solution:**
```csound
; Adjust amplitude
asig bamboo 30000, 0.02, 0, 0, 0.25, p5, p6  ; Increase from 20000
; Or use different 0dbfs
0dbfs = 1.0  ; Modern normalized scale
; Then use amp = 0.5-0.8
```

### Sounds Metallic, Not Woody
**Problem:** Wrong timbre for bamboo  
**Cause:** Frequencies too high or too harmonic  
**Solution:**
```csound
; Use lower, more inharmonic frequencies
asig bamboo 20000, 0.02, 0, 0, 0.25, 600, 1800  ; Lower, wider
; Not: 3000, 3300 (too high, too close)
```

---

## Sound Design Applications

### Gentle Wind Chimes

```csound
; Soft, sustained, delicate
asig bamboo 12000, 0.25, 0, 0.05, 0.12, 1200, 1750
awet reverb asig, 3.5
out awet*0.7, awet*0.7
```

### Aggressive Bamboo Stick Fight

```csound
; Sharp, percussive, high shake
asig bamboo 28000, 0.015, 0, 0.6, 0.65, 900, 2200
out asig, asig
```

### Bamboo Rain Stick Effect

```csound
; Many quick triggers with randomness
schedule "bamboo_grain", 0, 5  ; Trigger instrument

instr bamboo_grain
  ktrig metro 20  ; 20 strikes per second
  if ktrig == 1 then
    iamp random 8000, 15000
    ifreq random 600, 1500
    ifreq1 random ifreq*1.5, ifreq*2.5
    asig bamboo iamp, 0.05, 0, 0.3, 0.2, ifreq, ifreq1
    out asig, asig
  endif
endin
```

### Meditation/Zen Garden

```csond
; Sparse, low-pitched, very resonant
asig bamboo 18000, 0.4, 0, 0.02, 0.08, 400, 900
awet reverb asig, 8.0
out awet*0.5, awet*0.5
```

---

## Advanced Topics

### PhISEM Algorithm (Conceptual)

**Internal process (simplified):**

1. **Initialize resonators** at ifreq and ifreq1
2. **Generate random events** (bamboo collisions)
   - Rate controlled by imaxshake
   - Energy distributed randomly
3. **Feed events to resonators**
   - Each collision excites resonances
   - Multiple pieces = overlapping resonances
4. **Apply damping**
   - Exponential decay over time
5. **Output sum** of all resonator responses

**Key insight:**
Randomness in timing + deterministic resonances = natural percussion

### Relationship to Other Physical Models

**vs. Waveguide (bamboo opcode vs. wguide):**
- Waveguide: Detailed, deterministic, CPU-intensive
- PhISEM: Simplified, stochastic, efficient

**vs. Modal synthesis:**
- Modal: Multiple exponential decays at specific frequencies
- PhISEM: Similar but with stochastic excitation

**PhISEM is essentially:**
Stochastic excitation → Multiple resonant filters → Summation

### Resonator Implementation

Internally, bamboo likely uses:
- **Two resonant filters** (one for each frequency)
- **Exponential decay** on each resonator
- **Random impulse train** as excitation
- **Summation** of filter outputs

**Pseudo-code:**
```
for each random event:
  excite_resonator_1(ifreq, energy)
  excite_resonator_2(ifreq1, energy)
  
resonator_output_1 = filter(events, ifreq) * decay(idettack)
resonator_output_2 = filter(events, ifreq1) * decay(idettack)

output = resonator_output_1 + resonator_output_2
```

---

## Related Examples

**Progression Path:**
1. **Current:** Basic bamboo physical model
2. **Next:** Other PhISEM models (`cabasa`, `guiro`, `shaker`)
3. **Then:** Combining multiple PhISEM for complex percussion
4. **Advanced:** Custom physical models with modal synthesis

**Related Techniques:**
- `Modal Synthesis` - Similar resonator approach
- `Karplus-Strong` - Simple string physical model
- `Waveguide Percussion` - More detailed physical models
- `Noise-Based Percussion` - Filtered noise alternative

**Related Opcodes:**
- `cabasa` - Afro-Cuban shaker (similar PhISEM)
- `guiro` - Scraped percussion
- `sekere` - Beaded gourd shaker
- `tambourine` - Tambourine model
- `sleighbells` - Sleigh bells
- `shaker` - Generic shaker
- `mode` - Modal synthesis (related technique)

---

## Performance Notes

- **CPU Usage:** Very light - one of the most efficient models
- **Polyphony:** Can easily run 50+ simultaneous instances
- **Real-time Safe:** Yes, designed for real-time performance
- **Latency:** Minimal (standard ksmps)
- **Stochastic:** Output varies slightly each time (feature!)

---

## Historical Context

**PhISEM Development:**
- Developed by **Perry Cook** at Princeton/Stanford
- Part of his physical modeling research (1990s)
- Included in **STK (Synthesis Toolkit)** library
- Later ported to Csound

**Philosophy:**
Perry Cook's principle: **"Make simple models that can be controlled in real-time and still sound good."**

PhISEM demonstrates:
- Physics doesn't need to be perfect
- Perceptual realism > mathematical accuracy
- Randomness is essential for natural sounds
- Efficient algorithms enable real-time performance

**Impact:**
- Showed that simple models could sound realistic
- Made physical modeling accessible (low CPU)
- Influenced game audio and interactive music
- Demonstrated value of stochastic processes in synthesis

**Perry Cook's other contributions:**
- STK (Synthesis Toolkit) - widely used teaching/research tool
- Physical modeling research
- Real-time synthesis algorithms
- "Singing synthesis" work

---

## Extended Documentation

**Official Csound Opcode References:**
- [bamboo](https://csound.com/docs/manual/bamboo.html)
- [cabasa](https://csound.com/docs/manual/cabasa.html)
- [shaker](https://csound.com/docs/manual/shaker.html)
- Other PhISEM opcodes in same family

**Academic Papers:**
- Cook, Perry: "Physically Informed Sonic Modeling (PhISM): Synthesis of percussive sounds"
- Cook, Perry: "Real Sound Synthesis for Interactive Applications"

**Learning Resources:**
- Csound FLOSS Manual: Chapter 4.7 (Physical Modeling - Percussion)
- STK (Synthesis Toolkit) documentation
- Perry Cook's publications on physical modeling

**Fun fact:**
PhISEM models are so efficient they were used in early mobile phone ringtones and video game audio when CPU was extremely limited!
