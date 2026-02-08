---
source: Csound Journal
issue: 23
title: "Csound 30: Report on the Conference to Celebrate 30 Years of Csounding"
author: "Iain McCurdy"
url: https://csoundjournal.com/issue23/Csound30.html
---

# Csound 30: Report on the Conference to Celebrate 30 Years of Csounding

**Author:** Iain McCurdy
**Issue:** 23
**Source:** [Csound Journal](https://csoundjournal.com/issue23/Csound30.html)

---

[CSOUND JOURNAL ISSUE 23](https://csoundjournal.com/index.html)

 [INDEX](http://www.csoundjournal.com/) | [ABOUT](https://csoundjournal.com/about.html) | [LINKS](https://csoundjournal.com/links.html)     ![abstract image](images/Csound30Square.JPG)
# Csound 30

### Report on the Conference to Celebrate 30 Years of Csounding


by Iain McCurdy
## Introduction


The Csound 30 conference was held in Maynooth University, Ireland from the 25th–27th November, 2016. This was not part of the biennial canon of International Csound Conferences that began in Hannover in 2011, continued in Boston in 2013 and moved to Saint Petersburg in 2015, but was organised to mark the 30th anniversary of the program's existance. The significance of this juncture in Csound's life is not that it merely runs or is used or is supported but that it continues to lead the field in the comprehensive library of tools and techniques it provides for, its adoption of new trends and platforms, and its offering of a wide range of working methods through the numerous front-ends and interfaces offered by means of the API. Csound survives and flourishes by means of its community, which includes developers, composers and researchers, so it was a priority of the organisers that this conference be kept as accessible and efficient as possible to enable attendance by as many people as possible regardless of background or affiliation. Maynooth seemed to a reasonably accesible location but of course given Csound's global usage, there is no true centre. This global reach was demonstrated through the performance of music from as far afield as Tallinn, Montana and Chengdu.
## I. Tarmo Johannes: *The Computer Duo - technology as both a tool and a partner in performance*


The conference opened with the keynote speech delivered by Tarmo Johannes. This was also presented as part of the Maynooth Music Department's research seminar series and Tarmo succeeded in engaging the gamut of musicologists, composers, undergraduates, postgraduates and visiting Csounders who were in attendance. In this speech Tarmo talked about his first encounter and subsequent journey with Csound. The highlights were perhaps the performance of several pieces for flute and electronics.

Tarmo's first contact with Csound was through recommendation and for the purpose of implementing a performance of a Cage theatre piece by his ensemble 'U'[[1]](https://csoundjournal.com/#ref1). Tarmo's early work made use of Perl scripts to generate scores and his subsequent encounter with CsoundQt prompted continued interest, particularly by virtue of its integrated support. This interest led him to contribute to CsoundQt's development, ultimately leading to him becoming its chief developer. Subsequent work explored the ideas of interactive works and sound games. The question these works promoted was: "Where is the music? Within the game? Within the performer? Within the audience". Of course there is no definitive answer. Tarmo also observed that as participation can activate and excite audiences, making them more active listeners, audiences are no longer mere 'clients'. With the improvement and accesibility of mobile technology, Tarmo started to look at smartphones as potential instruments, using communication via the websocket protocol, ultimately through the use of Csound's websocket opcodes. This allows for the creation of HTML-based user interfaces with a host program written using CsoundQt and C++, and utilising the Csound API. A good example of this approach was used in *Pattern Game* which received a performance at the Csound Conference in St. Petersburg in 2015.

![Tarmo Johannes image](images/Tarmo.JPG)

**Figure 1. Tarmo Johannes performing *Studio 2B*.**

For the Emanuele Casale piece *Studio 2B* (2000), for alto flute and tape, Tarmo used Csound to create a visual click track as an alternative to using an audio click with headphones, a practice that can inhibit a players performance. OSC messages are sent from Csound to Processing[[2]](https://csoundjournal.com/#ref2) to control how to display a self-scrolling score along with a cursor to indicate the location where the player should be within the score. This piece was then performed within the talk, acting as a good example of how Csound can aid performance while not even being used to create or process audio.

 Tarmo then went on to discuss his work with remote music making, often via networks. This work capitalises on Csound 6's ability to recompile during performance and also inspired the UDP connection facilities of Csound to be written - a good example of how a practitioner's usage and needs can inspire the direction that developers take.

 Another example of Csound as an aid to performance is Tarmo's piece of software *eClick*[[3]](https://csoundjournal.com/#ref3) which uses a Csound master score to determine the nature of a metronome signal that can then be sent to any number of client performers via WIFI, thus ensuring synchronisation. This technology was then demonstrated through a performance of *Piccolo und Rauschen* (1996–97) by Peter Ablinger.

 Tarmo next introduced, *Braingame* (2015), another of his pieces that employs 'intercontinental' performance, this time in conjuction with the use of EEG and skin conductance sensors. This piece also made use of network streaming of audio using the Jamulus software[[4]](https://csoundjournal.com/#ref4) and it facilitated participation from musicians from around the world, including some famous Csounders.

 Finally Tarmo introduced and performed the highly atmospheric piece *Calls from the Fog* (2010) for flute and live electronics by Enda Bates. This electronic part of piece was originally written using MaxMSP but as the transformations it employs are fairly generic, Tarmo transcribed it for Csound with little difficulty. Its composer, Enda Bates, is an Irish composer based in Dublin and was also in attendance.
## II. Paper Sessions


The conference held two paper sessions which featured presentations from a mixture of locally based and international researchers.
### Dr. Richard Boulanger - Csound: the Roots, Birth and Early Years


 Our conference would have felt incomplete without the presence of Dr. Richard Boulanger so we were extremely pleased that he was in attendance and contributed so fully to the proceedings. Richard's first presentation, entitled *Three Decades with Csound: the Roots, Birth and Early Years*, provided a potted history of Csound from someone who was there at all of the key moments. This talk actually reached back further in history to Csound's notable antecedents of the 1960s and 70s. Richard's talk was full of revealing anecdotes involving key figures of electronic music, and to hear these stories relayed first hand particularly piqued the interest of Maynooth students.

![Boulanger image](images/RichardBoulanger.JPG)

**Figure 2. Dr. Richard Boulanger.**

 Richard started with a description of working with Barry Veroe at the MIT Media Lab as Csound made its first beeps. This collaboration had begun earlier with Music 11 in 1979 and the composition of Richard's seminal work *Trapped in Convert*. With Csound, Richard and Barry had used this piece as a test case in seeking out bugs. Csound's speed and efficiency distinguished it from its peers from the early days and this, suggests Richard, is key in its longevity. Richard was involved with benchmarking this efficiency in the 1980s at 'CARL' (The Computer Audio Research Laboratory) in San Diego on their PDP11 computer.
 Another key relationship for both Richard and Barry and by extension Csound was of course that with Max Mathews, the author of Music I - V of the Music N family of computer music programs[[5]](https://csoundjournal.com/#ref5). Csound itself grew out of Music IV. Barry Vercoe's undoubted genius was noted but Richard also described Barry's lectures where he would whisper into whiteboards that encircled the lecture theatre, eventually filling them completely. We were also intrigued to learn of Barry's triple filter paper method for making coffee that would ensure the strongest possible brew - Csound's origins are highly caffeinated. The inaccessibility of Barry Vercoe's original reference notes for the program (Barry insisted that they were an aide-mémoire for *him*) inspired Richard to scan, correct and word-process them. The first Csound Book[[6]](https://csoundjournal.com/#ref6) was written to address the obtuse nature the text of the reference manual. It is in these acts that Dr. B. reveals himself as the great evangelist for Csound.

 Richard next gave credit to an individual who might otherwise be overlooked. Larry Beauregard was first flautist in Pierre Boulez's Ensemble InterContemporain[[7]](https://csoundjournal.com/#ref7). Barry Vercoe had been collaborating with Larry on 'Synthetic Performer'[[8]](https://csoundjournal.com/#ref8), software for creating a virtual accompaniment for a live performer, in the early 1980s at IRCAM. In fact, also at IRCAM at this time, Miller Puckette wrote Max (later MaxMSP)[[9]](https://csoundjournal.com/#ref9) originally as an visual interface for Synthestic Performer. After Larry Beauregard's untimely death in 1985 Barry returned to MIT where he subsequently wrote Csound.

 As Csound progressed, Barry Vercoe's work on it receded and the project was adopted by others. John ffitch ported Csound to standard platforms such as MacOS and Windows. An significant block existed in Csound's original licence in that it only allowed the sofware to be used for non-profit educational purposes. Pressure from multiple contributor to the program finally forced MIT to release the software as Open Source LGPL. This change precipitated many of the developement that have allowed Csound to continue to thrive in the 2000s. Richard's interaction with Barry has continued though and one example of this was Barry's invitation to Richard to work together on the OLPC (One Laptop Per Child) project[[10]](https://csoundjournal.com/#ref10), a project to design Linux-based laptops to be distributed to children in developing countries. The music application on the OLPC used Csound as the synthesis engine. Barry's recent work has focussed more on education, and Richard noted that Barry has sometimes lamented that he has, to some extent, sacrificed his compositional career for that of a developer. Despite his distance from the project, Richard assured us that Barry is happy with where Csound is now.
### Brian Carty - Robotune: an iOS Application built with Csound


 Dr. Brian Carty is currently the director of education at the the Sound Training College in Dublin[[11]](https://csoundjournal.com/#ref11) and, inspired by a desire to engage his students with Csound, he initiated a project to create an app for iOS. The origins of this project go back five years when Auto-Tune [[12]](https://csoundjournal.com/#ref12) was very much in vogue. Robotune ultimately goes beyond the basic reparatory function of an auto-tune and is capable of many choir-like transformations of a single voice and robotic transformations. A better reference point is perhaps the 'TC Helicon VoiceLive 2'[[13]](https://csoundjournal.com/#ref13). With the Robotune, Brian hoped to be able to create an economical and accesible alternative to the existing examples, and based on the 500+ downloads made of the app since its release, this has been achieved. Development of the final app took about a year. The project was also a test of the notion that Csound could be used to produce a commercially successful software tool.

![Carty image](images/BrianCartyPaper.JPG)

**Figure 3. Dr. Brian Carty.**

 In the sound processing part of the app, Csound's frequency domain capabilities were naturally a significant element. At its core, the pTrack[[14]](https://csoundjournal.com/#ref14) opcode plays a priniciple role in tracking pitch and was chosen as the most reliable option amongst Csound small collection of pitch tracking opcodes. Choir harmonisation is offered with intelligent interval selection but it should be stressed that describing the effect can never do it justice and hearing the results are inifintely more illuminating. Time domain processing options also offered with Robotune including delays, reverb and looping. 'Swift' was used to develop the UI and the chnget/chnset opcodes were used for communication. The app is currently available on GitHub and the App store. Android's latency audio issues has held back developing a version for that platform but development on an Android version is in progress.

 In conclusion Brian reported that the app had received over 500 downloads, all derived from a development with no budget. It has been credited on several commercial releases and it has been noticed that these occurences have prompted spikes in downloads.


 Brian hopes that the success of this project will inspire other users to pursue a similar project.
### Dr. Steven Yi - On Csound and Blue


 Steven's talk was intended to present his views and experiences of Csound as a developer, particularly in regard to his own Csound front-end software, 'Blue'[[15]](https://csoundjournal.com/#ref15).

![Yi image](images/StevenYiPaper.JPG)

**Figure 4. Dr. Steven Yi.**

 Steven began by providing an overview of 'Blue's capabilities before discussing where he sees Csound and Blue going in the future. Steven noted that his point of entry with Csound was in 1998 through the program Cecilia, shortly before the release of the Csound Book[[6]](https://csoundjournal.com/#ref6) at which point Csound 4 would have been current. A key attraction was the precision offered by Csound and the openness of the community. Steven's first big contribution to the community was a program initially called 'Object Composition Environment', later to be called Blue. Its early developement was inspired by Steven's work with Flash amd was envisioned as a visual environment for Csound score development. Open-endeness, however, remained and remains a key precept: the software should resist assumption of any specific working method or style.

 2001-2004 covered Blue's early development and during this time it simply created a csd which would then be run by Csound.
 2004-2005 brought about key language changes enabled by the introduction of Matt Ingalls 'subinstrument' system which was followed by UDOs. Re-entrency with the API allows using Csound as a library and facilitates new language bindings.
 In 2005 Blue's mixer and effects system was introduced.
 From 2005-2011 Csound 5 matures, many changes were made internally that were not necessarily immediately apparent to the user. Developments were made on Csound's parser. Following on from intiatives begun in 2011 at the Csound Conferenece in Hannover, Csound is ported to iOS and Android. Csound also becomes usuable on the web through browsers using Portable Native Client (PNaCl) and Emscripten.
 2012-present represents the time so far covered by Csound 6. Transactional compilation becomes possible which enables live coding. Arrays are finally introduced into the language and sample accurate processing is implemented. Blue itself is still catching up with everything that is possible with Csound 6 but a commitment to modular design.
 Looking beyond the present, Steven highlighted Csound 7's proposed ability to be able to instantiate opcodes on the own connect them as they like, independent of usage within an instrument, as a feature that could open up many new and exciting possibilities for how the user might interact with Csound in real-time. What would result would be a kind of 'node' system where instruments could be reordered graphically. Steven likened these capabilities to things that are already possible in Supercollider.

 Following on from Steven's talk there were many questions posed, with particular interest being shown towards some of the new filters that Steven has added to Csound.
### Dr. Richard Boulanger: - Boulanger Labs, Writing Apps and Building Hardware Synths with Csound Inside


 Following on from his survey of the history of Csound, Richard Boulanger gave a overview of his experience of founding and managing the Boulanger Labs company which has, since 2011, produced a range of Csound-based software products for Ableton Live and for the Apple iPad. Richard has seen this venture as an important step in introducing Csound to a wider audience, but while it may not have been profitable to him personally, is has been highly successful in promoting the work of up and coming students and has provided for them career springboards.

 Richard also acknowleged the work of the wider Csound community and how Boulanger Labs endeavours have been enabled by helped by Csound tilda (~), the Csound object for MaxMSP and by the porting of Csound to iOS.

 Offshoot projects by contributors to Boulanger Labs are also impressive and one that Richard drew attention to in particular was the realisation of Csound as a hardware modular Eurorack in the Nebulae unit created by Qu-Bit.
### Martin Crowley, James Kelly - Educational Tools for Live Sound Engineering Built Using Cabbage and Csound Feedback


 Martin Crowley and James Kelly work at the Sound Training College in Dublin and presented a paper which introduced three sound engineering tools they had devised using Csound and Cabbage. The intention of these tools was educational and more specifically they intended to make accessible the training and testing of sound engineering principles in virtual environments.

![Crowley and Kelly image](images/MartinCrowleyJamesKelly.JPG)

**Figure 5. Martin Crowley and James Kelly.**

 The first of these was a recursive mixer inteeded to simulate carious tasks related to live sound. Students can explore signal flow routing and basic mix features including the setting up of multiple monitor mixes and EQ. This tool (along with the other two) includes an 'admin' panel which allows the student or the tutor to compare the current set-up with an earlier saved snapshot or an 'answer' version.

 The second tool presents a virtual room tuner where, using impulse responses of real rooms, students can explore the task of setting up EQ to compensate for the filtering effects of rooms and in particular act against individual frequencies 'taking off'.

 The third tool explores the phenomenon of microphone feedback based on gain distance of the microphone from the source (loop time) and axis orientation of the microphone. The graphics capabilities of Cabbage allowed this tool to present an interface in which the student actually drags the microphone around the virtual stage rather than simply dealing with a list of parameters.
### Federico Russo – MIDI Controlled Audio Effects – Real-Time Reshaping of the Audio Signal


 Federico Russo attended the Sound Training College in Dublin as an Erasmus student. Federico has continued his research since then and at the conference presented work on a new sound processing instrument based around the vocoder and cross-synthesis.

![Russo image](images/Federico.JPG)

**Figure 6. Federico Russo.**

 The instrument reads a live audio input (but optimised for sustaining, slow attack instruments) and is MIDI controlled. It incorporates a range of processing options, including reverbs and binaural sound projection, all with a flexible internal patching system. Federico presented some very impressive live examples using his own voice as input. This instrument offered a good companion piece to Brian Carty's 'RoboVoice' instrument.
### Shane Byrne - Csound as a Tool for Enabling Musicians


 Shane Byrne is currently working towards PhD in composition at Maynooth University with a focus on enabling human interaction through the use of technology. Shane provided an overview of his work over recent year, with a particular focus on his work with musicians with disabilities.

 *Ear Eye Mouth* is an installation piece that was a collaboration with Simon Kenny. It presented a model of a human ear embedded with a microphone as the source input for the installation. The sound of the room would then be processed useing pvs opcodes and diffused across four channels according to sensed movements via a Leap motion sensor. A later project, involving the Galway Autism Project which facilitates activities for 8 - 14 year olds, used the *Ear Eye Mouth* set-up but responded to feedback from participants by shifting the focus of provided tools towards more conventional sounds - sounds that were described as "clawing on the inside of my ears" were replaced with more easily digestible sounds resembling electric pianos. Shane noted that 'in-air' sensors, such as the Leap, can encourage more confident interaction from musicians with an aversion to physically touching instruments or sensors.

 Shane then introduced a number of successful projects that had been undertaken based at Queens University in Belfast, specifically at SARC (Sonic Arts Research Centre). The first of these was the 'Big Ears' 3-day workshop. With a focus on design and development being a two-way interaction between the designer and the musician/user, participants with a range of disabilies were encouraged to test and offer feedback on prototype instrument. Shane discussed the difficulty in ensuring sustainability of instruments beyond the project on account of the frequent need of esoteric knowledge in order to run these instrument and patch; the user or their carer may not have knowledge of the software, in Shane's case this would normally be Csound but for this project, because of sponsership restrictions, this was MaxMSP and the Arduino IDE. Recent front-end developments for Csound are starting to address this problem.

 Maynooth University's association with Intel has gained access for Shane to a number of their Intel Galileo boards for designing embedded instruments. Specialist opcodes were written (by Prof. Victor Lazzarini) to enable simplified input and output of data with the board. (After the talk it was suggested that these should be extended to facilitate usage with the Raspberry Pi's GPIO pins for auxiliary sensor communication.) The Galileo has received much less exposure and usage that the Raspberry Pi, probably on account of its much greater expense. It has now been replaced with the Edison board.

![Joystick inst. image](images/ShaneJoystick.JPG)

**Figure 7. Shane Byrne's Bespoke joystick instrument.**

 In a subsequent 'Big Ears' project at SARC in Belfast Shane was able to begin rolling out his ideas for the Galileo. The format for the project was modified this time: after an initial 2-day meeting the project would break and then reconvene two months later. This was to allow for much greater development durign the project. This time Shane worked on a joystick instrument that controlled a 4-oscillator synthesiser that employed various pitch modulations (a demonstration of this synthesiser particularly piqued the interest of Victor Lazzarini). The hardware that constituted the joystick was not an off-the-shelf item but instead combined home-made electronics and 3-d printing; a typical game-pad type joystick would be too small and inaccessible for those with movement restrictions. As well as the normal joystick operations, this instrument offers touch and pressure sensitivity.
### Thom McDonnell - Development of the Csound HRTF Opcodes to Allow use of Any Dataset, utilising the SOFA standard


 Thom McDonnell is Vice Principal and lecturer at the Sound Training College in Dublin and is also currently working towards a Masters by Research. Thom provided a survey of him research which builds upon HRTF innovations by Dr. Brian Carty. The aim of this technology is to be able to put sounds into 'real' spaces that are created virtually. Thom opened with an overview of the significant cues impacting upon sound localisation such as left/right volume difference, inter-aural time delay, pinna filtering and diffraction discrepancies between low and high frequecies.

![McDonnell image](images/Thom.JPG)

**Figure 8. Thom McDonnell.**

 One strand of Thom's work is to bring greater movement possibilities into HRTF work as a model of what could be aimed for he introduced the piece *Aisatsana* by the Aphex Twin which involves a remotely played grand piano swinging over the heads of the audience. The potential exists for Csound to do this virtually.

 It is important to address the newest technologies and Thom how this could be done by considering application that might involve the Oculus Rift Virtual Reality system, Playstation Virtual Reality and Cinema surround sound. One of the challenges in making this sort of technilogy more mainstream and transprtable is by implementing greater standardisation and one example where this is currently lacking is in the plethora of methods employed in capturing HRTF data sets. As a result of this the MIT data set has become rather ubiquitous on account of its overuse in attempt to create some sort of a standard. AES (Audio Engineers Society) has attempted to introduce a standardisation through the SOFA (Spatially Oriented Format for Acoustics). Thom went on to describe the highights of the format. As far as Csound is concerned Thom suggested possible improvements that could be made upon the existing HRTF opcodes.
## III. Workshops


On the second day of the conference there were two workshops held. Conference attendees were were able to attend both as participants and observers.
### Rory Walsh - Csound and the Unity Game Engine


 Rory Walsh's work with integrating Csound within game engine platforms is already familiar to a number of us but in this workshop he was able to present a further refinement of his work, some new examples and a quick start procedure for attendees.

![Walsh image](images/Rory.JPG)

**Figure 9. Rory Walsh.**

 Rory began by introducing the basic concepts of the Unity game engine framework such as player movements, camera movement, asset and project hierachy, collisions and events, the concept of 'AudioSources' and 'AudioListeners', scenes (game levels), lighting and the detinction between world space and local space within a game.

 Rory showed how an 'AudioSource' could be connected with playback of a stored sound and then connected to an object. 'AudioListeners' make a source audible and are normally connected to an in game 'camera' which will normally equate to the the point of view of the player.

 Next Rory was able do introduce his CsoundUnity package which integrates Csound with Unity. Older versions of this package insisted upon disabling Unity's audio facilities but the new version is able to combine Csound and Unity's audio procesing components. This therefore makes Csound simultaneously available with some of Unities 3d audio processors and should entice seasoned Unity programmers who may otherwise have been unwilling to dispense with Unity built-in audio capabilities. In CsoundUnity, Csound is treated as an 'AudioSource'. Rory first worked through a simple example in which a ball fell onto a cube which, upon colliding, would trigger a sound. Introducing his iconic 'Cabbage Man' game character, he presented simple sound games in which the character could shoot as vertical bars to layer harmonic partials or apply bandpass filters to a noise source. Some useful troubleshooting episodes were able to engage the help of a number of the workshop attendees.

 To conclude his workshop, Rory treated us to a sneak preview of a game he has written (still a work-in-progress) for his 1-year-old son. A main character traverses a wintery forest landscape navigating obstacles, inquisitive sheep and leaves blowing in the wind. The artwork for this game was created by Rory's wife and they gather the source sounds together on their wave in the hills around Dundalk - they evidently make quite a creative team. It will be interesting to see how CsoundUnity develops and how Rory and others use it creatively.

![Klangwunderland image](images/klangwunderland.png)

**Figure 10. Screenshot from *Klangwunderland* by Rory Walsh.**
### Alex Hofmann and Bernt Isak Wærstad: Live Electronics with Csound and the Raspberry Pi


 The second workshop featured Alex Hofmann and Bernt Isak Wærstad demonstrating their work with the COSMO (Csound On Stage Music Operator) device. This endeavour embeds Csound on a Raspberry Pi tinyware computer which is interfaced to a range of knobs, switches and light and sets the whole thing in a rugged case. Essentially COSMO represents a programmable effects pedal of effects unit that raps into the power and variety offered by Csound. A number of similar projects have emerged but the COSMO approach is a unique one. Alex and Bernt have given a number of workshops where attendees build and take home their own COSMO so the project is more about enabling other to do this for themselves rather than COSMO simply supplying a finished product. Another unique angle to the project is that a number of specialised auxiliary bits of hardware (like 'hats' or 'shields') have been developed to better serve the finished device than existing add-ons. The workshops they deliver therefore cover both hardware and software aspects but due to time constraints, this particular session focussed more on the software side. COSMO hardware was provided to workshop particpants in various stages of completion so that they could quickly explore the setting up of software.

![Hofmann and Waerstad image](images/AlexBernt.JPG)

**Figure 11. Alex Hofmann and Bernt Isak Wærstad helping workshop participants set up the COSMO software on their laptops.**

 The main piece of custom built hardware that the modern COSMO uses is something called a COSMO 'plank' which is an oblong circuit board that supplies 8 analog inputs (for knobs or sliders), 8 digital inputs (for switches) and 8 digital outputs (for LEDs). The Cosmo plank is based around the MCP3008 chip.

 Alex and Bernt described the various stages of evolution of the project. High quality audio is generally a problem with TinyWare computers as they supply none built in. Earlier versions of the COSMO used a cheap Behringer sound interface but more recently the Wolfsen audio shield is used instead. Before using the MCP3008 and the development of the COSMO plank, an Arduino was explored as a means of getting analog control information into the Raspberry Pi.

 Another custom built hardware innovation is a mini-board that adds 'true bypass' and live monitoring via an analog dry/wet mixer.

 The COSMO uses Linux but the project supplies a specialised pre-build operating system image which greatly simplifies the process of getting started. So far the COSMO has focussed mainly on audio processing but there is no reason why this technology could not be easily adapted for creating synthesisers.

![Cosmo image](images/COSMO.JPG)

**Figure 12. A finished COSMO in a laser-cut, wooden case.**

 After showing some promotional videos for the COSMO project, Bernt then demonstrated a finished COSMO, in a laser cut wooden case, in action. The COSMO software uses generic controller naming conventions to allow user to easily modify patches. A system of using #include and macros allows users to easily chain multiple effects. A collection of ready-made effects exists on GitHub but users can of course create their own from scratch. FTP trasfer is used to update the csd that the COSMO will use on start-up. No disassembly of the device should be required to make software changes.

 The power of TinyWare hardware, such as the Raspberry Pi, has increased by so much in the last few years that serious applications for them are now a reality. The very first iteration of the Raspberry Pi was underpowered to the point that audio applications could not expand beyond that of mere novelty. The most recent versions can deliver complex reverbs and pvs-opcode processing with relative ease.
## IV. Music


The conference held two concerts on consecutive evenings in the university's concert space, Riverstown Hall. The first concert focussed on works for fixed medium in multi-channel and the second largely comprised of piece that incorporated some sort of live, improvisatory or interactive element. The concerts were named 'nchnls = 8' and '-iadc -odac' accordingly.

 The first concert opened with *Coloured Dots and the Voids in Between* by Jan Jacob Hofmann. This is a piece that was spatially encoded in 3rd order ambisonics for the eight-channel set-up. The piece was created using Steven Yi's 'Blue' software and, using the 'pluck' opcode exclusively for sound synthesis, it created a very striking and pointillistic soundworld. Fortunately Jan Jacob was in attendance at the conference and gave an introducion to the piece.

 *Vosim Dream Sequence II* by Dave Philips presented the listener with luxuriant waves of sound. Dave is a well-known promoter of the use of Csound on Linux, most recently using Cabbage and sometimes visually enhanced using AVSynthesis.

 Enrico Francioni's *End of Time* contrasted with its dark industrial tone and its sounds of tumbling discord.

 Arsalan Obedian's *Cstück Nr.2* used synchronous granular synthesis upon the sound of speech, to move from its intelligibility to its transformation into a artificial tone, and to emphasise the piece's theme of crossing 'borders'.

 Anthony di Furia's *Piano Selvatico (Wild Plane)* closed the first half of this concert. This was a long piece but was extremely rich and immersive. The piece drew on aspects of the soundscape composition as the listener was taken on a journey through various rural soundscapes involving birdsong, animal noises and other natural sounds. These stages were ornamented by synthetic waves of texture and surreal interjections, but also by subtle modulations upon the most recognisable sounds. It is always good to meet up with old friends and colleagues at these kinds of event but is also nice to meet new ones. Anthony attended the conference and was a new aquaintance for many us but we hope to meet him again at future events.

 Matthew Geoghegan is a recent graduate of Maynooth University so it was a pleasure to hear him play one of his portfolio pieces *Nunc*. This piece contrasted unsettling electronic liquid-like sounds with forceful drum-like punctuations. It also has a nice angle that harked back to classic electronic works of the 1950s and 60s.

 It was great to have John ffitch in attendance at the conference but it was even better that he composed and played a new piece for us. This piece made extensive use of waveguide-synthesised flutes and its slow, steady, extended, ground-bass ostinato reached back to classical forms, yet this reference point was undercut through the use of clustering indeterminacy as if the line had become smeared and smudged. John's piece received a number of compliments from composers based at Maynooth.

 Anton Kholomiov's *Mother is Waiting* was a lush slow elegiac piece that exemplified the use of Csound with a slightly more conventional musical language. It showed the influence of Indian music in Anton's work.

 Wang Lichuan's piece *China* represented the piece that had travelled the furthest to appear at the conference (although Lichuan was unfortunately not able to accompany it). Its theme was also travel and trade, specifically the dissemination of chinaware from China to the rest of the world. This was reflected in the sound-world it defined that presented the sound of struck kitchenware - both real and synthesised. The composition of this piece used Csound as a plugin, both as a synthesiser and an effect, within a DAW (Cubase), providing a contrast to the more traditional approach in which all structuring work is carried out within Csound.

 Clemens von Reusner gave us a fascinating introduction to his piece *Definierte Lastbedingung* in which he employed which used specialised microphones to capture electromagnetic fields which were then used as source materials. In his programme note Clemens claimed claimed that this source material had no intrinsic musical quality but the final piece displayed obvious musicality while remaining true to its machine-like and industrial-sounding source. This 8-channel ambisonic work provided a very fitting conclusion to the first concert.

 The second concert showcased a number of pieces that made use live, performed elements but a numbet of pieces for fixed medium were also played. The first piece, briefly introduced by its composer Steven Yi, *Transit*, was already familiar to a number of Csounders since he posted the code on the Csound discussion list. Steven Yi's piece for fixed medium, 'Transit'. This was a short, Terry Riley inflected, piece which clearly showed Steven's interest in historical hardware synthesisers. The process of composition employed cycles of improvisation and the notating based on reflections upon the improvisations and this was clearly evident in the balance and timing of the piece. Of course it was great to have Steven in attendance at the conference and his contributions extended far beyond his piece and his paper.

![Creevey performing](images/MariaCreevey.JPG)

**Figure 13. Maria Creevey performs *String Fields* by Bill Alves.**

 Bill Alves piece *String Fields* for solo violin and electronics aluded to the influence of Indonesian gamelan in his music. This piece used increasingly stretched statements of a theme to create a kind of slowing canon. This piece's mechanisms was also based upon Bill's interest in just intonation and not just in how pitches were tuned but also in how proportions of time intervals were defined. It was wonderful that this performance could draw on the talents of Maynooth violinist Maria Creevey in collaborating on this piece and we were very pleased to have Bill in attendance. He was able to preface the performance of his piece with a technical description of its inner workings with much greater clarity than is possible here.

 Linda Antas's video piece *All That Glitters and Goes Bump in the Night* demonstrated how visuals could successfullly illuminate electronic sound by presenting visual materials that alternately suggested tumbling crystals and frenetic cellular activity. The piece's soundworld presented a coming together of extended piano technique, stretched metallic resonances and portentous drones. Linda was the only female composer or researcher at the conference - we hope for, and encourage, greater representation from female Csounders at future events.

 Shane Byrne'ss *Proprioception* offered something quite unique. This piece was performed through interpretations of Shane's movements that were translated via a Leap Motion Controller into control data for a Csound patch. Although Shane claims he is not a 'dancer', his deeper understanding of the patch he created clearly give him an enhanced ability to control this patch over that which a dancer might be able to achieve. This was a piece that explored darker, more threatening moods and its punctuating explosions grabbed the attention of all in the vacinity of Riverstown Hall.

 *ATT...* by Joachim Heintz was proposed by its composer as a short 'in absentia' greeting to the conference attendees. This was a piece that explored a more delicate and precise form of expression but in context felt refreshing and perfectly proportioned.

 After the interval we restarted with my own piece *Acoustic Capacitance* which is written for snare drum, cymbal and live electronics. For the electronic part, this piece uses convolution with impulse responses derived from the two live instruments to colour a range of synthetic excitation sounds. I was very pleased to be able to work with the perussionist Saul Rayson on this piece.

 Massimo Fragalà's piece for fixed medium *Voce3316* was entirely derived from a tiny source sample - a vical syllable - of less than 1/3 second in duration. The timbral variety contained within the piece belied this econony of source materials.

 As a complement to their workshop, Alex Hofmann and Bernt Isak Wærstad, treated us to an improvisation for saxophone, electric guitar and multiple COSMOs. Their performance explored an extensive pallette of sounds, from smooth washes of sound to shredded ostinati. An interesting contrast of approaches was in evidence in that Alex's playing (saxophone) made greater use of the instrument to supply gestural definition and affected electronic modulation mainly using foot-switches, whereas Bernt created gesture through parameter modulation upon looped samples of his guitar using the array of switches and knob on the COMSO.

 Massimo Avantaggiato's *Atlas of Uncertainty* for fixed medium, explored the world of inharmonic timbres and drew on sources such as bells chimes and tibetan singing bowls.

![Boulanger performing](images/CloningADinosaur.JPG)

**Figure 14. Dr. Richard Boulanger performs *Cloning a Dinosaur*.**

 The penultimate piece of this concert, *Cloning a Dinosaur* composed by Dr. Richard Boulanger, was a semi-improvised work created specially to commemorate Csound's 30th anniversary. 'Dinosaur' refers to the pieces drawing on Richard's own 1979 piece *Trapped in Convert* and 'Cloning' refers to how Csound has ensured its continued pre-eminence by reinventing and reimagining itself within new and emerging platforms. Dr. B's performance employed Csound on iPads by way of Boulanger Labs CsGrain and CsSpectral, and also within Eurorack modules in the form of Qu-Bit's Nebulae module. This piece had created some anticipation through the spectacle of Richard's impressive stage set-up and provided a great demonstration how Csound can break free from a computer or laptop.

 Our concert concluded with another demonstration of a unique approach to using Csound, this time with a live-coding improvisation by Hlödver Sigurdsson. Hlödver is an Icelandic Csounder currently based in Berlin, who is speahheading live coding practice with Csound. His performance projected his coding on a screen, overlaid upon abstract visuals.
## V. Conclusion


 The formal conference proceedings can be described in an article such as this but of course the many other things that join together the scheduled activities of a conference - the meals out, the coffee breaks, the discussions over breakfast, the over ambitious plans and commitments made after several pints of Guinness in the pub, all contribute with equal, and sometimes greater, importance to the proceedings.

![Attendees image](images/Carton.JPG)

**Figure 15. Conference attendees enjoying Maynooth's surroundings.*.**

 I must also give aknowledgement to the people who assisted in making this conference a success. I was partenered in organising the conference by Dr. Brian Carty, Dr. Victor Lazzarini and Rory Walsh. Additional support and efforts were made by Eugene Cherny and Steven Yi in setting up the conference website. We must thank the staff of the Music Department at Maynooth, in particular the head of department Professor Christopher Morris, Dr Gordon Delap and the administrative staff: Marie Breen, Doreen Bishop and Emily Cook. And without the unbeliveably efficient technical assistance of the department's technician, Paul Keegan, the conference with almost certainly not have been possible. Of course we greatly appreciate the wide variety and extremely high quality of submissions - both music and papers - to the conference by Csounders. A particular thank you to all those of you who made the effort of travelling, in some cases great distances and at great expense, to attend the conference.

 See you in Montevideo in 2017!
## References


[]][1] Ensemble U: Estonian contemporary music ensemble. [Online] Available: [http://uuu.ee/index_en.html](http://uuu.ee/index_en.html). [Accessed January 3, 2017].

[]][2] Processing - a software sketchbook for the visual arts [Online] Available: [https://processing.org/](https://processing.org/). [Accessed January 3, 2017].

[]][3] Tarmo Johannes, eClick - a free wireless click-track system for musicians. [Online] Available: [http://tarmoj.github.io/eclick/](http://tarmoj.github.io/eclick/). [Accessed January 3, 2017].

[]][4] Jamulus - software to enable musicians to perform real-time jam sessions over the internet [Online] Available: [http://llcon.sourceforge.net/](http://llcon.sourceforge.net/). [Accessed January 3, 2017].

[]][5] Music N, historical overview [Online] Available: [http://www.musicainformatica.org/topics/music-n.php](http://www.musicainformatica.org/topics/music-n.php). [Accessed January 5, 2017].

[]][6] Dr. Richard Boulanger (editor), "The Csound Book", MIT Press 2000.

[]][7] Ensemble InterContemporain [Online] Available: [http://www.ensembleinter.com/en/new-home-en.php/](http://www.ensembleinter.com/en/new-home-en.php/). [Accessed January 5, 2017].

[]][8] Barry Vercoe, Synthetic Performer [Online] Available: [http://www.musicainformatica.org/topics/synthetic-performer.php](http://www.musicainformatica.org/topics/synthetic-performer.php)). [Accessed January 5, 2017].

[]][9] Miller Puckette, MaxMSP [Online] Available: [https://en.wikipedia.org/wiki/Max_(software)](https://en.wikipedia.org/wiki/Max_(software)). [Accessed January 5, 2017].

[]][10] OLPC, One Laptop Per Child [Online] Available: [http://laptop.org/en/](http://laptop.org/en/). [Accessed January 5, 2017].

[]][11] Sound Training College [Online] Available: [https://soundtraining.com/](https://soundtraining.com/). [Accessed January 5, 2017].

[]][12] Antares Audio Technologies: Auto-Tune [Online] Available: [https://en.wikipedia.org/wiki/Auto-Tune/](https://en.wikipedia.org/wiki/Auto-Tune). [Accessed January 5, 2017].

[]][13] TC Helicon: VoiceLive II [Online] Available: [https://en.wikipedia.org/wiki/Auto-Tune/](https://en.wikipedia.org/wiki/Auto-Tune). [Accessed January 5, 2017].

[]][14] Barry Vercoe at al.: The Csound Reference Manual [Online] Available: [http://csound.github.io/docs/manual/ptrack.html/](http://csound.github.io/docs/manual/ptrack.html). [Accessed January 5, 2017].

[]][15] Steven Yi: Blue: a composition environment for Csound [Online] Available: [http://blue.kunstmusik.com//](http://blue.kunstmusik.com/). [Accessed January 5, 2017].
## Biography


![image](images/Iain.jpg) Iain McCurdy is a composer from Belfast, currently lecturing in music at Maynooth University. His work has covered the areas of acousmatic, electroacoustic, instrumental, sound installation and cross-disciplinary works involving all four. His work with Csound has focussed upon the creation of demonstrations of the software's capabilities, and more recent work has capitalised upon the Csound frontend, Cabbage. His work with sound installations and alternative controller design has drawn in exploration of electronics, sensors and instrument building.

 email: iainmccurdy AT gmail.com
