# FM Synthesis with Global Reverb Bus

## Metadata

- **Title:** FM Synthesis with Global Reverb Bus (Multi-Instrument Architecture)
- **Category:** FM Synthesis / Audio Routing / Effects Architecture / Global Processing
- **Difficulty:** Intermediate
- **Tags:** `fm-synthesis`, `frequency-modulation`, `global-reverb`, `audio-bus`, `signal-routing`, `effects-send`, `multi-instrument`, `modulation-index`, `global-variables`, `reverb`, `spatial-effects`
- **Source File:** `coda.aiff`

---

## Description

This example demonstrates two essential Csound concepts: (1) classic FM (Frequency Modulation) synthesis for creating rich, complex timbres, and (2) global audio signal routing using a reverb "bus" architecture. Multiple FM instruments send their signals to a global reverb processor (instrument 99), creating a unified spatial environment. This architecture is fundamental to professional Csound orchestration, separating sound generation from effects processing for efficiency and flexibility.

**Use Cases:**
- FM synthesis for bells, metallic sounds, complex tones
- Creating cohesive spatial environments across multiple instruments
- Efficient reverb processing (one reverb for many instruments)
- Learning signal routing and global variables in Csound
- Building professional multi-instrument compositions
- Understanding audio bus architecture (send/return effects)

**Key Concepts:**
1. **FM Synthesis:** Modulating one oscillator's frequency with another creates complex spectra
2. **Global Audio Variables:** `ga` variables pass audio between instruments
3. **Effects Bus:** Multiple instruments → single effect processor (efficient!)
4. **Signal Flow:** Direct dry signal + wet reverb signal = final output

---

## Complete Code

```csound
<CsoundSynthesizer>
<CsOptions>
-o coda.aiff
</CsOptions>
<CsInstruments>
; FM INSTRUMENT WITH GLOBAL REVERB
sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2
0dbfs     =         32768
garvbsig  init      0                             ; GLOBAL AUDIO REVERB SIGNAL

; INITIALIZATION
; p4      =         amplitude of output wave
; p5      =         carrier frequency in Hz
; p6      =         modulating frequency in Hz
; p7      =         modulation index 1
; p8      =         modulation index 2

          instr 1                                 ; FM INSTRUMENT
iamp1     =         p7 * p6                       ; amp for amod
iamp2     =         (p8-p7) * p6                  ; amp for ampmod
k1        randi     120, 10                       ; random variation ±120 Hz
k2        randi     200, 20                       ; random variation ±200 Hz
ampcar    oscil     p4, 1/p3, 1                   ; amp envelope for carrier
ampmod    oscil     iamp2, 1/p3, 1                ; amp envelope for modulator
amod      oscili    ampmod+iamp1, p6 + k1, 1      ; modulator oscillator
gasig     oscili    ampcar, k2 + p5 + amod, 1     ; carrier oscillator (global)
          outch     1, gasig * .25                ; left direct audio output
          outch     2, gasig * .25                ; right direct audio output
garvbsig  =         garvbsig + gasig * .25        ; send to reverb bus
          endin

          instr 99                                ; GLOBAL REVERB INSTRUMENT
irvbtime  =         p4                            ; reverb time (seconds)
asig2     reverb    garvbsig, irvbtime            ; reverb processing
          outch     1, asig2                      ; output reverb left
          outch     2, asig2                      ; output reverb right
garvbsig  =         0                             ; clear reverb bus
          endin
</CsInstruments>
<CsScore>
f1  0   1024    9   1   1   0   3   4   0   4   12  0

;instr  start   dur   amp   cfreq  mfreq  modI1  modI2
i1      0       16    2500  150    300    5      10
i1      7       14    .     .      .      .      .
i1      12      20    3600  300    650    10     20

;instr  start   dur   rvbtime
i99     0       67    35
e
</CsScore>
</CsoundSynthesizer>
```

---

## Detailed Explanation

### Orchestra Header

```csound
sr    = 44100
kr    = 4410
ksmps = 10
nchnls = 2
0dbfs = 32768
```

**Control rate setup:**
- `kr = 4410` - Control rate (44100/10)
- `ksmps = 10` - 10 audio samples per control period
- Less CPU intensive than ksmps=1
- Adequate for FM synthesis and reverb

### Global Variables

```csound
garvbsig  init  0
```

**Global audio variable for reverb bus:**
- `ga` prefix = **global audio** variable
- `garvbsig` = "global audio reverb signal"
- `init 0` = initialize to silence
- **Shared across all instruments** - any instrument can read/write
- Used to route audio to the global reverb (instrument 99)

**Why global variables?**
- **Efficiency:** One reverb processor for all instruments (instead of one per instrument)
- **Flexibility:** Easy to add more instruments to same reverb
- **Professional architecture:** Standard in audio production (send/return effects)

---

## Instrument 1 - FM Synthesizer

### Parameter Mapping

```csound
; p4 = amplitude of output wave
; p5 = carrier frequency in Hz
; p6 = modulating frequency in Hz
; p7 = modulation index 1 (minimum)
; p8 = modulation index 2 (maximum)
```

### Modulation Amplitude Calculations

```csound
iamp1 = p7 * p6
iamp2 = (p8-p7) * p6
```

**FM synthesis key relationship:**
```
modulation_amplitude = modulation_index × modulator_frequency
```

**iamp1 (minimum modulation):**
- `p7` = modulation index 1 (starting/minimum depth)
- `p7 * p6` = modulation amplitude at minimum
- Used as constant base modulation

**iamp2 (modulation envelope depth):**
- `p8 - p7` = modulation index range
- `(p8-p7) * p6` = additional modulation controlled by envelope
- Creates time-varying modulation depth

**Example (first note):**
- p6 = 300 Hz (modulator frequency)
- p7 = 5 (modulation index 1)
- p8 = 10 (modulation index 2)
- `iamp1 = 5 × 300 = 1500` Hz (base modulation)
- `iamp2 = (10-5) × 300 = 1500` Hz (envelope-controlled modulation)

### Random Frequency Deviations

```csound
k1  randi  120, 10    ; ±120 Hz variation at 10 Hz rate
k2  randi  200, 20    ; ±200 Hz variation at 20 Hz rate
```

**randi opcode** - Random interpolating values (k-rate)
- `k1`: Random modulator frequency deviation (±120 Hz, 10 Hz update rate)
- `k2`: Random carrier frequency deviation (±200 Hz, 20 Hz update rate)

**Why add randomness?**
- Prevents perfect, static tones (more organic)
- Creates subtle pitch variation (like analog instability)
- Adds "warmth" and "life" to synthetic sounds
- Different update rates (10 Hz vs 20 Hz) create complex interaction

### Amplitude Envelopes

```csound
ampcar  oscil  p4, 1/p3, 1
ampmod  oscil  iamp2, 1/p3, 1
```

**oscil** reading table 1 (sine wave) as envelope:

**ampcar (carrier amplitude envelope):**
- Amplitude = `p4` (peak amplitude from score)
- Frequency = `1/p3` (one cycle over note duration)
- **Result:** Sine-shaped envelope over note duration
  - At t=0: amplitude = 0 (sine starts at zero crossing)
  - At t=p3/2: amplitude = p4 (sine peak at middle)
  - At t=p3: amplitude = 0 (sine returns to zero)

**ampmod (modulation depth envelope):**
- Amplitude = `iamp2` (modulation depth range)
- Same sine envelope shape
- **Result:** Modulation index varies smoothly over note duration
  - Start: minimum modulation (brightest or darkest depending on timbre)
  - Middle: maximum modulation (peak spectral complexity)
  - End: minimum modulation (returns to simpler spectrum)

**Why sine-shaped envelopes?**
- Smooth attack and release (no clicks)
- Natural, musical feel
- Creates dynamic timbral evolution

### FM Synthesis Core

```csound
amod   oscili  ampmod+iamp1, p6 + k1, 1
gasig  oscili  ampcar, k2 + p5 + amod, 1
```

