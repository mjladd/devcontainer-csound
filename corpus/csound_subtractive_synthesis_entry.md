Title: Subtractive Synthesis
Category: Synthesis Techniques
Difficulty: Intermediate
Tags: subtractive, filter, VCF, lowpass, highpass, bandpass, resonance, moog, analog, VCO, envelope, synthesis

Description:
Subtractive synthesis creates sounds by filtering harmonically-rich source waveforms. The classic technique uses oscillators generating sawtooth, pulse, or noise waveforms, then shapes the timbre using filters (typically lowpass) with resonance. Filter cutoff frequency is often modulated by envelopes and LFOs to create dynamic, evolving timbres. This technique is fundamental to analog synthesizers like the Moog, ARP, and Roland classics.

---

## Example 1: Basic Subtractive - Buzz through Resonant Filter

Based on arnotSUBTRACT.csd

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

; Simple subtractive synthesis: buzz -> reson filter
instr 1
    ifreq = p4
    iamp = p5

    ; Amplitude envelope
    kgate linen iamp, p6, p3, p7

    ; Harmonically rich source: band-limited pulse train
    asrc buzz kgate, ifreq, 15, 1

    ; Filter cutoff sweeps from high to low
    kcf linseg ifreq*8, p3*0.3, ifreq*4, p3*0.7, ifreq*2

    ; Bandwidth as percentage of center frequency
    kbw = kcf * 0.15

    ; Resonant bandpass filter
    afilt reson asrc, kcf, kbw, 1

    ; Stereo output with slight panning
    outs afilt * sqrt(p8), afilt * sqrt(1-p8)
endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1  ; Sine wave for buzz

;   start dur  freq   amp   rise  decay pan
i1  0     3    131    0.4   0.5   0.5   0.3
i1  1     2    196    0.4   0.3   0.3   0.7
i1  2     2.5  165    0.4   0.4   0.4   0.5
i1  3.5   3    262    0.4   0.2   0.5   0.4
e
</CsScore>
</CsoundSynthesizer>
```

**Explanation:**
- `buzz` generates a band-limited pulse train with harmonics up to Nyquist
- `reson` provides a resonant bandpass filter for timbre shaping
- Filter cutoff sweeps down over time for classic "filter closing" effect
- Bandwidth controls resonance (narrower = more resonant)

---

## Example 2: Analog-Style VCO with Moog Filter

Based on moogvco1.csd

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

; Analog-modeling VCO with resonant lowpass filter
instr 1
    ifreq = cpspch(p4)
    iamp = p5
    ifco = p6           ; Filter cutoff multiplier
    irez = p7           ; Resonance (0-1)
    iwave = p8          ; 0=saw, 2=square, 4=triangle

    ; Amplitude envelope
    kamp linseg 0, 0.01, iamp, p3*0.7, iamp*0.8, p3*0.29, 0

    ; VCO - band-limited oscillator
    asig vco2 1, ifreq, iwave

    ; Filter envelope - exponential sweep
    kfenv expseg ifco*ifreq, p3*0.2, ifco*ifreq*1.5, p3*0.3, ifco*ifreq*0.5, p3*0.5, ifco*ifreq*0.2

    ; Moog ladder filter
    afilt moogladder asig, kfenv, irez

    ; Output with amplitude envelope
    aout = afilt * kamp

    outs aout, aout
endin

</CsInstruments>
<CsScore>
; Sawtooth bass
;   start dur  pitch  amp  fco  rez  wave
i1  0     1    6.00   0.5  4    0.3  0
i1  1.2   1    6.05   0.5  4    0.3  0
i1  2.4   1    6.07   0.5  5    0.4  0
i1  3.6   2    6.00   0.5  3    0.5  0

; Square lead
i1  6     0.8  8.00   0.4  6    0.5  2
i1  7     0.8  8.04   0.4  6    0.5  2
i1  8     0.8  8.07   0.4  8    0.6  2
i1  9     1.5  9.00   0.4  4    0.4  2
e
</CsScore>
</CsoundSynthesizer>
```

**Explanation:**
- `vco2` generates band-limited classic waveforms (saw, square, triangle)
- `moogladder` emulates the famous 4-pole Moog transistor ladder filter
- Filter cutoff is expressed as a multiplier of the base frequency
- Higher resonance values approach self-oscillation

---

## Example 3: Multi-Waveform VCO with PWM

Based on moog1.csd

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

