# Chapter 13

Chapter 13
Time-Domain Processing
Abstract This chapter will discuss processing of audio signals through the use of
time-domain techniques. These act on the samples of a waveform to deliver a variety
of effects, from echoes and reverberation to pitch shifting, timbral modiﬁcation and
sound localisation. The chapter is divided into four sections dealing with the basic
methods of ﬁxed and variable delays, ﬁltering and spatial audio. Code examples are
provided implementing many of the techniques from ﬁrst principles, to provide the
reader with an insight into the details of their operation.
13.1 Introduction
The manipulation of audio signals can be done in two fundamental ways: by pro-
cessing the samples of a sound waveform, or by acting on its spectral representation
[137]. Time-domain techniques are so named because they implement the former,
working on audio as a function of time. The latter methods, which will be explored
in Chapter 14, on the other hand process sound in its frequency-domain form.
The techniques explored in this chapter can be divided into three big groups,
which are closely related. The ﬁrst one of these is based on the use of medium to
long, ﬁxed signal delays, with which we can implement various types of echo and re-
verberation, as well as timbral, effects. Then we have the short- and medium-length
variable delay processing that allows a series of pitch and colour transformations.
Finally, we have ﬁlters, which are designed to do various types of spectral modiﬁ-
cations that can be used both in timbre modiﬁcation and in spatial audio effects.
13.2 Delay Lines
Digital delay lines are simple processors that hold the samples of an audio signal
for a speciﬁed amount of time [67, 34], releasing them afterwards. Their basic func-
© Springer International Publishing Switzerland 2016 
V. Lazzarini et al., Csound, DOI 10.1007/978-3-319-45370-5_
255
13
256
13 Time-Domain Processing
tion is to introduce a time delay in the signal, which is used in a variety of audio
processing applications. They can be expressed by a simple equation:
y(t) = x(t −d)
(13.1)
where t is the time, x(t) is the input signal, y(t) is the delay line output, and d the
amount of time the signal is delayed.
Conceptually, delay lines are ﬁrst-in ﬁrst-out (FIFO) queues, whose length de-
termines the amount of delay imposed on the signal (see Fig. 13.1). Since at each
sample period, one sample is placed into the processor and another comes out, the
time it takes for a sample to traverse the delay will be
d = L× 1
sr
(13.2)
where L is the length of the delay in samples, and sr, the sampling rate.
-

total delay: L samples
in
-
- out
Fig. 13.1 Conceptual representation of a delay line as a FIFO queue, where a sample takes L
sampling periods to exit it
The conceptual idea of a sample moving from one position in the FIFO queue
to another at each sampling period is useful for us to understand the principles of a
delay line. However, it is rarely the case that any delay of more than a few samples
is actually implemented in this way. This is because it involves moving L samples
around at every sampling period, which can be very inefﬁcient.
Instead, a circular buffer algorithm is used. The idea is to keep the samples in
place, and just move the reading position along the delay line, which involves a
fraction of the computational cost. Once we read a sample, we can write to the
buffer, and move the reading position one slot ahead, and repeat the whole operation.
When we reach the end of the buffer, we wrap around to the beginning again. This
means that a sample will be held for exactly the time it takes for the reading position
to return to where the sample was written, L sampling periods later (Fig. 13.2)
To illustrate this fundamental algorithm, we can implement it as a UDO (although
it already exists as internal opcodes in the system). We will use an a-rate array as
13.2 Delay Lines
257
a circular buffer and work on a sample-by-sample basis (ksmps=1, kr=sr). This is
required because we need to access the delay line one sample at a time. The code
for this is shown in listing 13.1. The delay length is set according to equation 13.2,
making it sure it is rounded to the nearest integral value (array sizes need to be
whole numbers), checking that the minimum size is 1. The algorithm follows: read
at kpos, write to the same spot, update kpos circularly.
Listing 13.1 Circular buffer delay
opcode Delay,a,ai
setksmps 1
asig,idel xin
kpos init 0
isize = idel > 1/sr ? round(idel*sr) : 1
adelay[] init isize
xout adelay[kpos]
adelay[kpos] = asig
kpos = kpos == isize-1 ? 0 : kpos+1
endop
'
&
$
%
6
-
-
-
-
-
-
-

?
in
out
?
6
Fig. 13.2 Circular buffer delay line: samples are kept in their stored position, and the read/write
position moves along the delay line circularly (in the direction shown by the line arrows). The
current read point is L samples behind the last write
This UDO is a version of the delay opcode in Csound, which also implements
a circular buffer using a similar algorithm:
asig delay ain, idel
Csound also allows a delay line to be set with a pair of separate opcodes for
reading and writing to it:
asig delayr idel
delayw ain
258
13 Time-Domain Processing
which also implements a circular buffer as in listing 13.1. The minimum delay for
delayr and delayw is one control period (ksmps samples), whereas delay does
not have this limitation. The basic effect that can be implemented using these op-
codes as they are is a single echo. This is done by adding the delayed and original
signal together. Further echoes will require other delays to be used, or the use of
feedback, which will be discussed in the next section.
13.2.1 Feedback
A fundamental concept in signal processing is feedback,which we have already en-
countered in Chapter 12. As we recall, this involves mixing the output of the process
back into its input. Within the present scenario, this allows us to create repeated de-
lays, that will be spaced regularly by the length of the delay line. The feedback
signal needs to be scaled by a gain to prevent the system from becoming unstable;
without this the output would keep growing as the audio is inserted back into the
delay (Fig. 13.3).The expression for this process is
y(t) = x(t)+gy(t −d)
w(t) = y(t −d)
(13.3)
where x(t) is the input signal, g is the feedback gain, and y(t −d) (w(t)) is the output
after delay time d. As we can see in Fig. 13.3, there is no direct signal in the output
of the feedback delay.
in
?
i
+
feedback gain
?
i
×
-
-
delay
- out
Fig. 13.3 Delay line with feedback. Depending on the value of feedback gain, various repeated
delays will be produced
The feedback gain will need to be less than 1 to ensure stability. Depending on
its value, many repeated delays will be heard. Each time the sound is recirculated
through the delay, it will be scaled by a certain amount, so after time T, a short sound
going through a delay of length D, and fed back with gain g, will be attenuated by
A = g
T
D
(13.4)
13.2 Delay Lines
259
For instance, with a delay of 1 s, and a gain of 0.5, the repeats will die off to about
1
1000th of the original amplitude after 10 seconds. This is an important threshold,
equivalent to -60dB, which is often used to measure the reverberation time of a
system. We can also determine the feedback gain based on a desired reverberation
time Tr and D:
g =
!
1
1000
" D
Tr
(13.5)
The feedback delay processor is used in many applications. It is a fairly common
effect, which can be easily created by mixing the input signal with the feedback
path:
ay = asig + adelay[kpos]*kg
The complete UDO will have an extra parameter that can be used to set the
feedback gain. We also add a safety check to make sure the gain does not make the
system unstable (by muting the feedback completely).
Listing 13.2 Feedback delay
opcode FDelay,a,aki
setksmps 1
asig,kg,idel xin
kpos init 0
isize = idel > 1/sr ? round(idel*sr) : 1
adelay[] init isize
kg = abs(kg) < 1 ? kg : 0
ay = asig + adelay[kpos]*kg
xout adelay[kpos]
adelay[kpos] = ay
kpos = kpos == isize-1 ? 0 : kpos+1
endop
This processor is also called a comb ﬁlter. Csound implements this process in the
comb opcode:
asig comb ain,krvt,idel
where the feedback gain is controlled indirectly via a reverberation time parameter
krvt, using eq. 13.5. We can also create this feedback delay using delayr and
delayw, with a very simple code:
asig delayw
delayr ain + asig*kg
However in this case, the minimum delay is limited to one control cycle (and so is
the feedback loop), whereas the comb ﬁlter has no such limit. The name comb ﬁlter
comes from the shape of this unit’s amplitude response (Fig. 13.4) whose shape dis-
plays a series of regular peaks. These are spaced by the ﬁlter fundamental frequency,
260
13 Time-Domain Processing
which is equivalent to the inverse of its delay time, 1/D. The impulse response is a
series of decaying impulses, whose amplitude falls exponentially according to eq.
13.4. The height of the peaks is determined by the gain.
Fig. 13.4 Comb ﬁlter impulse (top) and amplitude response (bottom) for D = 0.001s and g = 0.9.
The amplitude response peaks are spaced by 1,000 Hz
A comb ﬁlter can be used for echo effects, or as a way of colouring the spectrum
of an input sound. For the latter application, shorter delay times are required, so
that the ﬁlter peaks are more closely spaced, and its fundamental frequency is in the
audio range (>20 Hz). In general, comb ﬁlters will impart some colour to the input
sound, unless the delay time is signiﬁcantly large for the amplitude response peaks
to be bunched together (which is the case in echo applications).
13.2.2 All-Pass Filters
It is possible to create a delay line processor that has a ﬂat amplitude response. This
is done by combining a feedforward and a feedback path for the signal, using the
same absolute gain value, but with opposite signs. A diagram for this arrangement
is shown in Fig. 13.5. This is called an all-pass ﬁlter, as it passes all frequencies
with no attenuation. The expression for this process is
y(t) = x(t)+gy(t −d)
w(t) = y(t −d)−gy(t)
(13.6)
13.2 Delay Lines
261
where x(n) is the input, y(t −d) is the delay line output with delay d, and w(t) is
the all-pass output. The impulse and amplitude responses for this ﬁlter are shown in
Fig. 13.6.
in
?
i
+
gain
?
i
×
-
-
delay
-
out
i
×
-
i
+
6
6
-gain
-
Fig. 13.5 All-pass ﬁlter, using a combination of feedback and feedforward delays, with gains of
opposite signs, but the same absolute value
From this, we can see how the impulse response decay differs from the comb
ﬁlter. There is an abrupt drop from the direct sound (whose polarity is reversed at the
ﬁlter output) to the ﬁrst delay; the following repetitions are much lower in amplitude
than in the comb ﬁlter case. So, for an all-pass ﬁlter such as the one discussed here,
after time T, an impulse going through a delay D and with a feedback gain g will be
attenuated by
A = (1−g2)g
T
D −1
(13.7)
In order to implement the all-pass ﬁlter, we can make some modiﬁcations to our
comb code, so that it matches the diagram in Fig. 13.5. We take the mix of the
feedback signal and input and put this into the feedforward path. The output is a
mix of this signal and the delay line output.
Listing 13.3 All-pass ﬁlter implementation
opcode allpass,a,aki
setksmps 1
asig,kg,idel xin
isize = idel > 1/sr ? int(idel*sr) : 1
adelay[] init isize
kpos init 0
ay = asig + adelay[kpos]*kg
xout adelay[kpos] - kg*ay
adelay[kpos] = ay
kpos = kpos == isize-1 ? 0 : kpos+1
endop
In Csound, an all-pass ﬁlter is provided by the alpass opcode, which has the
same parameters as the comb ﬁlter, reverb and delay time (krvt and idel):
asig alpass ain,krvt,idel
262
13 Time-Domain Processing
Like the comb ﬁlter, it is possible to implement this with delayr and delayw:
adel delayr idel
amx = ain + adel*kg
asig = adel - kg*amx
delayw amx
Fig. 13.6 All-pass ﬁlter impulse (top) and amplitude response (bottom) for D = 0.001 s and g =
0.9. The amplitude response is ﬂat throughout the spectrum
A characteristic of the all-pass ﬁlter is that, although it does not colour the sound
in its steady state, it might ‘ring’ in response to a transient in the input (e.g. a sud-
den change in amplitude). This is due to the decay characteristics of its impulse
response. The ringing will be less prominent with lower values of its gain g, when
the ﬁlter tends to decay more quickly.
13.2.3 Reverb
A fundamental application of delay lines is the implementation of reverb effects
[30, 34, 67]. These try to add an ambience to the sound by simulating reﬂections
in a given space. There are various ways of implementing reverb. One of them is
to use comb and all-pass ﬁlters, which are also known as component reverberators
to create different types of reverb effects. The classic arrangement, also known as
Schroeder reverb [115], is a number of comb ﬁlters in parallel, whose output feeds
into a series of all-pass ﬁlters. In Csound, this is used in the opcodes reverb (four
13.2 Delay Lines
263
comb + two all-pass), nreverb (six comb + ﬁve all-pass, also customisable) and
freeverb (eight comb + three all-pass for each channel in stereo).
To illustrate this design, we will develop a simple UDO that uses four comb and
two all-pass ﬁlters in the usual arrangement. The main reason for having the comb
ﬁlters in parallel is that their role is to create the overall diffuse reverb. For this we
should try not to make their delay times coincide, so that the four can create different
decaying impulse trains to make the reverb more even frequency-wise. As we have
seen, comb ﬁlters will colour the sound quite a bit, and if we make their spectral
peaks non-coincident, this can be minimised. We can achieve this by selecting delay
times that are prime numbers. They should lie within a range between 10 and 50 ms
for best effect, although we could spread them a bit more to create more artiﬁcial-
sounding results.
Another issue with standard comb ﬁlters is that they sound very bright, unlike
most natural reﬂections, which have less energy at high frequencies. This is because
while the comb ﬁlter reverb time is the same for the whole spectrum, the most
common scenario is that reverb time becomes considerably shorter as frequencies
increase. To model this, we can insert a gentle low-pass ﬁlter in the feedback signal,
which will remove the high end more quickly than the lower [93]. In order to do
this, we have to implement our own comb ﬁlter with this modiﬁcation:
opcode CombF,a,akki
asig,kg,kf,idel xin
kg = 0.001ˆ(idel/kg)
adel delayr idel
delayw asig + tone(adel*kg,kf)
xout adel
endop
The all-pass ﬁlters, in series, have a different function: they are there to thicken
each impulse from the comb ﬁlters, so that the reverberation model has enough
reﬂections. For this, they need to have a short delay time, below 10 ms and a small
reverb time, of the order of about ten times their delay. We will let the user decide
the range of comb ﬁlter delays (min, max) and then select the correct times from a
prime number list. This is done with an i-time opcode that returns an array with four
values. We also report these to the console:
opcode DelayTimes,i[],ii
imin, imax xin
ipr[] fillarray 11,13,17,19,23,
29,31,37,41,43,47,53,59,
61,67,71,73,79
idel[] init 4
imin1 = imin > imax ? imax : imin
imax1 = imax < imin ? imin : imax
imin = imin1 < 0.011 ? 11 : imin1*1000
imax = imax1 > 0.079 ? 79 : imax1*1000
idel[0] = ipr[0]
264
13 Time-Domain Processing
icnt = lenarray(ipr)-1
idel[3] = ipr[icnt]
while (idel[3] > imax) do
idel[3] = ipr[icnt]
imxcnt = icnt
icnt -= 1
od
icnt = 0
while (idel[0] <= imin) do
idel[0] = ipr[icnt]
imncnt = icnt
icnt += 1
od
isp = (imxcnt - imncnt)/3
idel[1] = ipr[round(imncnt + isp)]
idel[2] = ipr[round(imncnt + 2*isp)]
printf_i "Comb delays: %d %d %d %d (ms)\n",
1, idel[0],idel[1],idel[2],idel[3]
xout idel/1000
endop
The reverb UDO sets the four combs in parallel and the two all-pass in series. It
uses the above opcodes to implement the comb ﬁlter and delay time calculations, as
shown in listing 13.4.
Listing 13.4 The implementation of a standard reverb effect, using a combination of four comb
and two all-pass ﬁlters
/*************************************************
asig Reverb ain,krvt,kf,imin,imax
ain - input audio
krvt - reverb time
kf - low-pass frequency cutoff
imin - min comb delay time
imax - max comb delay time
*************************************************/
opcode Reverb,a,akkii
asig,krvt,kf,imin,imax xin
idel[] DelayTimes imin,imax
ac1 CombF
asig,krvt,kf,idel[0]
ac2 CombF
asig,krvt,kf,idel[1]
ac3 CombF
asig,krvt,kf,idel[2]
ac4 CombF
asig,krvt,kf,idel[3]
ap1 alpass ac1+ac2+ac3+ac4,0.07,0.007
ap2 alpass ap1,0.05,0.005
xout ap2
endop
13.2 Delay Lines
265
Feedback delay networks
Another approach to create reverb effects is to use a feedback delay network, or
FDN [120, 118]. In this, we have a set of delay lines that are cross fed according
to a given feedback matrix. This determines which signals will feed each delay line
input. For instance, consider the matrix M in eq. 13.8, and a column vector D of
four delay outputs, eq. 13.9:
M =




0 1 1
0
−1 0 0 −1
−1 0 0
1
0 1 −1 0




(13.8)
D =




y0(t −d0)
y1(t −d1)
y2(t −d2)
y3(t −d3)




(13.9)
where dn is the delay time for line n.
A four-delay FDN can then be expressed as a matrix multiplication (eq. 13.10).
It combines the delay outputs, a scalar feedback gain g and the input signal x(t):
Y = x(t)+g{M ×D}
(13.10)
The vector Y holds the inputs of the four delay lines:
Y =




y0(t)
y1(t)
y2(t)
y3(t)




(13.11)
As with the comb ﬁlter, the FDN output is taken from the delay line outputs. If
we want a stereo output, we can route each of the four outputs to different channels
in any combination:
FDN =
×
(13.12)
where O is a mix matrix for two channels. For instance, we can have
O =
!
0.75 0.5 0.5 0.25
0.25 0.5 0.5 0.75
"
(13.13)
for a basic stereo spread.
A UDO demonstrating these ideas is shown in listing 13.5, and is illustrated in
Fig. 13.7. As with the previous reverb implementation, we need to make sure reverb
times are not equal across the spectrum, so we add a ﬁlter in the feedback path of
each delay line. A delay time factor is used to make the FDN longer or shorter,
keeping all the individual delay times relative to this. The overall gain is also scaled
by
1
√
2, to keep the feedback under control.
O
D
266
13 Time-Domain Processing
d0
d1
d2
d3
LP
LP
LP
LP




