# 3. Insert the all-pass ﬁlter into the model, using the coefﬁcient c as above.

3. Insert the all-pass ﬁlter into the model, using the coefﬁcient c as above.
Finally, when we come to implement this, it is easier to aggregate the two delay
lines used in the waveguide into one single block, removing the explicit reﬂection
at one end. Because the reﬂections cancel each other, we should also remove the
other one in the feedback loop. We can still initialise and read from the delay line
as before, but now taking account of this end-to-end joining of the two travelling
directions. By doing this, we can manipulate its size more easily. Also, with a single
delay line, we do not require sample-by-sample processing (ksmps=1), although we
will need to make sure that the minimum delay required is not less than the orchestra
ksmps.
A ﬁne-tuned version of the String UDO is shown below. It uses the Ap UDO,
which implements the all-pass tuning ﬁlter.
Listing 16.2 String model with an all-pass tuning ﬁlter
/**********************
asig Ap ain,ic
ain - input signal
ic - all-pass coefficient
********************/
opcode Ap,a,ai
setksmps 1
asig,ic xin
390
16 Physical Models
aap init 0
aap = ic*(asig - aap) + delay1(asig)
xout aap
endop
/**********************
asig String kamp,ifun,ils,ipos,ipk
kamp - amplitude
ifun - fundamental freq
ils - loss factor
ipos - pluck position
ipk - pickup position
********************/
opcode String,a,kiii
kamp,ifun,ipos,ipk xin
aap init 0
idel = 1/ifun
ides = sr*idel
idtt = int(ides-0.5)
ifrc = ides - (idtt + 0.5)
ic = (1-ifrc)/(1+ifrc)
kcnt line 0, p3, p3
if kcnt < idel then
ainit linseg 0,ipos*idel/2,-1,
(1-ipos)*idel,1,
ipos*idel/2,0
else
ainit=0
endif
awg delayr idtt/sr
apick1 deltap idel*(1-ipk)
apick2 deltap idel*ipk
afdb = Ap((awg + delay1(awg))*0.5, ic)
delayw
afdb+ainit
xout (apick1+apick2)*kamp
endop
16.2.2 Wind Instruments
Blowing into a cylindrical tube is in many ways similar to the string model above.
In this case, there is a pressure wave and an associated displacement of air, but the
governing equation and general solution is the same. The main difference is at the
ends of the tube. At a closed end the displacement wave just reverses its direction
16.2 Waveguides
391
with the same negation of the string. The open end is actually very similar to the
string case as the atmosphere outside the tube is massive and the wave is reﬂected
back up the tube without the negation, although with energy loss.
The other component is the insertion of pressure into the tube from some reed,
ﬁpple or mouthpiece. Modelling this differentiates the main class of instrument. A
basic design is shown in Fig. 16.2, where a reed input for a clarinet is depicted, with
a waveguide consisting of one open and one closed end. In this case, because of the
mixed boundaries, the fundamental frequency will be one octave lower compared to
an equivalent string waveguide.
6


×
6
 −1
-
-
?
loss

air
pressure
- reed
output
Fig. 16.2 Diagram of a simple wind instrument
Examples of cylindrical tubular instruments include ﬂutes, clarinets and trum-
pets. To complete these instruments we need to consider the action of blowing.
The simplest model is a single reed as used in a clarinet. A reed opens by bending
away from the rest position under pressure from the breath, mitigated by the pressure
in the tube. The exact way in which this happens is non-linear and depends on the
reed stiffness. A sufﬁciently accurate table lookup for this was developed by Perry
Cook [27], and this is used in the csound wgclar opcode. There are a range of
parameters, controlling things such as reed stiffness, amount of noise and the time
is takes to start and stop blowing.
We can modify the string example to create a clarinet waveguide instrument by
adding a reed mode as shown in Fig. 16.2, as well as a better low-pass ﬁlter to
simulate the loss at the bell end. The output of this instrument has an inherent DC
offset, which we can block using a dcblock2 ﬁlter.
Listing 16.3 Clarinet waveguide model
<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
isiz = 16384
ifn ftgen 1,0,isiz,-7,0.8,0.55*isiz,-1,0.45*isiz,-1
392
16 Physical Models
/*********************************
idel LPdel ifo,ifc
idel - lowpass delay (samples)
ifo - fund freq
ifc - cutoff freq
**********************************/
opcode LPdel,i,ii
ifo,ifc xin
ipi = $M_PI
itheta = 2*ipi*ifc/sr
iomega = 2*ipi*ifo/sr
ib = sqrt((2 - cos(itheta))ˆ2 -1) - 2 + cos(itheta)
iden = (1 + 2*ib*cos(iomega) + ib*ib)
ire = (1. + ib + cos(iomega)*(ib+ib*ib))/iden
img =
sin(iomega)*(ib + ib*ib)/iden
xout -taninv2(img,ire)/iomega
endop
/*********************************
asig Reed ain,kpr,kem,ifn
ain - input (feedback) signal
kpr - pressure amount
kem - embouch pos (0-1)
ifn - reed transfer fn
**********************************/
opcode Reed,a,akki
ain,kpr,kem,ifn xin
apr linsegr 0,.005,1,p3,1,.01,0
asig = ain-apr*kpr-kem
awsh tablei .25*asig,ifn,1,.5
asig *= awsh
xout asig
endop
/**********************
asig Ap ain,ic
ain - input signal
ic - all-pass coefficient
********************/
opcode Ap,a,ai
setksmps 1
asig,ic xin
aap init 0
aap = ic*(asig - aap) + delay1(asig)
16.2 Waveguides
393
xout aap
endop
/******************************
asig Pipe kamp,ifun,ipr,iem,ifc
kamp - amplitude
ifun - fundamental
ipr - air pressure
iem - embouch pos
ifc - lowpass filter factor
*******************************/
opcode Pipe,a,kiiii
kamp,ifun,ipr,ioff,ifc xin
awg2 init 0
aap init 0
ifun *= 2
ifc = ifun*ifc
ilpd = LPdel(ifun,ifc)
ides = sr/ifun
idtt = int(ides - ilpd)
ifrc = ides - (idtt + ilpd)
ic = (1-ifrc)/(1+ifrc)
awg1 delayr idtt/sr
afdb = Ap(tone(awg1,ifc), ic)
delayw Reed(-afdb,ipr,ioff,1)
xout dcblock2(awg1*kamp)
endop
instr 1
asig Pipe p4,p5,p6,p7,p8
out asig
endin
</CsInstruments>
<CsScore>
i1 0 1 10000 440 0.7 0.7 6
i1 + 1 10000 880 0.9 0.7 5
i1 + 1 10000 660 0.7 0.7 4.5
i1 + 1 10000 550 0.8 0.6 3
i1 + 1 10000 440 0.7 0.6 3.5
</CsScore>
</CsoundSynthesizer>
Note that the use of an IIR ﬁlter such as tone for the loss makes the ﬁne-tuning
of the waveguide somewhat more complex. However, the all-pass ﬁlter approach
can still be used to ﬁx this. All we need to do is to calculate the exact amount of
394
16 Physical Models
delay that is added by the ﬁlter, which is dependent on the cut-off frequency fc.
With this, the phase response of the ﬁlter will tell us what the delay is at a given
fundamental. The i-time UDO LPdel calculates this for the speciﬁc case of the
tone ﬁlter, which is deﬁned as
y(t) = (1+b)x(t)−by(t −1)
(16.5)
b =
7
(2−cos(θ))2 −1−2+cos(θ)
(16.6)
where θ = 2π fc/sr. With this in hand, we can proceed to determine the waveg-
uide length, and the necessary fractional delay. In LPDel, we calculate the phase
response for this ﬁlter at the fundamental frequency and return it as a time delay in
samples. This is then subtracted from the desired length for this fundamental. The
integral part of this is the delay line size; the fractional part determines the all-pass
coefﬁcient.
The ﬂute model is similar to the clarinet except excitation is based on a non-
linear jet that ﬂuctuates over the lip hole and the pipe is open at both ends. Again the
Csound opcode wgflute implements this with a detailed architecture due to Cook.
An opcode modelled on the brass family wgbrass uses an excitation controlled by
the mass, spring constant and damping of the lip, but is otherwise similar.
What has not been considered so far is how different pitches are played. There
are two approaches; the simpler is to take inspiration from the slide trombone and
simply change the length of the tube (delay line). As long as the lowest pitch of
an instrument is known, this is easy to implement. It is indeed the method used in
the Csound opcodes. The alternative is tone-holes, as usually found on woodwind
instruments. These can be modelled by splitting the delay line and inserting a ﬁlter
system to act for the energy loss. This is explored in detail in research papers [113,
78].
16.2.3 More Waveguide Ideas
The concept of the waveguide is an attractive one and has been used outside strings
and tubes. Attempts have been made to treat drum skins as a mesh of delays with
scattering at the nodes where they meet. There are a number of problems with this,
lsuch the connectivity of the mesh (Fig. 16.3 and what happens at the edge of a
circular membrane. There are a number of research papers about this but so far the
performance has not been anywhere near real-time, and other approaches, typically
noise and ﬁlters, have proved more reliable. However this remains a possible future
method [61, 4, 3].
16.3 Modal Models
395
Fig. 16.3 Two possible drum meshes
16.3 Modal Models
In Section 12.4 the idea of constructing a sound from its sinusoidal partials was
discussed. A related idea for a physical object is to determine its basic modes of
vibration and how they decay and to create a physical model based on adding these
modes together, matching the initial excitation. The resulting system can be very im-
pressive (see [107] for example), but it does require a signiﬁcant amount of analysis
and preprocessing for an arbitrarily shaped object.
This method is particularly useful for generating the sound from a regularly
shaped object such as a wooden or metallic block, where the modes can be pre-
calculated or estimated. Using a rich excitement we can get a usable sound. This
example shows the general idea. The sound decay needs to be long to get the effect.
Listing 16.4 Marimba model using modal resonances
<CsoundSynthesizer>
<CsInstruments>
gicos
ftgen 0, 0,8192,11,1
/**********************
asig MyMarimba idur,iamp,ifrq,ibias
idur - time to decay
iamp - amplitude
ifrq - fundamental freq
********************/
opcode MyMarimba,a,iii
idur,ifrq,iamp xin
; envelope
k1
expseg
.0001,.03,iamp,idur-.03,.001
; anticlick
396
16 Physical Models
k25
linseg
1,.03,1,idur-.03,3
; power to partials
k10
linseg
2.25,.03,3,idur-.03,2
a1
gbuzz
k1*k25,ifrq,k10,0,35,gicos
a2
reson
a1,500,50,1
;filt
a3
reson
a2,1500,100,1
;filt
a4
reson
a3,2500,150,1
;filt
a5
reson
a4,3500,150,1
;filt
a6
balance a5,a1
xout
a6
endop
instr 1
ifq
=
cpspch(p4)
asig MyMarimba
20,ifq,p5
out
asig
endin
</CsInstruments>
<CsScore>
i1
0
10
8.00
30000
i1
4
.
8.02
30000
i1
8
.
8.04
30000
i1
12
.
8.05
30000
i1
16
.
8.07
30000
i1
20
.
8.09
30000
i1
24
.
8.11
30000
i1
28
.
9.00
30000
i1
32
.
8.00
10000
i1
32
.
8.04
10000
i1
32
.
8.07
10000
</CsScore>
</CsoundSynthesizer>
In Csound this technique is used in three opcodes, marimba, vibes and
gogobel, all build from four modal resonances but with more controls that the
simple marimba shown above.
It is possible to use the modal model directly, supported by the opcode mode.
This is a resonant ﬁlter that can be applied to an impulse or similarly harmonically
rich input to model a variety of percussive sounds. For example we may model the
interaction between a physical object and a beater with the following UDO.
Listing 16.5 Mode ﬁlter example
opcode hit,a,iiiii
ihard, ifrq1, iq1, ifrq2, iq2 xin
ashock
mpulse
3,0 ;; initial impulse
; modes of beater-object interaction
16.4 Differential Equations and Finite Differences
397
aexc1
mode ashock,ifrq1,iq1
aexc2
mode ashock,ifrq2,iq2
aexc
=
ihard*(aexc1+aexc2)/2
;"Contact" condition : when aexc reaches 0,
; the excitator looses contact with the
; resonator, and stops influencing it
aexc
limit aexc,0,3*ihard
xout
aexc
endop
This can be applied to the following object.
Listing 16.6 Modal resonances example
opcode ring,a,aiiii
aecx, ifrq1, iq1, ifrq2, iq2
xin
ares1
mode aexc,ifrq1,iq1
ares2
mode aexc,ifrq2,iq2
ares
=
(ares1+ares2)/2
xout aexc+ares
endop
All that remains is to use suitable frequencies and Q for the interactions. There
are tables of possible values in an appendix to the Csound manual, but a simple
example might be
instr 1
astrike
hit
ampdb(68),80, 8, 180, 3
aout
ring astrike, 440, 60, 630, 53
out
aout
endin
More realistic outputs can be obtained with more uses of the mode resonator in
parallel, and a more applicable instrument might make use of parameters to select
the parameters for the resonators.
16.4 Differential Equations and Finite Differences
In the earlier discussion of a physical model of a string it was stated that it was
for a perfect string; that is for a string with no stiffness or other properties such as
shear. If we think about the strings of a piano, the stiffness is an important part of the
instrument and so the two wave solution of a waveguide is not valid. The differential
equation governing a more realistic string is
∂2u
∂t2 = c2 ∂2u
∂x2 −κ2 ∂4u
∂x4
(16.7)
398
16 Physical Models
where κ is a measure of stiffness. To obtain a solution to this one creates a dis-
crete grid in time and space, time step size being one sample, and approximates the
derivative by difference equations, where u(xn,t) is the displacement at point xn at
time t:
∂u
∂x →un+1 −un
δx
∂2u
∂x2 →un+1 −2un +un−1
δx2
(16.8)
and similarly for the other terms. For example the equation
∂u
∂t = ∂u
∂x
(16.9)
could become
u(xn,t +1) = u(xn,t)+ 1
δxu(xn+1,t)+(1−1
δx)u(xn,t)
(16.10)
Returning to our stiff strings this mechanism generates an array of linear equa-
tions in u(n,t) which, subject to some stability conditions on the ratio of the time
and space steps, represents the evolution in time of the motion of the string. This
process, a ﬁnite difference scheme, is signiﬁcantly slower to use than the waveguide
model, but is capable of very accurate sound. Additional terms can be added to the
equation to represent energy losses and similar properties.
Forms such as this are hard and slow to code in the Csound language. Producing
usable models is an active research area [11], and GPU parallelism is being used to
alleviate the performance issues.
There are three opcodes in Csound that follow this approach while delivering
acceptable performance, modelling a metal bar, a prepared piano string and a rever-
berating plate.
A thin metal bar can be considered as a special case of a stiff string, and a ﬁnite
difference scheme set up to calculate the displacement of the bar at a number of
steps along it. The ends of the bar can be clamped, pivoting or free, and there are
parameters for stiffness, quality of the strike and so on. The resulting opcode is
called barmodel.
A mathematically similar but sonically different model is found in the opcode
prepiano which incorporates three stiff strings held at both ends that interact,
and with optional preparations of rattles and rubbers to give a Cageian prepared
piano. The details can be found in [12].
The third opcode is for a two-dimensional stiff rectangular plate excited by an
audio signal and allowed to resonate. This requires a two-dimensional space grid
to advance time which adds complexity to the difference scheme but is otherwise
similar to the strings and bars. The opcode is called platerev and allows a deﬁned
stiffness and aspect ratio of the plate as well as multiple excitations and listening
points. The added complexity makes this much slower than real-time.
16.6 Other Approaches
399
16.5 Physically Inspired Models
Not quite real physical modelling, there is a class of instrument models introduced
by Cook [28] that are inspired by the physics but do not solve the equations, but
rather use stochastic methods to produce similar sounds. Most of these models are
percussion sounds.
Consider a maraca. Inside the head there are a number of seeds. As the maraca
is moved the seeds ﬂy in a parabola until they hit the inner surface, exciting the
body with an impulse. A true physical model would need to follow every seed in its
motion. But one could just think that the probability of a seed hitting the gourd at a
certain time depends on the number of seeds in the instrument and how vigorously it
is shaken. A random number generator suitably driven supplies this, and the model
just needs to treat the gourd as a resonant ﬁlter. That is the thinking behind this class.
In Csound there are a number of shaken and percussive opcodes that use this
method; cabasa, crunch, sekere, sandpaper, stix, guiro,
tambourine, bamboo, dripwater, and sleighbells. The differences are
in the body resonances and the excitations.
The inspiration from physics is not
limited to percussion. It is possible to model a siren, or a referee’s whistle, in a
similar way. In the whistle the pea moves round the body in response to the blowing
pressure, and the exit jet is sometimes partially blocked by the pea as it passes. The
model uses the pressure to control the frequency of blocking, with some stochastic
dither to give an acceptable sound.
16.6 Other Approaches
There is an alternative way of making physical models where all interactions are
seen as combinations of springs, masses and dampers. In many ways this is simi-
lar to the differential equation approach and may end in computations on a mesh.
Examples of these ideas can be found in the literature such as [33] or the CORDIS-
ANIMA project [60].
16.6.1 Spring-Mass System
While there are no Csound opcodes using the CORDIS-ANIMA abstraction, spring-
mass instruments can be designed using similar principles. A simple example is
given by a spring-mass system. If we can set up a number of equations that describe
the movement of the system, in terms of position (in one dimension) and velocity,
then we can sample it to obtain our audio signal (Fig. 16.4).
A force acting on a mass in such a system, whose displacement is x, can be
deﬁned by
400
16 Physical Models
Fig. 16.4 Spring-mass system, whose position is sampled to generate an output signal
F = −k ×x
(16.11)
where k is the spring constant for a mass on a spring. From this, and Newton’s sec-
ond law (F = ma), we can calculate the acceleration a in terms of the displacement
position x and mass m:
a = −k ×x
m
(16.12)
Finally, to make the system move we need to propagate the changes in velocity
and position. These are continuous, so we need a discretisation method to do this.
The simplest of these is Euler’s method:
yn+1 = yn +y′(t)×h
(16.13)
with tn+1 = tn +h.
In other words, the next value of a function after a certain step is the combination
of the current one plus a correction that is based on its derivative and the step. For
the velocity v, this translates to
vn+1 = vn +a×h
(16.14)
as the acceleration is the derivative of the velocity. For the position x, we have
xn+1 = xn +v×h
(16.15)
That works for an ideal system, with no dampening. If we want to dampen it,
then we introduce a constant d, 0 < d < 1, to the velocity integration:
vn+1 = vn ×d +a×h
(16.16)
16.6 Other Approaches
401
and we have everything we need to make a UDO to model this system and sample
the position of the mass as it oscillates:
Listing 16.7 A spring-mass UDO
/**************************
asig Masspring ad,ik,idp,ih
ad - external displacement
ik - spring constant
idp - dampening constant
ims - mass
**************************/
opcode Masspring,a,aiiii
setksmps 1
ad,ik,idp,ims xin
av init 0
ax init 0
ih = 1/sr
ac = -(ik*ax+ad)/ims
av = idp*av+ac*ih
ax = ax+av*ih
xout ax
endop
Note that h is set to the sampling period (1/sr), which is the step size of the audio
signal. To run the opcode, we need to set up the spring constant, the mass of the
object and the dampening. The ﬁrst two determine the pitch of the sound, whereas
the ﬁnal parameter sets how long the sound will decay.
Since this is a simple harmonic system, we can use the well-known relationship
between period T0, mass m and spring constant k:
T0 = 2π
8m
k
(16.17)
which can be reworked to give a certain model mass for an arbitrary f0 and spring
constant k:
m = k ×
!
1
2π f0
"2
(16.18)
The value of k will inﬂuence the amplitude of the audio signal, as it can be inter-
preted as the amount of stiffness in the spring. Increasing it has the effect of reducing
the output level for a given f0. The actual amplitude will also vary with the mass,
increasing for smaller masses for the same k. The following example shows an in-
strument that is designed to use the model. It makes an initial displacement (lasting
for one k-cycle) and then lets the system carry on vibrating.
Listing 16.8 An instrument using the spring-mass UDO
instr 1
402
16 Physical Models
asig = p4
ifr = p5
idp = p6
ik = 1.9
im = ik*(1/(2*$M_PI*ifr))ˆ2
ams Masspring asig,ik,idp,im
out dcblock(ams)
asig = 0
endin
schedule(1,0,5,0dbfs/2,440,0.9999)
The input into the system is very simple, like a single strike. Other possibilities
can be experimented with, including using audio ﬁles, to which the system will
respond like a resonator.
16.6.2 Scanned Synthesis
Scanned synthesis [130] is another method that can be cast as a physical modelling
technique. From this perspective, it can be shown to be related to the idea of a
network of masses, springs and dampers. The principle behind it is a separation
between a dynamic physical (spatial) system and the reading (scanning) of it to
produce the audio signal. These two distinct components make up the method.
The conﬁguration of the physical system can be done in different ways. In the
Csound implementation, this is done by deﬁning a set of masses, which can be con-
nected with each other via a number of springs. This creates a spring-mass network,
whose components have the basic characteristics of mass, stiffness, dampening and
initial velocity. This is set into motion, making it a dynamic system.
The fundamental layout of the network is set up by the connections between the
masses. This is deﬁned in the scanning matrix M, which is an N ×N matrix, where
N is the number of masses in the system, containing zeros and ones. If Mi,j is set
to one, we will have a connection between the mass elements indexed by i and j. A
zero means that there is no connection.
For instance, with N = 8, the following matrix has all the elements connected in
a line, making it an open unidirectional string:
M =












0 1 0 0 0 0 0 0
0 0 1 0 0 0 0 0
0 0 0 1 0 0 0 0
0 0 0 0 1 0 0 0
0 0 0 0 0 1 0 0
0 0 0 0 0 0 1 0
0 0 0 0 0 0 0 1
0 0 0 0 0 0 0 0












(16.19)
16.6 Other Approaches
403
As can be seen, mass 0 is connected to mass 1, which is connected to mass
2 etc. Mi,i+1 = 1 for 1 ≤i < N −1. Linked at right angles to each mass there are
centring springs to which some dampening can be applied. By adding the backwards
connections from the end of the string, Mi+1,i = 1, we can make it bidirectional
(Fig. 16.5). By adding two further connections (N −1 to 0, and 0 to N −1), we can
make a circular network. Many other connections are possible.
Fig. 16.5 Bidirectional string network with eight masses (represented by balls) connected by
springs. There are also vertical springs to which dampening is applied.
Csound will take matrices such as these as function tables, where a two-dimensional
matrix is converted to a vector in row-major order (as sequences of rows, ViN+j =
Mi,j):
V = (M0,0,M0,1,...,M0,N−1,M1,0,...,MN−1,N−1)
The following code excerpt shows how connection matrix could be created for a
bidirectional string, using the table-writing opcode tabw i:
ii init 0
while ii < iN-1 do
tabw_i 1,ii*iN+ii+1,ift
tabw_i 1,(ii+1)*iN+ii,ift
ii += 1
od
where ift is the function table holding the matrix in vector form, and iN is the
number of masses in the network. The opcode that sets up the model and puts it into
motion is scanu:
scanu ifinit, iupd, ifvel, ifmass,
ifcon, ifcentr, ifdamp,
kmass, kstif, kcentr, kdamp,
ileft, iright, kx, ky,
ain, idisp, id
ifinit: function table number with the initial position of the masses. If nega-
tive, it indicates the table is used as a hammer shape.
iupd: update period, determining how often the model calculates state changes.
ifvel: initial velocity function table.
ifmass: function table containing the mass of each object.
ifcon: connection matrix (N ×N size table).
404
16 Physical Models
ifcentr: function table with the centring force for each mass. This acts or-
thogonally to the connections in the network.
ifdamp: function table with the dampening factor for each mass
kmass: mass scaling.
kstif: spring stiffness scaling.
kdamp: dampening factor scaling.
ileft, iright: position of left/right hammers (init < 0).
kx: position of a hammer along the string (0 ≤kx ≤1), (init < 0).
ky: hammer power (init < 0).
ain: audio input that can be used to excite the model.
idisp: if 1, display the evolution of the masses.
id: identiﬁer to be used by a scanning opcode. If negative, it is taken to be a
function table to which the waveshape created by the model will be written to, so
any table-reading opcode can access it.
All tables, except for the matrix one, should have the same size as the number of
masses in the network. To make sound out of the model, we deﬁne a scanning path
through the network, and read it at a given rate. For each such model, we can have
more than one scanning operation occurring simultaneously:
ar scans kamp, kfreq, iftr, id[,iorder]
where kfr is the scanning frequency, iftr is the function table determining the
trajectory taken, and id is the model identiﬁer. The output amplitude is scaled by
kamp. The last, optional, parameter controls the interpolation order, which ranges
from 0, the default, to fourth-order. Note also that other opcodes can access the
waveform produced by the model if that is written to a function table.
The trajectory function table is a sequence of mass positions, 0 to N −1, in an
N-sized table, which will be used as the scanning order by the opcode. The fol-
lowing example demonstrates a scanu - scans pair, using a bi-directional string
network with 1024 masses. The scan path is linear up and down the string. The
scanning frequency and the model update rate are also controlled as parameters to
the instrument
Listing 16.9 Scanned synthesis example
giN = 1024
ginitf = ftgen(0,0,giN,7,0,giN/2,1,giN/2,0)
gimass = ftgen(0,0,giN,-7,1,giN,1)
gimatr = ftgen(0,0,giNˆ2,7,0,giNˆ2,0)
gicntr = ftgen(0,0,giN,-7,0,giN,2)
gidmpn = ftgen(0,0,giN,-7,0.7,giN,0.9)
givelc = ftgen(0,0,giN,-7,1,giN,0)
gitrjc = ftgen(0,0,giN,-7,0,giN/2,giN-1,giN/2,0)
instr 1
ii init 0
while ii < giN-1 do
16.7 Conclusions
405
tabw_i 1,ii*giN+ii+1,gimatr
tabw_i 1,(ii+1)*giN+ii,gimatr
ii += 1
od
asig init 0
scanu ginitf,1/p6,
givelc,gimass,
gimatr,gicntr,gidmpn,
1,.1,.1,-.01,0,0,
0,0,asig,1,1
a1
scans p4,p5,gitrjc,1,3
out a1
endin
schedule(1,0,10,0dbfs/20,220,100)
Scanned synthesis is a complex, yet very rich method for generating novel
sounds. Although not as completely intuitive as the simpler types of physical mod-
elling, it is very open to exploration and interactive manipulation.
16.6.3 ... and More
Csound has a rich collection of opcodes including ones not described above, but that
owe their existence to the thinking of this chapter. For example there are opcodes
for a simpliﬁed scanned synthesis and for a faster implementation lacking just one
little-used option. One might also explore wave terrain synthesis [14], which pre-
dates scanned synthesis with a ﬁxed environment. There is much to explore here;
with physical models there is the possibility to drive them in non-physical ways.
16.7 Conclusions
This chapter has introduced the basic ideas behind creating sounds based on the
physics of real instruments. The simplest style is based on the general solution of the
simple wave equation, and that generates controllable instruments in the string and
wind groups. Modal modelling can produce realistic sounds for struck objects. For
a greater investment in computer time it is possible to use ﬁnite difference schemes
to model more complex components of an instrument, such as stiffness and non-
simple interaction with other objects. We also brieﬂy considered a class of stochastic
instruments inspired by physics, and the chapter was completed by a look at other
approaches such as spring-mass models and scanned synthesis.
Part V
Composition Case Studies
