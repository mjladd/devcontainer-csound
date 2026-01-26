# 6. Hop the window position by N

6. Hop the window position by N
o samples (hopsize), where o is the number of
overlapped frames, and continue from the top.
The analysis output at each time point is a frame of amplitudes and frequen-
cies for each analysis point. The 0 Hz and Nyquist frequency amplitudes are often
packed together in the ﬁrst two positions of the array (as in rfft). This data format
is very easy to manipulate, as we will see in later sections. New data frames will be
produced every hopsize
sr
s, which is the analysis period. In general, the hopsize should
be no larger than 1
4 of the DFT size, but it can be smaller to guarantee a better quality
of audio ( 1
8 is a good choice).
The full listing of a PV analysis UDO is shown in listing 14.2. This code requires
the hopsize to be an integral multiple of ksmps, to allow the shiftin opcode to
correctly copy the input samples into an array.
Listing 14.2 Phase vocoder analysis opcode
/**************************************************
kMags[],kFreqs[],kflg PVA asig,isize,ihop
kMags[] - output magnitudes
kFreqs[] - output frequencies
kflg - new frame flag (1=new frame available)
asig - input signal
308
14 Spectral Processing
isize - DFT size
ihop - hopsize
**************************************************/
opcode PVA,k[]k[]k,aii
asig,isize,ihop xin
iolaps init isize/ihop
kcnt init 0
krow init 1
kIn[] init isize
kOlph[] init isize/2 + 1
ifac = (sr/(ihop*2*$M_PI))
iscal = (2*$M_PI*ihop/isize)
kfl = 0
kIn shiftin asig
if kcnt == ihop then
kWin[] window kIn,krow*ihop
kSpec[] rfft kWin
kMags[] mags kSpec
kPha[] phs kSpec
kDelta[] = kPha - kOlph
kOlph = kPha
kk = 0
kDelta unwrap kDelta
while kk < isize/2 do
kPha[kk] = (kDelta[kk] + kk*iscal)*ifac
kk += 1
od
krow = (krow+1)%iolaps
kcnt = 0
kfl = 1
endif
xout kMags,kPha,kfl
kcnt += ksmps
endop
Analysis data can be resynthesised by applying the reverse process:
