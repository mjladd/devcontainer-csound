# 2. For generic use: these opcodes will normally have access to all MIDI messages

2. For generic use: these opcodes will normally have access to all MIDI messages
coming into Csound.
In the ﬁrst category, we have
veloc: note velocity.
notnum: note number.
aftouch: aftertouch amount.
polyaft: aftertouch amount for a given note.
pchbend: pitch-bend amount.
ampmidi: takes the note velocity and translates it into amplitude.
cpsmidi and cpsmidib: translates note number into Hz, in the second case
incorporating pitch-bend data.
midictrl, midic7, midic14, and midic21: access any control change
data in the instrument input MIDI channel. The ‘14’ and ‘21’ opcodes can use
multiple messages together to make up higher-resolution data.
All of these opcodes are only applicable to MIDI-triggered instruments. For more
generic use we have
chanctrl, ctrl7, ctrl14 and ctrl21: control change data for a given
channel.
midiin: raw MIDI data input.
In order to access the MIDI device, it is necessary to include the -M dev option,
where dev is a device identiﬁer that will be dependent on the MIDI backend used,
and the devices available in the system.
MIDI ﬁles can also be used, in addition to real-time/device input (including si-
multaneously). All we need to do is to supply the ﬁlename with the -F option.
MIDI input examples
The following example shows a simple MIDI subtractive synthesiser, with support
for pitch bend and modulation wheel (controller 1). It takes in the velocity and
maps it to amplitude, with note number converted to Hz and used as the oscillator
frequency. The ﬁlter cut-off is controlled by the modulation wheel input and note
frequency.
Listing 9.1 Simple MIDI subtractive synthesiser
instr 1
kcps cpsmidib 2
iamp ampmidi 0dbfs
kcf midictrl 1,2,5
9.3 The Csound MIDI System
175
out linenr(moogladder(
vco2(iamp,kcps,10),
kcf*(kcps +
linenr(kcps,0.1,0.1,0.01)),
0.7), 0.01,0.1,0.01)
endin
The next example shows the use of a generic MIDI input to report the messages
received, a type of MIDI monitor. Note that we use massign with parameters set
to zero, which disables triggering of instruments (NOTE ON messages do not create
instances of any instrument). This is because we want to run only a single copy of
instrument 1 that will monitor incoming MIDI data. This approach can be used in
case we want to parse MIDI messages before dispatching them to other parts of the
code.
Listing 9.2 MIDI monitor to print out input messages
massign 0,0
instr 1
k1,k2,k3,k4 midiin
if k1 == 144 then
S1 strcpyk "NOTE ON"
elseif k1 == 128 then
S1 strcpyk
"NOTE OFF"
elseif k1 == 166 then
S1 strcpyk
"POLY AFTERTOUCH"
elseif k1 == 208 then
S1 strcpyk
"AFTERTOUCH"
elseif k1 == 192 then
S1 strcpyk
"PROGRAM CHANGE"
elseif k1 == 176 then
S1 strcpyk "CONTROL CHANGE"
elseif k1 == 224 then
S1 strcpyk
"PITCH BEND"
else
S1 strcpyk
"UNDEFINED"
endif
printf "%s chn:%d data1:%d data2:%d\n",
k1,S1,k2,k3,k4
endin
schedule(1,0,-1)
Mapping to instrument parameters
It is also possible to map NOTE ON/OFF data to given instrument parameter ﬁelds
(p4, p5 etc.). This allows us to make instruments ready for MIDI without needing to
176
9 MIDI Input and Output
modify them too much, or use some of the MIDI opcodes above. In order to do this,
we can use the following options:
--midi-key=N: route MIDI note on message key number to p-ﬁeld N as MIDI
value.
--midi-key-cps=N: route MIDI note on message key number to p-ﬁeld N
as cycles per second (Hz).
--midi-key-oct=N: route MIDI note on message key number to p-ﬁeld N
as linear octave.
--midi-key-pch=N: route MIDI note on message key number to p-ﬁeld N
as octave pitch-class.
--midi-velocity=N: route MIDI note on message velocity number to p-
ﬁeld N as MIDI value.
--midi-velocity-amp=N: route MIDI note on message velocity number to
p-ﬁeld N as amplitude change data for a given channel.
For instance, the options
--midi-key-cps=5 --midi-velocity-amp=4
will map key numbers to Hz in p5 and velocities to p4 (amplitudes in the range
of 0-0dbfs). In this case, the following minimal instrument will respond directly to
MIDI:
instr 1
out(linenr(oscili(p4,p5),0.01,0.1,0.01))
endin
The only thing we need to worry about is that the instruments we are hoping to
use with MIDI do not depend on the event duration (p3). If we use envelopes with
built-in release times as in the previous example, then we will not have any problems
reusing code for MIDI real-time performance.
9.3.2 Output
MIDI output is enabled with the -Q dev option, where, as before, dev is the desti-
nation device. It is also possible to write MIDI ﬁles using --midioutfile=....
Similarly to input, Csound provides a selection of opcodes that can be used for this
purpose:
midion, midion2, noteon, noteoff, notendur, and noteondur2 –
NOTE channel messages.
outiat and outkat – aftertouch.
outipat and outkpat – polyphonic aftertouch.
outic and outkc – control change.
outic14 and outkc14 – control change in two-message packages for extra
precision.
9.3 The Csound MIDI System
177
outipat and outkpat – program change.
outipb and outkpb – pitch bend.
midiout – generic MIDI message output.
Some of the NOTE opcodes will put out matching ON - OFF messages, so there
is no particular problem with hanging notes. However, when using something more
raw (such as noteon and midiout), care needs to be taken so that all notes are
killed off correctly.
MIDI output example
The following example demonstrates MIDI output. We use the midion opcode,
which can be run at k-rate. This opcode sends NOTE ON messages when one
of its data parameters (note number, velocity) changes. Before a new message is
sent, a NOTE OFF cancelling the previous note is also sent. The metro opcode is
used to trigger new messages every second (60 bpm), and the note parameters are
drawn from a pseudo-random sequence. For each note, we print its data values to
the screen.
Listing 9.3 Simple MIDI output example
instr 1
k1 metro 1
if k1 > 0 then
kn = 60+rnd:k(12)
kv = 60+birnd:k(40)
printf "NOTE %d %d\n", kn, kn, kv
midion 1,kn,kv
endif
endin
9.3.3 MIDI Backends
Depending on the operating system, various MIDI backends can be used. These can
be selected with the option -+rtmidi=.... The default backend for all platforms
is portmidi. Some frontends can also implement their own MIDI IO, in which case
there is no particular need to choose a different backend.
PortMidi
PortMidi is a cross-platform MIDI library that works with whatever implementation
is offered by the host OS. It can be selected by setting -+rtmidi=pmidi, but it is
178
9 MIDI Input and Output
also the default backend. Devices are listed numerically, so in order to select inputs
or outputs, we should provide the device number (e.g. -M 0, -Q 0). Devices can
be listed by running Csound with the sole option --midi-devices. The option
-M a enables all available input devices together.
CoreMIDI
CoreMIDI is the underlying OSX MIDI implementation, which can be accessed us-
ing -+rtmidi=coremidi. Devices are also listed numerically, as with PortMidi.
ALSA raw MIDI
ALSA raw MIDI is the basic Linux MIDI implementation, accessed using -
+rtmidi
=alsa. Devices are listed and set by name, e.g. hw:1,0.
ALSA sequencer
The Alsa sequencer is a higher-level MIDI implementation, accessed using -
+rtmidi
=alsaseq. Devices are also listed and set by name.
Jack
The Jack connection kit MIDI implementation works in a similar way to its audio
counterpart. We can set it up with -+rtmidi=jack, and it will connect by default
to the system MIDI sources and/or destinations. It is also possible to deﬁne the
connections by passing port names to -M and -Q. The Jack patchbay can be used to
set other links. Jack is particularly useful for inter-application MIDI IO.
9.4 Conclusions
In this chapter we have examined another means of controlling Csound, through
the use of the MIDI protocol. This can be employed for real-time device control,
as well as in ofﬂine scenarios with ﬁle input. The use of MIDI can be intermingled
with other forms of control, score, and orchestra code. It provides a ﬂexible way to
integrate Csound with other software and external hardware.
It was pointed out that MIDI has its limitations in that it supports a certain ap-
proach to music making that lacks some ﬂexibility. In addition, the protocol has
9.4 Conclusions
179
limited precision, as most of the data is in the seven-bit range. Alternatives to it
have been shown elsewhere in this book, and in particular, we will see in the next
chapter a more modern communications protocol that might eventually supersede
MIDI. However, at the time of writing, this is still the most widespread method of
connecting musical devices together for control purposes.
