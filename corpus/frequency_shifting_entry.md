# Csound Frequency Shifting and Hilbert Transform

## Overview

Frequency shifting (also called single-sideband modulation or SSB) shifts all frequencies in a signal by a constant amount in Hz. Unlike pitch shifting which multiplies frequencies (preserving harmonic relationships), frequency shifting adds a fixed offset, creating inharmonic, bell-like, or metallic timbres. The Hilbert transform is the mathematical foundation that makes this possible.

## Core Concepts

### Frequency Shifting vs Pitch Shifting
- **Pitch Shifting**: Multiplies frequencies (100Hz, 200Hz, 300Hz shifted up one octave becomes 200Hz, 400Hz, 600Hz - ratios preserved)
- **Frequency Shifting**: Adds fixed Hz (100Hz, 200Hz, 300Hz shifted by +50Hz becomes 150Hz, 250Hz, 350Hz - ratios changed)

### The Hilbert Transform
The Hilbert transform creates a 90-degree phase-shifted version of the input signal. When combined with the original using sine/cosine modulation, it enables single-sideband modulation:
- **Upper sideband (USB)**: Shifts frequencies upward
- **Lower sideband (LSB)**: Shifts frequencies downward

### Key Formula
```
USB = original * cos(2*pi*f*t) + hilbert(original) * sin(2*pi*f*t)
LSB = original * cos(2*pi*f*t) - hilbert(original) * sin(2*pi*f*t)
```

### Key Opcodes
- **hilbert**: Built-in Hilbert transformer (returns two signals: original and 90-degree shifted)
- **freqshift** (in some Csound versions): Dedicated frequency shifter opcode

## Example Instruments

### Example 1: Basic Frequency Shifting with hilbert Opcode
Using Csound's built-in Hilbert transformer for clean frequency shifting.

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

; Basic frequency shifter using hilbert opcode
instr 1
    iamp = p4
    ishift = p5      ; shift amount in Hz (positive = up, negative = down)

    ; Input signal - harmonically rich for interesting results
    ain vco2 iamp, 110, 10   ; sawtooth

    ; Hilbert transform returns two outputs:
    ; areal = original signal (in-phase)
    ; aimag = 90-degree phase shifted (quadrature)
    areal, aimag hilbert ain

    ; Modulator oscillators (sine and cosine)
    asin oscili 1, ishift, 1
    acos oscili 1, ishift, 1, 0.25   ; 0.25 phase = cosine

    ; Single sideband modulation
    ; USB (upper sideband) shifts up, LSB (lower) shifts down
    ausb = areal * acos - aimag * asin   ; upper sideband
    alsb = areal * acos + aimag * asin   ; lower sideband

    ; Output upper sideband (shift up when positive)
    aout = ausb

    aenv adsr 0.01, 0.1, 0.7, 0.3
    outs aout*aenv, aout*aenv
endin

; Compare shifted vs original
instr 2
    iamp = p4
    ishift = p5
    icps = cpspch(p6)

    ; Original signal
    aorig vco2 iamp, icps, 10

    ; Frequency shifted version
    areal, aimag hilbert aorig
    asin oscili 1, ishift, 1
    acos oscili 1, ishift, 1, 0.25
    ashifted = areal * acos - aimag * asin

    ; Pan original left, shifted right
    aenv adsr 0.01, 0.1, 0.7, 0.3

    outs aorig*aenv*0.7, ashifted*aenv*0.7
endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1   ; sine

; Basic frequency shifting at different amounts
;       amp  shift
i1 0 3  0.4  5      ; small shift - subtle beating
i1 4 3  0.4  50     ; moderate shift - inharmonic
i1 8 3  0.4  200    ; large shift - very metallic
i1 12 3 0.4  -100   ; negative shift - down

; Compare original (left) vs shifted (right)
;       amp  shift pitch
i2 16 3 0.4  20    8.00
i2 20 3 0.4  50    8.00
i2 24 3 0.4  100   8.00
e
</CsScore>
</CsoundSynthesizer>
```

### Example 2: Manual Hilbert Transform Implementation
An FIR-based Hilbert transformer for educational purposes.

```csound
<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 1          ; Required for sample-accurate FIR
nchnls = 2
0dbfs = 1

; Manual 11-tap FIR Hilbert transformer
; Based on classic implementation by Roger Klaveness
instr 1
    iamp = p4
    ishift = p5

    ; Input signal
    ain vco2 iamp, 110, 10

    ; Hilbert transform coefficients and gain
    igain = 1.570796327   ; pi/2

    ; Delay line state variables (11 taps)
    axv0 init 0
    axv1 init 0
    axv2 init 0
    axv3 init 0
    axv4 init 0
    axv5 init 0
    axv6 init 0
    axv7 init 0
    axv8 init 0
    axv9 init 0
    axv10 init 0

    ; Shift delay line
    axv0 = axv1
    axv1 = axv2
    axv2 = axv3
    axv3 = axv4
    axv4 = axv5
    axv5 = axv6
    axv6 = axv7
    axv7 = axv8
    axv8 = axv9
    axv9 = axv10
    axv10 = ain / igain

    ; FIR Hilbert filter (odd taps only for 90-degree shift)
    ; Coefficients designed for flat magnitude response
    ahilb = 0.0160000000 * (axv0 - axv10) + \
            0.1326173942 * (axv2 - axv8) + \
            0.9121478174 * (axv4 - axv6)

    ; Delayed original signal (center tap) for phase alignment
    aorig = axv5

    ; Modulators
    asin oscili 1, ishift, 1
    acos oscili 1, ishift, 1, 0.25

    ; SSB modulation
    ausb = aorig * acos + ahilb * asin   ; upper
    alsb = aorig * acos - ahilb * asin   ; lower

    aenv adsr 0.01, 0.1, 0.7, 0.3
    outs ausb*aenv, alsb*aenv   ; USB left, LSB right
endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1   ; sine

; Listen to upper (L) and lower (R) sidebands
i1 0 4 0.4 30
i1 5 4 0.4 100
e
</CsScore>
</CsoundSynthesizer>
```

### Example 3: Stereo Frequency Shifter with LFO Modulation
A more complete frequency shifter with stereo processing and modulation.

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

; Stereo frequency shifter with LFO and feedback
instr 1
    iamp = p4
    ishiftL = p5          ; left channel shift (Hz)
    ishiftR = p6          ; right channel shift (Hz)
    ilfo_depth = p7       ; LFO depth in Hz
    ilfo_rate = p8        ; LFO rate
    ifdbk = p9            ; feedback amount

    ; Input - use audio file or generated signal
    ainL vco2 iamp, 110, 10
    ainR = ainL

    ; Feedback signals
    afdbkL init 0
    afdbkR init 0

    ; LFO modulation (slightly different rates for stereo interest)
    klfoL oscili ilfo_depth, ilfo_rate, 1
    klfoR oscili ilfo_depth, ilfo_rate * 1.03, 1

    ; Mix input with feedback
    asrcL = ainL + afdbkL
    asrcR = ainR + afdbkR

    ; Hilbert transform
    arealL, aimagL hilbert asrcL
    arealR, aimagR hilbert asrcR

    ; Modulated shift frequency
    kshiftL = ishiftL + klfoL
    kshiftR = ishiftR + klfoR

    ; Modulators
    asinL oscili 1, kshiftL, 1
    acosL oscili 1, kshiftL, 1, 0.25
    asinR oscili 1, kshiftR, 1
    acosR oscili 1, kshiftR, 1, 0.25

    ; Frequency shifting (upper sideband)
    ashiftL = (arealL * acosL - aimagL * asinL) * 0.8
    ashiftR = (arealR * acosR - aimagR * asinR) * 0.8

    ; Update feedback
    afdbkL = ashiftL * ifdbk
    afdbkR = ashiftR * ifdbk

    aenv adsr 0.01, 0.1, 0.7, 0.5

    outs ashiftL*aenv, ashiftR*aenv
endin

; Frequency shifter with delay for richer texture
instr 2
    iamp = p4
    ishift = p5
    idelayL = p6/1000     ; delay time in ms
    idelayR = p7/1000
    idelay_fdbk = p8
    imix = p9

    ain vco2 iamp, 110, 10

    ; Frequency shift
    areal, aimag hilbert ain
    asin oscili 1, ishift, 1
    acos oscili 1, ishift, 1, 0.25
    ashifted = areal * acos - aimag * asin

    ; Stereo delays on shifted signal
    adelL init 0
    adelR init 0

    abufL delayr idelayL + 0.1
    atapL deltapi idelayL
    delayw ashifted + adelL * idelay_fdbk

    abufR delayr idelayR + 0.1
    atapR deltapi idelayR
    delayw ashifted + adelR * idelay_fdbk

    adelL = atapL
    adelR = atapR

    ; Mix dry and wet
    aoutL = ain * (1-imix) + (ashifted + atapL) * imix * 0.5
    aoutR = ain * (1-imix) + (ashifted + atapR) * imix * 0.5

    aenv adsr 0.01, 0.1, 0.7, 0.3
    outs aoutL*aenv, aoutR*aenv
endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1   ; sine

; Stereo shifter with LFO and feedback
;       amp  shiftL shiftR depth rate fdbk
i1 0 5  0.4  10     -10    5     0.3  0.3
i1 6 5  0.4  0.5    -0.5   2     0.2  0.5  ; very slow, subtle
i1 12 5 0.4  50     50     20    0.5  0.2

; With delay
;       amp  shift delayL delayR fdbk mix
i2 18 5 0.4  30    200    250    0.4  0.6
e
</CsScore>
</CsoundSynthesizer>
```

### Example 4: Barberpole Phaser Effect
Using continuously ascending/descending frequency shifting for infinite phaser.

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

; Barberpole phaser - continuously ascending/descending
instr 1
    iamp = p4
    irate = p5        ; rate of apparent motion (Hz)
    idir = p6         ; direction: 1 = up, -1 = down
    imix = p7

    ; Input
    ain vco2 iamp, 110, 10

    ; Multiple frequency shifters at different amounts create
    ; the illusion of infinite ascending/descending
    areal, aimag hilbert ain

    ; Shift amounts are spread across range, modulated at same rate
    ; but different phases to create smooth continuous motion
    kphase phasor irate * idir

    ; Four shift stages
    kshift1 = 1 + kphase * 10
    kshift2 = 1 + frac(kphase + 0.25) * 10
    kshift3 = 1 + frac(kphase + 0.5) * 10
    kshift4 = 1 + frac(kphase + 0.75) * 10

    ; Shift each stage
    asin1 oscili 1, kshift1, 1
    acos1 oscili 1, kshift1, 1, 0.25
    ash1 = areal * acos1 - aimag * asin1

    asin2 oscili 1, kshift2, 1
    acos2 oscili 1, kshift2, 1, 0.25
    ash2 = areal * acos2 - aimag * asin2

    asin3 oscili 1, kshift3, 1
    acos3 oscili 1, kshift3, 1, 0.25
    ash3 = areal * acos3 - aimag * asin3

    asin4 oscili 1, kshift4, 1
    acos4 oscili 1, kshift4, 1, 0.25
    ash4 = areal * acos4 - aimag * asin4

    ; Crossfade between stages based on phase for smooth transition
    ; Amplitude windows for each voice
    kamp1 = sin(kphase * 3.14159)
    kamp2 = sin(frac(kphase + 0.25) * 3.14159)
    kamp3 = sin(frac(kphase + 0.5) * 3.14159)
    kamp4 = sin(frac(kphase + 0.75) * 3.14159)

    amix = ash1*kamp1 + ash2*kamp2 + ash3*kamp3 + ash4*kamp4
    amix = amix * 0.5

    aout = ain * (1-imix) + amix * imix

    aenv adsr 0.01, 0.1, 0.8, 0.3
    outs aout*aenv, aout*aenv
endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1   ; sine

; Ascending barberpole
i1 0 8 0.4 0.5 1 0.6

; Descending barberpole
i1 10 8 0.4 0.3 -1 0.6
e
</CsScore>
</CsoundSynthesizer>
```

### Example 5: Frequency Shifting for Sound Design
Creative applications of frequency shifting for special effects.

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

; Metallic/bell-like transformation
instr 1
    iamp = p4
    icps = cpspch(p5)
    ishift = p6

    ; Simple tone as source
    ain oscili iamp, icps, 2  ; triangle

    ; Large frequency shift creates inharmonic partials
    areal, aimag hilbert ain
    asin oscili 1, ishift, 1
    acos oscili 1, ishift, 1, 0.25
    ashifted = areal * acos - aimag * asin

    ; Mix original with shifted for bell character
    aout = ain * 0.5 + ashifted * 0.5

    aenv expseg 1, 0.01, 1, p3-0.01, 0.001
    outs aout*aenv, aout*aenv
endin

; Doppler effect simulation
instr 2
    iamp = p4
    icps = p5

    ; Sawtooth source (engine-like)
    ain vco2 iamp, icps, 10

    ; Doppler shift envelope (approaches, passes, recedes)
    kshift linseg 200, p3/3, 50, p3/3, -50, p3/3, -200

    areal, aimag hilbert ain
    asin oscili 1, kshift, 1
    acos oscili 1, kshift, 1, 0.25
    aout = areal * acos - aimag * asin

    ; Also modulate amplitude for distance
    kamp linseg 0.3, p3/3, 1, p3/3, 0.8, p3/3, 0.2

    outs aout*kamp, aout*kamp
endin

; Thickening effect with small shift
instr 3
    iamp = p4
    icps = cpspch(p5)
    ishift = p6      ; small shift (1-5 Hz) for thickening

    ; Original signal
    aorig vco2 iamp, icps, 10

    ; Slightly shifted copy
    areal, aimag hilbert aorig
    asin oscili 1, ishift, 1
    acos oscili 1, ishift, 1, 0.25
    ashifted = areal * acos - aimag * asin

    ; Mix for chorusing/thickening effect
    aoutL = aorig * 0.7 + ashifted * 0.3
    aoutR = aorig * 0.3 + ashifted * 0.7

    aenv adsr 0.01, 0.1, 0.7, 0.3
    outs aoutL*aenv, aoutR*aenv
endin

; Alien voice effect
instr 4
    iamp = p4
    ishift = p5

    ; Read voice/sample
    ain diskin "hellorcb.aif", 1, 0, 1

    ; Frequency shift for alien quality
    areal, aimag hilbert ain
    asin oscili 1, ishift, 1
    acos oscili 1, ishift, 1, 0.25
    ashifted = areal * acos - aimag * asin

    ; Ring modulation adds to effect
    amod oscili 1, 150, 1
    aout = ashifted * amod

    outs aout*iamp, aout*iamp
endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1                  ; sine
f2 0 8192 7 -1 4096 1 4096 -1   ; triangle

; Bell/metallic sounds
;       amp  pitch shift
i1 0 2  0.4  8.00  77
i1 + .  .    8.04  89
i1 + .  .    8.07  101

; Doppler effect
i2 8 4 0.4 100

; Thickening effect
;       amp  pitch shift
i3 13 3 0.4  7.00  2
i3 17 3 0.4  7.00  5

; Alien voice (comment out if no audio file)
; i4 22 5 0.5 50
e
</CsScore>
</CsoundSynthesizer>
```

