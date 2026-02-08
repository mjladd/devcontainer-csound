---
source: Csound Journal
issue: 21
title: "Handle Csound with a BCF2000"
author: "hand takes more time"
url: https://csoundjournal.com/issue21/bcfcsound.html
---

# Handle Csound with a BCF2000

**Author:** hand takes more time
**Issue:** 21
**Source:** [Csound Journal](https://csoundjournal.com/issue21/bcfcsound.html)

---

CSOUND JOURNAL[](https://csoundjournal.com/../index.html) | [Issue 21](https://csoundjournal.com/index.html)
## Handle Csound with a BCF2000

 Olivier Baudouin
 olivierbaudouin AT gmail.com
## Introduction


The BCF2000 [[1]](https://csoundjournal.com/#ref1), by Behringer, is a popular MIDI controller for home studio. I have used this device to control Csound for several years, and in a variety of ways, so that today I feel the need to re-assemble, re-write, and rationalize all my Csound orchestras into a new set of User-Defined opcodes (UDO) named *BCFcsound*. The design of this program is mainly based on three ideas:
- Be able to move freely into the composition time
- Do not write code for a trajectory that can be drawn by hand
- Save and backup live data on the fly

The first principle is similar to JACK's transport (but JACK is not necessary), and rather implies compositions where events are triggered from "alwayson" instruments. **A foot switch is required to trigger recording operations**.

In the first section, we describe in detail how to set and to operate the BCF2000 so that it can correctly work with BCFcsound. In the second section, we give explanations about how to run BCFcsound. Finally, we will discuss how it works.
## I. Set and Operate the BCF2000

### Settings


There are two ways to setup the BCF2000: either by a Java software provided by Behringer, and/or manually by hand. With BC-Edit (Figure 1), the device can be set in four steps:
- Scan connected device(s)
- Select target device
- Import SysEx (file BCF-presets.syx)
- Select target presets

`BCF-presets.syx` defines two, ready-to-use presets on MIDI channels 1 and 2; users should typically opt for presets 1 and 2 as target. Some values can be customized (see below), and additional presets can be created by copying.

![image](bcf2000/bcedit.jpg)
 **Figure 1. Importing SysEx file with BC-Edit software.**

Proceeding by hand takes more time, but it is interesting because it helps to memorise the layout of controllers and channels. By now, it is assumed that users have studied their BCF2000 manual [[2]](https://csoundjournal.com/#ref2). Controller numbers appear in Figure 2 and Table 1. In Figure 2, a white color means that the controller channel is the current channel (i.e., channel 1 for preset 1, channel 2 for preset 2, etc.) and a red color means that the controller channel is the "control channel" (the channel of the first preset—usually channel 1—for all presets).



TYPE

CH

PAR

VAL1

VAL2

MODE

OPTION

DISPLAY

Encoders (41 → 47)

CC

Current

41 → 47

0

127

ABS (7 bits)

1d

On

Encoder 48

CC

Current

48

0

127

ABS

bar-

On

Encoders push buttons (51 → 57)

CC

Current

51 → 57

127

0

ABS

t on

On

Encoders  push button (58)

CC

Current

58

127

0

ABS

t on

On

Push buttons  (61 → 67, 71 → 77)

CC

Current

61 → 67,

71 → 77

127

0

ABS

t on

On

Push buttons 68, 78

CC

Control ch. (1)

68, 78

127

0

ABS

t on

On

Push buttons 21, 22

CC

Current

21, 22

127

0

ABS

t off

On

Push buttons 23, 24

CC

Control ch. (1)

23, 24

127

0

ABS

t off

On

Faders (1 → 7)

CC

Current

1 → 7

0

500

ABS14 (14 bits)

mot

On

Fader 8

CC

Control ch. (1)

8

0

Duration

of the piece

ABS14

mot

On

**Table 1. Full table of the BCF2000 parameters.**

![image](bcf2000/bcf-cc.jpg)
 **Figure 2. The layout of controllers**
### Customization


The gray squares in Table 1 indicate that the parameter can (or must be) changed. For example, **the second value of the time scroll fader must match with the duration of the piece** (several errors occur if this value exceeds the duration). You may also adjust mappings: fader 1 can be redefined to send values from 10 → 20 , encoder 3 from 100 → 0, etc. Setting the BCF manually may be of interest as it avoids adding conversion formulas to the user's CSD. Note that encoder groups (top right of Figure 2; only groups 2, 3 and 4) can be set to add 8x3 new—and separated from BCFcsound—parameters.
### Operate the device


Figure 3 shows the operational mapping of the BCF2000. Red areas are "control zones", and green areas are "data zones". The remaining area contains functions (see BCF2000 manual) that are not detected by Csound, such as the encoder groups or preset pad. "Data" controllers send values that are returned and recorded by BCFcsound. Only fader values (yellow frame) are recorded at k-rate, while encoders and their push buttons (and faders in manual mode, explanation below) are given back at init-time, or when the button "restore" is pressed.

Users have at their disposal two kinds of data controllers: faders for trajectories; and buttons and encoders for constants or single settings. When "shoot" is pressed, all controllers contained in the orange frame are recorded into a shot by preset, so that the user can call back his own controllers placement for a given time with "restore". To save fader data into files after a record, press the "save or backup" button. A short press will rewrite previous files, and a long press will create a time-stamped backup.

![image](bcf2000/bcf-zones.jpg)
 **Figure 2. Operational mapping of the BCF2000.**

The BCF2000 can operate in three "modes" (Table 2), according to the state of the "play" and "rec" buttons, and the foot switch (these modes are fully enabled in the "full mode", while only manual mode is available in the "single mode", see manual-type description below). In manual mode, faders can be moved freely, but data is not recorded into a table. In play mode, the last saved or recorded table is read, and the fader is actionated by its motor, if the "motors" button is on (LED crown on). Note that the time scroll fader motor is permanently disabled. When a "Rec" button is turned on, the corresponding fader is armed for recording and its "play" button is automatically turned on. While the foot switch remains off, the fader stays in play mode and table data are still sent. When the foot switch is pressed, the fader movements are recorded into a table, and the LED crown for "motors" blinks. At release, the fader returns to play mode.

If you are happy with the result, do not forget to press "save". You can replay your musical passage by moving the time scroll fader. While moving it, you can hold down the "time leap" button to avoid rewinding effects. Finally, two additional functions have been implemented to facilitate work with Csound: "kill" calls the `exitnow` opcode, and "recompile" calls `compileorc` (see CSD template below) or any other function.



PLAY

REC

FOOT SWITCH

Manual mode

off

off

-

Play mode

on

off

-

Play mode

on

on

off

Record mode

on

on

on

**Table 2. Operating modes**
## II. Run BCFcsound

### Description of the CSD template


The file BCFtemplate.csd contains the usual csound options, such as realtime audio and MIDI input/output or environment variables. BCFcsound has been designed on UbuntuStudio, and you may have to modify lines of the code shown below. Place the BCFcsound *.inc files (BCF.inc and BCFOPCODE.inc) in the current folder or, if defined, in the Csound include folder.
```csound

;AUDIO
-+rtaudio=<alsa>
-odac
;MIDI
-+rtmidi=<alsa>
-M hw:<3,0,0> ;from BCF2000
-Q hw:<3,0,0> ;to BCF2000
;ENVIRONMENT
--env:SFDIR=<mypath>/audio
--env:SADIR=<mypath>/analysis
--env:INCDIR=<mypath>/include
;DISPLAY
--m-warnings=0
(...)

```


BCFcsound works smoothly with kr = 4410, but this default value can be changed according to each system's features. Remember that `kr` cannot be changed once data have been saved. Another option however is to erase that data.
```csound

sr = 44100
kr = 4410
(...)

```


Definitions are optional: users can define a path where to save files and another one where to backup files. If not defined, files are saved in the current folder. The user defined opcode `BCF1` is automatically created by BCF.inc. To also use preset 2, define `BCF2` and so forth up to `BCF4`. Note that working with more than two presets may be complicated and resource-intensive. Each `BCF` opcode is created separatly from the others in order to protect MIDI initialization processes.
```csound

;OPTIONAL
#define BCFPATH #<mypath>/BCF/# ;don't forget the last slashe
#define BCFBACKUPPATH #<mypath>/BCF/backup/# ;Windows: backslashes
#define BCF2 ##
;#define BCF3 ##
;#define BCF4 ##
;========
;REQUIRED
#include "BCF.inc"
(...)

```

### Csound manual-type description of the BCFx user defined opcode


BCFx allows to easily control Csound via a BCF2000. `BCF1` matches with preset 1, `BCF2` with preset 2, `BCF3` with preset 3, and `BCF4` with preset 4.

**Syntax**
```csound

kfad1, kfad2, kfad3, kfad4, kfad5, kfad6, kfad7, \\
kenc1, kenc2, kenc3, kenc4, kenc5, kenc6, kenc7, \\
kbut1, kbut2, kbut3, kbut4, kbut5, kbut6, kbut7, \\
krecompile, kcurtime <b>BCF1</b> ichn, imode, iduration, ictrlchn, idisplay

```


**Initialization**

*ichn* -- MIDI channel of the BCF preset.

*imode* -- Single mode (0) or full mode (1). In the single mode, data functions (reading/saving tables) are disabled (but shot values are backed up at init time). All functions are enabled in the full mode.

*iduration* -- The piece duration, in seconds. Be careful, as table size is computed from this i-value, and therefore, the piece's duration cannot be changed once data have been saved (or erased).

*ictrlchn* -- MIDI channel for control operations. Must match with the MIDI channel of `BCF1`.

*idisplay* -- 0 or 1; if = 1, display time in the console (composition time and last position of the fader 8).

Last recorded shots are restored at i-time (except for faders in play mode), as well as last recorded tables.

**Performance**

*kfad1..7* returns values from fader 1 to 7. Use `port` or `portk` to smooth the signal.

*kenc1..7* -- returns values from encoder 1 to 7. Use `port` or `portk` to smooth the signal.

*kbut1..7* -- returns values from encoder push button 1 to 7.

*krecompile* -- only returns value from button 23 (Figure 2). It can be used to trigger recompilations (see example below).

*kcurtime* -- returns the current time of the composition. It does not match with the real time of execution. When several `BCFx` opcodes are defined, use only the last `kcurtime`. Using more than two presets significantly increases the CPU load.

**Example**

The example files BCFtemplate.csd and BCFtemplate.orc are shown below. You can download all the BCF example files shown in this article from the following link: [BCFexs.zip](https://csoundjournal.com/downloads/BCFexs.zip).

 BCFtemplate.csd
```csound

<CsoundSynthesizer>

<CsOptions>
;AUDIO
-+rtaudio=alsa
-odac
;MIDI
-+rtmidi=alsa
-M hw:3,0,0
-Q hw:3,0,0
;ENVIRONMENT
--env:SFDIR=<mypath>/audio
--env:SADIR=<mypath>/analysis
--env:INCDIR=<mypath>/include
;DISPLAY
;--m-warnings=0
</CsOptions>

<CsInstruments>

sr = 44100
ksmps = 10
nchnls = 2

;-----------------;
;       BCF       ;
;-----------------;
;========
;OPTIONAL
#define BCFPATH #<mypath>/BCF/# ;don't forget the last slashes
#define BCFBACKUPPATH #<mypath>/backup/# ;Windows: backslashes
#define BCF2 ##
;#define BCF3 ##
;#define BCF4 ##
;========
;REQUIRED
#define BCFREALDUR #600# ;macro or init variable. Must match with score duration.
#include "BCF.inc"
;-----------------;
gSinstr1 init "BCFtemplate.orc"

    instr Recompile

iMode init 1
iRelease init 0.1

iIns1 nstrnum "Instr1"
turnoff2 iIns1, iMode, iRelease
;iIns2...

iRes compileorc gSinstr1
schedule "Instr1", 0, $BCFREALDUR
if (iRes == 0) then
  Smess2 = "OK!\\n\\n"
else
  Smess2 = "FAILED!\\n\\n"
endif

Smess strcat "\\n\\nRECOMPILATION ", Smess2
prints Smess

turnoff

    endin

    instr Main

iBCFmode init 1
iBCF1chn init 1
iBCF2chn init 2
iBCF1dispTime init 1
iBCF2dispTime init 0
iBCFctrlChn init iBCF1chn

gkf1, kf2, kf3, kf4, kf5, kf6, kf7, \\
ke1, ke2, ke3, ke4, ke5, ke6, ke7, \\
kb1, kb2, kb3, kb4, kb5, kb6, kb7, \\
kRecompile_, kCurTime_ BCF1 iBCF1chn, iBCFmode, $BCFREALDUR, iBCFctrlChn, iBCF1dispTime

gkf1b, kf2b, kf3b, kf4b, kf5b, kf6b, kf7b, \\
ke1b, ke2b, ke3b, ke4b, ke5b, ke6b, ke7b, \\
kb1b, kb2b, kb3b, kb4b, kb5b, kb6b, kb7b, \\
kRecompile, kCurTime BCF2 iBCF2chn, iBCFmode, $BCFREALDUR, iBCFctrlChn, iBCF2dispTime

iRes compileorc gSinstr1
schedule "Instr1", 0, $BCFREALDUR
;Instr2...

schedkwhen kRecompile, 0.1, 1, "Recompile", 0, 1

    endin

</CsInstruments>
<CsScore>

#define DUR #600#
i "Main" 0 $DUR.

</CsScore>
</CsoundSynthesizer>

```


BCFtemplate.orc
```csound

    instr Instr1

printk2 gkf1
printk2 gkf1b

    endin

```

## III. Technical description of BCFcsound

### The BCF.inc file


Users only have to include this file to create `BCFx` opcodes. Because of initialization issues, each `BCF` opcode is created separately from the others by successive inclusions of the file `BCFOPCODE.inc`. `BCF.inc` also defines three instruments that must be initializated only when called: `BCFexit` to quit Csound, `BCFtoFiles` to save recorded tables, and `BCF2L` to implement a dual lamp function (play buttons are automatically switched on when their matching record buttons are activated). Both files are included in the download link for example files, shown above.
```csound

(...)
    instr BCFexit
    instr BCFtoFiles
    instr BCF2L
(...)

    opcode BCF1, kkkkkkkkkkkkkkkkkkkkkkk, iiooo
#include "BCFOPCODE.inc"
    endop

#ifdef BCF2
    opcode BCF2, kkkkkkkkkkkkkkkkkkkkkkk, iiooo
#include "BCFOPCODE.inc"
    endop
#end
(...)

```

### The BCFOPCODE.inc file


 Explanations are given within the code, which have been reduced to make understanding easier.
```csound

;---------;
;OPCODE IN;
;---------;

iChn, iMode, iDur_, iCtrlChn, iDisp xin
;; UDO init parameters.

iDur = iDur_+20 ;20 sec. = safety margin
;; A safety margin of 20 sec. is added to avoid table index overflows.
;-------------------;
;MIDI INITIALIZATION;
;-------------------;

;load last shot
iTshot ftgen 0, 0, -38, -7, 0, 37, 0
iTF8 ftgen 0, 0, -2, -7, 0, 1, 0
Sshot sprintf "$BCFPATHBCF%i-SHOT", iChn
SF8 = "$BCFPATHBCFBCF-SHOTF8"
iValidShot filevalid Sshot
iValidF8 filevalid SF8

(...)

SHOTRESTORE:
 ;before tab_i to get last recorded data
;; Beginning of shot MIDI reinitialization (and rest of shot initialization).

;load (or reload) shot and F8
if (iValidShot == 1) then
  ftload Sshot, 0, iTshot
endif
if (iValidF8 == 1) then
  ftload SF8, 0, iTF8
endif

;read shot
if1 tab_i 1, iTshot
..
if7 tab_i 7, iTshot
ib1 tab_i 8, iTshot
..
ib8 tab_i 15, iTshot
im1 tab_i 16, iTshot
..
im7 tab_i 22, iTshot
ir1 tab_i 23, iTshot
..
ir7 tab_i 29, iTshot
ie1 tab_i 30, iTshot
..
ie8 tab_i 37, iTshot

if8 tab_i 0, iTF8

;init faders
initc14 iChn, 1, 33, if1/16383

;; Note the MSB and LSB of fader controller numbers. The value 16383 (14 bits) corresponds to the "MODE" setting of fader on the BCF2000 (see Table 1).

initc14 iChn, 7, 39, if7/16383

initc14 iCtrlChn, 8, 40, if8/16383
;init encoders
ctrlinit iChn, 41, ie1, .. 48, ie8
;init push buttons of encoders
ctrlinit iChn, 51, ib1*127, .. 58, ib8*127
;init reading push buttons
ctrlinit iChn, 61, im1*127, .. 67, im7*127
;init recording push buttons
ctrlinit iChn, 71, ir1*127, .. 77, ir7*127

rireturn ;SHOTRESTORE
;; End of shot MIDI reinitialization.

;------------------;
;BCF INITIALIZATION;
;------------------;
;; Send MIDI initialization data to the BCF2000.

;faders
outic14 iChn, 1, 33, if1, 0, 16383
..
outic14 iChn, 7, 39, if7, 0, 16383

kf1 init if1 ;because of init into SHOTRESTORE
;; Only at initialization.
..
kf7 init if7

;init f8
outic14 iCtrlChn, 8, 40, if8, 0, 16383
;encoders
outic iChn, 41, ie1, 0, 127
..
outic iChn, 48, ie8, 0, 127
;push buttons of encoders
outic iChn, 51, ib1, 0, 1
..
outic iChn, 58, ib8, 0, 1
;reading push buttons
outic iChn, 61, im1, 0, 1
..
outic iChn, 67, im7, 0, 1
;recording push buttons
outic iChn, 71, ir1, 0, 1
..
outic iChn, 77, ir7, 0, 1

;--> single mode
if (iMode == 0) then
  prints "\\nSINGLE MODE\\n\\n"
  igoto SINGLEMODE1
endif
;; No tables in single mode.

;---------------------;
;TABLES INITIALIZATION;
;---------------------;

iTf1 ftgen 0, 0, iDur*kr, -7, 0, iDur*kr, 0
..
iTf7 ftgen 0, 0, iDur*kr, -7, 0, iDur*kr, 0

S1 sprintf "$BCFPATHBCF%i-F1", iChn
..
S7 sprintf "$BCFPATHBCF%i-F7", iChn

;load tables
iValidTf1 filevalid S1
if (iValidTf1 == 1) then
  ftload S1, 0, iTf1
endif
..
iValidTf7 filevalid S7
if (iValidTf7 == 1) then
  ftload S7, 0, iTf7
endif

;-----------;
SINGLEMODE1:; Label
;-----------;

;--------;
;READ BCF;
;--------;
;; Hardware controllers of the BCF2000 are read there, except for faders 1 → 7 (further)

;encoders
ke1 ctrl7 iChn, 41, 0, 127
..
ke8 ctrl7 iChn, 48, 0, 127
;push buttons of encoders
kb1 ctrl7 iChn, 51, 0, 1
..
kb8 ctrl7 iChn, 58, 0, 1
;reading push buttons
km1 ctrl7 iChn, 61, 0, 1
outkc iChn, 61, km1, 0, 1
 ;for BCF2L to work well
..
km8 ctrl7 iCtrlChn, 68, 0, 1
 ;m8 : no BCF2L
;recording push buttons
kr1 ctrl7 iChn, 71, 0, 1
..
kr8 ctrl7 iCtrlChn, 78, 0, 1
;pad
kp1 ctrl7 iChn, 21, 0, 1
kp2 ctrl7 iChn, 22, 0, 1
kp3 ctrl7 iCtrlChn, 23, 0, 1
kp4 ctrl7 iCtrlChn, 24, 0, 1
;foot switch
kSw ctrl7 iCtrlChn, 11, 0, 1

;--------------;
;TIME SCROLLING;
;--------------;
;; Fader 8 is used to move into the composition time.

kLastTk init 0
kRTk timek
kLastT init 0
kRT times

;time leap
if (kr8 == 0) then
  kf8 ctrl14 iCtrlChn, 8, 40, 0, 16383
endif

;detect f8 movements
ktrig_f8 changed kf8
if (ktrig_f8 == 1 || km8 == 1) then
  kLastT = kRT
  kLastTk = kRTk
endif

;calculation of time index (sec. and k-rate)
kCT = kf8 + kRT-kLastT
kCTk = kf8*kr + kRTk - kLastTk

;display time and f8 current position
cggoto (iDisp == 0 || iChn != iCtrlChn), SKIPDISP
  ktrig_metro metro 10
  printf "%6.2f  |  %6.2f\r", ktrig_metro, kCT, kf8
SKIPDISP:

;-------;
;EXITNOW;
;-------;
schedkwhen kp3, 0, 0, "BCFexit", 0, 0
;; To exit quickly Csound.

cggoto (iMode == 1), FULLMODE

;-----------;
;SINGLE MODE;
;-----------;
;; Only when Mode = 0

kf1 ctrl14 iChn, 1, 33, 0, 16383
..
kf7 ctrl14 iChn, 7, 39, 0, 16383

cggoto (iMode == 0), SINGLEMODE2

;--------;
FULLMODE:; Label
;--------;
;; Only when Mode = 1

;SAVE OR BACKUP TABLES
ktrig_p2 changed kp2
;; Save when the second push button of the pad (bottom right of the BCF2000) is pushed.
if (ktrig_p2 == 1 && kp2 == 1) then
  kdurp2 = kCT
elseif (ktrig_p2 == 1 && kp2 == 0) then
  kTbackup = kCT-kdurp2
endif

;; Backup (saving with timestamp) when this button is held on more than 0.5 sec.
if (kTbackup >= 0.5) then
  ktrig_p2b = 1
  kBackup = 1
elseif (kTbackup > 0 && kTbackup < 0.5) then
  ktrig_p2b = 1
  kBackup = 0
else
  ktrig_p2b = 0
endif

schedkwhen ktrig_p2b, 1, 1, "BCFtoFiles", 0, 10, \\
      kBackup, iChn, iTf1, iTf2, iTf3, iTf4, iTf5, iTf6, iTf7

kTbackup = 0

;PLAY MODE
;; Only when a play button is switched on or when the fader is armed before recording (foot switch off) .
if (km1 == 1 && kr1*kSw == 0) then
  kf1 tab kCTk, iTf1
endif
..
if (km7 == 1 && kr7*kSw == 0) then
  kf7 tab kCTk, iTf7
endif

;REACTUATING FADERS
;; When exiting manual mode, set last manual values.
  ;in order to stabilize faders at their current positions
ktrig_m1 changed km1
..
ktrig_m8 changed km8

if (ktrig_m1 == 1) then
  REINITF1i:
  initc14 iChn, 1, 33, i(kf1)/16383
  outic14 iChn, 1, 33, i(kf1), 0, 16383
  reinit REINITF1i
  rireturn
endif
..
if (ktrig_m7 == 1) then
  REINITF7i:
  initc14 iChn, 7, 39, i(kf7)/16383
  outic14 iChn, 7, 39, i(kf7), 0, 16383
  reinit REINITF7i
  rireturn
endif

;ACTUATING MOTORS
;; When motorization is on, and/or when exiting manual mode, and/or for shot restoration.
if (int(kb8-km1) + kr1*kSw == 0 || ktrig_m1+ktrig_m8 >= 1) then
  outkc14 iChn, 1, 33, kf1+ktrig_m1, 0, 16383
   ;"+ ktrig_m" permits actuation when km changes
   ;with a small fader scale (e.g 1 unit = 5mm), we see that the fader is not
    ;exactly at its place, but csound and BCF data are not affected by that
endif
..
if (int(kb8-km7) + kr7*kSw == 0 || ktrig_m7+ktrig_m8 >= 1) then
  outkc14 iChn, 7, 39, kf7+ktrig_m7, 0, 16383
endif

;MANUAL MODE
;; When no playing + no recording, or while recording (rec. + foot sw.)
if (km1 + kr1 == 0 || kSw * kr1 != 0) then
  kf1 ctrl14 iChn, 1, 33, 0, 16383
endif
..
if ( km7 + kr7 == 0 || kSw * kr7 != 0) then
  kf7 ctrl14 iChn, 7, 39, 0, 16383
endif

;RECORDING MODE
;; When rec button and foot switch are on.
iTflash ftgen 0, 0, 8, 7, 1, 3, 1, 1, 0, 4, 0

if (kSw == 1) then
  kFlash oscil 1, 1.2, iTflash

  if (kr1 == 1) then
    tabw kf1, kCTk, iTf1
  endif
..
  if (kr7 == 1) then
    tabw kf7, kCTk, iTf7
  endif
else
  kFlash = 1
endif

;motor on/off indicator or rec indicator
;; Blinking while recording.
outkc iChn, 48, (kb8+kSw)*kFlash, 0, 1

;AUTOMATIC DUAL LAMP
;; If rec button is switched on, then play button is switched on.
ktrig_r1 changed kr1, km1
schedkwhen ktrig_r1*kr1, 0.1, 1, "BCF2L", 0, 0, iChn, 61
..
ktrig_r7 changed kr7, km7
schedkwhen ktrig_r7*kr7, 0.1, 1, "BCF2L", 0, 0, iChn, 67

;WRITE AND SAVE SHOT
if (kp1 == 1) then
  printks "\\n\\nSHOT %i...\\n", 1, iChn
  tabw kf1, 1, iTshot
  ..
  tabw kf7, 7, iTshot
  tabw kb1, 8, iTshot
  ..
  tabw kb8, 15, iTshot
  tabw km1, 16, iTshot
  ..
  tabw km7, 22, iTshot
  tabw kr1, 23, iTshot
  ..
  tabw kr7, 29, iTshot
  tabw ke1, 30, iTshot
  ..
  tabw ke8, 37, iTshot

  tabw kf8, 0, iTF8

  REINITSHOTW:
  ftsave Sshot, 0, iTshot
  ftsave SF8, 0, iTF8
  rireturn
  reinit REINITSHOTW
   ;because ftsave runs at init time
  printks "... OK!\\n\\n", 1, iChn
endif

;RESTORE LAST SHOT
;; Reinit has to be called twice running in order to get correct values.
krestx2 init 0

if (ktrig_m8*km8 == 1 || krestx2 == 1) then
  krestx2 = km8
   ;krestx2 : for reinit x 2
  reinit SHOTRESTORE

  igoto NORESTOREINIT
   ;to avoid init x2

  ;faders
  outkc14 iChn, 1, 33, kf1+km8, 0, 16383
  ..
  outkc14 iChn, 7, 39, kf7+km8, 0, 16383
   ;+km8 : see ACTUATING MOTORS
  ;f8
  outkc14 iCtrlChn, 8, 40, kf8, 0, 16383
  ;encoders
  outkc iChn, 41, ke1, 0, 127
  ..
  outkc iChn, 48, ke8, 0, 127
  ;push buttons of encoders
  outkc iChn, 51, kb1, 0, 1
  ..
  outkc iChn, 58, kb8, 0, 1
  ;reading push buttons
  outkc iChn, 61, km1, 0, 1
  ..
  outkc iChn, 67, km7, 0, 1
  ;recording push buttons
  outkc iChn, 71, kr1, 0, 1
  ..
  outkc iChn, 77, kr7, 0, 1
  NORESTOREINIT:
endif

;-----------;
SINGLEMODE2:;Label
;-----------;

;----------;
;OPCODE OUT;
;----------;
;; Return values to the calling instrument

xout kf1, kf2, kf3, kf4, kf5, kf6, kf7, \\
     ke1, ke2, ke3, ke4, ke5, ke6, ke7, \\
     kb1, kb2, kb3, kb4, kb5, kb6, kb7, \\
     kp4, kCT

```

## Conclusion


BCFcsound has been designed to make composition with Csound easier by the full use of a BCF2000, but this UDO should be easily adapted to other MIDI controllers as well. While testing BCFcsound, I found that the CPU load was a little high, especially when using two presets. A C++ version may be more resource-efficient. I also found that the management of time in a composition was another limitation, since durations must be defined before composing. For a long piece, BCFcsound may be used to produce sections, while large sequencing operations may be done by hand.
## References


[[1]] MUSIC Group Services NV Inc., "B-Control Fader BCF2000." [Online] Available: ][http://www.music-group.com/Categories/Behringer/Computer-Audio/Desktop-Controllers/BCF2000/p/P0246](http://www.music-group.com/Categories/Behringer/Computer-Audio/Desktop-Controllers/BCF2000/p/P0246). [Accessed September 19, 2015].

[[2]] MUSIC Group Services NV Inc., "Behringer B-Control Fader BCF2000/RotaryBCR2000 User Manual." [Online] Available:[http://www.music-group.com/Categories/Behringer/Computer-Audio/Desktop-Controllers/BCF2000/p/P0246/downloads](http://www.music-group.com/Categories/Behringer/Computer-Audio/Desktop-Controllers/BCF2000/p/P0246/downloads) [Accessed September 19, 2015].
