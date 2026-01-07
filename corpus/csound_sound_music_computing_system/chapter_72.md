# 2. We use this curve as a set of magnitudes for a 0-phase spectrum, and take its

2. We use this curve as a set of magnitudes for a 0-phase spectrum, and take its
inverse DFT. In Csound, this amounts to copying the table into an array, making
its elements complex-valued (with r2c) and taking the transform (rifft):
copyf2array iSpec,ifn
iIR[] rifft r2c(iSpec)