M
i
×
i
×
i
×
i
×
?
g
?
g
6
g
6
g




in
6
i
+
6
i
+
6
i
+
6
i
+
-
-
-
-
-




-
-
-
-
-
-
-
O
- out L
- out R
Fig. 13.7 A feedback delay network consisting of four delay lines, and including lowpass ﬁlters in
the feedback path
Listing 13.5 A feedback delay network UDO
/********************************************
al,ar FDN asig,kg,kf,idel
al,ar - left and right outs
asig - input
kg - gain
kf - low-pass cutoff freq
idel - delay size factor
********************************************/
opcode FDN,aa,akki
aflt[] init 4
amix[] init 4
adel[] init 4
il[] fillarray .75,.5,.5,.25
ir[] fillarray .25,.5,.5,.75
idel[] fillarray 0.023,0.031,0.041,0.047
imatrix[][] init 4,4
imatrix[0][0] = 0
imatrix[0][1] = 1
imatrix[0][2] = 1
imatrix[0][3] = 0
imatrix[1][0] = -1
imatrix[1][1] = 0
imatrix[1][2] = 0
13.2 Delay Lines
267
imatrix[1][3] = -1
imatrix[2][0] = -1
imatrix[2][1] = 0
imatrix[2][2] = 0
imatrix[2][3] = 1
imatrix[3][0] = 0
imatrix[3][1] = 1
imatrix[3][2] = -1
imatrix[3][3] = 0
asig,kg,kf,id
xin
idel = idel*id
kg *= $M_SQRT1_2
ki = 0
while ki < 4 do
kj = 0
amix[ki] = asig
while kj < 4 do
amix[ki] = amix[ki]+aflt[kj]*imatrix[ki][kj]*kg
kj += 1
od
ki += 1
od
adel[0] delay amix[0],idel[0]
aflt[0] tone adel[0],kf
adel[1] delay amix[1],idel[1]
aflt[1] tone adel[1],kf
adel[2] delay amix[2],idel[2]
aflt[2] tone adel[2],kf
adel[3] delay amix[3],idel[3]
aflt[3] tone adel[3],kf
al = 0
ar = 0
kj = 0
while kj < 4 do
al += aflt[kj]*il[kj]
ar += aflt[kj]*ir[kj]
kj += 1
od
xout al, ar
endop
FDNs can be combined with other elements to make more sophisticated reverbs.
They can provide very good quality effects. In Csound, these structures are used in
the reverbsc and hrtfreverb opcodes.
268
13 Time-Domain Processing
13.2.4 Convolution
Another way of simulating reﬂections in a space can be realised through multitap
delays [67]. In this scenario, we have a single delay line with taps, or outputs at dif-
ferent positions along its length, providing smaller delay times. This can be realised
in Csound using a tap opcode such as deltap in between delayr and delayw
pairs:
asig delayr
idel
atap deltap
kdeltap
delayw ain
Any number of taps can be placed in a delay line such as this one. Each tap can
be scaled by a certain gain and added to the overall mix, to model the contribution
of that particular reﬂection. The extreme case is when we get an output at every
sample, and scale it by a given amount. This operation is called convolution [97], as
illustrated by Fig. 13.8. The scaling values for each tap are crucial here: they will
deﬁne the character of the space we want to reproduce.
in -
?
?
?
?
?
g
g
g
g
g
g
×
×
×
×
×
×






IR[0]
IR[1]
IR[2]
IR[3]
IR[4]
IR[N-1]
···
-
-
-
-
-
-
∑
- out
Fig. 13.8 Direct convolution: taps placed at each sample, scaled by each value of the impulse
response. The output is the sum of all the scaled taps
In order to model a given system, we can use these values: they are its response
to a single impulse, i.e. its impulse response (IR). This is a record of the intensity of
all the reﬂections produced by the system. We have already seen this with respect to
all-pass and comb ﬁlters, and we can use the same approach to look at real spaces.
An IR can be obtained from a recording of an impulse played in a room, and with
this, we can implement a convolution-based reverb.
Mathematically stated, this type of convolution can be written as
13.2 Delay Lines
269
x(t)∗h(t) =
N−1
∑
n=0
h(n)x(t −n)
(13.14)
where N is the length of the delay line, h(n) are the gain scalers, or the IR used, and
x(t) is the input to the delay line.
Convolution is an expensive operation, because it uses N multiplications and ad-
ditions for each output sample, where N is the IR length in samples. For this reason,
direct calculation of convolution using delay lines is only used for short IRs. A faster
implementation using spectral processing will be discussed in the next chapter. As
an illustration of the process, we present a convolution UDO in listing 13.6. This
code is for demonstration purposes only, as a faster internal opcode exists (dconv),
which is more practical to use.
Listing 13.6 UDO demonstrating the convolution operation
opcode Convolution,a,ai
setksmps 1
ain,irt xin
ilen = ftlen(irt)
acnv = 0
kk = ksmps
a1 delayr (ilen-1)/sr
while kk < ilen do
acnv += deltapn(kk)*table(kk,1)
kk += 1
od
delayw ain
xout acnv + ain*table(0,1)
endop
The UDO takes an input signal and the number of a table containing the IR.
We need to run this opcode at ksmps = 1, because the minimum delay allowed in
delayr and delayw is equivalent to one k-period ( 1
kr secs, or ksmps samples).
If we do not mind missing the ﬁrst ksmps samples of the IR, then we could run it
at lower control rates. As we can see, the process is very straightforward; we just
accumulate the output of each tap (with deltapn, which takes a delay time in
samples), and multiply by the IR read from the function table.
It is possible to design a hybrid reverb, whose ﬁrst hundred or so milliseconds are
implemented through convolution, and the rest is based on a standard algorithm or
FDN. This will use the IR for the early reﬂections, and the generic reverb for the dif-
fuse part. Often it is the character of the early reﬂections that is the most signiﬁcant
aspect of a given space, whereas the reverb tail is less distinct. This approach has
the advantage, on one hand, of being computationally more efﬁcient than using con-
volution for the whole duration of the reverberation, and on the other, of providing
a more natural feel to the effect (see listing 13.7).
270
13 Time-Domain Processing
Listing 13.7 Hybrid reverb combining convolution for early reﬂections and a standard algorithm
for diffuse reverberation
/******************************************
asig HybridVerb ain,krvt,kf,kearl,kdiff,irt
ain - input signal
krvt - reverb time
kf - lowpass cutoff factor (0-1)
kearl - level of early reflections
kdiff - level of diffuse reverb
irt - table containing an IR
********************************************/
opcode HybridVerb,a,akkkki
asig,krvt,kf,
kearl,kdiff,irf xin
kscal = 1/(kearl+kdif)
ilen = ftlen(irf)
iert = ilen/sr
arev nreverb asig,krvt,khf
acnv dconv asig,ilen,irf
afad expseg 0.001,iert,1,1,1
xout (acnv*kearl +
arev*afad*kdif)*kscal
endop
IRs for a variety of rooms, halls etc. are available for download from a number of
internet sites. These can be loaded into a function table using GEN 1. The UDO will
use the function table size to determine when the transition between convolution and
standard reverb happens. For most applications, the function table should ideally
have a length equivalent to about 100 ms.
13.3 Variable Delays
A complete class of processes can be implemented by varying the delay time over
time [31, 67]. Not only do we have a lengthening or shortening of the time between
the direct sound and the delay line output, but some important side effects occur.
The various algorithms explored in this section take advantage of these to modify
input signals in different ways.
With variable delay times we have to be careful about how the delay line is read.
The concerns here are similar to the ones in oscillator table lookup. When the delay
is ﬁxed, it is possible to round a non-integral delay time to the nearest number of
samples without major consequences. However, when we vary the delay time over
time, this is going to be problematic, esp. if the range of delay times is only a few
samples. This is because instead of a smooth change of delay time, we get a stepped
one. The quality of the output can be signiﬁcantly degraded.
13.3 Variable Delays
271
In order to avoid this problem, for variable-delay effects, we will always employ
interpolation when reading a delay line. The simplest, and least costly, method is
the linear case, which is a weighted average of the two samples around the desired
fractional delay time position. Next, there is cubic interpolation, which uses four
points. Higher-order methods are also possible for better precision, but these are
more costly. In Csound, we should also try to use audio-rate modulation sources to
vary the delay in most cases, to ensure a smooth result.
The following tap opcodes can be used with delayr and delayw for interpo-
lated reading of the delay line:
•
deltapi: linear interpolation.
•
deltap3: cubic interpolation.
•
deltapx: user-deﬁned higher-order interpolation (up to 1,024 points).
They are generally interchangeable, so any instrument design using one of them
can be modiﬁed to suit the user’s needs in terms of quality/computation load.
13.3.1 Flanger
Flanger is a classic audio effect [6], whose digital implementation employs a mod-
ulated feedback delay line [67]. The basic principle of operation is that of a comb
ﬁlter whose frequency is swept across the spectrum. From Fig. 13.4, we see that
the spacing of the peaks in the amplitude response is given by the inverse of the
delay time. A one-sample delay will work as a low-pass ﬁlter, as the peak spacing
is equivalent to sr Hz, which is beyond the frequency range (0 - sr
2 ). A two-sample
delay will have peaks at 0 and the Nyquist frequency. As the delays increase, the
peaks get closer together, and the result is a sweeping of the ﬁlter frequencies over
the spectrum.
As the spacing becomes small, the effect is diminished. For this reason, the ef-
fect is more pronounced with delays of a few milliseconds. The feedback gain de-
termines how sharp the peaks are, making the effect more present. As its value gets
closer to 1, the narrow resonances will create a pitched effect, which might dominate
the output sound. In this case, instead of a ﬁlter sweep, the result might be closer to
a glissando, as the peaks become more like the harmonics of a pulse wave.
An implementation of a ﬂanger UDO is shown in listing 13.8. It uses a sine wave
oscillator as a low-frequency oscillator (LFO), modulating the delay time between
a minimum and a maximum value. The minimum is set at 2
sr ( 1
kr , with ksmps = 2)
to allow two samples as a minimum for the cubic interpolation to work properly,
and the maximum at 10 ms, which is equivalent to a 100 Hz spacing. The ksmps
is set at 2 to allow the delay to go down to the minimum value (remembering that
delayr/delayw have a minimum delay time of one k-period). As the LFO pro-
duces a bipolar waveform (which ranges from -kwdth to +kwdth, we need to
offset and scale it, so that it is both fully positive and peaks at kwdth. Delay times
272
13 Time-Domain Processing
fm
?
width
2
?

˜
# width
2
+min
$
+i
- ?
?''

delay
''
+i
in-
-
6
×
g
i
6
- out
Fig. 13.9 A ﬂanger design using a sine wave LFO. Note that as the LFO produces a bipolar wave-
form from −width
2
to width
2
, we need to offset it to be fully positive, with the minimum at min
can never be negative. The UDO checks for the input values, making sure they are
in the correct range.
Listing 13.8 A ﬂanger UDO using a sinewave delay time modulation
/*****************************************************
asig Flanger ain,kf,kmin,kmax,kg
ain - input signal
kf - LFO modulation frequency.
kmin - min delay
kmax - max delay
kg - feedback gain
*****************************************************/
opcode Flanger,a,akkkk
setksmps 2
asig,kf,kmin,kmax,kg xin
idel = 0.01
im = 1/kr
km =
kmin < kmax ? kmin : kmax
kmx = kmax > kmin ? kmax : kmin
kmx = (kmx < idel ? kmx : idel)
km
= (km >
im ? km : im)
kwdth = kmx - km
amod oscili kwdth,kf
amod = (amod + kwdth)/2
admp delayr idel
afln deltap3
amod+km
delayw asig + afln*kg
xout afln
endop
13.3 Variable Delays
273
13.3.2 Chorus
The chorus effect works by trying to create an asynchrony between two signals, the
original and a delayed copy. To implement this, we set up a delay line whose delay
time is modulated by either a period source like the LFO or a noise generator, and
combine the delayed and original signals together (Fig. 13.10). The delay times are
higher than in the ﬂanger example, over 10 ms, but should use a modulation width
of a few milliseconds. A secondary effect is a slight period change in pitch caused
by the change in delay time (this will be explored fully in the vibrato effect). The
chorus effect does not normally include a feedback path.
fm
?
width
2
?
randi
# width
2
+min
$
+i
- ?
?''

delay
''
in-
- +i
6
- out
Fig. 13.10 A chorus UDO using a noise generator as a modulation source. As in the ﬂanger case,
we need to make sure the modulator output is in the correct delay range
Listing 13.9 A chorus UDO using a noise generator to modulate the delay time
/*****************************************************
asig Chorus ain,kf,kmin,kmax
ain - input signal
kf - noise generator frequency
kmin - min delay
kmax - max delay
*****************************************************/
opcode Chorus,a,akkk
asig,kf,kmin,kmax xin
idel = 0.1
im = 2/sr
km =
kmin < kmax ? kmin : kmax
kmx = kmax > kmin ? kmax : kmin
kmx = (kmx < idel ? kmx : idel)
km
= (km >
im ? km : im)
274
13 Time-Domain Processing
kwdth = kmx - km
amod randi kwdth,kf,2,1
amod = (amod + kwdth)/2
admp delayr idel
adel deltap3
amod+km
delayw asig
xout adel + asig
endop
The chorus implementation in listing 13.9 employs a bandlimited noise genera-
tor to create the delay time modulation. This is a good choice for vocal applications,
whereas in other uses, such as the thickening of instrumental sounds, we can use
a sine wave LFO instead. In this code, the two are interchangeable. Minimum and
maximum delays should be set at around 10 to 30 ms, with around 2 to 8 millisec-
onds difference between them. The larger this difference, the more pronounced the
pitch modulation effect will be.
13.3.3 Vibrato
The vibrato effect (Fig. 13.11) uses an important side-effect of varying the delay
time: frequency modulation (FM). FM happens because in order to create different
delay times, we need to read from the delay memory at a different pace than we
write to it. The difference in speed will cause the pitch to go up or down, depend-
ing on whether we are shortening the delay or lengthening it. We can think of this
as recording a segment of audio and reading it back at a different rate, a kind of
dynamic wavetable.
The writing speed to the delay line is always constant: it proceeds at intervals
of 1
sr s. In order to shorten the delay, the reading will have to be faster than this,
and so the pitch of the playback will rise. Conversely, to lengthen the delay, we will
need to read at a slower rate, lowering the pitch. If the rate of change of delay time
is constant, i.e. the delay gets shorter or longer at a constant pace, the speed of the
reading will be constant (higher or lower than the writing), and the pitch will be
ﬁxed higher or lower than the original. This is the case when we modulate the delay
line with a triangle or a ramp (sawtooth) waveform.
However, if the rate of change of delay line varies over time, the pitch will vary
constantly. If we modulate using a sine wave, then the read-out speed will be vari-
able, resulting in a continuous pitch oscillation. The key here is whether the ﬁrst-
order difference between the samples of a modulating waveform is constant or vary-
ing. A choice of a triangle waveform will make the pitch jump between two values,
above and below the original, as the difference is positive as the waveform rises, and
negative as it drops. With a non-linear curve such as the sine, the pitch will glide
between its maximum and minimum values.
Another important consequence of this is that if we keep the amount of modula-
tion constant, but modify its rate, the pitch change will be different. This is because,
13.3 Variable Delays
275
although we are covering the same range of delay times, the reading will proceed at
a different pace as the rate changes. So the width of vibrato will be dependent on
both the amount and rate of delay modulation.
fm
?
width
2
?

˜
# width
2
+min
$
+i
- ?
?''

delay
''
in
-
- out
Fig. 13.11 A vibrato UDO using a sine wave LFO. The output consists only of the variable delay
signal
It is interesting to consider how the vibrato width relates to the modulation rate
and amount. This will depend on the LFO waveform. The resulting frequency mod-
ulation is going to be the derivative of the delay time modulation. Let’s consider two
common cases:
1. triangle: the derivative of a triangular wave is a square wave. So for a triangular
modulator with depth ∆d seconds, and frequency fm Hz, ∆dTri( fmt), we have
∆d
∂
∂t Tri(fmt) = ∆d fmSq( fmt)
(13.15)
where Sq( ft) is a square wave with frequency f. Thus, the frequency will jump
between two values, f0(1 ± ∆d fm), where f0 is the original input sound fre-
quency. For instance, if we have an LFO running with fm = 2 Hz, by modulating
the delay between 0.1 and 0.35 s (∆d = 0.25), the pitch will alternate between
two values, 0.5 f0 and 1.5f0.
2. cosine: the derivative of a cosine is a sine. So, if we consider the modulation
by 0.5cos(2π fmt) (remembering that we have scaled it to ﬁt the correct delay
range), we have
∆d
∂
∂t 0.5cos(2π fmt) = −∆dπ fm sin(2π fmt)
(13.16)
In this case the frequency will vary in the range f0(1±∆dπ fm).
With these principles in mind, it is possible to consider the frequency modulation
effects of a delay line. Note that it is also possible to set fm to the audio range, for
276
13 Time-Domain Processing
a variety of interesting effects on arbitrary input sounds. This technique is called
Adaptive FM [76].
Listing 13.10 A vibrato UDO with an optional choice of function table for LFO modulation
/*****************************************************
asig Vibrato
ain,kf,kmin,kmax[,ifn]
ain - input signal
kf - LFO modulation frequency.
kmin - min delay
kmax - max delay
ifn - LFO function table, defaults to sine
*****************************************************/
opcode Vibrato,a,akkkj
asig,kf,kmin,kmax,ifn xin
idel = 0.1
im = 2/sr
km =
kmin < kmax ? kmin : kmax
kmx = kmax > kmin ? kmax : kmin
kmx = (kmx < idel ? kmx : idel)
km
= (km >
im ? km : im)
kwdth = kmx - km
amod oscili kwdth,kf,ifn
amod = (amod + kwdth)/2
admp delayr idel
adel deltap3
amod+km
delayw asig
xout adel
endop
The vibrato UDO in listing 13.10 implements an optional use of various func-
tion tables for its LFO. Vibrato and chorus are very similar in implementation. In