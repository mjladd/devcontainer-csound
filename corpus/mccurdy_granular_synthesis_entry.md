# McCurdy Granular Synthesis Examples

## Metadata
- **Title:** Granular Synthesis Examples (McCurdy)
- **Category:** Granular Synthesis
- **Difficulty:** Intermediate to Advanced
- **Tags:** granular, grains, time-stretching, pitch-shifting, formants, fof, fog, wavelets, syncgrain, sndwarp, grain3, granule, real-time, FLTK
- **Source:** Iain McCurdy Csound Realtime Examples
- **License:** CC BY-NC-SA 4.0

---

## Overview

Granular synthesis is a sound synthesis technique that operates on the microsound time scale. It is based on the same principle as sampling, but the samples are split into small pieces of around 1 to 100 ms in duration called "grains." These grains can be played back at different speeds, phases, volumes, and frequencies, and can be layered on top of each other to create complex textures.

This collection from Iain McCurdy demonstrates various granular synthesis opcodes and techniques in Csound, ranging from basic grain generation to complex vocal formant synthesis. The examples include both file-based and live audio granulation, as well as specialized techniques like FOF (Fonction d'Onde Formantique) synthesis for vocal imitation.

---

## Examples

### syncgrain
**File:** `syncgrain.csd`
**Description:** Syncgrain offers granular synthesis upon a stored sound file in a GEN 1 function table. Its strength lies in k-rate control for main input arguments, encouraging real-time manipulation. A distinctive feature is the interaction between density (kfreq), grain size (kgrsize), and progress rate (kprate). Higher density increases progress rate through the sound file. The progress rate defines grain start location as a fraction of the previous grain's trajectory.
**Key Opcodes:** `syncgrain`
**Parameters:**
- kamp: Amplitude of output
- kfreq: Density (grains per second) - higher values increase progress rate
- kpitch: Pitch ratio (1 = unison, 2 = octave up)
- kgrsize: Grain size in seconds
- kprate: Progress rate - 1 means grain starts where previous ended, 0.5 starts at halfway point
- isfn: Source sound function table
- iwfn: Grain envelope window function table
- iolaps: Maximum number of overlapping grains

---

### syncloop
**File:** `syncloop.csd`
**Description:** Syncloop is a variation of syncgrain that adds start and end loop points which are k-rate and therefore editable in real-time. This allows for freezing specific sections of the sound file while maintaining granular processing.
**Key Opcodes:** `syncloop`
**Parameters:**
- kamp: Amplitude
- kfreq: Grain density (grains per second)
- kpitch: Pitch ratio
- kgrsize: Grain size
- kprate: Progress rate through file
- kloopstart: Loop start point (in seconds)
- kloopend: Loop end point (in seconds)
- isfn: Source sound function table
- iwfn: Window function table
- iolaps: Maximum overlaps

---

### diskgrain
**File:** `diskgrain.csd`
**Description:** Diskgrain creates granular synthesis based on a sound file input, similar to syncgrain, but reads from a sound file on disk in real time rather than loading the entire file into memory. Better suited for very long input sound files. Supports both mono and stereo input files.
**Key Opcodes:** `diskgrain`
**Parameters:**
- Sfilename: Sound file path (string)
- kamp: Amplitude
- kfreq: Grain density
- kpitch: Pitch ratio
- kgrsize: Grain size
- kprate: Progress rate
- iwfn: Window function table
- iolaps: Maximum overlaps

---

### sndwarp
**File:** `sndwarp.csd`
**Description:** Sndwarp performs granular synthesis on a stored function table using either time-stretch mode (iratio) or pointer mode (time pointer). In stretch mode, a factor controls playback speed relative to original. In pointer mode, a variable defines where grains begin within the source file. Grain size is defined in samples via "window size."
**Key Opcodes:** `sndwarp`
**Parameters:**
- kamp: Amplitude
- kwarp: Time stretch factor (mode 0) or pointer position in seconds (mode 1)
- kpch: Pitch resample ratio (1 = no transposition)
- isfn: Source sound function table
- ibeg: Inskip into source (in seconds)
- iwsize: Window/grain size in samples
- irnd: Window size randomization bandwidth in samples
- ioverlap: Number of overlapping grains
- iwfn: Windowing function
- itimemode: 0 = stretch factor mode, 1 = pointer mode

---

### LiveSndwarp
**File:** `LiveSndwarp.csd`
**Description:** Implements live granulation of audio input using sndwarp in pointer mode. Live audio is written to a function table while sndwarp reads from behind the write pointer. Features grain delay with betarand distribution, feedback with optional clipping, balance control, and freeze mode for manual navigation through buffered audio.
**Key Opcodes:** `sndwarp`, `tablew`
**Parameters:**
- gkInGain: Input gain
- gkamp: Output gain
- gkwsize: Window/grain size in samples
- gkrnd: Window size randomization
- gkpch: Pitch ratio
- gkdly: Delay range for grain read pointer
- gkbeta: Delay distribution shape (1=uniform, 2=linear, >2=exponential)
- gkfback: Feedback amount
- gkfreeze: Freeze write pointer for manual navigation

---

### grain
**File:** `grain.csd`
**Description:** The grain opcode creates granular synthesis clouds. It does not offer precise pointer control like other opcodes - the grain pointer is either static or random across the input table. Works well with single-cycle waveforms and offers amplitude randomness offset not available in grain2 or grain3.
**Key Opcodes:** `grain`
**Parameters:**
- kamp: Amplitude
- kpitch: Pitch in Hz (for waveforms) or ratio (for sound files)
- kdens: Density (grains per second)
- kampoff: Amplitude random offset
- kfmd: Pitch randomization factor
- kgdur: Grain duration
- igfn: Grain waveform function table
- iwfn: Window/envelope function table
- imgdur: Maximum grain duration
- igrnd: 0 = static pointer, non-zero = random pointer

---

### grain2
**File:** `grain2.csd`
**Description:** Grain2 is a simpler version of grain3. It provides no user control of grain phase (pointer position) - initial phase is chosen randomly across the source function table. Density is defined as number of overlaps (i-rate), so changing it forces reinitialization.
**Key Opcodes:** `grain2`
**Parameters:**
- kpitch: Pitch (format depends on source - Hz for waveforms, ratio for samples)
- kfmd: Random pitch variation
- kdur: Grain duration in ms
- iovrlp: Number of overlaps (i-rate)
- ifn: Source function table
- iwfn: Window function table
- ifrpow: Distribution of random pitch variation
- iseed: Seed for random number generator
- imode: Mode flags for interpolation and frequency modulation

---

### grain3
**File:** `grain3.csd`
**Description:** Grain3 performs granular synthesis on a stored function table with extensive control. Can use single-cycle waveforms or stored samples. Offers user control of grain phase (pointer position), pitch randomization distributions, and various mode options for grain generation behavior.
**Key Opcodes:** `grain3`
**Parameters:**
- kpitch: Pitch (mathematically scaled for sample files)
- kphs: Grain phase/pointer position (0-1)
- kfmd: Pitch random offset
- kpmd: Phase random offset
- kdur: Grain duration in ms
- kdens: Density (grains per second)
- imaxovr: Maximum overlaps
- ifn: Source function table
- iwfn: Window function table
- kfrpow: Distribution of random frequency variation
- kprpow: Distribution of random phase variation
- iseed: Random seed value
- imode: Mode flags (sync phase, integer location, interpolation, etc.)

---

### MorphingPresets
**File:** `MorphingPresets.csd`
**Description:** Based on grain3, this example introduces 2D morphing between 4 presets using an FLjoy XY panel. Moving the crosshairs creates interpolation between corner presets. Presets can be saved/loaded to/from text files. Demonstrates preset management with ftsave/ftload.
**Key Opcodes:** `grain3`, `ftsave`, `ftload`, `FLjoy`, `ntrpol`
**Parameters:**
- All grain3 parameters plus:
- gkx, gky: XY position for morphing (0-1 each axis)
- Preset storage via function tables and text files

---

### granule
**File:** `granule.csd`
**Description:** Granule is a complex granular synthesis opcode good at producing dense textures. Uses playback ratio instead of pointer for file navigation. Creates layered grain streams with up to 128 independent voices. Supports up to 4 simultaneous transpositions per grain stream.
**Key Opcodes:** `granule`
**Parameters:**
- kamp: Amplitude
- ivoices: Number of grain stream voices (1-128)
- iratio: Playback ratio (1 = normal speed, 0.5 = half speed)
- iptrmode: Pointer direction (-1 = backward, 0 = random, 1 = forward)
- kgap: Time gap between grains in ms
- igap_os: Gap random offset percentage
- kgsize: Grain size in ms
- igsize_os: Size random offset percentage
- iatt: Attack time as percentage of grain duration
- idec: Decay time as percentage of grain duration
- ipshift: Number of transpositions (0-4, 0 = random octave)
- ipitch1-4: Transposition ratios for each voice
- iseed: Random seed value
- igskip: Inskip into source file

---

### fog
**File:** `fog.csd`
**Description:** Fog performs granular synthesis on stored sound material using a method similar to the fof opcode. The grain envelope combines duration, rise time, decay time, and bandwidth (exponential decay control). Supports both grain-by-grain and continuous transposition modes.
**Key Opcodes:** `fog`
**Parameters:**
- kamp: Amplitude
- kdens: Density (grains per second)
- ktrans: Transposition factor (1 = unison, negative = backwards)
- aspd: Pointer position (0-1, a-rate for smooth movement)
- koct: Octaviation index (0 = normal, 1+ = every other grain attenuated)
- kband: Bandwidth for exponential grain decay
- kris: Rise time
- kdur: Grain duration
- kdec: Decay time
- iolaps: Maximum overlaps
- ifna: Source sound function table
- ifnb: Rise/decay shape function table
- itotdur: Total duration
- itmode: Transposition mode (0 = per-grain, 1 = continuous)

---

### fof
**File:** `fof.csd`
**Description:** FOF (Fonction d'Onde Formantique) is specialized granular synthesis for creating vocal vowel sounds through rapidly repeated sine wave grains. The fundamental controls grain repetition rate, while the formant controls pitch within each grain. Used to create formant peaks typical of vocal sounds.
**Key Opcodes:** `fof`
**Parameters:**
- kamp: Amplitude
- kfund: Fundamental frequency (grain repetition rate in Hz)
- kform: Formant frequency (pitch within grains)
- koct: Octaviation factor (0 = normal, 1 = halve density/drop octave)
- kband: Bandwidth (controls exponential decay)
- kris: Rise time of grain envelope
- kdur: Total grain duration
- kdec: Decay time of grain envelope
- iolaps: Maximum grain overlaps
- ifna: Grain waveform (typically sine)
- ifnb: Envelope shape (exponential curve)
- itotdur: Total note duration

---

### fof2
**File:** `fof2.csd`
**Description:** Fof2 is an elaboration of fof with the ability to modulate grain starting phase at k-rate and a glissando parameter that sweeps each grain up or down by a given interval (in octaves). This enables "glisson" synthesis techniques.
**Key Opcodes:** `fof2`
**Parameters:**
- All fof parameters plus:
- kphs: Starting phase of each grain (k-rate, 0-1)
- kgliss: Glissando interval in octaves (positive = up, negative = down)

---

### fofx5
**File:** `fofx5.csd`
**Description:** Uses five simultaneous fof instances to imitate various singing voices (bass, tenor, counter-tenor, alto, soprano) singing vowel sounds. Includes formant data tables for each voice type and vowel (A, E, I, O, U). Features vowel LFO modulation, reverb, delay, EQ, and chorus effects.
**Key Opcodes:** `fof`, `FLjoy`, `freeverb`
**Parameters:**
- kndx: Vowel index (0-1, morphs between A-E-I-O-U)
- kfund: Fundamental frequency
- koct: Octaviation factor
- Formant data read from function tables for 5 formants per voice type
- Voice type selection (bass/tenor/counter-tenor/alto/soprano)
- Multiple input modes (sliders, XY panel, counters, MIDI)

---

### wavelets
**File:** `wavelets.csd`
**Description:** Wavelet granular synthesis where each grain begins and ends at zero crossings in the source waveform. Each grain represents a complete cycle. The source is generated via GEN 10 additive synthesis with user-controllable overtone structure. Fundamental and formant controlled by random spline generators.
**Key Opcodes:** `schedkwhen`, `poscil`, `rspline`
**Parameters:**
- krate: Rate of wavelet generation (perceived as fundamental)
- kcps: Pitch of waveform within wavelets (perceived as formant)
- gknum: Number of wavelets/cycles per grain
- GEN10 harmonic amplitudes (20 sliders)
- Fund/Form random range and rate controls
- De-regulation controls for high-frequency randomization

---

### WaveletGapping
**File:** `WaveletGapping.csd`
**Description:** Fragments a soundfile into wavelets (segments bounded by zero crossings) and inserts gaps between them during playback. Gap can be fixed duration or relative to wavelet duration. Implements the technique as a UDO for easy transplanting to other projects.
**Key Opcodes:** Custom UDO `WaveletGapper`, `flooper`, `trigger`, `timout`
**Parameters:**
- ifn: Source sound function table
- knwavelets: Number of zero crossings per wavelet segment
- kgap: Gap time (fixed in mode 0, relative in mode 1)
- kmode: 0 = fixed gap duration, 1 = gap relative to wavelet duration
- kspeed: Playback speed/pitch

---

### SchedkwhenGranulation
**File:** `SchedkwhenGranulation.csd`
**Description:** Implements granular synthesis using schedkwhen to create note events in real-time without built-in granular opcodes. Advantage: grain generation is fully customizable and per-grain processing (ring modulation, band-pass filtering) is possible. Includes global filtering and reverb on accumulated output.
**Key Opcodes:** `schedkwhen`, `metro`, `reson`, `reverbsc`
**Parameters:**
- kptr: Pointer position (with LFO modulation option)
- kGPS: Grains per second
- kdur: Grain duration range (min/max)
- katt/kdec: Grain envelope attack/decay ratios
- Per-grain pitch randomization (octave range, continuous offset)
- Per-grain ring modulation (frequency range, mix)
- Per-grain band-pass filtering (cutoff range, bandwidth range)
- Global HPF/LPF filtering
- Reverb (reverbsc)

---

## Common Grain Envelope Shapes

Most examples offer six selectable grain envelope shapes:

1. **Half Sine** - Smooth symmetric rise and fall (GEN 9)
2. **Percussive (straight segments)** - Sharp attack, linear decay (GEN 7)
3. **Percussive (exponential segments)** - Sharp attack, exponential decay (GEN 5)
4. **Gate** - Flat top with anti-click ramps at start/end (GEN 7)
5. **Reverse Percussive (straight)** - Linear attack, sharp decay (GEN 7)
6. **Reverse Percussive (exponential)** - Exponential attack, sharp decay (GEN 5)

---

## Common Techniques Across Examples

### MIDI Integration
Most examples support:
- MIDI note triggering (polyphonic or monophonic)
- MIDI pitch to grain density or transposition mapping
- MIDI controller modulation (typically CC#1 for depth, CC#2 for other parameters)

### Portamento/Smoothing
K-rate parameter changes are typically smoothed using `portk` with a ramping portamento time to prevent clicks on note start.

### Randomization
Common randomization techniques include:
- `rand`, `gauss`, `random` for offset values
- `rspline`, `jspline` for smooth random curves
- `exprand`, `betarand` for shaped distributions

### Recording Output
Most examples include a recording instrument using `fout` with 24-bit WAV format.

---

## Related Resources

- Csound Manual: Granular Synthesis section
- FLOSS Manual: Granular Synthesis chapter
- Original source: http://iainmccurdy.org/csound.html
