# Chapter 9

Chapter 9
MIDI Input and Output
Abstract In this chapter, we will explore the implementation of the MIDI protocol in
Csound. Following an introductory discussion of the protocol and its relevant parts,
we will explore how it is integrated into the software. We will show how MIDI
input is designed to ﬁt straight into the instrument-instance model of operation. The
dedicated opcodes for input and output will be introduced. The chapter will also
examine the different backend options that are currently supported by the system.
9.1 Introduction
The Musical Instrument Digital Interface (MIDI) protocol is a very widespread
means of communication for musical devices. It establishes a very straightforward
set of rules for sending various types of control data from a source to a destination.
It supports a point-to-point unidirectional connection, which can be made between
hardware equipment, software or a combination of both.
Although MIDI is signiﬁcantly limited when compared to other modern forms of
communication (for instance, IP messages), or data formats (e.g. the Csound score),
it is ubiquitous, having been adopted by all major music-making platforms. Due
to its limitations, it is also simple, and therefore cheap to implement in hardware.
While its death has been predicted many times, it has nevertheless lived on as a
useful means of connecting musical devices. It is however important to understand
the shortcomings of MIDI, and its narrow interpretation of music performance, so
that these do not become an impediment to ﬂexible music making.
9.2 MIDI Messages
The MIDI protocol incorporates three types of messages [87]: channel messages,
system common messages and system real-time messages. The ﬁrst type is used to
© Springer International Publishing Switzerland 2016 
V. Lazzarini et al., Csound, DOI 10.1007/978-3-319-45370-5_9
171
172
9 MIDI Input and Output
send control information to music devices, e.g. when to play a sound, to change
a control value etc. The second type includes system exclusive messages, which
is used for custom message types, deﬁning various types of data transfer (e.g. for
synthesiser editors, bulk dumps etc.), MIDI time code frames, song selection and
positioning. System real-time messages are used mainly for synchronisation through
timing clocks.
The MIDI implementation in Csound mostly addresses the receiving and send-
ing of channel messages. Such messages are formatted in a speciﬁc way, with two
components:
1. status: this comprises a code that deﬁnes the message type and a channel number.
There are seven message types and sixteen independent channels.
2. data: this is the data that is interpreted according to the message type. It can be
made up of one or two values, in the range of 0-127.
At the low level, MIDI messages are transmitted as a sequence of eight-bit bi-
nary numbers, or bytes. The status part occupies a single byte, the ﬁrst four bits
containing the message type and the second the channel (thus the limited number
of channels and message types allowed). The data can comprise one or two bytes,
depending on the message types (each byte carrying a single value). Status bytes
always start with a 1, and data bytes with 0, thus limiting the useful bits in each byte
to seven (hence the fundamental MIDI value range of 0-127).
9.2.1 Channel Message Types
The seven message types are: