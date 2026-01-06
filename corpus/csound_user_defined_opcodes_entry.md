Title: User-Defined Opcodes (UDOs)
Category: Code Organization/Modularity
Difficulty: Intermediate
Tags: UDO, opcode, function, reusable, modular, macro, abstraction, encapsulation, setksmps

Description:
User-Defined Opcodes (UDOs) allow you to create custom reusable opcodes in Csound. UDOs encapsulate complex signal processing or synthesis routines into simple, callable units. They improve code organization, reduce duplication, and enable you to build your own library of audio processing functions. UDOs can have their own local ksmps settings, allowing fine-grained control over performance characteristics.

---

## Example 1: Basic UDO - Simple Tremolo

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

; Define a simple tremolo UDO
; Inputs: audio signal, rate, depth (0-1)
; Output: processed audio signal
opcode Tremolo, a, akk
    ain, krate, kdepth xin

    klfo oscil kdepth, krate, -1  ; sine LFO
    kamp = 1 - kdepth*0.5 + klfo*0.5  ; scale to 0.5-1 range
    aout = ain * kamp

    xout aout
endop

instr 1
    ; Source signal
    asrc oscil 0.5, cpspch(p4), -1

    ; Apply tremolo using our UDO
    atrem Tremolo asrc, p5, p6

    ; Envelope
    kenv linseg 0, 0.05, 1, p3-0.1, 1, 0.05, 0

    outs atrem*kenv, atrem*kenv
endin

</CsInstruments>
<CsScore>
;       dur  pitch  rate  depth
i1 0    2    8.00   5     0.8
i1 2.5  2    8.04   8     0.5
i1 5    3    7.07   3     0.9
e
</CsScore>
</CsoundSynthesizer>
```

**Explanation:**
- `opcode Tremolo, a, akk` declares a UDO named "Tremolo" that outputs one audio signal (`a`) and takes three inputs: audio, k-rate, k-rate (`akk`)
- `xin` receives the input arguments in declared order
- `xout` sends the output value(s) back to the caller
- `endop` marks the end of the UDO definition
- The UDO is called like any built-in opcode: `atrem Tremolo asrc, p5, p6`

---

## Example 2: UDO with Multiple Outputs

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

; Stereo panner with width control
; Returns left and right channels
opcode StereoPan, aa, akk
    ain, kpan, kwidth xin

    ; kpan: 0=left, 0.5=center, 1=right
    ; kwidth: stereo spread (0=mono, 1=full stereo)

    kpanL = 0.5 + (0.5 - kpan) * kwidth
    kpanR = 0.5 + (kpan - 0.5) * kwidth

    ; Equal-power panning
    aleft = ain * sqrt(kpanL)
    aright = ain * sqrt(kpanR)

    xout aleft, aright
endop

instr 1
    ; Generate source
    asrc vco2 0.4, cpspch(p4)

    ; Autopan using LFO
    kpan oscil 0.5, p5, -1
    kpan = kpan + 0.5  ; center around 0.5

    ; Use our stereo panner
    aL, aR StereoPan asrc, kpan, p6

    ; Envelope
    kenv linseg 0, 0.02, 1, p3-0.07, 1, 0.05, 0

    outs aL*kenv, aR*kenv
endin

</CsInstruments>
<CsScore>
;       dur  pitch  panRate  width
i1 0    3    8.00   0.5      1.0
i1 3.5  3    8.07   2.0      0.5
i1 7    4    7.07   0.25     0.8
e
</CsScore>
</CsoundSynthesizer>
```

**Explanation:**
- `opcode StereoPan, aa, akk` declares two audio outputs (`aa`)
- Multiple outputs are assigned via `xout aleft, aright`
- When calling: `aL, aR StereoPan asrc, kpan, p6` - outputs are received in order

---

## Example 3: UDO with Local ksmps (setksmps)

```csound
<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32  ; Global ksmps
nchnls = 2
0dbfs = 1

; Envelope follower with fine control rate
; Uses local ksmps for more accurate tracking
opcode EnvFollow, k, ai
    ain, iresponse xin
    setksmps 1  ; Process at audio rate for accuracy

    ; RMS follower with variable response time
    krms rms ain
    kfollow port krms, iresponse

    xout kfollow
endop

; Filter with envelope-controlled cutoff
opcode EnvFilter, a, akkki
    ain, kbasefreq, kdepth, kresonance, iresponse xin

    ; Get envelope of input
    kenv EnvFollow ain, iresponse

    ; Scale envelope to frequency range
    kfreq = kbasefreq + kenv * kdepth * 10000
    kfreq limit kfreq, 20, sr/2 - 100

    ; Apply resonant lowpass filter
    aout moogladder ain, kfreq, kresonance

    xout aout
endop

instr 1
    ; Rich source with harmonics
    asrc vco2 0.3, cpspch(p4), 0  ; Sawtooth

    ; Add some grit
    asrc = asrc + vco2(0.1, cpspch(p4)*2.01, 2)  ; Detuned square

    ; Apply envelope-following filter
    afilt EnvFilter asrc, 200, p5, p6, 0.01

    ; Master envelope
    kenv linseg 0, 0.01, 1, p3-0.06, 1, 0.05, 0

    outs afilt*kenv, afilt*kenv
endin

</CsInstruments>
<CsScore>
;       dur  pitch  depth  resonance
i1 0    2    6.00   0.8    0.4
i1 2.5  2    6.07   0.5    0.7
i1 5    3    5.07   1.0    0.3
e
</CsScore>
</CsoundSynthesizer>
```

**Explanation:**
- `setksmps 1` inside a UDO sets a local control rate just for that opcode
- This is crucial for accurate envelope following and pitch tracking
- UDOs can call other UDOs (EnvFilter calls EnvFollow)
- The local ksmps doesn't affect the global orchestra setting

---

## Example 4: Recursive UDO - Multi-tap Delay

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

; Single delay tap with feedback
opcode DelayTap, a, aiik
    ain, idelay, ifeedback, kwet xin

    abuf delayr 2.0
    atap deltap idelay
    delayw ain + atap * ifeedback

    aout = ain * (1 - kwet) + atap * kwet
    xout aout
endop

; Multi-tap delay using multiple UDO calls
opcode MultiDelay, a, aiiiiikkk
    ain, idel1, idel2, idel3, ifb1, ifb2, ifb3, kwet xin

    a1 DelayTap ain, idel1, ifb1, kwet
    a2 DelayTap a1, idel2, ifb2, kwet * 0.7
    a3 DelayTap a2, idel3, ifb3, kwet * 0.5

    xout a3
endop

instr 1
    ; Percussive source
    aenv expon 1, 0.3, 0.001
    anoise rand 0.8
    asrc butterlp anoise * aenv, 2000
    asrc = asrc + oscil(aenv * 0.5, 150, -1)

    ; Multi-tap delay
    kwet linseg 0, 0.1, p5, p3-0.1, p5
    adly MultiDelay asrc, 0.125, 0.25, 0.375, 0.5, 0.4, 0.3, kwet

    outs adly, adly
endin

instr 2
    ; Melodic source
    asrc vco2 0.3, cpspch(p4)
    kenv linseg 0, 0.01, 1, 0.1, 0.5, p3-0.16, 0.3, 0.05, 0
    asrc = asrc * kenv

    ; Apply delay
    adly MultiDelay asrc, 0.166, 0.333, 0.5, 0.4, 0.35, 0.3, p5

    outs adly, adly
endin

</CsInstruments>
<CsScore>
; Percussive hits
i1 0    2    0    0.6
i1 2.5  2    0    0.8

; Melodic
i2 5    2    8.00  0.5
i2 6    2    8.04  0.5
i2 7    3    8.07  0.6
e
</CsScore>
</CsoundSynthesizer>
```

**Explanation:**
- UDOs can call other UDOs, enabling modular design
- `MultiDelay` builds on `DelayTap` to create complex effects
- Long type signatures (`aiiiiikkk`) specify multiple inputs of different rates

---

## Example 5: UDO with Optional/Default Arguments Using init

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

; ADSR envelope generator with sensible defaults
; All times are relative to note duration
opcode ADSRenv, k, ioooo
    idur, iattack, idecay, isustain, irelease xin

    ; Set defaults if arguments are 0 or omitted
    iattack = (iattack == 0 ? 0.1 : iattack)
    idecay = (idecay == 0 ? 0.2 : idecay)
    isustain = (isustain == 0 ? 0.7 : isustain)
    irelease = (irelease == 0 ? 0.2 : irelease)

    ; Calculate absolute times
    iatt_t = idur * iattack
    idec_t = idur * idecay
    isus_t = idur * (1 - iattack - idecay - irelease)
    irel_t = idur * irelease

    ; Ensure minimum sustain time
    isus_t = (isus_t < 0.01 ? 0.01 : isus_t)

    kenv linseg 0, iatt_t, 1, idec_t, isustain, isus_t, isustain, irel_t, 0

    xout kenv
endop

; Simple synth voice using the ADSR UDO
opcode SynthVoice, a, iiioooo
    iamp, ifreq, iwave, iatt, idec, isus, irel xin

    ; Generate envelope
    kenv ADSRenv p3, iatt, idec, isus, irel

    ; Select waveform
    if iwave == 0 then
        asrc vco2 iamp, ifreq, 0   ; Sawtooth
    elseif iwave == 1 then
        asrc vco2 iamp, ifreq, 2   ; Square
    elseif iwave == 2 then
        asrc vco2 iamp, ifreq, 4   ; Triangle
    else
        asrc oscil iamp, ifreq, -1 ; Sine
    endif

    xout asrc * kenv
endop

instr 1
    aout SynthVoice p4, cpspch(p5), p6, p7, p8, p9, p10
    outs aout, aout
endin

; Simplified call with defaults
instr 2
    aout SynthVoice p4, cpspch(p5), p6  ; Uses default ADSR
    outs aout, aout
endin

</CsInstruments>
<CsScore>
; Full ADSR specification
;        amp   pitch wave att  dec  sus  rel
i1 0   1 0.3   8.00  0    0.05 0.1  0.8  0.2
i1 1.5 1 0.3   8.04  1    0.01 0.3  0.4  0.3
i1 3   2 0.3   8.07  2    0.3  0.1  0.9  0.1

; Using defaults
;        amp   pitch wave
i2 5.5 1 0.3   7.00  0
i2 7   1 0.3   7.07  1
i2 8.5 2 0.3   8.00  3
e
</CsScore>
</CsoundSynthesizer>
```

**Explanation:**
- `o` in the type signature means optional i-rate argument
- Ternary operator `(condition ? value_if_true : value_if_false)` handles defaults
- UDOs can be called with fewer arguments when using `o` optional types
- This pattern allows flexible APIs with sensible defaults

---

## Example 6: UDO Library Pattern - Complete Synth Module

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

;=====================================================
; UDO LIBRARY: Modular Synthesizer Components
;=====================================================

; Detuned oscillator bank for fat sounds
opcode FatOsc, a, ikkii
    iamp, kfreq, kdetune, ivoices, iwave xin

    asum init 0
    kdet init 0

    icount = 0
    loop:
        ; Spread detuning across voices
        kdet = (icount - (ivoices-1)/2) * kdetune

        if iwave == 0 then
            avoice vco2 iamp/ivoices, kfreq * (1 + kdet*0.01), 0
        elseif iwave == 1 then
            avoice vco2 iamp/ivoices, kfreq * (1 + kdet*0.01), 2
        else
            avoice oscil iamp/ivoices, kfreq * (1 + kdet*0.01), -1
        endif

        asum = asum + avoice

        icount = icount + 1
        if icount < ivoices igoto loop

    xout asum
endop

; State-variable filter with multiple outputs
opcode SVFilter, aaa, akk
    ain, kfreq, kres xin

    ; Limit frequency to safe range
    kfreq limit kfreq, 20, sr/2 * 0.9

    ; State variable filter coefficients
    kf = 2 * sin($M_PI * kfreq / sr)
    kq = 1 - kres
    kq = (kq < 0.01 ? 0.01 : kq)  ; Prevent division by zero

    ; State variables
    alow init 0
    aband init 0

    ; Process
    ahigh = ain - alow - kq * aband
    aband = kf * ahigh + aband
    alow = kf * aband + alow

    ; Notch is high + low
    anotch = ahigh + alow

    xout alow, ahigh, aband
endop

; LFO with multiple waveforms
opcode LFO, k, iki
    iamp, kfreq, iwave xin

    if iwave == 0 then
        ; Sine
        kout oscil iamp, kfreq, -1
    elseif iwave == 1 then
        ; Triangle
        kout lfo iamp, kfreq, 1
    elseif iwave == 2 then
        ; Square
        kout lfo iamp, kfreq, 3
    elseif iwave == 3 then
        ; Sawtooth up
        kout lfo iamp, kfreq, 0
    else
        ; Sample & Hold
        kph phasor kfreq
        ktrig trigger kph, 0.5, 0
        krand random -iamp, iamp
        kout samphold krand, ktrig
    endif

    xout kout
endop

;=====================================================
; INSTRUMENTS USING THE UDO LIBRARY
;=====================================================

instr 1  ; Fat pad with filter sweep
    ibasefreq = cpspch(p4)

    ; LFO for filter modulation
    klfo LFO 1, p5, p6  ; amp, rate, wave

    ; Fat oscillator
    aosc FatOsc 0.3, ibasefreq, p7, 5, 0  ; amp, freq, detune, voices, wave

    ; Filter with LFO modulation
    kfiltfreq = 500 + klfo * 400
    alow, ahigh, aband SVFilter aosc, kfiltfreq, p8

    ; Mix filter outputs
    amix = alow * 0.7 + aband * 0.3

    ; Envelope
    kenv linseg 0, 0.2, 1, p3-0.4, 0.8, 0.2, 0

    outs amix*kenv, amix*kenv
endin

instr 2  ; Lead synth with filter options
    ibasefreq = cpspch(p4)

    ; Vibrato
    kvib LFO 0.01, 5, 0  ; Sine LFO
    kfreq = ibasefreq * (1 + kvib)

    ; Single fat osc
    aosc FatOsc 0.4, kfreq, 0.5, 3, 1  ; Square wave

    ; Filter envelope
    kfiltenv expseg 4000, 0.1, 1000, p3-0.1, 500

    alow, ahigh, aband SVFilter aosc, kfiltenv, p5

    ; Use lowpass output
    kenv linseg 0, 0.01, 1, p3-0.06, 0.9, 0.05, 0

    outs alow*kenv, alow*kenv
endin

</CsInstruments>
<CsScore>
; Pad: dur pitch lfoRate lfoWave detune resonance
i1 0    4   7.00   0.3    0      2      0.5
i1 4.5  4   7.07   0.5    1      1.5    0.6
i1 9    5   6.07   0.2    3      3      0.4

; Lead: dur pitch resonance
i2 0    1   9.00   0.4
i2 1.2  0.8 9.04   0.5
i2 2.2  1.5 9.07   0.3
i2 4    2   8.07   0.6
e
</CsScore>
</CsoundSynthesizer>
```

**Explanation:**
- UDOs can be organized as a library of reusable components
- Complex instruments are built by combining simple UDO building blocks
- This modular approach promotes code reuse and maintainability
- Each UDO has a single responsibility (oscillator, filter, LFO)

---

## Variations

1. **String type arguments**: Use `S` type for passing strings to UDOs (e.g., file paths)
2. **Array arguments**: Modern Csound supports arrays in UDOs with `k[]` or `a[]` types
3. **Global UDO files**: Store UDOs in separate `.udo` files and include with `#include`
4. **Polymorphic UDOs**: Create multiple versions with same name but different signatures
5. **Recursive UDOs**: UDOs can call themselves (with care to avoid infinite loops)

---

## Common Issues

| Problem | Solution |
|---------|----------|
| "Unknown opcode" error | Ensure UDO is defined before it's called in the orchestra |
| Wrong number of outputs | Check output type signature matches xout statement |
| Feedback/initialization issues | Use `init` for state variables that need initial values |
| Performance issues | Use `setksmps` only when necessary; higher values are more efficient |
| Type mismatch errors | Ensure input types (a/k/i) match between definition and call |
| UDO not found after `#include` | Check file path and ensure file contains valid UDO syntax |

---

## Related Examples

- csound_delay_line_effects_entry.md - Effects that benefit from UDO encapsulation
- csound_filter_bank_vocoder_entry.md - Complex filter banks as UDOs
- csound_reverb_design_entry.md - Reverb algorithms as reusable UDOs
- csound_fm_synthesis_entry.md - FM operators as UDO building blocks
