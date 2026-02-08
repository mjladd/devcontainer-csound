---
source: Csound Journal
issue: 18
title: "Interview with Jan Jacob Hofmann"
author: "the clearness of these thoughts"
url: https://csoundjournal.com/issue18/interview_jjh.html
---

# Interview with Jan Jacob Hofmann

**Author:** the clearness of these thoughts
**Issue:** 18
**Source:** [Csound Journal](https://csoundjournal.com/issue18/interview_jjh.html)

---

CSOUND JOURNAL[](https://csoundjournal.com/index.html) | [Issue 18](https://csoundjournal.com/index.html)
## Interview with Jan Jacob Hofmann
 Steven Yi
 stevenyi AT gmail.com

*This interview was conducted over email with Jan Jacob Hofmann. For more information and examples of his music, please go to his homepage at [http://www.sonicarchitecture.de](http://www.sonicarchitecture.de).*
## Interview


**SY: Hello Jan Jacob! I've long admired your work as a composer and have been looking forward to having an opportunity to interview you for the Journal. Could you tell us a little bit about yourself? **

JH: This question is perhaps the most difficult one right at the start. Obviously you are not just asking to tell things about my skills and education because else you would have asked precisely for that. So, I am afraid I just can not take that easy way out. It looks a bit like the question is rather a complex one...but I will give it a try.

I have always been interested in arts. I loved drawing at least since the age of four. I loved to draw the world around me, trying hard to depict what interested me as naturalistic as possible. Arts have been most intriguing to me since then. I started photographing with ambition when I was nine. Besides trying to reflect the world around me the desire grew more and more to search for a different, unknown, hidden alternative to the common. Music became an excellent guideline for that. I listened to late night Radio programmes featuring strange and experimental music when I was a teenager and became very excited about what was transmitted now and then. Laurie Anderson's "Oh Superman" was one of those, a radio programme about "Lautsprechermusik - Electroacoustic Music" was another one. Via radio I got in touch with music as a contemporary art form, while that aspect of music was totally neglected in my musical education at school or at home. There solely classical music was propagated. But that was music from the world, that already existed, and I was looking for something else, without knowing exactly what this could be.

On my 18th birthday I got an audio cassette from a friend of mine containing a sampler of "modern music". One of the pieces was "Orient - Occident" by Xenakis. I still have no idea why she gave that present to me as I did not talk at all about my musical interests at that time. Maybe just a coincidence. But that piece really struck me, I had the impression of understanding "every single word" of it. Since then I searched actively for electronic music, which was not easy at all as the record stores mostly sold mainstream. Still the radio stations in Germany did a good job in the late night programmes.

Another strong influence has been reading Kandinsky's "Über das Geistige in der Kunst". I must have been 19 or 20 years old when I came across it—a friend, a painter himself—had recomended it to me. I liked the idea that all arts are related on a perceptual level, that a colour may have its equivalent in a sound and the sound may have its equivalent in a shape. I remember reading the first pages in the train back from the library. I felt kind of elevated by the clearness of these thoughts. I also liked the idea that colour and shape have their own value and expression. And the idea of a possible convergence of arts in the future.

At sometime I began to wonder how music in the future would sound like. Or a music without rhythmic or any other repetitive patterns, melody and harmonic relations, music apart from conventions. I was looking for a music that grew its significance from the nature of an autonomous sound and the relation of sounds to each other. The wish began to grow to try that out.

At the same time I started to study architecture. I felt that this profession would be close enough to arts to satisfy me. I was also interested a lot in science, could have studied this too but was not too good at mathematics during school—so I became an architect. I liked the broad approach in which architecture was taught. I found that a variety of subjects were related to architecture, among them arts, philosophy, social studies... and music.

**SY: Thank you Jan Jacob for the beautiful answers! I think at first I had thought to ask just general background information, but I am so glad you shared these stories about your personal history. Could you discuss now your general approach to sound and music, perhaps explaining a bit about "Sonic Architecture"?**

I do still like the idea of sound as an autonomous object with its own nature. I do regard the timbre of a sound as most important. Several of these objects may relate to each other in time, adding complexity and creating significance at a larger scale. The sounds may interact with each other according their own, inherent rules. I do like a certain development, a process-like behavior of the sounds in time.

During my studies of architecture I kept experimenting with electronic sounds. Once I had a collaboration to make the sound for a performance. The artist wanted to have the music extremely loud; we had enourmous loudspeakers. Although it was just stereo there were strange spatial effects with the sound. It was so vivid, had shape and materiality, you could almost touch it.

This brought be to the idea that it could be rewarding to extend the sounds to three dimensions and thus merge it with architecture. The sound might change the space, like a moving installation of sculptured shapes would change it. The sound should also have a sort of materiality—sounding like some material, without referring necessarily to the yet known and possible materials.

This is still the way I do like to work with sounds. In opposite to most of the common architecture, changes and developments over time are part of the play. I found this "fourth dimension" very enriching. I do regard my pieces as changing sculptures in space. I am not sure, if they are more related to the realm of sound art or music. It could be called a choreography of sounds too.

**SY: It is very interesting to me to hear you talk about these ideas, as I've always felt these kinds of things in listening to your work, though I was unable to really explain in words what I was experiencing. I've also felt it difficult to put any specific label on your work, Could you describe how you use Csound in your work, perhaps also how your approach to Csound developed over time?**

JH: When I had my idea of expanding electronic music to three dimensions, I had a modular analog synthesizer and a four track tape recorder. Pretty soon it was clear, that I could not make these ideas work with that equipment. In the next minute it was clear, that there was not any existing equipment at all for what I was heading for. But a friend recommended me Csound for that task. I hoped, that it would be flexible and unlimited enough, so I bought my first computer and learned Csound. It took a while, more than a year, until I finished that chain of signal-processing units that spatialized my sounds by using 2nd order Ambisonics. Up to that point I had no idea if this task would have a chance to succeed at all. But I tried to make sure that at least the sound synthesis and processing programme I was going to learn would not set a limit to my task. Csound seemed the programme, where the chance of reaching any unforeseen limits seemed to be the smallest. Finally, at the end of the year 2000 I had my first spatial piece, "Tensile Elements".

At that time I used a spreadsheet for the score and a text editor for the orcestra. With that I generated the audio, which I then arranged using an audio editor to have a sort of graphical overview of the composition. I then mixed it down to several mono tracks to re-import it for spatialization into Csound. Sometimes I used Cmask for score generation, which made the workflow even more tedious. Often I had to go back to former states of production at the end because the spatialization changed amplitude and frequency relatively to distance and velocity, which did not make things easier to control. Rendering times were at least 10 hours, so every recursion took a long time.

In 2005 I met you at a demonstration on of your programme "Blue" at the Sounds Electric festival in Maynooth. I got a slight idea of what your programme was about and thought that this might be useful for my work too. I then totally changed my work flow of sound spatialisatiion and and am still in the process of optimization. But it has made my way of working enormously easier. I can now generate sounds and listen to the spatialized result almost at once, change parameters again by desire, I can generate CMask score within Blue and do the whole process of sound generation, composition and spatialisation within one programme. That is an enormous relief for me and it really facilitates the workflow enormously.

Also the possibilities have expanded. The former workflow limited me to 20 simultaneous channels of spatial sound sources. Now this limit does not exist any more which means that even spatial granular synthesis has become possible.

**SY: Perhaps this is a good time to ask further about the technical details of your approach to spatialisation. I know your system is quite featureful and as a result, I think it gives some of the best spatial experiences I have experienced in concert. Could you describe the various parts of the system, as well as what you mean by "spatial granular synthesis" and how that differs from the spatialization work you had done before?**

JH: Yes, giving each sound a direction is just a small part of what I do. In fact, Ambisonics just handles the direction of the sound but not the perception of distance of a virtual sound source. So I combined Ambisonic with several other clues of spatial perception for distance. But let us begin from the start:

First, a position of a sound has to be defined. I do this by creating a trajectory either in cartesian or polar coordinates. This trajectory may also be modified by periodic oscillations or random jitter so that the movement may become as complex and expressive as desired. This trajectory is then written into a zak-channel and sent to a sound-producing instrument, which is tied to that particular zak-channel that holds its location. As the sound is produced, it may be modified according to its distance and velocity. Usually, I do try to create a sonic environment as natural as possible. So the first thing I do is altering the frequency of the sound by doppler-effect. In most cases, this alteration is beyond conscious perception, however in some cases this becomes a component of the composition I have to deal with. So that is the simulation of movement then, along with the change of position of the sound archived by Ambisonic representation.

The simulation of distance however consists of several components. First the sound is altered according to its distance: the further a sound is away the more the high frequencies are damped and the amplitude is reduced. This corresponds to the natural filtering and attenuation of a sound in respect to its distance. Also the ratio of direct sound and reverberated sound changes and gives an important clue to distance.

Finally the first early reflections of a sound, both the specular and the diffuse ones, are simulated and positioned at their exact virtual positions in space via Ambisonics. These early reflections are equipped with distance clues themselves. The position and the quality of these early reflections change along with the movement of the sound. These early reflections have a rather subtle effect: they help to stabilize the image of the sound, making the impression clearer and less fatiguing to listen to.

The global reverb is also enhanced by Ambisonic spatialisation as reverberation from all directions is needed. Several decorrelated sources of reverberation are spread equidistant in space to make sure that the sound is placed into a natural impression of a reverberant space surrounding the listener.

So what I try to do is not to just to build a sound that has a specific location, but also build one that is embedded into a virtual sonic environment that corresponds to the position of the sound. Thus a vivid figure/ground relationship between sound and environment is achieved.

Actually, all I did was bring together several already known concepts of spatial representation and perception. Charles Dodge, Thomas A. Jerse and John Chowning were some of the developers, whose insights and publications I could incorporate well into my instruments of spatialisation. Also important for me was the work of David Griesinger regarding reverb and early reflections. Still I could not use all that 1:1 as I had to extend their ideas and formulas to 3d-space to make it work for me.

Extremely important for me has been also the personal exchange of ideas with Peter P. Lennox, now teaching at the University of Derby. He found the right words to describe patterns of sonic perception and encouraged me to refine my developments versus the creation of a whole sonic environment using early reflections.

Regarding "spatial granular synthesis" I might have to explain that the set of instruments described above allows the simultaneous spatialization of a limited number of sound sources - up to 20 at the same time, which was enough for the start. Still I find granular synthesis most intriguing and I was looking for a way to overcome this limit to be able to place an unlimited number of overlapping grains to different locations in space. So I reconfigured the organisation of my instruments in that way that a stream of grains may now be produced and controlled at some kind of meta-level while each grain now carries its own location and its own chain of signal processing instruments with it and finally adds up the result of this signal-processing into the common sonic environment. So before I could well spatialize a stream of gannular sound at one location and maybe another at a different one. Now we can place every single grain by desire in space. Thus clouds, swarm-like objects as well as sounding surfaces, shifted planes or broad areas with just certain densities and characteristics of sound become possible.

**SY: It is amazing to me the extent you have gone to with your spatialization system and that you are now applying it to even grains of sound. I remember well the experience of hearing "Hrafntinnusker" in concert and the results of your work were exceptional. Thank you very much Jan Jacob for your time to answer these questions. I certainly look forward to hearing more of your work in concert!**
