---
source: Csound Journal
issue: 19
title: "Interfacing Csound and Unity"
author: "scripting in various languages"
url: https://csoundjournal.com/issue19/InterfacingCsoundUnity.html
---

# Interfacing Csound and Unity

**Author:** scripting in various languages
**Issue:** 19
**Source:** [Csound Journal](https://csoundjournal.com/issue19/InterfacingCsoundUnity.html)

---

CSOUND JOURNAL[](https://csoundjournal.com/index.html) | [Issue 19](https://csoundjournal.com/index.html)
## Interfacing Csound and Unity

### Mapping visual and binaural 3D coordinates in virtual space
 Marte E. Roel Lesur
 marteroel@gmail.com
## Introduction


This article presents a system—article version available [here](https://csoundjournal.com/downloads/Binaural_Sound_Unity.zip), most recent version available [here](http://marte.me/site/binaural)—for interfacing a video game development tool, namely Unity, with some of Csound's binaural 3D sound opcodes—particularly *hrtfmove2*, *hrtfearly*, and *hrtfreverb *—for real-time binaural 3D sound source positioning. The main objective of such interfacing is to have visual 3D coordinates dynamically mapped to sound-source positions in a virtual space. Csound's attributes may be accessed from within Unity's GUI, allowing non-expert Csound users to explore the power of the mentioned binaural 3D opcodes. The current text discusses the methods used for such interfacing, as well as explains its capabilities.
##
I. Background


The system exploits the potential of three binaural 3D sound opcodes—*hrtfmove2 *[[1]](https://csoundjournal.com/#ref1), *hrtfearly *and *hrtfreverb *[[2]](https://csoundjournal.com/#ref2)—for positioning virtual 3D sound sources in conjunction with visual 3D coordinates. Such opcodes are based on the use of HRTFs (Head Related Transfer Functions), which filter sound in the way that would be filtered as it reaches the middle ear, accounting for the filtering of sound depending on its direction of incidence to one's anatomy (see [[3]](https://csoundjournal.com/#ref3), [[4]](https://csoundjournal.com/#ref4), [[5]](https://csoundjournal.com/#ref5)). A special attribute of these opcodes is that they allow for dynamic 3D positioning in real-time, using novel methods for interpolation [[6]](https://csoundjournal.com/#ref6).

 The proposed system uses a C# script for interfacing Unity[[7]](https://csoundjournal.com/#ref7), a video game engine, with Csound. Unity (Unity Technologies) is a fully integrated game development tool for designing and developing video games. Unity's philosophy is centered on allowing independent game developers to design low-budget, high quality games for many platforms, including Mac OS, Windows, Web players, Android, iOS, Windows Phone, BlackBerry, as well as commercial consoles [[8]](https://csoundjournal.com/#ref8). Unity may be programmed in languages such as C#, JavaScript, and boo, and includes its own IDE, MonoBehaviour. An open source OSC (Open Sound Control) script for C#, originally hosted by MakingThings [[9]](https://csoundjournal.com/#ref9), was briefly available for use within Unity, but MakingThings ceased to exist and only some of their projects are available from a code repository on Sourceforge.

The motivation behind the system is to map Unity visual attributes to auditory ones, so that video game developers can explore the potential of dynamic 3D sound positioning as well as virtual room acoustic parameters. This system enables communication between Unity and Csound via OSC (Open Sound Control). So far, the system (which can be easily expanded) accounts for up to 4 different sound sources and one listener, all of which reside in a room with the same conditions. Csound's attributes may be modified dynamically from within Unity's GUI, allowing non-expert Csound users to use such a system. Figure 1 shows the basic architecture of the present implementation.  ![image](images/unity_image001.png)

 **Figure 1. Basic system architecture.**
##
II. System methodology

### Unity


Unity is a game engine aimed at independent game designers for developing video games[[8]](https://csoundjournal.com/#ref8). Designers may modify the position of 3D objects from within the GUI (Figure 2), as well as program complex interactions and behaviors by scripting in various languages. For the present setup an OSC plugin was used for sending formatted messages via UDP from Unity. The plugin provides an OSC class to be used from within Unity's IDE. The plugin is a modified version of the Make Controller's open source C# script (originally hosted by MakingThings [[9]](https://csoundjournal.com/#ref9)) and uses the files Osc.cs and UDPPacketIO.cs, included in the download files via the link for the system listed in the Introduction above. A script (OSC3dSoundSender.cs) was written for converting Unity coordinates, as well as room attributes into relevant data for Csound to read. Such a script allows a number of variables to be accessed and changed from within Unity's GUI on the fly—namely source position, orientation (Figure 2), and a number of room parameters (Figure 3), among other attributes.

Two different behaviors of the system are implemented and may be chosen by modifying the *Sound Algorithm* input in Unity's GUI (Figure 3) to either 0 or 1. Sound Algorithm 0 is implemented for use with *SoundAlgorithm0.csd*. This file uses the *hrtfearly* opcode that processes the mathematical operations for deducting the angle of sound incidence out of 3D coordinates. Such behavior also enables the room parameters, which can be seen in Figure 3, and are echoic (the room size has a minimum of 2 x 2 x 2 meters due to the nature of Csound's *hrtfearly* opcode). Sound Algorithm 1, on the other hand, calculates the angular displacement out of 3D coordinates before being sent to SoundAlgorithm1.csd. This file uses the *hrtfmove2* opcode that understands angular values only: the distance is calculated using the inverse square law (approximately simulating an open space) within Unity's C# script. The Sound Algorithm 1 behavior disables the use of room parameters as well as early reflections. This accounts for a better externalization of sound sources, and may be of interest for some users due to its anechoic qualities.  ![image](images/unity_image002.png)

 **Figure 2. Modifying the position of virtual objects in 3D space via Unity's GUI (binaural position is modified in relation to the camera when the system is running in first person view).**

OSC communication occurs by default over UDP on a local host using port 9999. Unity sends a variety of messages in OSC format to be read by Csound. The messages are separated by Address Patterns depending on what they refer to, namely: source name, source loop, source triggers, source position (relative to the room for Sound Algorithm 0, and relative to the user for Sound Algorithm 1), listener position and orientation, amount of reverb, room parameters, and a trigger for stopping instruments together with Unity. These different sets of attributes are separated by the following Address Patterns to be read by Csound:
- /onOff
- /sourceName
- /sourceLoop
- /sourceAttributes
- /listenerPositions
- /reverbAmount
- /roomParameters
- /end   ![image](images/unity_image003.png)

 **Figure 3. Csound's attributes accessed from within Unity 3D's GUI.**
###
Csound


Csound provides all the DSP needed for the binaural spatialization and is set to process up to four samples in real-time. The system reads a number of variables sent by Unity via OSC, using the corresponding OSC opcodes in Csound, in order to control its parameters. Two different behaviors of binaural sound may be used, depending on the .*csd* file and its accompanying .*inc* files found on the same folder. *SoundAlgorithm0.csd *is prepared for echoic spatialization using the *hrtfearly* and *hrtfreverb* opcodes, while *SoundAlgorithm1.csd* is prepared for anechoic spatialization, using the *hrtfmove2* opcode. Each of these *.csd* files is accompanied by a number of .inc files that are read by the .*csd* code, which must be in the same folder, as shown in the system files download. The behavior of such .*inc* files is described here:

**initialization.inc** initializes all of the global variables that are used throughout the program.

**oscreceiver.inc** (instr 1001) reads all of the OSC messages and converts them into global *k-*rate variables that are used later in the program.

**logic.inc** (instr 999) performs all the logic for deleting and creating instances of instruments dynamically. This dynamic control of instrument instances is important, as it allows performing certain room modifications at *k-*rate, which would not be normally possible due to the nature of the *hrtfearly* opcode.

**samplers.inc **includes four instruments (instr 101 - instr 104) that use the *diskin *opcode for reading sound files from disk and sending them to the HRTF opcodes for processing. These instruments are instantiated by the logic.inc file (instrument 999).

**hrtfsources.inc **includes four instruments (instr 1 - instr 4) which use the *hrtfearly* opcode and each receive their own OSC messages for the position of the source, coming from OSC address */sourceAttributes1* through */sourceAttributes4*. These instruments process the a-rate signal sent by instruments 101 - 104. instr 1 - instr 4 are also instantiated by the logic.inc file (instrument 999). SoundAlgorithm0.csd uses the *hrtfearly *opcodes which also receives the listener's position, while SoundAlgorithm1.csd uses the *hrtfmove2 *opcodes providing anechoic spatialization.

**reverb.inc **includes instrument 10, which uses the *hrtfreverb *opcode for processing the late reflections of the virtual space. This instrument also receives its own OSC messages on address */reverbAmount*. Such an instrument is also instantiated via the logic.inc file. This file is only included for SoundAlgorithm0.

The binaural processing opcodes mentioned uses two dat files (hrtf-441000-left.dat and hrtf-441000- right.dat respectively) which include the HRTF impulse response database for the signal processing, based on MIT's Kemar library [[10]](https://csoundjournal.com/#ref10). For the current implementation, the 44.1kHz version of the database is used, although the system may be easily modified to use any of the Csound-included databases (48kHz and 96kHz). These files must be included in the same folder as the CSD files.

 A trigger sent via OSC (on address */end*) kills all the instances of instruments that are performing sound.
### Abstraction of 3D space


A particular aspect of the current interface is the way in which each of the systems abstracts three-dimensional space. On the one hand, Unity's abstraction is a first person view on which the *x-*axis is the azimuth, the *y-*axis is the elevation, and the *z-*axis is the depth. Alternatively, Csound's HRTF opcode's space abstraction is a bird's eye view, which if translated into a first person view, the *x-*axis would be the azimuth, the *y-*axis would be the depth, and the *z-*axis the elevation. For this reason, when translating Unity's coordinates into OSC messages, the *y *and the *z-*axes are inverted.
##
III. Using the system


To use the system, the user must install both Unity and Csound on his/her computer. To add new samples, mono .wav files should be added into one of the the folders in /Binaural_Sound_Unity/Assets/sounds/. New samples should be named using integer numbers followed by the sound file format i.e. 1.wav, 2.wav, 3.wav, and 4.wav.
### Csound


Choose one of the two .csd files, included in /Binaural_Sound_Unity/Assets/sounds/. SoundAlgorithm0.csd provides echoic HRTFs with access to room parameters, and SoundAlgorithm1.csd provides anechoic HRTFs. Csound should be ready to run.
### Unity


Open the Unity scene named "Template.unity" (/Binaural_Sound_Unity/Assets/Scenes/). From the hierarchy tab (see Figure 4), select the 3D sound object. From the OSC3dSoundSender.cs script attributes (see Figure. 3) choose an algorithm depending on the Csound file used. If the algorithm is set to 0 you may modify the room parameters (the minimum room size is 2 x 2 x 2), otherwise changing them will have no effect in the resulting sound. From the hierarchy tab (see Figure 4), drag the object that you want to map to binaural 3D sound into one of the Sound Object fields found in the inspector tab of the 3D Sound object (only sounds that are mapped to a Unity Object will be sounding, and the sound will stop if there is no object mapped to a Sound Object). Write the name of the sound that it will be mapped to (names may only be integer numbers excluding the format. i.e. 1, 2, 3, etc.). After doing so, the visual position of an object in Unity will correspond to the auditory position of such object. Set the main level of each of the Sound Objects and select if you want such sound to loop continuously. ![image](images/unity_image004.png)

 **Figure 4. Unity's Hierarchy Tab, where all the Unity Objects are present.**

Currently the Listener's position is paired with the camera. This is good when doing a first person
 game. Such settings may be changed by dragging and dropping the new listener's position into the Listener field in the inspector of the 3D sound object.

Note that when using Sound Algorithm 1, every spacial unit in Unity corresponds to 1 meter in Csound. If Unity objects are outside the size of the current room, the position of such objects will have no acoustic effect.

 The Sound On Off field was added for allowing the user to turn off the sound while experimenting.
##
IV. Conclusion


This system has enormous research capabilities regarding auditory-motor contingencies, as well as multimodality (between other possible areas of study) that may be explored by non-expert Csound users. A previous version of the system was used for research within the European Union's project Rehabilitation Gaming System [[11]](https://csoundjournal.com/#ref11). It may be seen as a companion to Dr. Brian Carty's Multibin [[12]](https://csoundjournal.com/#ref12), which may be used in conjunction with more complex graphics and game interactions. Future implementations could be enhanced by including a more dynamic system for switching sound files on the fly, being able to use other file formats, having a more free use of strings for sound names, and being able stop sounds without having to destroy the Unity Object (although this may be achieved by turning the sound level down to 0, but it does not stop the instrument instance).
##
Acknowledgements


I want to mention my admiration and gratification for Dr. Brian Carty, who has always been supportive of and attentive to my work. He has also provided the tools without which this work would not be possible. Additionally, I want to thank Dr. Richard Boulanger, for his contagious drive for doing things. And last, I want to give thanks to my supervisor Dr. Armin Duff, and the people of the Synthetic, Perceptive, Emotive and Cognitive Systems Group at the Universitat Pompeu Fabra, who were very supportive during the development of my related Master's thesis during 2012.
##
References


[][1] B. Carty, "HRTFmove, HRTFstat, HRTFmove2: Using the new HRTF Opcodes," *The Csound Journal*, Issue 9, July 28, 2008. [Online]. Available: [http://www.csounds.com/journal/issue9/newHRTFOpcodes.html.](http://www.csounds.com/journal/issue9/newHRTFOpcodes.html) [Accessed Aug. 16, 2013].

 [][2] B. Carty, "Hrtfearly and HrtfreverbNew Opcodes for Binaural Spatialisation." *Csound Journal*, Issue 16, January 24, 2012. [Online]. Available: [http://www.csounds.com/journal/issue16/CartyReverbOpcodes.html](http://www.csounds.com/journal/issue16/CartyReverbOpcodes.html) [Accessed Aug. 17, 2013].

[[3]] W. M. Hartmann, "How We Localize Sound." *Physics Today*, American Institute of Physics, November 1999, pp. 24-29.

[[4]] J. Blauert, "Spatial Hearing: The Psychophysics of Human Sound Localization." English Translation. Cambridge, MA: Massachusetts Institute of Technology, 1997.

[[5]] D. W. Grantham, "Spatial hearing and related phenomena." In *Hearing*, B.J.C. Moore, New York, NY: Academic Press, Inc., 1995.

 [][6] B. Carty, "Movements in Binaural Space: Issues in HRTF Interpolation and Reverberation, with applications to Computer Music." *NUI Maynooth ePrints and eTheses Archive*, March 2011. [Online]. Available: [http://eprints.nuim.ie/2580/](http://eprints.nuim.ie/2580/). [Accessed Aug. 17, 2013].

 [][7] Unity Technologies, "Create the games you love with Unity" *Unity Official Website, *2013. Available: [http://unity3d.com/unity/](http://unity3d.com/unity/)[Accessed Aug. 16, 2013].

 [][8] Unity Technologies, "Effortlessly unleash your game on the world's hottest
 platforms" *Unity Official Website*, 2013. Available: [http://unity3d.com/unity/multiplatform/](http://unity3d.com/unity/multiplatform/)[Accessed Aug.16, 2013].

 [][9] MakingThings, "makecontroller: An opensource hardware plataform & networked device" *Google code*. Available: [https://code.google.com/p/makecontroller/](https://code.google.com/p/makecontroller/) [Accessed Aug. 16, 2013], code found at [http://sourceforge.net/projects/makingthings/?source=](http://sourceforge.net/projects/makingthings/?source)[Accessed Aug. 14, 2013].

[][10] B. Gardner, K. Martin, "HrtfMeasurements of a KEMAR Dummy-Head Microphone" MIT Media Lab Machine Listening Group, July 18, 2000 [Online]. Available: [http://sound.media.mit.edu/resources/KEMAR.html](http://sound.media.mit.edu/resources/KEMAR.html) [Accessed Aug. 30, 2013].

[][11] M.S. Cameirao, et al., "Neurorehabilitation using the virtual reality based Rehabilitation Gaming System: methodology, design, psychometrics, usability and validation." *Journal of Neuroengineering and Rehabilitation, *vol. 7, p. 48, 2010.

 [][12] B. Carty, "MultiBin, A Binaural Tool for the Audition of Multi-Channel Audio." *CsoundJournal*, Issue 16, January 24, 2012. [Online]. Available: [http://www.csounds.com/journal/issue16/multibin.html](http://www.csounds.com/journal/issue16/multibin.html) [Accessed Aug. 31, 2013].


##
