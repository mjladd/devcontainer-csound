# Csound Reverb Design

## Metadata
- **Category**: Effects / Reverb
- **Difficulty**: Intermediate to Advanced
- **Tags**: reverb, comb filter, allpass, Schroeder, FDN, room simulation, spatial effects
- **Opcodes**: `comb`, `alpass`, `reverb`, `reverb2`, `delay`, `vdelay3`, `butterlp`, `butterhp`, `butterbp`, `pareq`

## Description

Reverb is essential for creating realistic acoustic spaces in digital audio. This entry covers reverb design from basic building blocks (comb and allpass filters) to complete algorithmic reverb implementations including the classic Schroeder reverb, William Gardner's nested allpass designs, and Feedback Delay Network (FDN) reverbs.

Reverb design in Csound involves understanding:
- **Comb filters**: Create the initial density and decay characteristics
- **Allpass filters**: Add diffusion without changing frequency response
- **Nested allpass filters**: Create more complex, natural-sounding diffusion
- **Feedback networks**: Allow multiple delay paths to interact
- **Pre/post filtering**: Shape the frequency content of the reverb tail

## Example 1: Classic Schroeder Reverb

The Schroeder reverb (1962) uses parallel comb filters feeding into series allpass filters. This is the foundation of most digital reverb algorithms.

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

; Global reverb send
ga_reverb_send  init  0

;---------------------------------------------------------------------------
; Sound source instrument
;---------------------------------------------------------------------------
instr 1
    iamp      = p4
    ifreq     = cpspch(p5)
    isend     = p6          ; Reverb send amount (0-1)

    ; Simple tone with envelope
    kenv      linen     iamp, 0.01, p3, 0.1
    asig      vco2      kenv, ifreq, 0
    asig      butterlp  asig, 2000

    ; Direct output (dry)
    outs      asig * (1 - isend), asig * (1 - isend)

    ; Send to reverb
    ga_reverb_send = ga_reverb_send + asig * isend
endin

;---------------------------------------------------------------------------
; Schroeder Reverb
; Classic design: 6 parallel comb filters -> 5 series allpass filters
;---------------------------------------------------------------------------
instr 99
    irevtime  = p4          ; Reverb time in seconds
    iwet      = p5          ; Wet level

    ain       = ga_reverb_send

    ; 6 parallel comb filters with prime-related delay times
    ; Delay times chosen to avoid flutter echoes
    ; Loop time = samples / sr, scaled for room size
    a1        comb      ain, irevtime, 1237./sr  ; ~28ms
    a2        comb      ain, irevtime, 1381./sr  ; ~31ms
    a3        comb      ain, irevtime, 1607./sr  ; ~36ms
    a4        comb      ain, irevtime, 1777./sr  ; ~40ms
    a5        comb      ain, irevtime, 1949./sr  ; ~44ms
    a6        comb      ain, irevtime, 2063./sr  ; ~47ms

    ; Sum the comb outputs
    asum      = a1 + a2 + a3 + a4 + a5 + a6

    ; 5 series allpass filters for diffusion
    ; Shorter delay times, moderate gain (~0.7)
    igain     = 0.7
    aa1       alpass    asum, igain * irevtime, 307./sr   ; ~7ms
    aa2       alpass    aa1,  igain * irevtime, 97./sr    ; ~2ms
    aa3       alpass    aa2,  igain * irevtime, 71./sr    ; ~1.6ms
    aa4       alpass    aa3,  igain * irevtime, 53./sr    ; ~1.2ms
    aa5       alpass    aa4,  igain * irevtime, 37./sr    ; ~0.8ms

    ; High-frequency damping (natural rooms absorb highs)
    aout      butterlp  aa5, 8000

    ; Stereo output with slight decorrelation
    aoutL     delay     aout, 0.001
    aoutR     delay     aout, 0.0013

    outs      aoutL * iwet, aoutR * iwet

    ; Clear the global
    ga_reverb_send = 0
endin

</CsInstruments>
<CsScore>
f0 10

; Sound source with reverb send
;    start  dur  amp   pitch   send
i1   0      0.5  0.3   8.00    0.4
i1   0.5    0.5  0.3   8.04    0.4
i1   1.0    0.5  0.3   8.07    0.4
i1   1.5    2.0  0.3   9.00    0.5

; Reverb processor (runs entire piece)
;     start dur  revtime  wet
i99   0     8    2.5      0.5

</CsScore>
</CsoundSynthesizer>
```

### Explanation

**Comb Filter Basics:**
The `comb` opcode creates a recirculating delay with feedback:
```
aout  comb  ain, krvt, ilpt [, istor]
```
- `krvt`: Reverb time - time for signal to decay 60dB
- `ilpt`: Loop time in seconds (determines comb frequency = 1/ilpt)

**Why Prime-Related Delay Times?**
The delay times (1237, 1381, 1607, 1777, 1949, 2063 samples) are chosen to be:
1. Mutually prime (no common factors)
2. Spread across a range to fill the frequency spectrum
3. Long enough to avoid obvious flutter echoes

**Allpass Filter Function:**
The `alpass` opcode passes all frequencies equally but adds phase shift:
```
aout  alpass  ain, krvt, ilpt [, istor]
```
The allpass section "smears" the discrete echoes from the comb filters into a smooth decay.

## Example 2: Nested Allpass Reverb (Gardner-Style)

William Gardner's nested allpass design creates denser, more natural reverbs by placing allpass filters inside other allpass filters.

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

ga_send   init  0

;---------------------------------------------------------------------------
; Sound source
;---------------------------------------------------------------------------
instr 1
    iamp      = p4
    ifreq     = cpspch(p5)
    isend     = p6

    kenv      linen     iamp, 0.01, p3, 0.05
    asig      pluck     kenv, ifreq, ifreq, 0, 1

    outs      asig * (1-isend), asig * (1-isend)
    ga_send   = ga_send + asig * isend
endin

;---------------------------------------------------------------------------
; Simple Allpass Filter (building block)
; Manual implementation showing the structure
;---------------------------------------------------------------------------
opcode SimpleAllpass, a, aki
    ain, kgain, itime   xin

    adel      init      0

    aout      = adel - kgain * ain         ; Feed forward
    adel      delay     ain + kgain * aout, itime   ; Feedback

    xout      aout
endop

;---------------------------------------------------------------------------
; Single Nested Allpass
; An allpass inside another allpass
;---------------------------------------------------------------------------
opcode NestedAllpass1, a, akiki
    ain, kgain1, itime1, kgain2, itime2   xin

    adel1     init      0
    adel2     init      0

    ; Inner allpass (nested inside the delay of outer)
    asum      = adel2 - kgain2 * adel1     ; Inner feed forward

    ; Outer allpass
    aout      = asum - kgain1 * ain        ; Outer feed forward

    ; Outer feedback (this is where inner allpass sits)
    adel1     delay     ain + kgain1 * aout, itime1 - itime2

    ; Inner feedback
    adel2     delay     adel1 + kgain2 * asum, itime2

    xout      aout
endop

;---------------------------------------------------------------------------
; Double Nested Allpass
; Two inner allpasses in series inside an outer allpass
;---------------------------------------------------------------------------
opcode NestedAllpass2, a, akikiki
    ain, kgain1, itime1, kgain2, itime2, kgain3, itime3   xin

    adel1     init      0
    adel2     init      0
    adel3     init      0

    ; First inner allpass feed forward
    asum1     = adel2 - kgain2 * adel1

    ; Second inner allpass feed forward
    asum2     = adel3 - kgain3 * asum1

    ; Outer allpass feed forward
    aout      = asum2 - kgain1 * ain

    ; Outer feedback
    adel1     delay     ain + kgain1 * aout, itime1 - itime2 - itime3

    ; First inner feedback
    adel2     delay     adel1 + kgain2 * asum1, itime2

    ; Second inner feedback
    adel3     delay     asum1 + kgain3 * asum2, itime3

    xout      aout
endop

;---------------------------------------------------------------------------
; Medium Room Reverb using nested allpass filters
;---------------------------------------------------------------------------
instr 99
    iamp      = p4
    idecay    = p5          ; Decay multiplier
    idense    = p6          ; Density (feedback amount)

    ; Initialize feedback paths
    aout61    init      0
    adel71    init      0

    ; Read input
    asig      = ga_send

    ; Pre-filter (remove extreme highs and lows)
    aflt01    butterlp  asig, 6000
    aflt01    butterhp  aflt01, 100

    ; Feedback filter (high frequencies decay faster in real rooms)
    aflt02    butterbp  0.4 * adel71 * idense, 1000, 500

    ; Initial mix
    asum01    = aflt01 + 0.5 * aflt02

    ; Double nested allpass (main diffusion)
    aout11    NestedAllpass2  asum01, 0.25*idense, 0.035*idecay, \
                              0.35*idense, 0.0083*idecay, 0.45*idense, 0.022*idecay

    ; Simple delay
    adel21    delay     aout11, 0.005 * idecay

    ; Single allpass
    asub31    SimpleAllpass  adel21, 0.45 * idense, 0.030 * idecay

    ; More delays
    adel41    delay     asub31, 0.067 * idecay
    adel51    delay     0.4 * adel41, 0.015 * idecay
    aout51    = aflt01 + adel41

    ; Final nested allpass
    aout61    NestedAllpass1  aout51, 0.25*idense, 0.0292*idecay, \
                              0.35*idense, 0.0098*idecay

    ; Combine outputs for stereo
    aout      = 0.5 * aout11 + 0.5 * adel41 + 0.5 * aout61

    ; Feedback path delay
    adel71    delay     aout61, 0.108 * idecay

    ; Click protection
    kclick    linseg    0, 0.002, iamp, p3-0.004, iamp, 0.002, 0

    ; Stereo output (invert one side for spaciousness)
    outs      aout * kclick, -aout * kclick

    ga_send   = 0
endin

</CsInstruments>
<CsScore>
f0 10

;     start  dur  amp   pitch  send
i1    0      0.1  0.5   8.00   0.6
i1    0.3    0.1  0.5   8.04   0.6
i1    0.6    0.1  0.5   8.07   0.6
i1    0.9    0.5  0.5   9.00   0.7

;     start  dur   amp   decay  density
i99   0      8     0.6   1.0    0.8

</CsScore>
</CsoundSynthesizer>
```

### Explanation

**Nested Allpass Structure:**
A nested allpass places one or more allpass filters inside the feedback loop of another. This creates more complex, natural-sounding diffusion patterns.

```
Simple Allpass:
    ain -> [delay + feedback] -> aout

Nested Allpass:
    ain -> [delay -> [inner allpass] -> feedback] -> aout
```

**Key Parameters:**
- `idecay`: Scales all delay times (larger = longer reverb)
- `idense`: Feedback amount (higher = more resonance, but watch for instability)

**Stereo Trick:**
Inverting one channel (`-aout`) creates a pseudo-stereo effect where the sound seems to come from all around. Note: this may cause issues with some surround systems.

## Example 3: Feedback Delay Network (FDN) Reverb

FDN reverbs use multiple delays with a feedback matrix that mixes all outputs back to all inputs. This creates very dense, smooth reverbs.

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

ga_send   init  0

;---------------------------------------------------------------------------
; Sound source - noise burst for testing reverb decay
;---------------------------------------------------------------------------
instr 1
    idur      = p3
    iamp      = p4
    isend     = p5

    ; Short noise burst
    kamp      linseg    0, 0.002, iamp, 0.01, 0, idur-0.012, 0
    asig      rand      kamp
    asig      butterlp  asig, 8000

    outs      asig * (1-isend), asig * (1-isend)
    ga_send   = ga_send + asig * isend
endin

;---------------------------------------------------------------------------
; Pitched source
;---------------------------------------------------------------------------
instr 2
    iamp      = p4
    ifreq     = cpspch(p5)
    isend     = p6

    kenv      linen     iamp, 0.01, p3, 0.1
    asig      vco2      kenv, ifreq, 2    ; Sawtooth
    asig      moogladder asig, 3000, 0.3

    outs      asig * (1-isend), asig * (1-isend)
    ga_send   = ga_send + asig * isend
endin

