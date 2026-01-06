# TB-303 Bassline Emulator

## Metadata

- **Title:** TB-303 Bassline Emulator (Acid Bassline Synthesizer)
- **Category:** Synthesizer Emulation / Sequencing / Subtractive Synthesis / Dance Music
- **Difficulty:** Advanced/Expert
- **Tags:** `tb-303`, `acid-bass`, `sequencer`, `subtractive-synthesis`, `resonant-filter`, `accent`, `portamento`, `slide`, `dance-music`, `techno`, `house`, `bandlimited`, `real-time-sequencing`
- **Source File:** `303emu.aiff`
- **Author:** Josep M Comajuncosas (1997)

---

## Description

This is a sophisticated emulation of the legendary Roland TB-303 bassline synthesizer, the instrument that defined acid house and techno music in the late 1980s. The TB-303's characteristic sound comes from its sawtooth oscillator feeding a resonant 4-pole filter with envelope modulation, combined with a step sequencer featuring accent and slide (portamento) controls. This Csound implementation recreates the complete 303 workflow: pattern sequencing, accents, slides, and the distinctive "squelchy" filter sweeps.

**Use Cases:**
- Acid house and techno basslines
- Electronic dance music production
- Learning classic synthesizer architecture
- Understanding sequencer-based composition
- Recreating vintage electronic music sounds
- Study of resonant filter behavior and envelope interaction

**Historical Significance:**
The TB-303 was originally designed (1981-1984) as a bass accompaniment for guitarists but was considered a commercial failure. When second-hand units flooded the market in the mid-80s, electronic producers discovered its unique sound, creating the "acid house" genre. Its squelchy, resonant filter sweeps became one of the most iconic sounds in electronic music history.

---

## Complete Code

```csound
<CsoundSynthesizer>
<CsOptions>
-o 303emu.aiff
</CsOptions>
<CsInstruments>
sr = 44100
kr = 44100
ksmps = 1

instr 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Roland TB-303 bassline emulator
; coded by Josep M Comajuncosas, Sept - Nov 1997
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; initial settings; control the overall character of the sound
imaxfreq      = 1000    ; max filter cutoff freq when ienvmod = 0
imaxsweep     = 10000   ; max filter freq at kenvmod & kaccent = 1
ireson        = 1       ; scale the resonance (>1 can make filter oscillate)

; init variables
itranspose   = p15      ; transpose in octaves (1 = raise 1 octave)
iseqfn       = p16      ; pitch sequence function table
iaccfn       = p17      ; accent sequence function table
idurfn       = p18      ; duration sequence function table
imaxamp      = p19      ; maximum amplitude
ibpm         = p14      ; beats per minute (tempo)
inotedur     = 15/ibpm  ; duration of one step
icount       init 0     ; sequence counter (for notes)
icount2      init 0     ; duration counter
ipcount2     init 0
idecaydur    = inotedur
imindecay    = (idecaydur<.2 ? .2 : idecaydur)  ; minimum decay = 0.2s
ipitch table 0,iseqfn   ; first note in sequence
ipitch = cpspch(itranspose + 6 + ipitch/100)
kaccurve     init 0

; twisting the knobs from the score
kfco       line p4, p3, p5      ; cutoff frequency (0-1)
kres       line p6, p3, p7      ; resonance (0-1)
kenvmod    line p8, p3, p9      ; envelope modulation (0-1)
kdecay     line p10, p3, p11    ; decay time (0-1)
kaccent    line p12, p3, p13    ; accent amount (0-1)

start:
; pitch & portamento from the sequence
ippitch = ipitch
ipitch table ftlen(iseqfn)*frac(icount/ftlen(iseqfn)),iseqfn
ipitch = cpspch(itranspose + 6 + ipitch/100)

if ipcount2 != icount2 goto noslide
kpitch linseg ippitch, .06, ipitch, inotedur-.06, ipitch
goto next

noslide:
kpitch = ipitch

next:
ipcount2 = icount2
timout 0,inotedur,contin
icount = icount + 1
reinit start
rireturn

contin:
; accent detector
iacc table ftlen(iaccfn)*frac((icount-1)/ftlen(iaccfn)), iaccfn
if iacc == 0 goto noaccent
ienvdecay = 0           ; accented notes are the shortest
iremacc = i(kaccurve)
kaccurve oscil1i 0, 1, .4, 3
kaccurve = kaccurve+iremacc  ; successive accents raise cutoff

goto sequencer

noaccent:
kaccurve = 0            ; no accent & "discharges" accent curve
ienvdecay = i(kdecay)

sequencer:
aremovedc init 0        ; set feedback to 0 at every event
imult table ftlen(idurfn)*frac(icount2/ftlen(idurfn)),idurfn
if imult != 0 goto noproblemo
icount2 = icount2 + 1
goto sequencer

noproblemo:
ieventdur = inotedur*imult

; two envelopes
kmeg expseg 1, imindecay+((ieventdur-imindecay)*ienvdecay), ienvdecay+.000001
kveg linen 1, .01, ieventdur, .016

; amplitude envelope
kamp = kveg*((1-i(kenvmod)) + kmeg*i(kenvmod)*(.5+.5*iacc*kaccent))

; filter envelope
ksweep = kveg * (imaxfreq + (.75*kmeg+.25*kaccurve*kaccent)*kenvmod*(imaxsweep-imaxfreq))
kfco = 20 + kfco * ksweep
kfco = (kfco > sr/2 ? sr/2 : kfco)

timout 0, ieventdur, out
icount2 = icount2 + 1
reinit contin

out:
; generate bandlimited sawtooth wave
abuzz buzz kamp, kpitch, sr/(4*kpitch), 1, 0
asaw integ abuzz, 0
asawdc atone asaw, 1

; resonant 4-pole LPF
kfcn = kfco/sr
kcorr = 1-4*kfcn
kres = kres/kcorr

ainpt = asawdc - aremovedc*kres*ireson
alpf tone ainpt, kfco
alpf tone alpf, kfco
alpf tone alpf, kfco
alpf tone alpf, kfco

aout balance alpf, asawdc

; final output
aremovedc atone aout, 10
    out imaxamp*aremovedc
endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1                  ; sine wave
f3 0 8193 8 0 512 1 1024 1 512 .5 2048 .2 4096 0  ; accent curve

; Pattern 1 - Complex acid line
f4  0 16 -2  12 24 12 14 15 12 0 12 12 24 12 14 15 6 13 16
f5  0 32 -2  0 1 0 0 0 0 0 0 0 1 0 1 1 1 0 0 0 1 0 0 1 0 1 1 1 1 0 0 0 0 0 1
f6  0 16 -2  2 1 1 2 1 1 1 2 1 1 3 1 4 0 0 0

; Pattern 2 - Simple bass line
f7  0 8  -2  10 0 12 0 7 10 12 7
f8  0 16 -2  1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
f9  0 2  -2  16 0

; Pattern 3 - Minimal bass
f10 0 8  -2  0 12 0 0 12 0 0 12
f11 0 8  -2  1 1 1 1 1 1 1 1
f12 0 8  -2  1 1 1 1 1 1 1 1

; Parameter automation examples
;      cutoff    resonance  envmod    decay     accent    bpm trans  seq  acc  dur  maxamp
;      st   end  st   end   st   end  st   end  st   end
i1  0  20  .1  .3   .2  .2   .1  .4   .05 .8   0   0    120   2     7    8    9    15000
i1  0  20  0   1    .5  1    .1  .4   1   1    1   1    120   0     4    5    6    5000
i1  20 40  .2  1    .5  1    .1  .1   .5  1    .5  1    120   2     7    8    9    15000
i1  40 20  .5  1    .95 1    1   .9   1   .1   .5  1    120   0     4    5    6    5000
i1  30 30  .5  1    .5  .5   .5  .5   .5  .5   0   0    120   0     10   11   12   10000
e
</CsScore>
</CsoundSynthesizer>
```

---

## Detailed Explanation

### Critical Performance Setting

```csound
sr = 44100
kr = 44100
ksmps = 1
```

**ksmps = 1 is ESSENTIAL** for this instrument to work correctly:
- The sequencer uses `timout`, `reinit`, and precise timing
- Filter feedback requires sample-accurate processing
- Real-time parameter updates need maximum resolution
- This is CPU-intensive but necessary for accuracy

### Global Parameters (Knob Settings)

These define the TB-303's characteristic controls, all normalized 0-1:

```csound
imaxfreq  = 1000    ; Base filter cutoff (when envmod = 0)
imaxsweep = 10000   ; Max filter sweep (when envmod & accent = 1)
ireson    = 1       ; Resonance scaling factor
```

**TB-303 character controls:**
- `imaxfreq`: Sets baseline filter brightness
- `imaxsweep`: Determines maximum "squelch" intensity
- `ireson`: Can be >1 for self-oscillation (screaming filter)

### Parameter Mapping from Score

```csound
itranspose = p15    ; Transpose in octaves
iseqfn     = p16    ; Pitch sequence table
iaccfn     = p17    ; Accent pattern table
idurfn     = p18    ; Note duration pattern table
imaxamp    = p19    ; Output amplitude
ibpm       = p14    ; Tempo (beats per minute)
```

**Flexible p-field assignments** allow complete control from score

### Tempo and Timing

```csound
inotedur = 15/ibpm
```

**Calculates step duration from BPM:**
- At 120 BPM: inotedur = 15/120 = 0.125 sec (16th notes)
- At 60 BPM: inotedur = 15/60 = 0.25 sec
- Formula chosen for standard 16-step sequencer timing

```csound
imindecay = (idecaydur<.2 ? .2 : idecaydur)
```

**Minimum decay prevents clicks:**
- Ensures at least 0.2s decay
- TB-303 characteristic: even short notes have some decay

### Knob Automation (Real-time Control)

```csound
kfco    line p4, p3, p5      ; Cutoff: start → end
kres    line p6, p3, p7      ; Resonance: start → end
kenvmod line p8, p3, p9      ; Envelope mod: start → end
kdecay  line p10, p3, p11    ; Decay: start → end
kaccent line p12, p3, p13    ; Accent: start → end
```

**Dynamic parameter sweeps** during performance:
- Recreates "tweaking knobs" during playback
- Classic acid house technique: filter sweeps during pattern
- All parameters interpolate linearly over note duration (p3)

### Sequencer Implementation (The Heart of the 303)

#### Pitch Sequencer with Portamento

```csound
start:
ippitch = ipitch
ipitch table ftlen(iseqfn)*frac(icount/ftlen(iseqfn)),iseqfn
ipitch = cpspch(itranspose + 6 + ipitch/100)
```

**Reads next pitch from sequence:**
- `ftlen(iseqfn)*frac(icount/ftlen(iseqfn))` wraps around table length
- Sequence loops automatically
- Pitch stored as: `6.00 + value/100` (6.12 = C#, etc.)
- `itranspose` adds octaves

#### Slide Detection (Portamento)

```csound
if ipcount2 != icount2 goto noslide
kpitch linseg ippitch, .06, ipitch, inotedur-.06, ipitch
goto next

noslide:
kpitch = ipitch
```

**TB-303's slide (portamento) behavior:**
- When consecutive notes are tied (same icount2 value)
- Creates 60ms pitch glide from previous to current note
- Otherwise, pitch jumps immediately
- **This recreates TB-303's "slide" switch per note**

**Implementation detail:**
The duration table (idurfn) controls ties:
- Duration = 1: single note
- Duration = 2: two tied notes (second gets slide)
- Duration = 3: three tied notes, etc.

#### Event Timing Control

```csound
timout 0, inotedur, contin
icount = icount + 1
reinit start
rireturn
```

**Precise step sequencing:**
- `timout`: Schedules next event after `inotedur`
- `reinit start`: Restarts instrument for next step
- `icount++`: Advances to next sequence position

### Accent System (Dynamic Articulation)

```csound
iacc table ftlen(iaccfn)*frac((icount-1)/ftlen(iaccfn)), iaccfn
if iacc == 0 goto noaccent
ienvdecay = 0
iremacc = i(kaccurve)
kaccurve oscil1i 0, 1, .4, 3
kaccurve = kaccurve+iremacc
goto sequencer
```

**Accent behavior (when iacc = 1):**
1. **Shortest decay** (`ienvdecay = 0`) - tight, punchy
2. **Accent curve** accumulates with `kaccurve`
3. **Successive accents** create hysteria (classic 303 behavior!)
4. `oscil1i` creates a rising curve (table 3) that persists

**Why this matters:**
Real TB-303 accents don't reset between notes - they build up, creating the characteristic "screaming" filter on rapid accents.

```csound
noaccent:
kaccurve = 0
ienvdecay = i(kdecay)
```

**No accent:**
- Normal decay time
- Accent curve resets to zero

### Duration Sequencer

```csound
imult table ftlen(idurfn)*frac(icount2/ftlen(idurfn)),idurfn
if imult != 0 goto noproblemo
icount2 = icount2 + 1
goto sequencer

noproblemo:
ieventdur = inotedur*imult
```

**Note duration control:**
- `imult` = duration multiplier from table
- 0 = skip (padding in table)
- 1 = single step
- 2 = two tied steps (slide/portamento)
- 3+ = longer tied notes

**This creates tied notes and enables slide!**

### Envelope Generators

#### Filter Envelope (MEG - Modulation Envelope Generator)

```csound
kmeg expseg 1, imindecay+((ieventdur-imindecay)*ienvdecay), ienvdecay+.000001
```

**Exponential decay:**
- Starts at 1
- Decays to near-zero over time
- Duration controlled by `kdecay` parameter and accents
- `.000001` prevents exact zero (expseg requirement)

**Behavior:**
- Accented notes: fastest decay (ienvdecay=0) → tight snap
- Normal notes: controlled by kdecay knob

#### Amplitude Envelope (VEG - Voltage Envelope Generator)

```csound
kveg linen 1, .01, ieventdur, .016
```

**Simple gate envelope:**
- 10ms attack (TB-303 has ~4ms, but prevents clicks)
- Sustain for event duration
- 16ms release
- Creates basic on/off envelope

### Amplitude Envelope Modulation

```csound
kamp = kveg*((1-i(kenvmod)) + kmeg*i(kenvmod)*(.5+.5*iacc*kaccent))
```

**Complex formula breakdown:**

When `kenvmod = 0` (no envelope modulation):
```
kamp = kveg * 1 = kveg
```
Simple gate envelope

When `kenvmod = 1` (full envelope modulation):
```
kamp = kveg * (kmeg * (.5 + .5*iacc*kaccent))
```

**With accent (iacc=1, kaccent=1):**
```
kamp = kveg * kmeg * 1  ; Full envelope depth
```

**Without accent (iacc=0):**
```
kamp = kveg * kmeg * 0.5  ; Half envelope depth
```

**Result:** Accents make notes louder AND have more filter sweep!

### Filter Envelope Modulation

```csound
ksweep = kveg * (imaxfreq + (.75*kmeg+.25*kaccurve*kaccent)*kenvmod*(imaxsweep-imaxfreq))
kfco = 20 + kfco * ksweep
kfco = (kfco > sr/2 ? sr/2 : kfco)
```

**Filter cutoff calculation:**

**Base frequency:**
```
kfco * imaxfreq  ; kfco from score (0-1)
```

**Envelope modulation added:**
```
+ (.75*kmeg + .25*kaccurve*kaccent) * kenvmod * (imaxsweep-imaxfreq)
```

**Components:**
- `kmeg`: 75% of modulation from decay envelope
- `kaccurve*kaccent`: 25% from accent accumulation
- `kenvmod`: Controls overall modulation amount (0-1)
- `(imaxsweep-imaxfreq)`: Range of frequency sweep

**Result:**
- At note start: high cutoff (bright, open filter)
- Over time: cutoff decays (filter closes)
- Accents: higher peak cutoff + accumulating hysteria
- Classic 303 "squelch" behavior!

**Safety limits:**
- Minimum: 20 Hz (always some bass)
- Maximum: sr/2 (Nyquist limit)

### Oscillator - Bandlimited Sawtooth

```csound
abuzz buzz kamp, kpitch, sr/(4*kpitch), 1, 0
asaw integ abuzz, 0
asawdc atone asaw, 1
```

**Why this approach?**

**1. buzz opcode:**
- Generates bandlimited pulse train
- `sr/(4*kpitch)`: Number of harmonics (up to sr/4, prevents aliasing)
- Table 1 (sine): Used for harmonic calculation
- Output: Bandlimited square/pulse wave

**2. integ (integration):**
- Converts pulse to sawtooth
- Integration of pulse = sawtooth
- Mathematical relationship: sawtooth is integral of pulse

**3. DC removal:**
- `atone`: High-pass filter at 1 Hz
- Removes DC offset from integration
- Prevents DC buildup in filter feedback

**Result:** Clean, bandlimited sawtooth oscillator (no aliasing!)

### 4-Pole Resonant Lowpass Filter

```csound
kfcn = kfco/sr
kcorr = 1-4*kfcn
kres = kres/kcorr

ainpt = asawdc - aremovedc*kres*ireson
alpf tone ainpt, kfco
alpf tone ainpt, kfco
alpf tone ainpt, kfco
alpf tone ainpt, kfco
```

**TB-303's legendary filter:**

**Four cascaded 1-pole filters** = 4-pole filter (24dB/octave slope)

**Feedback for resonance:**
```
ainpt = asawdc - aremovedc*kres*ireson
```
- Subtracts filtered output from input
- Creates resonant peak at cutoff frequency
- `kres`: Resonance amount (0-1)
- `ireson`: Global resonance scaling

**Frequency compensation:**
```
kcorr = 1-4*kfcn
kres = kres/kcorr
```
- Higher frequencies need more feedback for same resonance
- Empirical correction keeps resonance consistent
- Prevents filter from "going quiet" at high cutoffs

**Four tone opcodes cascaded:**
Each `tone` is a 1-pole lowpass (-6dB/octave)
- Four in series = -24dB/octave (4-pole characteristic)
- Matches TB-303's filter architecture

### Output Processing

```csound
aout balance alpf, asawdc
aremovedc atone aout, 10
out imaxamp*aremovedc
```

**balance opcode:**
- Matches filtered signal amplitude to dry signal
- Compensates for resonance peaks
- "Causes clicks" (comment) but maintains consistent level

**DC removal (again):**
- `atone` at 10 Hz
- Removes DC from feedback loop
- Critical for stable filter operation
- `aremovedc` feeds back to filter input (feedback loop!)

**Final output:**
- Scaled by `imaxamp` (p19)
- Allows different patterns at different levels

---

## Key Concepts

### TB-303 Architecture

**Classic analog synthesizer voice:**
1. **Oscillator** → Sawtooth wave (or square, not in this version)
2. **Filter** → Resonant 4-pole lowpass (24dB/oct)
3. **Envelopes** → Attack-Decay for filter & amplitude
4. **Sequencer** → 16-step pattern with accent & slide

**Signal flow:**
```
Sawtooth → 4-Pole Filter → VCA → Output
            ↑               ↑
        Filter Env      Amp Env
```

### The Accent System

**Real TB-303 behavior:**
- Accent switch per step in sequencer
- Accented notes are:
  - **Louder** (higher amplitude)
  - **Brighter** (higher filter cutoff)
  - **Shorter** (tighter decay)
- **Hysteria effect:** Successive accents don't reset - they accumulate!

**This emulation captures all these behaviors:**
```csound
kaccurve oscil1i 0, 1, .4, 3
kaccurve = kaccurve+iremacc  ; Accumulation!
```

### Slide (Portamento) Implementation

**TB-303 slide:**
- Not a global portamento
- Per-note slide switch in sequencer
- Only on tied notes

**Implementation:**
- Duration table determines tied notes
- Tied notes get 60ms pitch glide
- `linseg` creates smooth pitch transition

### Filter Behavior

**Classic 4-pole ladder filter** (Moog-style):
- Four 1-pole filters cascaded
- Feedback creates resonance peak
- High resonance → self-oscillation
- 24dB/octave rolloff (steep!)

**Envelope modulation:**
- Filter cutoff controlled by decay envelope
- Creates characteristic "wah" sweep
- Faster decay (accents) = snappier sound

---

## Parameter Exploration

### Cutoff Frequency (kfco: 0-1)

- **0-0.2** - Dark, muffled bass
  - Filter very closed
  - Emphasizes fundamental
  
- **0.3-0.5** - Classic acid bass range
  - Balanced brightness
  - Good for melodic lines
  
- **0.6-0.8** - Bright, aggressive
  - Opens filter significantly
  - More upper harmonics
  
- **0.9-1.0** - Very bright, thin
  - Almost no filtering
  - Squealing territory

### Resonance (kres: 0-1)

- **0-0.3** - Subtle resonance
  - Slight peak, natural sound
  
- **0.4-0.6** - Moderate (classic)
  - Clear resonant peak
  - Sweet spot for acid
  
- **0.7-0.9** - High resonance
  - Strong emphasis at cutoff
  - "Squelchy" character
  
- **0.95-1.0** - Self-oscillation
  - Filter screams/sings
  - Can overpower oscillator
  - Extreme acid territory

### Envelope Modulation (kenvmod: 0-1)

- **0-0.1** - Static filter
  - Little to no sweep
  - More traditional bass
  
- **0.2-0.4** - Subtle movement
  - Gentle filter animation
  - Organic feel
  
- **0.5-0.7** - Classic acid
  - Strong filter sweeps
  - Recognizable 303 sound
  
- **0.8-1.0** - Maximum sweep
  - Extreme filter modulation
  - Screaming, squelching
  - Classic "acid" sound

### Decay (kdecay: 0-1)

- **0-0.2** - Very short (tight)
  - Percussive, plucky
  - Good for fast patterns
  
- **0.3-0.5** - Medium decay
  - Balanced articulation
  - Musical phrasing
  
- **0.6-0.8** - Long decay
  - Sustained notes
  - Smoother lines
  
- **0.9-1.0** - Maximum sustain
  - Nearly full duration
  - Pad-like

### Accent (kaccent: 0-1)

- **0** - No accent effect
  - All notes equal
  
- **0.3-0.5** - Subtle accents
  - Gentle dynamics
  - Adds groove
  
- **0.6-0.8** - Strong accents
  - Clear emphasis
  - Punchy rhythm
  
- **0.9-1.0** - Maximum accent
  - Extreme dynamics
  - Hysteria can build

---

## Score Table Design

### Pitch Sequence Tables (f4, f7, f10)

```csound
f4 0 16 -2  12 24 12 14 15 12 0 12 12 24 12 14 15 6 13 16
```

**Format:** GEN02 (values stored as-is)
- Values are semitones above C (middle C = 0)
- Final pitch = `6.00 + value/100`
  - 12 = C# (6.12)
  - 0 = C (6.00)
  - 24 = C octave up (7.00)

**Wrap-around:** Sequence loops automatically via `frac(icount/ftlen)`

### Accent Pattern Tables (f5, f8, f11)

```csound
f5 0 32 -2  0 1 0 0 0 0 0 0 0 1 0 1 1 1 0 0...
```

**Binary pattern:**
- 0 = no accent
- 1 = accent

**Can be different length** from pitch sequence (polyrhythmic possibilities!)

### Duration Pattern Tables (f6, f9, f12)

```csound
f6 0 16 -2  2 1 1 2 1 1 1 2 1 1 3 1 4 0 0 0
```

**Multiplier values:**
- 0 = skip/padding
- 1 = single 16th note
- 2 = tied (creates slide + longer note)
- 3 = three tied steps
- 4+ = even longer notes

**Must be power of 2 length**, pad with zeros

### Accent Curve (f3)

```csound
f3 0 8193 8  0 512 1 1024 1 512 .5 2048 .2 4096 0
```

**GEN08 - Exponential segments:**
- Rising curve used by `oscil1i`
- Creates the "hysteria" build-up
- Shape affects how accents accumulate

---

## Variations

### Square Wave Oscillator

```csound
; Replace sawtooth with square wave
abuzz buzz kamp, kpitch, sr/(4*kpitch), 1, 0.5  ; 0.5 = square wave duty
; Skip integration step - use buzz directly
asawdc atone abuzz, 1
```

### Self-Oscillating Filter (Screaming 303)

```csound
; Increase resonance scaling
ireson = 2.0  ; or higher
; Or boost resonance in score
kres line 0.9, p3, 1.0  ; Sweep into self-oscillation
```

### Multiple Patterns Layered

```csound
; Score: Layer multiple instances with different patterns
i1 0 60  .3 .5  .5 .8  .5 .5  .5 .5  0 0  120  0  4  5  6  10000
i1 0 60  .5 .7  .7 .9  .6 .8  .3 .3  1 1  120  1  7  8  9  8000
; Different patterns, different transpositions, different knob positions
```

### Filter Modulation from LFO

```csound
; Add slow LFO to filter cutoff
klfo lfo 0.2, 0.5, 0  ; 0.5 Hz LFO, ±0.2 depth
kfco_mod = kfco + klfo
ksweep = kveg * (imaxfreq + ...) * kfco_mod
```

### Randomized Accents

```csound
; Generate random accent pattern
krnd random 0, 1
iacc = (krnd > 0.7 ? 1 : 0)  ; 30% chance of accent
```

### Tempo Changes

```csound
; Accelerando
ibpm line 100, p3, 140
inotedur = 15/ibpm  ; Note duration changes with tempo
```

---

## Common Issues & Solutions

### Clicks and Pops
**Problem:** Audible clicks at note transitions  
**Cause:** `balance` opcode or insufficient attack/release  
**Solution:**
```csound
; Increase attack time
kveg linen 1, .02, ieventdur, .03  ; Longer attack/release
; Or remove balance (accept volume variation)
; aout = alpf  ; Direct output, no balance
```

### Filter Doesn't Sweep
**Problem:** Static filter, no characteristic 303 sound  
**Cause:** `kenvmod` too low or `imaxsweep` too low  
**Solution:**
```csound
kenvmod line 0.7, p3, 0.9  ; Higher envelope modulation
imaxsweep = 15000  ; Increase maximum sweep range
```

### Resonance Too Weak/Strong
**Problem:** Filter doesn't "scream" or screams too much  
**Cause:** `ireson` scaling or `kres` values  
**Solution:**
```csound
ireson = 1.5  ; Increase global resonance
; Or adjust in score:
kres line 0.7, p3, 0.95  ; Sweep resonance
```

### Pattern Doesn't Loop Correctly
**Problem:** Sequence glitches or stops  
**Cause:** Table size not matching expected length  
**Solution:**
```csound
; Ensure table sizes match usage
; Pitch table: actual pattern length
f4 0 16 -2 ...  ; 16 steps
; Pad duration table to power of 2
f6 0 16 -2 ... 0 0 0  ; Pad with zeros
```

### No Slide/Portamento
**Problem:** Notes don't slide  
**Cause:** Duration table not creating tied notes  
**Solution:**
```csound
; Use values >1 for tied notes
f6 0 8 -2  2 1 2 1 2 1 2 1  ; 2s create slides
```

### Distortion at High Resonance
**Problem:** Output distorts/clips  
**Cause:** Resonance peak boosts amplitude  
**Solution:**
```csound
; Reduce output level
imaxamp = 8000  ; Lower than 15000
; Or add soft clipping
aout tanh aout*2  ; Soft saturation
```

---

## Sound Design Applications

### Classic Acid House Bassline

```csound
; High resonance, strong env mod, moderate cutoff
kfco line 0.3, p3, 0.5
kres line 0.75, p3, 0.85
kenvmod line 0.7, p3, 0.9
kaccent = 0.8
; Use pattern with lots of accents
```

### Deep Minimal Techno

```csound
; Low cutoff, minimal modulation, long decay
kfco = 0.2
kres = 0.4
kenvmod = 0.2
kdecay = 0.8
kaccent = 0.3
; Sparse accent pattern
```

### Screaming Lead

```csound
; Very high resonance, maximum modulation
kfco line 0.6, p3, 0.9
kres line 0.9, p3, 0.98
kenvmod = 1.0
kdecay = 0.2  ; Short, punchy
ireson = 2.0  ; Self-oscillation
```

### Liquid Funk Bassline

```csound
; Smooth, warm, moderate resonance
kfco line 0.4, p3, 0.6
kres = 0.5
kenvmod line 0.4, p3, 0.6
kdecay = 0.6
; Lots of slides in pattern
```

---

## Advanced Topics

### The Hysteria Effect

**Accent accumulation** is a key TB-303 characteristic:

```csound
kaccurve oscil1i 0, 1, .4, 3
kaccurve = kaccurve+iremacc
```

**How it works:**
1. Each accent triggers `oscil1i` (one-shot envelope)
2. Previous `kaccurve` value saved in `iremacc`
3. New envelope added to previous value
4. Filter cutoff boosted by `kaccurve`

**Result:**
Rapid accents cause filter to "scream" higher and higher - classic acid sound!

### Bandlimited Oscillator Theory

**Why buzz + integ?**

**Naive sawtooth:**
```csound
asaw phasor kpitch  ; Simple sawtooth
```
Problem: Aliasing! Harmonics fold back above Nyquist.

**Bandlimited approach:**
```csound
abuzz buzz kamp, kpitch, sr/(4*kpitch), 1
asaw integ abuzz
```

**buzz generates:**
- Limited number of harmonics (`sr/(4*kpitch)`)
- No harmonics above sr/4 (well below Nyquist)
- Clean, alias-free

**Integration:**
- Pulse (from buzz) → Sawtooth (via integ)
- Mathematical relationship (calculus)

### 4-Pole Filter Mathematics

**Transfer function:**
Each 1-pole filter has rolloff: H(f) = 1/(1 + jf/fc)

**Four cascaded:**
H_total(f) = H(f)^4 = 1/(1 + jf/fc)^4

**Slope:** 24 dB/octave (-24 dB/oct)

**With feedback (resonance):**
Creates peak at cutoff frequency, Q factor determined by feedback amount.

---

## Historical Context

**Roland TB-303 (1982-1984):**
- Designed by Tadao Kikumoto
- Intended as bass accompaniment for guitarists
- Commercial failure (sold ~10,000 units)
- Discontinued after 18 months

**Rebirth (mid-1980s):**
- Chicago house producers bought cheap second-hand units
- Discovered unique sound with high resonance + filter sweeps
- **Acid house born:** Phuture "Acid Tracks" (1987)
- Became THE sound of acid house, techno, trance

**Why it became legendary:**
1. **Unique sound:** No other synth sounded like it
2. **Sequencer workflow:** Pattern-based composition
3. **Happy accidents:** "Wrong" settings created new genre
4. **Scarcity:** Discontinued, became cult item

**Modern impact:**
- Recreated in countless hardware and software clones
- Roland released TR-8S, TB-03 (official recreations)
- Defines entire subgenres (acid house, acid techno)
- One of most influential instruments in electronic music

---

## Extended Documentation

**Official Csound Opcode References:**
- [buzz](https://csound.com/docs/manual/buzz.html)
- [tone](https://csound.com/docs/manual/tone.html)
- [integ](https://csound.com/docs/manual/integ.html)
- [balance](https://csound.com/docs/manual/balance.html)
- [timout](https://csound.com/docs/manual/timout.html)
- [oscil1i](https://csound.com/docs/manual/oscil1i.html)

**TB-303 References:**
- Roland TB-303 Service Manual (schematics)
- "The Bass Station: A Story of the Roland TB-303" - FACT Magazine
- Robin Whittle: TB-303 Analysis and Schematics

**Sequencer Programming:**
- TB-303 Original Manual (pattern programming)
- "Acid: The Secret Society of the 303" - book on acid house culture

**Learning Resources:**
- Sound On Sound: "Synth Secrets" - TB-303 Recreation series
- "Energy Flash" by Simon Reynolds (acid house history)
- YouTube: Countless TB-303 programming tutorials

**This emulation demonstrates:**
Advanced sequencing, envelope interaction, resonant filter design, and accent articulation - all core concepts in electronic music synthesis.
