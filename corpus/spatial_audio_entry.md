Title: Multi-channel and Spatial Audio Processing
Category: Spatial Audio/Panning
Difficulty: Intermediate to Advanced
Tags: panning, stereo, spatial, 3D audio, HRTF, binaural, Doppler, distance, multichannel, surround, quadraphonic, ambisonics, localization, pan, pan2, locsig, spat3d

Description:
Spatial audio creates the illusion of sound sources positioned in space around the listener. Csound provides multiple approaches: simple stereo panning (linear, equal-power, constant-power), distance simulation (amplitude falloff, filtering), Doppler effect for moving sources, HRTF-based binaural processing for headphone playback, and multi-channel output for surround systems. This entry covers panning laws, spatial positioning, and realistic 3D audio simulation.

================================================================================
EXAMPLE 1: Stereo Panning Techniques
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

; Linear panning (causes center dip)
        instr 1

iamp    = p4
ifqc    = cpspch(p5)
ipan    = p6              ; 0 = left, 1 = right

asig    oscil   iamp, ifqc, 1
kenv    linseg  0, 0.01, 1, p3-0.02, 1, 0.01, 0

; Simple linear panning
; Problem: perceived loudness drops at center
        outs    asig*kenv*(1-ipan), asig*kenv*ipan
        endin

; Square-root (equal-power) panning
        instr 2

iamp    = p4
ifqc    = cpspch(p5)
ipan    = p6

asig    oscil   iamp, ifqc, 1
kenv    linseg  0, 0.01, 1, p3-0.02, 1, 0.01, 0

; Equal-power panning maintains constant perceived loudness
; sqrt(L^2 + R^2) = constant
        outs    asig*kenv*sqrt(1-ipan), asig*kenv*sqrt(ipan)
        endin

; Constant-power (sine/cosine) panning
        instr 3

iamp    = p4
ifqc    = cpspch(p5)
ipan    = p6              ; 0-1 range
ipi     = 3.14159265

asig    oscil   iamp, ifqc, 1
kenv    linseg  0, 0.01, 1, p3-0.02, 1, 0.01, 0

; Convert 0-1 to angle (0 to pi/2)
iangle  = ipan * ipi / 2

; Constant-power: cos(angle) and sin(angle)
; Also known as "pan law"
ileft   = cos(iangle)
iright  = sin(iangle)

        outs    asig*kenv*ileft, asig*kenv*iright
        endin

; Automated panning (LFO-controlled)
        instr 4

iamp    = p4
ifqc    = cpspch(p5)
ipanrate = p6             ; Pan oscillation rate

asig    oscil   iamp, ifqc, 1
kenv    linseg  0, 0.01, 1, p3-0.02, 1, 0.01, 0

; LFO generates pan position 0-1
kpan    oscil   0.5, ipanrate, 1
kpan    = kpan + 0.5      ; Scale to 0-1 range

; Apply equal-power panning
        outs    asig*kenv*sqrt(1-kpan), asig*kenv*sqrt(kpan)
        endin

; Using built-in pan2 opcode
        instr 5

iamp    = p4
ifqc    = cpspch(p5)
ipan    = p6              ; 0 = left, 1 = right
itype   = p7              ; 0=equal power, 1=linear, 2=sqrt

asig    oscil   iamp, ifqc, 1
kenv    linseg  0, 0.01, 1, p3-0.02, 1, 0.01, 0

; pan2 provides multiple panning laws
aL, aR  pan2    asig*kenv, ipan, itype

        outs    aL, aR
        endin

</CsInstruments>
<CsScore>
f1 0 16384 10 1

; Compare panning laws - sweep from left to right
; Linear (hear the center dip)
i1 0 2 0.3 8.00 0
i1 2 2 0.3 8.00 0.5
i1 4 2 0.3 8.00 1

; Equal-power (constant loudness)
i2 7 2 0.3 8.00 0
i2 9 2 0.3 8.00 0.5
i2 11 2 0.3 8.00 1

; Constant-power
i3 14 2 0.3 8.00 0
i3 16 2 0.3 8.00 0.5
i3 18 2 0.3 8.00 1

; Auto-panning
i4 21 4 0.3 8.00 0.5
i4 26 4 0.3 8.00 2

; pan2 opcode
i5 31 2 0.3 8.00 0.5 0   ; Equal power
i5 34 2 0.3 8.00 0.5 1   ; Linear
i5 37 2 0.3 8.00 0.5 2   ; Sqrt
e
</CsScore>
</CsoundSynthesizer>
```

Explanation:
**Panning laws** determine how signal is distributed between speakers:

1. **Linear panning**: `L = 1-pan, R = pan`
   - Simple but causes 3dB drop at center
   - Sum of L+R is constant, but perceived power drops

2. **Equal-power (sqrt)**: `L = sqrt(1-pan), R = sqrt(pan)`
   - Maintains constant total power
   - Most common for stereo music production
   - L^2 + R^2 = constant

3. **Constant-power (sin/cos)**: `L = cos(angle), R = sin(angle)`
   - Maps pan position to angle (0 to 90 degrees)
   - Used in professional mixing consoles
   - Slightly different curve than sqrt

The **pan2** opcode provides these laws built-in:
- itype=0: Equal power (recommended)
- itype=1: Linear
- itype=2: Square root

================================================================================
EXAMPLE 2: Distance-Based Spatial Audio
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

; Distance simulation with amplitude and filtering
        instr 1

iamp    = p4
ifqc    = cpspch(p5)
idist   = p6              ; Distance in meters (1-100)
ipan    = p7              ; Pan position 0-1

asig    oscil   1, ifqc, 1

; Amplitude decreases with distance (inverse square law)
; In reality: amplitude = 1/distance^2
; For audio: use 1/(1+distance) to avoid extremes
kamp    = iamp / (1 + idist * idist * 0.01)

; High frequencies absorbed by air (lowpass filter)
; Cutoff decreases with distance
kfilt   = 20000 / (1 + idist * 0.2)
afilt   tone    asig, kfilt

; Apply amplitude and panning
aout    = afilt * kamp
kenv    linseg  0, 0.01, 1, p3-0.02, 1, 0.01, 0

        outs    aout*kenv*sqrt(1-ipan), aout*kenv*sqrt(ipan)
        endin

; Moving source with distance changes
        instr 2

iamp    = p4
ifqc    = cpspch(p5)
idist1  = p6              ; Starting distance
idist2  = p7              ; Ending distance
ipan1   = p8              ; Starting pan
ipan2   = p9              ; Ending pan

asig    oscil   1, ifqc, 1

; Interpolate distance and pan
kdist   line    idist1, p3, idist2
kpan    line    ipan1, p3, ipan2

; Distance-based amplitude
kamp    = iamp / (1 + kdist * kdist * 0.01)

; Air absorption filter
kfilt   = 20000 / (1 + kdist * 0.2)
afilt   tone    asig, kfilt

aout    = afilt * kamp
kenv    linseg  0, 0.01, 1, p3-0.02, 1, 0.01, 0

        outs    aout*kenv*sqrt(1-kpan), aout*kenv*sqrt(kpan)
        endin

; Reverb mix based on distance
        instr 3

iamp    = p4
ifqc    = cpspch(p5)
idist   = p6
ipan    = p7

asig    oscil   iamp, ifqc, 1

; Direct/reverb ratio changes with distance
; Close = mostly direct, far = mostly reverb
kdry    = 1 / (1 + idist * 0.1)
kwet    = 1 - kdry

; Simple reverb
arev    reverb  asig, 2

; Amplitude for direct sound (inverse square)
kamp    = 1 / (1 + idist * idist * 0.01)

; Mix direct and reverb
; Reverb is spread across stereo field
adirect = asig * kamp * kdry
arevmix = arev * kwet

kenv    linseg  0, 0.01, 1, p3-0.02, 1, 0.01, 0

aL      = (adirect * sqrt(1-ipan) + arevmix * 0.5) * kenv
aR      = (adirect * sqrt(ipan) + arevmix * 0.5) * kenv

        outs    aL, aR
        endin

</CsInstruments>
<CsScore>
f1 0 16384 10 1

; Static distances
;   dur  amp  pitch dist  pan
i1  0    2    0.8   1     0.5    ; Close
i1  3    2    0.8   5     0.5    ; Medium
i1  6    2    0.8   20    0.5    ; Far
i1  9    2    0.8   50    0.5    ; Very far

; Moving source (approaching)
;   dur  amp  pitch dist1 dist2 pan1 pan2
i2  12   4    0.8   50    1     0    1      ; Far-left to close-right

; Distance with reverb
;   dur  amp  pitch dist  pan
i3  18   3    0.6   1     0.5
i3  22   3    0.6   10    0.5
i3  26   3    0.6   30    0.5
e
</CsScore>
</CsoundSynthesizer>
```

Explanation:
Distance simulation combines several physical effects:

1. **Inverse square law**: Sound intensity decreases with distance squared. In practice, use a gentler formula to avoid extreme values.

2. **Air absorption**: High frequencies are absorbed more by air. Apply lowpass filter with cutoff decreasing with distance.

3. **Direct/reverb ratio**: Close sounds are mostly direct, distant sounds have more environmental reverb.

4. **Delay**: Sound travels at ~343 m/s. For moving sources, this creates Doppler effect (see Example 3).

The combination creates a convincing sense of depth even in stereo.

================================================================================
EXAMPLE 3: Doppler Effect and Moving Sources
================================================================================

Code:
```csound
<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps   = 2
nchnls  = 2
0dbfs   = 1

; Simple Doppler effect
        instr 1

iamp    = p4
ifqc    = cpspch(p5)
ispeed  = p6              ; Source speed in m/s (+ = approaching)

; Speed of sound
ics     = 343             ; m/s

asig    oscil   iamp, ifqc, 1

; Doppler frequency shift: f' = f * c / (c - v)
; Approaching: v positive, frequency increases
; Receding: v negative, frequency decreases
kdoppler = ics / (ics - ispeed)
kfqc    = ifqc * kdoppler

; Re-synthesize at shifted frequency
adopp   oscil   iamp, kfqc, 1

kenv    linseg  0, 0.01, 1, p3-0.02, 1, 0.01, 0

        outs    adopp*kenv, adopp*kenv
        endin

; Moving source with position tracking
        instr 2

iamp    = p4
ifqc    = cpspch(p5)
ix1     = p6              ; Start X position (meters)
iy1     = p7              ; Start Y position
ix2     = p8              ; End X position
iy2     = p9              ; End Y position

ics     = 0.343           ; Speed of sound in m/ms
imax    = 500             ; Max delay in ms
ipi     = 3.14159265

; Listener at origin facing +Y
iearx_l = -0.1            ; Left ear X
iearx_r = 0.1             ; Right ear X
ieary   = 0               ; Ears Y position

asig    oscil   iamp, ifqc, 1

; Interpolate source position
ksx     line    ix1, p3, ix2
ksy     line    iy1, p3, iy2

; Calculate distance to each ear
kdx_l   = ksx - iearx_l
kdx_r   = ksx - iearx_r
kdy     = ksy - ieary
kdist_l = sqrt(kdx_l*kdx_l + kdy*kdy)
kdist_r = sqrt(kdx_r*kdx_r + kdy*kdy)

; Avoid divide by zero
kdist_l = (kdist_l == 0) ? 0.001 : kdist_l
kdist_r = (kdist_r == 0) ? 0.001 : kdist_r

; Amplitude based on distance (inverse square)
kamp_l  = 1 / (1 + kdist_l * kdist_l)
kamp_r  = 1 / (1 + kdist_r * kdist_r)

; Delay based on distance (creates Doppler effect)
; vdelay3 with varying delay = pitch shift
kdel_l  = kdist_l / ics
kdel_r  = kdist_r / ics

adel_l  vdelay3 asig * kamp_l, kdel_l, imax
adel_r  vdelay3 asig * kamp_r, kdel_r, imax

; Air absorption
afilt_l tone    adel_l, 20000 / (1 + kdist_l * 0.1)
afilt_r tone    adel_r, 20000 / (1 + kdist_r * 0.1)

kenv    linseg  0, 0.01, 1, p3-0.02, 1, 0.01, 0

        outs    afilt_l * kenv, afilt_r * kenv
        endin

</CsInstruments>
<CsScore>
f1 0 16384 10 1

; Static Doppler (different approach speeds)
i1 0 2 0.5 8.00 30     ; Approaching at 30 m/s (pitch up)
i1 3 2 0.5 8.00 0      ; Stationary (no shift)
i1 6 2 0.5 8.00 -30    ; Receding at 30 m/s (pitch down)

; Moving source fly-by
; Source travels from far left to far right, passing close to listener
;   dur  amp  pitch x1    y1   x2   y2
i2  10   6    0.6   -20   5    20   5     ; Horizontal pass
i2  17   4    0.6   0     20   0    1     ; Approach from front
i2  22   4    0.6   0     1    0    20    ; Recede to front
e
</CsScore>
</CsoundSynthesizer>
```

Explanation:
**Doppler effect** occurs because sound waves compress when source approaches and stretch when receding:

Doppler formula: `f' = f * c / (c - v)`
- f = original frequency
- c = speed of sound (343 m/s)
- v = source velocity (positive = approaching)

Implementation methods:
1. **Direct calculation**: Resynthesize at shifted frequency (simple but unnatural)
2. **Variable delay**: Using vdelay with changing delay creates pitch shift naturally - this is how real Doppler works

For position-based simulation:
- Calculate distance from source to each ear
- Use vdelay3 with distance/speed_of_sound as delay time
- As distance decreases rapidly, delay change creates pitch increase (approaching)
- As distance increases, delay change creates pitch decrease (receding)

================================================================================
EXAMPLE 4: Simplified HRTF and Binaural Processing
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

; Simple HRTF simulation (head shadow)
        instr 1

iamp    = p4
ifqc    = cpspch(p5)
iangle  = p6              ; Angle in degrees (0=front, 90=right, -90=left, 180=behind)

ipi     = 3.14159265

asig    oscil   iamp, ifqc, 1

; Convert angle to radians
kang    = iangle * ipi / 180

; Inter-aural time difference (ITD)
; Max ITD is about 0.65ms for sounds at 90 degrees
kitd    = 0.00065 * sin(kang)

; Inter-aural level difference (ILD)
; High frequencies are shadowed by head more than low
; Approximate with lowpass on shadowed ear
kild    = abs(sin(kang))

; Determine which ear is shadowed
if iangle > 0 then
    ; Sound from right - left ear shadowed
    adelay_l = kitd * 1000  ; Convert to ms
    adelay_r = 0
    kfilt_l  = 8000 - 6000 * kild
    kfilt_r  = 20000
else
    ; Sound from left - right ear shadowed
    adelay_l = 0
    adelay_r = -kitd * 1000
    kfilt_l  = 20000
    kfilt_r  = 8000 - 6000 * kild
endif

; Apply ITD via delay
asigl   vdelay  asig, adelay_l + 0.01, 1
asigr   vdelay  asig, adelay_r + 0.01, 1

; Apply ILD via filtering (head shadow)
afiltl  butterlp asigl, kfilt_l
afiltr  butterlp asigr, kfilt_r

kenv    linseg  0, 0.01, 1, p3-0.02, 1, 0.01, 0

        outs    afiltl * kenv, afiltr * kenv
        endin

; HRTF with table-based filter curves
        instr 2

iamp    = p4
ifqc    = cpspch(p5)
iangle  = p6              ; -180 to +180 degrees
ihrtf_l = p7              ; HRTF table for left ear
ihrtf_r = p8              ; HRTF table for right ear
ipi     = 3.14159265

asig    oscil   iamp, ifqc, 1

; Normalize angle to 0-1 for table lookup
; -180 = 0, 0 = 0.5, +180 = 1
kang_norm = (iangle + 180) / 360

; Read filter cutoff from HRTF tables
khrtf_l tablei  kang_norm, ihrtf_l, 1
khrtf_r tablei  kang_norm, ihrtf_r, 1

; ITD based on angle
kitd    = 0.00065 * sin(iangle * ipi / 180)
kdel_l  = max(0, -kitd * 1000)
kdel_r  = max(0, kitd * 1000)

; Apply delay
asigl   vdelay  asig, kdel_l + 0.01, 1
asigr   vdelay  asig, kdel_r + 0.01, 1

; Apply HRTF filtering
afiltl  butterlp asigl, khrtf_l
afiltr  butterlp asigr, khrtf_r

kenv    linseg  0, 0.01, 1, p3-0.02, 1, 0.01, 0

        outs    afiltl * kenv, afiltr * kenv
        endin

; Rotating source around listener
        instr 3

iamp    = p4
ifqc    = cpspch(p5)
irotrate = p6             ; Rotations per second

asig    oscil   iamp, ifqc, 1

; Angle changes continuously
kangle  phasor  irotrate
kangle  = kangle * 360 - 180  ; Convert to -180 to +180

ipi     = 3.14159265
kang_rad = kangle * ipi / 180

; ITD
kitd    = 0.00065 * sin(kang_rad)

; Determine delays
kdel_l  = max(0, -kitd * 1000) + 0.01
kdel_r  = max(0, kitd * 1000) + 0.01

; ILD (head shadow filtering)
kild    = abs(sin(kang_rad))
kfilt_l = (kangle > 0) ? 8000 - 6000 * kild : 20000
kfilt_r = (kangle < 0) ? 8000 - 6000 * kild : 20000

asigl   vdelay  asig, kdel_l, 1
asigr   vdelay  asig, kdel_r, 1

afiltl  tone    asigl, kfilt_l
afiltr  tone    asigr, kfilt_r

kenv    linseg  0, 0.1, 1, p3-0.2, 1, 0.1, 0

        outs    afiltl * kenv, afiltr * kenv
        endin

</CsInstruments>
<CsScore>
f1 0 16384 10 1

; HRTF filter tables (simplified)
; Left ear: low cutoff when sound is from right (positive angles)
f4 0 1024 -7 16000 128 12000 384 3000 128 8000 256 20000 128 16000

; Right ear: low cutoff when sound is from left (negative angles)
f5 0 1024 -7 8000 128 3000 384 12000 128 16000 256 20000 128 8000

; Simple HRTF at various angles
i1 0 2 0.5 8.00 0       ; Front
i1 3 2 0.5 8.00 45      ; Front-right
i1 6 2 0.5 8.00 90      ; Right
i1 9 2 0.5 8.00 -90     ; Left
i1 12 2 0.5 8.00 180    ; Behind

; Table-based HRTF
i2 16 2 0.5 8.00 90 4 5

; Rotating source
i3 20 8 0.4 8.00 0.25   ; Slow rotation
i3 29 4 0.4 8.00 1      ; Fast rotation
e
</CsScore>
</CsoundSynthesizer>
```

Explanation:
**HRTF (Head-Related Transfer Function)** models how the head, ears, and torso affect sound:

Key components:
1. **ITD (Inter-aural Time Difference)**: Sound arrives at the farther ear later. Max ~0.65ms for 90-degree sources.

2. **ILD (Inter-aural Level Difference)**: The head shadows high frequencies. The far ear receives filtered sound.

3. **Spectral coloring**: The pinnae (outer ears) create complex spectral modifications that indicate elevation and front/back.

This simplified implementation captures ITD and ILD. For accurate HRTF, use measured impulse responses and the hrtfmove/hrtfstat opcodes.

Real HRTF data:
- MIT KEMAR dataset (public domain)
- CIPIC database
- Measured for specific dummy heads
- Contains impulse responses for many angles

================================================================================
EXAMPLE 5: Frequency-Dependent Spatial Processing
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

; Frequency-band panning (different bands at different positions)
        instr 1

ilevl   = p4
icut1   = p5              ; Low/mid crossover
icut2   = p6              ; Mid/high crossover
irate1  = p7              ; Low pan rate
irate2  = p8              ; Mid pan rate
irate3  = p9              ; High pan rate
iphse1  = p10 / 360       ; Low phase offset
iphse2  = p11 / 360       ; Mid phase offset
iphse3  = p12 / 360       ; High phase offset

ain     diskin2 "sample.wav", 1, 0, 1

; Split into frequency bands
alow    tone    ain, icut1          ; Low frequencies
amid    butterbp ain, (icut1+icut2)/2, icut2-icut1  ; Mid frequencies
ahigh   atone   ain, icut2          ; High frequencies

; Independent pan LFOs for each band
kpan1   oscili  0.5, irate1, 1, iphse1
kpan2   oscili  0.5, irate2, 1, iphse2
kpan3   oscili  0.5, irate3, 1, iphse3

kpan1   = kpan1 + 0.5
kpan2   = kpan2 + 0.5
kpan3   = kpan3 + 0.5

; Apply panning to each band
alow_l  = alow * sqrt(1 - kpan1)
alow_r  = alow * sqrt(kpan1)
amid_l  = amid * sqrt(1 - kpan2)
amid_r  = amid * sqrt(kpan2)
ahigh_l = ahigh * sqrt(1 - kpan3)
ahigh_r = ahigh * sqrt(kpan3)

; Sum bands
aL      = (alow_l + amid_l + ahigh_l) * ilevl
aR      = (alow_r + amid_r + ahigh_r) * ilevl

        outs    aL, aR
        endin

; 4-tap panning delay
        instr 2

ilevl   = p4
itap1   = p5 / 1000       ; Delay times in ms
itap2   = p6 / 1000
itap3   = p7 / 1000
itap4   = p8 / 1000
ifdbk1  = p9              ; Per-tap feedback
ifdbk2  = p10
ifdbk3  = p11
ifdbk4  = p12
irate1  = p13             ; Pan rates
irate2  = p14
irate3  = p15
irate4  = p16

atap1   init    0
atap2   init    0
atap3   init    0
atap4   init    0

ain     diskin2 "sample.wav", 1, 0, 1

; Feedback from previous taps
afdbk1  = atap1 * ifdbk1
afdbk2  = atap2 * ifdbk2
afdbk3  = atap3 * ifdbk3
afdbk4  = atap4 * ifdbk4

; Independent pan LFO for each tap
kpan1   oscil   0.5, irate1, 1
kpan2   oscil   0.5, irate2, 1
kpan3   oscil   0.5, irate3, 1
kpan4   oscil   0.5, irate4, 1

kpan1   = kpan1 + 0.5
kpan2   = kpan2 + 0.5
kpan3   = kpan3 + 0.5
kpan4   = kpan4 + 0.5

; Delay taps
atap1   delay   ain + afdbk1, itap1
atap2   delay   ain + afdbk2, itap2
atap3   delay   ain + afdbk3, itap3
atap4   delay   ain + afdbk4, itap4

; Pan each tap
aL      = atap1*sqrt(kpan1) + atap2*sqrt(1-kpan2) + atap3*sqrt(kpan3) + atap4*sqrt(1-kpan4)
aR      = atap1*sqrt(1-kpan1) + atap2*sqrt(kpan2) + atap3*sqrt(1-kpan3) + atap4*sqrt(kpan4)

        outs    ain + aL*ilevl, ain + aR*ilevl
        endin

</CsInstruments>
<CsScore>
f1 0 8193 10 1

; Frequency-band spatial processing
; Different rotation rates and phases create complex spatial movement
;   dur  level lowX midX rate1 rate2 rate3 ph1  ph2  ph3
i1  0    8     1    250  2500  0.5   0.7   0.3   0   120  240

; Panning delay
;   dur  lvl  t1   t2   t3   t4   fb1  fb2  fb3  fb4  r1   r2   r3   r4
i2  10   8    0.75 250  500  750  375  0.6  0.5  0.4  0.3  1.0  0.7  1.3  1.1
e
</CsScore>
</CsoundSynthesizer>
```

Explanation:
**Frequency-dependent spatial processing** creates rich, immersive effects by treating frequency bands differently:

1. **Band panning**: Low, mid, and high frequencies pan independently with different rates and phases. Creates swirling, complex spatial movement.

2. **Panning delay**: Each delay tap has its own pan position (and optionally LFO). Creates spatial depth and width.

Phase offsets between bands ensure they don't all move together, creating more interesting spatial motion.

Variations:
1. Use more frequency bands for finer control
2. Sync pan rates to tempo for rhythmic effects
3. Apply different reverb/delay to each band before panning
4. Use envelope followers to make panning respond to dynamics

================================================================================
EXAMPLE 6: Quadraphonic and Multi-Channel Output
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
nchnls  = 4               ; Quadraphonic output
0dbfs   = 1

; Basic quadraphonic panning
        instr 1

iamp    = p4
ifqc    = cpspch(p5)
ix      = p6              ; X position (-1 to +1, left to right)
iy      = p7              ; Y position (-1 to +1, back to front)

asig    oscil   iamp, ifqc, 1

; Calculate distance to each speaker
; Speakers at corners: FL(-1,1), FR(1,1), RL(-1,-1), RR(1,-1)
kdist_fl = sqrt((ix+1)*(ix+1) + (iy-1)*(iy-1))
kdist_fr = sqrt((ix-1)*(ix-1) + (iy-1)*(iy-1))
kdist_rl = sqrt((ix+1)*(ix+1) + (iy+1)*(iy+1))
kdist_rr = sqrt((ix-1)*(ix-1) + (iy+1)*(iy+1))

; Inverse distance for amplitude (with minimum)
kamp_fl = 1 / max(kdist_fl, 0.1)
kamp_fr = 1 / max(kdist_fr, 0.1)
kamp_rl = 1 / max(kdist_rl, 0.1)
kamp_rr = 1 / max(kdist_rr, 0.1)

; Normalize so total amplitude stays constant
ksum    = kamp_fl + kamp_fr + kamp_rl + kamp_rr
kamp_fl = kamp_fl / ksum
kamp_fr = kamp_fr / ksum
kamp_rl = kamp_rl / ksum
kamp_rr = kamp_rr / ksum

kenv    linseg  0, 0.01, 1, p3-0.02, 1, 0.01, 0

; Output to 4 channels
        outq    asig*kenv*kamp_fl, asig*kenv*kamp_fr, asig*kenv*kamp_rl, asig*kenv*kamp_rr
        endin

; Circular motion around listener
        instr 2

iamp    = p4
ifqc    = cpspch(p5)
iradius = p6              ; Distance from center
irate   = p7              ; Rotation rate (Hz)

asig    oscil   iamp, ifqc, 1

; Circular path
kangle  phasor  irate
kangle  = kangle * 2 * 3.14159265

kx      = iradius * sin(kangle)
ky      = iradius * cos(kangle)

; Same distance calculation as instr 1
kdist_fl = sqrt((kx+1)*(kx+1) + (ky-1)*(ky-1))
kdist_fr = sqrt((kx-1)*(kx-1) + (ky-1)*(ky-1))
kdist_rl = sqrt((kx+1)*(kx+1) + (ky+1)*(ky+1))
kdist_rr = sqrt((kx-1)*(kx-1) + (ky+1)*(ky+1))

kamp_fl = 1 / max(kdist_fl, 0.1)
kamp_fr = 1 / max(kdist_fr, 0.1)
kamp_rl = 1 / max(kdist_rl, 0.1)
kamp_rr = 1 / max(kdist_rr, 0.1)

ksum    = kamp_fl + kamp_fr + kamp_rl + kamp_rr
kamp_fl = kamp_fl / ksum
kamp_fr = kamp_fr / ksum
kamp_rl = kamp_rl / ksum
kamp_rr = kamp_rr / ksum

kenv    linseg  0, 0.1, 1, p3-0.2, 1, 0.1, 0

        outq    asig*kenv*kamp_fl, asig*kenv*kamp_fr, asig*kenv*kamp_rl, asig*kenv*kamp_rr
        endin

</CsInstruments>
<CsScore>
f1 0 16384 10 1

; Static positions in quad field
;   dur  amp  pitch x     y
i1  0    2    0.5   0     0     ; Center
i1  3    2    0.5   -1    1     ; Front left
i1  6    2    0.5   1     1     ; Front right
i1  9    2    0.5   -1    -1    ; Rear left
i1  12   2    0.5   1     -1    ; Rear right

; Rotating source
;   dur  amp  pitch radius rate
i2  16   8    0.4   0.8    0.5   ; Slow rotation
i2  25   4    0.4   0.8    2     ; Fast rotation
e
</CsScore>
</CsoundSynthesizer>
```

Explanation:
**Quadraphonic** and surround sound require multiple output channels:

- Set nchnls to the desired channel count (4, 6, 8, etc.)
- Use outq (4-channel), outh (6-channel), or outo (8-channel)
- Or use outch for arbitrary channel routing

**VBAP (Vector Base Amplitude Panning)**:
The distance-based method shown approximates VBAP, which is the standard for multi-channel panning. For accurate VBAP, use Csound's vbap family of opcodes.

Speaker layouts:
- Quad: FL, FR, RL, RR at corners
- 5.1: L, R, C, LFE, LS, RS
- 7.1: Add back L/R
- Ambisonics: Encode to B-format, decode to any speaker array

Common Issues:

1. **Phase cancellation in stereo**: When same signal pans to center, phase relationships matter. Use mono-compatible mixing.

2. **HRTF personalization**: Generic HRTFs may not work for all listeners. Allow customization or use multiple datasets.

3. **Distance simulation extremes**: Inverse-square law creates huge dynamic range. Use compressed distance formulas like 1/(1+d^2).

4. **Doppler artifacts**: Very fast movement causes pitch discontinuities. Smooth velocity changes and limit maximum speed.

5. **Multi-channel monitoring**: Test on actual speaker arrays when possible. Headphone simulation of surround is imperfect.

6. **CPU load**: Full spatial processing (HRTF, Doppler, distance) is expensive. Simplify for background elements.

Related Examples:
- csound_reverb_design_entry.md (environmental acoustics)
- csound_delay_line_effects_entry.md (spatial delays)
- csound_filter_bank_vocoder_entry.md (spectral processing for spatial effects)
