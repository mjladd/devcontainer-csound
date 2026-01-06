# Csound Chorus, Flanger, and Phaser Effects

## Overview

Chorus, flanger, and phaser are modulation effects that create movement and thickness in sound through time-varying delays and phase manipulation. While related, each has distinct characteristics:

- **Chorus**: Multiple detuned copies create ensemble/doubling effect (delays ~20-50ms)
- **Flanger**: Comb filtering with very short modulated delays (delays ~1-10ms)
- **Phaser**: All-pass filters create sweeping notches without time delay

## Core Concepts

### Chorus
- Uses longer delays (20-50ms) modulated by slow LFO
- Multiple delay taps with different modulation create richer effect
- No feedback typically used
- Creates sense of multiple performers

### Flanger
- Uses very short delays (0.1-10ms) modulated by LFO
- Feedback reinforces comb filtering effect
- Creates metallic, jet-like sweeping sound
- Originated from tape machine manipulation

### Phaser
- Uses cascaded all-pass filters instead of delays
- All-pass filters shift phase without amplitude change
- Mixing with dry signal creates moving notches
- Produces more subtle, liquid sweep than flanger

### Key Opcodes
- **flanger**: Built-in flanger with interpolating delay
- **phaser1**, **phaser2**: All-pass filter phasers
- **vdelay**, **vdelay3**: Variable delay lines for chorus/flanger
- **deltapi**: Interpolating delay tap for manual implementations

## Example Instruments

### Example 1: Basic Flanger
Using Csound's built-in flanger opcode with stereo LFO modulation.

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

; Basic stereo flanger
instr 1
    iamp = p4
    idelay = p5/1000      ; base delay in ms -> sec
    idepth = p6/2000      ; LFO depth in ms -> sec
    irate1 = p7           ; left LFO rate
    irate2 = p8           ; right LFO rate (slightly different for stereo)
    ifdbk = p9            ; feedback amount (-1 to 1)
    imix = p10            ; wet/dry mix (0=dry, 1=wet)

    ; Maximum delay needed
    imax = idelay + idepth + 0.001

    ; Input signal
    asig oscili iamp, 220, 1
    ; Or use audio file:
    ; asig diskin "input.wav", 1

    ; LFO modulation - triangle wave for smooth sweep
    alfo1 oscili idepth, irate1, 2
    alfo2 oscili idepth, irate2, 2, 0.5  ; 180 degree phase offset

    ; Offset LFO to positive range
    alfo1 = alfo1 + idelay + idepth
    alfo2 = alfo2 + idelay + idepth

    ; Flanger opcode: input, delay_time, feedback, max_delay
    aflng1 flanger asig, alfo1, ifdbk, imax
    aflng2 flanger asig, alfo2, ifdbk, imax

    ; Mix dry and wet
    aoutl = asig*(1-imix) + aflng1*imix
    aoutr = asig*(1-imix) + aflng2*imix

    outs aoutl, aoutr
endin

; Flanger with audio file input
instr 2
    idelay = 0.5/1000     ; 0.5ms base delay
    idepth = 5/1000       ; 5ms depth
    irate = 0.5           ; slow sweep
    ifdbk = 0.7           ; moderate feedback
    imax = idelay + idepth*2 + 0.001

    ain diskin "Piano.aif", 1

    ; Sine LFO
    klfo oscili idepth, irate, 1
    klfo = klfo + idelay + idepth

    aflng flanger ain, klfo, ifdbk, imax

    ; Stereo spread via delay
    aoutl = ain*0.5 + aflng*0.5
    aoutr delay aoutl, 0.01

    outs aoutl, aoutr
endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1                  ; sine
f2 0 8192 7 -1 4096 1 4096 -1   ; triangle

;       amp  delay depth rate1 rate2 fdbk mix
i1 0 5  0.5  0.5   5     0.5   0.6   0.7  0.5
i1 6 5  0.5  0.25  8     0.3   0.35 -0.8  0.7   ; negative feedback
i1 12 5 0.5  1.0   3     1.5   1.6   0.9  0.6   ; faster, more intense
e
</CsScore>
</CsoundSynthesizer>
```

### Example 2: Multi-Voice Chorus
Creating a rich ensemble effect with multiple detuned delay taps.

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

; Multi-voice chorus effect
instr 1
    iamp = p4
    idelay = p5/1000      ; base delay ~20-30ms for chorus
    idepth = p6/1000      ; modulation depth
    irate = p7            ; LFO rate
    imix = p8             ; wet/dry mix
    imax = idelay + idepth*2 + 0.1

    ; Source signal
    asig oscili iamp, cpspch(p9), 1

    ; Multiple LFOs with different rates and phases for each voice
    klfo1 oscili idepth, irate*0.9, 1, 0
    klfo2 oscili idepth, irate*1.0, 1, 0.25
    klfo3 oscili idepth, irate*1.1, 1, 0.5
    klfo4 oscili idepth, irate*0.95, 1, 0.75

    ; Four chorus voices with different base delays
    adel1 vdelay3 asig, (idelay*0.9 + klfo1)*1000, imax*1000
    adel2 vdelay3 asig, (idelay*1.0 + klfo2)*1000, imax*1000
    adel3 vdelay3 asig, (idelay*1.1 + klfo3)*1000, imax*1000
    adel4 vdelay3 asig, (idelay*1.05 + klfo4)*1000, imax*1000

    ; Mix and pan voices
    achorusl = adel1*0.5 + adel2*0.3 + adel3*0.1 + adel4*0.3
    achorusr = adel1*0.3 + adel2*0.1 + adel3*0.5 + adel4*0.3

    ; Final mix
    aoutl = asig*(1-imix) + achorusl*imix
    aoutr = asig*(1-imix) + achorusr*imix

    outs aoutl*0.7, aoutr*0.7
endin

; Chorus with random direction LFO (more organic movement)
instr 2
    iamp = p4
    idelay = p5/1000
    idepth = p6/1000
    irate = p7/sr/0.25
    imix = p8
    imax = idelay + idepth*2 + 0.1

    asig oscili iamp, cpspch(p9), 1

    ; Random direction triangle ramp
    kramp init 0.5
    iseed = rnd(1)
    krnd randi 1, p7*2, iseed

    if krnd > 0 goto up
    kramp = kramp + irate
    goto done
up:
    kramp = kramp - irate
done:
    klfo mirror kramp, 0, 1

    ; Convert to audio rate for smooth delay modulation
    alfo1 upsamp klfo
    alfo2 = 1 - alfo1

    ; Two complementary chorus voices
    achor1 vdelay3 asig, (alfo1*idepth + idelay)*1000, imax*1000
    achor2 vdelay3 asig, (alfo2*idepth + idelay)*1000, imax*1000

    aoutl = asig*imix + achor1*(1-imix)
    aoutr = asig*imix + achor2*(1-imix)

    outs aoutl, aoutr
endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1   ; sine

; Standard multi-voice chorus
;       amp  delay depth rate mix  pitch
i1 0 4  0.5  25    5     0.5  0.5  8.00
i1 5 4  0.5  25    5     0.5  0.5  8.04
i1 10 4 0.5  25    5     0.5  0.5  8.07

; Random direction chorus (more organic)
i2 15 4 0.5  20    8     0.3  0.5  8.00
i2 20 4 0.5  20    8     0.3  0.5  8.04
e
</CsScore>
</CsoundSynthesizer>
```

### Example 3: Phaser Effect
Using Csound's phaser1 opcode for classic phasing effects.

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

; Basic phaser using phaser1
instr 1
    iamp = p4
    ifreq = p5            ; base frequency of all-pass filters
    idepth = p6           ; LFO depth (frequency range)
    irate = p7            ; LFO rate
    ifdbk = p8            ; feedback (0-1)
    istages = p9          ; number of all-pass stages (4, 6, 8 typical)
    imix = p10            ; wet/dry mix

    ; Input signal - rich harmonic content works best
    asig vco2 iamp, 110, 10  ; sawtooth

    ; LFO for filter frequency sweep
    klfo oscili idepth/2, irate, 1
    klfo = klfo + ifreq + idepth/2

    ; phaser1: input, freq, stages, feedback
    aphase phaser1 asig, klfo, istages, ifdbk

    ; Mix wet/dry for notch effect
    aout = asig*(1-imix) + aphase*imix

    ; Envelope
    aenv linseg 0, 0.01, 1, p3-0.02, 1, 0.01, 0

    outs aout*aenv, aout*aenv
endin

; Stereo phaser with offset LFOs
instr 2
    iamp = p4
    ifreq = p5
    idepth = p6
    irate = p7
    ifdbk = p8
    istages = p9
    imix = p10

    asig vco2 iamp, cpspch(p11), 10

    ; Stereo LFOs with phase offset
    klfo1 oscili idepth/2, irate, 1, 0
    klfo2 oscili idepth/2, irate, 1, 0.5

    klfo1 = klfo1 + ifreq + idepth/2
    klfo2 = klfo2 + ifreq + idepth/2

    aphaseL phaser1 asig, klfo1, istages, ifdbk
    aphaseR phaser1 asig, klfo2, istages, ifdbk

    aoutL = asig*(1-imix) + aphaseL*imix
    aoutR = asig*(1-imix) + aphaseR*imix

    aenv linseg 0, 0.01, 1, p3-0.02, 1, 0.01, 0

    outs aoutL*aenv, aoutR*aenv
