# Chapter 16

Chapter 16
Physical Models
Abstract This chapter will introduce the area of physical modelling synthesis,
which has attracted much interest recently. It will discuss the basic ways which can
be used to model and simulate the sound-producing parts of different instruments.
It begins with an introduction to waveguides, showing how these can be constructed
with delay lines. It then discusses modal synthesis, which is another approach that
is based on simulating resonances that exist in sound-producing objects. Finally, it
presents an overview of ﬁnite difference methods, which can produce very realistic
results, but with considerable computational costs.
16.1 Introduction
Humans have been making and playing musical instruments for thousands of years,
and have developed ways of controlling the sounds they make. One of the problems
in computer-realised instruments is the lack of knowledge of how they behave, and
in particular how the control parameters interact. This leads to the idea of mimicking
the physical instrument, so we may understand the controls, but of course takes
the model beyond possible reality, for example by having unreasonable ranges or
impossible sizes or materials.
Thus we have collections of sounds derived from or inspired by physical arte-
facts. Within this category there are a wide variety of levels of accuracy and speed.
Here we explore separately models based on waveguides, detailed mathematical
modelling and models inspired by physics but approximated for speed.
16.2 Waveguides
It is well known that sound travelling in a perfect medium is governed by the wave
equation; in one spatial dimension that is ∂2u
∂t2 = c2 ∂2u
∂x2 . This equation actually has a
© Springer International Publishing Switzerland 2016 
V. Lazzarini et al., Csound, DOI 10.1007/978-3-319-45370-5_
385
16
386
16 Physical Models
simple solution. It is easy to see that f(x−ct) is a solution, for an arbitrary function
f. Similarly g(x + ct) is a solution. Putting these together we see that f(x −ct) +
g(x+ct) is a very general solution.
In order to interpret this let us concentrate on the f function. As time increases
the shape will stay the same, but moved forward in space, with the constant c being
the speed of movement. Considering the case of a perfect string, this corresponds to
a wave travelling in the positive direction. It is easy to see that the g component is
also a wave travelling in the negative direction. It is this solution and interpretation
that give rise to the waveguide concept.
16.2.1 Simple Plucked String
If we consider a ﬁnite string held at both ends, such as is found in physical string
instruments, we can apply the waveguide idea directly. It is simplest to consider
a plucked string, so the initial shape of the string is a triangle divided equally be-
tween the functions f and g. On releasing the pluck the triangle will move in both
directions. To continue the model we need to know what happens at the held ends.
Experimentation shows that the displacement is inverted and reﬂected, so the wave
travels back. But realistically some of the energy is lost, and converted into the
sound we wish to hear. A simple model for this loss in a low-pass ﬁlter, such as
an averaging one yn = (xn + xn−1)/2, which can be placed at one end of the string
(see also Section 12.2.2 for an analysis of this particular ﬁlter). To listen we take
a point on the string and copy the displacement value to the output. If we use two
simple delay lines to model the left- and right-moving waves we obtain a diagram
like Fig. 16.1.
6


-
?


?
loss

−1

×
×
−1


h
h
h
h
h
h
h
h
h
h
h

h
h
h
h
h
h
h
h
h
h
h
?
6


+
- output
Fig. 16.1 Diagram of a simple pluck model
But what pitch does this produce? That can be calculated by considering the
history of an initial impulse in one of the delay lines. If the delay in each line is
N samples it will take 2N samples, plus any delay incurred in the loss ﬁlter. In the
16.2 Waveguides
387
case of a simple averaging ﬁlter the group delay is half a sample, so we can play
pitches at sr/(2N+0.5) Hz. For low frequencies the errors are small, a 50 Hz target
and CD quality sampling rate we can choose 49.97 Hz or 50.09 Hz with the delay
lines 441 or 440 long. But for higher frequencies the error is very great; at 2,000 Hz
we need to chose between 1,960 and 2,151 Hz. This can be solved by introducing
another all-pass ﬁlter into the signal path which can have an adjustable delay to
tune it accurately. Generally speaking the parameters of the model are the delay line
lengths, the initial pluck shape, the loss and tuning ﬁlters, and the location of the
reading to the delay lines for the output.
It is possible to encode all this within Csound, using opcodes delayr and
delayw, and ﬁlter opcodes.
Listing 16.1 Simple waveguide string model
<CsoundSynthesizer>
<CsInstruments>
/**********************
asig String kamp,ifun,ils,ipos,ipk
kamp - amplitude
ifun - fundamental freq
ils - loss factor
ipos - pluck position
ipk - pickup position
********************/
opcode String,a,kiii
setksmps 1
kamp,ifun,ipos,ipk xin
ain1 init 0
ain2 init 0
idel = 1/(2*ifun)
kcnt line 0, p3, p3
if kcnt < idel then
ainit1 linseg
0,idel*ipos, 1, idel*(1-ipos),0
ainit2 linseg
0,idel*(1-ipos),-1, idel*ipos,0
else
ainit1=0
ainit2=0
endif
awg1 delayr idel
apick1 deltap idel*(1-ipk)
delayw
ain1+ainit1
awg2 delayr idel
apick2 deltap idel*ipk
delayw
ain2+ainit2
ain1 = (-awg2 + delay1(-awg2))*0.5
ain2 = -awg1
388
16 Physical Models
xout (apick1+apick2)*kamp
endop
instr 1
asig String p4,p5,0.3,0.05
out asig
endin
</CsInstruments>
<CsScore>
i1 0 1 10000 220
i1 + 1 10000 440
i1 + 1 10000 330
i1 + 1 10000 275
i1 + 1 10000 220
</CsScore>
</CsoundSynthesizer>
However there are a number of packaged opcodes that provide variants on the theme.
The pluck opcode implements a much simpliﬁed model, the Karplus and Strong
model, with one delay and random (white noise) initial state [57]. Fuller implemen-
tations can be found in the opcodes wgpluck and wgpluck2, which use slightly
different ﬁlters and tuning schemes.
It should be noted what these models do not provide: in particular instrument
body, sympathetic string vibration and vibration angle of the string. Body effects
can be simulated by adding one of the reverberation methods to the output sound. A
limited amount of sympathetic sound is provided by repluck, which includes an
audio excitement signal, and streson, which models a string as a resonator with
no initial pluck.
A mandolin has pairs of strings which will be at slightly different pitches; the
waveguide model can be extended to this case as well, as in opcode mandol.
Closely related to plucked strings are bowed strings, which use the same model
except the bow inserts a sequence of small plucks to insert energy into the string.
Csound offers the opcode wgbow for this. There are additional controls such as
where on the string the bowing happens, or equivalently where in the delay line to
insert the plucks, and how hard to press and move the bow, which is the same as
controlling the mini-plucks.
Tuning
As discussed above, the waveguide model can only be tuned to speciﬁc frequencies
at sr/(2N+0.50) Hz, where N is the length in samples of each delay line. In order to
allow a fractional delay to be set for ﬁne-tuning of the model, we can add an all-pass
ﬁlter to the feedback loop. As discussed in Chapter 13, these processors only affect
the timing (phase) of signals, and leave their amplitude unchanged. With a simple
16.2 Waveguides
389
ﬁrst-order all-pass ﬁlter, we can add an extra delay of less than one sample, so that
the waveguide fundamental has the correct pitch.
The form of this all-pass ﬁlter is
y(t) = c(x(t)−y(t −1))+x(t −1)
(16.1)
where x(t) is the input, y(t −1) and x(t −1) are the input and output delayed by one
sample, respectively. The coefﬁcient c is determined from the amount of fractional
delay d (0 < d < 1) required:
c = 1−d
1+d
(16.2)
The total delay in samples will then be Nwdelay + 0.5 + d, where Nwdelay is the
total waveguide delay length. To ﬁne-tune the model, we need to