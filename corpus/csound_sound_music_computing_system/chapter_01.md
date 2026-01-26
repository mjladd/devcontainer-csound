# Chapter 1

Chapter 1
Music Programming Systems
Abstract This chapter introduces music programming systems, beginning with a
historical perspective of their development leading to the appearance of Csound.
Its direct predecessors, MUSIC I-IV, MUSIC 360 and MUSIC 11, as well as the
classic MUSIC V system, are discussed in detail. Following this, we explore the
history of Csound and its evolution leading to the current version. Concepts such
as unit generators, instruments, compilers, function tables and numeric scores are
introduced as part of this survey of music programming systems.
1.1 Introduction
A music programming system is a complete software package for making music
with computers [68]. It not only provides the means for deﬁning the sequencing
of events that make up a musical performance with great precision, but it also en-
ables us to deﬁne the audio signal processing operations involved in generating the
sound, to a very ﬁne degree of detail and accuracy. Software such as Csound offers
an environment for making music from the ground up, from the very basic elements
that make up sound waves and their spectra, to the higher levels of music compo-
sition concerns such as sound objects, notes, textures, harmony, gestures, phrases,
sections, etc.
In this chapter, we will provide a historical perspective that will trace the devel-
opment of key software systems that have provided the foundations for computer
music. Csound is based on a long history of technological advances. The current
system is an evolution of earlier versions that have been developed over almost 30
years of work. Prior to that, we can trace its origins to MUSIC 11, MUSIC 360
and MUSIC IV, which were seminal pieces of software that shaped the way we
make music with computers. Many of the design principles and concepts that we
will be studying in this book have been originated or were inﬂuenced by these early
systems. We will complete this survey with an overview of the most up-to-date de-
velopments in Csound.
© Springer International Publishing Switzerland 2016
V. Lazzarini et al., Csound, DOI 10.1007/978-3-319-45370-5_1
3
4
1 Music Programming Systems
1.2 Early Music Programming Languages
The ﬁrst direct digital synthesis program was MUSIC I, created by Max Mathews in
1957, followed quickly by MUSIC II and MUSIC III, which paved the way to mod-
ern music programming systems. Mathews’ ﬁrst program was innovative in that,
for the ﬁrst time, a computer was used to calculate directly the samples of a dig-
ital waveform. In his second program, we see the introduction of a key piece of
technology, the table-lookup oscillator in MUSIC II, which is one of the most im-
portant components of a computer music program. In MUSIC III, however, we ﬁnd
the introduction of three essential elements that are still central to systems such as
Csound: the concepts of unit generator (UG) and instrument, and the compiler for
music programs [81, 82, 119]. Mathews explains the motivation behind its develop-
ment:
I wanted the complexity of the program to vary with the complexity of the musician’s de-
sires. If the musician wanted to do something simple, he or she shouldn’t have to do very
much in order to achieve it. If the musician wanted something very elaborate there was the
option of working harder to do the elaborate thing. The only answer I could see was not to
make the instruments myself – not to impose my taste and ideas about instruments on the
musicians – but rather to make a set of fairly universal building blocks and give the musician
both the task and the freedom to put these together into his or her instruments. [110]
The original principle of the UG has been applied almost universally in music
systems. A UG is a basic building block for an instrument, which can be connected
to other UGs to create a signal path, also sometimes called a synthesis graph. Even-
tually such a graph is terminated at an output (itself a UG), which is where the gen-
erated sound exits the instrument. Conceptually, UGs are black boxes, in that they
have a deﬁned behaviour given their parameters and/or inputs, possibly producing
certain outputs, but their internals are not exposed to the user. They can represent
a process as simple as a mixer (which adds two signals), or as complex as a Fast
Fourier Transform (which calculates the spectrum of a waveform). We often speak
of UGs as implementing an algorithm: a series of steps to realise some operation,
and such an algorithm can be trivial (such as sum), or complicated. UGs were such
a good idea that they were used beyond Computer Music, in hardware instruments
such as the classic analogue modular systems (Moog, ARP, etc.).
The second concept introduced by MUSIC III, instruments, is also very impor-
tant, in that it provides a structure in which to place UGs. It serves as a way of
deﬁning a given model for generating sounds, which is not a black box anymore,
but completely conﬁgurable by the user. So, here, we can connect UGs in all sorts
of ways that suit our intentions. Once that is done, this can ‘played’, ‘performed’, by
setting it to make sound. In early systems there would have been strict controls on
how many copies of such instruments, called instances, could be used at the same
time. However, in Csound, we can have as many instances as we would like working
together (bound only by computing resource requirements).
Finally, the compiler, which Mathews called the acoustic compiler, was also a
breakthrough, because it allowed the user to make her synthesis programs from
these instrument deﬁnitions and their UGs into a very efﬁcient binary form. In fact,
1.2 Early Music Programming Languages
5
it enabled an unlimited number of sound synthesis structures to be created in the
computer, depending only on the creativity of the designer, making the computer
not only a musical instrument, but a musical instrument generator. The principle of
the compiler lives on today in Csound, and in a very ﬂexible way, allowing users to
create new instruments on the ﬂy, while the system is running, making sound.
1.2.1 MUSIC IV
The ﬁrst general model of a music programming system was introduced in MUSIC
IV, written for the IBM 7094 computer in collaboration with Joan Miller, although
the basic ideas had already been present in MUSIC III [100]. MUSIC IV was a
complex software package, as demonstrated by its programmer’s manual [83], but it
was also more attractive to musicians. This can be noted in the introductory tutorial
written by James Tenney [122]. The software comprised a number of separate pro-
grams that were run in three distinct phases or passes, producing at the very end the
samples of a digital audio stream stored in a computer tape or disk ﬁle. In order to
listen to the resulting sounds, users would have to employ a separate program (often
in a different computer) to play back these ﬁles.
Operation of MUSIC IV was very laborious: the ﬁrst pass took control data in the
form of a numeric computer score and associated function-table generation instruc-
tions, in an unordered form and stored in temporary tape ﬁles. This information,
which included the program code itself, was provided in the form of punched cards.
The data in this pass were used as parameters to be fed to instruments in subsequent
stages. The two elements input at this stage, the score and function-table informa-
tion, are central to how MUSIC IV operated, and are still employed in music systems
today, and in particular, in Csound.
The numeric score is a list of parameters for each instance of instruments, to al-
low them to generate different types of sounds. For instance, an instrument might ask
for its pitch to be deﬁned externally as a parameter in the numeric score. That will al-
low users to run several copies of the same instrument playing different pitches, each
one deﬁned in the numeric score. The start times and durations, plus the requested
parameters are given in the score creating an event for a particular instrument. Each
one of these is a line in the score, and the list does not need to be entered in a par-
ticular time order, as sorting, as well as tempo alterations, can be done later. It is a
simple yet effective way to control instruments.
Function tables are an efﬁcient way to handle many types of mathematical op-
erations that are involved in the computing of sound. They are pre-calculated lists
of numbers that can be looked up directly, eliminating the need to compute them
repeatedly. For instance, if you need to create a sliding pitch, you can generate the
numbers that make up all the intermediary pitches in the glissando, place them in
a function table, and then just read them. This saves the program from having to
calculate them every time it needs to play this sound. Another example is a sound
waveform table, also known as a wavetable. If you need a ﬁxed-shape wave in your
6
1 Music Programming Systems
instrument, you can create it and place it in a table, then your instrument can just
read it to produce the signal required.
In MUSIC IV, the ﬁrst pass was effectively a card-reading stage, with little extra
functionality, although external subroutines could be applied to modify the score
data before this was saved. Memory for 800 events was made available by the sys-
tem. The ﬁrst pass data was then input to the second pass, where the score was sorted
in time order and any deﬁned tempo transformations applied, producing another set
of temporary ﬁles. In the third pass, a synthesis program was loaded, taking the
score from the previous stage, and generating the audio samples to be stored in the
output ﬁle.
The pass 3 program was created by the MUSIC IV acoustic compiler from the
synthesis program, called an orchestra, made up of instruments and UGs. Some ba-
sic conventions governed the MUSIC IV orchestra language, such as the modes of
connections allowed, determined by each unit generator and how they were organ-
ised syntactically. As a programming language, it featured a basic type system. Data
typing is a way of deﬁning speciﬁc rules for different types of computation objects
(e.g. numbers, text etc.) that a computer language manipulates. In MUSIC IV, there
are only a few deﬁned data types in the system: U (unit generator outputs), C (con-
version function outputs, from the score), P (note parameters, also from the score),
F (function tables) and K (system constants). Unlike in modern systems, only a cer-
tain number of parallel instances of each instrument were allowed to be run at the
same time, and each score event was required to be scheduled for a speciﬁc free
instrument instance.
The MUSIC IV compiler understood ﬁfteen unit generators. There were three
types of oscillators, which were used to generate basic waveform signals and de-
pended on pre-deﬁned function tables. Two envelope generators were provided to
control UG parameters (such as frequency or amplitude). A table-lookup UG was
also offered for direct access to tables. Two bandlimited noise units, of sample-
hold and interpolating types, complemented the set of generators in the system.
Three addition operators, for two, three and four inputs, were provided, as well as
a multiplier. Processors included a resonance unit based on ring modulation and a
second-order band-pass ﬁlter. Finally, an output unit complemented the system:
