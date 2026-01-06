Title: Sample Playback and Sound File Processing
Category: Sampling/Sound Files
Difficulty: Beginner to Intermediate
Tags: sample, sampling, soundin, diskin, loscil, table, GEN01, playback, pitch-shift, time-stretch, loops, sound file, audio file, wav, aiff

Description:
Csound provides multiple methods for loading and playing back sound files. The main approaches are: soundin/diskin for streaming directly from disk, loscil for looped sample playback (like a hardware sampler), and table-based playback using GEN 01 to load samples into memory. Each method has different trade-offs for CPU usage, flexibility, and memory consumption. This entry covers all major sample playback techniques and common processing operations like pitch shifting, time stretching, and sample scrambling.

================================================================================
EXAMPLE 1: Basic Sound File Playback with soundin and diskin
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

; Basic soundin playback (mono file)
        instr 1
ifile   = p4              ; Sound file number (soundin.N)
iskip   = p5              ; Skip time in seconds

asig    soundin ifile, iskip

kamp    linseg  0, 0.01, 1, p3-0.02, 1, 0.01, 0  ; De-click envelope

        outs    asig*kamp, asig*kamp
        endin

; Stereo soundin playback
        instr 2
ifile   = p4

asigL, asigR  soundin ifile

kamp    linseg  0, 0.01, 1, p3-0.02, 1, 0.01, 0

        outs    asigL*kamp, asigR*kamp
        endin

; diskin - more flexible, supports speed control
        instr 3
Sfile   = p4              ; Filename string
ispeed  = p5              ; Playback speed (1=normal, 2=double, 0.5=half)
iskip   = p6              ; Skip time

; diskin2 provides high-quality interpolation
asigL, asigR  diskin2 Sfile, ispeed, iskip, 0, 0, 4

kamp    linseg  0, 0.01, 1, p3-0.02, 1, 0.01, 0

        outs    asigL*kamp, asigR*kamp
        endin

; diskin with variable speed (pitch bend effect)
        instr 4
Sfile   = p4
ibasesp = p5              ; Base speed
ispvar  = p6              ; Speed variation amount

; Modulate playback speed with LFO
kspeed  oscil   ispvar, 0.5, 1
kspeed  = ibasesp + kspeed

asigL, asigR  diskin2 Sfile, kspeed, 0

kamp    linseg  0, 0.01, 1, p3-0.02, 1, 0.01, 0

        outs    asigL*kamp, asigR*kamp
        endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1            ; Sine for LFO

; Basic mono playback
i1 0 4 1 0                ; Play soundin.1 from beginning

; Stereo playback
i2 5 4 2                  ; Play soundin.2

; diskin with filename and speed
i3 10 4 "sample.wav" 1 0  ; Normal speed
i3 15 2 "sample.wav" 2 0  ; Double speed (octave up)
i3 18 8 "sample.wav" 0.5 0 ; Half speed (octave down)

; Variable speed wobble effect
i4 27 6 "sample.wav" 1 0.2
e
</CsScore>
</CsoundSynthesizer>
```

Explanation:
**soundin** is the simplest method - it reads samples directly from disk:
- Takes a file number (reads soundin.1, soundin.2, etc.) or filename string
- Supports stereo with two output arguments
- Limited control - plays at original speed only

**diskin/diskin2** provides more flexibility:
- Accepts filename strings directly
- Speed parameter allows pitch shifting (2 = octave up, 0.5 = octave down)
- Skip time for starting at arbitrary positions
- diskin2 uses better interpolation for smoother pitch shifting

The de-click envelope (linseg) prevents pops at note start/end by ramping amplitude.

================================================================================
EXAMPLE 2: Table-Based Sample Playback with GEN 01
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

; Simple table playback using line index
        instr 1

itab    = p4              ; Table number containing sample
idur    = p3

; Linear index from 0 to 1 over duration
aindex  line    0, idur, 1

; Read table (multiply by table size for proper indexing)
; ftlen returns table length
asig    tablei  aindex * ftlen(itab), itab

kamp    linseg  0, 0.01, 1, idur-0.02, 1, 0.01, 0

        out     asig * kamp
        endin

; Phasor-based playback with pitch control
        instr 2

itab    = p4
ibasefrq = sr / ftlen(itab)  ; Frequency for original pitch
ipitch  = p5                  ; Pitch multiplier

; Phasor generates 0-1 ramp at specified frequency
aphs    phasor  ibasefrq * ipitch

asig    tablei  aphs, itab, 1, 0, 1  ; Normalized table read

kamp    linseg  0, 0.01, 1, p3-0.02, 1, 0.01, 0

        out     asig * kamp
        endin

; Manual phase accumulation for scrubbing
        instr 3

itab    = p4
istart  = p5              ; Start position (0-1)
iend    = p6              ; End position (0-1)

; Linear interpolation through portion of sample
apos    line    istart, p3, iend

asig    tablei  apos, itab, 1, 0, 1

kamp    linseg  0, 0.01, 1, p3-0.02, 1, 0.01, 0

        out     asig * kamp
        endin

</CsInstruments>
<CsScore>
; GEN 01 loads sound file into table
; f# time size GEN "filename" skiptime format channel
; Size 0 = deferred (Csound determines size from file)
f1 0 0 1 "sample.wav" 0 0 0
f2 0 65536 1 "loop.wav" 0 4 0    ; Fixed size, format 4 = 16-bit

; Simple playback - plays whole sample in p3 duration
i1 0 2 1                  ; 2-second playback of table 1

; Phasor playback with pitch control
i2 3 2 1 1.0              ; Original pitch
i2 5 2 1 1.5              ; Fifth up
i2 7 2 1 0.5              ; Octave down
i2 9 4 1 0.25             ; Two octaves down, slower

; Scrubbing - play just a portion
i3 14 1 1 0.2 0.4         ; Play from 20% to 40%
i3 15 2 1 0.8 0.2         ; Reverse: 80% to 20%
e
</CsScore>
</CsoundSynthesizer>
```

Explanation:
**GEN 01** loads a sound file into a function table:
- Size 0 means deferred - Csound auto-sizes the table to fit the file
- Format codes: 0=auto, 1=16-bit short, 4=16-bit short, 6=32-bit float
- Channel: 0=all, 1=left, 2=right

**tablei** provides interpolated table reading:
- First argument is the index
- With normalized mode (arg4=1), index ranges 0-1
- Wrap mode (arg5=1) wraps index for looping

**phasor** generates a repeating 0-1 ramp at the specified frequency:
- Frequency = sr/tablesize gives original pitch
- Multiply frequency to change pitch
- Natural looping behavior

Manual scrubbing with line allows arbitrary start/end points and can play backwards (istart > iend).

================================================================================
EXAMPLE 3: Looped Sample Playback with loscil (Sampler-Style)
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

; Hardware sampler-style playback with pitch tracking
        instr 1

iamp    = p4
ipitch  = cpspch(p5)      ; Desired pitch
ibase   = cpspch(p6)      ; Original sample pitch (root key)
itab    = p7              ; Sample table
iatk    = p8              ; Attack time
idcy    = p9              ; Decay time
irel    = p10             ; Release time

idur    = p3 + irel       ; Extend duration for release
p3      = idur

; Amplitude envelope (ADSR-like)
kamp    linseg  0, iatk, 1, idur-iatk-idcy, 1, idcy, 0

; loscil: looping oscillator
; xamp, xcps, ifn, ibas [, imod1, ibeg1, iend1, imod2, ibeg2, iend2]
asamp   loscil  iamp, ipitch, itab, ibase

        outs    asamp*kamp, asamp*kamp
        endin

; Multi-sample playback (velocity layers)
        instr 2

iamp    = p4
ivel    = p5              ; Velocity 0-127
ipitch  = cpspch(p6)
ibase   = cpspch(8.09)    ; All samples recorded at A4

; Select sample based on velocity
if ivel < 43 then
    itab = 1              ; Soft sample
elseif ivel < 85 then
    itab = 2              ; Medium sample
else
    itab = 3              ; Loud sample
endif

; Scale amplitude by velocity
ivelamp = ivel / 127

kamp    linseg  0, 0.002, 1, p3-0.003, 1, 0.001, 0

asamp   loscil  iamp * ivelamp, ipitch, itab, ibase

        outs    asamp*kamp, asamp*kamp
        endin

; Looped sustain with crossfade
        instr 3

iamp    = p4
ipitch  = cpspch(p5)
ibase   = cpspch(8.09)
itab    = p6
isusloop = p7             ; 1 = sustain loop on

if isusloop == 1 then
    ; Use loop points embedded in sample or define here
    ; imod: 0=no loop, 1=loop forward, 2=loop back/forth
    ; Loop points are in sample frames
    asamp loscil iamp, ipitch, itab, ibase, 1, 10000, 30000
else
    asamp loscil iamp, ipitch, itab, ibase, 0
endif

kenv    linseg  0, 0.01, 1, p3-0.11, 1, 0.1, 0

        outs    asamp*kenv, asamp*kenv
        endin

</CsInstruments>
<CsScore>
; Load drum samples at different velocities
f1 0 0 1 "tom_soft.wav" 0 4 0
f2 0 0 1 "tom_med.wav" 0 4 0
f3 0 0 1 "tom_loud.wav" 0 4 0

; Pitched instrument sample
f4 0 0 1 "piano_a4.wav" 0 4 0

;   Sta  Dur  Amp   Pitch  Base   Tab  Atk   Dcy  Rel
i1  0    0.2  0.8   8.09   8.09   4    0.002 0.1  0.1
i1  +    0.2  0.8   8.04   8.09   4    .     .    .
i1  +    0.2  0.8   8.11   8.09   4    .     .    .
i1  +    0.2  0.8   9.02   8.09   4    .     .    .

; Velocity-switched drum hits
;   Sta  Dur  Amp   Vel  Pitch
i2  2    0.3  0.8   30   8.09     ; Soft
i2  +    0.3  0.8   70   8.09     ; Medium
i2  +    0.3  0.8   120  8.09     ; Loud

; Looped sustain
i3  4    3    0.6   8.00  4  1    ; With sustain loop
i3  7    1    0.6   8.00  4  0    ; Without loop
e
</CsScore>
</CsoundSynthesizer>
```

Explanation:
**loscil** emulates hardware samplers:
- Reads from a GEN 01 table at specified pitch
- ibase (base frequency) is the pitch at which the sample was recorded
- Automatically transposes by comparing xcps to ibas
- Supports loop points for sustained sounds

Loop modes (imod):
- 0: No looping (one-shot)
- 1: Forward loop (standard sustain)
- 2: Bidirectional (ping-pong) loop

ibeg/iend specify loop points in sample frames. Many samplers embed these in the file header; Csound can read them automatically with certain file formats.

Multi-sample/velocity switching creates more realistic instruments by using different recordings for different velocities or pitch ranges.

================================================================================
EXAMPLE 4: Sample Scrambler and Stutterer Effects
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

; Random segment scrambler
        instr 1

irlps   = p4              ; Max random loop repetitions
irdr1   = p5              ; Max random segment duration
irdr2   = p6              ; Min segment duration
iroff   = p7              ; Max random offset into file
ipan    = p8              ; Pan position (0-1)
ipanl   = sqrt(ipan)
ipanr   = sqrt(1-ipan)

; Initialize random parameters
idur    = rnd(irdr1) + irdr2      ; Random duration
ioffs   = rnd(iroff)              ; Random start position
inloops = int(rnd(irlps))         ; Random loop count

icount  = 0

kdclk   linseg  0, 0.002, 1, p3-0.004, 1, 0.002, 0

loop:
  ; Segment envelope to prevent clicks
  kaenv   linseg  0, 0.002, 1, idur-0.004, 1, 0.002, 0

  ; Read from random position in file
  asig    diskin2 "sample.wav", 1, ioffs
  aout    = asig * kaenv

  ; Check if segment time elapsed
  timout  0, idur, cont1
    icount = icount + 1
    if (icount <= inloops) igoto next
       ; Get new random parameters
       icount  = 0
       inloops = int(rnd(irlps))
       idur    = rnd(irdr1) + irdr2
       ioffs   = rnd(iroff)
next:
  reinit  loop

cont1:
        outs    aout*kdclk*ipanl, aout*kdclk*ipanr
        endin

; Stutter effect with tempo-synced loops
        instr 2

idur    = p3
ifqc    = p4              ; Stutter rate (Hz)
Sfile   = p5

; Stutter segment duration
isegdur = 1/ifqc
icount  = 0

koffset line    0, idur, 1        ; Progress through file

kenv    linseg  0, 0.01, 1, p3-0.02, 1, 0.01, 0

loop1:
  kamp    linseg  0, 0.005, 1, i(isegdur)-0.01, 1, 0.005, 0

  ; Read from current offset position
  asigL, asigR soundin Sfile, i(koffset)
  aout    = (asigL+asigR)/2 * kamp

  timout  0, isegdur, cont1
  reinit  loop1

cont1:
        outs    aout*kenv, aout*kenv
        endin

; Beat-synced sample chopper
        instr 3

itempo  = p4              ; BPM
ibeats  = p5              ; Beats per segment
Sfile   = p6

isegdur = (60/itempo) * ibeats
ioffs   = 0

kenv    linseg  0, 0.01, 1, p3-0.02, 1, 0.01, 0

loop:
  kchop   linseg  0, 0.002, 1, isegdur-0.004, 1, 0.002, 0

  ; Random beat offset
  ioffs   = int(rnd(8)) * isegdur

  asigL, asigR diskin2 Sfile, 1, ioffs
  aout    = (asigL+asigR)/2 * kchop

  timout  0, isegdur, cont
  reinit  loop

cont:
        outs    aout*kenv, aout*kenv
        endin

</CsInstruments>
<CsScore>
; Scrambler - random chunks
;   Sta  Dur  MaxLoops MaxDur MinDur MaxOff Pan
i1  0    16   16       0.1    0.02   2      1
i1  0    16   16       0.1    0.02   2      0

; Stutter effect
i2  17   8    8    "sample.wav"       ; 8 Hz stutter

; Beat-synced chopper
i3  26   8    120  0.5  "drums.wav"   ; 120 BPM, half-beat segments
e
</CsScore>
</CsoundSynthesizer>
```

Explanation:
The **reinit/timout** pattern enables dynamic segment-based processing:

1. **timout** delays reinitialization for the segment duration
2. When time expires, **reinit** jumps back to recalculate parameters
3. Each segment can have random or controlled duration, offset, etc.

**Scrambler** picks random chunks from the file and loops them random times before picking a new chunk. Creates glitchy, cut-up textures.

**Stutter** repeatedly plays the same position, creating rhythmic repetition effects. The koffset slowly advances through the file.

**Beat-synced chopper** quantizes segment timing to a tempo grid, useful for remix-style effects. Random offset picks different beat positions.

Key envelope techniques:
- Overall kenv prevents clicks at instrument start/end
- Segment kaenv prevents clicks at each loop point
- Short attack/decay times (2-5ms) are sufficient

================================================================================
EXAMPLE 5: Pitch Shifting via Table Resampling
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

; Pitch shifting by resampling rate change
        instr 1

itab    = p4
ipnew   = cpspch(p5)      ; Desired pitch
ipold   = cpspch(p6)      ; Original pitch
ioldsr  = p7              ; Original sample rate

; Calculate resampling increment
; Ratio adjusts for both pitch change and sample rate difference
incr    = (ioldsr/sr) * (ipnew/ipold)

kphase  init    0
aphase  interp  kphase            ; Convert k-rate to a-rate smoothly
asig    tablei  aphase, itab      ; Read with interpolation
kphase  = kphase + incr*ksmps     ; Advance phase

kamp    linseg  0, 0.01, 1, p3-0.02, 1, 0.01, 0

        out     asig * kamp
        endin

; Pitch shift with formant preservation (simplified)
        instr 2

itab    = p4
ipshift = p5              ; Pitch shift ratio (1=no change, 2=octave up)

ibasefq = sr / ftlen(itab)

; Read at shifted rate
aphs    phasor  ibasefq * ipshift
asig    tablei  aphs, itab, 1, 0, 1

; Formant correction: filter to compensate for spectral shift
; When pitch goes up, formants shift up - filter them back down
if ipshift > 1 then
    icutoff = 4000 / ipshift      ; Lower cutoff for upward shift
else
    icutoff = 4000 * (1/ipshift)  ; Raise cutoff for downward shift
endif

aout    tone    asig, icutoff

kamp    linseg  0, 0.01, 1, p3-0.02, 1, 0.01, 0

        out     aout * kamp
        endin

; Real-time pitch bend with envelope
        instr 3

itab    = p4
ipstart = p5              ; Starting pitch ratio
ipend   = p6              ; Ending pitch ratio

ibasefq = sr / ftlen(itab)

; Pitch envelope
kpratio line    ipstart, p3, ipend
kfq     = ibasefq * kpratio

aphs    phasor  kfq
asig    tablei  aphs, itab, 1, 0, 1

kamp    linseg  0, 0.01, 1, p3-0.02, 1, 0.01, 0

        out     asig * kamp
        endin

</CsInstruments>
<CsScore>
; Load sample (recorded at 44100 Hz, pitch = A4)
f1 0 32768 -1 "sample.wav" 0

; Transpose using resampling
;   Sta  Dur  Tab  NewPitch  OldPitch  OldSR
i1  0    2    1    9.00      8.09      44100   ; Up a minor 3rd
i1  3    2    1    8.04      8.09      44100   ; Down a 5th
i1  6    2    1    7.09      8.09      44100   ; Down an octave

; With simple formant correction
i2  9    2    1    2         ; Octave up
i2  12   4    1    0.5       ; Octave down

; Pitch bend sweep
i3  17   4    1    1.0  0.5  ; Bend down an octave
i3  22   2    1    0.5  2.0  ; Sweep up two octaves
e
</CsScore>
</CsoundSynthesizer>
```

Explanation:
Simple pitch shifting via resampling changes both pitch AND duration:
- Reading faster (incr > 1) raises pitch and shortens duration
- Reading slower (incr < 1) lowers pitch and lengthens duration

The resampling formula accounts for:
- Pitch change ratio (ipnew/ipold)
- Sample rate conversion (ioldsr/sr)

**interp** converts the k-rate phase to a-rate, providing smooth interpolation crucial for audio quality.

**Formant correction**: When you pitch shift a voice up, the formants (resonances that determine vowel sounds) also shift up, making voices sound "chipmunk-like." A simple lowpass filter can partially compensate. For proper formant-preserving pitch shift, use spectral processing (pvs opcodes) or granular techniques.

================================================================================
EXAMPLE 6: Sampler Effect Processor with Table Control
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

; Complex sampler with table-driven parameters
        instr 1

idur    = p3
iamp    = p4
ifqc    = p5              ; Playback rate
irattab = p6              ; Rate modulation table
iratrat = p7              ; Rate of rate modulation
ipantab = p8              ; Pan automation table
imixtab = p9              ; Amplitude automation table
ilptab  = p10             ; Loop duration table
isndin  = p11             ; Sound file number

; Read automation curves from tables
kpan    oscil   1, 1/idur, ipantab      ; Pan position
kmix    oscil   1, 1/idur, imixtab      ; Volume automation
kloop   oscil   1, 1/idur, ilptab       ; Loop length

loop1:
  kprate  oscil   1, iratrat/kloop, irattab  ; Modulated rate
  kamp    linseg  0, 0.01, 1, i(kloop)-0.02, 1, 0.01, 0

  asigL, asigR soundin isndin
  aout    = (asigL+asigR)/2 * kamp

  timout  0, i(kloop), cont1
  reinit  loop1

cont1:
        ; Equal-power panning
        outs    aout*sqrt(kpan)*kmix, aout*sqrt(1-kpan)*kmix
        endin

</CsInstruments>
<CsScore>
; Automation tables

; Rate modulation (varies playback rate)
f29 0 1024 -7 0.5 250 0.5 6 2 250 2 6 1 250 1 6 4 256 0.5

; Pan sweep (left to right)
f31 0 1024 7 1 1024 0

; Volume envelope (fade in, sustain, fade out)
f41 0 1024 5 0.01 128 1 768 1 128 0.01

; Loop duration (gets shorter over time)
f53 0 1024 -7 0.12 512 0.15 512 0.24

;   Sta  Dur  Amp  Pitch  RtTab  RtRt  PanTab  MixTab  LoopTab  File
i1  0    8    0.8  1      29     1     31      41      53       1

; Double speed version
i1  9    8    0.8  2      29     2     31      41      53       1
e
</CsScore>
</CsoundSynthesizer>
```

Explanation:
Using function tables to control parameters enables complex automation:

- **Rate table (f29)**: Multi-segment envelope defining playback speed changes
- **Pan table (f31)**: Smooth pan sweep from left to right
- **Mix table (f41)**: Exponential fade-in and fade-out
- **Loop table (f53)**: Varying loop durations

oscil reads through the table once per note duration (1/idur Hz), providing parameter automation over the instrument's lifetime.

The **reinit/timout** loop structure allows the loop duration (ilptab) to affect segment length dynamically - as kloop changes, segment timing changes.

Equal-power panning formula: sqrt(pan) and sqrt(1-pan) maintains constant perceived loudness as sound pans across the stereo field.

Variations:
1. Use random tables (GEN 21) for stochastic parameter variation
2. Add more automation tables for filter cutoff, resonance, etc.
3. Nest multiple reinit loops for complex rhythmic patterns
4. Use MIDI input to trigger samples and control parameters

Common Issues:

1. **Clicks at segment boundaries**: Always use short amplitude ramps (2-5ms) at the start and end of each segment. Use linseg with very short attack/decay times.

2. **Pitch quality with large shifts**: Simple resampling causes artifacts at extreme transpositions. For better quality, use higher-order interpolation (diskin2 with interp=4) or granular/spectral methods.

3. **Memory overflow with large files**: GEN 01 loads entire files into memory. For very long files, use diskin which streams from disk.

4. **Wrong sample rate**: If the sample has a different rate than sr, pitch will be wrong. Account for this in your frequency calculations: incr = (file_sr/sr) * desired_ratio

5. **Loop clicks**: Loop points should be at zero-crossings or use crossfade techniques. For simple looping, ensure loop start and end points have similar amplitudes.

6. **soundin file numbering**: soundin expects files named soundin.1, soundin.2, etc. in the current directory, or use SSDIR environment variable. Use diskin2 with string filenames for more flexibility.

Related Examples:
- csound_granular_synthesis_entry.md (granular sample manipulation)
- csound_delay_line_effects_entry.md (sample-based delays)
- csound_midi_integration_entry.md (MIDI-triggered samples)