### Example 6: Pitch-Tracked Frequency Shifting
Frequency shifting amount follows input pitch for harmonic effects.

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

; Frequency shift follows pitch for consistent harmonic relationship
instr 1
    iamp = p4
    icps = cpspch(p5)
    iratio = p6       ; shift as ratio of fundamental

    ; Input signal
    ain vco2 iamp, icps, 10

    ; Shift amount proportional to pitch
    ishift = icps * iratio

    ; Hilbert transform and shift
    areal, aimag hilbert ain
    asin oscili 1, ishift, 1
    acos oscili 1, ishift, 1, 0.25

    ; Upper sideband
    ashifted = areal * acos - aimag * asin

    ; Mix original with shifted
    aout = ain * 0.5 + ashifted * 0.5

    aenv adsr 0.01, 0.1, 0.7, 0.3
    outs aout*aenv, aout*aenv
endin

; Both sidebands for rich sound
instr 2
    iamp = p4
    icps = cpspch(p5)
    iratio = p6

    ain vco2 iamp, icps, 10

    ishift = icps * iratio

    areal, aimag hilbert ain
    asin oscili 1, ishift, 1
    acos oscili 1, ishift, 1, 0.25

    ausb = areal * acos - aimag * asin  ; upper
    alsb = areal * acos + aimag * asin  ; lower

    ; Pan sidebands
    aoutL = ain * 0.3 + ausb * 0.5 + alsb * 0.2
    aoutR = ain * 0.3 + ausb * 0.2 + alsb * 0.5

    aenv adsr 0.01, 0.1, 0.7, 0.3
    outs aoutL*aenv, aoutR*aenv
endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1   ; sine

; Pitch-tracked shifting
;       amp  pitch ratio
i1 0 2  0.4  7.00  0.5
i1 + .  .    7.07  .
i1 + .  .    8.00  .
i1 + .  .    8.07  .

; Both sidebands
i2 8 2  0.4  7.00  0.25
i2 + .  .    7.07  .
i2 + .  .    8.00  .
i2 + .  .    8.07  .
e
</CsScore>
</CsoundSynthesizer>
```

## Key Parameters

| Parameter | Typical Range | Effect |
|-----------|---------------|--------|
| Shift Amount | -500 to +500 Hz | Positive = up, negative = down |
| Small shift (1-10 Hz) | Creates beating/thickening |
| Medium shift (10-100 Hz) | Inharmonic/metallic tones |
| Large shift (100+ Hz) | Radical transformation |
| Feedback | 0 - 0.9 | Creates resonance and feedback loops |
| Mix | 0 - 1 | Dry/wet balance |

## Common Applications

1. **Sound Design**: Metallic, alien, and otherworldly sounds
2. **Thickening**: Small shifts create subtle chorusing
3. **Barberpole Effects**: Infinite rising/falling illusion
4. **Doppler Simulation**: Sweeping shift for motion effects
5. **Ring Modulation Alternative**: More controllable inharmonics
6. **Creative FX**: Feedback loops, modulated shifting

## Tips and Best Practices

1. **Phase Alignment**: When mixing dry and shifted signals, ensure proper phase relationship

2. **DC Blocking**: Frequency shifting can introduce DC offset - use `dcblock`

3. **Small Shifts**: Values < 10 Hz create subtle, musical effects (beating, thickening)

4. **Input Material**: Harmonically rich inputs produce more interesting results

5. **Feedback Control**: Keep feedback < 0.95 to avoid runaway oscillation

6. **Sample Rate**: Higher sample rates improve Hilbert transformer accuracy

7. **ksmps Setting**: For manual FIR implementation, use ksmps=1

## Related Opcodes

- `hilbert` - Hilbert transformer (returns in-phase and quadrature signals)
- `oscili`, `poscil` - For modulator oscillators
- `ring modulator` patterns - Related frequency transformation
- `delay`, `vdelay` - For combining with delays
- `dcblock` - Remove DC offset from output
