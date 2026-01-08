# McCurdy Physical Models Examples

## Metadata

- **Title:** Physical Modeling Examples (McCurdy)
- **Category:** Physical Modeling / Waveguide Synthesis
- **Difficulty:** Intermediate to Advanced
- **Tags:** `physical-modeling`, `waveguide`, `plucked-string`, `bowed-string`, `wind`, `percussion`, `STK`, `barmodel`, `modal`
- **Source:** Iain McCurdy Csound Realtime Examples
- **License:** CC BY-NC-SA 4.0
- **Original Location:** csound_realtime/PhysicalModels/

---

## Overview

Physical modeling synthesizes sound by simulating the physical properties of real instruments - strings, tubes, bars, membranes, and resonant bodies. Rather than sampling or additive synthesis, these opcodes solve equations describing how sound-producing objects vibrate. This collection demonstrates Csound's waveguide, bar model, and STK-based physical models.

---

## Waveguide String Models

### wgbow
**File:** `wgbow.csd`
**Author:** Iain McCurdy, 2006

**Description:** Physically modeled bowed string instrument based on Perry Cook's work. Simulates a bowed violin/cello-type string.

**Key Opcodes:** `wgbow`

**Parameters:**
- Amplitude - output level
- Frequency - fundamental pitch (20-4000 Hz)
- Bow Pressure - force on string (suggested 1-5, normal=3)
- Bow Position (krat) - where bow contacts string (0.025-0.23)
  - 0.025 = sul ponticello (at bridge, thin tone)
  - 0.127 = normal bowing position
  - 0.23 = flautando (over neck, flute-like)
- Vibrato Frequency - rate of vibrato (~5 Hz natural)
- Vibrato Amplitude - depth (0-0.1)
- Minimum Frequency - algorithm floor (default 50 Hz)

**Key Concept:** Vibrato modulates multiple parameters, not just pitch.

---

### wgbowedbar
**File:** `wgbowedbar.csd`
**Author:** Iain McCurdy

**Description:** Bowed bar physical model - simulates bowed metal or glass bars.

**Key Opcodes:** `wgbowedbar`

---

### wgpluck / wgpluck2
**Files:** `wgpluck.csd`, `wgpluck2.csd`
**Author:** Iain McCurdy

**Description:** Waveguide plucked string models. `wgpluck2` offers enhanced control over initial conditions.

**Key Opcodes:** `wgpluck`, `wgpluck2`

**Parameters:**
- Frequency - pitch
- Pluck Position - where string is plucked
- Pick-up Position - where vibration is sensed
- Damping - string decay rate
- Filter - tone control

---

### repluck
**File:** `repluck.csd`
**Author:** Iain McCurdy

**Description:** Plucked string using audio input as excitation source instead of internal noise burst.

**Key Opcodes:** `repluck`

---

### pluck
**File:** `pluck.csd`
**Author:** Iain McCurdy

**Description:** Classic Karplus-Strong plucked string algorithm - the original digital string model.

**Key Opcodes:** `pluck`

---

### mandol
**File:** `mandol.csd`
**Author:** Iain McCurdy

**Description:** Physical model of a mandolin with paired strings.

**Key Opcodes:** `mandol`

---

## Waveguide Wind Models

### wgflute
**File:** `wgflute.csd`
**Author:** Iain McCurdy

**Description:** Waveguide flute model with breath noise and embouchure control.

**Key Opcodes:** `wgflute`

---

### wgclar
**File:** `wgclar.csd`
**Author:** Iain McCurdy

**Description:** Waveguide clarinet model with reed dynamics.

**Key Opcodes:** `wgclar`

---

### wgbrass / wgbrass_explore
**Files:** `wgbrass.csd`, `wgbrass_explore.csd`
**Author:** Iain McCurdy

**Description:** Waveguide brass instrument model. The explore version provides extended parameter control.

**Key Opcodes:** `wgbrass`

---

## Bar and Resonator Models

### barmodel
**File:** `barmodel.csd`
**Author:** Iain McCurdy (algorithm by Stefan Bilbao, opcode by John ffitch)

**Description:** Physical model of a vibrating metal bar. Uses finite difference methods for realistic bar vibration.

**Key Opcodes:** `barmodel`

**Parameters:**
- Stiffness (K) - bar material stiffness (0.1-8000)
- 30 dB Decay Time (T30) - time for -30dB decay (0.1-30)
- High Frequency Loss (b) - damping of overtones
- Strike Position - where bar is hit (0.004-0.996)
- Strike Velocity - impact force (0-30000)
- Strike Width - mallet hardness (0.01-2)
- Scanning Frequency - output position modulation
- Boundary Conditions L/R:
  - Clamped - fixed end
  - Pivoting - hinged end
  - Free - unconstrained end

---

### barmodel_test
**File:** `barmodel_test.csd`
**Author:** Iain McCurdy

**Description:** Test/exploration version of barmodel.

---

### marimba
**File:** `marimba.csd`
**Author:** Iain McCurdy

**Description:** Marimba bar with resonator model.

**Key Opcodes:** `marimba`

---

### vibes
**File:** `vibes.csd`
**Author:** Iain McCurdy

**Description:** Vibraphone physical model with motor tremolo.

**Key Opcodes:** `vibes`

---

### gogobel
**File:** `gogobel.csd`
**Author:** Iain McCurdy

**Description:** Struck bell/gong physical model.

**Key Opcodes:** `gogobel`

---

## Shaker/Friction Models

### shaker
**File:** `shaker.csd`
**Author:** Iain McCurdy

**Description:** Generic shaker model - simulates objects containing particles.

**Key Opcodes:** `shaker`

