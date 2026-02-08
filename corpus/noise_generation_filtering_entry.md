# Csound Noise Generation and Filtering Techniques

## Overview

Noise is a fundamental building block in sound synthesis, used for everything from percussion and wind sounds to adding breath/texture to tones. Csound provides multiple noise generators with different spectral characteristics, plus extensive filtering capabilities to sculpt noise into musical sounds.

## Core Concepts

### Noise Types
- **White Noise**: Equal energy at all frequencies (flat spectrum)
- **Pink Noise**: Equal energy per octave (1/f spectrum, -3dB/octave)
- **Brown/Red Noise**: Even more low-frequency emphasis (-6dB/octave)
- **Blue Noise**: High-frequency emphasis (+3dB/octave)

### Noise Generators
- `rand` - Bipolar white noise (-amp to +amp)
- `randh` - Sample-and-hold random (stepped)
- `randi` - Interpolating random (smoothed)
- `trirand` - Triangular distribution white noise
- `gauss` - Gaussian (normal) distribution noise
- `noise` - White noise with optional highpass
- `pinkish` - Approximate pink noise

### Key Filtering Opcodes
- `reson` - Resonant bandpass filter
- `butterbp`, `butterlp`, `butterhp` - Butterworth filters
- `pareq` - Parametric EQ for spectral shaping
- `tone`, `atone` - Simple lowpass/highpass
- `moogladder`, `moogvcf` - Resonant lowpass

## Example Instruments

### Example 1: Basic Noise Types
Demonstrating different noise generators and their characteristics.

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

; White noise using rand (uniform distribution)
instr 1
    iamp = p4
    asig rand iamp
    aenv linseg 0, 0.01, 1, p3-0.02, 1, 0.01, 0
    outs asig*aenv, asig*aenv
endin

; Triangular distribution noise (less harsh)
instr 2
    iamp = p4
    asig trirand iamp
    aenv linseg 0, 0.01, 1, p3-0.02, 1, 0.01, 0
    outs asig*aenv, asig*aenv
endin

; Gaussian (normal) distribution noise
instr 3
    iamp = p4
    asig gauss iamp
    aenv linseg 0, 0.01, 1, p3-0.02, 1, 0.01, 0
    outs asig*aenv, asig*aenv
endin

; Sample-and-hold noise (stepped)
instr 4
    iamp = p4
    irate = p5    ; rate of new random values
    asig randh iamp, irate
    aenv linseg 0, 0.01, 1, p3-0.02, 1, 0.01, 0
    outs asig*aenv, asig*aenv
endin

; Interpolating random (smoothed random)
instr 5
    iamp = p4
    irate = p5
    asig randi iamp, irate
    aenv linseg 0, 0.01, 1, p3-0.02, 1, 0.01, 0
    outs asig*aenv, asig*aenv
endin

</CsInstruments>
<CsScore>
; White noise - uniform distribution
i1 0 2 0.3

; Triangular distribution - slightly softer
i2 3 2 0.3

; Gaussian - natural distribution
i3 6 2 0.3

; Sample-and-hold at different rates
i4 9  2 0.3 1000   ; slow
i4 12 2 0.3 10000  ; fast

; Interpolating random at different rates
i5 15 2 0.3 1000   ; slow - smooth
i5 18 2 0.3 10000  ; fast - more like noise
e
</CsScore>
</CsoundSynthesizer>
```

### Example 2: Pink Noise Generation
Creating pink noise using the classic 6-filter parallel method.

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

; Pink noise using 6 parallel first-order filters
; Classic Paul Kellet algorithm
instr 1
    iamp = p4
    isc = 0.6    ; scalar to match white noise amplitude

    ; Initialize filter states
    a1 init 0
    a2 init 0
    a3 init 0
    a4 init 0
    a5 init 0
    a6 init 0

    ; White noise source
    anz trirand iamp

    ; Six parallel leaky integrators with carefully chosen coefficients
    ; Each filter emphasizes a different frequency band
    a1 = 0.99886 * a1 + isc * 0.0555179 * anz
    a2 = 0.99332 * a2 + isc * 0.0750759 * anz
    a3 = 0.96900 * a3 + isc * 0.1538520 * anz
    a4 = 0.86650 * a4 + isc * 0.3104856 * anz
    a5 = 0.55000 * a5 + isc * 0.5329522 * anz
    a6 = -0.7616 * a6 - isc * 0.0168980 * anz

    ; Sum all filters for pink noise
    apink = a1 + a2 + a3 + a4 + a5 + a6

    aenv linseg 0, 0.01, 1, p3-0.02, 1, 0.01, 0
    outs apink*aenv*0.5, apink*aenv*0.5
endin

; Pink noise using pareq filter chain (alternative method)
instr 2
    iamp = p4

    ; Start with white noise
    anz trirand iamp

    ; Apply series of shelving filters to shape spectrum
    ; Each stage reduces high frequencies by ~3dB/octave
    a1 pareq anz, 625, 0.7079, 0.707, 2     ; high shelf
    a2 pareq a1, 2500, 0.3548, 0.707, 2
    a3 pareq a2, 10000, 0.1778, 0.707, 2
    apink pareq a3, 20000, 0.1259, 0.707, 2

    aenv linseg 0, 0.01, 1, p3-0.02, 1, 0.01, 0
    outs apink*aenv*0.3, apink*aenv*0.3
endin

; Simplified pink using just lowpass
instr 3
    iamp = p4

    anz rand iamp

    ; Simple approximation: lowpass white noise
    ; Not true pink but useful for many applications
    apink tone anz, 1000
    apink = apink * 3  ; compensate for level loss

    aenv linseg 0, 0.01, 1, p3-0.02, 1, 0.01, 0
    outs apink*aenv, apink*aenv
endin

</CsInstruments>
<CsScore>
; True pink noise (6-filter method)
i1 0 3 0.5

; Pink noise using pareq chain
i2 4 3 0.5

; Simple lowpassed approximation
i3 8 3 0.3
e
</CsScore>
</CsoundSynthesizer>
```

### Example 3: Filtered Noise for Pitched Sounds
Using bandpass filters to create pitched noise instruments.

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

; Basic filtered noise with reson
instr 1
    iamp = p4
    icps = cpspch(p5)
    ibw = p6            ; bandwidth in Hz

    ; White noise source
    anoise rand 1

    ; Resonant bandpass filter
    afilt reson anoise, icps, ibw

    ; Balance to control amplitude (reson can be very loud)
    aref rand iamp
    aout balance afilt, aref

    aenv linseg 0, 0.01, 1, p3-0.1, 1, 0.09, 0
    outs aout*aenv, aout*aenv
endin

; Multiple resonant filters for formant synthesis
instr 2
    iamp = p4
    icps = cpspch(p5)

    anoise rand 1

    ; Three formants (like vowel sounds)
    if1 = 500
    if2 = 1500
    if3 = 2500

    ibw = 50  ; narrow bandwidth for strong resonance

    a1 reson anoise, if1, ibw
    a2 reson anoise, if2, ibw * 1.5
    a3 reson anoise, if3, ibw * 2

    amix = a1 * 0.5 + a2 * 0.3 + a3 * 0.2

    aref rand iamp
    aout balance amix, aref

    aenv adsr 0.01, 0.1, 0.7, 0.2
    outs aout*aenv, aout*aenv
endin

; Noise with sweeping filter frequency
instr 3
    iamp = p4
    istart = cpspch(p5)
    iend = cpspch(p6)
    ibw = p7

    anoise rand 1

    ; Sweep filter center frequency
    kcps expseg istart, p3, iend

    afilt reson anoise, kcps, ibw

    aref rand iamp
    aout balance afilt, aref

    aenv linseg 0, 0.01, 1, p3-0.02, 1, 0.01, 0
    outs aout*aenv, aout*aenv
endin

</CsInstruments>
<CsScore>
; Basic filtered noise at different pitches
;       amp  pitch bw
i1 0 2  0.4  8.00  20
i1 + .  .    8.04  .
i1 + .  .    8.07  .
i1 + .  .    9.00  .

; Formant-style filtered noise
i2 8 2  0.4  7.00
i2 + .  .    7.07
i2 + .  .    8.00

; Sweeping filter
;       amp  start end   bw
i3 14 3 0.4  6.00  9.00  30
i3 18 3 0.4  9.00  6.00  30
e
</CsScore>
</CsoundSynthesizer>
```

### Example 4: Noise-Based Percussion
Creating drum and percussion sounds from filtered noise.

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

; Snare drum using noise + resonant filter
instr 1
    iamp = p4
    itone = p5    ; drum tone frequency

    ; Noise for snare wires
    anoise rand 1
    anoise butterhp anoise, 2000

    ; Tone component with pitch drop
    kpitch expon itone, 0.1, itone * 0.5
    atone oscili 1, kpitch, 1
    atone butterlp atone, 500

    ; Envelopes
    knoiseenv expon 1, 0.2, 0.01
    ktoneenv expon 1, 0.08, 0.001

    amix = anoise * knoiseenv * 0.5 + atone * ktoneenv * 0.7
    amix = amix * iamp

    outs amix, amix
endin

; Hi-hat using filtered noise
instr 2
    iamp = p4
    iopen = p5    ; 0 = closed, 1 = open

    anoise rand 1

    ; High bandpass for metallic character
    afilt butterbp anoise, 8000, 3000
    afilt = afilt + anoise * 0.1  ; add some fullness

    ; Closed vs open hat envelope
    if iopen == 0 then
        aenv expon 1, 0.05, 0.001
    else
        aenv expon 1, 0.3, 0.01
    endif

    aout = afilt * aenv * iamp

    outs aout, aout
endin

; Kick drum with noise transient
instr 3
    iamp = p4
    ipitch = p5

    ; Pitch drop for body
    kpitch expon ipitch, 0.15, ipitch * 0.3
    abody oscili 1, kpitch, 1

    ; Noise click for attack
    anoise rand 1
    anoise butterlp anoise, 200
    knoiseenv expon 1, 0.01, 0.001

    ; Body envelope
    kbodyenv expon 1, 0.3, 0.001

    amix = abody * kbodyenv + anoise * knoiseenv * 0.3
    amix = amix * iamp

    outs amix, amix
endin

; Cymbal/crash using layered filtered noise
instr 4
    iamp = p4

    anoise rand 1

    ; Multiple bandpass filters for metallic spectrum
    a1 butterbp anoise, 3000, 500
    a2 butterbp anoise, 5500, 700
    a3 butterbp anoise, 8000, 1000
    a4 butterbp anoise, 12000, 2000

    amix = a1 * 0.4 + a2 * 0.3 + a3 * 0.2 + a4 * 0.3

    ; Long decay envelope
    aenv expseg 1, 0.01, 1, p3-0.01, 0.001

    aout = amix * aenv * iamp

    outs aout, aout
endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1   ; sine

; Drum pattern
; Kick
i3 0   0.5 0.8 60
i3 1   .   .   .
i3 2   .   .   .
i3 3   .   .   .

; Snare
i1 0.5 0.3 0.6 200
i1 1.5 .   .   .
i1 2.5 .   .   .
i1 3.5 .   .   .

; Hi-hat (closed)
i2 0    0.1 0.3 0
i2 0.25 .   .   .
i2 0.5  .   .   .
i2 0.75 .   .   .
i2 1    .   .   .
i2 1.25 .   .   .
i2 1.5  .   .   .
i2 1.75 .   .   .

; Hi-hat (open) on offbeats
i2 0.5  0.2 0.25 1
i2 1.5  .   .    .

; Crash
i4 0 2 0.4
e
</CsScore>
</CsoundSynthesizer>
```

