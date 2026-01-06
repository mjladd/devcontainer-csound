# Csound Karplus-Strong / Plucked String Synthesis

## Overview

Karplus-Strong synthesis is a physical modeling technique that simulates plucked string sounds using a short burst of noise fed through a filtered delay line. The delay line length determines pitch, while filtering simulates energy loss as the string vibrates. Csound provides both built-in opcodes (`pluck`, `wgpluck2`, `repluck`) and the building blocks for manual implementations.

## Core Concepts

### The Karplus-Strong Algorithm
1. Fill a delay buffer with noise (or an excitation signal)
2. Read the delayed output and filter it (typically lowpass)
3. Feed the filtered output back into the delay line
4. The delay line length = sr / frequency

### Key Opcodes
- **pluck**: Simple built-in Karplus-Strong with various smoothing methods
- **wgpluck2**: Physical model of plucked string using waveguides
- **repluck**: Plucked string with external excitation signal
- **delayr/delayw**: Building blocks for manual implementations
- **filter2**: General-purpose filter for decay shaping

## Example Instruments

### Example 1: Basic pluck Opcode
The simplest approach using Csound's built-in pluck opcode.

```csound
<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

; Basic pluck opcode demonstration
instr 1
    iamp = p4
    icps = cpspch(p5)

    ; pluck args: amp, cps, buffer_size, init_table, smoothing_method
    ; Method 1 = simple averaging (original K-S)
    ; Method 2 = stretched averaging
    ; Method 3 = simple drum (adds random sign flipping)
    ; Method 4 = stretched drum
    ; Method 5 = weighted averaging (settable with two optional params)
    ; Method 6 = recursive filter (1st-order IIR)

    asig pluck iamp, icps, icps, 0, 1

    ; Envelope to prevent clicks
    aenv linseg 1, p3-0.05, 1, 0.05, 0

    outs asig*aenv, asig*aenv
endin

; Pluck with different smoothing methods
instr 2
    iamp = p4
    icps = cpspch(p5)
    imethod = p6

    asig pluck iamp, icps, icps, 0, imethod
    aenv linseg 1, p3-0.05, 1, 0.05, 0

    outs asig*aenv, asig*aenv
endin

</CsInstruments>
<CsScore>
; Basic pluck
i1 0 2 0.7 8.00
i1 + . .   8.04
i1 + . .   8.07
i1 + . .   9.00

; Compare smoothing methods
;        amp  pitch method
i2 8  2  0.7  8.00  1    ; simple averaging
i2 10 2  0.7  8.00  2    ; stretched averaging
i2 12 2  0.7  8.00  5    ; weighted averaging
i2 14 2  0.7  8.00  6    ; recursive filter
e
</CsScore>
</CsoundSynthesizer>
```

### Example 2: Manual Karplus-Strong Implementation
Low-level implementation using delay lines, demonstrating the algorithm fundamentals.

```csound
<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 1          ; kr = sr required for sample-accurate delays
nchnls = 2
0dbfs = 1

; Manual Karplus-Strong implementation
; Based on classic algorithm from Dodge
instr 1
    iamp = p4
    icps = p5

    ; Delay time = 1/frequency
    idlt = 1/icps

    ; Initialize output feedback
    aoutput init 0

    ; Generate noise burst at start
    ; Using timout to gate the noise
    timout 0, idlt, noise_burst
    goto continue

noise_burst:
    anoise rand iamp

continue:
    ; Delay line
    adel delayr idlt

    ; Mix delayed signal with noise (noise only during init)
    asig = anoise + adel

    ; Lowpass filter simulates energy loss (averaging filter)
    ; Simple 2-point average: y(n) = 0.5*x(n) + 0.5*x(n-1)
    afilt tone asig, sr/4

    ; Write filtered signal back to delay line
    delayw afilt

    ; Output
    aenv linseg 1, p3-0.1, 1, 0.1, 0
    outs afilt*aenv, afilt*aenv

    ; Clear noise after initial burst
    anoise = 0
endin

; More sophisticated manual implementation with pluck position
instr 2
    iamp = p4
    icps = cpspch(p5)
    ipluck = p6              ; pluck position (0-1)

    ; Delay length in samples and seconds
    idlts = int(sr/icps - 0.5)
    idlt = idlts/sr

    ; Fractional delay compensation using allpass
    irems = sr/icps - idlts + 0.5
    iph = (1-irems)/(1+irems)

    ; Counter for initialization
    kdlt init idlts

    ; Initialize signals
    awgout init 0
    anoize init 0

    if kdlt < 0 goto continue

    ; Initial noise burst
    anoise trirand iamp
    anoise butterlp anoise, 5000, 1

    ; Pluck position as FIR comb filter
    acomb delay anoise, ipluck*idlt
    anoize = anoise - acomb

continue:
    ; Waveguide delay line
    areturn delayr idlt
    ainput = anoize + areturn

    ; Lowpass filter for energy loss
    alpf filter2 ainput, 2, 0, 0.5, 0.5

    ; Allpass filter for fine tuning
    awgout filter2 alpf, 2, 1, iph, 1, iph

    delayw awgout

    aenv linseg 1, p3-0.1, 1, 0.1, 0
    outs awgout*aenv, awgout*aenv

    ; Decrement counter and clear noise
    kdlt = kdlt - 1
    anoize = 0
endin

</CsInstruments>
<CsScore>
; Basic manual K-S
i1 0 3 0.5 220
i1 + . .   330
i1 + . .   440

; With pluck position control
;        amp  pitch  pluck_pos
i2 9  3  0.5  8.00   0.1    ; near bridge (brighter)
i2 12 3  0.5  8.00   0.5    ; middle (fuller)
i2 15 3  0.5  8.00   0.9    ; near nut (darker)
e
</CsScore>
</CsoundSynthesizer>
```

### Example 3: wgpluck2 Physical Model
Using Csound's waveguide-based plucked string physical model.

```csound
<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

; wgpluck2 physical model demonstration
instr 1
    iamp = p4
    icps = cpspch(p5)
    iplk = p6        ; pluck position (0-1)
    ipick = p7       ; pick-up position (0-1)
    irefl = p8       ; reflection coefficient (0-1, affects brightness)

    ; wgpluck2 args: pluck_pos, amp, cps, pick_pos, refl_coeff
    asig wgpluck2 iplk, iamp, icps, ipick, irefl

    outs asig, asig
endin

; Exploring different timbres
instr 2
    iamp = p4
    icps = cpspch(p5)

    ; Three strings with slightly different parameters for richness
    a1 wgpluck2 0.1, iamp*0.5, icps*0.999, 0.1, 0.95
    a2 wgpluck2 0.2, iamp*0.5, icps,       0.2, 0.93
    a3 wgpluck2 0.15, iamp*0.5, icps*1.001, 0.15, 0.94

    amix = a1 + a2 + a3

    outs amix, amix
endin

</CsInstruments>
<CsScore>
; Basic wgpluck2
;        amp  pitch plk  pick refl
i1 0 3   0.6  8.00  0.1  0.1  0.95
i1 + .   .    8.04  .    .    .
i1 + .   .    8.07  .    .    .
i1 + .   .    9.00  .    .    .

; Vary reflection (brightness)
i1 12 3  0.6  8.00  0.2  0.2  0.99   ; very bright, long sustain
i1 15 3  0.6  8.00  0.2  0.2  0.90   ; medium
i1 18 3  0.6  8.00  0.2  0.2  0.80   ; dark, quick decay

; Chorused strings
i2 21 4  0.5  7.00
i2 25 4  0.5  7.07
i2 29 4  0.5  8.00
e
</CsScore>
</CsoundSynthesizer>
```

### Example 4: repluck with External Excitation
Using audio input to excite the string model - creates unique hybrid timbres.

```csound
<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

; repluck - plucked string excited by external audio
instr 1
    iamp = p4
    icps = cpspch(p5)
    iplk = p6        ; pluck position
    ipick = p7       ; pick position
    irefl = p8       ; reflection coefficient

    ; Use noise burst as excitation
    kenv linseg 1, 0.02, 0, 1, 0
    aexcite rand iamp * kenv

    ; repluck: plk, amp, cps, pick, refl, excite_signal
    asig repluck iplk, iamp, icps, ipick, irefl, aexcite

    outs asig, asig
endin

; Using oscillator as excitation
instr 2
    iamp = p4
    icps = cpspch(p5)

    ; Excite with brief pitched impulse
    kenv linseg 1, 0.01, 0, 1, 0
    aexcite oscili iamp*kenv, icps*2, 1   ; harmonic excitation

    asig repluck 0.1, iamp, icps, 0.2, 0.9, aexcite

    outs asig, asig
endin

; Voice-excited string (vocoder-like effect)
instr 3
    iamp = p4
    icps = cpspch(p5)

    ; Read voice sample as excitation
    aexcite diskin "hellorcb.aif", 1, 0, 1   ; looped
    aexcite = aexcite * iamp

    asig repluck 0.3, iamp, icps, 0.4, 0.85, aexcite

    aenv linseg 1, p3-0.1, 1, 0.1, 0
    outs asig*aenv, asig*aenv
endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1   ; sine for excitation

; Noise-excited
i1 0 3 0.6 8.00 0.1 0.1 0.93
i1 + . .   8.04 .   .   .
i1 + . .   8.07 .   .   .

; Oscillator-excited (more bell-like)
i2 9 3 0.6 8.00
i2 + . .   8.04
i2 + . .   8.07

; Voice-excited (comment out if no audio file)
; i3 18 5 0.5 7.00
; i3 +  5 0.5 8.00
e
</CsScore>
</CsoundSynthesizer>
```

### Example 5: Chorused Plucked Strings (Xanadu-style)
Creating rich, shimmering textures with detuned plucked strings and delays.

```csound
<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

; Chorused plucked strings with pitch shifting and delays
instr 1
    iamp = p4
    ioct = octpch(p5)
    ishift = 0.00666667      ; shift 8/1200 (8 cents)

    ; Vibrato
    icps = cpsoct(ioct)
    kvib oscili 1/120, icps/50, 1

    ; Three detuned plucks
    acenter pluck iamp, cpsoct(ioct+kvib), 1000, 1, 1
    aleft   pluck iamp, cpsoct(ioct+ishift), 1000, 1, 1
    aright  pluck iamp, cpsoct(ioct-ishift), 1000, 1, 1

    ; Delay line with pitch-shifting taps
    kf1 expon 0.1, p3, 1.0
    kf2 expon 1.0, p3, 0.1

    adump delayr 2.0
    delayw acenter
    atap1 deltapi kf1
    atap2 deltapi kf2
    ad1 deltap 2.0
    ad2 deltap 1.1

    ; Mix with stereo spread
    aoutl = aleft + atap1 + ad1
    aoutr = aright + atap2 + ad2

    outs aoutl*0.5, aoutr*0.5
endin

; Simpler chorus with fixed delays
instr 2
    iamp = p4
    ioct = octpch(p5)
    ishift = 0.00666667

    kvib oscili 1/120, cpsoct(ioct)/50, 1

    acenter pluck iamp*0.7, cpsoct(ioct+kvib), 1000, 1, 1
    aleft   pluck iamp*0.7, cpsoct(ioct+ishift), 1000, 1, 1
    aright  pluck iamp*0.7, cpsoct(ioct-ishift), 1000, 1, 1

    ; Fixed delays for warmth
    adump delayr 0.3
    delayw acenter
    ad1 deltap 0.1
    ad2 deltap 0.2

    outs aleft + ad1, aright + ad2
endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1

; Rich chorused plucks - guitar chord style
; Stagger note starts for strumming effect
i1 0    10 0.5 8.06
i1 0.1  .  .   9.01
i1 0.2  .  .   9.06
i1 0.3  .  .   9.10
i1 0.4  .  .   9.11
i1 0.5  .  .   10.04

; Second chord
i2 11   8  0.5 8.02
i2 11.1 .  .   8.09
i2 11.2 .  .   9.02
i2 11.3 .  .   9.06
i2 11.4 .  .   9.11
i2 11.5 .  .   10.04
e
</CsScore>
</CsoundSynthesizer>
```

### Example 6: Drum Synthesis with Karplus-Strong
Using the algorithm for drum/percussion sounds with modified parameters.

