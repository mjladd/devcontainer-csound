Title: Envelope Design Patterns
Category: Control Signals/Modulation
Difficulty: Beginner to Intermediate
Tags: envelope, ADSR, linseg, expseg, linen, adsr, madsr, envlpx, transeg, amplitude, control, articulation, dynamics

Description:
Envelopes are time-varying control signals that shape amplitude, filter cutoff, pitch, or other parameters over a note's duration. Well-designed envelopes are crucial for creating expressive, musical sounds. Csound provides many envelope generators ranging from simple (linen) to complex (envlpx, transeg). Understanding envelope design helps create punchy attacks, smooth pads, realistic instrument emulations, and dynamic sound design.

---

## Example 1: Basic Envelope Types - linseg, expseg, linen

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

; Linear segments (linseg)
instr 1
    iamp = p4
    ifreq = cpspch(p5)

    ; Attack-Sustain-Release envelope
    ; Straight lines between points
    kenv linseg 0, 0.1, iamp, p3-0.2, iamp*0.7, 0.1, 0

    asrc oscil 1, ifreq, -1
    aout = asrc * kenv

    outs aout, aout
endin

; Exponential segments (expseg)
instr 2
    iamp = p4
    ifreq = cpspch(p5)

    ; Exponential decay sounds more natural
    ; Note: expseg cannot reach zero, use small value
    kenv expseg 0.001, 0.05, iamp, p3-0.05, 0.001

    asrc oscil 1, ifreq, -1
    aout = asrc * kenv

    outs aout, aout
endin

; Simple linen envelope
instr 3
    iamp = p4
    ifreq = cpspch(p5)
    irise = p6
    idec = p7

    ; linen: automatic attack, sustain, decay
    kenv linen iamp, irise, p3, idec

    asrc oscil 1, ifreq, -1
    aout = asrc * kenv

    outs aout, aout
endin

; linenr - release triggered by note-off
instr 4
    iamp = p4
    ifreq = cpspch(p5)

    ; linenr: attack, then holds until note-off triggers release
    kenv linenr iamp, 0.1, 0.5, 0.01

    asrc oscil 1, ifreq, -1
    aout = asrc * kenv

    outs aout, aout
endin

</CsInstruments>
<CsScore>
; Linear envelope
i1 0   2   0.4  8.00

; Exponential - percussive sound
i2 3   1   0.4  8.00
i2 4.2 0.5 0.4  8.04
i2 4.9 0.3 0.4  8.07

; linen with variable attack/decay
;   dur  amp  pitch rise decay
i3 6   2    0.4  8.00  0.5  0.3   ; Slow attack
i3 8.5 1    0.4  8.04  0.01 0.5   ; Snappy attack

; linenr - sustain until release
i4 10  -3   0.4  8.00  ; Negative dur = held note
i4 11  -2   0.4  8.04
i4 12  -4   0.4  7.07
e
</CsScore>
</CsoundSynthesizer>
```

**Explanation:**
- `linseg` creates linear segments between breakpoints
- `expseg` creates exponential curves (cannot pass through or reach zero)
- `linen` provides simple attack-sustain-decay with automatic calculation
- `linenr` waits for note-off (negative p3) before starting release

---

## Example 2: Classic ADSR Envelope

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

; Manual ADSR using linseg
instr 1
    iamp = p4
    ifreq = cpspch(p5)
    iatt = p6       ; Attack time
    idec = p7       ; Decay time
    isus = p8       ; Sustain level (0-1)
    irel = p9       ; Release time

    ; Calculate sustain duration
    isus_dur = p3 - iatt - idec - irel
    isus_dur = (isus_dur < 0.01 ? 0.01 : isus_dur)

    ; ADSR envelope
    kenv linseg 0, iatt, 1, idec, isus, isus_dur, isus, irel, 0

    asrc vco2 iamp, ifreq, 0
    aout = asrc * kenv

    outs aout, aout
endin

; Using built-in adsr opcode
instr 2
    iamp = p4
    ifreq = cpspch(p5)
    iatt = p6
    idec = p7
    isus = p8
    irel = p9

    ; Built-in ADSR - note: sustain is level not time
    kenv adsr iatt, idec, isus, irel

    asrc vco2 iamp, ifreq, 0
    aout = asrc * kenv

    outs aout, aout
endin

; Exponential ADSR using madsr (MIDI-style)
instr 3
    iamp = p4
    ifreq = cpspch(p5)
    iatt = p6
    idec = p7
    isus = p8
    irel = p9

    ; madsr uses exponential segments for more natural sound
    kenv madsr iatt, idec, isus, irel

    asrc vco2 iamp, ifreq, 0
    aout = asrc * kenv

    outs aout, aout
endin

</CsInstruments>
<CsScore>
; Manual ADSR
;   dur  amp  pitch att  dec  sus  rel
i1 0    2    0.4   8.00 0.1  0.2  0.6  0.3

; Built-in adsr
i2 3    2    0.4   8.04 0.01 0.1  0.8  0.2  ; Fast attack
i2 5.5  2    0.4   8.07 0.3  0.2  0.5  0.5  ; Slow attack

; madsr - exponential
i3 8    1.5  0.4   8.00 0.05 0.15 0.7  0.3
i3 10   1.5  0.4   8.05 0.01 0.3  0.4  0.4
e
</CsScore>
</CsoundSynthesizer>
```

**Explanation:**
- ADSR = Attack, Decay, Sustain (level), Release
- Manual construction with `linseg` offers full control
- `adsr` opcode handles sustain duration automatically
- `madsr` provides exponential segments for more natural decay

---

## Example 3: Complex Envelopes with transeg

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

; transeg allows mixed linear/exponential segments
instr 1
    iamp = p4
    ifreq = cpspch(p5)

    ; transeg: value, time, type, value, time, type, value...
    ; type: 0=linear, positive=concave exp, negative=convex exp
    kenv transeg 0, 0.01, 0, 1, 0.1, -4, 0.3, p3-0.31, 2, 0.1, 0.2, 4, 0

    asrc vco2 iamp, ifreq, 0
    aout = asrc * kenv

    outs aout, aout
endin

; Percussive envelope with transeg
instr 2
    iamp = p4
    ifreq = cpspch(p5)
    idecay = p6

    ; Sharp attack, exponential decay
    kenv transeg 0, 0.001, 0, 1, idecay, -6, 0.001

    asrc oscil iamp, ifreq, -1
    aout = asrc * kenv

    outs aout, aout
endin

; Multi-stage envelope for pad evolution
instr 3
    iamp = p4
    ifreq = cpspch(p5)

    ; Complex evolving envelope
    kenv transeg 0, 0.5, 4, 0.3,      \  ; Slow fade in
                 1.0, -2, 0.8,        \  ; Rise to peak
                 0.5, 0, 0.8,         \  ; Hold
                 p3-2.5, 3, 0.4,      \  ; Slow decay
                 0.5, -4, 0           ;  ; Final release

    asrc vco2 iamp, ifreq, 4  ; Triangle wave
    aout = asrc * kenv

    outs aout, aout
endin

</CsInstruments>
<CsScore>
; transeg with curve control
i1 0   3   0.4  8.00
i1 3.5 2   0.4  8.04

; Percussive hits
;   dur  amp  pitch decay
i2 6   0.5  0.5  8.00  0.2
i2 6.3 0.5  0.5  9.00  0.15
i2 6.5 0.5  0.5  8.07  0.3
i2 6.8 0.8  0.5  7.00  0.5

; Evolving pad
i3 8   6    0.3  7.07
e
</CsScore>
</CsoundSynthesizer>
```

**Explanation:**
- `transeg` allows per-segment curve type specification
- Curve type: 0=linear, positive=exponential concave, negative=exponential convex
- Higher absolute values = more extreme curves
- Backslash `\` allows multi-line envelope definitions

---

## Example 4: Table-Based ADSR (High Flexibility)

Based on ADSR-Lin.csd and ADSRExp.csd

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

; Table-driven ADSR allows runtime sustain level changes
instr 1
    iamp = p4
    ifreq = cpspch(p5)
    iatt = (p6 < 0.001 ? 0.001 : p6)
    idec = (p7 < 0.001 ? 0.001 : p7)
    isus = p8
    irel = (p9 < 0.001 ? 0.001 : p9)

    ; Total envelope time
    itotal = iatt + idec + (p3 - iatt - idec - irel) + irel

    ; Phase through envelope
    krate = 1 / itotal
    aphs phasor krate

    ; Segment boundaries (normalized 0-1)
    k1 = iatt / itotal
    k2 = (iatt + idec) / itotal
    k3 = (p3 - irel) / itotal
    k4 = 1

    ; Clamp phase to segments and read appropriate table
    a1 limit aphs, 0, k1
    a2 limit aphs, k1, k2
    a3 limit aphs, k2, k3
    a4 limit aphs, k3, k4

    ; Normalize each segment and look up shape
    aattack = a1 / k1
    adecay = (a2 - k1) / (k2 - k1)
    asustain = (a3 - k2) / (k3 - k2)
    arelease = (a4 - k3) / (k4 - k3)

    ; Read envelope shapes from tables
    aatt_env tablei aattack, 1, 1        ; Attack shape
    adec_env tablei adecay, 2, 1         ; Decay shape
    asus_env tablei asustain, 3, 1       ; Sustain (flat)
    arel_env tablei arelease, 4, 1       ; Release shape

    ; Combine based on phase position
    aenv = aatt_env * (aphs <= k1 ? 1 : 0) + \
           (1 - adec_env * (1 - isus)) * (aphs > k1 && aphs <= k2 ? 1 : 0) + \
           isus * (aphs > k2 && aphs <= k3 ? 1 : 0) + \
           isus * (1 - arel_env) * (aphs > k3 ? 1 : 0)

    asrc vco2 iamp, ifreq, 0
    aout = asrc * aenv

    outs aout, aout
endin

; Simpler approach: table lookup with envelope shape
instr 2
    iamp = p4
    ifreq = cpspch(p5)
    ienvtab = p6    ; Which envelope table to use

    ; Read entire envelope from table
    kndx line 0, p3, 1
    kenv tablei kndx, ienvtab, 1

    asrc vco2 iamp, ifreq, 0
    aout = asrc * kenv

    outs aout, aout
endin

</CsInstruments>
<CsScore>
; Envelope segment shapes
f1 0 1024 7 0 1024 1           ; Linear attack
f2 0 1024 7 0 1024 1           ; Linear decay
f3 0 1024 7 1 1024 1           ; Flat sustain
f4 0 1024 7 0 1024 1           ; Linear release

; Pre-built envelope shapes
f10 0 1024 7 0 100 1 200 0.7 724 0.7 0 0    ; Plucky
f11 0 1024 5 0.001 200 1 824 0.001          ; Exponential decay
f12 0 1024 7 0 300 1 400 0.5 224 0.5 100 0  ; Pad

; Table-driven ADSR
;   dur  amp  pitch att  dec  sus  rel
i1 0   2    0.4   8.00 0.1  0.2  0.6  0.3

; Pre-built envelopes
;   dur  amp  pitch env_table
i2 3   0.5  0.4   8.00  10    ; Plucky
i2 4   0.3  0.4   9.00  11    ; Percussive
i2 5   3    0.4   7.07  12    ; Pad
e
</CsScore>
</CsoundSynthesizer>
```

**Explanation:**
- Table-based envelopes allow arbitrary shapes
- GEN 7 creates linear segments, GEN 5 creates exponential
- Pre-designed envelope tables enable quick sound design
- Complex shapes can be drawn or calculated offline

---

## Example 5: Pitch and Filter Envelopes

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

; Pitch envelope - drum synthesis
instr 1
    iamp = p4
    ifreq_start = p5    ; Starting frequency
    ifreq_end = p6      ; Ending frequency
    ipitch_decay = p7   ; Pitch envelope time

    ; Amplitude envelope
    kamp expseg 1, 0.001, 1, p3-0.001, 0.001

    ; Pitch envelope - fast drop
    kfreq expseg ifreq_start, ipitch_decay, ifreq_end, p3-ipitch_decay, ifreq_end

    ; Sine oscillator for clean tone
    asrc oscil iamp * kamp, kfreq, -1

    outs asrc, asrc
endin

; Filter envelope - synth bass
instr 2
    iamp = p4
    ifreq = cpspch(p5)
    ifco_start = p6     ; Filter cutoff start
    ifco_end = p7       ; Filter cutoff end
    iflt_decay = p8     ; Filter envelope time
    irez = p9           ; Resonance

    ; Amplitude envelope
    kamp linseg 0, 0.01, 1, p3-0.11, 0.8, 0.1, 0

    ; Filter envelope
    kfco expseg ifco_start, iflt_decay, ifco_end, p3-iflt_decay, ifco_end

    ; Rich source
    asrc vco2 iamp, ifreq, 0

    ; Filtered output
    afilt moogladder asrc, kfco, irez

    outs afilt*kamp, afilt*kamp
endin

; Combined pitch and filter envelope
instr 3
    iamp = p4
    ifreq = cpspch(p5)
    ipitch_env = p6     ; Pitch envelope depth (semitones)
    iflt_env = p7       ; Filter envelope depth

    ; Pitch envelope
    kpitch transeg ipitch_env, 0.05, -4, 0, p3-0.05, 0, 0
    kfreq = ifreq * semitone(kpitch)

    ; Filter envelope
    kfco transeg 200 + iflt_env, 0.1, -6, 200 + iflt_env*0.3, p3-0.1, 0, 200

    ; Amplitude envelope
    kamp adsr 0.01, 0.2, 0.7, 0.2

    ; Oscillator and filter
    asrc vco2 iamp, kfreq, 0
    afilt moogladder asrc, kfco, 0.4

    outs afilt*kamp, afilt*kamp
endin

</CsInstruments>
<CsScore>
; Kick drum - pitch drops quickly
;   dur  amp  f_start f_end  p_decay
i1 0   0.5  0.6  200     40     0.05
i1 0.6 0.5  0.6  300     50     0.03
i1 1.2 0.8  0.6  180     35     0.08

; Bass with filter envelope
;   dur  amp  pitch fco_st fco_end flt_dec rez
i2 2   1    0.5   6.00  3000   200     0.1    0.4
i2 3.2 0.8  0.5   6.05  4000   300     0.08   0.5
i2 4.2 1.5  0.5   5.07  2500   150     0.15   0.3

; Lead with both envelopes
;   dur  amp  pitch p_env f_env
i3 6   1    0.4   8.00  5     3000
i3 7.2 0.8  0.4   8.04  3     2000
i3 8.2 1.5  0.4   8.07  7     4000
e
</CsScore>
</CsoundSynthesizer>
```

**Explanation:**
- Pitch envelopes create drum sounds and zappy leads
- Filter envelopes shape timbre over time
- `semitone()` converts semitone offset to frequency multiplier
- Combining envelopes creates expressive, dynamic sounds

---

## Example 6: Envelope Generators for Modular Design

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

; Triggered AR envelope (attack-release)
opcode ARenv, k, kii
    ktrig, iatt, irel xin

    ; State machine
    kstate init 0
    kenv init 0

    ; Detect trigger
    ktrig_edge trigger ktrig, 0.5, 0

    ; Attack phase
    if ktrig_edge == 1 then
        kstate = 1
    endif

    ; Release phase when trigger goes low
    if ktrig == 0 && kstate == 1 then
        kstate = 2
    endif

    ; Generate envelope
    if kstate == 1 then
        kenv = kenv + (1 - kenv) * (1 - exp(-1/(iatt * kr)))
    elseif kstate == 2 then
        kenv = kenv * exp(-1/(irel * kr))
        if kenv < 0.001 then
            kstate = 0
            kenv = 0
        endif
    endif

    xout kenv
endop

; Looping envelope (for LFO-like behavior)
opcode LoopEnv, k, iii
    irise, ifall, iamp xin

    iperiod = irise + ifall
    kph phasor 1/iperiod

    if kph < irise/iperiod then
        kenv = kph * iperiod / irise
    else
        kenv = 1 - (kph - irise/iperiod) * iperiod / ifall
    endif

    xout kenv * iamp
endop

; Main instrument using modular envelopes
instr 1
    ifreq = cpspch(p4)
    iamp = p5

    ; Trigger from score (could be from MIDI or sequencer)
    ktrig init 1

    ; AR envelope
    kamp ARenv ktrig, 0.1, 0.3

    ; Looping envelope for filter
    kflt LoopEnv 0.3, 0.5, 2000

    ; Sound generation
    asrc vco2 iamp, ifreq, 0
    afilt moogladder asrc, 500 + kflt, 0.3

    outs afilt * kamp, afilt * kamp
endin

; Sequenced notes with evolving envelope
instr 2
    ifreq = cpspch(p4)
    iamp = p5

    ; Multi-stage envelope with hold
    kenv linseg 0, 0.01, 1,        \  ; Attack
                0.05, 0.7,         \  ; Initial decay
                0.1, 0.8,          \  ; Slight rise
                p3-0.26, 0.5,      \  ; Slow decay
                0.1, 0             ;  ; Release

    asrc vco2 iamp, ifreq, 2, 0.5
    aout = asrc * kenv

    outs aout, aout
endin

</CsInstruments>
<CsScore>
; AR envelope test
i1 0   2   8.00  0.4
i1 2.5 2   8.04  0.4
i1 5   3   7.07  0.4

; Sequenced notes
i2 8     0.4  8.00  0.4
i2 8.5   0.4  8.04  0.4
i2 9     0.4  8.07  0.4
i2 9.5   0.4  9.00  0.4
i2 10    1.5  8.00  0.4
e
</CsScore>
</CsoundSynthesizer>
```

**Explanation:**
- UDOs encapsulate envelope logic for reuse
- `trigger` opcode detects edges in control signals
- State machine pattern enables complex envelope behavior
- Looping envelopes useful for rhythmic effects

---

## Variations

1. **envlpx**: Exponential envelope with final release segment
2. **cosseg/cossegr**: Cosine interpolation for smooth S-curves
3. **jspline**: Random spline for organic, evolving envelopes
4. **rspline**: Random spline envelope generator
5. **loopseg**: Looping segment envelope
6. **Nested envelopes**: Apply envelope to another envelope's time

---

## Common Issues

| Problem | Solution |
|---------|----------|
| Clicks at note start/end | Ensure envelope starts/ends at 0; use minimum 1-5ms attack |
| expseg won't reach zero | Use small value (0.001) instead of 0 |
| Envelope times exceed note duration | Calculate segment times based on p3 |
| Sustain level not reached | Ensure attack+decay < total duration |
| Release cuts off | Use negative p3 with linenr/madsr, or extend note duration |
| Envelope too slow for fast notes | Scale envelope times proportionally to note duration |

---

## Related Examples

- csound_subtractive_synthesis_entry.md - Filter envelopes in synth context
- csound_dynamics_processing_entry.md - Envelope followers and compressors
- csound_fm_synthesis_entry.md - Index envelopes for FM brightness
- csound_sample_playback_entry.md - Envelopes for sample triggering
