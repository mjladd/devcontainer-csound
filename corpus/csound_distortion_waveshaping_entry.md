# Csound Distortion and Waveshaping

## Metadata
- **Category**: Effects / Distortion
- **Difficulty**: Intermediate
- **Tags**: distortion, waveshaping, tube amp, overdrive, saturation, clipping, harmonics
- **Opcodes**: `table`, `tablei`, `tanh`, `limit`, `distort`, `clip`, `powershape`

## Description

Distortion and waveshaping are techniques for adding harmonic content to audio signals by applying nonlinear transfer functions. This ranges from subtle warmth (soft saturation) to aggressive guitar amp tones (hard clipping).

Key concepts:
- **Transfer function**: Maps input amplitude to output amplitude
- **Waveshaping**: Using a lookup table as a transfer function
- **Soft clipping**: Gradual compression at extremes (tube-like warmth)
- **Hard clipping**: Abrupt limiting (harsh, digital distortion)
- **Chebyshev polynomials**: Mathematical functions for generating specific harmonics

## Example 1: Basic Waveshaping with Transfer Functions

Waveshaping uses a table lookup where the input signal indexes into a transfer function table.

### Complete Code

```csound
<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr        = 44100
ksmps     = 32
nchnls    = 2
0dbfs     = 1

;---------------------------------------------------------------------------
; Basic waveshaping demonstration
; Shows different transfer function shapes
;---------------------------------------------------------------------------
instr 1
    idist     = p4          ; Distortion type (1-4)
    idrive    = p5          ; Input gain (drive)
    ifreq     = cpspch(p6)

    ; Generate input signal
    kenv      linen     0.8, 0.01, p3, 0.1
    ain       vco2      kenv, ifreq, 0

    ; Scale input for table lookup (-1 to +1 maps to table)
    ain       = ain * idrive

    ; Apply waveshaping (table number = idist + 1)
    ; tablei with normalized mode: signal -1 to +1 maps across table
    ; Offset 0.5 centers the lookup (middle of table = 0 input)
    aout      tablei    ain, idist + 1, 1, 0.5

    ; Output scaling
    aout      = aout * 0.5
    outs      aout, aout
endin

</CsInstruments>
<CsScore>
; Transfer function tables (all normalized -1 to +1 range)

; Table 2: Linear (no distortion) - reference
f2 0 8193 7 -1 8192 1

; Table 3: Soft clipping (tanh-like S curve)
; Gentle compression at extremes
f3 0 8193 8 -0.8 1000 -0.79 2000 -0.7 2096 0.7 2000 0.79 1000 0.8

; Table 4: Hard clipping
; Flat at extremes = harsh harmonics
f4 0 8193 7 -0.7 1000 -0.7 6193 0.7 1000 0.7

; Table 5: Asymmetric (tube-like)
; Different positive/negative behavior adds even harmonics
f5 0 8193 7 -0.6 1500 -0.58 1500 -0.4 1693 0.5 2000 0.75 1500 0.8

; Test each distortion type
;     start  dur  type  drive  pitch
i1    0      1.5  1     0.3    8.00    ; Linear (reference)
i1    2      1.5  2     0.8    8.00    ; Soft clip
i1    4      1.5  3     0.9    8.00    ; Hard clip
i1    6      1.5  4     0.7    8.00    ; Asymmetric/tube

</CsScore>
</CsoundSynthesizer>
```

### Explanation

**Transfer Function Concept:**
The transfer function table maps input amplitude to output amplitude:
- Table center (index 0.5) = zero input
- Table edges = maximum positive/negative input
- Table shape determines harmonic content

**GEN 7 vs GEN 8:**
- `GEN 7`: Line segments (sharp transitions = more harmonics)
- `GEN 8`: Cubic splines (smooth transitions = softer sound)

**Drive Parameter:**
Higher drive pushes the signal further into the nonlinear regions of the transfer function:
```csound
ain = ain * idrive    ; More drive = more distortion
```

## Example 2: Tube Amplifier Simulation

This example models tube amp characteristics: soft saturation, asymmetric clipping, and duty cycle shift.

### Complete Code