endin

; Phaser2 - second-order all-pass filters for deeper effect
instr 3
    iamp = p4
    ifreq = p5
    iq = p6               ; Q factor of filters
    istages = p7
    imix = p8

    asig vco2 iamp, 110, 10

    ; Sweep parameters
    kfreq oscili 500, 0.3, 1
    kfreq = kfreq + 800

    ; phaser2: input, freq, Q, stages, mode, sep, fbgain
    ; mode 1 = first order, mode 2 = second order
    aphase phaser2 asig, kfreq, iq, istages, 2, 1.5, 0.7

    aout = asig*(1-imix) + aphase*imix
    aenv linseg 0, 0.01, 1, p3-0.02, 1, 0.01, 0

    outs aout*aenv, aout*aenv
endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1   ; sine

; Basic phaser
;       amp  freq  depth rate  fdbk stages mix
i1 0 4  0.4  400   600   0.5   0.7  6      0.5
i1 5 4  0.4  200   1000  0.3   0.8  8      0.6
i1 10 4 0.4  800   400   1.0   0.5  4      0.5

; Stereo phaser
;       amp  freq  depth rate  fdbk stages mix  pitch
i2 15 4 0.4  400   600   0.4   0.7  6      0.5  7.00
i2 20 4 0.4  400   600   0.4   0.7  6      0.5  7.07

; Phaser2 with Q control
;       amp  freq  Q    stages mix
i3 25 4 0.4  800   0.9  6      0.6
e
</CsScore>
</CsoundSynthesizer>
```

### Example 4: Manual Flanger Implementation
Building a flanger from scratch using delay lines for educational purposes.

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

; Manual flanger using delayr/deltapi
instr 1
    iamp = p4
    ibase = p5/1000       ; base delay in ms
    idepth = p6/1000      ; modulation depth in ms
    irate = p7            ; LFO rate
    ifdbk = p8            ; feedback
    imix = p9

    ; Maximum delay
    imaxdel = ibase + idepth*2 + 0.01

    ; Source
    asig vco2 iamp, 110, 10

    ; Feedback signal initialization
    afdbk init 0

    ; LFO
    alfo oscili idepth, irate, 2   ; triangle
    adeltime = alfo + ibase + idepth

    ; Delay line with feedback
    abuf delayr imaxdel
    atap deltapi adeltime
    delayw asig + afdbk*ifdbk

    ; Store for next iteration
    afdbk = atap

    ; Mix
    aout = asig*(1-imix) + atap*imix

    aenv linseg 0, 0.01, 1, p3-0.02, 1, 0.01, 0
    outs aout*aenv, aout*aenv
endin

; Cross-coupled stereo flanger (through-zero flanging)
instr 2
    iamp = p4
    ibase = p5/1000
    idepth = p6/1000
    irate = p7
    ifdbk = p8
    imix = p9
    imaxdel = ibase + idepth*2 + 0.01

    asig vco2 iamp, 110, 10

    ; Initialize feedback
    afdbkL init 0
    afdbkR init 0

    ; Opposite-phase LFOs for through-zero effect
    alfoL oscili idepth, irate, 2, 0
    alfoR oscili idepth, irate, 2, 0.5

    adeltimeL = alfoL + ibase + idepth
    adeltimeR = alfoR + ibase + idepth

    ; Left delay with right feedback (cross-coupled)
    abufL delayr imaxdel
    atapL deltapi adeltimeL
    delayw asig + afdbkR*ifdbk

    ; Right delay with left feedback
    abufR delayr imaxdel
    atapR deltapi adeltimeR
    delayw asig + afdbkL*ifdbk

    afdbkL = atapL
    afdbkR = atapR

    aoutL = asig*(1-imix) + atapL*imix
    aoutR = asig*(1-imix) + atapR*imix

    aenv linseg 0, 0.01, 1, p3-0.02, 1, 0.01, 0
    outs aoutL*aenv, aoutR*aenv
endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1                  ; sine
f2 0 8192 7 -1 4096 1 4096 -1   ; triangle

; Manual flanger
;       amp  base  depth rate  fdbk mix
i1 0 5  0.4  0.5   5     0.5   0.7  0.5
i1 6 5  0.4  0.25  8     0.3   0.9  0.6

; Cross-coupled stereo flanger
i2 12 5 0.4  0.5   5     0.4   0.6  0.5
e
</CsScore>
</CsoundSynthesizer>
```

### Example 5: Combined Effects Chain
Routing signal through multiple modulation effects.

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

zakinit 10, 10

; Sound source -> zak bus
instr 1
    iamp = p4
    icps = cpspch(p5)

    asig vco2 iamp, icps, 10

    aenv adsr 0.01, 0.1, 0.7, 0.2
    zaw asig*aenv, 1
endin

; Phaser effect
instr 10
    imix = p4
    ain zar 1

    klfo oscili 500, 0.4, 1
    klfo = klfo + 600

    aphase phaser1 ain, klfo, 6, 0.7
    aout = ain*(1-imix) + aphase*imix

    zaw aout, 2
endin

; Chorus effect
instr 20
    imix = p4
    idelay = 25/1000
    idepth = 5/1000
    imax = idelay + idepth*2 + 0.1

    ain zar 2

    klfo1 oscili idepth, 0.8, 1, 0
    klfo2 oscili idepth, 0.9, 1, 0.33
    klfo3 oscili idepth, 0.7, 1, 0.66

    achor1 vdelay3 ain, (idelay + klfo1)*1000, imax*1000
    achor2 vdelay3 ain, (idelay*1.1 + klfo2)*1000, imax*1000
    achor3 vdelay3 ain, (idelay*0.9 + klfo3)*1000, imax*1000

    achorusL = achor1*0.5 + achor2*0.3 + achor3*0.2
    achorusR = achor1*0.2 + achor2*0.5 + achor3*0.3

    aoutL = ain*(1-imix) + achorusL*imix
    aoutR = ain*(1-imix) + achorusR*imix

    zaw aoutL, 3
    zaw aoutR, 4
endin

; Flanger effect
instr 30
    imix = p4
    idelay = 1/1000
    idepth = 3/1000
    imax = idelay + idepth*2 + 0.01

    ainL zar 3
    ainR zar 4

    klfo1 oscili idepth, 0.3, 2, 0
    klfo2 oscili idepth, 0.3, 2, 0.5

    aflngL flanger ainL, klfo1 + idelay + idepth, 0.6, imax
    aflngR flanger ainR, klfo2 + idelay + idepth, 0.6, imax

    aoutL = ainL*(1-imix) + aflngL*imix
    aoutR = ainR*(1-imix) + aflngR*imix

    zaw aoutL, 5
    zaw aoutR, 6
endin

; Output mixer
instr 99
    igain = p4

    aL zar 5
    aR zar 6

    ; Declick
    kenv linseg 0, 0.01, 1, p3-0.02, 1, 0.01, 0

    outs aL*igain*kenv, aR*igain*kenv
    zacl 0, 10
endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1                  ; sine
f2 0 8192 7 -1 4096 1 4096 -1   ; triangle

; Notes
i1 0   2 0.4 7.00
i1 2   2 0.4 7.04
i1 4   2 0.4 7.07
i1 6   2 0.4 8.00

; Effects chain (runs entire duration)
;           mix
i10 0 8    0.5    ; phaser
i20 0 8    0.4    ; chorus
i30 0 8    0.3    ; flanger
i99 0 8    0.8    ; output
e
</CsScore>
</CsoundSynthesizer>
```

### Example 6: Animated Parameter Modulation
Effects with dynamically changing parameters for evolving textures.

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

; Flanger with evolving parameters
instr 1
    iamp = p4

    asig vco2 iamp, 110, 10

    ; Evolving parameters
    krate linseg 0.1, p3/2, 2.0, p3/2, 0.1
    kdepth linseg 1, p3/3, 8, p3/3, 3, p3/3, 1
    kfdbk linseg 0.3, p3, 0.9

    idelay = 0.5/1000
    imax = 0.02

    klfo oscili kdepth/1000, krate, 1
    klfo = klfo + idelay + kdepth/2000

    aflng flanger asig, klfo, kfdbk, imax
    aout = asig*0.5 + aflng*0.5

    aenv linseg 0, 0.02, 1, p3-0.04, 1, 0.02, 0
    outs aout*aenv, aout*aenv
endin

; Phaser with frequency tracking envelope
instr 2
    iamp = p4
    icps = cpspch(p5)

    asig vco2 iamp, icps, 10

    ; Phaser frequency follows note pitch
    kbase = icps * 2
    klfo oscili kbase/2, 0.5, 1
    kfreq = kbase + klfo

    ; Stages increase over time for evolving character
    kstages linseg 2, p3, 12

    ; Use integer stages
    istages = 6

    aphase phaser1 asig, kfreq, istages, 0.7
    aout = asig*0.4 + aphase*0.6

    aenv adsr 0.01, 0.1, 0.7, 0.3
    outs aout*aenv, aout*aenv
endin

; Chorus that builds density over time
instr 3
    iamp = p4
    icps = cpspch(p5)

    asig vco2 iamp, icps, 10

    ; Start with 1 voice, build to full chorus
    kmix linseg 0, p3*0.3, 0, p3*0.7, 1

    idelay = 25/1000
    idepth = 5/1000
    imax = 0.1

    ; 4 chorus voices
    klfo1 oscili idepth, 0.7, 1, 0
    klfo2 oscili idepth, 0.8, 1, 0.25
    klfo3 oscili idepth, 0.9, 1, 0.5
    klfo4 oscili idepth, 1.0, 1, 0.75

    achor1 vdelay3 asig, (idelay + klfo1)*1000, imax*1000
    achor2 vdelay3 asig, (idelay*1.05 + klfo2)*1000, imax*1000
    achor3 vdelay3 asig, (idelay*0.95 + klfo3)*1000, imax*1000
    achor4 vdelay3 asig, (idelay*1.1 + klfo4)*1000, imax*1000

    achorus = (achor1 + achor2 + achor3 + achor4) * 0.25
    aout = asig*(1-kmix) + achorus*kmix

    aenv adsr 0.01, 0.1, 0.8, 0.5
    outs aout*aenv, aout*aenv
endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1   ; sine

; Evolving flanger
i1 0 8 0.4

; Pitch-tracking phaser
i2 10 3 0.4 7.00
i2 13 3 0.4 7.04
i2 16 3 0.4 7.07

; Building chorus
i3 20 6 0.4 8.00
e
</CsScore>
</CsoundSynthesizer>
```

## Key Parameters

### Flanger Parameters
| Parameter | Typical Range | Effect |
|-----------|---------------|--------|
| Base Delay | 0.1-5ms | Higher = more pronounced comb filtering |
| Depth | 0.1-10ms | Sweep range of the effect |
| Rate | 0.1-5 Hz | Speed of sweep |
| Feedback | -0.99 to 0.99 | Negative = through-zero, positive = resonant |

### Chorus Parameters
| Parameter | Typical Range | Effect |
|-----------|---------------|--------|
| Base Delay | 15-50ms | Longer = more separation from dry |
| Depth | 1-10ms | Amount of pitch variation |
| Rate | 0.1-3 Hz | Speed of modulation |
| Voices | 2-6 | More = thicker ensemble |

### Phaser Parameters
| Parameter | Typical Range | Effect |
|-----------|---------------|--------|
| Base Freq | 100-2000 Hz | Center of sweep |
| Depth | 100-2000 Hz | Range of sweep |
| Rate | 0.1-2 Hz | Speed of sweep |
| Stages | 4-12 | More = deeper notches |
| Feedback | 0-0.95 | Resonance at notches |

## LFO Waveforms

Different waveforms create different sweep characters:

```csound
; Sine - smooth, classic sound
f1 0 8192 10 1

; Triangle - linear sweep, more aggressive
f2 0 8192 7 -1 4096 1 4096 -1

; Exponential - fast attack, slow decay
f3 0 8192 5 0.001 4096 1 4096 0.001

; Random/Sample-hold - stepped, robotic
; Use randh or randi opcodes instead
```

## Tips and Best Practices

1. **Source Material**: These effects work best on harmonically rich sources (sawtooth, strings, guitars)

2. **Feedback Caution**: High feedback can cause instability - keep below 0.95

3. **CPU Efficiency**: Use `flanger` opcode instead of manual implementation when possible

4. **Stereo Width**: Offset LFO phases between channels for wider stereo image

5. **Mix Levels**: Start with 50% wet/dry mix and adjust to taste

6. **Avoiding Mudiness**: Use highpass filter before chorus to prevent bass buildup

7. **Combining Effects**: Order matters - typically phaser -> chorus -> flanger in chain

## Related Opcodes

- `flanger` - Built-in flanger with interpolating delay
- `phaser1` - First-order all-pass phaser
- `phaser2` - Second-order all-pass phaser with Q control
- `vdelay`, `vdelay3` - Variable delay lines (vdelay3 = cubic interpolation)
- `deltapi` - Interpolating delay tap
- `delayr`, `delayw` - Delay line read/write
- `oscili`, `lfo` - LFO generation
- `mirror` - Keep LFO in range
