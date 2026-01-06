# Csound Filter Banks and Vocoders

## Metadata
- **Category**: Effects / Spectral Processing
- **Difficulty**: Intermediate to Advanced
- **Tags**: filter bank, vocoder, bandpass, formant, spectral, speech synthesis, analysis-resynthesis
- **Opcodes**: `butterbp`, `resonx`, `tonex`, `atonex`, `rms`, `balance`, `gain`

## Description

Filter banks split audio into multiple frequency bands for independent processing. Vocoders use filter banks to analyze a "modulator" signal (typically speech) and impose its spectral characteristics onto a "carrier" signal (typically a synth). This creates the classic "robot voice" effect.

Key concepts:
- **Filter Bank**: Parallel array of bandpass filters covering the spectrum
- **Modulator**: The control signal (what shapes the sound)
- **Carrier**: The excitation signal (what provides the tonal content)
- **Envelope Follower**: Extracts amplitude envelope from each band
- **Analysis-Resynthesis**: Breaking down and rebuilding sound through filters

## Example 1: Basic Filter Bank

A simple filter bank that splits audio into multiple frequency bands.

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
; 8-band filter bank with individual band control
;---------------------------------------------------------------------------
instr 1
    iamp      = p4

    ; Generate white noise as source
    anoise    rand      iamp

    ; Alternative: use a rich harmonic source
    ; asig    vco2      iamp, 100, 0

    ; Band center frequencies (logarithmically spaced)
    ; Covering ~100Hz to ~8000Hz
    if1       = 125
    if2       = 250
    if3       = 500
    if4       = 1000
    if5       = 2000
    if6       = 4000
    if7       = 6000
    if8       = 8000

    ; Bandwidth factor (Q = center_freq / bandwidth)
    ; Higher = narrower bands = more resonant
    ibw       = 0.5       ; Bandwidth as fraction of center freq

    ; Filter each band
    ; butterbp: asig, freq, bandwidth
    ab1       butterbp  anoise, if1, if1 * ibw
    ab2       butterbp  anoise, if2, if2 * ibw
    ab3       butterbp  anoise, if3, if3 * ibw
    ab4       butterbp  anoise, if4, if4 * ibw
    ab5       butterbp  anoise, if5, if5 * ibw
    ab6       butterbp  anoise, if6, if6 * ibw
    ab7       butterbp  anoise, if7, if7 * ibw
    ab8       butterbp  anoise, if8, if8 * ibw

    ; Individual band gains (like a graphic EQ)
    kg1       = 1.0
    kg2       = 0.8
    kg3       = 1.2
    kg4       = 1.0
    kg5       = 0.6
    kg6       = 0.8
    kg7       = 0.4
    kg8       = 0.3

    ; Mix all bands
    aout      = ab1*kg1 + ab2*kg2 + ab3*kg3 + ab4*kg4 + ab5*kg5 + ab6*kg6 + ab7*kg7 + ab8*kg8

    ; Normalize (filter banks can boost level)
    aout      = aout * 0.3

    outs      aout, aout
endin

;---------------------------------------------------------------------------
; Animated filter bank - bands sweep through spectrum
;---------------------------------------------------------------------------
instr 2
    iamp      = p4
    irate     = p5          ; Sweep rate

    anoise    rand      iamp

    ; LFO modulates band positions
    kmod      oscil     1, irate, 1

    ; Base frequencies with modulation
    kf1       = 125 * (1 + kmod * 0.2)
    kf2       = 250 * (1 + kmod * 0.3)
    kf3       = 500 * (1 + kmod * 0.4)
    kf4       = 1000 * (1 - kmod * 0.3)
    kf5       = 2000 * (1 - kmod * 0.2)

    ibw       = 0.3

    ; Using butterbp with k-rate center frequency
    ab1       butterbp  anoise, kf1, kf1 * ibw
    ab2       butterbp  anoise, kf2, kf2 * ibw
    ab3       butterbp  anoise, kf3, kf3 * ibw
    ab4       butterbp  anoise, kf4, kf4 * ibw
    ab5       butterbp  anoise, kf5, kf5 * ibw

    aout      = (ab1 + ab2 + ab3 + ab4 + ab5) * 0.4

    outs      aout, aout
endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1     ; Sine for LFO

; Static filter bank
i1    0    3    0.8
s

; Animated filter bank
;     start  dur  amp   rate
i2    0      4    0.8   0.25
i2    4.5    4    0.8   0.5
i2    9      4    0.8   1.0