---

### cabasa
**File:** `cabasa.csd`
**Author:** Iain McCurdy

**Description:** Cabasa percussion instrument model.

**Key Opcodes:** `cabasa`

---

### crunch
**File:** `crunch.csd`
**Author:** Iain McCurdy

**Description:** Crunching/crushing sound model.

**Key Opcodes:** `crunch`

---

### sekere
**File:** `sekere.csd`
**Author:** Iain McCurdy

**Description:** Sekere (African gourd shaker) physical model.

**Key Opcodes:** `sekere`

---

### sandpaper
**File:** `sandpaper.csd`
**Author:** Iain McCurdy

**Description:** Sandpaper rubbing sound model.

**Key Opcodes:** `sandpaper`

---

### stix
**File:** `stix.csd`
**Author:** Iain McCurdy

**Description:** Wooden sticks clicking/tapping model.

**Key Opcodes:** `stix`

---

### sleighbells
**File:** `sleighbells.csd`
**Author:** Iain McCurdy

**Description:** Sleigh bells jingle model.

**Key Opcodes:** `sleighbells`

---

### tambourine
**File:** `tambourine.csd`
**Author:** Iain McCurdy

**Description:** Tambourine physical model with jingles.

**Key Opcodes:** `tambourine`

---

### bamboo
**File:** `bamboo.csd`
**Author:** Iain McCurdy

**Description:** Bamboo wind chimes model.

**Key Opcodes:** `bamboo`

---

### dripwater
**File:** `dripwater.csd`
**Author:** Iain McCurdy

**Description:** Water dripping/dropping sound model.

**Key Opcodes:** `dripwater`

---

### guiro
**File:** `guiro.csd`
**Author:** Iain McCurdy

**Description:** Guiro (scraped gourd) physical model.

**Key Opcodes:** `guiro`

---

## Other Physical Models

### moog
**File:** `moog.csd`
**Author:** Iain McCurdy

**Description:** Moog-style lowpass filter model as synthesis element.

**Key Opcodes:** `moog`

---

### PrePiano
**File:** `PrePiano.csd`
**Author:** Iain McCurdy

**Description:** Prepared piano physical model with modified string behavior.

**Key Opcodes:** Piano-related opcodes

---

## STK Opcodes

### STKopcodes
**File:** `STKopcodes.csd`
**Author:** Iain McCurdy

**Description:** Comprehensive demonstration of all 27 STK (Synthesis Tool Kit) opcodes from Perry Cook's library. GUI adapts to show relevant parameters for each instrument.

**Key Opcodes:** All STK* opcodes

**STK Instruments:**
1. STKBandedWG - Bowed bars/glasses/bowls
2. STKBeeThree - Hammond-style organ (TX81Z algorithm 8)
3. STKBlowBotl - Blown bottle (Helmholtz resonator)
4. STKBlowHole - Clarinet with register hole
5. STKBowed - Bowed string waveguide
6. STKBrass - Brass instrument waveguide
7. STKClarinet - Clarinet physical model
8. STKDrummer - Drum kit sampler
9. STKFlute - Flute physical model
10. STKFMVoices - FM voice synthesis
11. STKHevyMetl - FM heavy metal guitar
12. STKMandolin - Mandolin physical model
13. STKModalBar - Modal bar synthesis
14. STKMoog - Moog-style sweeping filter
15. STKPercFlut - Percussive flute
16. STKPlucked - Plucked string
17. STKResonate - Resonance model
18. STKRhodey - Rhodes piano
19. STKSaxofony - Saxophone
20. STKShakers - Various shakers
21. STKSimple - Simple waveguide
22. STKSitar - Sitar
23. STKStifKarp - Stiff string (piano-like)
24. STKTubeBell - Tubular bell
25. STKVoicForm - Voice formant synthesis
26. STKWhistle - Whistle model
27. STKWurley - Wurlitzer piano

**Reference:** https://ccrma.stanford.edu/software/stk/classes.html

---

## Physical Modeling Concepts

### Waveguide Synthesis
Digital waveguides simulate wave propagation in strings and tubes using delay lines with filters. The delay length determines pitch, and the filter models energy loss.

### Karplus-Strong
Original digital plucked string: noise burst → delay line → lowpass filter → feedback. Simple but effective.

### Modal Synthesis
Models resonant objects as banks of bandpass filters at modal frequencies. Good for bells, bars, and plates.

### Finite Difference
Solves wave equations numerically on a grid. More accurate but computationally expensive. Used in barmodel.

---

## Key Opcodes Reference

| Opcode | Category | Description |
|--------|----------|-------------|
| `wgbow` | String | Bowed string waveguide |
| `wgpluck` | String | Plucked string waveguide |
| `wgpluck2` | String | Enhanced plucked string |
| `repluck` | String | Audio-excited pluck |
| `pluck` | String | Karplus-Strong algorithm |
| `wgflute` | Wind | Flute waveguide |
| `wgclar` | Wind | Clarinet waveguide |
| `wgbrass` | Wind | Brass waveguide |
| `barmodel` | Bar | Finite difference bar |
| `marimba` | Bar | Marimba model |
| `vibes` | Bar | Vibraphone model |
| `shaker` | Percussion | Particle shaker |
| `cabasa` | Percussion | Cabasa model |
| `tambourine` | Percussion | Tambourine model |
| `STK*` | Various | Perry Cook's STK library |

---

## Related Corpus Entries

- `mccurdy_additive_synthesis_entry.md` - Modal additive synthesis
- `csound_physical_models_entry.md` - Physical modeling theory
- `csound_pluck_tutorial_entry.md` - Karplus-Strong details

