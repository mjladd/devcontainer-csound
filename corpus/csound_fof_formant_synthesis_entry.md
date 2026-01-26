# FOF Formant Synthesis

## Metadata

- **Title:** FOF Formant Synthesis (Singing Voice Synthesis)
- **Category:** Formant Synthesis / Vocal Synthesis / Granular-like Synthesis
- **Difficulty:** Advanced
- **Tags:** `fof`, `formant-synthesis`, `vocal-synthesis`, `singing-voice`, `granular`, `formants`, `vowels`, `grains`, `additive`, `spectral-synthesis`, `human-voice`, `choir`
- **Source File:** `ins4.aiff`

---

## Description

FOF (Fonction d'Onde Formantique, or Formant Wave Function) is a sophisticated synthesis technique developed by Xavier Rodet at IRCAM for creating realistic singing voice synthesis. It generates vocal sounds by producing streams of short sinusoidal grains that create formants - the resonant peaks that define vowel sounds. Unlike traditional subtractive synthesis (oscillator → filter), FOF builds vowels additively from the ground up, creating natural-sounding vocal timbres with precise control over formant frequencies.

**Use Cases:**
- Realistic singing voice synthesis
- Choir and vocal ensemble sounds
- Vowel morphing and vocal effects
- Experimental vocal processing
- Understanding human voice acoustics
- Creating formant-based timbres
- Linguistic and phonetic research

**What are Formants?**
Formants are resonant frequencies of the vocal tract that define different vowel sounds. For example:
- "ee" (as in "beet"): F1≈270 Hz, F2≈2300 Hz
- "ah" (as in "father"): F1≈730 Hz, F2≈1090 Hz
- "oo" (as in "boot"): F1≈300 Hz, F2≈870 Hz

FOF synthesis recreates these formants through grain-based additive synthesis.

---

## Complete Code

```csound
<CsoundSynthesizer>
<CsOptions>
-o ins4.aiff
</CsOptions>
<CsInstruments>
sr = 44100
kr = 4410
ksmps = 10
nchnls = 2
ifreq = p4

        instr 4
;       opcode  ia      dur1    ib      dur2    ic      dur3    id
aamp    linseg  0,      p3*.3,  8000,   p3*.2,  8500,   p3*.5,  10000
afund   expseg  200,    p3*.8,  342,    p3*.2,  223
afreq   linseg  20,     p3*.2,  p6,     p3*.8,  20
;       opcode  amp,    fund    form    oct  band  rise  dur   dec   olaps ifna ifnb otdur
a1      fof     aamp*p7,afund,  afreq,  0,   0,    .1,   .12,  .009, 100,  24,   23,  p3,   0,  1
        out     a1*.05, a1*.05
        endin
</CsInstruments>
<CsScore>
;****************************
;     Function Tables
;****************************
f23     0       1024    19      .5      .5      270     .5
f24     0       512     7       0       50      .25     50      .75     350     .75     62      0
;****************************
;     Instrument 4 Score
;****************************
;       str     dur     freq    p5      p6      p7
i4      0       10      0       0       490     1
i4      10      10      0       0       290     1
i4      20      10      0       0       690     1
</CsScore>
</CsoundSynthesizer>
```

---

## Detailed Explanation

### Orchestra Header

```csound
sr = 44100
kr = 4410
ksmps = 10
nchnls = 2
ifreq = p4
```

**Control rate:**
- `ksmps = 10` (standard k-rate, adequate for FOF)
- FOF doesn't require `ksmps=1` like waveguides
- k-rate envelopes control grain parameters

**Global variable:**
```csound
ifreq = p4
```
- Defined but **not used** in this example
- Likely leftover from development
- p6 is used for formant frequency instead

### Instrument 4 - FOF Synthesizer

#### Amplitude Envelope

```csound
aamp linseg 0, p3*.3, 8000, p3*.2, 8500, p3*.5, 10000
```

**Multi-segment linear envelope:**
- **Segment 1** (30% of duration): 0 → 8000
  - Attack phase
  - Gradual crescendo

- **Segment 2** (20% of duration): 8000 → 8500
  - Slight increase
  - Mid-section stability

- **Segment 3** (50% of duration): 8500 → 10000
  - Final half of note
  - Crescendo to peak

**Total proportions:** 30% attack + 20% sustain + 50% swell

**Why this shape?**
- Natural vocal phrasing
- Avoids sudden onset (no clicks)
- Builds intensity like sung note
- Crescendo to climax

#### Fundamental Frequency (Pitch) Envelope

```csound
afund expseg 200, p3*.8, 342, p3*.2, 223
```

**Exponential pitch envelope:**
- **80% of duration:** 200 Hz → 342 Hz
  - Rises ~9 semitones (about a major 6th)
  - Exponential = musical pitch perception

- **20% of duration:** 342 Hz → 223 Hz
  - Falls back down ~7 semitones
  - Resolution/relaxation

**Musical interpretation:**
- Like a vocal glissando or portamento
- Up then down (expressive phrasing)
- 200 Hz ≈ G3, 342 Hz ≈ F4, 223 Hz ≈ A3

**Why exponential?**
- Linear Hz changes sound unnatural
- We perceive pitch logarithmically
- Exponential = even musical intervals

#### Formant Frequency Envelope

```csound
afreq linseg 20, p3*.2, p6, p3*.8, 20
```

**Formant center frequency sweep:**
- **20% of duration:** 20 Hz → p6 (target formant)
  - Starts very low (sub-audio)
  - Rises to vowel formant frequency

- **80% of duration:** p6 → 20 Hz
  - Returns to sub-audio
  - Long fade-out

**From score:**
- p6 values: 490, 290, 690 Hz
- These are formant frequencies (vowel colors)

**Why start/end at 20 Hz?**
- Creates smooth entrance/exit
- Avoids sudden formant onset
- 20 Hz is essentially silent (threshold of hearing)

**Effect:**
Vowel "emerges" from nothing, sustains, then "dissolves"

### FOF Opcode (The Heart of the Instrument)

```csound
a1 fof aamp*p7, afund, afreq, 0, 0, .1, .12, .009, 100, 24, 23, p3, 0, 1
```

**fof** - Formant wave function generator

This opcode has **14 parameters** - let's break them down:

#### Parameter 1: `aamp*p7` - Amplitude
- `aamp` = envelope (0-10000)
- `p7` = amplitude scaling from score (all 1 in this example)
- Controls overall grain stream volume

#### Parameter 2: `afund` - Fundamental Frequency
- `afund` = pitch envelope (200-342-223 Hz)
- Determines pitch of the voice
- Grain repetition rate
- Creates perceived pitch

#### Parameter 3: `afreq` - Formant Frequency
- `afreq` = formant envelope (20-p6-20 Hz)
- Center frequency of each grain
- Defines vowel quality
- Different formants = different vowels

**This is the key to vowel synthesis!**

#### Parameter 4: `0` - Octaviation Index
- 0 = no octaviation
- Non-zero would add octave components
- Enriches spectrum

#### Parameter 5: `0` - Bandwidth
- 0 = use default bandwidth
- Controls formant width/sharpness
- Positive values widen formant
- Affects vowel clarity

#### Parameter 6: `.1` - Rise Time (seconds)
- 0.1s = 100ms rise
- Attack portion of each grain
- Shapes grain envelope
- Affects brightness

#### Parameter 7: `.12` - Overall Grain Duration (seconds)
- 120ms per grain
- Total grain length
- Includes rise, sustain, decay

#### Parameter 8: `.009` - Decay Time (seconds)
- 9ms decay
- Release portion of each grain
- Quick decay = clearer grains

**Grain envelope proportions:**
- Rise: 100ms
- Sustain: 120 - 100 - 9 = 11ms
- Decay: 9ms

#### Parameter 9: `100` - Number of Overlaps
- 100 grains can overlap simultaneously
- High number = smooth, continuous sound
- Low number = granular, discrete

**Critical parameter!**
Too few overlaps → gaps in sound
Too many → CPU intensive

#### Parameter 10: `24` - Amplitude Function (ifna)
- Table f24 (grain amplitude envelope)
- Shapes each grain's amplitude
- Defines grain window

#### Parameter 11: `23` - Frequency Function (ifnb)
- Table f23 (grain frequency envelope)
- Modulates grain frequency
- Can create vibrato or formant movement within grain

#### Parameter 12: `p3` - Total Duration
- Overall instrument duration
- How long to generate grains

#### Parameter 13: `0` - Initial Phase (iphs)
- 0 = random phase
- Affects grain phase relationships
- Usually left at 0

#### Parameter 14: `1` - Mode
- 1 = default mode
- Different modes affect grain generation
- Mode 1 is standard

### Output

```csound
out a1*.05, a1*.05
```

**Stereo output:**
- Same signal both channels (mono source)
- Scaled by 0.05 (5%)
- FOF can produce high amplitudes
- Scaling prevents clipping

---

## Score Section

### Function Tables

#### Table 23 (f23) - Frequency Function

```csound
f23  0  1024  19  .5  .5  270  .5
```

**GEN19 - Composite distribution function:**
- Size: 1024 points
- **Parameters:** `.5  .5  270  .5`
  - Type: 0.5 (specific distribution shape)
  - Parameter 1: 0.5
  - Parameter 2: 270
  - Parameter 3: 0.5

**Purpose:**
- Modulates frequency within each grain
- Can create slight vibrato or formant variation
- Adds richness to individual grains

**GEN19 is complex** - creates statistically distributed values

#### Table 24 (f24) - Grain Envelope

```csound
f24  0  512  7  0  50  .25  50  .75  350  .75  62  0
```

**GEN07 - Linear segments (grain window):**

Breaking down the segments:
```
Points 0-50:    0 → 0.25    (rise)
Points 50-100:  0.25 → 0.75 (continue rise)
Points 100-450: 0.75 → 0.75 (sustain plateau)
Points 450-512: 0.75 → 0    (decay)
```

**Proportions:**
- Rise: ~100 points (~20%)
- Sustain: ~350 points (~68%)
- Decay: ~62 points (~12%)

**Grain envelope shape:**
```
      _________
     /         \
    /           \___
   /                 \
```

**Why this shape?**
- Smooth rise prevents clicks
- Long sustain maintains formant
- Quick decay allows overlaps
- Asymmetric (longer sustain than rise)

### Note Events

```csound
;       start   dur     p4      p5      formant(p6)     amp_scale(p7)
i4      0       10      0       0       490             1
i4      10      10      0       0       290             1
i4      20      10      0       0       690             1
```

**Three 10-second notes** with different formant frequencies:

**Event 1 (0-10s): p6=490 Hz**
- Mid-range formant
- Vowel-like quality
- Neutral vowel (like "eh")

**Event 2 (10-20s): p6=290 Hz**
- Lower formant
- Darker, more closed vowel
- Like "uh" or "oo"

**Event 3 (20-30s): p6=690 Hz**
- Higher formant
- Brighter, more open vowel
- Like "ah" or "ay"

**Parameters p4, p5 unused** (both = 0)
- Likely placeholders or from earlier version
- Could be used for additional control

---

## Key Concepts

### FOF Synthesis Theory

**Core principle:**
Generate streams of short sinusoidal grains (formants) at the fundamental frequency rate.

**Each grain:**
1. Has center frequency = formant frequency
2. Has envelope (rise-sustain-decay)
3. Repeats at fundamental frequency
4. Overlaps with other grains

**Result:**
- Fundamental frequency = perceived pitch
- Formant frequency = vowel color
- Grain rate = pitch
- Grain content = timbre

### Formants and Vowels

**Human voice production:**
- Vocal cords vibrate at fundamental frequency (pitch)
- Vocal tract resonates at formant frequencies (vowel)
- Different tongue/jaw positions = different formants

**Common vowel formants (first formant F1):**
- "ee" (beet): ~270 Hz
- "ih" (bit): ~390 Hz
- "eh" (bet): ~530 Hz
- "ae" (bat): ~660 Hz
- "ah" (father): ~730 Hz
- "aw" (bought): ~570 Hz
- "oo" (boot): ~300 Hz
- "uh" (but): ~640 Hz

**This example explores three F1 values:**
- 290 Hz (close to "oo")
- 490 Hz (between "eh" and "ae")
- 690 Hz (close to "ah")

### FOF vs. Other Grain-Based Synthesis

**FOF (formant-specific):**
- Grains have precise frequency content
- Designed for vocal synthesis
- Formant-centered approach
- Grain parameters carefully chosen

**Granular (generic):**
- Grains can be any sound
- General-purpose texture creation
- Sample-based or generated
- Wide range of applications

**FOF is specialized granular synthesis** optimized for formants!

### Number of Overlaps

**Overlap formula:**
```
overlap = grain_duration × grain_rate
```

**Example:**
- Grain duration: 0.12s
- Fundamental: 200 Hz (200 grains/second)
- Theoretical overlap: 0.12 × 200 = 24 grains

**Why specify 100 overlaps?**
- Safety margin (fundamental varies 200-342 Hz)
- Ensures smooth output at all pitches
- Maximum concurrent grains

**Too few overlaps:**
- Gaps in sound
- "Helicopter" effect
- Unnatural

**Too many overlaps:**
- CPU intensive
- Diminishing returns
- Usually 50-200 is adequate

---

## Parameter Exploration

### Formant Frequency (afreq / p6)

**Low (200-400 Hz):**
- Dark, closed vowels
- "oo" (boot), "oh" (boat)
- Mellow, warm

**Mid (400-600 Hz):**
- Neutral, balanced vowels
- "eh" (bet), "uh" (but)
- Natural speaking range

**High (600-900 Hz):**
- Bright, open vowels
- "ah" (father), "ae" (bat)
- Powerful, resonant

**Very high (900+ Hz):**
- Extreme brightness
- Unnatural but interesting
- Can sound nasal or harsh

### Fundamental Frequency (afund)

**Low (80-150 Hz):**
- Male bass voice
- Deep, resonant
- Authoritative

**Mid (150-300 Hz):**
- Male tenor / Female alto
- Versatile range
- Most musical

**High (300-600 Hz):**
- Female soprano
- Bright, soaring
- Emotional intensity

**Pitch modulation:**
- Vibrato: `afund * (1 + lfo(0.02, 6))`
- Glissando: exponential sweeps (as in example)
- Portamento: smooth pitch changes

### Grain Duration Parameters

**Rise time (.1 in example):**
- **Short (0.01-0.05s):** Sharp attack, bright
- **Medium (0.05-0.15s):** Balanced
- **Long (0.15-0.3s):** Soft, gentle

**Overall duration (.12 in example):**
- **Short (0.05-0.1s):** Thin, reedy
- **Medium (0.1-0.2s):** Balanced, vocal-like
- **Long (0.2-0.5s):** Thick, padded

**Decay time (.009 in example):**
- **Very short (0.001-0.01s):** Clean, precise
- **Short (0.01-0.05s):** Natural
- **Long (0.05-0.1s):** Blurred, smeared

### Bandwidth (currently 0 = default)

**Narrow (10-50 Hz):**
- Sharp formant peak
- Clear vowel definition
- Can sound synthetic

**Medium (50-150 Hz):**
- Natural formant width
- Balanced clarity
- Realistic vowels

**Wide (150-300+ Hz):**
- Diffuse formant
- Less clear vowel
- More textural

---

## Variations

### Realistic Vowel Sequence

```csound
; Create vowel progression: ee → ah → oo
; Using multiple formants (F1 and F2)
afreq1 linseg 270, p3/3, 730, p3/3, 300, p3/3, 270  ; F1
afreq2 linseg 2300, p3/3, 1090, p3/3, 870, p3/3, 2300  ; F2

a1 fof aamp*0.5, afund, afreq1, 0, 0, .1, .12, .009, 100, 24, 23, p3, 0, 1
a2 fof aamp*0.3, afund, afreq2, 0, 0, .08, .1, .007, 80, 24, 23, p3, 0, 1
aout = a1 + a2
```

### Choir Effect (Multiple Voices)

```csound
; Three slightly detuned voices
a1 fof aamp, afund, afreq, 0, 0, .1, .12, .009, 100, 24, 23, p3, 0, 1
a2 fof aamp, afund*1.01, afreq*1.02, 0, 0, .1, .12, .009, 100, 24, 23, p3, 0, 1
a3 fof aamp, afund*0.99, afreq*0.98, 0, 0, .1, .12, .009, 100, 24, 23, p3, 0, 1
achoir = (a1 + a2 + a3) / 3
```

### Vibrato

```csound
; Add vocal vibrato
kvib lfo 0.02, 5.5, 0      ; 5.5 Hz vibrato, ±2% depth
afund_vib = afund * (1 + kvib)
a1 fof aamp*p7, afund_vib, afreq, 0, 0, .1, .12, .009, 100, 24, 23, p3, 0, 1
```

### Formant Tremolo

```csound
; Modulate formant frequency
ktrem lfo 50, 3, 0         ; ±50 Hz at 3 Hz
afreq_trem = afreq + ktrem
a1 fof aamp*p7, afund, afreq_trem, 0, 0, .1, .12, .009, 100, 24, 23, p3, 0, 1
```

### Multiple Formants (More Realistic)

```csound
; Five formants for richer vowel
aF1 = 500   ; First formant
aF2 = 1500  ; Second formant
aF3 = 2500  ; Third formant
aF4 = 3500  ; Fourth formant
aF5 = 4500  ; Fifth formant

a1 fof aamp*1.0, afund, aF1, 0, 0, .1, .12, .009, 100, 24, 23, p3, 0, 1
a2 fof aamp*0.6, afund, aF2, 0, 0, .08, .1, .007, 80, 24, 23, p3, 0, 1
a3 fof aamp*0.4, afund, aF3, 0, 0, .06, .08, .005, 60, 24, 23, p3, 0, 1
a4 fof aamp*0.2, afund, aF4, 0, 0, .04, .06, .003, 40, 24, 23, p3, 0, 1
a5 fof aamp*0.1, afund, aF5, 0, 0, .02, .04, .002, 20, 24, 23, p3, 0, 1

avowel = a1 + a2 + a3 + a4 + a5
```

### Dynamic Grain Parameters

```csound
; Grain duration changes over time
kdur linseg .05, p3, .2     ; Grain gets longer
a1 fof aamp*p7, afund, afreq, 0, 0, .1, kdur, .009, 100, 24, 23, p3, 0, 1
```

---

## Common Issues & Solutions

### Distortion/Clipping
**Problem:** Output distorts, especially with high overlaps
**Cause:** Too many grains summing, excessive amplitude
**Solution:**
```csound
; Reduce amplitude
aamp linseg 0, p3*.3, 4000, p3*.2, 4500, p3*.5, 5000  ; Half amplitude
; Or scale output more
out a1*.02, a1*.02  ; Was .05, now .02
```

### Gaps or "Helicopter" Sound
**Problem:** Sound is discontinuous, rhythmic artifacts
**Cause:** Too few overlaps, grain duration too short
**Solution:**
```csound
; Increase overlaps
a1 fof aamp*p7, afund, afreq, 0, 0, .1, .12, .009, 200, 24, 23, p3, 0, 1
;                                                   ^^^ was 100
; Or increase grain duration
a1 fof aamp*p7, afund, afreq, 0, 0, .1, .2, .009, 100, 24, 23, p3, 0, 1
;                                           ^^ was .12
```

### Clicks or Pops
**Problem:** Audible clicks at grain boundaries
**Cause:** Grain envelope too sharp, rise/decay too short
**Solution:**
```csound
; Smoother grain envelope (f24)
f24 0 512 7 0 100 .75 312 .75 100 0  ; Gentler rise/decay
; Or increase rise/decay times
a1 fof aamp*p7, afund, afreq, 0, 0, .15, .2, .02, 100, 24, 23, p3, 0, 1
;                                    ^^^  ^^  ^^^  Longer
```

### Unnatural or Synthetic Sound
**Problem:** Doesn't sound like voice
**Cause:** Single formant, static parameters
**Solution:**
```csound
; Add multiple formants (see variations above)
; Add vibrato
; Use realistic formant values
; Modulate parameters over time
```

### CPU Overload
**Problem:** Performance issues, dropouts
**Cause:** Too many overlaps, too many simultaneous FOF instances
**Solution:**
```csound
; Reduce overlaps
a1 fof aamp*p7, afund, afreq, 0, 0, .1, .12, .009, 50, 24, 23, p3, 0, 1
;                                                   ^^ was 100
; Or limit polyphony in score
```

### Wrong Formant Frequencies
**Problem:** Vowels don't sound right
**Cause:** Incorrect formant values
**Solution:**
```csound
; Use standard vowel formants:
; "ee": F1=270, F2=2300
; "ih": F1=390, F2=1990
; "eh": F1=530, F2=1840
; "ah": F1=730, F2=1090
; "oo": F1=300, F2=870
```

---

## Sound Design Applications

### Realistic Singing Voice

```csound
; Multiple formants with vibrato
kvib lfo 0.015, 5.8, 0
afund_vib = afund * (1 + kvib)

; Vowel "ah" (F1=730, F2=1090)
a1 fof aamp*1.0, afund_vib, 730, 0, 0, .1, .12, .009, 100, 24, 23, p3, 0, 1
a2 fof aamp*0.5, afund_vib, 1090, 0, 0, .08, .1, .007, 80, 24, 23, p3, 0, 1
asinging = a1 + a2
```

### Choir Ensemble

```csound
; 5 voices, slightly detuned, different formants
a1 fof aamp, afund*0.98, 480, 0, 0, .1, .12, .009, 100, 24, 23, p3, 0, 1
a2 fof aamp, afund*0.99, 490, 0, 0, .1, .12, .009, 100, 24, 23, p3, 0, 1
a3 fof aamp, afund*1.0, 500, 0, 0, .1, .12, .009, 100, 24, 23, p3, 0, 1
a4 fof aamp, afund*1.01, 510, 0, 0, .1, .12, .009, 100, 24, 23, p3, 0, 1
a5 fof aamp, afund*1.02, 520, 0, 0, .1, .12, .009, 100, 24, 23, p3, 0, 1
achoir = (a1+a2+a3+a4+a5) * 0.2
```

### Vocal Pad/Drone

```csound
; Slow-moving formants, sustained
aamp = 5000  ; Constant amplitude
afund = 150  ; Low, sustained pitch
afreq linseg 400, p3, 600  ; Slow formant sweep
a1 fof aamp, afund, afreq, 0, 0, .2, .3, .05, 150, 24, 23, p3, 0, 1
```

### Alien/Synthetic Voice

```csound
; Rapid formant modulation, unusual frequencies
kform lfo 200, 8, 0  ; Fast LFO
afreq = 1500 + kform  ; High, unstable formant
a1 fof aamp, afund, afreq, 0, 0, .05, .06, .002, 80, 24, 23, p3, 0, 1
```

---

## Advanced Topics

### Formant Bandwidth and Q

**Bandwidth affects formant sharpness:**
```
Q = formant_frequency / bandwidth
```

**Narrow bandwidth (high Q):**
- Sharp, well-defined formants
- Can sound synthetic
- Clear vowel articulation

**Wide bandwidth (low Q):**
- Diffuse formants
- More natural (vocal tract has losses)
- Softer vowel definition

**In FOF:**
Bandwidth parameter (currently 0 = default) controls this directly

### Grain Envelope Design

**Ideal grain envelope:**
- Smooth rise (prevent clicks)
- Plateau sustain (maintain formant energy)
- Smooth decay (allow overlap)

**Common window functions:**
- Hanning: Smooth, no sidelobes
- Hamming: Slightly better sidelobe suppression
- Blackman: Excellent sidelobe suppression
- Gaussian: Very smooth

**Table f24 approximates raised cosine window**

### Multi-Formant Vowel Synthesis

**Human vowels require multiple formants:**
- **F1** (First formant): 200-1000 Hz - primary vowel identifier
- **F2** (Second formant): 800-2500 Hz - vowel distinction
- **F3** (Third formant): 2000-3500 Hz - voice quality
- **F4-F5** (Higher formants): 3000-5000 Hz - naturalness

**Single formant** (this example) gives basic vowel color.
**Multiple formants** create realistic vowels.

### FOF vs. Physical Modeling

**FOF (formant-based):**
- Direct specification of formants
- Additive approach
- Precise control of spectral peaks
- Good for vowels, not consonants

**Physical modeling (waveguide/mass-spring):**
- Simulates vocal tract physics
- Indirect formant control
- Can produce consonants
- More realistic but complex

**FOF is "perceptually informed"** - shortcuts physics to create convincing results.

---

## Related Examples

**Progression Path:**
1. **Current:** Basic FOF with single formant
2. **Next:** Multi-formant FOF (realistic vowels)
3. **Then:** FOF with consonant synthesis
4. **Advanced:** Complete singing voice synthesis system

**Related Techniques:**
- `Additive Synthesis` - Similar concept (sum of partials)
- `Granular Synthesis` - Generic grain-based synthesis
- `Formant Filtering` - Subtractive approach to vowels
- `Physical Modeling` - Alternative vocal synthesis

**Related Opcodes:**
- `fof2` - Extended FOF with more parameters
- `grain` - Generic granular synthesis
- `mode` - Modal synthesis (related to formants)
- `reson` - Bandpass filter (formant filtering)

---

## Performance Notes

- **CPU Usage:** Moderate to high (many overlapping grains)
- **Polyphony:** 5-10 simultaneous FOF instruments typical
- **Real-time Safe:** Yes, but watch overlap count
- **Latency:** Standard (ksmps = 10)
- **Quality:** Excellent for vocal synthesis

---

## Historical Context

**FOF Development:**
- **Invented:** Xavier Rodet, IRCAM (Paris), late 1970s
- **Purpose:** Singing voice synthesis research
- **Innovation:** Grain-based formant synthesis

**IRCAM (Institut de Recherche et Coordination Acoustique/Musique):**
- Premier computer music research center
- Founded by Pierre Boulez (1977)
- Birthplace of many synthesis techniques

**Impact:**
- Demonstrated grain-based synthesis for specific timbres
- Influenced understanding of vowel perception
- Led to advanced singing synthesizers (Vocaloid, etc.)
- Showed additive approaches could rival subtractive

**Xavier Rodet's contributions:**
- FOF synthesis
- CHANT (singing synthesis system)
- Spectral modeling synthesis
- Voice analysis/synthesis research

**Modern descendants:**
- Vocaloid (uses spectral analysis + synthesis)
- Synthesizer V (neural + traditional techniques)
- Various formant synthesizers

---

## Extended Documentation

**Official Csound Opcode References:**
- [fof](https://csound.com/docs/manual/fof.html)
- [fof2](https://csound.com/docs/manual/fof2.html)
- [linseg](https://csound.com/docs/manual/linseg.html) / [expseg](https://csound.com/docs/manual/expseg.html)
- [GEN19](https://csound.com/docs/manual/GEN19.html)

**Academic Papers:**
- Rodet, Xavier: "Time-domain formant-wave-function synthesis" (1984)
- Rodet et al.: "The CHANT Project: From the synthesis of the singing voice to synthesis in general"
- Sundberg, Johan: "The Science of the Singing Voice"

**Formant Reference Data:**
- Peterson & Barney (1952): Classic vowel formant measurements
- Hillenbrand et al. (1995): Updated formant data
- IPA vowel charts with formant values

**Learning Resources:**
- Csound FLOSS Manual: Chapter 4.8 (Formant Synthesis)
- The Csound Book: "Synthesis by Granulation" chapter
- IRCAM documentation archives

**Key insight:** FOF demonstrates that complex natural sounds (human voice) can be synthesized by understanding their perceptual essence (formants) rather than exact physical modeling. This "perceptually informed" approach is efficient and effective.
