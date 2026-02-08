---
source: Csound Journal
issue: 5
title: "Thoughts and Experiences with The Flyndre: An Interview with &Oslash;yvind Brandstegg"
author: "telling us"
url: https://csoundjournal.com/issue5/interviewOeyvindBrandtsegg.html
---

# Thoughts and Experiences with The Flyndre: An Interview with &Oslash;yvind Brandstegg

**Author:** telling us
**Issue:** 5
**Source:** [Csound Journal](https://csoundjournal.com/issue5/interviewOeyvindBrandtsegg.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 5](https://csoundjournal.com/index.html)
## Thoughts and Experiences with The Flyndre

### An Interview with Øyvind Brandtsegg
 Steven Yi
 stevenyi AT gmail.com  **SY: Hi Øyvind! Thank you very much for taking the time to do this interview regarding your new installation "Flyndre". Before we begin on the installation, could you start off by telling us a little bit about yourself?**

 ØB: I'm a Norwegian musician/composer/programmer. I have no formal education in programming, but have picked up what I know about programming on the basis of musical needs as I went along. I started out as a drummer in rock bands in the 1980's, and this has probably formed my musical preferences to great extent. In the 90's, I wanted to study music at the jazz department of the Conservatory in Trondheim (now NTNU). I switched to vibraphone for the jazz studies, as I figured my drumming style was somewhat heavy for jazz. I soon realized that the vibraphone did not in itself provide sonic variation enough for what I wanted musically. I wanted to have some rougher sounds at my disposal in addition to the niceness of the vibraphone sound. I started to use electronics to process the vibe, along the same lines a guitarist would do to an electric guitar. In 1994 I started using midi triggers on the vibe, using hardware synthesizers and samplers as sound sources. I soon realized that I had not time to physically push buttons on the synthesizer (e.g. to change patches or to use modulation controller) while playing the vibe with two mallets in each hand. I started looking into using sensors for physical gesture control. I tried a lot of different gear, and ended up using a combination of infrared distance sensors and EMG sensors measuring muscle strain. I had a lot of help from the Trondheim based company Soundscape Studios in finding the right equipment. I started using the software MAX to process the signals from the sensors, and also to do some algorithmic composition/automation. My setup at that time (1995 to 1997) consisted of acoustic vibes with piezo pickups for audio and MIDI, MAX on a Mac laptop, a Korg Wavestation, and a Roland sampler. I implemented my first improvisation-processing MAX patches in 1997, testing out the interplay between my improvising and the computer as a counterpart musician. Then I discovered Csound, sometime around 1996.

 I realized that the computers I could afford would not provide the necessary CPU power to be used in realtime performance for audio synthesis, but I anticipated that the computers would be fast enough by the time I had learned how to use Csound. In 1998 I started using Csound as my main audio synthesis engine for live performances, on a 40kg heavy rack mount computer. In the beginning I had to back it up with a hardware sampler to allow the necessary polyphony. I still used MAX for control purposes on a Mac, running Csound on a PC platform.

 After a while I grew impatient with what I experienced as instabilities with MAX, and at the same time my Mac laptop was damaged beyond repair on a tour. I reimplemented my MAX control routines in Csound, and have used Csound exclusively ever since. In 2000 I got a commission for a work for Choir and electronics, and I saw the chance to use that commission to develop a live sampler for improvised work. This is what later became ImproSculpt. Since then, I've been researching the interplay between improvised performance and computer processing, trying to develop a responsive machine-musician that can both follow my improvisation and provide musical challenges that influence the way I play by requiring me to react to the machine's output.

 I've currently exchanged the vibraphone for a Marimba Lumina, and exchanged the rack mount computer for a laptop, bringing down my total weight of personal luggage from 160kg to a mere 30-40 kg. Hehe, life has indeed become easier in that respect.


 **SY: Could you tell us about where you are now and what you are working on?**

ØB: Since 2004, I've worked in a research position hosted by NTNU, allowing me to further investigate the use of computers to implement a compositionally enabled instrument for improvised performance. By compositionally enabled, I mean that some composition techniques are implemented in the instrument, allowing for some automation of the intellectual or mathematical aspects of composition, while using the improvised input as raw material for the compositional processes in realtime. My research position is an equivalent to a PhD, but it is based more firmly on artistic research, relaxing the formal academic aspects of a traditional PhD.



 **SY: The work on "compositional techniques implemented in the instrument" seems that it is heading towards a live manipulation of compositional algorithms in the same way that one performs with acoustic instruments, in that there would be a similar development of intuition and familiarity with working with the compositional techniques as one develops within the parameter space of performing on a physical instrument. Would you say this is where you are heading or is it less deterministic than that?**

ØB: I would say this is exactly what I try to do. Intuition and familiarity are important aspects of improvised performance, and my main goal is to extend the vocabulary for (my) improvisation by incorporating compositional strategies and techniques.

 I find that a lot of fellow improviser musicians are reluctant to thinking in terms of a musically based intellectual construct, but most of them start to think of it as a refreshing approach once they get more familiar with the sound of it. Take serial techniques for example, strictly used, they provide rigid rules for the development of the music. But the interesting point for an improviser is that the serial technique lends a certain "sonic imprint" that is pretty robust to improvised modifications of the original series. Maybe I'm being too abstract or fuzzy about my explanation, but what I intend to describe is that one can hear the "sonic taste" of a serially developed motif, even if the rules are relaxed somewhat. I tend to think about this in the same way that harmony and melody is treated in traditional jazz improvisations. When a musician starts to learn about jazz improvisation and harmony, there are pretty strict rules about what notes can be played on what chords. As one learns more, each and every rule can be bent and changed to the extent that a skilled performer never thinks about rules and most certainly violates them. A tasteful violation of rules is part of what is considered a personal style in any kind of performance.

 I want the instrument to be as deterministic as possible, giving the exact same response to the same stimuli each and every time. That said, as with acoustic instruments, I look for a complex interplay of subtle nuances in stimuli leading to a rich palette of potential for expression. The rules governing the instrument's response to various stimuli can be complex, and a performer will need to practice to gain control of the instrument. It might seem to the inexperienced player that the instrument behaves in non-deterministic ways. But this is the same as one would experience when learning to play an acoustic instrument.




 **AK: Can you offer any tips to other computer music composers who might be interested in going the same route?**

FW: I would say try to find performers who are open minded and interested in trying different things. And maybe most of all, performers who want to make a piece their own - they are the people who will find things in your music that you didn't know were there!

On a practical note, it's also important that you make your music not only do-able, but something that people might actually become involved in trying to do. For example, most performers I know are not terrifically interested in playing pieces where they have to coordinate with super-precision, down to the half-second, with a tape part. Its not something that comes naturally, and although a great performer will be able to do it, he or she will not be able to help feeling somewhat resistant; whereas if you build in flexibility, you allow the performer room to move, to be creative, and to feel.



 **SY: Regarding your new installation work "Flyndre", how much does your work regarding improvisation play a part? I know that Flyndre uses environmental data as data sources rather than human interaction. Do you view the sources of information as very different when you are working?**

ØB: Actually, I view the sources of information as similar. The environmental data are used in place of human input. This might seem strange, because the success of the human interaction with the instrument relies heavily on the musical abilities of the human, and the environmental data does not possess any musical knowledge whatsoever. I do take care in planning what parameters the environmental data should be able to control, and as such I view the data mapping as a large part of the compositional work with an installation. The musical knowledge is built into the instrument as part of the data mapping.



 **SY: Taking a step back, could you tell us a little bit about Flyndre? (What motivated the project, how did it develop, challenges of such a large project)**

ØB: The Flyndre is a sound installation situated in Inderøy, Norway. It is based upon an existing aluminium sculpture by Nils Aas. The music for the sound installation is in constant evolution during the exhibition period of 10 years, affected by environmental data (light, temperature, tide, moon phase etc). Most of the technical equipment is placed in Trondheim, some two hours away from the physical installation site, streaming sensor and audio signals between the two sites. The reason for putting the equipment in Trondheim is practical, to avoid having to put a computer in an outside environment in a public park. Also, a nice side effect of this setup is that we can stream the audio from the installation to the webpage for the project.

 In 2003, I had been working on another large sound installation in collaboration with the Norwegian composer Christian Eggen. This was situated in a public park (Vigelandsparken) in Oslo. There are a lot of sculptures by Gustav Vigeland in that park, but we did not make any of the sound installations relate to the sculptures. I kind of like the idea of placing a sound installation in a public space, where it can be experienced more "as is" than what would be the case if it is placed in a museum or gallery space. This is because the expectations of the viewer/audience are different in this context. Also, in a public park, there are other sounds that merge with the sounds from the installation, and I like the idea that the audience can be unsure if some of the sounds come from the environment or the installation.

 I also view sound installation as one way to regain the "original" of a work, in these times when digital copying is so common and music recordings have somewhat lost the status of an original object. The audio track for a sound installation can of course be copied, but the full work is only ever present at the physical installation site.

 At the same time, in 2003, I started looking more closely at the Flyndre sculpture by Nils Aas. The sculpture was made by Aas in 2000 and it is situated in Inderøy, some two hours north of Trondheim. The Flyndre sculpture is made of aluminium bands, almost like a scaled-up version of a wire frame sculpture. The aluminium in the sculpture is resonant, and tapping on different parts of the sculpture makes a variety of sounds and resonances. Through Soundscape Studios in Trondheim, I had become aware of the NXT flat panel speaker technique. This is based on using a small exciter element to transfer audio as vibrations into an object, making the object into a loudspeaker. The original idea for the Flyndre sound installation was inspired by this simple combination of a speaker technique and a resonating object (the sculpture). I contacted Nils Aas to discuss the project with him, and he was very enthusiastic about me bringing another dimension into his work. Sadly, Nils died in 2004 and never got to hear the installation.

 An early challenge in the project was raising money. In hindsight, it seems to me like one of the most important parts in raising the money was expressing the artistic ideas in writing, in such a way that bureaucrats would "get the point" and be interested in contributing to the project. I always find it hard to express artistic ideas in writing, because the concepts involved may be somewhat abstract and in any case audio is my preferred way of expressing the ideas, not text. I had a lot of help from my producer Kulturbyrået Mesén; they really helped me focus my ideas into a written project description.

 Another interesting aspect of the Flyndre project is the large number of contributors, as 35 to 40 people have been directly involved in the making of the sound installation. Sensor design, computer programming, financing, electricity cabling, equipment housing (outdoors), internet connections, audio streaming solutions, web design, these are just examples of the tasks that other people have done for me. It would take too long to give a detailed list here, but there's some more information on the web page www.flyndresang.no. Without all the help, I would not have been able to complete the project, and at the same time, it has been quite a new experience for me trying to coordinate the efforts of so many people.



 **SY: That is really quite a large group of people to coordinate! It’s really amazing what went into putting together this installation. Would you describe some of the challenges you found in working on such a large project?**

ØB: In general, there were challenges related to managing deadlines for different parts of the project that relied on each other, e.g. getting the network connections in Inderøy ready at the same time as the systems in Trondheim to be able to test the network connections and so on. I find that in all projects like this, even if you have a budget, you will rely on the favours and goodwill of people involved. You oftentimes have to ask people to do a little more than what they are paid to do, and still do it on time. Working on a long timescale (the Flyndre project took 3 years from conception to opening) does not necessarily help, because most people tend to postpone a task until the last minute anyway. This is probably just the result of everyone having a crowded time schedule, but I realized it might be wise to set deadlines with this in mind…

 Bug fixing my software has been a challenge in this project, as the software runs on university servers and the hardware is locked inside server rooms. Installation and configuration has to be done remotely via network, and in the event that my software crashes the computer, I have to call someone to physically lock themselves into the server room and hard reboot. One should think that this was not frequently necessary, but the software has behaved quite differently on a server than on my laptop, giving rise to a generous amount of hard reboots being necessary ;-) One of the most frequent issues has been related to threading in Python, and the server has proved to be much more sensitive to these issues than my laptop.

 When working at night, I could not call the service staff for the university computers in case something went wrong. At times when I needed to do a soft reboot of the server via remote connection, it felt somewhat like a scene out of a sci-fi movie. I’m thinking of scenes where the spacecraft is going into radio shadow for several minutes while circling the far side of a planet. When issuing a reboot from a remote connection, there’s not much you can do if the machine for some reason should have problems booting. And the only thing you can look at is the “not connected” message blinking while the machine reboots. I guess this might be an everyday situation for server techs, but for me it was unnerving enough when programming at night during the last phase of the project.

 The composition of a piece of music with duration of 10 years has been a conceptual challenge for me. Trying to get a firm grip on the large time span has been interesting indeed. Even if the music is algorithmic, and a lot of variations are modulated via the parameter inputs, it still requires quite an extensive library of material for the software to create variations from. I've also wanted to create local variations creating a listening experience for the "one-time 2-minute listener", as well as creating long-term evolution.

 I won’t bore you with all the details about specific parameter mappings, but a few general points might be of interest. One of the input parameters used is the tidal water, because the Flyndre sculpture is situated by a tidal stream. This looks somewhat like a broad river, but every six hours, the water changes direction and start flowing the other way. I think of this as a huge low frequency oscillator. Water speed, flow direction and water level are used as derivative parameters from the movement of the tides. Also relating to the tides is the phases of the moon, and I’ve mapped it so that there’s a lot more dense activity in the composition at the time of full moon, and a more relaxed musical attitude at the time of new moon.

 During this project, I’ve built a completely new base for my software instrument ImproSculpt, starting from scratch. It is great fun writing compositional software and composing with it at the same time, as the interaction of the two processes can enrich both the composition and the programming. I guess you must have had similar experiences when working with Blue?


SY: Certainly!


ØB: At the same time, it is easy (for me) to get lost, spending days on implementing a tiny detail in software and losing track of the overall compositional goal.

 SY: Again, certainly! (*laughs*) I think it’s really easy for anyone who creates their own tools for music making to get lost working on them and not spending enough time working with them. [A wise piece of advice Michael Gogins told me very early on in my programming career.]

 Could you tell us a little bit more about how Csound was used in your project?

 ØB: I’ve used the Csound API with Python as a host. All the compositional logic, GUI, sensor interface and program control is implemented in Python, while Csound is used for the audio synthesis. I’ve had timing problems with Python, and one of my next tasks will be to implement a better sequencing timer. I will probably port all time critical functions to Csound, and rely on control rate timing. I plan on separating the application into at least three standalone programs, one each for GUI, logic, and audio synthesis. The three applications will then communicate via TCP.

 A lot of the Csound programming could be considered straightforward, with oscillators, sample playback, filters and effects. I’ve deliberately used some retro sounding instruments, for example mellotron samples and a fof voice formant synthesizer. One nice things about the formant synthesizer is that it actually sounds a lot like an analogue lead synth at times, while still retaining some of the modulation richness of vocal formants.

 A brand new opcode for granular synthesis have been used in this project. It is called “partikkel” and was written for me by acoustics students Thom Johansen and Torgeir Strand Henriksen. I got the idea for the opcode after reading Curtis Roads’ “Microsound”. I wanted to have one particle synthesizer capable of doing all variants of time based granular synthesis. The reason for having it all in one opcode is that it enables me to move gradually between different variants of the technique. It has become one monster of an opcode, with approximately 50 input parameters (still not settled on a final parameter configuration). It is not what you’d call easy to use, but the focus has been on maximum flexibility. One of the astonishing features of the partikkel opcode is that it allows separate control per grain over parameters like panning, effect sends, transposition, gain, FM, etc. I’ve written some mapping schemes for metaparameter control, allowing the control of a multi-voice particle cloud with only 5 or 6 parameters. Here I’m using metaparameters like “turbulence”, “transparency”, “vertical size”, “duration” and “width” while playing back a precomposed automation of some three-hundred-and-a-few separate parameters, allowing the metaparameters to modulate the automation.


 SY: Wow! It is great to hear that you have a really generic granular synthesis opcode and it sounds like it is possible to get a really wide variety of sound from it. Will you be publishing this opcode and mapping schemes?

 (Smiles) Of course I will. There are two reasons why this hasn’t been done already. One is that I’ve tried to come up with a good input parameter configuration for the opcode, to make it more accessible to other users. The other reason is that I need assistance from the students that helped me build this opcode in the first place, and it’s been hard for them to allocate enough time to the project now that they’re finished studying. But I keep pushing for this to happen sometime soon, and I also try to find money to pay them for their time spent. I would also like to write some examples or tutorials for the opcode to get other people started using it.


 SY: Now that you’ve finally finished this massive project, what are your plans now for your own work? Do you have more Flyndre-sized projects in mind?

 Well, there are actually a few more installation projects coming up. One that I’ve started working on is an installation for a local college. They’ve built a new central building for the school, connecting existing buildings. I’m working together with the Norwegian artist Viel Bjerkeset Andersen on this project. We will build several tree-like structures with aluminium tubes, relating to the paths of movement of people within the connected buildings of the school. For the audio part of the installation, I will be using the acoustic characteristics of the tubes as a basis. I will put a speaker in one end of such a tube, and a microphone in the other end, creating a feedback loop that enhances the resonant frequencies of the tube. I will write a Csound instrument that acts as a slow responding feedback eliminator. Hopefully this will create a sort of didjeridoo-ish organic ambient texture with evolving harmonic content. In addition I will use the particle opcode to distribute particles of the drone sound onto speakers mounted on the windows of some transit corridors connecting the various buildings.

 But, my main focus when looking forward is to take the software used in Flyndre and rework it for use in concerts. I would like to implement more compositional techniques, and there are also the challenges related to setting up intuitive ways of controlling a multi-parameter application in realtime. I’m using a very flexible hardware controller, the Marimba Lumina. I hope to set up some mapping schemes for it that allows the simultaneous control of composition algorithms while also using it to play melodies as a traditional midi controller.

 SY: Thank you very much Øyvind for sharing your thoughts and experiences with The Flyndre and Csound. I’m glad that you’ve taken the time out to discuss all of this and I am looking forward to experiencing more of your work and learning more from you in the future. Hopefully someday I’ll have a chance to visit Norway to experience this work live too! Thanks again!

 ØB: You’re welcome, and thanks for taking the time to do the interview.


### Related links

- Flyndre – [http://www.flyndresang.no](http://www.flyndresang.no)
- Øyvind Brandtsegg’s Homepage - [http://oeyvind.teks.no](http://oeyvind.teks.no)
- Soundscape Studios - [http://soundscape-studios.no/e_index.html](http://soundscape-studios.no/e_index.html)
- Kulturbyrået Mesén - [http://mesen.com/english/](http://mesen.com/english/)