**Modulator (amod):**
```csound
oscili  ampmod+iamp1, p6 + k1, 1
```
- **Amplitude:** `ampmod + iamp1`
  - `iamp1` = constant base modulation
  - `ampmod` = time-varying modulation (envelope)
  - Sum = total modulation depth varies over time
- **Frequency:** `p6 + k1`
  - `p6` = base modulator frequency
  - `k1` = random deviation
- **Table:** 1 (sine wave)
- **Output:** Audio-rate modulation signal

**Carrier (gasig):**
```csound
oscili  ampcar, k2 + p5 + amod, 1
```
- **Amplitude:** `ampcar` (envelope-controlled)
- **Frequency:** `k2 + p5 + amod`
  - `p5` = base carrier frequency
  - `k2` = random deviation
  - `amod` = **FM modulation signal** (key to FM synthesis!)
- **Table:** 1 (sine wave)
- **Output:** Global audio signal (`gasig`)

**FM Synthesis Principle:**
The modulator's output (amod) is added to the carrier's frequency input, creating frequency modulation. This generates complex spectra with multiple sidebands.

**Why `gasig` instead of `asig`?**
- `ga` prefix = **global audio** variable
- Available to other instruments (like reverb processor)
- Standard practice for signals that need global routing

### Signal Routing

```csound
outch  1, gasig * .25
outch  2, gasig * .25
garvbsig = garvbsig + gasig * .25
```

**Three-way signal split:**

**1. Direct output left/right (dry signal):**
```csound
outch 1, gasig * .25    ; 25% to left output
outch 2, gasig * .25    ; 25% to right output
```
- Stereo output (same signal both channels)
- 0.25 scaling prevents clipping (75% headroom)

**2. Send to reverb bus (wet signal):**
```csound
garvbsig = garvbsig + gasig * .25
```
- **Accumulates** signal into global reverb bus
- `garvbsig + gasig` (not `=` alone!) allows multiple instruments to sum
- Also scaled to 0.25

**Overall signal flow:**
- 25% dry left
- 25% dry right
- 25% to reverb (which will output wet signal)
- Total: 75% per instrument (leaves headroom for multiple instances)

**Why this architecture?**
Classic **wet/dry mix** with **send/return** effects routing:
- Dry signal: immediate, present
- Wet signal: reverberant, spacious
- Separation allows independent control

---

## Instrument 99 - Global Reverb Processor

```csound
instr 99
irvbtime  =     p4
asig2     reverb    garvbsig, irvbtime
          outch     1, asig2
          outch     2, asig2
garvbsig  =     0
endin
```

### Reverb Processing

```csound
irvbtime = p4
```
**Reverb time parameter:**
- p4 = reverb decay time in seconds
- Time for signal to decay to -60 dB
- From score: `i99 0 67 35` → 35 seconds reverb time
- **Very long reverb** (35s) = "excessive reverb" per title

```csound
asig2  reverb  garvbsig, irvbtime
```

**reverb opcode** - Classic Schroeder reverb:
- Input: `garvbsig` (accumulated audio from all instruments)
- Reverb time: `irvbtime` (35 seconds)
- Output: `asig2` (reverberant signal)

**How it works:**
- All FM instruments send signal to `garvbsig`
- Reverb processes the summed signal
- Creates unified acoustic space
- Much more efficient than per-instrument reverb

### Output

```csound
outch  1, asig2
outch  2, asig2
```

**Reverb output (wet signal only):**
- Stereo output (same to both channels)
- **No scaling** - reverb opcode already attenuates
- Adds spatial depth to dry signal from instrument 1

### Critical Bus Clearing

```csound
garvbsig = 0
```

**ESSENTIAL: Clear the reverb bus!**

**Why this is critical:**
- Global variables persist between k-cycles
- Without clearing: signal accumulates infinitely
- Result: Exponentially growing amplitude → distortion/explosion

**How it works:**
1. Instruments write to `garvbsig` during k-cycle
2. Reverb reads accumulated `garvbsig`
3. Reverb clears `garvbsig` to zero
4. Next k-cycle starts fresh

**Must be in same instrument that reads the bus!**

---

## Score Section

### Function Table

```csound
f1  0  1024  9  1  1  0  3  4  0  4  12  0
```

**GEN09 - Composite waveform:**
```
Partial  Strength  Phase
1        1         0      ; Fundamental
3        4         0      ; 3rd harmonic (4× amplitude)
4        12        0      ; 4th harmonic (12× amplitude!)
```

**Resulting waveform:**
- Strong upper harmonics (3rd and 4th)
- Very bright, complex waveform
- Not a pure sine - rich harmonic content
- Used for both envelopes and oscillators

**Why this matters:**
- Table 1 used by both envelopes and oscillators
- Rich harmonic content in envelopes creates interesting amplitude modulation
- Creates more complex FM spectra

### FM Instrument Calls

**Event 1:**
```csound
i1  0  16  2500  150  300  5  10
```
- **0-16 sec**, 2500 amplitude
- **Carrier:** 150 Hz (low, bass-like)
- **Modulator:** 300 Hz (2:1 ratio with carrier)
- **Mod Index:** 5 → 10 (increases over time)
- **Timbre:** Deep, evolving bass with complex harmonics

**Event 2:**
```csound
i1  7  14  <  <  <  <  <
```
- **7-21 sec** (starts during event 1 - overlap!)
- `<` = **carry** (use previous value)
- **Same parameters as event 1**
- Creates overlap/layering of similar sounds

**Event 3:**
```csound
i1  12  20  3600  300  650  10  20
```
- **12-32 sec** (overlaps with event 2)
- **Louder** (3600 vs 2500)
- **Higher carrier:** 300 Hz
- **Higher modulator:** 650 Hz (≈2.17:1 ratio - inharmonic!)
- **Greater mod depth:** 10 → 20 (more extreme modulation)
- **Timbre:** Brighter, more complex, dramatic evolution

### Global Reverb Call

```csound
i99  0  67  35
```
- **Instrument 99** (reverb processor)
- **0-67 seconds** (must cover entire piece duration)
- **35 seconds** reverb time (very long, "excessive")

**Why duration = 67 seconds?**
Last note ends at 32s, but needs time for reverb decay. 67s ensures complete reverb tail.

---

## Key Concepts

### FM Synthesis Fundamentals

**Basic principle:**
```
carrier_frequency = base_frequency + modulator_signal
```

**Resulting spectrum:**
```
Frequencies = fc ± n×fm
where:
  fc = carrier frequency
  fm = modulator frequency
  n = 0, 1, 2, 3... (sideband number)
```

**Modulation index controls:**
- **Low index (1-2):** Few sidebands, simpler timbre
- **Medium index (5-10):** Multiple sidebands, complex timbre
- **High index (>10):** Many sidebands, very bright/noisy

**Example calculation (Event 1):**
- fc = 150 Hz (carrier)
- fm = 300 Hz (modulator)
- Index = 5 (minimum) to 10 (maximum)

**Sidebands at index=5:**
```
150 ± 0×300 = 150 Hz
150 ± 1×300 = 150±300 = -150, 450 Hz (only 450 Hz audible)
150 ± 2×300 = 150±600 = -450, 750 Hz (only 750 Hz audible)
150 ± 3×300 = 150±900 = -750, 1050 Hz (only 1050 Hz audible)
... up to ±5 sidebands
```

**Why it sounds complex:**
Multiple frequencies generated from just two oscillators!

### C:M Ratio (Carrier to Modulator Ratio)

**Event 1:** 150:300 = 1:2
- **Harmonic relationship** (integer ratio)
- Creates harmonic spectrum
- Musical, tonal result

**Event 3:** 300:650 ≈ 1:2.17
- **Inharmonic relationship** (non-integer ratio)
- Creates inharmonic spectrum
- Bell-like, metallic, complex

**Classic FM timbres:**
- **1:1** - Brass-like
- **1:2** - Clarinet-like
- **2:1** - Hollow, woody
- **Non-integer** - Bells, metallic, gongs

### Global Audio Bus Architecture

