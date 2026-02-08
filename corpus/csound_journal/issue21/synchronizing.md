---
source: Csound Journal
issue: 21
title: "Synchronizing a Networked Csound Laptop Ensemble using OSC"
author: "Roger Dannenberg"
url: https://csoundjournal.com/issue21/synchronizing.html
---

# Synchronizing a Networked Csound Laptop Ensemble using OSC

**Author:** Roger Dannenberg
**Issue:** 21
**Source:** [Csound Journal](https://csoundjournal.com/issue21/synchronizing.html)

---

CSOUND JOURNAL[](https://csoundjournal.com/../index.html) | [Issue 21](https://csoundjournal.com/index.html)
##  Synchronizing a Networked Csound Laptop Ensemble using OSC
 Russell Pinkston
 rpinkston AT utexas.edu
## Introduction


In this article, I will describe a method of synchronizing multiple networked computers for interactive musical performance using Csound and Open Sound Control (OSC). I chose to adopt a client/server approach based on the "forward-synchronous" system developed by Roger Dannenberg[[1]](https://csoundjournal.com/#ref1)[[2]](https://csoundjournal.com/#ref2). The basic idea of this system is that the server maintains a master (global) clock, while the clients keep their local clocks synchronized with the global clock by querying the server at regular intervals. Since all the computers agree on the global time, as well as the current beat, tempo, and meter, they can schedule events to occur at precise moments in the future, even if there are network latencies. Dannenberg's system allows for changes in tempo, but not in meter, so I added that capability. I also created a graphical user interface for the system in CsoundQT and constructed a small set of custom OSC messages for communications between machines.
## Overview


The system works as follows:
- Clients individually send messages to the server asking to join the group and the server adds their user names and IP addresses to its database. The IP address and receive port of the server must be known in advance and the server must be up and running first. For the sake of simplicity and efficiency, all the clients use the same receive port, which should also be agreed upon in advance.
- Once a client/user has joined the group, s/he can get a list of other users, chat with the group, send/receive f-tables, send and receive scheduled performance events (snapshot changes), and establish clock and beat synchronization with the server.
- Musical time (current beat, tempo, and meter) is established and maintained by the server, which notifies all the clients whenever the tempo or meter has changed. Clients poll the server at regular intervals to maintain clock synchronization and at any time may issue a "beat query" to the server, which returns the most recent beat number, the time it occurred on the server, and the current meter and tempo. It also provides the beat number at the last change in either tempo or meter, the time and bar number at which that occurred, and the beat number of the downbeat of that bar. This means that client machines can join the group at any time and know exactly where they are in the music.
## Implementation


The Csound orchestra that implements the system I will describe here is very large, so it would be impractical to include and discuss all of the code in this article. Moreover, a significant amount of that code is related to the graphical user interface, which happens to be built in CsoundQT, but which could be built in any number of user interface programs. In short, most of that code is not relevant to the subject of this article. Consequently, I will focus primarily on the concepts and techniques that are integral to the task of establishing communication and maintaining precise synchronization in a networked laptop ensemble, and discuss selected portions of the Csound code involved. The complete CSD is available for download from the following link [Pinkston Example.zip](https://csoundjournal.com/downloads/PinkstonExample.zip), and I have included numerous comments that should make it relatively easy to understand.
### Open Sound Control


Open Sound Control (OSC) is a protocol for communication between computers, synthesizers, and other multimedia devices. It was developed at the UC Berkeley Center for New Music and Audio Technologies (CNMAT) in the late 1990's and has since become an industry standard. (More information about OSC and how to use it can be found at http://www.opensoundcontrol.org[[4]](https://csoundjournal.com/#ref4).) Csound provides two opcodes for use with OSC messages—`OSCsend` and `OSClisten`. (Note: At the time of this writing, these opcodes were not included in the Reference section of the Csound manual. However, they can be found in the Opcodes Overview section under OSC and Network.) Before you can use `OSClisten`, you must first use `OSCinit` to specify and initialize the network receive port(s). The port numbers are more or less arbitrary, as long as you avoid lower numbered ports that may be in use by the operating system, or by other applications that use the network. For this example, I chose to use port 50000 for messages being received by the server and 50001 for messages being received by the client. Note that only one application may use a given port at a time, so if you plan to run multiple instances of an OSC-based Csound program on the same computer, each instance would need its own receive port(s). Since the ports will be used by multiple instruments and do not change during performance, I define them as global i-time variables. These statements are all placed in the orchestra header:


```csound

giInportS   = 50000       ;Server's receive port
giOutportS  = 50001       ;Port server will send to (i.e., the client)
giInport    = 50001       ;Client's receive port
giOutport   = 50000       ;Port client will send to (i.e., the server)

gioscC OSCinit giInport   ;initialize OSClisten for client
gioscS OSCinit giInportS  ;initialize OSClisten for server

```


OSC messages have the following basic format:
```csound

<address-string> <arg1> <arg2>...<argN>

```


The address string is similar to a directory path, e.g.: /music, /fader/3, /BankA/button/1, etc. There can be multiple arguments following the address string, but the type of each argument must be specified. The most commonly used types are int (i), float (f), and string (s). The numbers and types of arguments listed in a pair of `OSCsend` and `OSClisten` opcodes used to send and receive a particular OSC message must agree exactly, as well as the OSC address, or the message will be sent, but not received. Moreover, no error message will be generated by the `OSClisten` opcode, so it can be difficult to debug such problems.

A section of code (from instr 2 of the example orchestra) that sends an OSC message from the client machine asking to join the user group is shown below. The complete CSD file can be downloaded from the link given above.
```csound

;changing the update flag causes OSCsend to transmit
kupdate =       kupdate+1
        OSCsend kupdate,gSserverIP,giOutport,"/join/user","ss",gSname,gSlocalIP

```


This statement sends two strings (`gSname` and `gSlocalIP`) to port `giOutport` on IP address `gSserverIP`. Note that `OSCsend` transmits messages when the value of its `kwhen` parameter (`kupdate` in this example) changes. Using a trigger signal for this purpose is not a good idea, because it will cause messages to be sent twice—once when the trigger value is 1 and then again when it returns to 0. Thus I generally use a trigger in conjunction with a k-variable, which I increment every time the trigger equals 1.

 The server listens for such messages, as shown below:
```csound

;Listen for user join requests
ktrg4   OSClisten   gioscS, "/join/user", "ss", Suser, SuserIP
        if (ktrg4 == 1) then
;process this request...

```


Here, `OSClisten` is using the port specified in the `OSCinit` statement in the orchestra header. The variable `gioscS` contains the "handle" returned by `OSCinit`. It is this handle that must be used as the first argument to `OSClisten`, rather than the name of the port, itself. The only OSC messages that this particular `OSClisten` will recognize are those beginning with the address `/join/user` and having two strings as arguments. Note that the `Suser` and `SuserIP` string variables in the arguments field of `OSClisten` are output variables, even though they appear to the right of the opcode. They must be initialized prior to being used, which I do at the top of the server instrument (instr 99 in the example orchestra) with the following statements:
```csound

Suser   strcpy ""
SuserIP strcpy ""

```


When `OSClisten` receives a valid (matching) OSC message, it sets `ktrg4` to 1 for a single k-period. This is both efficient and convenient, because it easy to use the trigger in conjunction with an `if` statement to only execute the processing code when a new `/join/user` message has been received.
### Connecting the Ensemble


To connect the various client machines, the server must build and maintain lists of user names and IP addresses. This is easy to do in Csound6, because of its support for string arrays. In the orchestra header, I first define a macro, `$MAXUSERS`, used to determine the size of the string arrays, and then initialize them as follows:
```csound

gSUsers[]   init $MAXUSERS  ;Array of user names
gSIPs[]     init $MAXUSERS  ;Array of user IP addresses
gSUsers[0]  strcpy ""       ;initialize the first locations with a null string
gSIPs[0]    strcpy ""

```


I also define two UDOs, which make it easier to add and find users:
```csound

;--------------------------------------------------------------------------------
opcode        finduser,k,Sk ;finds a user's number in the user group
              Sname,kNUsers xin
kindex        =           0
loop:
kres          strcmpk     gSUsers[kindex],Sname
              if          (kres == 0) goto end
              loop_lt     kindex,1,kNUsers,loop
kindex        =           -1    ;not found
end:
              xout        kindex
              endop
;--------------------------------------------------------------------------------
opcode            adduser,k,SSi ;adds a new user to the user group
                  Sname,SIP,imaxusers xin
                  if (gkusers == imaxusers) then
kindex            =         -1 ;error: too many users
                  kgoto     end
                  endif
                  if (gkusers != 0) then
kuser             finduser Sname,gkusers
                  if (kuser >= 0) then
kindex            = -2 ;error: user has already joined
                  kgoto end
                  endif ;end user test if
                  endif ;end finduser if
;user has not already joined, so add
gSUsers[gkusers]  strcpyk Sname
gSIPs[gkusers]    strcpyk SIP
gkusers           = gkusers+1 ;updatethecurrentnumberofusers
kindex            = 0 ;return no error
end:
xout kindex
endop
;--------------------------------------------------------------------------------

```


The `adduser` UDO first checks to see if there is room for another user, then calls the `finduser` UDO to make sure the name is not already in the array. If it is not, `adduser` copies the name to the next available location in `gSUsers` array and the IP address to the corresponding location in the `gSIPs` array. It also increments `gkusers`, a global variable (initialized to 0 in the orchestra header) that stores the current total number of users in the group. The server then sends the OSC message `/join/confirm` to the client machine, to confirm the join request (or deny it, if the user has already joined, or there are too many users in the group).

Once a user has joined the group, s/he can request the server to send a list of user names and ip addresses, using the OSC message `/getusers`, and can also send and receive chat messages to/from other users in the group. The OSC messages defined for chatting are:
```csound

/chatsend <string username > <string chatline>
/chatreceive <string username> <string chatline>

```


All chat messages are sent to the server, which checks to see that the author is a valid user, and if so, broadcasts the chat message to the entire group. Here is the relevant server code:
```csound

ktrg5     OSClisten   gioscS, "/chatsend", "ss", Suser, Schatline
          if          (ktrg5 == 1) then
;check if we have any users in the group
          if          (gkusers == 0) goto continue
;check if this user is in the group
knth      finduser    Suser,gkusers
          if          (knth >= 0) goto broadcast ;found user, broadcast the message
;error handling here...

```


Broadcasting a chat message involves looping through the entire list of IP addresses and sending the message to each one. Since `OSCsend`'s IP address and port arguments must be set at i-time, as well as the OSC address and argument types, the easiest way to broadcast a message to multiple IP addresses is to use a dedicated instrument for each specific OSC message. Here is the instrument for broadcasting a chat message to a specific IP address:
```csound

      instr     101 ;sends a chat line to the specified IP
SIP   strcpy    p4
      OSCsend   1, SIP, giOutportS, "/chatreceive", "ss", gSuser, gStext
      turnoff
      endin

```


The instrument is passed the target IP address string in a p-field, while the name of the author and the message text are stored in global string variables. It simply sends the message to the specified IP address at i-time and then turns itself off. The instrument is called repeatedly from the server instrument using the `scoreline` opcode within a k-time loop, as follows:
```csound

broadcast:
; broadcast the message to all users
gStext    strcpyk   Schatline
gSuser    strcpyk   Suser
kndx      =         1
broadcast_loop:
Sline     sprintfk  {{i 101 0 1 "%s"}}, gSIPs[kndx-1]
          scoreline Sline, kndx
          loop_le   kndx, 1, gkusers, broadcast_loop
          endif     ;end chatsend if

```


The reason for using `scoreline`, rather than `event`, or `schedule`, is that `scoreline` permits multiple strings to be passed via p-fields. In this instance, there is just one string being passed, but in other instances, more strings need to be passed. The Csound convention for passing strings as p-field arguments requires putting them in quotations, so it is necessary to use the `{{...}}` delimiters in the `sprintfk` statement, to enclose the format string.

The client instrument must be ready and able to receive and display an incoming chat message. This requires the use of an `OSClisten` and a means to display the message in a GUI. Incoming chat messages are displayed in a scrolling window, with the most recent message at the top. Messages are displayed in the conventional format, *author: message text*. Below is shown the relevant Csound code, contained in instrument 1 of the example orchestra:
```csound

;Listen for incoming chat messages
ktrg1   OSClisten gioscC, "/chatreceive", "ss", Sname, Smsg
        if        (ktrg1 == 1) then
Sname   strcatk   Sname, ": " ;add a colon and space after the author's name
Sline1  strcatk   Sname, Smsg ;then append the message

;Update the chatwindow in CsoundQT
        outvalue  "chatline3", Sline3 ;oldest message
        outvalue  "chatline2", Sline2 ;previous message
        outvalue  "chatline1", Sline1 ;current message
Sline3  strcpyk   Sline2 ;move the old lines down now, in
Sline1  strcpyk   Sline1 ;preparation for the next message
        endif     ;end chat receive if

```

### Synchronization


The key to synchronizing multiple laptops over a conventional TCP/IP-based network is to establish a global time, or master clock, that all the machines can reference. Since internet communication (especially involving wireless networks) is inherently unreliable, especially in terms of timing, it is not practical to rely upon sending any sort of clock signal over the network, as a way to synchronize music. Instead, each client machine needs to have its own internal clock running, and to adjust its local time base dynamically to keep it synchronized with that of the server.

The method I use for this is an adaptation of one devised by Roger Dannenberg, of Carnegie Mellon University. His articles on the method are listed below in the references [[1]](https://csoundjournal.com/#ref1) - [[3]](https://csoundjournal.com/#ref3). As mentioned in the Overview, the client machines periodically query the server to find out what the current time is, and the server replies to each such query. The challenge lies in dealing with the network latencies, which are inevitable. The client sends a query at time `T1`, the server receives it and replies at time `T2`, and the client receives the reply at time `T3`.

The problem is that the intervals between these times are variable and unpredictable. In any case, no matter what the latency is, by the time the client receives the clock message from the server, it is no longer accurate, because the server's clock has continued to run in the interim. Dannenberg's solution to this problem is two-fold: first, discard any timing messages that take longer than some threshold to arrive; and second, assume that the amount of time that has elapsed since the server replied is 1/2 the round trip time. Hence, if the response to a query takes less than the threshold time to arrive, we estimate the actual server time `Ts` as follows:
```csound

Ts = Tr + (T3-T1)/2

```


Where `Tr` is the time reported by the server in response to a query, `T1` is the time the query was sent and `T3` is the time the reply was received. Hence, `T3-T1` is the round trip time, and we add half of that amount to *Tr* to approximate what the actual server time (`Ts`) is right now. Knowing that, we can continuously adjust the client's local clock (`Tc`) to match the server's clock by adding an offset, which is equal to `Ts-Tc`. (This assumes that the server's clock has been running longer than the client's clock, which is usually the case.)

It is important to note that the threshold must be picked very carefully, through experimentation on the particular network. If it is set too high, then longer round trip times will cause glitches, because the estimated server time will be inaccurate. If it is set too low, on the other hand, then timing messages from the server will only get through occasionally, if ever. Similarly, the query rate must be fast enough to allow for (possibly) numerous slow round trip replies to be discarded, while still keeping accurate track of the server's clock. But it must not be so fast that, with multiple machines all issuing such queries, the server cannot keep up. According to Dannenberg, the best method to use is to periodically send a burst of queries and always use the one with the fastest round trip time. However, this seemed too difficult to implement with Csound, so I went with the threshold method.

 The format of the time query OSC message is:
```csound

/timeq <string username> <float query_time> <string ipaddress>

```


 ...where `query_time` is the local clock time when the `/timeq` message was sent. The `username` is provided so that the server can check to see if the requester is a valid member of the group. However, checking this on every query involves some overhead and is usually not worth the trouble. Consequently, the server can just reply directly to the `ipaddress`, without bothering to check.

 The reply message format is:
```csound

/timeq/response <float server_time> <float query_time>

```


The `query_time` is provided in the message, along with the current `server_time`, to facilitate round trip calculation. The client code to handle the `/timeq/response` message is as follows:
```csound

ktrg2   OSClisten gioscC, "/timeq/response", "ff", ktimeS, ktimeQ
        if        (ktrg2 == 1) then
kdiff   =         ktimeL - ktimeQ           ;round trip query time
        if        (kdiff < $THRESH) then ;if less than threshold
ktimeS  =         ktimeL+koffset,.05        ;assume Server time is now 1/2 diff later
koffset =         ktimeS - ktimeL           ;offset is the difference from local time
        endif     ;end check threshold if
        endif     ;end OSClisten if
gktimeA portk     ktimeS + kdiff/2          ;smooth any changes

```


The `ktimeL` variable is the local clock time, which is adjusted to match the server's time by adding the offset value koffset. This happens continuously (at the krate), whereas `koffset` is only changed when a `/timeq/response` message is received with a round-trip time less than the threshold (`$THRESH`) value.

 The client sends `/timeq` messages to the server at a set rate (`$TIMEQHZ`), as follows:
```csound

ktrigQ  metro   $TIMEQHZ          ;check server TIMEQHZ times/second
        if      (ktrigQ == 1) then
        OSCsend ktimeL, gSserverIP, giOutport, "/timeq", "sfs", gSname, ktimeL, gSlocalIP
        endif   ;end metro if

```


 Note that in addition to including `ktimeL` as the 2nd parameter for the OSC message, I also use it as the `kwhen` parameter for `OSCsend` here, since it is always incrementing.
### Musical Time


 Musical time is expressed in beats (quarter notes at a given tempo), and grouped into measures/bars according to the current meter. A client's local time is derived from the `timeinsts` opcode, which provides the elapsed time in seconds since an instrument was started, at the k-rate. The local time is converted from seconds to beats by continuously multiplying it by a tempo factor, which is the number of beats/second at the current tempo. The server controls the tempo and meter, and it keeps track of the beat count and the current bar number. It only notifies the clients if the tempo or meter has changed, but clients can issue a beat request to the server, if they ever need this information. The OSC message to request the current beat from the server is:
```csound

/beatq <username>

```


 The server responds to the user who sent this message with the following:
```csound

/beatq/response <beat><time><tempo><meter><offset_beat><offset_time><offset_bar><bar_beat>

```


 Where:   `<beat>` is the integer number of the server's most recent beat `<time>` is the floating point time that the most recent beat occurred  is the current floating point tempo in beats/minute `<meter>` is the current integer number of beats/bar `<offset_beat>` is the integer beat number at the last tempo or meter change  `<offset_time>` is the floating point time of the last tempo or meter change  `<offset_bar>` is the integer bar number at the last tempo or meter change  `<bar_beat>` is the integer beat number of the offset bar

 All this information is necessary, because each client is responsible for maintaining its own count of beats and measures, based on its local clock. If the meter never changed, the local beat and measure could simply be calculated from the latest beat, time, and tempo provided by the server, based on the amount of time elapsed since then. However, since both the tempo and the meter can change during the performance, the current beat and bar number must be calculated as follows:
```csound

current_beat = offset_beat + int((current_time - offset_time) * beats_per_second)
current_bar = offset_bar + int((current_beat - bar_beat) / meter)

```


 To account for the time elapsed since the server reported the current beat, it is necessary to compare the current local time to the time of the last beat reported by the server and wait until the server's next beat boundary before making any adjustments. The wait is implemented with `timout`. Below is shown the client code (from instrument 3 in the example orchestra) for handling a `/beatq/response` message from the server:
```csound

ktrg      OSClisten   gioscC, "/beatq/response", "iffiifii", kbeatN, ktimeN, \
                            kStempo, kSmeter, kSoffset, kSbase, kSoldbar, kSoldbeat
          if          (ktrg == 1) then
kbeatDur  =           60./kStempo
kcurBeat  =           kbeatN + (gktimeA-ktimeN)/kbeatDur    ;current fractional beat
kwait     =           (1-(kcurBeat-int(kcurBeat)))*kbeatDur ;time until next beat
krflag    =           1                   ;turn on the reset flag
          reinit      start               ;reinit the timout to wait until next beat
          endif                           ;end OSClisten ktrg if
          if (krflag == 0) goto skipover  ;skip timout except when reset flag is set
start:    timout      0,i(kwait),skipover ;wait until next beat boundary
          rireturn

                                          ;after timout completed, update everything
          outvalue    "Tempo",kStempo     ;display/change to server's current tempo
gkMeter   =           kSmeter             ;change to server's current meter
kMeter    init        i(gkMeter)-1        ;workaround for outvalue at i-time issue
kMeter    =           gkMeter-1           ;meter number in menu
          outvalue    "Meter",kMeter      ;display current meter in menu
gkOffset  =           kSoffset            ;reset everything else to match server
gkBase    =           kSbase
gkOldbar  =           kSoldbar
gkOldbeat =           kSoldbeat
krflag    =           0                   ;clear the reset flag
skipover:                                 ;timout branch target

```

### Performing Synchronized Music


 Since all the clients are continuously adjusting their local clocks to keep them synchronized with the server, and since they know the current tempo, meter, beat, and bar, keeping the music synchronized is reasonably straightforward. However, it is not possible to use `metro` to trigger notes at the current tempo, because `metro`'s internal clock is not synchronized with our adjusted local clock. Instead, triggers must be generated at the desired rhythmic subdivision (or tick duration) directly from the clock, as follows:
```csound

tick_number = int(local_time * beats_per_second / ticks_per_beat)

- if tick_number has changed, generate a trigger

```


 Below is a simple instrument that generates notes at a particular rhythmic subdivision on a slave instrument (instr 10) using `schedkwhen`:
```csound

        instr 5                     ;starts via GUI and schedules notes with pluck
;Count ticks (subdivisions) since the last downbeat
kTick   =           int(((gktimeA - gkBarTime) * gkTempo/60.) / gkPluckDiv)
kTTrig  changed     kTick
        schedkwhen  kTTrig,0,0,10,gkdelay,.25,.5,kTick endin

```


 Here, `gkBarTime` is the time of the last downbeat, which is set by the clock instrument (instr 3) every time the bar changes. The variable `gkPluckDiv` is set by the user via the GUI (monitored by instr 4), and it is equal to the tick duration as a fraction of a beat. (E.g., a sixteenth note would be .25). Hence, `kTick` will be the integer number of ticks that have occurred since the last downbeat, beginning with 0, and a trigger will be generated every time there is a new tick. (Note: The global variable `gkdelay` is used by every instrument that schedules notes. It is used to offset the actual start time of the scheduled note to compensate for latencies in the audio interfaces of other client computers. Before a performance, all the computers must manually adjust their delay time to match the playback of the computer with the greatest latency. A simple blip generator instrument is provided to facilitate this.) Below is shown the slave instrument:
```csound

            instr     10 ;Pluck Harmonics instrument
iAmp        =         p4
iTick       =         p5
            kgoto     skip ;Check widget value at i-time only
kCutoff     invalue   "PluckLPFCutoff"
skip:
kamp        linen     iAmp*gkPluckVol,.01,p3,.15
icps0       =         cpsmidinn(24+i(gkPluckKey))
            if        (i(gkWrap) == 0) then
;Wrap
iMod        =         i(gkHarmMod)
icps        =         icps0+icps0*wrap(iTick,0,iMod)
else
;Fold
iMod        =         i(gkHarmMod)-1
icps        =         icps0+icps0*mirror(iTick,0,iMod)
            endif
asig        pluck     kamp,icps,icps0*8,0,6
asig        butlp     asig,cpsoct(i(kCutoff))
            outs      asig,asig
            endin

```


 Instrument 10 generates a lowpass-filtered note with `pluck`. The variables `gkPluckVol`, `gkPluckKey`, `gkWrap`, and `gkHarmMod` are set by CsoundQT widgets that are read by instrument 4. The pitch of each note is determined by the tick number, which is passed by `schedkwhen` in p5. As the tick numbers increase from 0, the pitches attempt to climb the harmonic series based on the frequency of `gkPluckKey`, but are either wrapped or folded between the fundamental (`icps0`) and `icps0 * gkHarmMod`. This can result in interesting patterns that either reinforce or contradict the prevailing meter, since the tick number is always reset to 0 at every downbeat, regardless of where we are in the sequence of harmonics. Because ticks are generated directly from the clock, any subdivision is possible, and different instruments can be working with different rhythmic values, which may or may not be related to the meter.
### Scheduling Future Events


 The system provides a convenient mechanism for scheduling events at some future time. Events are defined as snapshot (or preset) changes, which can include tempo and meter changes, as well as parameter changes for sound generating instruments. They can be scheduled locally, to occur on a single machine, or through the server, to be scheduled on all the machines. They can also be scheduled to occur at a specific bar in the future, or some number of bars relative to the current one. There is a dedicated instrument (instr 98), which handles the scheduling. When instantiated, it simply runs until the scheduled bar has been reached, then recalls the desired snapshot number and turns itself off. The instrument can be called multiple times, so that a sequence of snapshot changes can be scheduled in advance. The OSC message to schedule a snapshot change via the server is:
```csound

/schedule/request <string username> <int bar> <int snapshot> <int type>

```


 The `username` refers to the user requesting the scheduled event, which is a change to the specified `snapshot` number, to occur at the specified `bar`. The type of schedule request can be either relative (to the current bar), or absolute (as specific bar number in the future). The server listens for such requests, checks to see if the user is a member of the group, and if so, broadcasts the schedule request to every member of the group, using this OSC message:
```csound

/schedule <int bar> <int snapshot> <int type>

```


 When a client machine receives a `/schedule` message, it simply calls instrument 98, passing it the bar number, snapshot number, and type. An option is provided to allow, or ignore, incoming schedule requests.
### Sharing Function Tables


 F-tables of any length can be sent using OSC messages, although sending extremely large tables (such as audio files) is impractical. Sending pitch tables or sequence data, however, is entirely feasible. Since F-tables may be of various sizes, and since the `OSCsend` and `OSClisten` opcodes require a fixed number of parameters in their argument lists, the contents of a table are sent piecemeal—8 values per OSC message. The F-table that will receive the incoming data must already exist and be sufficiently large to hold all the data. Since it would be awkward if table data started coming in before the target machine was ready to receive it, the convention is that F-tables are only transmitted when a user specifically requests them. Here is the OSC message to request a table:
```csound

/gettab <int target_fnum> <int source_fnum> <string target_ip> <int target_port>

```


 The `target_ip` is just the IP address of the machine requesting the table. However the `target_port` for table transmission will necessarily be different from the one used to receive most other OSC messages, so it must be specified here. In the example orchestra, port 50002 is used for table transmissions.

 A machine receiving the `/gettab` message should respond to the IP address and port provided by the requestor with a series of `/filltab` messages, which have the following format:
```csound

/filltab <int target_fnum> <int start_loc> <float val1> <float val2>...<float val8>

```


 This message will send 8 floating point values, which are to be loaded into the target function table, beginning at location `start_loc`. Below is shown the instrument that sends the contents of an F-table to a specific IP address via OSC:
```csound

          instr 106               ;dumps a table via OSC
SIP       invalue "TargetIP"
kMyFn     invalue "OutputTable"
kTgtFn    invalue "TargetTable"
          tb0_init i(kMyFn)       ;table to dump
kn        init 0                  ;starting location in the table
imax      = 128                   ;gicount
loop:
  OSCsend kn,SIP,giAltport,"/filltab","iiffffffff",i(kTgtFn),kn,tb0(kn),tb0(kn+1),\
          tb0(kn+2),tb0(kn+3),tb0(kn+4),tb0(kn+5),tb0(kn+6),tb0(kn+7)

          loop_lt kn,8,imax,loop
          turnoff
          endin

```


 The receiving computer loads the data into the target function table, as follows:
```csound

ktrigT    OSClisten   gioscC, "/filltab","iiffffffff",kfn,kn,\
                      kv0,kv1,kv2,kv3,kv4,kv5,kv6,kv7
          if (ktrigT == 1 && kfn == giMyFn) then
          tablew kv0,kn,giMyFn
          tablew kv1,kn+1,giMyFn
          tablew kv2,kn+2,giMyFn
          tablew kv3,kn+3,giMyFn
          tablew kv4,kn+4,giMyFn
          tablew kv5,kn+5,giMyFn
          tablew kv6,kn+6,giMyFn
          tablew kv7,kn+7,giMyFn
          endif ;end filltab if

```


 As a precaution, a check is made to ensure that the target table number in the incoming `/filltab` message corresponds to the table the receiving machine is expecting (`giMyFn`).
## Conclusion


 An earlier version of the system described here was successfully used by an ensemble of 4 laptops in a performance at The University of Texas. The example orchestra that accompanies this article is a stripped down version of the orchestras used in the performance, which had different instruments, some of which were considerably more complicated. Each laptop performer had a different set of instruments, in fact, but they all used the same client/server code. The ensemble used a dedicated wireless router in performance, but we sometimes used the campus wireless network during rehearsals without encountering any significant timing problems. The server should always be run on the fastest machine, and ideally, should not be doing anything else.

In our concert, however, the computer running the server was also doing a full share of the music generation, without apparent difficulty. Interacting with the CsoundQT GUI, however, often did cause timing problems and glitches. Moving a fader with the mouse, for example, invariably caused timing glitches. Using it in conjunction with an external MIDI controller (a Korg nanoKontrol2), however, seemed to solve that problem.

Future enhancements will include the capability for the server to push table data to the client machines on a scheduled basis, for audio captured on one machine to be shared with other machines, OSC communications with video/graphics software (such as Isadora), and greater use of gestural controllers.
## References


[][1] Roger Dannenberg, and Eli Brandt, "Time in Distributed Real-Time Systems." [Online] Available: [http://www.cs.cmu.edu/~rbd/papers/synchronous99/synchronous99.pdf](http://www.cs.cmu.edu/~rbd/papers/synchronous99/synchronous99.pdf) [Accessed August 15, 2015].

[][2] Dawen Liang, Guangyu Xia, and Roger B. Dannenberg, "A Framework for Coordination and Synchronization of Media," in *Proceedings of the International Conference on New Interfaces for Musical Expression*, Paper Session E, 30 May , 2011, Oslo, Norway. [Online] Available: [http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.450.4513&rep=rep1&type=pdf](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.450.4513&rep=rep1&type=pdf) [Accessed August 15, 2015].

[][3] Roger Dannenberg, et al, "The Carnegie Mellon Laptop Orchestra,"* Carnegie Mellon University, Research Showcase@CMU*, August, 2007. [Online] Available: [http://repository.cmu.edu/cgi/viewcontent.cgi?article=1511&context=compsci](http://repository.cmu.edu/cgi/viewcontent.cgi?article=1511&context=compsci) [Accessed August 15, 2015].

[][4] Matt Wright, "The Open Sound Control 1.0 Specification," Version 1.0, opensoundcontrol.org. March 26, 2002. [Online] Available: [http://opensoundcontrol.org/spec-1_0](http://opensoundcontrol.org/spec-1_0) [Accessed August 15, 2015].
