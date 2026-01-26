# 1. An initial analysis step produces frames of amplitudes, frequencies, and phases

1. An initial analysis step produces frames of amplitudes, frequencies, and phases
from an input signal. This is done in Csound by applying the Instantaneous Fre-
quency Distribution (IFD) [1, 44] to provide a frame of frequencies. This is also
based on the DFT, but uses a different method to the phase vocoder. The pro-
cess also yields amplitudes and phases for the same analysis frame. The opcodes
pvsifd or tabifd are used for this:
ffr,fph pvsifd
asig, isize, ihop, iwin
ffr,fph tabifd
ktimpt,kamp,kpitch,isize,ihop,iwin,ifn
14.5 Sinusoidal Modelling
323
Each one produces a pair of f-sig outputs, one containing amplitudes and frequen-
cies (PVS AMP FREQ format), and another containing amplitudes and phases
(PVS AMP PHASE). The main difference between them is that pvsifd takes
an audio input signal, whereas tabifd reads from a function table.