**Signal flow diagram:**
```
Instrument 1 ────► gasig ────┬──► outch 1,2 (dry)
                              │
                              └──► garvbsig ──► Instrument 99 (reverb) ──► outch 1,2 (wet)
```

**Why global audio variables?**

**Advantages:**
1. **Efficiency** - One reverb for many instruments (not one per instrument)
2. **Unified space** - All sounds share same reverb characteristics
3. **Flexibility** - Easy to add more instruments to bus
4. **Professional architecture** - Standard in audio production

**Naming convention:**
- `ga` prefix = global audio
- Descriptive name: `garvbsig`, `gasend`, `gadelaysig`, etc.

**Critical pattern:**
```csound
; In sound-generating instrument:
gaBus = gaBus + aSignal

; In effect instrument:
aProcessed effect gaBus
out aProcessed
gaBus = 0    ; MUST CLEAR!
```

---

## Parameter Exploration

### Modulation Index (p7, p8)

**Low (1-3):**
- Few sidebands
- Simple, relatively pure timbre
- Subtle frequency modulation

**Medium (5-10):**
- Multiple sidebands
- Complex, rich timbre
- Characteristic FM sound
- Good for most musical applications

**High (15-30):**
- Many sidebands
- Very bright, dense spectrum
- Can sound noisy or harsh
- Good for aggressive, metallic sounds

**Dynamic range (p8-p7):**
- **Small range** (p7=8, p8=10): Subtle evolution
- **Large range** (p7=5, p8=20): Dramatic timbral change

### Carrier:Modulator Ratio

**Harmonic (integer ratios):**
- 1:1, 1:2, 2:1, 3:2, etc.
- Produces harmonic overtones
- Musical, tonal

**Inharmonic (non-integer):**
- 1:1.5, 1:2.17, 1:π, etc.
- Produces inharmonic overtones
- Bell-like, metallic, complex

**Detuned (close to integer):**
- 1:1.99, 1:2.01
- Beating effects
- Chorus-like movement

### Reverb Time (p4 of instr 99)

**Short (0.5-2 seconds):**
- Room ambience
- Tight, defined space
- Good for rhythmic material

**Medium (2-5 seconds):**
- Hall reverb
- Natural acoustic space
- Most musical applications

**Long (5-15 seconds):**
- Cathedral, large space
- Lush, atmospheric
- Ambient music

**Very long (15+ seconds):**
- "Excessive" (as title suggests)
- Drone-like pad
- Experimental, immersive
- Example uses 35 seconds!

---

## Variations

### Simple FM Bell

```csound
; Inharmonic ratio, high index
i1  0  5  3000  200  440  15  25
; C:M ratio 200:440 ≈ 1:2.2 (bell-like)
```

### FM Brass

```csound
; 1:1 ratio (brass characteristic)
i1  0  3  2500  220  220  5  8
```

### FM Bass with Envelope

```csound
; Low frequencies, moderate index
i1  0  8  3000  50  100  3  7
; Timbral evolution over 8 seconds
```

### Multiple Reverb Buses

```csound
; Orchestra
garvb1 init 0  ; Short reverb
garvb2 init 0  ; Long reverb

instr 1
  ; ... FM synthesis ...
  garvb1 = garvb1 + gasig * 0.1   ; Send to short reverb
  garvb2 = garvb2 + gasig * 0.3   ; Send more to long reverb
endin

instr 98  ; Short reverb
  ashort reverb garvb1, 1.5
  out ashort, ashort
  garvb1 = 0
endin

instr 99  ; Long reverb
  along reverb garvb2, 8.0
  out along, along
  garvb2 = 0
endin
```

### Stereo Panning

```csound
; In instrument 1, before reverb send
apan linseg 0, p3, 1        ; Pan left to right
outch 1, gasig * (1-apan)   ; Left channel
outch 2, gasig * apan       ; Right channel
; Reverb still receives mono sum
```

### Dynamic Reverb Time

```csound
; In instrument 99
krvbtime line p4, p3, p4*0.5  ; Reverb time decreases
asig2 reverb garvbsig, krvbtime
```

### Multiple FM Instruments to Same Bus

```csound
instr 1  ; High FM
  ; ... synthesis ...
  garvbsig = garvbsig + gasig * 0.25
endin

instr 2  ; Low FM
  ; ... synthesis ...
  garvbsig = garvbsig + gasig * 0.25
endin

instr 3  ; Noise
  anoise rand 5000
  garvbsig = garvbsig + anoise * 0.1
endin

; All share instrument 99 reverb!
```

---

## Common Issues & Solutions

### Reverb Bus Not Cleared (Explosion!)
**Problem:** Sound grows exponentially, distorts, explodes
**Cause:** `garvbsig = 0` missing from reverb instrument
**Solution:**
```csound
instr 99
  asig2 reverb garvbsig, irvbtime
  out asig2, asig2
  garvbsig = 0    ; MUST HAVE THIS!
endin
```

### No Reverb Heard
**Problem:** Only dry signal, no spatial depth
**Cause:**
- Reverb instrument (99) not running
- Duration too short
- Global variable not accumulating

**Solution:**
```csound
; Ensure reverb runs entire piece
i99 0 [total_duration + reverb_time] 5

; Check accumulation (not assignment)
garvbsig = garvbsig + gasig  ; Correct (+=)
; NOT: garvbsig = gasig       ; Wrong (last write wins)
```

### Distortion/Clipping
**Problem:** Output distorts
**Cause:** Too many instruments, insufficient scaling
**Solution:**
```csound
; Scale down signals
outch 1, gasig * 0.1     ; Reduce from 0.25
garvbsig = garvbsig + gasig * 0.1

; Or normalize output
aout = gasig
aout limit aout, -0dbfs, 0dbfs
```

### FM Sounds Wrong/Static
**Problem:** Not enough timbral evolution
**Cause:** p7 = p8 (no modulation index change)
**Solution:**
```csound
; Ensure p7 < p8 for evolution
i1 0 10 3000 200 400 5 15  ; Good (5→15)
; NOT: i1 0 10 3000 200 400 10 10  ; Static (10→10)
```

### Reverb Time Incorrect
**Problem:** Reverb too short or too long
**Cause:** p4 parameter in i99 statement
**Solution:**
```csound
; Adjust reverb time
i99 0 60 2.5   ; Shorter (2.5s room)
i99 0 60 8     ; Medium (8s hall)
i99 0 60 35    ; Long (35s cathedral)
```

---

## Sound Design Applications

### Ambient FM Pad

```csound
; Long notes, low index range, long reverb
i1  0  30  2000  100  200  2  5
i1  10 30  2000  150  301  2  5
i1  20 30  2000  200  402  2  5
i99 0  70  25   ; Very long reverb
```

### FM Bell Ensemble

```csound
; Inharmonic ratios, high indices
i1  0  8  3000  200  440  10  20
i1  2  8  3000  300  660  10  20
i1  4  8  3000  400  880  10  20
i99 0  20 8    ; Medium reverb
```

### Aggressive FM Lead

```csound
; High frequencies, extreme modulation
i1  0  5  4000  800  1600  20  40
i99 0  10 3    ; Short, tight reverb
```

### Evolving Soundscape

```csound
; Overlapping, varying parameters
i1  0  20  2500  100  200   5  15
i1  5  20  2500  150  305   6  12
i1  10 20  2500  200  410   7  10
i1  15 20  2500  250  515   8  16
i99 0  50  20   ; Long reverb for smooth blend
```

---

## Advanced Topics

### FM Synthesis Theory

**Mathematical formulation:**
```
output = A × sin(2π×fc×t + I×sin(2π×fm×t))

where:
  A = carrier amplitude
  fc = carrier frequency
  I = modulation index
  fm = modulator frequency
  t = time
```

**Bessel function prediction:**
Sideband amplitudes predicted by Bessel functions of the first kind:
```
Amplitude of nth sideband = Jn(I)
```
where I = modulation index

