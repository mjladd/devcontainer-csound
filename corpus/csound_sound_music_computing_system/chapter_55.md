# Chapter 10

Chapter 10
Open Sound Control and Networking
Abstract In this chapter, we examine the networking capabilities of Csound. Through
the use of Open Sound Control, the network opcodes, and/or the server, users can
interact with external software, as well as with distributed processes in separate ma-
chines. The chapter explores these ideas, introducing key concepts and providing
some examples of applications.
10.1 Introduction
Csound has extensive support for interaction and control via the network. This al-
lows processes running on separate machines (or even on the same one) to com-
municate with each other. It also provides extra means of allowing the system to
interact with other software that can use the common networking protocols. There
are three areas of functionality within Csound that use networking for their oper-
ation: the Open Sound Control (OSC) opcodes; the all-purpose network opcodes;
and the Csound server.
10.2 Open Sound Control
Open Sound Control was developed in the mid-1990s at CNMAT [133, 134], and
is now widely used. Its goal was to create a more ﬂexible, dynamic alternative to
MIDI. It uses modern network communications, usually based on the user datagram
transport layer protocol (UDP), and allows not only communication between syn-
thesisers but also between applications and remote computers.
© Springer International Publishing Switzerland 2016
V. Lazzarini et al., Csound, DOI 10.1007/978-3-319-45370-5_
181
10
182
10 Open Sound Control and Networking
10.2.1 The OSC Protocol
The basic unit of OSC data is a message. This is sent to an address which follows the
UNIX path convention, starting with a slash and creating branches at every follow-
ing slash. The names inside this structure are free, but the convention is that the name
should ﬁt the content, for instance /voice/3/freq or /ITL/table/point0.
So, in contrast to MIDI, the address space is not pre-deﬁned and can be changed
dynamically.
An OSC message must specify the type(s) of its argument(s). The basic types
supported by Csound are:
•
integer 32-bit (type speciﬁer: "i")
•
long integer 64-bit ("h")
•
ﬂoat ("f")
•
double ("d")
•
character ("c")
•
string ("s").
Once data types are declared, messages can be sent and received. In OSC termi-
nology, anything that sends a message is a client, and anything that receives it is a
server. Csound can be both, in various ways, as it can
•
send a message and receive it in another part of the same program;
•
receive a message which is sent by any other application on this computer (local-
host) or anywhere in the network;
•
send a message to another application anywhere in the network.
10.2.2 Csound Implementation
The basic OSC opcodes in Csound are OSCsend and OSCreceive. As their
names suggest, the former sends a message from Csound to anywhere, and the latter
receives a message from anywhere in Csound:
OSCsend kwhen, ihost, iport, idestination,
itype [, kdata1, kdata2, ...]
where kwhen sends a message whenever it changes, ihost contains an IP address,
iport speciﬁes a port number, and idestination is a string with the address
space. The itype string contains one or more of the above-mentioned type speci-
ﬁers which will then occur as kdata1, kdata2 and so on.
ihandle OSCinit iport
kans OSClisten ihandle, idest, itype
[, xdata1, xdata2, ...]
10.2 Open Sound Control
183
The opcode outputs 1 (to kans) whenever a new OSC message is received, oth-
erwise zero. The ihandle argument contains the port number which has been
opened by OSCinit; idest and itype have the same meaning as in OSCsend.
The arguments xdata1, xdata2 etc. must correspond to the data types which
have been speciﬁed in the itype string. These will receive the contents of the in-
coming message, and must have been declared in the code beforehand, usually with
an init statement to avoid an undeﬁned-variable error.
The following code sends one integer, one ﬂoat, one string, and one more ﬂoat
once a second via port 8756 to the localhost ("127.0.0.1"), and receives them
by another Csound instance.
Listing 10.1 Client (sender) program
instr send_OSC
kSend = int(times:k())+1
kInt = int(random:k(1,10))
String = "Hello anywhere"
kFloat1 = random:k(0,1)
kFloat2 = random:k(-1,0)
OSCsend kSend, "127.0.0.1", 8756,
"/test/1", "ifsf",
kInt, kFloat1,
String, kFloat2
printf {{
OSC message %d sent at time %f!
int = %d, float1 = %f,
String = '%s', float2 = %f\n
}},
kSend, kSend, date:k(),
kInt,
kFloat1, String,
kFloat2
endin
schedule("send_OSC",0,1000)
Listing 10.2 Server (receiver) program
giRecPort OSCinit 8756
instr receive_OSC
kI, kF1, kF2, kCount init 0
Str = ""
kGotOne OSClisten giRecPort, "/test/1", "ifsf",
kI, kF1, Str, kF2
if kGotOne == 1 then
kCount += 1
printf {{
OSC message %d received at time %f!
int = %d, float1 = %f,
184
10 Open Sound Control and Networking
String = '%s', float2 = %f\n
}},kCount, kCount, date:k(),
kI, kF1, Str, kF2
endif
endin
schedule("receive_OSC", 0, 1000)
Running the two programs on two separate processes (different terminals/shells)
shows this printout for the sender:
OSC message 1 sent at time 1449094584.194864!
int = 8, float1 = 0.291342,
String = 'Hello anywhere', float2 = -0.074289
OSC message 2 sent at time 1449094585.167630!
int = 5, float1 = 0.680684,
String = 'Hello anywhere', float2 = -0.749450
OSC message 3 sent at time 1449094586.166411!
int = 1, float1 = 0.871381,
String = 'Hello anywhere', float2 = -0.070356
OSC message 4 sent at time 1449094587.168919!
int = 3, float1 = 0.615197,
String = 'Hello anywhere', float2 = -0.863861
And this one for the receiver:
OSC message 1 received at time 1449094584.195330!
int = 8, float1 = 0.291342,
String = 'Hello anywhere', float2 = -0.074289
OSC message 2 received at time 1449094585.172991!
int = 5, float1 = 0.680684,
String = 'Hello anywhere', float2 = -0.749450
OSC message 3 received at time 1449094586.171918!
int = 1, float1 = 0.871381,
String = 'Hello anywhere', float2 = -0.070356
OSC message 4 received at time 1449094587.169059!
int = 3, float1 = 0.615197,
String = 'Hello anywhere', float2 = -0.863861
So in this case the messages are received with a time delay of about 5 millisec-
onds.
10.2 Open Sound Control
185
10.2.3 Inter-application Examples
Processing using Csound as an audio engine
Processing is a Java-based programming language for visual arts1. Its visual engine
can interact easily with Csound’s audio engine via OSC. A simple example uses the
“Distance1D” code from the built-in Processing examples. Four lines (one thick,
one thin, on two levels) move depending on the mouse position (Fig. 10.1).
Fig. 10.1 Processing user interface
To send the four x-positions as OSC messages, we use the code shown in list-
ing 10.3 in the Processing sketchbook.
Listing 10.3 Processing program for OSC messaging
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress myRemoteLocation;
float xpos1;
float xpos2;
float xpos3;
float xpos4;
...
1 http://processing.org
186
10 Open Sound Control and Networking
void setup()
{
...
oscP5 = new OscP5(this,12001);
myRemoteLocation = new NetAddress("127.0.0.1",12002);
...
}
void draw()
{
...
OscMessage xposMessage =
new OscMessage("/Proc/xpos");
xposMessage.add(xpos1);
xposMessage.add(xpos2);
xposMessage.add(xpos3);
xposMessage.add(xpos4);
oscP5.send(xposMessage, myRemoteLocation);
}
The Processing sketch sends the four locations as x-positions in one OSC mes-
sage with the address /Proc/xpos on port 12,002. The message consists of four
ﬂoating point numbers which represent xpos1, xpos2, xpos3, and xpos4. The
Csound code receives these messages and scales the pixel range (0, ..., 640) to the
octave C-C (MIDI 72-84) for the upper two lines, and to the octave F#-F# (MIDI
66-78) for the lower two lines. As the lines move at different speeds, the distance
changes all the time. We use this to increase the volume of the two lines on the same
level when they become closer to each other, and vice versa. The movement of the
mouse leads to different chords and different changes between chords (listing 10.4).
Listing 10.4 OSC-controlled Csound synthesis code
opcode Scale, k, kkkkk
kVal, kInMin, kInMax, kOutMin, kOutMax xin
kValOut = (((kOutMax - kOutMin) / (kInMax - kInMin)) *
(kVal - kInMin)) + kOutMin
xout kValOut
endop
giPort OSCinit 12002
instr 1
;initialize variables and receive OSC
kx1, kx2, kx3, kx4 init 0
10.2 Open Sound Control
187
kPing OSClisten giPort, "/Proc/xpos", "ffff",
kx1,
kx2, kx3, kx4
;scale x-values to MIDI note numbers
km1 Scale kx1, 0, 640, 72, 84
km2 Scale kx2, 0, 640, 72, 84
km3 Scale kx3, 0, 640, 66, 78
km4 Scale kx4, 0, 640, 66, 78
;change volume according to distance 1-2 and 3-4
kdb12 = -abs(km1-km2)*2 - 16
kdb12 port kdb12, .1
kdb34 = -abs(km3-km4)*2 - 16
kdb34 port kdb34, .1
;produce sound and output
ax1 poscil ampdb(kdb12), cpsmidinn(km1)
ax2 poscil ampdb(kdb12), cpsmidinn(km2)
ax3 poscil ampdb(kdb34), cpsmidinn(km3)
ax4 poscil ampdb(kdb34), cpsmidinn(km4)
ax = ax1 + ax2 + ax3 + ax4
kFadeIn linseg 0, 1, 1
out ax*kFadeIn, ax*kFadeIn
endin
schedule(1,0,1000)
Csound using INScore as an intelligent display
Open Sound Control can not only be used for real-time soniﬁcation of visual data
by Csound, as demonstrated in the previous section. It can also be used the other
way round: Csound produces sounding events which are then visualised. INScore2,
developed at GRAME3, is one of the many applications which are capable of doing
this.
The approach here is slightly different from the one using Processing: INScore
does not need any code. Once it is launched, it listens to OSC messages (by default
on port 7,000). These messages can create, modify and remove any graphical repre-
sentation. For instance, the message /ITL/csound new will create a new panel
2 http://inscore.sourceforge.net
3 http://grame.fr
188
10 Open Sound Control and Networking
called csound4. The message /ITL/csound/point0 set ellipse 0.1
0.2 will create an ellipse with address point0 and size (0.1,0.2) (x,y) in this
panel. In Csound code, both messages look like this:
OSCsend 1, "", 7000, "/ITL/csound", "s", "new"
OSCsend 1, "", 7000, "/ITL/csound/point0",
"ssff", "set", "ellipse", 0.1, 0.2
Fig. 10.2 Graphics generated by listing 10.5 displayed in INScore
The example code in listing 10.5 uses this ﬂexibility in various ways. Ten in-
stances of OneTone are created (Fig. 10.2). Each instance carries a unique ID, as
it is called with a p4 from zero to nine. This ID via p4 is used to link one instance
to one of the ten points in the INScore panel. Each instance will create a successor
with the same p4. The ten points are modiﬁed by the sounds in many ways:
•
“High” and “low” pitches are placed high and low in the panel.
4 /ITL is the address space for the INScore application.
10.2 Open Sound Control
189
•
Left/right position is determined by the panning.
•
The form of the ellipse depends on shorter/duller (more horizontal) or longer/-
more resonant (more vertical) sounds.
•
The colour is a mixture of red (depending on pitch) and some blue (depending
on ﬁlter quality).
•
The size of an ellipse depends on the volume. Each point disappears slowly when
the sound gets softer.
Except for the continuous decrement of the size, it is sufﬁcient to send all mes-
sages only once, by using kwhen=1. For the transformation of the size, a rate of 15
Hz is applied for sending OSC messages, instead of sending on every k-cycle.
Listing 10.5 OSC-generating Csound code
ksmps = 32
nchnls = 2
0dbfs = 1
seed 0
;inscore default port for receiving OSC
giOscPort = 7000
opcode Scale, i, iiiii
iVal, iInMin, iInMax, iOutMin, iOutMax xin
iValOut = (((iOutMax - iOutMin) / (iInMax - iInMin))
* (iVal - iInMin)) + iOutMin
xout iValOut
endop
instr Init
OSCsend 1, "", giOscPort, "/ITL/csound", "s", "new"
OSCsend 1, "", giOscPort, "/ITL/csound/*", "s", "del"
gkSend metro 15
indx = 0
while indx < 10 do
schedule "OneTone", 0, 1, indx
indx += 1
od
schedule "Reverb", 0, p3
endin
instr OneTone
;generate tone and send to reverb
iOct random 7,10
iDb random -20,0
iQ random 100,1000
p3 = iQ/100
190
10 Open Sound Control and Networking
aStrike butlp mpulse(ampdb(iDb), p3), cpsoct(iOct)
aTone linen mode(aStrike, cpsoct(iOct), iQ), 0, p3, p3/2
iPan random 0,1
aL,aR pan2 aTone, iPan
chnmix aL, "left"
chnmix aR, "right"
;send OSC messages to Inscore
S_address sprintf "/ITL/csound/point%d", p4
iSizeX Scale iDb, -20, 0, .1, .3
iY_rel Scale iQ, 100, 1000, .1, 2
OSCsend 1, "", giOscPort, S_address, "ssff", "set",
"ellipse", iSizeX, iSizeX*iY_relˆ2
OSCsend 1, "", giOscPort, S_address, "si", "red",
Scale(iOct,7,10,0,256)
OSCsend 1, "", giOscPort, S_address, "si", "blue",
Scale(iQ,100,1000,100,0)
OSCsend 1, "", giOscPort, S_address, "sf", "y",
Scale(iOct,7,10,.7,-.7)
OSCsend 1, "", giOscPort, S_address, "sf", "x",
Scale(iPan,0,1,-1,1)
OSCsend gkSend, "", giOscPort, S_address, "sf",
"scale", line:k(1,p3,0)
;call a new instance of this ID
schedule "OneTone", p3, 1, p4
endin
instr Reverb
aL chnget "left"
aR chnget "right"
aLrv, aRrv reverbsc aL, aR, .7, sr/3
out aL*.8+aLrv*.2, aR*.8+aRrv*.2
chnclear "left"
chnclear "right"
endin
schedule("Init",0,9999)
Note that OSCsend will default to the localhost if passed an empty string as its
destination network address. When using OSC for inter-application connections in
the same machine, this is the normal procedure.
10.3 Network Opcodes
191
10.3 Network Opcodes
In addition to the speciﬁc OSC opcodes, which are designed to read this particular
protocol, Csound has more general network opcodes that can be used to send and
receive data via UDP or TCP (Transport Control Protocol) messages. These opcodes
can be used to work with a-variables, mostly, but can also be used to send and receive
control data.
The UDP opcodes are
asig sockrecv iport,ilen
ksig sockrecv iport,ilen
socksend asig,Sadrr,iport,ilen
socksend ksig,Sadrr,iport,ilen
where the network address is given by Saddr, the port used by iport. It is also
necessary to set the length of the individual packets in UDP transmission: ilen,
which needs to be small enough to ﬁt a single maximum transmission unit (MTU,
1,456 bytes). While UDP signals can theoretically carry audio signals, in practice it
is difﬁcult to have a reliable connection. However, it can carry control or modulation
data well. In the following examples, we have a sender producing a glissando signal
that is applied to an oscillator frequency at the receiver.
The send instrument produces an exponential control signal, and sends it to the
localhost, port 7,708:
instr 1
socksend expon(1,10,2),
"127.0.0.1",7708,200
endin
schedule(1,0,-1)
The receiver, running in a separate process, takes the UDP data and uses it as a
frequency scaler.
instr 1
k1 sockrecv 7708,200
out oscili(0dbfs/2, k1*440)
endin
schedule(1,0,-1)
In addition to these, Csound has a pair of TCP opcodes. These work differently,
requiring the two ends of the connection to handshake, so the receiver will have to
look for a speciﬁc sender address, instead of receiving data from any sender:
stsend asig,Saddr,iport
asig strecv Saddr,iport
Messages are send in a stream, and the connection is more reliable. It works
better for sending audio, as in the example below:
192
10 Open Sound Control and Networking
instr 1
stsend oscili(0dbfs/2,440), "127.0.0.1",8000
endin
schedule(1,0,-1)
instr 1
out strecv("127.0.0.1",8000)
endin
schedule(1,0,-1)
10.4 Csound UDP Server
In addition to its OSC and network opcodes, Csound can also be set up as a server
that will listen to UDP connections containing code text. As soon as it is received,
a text string is compiled by Csound. In this way, Csound can work as lightweight
audio server. If Csound is passed the --port=N option, it will listen to messages
on port N, until it is closed (by sending it a kill signal, ctrl-c).
Messages can be sent to Csound from any UDP source, locally or on the network.
For instance, we can start Csound with these options:
$ csound --port=40000 -odac
And we would see the following messages (among others):
0dBFS level = 32768.0
UDP server started on port 40000
orch now loaded
audio buffered in 1024 sample-frame blocks
PortAudio V19-devel (built Sep
4 2014 22:30:30)
0: dac0 (Built-in Output)
1: dac1 (Soundflower (2ch))
2: dac2 (Soundflower (64ch))
3: dac3 (Aggregate Device)
PortAudio: selected output device ’Built-in Output’
writing 1024 sample blks of 64-bit floats to dac
SECTION 1:
Csound is running, with no instruments. We can use the command nc (netcat) to
send a UDP message to it, using the heredoc facility, from another shell:
$ nc -uw 1
127.0.0.1 40000 <<end
> instr 1
> a1 oscili p4,p5
> out a1
> endin
10.5 Conclusions
193
> schedule(1,0,2,0dbfs/2,440)
> end
and all the text from the top to the keyword end, but excluding it, will be sent
to Csound via UDP. The nc command takes in the network address (127.0.0.1,
the localhost) and a port (40,000) to send the message to. This demonstrates the
simplicity of the system, which can be used in a variety of set-ups.
As shown with OSC, third-party networking programs can be used to interface
with the system. In particular, text editors (such as emacs or vim) can be conﬁg-
ured to send selections of text to Csound, allowing them to implement interactive
frontend facilities. Note that just by adding the --port=N option, we can start the
network server, which works even alongside other input methods, scores, MIDI etc.
The server itself can be closed by sending the string "##close##" to it.
10.5 Conclusions
Open Sound Control gives Csound a fast and ﬂexible communication with any other
application which is able to use OSC. It offers a wide range of use cases in soni-
ﬁcation and visualisation. It makes it possible to control Csound remotely via any
OSC-capable software, as explored in the examples based on Processing and In-
score.
In complement to the OSC implementation, we have the generic network op-
codes. These allow the user to send raw data over UDP and TCP connections, for
both control and audio applications.
Finally, we introduced the built-in UDP server that is provided as part of the audio
engine. Once enabled, it is possible to use it to send strings containing Csound code
to be compiled and run. This provides a third way in which users can interact with
the system over network communications infrastructure.
