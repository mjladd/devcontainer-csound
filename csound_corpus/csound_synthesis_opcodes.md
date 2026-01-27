# CSound Synthesis Opcodes

## Oscillators and Basic Waveform Generators

### Standard Oscillators

- oscil - Simple oscillator with linear interpolation
- oscili - Oscillator with cubic interpolation
- oscil3 - Oscillator with cubic interpolation (legacy)
- oscilikt - Interpolating oscillator with pitch and amplitude modulation
- oscils - Simple sine oscillator
- poscil - High precision oscillator with interpolation
- poscil3 - High precision oscillator with cubic interpolation
- loscil - Read sampled sound from a table with looping
- loscil3 - Read sampled sound from a table with cubic interpolation

### Phase Accumulator Oscillators

- phasor - Produce a normalized moving phase value
- phasorbnk - Produce multiple normalized moving phase values

### Table Lookup Oscillators

- table - Access table values by direct indexing
- tablei - Access table values by direct indexing with interpolation
- table3 - Access table values with cubic interpolation
- tablekt - Access table values with k-rate or a-rate control
- tablexkt - Access table values with crossfade

## Additive Synthesis

- buzz - Output a set of harmonically related sine partials
- gbuzz - Output a set of harmonically related cosine partials
- mpulse - Generates a set of impulses
- vco - Implementation of a band-limited oscillator using pre-calculated tables
- vco2 - Implementation of a band-limited oscillator using integration
- adsynt - Perform additive synthesis with an arbitrary number of partials
- adsynt2 - Additive synthesis using a bank of interpolating oscillators
- hsboscil - Harmonic oscillator with amplitude and frequency modulation

## Subtractive Synthesis

### Filters - Low Pass

- tone - First-order recursive low-pass filter
- tonex - Emulation of a resistor-capacitor low-pass filter
- atone - First-order recursive high-pass filter
- port - Portamento (glissando) generator
- butlp - Second-order Butterworth low-pass filter
- lpf18 - 18dB/octave low-pass filter
- moogladder - Moog ladder filter implementation
- moogvcf - Moog voltage-controlled filter
- moogvcf2 - Improved Moog voltage-controlled filter
- lpform - Formant filter
- lpf - General low-pass filter

### Filters - High Pass

- buthp - Second-order Butterworth high-pass filter
- atone - First-order recursive high-pass filter
- atonex - Emulation of a resistor-capacitor high-pass filter

### Filters - Band Pass

- butbp - Second-order Butterworth band-pass filter
- reson - Second-order resonant filter
- resonk - Second-order resonant filter with k-rate frequency
- resonr - Resonant second-order filter with variable resonance
- resony - Second-order resonant filter with k-rate frequency and bandwidth
- resonx - Emulation of a second-order resonant filter
- resonxk - Emulation of a second-order resonant filter with k-rate frequency
- tbvcf - Models a TB303 voltage-controlled filter

### Filters - Band Reject

- butbr - Second-order Butterworth band-reject filter
- areson - Second-order band-reject filter

### Filters - Comb and Allpass

- comb - Reverberates an input signal with a "colored" frequency response
- vcomb - Variable delay comb filter
- alpass - Reverberates an input signal with a flat frequency response
- valpass - Variable delay allpass filter

### Filters - State Variable and Multi-mode

- statevar - State-variable filter
- svfilter - State-variable filter with simultaneous outputs
- bqrez - Resonant second-order filter implemented with a biquad
- rbjeq - Parametric equalizer second-order filter

### Filters - Formant

- fof - FOF (Forme d'Onde Formatique) synthesis
- fof2 - Improved FOF synthesis
- fofilter - Formant filter
- resonz - Bandpass filter with variable frequency response

## FM (Frequency Modulation) Synthesis

- foscil - Basic frequency modulated oscillator
- foscili - FM oscillator with linear interpolation
- fmb3 - FM bell or tubular chime
- fmbell - FM bell
- fmrhode - FM Rhodes piano
- fmwurlie - FM Wurlitzer electric piano
- fmpercfl - FM percussion instrument
- fmvoice - FM voice synthesis
- crossfm - Cross frequency modulation synthesis
- crossfmi - Cross frequency modulation synthesis with interpolation
- crosspm - Cross phase modulation synthesis
- crosspmi - Cross phase modulation synthesis with interpolation

## Granular Synthesis

- grain - Generates granular synthesis textures
- grain2 - Easier-to-use granular synthesis texture generator
- grain3 - Generates granular synthesis textures with more user control
- granule - Granular synthesis generator with a more flexible approach
- partikkel - Powerful granular synthesis with support for waveshaping and envelope control
- partikkelsync - Grain sync signal for partikkel
- fof - FOF synthesis (can be used for granular synthesis)
- sndwarp - Time and pitch scaling with granular resynthesis
- sndwarpst - Stereo version of sndwarp
- syncgrain - Synchronous granular synthesis
- syncloop - Synchronous granular sample-accurate looping

## Waveshaping and Distortion

- distort - Distort an audio signal
- distort1 - Modified hyperbolic tangent distortion
- powershape - Waveshaper with controllable amount of distortion
- polynomial - Polynomial evaluation
- chebyshevpoly - Chebyshev polynomial evaluation
- pdclip - Soft distortion with clipping
- pdhalfy - Half-wave rectifier
- tanh - Hyperbolic tangent function (waveshaping)
- limit - Sets the lower and upper limits of the input signal

## Physical Models

### Plucked Strings

- pluck - Produces a naturally decaying plucked string or drum sound
- wgpluck - Physical model of a plucked string (waveguide)
- wgpluck2 - Physical model with control of pluck position
- repluck - Physical model with control of decay and sustain

### Bowed Strings

- wgbow - Physical model of a bowed string
- wgbowedbar - Physical model of a bowed bar

### Flutes and Wind Instruments

- wgflute - Physical model of a flute
- wgbrass - Physical model of a brass instrument
- wgclar - Physical model of a clarinet

### Percussion

- tambourine - Physical model of a tambourine
- cabasa - Physical model of a cabasa
- bamboox - Physical model of a bamboo wind chime
- dripwater - Physical model of dripping water
- crunch - Physical model of a crunch sound
- sandpaper - Physical model of sandpaper scratching

### Modal Synthesis

- [x] mode - Modal synthesis filter
- [x] streson - String resonator with variable fundamental frequency
- [x] prepiano - Prepared piano physical model
- [x] marimba - Physical model of a marimba
- [x] vibes - Physical model of a vibraphone
- [x] mandol - Physical model of a mandolin
- [x] gogobel - Physical model of a gong/bell

### General Physical Models

- barmodel - Physical model of a metal bar
- shaker - Physical model of a shaker instrument
- sekere - Physical model of a sekere (maraca-like)

## Waveguide Synthesis

- wguide1 - Waveguide model with one delay line
- wguide2 - Waveguide model with two delay lines
- wterrain - Waveguide terrain synthesis

## Wavetable Synthesis

- oscbnk - Mixes the output of any number of oscillators
- poscil - High precision oscillator reading from function tables
- vposcil - Variable precision oscillator

## Noise Generators

- rand - Generates a controlled random number series
- randi - Generates a controlled random number series with interpolation
- randh - Generates random numbers with sample-and-hold
- random - Generates random numbers with a choice of distribution
- randomh - Random numbers with sample-and-hold
- randomi - Random numbers with interpolation
- noise - White noise generator
- pinkish - Generates approximate pink noise
- pinker - Generates pink noise

## Sample Playback and Looping

- loscil - Read sampled sound from a table with looping
- loscil3 - Read sampled sound with cubic interpolation and looping
- lphasor - Phasor with looping capabilities
- flooper - Function-table-based crossfading looper
- flooper2 - Crossfading looper with more controls
- sfiplay - Plays a SoundFont2 sample
- sfplay - Plays a SoundFont2 sample with pitch control
- sfplaym - Plays a SoundFont2 sample with MIDI control

## Spectral and FFT Synthesis

- pvsanal - Generate an fsig from a mono audio source
- pvsynth - Resynthesize time-domain audio from frequency-domain fsig data
- pvsadsyn - Resynthesize using fast oscillator bank
- pvscross - Perform cross-synthesis between two source fsigs
- pvsfilter - Filter a source fsig using a second fsig
- pvsmorph - Morph between two source fsigs
- pvsblur - Blur the spectral components
- pvsmix - Mix two fsigs
- pvsmooth - Smooth spectral data
- pvsfreeze - Freeze spectral content
- pvsbuffer - Create and manipulate a buffer of fsig data
- pvsbufread - Read from a pvs buffer
- resyn - FFT-based resynthesis with transformations
- adsyn - Output is the sum of upto 200 sinusoids
- pvoc - FFT-based phase vocoder

## Karplus-Strong Synthesis

- pluck - Karplus-Strong plucked string algorithm
- streson - String resonator (Karplus-Strong variant)

## Scanned Synthesis

- scanu - Compute the waveform and the wavetable for use in scanned synthesis
- scans - Generate audio output using scanned synthesis
- scantable - Update the wavetable for scanned synthesis

## Vector Synthesis

- vpvoc - Vector-based phase vocoder

## Amplitude and Ring Modulation

- ring - Ring modulation (simple multiplication)
- ampmidid - MIDI amplitude with decay

## Vocal Synthesis

- fog - Audio output is a succession of sinusoid bursts
- voc - Vocal synthesis filter

## FM4 Operator Models

- fmb3 - FM bell or tubular chime
- fmbell - FM bell sound
- fmrhode - FM Rhodes piano emulation
- fmwurlie - FM Wurlitzer electric piano
- fmpercfl - FM percussion (flute model)
- fmvoice - FM voice synthesis

## Padsynth Algorithm

- padsynth - Generate wave-tables for the padsynth algorithm

## LA (Linear Arithmetic) Synthesis

- crossfm - Cross frequency modulation between two oscillators
- crosspm - Cross phase modulation between two oscillators

## Pulsar Synthesis

- ATSadd - Use data from ATS analysis to do additive resynthesis
- ATSaddnz - Use data from ATS analysis to do noise resynthesis
- ATScross - Perform cross-synthesis using ATS data
- ATSsinnoi - Use ATS data to perform sinusoidal plus noise resynthesis

## Additional Synthesis Opcodes

### Low-Frequency Oscillators (LFO)

- lfo - Low frequency oscillator with various waveforms
- lfsr - Linear feedback shift register random generator

### Envelope Generators (used with synthesis)

- linen - Linear envelope generator
- linenr - Linear envelope with release segment
- adsr - ADSR envelope generator
- madsr - MIDI-aware ADSR envelope
- mxadsr - Extended MIDI ADSR envelope
- expseg - Exponential segment generator
- linseg - Linear segment generator

### Pulse Generators

- vco - Voltage-controlled oscillator
- vco2 - Band-limited pulse, saw, triangle, and square waveforms
- squinewave - Square wave with improved DC characteristics
- vco2ift - Detuned vco2 oscillators
- vco2init - Calculates tables for vco2

### Special Oscillators

- planet - Simulates a planet orbiting in a binary star system
- lorenz - Lorenz chaotic attractor
- gendy - Dynamic stochastic synthesis
- gendyc - Dynamic stochastic synthesis with cubic interpolation
- gendyx - Dynamic stochastic synthesis with more controls

## Drum Synthesis

- dripwater - Semi-physical model of dripping water
- tambourine - Semi-physical model of a tambourine
- sleighbells - Semi-physical model of sleighbells
- guiro - Semi-physical model of a guiro
- cabasa - Semi-physical model of a cabasa
- sekere - Semi-physical model of a sekere
- sandpaper - Semi-physical model of sandpaper
- crunch - Semi-physical model of a crunch

## Vowel and Formant Synthesis

- fof - Formant synthesis
- fof2 - Improved formant synthesis
- fofilter - Formant filter
- fog - Formant synthesis with granular approach
- winsound - Formant synthesis using a window function

## PADsynth

- padsynth - Generate a sample table using the PADsynth algorithm

## FM Synthesis Variations

- fm - Basic frequency modulation
- crossfm - Cross frequency modulation
- crossfmi - Cross FM with interpolation
- crosspm - Cross phase modulation
- crosspmi - Cross PM with interpolation

## Waveset and Waveterrain Synthesis

- wterrain - Waveterrain synthesis oscillator
- wterrain2 - Waveterrain synthesis with more controls

## Resonant Models

- mode - Modal synthesis filter bank
- streson - String resonator
- resony - Resonant filter
- resonr - Resonant filter with variable frequency
- resonz - Resonant bandpass filter
- vlowres - Resonant low-pass filter

## SuperCollider Oscillators (SC Opcodes)

- SCOsc - SuperCollider-compatible oscillator
- SCOscil - SuperCollider-compatible table oscillator

## Synthesis Utilities

- [ ] balance - Adjust one audio signal according to the amplitude of another
- [ ] follow - Envelope follower
- [ ] follow2 - Envelope follower with different controls
- [ ] rms - Root-mean-square of a signal
- [ ] gain - Adjusts the amplitude audio signal

## Specialized Synthesis

- [ ] hsboscil - Harmonic sweep oscillator with a user-defined pattern
- [ ] gendy - Implementation of Iannis Xenakis' Dynamic Stochastic Synthesis
- [ ] gendyc - Gendy with cubic interpolation
- [ ] gendyx - Gendy with more controls
- [ ] gausstrig - Random impulses around a certain frequency
- [ ] dust - Random impulses
- [ ] dust2 - Random impulses (bipolar)
- [ ] gausstrig - Random impulses with Gaussian distribution
- [ ] mpulse - Generates a set of impulses

## Vocoder

- [ ] vocoder - Vocoder implementation