**Bandwidth estimate:**
```
Bandwidth ≈ 2 × fm × (I + 1)
```
Carson's rule for FM bandwidth

### Global Variable Execution Order

**Critical timing:**
```csound
; K-cycle N:
instr 1: writes to garvbsig
instr 2: writes to garvbsig
instr 99: reads garvbsig, clears it

; K-cycle N+1:
instr 1: writes to garvbsig (now zero)
...
```

**Instrument execution order:**
- Lower instrument numbers execute first
- By default: 1, 2, 3, ... 99
- Can override with `massign` or scheduling

**Why reverb is instrument 99:**
High number ensures it executes **after** all signal generators, reading their accumulated signals.

### Multiple Effect Buses

**Professional architecture:**
```csound
; Global buses
garvb init 0    ; Reverb bus
gadly init 0    ; Delay bus
gacmp init 0    ; Compressor bus

; Sound generator
instr 1
  ; ... synthesis ...
  garvb = garvb + asig * 0.3
  gadly = gadly + asig * 0.1
endin

; Effects
instr 98  ; Delay
  adly delay gadly, 0.5
  out adly, adly
  gadly = 0
endin

instr 99  ; Reverb
  arvb reverb garvb, 5
  out arvb, arvb
  garvb = 0
endin
```

---

## Related Examples

**Progression Path:**
1. **Current:** Basic FM with global reverb bus
2. **Next:** Complex FM (multiple modulators)
3. **Then:** Additive synthesis with effect buses
4. **Advanced:** Complete mixing console in Csound

**Related Techniques:**
- `Additive Synthesis` - Summing multiple oscillators
- `Waveshaping` - Another nonlinear synthesis method
- `Phase Modulation` - Related to FM (used in DX7)
- `Audio Bus Mixing` - Professional signal routing

**Related Opcodes:**
- `foscil` / `foscili` - Optimized FM oscillators
- `reverbsc` - Higher quality stereo reverb
- `freeverb` - Another reverb algorithm
- `nreverb` - Network reverb (more parameters)

---

## Performance Notes

- **CPU Usage:** Moderate (FM is efficient, reverb adds some load)
- **Polyphony:** Can run many FM instruments simultaneously
- **Real-time Safe:** Yes, suitable for live performance
- **Latency:** Standard (ksmps = 10)
- **Bus Efficiency:** One reverb >> multiple reverbs (much more CPU efficient)

---

## Historical Context

**FM Synthesis:**
- **Invented:** John Chowning (Stanford, 1967-73)
- **Patents:** Stanford University, licensed to Yamaha
- **Yamaha DX7 (1983):** First commercial FM synthesizer
  - Became one of best-selling synthesizers ever
  - Defined 1980s sound (bells, electric pianos, bass)
- **Impact:** Showed computers could create complex timbres efficiently

**Global Audio Buses:**
- Standard architecture from analog mixing consoles
- "Send/return" or "aux send" routing
- Adopted in digital audio workstations (DAWs)
- Essential for efficient effects processing

**This example demonstrates:**
Classic computer music techniques from the 1970s-80s that remain fundamental today.

---

## Extended Documentation

**Official Csound Opcode References:**
- [oscil](https://csound.com/docs/manual/oscil.html) / [oscili](https://csound.com/docs/manual/oscili.html)
- [reverb](https://csound.com/docs/manual/reverb.html)
- [randi](https://csound.com/docs/manual/randi.html)
- [foscil](https://csound.com/docs/manual/foscil.html) - Optimized FM

**FM Synthesis References:**
- Chowning, John: "The Synthesis of Complex Audio Spectra by Means of Frequency Modulation" (1973)
- DX7 Manual - Classic FM programming reference
- Roads, Curtis: "The Computer Music Tutorial" - FM chapter

**Learning Resources:**
- Csound FLOSS Manual: Chapter 4.2 (FM Synthesis)
- The Csound Book: "FM Synthesis" chapter
- Sound On Sound: "Synth Secrets" - FM articles

**Philosophy:**
This example shows how simple techniques (two oscillators, one reverb) can create rich, professional results through proper architecture and signal routing.
