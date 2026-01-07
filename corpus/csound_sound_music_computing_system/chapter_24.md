# 1. PVS AMP FREQ: this sub type carries frames (vectors) of amplitude and fre-

1. PVS AMP FREQ: this sub type carries frames (vectors) of amplitude and fre-
quency pairs. Each one of these refers to a given frequency band (bin), in as-
cending order from 0 Hz to the Nyquist frequency (inclusive). At the analysis,
the spectrum is broken into a certain number of these bins, which are equally-
spaced in frequency. Alongside this data, the f-sig carries the analysis frame size,
the spacing between analysis points (hopsize), the window size and type used.
This subtype is employed for Phase Vocoder signals, and is the most commonly
used f-sig.