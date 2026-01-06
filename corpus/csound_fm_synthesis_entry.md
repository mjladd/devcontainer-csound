# Csound FM Synthesis and DX7 Algorithms

## Metadata
- **Category**: Synthesis / FM
- **Difficulty**: Intermediate to Advanced
- **Tags**: FM synthesis, frequency modulation, DX7, operators, algorithms, carriers, modulators, feedback
- **Opcodes**: `foscil`, `oscili`, `phasor`, `tablei`, `linseg`

## Description

Frequency Modulation (FM) synthesis creates complex timbres by modulating the frequency of one oscillator (carrier) with another oscillator (modulator). The Yamaha DX7 popularized FM synthesis with its 6-operator architecture and 32 different algorithms (routing configurations).

Key FM concepts:
- **Carrier**: The oscillator we hear directly
- **Modulator**: The oscillator that modulates the carrier's frequency
- **Algorithm**: How operators are connected (series, parallel, or combinations)
- **Operator**: A single oscillator with its own envelope
- **Modulation Index**: Controls brightness/complexity of the sound
- **Feedback**: An operator modulating itself

## Example 1: Basic Two-Operator FM

The simplest FM configuration: one modulator controlling one carrier.

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
; Basic 2-operator FM using foscil
; foscil is Csound's built-in FM oscillator
;---------------------------------------------------------------------------
instr 1
    iamp      = p4
    ifreq     = cpspch(p5)
    icar      = p6          ; Carrier ratio (e.g., 1 = fundamental)
    imod      = p7          ; Modulator ratio
    iindex    = p8          ; Modulation index (brightness)

    ; Envelope for amplitude
    kenv      linen     iamp, 0.01, p3, 0.1

    ; Envelope for index (brightness) - typical FM trick
    kindex    linseg    iindex, p3*0.3, iindex*0.5, p3*0.7, iindex*0.2

    ; foscil: amp, freq, carrier_ratio, mod_ratio, index, table
    asig      foscil    kenv, ifreq, icar, imod, kindex, 1

    outs      asig, asig
endin

;---------------------------------------------------------------------------
; Manual 2-operator FM using oscillators
; Shows the underlying math
;---------------------------------------------------------------------------
instr 2
    iamp      = p4
    ifreq     = cpspch(p5)
    icar      = p6
    imod      = p7
    iindex    = p8

    kenv      linen     iamp, 0.01, p3, 0.1
    kindex    linseg    iindex, p3*0.3, iindex*0.5, p3*0.7, iindex*0.2

    ; Modulator frequency
    imod_freq = ifreq * imod

    ; Modulator oscillator
    ; Modulation depth = index * modulator_frequency
    amod      oscili    kindex * imod_freq, imod_freq, 1

    ; Carrier frequency = base_freq * ratio + modulation
    ; The modulator output adds to the carrier frequency
    icar_freq = ifreq * icar
    acar      oscili    kenv, icar_freq + amod, 1

    outs      acar, acar
endin

</CsInstruments>
<CsScore>
; Sine wave table
f1 0 16384 10 1

; Using foscil (built-in FM)
;     start  dur  amp   pitch  car  mod  index
i1    0      1    0.4   8.00   1    1    3       ; C:M = 1:1, warm
i1    1.5    1    0.4   8.00   1    2    5       ; C:M = 1:2, brighter
i1    3      1    0.4   8.00   1    3    4       ; C:M = 1:3, hollow
i1    4.5    1    0.4   8.00   1    1.414 6     ; C:M = 1:sqrt(2), bell-like
s

; Using manual FM (same ratios)
i2    0      1    0.4   8.00   1    1    3
i2    1.5    1    0.4   8.00   1    2    5
i2    3      1    0.4   8.00   1    3    4
i2    4.5    1    0.4   8.00   1    1.414 6

</CsScore>
</CsoundSynthesizer>
```

### Explanation

**FM Formula:**
```
output = sin(carrier_freq * t + index * sin(modulator_freq * t))
```

**Carrier:Modulator Ratios:**
| Ratio | Character |
|-------|-----------|
| 1:1 | Warm, all harmonics |
| 1:2 | Bright, odd+even harmonics |
| 1:3 | Hollow, clarinet-like |
| 1:4 | Bright, complex |
| 1:1.414 | Inharmonic, bell-like |

**Modulation Index:**
- Low (0-2): Subtle brightness, few sidebands
- Medium (3-5): Rich harmonic content
- High (6+): Aggressive, metallic

**foscil Opcode:**
```csound
aout  foscil  kamp, kcps, kcar, kmod, kndx, ifn [, iphs]
```
- `kamp`: Amplitude
- `kcps`: Base frequency
- `kcar`: Carrier ratio
- `kmod`: Modulator ratio
- `kndx`: Modulation index
- `ifn`: Function table (usually sine)

## Example 2: Three-Operator Stack (DX7 Algorithm Style)

A stack of three operators where each modulates the next.

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
; 3-operator stack: Op3 -> Op2 -> Op1 (carrier)
; Similar to DX7 algorithms with serial modulation
;---------------------------------------------------------------------------
instr 1
    iamp      = p4
    ifreq     = cpspch(p5)

    ; Operator ratios
    irat1     = 1           ; Carrier (we hear this)
    irat2     = 2           ; Modulator for op1
    irat3     = 3           ; Modulator for op2

    ; Operator levels (modulation depth)
    ilvl1     = 1           ; Carrier amplitude
    ilvl2     = 3           ; Mod depth for op2->op1
    ilvl3     = 2           ; Mod depth for op3->op2

    ; Individual envelopes for each operator
    ; Carrier envelope (what we hear)
    kenv1     linen     iamp * ilvl1, 0.01, p3, 0.2

    ; Modulator envelopes (affect timbre)
    ; Faster decay on modulators = brightness fades
    kenv2     expseg    ilvl2, p3*0.1, ilvl2, p3*0.3, ilvl2*0.5, p3*0.6, 0.01
    kenv3     expseg    ilvl3, p3*0.05, ilvl3*0.3, p3*0.95, 0.01

    ; Calculate frequencies
    ifreq1    = ifreq * irat1
    ifreq2    = ifreq * irat2
    ifreq3    = ifreq * irat3

    ; Op3: Top of stack (no modulation input)
    aop3      oscili    kenv3 * ifreq3, ifreq3, 1

    ; Op2: Modulated by Op3
    aop2      oscili    kenv2 * ifreq2, ifreq2 + aop3, 1

    ; Op1: Carrier, modulated by Op2
    aop1      oscili    kenv1, ifreq1 + aop2, 1

    outs      aop1, aop1
endin

;---------------------------------------------------------------------------
; Phase modulation version (more accurate to DX7)
; DX7 uses phase modulation, not frequency modulation
;---------------------------------------------------------------------------
instr 2
    iamp      = p4
    ifreq     = cpspch(p5)

    irat1     = 1
    irat2     = 2
    irat3     = 4

    ilvl1     = 1
    ilvl2     = 0.4         ; Phase mod depth (radians/2pi)
    ilvl3     = 0.3

    kenv1     linen     iamp * ilvl1, 0.01, p3, 0.2
    kenv2     expseg    ilvl2, p3*0.1, ilvl2, p3*0.3, ilvl2*0.5, p3*0.6, 0.01
    kenv3     expseg    ilvl3, p3*0.05, ilvl3*0.3, p3*0.95, 0.01

    ; Phase modulation using phasor + tablei
    ; Op3
    aph3      phasor    ifreq * irat3
    aop3      tablei    aph3, 1, 1, 0, 1
    aop3      = aop3 * kenv3

    ; Op2: phase offset by op3
    aph2      phasor    ifreq * irat2
    aop2      tablei    aph2 + aop3, 1, 1, 0, 1
    aop2      = aop2 * kenv2

    ; Op1 (carrier): phase offset by op2
    aph1      phasor    ifreq * irat1
    aop1      tablei    aph1 + aop2, 1, 1, 0, 1
    aop1      = aop1 * kenv1

    outs      aop1, aop1
endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1

; Frequency modulation approach
;     start  dur  amp   pitch
i1    0      1    0.5   8.00
i1    1.2    1    0.5   8.04
i1    2.4    1    0.5   8.07
i1    3.6    2    0.5   9.00
s

; Phase modulation approach
i2    0      1    0.5   8.00
i2    1.2    1    0.5   8.04
i2    2.4    1    0.5   8.07
i2    3.6    2    0.5   9.00

</CsScore>
</CsoundSynthesizer>
```

### Explanation

**Stack Topology:**
```
  Op3 (modulator)
   |
  Op2 (modulator)
   |
  Op1 (carrier) --> OUTPUT
```

**FM vs Phase Modulation:**
The DX7 actually uses phase modulation, not frequency modulation. The difference is subtle but audible:
- **FM**: Modulator output adds to carrier frequency
- **PM**: Modulator output offsets carrier phase

Phase modulation using phasor + tablei:
```csound
aph1   phasor   ifreq              ; Phase accumulator 0-1
aop1   tablei   aph1 + amod, 1, 1, 0, 1  ; Phase offset by modulator
```

## Example 3: DX7 Algorithm 5 (Three Parallel Stacks)

Algorithm 5 has three independent carrier stacks, creating rich, organ-like tones.

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
; DX7 Algorithm 5:
;     2   4   6]      (] = feedback)
;     |   |   |
;     1   3   5       (1, 3, 5 are carriers)
;
; Three parallel 2-op stacks, feedback on op6
;---------------------------------------------------------------------------
instr 1
    iamp      = p4
    ifreq     = cpspch(p5)
    ifeedback = p6          ; Feedback amount for op6

    ; Operator frequency ratios
    irat1     = 1           ; Carrier 1 (fundamental)
    irat2     = 1           ; Modulator for op1
    irat3     = 2           ; Carrier 2 (octave)
    irat4     = 6           ; Modulator for op3
    irat5     = 4           ; Carrier 3
    irat6     = 8           ; Modulator for op5 (with feedback)

    ; Operator levels
    ilvl1     = 1           ; Carrier 1 level
    ilvl2     = 2           ; Mod depth 2->1
    ilvl3     = 0.7         ; Carrier 2 level
    ilvl4     = 1.5         ; Mod depth 4->3
    ilvl5     = 0.5         ; Carrier 3 level
    ilvl6     = 2           ; Mod depth 6->5

    ; Envelopes - each operator has ADSR
    ; Carrier envelopes (amplitude)
    kenv1     linseg    0, 0.01, ilvl1, p3*0.3, ilvl1*0.8, p3*0.6, ilvl1*0.6, 0.09, 0
    kenv3     linseg    0, 0.02, ilvl3, p3*0.2, ilvl3*0.5, p3*0.7, ilvl3*0.3, 0.08, 0
    kenv5     linseg    0, 0.005, ilvl5, p3*0.1, ilvl5*0.2, p3*0.8, 0.01, 0.095, 0

    ; Modulator envelopes (timbre)
    kenv2     expseg    0.01, 0.01, ilvl2, p3*0.2, ilvl2*0.3, p3*0.79, 0.01
    kenv4     expseg    0.01, 0.005, ilvl4, p3*0.1, ilvl4*0.1, p3*0.895, 0.01
    kenv6     expseg    0.01, 0.01, ilvl6, p3*0.15, ilvl6*0.2, p3*0.84, 0.01

    ; Calculate frequencies
    ifreq1    = ifreq * irat1
    ifreq2    = ifreq * irat2
    ifreq3    = ifreq * irat3
    ifreq4    = ifreq * irat4
    ifreq5    = ifreq * irat5
    ifreq6    = ifreq * irat6

    ; Stack 1: Op2 -> Op1
    aop2      oscili    kenv2 * ifreq2, ifreq2, 1
    aph1      phasor    ifreq1
    aop1      tablei    aph1 + aop2, 1, 1, 0, 1
    aop1      = aop1 * kenv1

    ; Stack 2: Op4 -> Op3
    aop4      oscili    kenv4 * ifreq4, ifreq4, 1
    aph3      phasor    ifreq3
    aop3      tablei    aph3 + aop4, 1, 1, 0, 1
    aop3      = aop3 * kenv3

    ; Stack 3: Op6 (with feedback) -> Op5
    aop6      init      0
    aph6      phasor    ifreq6
    aop6      tablei    aph6 + aop6 * ifeedback * 0.1, 1, 1, 0, 1
    aop6      = aop6 * kenv6

    aph5      phasor    ifreq5
    aop5      tablei    aph5 + aop6, 1, 1, 0, 1
    aop5      = aop5 * kenv5

    ; Mix all three carriers
    aout      = (aop1 + aop3 + aop5) * iamp

    outs      aout, aout
endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1

; Bell-flute style patch
;     start  dur  amp   pitch  feedback
i1    0      1.5  0.4   8.00   0.3
i1    1.7    1.5  0.4   8.04   0.3
i1    3.4    1.5  0.4   8.07   0.3
i1    5.1    3    0.4   9.00   0.5

</CsScore>
</CsoundSynthesizer>
```

### Algorithm 5 Diagram
```
    [Op2]     [Op4]     [Op6]<--+
      |         |         |     |
    [Op1]     [Op3]     [Op5]   | (feedback)
      |         |         |     |
      +---------+---------+     |
              |                 |
           OUTPUT          -----+
```

## Example 4: Algorithm 32 (All Carriers)

Algorithm 32 uses all six operators as carriers - the most additive-like of DX7 algorithms.

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
; DX7 Algorithm 32:
;     1  2  3  4  5  6]     (all carriers, feedback on 6)
;
; Organ-like, additive synthesis character
;---------------------------------------------------------------------------
instr 1
    iamp      = p4
    ifreq     = cpspch(p5)
    ifeedback = p6

    ; Harmonic ratios (organ drawbar style)
    irat1     = 0.5         ; Sub-octave
    irat2     = 1           ; Fundamental
    irat3     = 2           ; Octave
    irat4     = 3           ; 12th
    irat5     = 4           ; 2 octaves
    irat6     = 6           ; Octave + 5th (with feedback)

    ; Operator levels (like drawbar settings)
    ilvl1     = 0.5
    ilvl2     = 1.0
    ilvl3     = 0.7
    ilvl4     = 0.4
    ilvl5     = 0.3
    ilvl6     = 0.2

    ; Shared envelope (organ-like)
    kenv      linseg    0, 0.005, 1, p3-0.105, 1, 0.1, 0

    ; Individual attack variations for realism
    kenv1     linseg    0, 0.008, ilvl1, 0.1, ilvl1*0.9, p3-0.208, ilvl1*0.9, 0.1, 0
    kenv2     linseg    0, 0.005, ilvl2, 0.1, ilvl2*0.95, p3-0.205, ilvl2*0.95, 0.1, 0
    kenv3     linseg    0, 0.004, ilvl3, 0.1, ilvl3*0.85, p3-0.204, ilvl3*0.85, 0.1, 0
    kenv4     linseg    0, 0.003, ilvl4, 0.1, ilvl4*0.8, p3-0.203, ilvl4*0.8, 0.1, 0
    kenv5     linseg    0, 0.002, ilvl5, 0.1, ilvl5*0.7, p3-0.202, ilvl5*0.7, 0.1, 0
    kenv6     linseg    0, 0.003, ilvl6, 0.1, ilvl6*0.6, p3-0.203, ilvl6*0.6, 0.1, 0

    ; All operators (op6 has feedback)
    aop1      oscili    kenv1, ifreq * irat1, 1
    aop2      oscili    kenv2, ifreq * irat2, 1
    aop3      oscili    kenv3, ifreq * irat3, 1
    aop4      oscili    kenv4, ifreq * irat4, 1
    aop5      oscili    kenv5, ifreq * irat5, 1

    ; Op6 with feedback
    aop6      init      0
    aph6      phasor    ifreq * irat6
    aop6      tablei    aph6 + aop6 * ifeedback * 0.6, 1, 1, 0, 1
    aop6      = aop6 * kenv6

    ; Sum all carriers
    aout      = (aop1 + aop2 + aop3 + aop4 + aop5 + aop6) * iamp

    outs      aout, aout
endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1

; Organ-like tones
;     start  dur  amp   pitch  feedback
i1    0      0.5  0.3   7.00   0
i1    0      0.5  0.3   8.00   0
i1    0      0.5  0.3   8.04   0

i1    1      0.5  0.3   7.05   0.3
i1    1      0.5  0.3   8.00   0.3
i1    1      0.5  0.3   8.05   0.3

i1    2      0.5  0.3   7.07   0.5
i1    2      0.5  0.3   8.02   0.5
i1    2      0.5  0.3   8.07   0.5

i1    3      2    0.25  7.00   0.7
i1    3      2    0.25  8.00   0.7
i1    3      2    0.25   8.04   0.7
i1    3      2    0.25  8.07   0.7

</CsScore>
</CsoundSynthesizer>
```

### Explanation

**Algorithm 32 - All Carriers:**
All six operators output directly (no modulation between them), creating additive-like synthesis. Feedback on op6 adds harmonic richness.

**Feedback:**
An operator modulating itself creates a sawtooth-like wave:
```csound
aop6    init      0                              ; Previous sample
aph6    phasor    ifreq6
aop6    tablei    aph6 + aop6 * ifeedback, 1, 1, 0, 1
```
- Low feedback: Sine wave
- Medium feedback: Adds harmonics
- High feedback: Approaches sawtooth

## Variations

### Electric Piano (Rhodes-like)
```csound
; Use inharmonic ratios and velocity-sensitive index
irat1   = 1
irat2   = 14        ; High inharmonic ratio for "tine" character

; Velocity controls brightness
kindex  = iveloc * 5  ; Harder = brighter

amod    oscili    kindex * ifreq * irat2, ifreq * irat2, 1
acar    oscili    kenv, ifreq + amod, 1
```

### Brass
```csound
; Use 1:1 ratio with dynamic index
irat1   = 1
irat2   = 1

; Slow attack, index follows amplitude
kenv    linseg    0, 0.1, 1, p3-0.2, 0.9, 0.1, 0
kindex  linseg    0.5, 0.15, 6, p3-0.25, 4, 0.1, 0.5

amod    oscili    kindex * ifreq, ifreq, 1
acar    oscili    kenv * iamp, ifreq + amod, 1
```

### Bell
```csound
; Inharmonic ratios, fast modulator decay
irat1   = 1
irat2   = 1.414     ; sqrt(2) = inharmonic

kenv1   expon     1, p3, 0.001     ; Slow carrier decay
kenv2   expon     1, p3*0.1, 0.001 ; Fast mod decay

amod    oscili    kenv2 * 5 * ifreq, ifreq * irat2, 1
acar    oscili    kenv1 * iamp, ifreq + amod, 1
```

## Common Issues and Solutions

### 1. Too Harsh/Bright
**Problem**: Sound is unpleasantly harsh
**Solution**:
- Reduce modulation index
- Use faster decay on modulator envelopes
- Filter the output: `aout butterlp aout, 5000`

### 2. Pitch Instability
**Problem**: Notes sound out of tune
**Solution**:
- Ensure modulator returns to zero during sustain
- Use phase modulation instead of FM for better stability
- Check that modulation depth isn't too extreme

### 3. Aliasing
**Problem**: High-frequency artifacts, especially at high pitches
**Solution**:
- Reduce modulation index at higher pitches:
  ```csound
  kindex = iindex * (1 - (ifreq - 200) / 4000)
  ```
- Use oversampling for extreme FM

### 4. Click at Note Start
**Problem**: Audible click at attack
**Solution**:
- Add short attack to all envelopes (even 1-2ms)
- Initialize feedback operators: `aop6 init 0`

### 5. Feedback Instability
**Problem**: Feedback causes runaway amplitude
**Solution**:
- Keep feedback coefficient under 1.0
- Scale feedback: `ifeedback / (2 * 3.14159)`
- Add soft limiting: `aop6 tanh aop6`

## Related Examples

- `dx701.csd` through `dx732.csd` - All 32 DX7 algorithms implemented
- `fmsynth.csd` - Cross-modulating FM with foscil
- `fmsimp1.csd` - Simple FM examples
- `fmfeed1a.csd`, `fmfeed1b.csd` - Feedback FM examples
- `altfm.csd` - Alternative FM techniques