</CsScore>
</CsoundSynthesizer>
```

### Explanation

**Logarithmic Spacing:**
Human hearing is logarithmic, so filter bands are typically spaced exponentially:
```
125, 250, 500, 1000, 2000, 4000...  (each band is 2x the previous)
```

**Bandwidth:**
The bandwidth determines how much of the spectrum each filter captures:
- Wide bands (high bandwidth): More overlap, smoother response
- Narrow bands (low bandwidth): More selective, more resonant

**butterbp opcode:**
```csound
aout  butterbp  ain, kfreq, kband
```
- `kfreq`: Center frequency
- `kband`: Bandwidth in Hz (not Q!)

## Example 2: Classic Vocoder

The vocoder analyzes the modulator's spectrum and applies it to the carrier.

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
; 16-band vocoder
; Modulator = voice/speech (shapes the sound)
; Carrier = synth (provides the tone)
;---------------------------------------------------------------------------
instr 1
    iamp      = p4
    icarfreq  = cpspch(p5)    ; Carrier pitch

    ; === MODULATOR: Voice input (using noise for demo) ===
    ; In practice, use: amod soundin "voice.wav"
    ; or: amod inch 1 (for live input)
    amod      rand      0.8
    ; Simulate formants with a few resonant filters
    amod      butterbp  amod, 500, 100
    amod      = amod + butterbp(amod, 1500, 200) * 0.5
    amod      = amod + butterbp(amod, 2500, 300) * 0.3

    ; === CARRIER: Rich harmonic source ===
    acar      vco2      0.8, icarfreq, 0    ; Sawtooth

    ; === VOCODER PARAMETERS ===
    ; Frequency range
    ilow      = 100         ; Lowest band
    ihigh     = 8000        ; Highest band
    inbands   = 16          ; Number of bands

    ; Calculate step multiplier for log spacing
    istep     pow       ihigh/ilow, 1/(inbands-1)

    ; Bandwidth factor
    ibw       = 0.4

    ; Calculate all center frequencies
    if1       = ilow
    if2       = if1 * istep
    if3       = if2 * istep
    if4       = if3 * istep
    if5       = if4 * istep
    if6       = if5 * istep
    if7       = if6 * istep
    if8       = if7 * istep
    if9       = if8 * istep
    if10      = if9 * istep
    if11      = if10 * istep
    if12      = if11 * istep
    if13      = if12 * istep
    if14      = if13 * istep
    if15      = if14 * istep
    if16      = if15 * istep

    ; === ANALYZE MODULATOR ===
    ; Bandpass filter modulator into bands
    am1       butterbp  amod, if1,  if1 * ibw
    am2       butterbp  amod, if2,  if2 * ibw
    am3       butterbp  amod, if3,  if3 * ibw
    am4       butterbp  amod, if4,  if4 * ibw
    am5       butterbp  amod, if5,  if5 * ibw
    am6       butterbp  amod, if6,  if6 * ibw
    am7       butterbp  amod, if7,  if7 * ibw
    am8       butterbp  amod, if8,  if8 * ibw
    am9       butterbp  amod, if9,  if9 * ibw
    am10      butterbp  amod, if10, if10 * ibw
    am11      butterbp  amod, if11, if11 * ibw
    am12      butterbp  amod, if12, if12 * ibw
    am13      butterbp  amod, if13, if13 * ibw
    am14      butterbp  amod, if14, if14 * ibw
    am15      butterbp  amod, if15, if15 * ibw
    am16      butterbp  amod, if16, if16 * ibw

    ; === FILTER CARRIER ===
    ; Same filters applied to carrier
    ac1       butterbp  acar, if1,  if1 * ibw
    ac2       butterbp  acar, if2,  if2 * ibw
    ac3       butterbp  acar, if3,  if3 * ibw
    ac4       butterbp  acar, if4,  if4 * ibw
    ac5       butterbp  acar, if5,  if5 * ibw
    ac6       butterbp  acar, if6,  if6 * ibw
    ac7       butterbp  acar, if7,  if7 * ibw
    ac8       butterbp  acar, if8,  if8 * ibw
    ac9       butterbp  acar, if9,  if9 * ibw
    ac10      butterbp  acar, if10, if10 * ibw
    ac11      butterbp  acar, if11, if11 * ibw
    ac12      butterbp  acar, if12, if12 * ibw
    ac13      butterbp  acar, if13, if13 * ibw
    ac14      butterbp  acar, if14, if14 * ibw
    ac15      butterbp  acar, if15, if15 * ibw
    ac16      butterbp  acar, if16, if16 * ibw

    ; === APPLY MODULATOR ENVELOPE TO CARRIER ===
    ; balance: makes carrier amplitude follow modulator amplitude
    ao1       balance   ac1,  am1
    ao2       balance   ac2,  am2
    ao3       balance   ac3,  am3
    ao4       balance   ac4,  am4
    ao5       balance   ac5,  am5
    ao6       balance   ac6,  am6
    ao7       balance   ac7,  am7
    ao8       balance   ac8,  am8
    ao9       balance   ac9,  am9
    ao10      balance   ac10, am10
    ao11      balance   ac11, am11
    ao12      balance   ac12, am12
    ao13      balance   ac13, am13
    ao14      balance   ac14, am14
    ao15      balance   ac15, am15
    ao16      balance   ac16, am16

    ; === MIX OUTPUT ===
    aout      = ao1+ao2+ao3+ao4+ao5+ao6+ao7+ao8+ao9+ao10+ao11+ao12+ao13+ao14+ao15+ao16

    ; Scale output
    aout      = aout * iamp / ibw

    outs      aout, aout
endin

</CsInstruments>
<CsScore>
; Test vocoder at different pitches
;     start  dur  amp   pitch
i1    0      3    0.5   7.00
i1    3.5    3    0.5   7.07
i1    7      3    0.5   8.00
i1    10.5   4    0.5   6.07

</CsScore>
</CsoundSynthesizer>
```

