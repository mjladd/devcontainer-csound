---
source: Csound Journal
issue: 9
title: "hrtfmove, hrtfstat, hrtfmove2: Using the New HRTF Opcodes"
author: "imposing the properties of"
url: https://csoundjournal.com/issue9/newHRTFOpcodes.html
---

# hrtfmove, hrtfstat, hrtfmove2: Using the New HRTF Opcodes

**Author:** imposing the properties of
**Issue:** 9
**Source:** [Csound Journal](https://csoundjournal.com/issue9/newHRTFOpcodes.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 9](https://csoundjournal.com/index.html)
## hrtfmove, hrtfstat, hrtfmove2: Using the New HRTF Opcodes
 Brian Carty
 Sound and Digital Music Technology Group,
 National University of Ireland, Maynooth
 Maynooth
 Co. Kildare
 Ireland
 brian.m.carty AT nuim.ie
## Abstract


The new Head Related Transfer Function (HRTF) opcodes introduced in Csound 5.08 (March 2008) will be discussed from a practical point of view in this article. Technical aspects of the opcodes and the motivation for their development are discussed in [[1]](https://csoundjournal.com/#ref1). This article will focus more on using the opcodes practically, although elements of their internal digital signal processing will be covered in context.
## I. Binaural Audio

### Spatial Hearing


A brief introduction to binaural audio is perhaps an apt place to begin any discussion of HRTF based audio spatialisation. Sound localisation refers to how and why we can locate sounds in our spatial environment. Receiving sound from two ears (binaural hearing) is the main factor involved in sound localisation. The brain can thus compare two independent signals and establish, often very accurately, where a sound is located. The two main binaural cues for sound localisation are interaural time and intensity differences (ITD and IID respectively). Monaural cues (information from one ear) can also help with sound localisation, for example, in deciding whether a sound is in front of or behind a listener (there are no interaural cues in the median plane). The non-uniform shape of the pinna filters sounds differently depending on location, which provides the main monaural cue. For more information on spatial hearing, see [[2]](https://csoundjournal.com/#ref2) or [[3]](https://csoundjournal.com/#ref3).
### Head Related Transfer Functions (HRTFs)


HRTFs are functions which describe how a sound is altered from source to eardrum. The HRTFs for the left and right ear for a source at a particular location thus constitute all the auditory localisation cues mentioned above. By imposing the properties of a HRTF from a specific location on an arbitrary mono input sound, the input can be artificially placed at that location/spatialised. This process is implemented using convolution.

Typically, HRTFs are measured at discrete points around a listener/dummy head. The data set used here was measured using a KEMAR [[4]](https://csoundjournal.com/#ref4) dummy at MIT [[5]](https://csoundjournal.com/#ref5). Therefore, if non measured points are needed, or if a source is required to move smoothly between points, some form of interpolation is necessary. It is important to note that the listener is essentially listening with the ears of the dummy head in this context, which can reduce the spatial quality of the outcome. Ideally, a user's own HRTFs should be measured and used, but this is a time consuming process. Non-individualised HRTFs, as used here, give a good spatial impression.
### HRTF Interpolation


HRTF interpolation is desirable in the frequency domain, for reasons of accuracy and efficiency. In the frequency domain, the magnitudes and phases of each component of the HRTF can be dealt with directly. Magnitudes can be interpolated directly, but phase is a periodic quantity, so cannot be successfully interpolated. Phase varies from 0 � 2pi, then back to 0 etc, so it is often ambiguous whether one phase value is behind another, or ahead, having moved into the next, or subsequent cycles [[1]](https://csoundjournal.com/#ref1).

A commonly used solution to the difficulty of HRTF interpolation is to break the HRTF into a minimum phase and an all pass system. This can be performed on any rational system function [[6]](https://csoundjournal.com/#ref6). It has been observed that the all pass phase component of this breakdown of HRTFs is 'nearly linear up to 10 kHz' [[7]](https://csoundjournal.com/#ref7). A linear phase all pass system can be described by a simple delay, quite a straightforward operation to implement. A key and unique property of minimum phase systems is that magnitude is related to phase. Therefore HRTF interpolation involves the extraction of the linear delay from the HRTF left and right ear pair for the location in question and the transformation of the left and right ear HRTF into minimum phase representations. Delays and magnitudes can then be interpolated, and phases derived from magnitudes. This process is quite complex and involves data preparation and transformation. Also, the assumption that the allpass phase component of the minimum phase all pass breakdown is linear is not completely accurate, although it has been found to be adequate 'for most positions [[8]](https://csoundjournal.com/#ref8)'. Therefore alternatives are suggested and implemented as opcodes.
### Developing a Binaural System


 Considerations, difficulties and processes involved in developing a software solution to HRTF based binaural processing are discussed in [[9]](https://csoundjournal.com/#ref9) and [[3]](https://csoundjournal.com/#ref3). To summarise, the process involves applying the characteristics of the HRTF onto the sound that needs to be spatialised. The HRTF measures how the ear responds to an impulse, thus it contains information on how the ear treats all audible frequencies. The process of applying this function onto an arbitrary source sound in the frequency domain can be summarised thus:  Analyse the (ideally mono, non-spatialised) source sound to see what component frequencies make up the sound. Retrieve the measured HRTF/interpolated HRTF for the location in question. Impose the HRTF onto the source sound. Boost or attenuate and delay the component frequencies that make up the source sound in the same way that the HRTF does: frequency domain convolution.  Play the resulting sound, in headphones.

It is crucial that the resulting sound is played back in headphones for several reasons. Primarily, the HRTF processing has already considered the ears, so listening in loudspeakers will introduce a second set of ear processing. Loudspeaker listening is also problematic in that the signal from both loudspeakers will reach both ears i.e. the signal from the left loudspeaker will reach the left ear, and shortly after, the right. In headphone listening, the sound from the left headphone only reaches the left ear. Finally, the reverberant qualities of listening to the result in a room may alter the spatial image.

Moving sources are realisable by constantly updating the HRTF information in accordance with the source trajectory.
### New Approaches to HRTF Interpolation


The algorithms introduced and used by the new opcodes are discussed in more detail in [[1]](https://csoundjournal.com/#ref1). They both use HRTF frequency domain magnitude interpolation, but approach the problem of phase interpolation differently. The aim of the opcodes is to use the empirical/measured HRTF data directly, without complex transformations (such as minimum phase all pass decomposition and consequent phase derivation).

The first approach is to simply use the nearest measured phase data. The interpolated HRTF is thus composed of an interpolated magnitude spectrum taking weighted magnitudes from each of the four nearest measured HRTFs and the phase spectrum of the nearest. As our phase sensitivity does not require exact accuracy [[8]](https://csoundjournal.com/#ref8), this is proposed as a basic, efficient solution which allows a user to directly apply a dataset without any complex digital signal processing or data manipulation. If a source is moving, the change from one nearest measured phase to another may cause a discontinuity/click in the output. This is removed/minimised by a user defined short crossfade. For noisy, frequency rich sources, a crossfade of one spectral processing buffer (128 samples) may be enough. Narrowband sources may require more buffers.

The second approach to phase interpolation is to assume the head is a sphere. A phase spectrum can thus be derived using relatively simple geometry. This crude phase spectrum is augmented by adding a frequency dependent scaling factor at the lower end of the spectrum, where phase is more important. This scaling factor is extracted from the empirical data, and is averaged across location. Therefore, a theoretically and psychoacoustically ideal phase spectrum is derived.
## II. New HRTF Opcodes

### Preliminary Instructions


 The opcodes need the spectral HRTF data files to run. These can be found on the Csound Sourceforge page as [HRTF-data5.08.zip](http://sourceforge.net/project/showfiles.php?group_id=81968), as well as in the samples directory of the Sourceforge downloads. Each file represents the left or right data for each of the three available sampling rates. The appropriate files for the sampling rate being used should be in the current directory or the SADIR (set up an environment variable called SADIR, and give it a location, see the *Csound Manual* for details). Alternatively, a path can be added to each data file parameter to the files in question. Note that examples in this article and in the *Csound Manual* assume that data files (at the correct sampling rate) are in the working directory or the SADIR.
### hrtfmove


`hrtfmove` is the first of the new opcodes. It offers phase truncation (nearest measured phase) processing or minimum phase based processing.
```csound
aleft, aright **hrtfmove** asrc, kAz, kElev, ifilel, ifiler [, imode, ifade, isr]
```


The opcode outputs stereo left and right signals, meant for headphone reproduction, as above. `hrtfmove` takes a mono audio source. A k-rate source angle/azimuth and elevation are allowed (note that elevation differences are more difficult to distinguish, particularly in a non-individualised dataset). The datafiles complete the obligatory opcode arguments, as discussed above. The csd file below illustrates how to spatialise a mono source to a static location directly to the right of the listener: at 90 degrees. Positive angle values represent locations on the right of the listener, negative on the left. Positive elevations represent angles above the listener's horizontal plane (max 90 degrees) and negative below (min -40 degrees). The file below outputs realtime audio, and uses 2 instruments.

The first is a simple pluck instrument, whose output is sent to a global variable, "gasrc". The second uses "gasrc" as the input to a `hrtfmove` based instrument.

The score turns on both instruments for 2 seconds. Internally, the opcode chooses the correct HRTF data to load and convolves it with the input. The datafiles are stored as spectrally analysed files, for efficiency. Therefore only the mono input needs to be Fourier analysed for the spectral convolution. Note that `hrtfmove` uses overlap-add convolution processing.

[eg1.csd](https://csoundjournal.com/hrtfarticle/eg1.csd)
```csound

<CsoundSynthesizer>
<CsOptions>
    ; Select flags here
    ; realtime audio out
    -o dac
    ; For non-realtime ouput leave only the line below:
    ; -o hrtf.wav

</CsOptions>
<CsInstruments>

    sr = 44100
    kr = 4410
    ksmps = 10
    nchnls = 2

    gasrc init 0

    instr 1		;a plucked string

    kamp = p4
    kcps = cpspch(p5)
    icps = cpspch(p5)

    a1 pluck kamp, kcps, icps, 0, 1

    gasrc = a1

    endin

    instr 10	;uses output from instr1 as source

    aleft,aright hrtfmove gasrc, 90,0, "hrtf-44100-left.dat","hrtf-44100-right.dat"

    outs	aleft, aright

    endin


</CsInstruments>
<CsScore>

    ; Play Instrument 1: a plucked string
    i1 0 2 20000 8.00

    ; Play Instrument 10 for 2 seconds.
    i10 0 2


</CsScore>
</CsoundSynthesizer>
```


A dynamic source is perhaps more interesting. The following csd file moves a mono, 2 second sample from in front of the listener to their right side. This csd simply opens and plays a file using `soundin` and uses a line to create the 0 to 90 degree trajectory. The number of Fast Fourier Transform processing buffers used in the crossfade to hide the clicks when the nearest measured phase data changes, as described above, defaults to 8. This works well for this example, as no clicks can be heard, and source movement is smooth and convincing.

[eg2.csd](https://csoundjournal.com/hrtfarticle/eg2.csd)
```csound

<CsoundSynthesizer>
<CsOptions>
    -o dac
</CsOptions>
<CsInstruments>

    nchnls = 2

    instr 1

    kaz line 0, p3, 90
    ain soundin "sample.wav"
    aleft,aright hrtfmove ain, kaz,0, "hrtf-44100-left.dat","hrtf-44100-right.dat"

    outs	aleft, aright

    endin

</CsInstruments>
<CsScore>

    i1 0 2

</CsScore>
</CsoundSynthesizer>

```


A more noisy sound may need only 1 buffer, for example the code snippet from eg3.csd below uses an impulsive sound as its input.

[eg3.csd](https://csoundjournal.com/hrtfarticle/eg3.csd)
```csound

kaz line 0, p3, 90
ain soundin "impulse.wav"
aleft,aright hrtfmove ain, kaz,0, "hrtf-44100-left.dat","hrtf-44100-right.dat", 0,1
```


This code introduces the optional parameters. The first is the mode of the opcode, which will be discussed shortly, and defaults to 0, which represents phase truncation processing. The next is the amount of fast fourier transform buffers used in the crossfade mentioned above, 1 in this case works well with the impulsive sound. Indeed, with this particular frequency rich sound, longer crossfades may be undesirably audible.

The first parameter decides the mode of the opcode: 0 for phase truncation processing, 1 for minimum phase. In minimum phase based processing, the magnitudes are interpolated as before, and the phases are derived from these magnitudes in real time. The tiny time delays representing the all pass component of the minimum phase all pass decomposition (see above) have been pre extracted and are stored internally in the opcode. So, for example, to run eg1.csd using minimum phase processing, it is simply a matter of adding this optional parameter. Note that the crossfade parameter does not effect minimum phase processing. The final parameter is sampling rate. It is important to note that the source, csd header, datafiles and opcode sr parameter should all agree. The default sr is 44100 Hz. The opcode will post a warning if the csd sr is not equal to the opcode's internal processing sr, but the source and datafile sr are up to the user to verify. The file below shows a 48000 Hz 2 second sample: "sample48k.wav", being processed using the minimum phase algorithm by `hrtfmove` at 48000 Hz, using the 48000 Hz data, in a 48000 Hz csd file. Note that the minimum phase mode is selected, and the crossfade parameter is not in use.

[eg4.csd](https://csoundjournal.com/hrtfarticle/eg4.csd)
```csound

<CsoundSynthesizer>
<CsOptions>
    -o dac
</CsOptions>
<CsInstruments>

sr = 48000
kr = 4800
ksmps = 10
nchnls = 2

    instr 1

kaz line 0, p3, 90
ain soundin "sample48k.wav"
aleft,aright hrtfmove ain, kaz,0, "hrtf-48000-left.dat","hrtf-48000-right.dat", 1, 0, 48000

    outs	aleft, aright

    endin

</CsInstruments>
<CsScore>

    i1 0 2

</CsScore>
</CsoundSynthesizer>

```

### hrtfmove2, hrtfstat


The other two opcodes use the scaled spherical head model.
```csound

aleft, aright **hrtfmove2** asrc, kAz, kElev, ifilel, ifiler [, ioverlap, iradius, isr]

aleft, aright **hrtfstat** asrc, iAz, iElev, ifilel, ifiler [, iradius, isr]
```


The reason for two opcodes is that the phase spectrum derivation requires a Short Time Fourier Transform (STFT) process to avoid noise due to the synthetic phase spectra of moving sources changing. For more on the STFT, see [[10]](https://csoundjournal.com/#ref10). Thus the static version of the opcode requires significantly less processing (it uses overlap-add convolution processing, as with `hrtfmove`), and is isolated as a more efficient solution to static HRTF processing. The obligatory parameters are the same as the opcode `hrtfmove`; with the exception that opcode `hrtfstat` can only take i-rate values for angle and elevation. Optional parameters are head radius and sampling rate for the static opcode, and head radius, STFT overlap and sampling rate for the dynamic opcode. Head radius is the radius value used in the geometric formula used to calculate the phase spectrum, and defaults to a value of 9.0 cm. Legal values are greater than 0 and less than or equal to 15. The STFT process, briefly, converts audio into a series of overlapping, windowed spectral frames. These frames are then processed and re-synthesised for output. The overlap parameter defines how many overlaps occur in each frame. More overlaps can capture more dynamic spectra, but increase required processing. A value of 4 is considered as a good compromise, so is the default value. Legal values are 2, 4, 8 and 16. The code snippet below, from eg5.csd uses opcode `hrtfmove2` to move the source from in front of, to the right of the user. Optional parameters (not used below) are more subtle here than in the use of opcode `hrtfmove`. For example, an overlap of factor 2 is simply too little and causes distortion, but 4 works well. Note the changes in spatialisation as the radius value is altered. For example, the spatial image is audibly affected at the extremes of the radius range. The default value of 9 cm works well for the author.

[eg5.csd](https://csoundjournal.com/hrtfarticle/eg5.csd)
```csound

kaz line 0, p3, 90
ain soundin "sample.wav"
aleft,aright hrtfmove2 ain, kaz,0, "hrtf-44100-left.dat","hrtf-44100-right.dat"

```


The code snippet from eg6.csd, below, shows the use of opcode `hrtfstat`. Note the i-rate azimuth and elevation values. Also, opcode `hrtfstat` only has 2 optional parameters (not shown below); radius and sampling rate; overlap is omitted as STFT processing is not employed. Note also that an angle value to the extreme left of the listener can be expressed as -90 or 270 degrees (+/- any multiple of 360).

[eg6.csd](https://csoundjournal.com/hrtfarticle/eg6.csd)
```csound
ain soundin "sample.wav"
aleft,aright hrtfstat ain, -90,0, "hrtf-44100-left.dat","hrtf-44100-right.dat"
```


The new opcodes serve as an update to the existing `hrtfer` Opcode, introducing smooth movement and interpolation, and removing discontinuities for dynamic sources. This update is discussed in more detail in [[1]](https://csoundjournal.com/#ref1).
### A More Complex Example


An interesting application of HRTF based spatialisation is the development of multi-channel binaural spatialisation tools. The main premise here is to use HRTF processing to place a source sound at a loudspeaker location relative to the listener. Thus virtual loudspeakers are situated around a listener, using binaural processing. Signals derived from a multi-channel spatialisation algorithm such as Ambisonics, Vector Based Amplitude Panning or even Wave Field Synthesis then feed these virtual loudspeakers. If, for example, a user wishes to virtualise an 8 channel Ambisonic system, 8 HRTF processes are needed to create 8 virtual sources, one at each loudspeaker location around the listener. The decoded Ambisonic signals sent to these loudspeakers are thus HRTF filtered accordingly. The user then gets the impression of being in the sweet spot of an Ambisonic configuration. eg7.csd contains a UDO which implements this Ambisonic setup in headphones. The `bformdec` Opcode decodes an Ambisonic B format signal to a user desired loudspeaker setup. In this case, an 8 loudspeaker circular setup is used, with the loudspeaker angles (relative to the listener) defined according to the opcode's output. The UDO takes a second order Ambisonic signal as its input, uses opcode `bformdec` to decode this signal for Ambisonic reproduction, then HRTF filters each loudspeaker feed according to its location. All binaural virtual loudspeakers are then added for the output.

This UDO acts as a simplified version of the Ambisonic material available at [[11]](https://csoundjournal.com/#ref11). The hrtf interpolation algorithms introduced by the new opcodes allow the possibility of non measured loudspeaker points, increasing accuracy.

[eg7.csd](https://csoundjournal.com/hrtfarticle/eg7.csd)
```csound

opcode Binambi, aa, aaaaaaaaa

aw, ax, ay, az, ar, as, at, au, av xin

; decode B format for 8 channel circle loudspeaker setup
a1, a2, a3, a4, a5, a6, a7, a8 bformdec 4, aw, ax, ay, az, ar, as, at, au, av

; binaurally encode each channel
; (hrtf phase truncation...)
 al1, ar1 	hrtfmove  a2,  22.5,   0, "hrtf-44100-left.dat", "hrtf-44100-right.dat"
 al2, ar2 	hrtfmove  a1,  67.5,   0, "hrtf-44100-left.dat", "hrtf-44100-right.dat"
 al3, ar3 	hrtfmove  a8,  112.5, 0, "hrtf-44100-left.dat", "hrtf-44100-right.dat"
 al4, ar4 	hrtfmove  a7,  157.5, 0, "hrtf-44100-left.dat", "hrtf-44100-right.dat"
 al5, ar5 	hrtfmove  a6,  202.5, 0, "hrtf-44100-left.dat", "hrtf-44100-right.dat"
 al6, ar6 	hrtfmove  a5,  247.5, 0, "hrtf-44100-left.dat", "hrtf-44100-right.dat"
 al7, ar7 	hrtfmove  a4,  292.5, 0, "hrtf-44100-left.dat", "hrtf-44100-right.dat"
 al8, ar8 	hrtfmove  a3,  337.5, 0, "hrtf-44100-left.dat", "hrtf-44100-right.dat"

 aleft = (al1+al2+al3+al4+al5+al6+al7+al8)/8
 aright = (ar1+ar2+ar3+ar4+ar5+ar6+ar7+ar8)/8

 ; write binaural audio out
        xout aleft, aright
endop

```


The actual file eg7.csd uses this UDO. First, it encodes a signal (here the sample file read from a table in the score and played forwards, then backwards by opcode `loscil`. A simple trajectory is then encoded by the `bformenc` opcode (note that Ambisonic coordinates use directly to the right of the user as 0 degrees, and proceed anti clockwise, by convention) and decoded using the UDO.
## III. Future Work


Future work in the area will aim to further generalise this UDO. As smooth dynamic source movement is now possible, a system to allow a user to move around a virtual loudspeaker environment is feasible. A complete system will ideally allow a user to pick a multi-channel spatialisation algorithm (Ambisonics, Vector Based Amplitude Panning, Wave Field Synthesis), decide the number of, and location of loudspeakers and the reverberant qualities of their virtual listening room. Crucially, multi-channel algorithms can thus be tested for a moving listener or a user outside of the sweet spot.
## Acknowledgements


This work is supported by the Irish Research Council for Science, Engineering and Technology: funded by the National Development Plan and NUI Maynooth. I would also like to thank Bill Gardner and Keith Martin for making their HRTF measurements available.
## References


[[1]] V. Lazzarini and B. Carty, "New Csound Opcodes for Binaural Processing", Proc. 6th Linux Audio Conference, Cologne, Germany, February 2008, pp. 28-35.

[[2]] B. Moore, "An Introduction to the Psychology of Hearing", Elsevier Academic Press, London, UK, fifth edition, 2004.

[[3]] B. Carty, "Artificial Simulation of Audio Spatialisation: Developing a Binaural System", Maynooth Musicology, vol.1, pp. 271-296, March 2008.

[[4]] M. Burkhard and R. Sachs, "Anthropometric manikin for acoustic research", Journal of the Acoustical Society of America, vol. 58, no. 1, pp.214-222, July 1975.

[[5]] B. Gardner and K. Martin, "HRTF Measurements of a KEMAR Dummy Head Microphone", Available at [http://sound.media.mit.edu/KEMAR.html](http://sound.media.mit.edu/KEMAR.html), Accessed May, 2008.

[[6]] A. Oppenheim, and R. Schafer, Discrete-Time Signal Processing, Prentice Hall, New Jersey, USA, second edition, 1999.

[[7]] S. Mehrgardt and V. Mellert, "Transformation Characteristics of the external human ear", Journal of the Acoustical Society of America, vol. 61, no. 6, pp. 1567-1576, June 1977.

[[8]] A. Kulkarni, S. Isabelle and H. Colburn, "Sensitivity of Human Subjects to Head-Related Transfer-Function Phase Spectra", Journal of the Acoustical Society of America, vol. 105, no. 5, pp. 2821-2840, May 1999.

[[9]] D. Begault, 3-D Sound for Virtual Reality and Multimedia, AP Professional, London, UK, 1994.

[[10]] F. R. Moore, Elements of Computer Music, Prentice-Hall, New Jersey, USA, 1990.

[[11]] J. Hoffman, [http://www.sonicarchitecture.de/](http://www.sonicarchitecture.de/), accessed May, 2008.

[[12]] [http://www.csounds.com](http://www.csounds.com)
