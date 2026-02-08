# Scanned Synthesis: Dynamic String Simulation

## Metadata

- **Title:** Scanned Synthesis: Dynamic String Simulation
- **Category:** Scanned Synthesis / Physical Modeling / Generative Synthesis
- **Difficulty:** Advanced
- **Tags:** `scanu`, `scans`, `scanned-synthesis`, `physical-modeling`, `dynamic-system`, `mass-spring`, `string-simulation`, `generative`, `evolving-sound`, `complex-timbres`
- **Source File:** `13_scannedSimple.aiff`

---

## Description

Scanned synthesis is a unique approach to sound generation developed by Bill Verplank, Max Mathews, and Rob Shaw. It simulates a network of masses connected by springs, creating a dynamic physical system whose motion is "scanned" to produce audio. Unlike traditional waveguide synthesis which models specific instruments, scanned synthesis creates entirely new timbres by defining custom physical topologies (strings, membranes, arbitrary networks) and scanning their vibrating state.

**Use Cases:**
- Creating novel, organic timbres impossible with other synthesis methods
- Evolving, non-repetitive textures with natural motion
- Physical modeling of custom string/membrane instruments
- Generative music with physically-based evolution
- Sound design for experimental/electronic music
- Simulating complex resonant bodies

**Key Innovation:**
The sound evolves naturally according to physics - you design the physical system, excite it, and listen as it vibrates and settles.

---

## Complete Code

```csound
<CsoundSynthesizer>
<CsOptions>
-o 13_scannedSimple.aiff
</CsOptions>
<CsInstruments>
	instr	1
a0	=		0
sr = 44100
ksmps = 100
nchnls = 1
0dbfs = 1
;	scanu	init,irate,ifnvel,ifnmass,ifnstif,ifncentr,ifndamp
;             kmass,kstif,kcentr,kdamp,ileft,iright,kx,ky,ain,idisp,id
	scanu	1, .01, 6, 2, 3, 4, 5, 2, .1, .1, -.01, .1, .5, 0, 0, a0, 0, 2
;ar scans	kamp,      kfreq,ifntraj,id[, korder]
a1	scans	ampdb(p4), cpspch(p5), 7, 2
	out		a1
	endin
</CsInstruments>
<CsScore>
; Initial condition
f1 0 128 7 0 64 1 64 0
; Masses
f2 0 128 -7 1 128 1
; Spring matrices
f3 0 16384 -23 "circularstring-128.mat"
f3 0 16384 -23 "scores/scanned_synthesis/surfaces/circularstring-128.matrix"
; Centering force
f4  0 128 -7 0 128 2
; Damping
f5 0 128 -7 1 128 1
; Initial velocity
f6 0 128 -7 0 128 0
; Trajectories
f7 0 128 -5 .001 128 128
; Note list
i1 0  10  86 6.00
i1 11 14  86 7.00
i1 15 20  86 5.00
</CsScore>
</CsoundSynthesizer>
```

---

## Detailed Explanation

### Orchestra Header

```csound
a0 = 0
sr = 44100
ksmps = 100
nchnls = 1
0dbfs = 1
```

**Key settings:**
- `a0 = 0` - Zero audio input (no external excitation after initialization)
- `ksmps = 100` - Higher ksmps acceptable for scanned synthesis (less demanding than waveguides)
- `0dbfs = 1` - Normalized amplitude scale (modern standard)

**Note on ksmps:**
Unlike waveguide synthesis, scanned synthesis doesn't require `ksmps=1`. The physical simulation runs internally at its own rate, independent of control rate.

### Instrument 1 - Scanned Synthesis Engine

#### The scanu Opcode (Scanner Update)

```csound
scanu	1, .01, 6, 2, 3, 4, 5, 2, .1, .1, -.01, .1, .5, 0, 0, a0, 0, 2
```

**scanu** = "scan update" - Updates the physical model simulation

**Parameters breakdown:**

**1. `init=1` (f1)** - Initial displacement table
- Defines starting shape/position of masses
- Table f1: Triangle wave shape (0→1→0)
- This is like plucking a string at the midpoint

**2. `irate=.01`** - Update rate for physics simulation
- How often (in seconds) to recalculate physics
- .01 = 100 updates per second
- Smaller = more accurate but more CPU
- Larger = more efficient but less accurate

**3. `ifnvel=6` (f6)** - Initial velocity table
- Starting velocities of all masses
- Table f6: All zeros (starts from rest)
- Non-zero values would add initial momentum

**4. `ifnmass=2` (f2)** - Mass distribution table
- Defines mass at each point in the network
- Table f2: All 1's (uniform mass)
- Varying masses changes resonance behavior

**5. `ifnstif=3` (f3)** - Stiffness matrix
- Defines spring connections between masses
- **Critical parameter** - determines topology
- f3 loads "circularstring-128.mat" (circular string topology)
- This is what makes it sound like a string vs. membrane vs. other

**6. `ifncentr=4` (f4)** - Centering force table
- Pulls masses back toward equilibrium (rest position)
- Table f4: All 2's (moderate centering)
- Like gravity or spring tension to rest position

**7. `ifndamp=5` (f5)** - Damping table
- Energy loss/friction at each mass
- Table f5: All 1's (moderate damping)
- Higher = faster decay, Lower = longer resonance

**8. `kmass=2`** - Global mass scaling
- Multiplies all mass values
- 2 = double the mass (slower movement)
- Affects resonant frequencies

**9. `kstif=.1`** - Global stiffness scaling
- Multiplies all spring stiffness values
- .1 = softer springs (lower pitch, more flexible)
- Higher = stiffer (higher pitch, more rigid)

**10. `kcentr=.1`** - Global centering force scaling
- Multiplies centering forces
- .1 = weak centering (freer motion)

**11. `kdamp=-.01`** - Global damping scaling
- Negative value = anti-damping (adds energy!)
- -.01 = slight energy injection (sustains oscillation)
- **Critical:** Prevents model from dying away
- Too negative = instability/explosion

**12. `ileft=.1`** - Left boundary condition
- How the left end of string is constrained
- .1 = mostly free (can move)
- 0 = completely free, 1 = completely fixed

**13. `iright=.5`** - Right boundary condition
- How the right end is constrained
- .5 = semi-fixed (partial constraint)
- Creates asymmetry in the string

**14. `kx=0`** - X position for scanning
- Not used in this example (0 = not scanning spatially)

**15. `ky=0`** - Y position for scanning
- Not used in this example

**16. `ain=a0`** - External audio input
- a0 = 0 (no ongoing excitation)
- Could inject audio to continuously excite the system

**17. `idisp=0`** - Display update rate
- 0 = no display
- Used for visualization in GUI environments

**18. `id=2`** - ID number for this scanned network
- Identifier to reference this specific simulation
- Multiple instruments can share same ID or have different IDs

#### The scans Opcode (Scanner Read)

```csound
a1	scans	ampdb(p4), cpspch(p5), 7, 2
```

**scans** = "scan synthesis" - Reads the physical model to produce audio

**Parameters:**

**1. `ampdb(p4)`** - Amplitude
- `ampdb()` converts dB to linear amplitude
- p4 = 86 dB (quite loud)
- Controls output level

**2. `cpspch(p5)`** - Scanning frequency
- `cpspch()` converts pitch notation to Hz
- p5 = 6.00 (middle C), 7.00 (C octave up), 5.00 (C octave down)
- **This is NOT the resonant pitch of the string**
- This is the rate at which we "scan" along the string to read positions

**How scanning works:**
Imagine a string with 128 masses. `scans` reads the position of these masses in sequence at the scanning frequency:
- 6.00 ≈ 261 Hz means reading all 128 masses 261 times per second
- Each mass position becomes a sample value
- The dynamic motion of masses creates the timbre

**3. `ifntraj=7` (f7)** - Trajectory/scanning path table
- Defines which masses to read and in what order
- Table f7: Exponential curve from .001 to 128
- This is the "pickup" position along the string
- Different trajectories = different timbres from same physical system

**4. `id=2`** - ID of scanned network to read
- Must match the ID in `scanu`
- References the physical simulation created above

```csound
out a1
```
Output the scanned audio signal

### Score Section

#### Function Tables (The Physical Model Definition)

```csound
f1 0 128 7 0 64 1 64 0
```
**Initial Displacement (f1)** - GEN07 (linear segments)
- 128 points (128 masses in the string)
- Segment 1: Points 0-64, value 0→1 (rising)
- Segment 2: Points 64-128, value 1→0 (falling)
- **Shape:** Triangle wave (like plucking a string at center)
- **Effect:** Excites fundamental and odd harmonics strongly

```csound
f2 0 128 -7 1 128 1
```
**Mass Distribution (f2)** - Uniform masses
- 128 points, all value = 1
- Equal mass at every point
- Negative GEN number = non-normalizing (values stay as-is)
- **Effect:** Uniform inertia throughout string

```csound
f3 0 16384 -23 "circularstring-128.mat"
f3 0 16384 -23 "scores/scanned_synthesis/surfaces/circularstring-128.matrix"
```
**Spring Matrix (f3)** - GEN23 (reads external matrix file)
- **CRITICAL TABLE** - defines the topology
- Size 16384 (must be large enough for 128×128 connectivity matrix)
- Loads "circularstring-128.mat" or the full path version
- **This matrix defines which masses connect to which via springs**

**Circular string topology:**
Each mass connects to its neighbors in a circle:
```
Mass 0 ← → Mass 1 ← → Mass 2 ... → Mass 127 ← → Mass 0
```
Forms a closed loop (circular string = like a vibrating ring)

**Other possible topologies:**
- Linear string (fixed ends)
- 2D membrane (grid connections)
- Custom networks (any connection pattern)

```csound
f4 0 128 -7 0 128 2
```
**Centering Force (f4)** - Pull toward equilibrium
- 128 points, all value = 2
- Moderate restoring force
- Like springs pulling each mass back to rest position
- **Effect:** Prevents runaway motion, defines fundamental pitch

```csound
f5 0 128 -7 1 128 1
```
**Damping (f5)** - Energy loss
- 128 points, all value = 1
- Moderate damping at all masses
- **Effect:** Controls decay time
- Higher = faster decay, Lower = longer sustain

```csound
f6 0 128 -7 0 128 0
```
**Initial Velocity (f6)** - Starting momentum
- 128 points, all value = 0
- Masses start from rest
- Non-zero would add initial "strike" velocity
- **Effect:** Combined with f1 (displacement) defines initial energy

```csound
f7 0 128 -5 .001 128 128
```
**Scan Trajectory (f7)** - GEN05 (exponential curve)
- 128 points
- Exponential from .001 to 128
- **This is the "pickup" position along the string**
- Reads masses non-uniformly (more samples from higher-numbered masses)
- **Effect:** Like changing pickup position on guitar - different harmonics emphasized

**Why exponential?**
Linear scan (.001 → 128 linearly) would emphasize fundamental.
Exponential scan emphasizes higher partials, creates brighter timbre.

#### Tempo and Notes

```csound
; Note: No tempo line needed with absolute times
; i-statements use absolute start times

i1 0  10  86 6.00    ; Start at 0s, 10s duration, 86dB, pitch 6.00 (C4)
i1 11 14  86 7.00    ; Start at 11s, 14s duration, 86dB, pitch 7.00 (C5)
i1 15 20  86 5.00    ; Start at 15s, 20s duration, 86dB, pitch 5.00 (C3)
```

**Note structure:**
- All use same physical model (same scanu parameters)
- Different scanning frequencies (p5) create different pitches
- Long durations allow physical model to evolve naturally
- **Overlapping notes:** Note 1 ends at 10s, Note 2 starts at 11s (1s gap)

**Scanning frequency effect:**
- 6.00 (261 Hz) scans the 128 masses 261 times/second
- 7.00 (523 Hz) scans twice as fast - octave higher
- 5.00 (130 Hz) scans half as fast - octave lower
- The *resonant* behavior of the physical model is the same; only scanning rate changes

---

## Key Concepts

### What is Scanned Synthesis?

**Traditional synthesis:**
Oscillators, filters, envelopes generate sound directly.

**Physical modeling (waveguide):**
Simulates specific physical systems (strings, pipes) with known behavior.

**Scanned synthesis:**
1. Define an arbitrary mass-spring network (the "haptic device")
2. Give it initial energy (displacement, velocity)
3. Let physics simulation run (masses bounce on springs)
4. "Scan" the positions of masses to generate audio
5. Sound evolves according to physical laws (resonance, damping, etc.)

**The genius:**
You design the physics, not the sound. Sound emerges from physical behavior.

### The Two-Stage Process

**Stage 1: scanu (Update)**
- Runs physical simulation
- Calculates forces, accelerations, velocities, positions
- Updates mass-spring network state
- Happens at `irate` interval (.01 = 100 Hz in example)

**Stage 2: scans (Read)**
- Scans the current state of masses
- Converts positions into audio samples
- Happens at audio rate (44100 Hz)
- Different scan rates = different pitches from same physics

**Analogy:**
- `scanu` = video camera recording a vibrating string
- `scans` = playing back that video at different speeds (different pitches)

### Mass-Spring-Damper Physics

Each mass in the network obeys:
```
F = ma (Newton's second law)
F_total = F_springs + F_centering + F_damping + F_external
```

**Spring forces:**
Pull mass toward connected neighbors (Hooke's law):
```
F_spring = -k * (x - x_neighbor)
```
k = stiffness

**Centering force:**
Pulls toward rest position:
```
F_center = -c * x
```
c = centering coefficient

**Damping force:**
Opposes motion (friction):
```
F_damp = -d * velocity
```
d = damping coefficient

**Result:**
Complex, natural-sounding motion with resonances, harmonics, decay.

### Topology: The Heart of Scanned Synthesis

The **stiffness matrix** (f3) defines the network topology:

**Circular string (example):**
```
Mass connections:
0-1, 1-2, 2-3, ..., 126-127, 127-0
```
Forms a loop - like a vibrating ring

**Linear string:**
```
0-1, 1-2, 2-3, ..., 126-127
```
Fixed or free ends - like a guitar string

**2D Membrane:**
```
Grid connections (4 neighbors per internal mass)
Like a drumhead
```

**Arbitrary networks:**
Any connection pattern imaginable!

**Different topologies = completely different timbres** from the same scanning code.

---

## Parameter Exploration

### Initial Condition (f1) Effects

**Triangle (example):**
- Fundamental + odd harmonics strong
- Like plucking at center

**Sine wave:**
```csound
f1 0 128 10 1    ; Pure sine shape
```
- Pure fundamental initially
- Evolves to include harmonics

**Random displacement:**
```csound
f1 0 128 21 1    ; Random values
```
- Noisy excitation
- All harmonics excited
- Chaotic initial sound

**Impulse (single spike):**
```csound
f1 0 128 7 0 63 0 1 1 64 0    ; Single spike at center
```
- All harmonics equally excited
- Broadband excitation

### Stiffness (kstif) Parameter

- **0.01-0.05** - Very flexible (low, fluttery pitch)
  - Slow resonances
  - Deep, organic sounds

- **0.1** - Moderate (example value)
  - Balanced flexibility
  - Musical pitch range

- **0.5-1.0** - Stiff (higher, tighter pitch)
  - Faster resonances
  - Brighter, more metallic

- **> 2.0** - Very stiff
  - High-pitched
  - Can become unstable

### Damping (kdamp) Parameter

**Positive damping (energy loss):**
- **0.01-0.1** - Light damping (long sustain)
- **0.5-1.0** - Moderate damping (natural decay)
- **2.0+** - Heavy damping (quick decay)

**Negative damping (energy injection):**
- **-0.001 to -0.01** - Slight injection (sustains oscillation)
- **-0.02 to -0.05** - Moderate injection (growing oscillation)
- **< -0.1** - Danger zone (can explode!)

**In example:** `kdamp = -.01` adds just enough energy to sustain indefinitely

### Centering Force (kcentr) Effects

- **0-0.05** - Very weak (nearly free motion)
  - Low fundamental pitch
  - Loose, floppy sound

- **0.1** - Weak (example value)
  - Moderate fundamental
  - Flexible but controlled

- **0.5-1.0** - Moderate
  - Clear fundamental pitch
  - Stable oscillation

- **> 2.0** - Strong
  - High fundamental
  - Tight, constrained sound

### Scan Trajectory (f7) Impact

**Linear scan:**
```csound
f7 0 128 -7 1 128 128    ; Linear 1→128
```
- Even reading of all masses
- Balanced harmonic spectrum

**Exponential (example):**
```csound
f7 0 128 -5 .001 128 128    ; Exponential
```
- More weight on higher masses
- Brighter, more upper harmonics

**Sine wave scan:**
```csound
f7 0 128 10 1    ; Sine shape
```
- Smooth, variable pickup position
- Warmer tone

**Random scan:**
```csound
f7 0 128 21 1    ; Random
```
- Unpredictable timbre
- Noisy character

**Effect:**
Like moving a guitar pickup along the string - same vibration, different sound.

---

## Variations

### Membrane (2D) Instead of String

```csound
; Load membrane matrix instead
f3 0 16384 -23 "membrane-128.mat"
; Or use GEN52 for automatic membrane generation
; f3 0 16384 -52 128 1 0.5 0.5 2 1    ; Square membrane
```

### Time-Varying Stiffness (Pitch Sweep)

```csound
kstif line 0.05, p3, 0.5    ; Stiffness increases over time
scanu 1, .01, 6, 2, 3, 4, 5, 2, kstif, .1, -.01, .1, .5, 0, 0, a0, 0, 2
```

### External Audio Excitation

```csound
ain diskin "sample.wav", 1    ; Load audio file
scanu 1, .01, 6, 2, 3, 4, 5, 2, .1, .1, -.01, .1, .5, 0, 0, ain*0.5, 0, 2
; Continuously excites model with external audio
```

### Multiple Scan Trajectories (Chord)

```csound
; Define multiple trajectory tables
f7 0 128 -5 .001 128 128     ; Trajectory 1
f8 0 128 -7 1 128 128        ; Trajectory 2 (linear)
f9 0 128 10 1                ; Trajectory 3 (sine)

; Scan with all three
a1 scans ampdb(p4), cpspch(p5), 7, 2
a2 scans ampdb(p4), cpspch(p5)*1.5, 8, 2    ; Perfect fifth higher
a3 scans ampdb(p4), cpspch(p5)*2, 9, 2      ; Octave higher
out (a1 + a2 + a3) / 3
```

### Non-Uniform Mass Distribution

```csound
; Heavier masses at the ends, lighter in middle
f2 0 128 -7 2 32 0.5 64 0.5 32 2
; Creates different resonance patterns
```

### Dynamic Damping (Envelope)

```csound
kdamp linseg -.01, 5, -.001, p3-5, .05    ; Sustain then decay
scanu 1, .01, 6, 2, 3, 4, 5, 2, .1, .1, kdamp, .1, .5, 0, 0, a0, 0, 2
```

### Spatial Scanning (Moving Pickup)

```csound
; Scan position moves along string
kscanpos lfo 64, 0.5, 0    ; LFO 0.5Hz, ±64 units
kx = 64 + kscanpos         ; Center ± 64 = full string
scanu 1, .01, 6, 2, 3, 4, 5, 2, .1, .1, -.01, .1, kx, 0, 0, a0, 0, 2
```

---

## Common Issues & Solutions

### No Sound Output
**Problem:** Scanned synthesis produces silence
**Cause:**
- Initial condition (f1) is all zeros
- Stiffness matrix (f3) file not found
- All damping, no energy injection

**Solution:**
```csound
; Ensure proper initial excitation:
f1 0 128 7 0 64 1 64 0    ; Non-zero initial shape
; Verify matrix file path is correct
; Use negative damping to sustain:
kdamp = -.01
```

### System Explodes (Amplitude Grows Uncontrollably)
**Problem:** Output level increases infinitely, eventual distortion
**Cause:** Negative damping (kdamp) too large (too much energy injection)
**Solution:**
```csound
; Reduce anti-damping:
kdamp = -.005    ; Was -.01 or more negative
; Or add positive damping:
kdamp = .05      ; Energy loss instead
; Or lower centering force:
kcentr = .05     ; Less restoring force
```

### Sound Decays Too Quickly
**Problem:** Model dies away almost immediately
**Cause:** Too much positive damping, not enough sustain
**Solution:**
```csound
; Reduce damping:
kdamp = -.01     ; Negative = energy injection
; Or reduce damping table values:
f5 0 128 -7 0.1 128 0.1    ; Less damping
; Or increase stiffness (more resonance):
kstif = .2
```

### Pitch is Wrong or Unstable
**Problem:** Pitch doesn't match scanning frequency or wavers
**Cause:** Confusion about scanning vs. resonant pitch
**Clarification:**
- **Scanning frequency (cpspch(p5))** controls playback pitch
- **Resonant pitch** depends on stiffness, centering, mass
- These are independent!

**Solution:**
```csound
; Scanning frequency sets perceived pitch:
a1 scans ampdb(p4), cpspch(p5), 7, 2
; Adjust resonance separately with stiffness/centering
```

### Matrix File Not Found Error
**Problem:** "can't open file circularstring-128.mat"
**Cause:** Matrix file path incorrect or file missing
**Solution:**
```csound
; Use full path:
f3 0 16384 -23 "/full/path/to/circularstring-128.matrix"
; Or generate matrix with GEN52 (if available):
f3 0 16384 -52 128 1 0 0 2 1    ; Auto-generate circular string
; Or create custom matrix
```

### Harsh, Unpleasant Timbre
**Problem:** Sound too bright or metallic
**Cause:** Scan trajectory emphasizes high partials, or stiffness too high
**Solution:**
```csound
; Use gentler scan trajectory:
f7 0 128 -7 1 128 128        ; Linear instead of exponential
; Reduce stiffness:
kstif = .05
; Add filtering:
a1 scans ampdb(p4), cpspch(p5), 7, 2
a1 tone a1, 2000    ; Low-pass filter
```

### CPU Overload
**Problem:** High CPU usage, audio dropouts
**Cause:** Update rate too fast (irate too small)
**Solution:**
```csound
; Increase update interval:
scanu 1, .02, 6, 2, 3, 4, 5, ...    ; Was .01, now .02 (slower updates)
; Or reduce number of masses (use 64 instead of 128)
; Or increase ksmps:
ksmps = 200    ; Was 100
```

---

## Sound Design Applications

### Evolving Ambient Pad

```csound
; Very slow evolution, high sustain
scanu 1, .02, 6, 2, 3, 4, 5, 5, .05, .05, -.005, .1, .5, 0, 0, a0, 0, 2
kfreq = cpspch(p5) * (1 + lfo(0.01, 0.1))    ; Slow pitch drift
a1 scans ampdb(p4-6), kfreq, 7, 2    ; Quieter (-6dB)
a1 reverb a1, 5    ; Long reverb
out a1
```

### Percussive Pluck

```csound
; Sharp attack, fast decay
f1 0 128 7 0 32 1 32 -1 64 0    ; Sharp triangular pluck
scanu 1, .005, 6, 2, 3, 4, 5, 1, .3, .2, .1, .1, .5, 0, 0, a0, 0, 2
a1 scans ampdb(p4), cpspch(p5)*2, 7, 2    ; Octave higher
out a1
```

### Metallic Resonance

```csound
; High stiffness, tight centering
scanu 1, .008, 6, 2, 3, 4, 5, 2, .8, .5, -.02, .1, .5, 0, 0, a0, 0, 2
; Bright scan trajectory
f7 0 128 -5 .001 128 128
```

### Bowed String Emulation

```csound
; Continuous excitation with noise
anoise rand .02
scanu 1, .01, 6, 2, 3, 4, 5, 2, .15, .08, -.015, .05, .5, 0, 0, anoise, 0, 2
a1 scans ampdb(p4), cpspch(p5), 7, 2
out a1
```

---

## Advanced Topics

### Understanding the Stiffness Matrix

The stiffness matrix is an N×N table (128×128 for 128 masses) where:
- Row i, Column j = spring stiffness connecting mass i to mass j
- Diagonal = self-connection (usually 0)
- Symmetric matrix (connection i→j = connection j→i)

**Circular string example (simplified for 8 masses):**
```
Mass:  0  1  2  3  4  5  6  7
  0 [  0  k  0  0  0  0  0  k ]    ; Mass 0 connects to 1 and 7
  1 [  k  0  k  0  0  0  0  0 ]    ; Mass 1 connects to 0 and 2
  2 [  0  k  0  k  0  0  0  0 ]    ; Mass 2 connects to 1 and 3
  ... etc ...
  7 [  k  0  0  0  0  0  k  0 ]    ; Mass 7 connects to 6 and 0
```

k = stiffness value (positive number)

**Different topologies change this matrix pattern completely.**

### Physics Simulation Internals

At each `irate` interval (.01 sec in example), `scanu` performs:

1. **Calculate forces on each mass:**
```
F[i] = Σ(stiffness[i,j] * (position[j] - position[i]))    ; Spring forces
     + centering[i] * (-position[i])                       ; Centering
     + damping[i] * (-velocity[i])                        ; Damping
```

2. **Update velocities (Euler integration):**
```
velocity[i] = velocity[i] + (F[i] / mass[i]) * dt
```

3. **Update positions:**
```
position[i] = position[i] + velocity[i] * dt
```

Where dt = `irate` (time step)

**More sophisticated integration (Verlet, Runge-Kutta) could be used for better stability.**

### Scanning as Wavetable Synthesis

The `scans` opcode essentially performs:

```
sample_rate = kfreq (scanning frequency)
phase_increment = kfreq / sr

For each audio sample:
  index = phase * 128    ; Which mass to read (with interpolation)
  output = position[index] from scanu simulation
  phase = phase + phase_increment
```

**Result:** The 128 mass positions become a 128-point wavetable, continuously updated by physics!

### Relationship to Other Synthesis

**vs. Waveguide:**
- Waveguide: Specific instrument models (string, pipe)
- Scanned: Arbitrary networks, novel timbres

**vs. Wavetable:**
- Wavetable: Static tables, scan at different rates
- Scanned: Dynamic "living" wavetable evolving via physics

**vs. Granular:**
- Granular: Microscopic time-domain manipulation
- Scanned: Macroscopic spatial-domain manipulation

**Unique strength:**
Scanned synthesis creates sounds that are:
- Physically coherent (obeying natural laws)
- Novel (not imitating real instruments)
- Dynamically evolving
- Parameter-sensitive in intuitive ways

---

## Matrix File Generation

### Using GEN52 (if available)

```csound
; Circular string
f3 0 16384 -52 128 1 0 0 2 1
;              N  conn. left right BC boundary

; Linear string
f3 0 16384 -52 128 1 1 1 0 1

; 2D membrane (square)
f3 0 16384 -52 128 2 0.5 0.5 2 1
;              N  dim X   Y   BC
```

### Manual Matrix Creation

For custom topologies, create your own matrix:

**Python example:**
```python
import numpy as np

N = 128  # Number of masses
matrix = np.zeros((N, N))

# Circular string: connect each mass to neighbors
for i in range(N):
    matrix[i, (i+1) % N] = 1.0    # Connect to next
    matrix[i, (i-1) % N] = 1.0    # Connect to previous

# Save to file (Csound -23 format)
matrix.flatten().tofile('my_custom.matrix')
```

---

## Related Examples

**Progression Path:**
1. **Current:** Basic scanned synthesis (circular string)
2. **Next:** 2D scanned synthesis (membrane)
3. **Then:** Custom topologies and networks
4. **Advanced:** Real-time haptic control (MIDI/gesture input)

**Related Techniques:**
- `Waveguide String Synthesis` - Related physical modeling
- `Modal Synthesis` - Another physics-based approach
- `Granular Scanning` - Combining granular with scanned
- `Karplus-Strong` - Simpler string synthesis

**Related Opcodes:**
- `scanu` - Scanner update (physics simulation)
- `scans` - Scanner read (audio generation)
- `xscanu` / `xscans` - Extended versions with more parameters
- `wguide1` / `wguide2` - Waveguide synthesis (related)

---

## Performance Notes

- **CPU Usage:** Moderate to high depending on update rate and number of masses
- **Polyphony:** 10-20 simultaneous instances typical
- **Real-time Safe:** Yes, with appropriate `irate`
- **Latency:** Determined by ksmps
- **Memory:** Moderate (stiffness matrix can be large)
- **Initialization Time:** Slight delay loading matrix files

**Optimization Tips:**
- Increase `irate` (.02 instead of .01) for efficiency
- Use fewer masses (64 instead of 128)
- Share same `id` across multiple instruments to reuse same simulation
- Preload matrix files at score time

---

## Historical Context

**Inventors:**
- Bill Verplank (Interval Research)
- Max Mathews (Bell Labs legend)
- Rob Shaw (physicist)

**Development (mid-1990s):**
Created at Interval Research Corporation as part of "haptic synthesis" research - originally intended for force-feedback devices where users could "feel" and sculpt vibrating surfaces.

**Musical adoption:**
Composers and sound designers discovered the sonic potential:
- Creates timbres impossible with traditional methods
- Natural evolution and organic character
- Parametrically controllable yet unpredictable

**Csound implementation:**
Paris Smaragdis ported to Csound (scanu/scans opcodes), making it accessible to the computer music community.

**Impact:**
Demonstrated that novel synthesis methods could emerge from interdisciplinary research (haptics + music + physics).

---

## Extended Documentation

**Official Csound Opcode References:**
- [scanu](https://csound.com/docs/manual/scanu.html)
- [scans](https://csound.com/docs/manual/scans.html)
- [xscanu](https://csound.com/docs/manual/xscanu.html)
- [GEN23](https://csound.com/docs/manual/GEN23.html) - Matrix file loading
- [GEN52](https://csound.com/docs/manual/GEN52.html) - Matrix generation (if available)

**Academic Papers:**
- Verplank, Mathews, Shaw: "Scanned Synthesis" (ICMC 2000)
- Paris Smaragdis: "Scanned Synthesis in Csound"

**Learning Resources:**
- Csound FLOSS Manual: Chapter 4.12 (Scanned Synthesis)
- The Csound Book: "New Concepts" section
- Csound examples/scanned_synthesis/ directory (matrix files)

**Matrix File Collections:**
Many Csound distributions include pre-made matrix files:
- circularstring-128.matrix
- membrane-128.matrix
- torus-128.matrix
- And more exotic topologies

**Philosophy:**
Scanned synthesis embodies a key computer music principle: *sound as emergent behavior of simpler rules* rather than direct specification. You design the physics, discover the sound.
