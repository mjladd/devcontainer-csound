Title: Dynamics Processing - Compression, Limiting, and Gain Control
Category: Effects/Dynamics
Difficulty: Intermediate
Tags: compressor, limiter, dynamics, gain, rms, balance, envelope follower, sidechain, threshold, ratio, attack, release, dam, compress, clip, normalize

Description:
Dynamics processing controls the amplitude range of audio signals. Csound provides several opcodes for dynamics control: compress for professional compression/limiting, dam for dynamic amplitude modification, balance for amplitude matching, gain for automatic gain control, and envelope followers (rms, follow, follow2) for extracting amplitude envelopes. This entry covers compression, limiting, gating, and related techniques essential for mixing, mastering, and sound design.

================================================================================
EXAMPLE 1: Basic Compressor using compress Opcode
================================================================================

Code:
```csound
<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps   = 32
nchnls  = 2
0dbfs   = 1

; Basic compression with compress opcode
        instr 1

ain     diskin2 "drums.wav", 1, 0, 1  ; Loop playback

; compress parameters
ithresh = ampdb(p4)       ; Threshold in dB -> linear
iratio  = p5              ; Compression ratio (e.g., 4 = 4:1)
iatt    = p6              ; Attack time in seconds
irel    = p7              ; Release time in seconds
ilook   = 0.01            ; Lookahead time (for limiting)

; Knee width: 0 = hard knee, higher = softer knee
iknee   = 6               ; 6 dB soft knee

; compress: aout compress asig, acomp, kthresh, kloknee, khiknee, kratio, katt, krel, ilook
; asig = signal to compress
; acomp = signal for sidechain detection (usually same as asig)
; kthresh = threshold level
; kloknee/khiknee = knee points (for soft knee)

aout    compress ain, ain, ithresh, ithresh-iknee, ithresh, 1/iratio, iatt, irel, ilook

; Makeup gain to compensate for compression
igain   = p8              ; Makeup gain in dB
aout    = aout * ampdb(igain)

        outs    aout, aout
        endin

; Hard limiter
        instr 2

ain     diskin2 "drums.wav", 1, 0, 1

; Limiter = compressor with very high ratio
ithresh = ampdb(-3)       ; -3 dB ceiling
iratio  = 20              ; 20:1 ratio (effectively limiting)
iatt    = 0.001           ; Very fast attack (1ms)
irel    = 0.1             ; 100ms release
ilook   = 0.005           ; 5ms lookahead

aout    compress ain, ain, ithresh, ithresh, ithresh, 1/iratio, iatt, irel, ilook

        outs    aout, aout
        endin

</CsInstruments>
<CsScore>
; Moderate compression
;   dur  thresh ratio  att    rel    makeup
i1  0    8    -20      4      0.01   0.2    6

; Heavy compression (squash)
i1  10   8    -30      8      0.001  0.3    12

; Limiter
i2  20   8
e
</CsScore>
</CsoundSynthesizer>
```

Explanation:
The **compress** opcode implements a standard dynamics processor:

Key parameters:
- **kthresh**: Level above which compression begins
- **kloknee/khiknee**: Soft knee range (set equal for hard knee)
- **kratio**: Compression ratio as a fraction (1/4 for 4:1)
- **katt**: Attack time - how fast compression engages
- **krel**: Release time - how fast compression releases
- **ilook**: Lookahead time - delays audio to allow anticipatory gain reduction

Attack/Release guidelines:
- Fast attack (1-10ms): Catches transients, can sound "pumpy"
- Slow attack (20-100ms): Lets transients through, more natural
- Fast release (50-100ms): Quick recovery, more aggressive
- Slow release (200-500ms): Smoother, less pumping

Ratio meanings:
- 2:1 = gentle compression
- 4:1 = moderate compression
- 8:1 = heavy compression
- 20:1+ = limiting

================================================================================
EXAMPLE 2: Sidechain Compression
================================================================================

Code:
```csound
<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps   = 32
nchnls  = 2
0dbfs   = 1

; Sidechain compression - "ducking" effect
        instr 1

; Main signal (e.g., synth pad)
apad    oscil   0.5, cpspch(p4), 1
apad    = apad + oscil:a(0.3, cpspch(p4)*2.01, 1)  ; Add slight detune

; Sidechain trigger (e.g., kick drum)
akick   diskin2 "kick.wav", 1, 0, 1

; compress using kick as sidechain detector
; The pad gets compressed when the kick hits
ithresh = ampdb(-20)
iratio  = 8
iatt    = 0.005           ; Fast attack for tight ducking
irel    = 0.15            ; Medium release for pumping effect

; First argument = signal to compress (pad)
; Second argument = sidechain signal (kick)
acomp   compress apad, akick, ithresh, ithresh, ithresh, 1/iratio, iatt, irel, 0.01

; Mix kick and compressed pad
aout    = acomp + akick * 0.8

        outs    aout, aout
        endin

; Frequency-selective sidechain (de-esser style)
        instr 2

ain     diskin2 "vocal.wav", 1, 0, 1

; High-frequency sidechain for de-essing
; Filter to isolate sibilants (4-8kHz)
aside   butterhp ain, 4000
aside   butterlp aside, 10000

; Compress full signal based on high-frequency content
ithresh = ampdb(-30)
iratio  = 6
iatt    = 0.001
irel    = 0.05

aout    compress ain, aside, ithresh, ithresh, ithresh, 1/iratio, iatt, irel, 0.002

        outs    aout, aout
        endin

</CsInstruments>
<CsScore>
f1 0 16384 10 1 0.5 0.3 0.2 0.1

; Sidechain ducking
i1 0 16 7.00

; De-esser
i2 20 10
e
</CsScore>
</CsoundSynthesizer>
```

Explanation:
**Sidechain compression** uses a different signal to control compression:

1. **Ducking**: Classic EDM effect where kick triggers pad compression, creating rhythmic "pumping"
2. **De-essing**: Filter the sidechain to target sibilants, compressing only when "s" sounds occur

The key is separating:
- Signal being compressed (asig - first argument)
- Signal controlling compression (acomp - second argument)

For ducking:
- Fast attack catches kick transient immediately
- Release time controls "pumping" speed
- Threshold determines ducking depth

================================================================================
EXAMPLE 3: Dynamic Amplitude Modifier (dam)
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

; dam - Dynamic Amplitude Modifier
; More flexible than compress for some applications
        instr 1

ain     diskin2 "music.wav", 1, 0, 1

; dam parameters
ithresh = ampdb(p4)       ; Threshold
icomp1  = p5              ; Compression ratio below threshold
icomp2  = p6              ; Compression ratio above threshold (expansion if > 1)
irtime  = p7              ; Response time (averaging time)
iatt    = p8              ; Attack time

; dam asig, kthresh, icomp1, icomp2, irtime, iatt
; comp1 = 1 means no change below threshold
; comp2 < 1 means compression above threshold
; comp2 > 1 means expansion above threshold

aout    dam     ain, ithresh, icomp1, icomp2, irtime, iatt

        outs    aout, aout
        endin

; Upward compression (raise quiet parts)
        instr 2

ain     diskin2 "vocal.wav", 1, 0, 1

; Boost signals below threshold
ithresh = ampdb(-30)
iboost  = 2               ; Boost ratio below threshold
icomp   = 0.5             ; Compress above threshold

aout    dam     ain, ithresh, iboost, icomp, 0.02, 0.01

; Apply makeup gain
aout    = aout * 0.7

        outs    aout, aout
        endin

; Noise gate using dam
        instr 3

ain     diskin2 "noisy.wav", 1, 0, 1

; Gate: heavily reduce signal below threshold
ithresh = ampdb(-40)      ; Gate threshold
igate   = 0.01            ; Almost silence below threshold
inorm   = 1               ; Normal above threshold

aout    dam     ain, ithresh, igate, inorm, 0.005, 0.001

        outs    aout, aout
        endin

</CsInstruments>
<CsScore>
; Standard compression
;   dur  thresh comp1  comp2  rtime  att
i1  0    8    -20     1      0.5    0.02   0.01

; Upward compression
i2  10   8

; Noise gate
i3  20   8
e
</CsScore>
</CsoundSynthesizer>
```

Explanation:
**dam** (Dynamic Amplitude Modifier) provides flexible dynamics control:

- **kthresh**: Amplitude threshold dividing two behaviors
- **icomp1**: Compression ratio for signals BELOW threshold
- **icomp2**: Compression ratio for signals ABOVE threshold
- **irtime**: RMS averaging time for level detection
- **iatt**: Attack time for gain changes

Applications:
1. **Standard compression**: comp1=1, comp2<1 (compress above threshold)
2. **Upward compression**: comp1>1, comp2=1 (boost below threshold)
3. **Expansion**: comp1=1, comp2>1 (increase dynamics above threshold)
4. **Noise gate**: comp1≈0, comp2=1 (silence below threshold)

dam is simpler than compress but lacks soft knee and lookahead.

================================================================================
EXAMPLE 4: Balance - Amplitude Matching
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

; balance - match amplitude of one signal to another
        instr 1

; Generate filtered noise (resonant filter boosts amplitude)
anoise  rand    0.5
ifqc    = cpspch(p4)

; Resonant filter greatly boosts amplitude at center frequency
afilt   reson   anoise, ifqc, ifqc/10

; balance restores original amplitude envelope
aout    balance afilt, anoise

kenv    linseg  0, 0.01, 1, p3-0.02, 1, 0.01, 0

        outs    aout*kenv, aout*kenv
        endin

; Vocoder-style amplitude transfer
        instr 2

; Modulator (controls amplitude)
amod    diskin2 "voice.wav", 1, 0, 1

; Carrier (provides timbre)
acar    buzz    1, cpspch(p4), 50, 1

; Filter both to same band
ifqc    = 1000
ibw     = 200

amodf   butterbp amod, ifqc, ibw
acarf   butterbp acar, ifqc, ibw

; Transfer modulator's amplitude to carrier
aout    balance acarf, amodf

        outs    aout, aout
        endin

; Multi-band processing with balance
        instr 3

ain     diskin2 "drums.wav", 1, 0, 1

; Split into bands
alow    butterlp ain, 200
amid    butterbp ain, 1000, 800
ahigh   butterhp ain, 4000

; Process each band differently
; Heavy compression on low end
alow2   compress alow, alow, 0.1, 0.1, 0.1, 0.25, 0.01, 0.1, 0.01

; Light compression on mids
amid2   compress amid, amid, 0.2, 0.2, 0.2, 0.5, 0.005, 0.05, 0.005

; Limit highs
ahigh2  compress ahigh, ahigh, 0.3, 0.3, 0.3, 0.1, 0.001, 0.02, 0.002

; Balance to restore original band levels
alow3   balance alow2, alow
amid3   balance amid2, amid
ahigh3  balance ahigh2, ahigh

; Recombine
aout    = alow3 + amid3 + ahigh3

        outs    aout, aout
        endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1

; Resonant filter with balance
i1 0 2 8.00
i1 2 2 8.05
i1 4 2 8.09

; Vocoder-style
i2 7 8 7.00

; Multiband compression
i3 16 8
e
</CsScore>
</CsoundSynthesizer>
```

Explanation:
**balance** adjusts one signal's amplitude to match another's RMS envelope:

```
aout balance asig, acomp [, ihp] [, ihalfamp]
```

- asig: Signal whose amplitude will be adjusted
- acomp: Reference signal providing target amplitude
- ihp: Highpass filter frequency for envelope detection (default 10 Hz)
- ihalfamp: Envelope follower half-time (default 0.5 sec)

Common uses:
1. **Post-filter normalization**: Resonant filters boost amplitude; balance restores original level
2. **Vocoder bands**: Transfer speech amplitude to carrier signal
3. **Multiband processing**: After processing each band, use balance to maintain original band balance

balance is essential whenever processing changes amplitude unpredictably (filters, waveshaping, etc.).

================================================================================
EXAMPLE 5: Envelope Followers (rms, follow, follow2)
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

; RMS envelope follower
        instr 1