### Explanation

**Vocoder Signal Flow:**
```
MODULATOR (voice) --> [Filter Bank] --> [Envelope Follower] --+
                                                               |
CARRIER (synth) ---> [Filter Bank] --> [VCA] <----------------+
                                         |
                                      OUTPUT
```

**balance opcode:**
The `balance` opcode is key to vocoding - it adjusts the carrier band's amplitude to match the modulator band:
```csound
aout  balance  acarrier_band, amodulator_band [, ihp [, istor]]
```
- `ihp`: Optional highpass cutoff for envelope following (default 10 Hz)

## Example 3: Advanced Vocoder with RMS Envelope Following

Using explicit RMS measurement for more control over envelope following.

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
; 8-band vocoder with RMS envelope following
; More control over attack/release characteristics
;---------------------------------------------------------------------------
instr 1
    iamp      = p4
    icarfreq  = cpspch(p5)
    iattack   = p6          ; Envelope attack time (ms)
    irelease  = p7          ; Envelope release time (ms)

    ; Modulator (simulated speech-like signal)
    amod      rand      0.5
    amod      butterbp  amod, 800, 200
    amod      = amod + butterbp(amod, 1800, 300) * 0.6

    ; Carrier
    acar      vco2      0.7, icarfreq, 0
    acar      = acar + vco2(0.3, icarfreq * 2.01, 0)  ; Slight detuning

    ; Filter frequencies (formant-focused)
    if1       = 200
    if2       = 400
    if3       = 800
    if4       = 1200
    if5       = 2000
    if6       = 3000
    if7       = 4500
    if8       = 6500

    ibw       = 0.35

    ; RMS period (samples) - controls envelope smoothness
    irmsper   = sr * iattack / 1000

    ; === MODULATOR ANALYSIS ===
    am1       butterbp  amod, if1, if1 * ibw
    am2       butterbp  amod, if2, if2 * ibw
    am3       butterbp  amod, if3, if3 * ibw
    am4       butterbp  amod, if4, if4 * ibw
    am5       butterbp  amod, if5, if5 * ibw
    am6       butterbp  amod, if6, if6 * ibw
    am7       butterbp  amod, if7, if7 * ibw
    am8       butterbp  amod, if8, if8 * ibw

    ; === EXTRACT RMS ENVELOPES ===
    krms1     rms       am1, irmsper
    krms2     rms       am2, irmsper
    krms3     rms       am3, irmsper
    krms4     rms       am4, irmsper
    krms5     rms       am5, irmsper
    krms6     rms       am6, irmsper
    krms7     rms       am7, irmsper
    krms8     rms       am8, irmsper

    ; === CARRIER FILTERING ===
    ac1       butterbp  acar, if1, if1 * ibw
    ac2       butterbp  acar, if2, if2 * ibw
    ac3       butterbp  acar, if3, if3 * ibw
    ac4       butterbp  acar, if4, if4 * ibw
    ac5       butterbp  acar, if5, if5 * ibw
    ac6       butterbp  acar, if6, if6 * ibw
    ac7       butterbp  acar, if7, if7 * ibw
    ac8       butterbp  acar, if8, if8 * ibw

    ; === APPLY ENVELOPES USING gain OPCODE ===
    ; gain scales signal to match RMS level
    ao1       gain      ac1, krms1, irmsper
    ao2       gain      ac2, krms2, irmsper
    ao3       gain      ac3, krms3, irmsper
    ao4       gain      ac4, krms4, irmsper
    ao5       gain      ac5, krms5, irmsper
    ao6       gain      ac6, krms6, irmsper
    ao7       gain      ac7, krms7, irmsper
    ao8       gain      ac8, krms8, irmsper

    ; === MIX ===
    aout      = (ao1 + ao2 + ao3 + ao4 + ao5 + ao6 + ao7 + ao8) * iamp

    ; Add some high frequency pass-through for intelligibility
    ahf       butterhp  amod, 5000
    aout      = aout + ahf * 0.2

    outs      aout, aout
endin

</CsInstruments>
<CsScore>
; Different envelope settings
;     start  dur  amp   pitch  attack  release
i1    0      3    0.5   7.00   10      50      ; Fast, crisp
i1    3.5    3    0.5   7.07   50      100     ; Medium
i1    7      3    0.5   8.00   100     200     ; Slow, smooth

</CsScore>
</CsoundSynthesizer>
```

### Explanation

**RMS Envelope Following:**
```csound
krms  rms  asig, ihp
```
- `ihp`: Period in samples for RMS calculation
- Longer period = smoother envelope, slower response
- Shorter period = faster response, more detail

**gain opcode:**
```csound
aout  gain  asig, krms, ihp
```
Scales the input signal so its RMS matches the target RMS value.

**High-Frequency Pass-Through:**
Adding unprocessed high frequencies improves speech intelligibility:
```csound
ahf   butterhp  amod, 5000
aout  = aout + ahf * 0.2
```

## Example 4: Formant Filter Bank (Vowel Synthesis)

Filter banks tuned to vocal formant frequencies can synthesize vowel sounds.

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
; Vowel formant synthesis using filter bank
;---------------------------------------------------------------------------
instr 1
    iamp      = p4
    ifreq     = cpspch(p5)
    ivowel    = p6          ; 0=A, 1=E, 2=I, 3=O, 4=U

    ; Rich excitation source
    asrc      vco2      iamp, ifreq, 0
    asrc      = asrc + rand(iamp * 0.02)    ; Add breath noise

    ; Vowel formant frequencies (approximate male voice)
    ;           F1    F2    F3    F4
    ; A (ah):   730   1090  2440  3400
    ; E (eh):   530   1840  2480  3520
    ; I (ee):   270   2290  3010  3400
    ; O (oh):   570   840   2410  3400
    ; U (oo):   300   870   2240  3400

    ; Read formants from tables based on vowel selection
    if1       table     ivowel, 1
    if2       table     ivowel, 2
    if3       table     ivowel, 3
    if4       table     ivowel, 4

    ; Formant bandwidths
    ibw1      = 90
    ibw2      = 110
    ibw3      = 170
    ibw4      = 250

    ; Apply formant filters
    ; Using resonx for sharper resonance
    af1       resonx    asrc, if1, ibw1, 2, 1
    af2       resonx    asrc, if2, ibw2, 2, 1
    af3       resonx    asrc, if3, ibw3, 2, 1
    af4       resonx    asrc, if4, ibw4, 2, 1

    ; Mix formants (typical amplitude ratios)
    aout      = af1 * 1.0 + af2 * 0.6 + af3 * 0.3 + af4 * 0.1

    ; Apply envelope
    kenv      linen     1, 0.05, p3, 0.1
    aout      = aout * kenv

    outs      aout, aout
endin

;---------------------------------------------------------------------------
; Morphing between vowels
;---------------------------------------------------------------------------
instr 2
    iamp      = p4
    ifreq     = cpspch(p5)
    ivowel1   = p6          ; Start vowel
    ivowel2   = p7          ; End vowel

    asrc      vco2      iamp, ifreq, 0
    asrc      = asrc + rand(iamp * 0.02)

    ; Morph position
    kmorph    linseg    0, p3, 1

    ; Interpolate formant frequencies
    if1a      table     ivowel1, 1
    if1b      table     ivowel2, 1
    kf1       = if1a + (if1b - if1a) * kmorph

    if2a      table     ivowel1, 2
    if2b      table     ivowel2, 2
    kf2       = if2a + (if2b - if2a) * kmorph

    if3a      table     ivowel1, 3
    if3b      table     ivowel2, 3
    kf3       = if3a + (if3b - if3a) * kmorph

    if4a      table     ivowel1, 4
    if4b      table     ivowel2, 4
    kf4       = if4a + (if4b - if4a) * kmorph

    ; Apply formant filters
    af1       resonx    asrc, kf1, 90, 2, 1
    af2       resonx    asrc, kf2, 110, 2, 1
    af3       resonx    asrc, kf3, 170, 2, 1
    af4       resonx    asrc, kf4, 250, 2, 1

    aout      = af1 * 1.0 + af2 * 0.6 + af3 * 0.3 + af4 * 0.1

    kenv      linen     1, 0.05, p3, 0.1
    aout      = aout * kenv

    outs      aout, aout
endin

</CsInstruments>
<CsScore>
; Formant tables: F1
f1 0 8 -2 730 530 270 570 300
; F2
f2 0 8 -2 1090 1840 2290 840 870
; F3
f3 0 8 -2 2440 2480 3010 2410 2240
; F4
f4 0 8 -2 3400 3520 3400 3400 3400

; Individual vowels
;     start  dur  amp   pitch  vowel
i1    0      0.8  0.5   8.00   0     ; A
i1    1      0.8  0.5   8.00   1     ; E
i1    2      0.8  0.5   8.00   2     ; I
i1    3      0.8  0.5   8.00   3     ; O
i1    4      0.8  0.5   8.00   4     ; U
s

; Vowel morphing
;     start  dur  amp   pitch  from  to
i2    0      2    0.5   7.00   0     2     ; A -> I
i2    2.5    2    0.5   7.05   2     4     ; I -> U
i2    5      2    0.5   7.07   4     0     ; U -> A

</CsScore>
</CsoundSynthesizer>
```

### Vowel Formant Reference

| Vowel | F1 (Hz) | F2 (Hz) | F3 (Hz) |
|-------|---------|---------|---------|
| A (ah)| 730     | 1090    | 2440    |
| E (eh)| 530     | 1840    | 2480    |
| I (ee)| 270     | 2290    | 3010    |
| O (oh)| 570     | 840     | 2410    |
| U (oo)| 300     | 870     | 2240    |

## Variations

### resonx vs butterbp

For vocoder applications, `resonx` often sounds better:
```csound
; butterbp: Butterworth, flatter response
aout  butterbp  ain, kfreq, kbw

; resonx: Resonant, with adjustable poles
aout  resonx    ain, kfreq, kbw, inumlayer, iscl
; inumlayer: more layers = steeper rolloff
; iscl: 1 = peak normalized, 2 = RMS normalized
```

### Sibilance Enhancement

Add unvocoded high frequencies for better consonants:
```csound
; High-pass the modulator
asib    butterhp  amod, 5000

; Mix with vocoded signal
aout    = avocoded + asib * 0.3
```

### Stereo Spreading

Create stereo width by detuning left/right carriers:
```csound
acarL   vco2    0.7, icarfreq * 0.998, 0
acarR   vco2    0.7, icarfreq * 1.002, 0
```

## Common Issues and Solutions

### 1. Muddy/Unclear Sound
**Problem**: Vocoded output lacks definition
**Solution**:
- Increase number of bands
- Narrow the bandwidth
- Add high-frequency pass-through
- Use faster envelope following

### 2. Pumping/Breathing
**Problem**: Amplitude fluctuates unnaturally
**Solution**:
- Increase RMS averaging period
- Add compression before vocoding
- Lower the bandwidth factor

### 3. Too Resonant/Ringy
**Problem**: Individual bands ring too long
**Solution**:
- Use `butterbp` instead of `resonx`
- Increase bandwidth
- Reduce filter Q/poles

### 4. Loss of Pitch Definition
**Problem**: Carrier pitch not clear in output
**Solution**:
- Use a harmonically rich carrier (sawtooth)
- Ensure carrier has energy in all bands
- Check modulator isn't too quiet

### 5. Aliasing in Resonant Filters
**Problem**: High-frequency artifacts
**Solution**:
```csound
; Limit maximum frequency
kfreq   limit   kfreq, 20, sr/2 - 100
```

## Related Examples

- `fltbank.csd` - Basic 5-band filter bank
- `vocode.csd` - 21-band and 8-band vocoders
- `cvocoder.csd` - Advanced vocoder with routing options
- `fltsynth.csd` - Filter bank synthesis
- `rezflt1.csd` - Resonant filter examples
