Title: Additive Synthesis Techniques
Category: Synthesis/Additive
Difficulty: Beginner to Intermediate
Tags: additive, harmonics, partials, overtones, buzz, gbuzz, oscillator bank, spectrum, timbre, Fourier, sine waves, harmonic series

Description:
Additive synthesis builds complex timbres by combining multiple sine wave oscillators (partials). Based on Fourier theory, any periodic sound can be represented as a sum of sinusoids at harmonic or inharmonic frequencies. Csound provides several approaches: manual oscillator banks, GEN 10 for static spectra, buzz/gbuzz for band-limited pulse trains, and adsyn for analysis-based resynthesis. Additive synthesis offers precise control over spectral content and enables smooth timbral morphing.

================================================================================
EXAMPLE 1: Basic Additive Synthesis with Manual Oscillator Bank
================================================================================

Code:
```csound
<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps   = 10
nchnls  = 2
0dbfs   = 1

; Manual additive synthesis - 4 partials with individual control
        instr 1

idur    = p3
iamp    = p4
ifqc    = cpspch(p5)

; Vibrato common to all partials
kdvib   linseg  0, 0.1, 0, 0.1, 0.01, idur-0.2, 0.01
kvibr   oscil   kdvib, 6, 1

; Amplitude envelope
kamp    linseg  0, 0.01, iamp, idur-0.02, iamp*0.8, 0.01, 0
aamp    interp  kamp              ; Smooth to a-rate

; Four harmonic partials with decreasing amplitude
; Slight detuning between L/R creates stereo width
aout1L  oscil   aamp,     ifqc*1.001*(1+kvibr), 1
aout1R  oscil   aamp,     ifqc*0.999*(1+kvibr), 1
aout2L  oscil   aamp*0.5, ifqc*2.002*(1+kvibr), 1
aout2R  oscil   aamp*0.5, ifqc*1.998*(1+kvibr), 1
aout3L  oscil   aamp*0.33,ifqc*3.001*(1+kvibr), 1
aout3R  oscil   aamp*0.33,ifqc*2.999*(1+kvibr), 1
aout4L  oscil   aamp*0.25,ifqc*4.002*(1+kvibr), 1
aout4R  oscil   aamp*0.25,ifqc*3.998*(1+kvibr), 1

aoutL   = aout1L + aout2L + aout3L + aout4L
aoutR   = aout1R + aout2R + aout3R + aout4R

        outs    aoutL, aoutR
        endin

; 8-partial additive with harmonic series
        instr 2

idur    = p3
iamp    = p4
ifqc    = cpspch(p5)

kenv    linseg  0, 0.05, 1, idur-0.1, 0.7, 0.05, 0

; Harmonic amplitudes follow 1/n series (sawtooth-like)
a1      oscil   iamp,      ifqc*1, 1
a2      oscil   iamp/2,    ifqc*2, 1
a3      oscil   iamp/3,    ifqc*3, 1
a4      oscil   iamp/4,    ifqc*4, 1
a5      oscil   iamp/5,    ifqc*5, 1
a6      oscil   iamp/6,    ifqc*6, 1
a7      oscil   iamp/7,    ifqc*7, 1
a8      oscil   iamp/8,    ifqc*8, 1

aout    = (a1+a2+a3+a4+a5+a6+a7+a8) * kenv

        outs    aout, aout
        endin

</CsInstruments>
<CsScore>
f1 0 16384 10 1           ; Sine wave

; Basic 4-partial additive
i1 0 2 0.3 8.00
i1 2 2 0.3 8.07
i1 4 2 0.3 9.00

; 8-partial sawtooth approximation
i2 7 2 0.2 7.00
i2 9 2 0.2 8.00
e
</CsScore>
</CsoundSynthesizer>
```

Explanation:
Manual additive synthesis gives complete control over each partial:
- Each oscil generates one sinusoidal partial
- Frequency is a multiple of the fundamental (harmonic series: 1x, 2x, 3x...)
- Amplitude typically decreases for higher partials

Classic waveform approximations:
- **Sawtooth**: All harmonics, amplitude = 1/n
- **Square wave**: Odd harmonics only, amplitude = 1/n
- **Triangle**: Odd harmonics, amplitude = 1/n^2

The slight L/R detuning (1.001 vs 0.999) creates a natural stereo chorus effect without explicit chorus processing.

================================================================================
EXAMPLE 2: Table-Driven Additive with GEN 10
================================================================================

Code:
```csound
<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps   = 10
nchnls  = 2
0dbfs   = 1

; Single oscillator using GEN 10 pre-computed spectrum
        instr 1

idur    = p3
iamp    = p4
ifqc    = cpspch(p5)
itable  = p6              ; Waveform table

; Vibrato
kdvib   linseg  0, 0.1, 0, 0.1, 0.01, idur-0.2, 0.01
kvibr   oscil   kdvib, 6, 1

; Envelope
kamp    linseg  0, 0.01, iamp, idur-0.02, iamp*0.8, 0.01, 0
aamp    interp  kamp

; Stereo detuning
aoutL   oscil   aamp, ifqc*1.001*(1+kvibr), itable
aoutR   oscil   aamp, ifqc*0.999*(1+kvibr), itable

        outs    aoutL, aoutR
        endin

; Crossfade between two timbres
        instr 2

idur    = p3
iamp    = p4
ifqc    = cpspch(p5)
itab1   = p6              ; Starting timbre
itab2   = p7              ; Ending timbre

kenv    linseg  0, 0.01, 1, idur-0.02, 1, 0.01, 0
kmix    line    0, idur, 1  ; Crossfade position

a1      oscil   iamp, ifqc, itab1
a2      oscil   iamp, ifqc, itab2

; Linear crossfade between timbres
aout    = a1*(1-kmix) + a2*kmix

        outs    aout*kenv, aout*kenv
        endin

</CsInstruments>
<CsScore>
; GEN 10: harmonic partials with relative strengths
; f# time size GEN h1 h2 h3 h4 h5 h6...

; Sine wave (fundamental only)
f1 0 16384 10 1

; Sawtooth approximation (1/n series)
f2 0 16384 10 1 0.5 0.33 0.25 0.2 0.167 0.143 0.125

; Square wave (odd harmonics 1/n)
f3 0 16384 10 1 0 0.5 0 0.333 0 0.25 0 0.2 0 0.167

; Triangle wave (odd harmonics 1/n^2)
f4 0 16384 10 1 0 0.111 0 0.04 0 0.0204 0 0.0123 0 0.00826

; Vocal-like spectrum (custom)
f5 0 1024 10 1 0.3 0.1 0 0.2 0.02 0 0.1 0.04

; Hollow/clarinet-like (strong odd, weak even)
f6 0 16384 10 1 0 0.5 0 0.333 0 0 0 0.2 0 0.167

; Play different waveforms
i1 0  0.5 0.4 8.00 1    ; Sine
i1 +  0.5 0.4 8.00 2    ; Saw
i1 .  0.5 0.4 8.00 3    ; Square
i1 .  0.5 0.4 8.00 4    ; Triangle
i1 .  0.5 0.4 8.00 5    ; Vocal
i1 .  0.5 0.4 8.00 6    ; Hollow

; Timbre morphing: sine to saw
i2 4 4 0.3 8.00 1 2

; Timbre morphing: square to triangle
i2 9 4 0.3 7.00 3 4
e
</CsScore>
</CsoundSynthesizer>
```

Explanation:
**GEN 10** computes a waveform by summing harmonically-related sinusoids:
- Arguments after GEN number are relative harmonic strengths
- Harmonic 1 = fundamental, harmonic 2 = octave, harmonic 3 = octave+fifth, etc.
- The table is normalized automatically

Using pre-computed tables is more CPU efficient than multiple oscillators, but the spectrum is fixed. Timbre morphing can be achieved by crossfading between tables.

GEN 10 only supports harmonic (integer multiple) partials. For inharmonic spectra, use GEN 09 or GEN 19.

================================================================================
EXAMPLE 3: Dynamic Additive with Table-Controlled Envelopes
================================================================================

Code:
```csound
<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps   = 10
nchnls  = 2
0dbfs   = 1

; Four partials with independent amplitude and pitch envelopes
        instr 1

idur    = p3
iamp    = p4
ifqc    = cpspch(p5)
itabl0  = p6              ; Waveform table (sine)
itab1   = p7              ; Partial 1 amplitude envelope
itab2   = p8              ; Partial 2 amplitude envelope
itab3   = p9              ; Partial 3 amplitude envelope
itab4   = p10             ; Partial 4 amplitude envelope
ipch1   = p11             ; Partial 1 pitch envelope
ipch2   = p12             ; Partial 2 pitch envelope
ipch3   = p13             ; Partial 3 pitch envelope
ipch4   = p14             ; Partial 4 pitch envelope

; Read envelope tables once per note duration
; Amplitude envelopes
aamp1   oscil   1, 1/idur, itab1
aamp2   oscil   1, 1/idur, itab2
aamp3   oscil   1, 1/idur, itab3
aamp4   oscil   1, 1/idur, itab4

; Pitch ratio envelopes (multiply fundamental)
apch1   oscil   1, 1/idur, ipch1
apch2   oscil   1, 1/idur, ipch2
apch3   oscil   1, 1/idur, ipch3
apch4   oscil   1, 1/idur, ipch4

; Generate partials with dynamic amplitude and pitch
aout1   oscil   aamp1, ifqc*apch1, itabl0
aout2   oscil   aamp2, ifqc*apch2, itabl0
aout3   oscil   aamp3, ifqc*apch3, itabl0
aout4   oscil   aamp4, ifqc*apch4, itabl0

; Mix partials (different L/R balance)
aoutL   = (aout1 + aout2 + aout3) * iamp
aoutR   = (aout1 - aout3 + aout4) * iamp

        outs    aoutL, aoutR
        endin

</CsInstruments>
<CsScore>
; Sine wave for partials
f1 0 16384 10 1

; Amplitude envelope tables (read over note duration)
; Attack-decay envelope
f10 0 1024 7 0 100 1 200 0.7 724 0

; Slow attack, long sustain
f11 0 1024 7 0 300 1 624 1 100 0

; Percussive (fast attack, slow decay)
f12 0 1024 5 0.001 50 1 974 0.001

; Swell (crescendo-decrescendo)
f13 0 1024 7 0 512 1 512 0

; Pitch envelope tables (ratio multipliers)
; Stable at harmonic 1
f20 0 1024 7 1 1024 1

; Stable at harmonic 2
f21 0 1024 7 2 1024 2

; Glide from 2 to 3
f22 0 1024 7 2 1024 3

; Wobble around harmonic 4
f23 0 1024 7 4 256 4.1 256 3.9 256 4.1 256 4

;   Sta Dur  Amp  Pitch Wave AmpEnv1-4     PitchEnv1-4
i1  0   3    0.3  8.00  1    10 11 12 13   20 21 22 23
i1  4   3    0.3  7.07  1    11 10 13 12   20 21 22 23
i1  8   5    0.3  7.00  1    12 12 12 12   20 21 22 23
e
</CsScore>
</CsoundSynthesizer>
```

Explanation:
This technique uses function tables to control amplitude and pitch of each partial independently:

- **Amplitude tables**: Define how each partial's loudness evolves over the note
- **Pitch tables**: Define pitch ratio (e.g., 2 = octave above fundamental)

Reading tables with oscil at 1/idur Hz reads through the entire table once per note. This allows:
- Different attack times for each partial (realistic instrument behavior)
- Pitch glides or vibrato on individual partials
- Complex timbral evolution over time

Real acoustic instruments have partials that enter and decay at different rates. This technique can model that behavior precisely.

================================================================================
EXAMPLE 4: Band-Limited Pulse Trains with buzz and gbuzz
================================================================================

Code:
```csound
<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps   = 100
nchnls  = 2
0dbfs   = 1

; Basic buzz - all harmonics equal amplitude
        instr 1

idur    = p3
iamp    = p4
ifqc    = p5

; Calculate max harmonics to avoid aliasing
; Nyquist = sr/2, highest harmonic must be below Nyquist
inmh    = int(sr/2/ifqc)

; Envelope
aenv    linen   iamp, 0.2, idur, 0.2

; buzz generates pulse train with inmh harmonics
asrc    buzz    aenv, ifqc, inmh, 1

        outs    asrc, asrc
        endin

; gbuzz with amplitude ratio control
        instr 2

idur    = p3
iamp    = p4
ifqc    = p5
inmh    = int(sr/2/ifqc)   ; Number of harmonics
ilh     = 1                 ; Lowest harmonic (1 = fundamental)

; Cosine table required for gbuzz
ifn     = 5

; Amplitude envelope
aenv    linen   iamp, 0.2, idur, 0.2

; kratio controls amplitude rolloff between harmonics
; kratio = 1: all harmonics equal (bright, buzzy)
; kratio = 0.5: each harmonic half the previous (warmer)
; kratio = 0: only fundamental (sine wave)
kratio  linseg  1, idur/2, 0, idur/4, 0.8, idur/4, 0.6

asrc    gbuzz   aenv, ifqc, inmh, ilh, kratio, ifn

        outs    asrc, asrc
        endin

; gbuzz for PWM-like sounds
        instr 3

idur    = p3
iamp    = p4
ifqc    = p5

inmh    = int(sr/2/ifqc)

aenv    linen   iamp, 0.01, idur, 0.1

; Modulate ratio for timbral movement
kratio  oscil   0.4, 0.5, 1    ; LFO
kratio  = 0.5 + kratio         ; Center around 0.5

asrc    gbuzz   aenv, ifqc, inmh, 1, kratio, 5

        outs    asrc, asrc
        endin

; Subtractive-style: buzz through filter
        instr 4

idur    = p3
iamp    = p4
ifqc    = cpspch(p5)
ifco    = p6              ; Filter cutoff
ires    = p7              ; Filter resonance

inmh    = int(sr/2/ifqc)

; Filter envelope
kfco    expseg  ifco*4, 0.1, ifco, idur-0.1, ifco*0.5
kamp    linseg  0, 0.002, iamp, 0.2, iamp*0.8, idur-0.222, iamp*0.5, 0.02, 0

; Generate harmonically rich source
asrc    buzz    1, ifqc, inmh, 1

; Resonant lowpass filter
afilt   moogladder asrc, kfco, ires

        outs    afilt*kamp, afilt*kamp
        endin

</CsInstruments>
<CsScore>
; Sine wave for buzz
f1 0 8193 10 1

; Cosine wave for gbuzz (required!)
f5 0 8193 11 1 1

; Basic buzz at different frequencies
;   dur  amp  freq
i1 0  2  0.3  55
i1 +  2  0.3  110
i1 .  2  0.3  440
i1 .  2  0.3  1760

; gbuzz with dynamic ratio
i2 9  10 0.3  220

; gbuzz PWM-like
i3 20 4  0.3  110

; Subtractive style: buzz + filter
;    dur  amp  pitch  cutoff  res
i4 25 2  0.5  7.00   2000    0.3
i4 +  2  0.5  7.05   4000    0.5
i4 .  2  0.5  7.07   1000    0.7
e
</CsScore>
</CsoundSynthesizer>
```

Explanation:
**buzz** generates a band-limited pulse train (all harmonics at equal amplitude):
- inmh = number of harmonics
- Must use cosine table (GEN 11) as function
- Bright, buzzy timbre

**gbuzz** adds a ratio parameter for harmonic amplitude control:
- kratio controls amplitude relationship between successive harmonics
- kratio = 1: equal amplitudes (like buzz)
- kratio < 1: higher harmonics weaker (warmer sound)
- kratio > 1: higher harmonics stronger (unusual, harsh)
- kratio = 0: sine wave only

Anti-aliasing: Calculate inmh = sr/2/ifqc to ensure the highest harmonic stays below the Nyquist frequency. This prevents aliasing artifacts.

gbuzz is excellent for:
- PWM-like timbral animation (modulate kratio)
- Subtractive synthesis source (feed into filters)
- Organ-like tones

================================================================================
EXAMPLE 5: Analysis-Based Resynthesis with adsyn
================================================================================

Code:
```csound
<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps   = 10
nchnls  = 1
0dbfs   = 1

; adsyn resynthesis from analysis file
        instr 1

idur    = p3
iamp    = p4
ispeed1 = p5              ; Starting playback speed
ispeed2 = p6              ; Ending playback speed
ifrq1   = p7              ; Starting frequency multiplier
ifrq2   = p8              ; Middle frequency multiplier
ifrq3   = p9              ; Ending frequency multiplier
iaession  = p10           ; Analysis file number

; Speed envelope (time-stretching)
kspeed  line    ispeed1, idur, ispeed2

; Frequency envelope (pitch shifting)
kfreq   linseg  ifrq1, idur*0.5, ifrq2, idur*0.5, ifrq3

; adsyn: resynthesis from analysis file
; kaession = amplitude scale, kfreq = frequency scale, kspeed = time scale
asig    adsyn   iamp, kfreq, kspeed, iaession

        out     asig
        endin

; Simple adsyn playback
        instr 2

idur    = p3
iaession  = p4

; Normal speed, normal pitch
asig    adsyn   1, 1, 1, iaession

kenv    linseg  0, 0.01, 1, idur-0.02, 1, 0.01, 0

        out     asig * kenv
        endin

</CsInstruments>
<CsScore>
; adsyn requires pre-analyzed files (created with hetro utility)
; Analysis file contains time-varying amplitude and frequency for each partial

; Time-stretch and pitch-shift effects
;   dur amp  sp1  sp2  frq1 frq2 frq3 file
i1 0   3   1    1    2    1    0.5  4    1
i1 4   3   2    1    0.5  1    2    0.5  1
i1 8   3   0.2  1    2    1    0.5  4    1

; Multiple layers
i1 8   3   0.2  1    0.5  1    2    0.5  1
i1 8   3   0.2  2    0.5  8    0.5  1    1

; Very slow playback (time stretch)
i1 12  150 1    0.05 0.05 1    1    1    1
e
</CsScore>
</CsoundSynthesizer>
```

Explanation:
**adsyn** performs additive resynthesis from analysis data:
- Analysis files are created using the **hetro** utility (heterodyne filter analysis)
- Contains time-varying frequency and amplitude for each detected partial
- Allows independent time and pitch manipulation

Parameters:
- kaession: Amplitude scale factor
- kfreq: Frequency multiplier (pitch shift)
- kspeed: Time scale (playback speed, affects duration)

adsyn enables:
- Time-stretching without pitch change (kspeed < 1, kfreq = 1)
- Pitch shifting without time change (kspeed = 1, kfreq != 1)
- Combined transformations
- Cross-synthesis (using analysis from one sound with different control)

Creating analysis files:
```bash
hetro -s44100 -b0 -d2.5 -f100 -h20 input.wav output.adf
```
- -s: sample rate
- -b: begin time
- -d: duration
- -f: fundamental estimate
- -h: number of harmonics to track

================================================================================
EXAMPLE 6: Band-Limited Waveform Generation for Anti-Aliased Synthesis
================================================================================

Code:
```csound
<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps   = 10
nchnls  = 2
0dbfs   = 1

; Band-limited sawtooth using buzz + integrator
        instr 1

idur    = p3
iamp    = p4
ifqc    = cpspch(p5)
ifco    = p6
irez    = p7

inmh    = int(sr/2/ifqc)      ; Max harmonics before aliasing

kfco    expseg  100+ifco, 0.2*idur, ifco+100, 0.5*idur, ifco*0.1+100, 0.3*idur, ifco*0.001+100
kamp    linseg  0, 0.002, iamp, 0.2, iamp*0.8, idur-0.222, iamp*0.5, 0.02, 0

; buzz generates harmonically complete pulse
apulse  buzz    1, ifqc, inmh, 1

; Leaky integrator converts pulse to sawtooth
; biquad as integrator: y[n] = x[n] + 0.999*y[n-1]
asaw    biquad  apulse, 1, 0, 0, 1, -0.999, 0

; Resonant filter
afilt   moogladder asaw, kfco, irez

        outs    afilt*kamp, afilt*kamp
        endin

; Band-limited square from two saws
        instr 2

idur    = p3
iamp    = p4
ifqc    = cpspch(p5)
ipw     = p6              ; Pulse width (0-1)

inmh    = int(sr/2/ifqc)

kamp    linseg  0, 0.01, iamp, idur-0.02, iamp, 0.01, 0

; Two phase-offset sawtooths
apulse1 buzz    1, ifqc, inmh, 1
asaw1   biquad  apulse1, 1, 0, 0, 1, -0.999, 0

; Delayed version (pulse width offset)
adel    vdelay  asaw1, 1000*ipw/ifqc, 50

; Subtract to get square/PWM
asquare = asaw1 - adel

        outs    asquare*kamp, asquare*kamp
        endin

; Frequency-adaptive harmonic count
        instr 3

idur    = p3
iamp    = p4

; Pitch glide
kfqc    expseg  50, idur, 2000

; Dynamically calculate max harmonics
knmh    = int(sr/2/kfqc)

kamp    linseg  0, 0.01, iamp, idur-0.02, iamp, 0.01, 0

; gbuzz with adaptive harmonic count
asig    gbuzz   kamp, kfqc, knmh, 1, 0.7, 5

        outs    asig, asig
        endin

</CsInstruments>
<CsScore>
f1 0 16384 10 1           ; Sine
f5 0 8193 11 1 1          ; Cosine for gbuzz

; Band-limited saw through filter
;    dur  amp  pitch  cutoff  rez
i1  0    2    0.5    7.05    1000    0.1
i1  +    2    0.5    6.03    2000    0.2
i1  .    2    0.5    6.10    4000    0.4
i1  .    2    0.5    7.05    8000    0.8

; PWM-style square wave
;    dur  amp  pitch  pw
i2  9    2    0.3    7.00    0.5     ; 50% = square
i2  +    2    0.3    7.00    0.25    ; 25% pulse
i2  .    2    0.3    7.00    0.1     ; 10% pulse

; Adaptive harmonics during pitch glide
i3  16   8    0.3
e
</CsScore>
</CsoundSynthesizer>
```

Explanation:
**Band-limiting** prevents aliasing when generating classic waveforms:

1. **Buzz + Integrator method**:
   - buzz generates a harmonically-limited pulse train
   - A leaky integrator (biquad with feedback ~0.999) converts pulse to saw
   - Result is alias-free sawtooth at any frequency

2. **Two-saw method for square/PWM**:
   - Generate two sawtooths
   - Delay one by the pulse width
   - Subtract to get square/rectangle wave
   - Pulse width controls duty cycle (0.5 = square)

3. **Adaptive harmonics**:
   - Recalculate knmh = sr/2/kfqc continuously
   - Higher pitches get fewer harmonics automatically
   - Prevents aliasing during pitch sweeps

The biquad integrator formula:
- b0=1, b1=0, b2=0 (feedforward)
- a0=1, a1=-0.999, a2=0 (feedback)
- "Leaky" prevents DC buildup while maintaining saw shape

Variations:
1. Use different kratio values in gbuzz for various timbres
2. Modulate pulse width for classic PWM animation
3. Layer multiple detuned oscillators for supersaw
4. Apply formant filters for vocal-like additive sounds
5. Use GEN 09/19 for inharmonic additive spectra

Common Issues:

1. **Aliasing**: High frequencies fold back as artifacts. Always calculate max harmonics: nmh = sr/2/freq. Use band-limited techniques for frequencies above ~500 Hz.

2. **DC offset**: Some additive configurations produce DC. Use dcblock or highpass filter to remove.

3. **CPU load**: Many oscillators consume significant CPU. Use GEN 10 tables when spectrum is static, or reduce partial count for background sounds.

4. **Phase alignment**: Starting phases affect timbre. For consistent sound, initialize phases or use phase-aligned tables.

5. **Amplitude scaling**: Sum of many partials can exceed 0dB. Scale amplitude by 1/num_partials or use a limiter.

6. **gbuzz requires cosine**: Using a sine table with gbuzz produces incorrect results. Always use GEN 11 for the cosine table.

Related Examples:
- csound_fm_synthesis_entry.md (alternative approach to complex spectra)
- csound_fof_formant_synthesis_entry.md (formant-based additive)
- csound_granular_synthesis_entry.md (grain-based timbres)
- csound_butterworth_filters_entry.md (subtractive filtering)