ain     diskin2 "drums.wav", 1, 0, 1

; rms returns RMS amplitude
; ihp = highpass cutoff for envelope smoothing
krms    rms     ain, 20       ; 20 Hz smoothing

; Use RMS to control filter cutoff (auto-wah)
kfilt   = 200 + krms * 10000

afilt   moogladder ain, kfilt, 0.4

        outs    afilt, afilt
        endin

; follow - simple envelope follower
        instr 2

ain     diskin2 "drums.wav", 1, 0, 1

; follow tracks peak amplitude with smoothing
kenv    follow  ain, 0.01     ; 10ms averaging

; Use envelope for tremolo depth
klfo    oscil   0.5, 4, 1
kmod    = 1 - kenv * klfo     ; Less tremolo when loud

aout    = ain * kmod

        outs    aout, aout
        endin

; follow2 - separate attack/release times
        instr 3

ain     diskin2 "drums.wav", 1, 0, 1

; follow2 allows different attack and release
; Useful for precise envelope shaping
kenv    follow2 ain, 0.001, 0.1   ; 1ms attack, 100ms release

; Gate: only pass signal above threshold
kthresh = 0.1
kgate   = (kenv > kthresh) ? 1 : 0

; Smooth the gate to avoid clicks
kgate   port    kgate, 0.01

aout    = ain * kgate

        outs    aout, aout
        endin

; Custom compressor using envelope follower
        instr 4

ain     diskin2 "drums.wav", 1, 0, 1

; Get envelope
kenv    follow2 ain, 0.005, 0.05

; Calculate gain reduction
kthresh = 0.3
kratio  = 4

; Below threshold: gain = 1
; Above threshold: compressed gain
if kenv < kthresh then
    kgain = 1
else
    ; Compression formula
    kover = kenv - kthresh
    kgain = (kthresh + kover/kratio) / kenv
endif

; Apply gain with smoothing
kgain   port    kgain, 0.01
aout    = ain * kgain

; Makeup gain
aout    = aout * 1.5

        outs    aout, aout
        endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1

; RMS auto-wah
i1 0 8

; Envelope-controlled tremolo
i2 10 8

; Envelope gate
i3 20 8

; Custom compressor
i4 30 8
e
</CsScore>
</CsoundSynthesizer>
```

Explanation:
Envelope followers extract amplitude information for control purposes:

**rms**: Returns RMS (Root Mean Square) amplitude
- More accurate representation of perceived loudness
- ihp parameter controls smoothing

**follow**: Simple peak follower
- Tracks amplitude peaks with single time constant
- Good for general envelope extraction

**follow2**: Separate attack/release times
- iatt: How fast it responds to increases
- irel: How fast it responds to decreases
- Essential for musical dynamics control

Applications:
1. **Auto-wah**: Envelope controls filter cutoff
2. **Envelope-controlled effects**: Depth, rate, or mix follow amplitude
3. **Noise gates**: Mute when envelope below threshold
4. **Custom compressors**: Build compressor from envelope + gain calculation

================================================================================
EXAMPLE 6: Gain Staging and Limiting
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

; gain opcode for automatic gain control
        instr 1

ain     diskin2 "music.wav", 1, 0, 1

; gain adjusts signal to target RMS level
; gain asig, krms [, ihp]
itarget = ampdb(-12)      ; Target -12 dB RMS

aout    gain    ain, itarget, 10

        outs    aout, aout
        endin

; Hard clipping
        instr 2

ain     diskin2 "music.wav", 1, 0, 1

; Boost signal
ain     = ain * ampdb(p4)

; clip limits amplitude to specified range
; clip asig, imeth, ilimit [, iarg]
; imeth: 0=Bram de Jong, 1=sine, 2=tanh
ilimit  = 0.9

aout    clip    ain, 0, ilimit

        outs    aout, aout
        endin

; Soft saturation using tanh
        instr 3

ain     diskin2 "music.wav", 1, 0, 1

; Drive into saturation
kdrive  = ampdb(p4)

; tanh provides musical soft clipping
asat    = tanh(ain * kdrive)

; Compensate for level reduction
aout    = asat * (1/tanh(kdrive))

kenv    linseg  0, 0.01, 1, p3-0.02, 1, 0.01, 0

        outs    aout*kenv, aout*kenv
        endin

; Brick-wall limiter
        instr 4

ain     diskin2 "music.wav", 1, 0, 1

; Boost input
ain     = ain * ampdb(6)

; Very fast attack limiter
ithresh = ampdb(-1)       ; -1 dB ceiling
iratio  = 100             ; Essentially infinite ratio
iatt    = 0.0001          ; 0.1ms attack
irel    = 0.05            ; 50ms release
ilook   = 0.005           ; 5ms lookahead

aout    compress ain, ain, ithresh, ithresh, ithresh, 1/iratio, iatt, irel, ilook

        outs    aout, aout
        endin

; Multiband limiter for mastering
        instr 5

ain     diskin2 "music.wav", 1, 0, 1

; Three-band split
alow    butterlp ain, 150
amid    butterbp ain, 1500, 2700
ahigh   butterhp ain, 6000

; Individual limiters per band
ithresh = ampdb(-3)

alow2   compress alow, alow, ithresh*1.5, ithresh*1.5, ithresh*1.5, 0.02, 0.001, 0.1, 0.005
amid2   compress amid, amid, ithresh, ithresh, ithresh, 0.02, 0.0005, 0.05, 0.003
ahigh2  compress ahigh, ahigh, ithresh*0.7, ithresh*0.7, ithresh*0.7, 0.02, 0.0002, 0.03, 0.002

; Recombine
aout    = alow2 + amid2 + ahigh2

; Final limiter
aout    compress aout, aout, ampdb(-0.3), ampdb(-0.3), ampdb(-0.3), 0.01, 0.0001, 0.05, 0.005

        outs    aout, aout
        endin

</CsInstruments>
<CsScore>
; Automatic gain control
i1 0 8

; Hard clipping (+12dB drive)
i2 10 8 12

; Soft saturation
i3 20 8 12

; Brick-wall limiter
i4 30 8

; Multiband mastering limiter
i5 40 8
e
</CsScore>
</CsoundSynthesizer>
```

Explanation:
**gain**: Automatic Gain Control (AGC)
- Adjusts signal to target RMS level
- Useful for normalizing inconsistent sources

**clip**: Hard limiting/clipping
- Method 0: Bram de Jong soft clip
- Method 1: Sine-based soft clip
- Method 2: tanh saturation

**tanh saturation**: Musical soft clipping
- Gentle compression of peaks
- Adds subtle harmonic warmth
- Natural limiting behavior

**Brick-wall limiter**: Using compress with:
- Very high ratio (50:1 to 100:1)
- Very fast attack (<1ms)
- Lookahead for true peak limiting

**Multiband limiting**: Process frequency bands separately
- Low end can tolerate slower attack
- High frequencies need faster response
- Prevents one band from triggering whole-mix limiting

Variations:
1. Use dam for simpler dynamics control
2. Chain multiple stages of gentle compression
3. Parallel compression: mix compressed and dry signals
4. Add makeup gain automation based on gain reduction
5. Use envelope followers to trigger other effects

Common Issues:

1. **Pumping/breathing**: Release time too fast. Increase release or use auto-release.

2. **Transient loss**: Attack too fast. Slow attack or use parallel compression to preserve punch.

3. **Over-compression**: Too low threshold or high ratio. Use gentler settings and multiple stages.

4. **Distortion on bass**: Compressor reacting to sub frequencies. Use highpass filter on sidechain or multiband.

5. **Clicks at gate open/close**: Gate transition too abrupt. Add short attack/release on gate or use port to smooth.

6. **Level inconsistency after compression**: Always add makeup gain to compensate for gain reduction.

7. **Phase issues in multiband**: Crossover filters cause phase shifts. Use linear-phase filters or accept coloration.

Related Examples:
- csound_filter_bank_vocoder_entry.md (envelope following for vocoder)
- csound_distortion_waveshaping_entry.md (saturation techniques)
- csound_reverb_design_entry.md (dynamics before/after reverb)