; Initialize zak space for modulation routing
zakinit 10, 10

; LFO for pulse width modulation
instr 5
    iamp = p4
    ifreq = p5

    klfo oscil iamp, ifreq, 1
    kout = klfo * 0.5 + 0.5    ; Scale to 0-1 range

    zkw kout, 1                 ; Write to zak channel 1
endin

; Main VCO with selectable waveform and PWM
instr 10
    ifreq = cpspch(p4)
    iamp = p5
    ifco = p6 * ifreq / 500    ; Scale cutoff with frequency
    irez = p7
    iwave = p8                  ; 1=saw, 2=square/PWM, 3=triangle

    ; Read PWM from zak bus
    kpw zkr 1
    kpw = (kpw < 0.05 ? 0.05 : kpw)
    kpw = (kpw > 0.95 ? 0.95 : kpw)

    ; Filter envelope
    kfenv expseg 100+ifco*0.5, p3*0.2, ifco+100, p3*0.5, ifco*0.2+100, p3*0.3, ifco*0.1+100

    ; Amplitude envelope
    kamp linseg 0, 0.01, iamp, p3*0.2, iamp*0.8, p3*0.59, iamp*0.5, p3*0.2, 0

    ; Band-limited waveform generation using vco2
    if iwave == 1 then
        asig vco2 1, ifreq, 0           ; Sawtooth
    elseif iwave == 2 then
        asig vco2 1, ifreq, 2, kpw      ; PWM square
    else
        asig vco2 1, ifreq, 4           ; Triangle
    endif

    ; Resonant lowpass filter
    afilt moogvcf asig, kfenv, irez

    outs afilt*kamp, afilt*kamp
endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1  ; Sine for LFO

; Start LFO for PWM modulation
;   start dur  amp  freq
i5  0     20   0.8  0.5

; Sawtooth sequence
;   start dur  pitch amp   fco   rez  wave
i10 0     1    7.00  0.5   5000  0.3  1
i10 1.2   1    7.07  0.5   5000  0.3  1

; PWM square sequence
i10 2.5   1    8.00  0.4   4000  0.4  2
i10 3.7   1    8.04  0.4   4000  0.4  2
i10 4.9   1.5  8.07  0.4   3000  0.5  2

; Triangle pad
i10 7     3    6.07  0.5   8000  0.2  3
e
</CsScore>
</CsoundSynthesizer>
```

**Explanation:**
- `zakinit` creates a modulation bus for routing LFO to PWM
- `vco2` with mode 2 and pulse width creates PWM sounds
- `moogvcf` is another Moog filter emulation (older but classic)
- Zak bus allows flexible modulation routing between instruments

---

## Example 4: Classic Filter Types Demonstrated

Based on FILTDEMO.csd

```csound
<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 1
0dbfs = 1

; Lowpass filter - removes high frequencies
instr 1
    ifreq = p4
    icutoff = p5

    ; Harmonically rich source
    asrc vco2 0.5, ifreq, 0

    ; Butterworth lowpass
    afilt butterlp asrc, icutoff

    kenv linseg 0, 0.01, 1, p3-0.06, 1, 0.05, 0
    out afilt * kenv
endin

; Highpass filter - removes low frequencies
instr 2
    ifreq = p4
    icutoff = p5

    asrc vco2 0.5, ifreq, 0

    ; Butterworth highpass
    afilt butterhp asrc, icutoff

    kenv linseg 0, 0.01, 1, p3-0.06, 1, 0.05, 0
    out afilt * kenv
endin

; Bandpass filter - isolates frequency band
instr 3
    ifreq = p4
    icf = p5    ; Center frequency
    ibw = p6    ; Bandwidth

    asrc vco2 0.5, ifreq, 0

    ; Resonant bandpass
    afilt reson asrc, icf, ibw, 1

    kenv linseg 0, 0.01, 1, p3-0.06, 1, 0.05, 0
    out afilt * kenv
endin

; Notch (band-reject) filter
instr 4
    ifreq = p4
    icf = p5
    ibw = p6

    asrc vco2 0.5, ifreq, 0

    ; Band-reject filter
    afilt areson asrc, icf, ibw, 1

    kenv linseg 0, 0.01, 1, p3-0.06, 1, 0.05, 0
    out afilt * kenv * 0.5
endin

; Resonant lowpass with sweep
instr 5
    ifreq = p4
    irez = p5

    asrc vco2 0.5, ifreq, 0

    ; Filter sweep
    kcf expseg ifreq*10, p3*0.5, ifreq*2, p3*0.5, ifreq*10

    ; Moog ladder with resonance
    afilt moogladder asrc, kcf, irez

    kenv linseg 0, 0.01, 1, p3-0.06, 1, 0.05, 0
    out afilt * kenv
endin

</CsInstruments>
<CsScore>
; Lowpass examples
i1 0   1.5 200 1000   ; Low cutoff
i1 2   1.5 200 4000   ; Higher cutoff

; Highpass examples
i2 4   1.5 200 500    ; Remove bass
i2 6   1.5 200 2000   ; Remove more

; Bandpass examples
i3 8   1.5 200 800  100   ; Narrow band
i3 10  1.5 200 800  400   ; Wide band

; Notch examples
i4 12  1.5 200 1000 200
i4 14  1.5 200 500  100

; Resonant sweep
i5 16  3   100 0.3
i5 19  3   100 0.6
i5 22  3   100 0.85
e
</CsScore>
</CsoundSynthesizer>
```

**Explanation:**
- `butterlp/butterhp` provide clean 2-pole Butterworth response
- `reson` is a 2-pole resonant bandpass, good for formant synthesis
- `areson` (band-reject) removes a frequency band
- `moogladder` adds musical resonance for classic synth sounds

---

## Example 5: Envelope-Controlled Filter (Auto-wah)

Based on EnvFilter.csd

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

; Envelope follower-controlled filter
instr 1
    iamp = p4
    idepth = p5     ; Filter sweep depth
    irez = p6       ; Resonance

    ; Rich harmonic source
    asrc vco2 iamp, cpspch(p7), 0

    ; Envelope follower
    aenv follow asrc, 0.02

    ; Smooth the envelope
    asmooth butterlp aenv, 30

    ; Scale envelope to filter frequency
    kfilt = 200 + (asmooth/iamp) * idepth * 5000

    ; Apply resonant filter
    afilt moogvcf asrc, kfilt, irez

    ; Amplitude envelope
    kamp linseg 0, 0.01, 1, p3-0.06, 1, 0.05, 0

    outs afilt*kamp, afilt*kamp
endin

; Triggered envelope filter (classic synth bass)
instr 2
    ifreq = cpspch(p4)
    iamp = p5
    ifco_start = p6     ; Starting filter cutoff
    ifco_end = p7       ; Ending filter cutoff
    irez = p8

    ; Source oscillator
    asrc vco2 iamp, ifreq, 0

    ; Filter envelope - fast attack, medium decay
    kfenv expseg ifco_start, 0.02, ifco_start, 0.001, ifco_start*1.5, 0.15, ifco_end, p3-0.171, ifco_end

    ; Apply filter
    afilt moogladder asrc, kfenv, irez

    ; Amplitude envelope
    kamp linseg 0, 0.005, 1, 0.1, 0.8, p3-0.155, 0.6, 0.05, 0

    outs afilt*kamp, afilt*kamp
endin

</CsInstruments>
<CsScore>
; Auto-wah style
;   dur  amp   depth rez  pitch
i1  0    2     0.4   0.8  0.4  7.00
i1  2.5  2     0.4   0.5  0.5  7.05
i1  5    3     0.4   1.0  0.3  6.07

; Punchy bass with filter envelope
;   dur  pitch amp   fco_st fco_end rez
i2  8    6.00  0.5   4000   200     0.3
i2  8.5  6.00  0.5   4000   200     0.3
i2  9    6.05  0.5   5000   300     0.35
i2  9.5  6.05  0.5   5000   300     0.35
i2  10   6.07  0.5   6000   250     0.4
i2  11   5.07  0.5   3000   150     0.5
e
</CsScore>
</CsoundSynthesizer>
```

**Explanation:**
- `follow` tracks the amplitude envelope of the input
- Envelope is smoothed and scaled to control filter cutoff
- Creates dynamic "wah" effects that respond to playing dynamics
- Triggered envelope creates classic punchy synth bass sounds

---

## Example 6: Detuned Multi-Oscillator "Supersaw"

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

; Supersaw-style detuned oscillator bank
instr 1
    ifreq = cpspch(p4)
    iamp = p5
    idetune = p6        ; Detune amount in cents
    ifco = p7           ; Filter cutoff multiplier
    irez = p8

    ; Convert cents to ratio
    idet = idetune / 1200

    ; 7 detuned sawtooth oscillators
    a1 vco2 iamp/7, ifreq * semitone(-idet*3)
    a2 vco2 iamp/7, ifreq * semitone(-idet*2)
    a3 vco2 iamp/7, ifreq * semitone(-idet)
    a4 vco2 iamp/7, ifreq                        ; Center
    a5 vco2 iamp/7, ifreq * semitone(idet)
    a6 vco2 iamp/7, ifreq * semitone(idet*2)
    a7 vco2 iamp/7, ifreq * semitone(idet*3)

    ; Mix oscillators
    amix = a1 + a2 + a3 + a4 + a5 + a6 + a7

    ; Filter envelope
    kfenv expseg ifco*ifreq, 0.1, ifco*ifreq*1.2, 0.2, ifco*ifreq*0.8, p3-0.3, ifco*ifreq*0.5

    ; Apply filter
    afilt moogladder amix, kfenv, irez

    ; Amplitude envelope
    kamp linseg 0, 0.05, 1, p3-0.15, 0.9, 0.1, 0

    ; Stereo spread using slight delay
    aL = afilt
    aR delay afilt, 0.0003

    outs aL*kamp, aR*kamp
endin

; Sub-oscillator bass
instr 2
    ifreq = cpspch(p4)
    iamp = p5
    ifco = p6
    irez = p7

    ; Main oscillator (saw)
    amain vco2 iamp*0.6, ifreq, 0

    ; Sub oscillator (square, one octave down)
    asub vco2 iamp*0.4, ifreq/2, 2, 0.5

    ; Mix
    amix = amain + asub

    ; Filter
    kfenv expseg ifco, 0.05, ifco*1.5, 0.1, ifco*0.3, p3-0.15, ifco*0.2

    afilt moogladder amix, kfenv, irez

    ; Envelope
    kamp linseg 0, 0.01, 1, 0.1, 0.7, p3-0.16, 0.5, 0.05, 0

    outs afilt*kamp, afilt*kamp
endin

</CsInstruments>
<CsScore>
; Supersaw pad
;   dur  pitch amp  detune fco  rez
i1  0    4     8.00 0.4   30   5    0.2
i1  4.5  4     8.07 0.4   25   4    0.25
i1  9    5     7.07 0.4   40   6    0.15

; Bass with sub
;   dur  pitch amp  fco   rez
i2  0    1     6.00 0.5   2000  0.3
i2  1.2  1     6.00 0.5   2000  0.3
i2  2.4  1     6.05 0.5   2500  0.35
i2  3.6  2     5.07 0.5   1500  0.4
e
</CsScore>
</CsoundSynthesizer>
```

**Explanation:**
- Multiple slightly detuned oscillators create rich "supersaw" sound
- `semitone()` function converts semitone offset to frequency ratio
- Sub-oscillator adds low-end weight (common in EDM bass)
- Slight stereo delay creates width without phase issues in mono

---

## Variations

1. **Different filter types**: Try `lpf18` (3-pole), `k35_lpf` (Korg 35), `diode_ladder`
2. **Parallel filters**: Route signal through multiple filters and mix outputs
3. **Filter FM**: Modulate cutoff with an audio-rate oscillator
4. **Noise mixing**: Add filtered noise for breathiness
5. **Key tracking**: Scale filter cutoff with pitch (`kcf = ifreq * imultiplier`)
6. **Velocity sensitivity**: Map MIDI velocity to filter cutoff and envelope intensity

---

## Common Issues

| Problem | Solution |
|---------|----------|
| Filter self-oscillation | Reduce resonance; values above 0.9 can cause oscillation |
| Harsh/digital sound | Use band-limited oscillators (vco2, buzz) not raw waveforms |
| Muddy bass | Reduce resonance at low frequencies; use highpass to clean sub content |
| Clicking on filter sweep | Smooth rapid cutoff changes with `port` or `lag` |
| CPU overload with many voices | Use `vco2` instead of multiple `oscil` for detuning |
| Thin sound | Add sub-oscillator or detune multiple oscillators |

---

## Related Examples

- csound_butterworth_filters_entry.md - Detailed Butterworth filter usage
- csound_filter_bank_vocoder_entry.md - Multiple parallel filters
- csound_tb303_emulator_entry.md - Classic acid bass synthesis
- csound_envelope_design_patterns_entry.md - Envelope shaping techniques
- csound_moog_filter_entry.md - Deep dive into Moog filter emulations
