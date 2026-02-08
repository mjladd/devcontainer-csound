---
source: Csound Journal
issue: 12
title: "A User Approach to Sample Replacement"
author: "placing an attack every"
url: https://csoundjournal.com/issue12/samplereplacement.html
---

# A User Approach to Sample Replacement

**Author:** placing an attack every
**Issue:** 12
**Source:** [Csound Journal](https://csoundjournal.com/issue12/samplereplacement.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 12](https://csoundjournal.com/index.html)
## A User Approach to Sample Replacement
 Jim Hearon
 j_hearon AT hotmail.com
## Introduction


 Many commercial and open source multitracking applications feature some type of beat detection algorithm and/or sample replacement function. The concepts of beat detection for beat stretching, and sample replacement for replacing less than perfect human hits with samples, are powerful tools which can be extended into more artistic applications such as creative techniques for computer music. The following examples are beginning efforts for a user approach to sample replacement in Csound.
##
 I. Sample Replacement using *tablewa* and *tablera *



 In order to work with sample replacement using Csound opcodes, a simple approach was undertaken employing the precalculation and creation of a beat structured .wav file. A Tambourine.wav file was created using a semi-physical model of a tambourine sound from Csound. The Tambourine.wav example was created at 44.1 KHz, placing a tambourine hit every 0.5 sec. This short .wav file simulates a recorded track with a beat structure by placing an attack every 22050 samples, for a total file length of 4 seconds or 176400 samples (44100 * 4), and a total of 8 attacks. Because the beat contents of the tambourine file are known, in this case, there was no need to pursue beat detection for analysis. Csound has opcodes for transient detection, however Scheirer[[1]](https://csoundjournal.com/#ref1), and also Cheng et al.[[2]](https://csoundjournal.com/#ref2) discuss beat detection in the frequency domain.  [![](images/smplrplment/tambmp3.png)](https://csoundjournal.com/audio/Tambourine.mp3)

 A clap sound sample was chosen as the replacement sample to help distinguish replaced samples clearly from the existing tambourine hits. The clap sound was positioned via an audio editor to begin at the beginning of another .wav file, or "0" samples onset, and although the clap sample was only 0.5 sec.(22050 samples) in duration, the total length of clap.wav file was extended with silence to match the duration of the tambourine file (4 seconds) in order to work with the *tablewa *and *tablera* opcodes.

 Although Csound has many opcodes which may be suitable for working with beat detection and sample replacement such as the opcodes *floor*, *limit*, *peak*, *filepeak*, *trigger*, *readk*, *fink*, *seqtime2*, *timeinstk*, etc., it was decided initially to employ the *tablewa* and *tablera *opcodes, since those opcodes are designed to write to sequential locations in tables using table lookup functions. The Tambourine.wav and Clap.wav files were each placed in respective tables of 4 seconds or 176400 samples in length and a UDO (User-defined Opcode) was designed to sequentially replace the even tambourine beats with a clap which should be audible in Example1.mp3.  [![](images/smplrplment/ex1mp3.png)](https://csoundjournal.com/audio/example_1.mp3)

 By design it was decided to use .sco file and pfield entries to list the sequential sample numbers for replacement, allowing the instrument calling the UDO to be employed several times in the .sco, while changing the pfield values for particular sample numbers or beat replacements. Also a procedure was employed to read samples or beats from the tambourine and clap tables, and place them sequentially into a third table of the same initial length (table 101, Ex.1 .csd), which was then used with *fout* for writing the final .wav file to disk.

 Setting ksmps to the size of the table length was based on a-rate wa/ra use inside a k-rate loop. For every max k values or end of loop, *tablewa *will write ksmps number of samples. All .csd example files and .wav sources can be downloaded here: [ SampleReplacement.zip.](https://csoundjournal.com/smplrplexs.zip)
##
 II. Sample Replacement using *vaget* and *vaset*


 While writing to sequential locations in tables using *tablewa* and *tablera* proved useful for sample replacement, the *wa/ra* approach was an acid test for using the sample level opcodes *vaget* and *vaset*. These opcodes, by Steven Yi, allow sample-by-sample manipulation at the k-rate, accessing values of the current buffer of an a-rate variable by indexing.

 The approach shown below is a non-standard use of *vaget* and *vaset*. It accomplishes sample replacement via sample level manipulation employing multiple conditional *if* and *elseif *statements within a *loop_lt* based on index or sample numbers. This is a different approach from *The Canonical Csound Reference Manual* example for *vaget* which employs the values of those indexes, not the index or sample numbers themselves.

 It was discovered after considerable experimentation that all varieties of looping oscillator opcodes would not work with this design. Therefore an approach was used to read a-variables from disk before employing *vaget*. The k-rate loop gives the same result as writing sequentially using *tablewa* and *tablera* by listing the sample or index numbers for replacement using conditional *elseif* statements.
```csound

	instr 5
a1 init 0
a2 init 0
a3 init 0

a1 diskin "Tambourine.wav", 1, 0, 0, 4
a2 diskin "Longclap.wav", 1, 0, 0, 4

kval init 0
kndx = 0

/*
beat1 - 0
beat2 - 22050
beat3 - 44100
beat4 - 66150
beat5 - 88200
beat6 - 110250
beat7 - 132300
beat8 - 154350
EOF   - 176400
*/

loopStart1:

	if (kndx > 0 && kndx < 22049) then
	kval vaget kndx,a1

	elseif (kndx > 22049 && kndx < 44099) then
	kval vaget kndx - 22049, a2

	elseif (kndx > 44099 && kndx < 66139) then
	kval vaget kndx,a1

	elseif (kndx > 66149 && kndx < 88199) then
	kval vaget kndx - 66149, a2

	elseif (kndx > 88199 && kndx < 110249) then
	kval vaget kndx,a1

	elseif (kndx > 110249 && kndx < 132299) then
	kval vaget kndx - 110249,a2

	elseif (kndx > 132299 && kndx < 154349) then
	kval vaget kndx,a1

	elseif (kndx > 154349) then
	kval vaget kndx - 154349,a2
	endif

	vaset kval,kndx,a3

	if (kndx >176400) goto last;
    loop_lt kndx, 1, ksmps, loopStart1

last:
	turnoff
	endin
```

##
 III. An Esoteric Example of Sample Replacement


The use of *vaget* and *vaset*, although non-standard, proved satisfactory for sample replacement, however the .orc code was not concise due to the use of multiple conditional *if* and *elseif* statements. While the approach shown above could be simplified by the development of a UDO and made more compact, some thought was given to the overall use of sample replacement in Csound before moving on to that task.

 Because Csound is not always used for a beat oriented type music, and may use time as a reference, an audio file was synthesized (Bells.wav) at 48 KHz of 12 seconds duration which had pulses but not a clear metric beat structure as in the previous examples, and it was decided to try to replace samples using a percussive clank sound of 24000 samples which could be clearly distinguished from the existing pulses.

 Unlike the commercial type drum kit sample replacement editing where the beat or hit is probably preceded and followed by a brief amount of near silence, this esoteric type sample replacement may occur at a non-zero crossing, and required a fade out of a few samples just before the replaced sample in order to avoid a click. One interesting observation was while working on the sample level, many useful opcodes, such as *expseg* for envelope generation, are not available and one has to create those functions. Log10 was used in the UDO below with extra scaling to create a 1000 sample fade to "0" before sample replacement.

 As in the first example above it was decided to use .sco file and pfield entries to list the sample start locations for replacement, allowing the instrument calling the UDO to be employed several times in the .sco, but changing the pfield values for the point of particular beat replacement. The result should be audible in Example3.mp3.  [![](images/smplrplment/ex3mp3.png)](https://csoundjournal.com/audio/example_3.mp3)
```csound

<CsoundSynthesizer>
<CsOptions>
-s -d -+rtaudio=PortAudio -odac4 -W -b1024 -B16384
</CsOptions>
<CsInstruments>

sr=48000
ksmps=576000
nchnls=1

;GLOBAL VARIABLES
gitmp1    ftgen 100, 0, -576000, -10, 1
gitmp3   ftgen 200, 0, -576000, -10, 1
gitmp4   ftgen 300, 0, -576000, -10, 1

gabells init 0
gabells2 init 0
gaclank init 0

gilen1 filelen "Bells.wav"
gilen2 filelen "Clank.wav"
gisamples1 init 0
gisamples2 init 0
;=======================
;UDO
opcode SampleReplace, a, iiiiiii

;init local variables
a1 init 0
a2 init 0
a3 init 0
kval init 0
kndx = 0
clear gabells

istart, ifade, icut, ismplstart, ismplend, icont, iend, xin

/* ;ck values, etc.
printf "start %d\n", 1, istart
printf "fade %d\n", 1, ifade
printf "cut %d\n", 1, icut
printf "smplRplstart > %d\n", 1, ismplstart
printf "smplRplend < %d\n", 1, ismplend
printf "cont %d\n", 1, icont
*/

a1 diskin "Samplereplace.wav", 1, 0, 0, 4
a2 diskin "clankfile.wav", 1, 0, 0, 4

loopStart1:

	;initial file
	if (kndx > istart && kndx < ifade) then
	kval vaget kndx,a1

	;SLIGHT FADE OUT within intial file
	elseif (kndx > ifade && kndx < icut) then
	kval vaget kndx,a1
	;LOGARITHMIC w xtra scaling
	kval = kval * (log10(10 - (10*((kndx-ifade)/1110))))

	;INSERT THE FIRST SAMPLE REPLACEMENT
	elseif (kndx > ismplstart && kndx < ismplend) then
	kval vaget kndx - ismplstart, a2

	;CONTINUE AFTER SAMP REPLACEMENT WITH ORIGINAL FILE
	elseif (kndx > icont) then
	kval vaget kndx, a1
	endif

	vaset kval,kndx,a3

	if (kndx > iend) goto last;
	loop_lt kndx, 1, ksmps, loopStart1

last:
	gabells = gabells + a3
	printf "UDO finished at  %d\n", 1, kndx
	clear a1, a2, a3
	xout a3
endop
;====================
;WRITE DISKIN FILES TO EQUAL LENGTH TABLES
  instr 1
;GET/WRITE Bells.wav to table(12 sec., no real beats, but pulsing snds)
;Load into a table(100)

print gilen1
gisamples1 = gilen1 * sr
print gisamples1

andx line 0, gilen1, gisamples1
asig1 diskin "Bells.wav", 1, 0, 0, 4
tablew asig1, andx, 100
    endin
;==============
;GET/WRITE CLANK wav to table
    instr 2
andx line 0, gilen1, gisamples1 ;using length from above
asig2 diskin "Clank.wav", 1, 0, 0, 4
tablew asig2, andx, 200
    endin
;======================
;SAVE THE TABLES TO .WAV ON DISK
	instr 3
andx line 0, gilen1, gisamples1 ;using length from above
a1 table andx, 100
gabells= gabells + a1
	endin
;==================
	instr 4
fout "Samplereplace.wav", 2, gabells
	endin
;==================
	instr 5
clear gabells
andx line 0, gilen1, gisamples1 ;using length from above
a1 table andx, 200
gaclank= gaclank + a1
	endin
;==================
	instr 6
fout "clankfile.wav", 2, gaclank
	endin
;=================
;READ FILES FROM DISK AND DO VAGET/VASET
	instr 7
;SAMPLE REPLACER
;istart, ifade, icut, ismplstart, ismplend, icont, iend, xin

ibeat = p4 ;beat to replace

istart = 0
ifade = (ibeat - 1000)-1
icut  =  ibeat -1
ismplstart = ibeat -1
ismplend  = (ibeat - 1) + (gilen2 * sr)
icont = (ibeat - 1) + (gilen2 * sr)
iend = gisamples1

asig SampleReplace istart, ifade, icut, ismplstart, ismplend, icont, iend
	endin

/*
SR = 48000
start = 0
2 sec. = 96000
4 sec. = 192000
8 sec. = 384000
10 sec. = 480000
12 sec. = EOF 576000
*/
;=================
;WRITE THE MODIFIED FILE TO DISK
	instr 8
fout "Samplereplace.wav", 2, gabells
	endin
;=================
</CsInstruments>
<CsScore>
f1 0 -576000 1 "Bells.wav" 0 4 0
f2 0 -24000 1 "Clank.wav" 0 4 0

i1	0	12
s
i2	0	12
s
i3	0	12
s
i4	0	12
s
i5	0	12
s
i6	0	12
s
i7	0	12	96000
s
i8	0	12
s
i7	0	12	192000
s
i8	0	12
s
i7	0	12	384000
s
i8	0	12
s
i7	0	12	480000
s
i8	0	12
e
</CsScore>
</CsoundSynthesizer>
```

##
 IV. Conclusions


 It is known that disk operations are slow compared to those in memory, however the use of *diskin* proved more useful than looping oscillator opcodes when working with *vaget* and *vaset* for sample replacement. Commercial applications such as *Drumagog* and Digidesign's *SoundReplacer*, as well as others, are sophisticated and complex applications which have found usefulness in audio editing as plugins[[3]](https://csoundjournal.com/#ref3). The basic idea of sample replacement can be employed for more esoteric applications, such as computer music techniques, and there is room for more opcode development in Csound which would support beat detection and sample replacement.


## References


 [][1]]Scheirer, Eric D. "Tempo and beat analysis of acoustic musical signals".*The Journal of the Acoustical Society of America*, Vol. 103, No. 1. (1998), pp. 588-601.]
  Another good article is "Tempo and Beat Estimation of Music Signals" by Alonso, David, and Richard.

 [][2]] Beat This. A Beat Synchronization Project. [ http://www.owlnet.rice.edu/~elec301/Projects01/beat_sync/beatalgo.html](http://www.owlnet.rice.edu/~elec301/Projects01/beat_sync/beatalgo.html) (8 Nov 2009)
  Matlab .m files of their algorithms are available for download.

 [][3]]Digidesign. Drum Hit and Sound Replacement AudioSuite Plug-in. [http://www.digidesign.com/index.cfm?navid=115&itemid=1059](http://www.digidesign.com/index.cfm?navid=115&itemid=1059) (8 Nov 2009)  Drumagog Drum Replacer Plug-In. [ http://www.drumagog.com/](http://www.drumagog.com/) (8 Nov 2009)
  Audacity 1.3.9 features a beat finder tool for beat analysis which has good graphical output shown below the waveform view.
  Trillium Lane Labs features a Plug-In called "Drum Rehab".
  Mark of the Unicorn features a "Beat Detection Engine" in Digital Performer which is useful for beat stretching.
