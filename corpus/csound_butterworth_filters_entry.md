# Butterworth Filter Suite: Lowpass, Highpass, Bandpass, and Band-Reject

## Metadata

- **Title:** Butterworth Filter Suite: LP, HP, BP, and BR Filters
- **Category:** Filtering / Subtractive Synthesis / Signal Processing / Audio Effects
- **Difficulty:** Beginner/Intermediate
- **Tags:** `butterworth`, `filter`, `lowpass`, `highpass`, `bandpass`, `notch`, `band-reject`, `butterlp`, `butterhp`, `butterbp`, `butterbr`, `subtractive-synthesis`, `EQ`, `frequency-shaping`, `resonance`
- **Source Files:** `butter.csd`, `filtex.csd`, `buttest.csd`

---

## Description

Butterworth filters are the workhorses of audio signal processing, prized for their **maximally flat passband response** - meaning they don't boost or color frequencies in their passband. Csound provides four Butterworth filter opcodes covering all essential filter types: lowpass (butterlp), highpass (butterhp), bandpass (butterbp), and band-reject/notch (butterbr). These second-order (12 dB/octave) filters form the foundation of subtractive synthesis and equalizer design.

**Use Cases:**
- Subtractive synthesis (oscillator → filter → output)
- Removing unwanted frequencies (hiss, rumble, hum)
- Creating filter sweeps and wah effects
- Building parametric EQs
- Isolating frequency bands for analysis or processing
- Removing specific frequencies (notch filtering for feedback suppression)
- Tone shaping and sound design

**Why Butterworth?**
- **Flat passband:** No ripple or coloration in passed frequencies
- **Predictable rolloff:** 12 dB/octave (second-order) slope
- **Smooth phase response:** Less phase distortion than other designs
- **Well-behaved:** Stable and efficient at all frequencies
- **Industry standard:** Used in countless audio applications

---

## Complete Code

### Example 1: All Four Butterworth Filter Types

```csound
<CsoundSynthesizer>
<CsOptions>
-o butterworth_demo.wav
</CsOptions>
<CsInstruments>
sr        = 44100
kr        = 4410
ksmps     = 10
nchnls    = 2
0dbfs     = 1

; ===========================================
; INSTRUMENT 1: LOWPASS FILTER (butterlp)
; Passes frequencies BELOW cutoff
; ===========================================
          instr     1
iamp      = p4
icutoff   = p5                    ; Cutoff frequency in Hz

; White noise source - contains all frequencies equally
anois     rand      iamp

; Sweeping cutoff frequency
kfreq     linseg    100, p3/2, icutoff, p3/2, 100

; LOWPASS FILTER
; butterlp asig, kfreq
; - asig: input signal
; - kfreq: cutoff frequency (Hz)
afil      butterlp  anois, kfreq

          outs      afil, afil
          endin

; ===========================================
; INSTRUMENT 2: HIGHPASS FILTER (butterhp)
; Passes frequencies ABOVE cutoff
; ===========================================
          instr     2
iamp      = p4
icutoff   = p5

anois     rand      iamp

; Sweeping cutoff
kfreq     linseg    20, p3/2, icutoff, p3/2, 20

; HIGHPASS FILTER
; butterhp asig, kfreq
afil      butterhp  anois, kfreq

          outs      afil, afil
          endin

; ===========================================
; INSTRUMENT 3: BANDPASS FILTER (butterbp)
; Passes frequencies AROUND center frequency
; ===========================================
          instr     3
iamp      = p4
icenter   = p5                    ; Center frequency
ibw       = p6                    ; Bandwidth in Hz

anois     rand      iamp

; Sweeping center frequency
kfreq     linseg    200, p3/2, icenter, p3/2, 200
kbw       = ibw                   ; Fixed bandwidth (or modulate it)

; BANDPASS FILTER
; butterbp asig, kcf, kbw
; - kcf: center frequency (Hz)
; - kbw: bandwidth (Hz) - the range of frequencies passed
afil      butterbp  anois, kfreq, kbw

; Bandpass output is quieter, boost it
          outs      afil * 5, afil * 5
          endin

; ===========================================
; INSTRUMENT 4: BAND-REJECT (NOTCH) FILTER (butterbr)
; Removes frequencies AROUND center frequency
; ===========================================
          instr     4
iamp      = p4
icenter   = p5                    ; Notch center frequency
ibw       = p6                    ; Notch width in Hz

anois     rand      iamp

; Fixed notch frequency, sweeping bandwidth
kfreq     = icenter
kbw       linseg    10, p3/2, ibw, p3/2, 10

; BAND-REJECT (NOTCH) FILTER
; butterbr asig, kcf, kbw
afil      butterbr  anois, kfreq, kbw

          outs      afil, afil
          endin

</CsInstruments>
<CsScore>
; Demonstrate each filter type

; LOWPASS - sweep from 100 Hz to 5000 Hz and back
; p1  p2   p3   p4    p5
; ins strt dur  amp   cutoff
i1   0    4    0.3   5000

; HIGHPASS - sweep from 20 Hz to 8000 Hz and back
i2   5    4    0.3   8000

; BANDPASS - sweep center from 200 Hz to 3000 Hz
; p1  p2   p3   p4    p5      p6
; ins strt dur  amp   center  bandwidth
i3   10   4    0.3   3000    200

; BAND-REJECT - notch at 1000 Hz, bandwidth widens
i4   15   4    0.3   1000    500

e
</CsScore>
</CsoundSynthesizer>
```

### Example 2: Classic Subtractive Synthesizer

```csound
<CsoundSynthesizer>
<CsOptions>
-o subtractive_synth.wav
</CsOptions>
<CsInstruments>
sr        = 44100
kr        = 4410
ksmps     = 10
nchnls    = 2
0dbfs     = 1

; Classic subtractive synth: Oscillator → Filter → Amplifier
          instr     10
; PARAMETERS
iamp      = p4
ifreq     = cpspch(p5)            ; Pitch in Csound notation
ifiltbase = p6                    ; Base filter cutoff
ifiltmod  = p7                    ; Filter envelope depth
iattack   = p8
irelease  = p9

; AMPLITUDE ENVELOPE
kamp      linen     iamp, iattack, p3, irelease

; FILTER ENVELOPE (attack-decay style)
kfiltenv  expseg    0.01, iattack*0.5, 1, p3-iattack*0.5, 0.2

; OSCILLATOR - sawtooth (rich in harmonics)
aosc      vco2      1, ifreq, 0           ; Sawtooth wave

; Add sub-oscillator for bass weight
asub      vco2      0.5, ifreq * 0.5, 0   ; One octave down

; Mix oscillators
amix      = aosc + asub * 0.5

; FILTER - lowpass with envelope modulation
kcutoff   = ifiltbase + (kfiltenv * ifiltmod)
kcutoff   limit     kcutoff, 20, sr/2 - 100   ; Safety limits!
afilt     butterlp  amix, kcutoff

; OUTPUT with amplitude envelope
aout      = afilt * kamp
          outs      aout, aout
          endin

; Synth bass with resonant filter (using cascaded butterworth)
          instr     11
iamp      = p4
ifreq     = cpspch(p5)
ifiltbase = p6
iresonance = p7                   ; 1-10, amount of resonant boost

; Envelopes
kamp      linen     iamp, 0.01, p3, 0.1
kfiltenv  expseg    0.01, 0.05, 1, 0.2, 0.3, p3-0.25, 0.1

; Oscillator
aosc      vco2      1, ifreq, 0

; Filter cutoff
kcutoff   = ifiltbase * kfiltenv
kcutoff   limit     kcutoff, 50, 10000

; RESONANCE via parallel bandpass
; Butterworth doesn't have resonance, so we add it
afiltlp   butterlp  aosc, kcutoff
afiltbp   butterbp  aosc, kcutoff, kcutoff * 0.1  ; Narrow band at cutoff
aresonant = afiltlp + afiltbp * iresonance

aout      = aresonant * kamp
          outs      aout, aout
          endin

</CsInstruments>
<CsScore>
; Classic synth pad
; p1  p2   p3   p4    p5    p6      p7      p8    p9
; ins strt dur  amp   pitch base    mod     att   rel
i10  0    2    0.4   8.00  800     4000    0.3   0.5
i10  2.5  2    0.4   8.04  1000    5000    0.2   0.4
i10  5    2    0.4   8.07  600     3000    0.4   0.6
i10  7.5  3    0.4   8.00  500     6000    0.5   1.0

; Resonant bass
; p1  p2   p3   p4    p5    p6      p7
; ins strt dur  amp   pitch cutoff  resonance
i11  11   1    0.5   6.00  2000    3
i11  12.5 1    0.5   6.00  3000    5
i11  14   1    0.5   6.00  4000    8
i11  15.5 2    0.5   6.00  1500    4

e
</CsScore>
</CsoundSynthesizer>
```

### Example 3: Parametric EQ using Butterworth Filters

```csound
<CsoundSynthesizer>
<CsOptions>
-o parametric_eq.wav
</CsOptions>
<CsInstruments>
sr        = 44100
kr        = 4410
ksmps     = 10
nchnls    = 2
0dbfs     = 1

; 3-Band Parametric EQ
          instr     20
; INPUT - could be soundin, diskin2, or any signal
ain       rand      0.3           ; White noise for demonstration

; EQ PARAMETERS
; Low shelf (using highpass to cut, add back original for boost)
klowfreq  = p4                    ; Low shelf frequency
klowgain  = p5                    ; Low gain (dB, negative = cut)

; Mid band (bandpass/notch)
kmidfreq  = p6                    ; Mid center frequency
kmidbw    = p7                    ; Mid bandwidth
kmidgain  = p8                    ; Mid gain (dB)

; High shelf (using lowpass)
khighfreq = p9                    ; High shelf frequency
khighgain = p10                   ; High gain (dB)

; LOW SHELF IMPLEMENTATION
; Cut: highpass removes lows, mix back some original
; Boost: add filtered lows to original
alowcut   butterhp  ain, klowfreq
alow      butterlp  ain, klowfreq
if klowgain < 0 then
  ; Cut lows: blend toward highpassed
  klowmix = ampdb(klowgain)
  alowout = alowcut + alow * klowmix
else
  ; Boost lows: add extra low content
  klowboost = ampdb(klowgain) - 1
  alowout = ain + alow * klowboost
endif

; MID BAND IMPLEMENTATION
; Extract mid band, scale it, add/subtract from signal
amid      butterbp  alowout, kmidfreq, kmidbw
if kmidgain < 0 then
  ; Cut: use notch filter approach
  kmidmix = 1 - ampdb(-kmidgain)
  anotch  butterbr  alowout, kmidfreq, kmidbw
  amidout = alowout * kmidmix + anotch * (1 - kmidmix)
else
  ; Boost: add bandpassed content
  kmidboost = ampdb(kmidgain) - 1
  amidout = alowout + amid * kmidboost
endif

; HIGH SHELF IMPLEMENTATION
ahighcut  butterlp  amidout, khighfreq
ahigh     butterhp  amidout, khighfreq
if khighgain < 0 then
  ; Cut highs
  khighmix = ampdb(khighgain)
  ahighout = ahighcut + ahigh * khighmix
else
  ; Boost highs
  khighboost = ampdb(khighgain) - 1
  ahighout = amidout + ahigh * khighboost
endif

          outs      ahighout, ahighout
          endin

; Simple high-cut / low-cut utility filters
          instr     21
ain       diskin2   "input.wav", 1, 0, 1   ; Loop input file
; If no file, use noise:
; ain     rand      0.3

ilowcut   = p4                    ; Highpass cutoff (remove rumble)
ihighcut  = p5                    ; Lowpass cutoff (remove hiss)

; Apply both filters
afilt     butterhp  ain, ilowcut
afilt     butterlp  afilt, ihighcut

          outs      afilt, afilt
          endin

</CsInstruments>
<CsScore>
; Parametric EQ demonstration
; p1  p2  p3  p4     p5      p6      p7    p8     p9      p10
; ins st  dur lowf   lowgain midf    midbw midg   highf   highgain
i20  0   4   200    0       1000    200   0      4000    0        ; Flat
i20  5   4   200    6       1000    200   0      4000    0        ; Low boost
i20  10  4   200    -6      1000    200   0      4000    0        ; Low cut
i20  15  4   200    0       1000    200   6      4000    0        ; Mid boost
i20  20  4   200    0       1000    200   -6     4000    0        ; Mid cut
i20  25  4   200    0       1000    200   0      4000    6        ; High boost
i20  30  4   200    0       1000    200   0      4000    -6       ; High cut

e
</CsScore>
</CsoundSynthesizer>
```

### Example 4: Filter Combinations and Cascading

```csound
<CsoundSynthesizer>
<CsOptions>
-o filter_cascade.wav
</CsOptions>
<CsInstruments>
sr        = 44100
kr        = 4410
ksmps     = 10
nchnls    = 2
0dbfs     = 1

; Cascaded filters for steeper slopes
          instr     30
iamp      = p4
icutoff   = p5
iorder    = p6                    ; 1, 2, or 3 (12, 24, or 36 dB/oct)

anois     rand      iamp

; Sweeping filter
kfreq     linseg    100, p3/2, icutoff, p3/2, 100

; CASCADED LOWPASS - each stage adds 12 dB/octave
afilt     butterlp  anois, kfreq
if iorder >= 2 then
  afilt   butterlp  afilt, kfreq       ; 24 dB/octave
endif
if iorder >= 3 then
  afilt   butterlp  afilt, kfreq       ; 36 dB/octave
endif

          outs      afilt, afilt
          endin

; Bandpass created from LP + HP combination
          instr     31
iamp      = p4
ilowcut   = p5                    ; Lower edge of band
ihighcut  = p6                    ; Upper edge of band

anois     rand      iamp

; Modulate both cutoffs together (parallel motion)
kmod      linseg    0, p3/2, 1, p3/2, 0
klow      = ilowcut * (1 + kmod * 3)
khigh     = ihighcut * (1 + kmod * 3)

; BANDPASS via HP then LP
; This creates a bandpass with independent control of both edges
afilt     butterhp  anois, klow
afilt     butterlp  afilt, khigh

          outs      afilt, afilt
          endin

; Multiple notch filters (removing harmonics)
          instr     32
iamp      = p4
ifund     = p5                    ; Fundamental to remove

; Sawtooth with all harmonics
aosc      vco2      iamp, 100, 0

; Remove fundamental and first few harmonics with notches
anotch    butterbr  aosc, ifund, 20           ; Remove fundamental
anotch    butterbr  anotch, ifund*2, 20       ; Remove 2nd harmonic
anotch    butterbr  anotch, ifund*3, 20       ; Remove 3rd harmonic
anotch    butterbr  anotch, ifund*4, 20       ; Remove 4th harmonic

          outs      anotch, anotch
          endin

</CsInstruments>
<CsScore>
; Cascaded filters - compare slopes
; p1  p2  p3  p4   p5     p6
; ins st  dur amp  cutoff order
i30  0   3   0.3  5000   1     ; 12 dB/octave
i30  4   3   0.3  5000   2     ; 24 dB/octave
i30  8   3   0.3  5000   3     ; 36 dB/octave

; Bandpass via HP+LP
; p1  p2  p3  p4   p5      p6
; ins st  dur amp  lowcut  highcut
i31  12  4   0.3  500     2000

; Multiple notches
i32  17  4   0.3  100

e
</CsScore>
</CsoundSynthesizer>
```

---

## Detailed Explanation

### Butterworth Filter Characteristics

**The Butterworth Response:**

Butterworth filters are characterized by their **maximally flat magnitude response** in the passband. This means:
- No ripples or peaks in the passband
- Monotonic rolloff in the stopband
- -3 dB point exactly at the cutoff frequency
- 12 dB/octave (second-order) or steeper when cascaded

**Mathematical Background:**

The magnitude response follows:
```
|H(f)|² = 1 / (1 + (f/fc)^(2n))
```
Where:
- f = frequency
- fc = cutoff frequency
- n = filter order (Csound's butter* = 2nd order)

**At cutoff frequency:** |H(fc)|² = 0.5 → |H(fc)| = 0.707 → -3 dB

### The Four Butterworth Opcodes

#### butterlp - Lowpass Filter

```csound
afilt butterlp asig, kfreq [, iskip]
```

**Function:** Passes frequencies BELOW cutoff, attenuates frequencies ABOVE

**Parameters:**
- `asig` - Input signal
- `kfreq` - Cutoff frequency in Hz (-3 dB point)
- `iskip` - (optional) Skip initialization if non-zero

**Frequency Response:**
```
     |
  0dB|________
     |        \
 -3dB|         * ← cutoff
     |          \
-12dB|           \  ← 12dB/octave slope
     |            \
     +-------------\--------→ frequency
              fc   2fc
```

**Typical Uses:**
- Remove high-frequency hiss/noise
- Darken/warm up a sound
- Create "muffled" or "underwater" effects
- Classic synth filter sweeps

#### butterhp - Highpass Filter

```csound
afilt butterhp asig, kfreq [, iskip]
```

**Function:** Passes frequencies ABOVE cutoff, attenuates frequencies BELOW

**Parameters:** Same as butterlp

**Frequency Response:**
```
     |
  0dB|              ________
     |             /
 -3dB|            * ← cutoff
     |           /
-12dB|          /
     |         /
     +--------/-------------→ frequency
            fc
```

**Typical Uses:**
- Remove low-frequency rumble
- Thin out a bass-heavy mix
- Create "tinny" or "telephone" effects
- Isolate high frequency content

#### butterbp - Bandpass Filter

```csound
afilt butterbp asig, kcf, kbw [, iskip]
```

**Function:** Passes frequencies AROUND center frequency within bandwidth

**Parameters:**
- `asig` - Input signal
- `kcf` - Center frequency in Hz
- `kbw` - Bandwidth in Hz (frequency range passed)
- `iskip` - (optional) Skip initialization

**Frequency Response:**
```
     |
  0dB|        ___
     |       /   \
 -3dB|      *     * ← -3dB points define bandwidth
     |     /       \
     |    /         \
     +---/-----+-----\------→ frequency
            cf
         |←-bw-→|
```

**Q Factor:** The ratio of center frequency to bandwidth
```
Q = cf / bw
```
- High Q = narrow band, more selective
- Low Q = wide band, less selective

**Typical Uses:**
- Isolate specific frequency ranges
- Create resonant "wah" effects
- Telephone/radio voice simulation
- Frequency analysis and extraction

#### butterbr - Band-Reject (Notch) Filter

```csound
afilt butterbr asig, kcf, kbw [, iskip]
```

**Function:** REMOVES frequencies around center frequency, passes everything else

**Parameters:** Same as butterbp

**Frequency Response:**
```
     |
  0dB|____       ____
     |    \     /
 -3dB|     *   * ← -3dB points
     |      \ /
     |       V ← notch depth
     +-------+----------→ frequency
            cf
```

**Typical Uses:**
- Remove hum (50/60 Hz and harmonics)
- Feedback suppression in live sound
- Removing specific unwanted frequencies
- Creating "phaser-like" effects with multiple notches

---

## Key Concepts

### Filter Order and Slope

**Csound's Butterworth filters are 2nd-order (12 dB/octave):**

| Filter Order | Slope | Csound Implementation |
|--------------|-------|----------------------|
| 1st order | 6 dB/oct | tone (LP), atone (HP) |
| 2nd order | 12 dB/oct | butter* opcodes |
| 4th order | 24 dB/oct | Cascade 2 butter* |
| 6th order | 36 dB/oct | Cascade 3 butter* |

**Cascading for steeper slopes:**
```csound
; 24 dB/octave lowpass
afilt butterlp ain, kcutoff
afilt butterlp afilt, kcutoff

; 36 dB/octave lowpass
afilt butterlp ain, kcutoff
afilt butterlp afilt, kcutoff
afilt butterlp afilt, kcutoff
```

### Cutoff Frequency Limits

**Critical constraints:**
- Minimum: > 0 Hz (practically > 1 Hz)
- Maximum: < sr/2 (Nyquist frequency)
- **Safe practice:** Keep cutoff between 20 Hz and sr/2 - 100 Hz

```csound
; ALWAYS limit cutoff frequency!
kcutoff limit kcutoff, 20, sr/2 - 100
afilt   butterlp ain, kcutoff
```

**Why?**
- Cutoff at 0 Hz = mathematical singularity
- Cutoff at Nyquist = unstable behavior
- Exceeding Nyquist = undefined results

### Bandwidth and Q

For bandpass and band-reject filters:

**Bandwidth (bw):** The frequency range in Hz
**Q Factor:** Selectivity measure

```
Q = center_frequency / bandwidth
bandwidth = center_frequency / Q
```

| Q Value | Character |
|---------|-----------|
| 0.5-1 | Very wide, gentle |
| 1-2 | Moderate selectivity |
| 5-10 | Narrow, resonant |
| 20+ | Very narrow, "ringing" |

**Practical consideration:**
Very high Q (narrow bandwidth) can cause:
- Loud resonant peaks
- Ringing artifacts
- Instability at low frequencies

### Phase Response

Butterworth filters alter phase, not just amplitude:
- **Lowpass:** Phase lag increases with frequency
- **Highpass:** Phase lead at low frequencies
- **All filters:** Maximum phase shift at cutoff

**Musical implications:**
- Slight "smearing" of transients
- Phase differences between filtered and unfiltered signals
- Can cause comb filtering when mixed with dry signal

---

## Comparison with Other Csound Filters

### Filter Opcode Comparison

| Opcode | Type | Order | Resonance | Character |
|--------|------|-------|-----------|-----------|
| `tone` | LP | 1st (6dB) | No | Gentle, warm |
| `atone` | HP | 1st (6dB) | No | Gentle |
| `butterlp` | LP | 2nd (12dB) | No | Clean, precise |
| `butterhp` | HP | 2nd (12dB) | No | Clean, precise |
| `butterbp` | BP | 2nd | Via Q | Clean |
| `butterbr` | Notch | 2nd | Via Q | Clean |
| `reson` | BP | 2nd | Yes | Resonant, colored |
| `resonx` | BP | Variable | Yes | Resonant |
| `moogladder` | LP | 4th (24dB) | Yes | Warm, analog |
| `lpf18` | LP | 3-pole | Yes | Analog character |

### When to Use Each

**Use Butterworth when:**
- You want clean, transparent filtering
- Building EQs or utility filters
- Precise frequency control needed
- No resonance/coloration desired

**Use tone/atone when:**
- Simple, gentle filtering needed
- CPU efficiency is priority
- Slight coloration acceptable

**Use moogladder/lpf18 when:**
- Classic analog synth sound needed
- Self-oscillating filter desired
- Musical resonance important

**Use reson when:**
- Strong resonance needed
- Bandpass with controllable Q
- Creating formant-like peaks

---

## Variations

### Adding Resonance to Butterworth

Butterworth filters have no built-in resonance. Add it with parallel bandpass:

```csound
; Resonant lowpass using butterworth
kresonance = 5                    ; Resonance amount (0-10)
kcutoff    = 1000

; Main lowpass
afiltlp    butterlp ain, kcutoff

; Resonant peak at cutoff
kbw        = kcutoff * 0.1        ; Bandwidth = 10% of cutoff
afiltbp    butterbp ain, kcutoff, kbw

; Mix: more resonance = more bandpass
aout       = afiltlp + afiltbp * kresonance * 0.5
```

### Envelope-Controlled Filter

```csound
; Classic synth filter with ADSR
ibase     = 200                   ; Base cutoff
ipeak     = 5000                  ; Peak cutoff
iattack   = 0.1
idecay    = 0.3
isustain  = 0.4                   ; Sustain level (0-1)
irelease  = 0.5

kfiltenv  madsr iattack, idecay, isustain, irelease
kcutoff   = ibase + (kfiltenv * (ipeak - ibase))

afilt     butterlp aosc, kcutoff
```

### Key Tracking (Filter Follows Pitch)

```csound
; Filter cutoff tracks pitch for consistent brightness
ifreq     = cpspch(p5)
itracking = 0.5                   ; 0=no tracking, 1=full tracking
ibase     = 2000

kcutoff   = ibase + (ifreq * itracking * 4)
afilt     butterlp aosc, kcutoff
```

### Morphing Between Filter Types

```csound
; Crossfade between LP, BP, HP
kmorph    linseg 0, p3/3, 0.5, p3/3, 1, p3/3, 0.5
kcutoff   = 2000

alp       butterlp ain, kcutoff
abp       butterbp ain, kcutoff, 400
ahp       butterhp ain, kcutoff

; Morph: 0=LP, 0.5=BP, 1=HP
if kmorph < 0.5 then
  aout = alp * (1 - kmorph*2) + abp * (kmorph*2)
else
  aout = abp * (1 - (kmorph-0.5)*2) + ahp * ((kmorph-0.5)*2)
endif
```

### Parallel Filter Bank

```csound
; Multiple bandpass filters for formant-like peaks
af1       butterbp ain, 500, 50
af2       butterbp ain, 1500, 100
af3       butterbp ain, 2500, 150
af4       butterbp ain, 3500, 200

aout      = (af1 + af2 + af3 + af4) * 2
```

### Dynamic Bandwidth

```csound
; Bandwidth narrows as cutoff rises (constant Q)
kcutoff   linseg 200, p3, 4000
kQ        = 5                     ; Constant Q factor
kbw       = kcutoff / kQ          ; Bandwidth = cutoff / Q

afilt     butterbp ain, kcutoff, kbw
```

---

## Common Issues & Solutions

### Filter Blows Up / Extreme Output

**Problem:** Output becomes extremely loud or infinite
**Cause:** Cutoff frequency at or beyond Nyquist
**Solution:**
```csound
; ALWAYS clamp cutoff frequency
kcutoff limit kcutoff, 20, sr/2 - 100
; Or use safety wrapper
kcutoff = max(20, min(kcutoff, sr/2 - 100))
```

### Clicks When Cutoff Changes Rapidly

**Problem:** Audible clicks during fast filter sweeps
**Cause:** Large parameter jumps between k-cycles
**Solution:**
```csound
; Smooth the cutoff changes
kcutoff_raw = ... ; Your modulated cutoff
kcutoff     port kcutoff_raw, 0.01  ; 10ms smoothing

afilt       butterlp ain, kcutoff
```

### Bandpass Output Too Quiet

**Problem:** Bandpass filter output much quieter than input
**Cause:** Bandpass only passes limited frequency range
**Solution:**
```csound
; Boost bandpass output
afilt butterbp ain, kcf, kbw
aout  = afilt * 5              ; Boost by ~14dB

; Or normalize based on bandwidth
kgain = 1000 / kbw             ; Narrower = more boost
aout  = afilt * kgain
```

### Notch Filter Not Deep Enough

**Problem:** Band-reject doesn't fully remove target frequency
**Cause:** Bandwidth too wide, or single stage insufficient
**Solution:**
```csound
; Narrower bandwidth
afilt butterbr ain, kcf, 10    ; Very narrow notch

; Or cascade multiple notches
afilt butterbr ain, kcf, 20
afilt butterbr afilt, kcf, 20  ; Deeper notch

; Or use multiple stages at same frequency
afilt butterbr ain, kcf, 50
afilt butterbr afilt, kcf, 50
afilt butterbr afilt, kcf, 50  ; Very deep
```

### Filter Sounds Dull/Lifeless

**Problem:** Filtered sound lacks energy
**Cause:** Butterworth has no resonance, just attenuation
**Solution:**
```csound
; Add resonant peak (see "Adding Resonance" variation above)
afiltlp butterlp ain, kcutoff
afiltbp butterbp ain, kcutoff, kcutoff * 0.1
aout    = afiltlp + afiltbp * 3  ; Add resonance
```

### Low-Frequency Instability

**Problem:** Filter becomes unstable or produces DC offset at very low cutoffs
**Cause:** Numerical precision issues at extreme low frequencies
**Solution:**
```csound
; Keep minimum cutoff reasonable
kcutoff = max(kcutoff, 20)     ; Never below 20 Hz

; DC blocking after filtering
afilt butterlp ain, kcutoff
aout  dcblock afilt             ; Remove any DC offset
```

---

## Sound Design Applications

### Classic Synth Filter Sweep

```csound
; Acid-style filter sweep
kenv   expseg 0.01, 0.01, 1, 0.1, 0.3, p3-0.11, 0.1
kcutoff = 200 + kenv * 4000

aosc   vco2 0.5, 55, 0          ; Low sawtooth
afilt  butterlp aosc, kcutoff
afilt  butterlp afilt, kcutoff  ; 24dB/oct for more "squelch"
```

### Telephone Voice Effect

```csound
; Bandpass to telephone frequency range (300-3400 Hz)
avoice diskin2 "voice.wav", 1
afilt  butterhp avoice, 300
afilt  butterlp afilt, 3400
; Optional: add some distortion for authenticity
afilt  tanh afilt * 2
```

### Wah-Wah Effect

```csound
; LFO-controlled bandpass
kwah   oscil 1500, 2, 1         ; 2 Hz wah rate
kcf    = 800 + kwah             ; Sweep 800-2300 Hz

afilt  butterbp ain, kcf, 300   ; Bandpass with fixed width
aout   = afilt * 3              ; Boost
```

### Hum Removal (50/60 Hz)

```csound
; Remove mains hum and harmonics
ihum   = 60                      ; 60 Hz (US) or 50 Hz (EU)
afilt  butterbr ain, ihum, 5     ; Fundamental
afilt  butterbr afilt, ihum*2, 5 ; 2nd harmonic
afilt  butterbr afilt, ihum*3, 5 ; 3rd harmonic
```

### Spectral Tilt (Brightness Control)

```csound
; Tilt EQ: boost highs while cutting lows (or vice versa)
ktilt  = p4                      ; -1 to +1 (dark to bright)
ipivot = 1000                    ; Pivot frequency

if ktilt > 0 then
  afilt butterhp ain, ipivot * (1 - ktilt * 0.5)
  afilt = ain + afilt * ktilt * 2
else
  afilt butterlp ain, ipivot * (1 + ktilt * 0.5)
  afilt = ain + afilt * abs(ktilt) * 2
endif
```

---

## Performance Notes

- **CPU Usage:** Very low - Butterworth filters are highly efficient
- **Polyphony:** Can run hundreds of filter instances
- **Real-time Safe:** Yes, excellent for live performance
- **Latency:** Minimal (a few samples of group delay)
- **Numerical Stability:** Excellent within valid frequency range

**Optimization Tips:**
- Use `tone/atone` if 6dB/octave is sufficient (slightly more efficient)
- Avoid recalculating filter coefficients unnecessarily (use k-rate, not a-rate for cutoff when possible)
- For very steep filters, consider `bqrez` or `moogladder` (single opcode vs cascade)

---

## Historical Context

**Stephen Butterworth (1930):**
Published "On the Theory of Filter Amplifiers" describing the maximally-flat magnitude response filter design. His goal was a filter with no passband ripple, unlike earlier Chebyshev designs.

**Analog Origins:**
Originally implemented with resistors, capacitors, and operational amplifiers. The flat response made them ideal for audio applications where coloration was undesirable.

**Digital Implementation:**
Converted to digital form using bilinear transform, maintaining the flat response while enabling precise computer control. Csound's implementation follows standard IIR (Infinite Impulse Response) filter design.

**Industry Standard:**
Butterworth became the default choice for countless audio applications:
- Crossover networks in speakers
- Anti-aliasing filters in ADCs
- Reconstruction filters in DACs
- EQ circuits in mixing consoles
- Tone controls in amplifiers

---

## Extended Documentation

**Official Csound Opcode References:**
- [butterlp](https://csound.com/docs/manual/butterlp.html)
- [butterhp](https://csound.com/docs/manual/butterhp.html)
- [butterbp](https://csound.com/docs/manual/butterbp.html)
- [butterbr](https://csound.com/docs/manual/butterbr.html)

**Related Filter Opcodes:**
- [tone](https://csound.com/docs/manual/tone.html) - 1st order lowpass
- [atone](https://csound.com/docs/manual/atone.html) - 1st order highpass
- [reson](https://csound.com/docs/manual/reson.html) - Resonant bandpass
- [moogladder](https://csound.com/docs/manual/moogladder.html) - Moog-style resonant LP
- [bqrez](https://csound.com/docs/manual/bqrez.html) - Biquad resonant filter

**Learning Resources:**
- Csound FLOSS Manual: Chapter 5.1 (Filters)
- "The Audio Programming Book" - Filter chapters
- Smith, Julius O.: "Introduction to Digital Filters"
- Zölzer, Udo: "DAFX: Digital Audio Effects"

**Mathematical References:**
- Butterworth, Stephen: "On the Theory of Filter Amplifiers" (1930)
- Oppenheim & Schafer: "Discrete-Time Signal Processing"
- Steiglitz, Ken: "A Digital Signal Processing Primer"