```csound
<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

; Drum mode of pluck opcode
instr 1
    iamp = p4
    icps = p5

    ; Method 3 = simple drum (random sign flipping creates inharmonic decay)
    ; Method 4 = stretched drum
    asig pluck iamp, icps, icps, 0, 3

    ; Short envelope for percussive sound
    aenv expon 1, p3, 0.001

    outs asig*aenv, asig*aenv
endin

; Snare-like drum
instr 2
    iamp = p4
    icps = p5

    ; Mix drum and stretched drum for snare character
    a1 pluck iamp*0.7, icps, icps, 0, 3
    a2 pluck iamp*0.5, icps*1.5, icps*1.5, 0, 4

    ; Add noise for snare wires
    anoise rand iamp*0.3
    anoise butterhp anoise, 2000
    knoiseenv expon 1, 0.1, 0.001

    amix = a1 + a2 + anoise*knoiseenv
    aenv expon 1, p3, 0.001

    outs amix*aenv, amix*aenv
endin

; Tom-tom
instr 3
    iamp = p4
    icps = p5

    ; Lower pitch with pitch drop
    kpitch expon icps, p3*0.5, icps*0.7

    asig pluck iamp, kpitch, icps, 0, 3

    ; Longer decay for tom
    aenv expon 1, p3, 0.01

    outs asig*aenv, asig*aenv
endin

; Hi-hat using very short delay (high freq)
instr 4
    iamp = p4

    ; High frequency = metallic sound
    icps = 8000

    asig pluck iamp, icps, icps, 0, 1

    ; Very short for closed hat
    aenv expon 1, p3, 0.001

    ; Highpass for brightness
    asig butterhp asig, 5000

    outs asig*aenv, asig*aenv
endin

</CsInstruments>
<CsScore>
; Kick drum
i1 0   0.5  0.8  60
i1 1   .    .    .
i1 2   .    .    .
i1 3   .    .    .

; Snare
i2 0.5 0.3  0.7  200
i2 1.5 .    .    .
i2 2.5 .    .    .
i2 3.5 .    .    .

; Toms
i3 4   0.4  0.6  120
i3 4.5 .    .    100
i3 5   .    .    80

; Hi-hat
i4 0    0.05 0.3  0
i4 0.25 .    .    0
i4 0.5  .    .    0
i4 0.75 .    .    0
i4 1    .    .    0
i4 1.25 .    .    0
i4 1.5  .    .    0
i4 1.75 .    .    0
e
</CsScore>
</CsoundSynthesizer>
```

## Key Parameters and Their Effects

### Frequency/Pitch
- Delay line length = sr/frequency
- Lower pitches require longer delay buffers
- Very low pitches may need large buffer sizes

### Decay Time (Reflection/Damping)
- Higher reflection coefficient = longer sustain
- Filter cutoff affects brightness of decay
- Lower filter = darker, shorter decay

### Pluck Position
- Near bridge (0.1): brighter, more harmonics
- Middle (0.5): fuller, more fundamental
- Near nut (0.9): darker, fewer harmonics

### Pick Position (wgpluck2)
- Affects which harmonics are emphasized in output
- Similar effect to pickup position on electric guitar

## Common Patterns

### Creating Realistic Guitar Sounds
```csound
; Combine multiple detuned strings with:
; - Slight pitch variation (chorus effect)
; - Staggered start times (strumming)
; - Stereo spread
; - Reverb for space
```

### Plucked Bass
```csound
; Use lower frequencies with:
; - Lower reflection coefficient for quicker decay
; - Mild lowpass on output
; - Emphasis on fundamental
```

### Harpsichord/Clavinet
```csound
; Multiple strings per note with:
; - Different pluck positions
; - Slight detuning
; - Brighter filter settings
```

## Tips and Best Practices

1. **Sample Rate Considerations**: Manual implementations may need ksmps=1 (kr=sr) for accurate pitch at high frequencies

2. **Initialization**: Ensure delay lines are properly filled during the first delay-length period

3. **Pitch Accuracy**: Use allpass filters for fractional delay compensation when precise tuning is needed

4. **Avoiding Clicks**: Always use envelopes at note end to prevent discontinuities

5. **Polyphony**: Each note needs its own delay buffer - watch memory usage with many voices

6. **Combining with Effects**: Plucked strings benefit greatly from reverb, chorus, and gentle compression

## Related Opcodes

- `pluck` - Built-in Karplus-Strong
- `wgpluck`, `wgpluck2` - Waveguide plucked string
- `repluck` - External excitation plucked string
- `wgbow`, `wgbowedbar` - Bowed string models
- `wgflute`, `wgclar` - Wind instrument waveguides
- `delayr`, `delayw`, `deltap`, `deltapi` - Delay line building blocks
- `tone`, `butlp` - Lowpass filters for decay shaping
- `filter2` - General purpose filter for allpass tuning
