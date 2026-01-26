# 5. For a variable-speed source, use a non-linear function to change the delay time;

5. For a variable-speed source, use a non-linear function to change the delay time;
for ﬁxed speed, use a linear envelope.
The code in listing 13.11 implements a Doppler shift UDO using the ideas dis-
cussed above. It takes a distance in meters, and models the movement of the source
according to this parameter, via a delay line change in position and amplitude atten-
uation.
278
13 Time-Domain Processing
Listing 13.11 A Doppler shift UDO, which models the movement of a source according to its
distance in meters
/*****************************************************
asig Doppler ain,kpos,imax
ain - input signal
kpos - absolute source distance in meters
imax - maximum source distance
*****************************************************/
opcode Doppler,a,aki
asig,kp,imax xin
ic = 344
admp delayr
imax/ic
adop deltap3 a(kp)/ic
kscal = kp > 1 ? 1/kp : 1
delayw asig*kscal
xout adop
endop
13.3.5 Pitch Shifter
The triangle-wave vibrato effect discussed in Section 13.3.3, which creates alter-
nating steady pitch jumps, and indeed the constant-speed doppler effect, suggest
that we might be able to implement a pitch shift effect using similar principles. The
problem to solve here is how to create a continuously increasing or decreasing de-
lay beyond the range of the delay times available to us. If we could somehow jump
smoothly from a maximum delay to a minimum delay (and vice versa), then we
could just circularly move around the delay line, as if it were a function table.
The problem with this jump is that there is an abrupt discontinuity in the wave-
form as we move from one end of the delay to the other. We can use an envelope to
hide this transition, but, alone, that would create an amplitude modulation effect. To
avoid this, we can use two delay line taps, spaced by 1
2 delay length, so that when
one tap is at the zero point of the envelope, the other is at its maximum. Some mod-
ulation artefacts might still arise from the phase differences of the two taps, but we
can try to minimise these later.
So, for the pitch shifter effect to work, we need to modulate the delay line with a
sawtooth wave, rather than a triangle (we want the pitch to change in just one direc-
tion). The straight line of the sawtooth wave will have a constant derivative (except
at the transition), which will give us a constant pitch change. As we saw earlier, the
amount of pitch change is dependent on the modulation width and frequency. If we
want to effect a pitch shift p in a signal with frequency f0, we can ﬁnd the sawtooth
wave modulation frequency fm using what we learned from eq. 13.15. According to
that, the upwards pitch change pf0 is equivalent to
13.3 Variable Delays
279
pf0 = f0(1+∆d fm)
(13.20)
We can then determine the fm required for a given pitch shift factor p and delay
modulation width ∆d as
fm = p−1
∆d
(13.21)
The pitch shifter effect then is just a matter of using two phase-offset sawtooth
waves with frequency set to fm, which modulate two taps of a delay line. In syn-
chrony with this modulation, we need to use an envelope that will cut out the wrap-
around jumps. This can be done with two triangle waves that are run in phase with
each modulator.
A Csound UDO implementing these ideas is shown in listing 13.12. As modu-
lators, it employs two phasor opcodes, offset by 0.5 period. Since these produce
an up-ramp (inverted) sawtooth, we ran them with negative frequency to produce
a down-ramp signal, which will scale the input signal frequency upwards (as the
delay time gets shorter). If the pitch shift requested is below 1, then the sawtooth
frequency will be positive and the shift will be downwards.
Listing 13.12 A pitch shifter UDO using two sawtooth modulators controlling two taps that will
be offset by 1
2 delay length
/*****************************************************
asig PitchShifter ain,kp,kdel,ifn[,imax]
ain - input signal
kp - pitch shift factor (interval ratio)
kdel - delay mod width
ifn - window (envelope) to cut discontinuities
imax - optional max delay (defaults to 1 sec)
*****************************************************/
opcode PitchShifter,a,akkip
asig,kp,kdel,ifn,imax xin
kfm = (kp-1)/kdel
amd1 phasor -kfm
amd2 phasor -kfm,0.5
admp delayr imax
atp1 deltap3 amd1*kdel
atp2 deltap3 amd2*kdel
delayw asig
xout atp1*tablei:a(amd1,ifn,1) +
atp2*tablei:a(amd2,ifn,1)
endop
The table for the pitch shifter window can be built with a triangle window (using
GEN 20):
ifn ftgen 1,0,16384,20,3
280
13 Time-Domain Processing
Finally, this pitch-shifting algorithm is prone to amplitude modulation artefacts
due to the combination of the two taps, which in certain situations can be very
noticeably out of phase. To minimise this, it is possible to pitch track the signal and
use this to control the delay modulation width. If we set this to twice the fundamental
period of the input sound, then geerally the taps will be phase aligned. Of course,
if the input sound does not have a pitch that can be tracked, this will not work.
However, in this case, phase misalignment will not play a signiﬁcant part in the
process. The following instrument example shows how this can be set up to create a
vocal/instrument harmoniser, which tracks fundamentals in the range of 100 to 600
Hz to control the delay width. The pitch is pegged at this range and we use a port
opcode to smooth the ﬂuctuations, avoiding any undue modulation.
instr 1
ain inch 1
kf, ka pitchamdf ain,100,600
kf = kf < 100 ? 100 : (kf > 600 ? 600 : kf)
kdel = 2/kf
kdel port kdel, 0.01, 0.1
asig PitchShifter ain,1.5,kdel,1
outs asig+ain,asig+ain
endin
schedule(1,0,-1)
13.4 Filters
We have already introduced the main characteristics and applications of ﬁlters in
source-modiﬁer synthesis (Chapter 12). In this section, we will explore some in-
ternal aspects of ﬁlter implementation, and the use of these processors in sound
transformation.
Filters also depend on delay lines for their operation. In fact, we can describe all
of the operations in Sections 13.2 and 13.3 in terms of some sort of ﬁltering. The
comb and all-pass delay processors, for instance, are inﬁnite impulse response (IIR)
ﬁlters, whereas the convolution reverb is a ﬁnite impulse response (FIR) ﬁlter. These
are all high-order ﬁlters, employing long delays. In this section, we will start by
looking at ﬁlters using one or two sample delays, with feedback, and then consider
feedforward ﬁlters based on longer impulse responses.
13.4.1 Design Example: a Second-Order All-Pass Filter
As an example of how we can implement a ﬁlter in Csound, we will look at a second-
order all-pass [90]. This design is used in the construction of a phase shifter, which
13.4 Filters
281
will be our ﬁnal destination. This effect works by combining a signal with another
whose phase has been modiﬁed non-linearly across the spectrum. The result is a
cancellation of certain frequencies that are out of phase.
An all-pass ﬁlter, as seen before, has the characteristic of having a ﬂat amplitude
response, i.e. passing all frequencies with no modiﬁcation. Some of these ﬁlters also
have the effect of changing the phase of a signal non-linearly across the spectrum.
This is the case of the second-order IIR all-pass, which we will implement here. In
its output, some frequencies can have up to half a cycle (180o, or π radians) phase
shift in relation to the input sound.
As we have seen before, a second-order ﬁlter uses up to two samples of delay.
Also, as in the case of the high-order all-pass, we will combine a feedback signal
path with a feedforward one. The expression is very similar in form:
w(t) = x(t)+a1w(t −1)−a2w(t −2)
y(t) = w(t)−b1w(t −1)+b2w(t −2)
(13.22)
where a1 and a2 are the gains associated with the feedback path of the one- and two-
sample delays, and b1 and b2 are feedforward gains. Another term used for these is
ﬁlter coefﬁcients. Equation 13.22 is called a ﬁlter equation.
To make the ﬁlter all-pass, we have to balance these gain values to make the
feedforward section cancel out the feedback one. For instance, we set b2 as the
reciprocal (inverse) of a2. The a1 and b1 coefﬁcients will be used to tune the ﬁlter to
a certain frequency. We can set all of these according to two common parameters:
bandwidth and centre frequency. The former will determine how wide the phase
shift region is, and the latter determines its centre. For bandwidth B and frequency
fc, the four coefﬁcients of the all-pass ﬁlter will be
R = exp
!−πB
sr
"
a1 = 2Rcos
!2π fc
sr
"
a2 = R2
b1 = R
2 cos
!2π fc
sr
"
b2 = 1
a2
(13.23)
A plot of the phase response of this ﬁlter is shown in Fig. 13.12, using bandwidth
B = 500 Hz and centre frequency fc = 5,000 Hz. It is possible to see that at the
centre frequency the phase is shifted by π radians, or half a cycle.
We can implement this ﬁlter as a UDO using the expressions in eqs.13.22
and 13.23. The opcode will take the centre frequency and bandwidth as control-rate
282
13 Time-Domain Processing
Fig. 13.12 second-order all-pass ﬁlter phase response, with bandwidth B = 500 Hz and centre
frequency fc = 5,000 Hz
arguments. The processing has to be done on a sample-by-sample basis because of
the minimum one-sample delay requirement.
Listing 13.13 2nd-order all-pass ﬁlter UDO with variable centre frequency and bandwidth
/*****************************************************
asig AP ain,kfr,kbw
ain - input signal
kfr - centre frequency
kbw - bandwitdth
*****************************************************/
opcode AP,a,akk
setksmps 1
asig,kfr,kbw
xin
ad[] init 2
kR = exp(-$M_PI*kbw/sr)
kw = 2*cos(kfr*2*$M_PI/sr)
kR2 = kR*kR
aw = asig + kR*kw*ad[0] - kR2*ad[1]
ay = aw - (kw/kR)*ad[0] + (1/kR2)*ad[1]
ad[1] = ad[0]
ad[0] = aw
xout ay
endop
With this all-pass ﬁlter we can build a phase shifter. The idea is to combine
the output of the ﬁlter with the original signal so that phase differences will create
a dip in the spectrum, then modulate the centre frequency to produce a sweeping
effect. One second-order all-pass can create a single band-rejecting region. For fur-
ther ones, we can use more all-pass ﬁlters in series, tuning each one to a different
frequency. In the design here, we will use three ﬁlters, so creating a sixth-order all-
pass, with three dips in the spectrum. We will space the ﬁlters so that the second
13.4 Filters
283
and third ﬁlters are centred at twice and four times the ﬁrst frequency. When we
combine these and the original signal, the overall effect is not all-pass anymore. In
Fig. 13.13, we see a plot of the resulting phase and amplitude responses of the phase
shifter, with frequencies centred at 1,000, 2,000 and 4,000 Hz, and bandwidths of
100, 200 and 400 Hz, respectively.
Fig. 13.13 sixth-order phase shifter phase (top) and amplitude (bottom) response, with frequencies
centred at 1,000, 2,000 and 4,000 Hz, and bandwidths of 100, 200 and 400 Hz, respectively
A UDO implementing these ideas is shown in listing 13.14. It uses an LFO to
modulate the ﬁlter centre frequencies, whose range is set between a minimum and
a maximum (pegged at 0 and sr/2, respectively). By changing these, it is possible
to control modulation depth. The phaser also features a Q control that makes the
bandwidths relative to the centre frequencies.
Listing 13.14 Sixth-order phase shifter with LFO modulation, and user-deﬁned frequency ranges
and Q
/*****************************************************
asig Phaser ain,kfr,kmin,kmax,kQ
ain - input signal
kfr - LFO frequency
kmin - minimum centre frequency
kmax - maximum centre frequency
kQ - filter Q (cf/bw)
*****************************************************/
opcode Phaser,a,akkkk
as,kfr,kmin,kmax,kQ xin
km =
kmin < kmax ? kmin : kmax
284
13 Time-Domain Processing
kmx = kmax > kmin ? kmax : kmin
km = km > 0 ? km : 0
kmx = kmx < sr/2 ? kmx : sr/2
kwdth = kmax/4 - km
kmd oscili kwdth,kfr
kmd = km + (kmd + kwdth)/2
as1 AP as,kmd,kmd/kQ
as2 AP as1,kmd*2,kmd*2/kQ
as3 AP as2,kmd*4,kmd*4/kQ
xout as3+as
endop
A number of variations are possible, by setting a different centre frequency spac-
ing, using more all-pass ﬁlters in the cascade connection, and decoupling the band-
widths and frequencies. As with the other variable delay line algorithms discussed
earlier, considerable variation exists between different implementations offered by
effects processors.
13.4.2 Equalisation
Equalisation is another typical application of ﬁlters for sound processing. Equaliser
ﬁlters tend to be slightly different from the standard types we have seen. They are of-
ten designed to boost or cut one particular band without modifying others, whereas
an ordinary band-pass ﬁlter generally has an effect across all of the spectrum. In
Csound, a good equaliser is found in the eqfil opcodes, which is based on a well-
known design by Regalia and Mitra [106]. This ﬁlter has a characteristic response
that can be shaped to have a peak or a notch at its centre:
asig eqfil ain, kcf, kbw, kgain
Its arguments are self-explanatory: kcf is the centre frequency, kbw, the band-
width. The gain parameter kgain makes the ﬁlter boost or cut a given band of
frequencies. Its amplitude response will be ﬂat for kgain = 1. If kgain ¿ 1, a
peak will appear at the centre frequency, with bandwitdh set by kbw. Outside this
band, the response will be ﬂat. A notch can be created with a gain smaller than one.
Listing 13.15 shows a graphic equaliser UDO based on a number of eqfil
ﬁlters arranged in series. It uses recursion to determine the number of bands dynam-
ically. The number of these is taken from the size of a function table containing the
gain values for each band. Bands are exponentially spaced in the spectrum, between
a minimum and a maximum frequency. This will separate the ﬁlters by an equal
musical interval. A Q value is also provided as an argument.
Listing 13.15 A graphic equaliser with a user-deﬁned number of bands. The number of gain values
in a function table determines the number of ﬁlters
/*****************************************************
13.4 Filters
285
asig Equaliser ain,kmin,kmax,kQ,ifn
ain - input signal
kmin - minimum filter frequency
kmax - maximum filter frequency
kQ - filter Q (cf/bw)
ifn - function table containing the filter gains
*****************************************************/
opcode Equaliser,a,akkkio
asig,kmin,kmax,
kQ,ifn,icnt xin
iend = ftlen(ifn)
if icnt < iend-1 then
asig Equaliser asig,kmin,kmax,
kQ,ifn,icnt+1
endif
print icnt
kf = kmin*(kmax/kmin)ˆ(icnt/(iend-1))
xout eqfil(asig,kf,
kf/kQ,table:k(icnt,ifn))
endop
13.4.3 FIR Filters
So far we have not discussed FIR ﬁlters in detail, as these are not as widely employed
in music synthesis and processing as IIR ones. However, there are some interesting
applications for these ﬁlters. For instance, we can use them to block out some parts
of the spectrum very effectively. In this section, we will look at how we can build
FIR ﬁlters from a given amplitude response curve. Generally speaking, these ﬁlters
need to be much longer (i.e. higher order) than feedback types to have a decisive
effect on the input sound. Another difﬁculty is that feedforward ﬁlters are not easily
transformed into time-varying forms, because of the way they are designed.
FIR ﬁlters can be described by the following equation:
y(t) = a0x(t)+a1x(t −1)+...+aN−1x(t −(N −1))
=
N−1
∑
n=0
anx(t −n)
(13.24)
where, as before, y(t) is the ﬁlter output, x(t) is the input and x(t −n) is the input
delayed by n samples. Each delay coefﬁcient an can be considered a sample of an
impulse response that describes the ﬁlter (compare, for instance, eq. 13.24 with eq.
13.14):
286
13 Time-Domain Processing
h(n) = {a0,a1,...,aN−1}
(13.25)
So, effectively, an FIR is a delay line tapped at each sample, with the coefﬁcients
associated with each delay point equivalent to its IR. Thus we can implement a feed-
forward ﬁlter as the convolution of an input signal with a certain specially created
IR.
Designing FIR ﬁlters can be a complex art, especially if we are looking to min-
imise the IR length, while approaching a certain amplitude and phase response [88].
However, it is possible to create ﬁlters with more generic forms by following some
simple steps. The fundamental principle behind FIR design is that we can obtain
its coefﬁcients (or its IR) from a given amplitude response via an inverse discrete
Fourier transform (IDFT). Thus, we can draw a certain desired spectral curve, and
from this we make a frequency response, which can be transformed into an IR for
a convolution operation. The theory behind this is explored in more detail in sec-
tion 14.2.
The ﬁlter design process can be outlined as follows:
