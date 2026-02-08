---
source: Csound Journal
issue: 16
title: "Hrtfearly and Hrtfreverb"
author: "real FFT use"
url: https://csoundjournal.com/issue16/CartyReverbOpcodes.html
---

# Hrtfearly and Hrtfreverb

**Author:** real FFT use
**Issue:** 16
**Source:** [Csound Journal](https://csoundjournal.com/issue16/CartyReverbOpcodes.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 16](https://csoundjournal.com/index.html)
## Hrtfearly and Hrtfreverb

### New Opcodes for Binaural Spatialisation
 Dr Brian Carty
 Sound Training Centre, Temple Bar, Dublin 2
 brian AT soundtraining.com
## Introduction


The new binaural reverb opcodes were introduced in Csound 5.15, and are discussed from a practical point of view in this article. For a review of the literature and implementation specifics, see [[1]](https://csoundjournal.com/#ref1), [[2]](https://csoundjournal.com/#ref2), [[3]](https://csoundjournal.com/#ref3). For details of parameter defaults and limitations, see *The Canonical Csound Reference Manual* pages for the HRTF opcodes for Csound version 5.15 or later .
##
 I. Background


### HRTF Opcodes


 The binaural reverb opcodes follow from the development of the Head Related Transfer Function (HRTF) opcodes introduced in Csound 5.08. Details on implementation, algorithm generation and literature reviews can be found in [[3]](https://csoundjournal.com/#ref3), [[4]](https://csoundjournal.com/#ref4), [[5]](https://csoundjournal.com/#ref5), [[6]](https://csoundjournal.com/#ref6), [[7]](https://csoundjournal.com/#ref7) and *The Canonical Csound Reference Manual* pages for `hrtfmove`, `hrtfmove2` and `hrtfstat`. The HRTF opcodes have been updated and optimised as part of the process of developing the new reverb opcodes. The operating/algorithmic principles remain the same; updates are mainly for optimisation. Data files have also been reduced in size (essentially due to complex FFT processing being replaced by real FFT use), so users should ensure that up to date HRTF data files are being used.

Details on binaural spatialisation are covered elsewhere [[1]](https://csoundjournal.com/#ref1), [[3]](https://csoundjournal.com/#ref3). Briefly, the HRTF describes how a sound is altered from source to eardrum. In pairs (for left and right ears), they can be used as filters to artificially spatialise audio, exploiting sound localisation cues such as interaural differences and spectral alterations. The process works best for headphones.

Implementation of a HRTF based binaural spatialisation system involves several challenges, primarily related to generating a dynamic digital filter that describes the HRTF. The HRTF opcodes are based on novel solutions to these challenges, which approach the problem in the spectral domain, from a psychoacoustical point of view. The treatment of the phase of the HRTF is focused upon, where `hrtfmove` uses a phase truncation method, and `hrtfmove2` derives a functional phase. The new approaches perform extremely well both objectively and subjectively when compared to existing, widely-employed techniques (i.e. minimum phase based).
### Reverberation


Reverberation occurs when sound is generated in an enclosed space. Several approaches to artificially recreating reverberation exist [[3]](https://csoundjournal.com/#ref3). A common technique involves considering the process in two stages. Firstly, the early reflections are processed, emulating the source signal reflecting off boundaries in the enclosed space. Secondly, the later, diffuse reverberation can be considered more generally; less accuracy is required as the reflections build to a diffuse field. This approach is taken here. The many subtleties involved are discussed elsewhere [[2]](https://csoundjournal.com/#ref2), [[3]](https://csoundjournal.com/#ref3).
## II. New Opcodes


### Early Reflections: hrtfearly


The `hrtfearly` opcode allows user control over early reflection processing. Several parameters are available, allowing flexibility. A shoebox-shaped geometry is assumed. Required arguments are the (dynamic) location of the source and listener in the x, y and z plane (`asrc, ksrcx, ksrcy, ksrcz, klstnrx, klstnry, klstnrz`), and the HRTF datafile location/names and a default room argument (`ifilel, ifiler`, and `idefroom`). The location of the source/listener will dictate the time and spatial location of each reflection. Each reflection is processed with a high resolution HRTF filter, exploiting new optimisations in the phase truncation HRTF algorithm. File locations follow the usual standards. Default rooms are medium (1: 10 10 3), small (2: 3 4 3) or large (3: 20 25 7). From the example below, the following line of code will move the source relative to the x axis according to kx, staying at a static y and z location. The listener is static (at the mid-back of a medium room).
```csound
aearlyl,aearlyr, irt60low, irt60high, imfp hrtfearly gasrc, kx, 5, 1, 5, 1, 1,\
"hrtf-44100-left.dat", "hrtf-44100-right.dat", 1
```


Reflected sound will be reduced in amplitude by the extra distance travelled and the absorption of the reflecting surface. This absorption will typically be frequency specific, depending on the material of the reflecting surface.

The output, input and optional input parameters for `hrtfearly` are shown below.

 `aleft, aright, irt60low, irt60high, imfp **hrtfearly** asrc, ksrcx, ksrcy, ksrcz, klstnrx, klstnry, klstnrz, ifilel, ifiler, idefroom [,ifade, isr, iorder, ithreed, kheadrot, iroomx, iroomy, iroomz, iwallhigh, iwalllow, iwallgain1, iwallgain2, iwallgain3, ifloorhigh, ifloorlow, ifloorgain1, ifloorgain2, ifloorgain3, iceilinghigh, iceilinglow, iceilinggain1, iceilinggain2, iceilinggain3]`

Among the optional [ ] input parameters shown above are: 1. the fade length, `ifade`, for the phase truncation algorithm [[4]](https://csoundjournal.com/#ref4), [[5]](https://csoundjournal.com/#ref5), 2. the sampling rate of processing, `isr`, (this should match the data sampling rate of the files), 3. the order of the processing, `iorder`, (first order processing implies processing the first reflections, second order processes the first and second, etc), 4. whether three dimensional processing is employed, `ithreed`, (two dimensional is the default for efficiency; adding the z dimension increases processor requirements, particularly for higher order processing), 5. a dynamic angular head rotation control value, `kheadrot`, 6. room dimensions, `iroomx` etc, (read when a room default is not used), and finally, 7. high and low absorption values for each surface, `iwallhigh` etc, as well as three gain values for a low, mid and high frequency equalisation filter for each surface, `iceilinghigh` etc, (the surfaces considered are the roof, ceiling and walls where a typical room setup is assumed). It is expected that default room values should be adequate in most usage scenarios; however control is offered over all aspects of the processing using the optional parameters.

Of particular interest, from a point of view of integration with the later reverberant tail, is the fact that the opcode has a number of outputs in addition to the stereo processed audio. The overall low and high frequency reverb time suggested by the room and materials, as well as the mean free path in the room are also output. The mean free path is the mean distance of a sound ray between two reflections in a room.
### Later Diffuse Field: hrtfreverb


The later diffuse field reverberation is processed using a feedback delay network setup [[3]](https://csoundjournal.com/#ref3). Averaged binaural filters add a sense of externalisation and space. The `hrtfreverb` opcode is designed to work with `hrtfearly`, but can work independently as well, for example, when reverb is being used creatively and when the processing cost of processing early reflections is undesirable. The feedback delay model essentially uses a cross-fertilisation paradigm to build up the late reverb tail. A number of delay lines are used, each one feeding into the others to add density. The algorithm also uses averaged binaural filters, as well as accurate interaural coherence [[3]](https://csoundjournal.com/#ref3).

The required arguments for the `hrtfreverb` opcode are input audio (`asrc`), low and high reverb times (`ilowrt60,` and ` ihighrt60`—these are used to control the feedback delay network and can be patched directly from an instance of `hrtfearly` if desired), and file locations or names (`ifilel, `and `ifiler`). Optional values are sample rate (`isr`—this value should agree with the processing or data file sample rate value), and a mean free path and order (`imfp, `and` iorder`). When used, the latter two parameters calculate an appropriate delay for the late tail, considering the room size and order of processing of the early reflections. These parameters thus become relevant when using `hrtfreverb` with `hrtfearly`. The processed audio and the appropriatly calculated delay time are output from the opcode. The output, input and optional input parameters for `hrtfreverb` are shown below.

`aleft, aright, idel **hrtfreverb** asrc, ilowrt60, ihighrt60, ifilel, ifiler [,isr, imfp, iorder]`

The code example below is a .csd file showing typical use of the ` hrtfearly` and `hrtfreverb` opcodes.
```csound
<CsoundSynthesizer>
<CsOptions>

; Select flags here
; realtime audio out
 -o dac
; file ouput
; -o hrtf.wav

</CsOptions>
<CsInstruments>

nchnls = 2
gasrc init 0 ;global

instr 1	;a plucked string, distorted and filtered
  iamp = 15000
  icps = cpspch(p4)

  a1 pluck iamp, icps, icps, 0, 1
  adist distort1 a1, 10, .5, 0, 0
  afilt moogvcf2 adist, 8000, .5
  aout linen afilt, 0, p3, .01

  gasrc = gasrc + aout
endin

instr 10 ;uses output from instr1 as source
  ;simple path for source
  kx line 2, p3, 9

  ;early reflections, room default 1
  aearlyl,aearlyr, irt60low, irt60high, imfp hrtfearly gasrc, kx, 5, 1, 5, 1, 1, \
 	"hrtf-44100-left.dat", "hrtf-44100-right.dat", 1

  ;later reverb, uses outputs from above
  arevl, arevr, idel hrtfreverb gasrc, irt60low, irt60high, "hrtf-44100-left.dat", \
	"hrtf-44100-right.dat", 44100, imfp

  ;delayed and scaled
  alatel delay arevl * .1, idel
  alater delay arevr * .1, idel

  outs	aearlyl + alatel, aearlyr + alater
  gasrc = 0
endin

</CsInstruments>
<CsScore>

; Play Instrument 1: a simple arpeggio
i1 0 .2 8.00
i1 + .2 8.04
i1 + .2 8.07
i1 + .2 8.11
i1 + .2 9.02
i1 + 1.5 8.11
i1 + 1.5 8.07
i1 + 1.5 8.04
i1 + 1.5 8.00
i1 + 1.5 7.09
i1 + 4 8.00

; Play Instrument 10 for 13 seconds.
i10 0 13

</CsScore>
</CsoundSynthesizer>

```


The following partial code is an example of creative usage demonstrating an unnaturally large reverberant space, and creating a drone like effect by changing only instrument 10 from the example .csd file, above.
```csound
instr 10 ;uses output from instr1 as source
  ;non-natural later reverb
  irt60low = 80
  irt60high = 75

  arevl, arevr, idel hrtfreverb gasrc, irt60low, irt60high, "hrtf-44100-left.dat", \
	"hrtf-44100-right.dat"
  outs	arevl*.5, arevr*.5
  gasrc = 0
endin

```

### Design


These opcodes are designed with a multi-source setup in mind. Thus several `hrtfearly` processing units can feed one `hrtfreverb`. Individual sources can therefore be given accurate spatial cues by including accurate binaural direct and early reflection processing options. A more diffuse late reverberant field can be achieved with just one instance of `hrtfreverb`, thus optimising performance. A multi-channel binaural implementation of this processing model which offers the ability to audition multi-channel sound in standard stereo headphones is presented in the accompanying article, [*MultiBin, A Binaural Tool for the Audition of Multi-channel Audio*](https://csoundjournal.com/multibin.html). That articles helps demonstrate the advanced potential for using the opcodes more comprehensively. You can also download the .csd files for the above examples here: [CartyReverbExs.zip](https://csoundjournal.com/CartyReverbExs.zip).
## III. Conclusion



It is hoped that this article clearly illustrates the rationale and overall concepts of the new binaural reverb opcodes. Further detail on any topics discussed can be found through the references listed below.
## IV. Acknowledgements



This work was supported by the Irish Research Council for Science, Engineering and Technology: funded by the National Development Plan and NUI Maynooth. I would also like to thank Bill Gardner and Keith Martin for making their HRTF measurements available.
## V. References



[][1]] B. Carty, "Brian Carty," 2011. [Online]. Available: [http://www.bmcarty.com/pubs.html](http://www.bmcarty.com/pubs.html). [Accessed Nov. 28, 2011].

 *Note: The above URL is no longer valid. The material is now accessible at [http://www.bmcarty.ie/pubs](http://www.bmcarty.ie/pubs) [accessed February 19, 2014] *

[][2]] B. Carty, and V. Lazzarini, *HRTFearly & HRTFreverb: Flexible Binaural Reverberation Processing,* International Computer Music Conference (ICMC) 2010, Poster/Demo Session, June 01, 2010.

[][3]] B. Carty, "Movements in Binaural Space: Issues in HRTF Interpolation and Reverberation, with applications to Computer Music," *NUI Maynooth ePrints and eTheses Archive*, March 2011. [Online]. Available: [http://eprints.nuim.ie/2580/](http://eprints.nuim.ie/2580/). [Accessed Nov. 28, 2011].

[][4]] B. Carty, and V. Lazzarini, "Binaural HRTF Based Spatialisation: New Approaches and Implementation," In Proceedings of the International Conference on Digital Audio Effects (DAFx-09) September 1-4, 2009, pp 49-54. [Online]. Available: [http://dafx09.como.polimi.it/proceedings/papers/paper_15.pdf](http://dafx09.como.polimi.it/proceedings/papers/paper_15.pdf). [Accessed Nov. 28, 2011].

[][5]] B. Carty, and V. Lazzarini, "Frequency-Domain Interpolation of Empirical HRTF Data," presented at 126th AES Convention, Munich, May 2009. [Online]. Available: [http://www.aes.org/e-lib/browse.cfm?elib=14921](http://www.aes.org/e-lib/browse.cfm?elib=14921). [Accessed Nov. 29, 2011].

[][6]] V. Lazzarini, and B. Carty, "New Csound Opcodes for Binaural Processing," Proceedings of the 2008 Linux Audio Conference, Cologne, February 2008, pp 28-35. [Online]. Available: [http://lac.linuxaudio.org/2008/download/papers/4.pdf](http://lac.linuxaudio.org/2008/download/papers/4.pdf). [Accessed Nov. 29, 2011].

[][7]] B. Carty, "HRTFmove, HRTFstat, HRTFmove2: Using the new HRTF Opcodes," *The Csound Journal*, Issue 9, July 28, 2008. [Online]. Available: [http://www.csounds.com/journal/issue9/newHRTFOpcodes.html](https://csoundjournal.com/   http://www.csounds.com/journal/issue9/newHRTFOpcodes.html). [Accessed Nov. 29, 2011].