### Example 5: Wind and Breath Sounds
Simulating natural sounds using filtered noise.

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

; Wind sound using slowly modulated filtered noise
instr 1
    iamp = p4

    ; White noise source
    anoise rand 1

    ; Slowly varying filter parameters
    klfo1 oscili 500, 0.1, 1
    klfo2 oscili 300, 0.13, 1
    kcf = 600 + klfo1 + klfo2

    ; Bandpass for wind character
    afilt butterbp anoise, kcf, kcf * 0.5

    ; Amplitude modulation for gusting
    kgust oscili 0.4, 0.07, 1
    kgust = kgust + 0.6

    aenv linseg 0, 1, 1, p3-2, 1, 1, 0
    aout = afilt * kgust * aenv * iamp

    outs aout, aout
endin

; Breath/air sound for wind instruments
instr 2
    iamp = p4
    icps = cpspch(p5)

    ; Noise for breath
    anoise rand 1

    ; Filter around note frequency and harmonics
    a1 butterbp anoise, icps, icps * 0.1
    a2 butterbp anoise, icps * 2, icps * 0.2
    a3 butterbp anoise, icps * 3, icps * 0.3

    abreath = a1 * 0.5 + a2 * 0.3 + a3 * 0.2

    ; Envelope with breathy attack
    kbreath linseg 1, 0.05, 0.3, p3-0.1, 0.3, 0.05, 0
    aenv adsr 0.1, 0.1, 0.7, 0.3

    aout = abreath * kbreath * aenv * iamp

    outs aout, aout
endin

; Ocean waves using filtered noise with rhythm
instr 3
    iamp = p4

    anoise rand 1

    ; Low rumble component
    alow butterlp anoise, 200
    alow = alow * 3

    ; Higher frequencies
    ahigh butterbp anoise, 1500, 1000

    ; Wave rhythm - slow surge
    kwave oscili 0.5, 0.1, 1
    kwave = kwave + 0.5

    ; Additional faster rhythm for smaller waves
    kripple oscili 0.15, 0.7, 1
    kripple = kripple + 0.85

    amix = alow * 0.6 + ahigh * 0.3
    amix = amix * kwave * kripple

    aenv linseg 0, 2, 1, p3-4, 1, 2, 0
    aout = amix * aenv * iamp

    outs aout, aout
endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1   ; sine

; Wind
i1 0 10 0.4

; Breath sounds at different pitches
i2 12 3 0.3 8.00
i2 16 3 0.3 8.07
i2 20 3 0.3 9.00

; Ocean
i3 24 15 0.5
e
</CsScore>
</CsoundSynthesizer>
```

### Example 6: Noise Modulation and Textures
Using noise to modulate other parameters for evolving textures.

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

; Pitch modulation with noise (unstable oscillator)
instr 1
    iamp = p4
    icps = cpspch(p5)
    idepth = p6    ; pitch wobble depth in Hz

    ; Noise for pitch modulation
    knoise randi idepth, 10

    asig oscili iamp, icps + knoise, 1

    aenv adsr 0.01, 0.1, 0.7, 0.2
    outs asig*aenv, asig*aenv
endin

; Filter cutoff modulation with noise
instr 2
    iamp = p4
    icps = cpspch(p5)
    ibase = p6     ; base filter frequency
    idepth = p7    ; modulation depth

    ; Rich source
    asig vco2 iamp, icps, 10

    ; Noise-modulated filter
    knoise randi idepth, 5
    kcf = ibase + knoise

    afilt moogladder asig, kcf, 0.7

    aenv adsr 0.01, 0.1, 0.7, 0.3
    outs afilt*aenv, afilt*aenv
endin

; Amplitude modulation with noise (tremolo/flutter)
instr 3
    iamp = p4
    icps = cpspch(p5)
    idepth = p6    ; AM depth (0-1)
    irate = p7     ; AM rate

    asig oscili iamp, icps, 1

    ; Noise-based AM
    knoise randi idepth, irate
    kmod = 1 - idepth/2 + knoise  ; center around 1

    aenv adsr 0.01, 0.1, 0.8, 0.2
    outs asig*kmod*aenv, asig*kmod*aenv
endin

; Granular-style texture using noise-triggered events
instr 4
    iamp = p4
    idensity = p5  ; grains per second

    ; Use noise to randomly trigger grains
    ktrig metro idensity
    krand randh 1, idensity*2

    ; Random pitch for each grain
    if ktrig == 1 then
        reinit newgrain
    endif

newgrain:
    ipitch = 200 + i(krand) * 300
    rireturn

    ; Short grain envelope
    aenv expseg 0.001, 0.01, 1, 0.05, 0.001

    asig oscili iamp, ipitch, 1
    asig = asig * aenv

    ; Accumulate
    aout = aout * 0.9 + asig

    outs aout, aout
endin

; Noise burst cloud
instr 5
    iamp = p4

    ; Random noise bursts
    ktrig metro 20
    if ktrig == 1 then
        reinit newburst
    endif

newburst:
    idur = 0.01 + rnd(0.05)
    ifreq = 500 + rnd(4000)
    ibw = ifreq * (0.1 + rnd(0.3))
    rireturn

    ; Burst envelope
    aenv expseg 1, idur, 0.001

    anoise rand iamp
    afilt butterbp anoise, ifreq, ibw
    aout = afilt * aenv * 0.3

    ; Stereo spread
    kpan = 0.3 + rnd(0.4)

    outs aout * sqrt(kpan), aout * sqrt(1-kpan)
endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1   ; sine

; Pitch wobble
i1 0 3 0.4 8.00 5

; Filter modulation
i2 4 3 0.4 7.00 1000 500

; Amplitude flutter
i3 8 3 0.4 8.00 0.3 8

; Granular texture
i4 12 5 0.3 15

; Noise burst cloud
i5 18 5 0.2
e
</CsScore>
</CsoundSynthesizer>
```

## Key Opcodes Reference

### Noise Generators
| Opcode | Distribution | Use Case |
|--------|-------------|----------|
| `rand` | Uniform | General white noise |
| `trirand` | Triangular | Softer noise, less extreme |
| `gauss` | Gaussian | Natural distribution |
| `randh` | Uniform, stepped | S&H, stepped modulation |
| `randi` | Uniform, interpolated | Smooth random LFO |

### Filters for Noise Shaping
| Opcode | Type | Notes |
|--------|------|-------|
| `reson` | 2nd-order BP | Very resonant, needs balance |
| `butterbp` | Butterworth BP | Flat passband |
| `butterlp/hp` | Butterworth LP/HP | Clean rolloff |
| `tone/atone` | 1st-order LP/HP | Simple, gentle slope |
| `pareq` | Parametric EQ | Flexible shaping |
| `moogladder` | Resonant LP | Analog-style |

## Tips and Best Practices

1. **Level Control**: Resonant filters can have very high gain - use `balance` opcode

2. **Bandwidth Selection**: Narrow bandwidth = more pitched; wide = more noise-like

3. **Pink Noise**: Use for more natural-sounding results (matches human perception)

4. **Layering**: Combine multiple filtered noise bands for complex textures

5. **Seed Control**: Some opcodes accept seed values for reproducible random sequences

6. **Rate Selection**: For `randh`/`randi`, rate affects character dramatically

7. **DC Offset**: Some noise operations can introduce DC - use `dcblock` if needed

## Related Opcodes

- `noise` - White noise with optional highpass
- `dust`, `dust2` - Random impulses
- `jitter`, `jitter2` - Jittering control signal
- `vibrato` - Includes random component
- `dcblock` - Remove DC offset from signal
- `balance` - Match amplitude of one signal to another