;---------------------------------------------------------------------------
; 4-Delay FDN Reverb
;---------------------------------------------------------------------------
instr 99
    iamp      = p4
    itime     = p5          ; Base delay time in ms
    idens     = p6          ; Density/feedback amount
    ifc       = p7          ; Filter coefficient (0.5 = high cut)
    ipfco     = p8          ; Pre-filter cutoff

    ; Feedback state
    a1        init      0
    a2        init      0
    a3        init      0
    a4        init      0

    ; Randomize delay times based on base time
    itim1     = rnd(itime * 0.75) + itime
    itim2     = rnd(itime * 0.75) + itime
    itim3     = rnd(itime * 0.75) + itime
    itim4     = rnd(itime * 0.75) + itime

    ; Modulation to prevent ringing (very slow, subtle)
    at1       oscil     itim1 * 0.05, 0.50, 1, 0.1
    at2       oscil     itim2 * 0.05, 0.56, 1, 0.7
    at3       oscil     itim3 * 0.05, 0.54, 1, 0.3
    at4       oscil     itim4 * 0.05, 0.51, 1, 0.9

    atim1     = itim1 + at1 + 20
    atim2     = itim2 + at2 + 20
    atim3     = itim3 + at3 + 20
    atim4     = itim4 + at4 + 20

    ; Feedback matrix (Hadamard-like)
    ; Signs chosen to ensure energy conservation
    ig11      = 0.45 * idens
    ig12      = 0.33 * idens
    ig13      = -0.31 * idens
    ig14      = -0.29 * idens

    ig21      = -0.32 * idens
    ig22      = -0.35 * idens
    ig23      = 0.36 * idens
    ig24      = 0.26 * idens

    ig31      = 0.31 * idens
    ig32      = 0.35 * idens
    ig33      = 0.37 * idens
    ig34      = -0.32 * idens

    ig41      = -0.33 * idens
    ig42      = -0.32 * idens
    ig43      = -0.35 * idens
    ig44      = 0.37 * idens

    ; High shelf filter settings
    iq        = sqrt(0.5)
    ifc1      = 5000 * ifc
    ifc2      = 5200 * ifc
    ifc3      = 5400 * ifc
    ifc4      = 5300 * ifc

    ; Read and pre-filter input
    asig1     = ga_send
    asig      butterlp  asig1, ipfco

    ; FDN core: variable delays with cross-feedback
    aa1       vdelay3   asig + ig11*a1 + ig12*a2 + ig13*a3 + ig14*a4, atim1, 1000
    aa2       vdelay3   asig + ig21*a1 + ig22*a2 + ig23*a3 + ig24*a4, atim2, 1000
    aa3       vdelay3   asig + ig31*a1 + ig32*a2 + ig33*a3 + ig34*a4, atim3, 1000
    aa4       vdelay3   asig + ig41*a1 + ig42*a2 + ig43*a3 + ig44*a4, atim4, 1000

    ; High shelf filters (simulate air absorption)
    ; pareq mode 2 = high shelf, iv < 1 means cut
    a1        pareq     aa1, ifc1, 0.5, iq, 2
    a2        pareq     aa2, ifc2, 0.5, iq, 2
    a3        pareq     aa3, ifc3, 0.5, iq, 2
    a4        pareq     aa4, ifc4, 0.5, iq, 2

    ; Mix and remove DC
    aout      butterhp  (a1 + a2 + a3 + a4) * iamp, 20

    ; Stereo decorrelation
    aoutL     = a1 + a3
    aoutR     = a2 + a4

    outs      aoutL * iamp, aoutR * iamp

    ga_send   = 0
endin

</CsInstruments>
<CsScore>
f1 0 65536 10 1   ; Sine for modulation

; Impulse test
;     start  dur   amp   send
i1    0      0.1   0.8   0.9

; Musical test
;     start  dur   amp   pitch  send
i2    1      0.5   0.4   7.00   0.5
i2    1.5    0.5   0.4   7.04   0.5
i2    2      0.5   0.4   7.07   0.5
i2    2.5    1.0   0.4   8.00   0.6

; FDN Reverb
;     start  dur   amp   time  dens  fc    prefco
i99   0      6     0.4   30    0.8   0.8   4000

</CsScore>
</CsoundSynthesizer>
```

### Explanation

**FDN Structure:**
```
Input -> [Delay 1] -> [Filter] --\
      -> [Delay 2] -> [Filter] ---+-> Matrix -> Mix with input
      -> [Delay 3] -> [Filter] --/    (feedback to all delays)
      -> [Delay 4] -> [Filter] -/
