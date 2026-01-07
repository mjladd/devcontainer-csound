# 3. The spectrum of an input signal can also be obtained with the DFT.

3. The spectrum of an input signal can also be obtained with the DFT.
So, the operation can be implemented by analysing a signal and an IR using the
DFT, multiplying them together, and transforming back the result using the IDFT
304
14 Spectral Processing
(Fig. 14.8). Since the transforms can be implemented with fast algorithms, for large
IR sizes it is more efﬁcient to use this method. The major difﬁculty to overcome is
that in order to do this, we need to have the complete input signal before we could
take its DFT. This is not practical for streaming and real-time applications, where
the signal is available only on a sample-by-sample basis. It means we need to wait
for the complete input signal to ﬁnish before we are able to hear the convolution,
which also means an unacceptable latency between input and output.
input
?
DFT
?
IR
?
DFT
i
×?

IDFT
?
Fig. 14.8 Fast convolution: multiplication in the frequency domain is equivalent to convolution in
the time domain
A solution is to slice the input signal to match the size of the IR, and take a
sequence of DFTs, then overlap-add the result. This works well for arbitrary input
sizes, so the operation can be performed in a streaming fashion. However, depending
on the size of the IR, audible latency will remain. We can minimise this by further
slicing both the input signal and the IR into a smaller size, applying a slightly dif-
ferent algorithm to reconstruct the output, called partitioned convolution.
In this case, we will need to balance the need for lower latency with the com-
putational load, as smaller partitions are slower to calculate. Effectively this works
as an in-between solution in that the larger the partitions, the closer we are to a full
DFT-based fast convolution, and the smaller, the closer to a direct method (which
would be equivalent to a partition size of one sample).
In Csound, the ftconv is a drop-in fast partitioned convolution replacement for
dconv, in that, similarly, it reads an IR from a function table. We can set the parti-
tion size, which will determine the amount of initial delay. This opcode can deal in
real time with much larger IRs than dconv, and it can be used to implement, for in-
stance, convolution reverbs. Another alternative which takes an IR from a soundﬁle
is pconvolve.
In fact, we can do much better by combining these two opcodes, ftconv and
dconv. It is possible to completely avoid the DFT latency by using direct convolu-
tion to cover the ﬁrst partition, then do the rest with the fast method [45]. To make
this work, we have to split the IR into two segments: one containing the ﬁrst P sam-
ples, where P is the partition size, and another segment with the remaining samples.
Once this is done, we use dconv with the ﬁrst part, and ftconv with the second,
and mix the two signals.
14.3 Fast Convolution
305
This can be further enhanced by having multiple partition sizes, starting with a
small partition, whose ﬁrst block is calculated with direct convolution, and growing
towards the tail of the IR, using the DFT method. An example with three partitions
is shown in Fig. 14.9, where the N-sample IR is segmented into sections with 128,
896 and N −1,024 samples each. The ﬁrst section is always calculated with di-
rect convolution (partition size = 1), followed in this case by a segment with seven
partitions of 128 samples, and the rest using 1024-sample blocks.
IR segments
partition sizes
1
128
-

128
896
-

1024
N −1024
-

...
...
Fig. 14.9 Multiple-partition fast convolution, three partitions with sizes 1, 128, and 1,024. The
N-sample IR is segmented into three sections, with 128, 896 and N −1,024 samples each. In this
case, the ﬁrst partition size is 128 and the partition growth ratio is 8
The following example in listing 14.1 implements this scheme. It takes the ﬁrst
partition size ipart, a partition growth ratio irat and the total number of partition
sizes inp. Each new partition size will be irat times the previous size. The audio
signal is then processed ﬁrst with direct and then with fast convolution to produce a
zero-latency output, very efﬁciently. The size, number and ratio of partitions can be
adjusted to obtain the best performance.
Listing 14.1 Convolution UDO using a combination of direct and fast methods, with multiple
partition sizes
/**************************************************
asig ZConv ain,ipart,irat,inp,ifn
ain - input signal
ipart - first partition size in samples
irat - partition ratio
inp - total number of partition sizes
ifn - function table number containing the IR
**************************************************/
opcode ZConv,a,aiiiio
asig,iprt,irat,inp,ifn,icnt xin
if icnt < inp-1 then
acn ZConv asig,iprt,irat,inp,ifn,icnt+1
endif
if icnt == 0 then
a1 dconv asig,iprt,ifn
elseif icnt < inp-1 then
ipt = iprt*iratˆ(icnt-1)
306
14 Spectral Processing
isiz = ipt*(irat-1)
a1 ftconv asig,ifn,ipt,ipt,isiz
else
ipt = iprt*iratˆ(icnt-1)
a1 ftconv asig,ifn,ipt,ipt
endif
xout a1 + acn
endop
14.4 The Phase Vocoder
The DFT is a single-shot analysis. If we step it over time, and take a sequence of
regular transform frames, we can start to capture aspects of time-varying spectra that
cannot be manipulated with just one window. This analysis is also called the short-
time Fourier transform (STFT). Furthermore, we will be able to compare analysis
data from successive frames to determine the time-varying frequency of each signal
component. This is the basis for a practical implementation of the phase vocoder
(PV) algorithm [42, 35].
The DFT can provide us with the magnitudes and phases of each analysis point
(bin), via the expressions in eq. 14.2. However, this does not tell us directly what the
actual frequencies of each component are, except in the trivial case where these are
exact multiples of the fundamental analysis frequency. So we need to do more work.
The key to this is to know that frequency is the time derivative of the phase. This
can be translated to differences between phases from two successive DFT analysis
frames.
The PV analysis algorithm transforms an audio signal into amplitude and fre-
quency signals, and these can be converted back into the time domain through PV
synthesis (Fig. 14.10). The analysis output consists of N
2 +1 bins (bands, where N is
the DFT size), each with an amplitude-frequency pair at each time point of the anal-
ysis. These can be spaced by one or, more commonly, several samples. The spacing
between each pair of time positions is called the analysis hopsize. PV bins will have
a constant bandwidth, equivalent to sr
N Hz. They will be centred at 0, sr
N ,2 sr
N ,..., sr
2
Hz.
audio
signal
-
analysis
-

synthesis

amplitudes
+
frequencies
Fig. 14.10 Phase vocoder analysis and synthesis, which transform audio signals into their con-
stituent amplitudes and frequencies and vice versa
14.4 The Phase Vocoder
307
The PV analysis algorithm can be outlined as follows [64]: