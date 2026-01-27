# CSound Signal Processing Opcodes

## Filters

### Low-Pass Filters

- rezzy - Resonant low-pass filter

### State-Variable Filters

- svn - State-variable filter with nonlinear processing

### Comb Filters

- combinv - Inverse comb filter

### Multi-mode Filters

- K35_lpf - Korg35 low-pass filter
- K35_hpf - Korg35 high-pass filter
- diode_ladder - Diode ladder filter
- zdf_1pole - Zero-delay feedback one-pole filter
- zdf_2pole - Zero-delay feedback two-pole filter
- zdf_ladder - Zero-delay feedback ladder filter
- mvchpf - Moog voltage-controlled high-pass filter
- mvclpf1 - Moog voltage-controlled low-pass filter (1-pole)
- mvclpf2 - Moog voltage-controlled low-pass filter (2-pole)
- mvclpf3 - Moog voltage-controlled low-pass filter (3-pole)
- mvclpf4 - Moog voltage-controlled low-pass filter (4-pole)

### Filter Analysis

- peak - Maintains the output amplitude equal to the peak value of the input
- median - Median filter
- mediank - K-rate median filter

## Equalization

- eqfil - Equalizer filter (second-order)
- rbjeq - Parametric equalizer (Robert Bristow-Johnson)
- pareq - Parametric equalizer
- lowshelf - Low-frequency shelving equalizer
- highshelf - High-frequency shelving equalizer
- peakq - Peaking equalizer filter
- hilbert - Hilbert transform filter (all-pass 90-degree phase shift)
- hilbert2 - Hilbert transform with improved characteristics

## Delay Lines

### Simple Delays

- delay - Delay an input signal by some time interval
- delay1 - Delay signal by one sample
- delayk - K-rate signal delay
- delayr - Read from a delay line
- delayw - Write to a delay line
- deltap - Tap a delay line
- deltapi - Tap a delay line with interpolation
- deltap3 - Tap a delay line with cubic interpolation
- deltapn - Tap a delay line at variable rate
- deltapx - Tap a delay line with controllable tap time
- deltapxw - Multi-tap delay with crossfade

### Variable Delays

- vdelay - Variable delay
- vdelay3 - Variable delay with cubic interpolation
- vdelayx - Variable delay with high-quality interpolation
- vdelayxw - Variable delay with crossfade
- vdelayxq - Variable delay with quadratic interpolation
- vdelayxs - Variable delay with sinc interpolation
- vdelaywq - Variable delay write with quadratic interpolation
- vdelayws - Variable delay write with sinc interpolation

### Multi-tap Delays

- multitap - Multi-tap delay line
- tapstop - Start/stop tape delay effect

## Reverb

### Algorithmic Reverbs

- reverb - Reverberates an input signal with a natural room sound
- reverb2 - Same as reverb but with more flexible stereo output
- nreverb - Reverberator based on the waveguide mesh
- reverbsc - Sean Costello's reverb algorithm
- freeverb - Freeverb stereo reverb
- valpass - Variable allpass (used in reverb design)
- jspline - Jitter spline generator (useful for reverb modulation)

### Convolution Reverb

- pconvolve - Partitioned convolution
- convolve - Convolution of two signals
- dconv - Direct convolution
- ftconv - Partitioned convolution with a function table

### Plate Reverb

- platerev - Plate reverb

## Dynamics Processing

### Compression and Limiting

- compress - Audio compressor with adjustable response time
- compress2 - Compress, limit, expand, duck or gate
- dam - Dynamic compressor/expander
- clip - Clips a signal to a predefined limit

### Envelope Following

- peak - Maintains peak amplitude

### Gates and Ducking

- compress2 - Can be used for gating
- hvs1 - Hysteresis-based trigger

## Distortion and Saturation

- taninv - Inverse tangent distortion
- taninv2 - Inverse tangent distortion with adjustable knee
- clip - Hard clipping

## Modulation Effects

### Chorus

- chorus - Chorus effect

### Flanging

- flanger - Flanging effect
- wguide1 - Can create flanging effects
- wguide2 - Can create flanging effects

### Phasing

- phaser1 - First-order allpass phaser
- phaser2 - Second-order allpass phaser

### Tremolo and Vibrato

- vdelay - Can create vibrato effects
- vibr - Generates natural-sounding vibrato
- vibrato - Generates vibrato

## Pitch Shifting and Time Stretching

- pvshift - Pitch shift using phase vocoder
- pvscale - Scale the frequency components of a pv stream
- pvstanal - Phase vocoder analysis with onset detection
- sndwarp - Time and pitch scaling by granular resynthesis
- sndwarpst - Stereo version of sndwarp
- mincer - Phase-locked vocoder for time/pitch scaling
- temposcal - Time scaling of audio without pitch change
- pshift - Pitch shift using FFT

## Spatialization

### Panning

- pan - Distribute audio across multiple channels
- pan2 - Stereo panning
- p5gdata - P5 glove data scaling
- space - Distribute an audio signal among four channels
- spsend - Send audio to space with distance cues
- spat3d - 3D spatialization using stereo pairs
- spat3di - 3D spatialization with interpolation
- spat3dt - 3D spatialization with distance cues

### Doppler

- doppler - Doppler shift simulation

### Ambisonics

- bformenc - B-format encoder for Ambisonic spatialization
- bformenc1 - First-order B-format encoder
- bformdec - B-format decoder for Ambisonic reproduction
- bformdec1 - First-order B-format decoder
- bformdec2 - Second-order B-format decoder

### HRTF (Head-Related Transfer Function)

- hrtfmove - HRTF spatialization with moving sound sources
- hrtfmove2 - Improved HRTF spatialization
- hrtfstat - HRTF spatialization for static sources
- hrtfer - HRTF spatialization

## Amplitude and Envelope Processing

- envlpx - Envelope with configurable shape
- envlpxr - Envelope with release segment
- transeg - Construct a series of segments with various curves
- transegr - Transeg with release segment
- cosseg - Cosine segment generator
- cossegr - Cosine segment with release

## Frequency Domain Processing

### FFT/Phase Vocoder

- pvstencil - Apply a mask to spectral bins
- pvsmaska - Mask spectral signal
- pvsbufread2 - Enhanced pvs buffer reading
- pvsdemix - Spectral azimuth-based de-mixing
- pvsvoc - Phase vocoder streaming
- pvslock - Lock phase relationships
- pvsbin - Access individual bins of a pvs signal
- pvscent - Calculate spectral centroid
- pvsftw - Write fsig to function table
- pvsftr - Read fsig from function table
- pvsarp - Arpeggiate spectral components
- pvswarp - Warp spectral components
- pvsbandr - Band-reject filter for pvs signals
- pvsbandp - Band-pass filter for pvs signals

### Convolution

- convolve - Convolution of audio signals
- dconv - Direct convolution
- pconvolve - Partitioned convolution
- ftconv - Partitioned convolution with function table
- tvconv - Time-varying convolution

## Analysis

### Pitch Detection

- pitch - Pitch detection using autocorrelation
- pitchamdf - Pitch detection using AMDF method
- ptrack - Pitch and amplitude tracking
- pvscent - Spectral centroid calculation
- centroid - Spectral centroid

### Amplitude Analysis

- max - Maximum value
- max_k - K-rate maximum
- min - Minimum value
- min_k - K-rate minimum
- peak - Peak amplitude tracker
- pvsceps - Cepstral analysis
- pvscent - Spectral centroid

### Spectral Analysis

- spectrum - Generate spectral data
- pvsanal - Phase vocoder analysis
- pvanal - Phase vocoder analysis (legacy)
- pvstanal - Phase vocoder analysis with onset detection
- pvread - Read from a phase vocoder analysis file
- specaddm - Spectral magnitude addition
- specdiff - Spectral difference
- specdisp - Spectral display
- specfilt - Spectral filtering
- spechist - Spectral histogram
- specptrk - Spectral peak tracking
- specscal - Spectral scaling
- specsum - Spectral summation

### FFT

- fft - Fast Fourier Transform
- fftinv - Inverse FFT
- rfft - Real FFT
- rifft - Real inverse FFT

## Signal Routing and Mixing

### Mixing

- sum - Sum of multiple signals
- product - Product of signals
- vincr - Increment a signal

### Crossfading

- xfade - Crossfade between signals
- xfadec - Crossfade with curve control
- xfader - Crossfader with exponential curve

### Gain Control

- gain - Apply gain
- clip - Clip signal to range

## Sampling and Sample Rate Conversion

- upsamp - Upsample from k-rate to a-rate
- downsamp - Downsample from a-rate to k-rate
- interp - Interpolate between k-rate values at a-rate
- integ - Integration of a signal
- diff - Differentiation of a signal
- samphold - Sample and hold
- vaget - Variable-rate audio data read

## Waveshaping

- distort1 - Modified tanh distortion
- powershape - Power-based waveshaping
- polynomial - Polynomial waveshaping
- tablexkt - Table lookup with crossfade (waveshaping)

## Amplitude Modulation

- am - Amplitude modulation

## Audio Effects Processing

### Auto-wah

- wah - Wah-wah effect
- autowah - Auto-wah effect

### Tremolo

- tremotor - Tremolo effect

### Vocoder

- vocoder - Vocoder effect

### Lo-Fi Effects

- lofi - Lo-fi effect with sample rate and bit depth reduction
- loopseg - Looping segment generator
- looptseg - Looping segment with time control
- loopxseg - Looping segment with exponential curves

## Noise Reduction and Gating

- denorm - Denormalization filter
- dcblock - DC blocking filter
- dcblock2 - Improved DC blocking filter

## Resampling and Interpolation

- upsamp - Upsample k-rate to a-rate
- downsamp - Downsample a-rate to k-rate
- interp - Interpolate between k-rate values
- vaget - Variable-rate audio get
- tablei - Table read with interpolation
- table3 - Table read with cubic interpolation
- tablexkt - Table read with crossfade
- oscil1i - 1D linear interpolated table lookup
- osciliktp - Interpolated table lookup with phase offset

## Stereo and Multi-channel Processing

- pan2 - Stereo panning
- stereopan - Stereo panning with position control
- xyin - Sense the cursor position in an output window
- monitor - Monitor audio from a channel
- inch - Read audio from an input channel
- outch - Write audio to output channels

## Phase Manipulation

- hilbert - Hilbert transform (90-degree phase shift)
- hilbert2 - Improved Hilbert transform
- phaseshifter - Stereo phase shifter

## Sample Accurate Timing

- vdel_k - Variable delay at k-rate
- delayr/delayw - Sample-accurate delay read/write
- samphold - Sample and hold

## Spectral Processing

### Spectral Modification

- pvscale - Scale frequencies in pvs signal
- pvshift - Shift frequencies in pvs signal
- pvsmorph - Morph between two pvs signals
- pvsmix - Mix two pvs signals
- pvscross - Cross synthesis
- pvsfilter - Filter using pvs signal
- pvstencil - Apply spectral mask
- pvsarp - Spectral arpeggiator
- pvswarp - Warp spectral bins

### Spectral Blurring and Smearing

- pvsblur - Blur spectral bins over time

### Spectral Gating and Masking

- pvsgain - Apply gain to pvs signal
- pvsmaska - Mask spectral bins
- pvsfreeze - Freeze spectral content

### Bin Processing

- pvsbin - Read/write individual bins
- pvsbinread - Read from spectral bins
- pvsinfo - Get info about pvs signal

## Audio Math Operations

- abs - Absolute value
- sqrt - Square root
- exp - Exponential
- log - Natural logarithm
- log10 - Base-10 logarithm
- pow - Power function
- sin - Sine
- cos - Cosine
- tan - Tangent

## Utilities

### Signal Monitoring

- monitor - Monitor audio output
- display - Display audio signal
- dispfft - Display FFT
- fftdisp - FFT display

### Signal Measurement

- max_k - Maximum of a k-rate signal
- min_k - Minimum of a k-rate signal
- rms - RMS measurement
- peak - Peak measurement
- vactrol - Envelope follower modeling optical compressor

### Signal Generation for Testing

- pinkish - Pink noise
- pinker - Pink noise generator
- noise - White noise
- gausstrig - Gaussian-distributed random impulses
- dust - Random impulses
- dust2 - Bipolar random impulses

## Linear Prediction

- lpread - Read linear prediction data from analysis file
- lpreson - Resynthesizes audio from linear prediction data
- lpfreson - Formant synthesis using linear prediction

## ATS (Analysis-Transformation-Synthesis)

- ATSread - Read data from ATS analysis file
- ATSinfo - Get info from ATS file
- ATSbufread - Read and buffer ATS data
- ATSinterpread - Read ATS data with interpolation
- ATSpartialtap - Tap individual partials from ATS data

## Soundfile Processing

- filescal - Scale a soundfile
- filesr - Get sample rate of soundfile
- filelen - Get length of soundfile
- filepeak - Get peak amplitude of soundfile
- filenchnls - Get number of channels in soundfile

## Signal Flow Control

- denorm - Remove denormal numbers
- vactrol - Vactrol-style envelope follower
- lag - Lag processor (exponential portamento)
- lagud - Lag with separate up/down times
- port - Portamento
- portk - K-rate portamento
- tlineto - Linear interpolation to target

## Window Functions (for analysis/processing)

- window - Apply window function to a signal
- pvscent - Spectral centroid using windowing

## Stereo Enhancement

- freeverb - Stereo reverb
- reverbsc - Stereo reverb
- stereomix - Stereo mix with width control
- mirror - Reflect left/right channels

## Advanced Signal Processing

### Granular Processing

- grain - Granular processing
- grain2 - Granular processing (v2)
- grain3 - Granular processing (v3)
- granule - Granular synthesis/processing
- partikkel - Advanced granular processor
- syncgrain - Synchronous granular processing
- syncloop - Granular loop processor

### Vector Processing

- vadd - Vector addition
- vmult - Vector multiplication
- vport - Vector portamento
- vpow - Vector power