```

**Feedback Matrix:**
The matrix coefficients mix outputs back to inputs. For stability:
- Row sums and column sums should be less than 1
- Mixed signs create more natural diffusion
- Hadamard or householder matrices are commonly used

**Modulated Delays:**
Slow LFO modulation on delay times (`vdelay3`) prevents metallic ringing:
```csound
at1   oscil   itim1 * 0.05, 0.50, 1, 0.1
```
The modulation depth (5%) and rate (0.5 Hz) are subtle enough to avoid pitch shifting.

## Example 4: Room Size Variations

Different room sizes require different parameter tuning.

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

ga_send   init  0

;---------------------------------------------------------------------------
; Test sound
;---------------------------------------------------------------------------
instr 1
    iamp      = p4
    ifreq     = cpspch(p5)
    isend     = p6

    kenv      expon     iamp, p3, 0.001
    asig      pluck     kenv, ifreq, ifreq, 0, 1

    outs      asig * (1-isend), asig * (1-isend)
    ga_send   = ga_send + asig * isend
endin

;---------------------------------------------------------------------------
; Configurable Room Reverb
; p4 = amp, p5 = room size (0.5=small, 1=medium, 2=large)
; p6 = brightness (0-1), p7 = density
;---------------------------------------------------------------------------
instr 99
    iamp      = p4
    isize     = p5          ; Room size multiplier
    ibright   = p6          ; High frequency retention
    idense    = p7          ; Density/feedback

    ; Feedback state
    aout_prev init      0
    adel1     init      0
    adel2     init      0
    adel3     init      0
    adel4     init      0
    adel5     init      0
    adel6     init      0

    ; Pre-filter based on room size and brightness
    ipreflt   = 4000 + ibright * 8000       ; 4-12 kHz
    ifbflt    = 1000 + ibright * 4000       ; 1-5 kHz (feedback)

    ; Read and filter input
    asig      = ga_send
    aflt      butterlp  asig, ipreflt
    aflt      butterhp  aflt, 80

    ; Feedback path (filtered to simulate air absorption)
    afb       butterlp  aout_prev * idense, ifbflt

    ; Mix input with feedback
    amix      = aflt + 0.4 * afb

    ; Comb filter bank (scaled by room size)
    ; Base times in ms, scaled by isize
    a1        comb      amix, 2.0 * isize, 0.030 * isize
    a2        comb      amix, 2.0 * isize, 0.034 * isize
    a3        comb      amix, 2.0 * isize, 0.039 * isize
    a4        comb      amix, 2.0 * isize, 0.043 * isize

    asum      = a1 + a2 + a3 + a4

    ; Allpass diffusion (also scaled)
    aa1       alpass    asum, 1.5 * isize, 0.0051 * isize
    aa2       alpass    aa1,  1.5 * isize, 0.0077 * isize

    ; Store for feedback
    aout_prev = aa2

    ; Output filtering
    aout      butterlp  aa2, ipreflt * 0.8
    aout      butterhp  aout, 60

    ; Stereo spread
    kpan      oscil     0.3, 0.1, 1
    aoutL     = aout * (0.5 + kpan)
    aoutR     = aout * (0.5 - kpan)

    outs      aoutL * iamp, aoutR * iamp

    ga_send   = 0
endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1

; === Small Room (bathroom, closet) ===
;     start  dur  amp   pitch  send
i1    0      0.3  0.5   8.00   0.5
i1    0.3    0.3  0.5   8.07   0.5
i1    0.6    0.5  0.5   9.00   0.6
;     start  dur   amp   size  bright  dens
i99   0      3     0.6   0.5   0.8     0.6
s

; === Medium Room (living room) ===
i1    0      0.3  0.5   8.00   0.5
i1    0.3    0.3  0.5   8.07   0.5
i1    0.6    0.5  0.5   9.00   0.6
i99   0      4     0.5   1.0   0.6     0.7
s

; === Large Room (hall) ===
i1    0      0.3  0.5   8.00   0.5
i1    0.3    0.3  0.5   8.07   0.5
i1    0.6    0.5  0.5   9.00   0.6
i99   0      6     0.4   2.0   0.4     0.8
s

; === Cathedral ===
i1    0      0.3  0.5   8.00   0.6
i1    0.3    0.3  0.5   8.07   0.6
i1    0.6    0.5  0.5   9.00   0.7
i99   0      10    0.3   3.5   0.3     0.9

</CsScore>
</CsoundSynthesizer>
```

### Room Size Guidelines

| Room Type | Size Mult | Brightness | Density | Decay Time |
|-----------|-----------|------------|---------|------------|
| Bathroom  | 0.3-0.5   | 0.8-1.0    | 0.5     | 0.3-0.5s   |
| Bedroom   | 0.6-0.8   | 0.6-0.8    | 0.6     | 0.4-0.7s   |
| Living    | 1.0       | 0.5-0.7    | 0.7     | 0.6-1.0s   |
| Concert   | 2.0-3.0   | 0.3-0.5    | 0.8     | 1.5-2.5s   |
| Cathedral | 3.0-5.0   | 0.2-0.4    | 0.9     | 3.0-6.0s   |

## Variations

### Built-in Reverb Opcodes
Csound provides simpler reverb opcodes for quick results:

```csound
; Basic reverb
aout  reverb  ain, irevtime

; Stereo reverb with more control
aoutL, aoutR  reverbsc  ainL, ainR, kfeedback, kfco

; Freeverb algorithm
aoutL, aoutR  freeverb  ainL, ainR, kRoomSize, kHFDamp
```

### Early Reflections
Add early reflections before the reverb tail:

```csound
; Early reflection tap delays
aer1    delay   ain, 0.013
aer2    delay   ain, 0.019
aer3    delay   ain, 0.031
aer4    delay   ain, 0.043
aearly  = 0.8*aer1 + 0.6*aer2 + 0.4*aer3 + 0.3*aer4

; Feed to late reverb
alate   reverb  aearly + ain*0.5, 2.0
aout    = aearly*0.4 + alate*0.6
```

### Convolution Reverb
For realistic spaces, use convolution with impulse responses:

```csound
; Load impulse response
iir     ftgen   0, 0, 0, 1, "hall_ir.wav", 0, 0, 0

; Convolve
aout    pconvolve  ain, iir
```

## Common Issues and Solutions

### 1. Metallic Ringing
**Problem**: Reverb sounds metallic or "springy"
**Solution**:
- Use more comb/delay lines with prime-related times
- Add subtle delay time modulation
- Increase feedback matrix complexity

### 2. Reverb Too Dark/Bright
**Problem**: Frequency balance is wrong
**Solution**:
```csound
; Adjust pre-filter cutoff
aflt  butterlp  ain, 8000   ; Brighter input = brighter reverb

; Adjust feedback filter
afb   butterlp  afeedback, 3000  ; Lower = darker tail
```

### 3. Unstable/Exploding Feedback
**Problem**: Signal grows without bound
**Solution**:
- Ensure feedback coefficients sum to less than 1
- Add limiting: `aout limit aout, -1, 1`
- Reduce density parameter

### 4. DC Buildup
**Problem**: Signal drifts away from zero
**Solution**:
```csound
; Always include DC blocking on output
aout  butterhp  aout, 20
```

### 5. Click at Start/End
**Problem**: Audible clicks when reverb starts/stops
**Solution**:
```csound
; Amplitude ramp
kclick  linseg  0, 0.002, 1, p3-0.004, 1, 0.002, 0
aout    = aout * kclick
```

### 6. Mono Collapse
**Problem**: Reverb doesn't sound spatial in mono
**Solution**:
- Don't invert channels if mono compatibility matters
- Use decorrelated but non-inverted stereo:
```csound
aoutL   delay   aout, 0.011
aoutR   delay   aout, 0.017
```

## Related Examples

- `stanverb.csd` - Classic Schroeder reverb implementation
- `gardverb.csd` - William Gardner's nested allpass reverbs
- `reverbs.csd` - FDN reverb variations (Hans Mikelson)
- `comb1.csd`, `comb2.csd` - Basic comb filter exploration
- `Reverb11.csd`, `Reverb12.csd` - Additional reverb experiments
