# Chapter 8

Chapter 8
The Numeric Score
Abstract This chapter discusses the standard numeric score, which can be used to
control events in Csound. Following a general introduction to its syntax and inte-
gration with the system, the text explores the basic statement types that compose it,
and how they are organised. The score processor and its functionality are explored,
followed by a look at loops and playback control. The chapter concludes with a
discussion of score generation by external programs and scripting languages.
8.1 Introduction
The standard numeric score was the original means of controlling Csound, and for
many composers, it is still seen as the fundamental environment for creating music
with the software. Its concept and form goes a long way back to MUSIC III and IV,
which inﬂuenced its direct predecessors in the MUSIC 360 and MUSIC 11 systems.
It was created to respond to a need to specify instances of compiled instruments
to run at certain times, as well as create function tables as needed. Scores were
also designed to go through a certain amount of processing so that tempo and event
sorting could be applied. A traditional separation of signal processing and event
scheduling was behind the idea of score and orchestra. The lines between these two
were blurred as Csound developed, and now the score is one of many ways we can
use to control instruments.
The score can be seen as a data format rather than a proper programming lan-
guage, even though it has many scripting capabilities. An important aspect to un-
derstand is that its syntax is very different from the Csound language proper (the
‘orchestra’). There are reasons for this: ﬁrstly, the score serves a different purpose;
secondly, it developed separately, and independently from the orchestra. Thus, we
need to be very careful not to mix the two. In particular, the score is much simpler,
and has very straightforward syntax rules. These can be summarised as:
