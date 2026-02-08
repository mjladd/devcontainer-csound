# McCurdy FM/PM/RM/AM Synthesis Examples

## Metadata
- **Title:** FM/PM/RM/AM Synthesis Examples (McCurdy)
- **Category:** Frequency Modulation / Phase Modulation / Ring Modulation / Amplitude Modulation
- **Difficulty:** Intermediate
- **Tags:** fm-synthesis, phase-modulation, ring-modulation, amplitude-modulation, modulator, carrier, sidebands, index-of-modulation, foscil, TX81Z, envelope, spectral-synthesis
- **Source:** Iain McCurdy Csound Realtime Examples
- **License:** CC BY-NC-SA 4.0

---

## Overview

This collection demonstrates the family of modulation synthesis techniques: Frequency Modulation (FM), Phase Modulation (PM), Ring Modulation (RM), and Amplitude Modulation (AM). These techniques create complex spectra by using one oscillator (the modulator) to influence another oscillator (the carrier).

**Key Concepts:**
- **Carrier:** The oscillator whose output is heard
- **Modulator:** The oscillator that influences the carrier's frequency, phase, or amplitude
- **Index of Modulation:** Controls spectral richness (brightness) in FM/PM synthesis
- **Peak Deviation:** The amplitude of the modulator, calculated as `baseFreq * index`
- **Sidebands:** Additional spectral components created by modulation
- **Frequency Ratios:** Simple ratios produce harmonic spectra; complex ratios produce inharmonic/bell-like timbres

---

## Ring Modulation / Amplitude Modulation

### Ring Modulation and Amplitude Modulation
**File:** `RingModulationAmplitudeModulation.csd`
**Description:** Demonstrates the difference between amplitude modulation (AM) and ring modulation (RM). When modulation frequency enters the audio range, sidebands emerge. AM uses a unipolar modulator (0 to 1), producing the carrier frequency plus sum sidebands. RM uses a bipolar modulator (-1 to 1), producing sum and difference sidebands without the carrier frequency.
**Key Opcodes:** `oscili`, `oscilikt`, `gbuzz`, `ntrpol`
**Parameters:**
- Modulation Frequency: 1-15000 Hz - controls sideband frequencies
- Dry/Wet Mix: blend between original and modulated signal
- Input Signal: choice of live input, sine tone, drum loop, or sample
- Modulator Waveform: sine or triangle wave

---

## FM Synthesis - Basic Examples

### Simple Modulator-Carrier (Raw Parameters)
**File:** `SimpleModulatorCarrier.csd`
**Description:** FM synthesis in its simplest form with direct control over modulator and carrier amplitudes and frequencies. Demonstrates how modulator amplitude controls spectral brightness and how frequency ratios affect timbre (simple ratios = harmonic, complex ratios = inharmonic).
**Key Opcodes:** `oscili`
**Parameters:**
- Modulator Amplitude: 0-32768 - controls spectral intensity
- Carrier Amplitude: 0-32768 - controls output volume
- Modulator Frequency: 0-20000 Hz
- Carrier Frequency: 0-20000 Hz

---

### Modulator-Carrier with Index of Modulation
**File:** `ModulatorCarrier.csd`
**Description:** Implements the conventional FM formula using the Index of Modulation to control spectral brightness. Peak Deviation is calculated as `Index * Base Frequency`. Uses frequency ratios to define carrier and modulator frequencies relative to a base frequency.
**Key Opcodes:** `oscili`, `FLjoy`
**Parameters:**
- Base Frequency: 20-20000 Hz - fundamental pitch
- Index of Modulation: 0-10 - controls spectral richness
- Carrier Ratio: multiplier for carrier frequency
- Modulator Ratio: multiplier for modulator frequency
- Peak Deviation: display only, calculated value

---

### Modulator-Carrier with Envelopes
**File:** `ModulatorCarrierWithEnvelopes.csd`
**Description:** Adds ADSR envelopes to both the index of modulation and amplitude, creating dynamic timbres that evolve over time. Includes presets for Metal Plate, Clarinet, Trumpet, and Bassoon sounds.
**Key Opcodes:** `oscili`, `madsr`, `mxadsr`
**Parameters:**
- Base Frequency: 20-20000 Hz
- Modulation Index: 0-20
- Index Envelope: Attack, Decay, Sustain, Release, Delay
- Amplitude Envelope: Attack, Decay, Sustain, Release, Delay
- Carrier/Modulator Ratios

---

### Vibrato to Sidebands Demonstration
**File:** `FMSynthesisVibratoToSideBands.csd`
**Description:** Educational example showing the transition from perceivable vibrato to sidebands. As vibrato frequency increases beyond ~15 Hz, we stop hearing pitch fluctuations and begin hearing spectral components (sidebands).
**Key Opcodes:** `oscili`, `expseg`
**Parameters:**
- Vibrato Depth: automatically varies from 0.001 to 3000
- Vibrato Rate: automatically varies from 2 Hz to 1000 Hz
- Demonstrates the perceptual threshold between modulation and spectrum

---

### foscil and foscili Opcodes
**File:** `foscil_foscili.csd`
**Description:** Demonstrates the dedicated FM synthesis opcodes `foscil` (non-interpolating) and `foscili` (interpolating). These implement the Chowning modulator-carrier pairing in a single opcode. Includes comparison with first-principles implementation.
**Key Opcodes:** `foscil`, `foscili`, `oscili`
**Parameters:**
- Amplitude: 0-1
- Base Frequency: 20-20000 Hz
- Carrier Ratio: frequency multiplier for carrier
- Modulator Ratio: frequency multiplier for modulator
- Index: 0-20 - modulation index

---

## FM Synthesis - Multi-Oscillator Algorithms

### One Modulator to Two Carriers
**File:** `FMMod2Car.csd`
**Description:** Three-oscillator algorithm where a single modulator simultaneously modulates the frequency of two independent carriers. Carriers can be detuned to create beating effects.
**Key Opcodes:** `oscili`
**Parameters:**
- Base Frequency: 20-20000 Hz
- Modulation Index: 0-50
- Carrier 1/2 Amplitude: independent amplitude controls
- Carrier 1/2 Ratio: frequency ratios for each carrier
- Modulator Ratio: frequency ratio for modulator
- Master Gain: overall output level

---

### Two Modulators to One Carrier
**File:** `FM2ModCar.csd`
**Description:** Three-oscillator algorithm with two parallel modulators feeding a single carrier. Each modulator has independent index and ratio controls. Slight ratio offsets create dramatic spectral modulation similar to filter sweeps.
**Key Opcodes:** `oscili`
**Parameters:**
- Base Frequency: 20-20000 Hz
- Modulation Index 1/2: independent modulation depths
- Carrier Ratio: frequency ratio for carrier
- Modulator 1/2 Ratios: frequency ratios for each modulator
- Peak Deviation 1/2: calculated values for each modulator

---

### Three Modulators to One Carrier
**File:** `FM3ModCar.csd`
**Description:** Four-oscillator algorithm with three parallel modulators feeding a single carrier. Provides even more complex spectral possibilities than two-modulator configurations.
**Key Opcodes:** `oscili`
**Parameters:**
- Base Frequency: 20-20000 Hz
- Modulation Index 1/2/3: independent modulation depths
- Carrier Ratio: frequency ratio for carrier
- Modulator 1/2/3 Ratios: frequency ratios for each modulator
- 8 presets demonstrating various timbres

---

### Two Modulators to One Carrier with Envelopes
**File:** `2xModulatorCarrierWithEnvelopes.csd`
**Description:** Two parallel modulators with independent ADSR envelopes for each modulator's index, plus an amplitude envelope. Useful for creating attack transients with one modulator and sustain characteristics with another.
**Key Opcodes:** `oscili`, `madsr`, `mxadsr`
**Parameters:**
- Base Frequency: 20-20000 Hz
- Modulation Index 1/2: with independent envelopes
- Index 1 Envelope: ADSR + Delay
- Index 2 Envelope: ADSR + Delay
- Amplitude Envelope: ADSR + Delay
- Carrier/Modulator Ratios

---

### Modulator to Modulator to Carrier (Serial Chain)
**File:** `FMModModCar.csd`
**Description:** Three-oscillator serial algorithm where modulator 1 modulates modulator 2, which in turn modulates the carrier. Capable of generating extremely complex and sometimes chaotic spectra.
**Key Opcodes:** `oscili`
**Parameters:**
- Base Frequency: 20-20000 Hz
- Modulation Index 1: controls mod1's influence on mod2
- Modulation Index 2: controls mod2's influence on carrier
- Carrier Ratio: frequency ratio for carrier
- Modulator 1/2 Ratios: frequency ratios for modulators
- 8 presets including extreme/strident spectra

---

### Modulator to Modulator to Carrier with Envelopes
**File:** `FMModModCarEnvelopes.csd`
**Description:** Serial FM chain (mod1 -> mod2 -> carrier) with independent ADSR envelopes for both modulation indices. Particularly effective for creating evolving, complex timbres.
**Key Opcodes:** `oscili`, `madsr`
**Parameters:**
- Base Frequency: 20-20000 Hz
- Modulation Index 1/2: with independent envelopes
- Index 1 Envelope: Attack, Decay, Sustain, Release
- Index 2 (Amplitude) Envelope: Attack, Decay, Sustain, Release
- Carrier/Modulator Ratios
- 8 presets for complex timbres

---

### Two Modulator-Carrier Pairs
**File:** `FMModCarModCar.csd`
**Description:** Four-oscillator algorithm combining two independent modulator-carrier pairs. Each pair has independent fine-tuning for detuning/beating effects between the pairs.
**Key Opcodes:** `oscili`
**Parameters:**
- Base Frequency: 1-20000 Hz
- Fine Tune 1/2: cents offset for each pair (-100 to +100)
- Modulation Index 1/2: independent index for each pair
- Carrier 1/2 Ratio: frequency ratios for carriers
- Modulator 1/2 Ratio: frequency ratios for modulators
- Carrier 1/2 Amplitude: independent amplitudes
- Master Gain: overall output level

---

## Phase Modulation Synthesis

### Carrier with Feedback
**File:** `PhaseModulationSynthesisCf.csd`
**Description:** Single oscillator phase modulation with self-modulating feedback loop. Creates complex spectra from a minimal configuration.
**Key Opcodes:** `phasor`, `tablei`
**Parameters:**
- Base Frequency: 20-20000 Hz
- Amplitude: 0-30000
- Feedback Ratio: 0-1 - amount of output fed back to phase input

---

### Modulator (with Feedback) to Carrier
**File:** `PhaseModulationSynthesisMfC.csd`
**Description:** Modulator-carrier PM with feedback on the modulator. Includes switch to compare PM and FM synthesis techniques. Demonstrates that feedback is not used in the FM version.
**Key Opcodes:** `phasor`, `tablei`, `oscili`
**Parameters:**
- Base Frequency: 20-20000 Hz
- Modulation Index: 0-100
- Carrier/Modulator Ratios
- Feedback Ratio: 0-1 (PM only)
- Peak Deviation: display of calculated value
- Mode Switch: Phase Modulation or FM Synthesis

---

### Modulator to Carrier (with Feedback)
**File:** `PhaseModulationSynthesisMCf.csd`
**Description:** Modulator-carrier PM with feedback loop on the carrier output feeding back to the modulator.
**Key Opcodes:** `phasor`, `tablei`
**Parameters:**
- Base Frequency: 20-20000 Hz
- Modulation Index: 0-100
- Carrier/Modulator Ratios
- Feedback Ratio: 0-1

---

### Two Parallel Modulators to Carrier
**File:** `PhaseModulationSynthesisMM_C.csd`
**Description:** Phase modulation with two parallel modulators both feeding a single carrier. Each modulator has independent index and frequency ratio controls.
**Key Opcodes:** `phasor`, `tablei`
**Parameters:**
- Base Frequency: 20-20000 Hz
- Modulation Index 1/2: independent depths
- Carrier Amplitude: 0-1
- Modulator 1/2 Ratios: frequency ratios
- Carrier Ratio: frequency ratio

---

### Three Parallel Modulators to Carrier
**File:** `PhaseModulationSynthesisMMM_C.csd`
**Description:** Phase modulation with three parallel modulators feeding a single carrier. Default ratios are slightly detuned for chorus-like effects.
**Key Opcodes:** `phasor`, `tablei`
**Parameters:**
- Base Frequency: 20-20000 Hz
- Modulation Index 1/2/3: independent depths
- Carrier Amplitude: 0-1
- Modulator 1/2/3 Ratios: frequency ratios
- Carrier Ratio: frequency ratio

---

### Serial Modulator Chain (M->M->C)
**File:** `PhaseModulationSynthesisMMC.csd`
**Description:** Phase modulation with modulator 1 modulating modulator 2, which modulates the carrier. Includes chorus effect on output.
**Key Opcodes:** `phasor`, `tablei`, `delayr`, `deltap3`, `delayw`
**Parameters:**
- Base Frequency: 20-20000 Hz
- Modulation Index 1/2: independent depths (0-1)
- Modulator 1/2 Ratios: frequency ratios
- Carrier Ratio: frequency ratio
- Chorus Depth/Rate/Mix: output effect controls

---

### Serial Modulator Chain (M->M->M->C)
**File:** `PhaseModulationSynthesisMMMC.csd`
**Description:** Phase modulation with three serial modulators: mod1 -> mod2 -> mod3 -> carrier. Includes chorus effect on output.
**Key Opcodes:** `phasor`, `tablei`, `delayr`, `deltap3`, `delayw`, `zakinit`, `zar`, `zawm`, `zacl`
**Parameters:**
- Base Frequency: 20-20000 Hz
- Modulation Index 1/2/3: independent depths (0-10)
- Modulator 1/2/3 Ratios: frequency ratios
- Carrier Ratio: frequency ratio
- Carrier Amplitude: 0-1
- Chorus Depth/Rate/Mix: output effect controls

---

## TX81Z FM Preset Opcodes

### Yamaha TX81Z Models
**File:** `TX81Z.csd`
**Description:** Demonstrates Csound's built-in opcodes that implement presets from the Yamaha TX81Z FM synthesizer module. Seven different four-operator FM algorithms with preset timbres.
**Key Opcodes:** `fmb3`, `fmbell`, `fmmetal`, `fmpercfl`, `fmrhode`, `fmvoice`, `fmwurlie`
**Parameters:**
- Amplitude: 0-1 (CC#7)
- Control 1: 0-99 (CC#3) - varies by preset (total mod index, mod index 1, vowel)
- Control 2: 0-99 (CC#4) - varies by preset (crossfade, tilt)
- Vibrato Depth: 0.0001-1 (CC#1)
- Vibrato Rate: 0-10 (CC#2)
- Preset Types:
  - B3: Hammond B3 organ simulation
  - Bell: Tubular bell
  - Heavy Metal: Aggressive distorted sound
  - Percussive Flute: Breathy flute with attack
  - Rhodes: Rhodes electric piano
  - Voice: Vocal formant synthesis
  - Wurlitzer: Wurlitzer electric piano

---

## Common Patterns and Techniques

### FM Synthesis Formula
```
Peak Deviation = Base Frequency * Index of Modulation
Modulator Output = oscili(Peak Deviation, Base Freq * Mod Ratio)
Carrier Output = oscili(Carrier Amp, (Base Freq * Car Ratio) + Modulator Output)
```

### Phase Modulation Pattern
```
Mod Phase = phasor(Base Freq * Mod Ratio)
Modulator = tablei(Mod Phase, sine_table, 1, 0, 1)
Modulator = Modulator * Index
Car Phase = phasor(Base Freq * Car Ratio)
Carrier = tablei(Car Phase + Modulator, sine_table, 1, 0, 1)
```

### Anti-Click Envelope
```
aAntiClick linsegr 0, 0.001, 1, 0.01, 0
```

### Portamento Smoothing
```
iporttime = 0.02
kporttime linseg 0, 0.001, iporttime, 1, iporttime
kparam portk gkparam, kporttime
```

---

## Algorithm Diagrams

### Basic Modulator-Carrier
```
    +-----+
    | MOD |
    +--+--+
       |
    +--+--+
    | CAR |
    +--+--+
       |
      OUT
```

### Parallel Modulators
```
  +-----+   +-----+
  |MOD 1|   |MOD 2|
  +--+--+   +--+--+
     |         |
     +----+----+
          |
       +--+--+
       | CAR |
       +--+--+
          |
         OUT
```

### Serial Modulators
```
    +-----+
    |MOD 1|
    +--+--+
       |
    +--+--+
    |MOD 2|
    +--+--+
       |
    +--+--+
    | CAR |
    +--+--+
       |
      OUT
```

### Feedback Loop
```
       +------+
       V      |
    +--+--+   |
    | OSC |   | (feedback)
    +--+--+   |
       |      |
       +------+
       |
      OUT
```
