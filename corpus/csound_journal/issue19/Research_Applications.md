---
source: Csound Journal
issue: 19
title: "Csound's Binaural 3D-sound Opcodes"
author: "scripting in various languages"
url: https://csoundjournal.com/issue19/Research_Applications.html
---

# Csound's Binaural 3D-sound Opcodes

**Author:** scripting in various languages
**Issue:** 19
**Source:** [Csound Journal](https://csoundjournal.com/issue19/Research_Applications.html)

---

CSOUND JOURNAL[](https://csoundjournal.com/index.html) | [Issue 19](https://csoundjournal.com/index.html)
## Csound's Binaural 3D-sound Opcodes

### Example systems and applications for research and rehabilitation in the cognitive sciences
 Marte E. Roel Lesur
 marteroel AT gmail.com

 Sebastián Lelo de Larrea
 grandmastersebas AT gmail.com
## Introduction
 This paper provides examples of current and possible future applications of Csound's binaural 3D-sound opcodes, in particular, *hrtfmove2*[[1]](https://csoundjournal.com/#ref1), *hrtfearly *and *hrtfreverb*[[2]](https://csoundjournal.com/#ref2). It briefly describes punctual systems that have been developed and may be used for future research in the Cognitive Sciences, particularly in the areas of multimodal integration, crossmodal modulation, spacial perception and the sensorimotor system (auditorimotor mappings, in particular). Additionally this paper shows examples of creative applications that may shed light on possible scientific research. The article is aimed at providing an overview of systems as well as possible applications for them, a palette that may be important for people involved in research projects.
##
I. Background


Csound includes a series of opcodes that are based on the use of the Head Related Transfer Functions (HRTFs) for virtually positioning sound sources in 3D space. These opcodes provide optimal results through the use of headphones. The HRTFs filter sound in the way that would be filtered as it reaches the middle ear, accounting for the filtering of sound depending on its direction of incidence to one's anatomy[[3]](https://csoundjournal.com/#ref3)[[4]](https://csoundjournal.com/#ref4)[[5]](https://csoundjournal.com/#ref5). An important aspect of the *hrtfmove2*[[1]](https://csoundjournal.com/#ref1), *hrtfearly *and *hrtfreverb*[[2]](https://csoundjournal.com/#ref2) opcodes is that they may be used dynamically using novel methods of interpolation[[6]](https://csoundjournal.com/#ref6). This means that the virtual positions of sound sources may be moved in realtime, moved through previously programmed functions, as well as mapped to other inputs. Note that *hrtfmove2 *does not account for room reflections, hence it does not provide an optimal externalization of sound sources. However, it may be of interest for specific scenarios.

These systems may be of use for research in particular aspects of the Cognitive Sciences. Sensory research in most of the past century has focused on specific attributes of separate sensory modalities, rather than multimodal integration[[7]](https://csoundjournal.com/#ref7). According to Calvert et al. "it is interesting to note that with the specialization of modern research and the tendency to focus on the functional properties of individual senses, an early perspective was set aside, namely, that perception is fundamentally a multisensory phenomenon"[[8]](https://csoundjournal.com/#ref8). Multimodal integration and crossmodal modulation of audition and vision, particularly in the space domain, may be throughly experimented with using Csound's binaural opcodes in conjunction with visual systems that map visual 3D coordinates to binaural sound. Some examples of these systems are presented in the following section.

Proprioception, on the other hand, refers to the ability to perceive one's own body. This perception includes the relative position of neighboring parts of the body as well as the strength and effort being employed for movement. Through the use of some of the systems and sensors described in the following section, specific body movements may be mapped to the position of 3D sound, accounting for a multimodal interaction between proprioception and spacial sound. Such conjunction could represent a novel approach for the study of the adaptation of distinct motor programmes to specific sensory stimulation coming from either the environment or one's own body. Let us keep in mind that perception varies over the lifespan through development processes and aging, and may certainly vary due to special circumstances like disease. The insights that these tools provide may shed light on human cognition and adaptive processes as a whole.

Various systems have been developed for further experimentation in the aforementioned areas. One of the benefits of such systems is that they allow non-expert Csound users to explore the power of Csound's binaural 3D opcodes, either through GUIs, popular applications and other programming languages and environments. Such systems are briefly described in the following section.
##
II. Example systems and interfaces


The following systems, with the exception of Dr. Brian Carty's Multibin, the Flexible Action and Articulation Toolkit, and the Rehabilitation Gaming System, can be downloaded [here](https://csoundjournal.com/downloads/Research_Applications_Download.zip). Note that Csound's binaural 3D opcodes require the use of MIT's KEMAR measurements[[9]](https://csoundjournal.com/#ref9); such files are included with the latest version of Csound.
### Multibin


Multibin[[10]](https://csoundjournal.com/#ref10) is a tool, developed by Dr. Brian Carty (2012), for positioning 3D-sound sources in binaural space. It is similar to the Max/MSP interface described later in this text, allowing for more sources as well as the access to room parameters of the *hrtfearly *and *hrtfreverb *opcodes. The system is further described in [[10]](https://csoundjournal.com/#ref10) where some of the applications that have been presented in this article, such as head-tracking, are proposed.
### Unity


Unity is a game engine aimed at independent game designers for developing video games[[11]](https://csoundjournal.com/#ref11). Designers may modify the position of 3D objects from within the GUI (Figure 1), as well as program complex interactions and behaviors by scripting in various languages. The downloadable system files were developed to allow users to modify the auditory position of up to four 3D objects (using Csound) in real-time from within Unity. A number of parameters may be accessed from within Unity's GUI (Figure 2), namely source and listener's position, orientation, and room parameters, among other attributes. A detailed explanation of the system may be seen in [[12]](https://csoundjournal.com/#ref12). This system is available for use with the *hrtfmove2 * (anechoic) opcode, as well as the *hrtfearly *& *hrtfreverb *(echoic) opcodes.  ![image](images/research_image_001.png)

 **Figure 1. Modifying the position of virtual objects in Unity**.

   ![image](images/research_image_002.png)

 **Figure 2. Csound's attributes accessed from within Unity.**
### Max/MSP


Max is a visual programming language that allows users to create their own systems[[13]](https://csoundjournal.com/#ref13). A tool was developed, with the help of the Max object csound~[[14]](https://csoundjournal.com/#ref14), that provides a useful GUI (Figure 3) for positioning sound sources in binaural 3D space. This tool uses the *hrtfearly *and *hrtfreverb *opcodes). Such a tool is also available as a stand alone application for users that are unexperienced with programming, as well as users that do not own Max. Future implementations will include access to more room parameters.

 An important aspect of Max is its modularity. Programs may be easily implemented within other programs, providing a huge palette of possible conjunctions with other systems, sensors and actuators. For binaural spatialization, the use of motion detection systems is of special relevance.  ![image](images/research_Image_003.png)

 **Figure 3. Max/MSP Binaural 3D sound GUI.**
### User Tracking


Diverse methods for tracking elements through the use of sensors may be applied in conjunction with Csound's binaural 3D-sound opcodes. Various experiments have been conducted using sensors such as a Wii Remote, infrared cameras, webcams for color and face tracking, and Microsoft's Kinect. The Kinect sensor has been extensively used for research applications; It gives users the ability to interact with computers by means of their body, and according to Microsoft, it "has a deep understanding of human characteristics, including skeletal and facial tracking, and gesture recognition"[[15]](https://csoundjournal.com/#ref15). Using a depth camera, the Kinect is able to track the joints of users by obtaining what is commonly known as *skeleton *information. A number of tools have been implemented for allowing this, including the Kinect SDK[[16]](https://csoundjournal.com/#ref16), the OpenNI library[[17]](https://csoundjournal.com/#ref17), and the Flexible Action and Articulated Skeleton Toolkit (FAAST)[[18]](https://csoundjournal.com/#ref18). FAAST has been used for communication with Unity 3D and Csound binaural 3D opcodes (using an older version of the previously mentioned interface with Unity) within the Rehabilitation Gaming System[[19]](https://csoundjournal.com/#ref19)[[20]](https://csoundjournal.com/#ref20) for mapping the position of joints to the position of virtual 3D sounds.

Additionally, a version of the Max/MSP system described in the previous section includes a Kinect addition. It uses the Max object *dp.kinect *for Windows[[21]](https://csoundjournal.com/#ref21), and *jit.openni*[[22]](https://csoundjournal.com/#ref22) for Mac OS. This implementation is not based on the *skeleton *tracking format, but rather on the detection of blobs through the use of the *cv.jit *Max objects collection[[23]](https://csoundjournal.com/#ref23), where the Kinect is positioned on top of the users, so that what is achieved is head tracking. This method is done for assessing the 3D position of the user's head relative to the virtual sound-sources. Note that this does not intrinsically account for head-rotation tracking. However, such discussion is outside the scope of this paper.
### Ableton Live


Live (Ableton)[[24]](https://csoundjournal.com/#ref24) is a popular Digital Audio Workstation optimized for live performance. Plug-ins for Live may be programmed using Max for Live, which embeds Max within Live. Using the *csound~ *Max object[[14]](https://csoundjournal.com/#ref14), a plug-in was developed for positioning 3D sound-sources in binaural space from within Live. Positions may be modified from within the plug-in GUI (Figure 5). The current implementation is only available with the use of the *hrtfearly *and *hrtfreverb *opcodes. Future versions will include access to more room parameters.  ![image](images/research_Image_004.png)

 **Figure 4. Ableton Live's Binaural 3D sound plugin.**
##
III. Research Applications


The previously presented systems may be used for research in various disciplines, especially in the Cognitive Sciences, which find an immediate application for rehabilitation and research. In the rehabilitation context, a study by Avanzini and colleagues[[25]](https://csoundjournal.com/#ref25) analyses 36 papers referring to multiple technological rehabilitation systems, ranging from robotics to virtual reality. In their study they point out that it is only a minuscule part of the papers that use sound as a continuous feedback (rather than an auditory icon) aimed at having impact in the rehabilitation process.

On the other hand, research on multimodality and crossmodal modulations may be achieved through these systems. As pointed out by Shams and others, "most studies have focused on the effects of visual stimulation on perception in other modalities, and consequently the effects of other modalities on vision are not as well understood"[[7]](https://csoundjournal.com/#ref7). In terms of movement and sensing, according to Lakoff and Gallesse, "the modalities of action and perception are integrated at the level of the sensory-motor system itself and not via higher association areas"[[26]](https://csoundjournal.com/#ref26). They, too, argue that multimodality denies the existence of separate modules for action and perception, showing that "the same neurons that control purposeful actions also respond to visual, auditory and somato-sensory information about the objects to which the actions are directed"[[26]](https://csoundjournal.com/#ref26). A better understanding over this perspective is of the outmost importance for optimizing motor-rehabilitation processes when the issues are related to cognitive impairments. Such views suggests that sensory stimulation coupled with movement may have a direct effect on movement-recovery, as has been shown by the Rehabilitation Gaming System[[19]](https://csoundjournal.com/#ref19)[[20]](https://csoundjournal.com/#ref20). Another potential study area for these tools is that of spatial neglect, which affects the conscious access to certain spacial locations. A similar approach for studying auditory-neglect is taken by Bellman and colleagues[[27]](https://csoundjournal.com/#ref27) through the use of interaural time differences (ITDs, one of the aspects that constitute binaural 3D sound, see [[3]](https://csoundjournal.com/#ref3), [[4]](https://csoundjournal.com/#ref4) and [[5]](https://csoundjournal.com/#ref5)).

Aytekin and colleagues[[28]](https://csoundjournal.com/#ref28), consistent with the sensorimotor contingencies theory of O'Regan and Noë[[29]](https://csoundjournal.com/#ref29), propose a sensorimotor approach to sound localization, arguing that acoustical cues are not enough to provide a spatial reference. Their arguments show that the embodied nature of sound localization implies brain plasticity: neural adaptations to the subject's structural development and environment, providing evidence that auditory experience is prior to sound localization. On the other hand, they explicitly present sound localization as a multimodal ability saying that "Vision, for instance, can influence and guide calibration of sound localization,"[[28]](https://csoundjournal.com/#ref28) and "Proprioceptive senses, such as position and the motion of the head, as well as the perceived direction of gravitational forces, and gaze direction also play(s) essential roles in sound localization"[[28]](https://csoundjournal.com/#ref28). Following these ideas, experimental results may be acquired by means of the previously presented systems.

Note that human's HRTFs are subjective, as they are based on an individual's physiological attributes. Csound's binaural 3D opcodes are based on the use of a KEMAR dummy head microphone[[9]](https://csoundjournal.com/#ref9) and are not optimal in terms of an individual's subtleties, but provide a good reference of the HRTFs. More recent HRTF libraries are available, but a detailed discussion on the subject is outside the scope of this paper.
### Current applications


The use of the *hrtfmove2 *opcode in conjunction with Unity showed preliminary results in that there is a significant positive effect of movement in the perception of auditory depth in virtual environments[[30]](https://csoundjournal.com/#ref30). This was achieved through *skeleton *tracking, using the Kinect, under two conditions: (1) disabling the effect of torso-movement on the auditory stimuli, and (2) enabling it[[30]](https://csoundjournal.com/#ref30). When the movement of the torso had an impact on the auditory stimuli, subjects showed a significantly improved detection of auditory depth (how far away sound sources are). Surprisingly, opposite results were found regarding the perception of elevation and azimuth. Further research is needed to clarify these results, however it appears clear that the manipulated parameters are closely interlinked in perception. Furthermore, the Unity 3D integration with binaural sound may be important for future studies on sensorimotor and audiovisual couplings.

Additionally, Regev[[31]](https://csoundjournal.com/#ref31) showed that after a short process of mapping the arm's position to sound frequency, a proprioceptive and auditory coupling is achieved (creating a sensorimotor contingency [see [[29]](https://csoundjournal.com/#ref29)]), after which modifying the mapping to pitch has an impact on the arm's proprioception. Such study may be further investigated through using spatial sound and possibly used in future rehabilitation systems.

The application of non-natural sensorimotor contingencies was applied in an artistic context within an installation for the project *Qualia*(Paul Rosero, Marte Roel, 2013). The installation uses the Max/MSP system previously described, in conjunction with Kinect for user tracking. This allows to map the size of a physical room to a room of virtualy any dimensions. Such an approach provides non-natural sensorimotor couplings of movement to spatial position of sounds, where one human step may be reflected as fifty meters in terms of virtual sound. Although this approach was used in an artistic context, it may be of use for studying adaptive processes in terms of the sensorimotor system as well as the efect that such changes have on a subject's movement.

Lastly, a similar approach was used for the art installation *Ominous Luminosity *(Ovidiu Cincheza, Aki Weston Murai, Marte Roel, 2012), where users explore a city by riding on a static bicycle from within a gallery. Within a research context, this may be used for assessing our capacity for abstracting spatial displacement though auditory acceleration cues.
## IV. Conclusion


The previously presented systems as well as the theories and applications described may be of significance for future research in the area of the Cognitive Sciences. Such ideas may be accounted by people pursuing graduate studies in related areas, as well as independent researchers. Further development of the proposed systems is encouraged. It should be noted that none of these systems account for data logging and that such a tool is important for research applications. Also the use of other HRTF libraries other than MIT's KEMAR should be considered for future revisions of the opcodes.
## Acknowledgements


We want to mention our gratification to the work of Dr. Brian Carty, who developed the opcodes mentioned above for binaural 3D sound. He has always been very supportive of our research. We also want to thank Dr. Richard Boulanger for his constant support and enthusiasm. Finally, we want to thank Dr. Armin Duff, and the people of the Synthetic, Perceptive, Emotive and Cognitive Systems Group at the Universitat Pompeu Fabra.
## References


[][1]] B. Carty, "HRTFmove, HRTFstat, HRTFmove2: Using the new HRTF Opcodes." *Csound Journal*, Issue 9, July 28, 2008. [Online]. Available: [http://www.csounds.com/journal/issue9/newHRTFOpcodes.html](http://www.csounds.com/journal/issue9/newHRTFOpcodes.html). [Accessed Aug. 16, 2013].

[][2]] B. Carty, "Hrtfearly and HrtfreverbNew Opcodes for Binaural Spatialisation." *Csound Journal*, Issue 16, January 24, 2012. [Online]. Available: [http://www.csounds.com/journal/issue16/CartyReverbOpcodes.html](http://www.csounds.com/journal/issue16/CartyReverbOpcodes.html) [Accessed Aug. 17, 2013].

[[3]] W. M. Hartmann, "How We Localize Sound." *Physics Today*, American Institute of Physics, November 1999, pp. 24-29.

[[4]] J. Blauert, "Spatial Hearing: The Psychophysics of Human Sound Localization." English Translation. Cambridge, MA: Massachusetts Institute of Technology, 1997.

[[5]] D. W. Grantham, "Spatial hearing and related phenomena." In *Hearing*, B.J.C. Moore, New York, NY: Academic Press, Inc., 1995.

[][6]] B. Carty, "Movements in Binaural Space: Issues in HRTF Interpolation and Reverberation, with applications to Computer Music." *NUI Maynooth ePrints and eTheses Archive*, June 17, 2011. [Online]. Available: [http://eprints.nuim.ie/2580/](http://eprints.nuim.ie/2580/). [Accessed Aug. 17, 2013].

[][7]] L. Shams, Y. Kamitani, and S. Shimojo, "Modulations of Visual Perception by Sound." In *The Handbook of Multisensory Processes*. G. Calvert, C. Spence, B. E. Stein, Cambridge, MA : MIT Press, 2004, pp. 27 -33.

[][8]] G. Calvert, C. Spence, B. E. Stein, "Introduction." In *The Handbook of Multisensory Processes. *G. Calvert, C. Spence, B. E. Stein, Cambridge, MA : MIT Press, 2004, xii - xvii.

[][9] B. Gardner, K. Martin, "HrtfMeasurements of a KEMAR Dummy-Head Microphone," MIT Media Lab Machine Listening Group, July 18, 2000. [Online]. Available: [http://sound.media.mit.edu/resources/KEMAR.html](http://sound.media.mit.edu/resources/KEMAR.html) [Accessed Aug. 30, 2013].

[][10]] B. Carty, "MultiBin, A Binaural Tool for the Audition of Multi-Channel Audio." * Csound Journal*, Issue 16, 2012. [Online]. Available: [http://www.csounds.com/journal/issue16/multibin.html](http://www.csounds.com/journal/issue16/multibin.html) [Accessed Aug. 31, 2013].

[][11]] Unity Technologies, "Create the games you love with Unity" *Unity Official Website*, 2013. [Online]. Available: [http://unity3d.com/unity/](http://unity3d.com/unity/) [Accessed Aug. 16, 2013].

[][12]] M. E. Roel Lesur, "Interfacing Csound and Unity: Mapping visual and binaural 3D coordinates in virtual space." *Csound Journal*, Issue 19, 2013. [In press].

[][13]] Cycling 74, "Visual Programming with Max" *Cycling 74, **Official Website*, 2013*. *Available: [http://cycling74.com/products/max/visual-programming/](http://cycling74.com/products/max/visual-programming/) [Accessed Sept. 15, 2013].

[][14]] Davis Pyon, "A Max external to run Csound." 2003. [Online].Available: [http://www.davixology.com/csound~.html](http://www.davixology.com/csound%7E.html) [Accessed Sept. 15, 2013].

[][15]] Microsoft Corporation, "Kinect for Windows Features," *Kinect for Windows, *Official Website, 2013. [Online]. Available: [http://www.microsoft.com/en-us/kinectforwindows/discover/features.aspx](http://www.microsoft.com/en-us/kinectforwindows/discover/features.aspx) [Accessed Sept. 15, 2013].

[][16]] Microsoft Corporation, "Developer Downloads," *Kinect for Windows, *Official Website, 2013. [Online]. Available: [http:// www.microsoft.com/en-us/kinectforwindows/develop/developer-downloads.aspx](http://www.microsoft.com/en-us/kinectforwindows/develop/developer-downloads.aspx) [Accessed Sept. 15, 2013].

[][17]] Open NI, "About OpenNI, " *OpenNI, **Official Website*, 2013. [Online]. Available: [http://www.openni.org/about/](http://www.openni.org/about/) [Accessed Sept. 16, 2013].

[][18]]E. Suma, B Lange, A. Rizzo, D. Krum, M. Bolas, "FAAST: The Flexible Action and Articulated Skeleton Toolkit." *Proceedings of IEEE Virtual Reality*, 2011, pp. 247-248.

[][19] M.S. Cameirao, *et al*., "Neurorehabilitation using the virtual reality based Rehabilitation Gaming System: methodology, design, psychometrics, usability and validation." *Journal of Neuroengineering and Rehabilitation, *vol. 7, 2010, p. 48.

[][20]] Universitat Pompeu Fabra, "Rehabilitation Gaming System," Rehabilitation Gaming System, *Official Website*, 2013. Available: [http://rgs-project.eu/](http://rgs-project.eu/) [Accessed Sept. 15, 2013].

[][21]] D. Phurrough, "dp.kinect, Cycling 74 Max external using Microsoft Kinect SDK." 2013. [Online].Available: [http://hidale.com/dp-kinect/](http://hidale.com/dp-kinect/) [Accessed Sept 15, 2013].

[][22]] D. Phurrough, "jit.openni, OpenNI access for your depth sensors like Microsoft Kinect in Cycling 74's Max." 2013. [Online].Available: [http://hidale.com/jit-openni/](http://hidale.com/jit-openni/) [Accessed Sept 15, 2013].

[][23]] J. M. Pelletier, "cv.jit, computer vision for jitter." 2013. [Online].Available: [http://jmpelletier.com/cvjit/](http://jmpelletier.com/cvjit/) [Accessed Sept.15, 2013].

[][24]] Ableton "Live". [Online]. Available: [https://www.ableton.com/en/](https://www.ableton.com/en/) [Accessed February 6, 2014].

[][25]] F. Avanzini, A. De Götzen, S. Spagnol, A. Rodá, "Integrating auditory feedback in motor rehabilitation systems." *Dep. of Information Engineering, University of Padova, Italy.* 2010. [Online]. Available: [http://www.dei.unipd.it/~avanzini/downloads/paper/avanzini_skills09.pdf](http://www.dei.unipd.it/~avanzini/downloads/paper/avanzini_skills09.pdf) [Accessed Feb. 15, 2014].

[][26]]. V. Gallese, G. Lakoff, "The Brain's Concepts: The Role of the Sensory-motor System in Conceptual knowledge." *Cognitive Neuropsychology*, 21. 2005. [Online]. Available: [http://www.unipr.it/arpa/mirror/pubs/pdffiles/Gallese-Lakoff_2005.pdf](http://www.unipr.it/arpa/mirror/pubs/pdffiles/Gallese-Lakoff_2005.pdf) [Accessed Feb. 15, 2014].

[][27]] A. Bellman, R. Meuli, S. Clarke, "Two types of auditory neglect," *Brain *. Oxford University Press, 2001, pp. 676-687.

[][28]] M. Aytekin, C.F. Moss, J. Z. Simon, "A Sensorimotor Approach to Sound Localization." *Neural Computation*, Vol. 20, No. 3, 2008, pp. 603-635.

[][29]] K. J. O'Regan, A. Noë, "What is it like to see: A sensorimotor theory of perceptual experience." *Synthèse,* 129(1), 2001, 79-103.

[][30]] M. E. Roel Lesur, *3D Neurorehabilitation Environments: assessing the effect of sensorimotor dynamics for spacial perception in virtual environments for two modalities: visual and auditory*. Master Thesis, Department of Communication and Information Technologies, Universitat Pompeu Fabra, 2012.

[][31]] Regev, I.T. *Sonic Feedback to Movement, Assesment of Learned Auditory-Proprioceptive Integration*. Master Thesis, Department of Communication and Information Technologies, Universitat Pompeu Fabra, 2011.
