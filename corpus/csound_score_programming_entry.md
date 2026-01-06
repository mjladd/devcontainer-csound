Title: Score Programming Techniques
Category: Composition/Sequencing
Difficulty: Beginner to Intermediate
Tags: score, sequencing, p-fields, carry, tempo, sections, macros, algorithmic, composition, scheduling, GEN, tables

Description:
The Csound score is a powerful system for scheduling instrument events. Beyond simple note lists, the score supports shorthand notation, tempo changes, sections, macros, ramping values, and more. Understanding score programming enables efficient composition, algorithmic generation, and complex musical structures. Scores can also be generated externally using Python, scripting, or score generators.

---

## Example 1: Basic Score Syntax and P-field Carry

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

instr 1
    iamp = p4
    ifreq = cpspch(p5)
    ipan = p6

    ; Simple tone with envelope
    kenv linseg 0, 0.02, 1, p3-0.07, 0.8, 0.05, 0
    asrc vco2 iamp, ifreq, 0

    aleft = asrc * kenv * sqrt(1-ipan)
    aright = asrc * kenv * sqrt(ipan)

    outs aleft, aright
endin

</CsInstruments>
<CsScore>
; Basic instrument statement:
; i<instr> <start> <dur> <p4> <p5> <p6> ...

; Standard notation
i1 0     0.5   0.4   8.00   0.5
i1 0.5   0.5   0.4   8.04   0.5
i1 1.0   0.5   0.4   8.07   0.5
i1 1.5   1.0   0.4   9.00   0.5

; P-field carry: "." repeats previous value in that column
i1 3     0.5   0.4   8.00   0.3
i1 3.5   .     .     8.04   .       ; dur=0.5, amp=0.4, pan=0.3
i1 4.0   .     .     8.07   .
i1 4.5   1.0   .     9.00   .

; "+" for start time means: previous start + previous duration
i1 6     0.25  0.4   8.00   0.7
i1 +     .     .     8.02   .       ; starts at 6.25
i1 +     .     .     8.04   .       ; starts at 6.5
i1 +     .     .     8.05   .       ; starts at 6.75
i1 +     .     .     8.07   .       ; starts at 7.0
i1 +     .     .     8.09   .
i1 +     .     .     8.11   .
i1 +     1.0   .     9.00   .       ; starts at 7.5

e
</CsScore>
</CsoundSynthesizer>
```

**Explanation:**
- `.` (dot) carries the previous value in that p-field column
- `+` calculates start time as previous start + previous duration
- Carry significantly reduces score typing for repeated patterns
- All p-fields after p3 can be carried independently

---

## Example 2: Tempo and Score Sections

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

instr 1
    iamp = p4
    ifreq = cpspch(p5)

    kenv linseg 0, 0.01, 1, p3-0.06, 0.8, 0.05, 0
    asrc vco2 iamp, ifreq, 2, 0.5

    outs asrc*kenv, asrc*kenv
endin

; Percussion
instr 2
    iamp = p4

    kenv expon 1, p3, 0.001
    anoise rand iamp
    afilt butterlp anoise, 200

    outs afilt*kenv, afilt*kenv
endin

</CsInstruments>
<CsScore>
; TEMPO STATEMENT
; t <beat> <tempo> [<beat> <tempo> ...]
; Tempo in BPM, score times are in beats not seconds

t 0 120    ; 120 BPM throughout

; Section 1: Quarter note = 0.5 beats at 120 BPM
i1 0   0.5  0.4  8.00
i1 +   .    .    8.04
i1 +   .    .    8.07
i1 +   1    .    9.00

i2 0   0.25 0.5
i2 1   .    .
i2 2   .    .
i2 3   .    .

; Force wait before next section
f0 4

; NEW SECTION - time resets to 0
s

; Tempo change: accelerando from 120 to 180 BPM
t 0 120  4 180

i1 0   0.5  0.4  8.00
i1 +   .    .    8.04
i1 +   .    .    8.07
i1 +   .    .    9.00
i1 +   .    .    9.04
i1 +   .    .    9.07
i1 +   .    .    10.00
i1 +   1    .    10.04

i2 0   0.25 0.5
i2 1   .    .
i2 2   .    .
i2 3   .    .
i2 4   .    .
i2 5   .    .
i2 6   .    .
i2 7   .    .

f0 8

; Another section - back to slow tempo
s
t 0 80

i1 0   2    0.4  7.00
i1 +   2    .    7.07
i1 +   4    .    8.00

e
</CsScore>
</CsoundSynthesizer>
```

**Explanation:**
- `t` statement sets tempo in BPM; multiple points create tempo ramps
- `s` starts a new section; time resets to 0
- `f0 <time>` forces score to wait (silent padding)
- Score times become beats, converted to seconds via tempo

---

## Example 3: Score Macros and Expressions

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

instr 1
    iamp = p4
    ifreq = cpspch(p5)
    ipan = p6
    ifco = p7

    kenv linseg 0, 0.02, 1, p3-0.07, 0.8, 0.05, 0
    asrc vco2 iamp, ifreq, 0
    afilt moogladder asrc, ifco, 0.3

    outs afilt*kenv*sqrt(1-ipan), afilt*kenv*sqrt(ipan)
endin

</CsInstruments>
<CsScore>
; MACROS - define once, use many times
#define AMP #0.4#
#define DUR #0.5#
#define PANL #0.2#
#define PANR #0.8#
#define PANC #0.5#

; Chord macro
#define CMAJ(time'oct'pan)
    #i1 $time   $DUR  $AMP  $oct.00  $pan  2000
    i1 $time    $DUR  $AMP  $oct.04  $pan  2000
    i1 $time    $DUR  $AMP  $oct.07  $pan  2000#

#define CMIN(time'oct'pan)
    #i1 $time   $DUR  $AMP  $oct.00  $pan  2000
    i1 $time    $DUR  $AMP  $oct.03  $pan  2000
    i1 $time    $DUR  $AMP  $oct.07  $pan  2000#

; Use macros
$CMAJ(0'8'$PANL)
$CMIN(1'8'$PANR)
$CMAJ(2'8'$PANC)
$CMAJ(3'7'$PANC)

; EXPRESSIONS in p-fields (requires [ ])
i1 5    0.5   [0.3+0.1]      8.00   0.5   [1000*2]
i1 5.5  0.5   [0.5*0.8]      8.04   0.5   [500+1500]

; Random values with $MACRO
#define RPAN #[0.3 + rnd(0.4)]#

i1 7    0.5   0.4   8.00   $RPAN   2000
i1 7.5  0.5   0.4   8.04   $RPAN   2000
i1 8    0.5   0.4   8.07   $RPAN   2000
i1 8.5  1     0.4   9.00   $RPAN   2000

e
</CsScore>
</CsoundSynthesizer>
```

**Explanation:**
- `#define NAME #value#` creates a macro
- `$NAME` expands the macro
- Macros with arguments use `'` as separator
- `[expression]` evaluates mathematical expressions
- `rnd(x)` generates random values 0 to x in expressions

---

## Example 4: Ramping P-fields and Algorithmic Patterns

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

instr 1
    iamp = p4
    ifreq = cpspch(p5)
    ipan = p6

    kenv linseg 0, 0.01, 1, p3-0.06, 0.8, 0.05, 0
    asrc vco2 iamp, ifreq, 0

    outs asrc*kenv*sqrt(1-ipan), asrc*kenv*sqrt(ipan)
endin

</CsInstruments>
<CsScore>
; RAMPING with < and >
; "<" ramps from previous value to next explicit value
; ">" ramps down

; Frequency ramp up
i1 0    0.25  0.4  7.00   0.5
i1 +    .     .    <      .
i1 +    .     .    <      .
i1 +    .     .    <      .
i1 +    .     .    8.00   .     ; Ramps 7.00 -> 8.00 over 4 notes

; Amplitude ramp
i1 2    0.25  0.1  8.00   0.5
i1 +    .     <    .      .
i1 +    .     <    .      .
i1 +    .     <    .      .
i1 +    .     0.6  .      .     ; Crescendo

; Pan sweep
i1 4    0.25  0.4  8.00   0.0
i1 +    .     .    8.02   <
i1 +    .     .    8.04   <
i1 +    .     .    8.05   <
i1 +    .     .    8.07   <
i1 +    .     .    8.09   <
i1 +    .     .    8.11   <
i1 +    0.5   .    9.00   1.0   ; Pan left to right

; Decrescendo (ramp down)
i1 6    0.25  0.5  8.00   0.5
i1 +    .     >    .      .
i1 +    .     >    .      .
i1 +    .     >    .      .
i1 +    .     0.1  .      .     ; Fade out

; NESTED LOOPS using score preprocessing
; (Note: actual loops require score generator or Python)

; Repeating pattern manually expanded
#define PATTERN(start'pitch)
    #i1 $start       0.125  0.4  $pitch.00  0.3
    i1 [$start+0.125] 0.125  0.3  $pitch.07  0.5
    i1 [$start+0.25]  0.125  0.4  $pitch.04  0.7
    i1 [$start+0.375] 0.125  0.3  $pitch.07  0.5#

$PATTERN(8'8)
$PATTERN(8.5'8)
$PATTERN(9'9)
$PATTERN(9.5'8)

e
</CsScore>
</CsoundSynthesizer>
```

**Explanation:**
- `<` ramps linearly from last explicit value to next explicit value
- `>` is typically used for downward ramps
- Ramps span all notes between explicit values
- Macros with expressions enable pattern-based composition

---

## Example 5: Table-Based Score Data

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

; Read pitch sequence from table
instr 1
    iamp = p4
    ipitchtab = p5
    iindex = p6

    ; Read pitch from table
    ipch table iindex, ipitchtab

    ; Convert to frequency
    ifreq = cpspch(ipch)

    ; Envelope
    kenv linseg 0, 0.02, 1, p3-0.07, 0.7, 0.05, 0

    ; Sound
    asrc vco2 iamp, ifreq, 0
    afilt moogladder asrc, ifreq*4, 0.3

    outs afilt*kenv, afilt*kenv
endin

; Algorithmic instrument - plays through table
instr 2
    iamp = p4
    ipitchtab = p5
    itempo = p6         ; Notes per second
    itablen = ftlen(ipitchtab)

    ; Trigger new notes
reinit_loop:
    iindex init 0

    ; Get pitch from table
    ipch table iindex, ipitchtab
    ifreq = cpspch(ipch)

    ; Play the note
    kenv linseg 0, 0.01, 1, (1/itempo)-0.05, 0.7, 0.04, 0

    asrc vco2 iamp, ifreq, 0
    afilt butterlp asrc, ifreq*6

    outs afilt*kenv, afilt*kenv

    ; Advance to next note
    timout 0, 1/itempo, continue
    iindex = (iindex + 1) % itablen
    reinit reinit_loop

continue:
endin

</CsInstruments>
<CsScore>
; Pitch sequence tables using GEN 2 (arbitrary values)
; Table 10: C major scale
f10 0 8 -2  8.00 8.02 8.04 8.05 8.07 8.09 8.11 9.00

; Table 11: Melody pattern
f11 0 16 -2  8.00 8.04 8.07 9.00 8.07 8.04 8.00 7.07 \
             8.02 8.05 8.09 9.02 8.09 8.05 8.02 7.09

; Table 12: Bass pattern
f12 0 4 -2   6.00 6.07 6.05 6.07

; Play notes from table manually
;       dur  amp  tab  index
i1 0    0.5  0.4  10   0
i1 +    .    .    .    1
i1 +    .    .    .    2
i1 +    .    .    .    3
i1 +    .    .    .    4
i1 +    .    .    .    5
i1 +    .    .    .    6
i1 +    1    .    .    7

; Automatic playback through melody table
;       dur  amp  tab  tempo
i2 5    8    0.3  11   4     ; 4 notes per second

; Bass pattern
i2 5    8    0.3  12   2     ; 2 notes per second

e
</CsScore>
</CsoundSynthesizer>
```

**Explanation:**
- GEN 2 (`-2` for unnormalized) stores arbitrary values like pitches
- `table` opcode reads values at i-rate
- `ftlen()` returns table length for looping
- `reinit`/`timout` pattern creates note sequencers

---

## Example 6: Conditional Logic and Markov Chains

Based on markov.csd

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

; Initialize global reverb
ga1 init 0

instr 1
    ipitch_table = p5
    ioctave = p6
    itempo = p7
    ichoice = p8

    ; Markov-style: choice determines which pitch set
    if ichoice == 0 igoto set_a
    if ichoice == 1 igoto set_b
    igoto set_a

set_a:
    ipitchtab = 2   ; Pitch set A
    igoto continue

set_b:
    ipitchtab = 3   ; Pitch set B
    igoto continue

continue:
    ; Retriggering envelope
retrig:
    ; Random index into pitch table
    irand random 0, 8
    iindex = int(irand)

    ; Get pitch
    ipch table iindex, ipitchtab
    ipch = ipch + ioctave

    ; Note envelope
    kenv linen 1, 0.02, 1/itempo, 0.05

    ; Sound
    asrc oscil p4*kenv, cpspch(ipch), -1

    ; Output and send to reverb
    outs asrc, asrc
    ga1 = ga1 + asrc * 0.3

    ; Retrigger
    timout 0, 1/itempo, done
    reinit retrig

done:
endin

; Reverb instrument
instr 99
    arev reverb ga1, 1.5
    outs arev*0.5, arev*0.5
    ga1 = 0
endin

</CsInstruments>
<CsScore>
; Pitch tables (relative pitches, octave added in instrument)
; Set A: Major pentatonic
f2 0 8 -2  0.00 0.02 0.04 0.07 0.09 1.00 1.02 1.04

; Set B: Minor pentatonic
f3 0 8 -2  0.00 0.03 0.05 0.07 0.10 1.00 1.03 1.05

; Global reverb
i99 0 20

; Markov-style composition
; Different "choices" select different pitch sets
;       dur  amp  tab  oct  tempo choice
i1 0    4    0.3  2    8    4     0       ; Set A
i1 4    4    0.3  2    7    3     1       ; Set B
i1 8    4    0.3  2    8    5     0       ; Set A
i1 12   4    0.3  2    9    6     1       ; Set B

; Layered with different octaves
i1 0    4    0.2  2    7    2     1
i1 8    4    0.2  2    6    1.5   0

e
</CsScore>
</CsoundSynthesizer>
```

**Explanation:**
- `igoto` provides conditional branching in instruments
- `random` generates values for algorithmic choices
- `reinit`/`timout` creates rhythmic patterns
- Table selection implements simple Markov-chain composition

---

## Variations

1. **Score generators**: Use Python, Cmask, or nGen to generate complex scores
2. **Live coding**: CsoundQt and Cabbage support real-time score modification
3. **MIDI file import**: Convert MIDI to Csound score with external tools
4. **Score includes**: `#include "melody.sco"` for modular composition
5. **Named instruments**: Use string names instead of numbers
6. **Score preprocessing**: csbeats, cmask, and other preprocessors

---

## Common Issues

| Problem | Solution |
|---------|----------|
| Timing errors with tempo | Remember times are beats, not seconds when using `t` |
| Carry not working | Ensure previous event has the value; `.` doesn't work on first event |
| Section timing confusion | `s` resets time to 0; use `f0` for padding between sections |
| Macro syntax errors | Check `#` placement and argument separators (`'`) |
| Expression evaluation fails | Ensure expressions are in `[]` brackets |
| Table index out of range | Use modulo `%` to wrap index to table length |

---

## Related Examples

- csound_midi_integration_entry.md - Real-time note input
- csound_granular_synthesis_entry.md - Algorithmic grain scheduling
- csound_sample_playback_entry.md - Triggering samples from score
- csound_fm_synthesis_entry.md - Score examples for FM patches
