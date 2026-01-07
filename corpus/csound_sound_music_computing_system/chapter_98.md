# Chapter 18

Chapter 18
Øyvind Brandtsegg: Feedback Piece
Abstract This chapter presents a case study of a live electronics piece where the
only sound source is audio feedback captured with two directional microphones.
The performer controls the timbre by means of microphone position. Algorithms
for automatic feedback reduction are used, and timbral colouring added by using
delays, granular effects, and spectral panning.
18.1 Introduction
The piece is based on audio feedback as the only sound generator. It was originally
inspired by the works of Alvin Lucier and Agostino Di Scipio, and how they use
audio feedback to explore the characteristics of a physical space. Audio from the
speakers is picked up by microphones (two shotgun/supercardioid microphones)
and treated with a slow feedback suppression technique. In my feedback piece, a
performer holds these two microphones and moves around in the concert space,
exploring the different resonant characteristics. Different parts of the room will have
resonances at speciﬁc frequencies, and the microphone position in relation to the
speakers will also greatly affect the feedback potential.
Some subtle colouring effects are added, for example delays to extend the tail of
the changing timbres and also to help to get feedback at lower sound levels. Spectral-
panning techniques are used to spread timbral components to different locations in
the room. During the later part of the piece, granular effects are used to further
shape and extend the available sonic palette, still maintaining the concept of using
microphone feedback as the only sound source. The overall form of the piece is
set by a timed automation of the effects treatment parameters, and the actual sonic
content is determined by the performer moving the microphones around the room
where the piece is performed. The relationship between material and form is thus
explored, in the context of the particular performance venue. Example recordings of
the piece can be found at [21, 20].
© Springer International Publishing Switzerland 2016 
V. Lazzarini et al., Csound, DOI 10.1007/978-3-319-45370-5_18
443
444
18 Øyvind Brandtsegg: Feedback Piece
18.2 Feedback-Processing Techniques
As the signal from audio feedback picked up by microphones in the room is the
only sound source for the piece, the digital treatment of the signal is signiﬁcant
for allowing the instrument a certain amount of timbral plasticity. The performer
ultimately shapes the sound by way of microphone positioning, but the potential
for timbral manipulation of the feedback lies in the adaptive ﬁlters. Some of these
ﬁlters selectively reduce feedback at speciﬁc frequencies, while others maintain or
increase the potential for feedback. Before A/D conversion, the microphone signal
is gently compressed, as the signal level picked up by the microphone can vary
greatly between the furthest corner of the room and a position directly in front of
the speaker. A regular equalising stage is also used, manually tuned according to
venue and speaker system, with the purpose of evening out the general frequency
response of the system. The adaptive ﬁlters for digitally controlling the feedback
consist of three different effects in series. The effects are