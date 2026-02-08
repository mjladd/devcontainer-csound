"""
Csound opcode descriptions, categories, and detection utilities.

Extracted from the corpus analysis scripts and expanded with category mappings
for enriching chunks during indexing.
"""

import re

# Opcode to description mapping (200+ opcodes)
OPCODE_DESCRIPTIONS: dict[str, str] = {
    # Oscillators
    "oscil": "oscillator",
    "oscili": "interpolating oscillator",
    "oscils": "simple sine oscillator",
    "poscil": "high-precision oscillator",
    "poscil3": "high-precision cubic interpolation oscillator",
    "vco": "analog-style oscillator",
    "vco2": "bandlimited oscillator",
    "buzz": "buzz/pulse generator",
    "gbuzz": "generalized buzz generator",
    # FM Synthesis
    "foscil": "FM synthesis",
    "foscili": "interpolating FM synthesis",
    "fmbell": "FM bell synthesis",
    "fmrhode": "FM Rhodes piano",
    "fmwurlie": "FM Wurlitzer piano",
    "fmvoice": "FM voice synthesis",
    "fmpercfl": "FM percussion/flute",
    "fmb3": "FM Hammond B3 organ",
    "crossfm": "cross-coupled FM synthesis",
    "crosspm": "cross-coupled phase modulation",
    # Granular
    "grain": "granular synthesis",
    "grain2": "granular synthesis",
    "grain3": "pitch-synchronous granular synthesis",
    "granule": "advanced granular synthesis",
    "syncgrain": "synchronous granular synthesis",
    "syncloop": "looping granular synthesis",
    "sndwarp": "time-stretching/pitch-shifting",
    "sndwarpst": "stereo time-stretching",
    "partikkel": "advanced granular synthesis",
    "fog": "FOG granular synthesis",
    # Physical Models
    "pluck": "Karplus-Strong plucked string",
    "repluck": "enhanced plucked string",
    "wgpluck": "waveguide plucked string",
    "wgpluck2": "waveguide plucked string",
    "wgbow": "waveguide bowed string",
    "wgbowedbar": "waveguide bowed bar",
    "wgflute": "waveguide flute",
    "wgclar": "waveguide clarinet",
    "wgbrass": "waveguide brass",
    "streson": "string resonator",
    "mode": "modal synthesis",
    "marimba": "marimba physical model",
    "vibes": "vibraphone physical model",
    "barmodel": "bar physical model",
    "prepiano": "prepared piano model",
    "mandol": "mandolin physical model",
    "gogobel": "gourd/bell physical model",
    # Filters
    "moogladder": "Moog ladder filter",
    "moogvcf": "Moog VCF filter",
    "moogvcf2": "Moog VCF filter",
    "lowpass2": "resonant lowpass filter",
    "bqrez": "resonant filter",
    "butterlp": "Butterworth lowpass filter",
    "butterhp": "Butterworth highpass filter",
    "butterbp": "Butterworth bandpass filter",
    "butterbr": "Butterworth band-reject filter",
    "resonx": "resonant filter bank",
    "reson": "resonant filter",
    "areson": "anti-resonant filter",
    "lpf18": "3-pole lowpass filter",
    "tbvcf": "TB-303 style filter",
    "statevar": "state-variable filter",
    "svfilter": "state-variable filter",
    "clfilt": "controllable filter",
    "pareq": "parametric equalizer",
    "eqfil": "equalizer filter",
    "tonex": "tone control filter",
    "atonex": "anti-tone control filter",
    "tone": "first-order lowpass filter",
    "atone": "first-order highpass filter",
    "butlp": "Butterworth lowpass filter",
    "buthp": "Butterworth highpass filter",
    "butbp": "Butterworth bandpass filter",
    "butbr": "Butterworth band-reject filter",
    "diode_ladder": "diode ladder filter",
    "zdf_ladder": "zero-delay feedback ladder filter",
    "zdf_1pole": "zero-delay feedback 1-pole filter",
    "zdf_2pole": "zero-delay feedback 2-pole filter",
    "k35_lpf": "Korg35 lowpass filter",
    "k35_hpf": "Korg35 highpass filter",
    # Effects
    "reverb": "reverb effect",
    "nreverb": "natural reverb",
    "freeverb": "Freeverb reverb",
    "reverbsc": "stereo reverb",
    "reverb2": "stereo reverb",
    "delay": "delay effect",
    "delay1": "one-sample delay",
    "delayr": "delay line read",
    "delayw": "delay line write",
    "deltap": "delay line tap",
    "deltapi": "interpolating delay line tap",
    "deltap3": "cubic interpolating delay line tap",
    "deltapx": "high-quality delay line tap",
    "deltapxw": "high-quality delay line write",
    "vdelay": "variable delay",
    "vdelay3": "interpolating variable delay",
    "vdelayx": "high-quality variable delay",
    "flanger": "flanger effect",
    "chorus": "chorus effect",
    "phaser1": "first-order phaser",
    "phaser2": "second-order phaser",
    "distort": "distortion effect",
    "distort1": "modified distortion",
    "clip": "clipping/distortion",
    "powershape": "waveshaping",
    "pdclip": "phase distortion clipping",
    "pdhalf": "phase distortion",
    "compress": "compressor",
    "compress2": "compressor",
    "dam": "dynamics processor",
    "follow": "envelope follower",
    "follow2": "envelope follower",
    "balance": "amplitude balance",
    "balance2": "amplitude balance",
    "pan2": "stereo panning",
    "pan": "panning",
    "locsig": "spatial localization",
    "locsend": "spatial localization send",
    "hrtfer": "HRTF spatialization",
    "hrtfmove": "HRTF movement",
    "hrtfmove2": "HRTF movement",
    "hrtfstat": "static HRTF",
    "vbap": "vector-base amplitude panning",
    "vbaplsinit": "VBAP initialization",
    "doppler": "doppler effect",
    "hilbert": "Hilbert transform",
    "freqshift": "frequency shifting",
    "ringmod": "ring modulation",
    # FOF/Formant
    "fof": "FOF formant synthesis",
    "fof2": "FOF formant synthesis with glissando",
    # Spectral/FFT
    "pvsanal": "FFT analysis",
    "pvsynth": "FFT resynthesis",
    "pvsadsyn": "FFT additive resynthesis",
    "pvscross": "spectral cross-synthesis",
    "pvsmorph": "spectral morphing",
    "pvsfreeze": "spectral freeze",
    "pvshift": "spectral pitch shifting",
    "pvscale": "spectral scaling",
    "pvsblur": "spectral blurring",
    "pvsmooth": "spectral smoothing",
    "pvsfilter": "spectral filtering",
    "pvsbandp": "spectral bandpass",
    "pvsbandr": "spectral band-reject",
    "pvsbufread": "spectral buffer read",
    "pvscent": "spectral centroid",
    "pvsinit": "spectral init",
    "pvsinfo": "spectral info",
    "pvsfread": "spectral file read",
    "pvsftr": "spectral frequency transform",
    "pvsftw": "spectral frequency write",
    "pvsmaska": "spectral masking",
    "pvsosc": "spectral oscillator",
    "pvswarp": "spectral warping",
    # Noise
    "rand": "random noise",
    "randi": "interpolating random",
    "randh": "sample-and-hold random",
    "noise": "white noise",
    "pinkish": "pink noise",
    "dust": "random impulses",
    "dust2": "random impulses",
    "gausstrig": "Gaussian trigger",
    "gauss": "Gaussian distribution",
    "fractalnoise": "fractal noise",
    # Envelopes
    "linen": "linear envelope",
    "linenr": "linear envelope with release",
    "linseg": "linear segments",
    "linsegr": "linear segments with release",
    "expseg": "exponential segments",
    "expsegr": "exponential segments with release",
    "adsr": "ADSR envelope",
    "madsr": "MIDI ADSR envelope",
    "xadsr": "exponential ADSR",
    "mxadsr": "MIDI exponential ADSR",
    "transeg": "transition segments",
    "cosseg": "cosine segments",
    "cossegr": "cosine segments with release",
    "jspline": "jittered spline",
    "rspline": "random spline",
    # Scanned Synthesis
    "scanu": "scanned synthesis",
    "scanu2": "scanned synthesis",
    "scans": "scanned synthesis",
    "scantable": "scanned synthesis table",
    # Waveguide
    "wguide1": "simple waveguide",
    "wguide2": "dual waveguide",
    # Sample Playback
    "loscil": "looping oscillator/sampler",
    "loscil3": "cubic interpolation sampler",
    "flooper": "function table looper",
    "flooper2": "enhanced looper",
    "sndloop": "sound loop recorder",
    "diskin": "disk streaming",
    "diskin2": "enhanced disk streaming",
    "mp3in": "MP3 playback",
    "mincer": "phase-locked time-stretching",
    "temposcal": "time-stretching with tempo scaling",
    # Additive
    "adsyn": "additive synthesis",
    "adsynt": "additive synthesis",
    "adsynt2": "additive synthesis",
    "hsboscil": "harmonic synthesis",
    # Analysis
    "pitch": "pitch detection",
    "pitchamdf": "AMDF pitch detection",
    "ptrack": "pitch tracking",
    "plltrack": "PLL pitch tracking",
    "pvspitch": "spectral pitch detection",
    "centroid": "spectral centroid",
    "rms": "RMS amplitude",
    "specptrk": "spectral peak tracking",
    # MIDI
    "massign": "MIDI channel assignment",
    "pgmassign": "MIDI program assignment",
    "notnum": "MIDI note number",
    "veloc": "MIDI velocity",
    "cpsmidi": "MIDI to CPS",
    "cpsmidib": "MIDI with pitch bend to CPS",
    "ampmidi": "MIDI to amplitude",
    "midiin": "raw MIDI input",
    "midictrl": "MIDI controller",
    "ctrl7": "7-bit MIDI controller",
    "ctrl14": "14-bit MIDI controller",
    "ctrl21": "21-bit MIDI controller",
    "initc7": "init 7-bit controller",
    "initc14": "init 14-bit controller",
    # Table operations
    "tablei": "table interpolation read",
    "table": "table read",
    "tablew": "table write",
    "tabw": "table write",
    "tab": "table read",
    "ftgen": "function table generation",
    "ftgentmp": "temporary function table generation",
    # I/O
    "out": "mono output",
    "outs": "stereo output",
    "outch": "channel output",
    "inch": "channel input",
    "in": "mono input",
    "ins": "stereo input",
    "fout": "file output",
    "fin": "file input",
    # Score
    "event": "score event",
    "event_i": "score event at i-time",
    "schedule": "scheduled event",
    "schedulek": "k-rate scheduled event",
    "turnoff": "turn off instrument",
    "turnoff2": "turn off instrument",
    # Printing/debugging
    "prints": "print string",
    "printks": "print k-rate string",
    "printf": "formatted print",
    "printf_i": "formatted print at i-time",
}

# Category mappings for technique inference
OPCODE_CATEGORIES: dict[str, list[str]] = {
    "oscillators": [
        "oscil", "oscili", "oscils", "poscil", "poscil3", "vco", "vco2",
        "buzz", "gbuzz",
    ],
    "fm_synthesis": [
        "foscil", "foscili", "fmbell", "fmrhode", "fmwurlie", "fmvoice",
        "fmpercfl", "fmb3", "crossfm", "crosspm",
    ],
    "granular_synthesis": [
        "grain", "grain2", "grain3", "granule", "syncgrain", "syncloop",
        "sndwarp", "sndwarpst", "partikkel", "fog",
    ],
    "physical_modeling": [
        "pluck", "repluck", "wgpluck", "wgpluck2", "wgbow", "wgbowedbar",
        "wgflute", "wgclar", "wgbrass", "streson", "mode", "marimba",
        "vibes", "barmodel", "prepiano", "mandol", "gogobel",
    ],
    "filters": [
        "moogladder", "moogvcf", "moogvcf2", "lowpass2", "bqrez",
        "butterlp", "butterhp", "butterbp", "butterbr", "resonx", "reson",
        "areson", "lpf18", "tbvcf", "statevar", "svfilter", "clfilt",
        "pareq", "eqfil", "tonex", "atonex", "tone", "atone",
        "butlp", "buthp", "butbp", "butbr", "diode_ladder",
        "zdf_ladder", "zdf_1pole", "zdf_2pole", "k35_lpf", "k35_hpf",
    ],
    "reverb": [
        "reverb", "nreverb", "freeverb", "reverbsc", "reverb2",
    ],
    "delay": [
        "delay", "delay1", "delayr", "delayw", "deltap", "deltapi",
        "deltap3", "deltapx", "deltapxw", "vdelay", "vdelay3", "vdelayx",
    ],
    "modulation_effects": [
        "flanger", "chorus", "phaser1", "phaser2",
    ],
    "distortion": [
        "distort", "distort1", "clip", "powershape", "pdclip", "pdhalf",
    ],
    "dynamics": [
        "compress", "compress2", "dam", "follow", "follow2", "balance",
        "balance2",
    ],
    "spatialization": [
        "pan2", "pan", "locsig", "locsend", "hrtfer", "hrtfmove",
        "hrtfmove2", "hrtfstat", "vbap", "vbaplsinit", "doppler",
    ],
    "spectral_processing": [
        "pvsanal", "pvsynth", "pvsadsyn", "pvscross", "pvsmorph",
        "pvsfreeze", "pvshift", "pvscale", "pvsblur", "pvsmooth",
        "pvsfilter", "pvsbandp", "pvsbandr", "pvsbufread", "pvscent",
        "pvsinit", "pvsinfo", "pvsfread", "pvsmaska", "pvsosc", "pvswarp",
    ],
    "noise": [
        "rand", "randi", "randh", "noise", "pinkish", "dust", "dust2",
        "gausstrig", "gauss", "fractalnoise",
    ],
    "envelopes": [
        "linen", "linenr", "linseg", "linsegr", "expseg", "expsegr",
        "adsr", "madsr", "xadsr", "mxadsr", "transeg", "cosseg",
        "cossegr", "jspline", "rspline",
    ],
    "scanned_synthesis": [
        "scanu", "scanu2", "scans", "scantable",
    ],
    "waveguide": [
        "wguide1", "wguide2",
    ],
    "sample_playback": [
        "loscil", "loscil3", "flooper", "flooper2", "sndloop", "diskin",
        "diskin2", "mp3in", "mincer", "temposcal",
    ],
    "additive_synthesis": [
        "adsyn", "adsynt", "adsynt2", "hsboscil",
    ],
    "fof_formant": [
        "fof", "fof2",
    ],
    "frequency_shifting": [
        "hilbert", "freqshift", "ringmod",
    ],
}

# Reverse mapping: opcode -> category
_OPCODE_TO_CATEGORY: dict[str, str] = {}
for _cat, _opcodes in OPCODE_CATEGORIES.items():
    for _op in _opcodes:
        _OPCODE_TO_CATEGORY[_op] = _cat


def detect_opcodes(code: str) -> list[str]:
    """
    Detect known Csound opcodes in a code string.

    Args:
        code: Csound code to analyze

    Returns:
        List of detected opcode names, sorted alphabetically
    """
    found = []
    code_lower = code.lower()
    for opcode in OPCODE_DESCRIPTIONS:
        pattern = rf'\b{re.escape(opcode)}\b'
        if re.search(pattern, code_lower):
            found.append(opcode)
    return sorted(found)


def infer_techniques(opcodes: list[str]) -> list[str]:
    """
    Infer synthesis/processing techniques from a list of opcodes.

    Args:
        opcodes: List of opcode names

    Returns:
        List of unique technique/category names
    """
    techniques = set()
    for opcode in opcodes:
        cat = _OPCODE_TO_CATEGORY.get(opcode)
        if cat:
            techniques.add(cat)
    return sorted(techniques)


def get_opcode_description(opcode: str) -> str | None:
    """Get the description for an opcode, or None if unknown."""
    return OPCODE_DESCRIPTIONS.get(opcode.lower())


def get_opcode_category(opcode: str) -> str | None:
    """Get the category for an opcode, or None if unknown."""
    return _OPCODE_TO_CATEGORY.get(opcode.lower())