```csound
<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr        = 44100
ksmps     = 32
nchnls    = 2
0dbfs     = 1

ga_guitar init  0

;---------------------------------------------------------------------------
; Guitar input simulation (plucked string)
;---------------------------------------------------------------------------
instr 1
    iamp      = p4
    ifreq     = cpspch(p5)

    kenv      linseg    0, 0.002, iamp, p3-0.004, iamp*0.3, 0.002, 0
    asig      pluck     kenv, ifreq, ifreq, 0, 1

    ; Direct sound (small amount)
    outs      asig * 0.1, asig * 0.1

    ; Send to amp
    ga_guitar = ga_guitar + asig
endin

;---------------------------------------------------------------------------
; Tube Amplifier Model
;---------------------------------------------------------------------------
instr 10
    kamp      linseg    0, 0.002, 1, p3-0.004, 1, 0.002, 0

    ; Parameters
    igain_pre = p4          ; Preamp gain (drive)
    igain_post = p5         ; Output level
    iduty     = p6          ; Duty cycle shift (asymmetry)
    islope    = p7          ; Slew rate effect

    ; Previous sample for slew calculation
    asig_old  init      0

    ; Scale input signal
    asig      = igain_pre * ga_guitar

    ; Waveshaping through transfer function table
    ; Table 5 is the tube distortion curve
    aclip     tablei    asig * 0.5 + 0.5, 5, 1

    ; Scale output
    aclip     = aclip * igain_post

    ; Tube amps exhibit duty cycle shift and slew rate limiting
    ; This creates subtle pitch/timing modulation based on amplitude
    atemp     delayr    0.1
    ; Variable delay based on signal level and rate of change
    adeltime  = (1 - iduty * asig) / 3000 + (1 + islope * (asig - asig_old)) / 3000
    adel      deltapi   adeltime
              delayw    aclip

    ; Store for next sample
    asig_old  = asig

    ; Tone control (simple low-pass for speaker simulation)
    aout      butterlp  adel, 5000
    aout      butterhp  aout, 80

    outs      aout * kamp, aout * kamp

    ga_guitar = 0
endin

</CsInstruments>
<CsScore>
; Tube distortion transfer function
; Asymmetric S-curve with soft saturation
; Negative values clip earlier than positive (tube bias)
f5 0 8193 8 -0.8 400 -0.78 800 -0.7 2996 0.7 800 0.78 400 0.8

; Clean amp settings
;      start  dur   pre   post  duty  slope
i10    0      3     1     0.7   0     0

; Guitar notes (clean)
i1     0      0.5   0.4   7.00
i1     0.3    0.4   0.35  7.05
i1     0.6    0.3   0.3   8.00
i1     0.9    0.8   0.4   7.07
s

; Mild overdrive
i10    0      3     3     0.5   0.3   0.1

i1     0      0.5   0.5   7.00
i1     0.3    0.4   0.45  7.05
i1     0.6    0.3   0.4   8.00
i1     0.9    0.8   0.5   7.07
s

; Heavy distortion
i10    0      3     8     0.3   0.5   0.2

i1     0      0.5   0.6   6.00
i1     0.3    0.4   0.55  6.05
i1     0.6    0.3   0.5   7.00
i1     0.9    1.5   0.6   6.07

</CsScore>
</CsoundSynthesizer>
```

### Explanation

**Preamp Gain (Drive):**
The preamp stage amplifies the signal before the nonlinear stage. Higher gain means more of the signal enters the clipping region:
```csound
asig = igain_pre * ga_guitar   ; Drive into saturation
```

**Asymmetric Transfer Function:**
Real tubes clip asymmetrically due to their physics. This adds even harmonics (2nd, 4th, etc.) which sound "warmer":
```
f5 0 8193 8 -0.8 400 -0.78 800 -0.7 2996 0.7 800 0.78 400 0.8
         ^^^                              ^^^
         Negative clips at -0.8           Positive reaches 0.8
```

**Duty Cycle and Slew Rate:**
Tube amps exhibit amplitude-dependent timing shifts:
- **Duty cycle**: Positive and negative half-cycles have different durations
- **Slew rate**: Fast transients are softened

```csound
adeltime = (1 - iduty * asig) / 3000 + (1 + islope * (asig - asig_old)) / 3000
```

## Example 3: Chebyshev Polynomial Waveshaping

Chebyshev polynomials generate specific harmonics when applied to a sine wave. This provides precise control over the harmonic spectrum.

### Complete Code

```csound
<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr        = 44100
ksmps     = 32
nchnls    = 2
0dbfs     = 1

;---------------------------------------------------------------------------
; Chebyshev waveshaping for harmonic generation
;---------------------------------------------------------------------------
instr 1
    iamp      = p4
    ifreq     = cpspch(p5)
    itable    = p6          ; Which Chebyshev table

    ; Pure sine wave input (important for Chebyshev!)
    kenv      linen     iamp, 0.05, p3, 0.2
    ain       oscil     kenv, ifreq, 1

    ; Waveshaping with Chebyshev polynomial
    ; Input must be -1 to +1 for correct harmonic generation
    aout      tablei    ain, itable, 1, 0.5

    ; Filter to tame any harshness
    aout      butterlp  aout, 8000

    outs      aout, aout
endin

;---------------------------------------------------------------------------
; Dynamic waveshaping - morph between transfer functions
;---------------------------------------------------------------------------
instr 2
    iamp      = p4
    ifreq     = cpspch(p5)

    ; Envelope controls waveshaping intensity
    kindex    linseg    0, p3*0.3, 0.8, p3*0.4, 0.3, p3*0.3, 0
    kenv      linen     iamp, 0.02, p3, 0.1

    ; Sine wave input
    ain       oscil     1, ifreq, 1

    ; Crossfade between tables based on envelope
    ; Table 10 = mild, Table 11 = aggressive
    aout1     tablei    ain * kindex, 10, 1, 0.5
    aout2     tablei    ain * kindex, 11, 1, 0.5

    ; Morph based on amplitude
    kmorph    = kindex      ; More drive = more harmonics
    aout      = aout1 * (1-kmorph) + aout2 * kmorph

    aout      = aout * kenv
    outs      aout, aout
endin

;---------------------------------------------------------------------------
; Moving waveshaper - scan through table
;---------------------------------------------------------------------------
instr 3
    iamp      = p4
    ifreq     = cpspch(p5)

    kenv      linen     iamp, 0.01, p3, 0.3

    ; Oscillator provides waveshaping index
    kindex    linseg    0, 0.01, 256, p3*0.35, 512, p3*0.3, 1024, p3*0.34, 1536

    ain       oscil     kenv, ifreq, 1

    ; Read from extended table, offset moves through different regions
    aout      tablei    ain * 256 + 256 + kindex, 12, 0, 0, 1

    aout      butterlp  aout * 15, 6000
    outs      aout, aout
endin

</CsInstruments>
<CsScore>
; Pure sine wave
f1 0 4096 10 1

; Chebyshev tables using GEN 13 (Chebyshev type 1)
; GEN 13 args: 1, 1, then harmonic weights
; Each weight adds that harmonic when sine is input

; Table 5: Adds 2nd and 3rd harmonics
; Syntax: f# time size 13 1 1 h1 h2 h3 h4 ...
f5 0 8193 13 1 1 0 1 0.5 0.3

; Table 6: Odd harmonics only (clarinet-like)
f6 0 8193 13 1 1 1 0 0.3 0 0.1

; Table 7: Strong 2nd harmonic (warm, even)
f7 0 8193 13 1 1 0 1 0 0

; Table 8: Complex - many harmonics
f8 0 8193 13 1 1 0 5 -2 -3 0 8 -9 0 2 0 -3 0 2

; Tables for morphing (GEN 3 - polynomial)
; f# time size 3 xmin xmax c0 c1 c2 c3...
f10 0 513 3 -1 1 0 1 0           ; Linear + 2nd harmonic
f11 0 513 3 -1 1 0 0 3 0 -10.5 0 6   ; Complex polynomial

; Extended table for scanning (4 regions)
f12 0 2049 3 -1 1 0 1 0 0 3 0 -10.5 0 6

; Test Chebyshev tables
;     start  dur  amp   pitch  table
i1    0      1.5  0.5   8.00   5      ; 2nd + 3rd harmonics
i1    2      1.5  0.5   8.00   6      ; Odd harmonics
i1    4      1.5  0.5   8.00   7      ; 2nd harmonic only
i1    6      1.5  0.5   8.00   8      ; Complex
s

; Dynamic waveshaping
i2    0      3    0.5   7.00
s

; Scanning waveshaper
i3    0      3    0.3   8.00

</CsScore>
</CsoundSynthesizer>
```

### Explanation

**GEN 13 (Chebyshev Type 1):**
Creates a transfer function from Chebyshev polynomial coefficients:
```
f5 0 8193 13 1 1 0 1 0.5 0.3
              | | | |   |   |
              | | | |   |   +-- 4th harmonic weight
              | | | |   +------ 3rd harmonic weight
              | | | +---------- 2nd harmonic weight
              | | +------------ 1st harmonic weight (fundamental)
              | +-------------- xint (usually 1)
              +---------------- xamp (usually 1)
```

When a sine wave passes through this table:
- Weight 0 for fundamental means fundamental passes unchanged
- Weight 1 for 2nd means 2nd harmonic is added at full strength
- Weight 0.5 for 3rd means 3rd harmonic at half strength

**GEN 3 (Polynomial):**
Creates transfer function from polynomial coefficients:
```
f10 0 513 3 -1 1 0 1 0
            |  | | | |
            |  | | | +-- x^2 coefficient
            |  | | +---- x^1 coefficient
            |  | +------ x^0 coefficient (constant)
            |  +-------- xmax
            +---------- xmin
```

**Dynamic Waveshaping:**
Modulating the input amplitude changes how much of the transfer function is used:
```csound
ain * kindex    ; kindex controls distortion amount
```

## Example 4: Built-in Distortion Opcodes

Csound provides several built-in opcodes for common distortion effects.

### Complete Code

```csound
<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr        = 44100
ksmps     = 32
nchnls    = 2
0dbfs     = 1

;---------------------------------------------------------------------------
; Using built-in distortion opcodes
;---------------------------------------------------------------------------

; tanh saturation (smooth, symmetric)
instr 1
    iamp      = p4
    idrive    = p5
    ifreq     = cpspch(p6)

    kenv      linen     iamp, 0.01, p3, 0.1
    ain       vco2      kenv, ifreq, 0

    ; tanh provides natural soft clipping
    ; Drive controls how hard we hit the saturation
    aout      tanh      ain * idrive
    aout      = aout / idrive   ; Compensate for level increase

    outs      aout, aout
endin

; clip opcode (various clipping methods)
instr 2
    iamp      = p4
    imethod   = p5          ; 0=bram, 1=sine, 2=tanh
    ifreq     = cpspch(p6)

    kenv      linen     iamp, 0.01, p3, 0.1
    ain       vco2      kenv * 2, ifreq, 0   ; Overdrive input

    ; clip opcode with different methods
    ; Args: asig, imethod, ilimit, iarg (method-specific)
    aout      clip      ain, imethod, 0.8

    outs      aout * 0.7, aout * 0.7
endin

; distort opcode (table-based with pregain)
instr 3
    iamp      = p4
    idist     = p5          ; Distortion amount 0-1
    ifreq     = cpspch(p6)

    kenv      linen     iamp, 0.01, p3, 0.1
    ain       vco2      kenv, ifreq, 0

    ; distort opcode uses sigmoid function
    ; kdist: 0 = clean, approaching 1 = heavy distortion
    aout      distort   ain, idist, 1    ; ifn=1 (sigmoid table)

    outs      aout, aout
endin

; powershape opcode (attempt power-based shaping)
instr 4
    iamp      = p4
    ishape    = p5          ; Shape amount (>1 = expansion, <1 = compression)
    ifreq     = cpspch(p6)

    kenv      linen     iamp, 0.01, p3, 0.1
    ain       vco2      kenv, ifreq, 0

    ; powershape raises signal to a power
    ; Values > 1 add odd harmonics (compression-like)
    ; Values < 1 add even harmonics (expansion-like)
    aout      powershape  ain, ishape

    outs      aout, aout
endin

; limit opcode (hard clipping)
instr 5
    iamp      = p4
    ilimit    = p5          ; Clipping threshold
    ifreq     = cpspch(p6)

    kenv      linen     iamp, 0.01, p3, 0.1
    ain       vco2      kenv, ifreq, 0

    ; Hard limit - creates lots of odd harmonics
    aout      limit     ain, -ilimit, ilimit

    ; Filter to reduce harshness
    aout      butterlp  aout, 4000

    outs      aout * 0.8, aout * 0.8
endin

</CsInstruments>
<CsScore>
; Sigmoid table for distort opcode
f1 0 8193 19 0.5 0.5 270 0.5

; tanh saturation (drives 1, 3, 8)
;     start  dur  amp   drive  pitch
i1    0      1    0.4   1      8.00    ; Clean
i1    1.2    1    0.4   3      8.00    ; Mild saturation
i1    2.4    1    0.4   8      8.00    ; Heavy saturation
s

; clip methods
;     start  dur  amp   method pitch
i2    0      1    0.4   0      8.00    ; Bram de Jong
i2    1.2    1    0.4   1      8.00    ; Sine
i2    2.4    1    0.4   2      8.00    ; tanh
s

; distort opcode
;     start  dur  amp   dist   pitch
i3    0      1    0.4   0.1    8.00    ; Light
i3    1.2    1    0.4   0.5    8.00    ; Medium
i3    2.4    1    0.4   0.9    8.00    ; Heavy
s

; powershape
;     start  dur  amp   shape  pitch
i4    0      1    0.4   0.5    8.00    ; Softer
i4    1.2    1    0.4   1.5    8.00    ; Expansion
i4    2.4    1    0.4   3.0    8.00    ; Strong expansion
s

; Hard limiting
;     start  dur  amp   limit  pitch
i5    0      1    0.5   0.8    8.00    ; Mild
i5    1.2    1    0.5   0.4    8.00    ; Medium
i5    2.4    1    0.5   0.2    8.00    ; Extreme

</CsScore>
</CsoundSynthesizer>
```

### Built-in Opcode Summary

| Opcode | Type | Character | Use Case |
|--------|------|-----------|----------|
| `tanh` | Soft clip | Warm, symmetric | Tube warmth, general saturation |
| `clip` | Configurable | Variable | General purpose, multiple algorithms |
| `distort` | Table-based | Smooth | When you want control via table |
| `powershape` | Power curve | Adds harmonics | Subtle coloration |
| `limit` | Hard clip | Harsh, digital | Extreme distortion, lo-fi |

## Variations

### Multiband Distortion
Apply different distortion to different frequency bands:

```csound
; Split into bands
alow      butterlp  ain, 300
amid      butterbp  ain, 1000, 700
ahigh     butterhp  ain, 2000

; Distort each differently
alow_d    tanh      alow * 2
amid_d    tanh      amid * 4       ; More drive on mids
ahigh_d   tanh      ahigh * 1.5

; Recombine
aout      = alow_d + amid_d + ahigh_d
```

### Cabinet Simulation
Real amp distortion includes speaker cabinet filtering:

```csound
; After distortion, simulate speaker cabinet
aout      pareq     adist, 120, 2, 0.7, 1     ; Bass boost
aout      butterlp  aout, 5000                 ; Speaker rolloff
aout      pareq     aout, 3000, 0.7, 1, 2     ; Presence cut
```

### Rectification (Octave Effect)
Full-wave rectification doubles the frequency:

```csound
; Full-wave rectifier
aout = abs(ain)

; Half-wave rectifier (fuzz-like)
aout = (ain + abs(ain)) / 2
```

## Common Issues and Solutions

### 1. Output Too Loud
**Problem**: Distortion increases perceived loudness
**Solution**:
```csound
; Compensate for drive
aout = tanh(ain * idrive) / idrive

; Or use automatic gain compensation
aout = tanh(ain * idrive)
krms rms aout
aout = aout / (krms + 0.001)  ; Normalize
```

### 2. Too Harsh/Fizzy
**Problem**: Excessive high frequencies
**Solution**:
```csound
; Filter before and/or after distortion
ain   butterlp  ain, 4000     ; Pre-filter
aout  tanh      ain * idrive
aout  butterlp  aout, 5000    ; Post-filter (cabinet sim)
```

### 3. DC Offset
**Problem**: Signal drifts from zero (especially asymmetric distortion)
**Solution**:
```csound
; Always include DC blocking
aout  butterhp  aout, 20
```

### 4. Aliasing
**Problem**: Digital artifacts at high frequencies
**Solution**:
- Use oversampling for extreme distortion
- Filter before distortion to remove content above sr/4
- Use smoother transfer functions (GEN 8 instead of GEN 7)

### 5. Loss of Dynamics
**Problem**: Distortion compresses dynamic range
**Solution**:
```csound
; Blend dry and wet for dynamics
aout = ain * (1-idry) + tanh(ain * idrive) * idry
```

## Related Examples

- `dist.csd` - Basic waveshaping with table lookup
- `distortion.csd` - Tube amp model with duty cycle
- `tubedistort.csd` - Alternative tube amp implementation
- `Waveshap.csd` - Chebyshev polynomial waveshaping (MIDI)
