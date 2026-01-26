# Chapter 12, we have implemented these effects as part of the tonewheel organ im-

Chapter 12, we have implemented these effects as part of the tonewheel organ im-
plementation, and there the differences were only that the chorus effect mixed the
original signal, while the vibrato did not. It is important to note that there is some
variation in the interpretation of what these effects are supposed to be across dif-
ferent effects implementations. Nevertheless, the ideas discussed here are generally
accepted as the basic principles for these processes.
13.3.4 Doppler
The Doppler shift is the perceived change in frequency of a waveform due to a mov-
ing source. As it moves towards or away from the listener, the wavefront reaching
her is either squeezed or stretched, resulting in a pitch modiﬁcation. The perceived
13.3 Variable Delays
277
frequency fp will be related to the original frequency fo by the following relation-
ship:
fp = fo ×
c
c−v
(13.17)
where c is the speed of sound in the air (∼= 344 ms-1) and v is the velocity of the
sound source. If the source is moving towards the listener, the velocity is positive,
and the frequency will rise. In the other direction, the frequency will drop.
The effect of a variable delay line is similar to the Doppler effect. When the
delay time is decreased, the effect is similar to making the source move closer to the
listener, since the time delay between emission and reception is reduced.
A digital waveform can be modelled as travelling c
sr meters every sample. In this
case, a delay of D samples will represent a position at a distance of
p = D× c
srm
(13.18)
Thus, if we vary D, the effect can be used to model a sound source moving with
velocity V,
V = D
t × c
srms−1
(13.19)
As with the vibrato effect discussed above, Doppler shift is proportional to the
rate of change of the delay over time. So a faster moving object will imply a faster
change in the delay time. For varying speeds, then the delay time has to change at
different rates. If the effect of a sound passing the listener is desired, then a posi-
tive shift followed by a negative shift is necessary. This can be easily achieved by
decreasing and then increasing the delay times. The rate of change will model the
speed of the source. A change in amplitude can also reinforce the effect.
For example, if we want the source to move from a position at maximum distance
pmax to a minimum distance position pmin, we can do this:
