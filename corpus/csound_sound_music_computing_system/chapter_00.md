# Front Matter

Victor Lazzarini · Steven Yi
John ffitch · Joachim Heintz
Øyvind Brandtsegg · Iain McCurdy
Csound
A Sound and Music Computing System
Victor Lazzarini
Department of Music
National University of Ireland
Maynooth, Kildare
Ireland
Steven Yi
Department of Music
National University of Ireland
Maynooth, Kildare
Ireland
John fﬁtch
Department of Computer Science
University of Bath
Bath
UK
Joachim Heintz
Institut für Neue Musik
Hochschule für Musik, Theater und
Medien Hannover
Hannover
Germany
Øyvind Brandtsegg
Department of Music
Norwegian University of Science
and Technology
Trondheim
Norway
Iain McCurdy
Berlin
Germany
ISBN 978-3-319-45368-2
ISBN 978-3-319-45370-5
(eBook)
DOI 10.1007/978-3-319-45370-5
Library of Congress Control Number: 2016953291
© Springer International Publishing Switzerland 2016
This work is subject to copyright. All rights are reserved by the Publisher, whether the whole or part
of the material is concerned, speciﬁcally the rights of translation, reprinting, reuse of illustrations,
recitation, broadcasting, reproduction on microﬁlms or in any other physical way, and transmission
or information storage and retrieval, electronic adaptation, computer software, or by similar or dissimilar
methodology now known or hereafter developed.
The use of general descriptive names, registered names, trademarks, service marks, etc. in this
publication does not imply, even in the absence of a speciﬁc statement, that such names are exempt from
the relevant protective laws and regulations and therefore free for general use.
The publisher, the authors and the editors are safe to assume that the advice and information in this
book are believed to be true and accurate at the date of publication. Neither the publisher nor the
authors or the editors give a warranty, express or implied, with respect to the material contained herein or
for any errors or omissions that may have been made.
Printed on acid-free paper
This Springer imprint is published by Springer Nature
The registered company address is: Gewerbestrasse 11, 6330 Cham, Switzerland
The registered company is Springer International Publishing AG
Foreword
Csound – A Sound and Music Computing System: this book should be a great asset
for all of those who wish to take advantage of the power of computers in the ﬁeld of
sound and music.
I was myself extremely fortunate to be among the ﬁrst to take advantage of two
ancestors of the Csound software, namely MUSIC IV and MUSIC V, the early pro-
grams designed by Max Mathews in the 1960s. Thanks to these programs, I could
effectively participate in early explorations of sound synthesis for music. This has
shaped all my activity in electroacoustic music and mixed music. Csound retains the
advantages of MUSIC IV and MUSIC V and adds new possibilities taking advan-
tage of the progress in computer technology and in sonic and musical research.
Today, Csound is in my opinion the most powerful and general program for sound
synthesis and processing. Moreover, it is likely to endure, since it is maintained
and developed by a team of competent and dedicated persons. The authors of this
book are part of this team: they are talented software experts but also composers or
sound designers. The book reviews the programs which culminated in the present
Csound, and it explains in full detail the recent features. It can thus serve as both an
introduction to Csound and a handbook for all its classic and novel resources.
In this foreword, I would like to present some historical recollections of the early
days of computer sound synthesis: they may shed light on the developments that
resulted in the Csound software and on the raison d’ˆetre of its speciﬁc features.
The ﬁrst digital recording and the ﬁrst computer sound synthesis were accom-
plished in 1957 at Bell Laboratories by Max Mathews and his colleagues. Mathews
decided to harness the computer to calculate directly the successive samples of a
sound wave, instead of sampling recordings of sounds produced by acoustic vi-
brations: he wrote the ﬁrst program for computer music synthesis, called MUSIC
I, and his colleague Newman Guttman realised In The Silver Scale, a 17-second
monophonic computer music piece ... which sounded simplistic and unappealing.
This was a disappointing start: Mathews knew that he had to write more power-
ful programs. Thus came MUSIC II, with four-voice polyphony. MUSIC II intro-
duced an ingenious new design for a software oscillator that could generate periodic
waves by looking up a wavetable with different increments, thus yielding different
vii
viii
Foreword
frequencies. This process saved a lot of computing time, and it was applicable to a
huge variety of waveshapes. With this version of the program, Guttman realised a
1-minute piece called Pitch Study. Even though the music was still rudimentary, it
had some intriguing features. Edgard Var`ese was intrigued by the advent of digital
synthesis: he hoped it would afford the composer more musical control than the ana-
log devices of electronic music. On April 26, 1959, Var`ese decided to present Pitch
Study to the public in a carte blanche he gave at the Village Gate in New York City,
as a sort of manifesto encouraging the continuation of the development of computer
sound synthesis at Bell Laboratories.
Clearly, programming permits us to synthesise sounds in many different ways:
but Mathews realised that he would have to spend his life writing different pro-
grams to implement musical ideas and fulﬁll the desires of various composers. So
he undertook to design a really ﬂexible program, as general as possible – a music
compiler, that is, a program that could generate a multiplicity of different music
programs.
To attain ﬂexibility, Mathews resorted to the concept of modularity. By selecting
from among a collection of modules and connecting them in various ways, one can
implement a large number of possibilities, as in construction sets such as Meccano
or Lego.
The modular approach is at work in human languages, in which a small number
of basic elements – the phonemes – are articulated into words and phrases, allow-
ing an immense variety of utterances from a limited elementary repertoire. In fact,
the idea of a system articulated from a small number of distinct, discontinuous ele-
ments – discrete in the mathematical sense – had been clearly expressed in the early
nineteenth-century by Wilhelm von Humboldt, linguist and brother of the celebrated
explorer Alexander von Humboldt. Similarly, chemistry showed that all substances
can in principle be synthesised from fewer than one hundred chemical elements,
each of them formed of a single type of atoms. Biology also gives rise to an incred-
ible diversity of animals and plants: the common living building blocks of life have
only been identiﬁed in the last ﬁfty years.
In 1959, Mathews wrote MUSIC III, a compiler implementing a modular ap-
proach for the computation of sound waveforms. Users of MUSIC III could per-
form different kinds of sound synthesis: they had to make their own choice among a
repertoire of available modules, called unit generators, each of which corresponded
to an elementary function of sound production or transformation (oscillator, random
number generator, adder, multiplier, ﬁlter ...). A user then assembled the chosen
modules at will to deﬁne instruments, as if he or she were patching a modular syn-
thesiser. However, contrary to common belief, Mathews’ modular conception did
not copy that of synthesisers: on the contrary, it inspired the analog devices built
by Moog, Buchla, or Ketoff using voltage control, which only appeared after 1964,
while MUSIC III was written in 1959. In fact, Mathews’ modular concept has inﬂu-
enced most of the synthesis programs – the next versions MUSIC IV and MUSIC V,
but also MUSIC 10, MUSIC 360, MUSIC 11, Cmusic, Csound – and also most ana-
log or digital synthesisers – such as Arp, DX7, 4A, 4B, 4C, 4X, SYTER, compilers
for physical modeling such as CORDIS-ANIMA, Genesis, Mimesis, Modalys, and
Foreword
ix
real-time programs such as MaxMSP and Pure Data, much used today and more
widely ﬂow-based and object-oriented programming used in languages for elec-
tronic circuit simulation or computing software such as MATLAB.
The music compilers introduced by Mathews are software toolboxes. The mod-
ules that the user selects and connects are virtual: they correspond to portions of
program code. Connections are stipulated by a declarative text that must follow con-
ventions speciﬁc to the program. It is more meaningful to represent the connections
in terms of a diagram, hence the name of block diagram compilers. In MUSIC III
and in many later programs, instruments must be activated by note statements which
specify the parameters left variable, such as starting time, duration, amplitude and
pitch. The analogy to traditional instruments is suggestive. It may appear to follow a
neo-classical approach: but synthesised notes may last 1 millisecond or 10 minutes,
and each one may sound like a chord of several tones or fuse with other notes into a
single tone.
In the 1970s, Barry Vercoe wrote MUSIC 11, an efﬁcient synthesis program for
the PDP11. Then Csound came around 1986. The advent of the Csound software
written by Barry Vercoe was a major step. C, developed at Bell Laboratories, is a
high-level language, hence easily readable, but it can also control speciﬁc features
of a computer processor. In particular, the UNIX operating system – the ancestor of
Linux – was written in C. Compositional subroutines can be written in C. Csound is
an heir of MUSIC IV rather than MUSIC V: the unit generators transmit their output
sample by sample, which makes it easier to combine them.
With MUSIC IV, MUSIC V, and Csound, synthesis can envision building prac-
tically any kind of sonic structure, providing if needed additional modules to im-
plement processes not foreseen earlier. These music programs draw on a wide pro-
gramming potential, and they put at the disposal of the user a variety of tools for
virtual sound creation. Compositional control can thus be expanded to the level of
the sonic microstructure: beyond composing with ready-made sounds, the musician
can compose the sounds themselves.
The issues migrate from hardware to software, from technology to knowledge
and know-how. The difﬁculty is no longer the construction of the tools, but their
effective use, which must take into account not only the imperatives of the musical
purpose, but also the characteristics of perception. So there is a need to develop
the understanding of hearing. One cannot synthesise a sound by just stipulating
the desired effect: synthesis requires the description of all its physical parameters,
so one should beware of the auditory effect of a physical structure. The musical
purpose is the prerogative of the user, but he or she must in any case take perception
into account.
Since the beginning of synthesis, the exploration of musical sound with synthe-
sis programs such as MUSIC IV, MUSIC V, and Csound has contributed substantial
scientiﬁc advances in hearing processes, leading to a better understanding of the
perception of musical sound. The physical structure of a synthetic sound is known
by construction – the data specifying the synthesis parameters provide a complete
structural representation of that sound. Listening to a synthetic sound allows eval-
uation of the relation between the physical structure and the auditory effect. The
x
Foreword
experience of computer sound synthesis showed that this so-called psychoacoustic
relation between cause and effect, between objective structure and auditory sensa-
tion, is much more complex that was initially believed.
Exploring synthesis of musical tones showed that prescribed relations between
certain physical parameters do not always translate into similar – isomorphic – re-
lations between the corresponding perceptual attributes. For instance, the perceived
pitch of periodic tones is correlated to the physical frequency: however Roger Shep-
ard could synthesise twelve tones ascending a chromatic scale that seem to go up
endlessly when they are repeated. I myself generated glissandi going down the scale
but ending higher in pitch than where they started. I also synthesised tones that seem
to go down in pitch when one doubles their frequencies. These paradoxes might be
called illusory effects, errors of the sense of hearing: but what matters in music is the
auditory effect. John Chowning has taken advantage of the idiosyncrasies of spatial
hearing to create striking illusory motions of sound sources, a great contribution
to kinetic music. He has proposed the expression sensory esthetics for a new ﬁeld
of musical inquiry relating to the quest for perceived musicality, including natural-
ness, exempliﬁed by his simulations of the singing voice. Chowning has analysed
by synthesis the capacity of the ear to sort two instrument tones in unison: while the
ear fuses coherent vibrations, programming slightly different modulations for such
tones makes their vibrations incoherent. This insight can be used to control synthe-
sis so as to make speciﬁc sounds emerge from a sonic magma, which Chowning
demonstrated in his work Phon´e.
As Marc Battier wrote in 1992, the use of the software toolboxes such as MUSIC
IV, MUSIC V, and Csound has favoured the development of an economy of ex-
changes regarding sonic know-how. In 1967, Chowning visited Bell Labs to discuss
his early experiments on the use of frequency modulation (FM) for sound synthesis,
and he communicated his synthesis data. I was impressed by the ease of replicating
FM tones, and I took advantage of Chowning’s recipes in my 1969 work Muta-
tions. That same year 1969, Chowning organised one of the ﬁrst computer music
courses in Stanford, and he invited Mathews to teach the use of MUSIC V. Mathews
asked me whether I could pass him some of my synthesis research that he could
present. I hastily assembled some examples which I thought could be of interest,
and I gave Max a document which I called An introductory catalogue of computer
synthesized sounds [108]. For each sound example, the catalogue provides the MU-
SIC V score specifying the parameters of the desired sound (in effect an operational
recipe), the audio recording of the sound (initially on an enclosed vinyl disc), and
an explanation of the purpose and details. This document was widely diffused by
Bell Labs, and it was reprinted without changes in Wergo’s The Historical CD of
Digital Sound Synthesis (1995). In 1973, Chowning published his milestone paper
on FM synthesis, including the synthesis recipe for a number of interesting FM
tones. In 2000, Richard Boulanger edited The Csound Book, comprising tutorials
and examples. Together with Victor Lazzarini, in 2011, Boulanger edited The Audio
Programming Book, with the aim to expand the community of audio developers and
stretch the possibilities of the existing programs. Clearly, block diagram compilers
such as MUSIC V, Cmusic, and Csound considerably helped this cooperative effort
Foreword
xi
of exploring and increasing the possibilities of computer sound synthesis and pro-
cessing. The dissemination of know-how provides cues that help users to build their
own virtual tools for sound creation with these software toolboxes.
The robustness and precision of structured synthesis programs such as Csound
favour musical work survival and reconstitution. In the 1980s, Antonio de Sousa
Dias converted several examples from my MUSIC V Catalogue into Csound. From
the computer score and with some help from the composer, two milestone works by
John Chowning have recently been reconstituted, which made it possible to refresh
the sound quality by replicating their synthesis with modern conversion hardware:
Stria, independently by Kevin Dahan and Olivier Baudouin, and Turenas by Laurent
Pottier, who transcribed it for four players playing digital percussion live.
In the late 1970s, for one of the ﬁrst composer courses at IRCAM, Denis Lorrain
wrote an analysis of my work Inharmonique for soprano and computer-synthesised
sounds, realized in 1977. Lorrain’s IRCAM report (26/80) included the MUSIC
V recipes of the important passages, in particular bell-like sounds that were later
turned into ﬂuid textures by simply changing the shape of an amplitude enve-
lope. More than 10 years later, with the help of Antonio de Sousa Dias and Daniel
Arﬁb, I could generate such sounds in real-time with the real-time-oriented program
MaxMSP discussed below.
MUSIC IV, MUSIC V, Cmusic, and Csound were not initially designed for real-
time operation. For many years, real-time synthesis and processing of sounds were
too demanding for digital computers. Laptops are now fast enough to make real-
time synthesis practical. Real-time performance seems vital to music, but the act of
composition requires us to be freed from real-time. One may say that MUSIC IV,
MUSIC V, Cmusic, and Csound are composition-oriented rather than performance-
oriented.
This might seem a limitation: but real-time operation also has limitations and
problems. In the early 1980s, the preoccupation with real-time became dominant
for a while. IRCAM claimed that their digital process 4X, then in progress, would
make non-real time obsolete, but the 4X soon became technically obsolete, so that
most works realised with this processor can only be heard today as recordings.
Real-time demands make it hard to ensure the sustainability of the music. Boulez’s
work R´epons, emblematic of IRCAM, was kept alive after the 4X was no longer
operational, but only thanks to man-years of work by dedicated specialists. Noth-
ing is left of Balz Trumpy’s Wellenspiele real-time version (1978 Donaueschingen),
whereas Harvey’s Mortuos Plango (1980), mostly realised with MUSIC V, remains
as a prominent work of that period.
The obsolescence of the technology should not make musical works ephemeral.
In the 1980s, the Yamaha DX7 synthesiser was very promising – it was based on
timbal know-how developed by Chowning and his collaborators, it was well docu-
mented, and it could be programmed to some extent. In 1986 at CCRMA, Stanford,
Chowning and David Bristow organised a course to teach composers to program
their own sounds on the DX7, but Yamaha soon stopped production to replace the
DX7 with completely different models. In contradistinction, Csound remains – it
xii
Foreword
can now emulate the DX7 as well as other synthesisers or Fender Rhodes electric
pianos.
A more recent piece of modular software, MaxMSP, designed by Miller Puckette,
is a powerful resource for musical performance: indeed it was a milestone for real-
time operation. However it is not easy to generate a prescribed score with it. Also,
even though it does not require special hardware, real-time oriented software tends
to be more fragile and unstable. Csound is precise and efﬁcient, and it can deal with
performance in several ways without enslaving the user with the constraints of real-
time. It has developed compatibility with the popular and useful MIDI protocol. The
Csound library can complement other programs: for instance, Csound can be used
as a powerful MaxMSP object. The control and interaction possibilities have been
much expanded, and the book explains them in due detail.
It should be made clear that Csound is not limited to synthesis. In the late 1960s,
Mathews incorporated in the design of MUSIC V modules that could introduce
sampled sounds regardless of their origin: arbitrary sounds could then be digitally
processed by block diagram compilers. In GRM, the Paris birthplace of musique
concr`ete, Benedict Mailliard and Yann Geslin wrote in the early 1980s the so-called
Studio 123 software to perform sound processing operations, many of which inter-
nally used unit generators from MUSIC V. This software was used to produce works
such as Franc¸ois Bayle’s Erosphere and my own piece Sud, in which I intimately
combined synthetic and acoustic sound material in an effort to marry electronic
music and musique concr`ete; it was a model for the GRM Tools plug-ins. Csound
has incorporated and extended sound processing capabilities in the framework of a
well-organised and documented logic.
Block diagram compilers therefore supported new ways of thinking for writ-
ing music, and they provided means for composing sounds beyond the traditional
graphic notation of notes and durations, in ways that can unfurl with the help of
speciﬁc programs. Certainly, the artistic responsibility for a musical work rests with
the composer’s own commitment to present his or her sonic result as a piece of mu-
sic, but the extension of the musical territory has been a collective endeavour of a
dedicated community. Csound has grown with this extension, it is now available on
several platforms, and it can be augmented by the individual composers and tailored
to their needs and their desires.
In my view, Csound is the most powerful software for modular sound synthesis
and processing: Csound – A Sound and Music Computing System is a timely pub-
lication. The book is rightly dedicated to Richard Boulanger, whose indefatigable
activity has made Csound the most accomplished development of block diagram
compilers. It is also indebted to Max Mathews’ generosity and genius of design,
and to Barry Vercoe’s exigencies for high-level musical software. Last but not least,
it owes much to all the contributions of the authors, who are talented as sound de-
signers, developers and musicians.
Marseille, December 2015
Jean-Claude Risset
Preface
This book is the culmination of many years of work and development. At the Csound
Conference in Hannover, 2011, there was a general agreement among the commu-
nity that a new book on the many new features of the language was a necessity. For
one reason or another, the opportunity of putting together an edited collection of
chapters covering different aspects of the software never materialised. As Csound
5 gave way to Csound 6, and the system started expanding into various platforms,
mobile, web, and embedded, the need for a publication centred on the system itself
became even more evident. This book aims to ﬁll this space, building on the already
rich literature in Computer Music, and adding to previous efforts, which covered
earlier versions of Csound in good detail.
A major aspect of this book is that it was written by a combination of system de-
velopers/maintainers, Lazzarini, Yi and fﬁtch, and power users/developers, Brandt-
segg, Heintz and McCurdy, who together have a deep knowledge of the internal and
external aspects of Csound. All the major elements of the system are covered in
breadth and detail. This book is intended for both novice and advanced users of the
system, as well as developers, composers, researchers, sound designers, and digi-
tal artists, who have an interest in computer music software and its applications. In
particular, it can be used wholly or in sections, by students and lecturers in music
technology programmes.
To ensure its longevity and continued relevance, the book does not cover plat-
form and host-speciﬁc issues. In particular, it does not dedicate space to showing
how to download and install the software, or how to use a particular feature of a
currently existing graphical frontend. As Csound is a programming library that can
be embedded in a variety of ways, there are numerous programs employing it, some
of which might not be as long-lasting as others. Wherever relevant and appropri-
ate, we will be considering the terminal (command-line interface) frontend, which
is the only host that is guaranteed to always be present in a Csound installation. In
any case, the operation topics left out of this book are duly covered in many online
resources (more details below), which are in fact the most appropriate vehicles for
them.
xiii
xiv
Preface
The book is organised in ﬁve parts: Introduction; Language; Interaction; Instru-
ment Development; and Composition Case Studies. The two chapters in the In-
troduction are designed to give some context to the reader. The ﬁrst one localises
Csound in the history of Computer Music, discussing in some detail a number of its
predecessors, and introducing some principles that will be used throughout the book.
This is followed by a chapter covering key elements of computer music software,
as applied to Csound. As it navigates through these, it moves from general consid-
erations to more speciﬁc ones that are central to the operation of the system. It con-
cludes with an overview of the Csound application programming interface (API),
which is an important aspect of the system for software development. However, the
focus of this work is ﬁrmly centred on the system itself, rather than embedding or
application programming. The next parts of the book delve deeper into the details
of using the software as a sound and music computing system.
The second part is dedicated to the Csound language. It aims to be a concise
guide to programming, covering basic and advanced elements, in an up-to-date way.
It begins with a chapter that covers the ground level of the language, at the end
of which the reader should have a good grasp of how to code simple instruments,
and use the system to make music. It moves on to discuss advanced data types,
which have been introduced in the later versions of the system, and provide new
functionality to the language. Core issues of programming, such as branching and
loops, as well as scheduling and recursion are covered in the third chapter. This is
followed by an overview of instrument graphs and connections. The ﬁfth chapter
explores the concept of user-deﬁned opcodes, and how these can be used to extend
the language.
The topic of control and interaction is covered in the third part of the book.
The ﬁrst chapter looks at the standard numeric score, and discusses the various
types of functionality that it offers to users. The reader is then guided through the
MIDI implementation in Csound, which is both simple to use, and very ﬂexible and
powerful. The facilities for network control, via the Open Sound Control protocol
and other means, is the topic of the third chapter in this part. A chapter covering
scripting with a separate general-purpose programming language complements this
part. In this, we explore the possibilities of using Python externally, via the Csound
API, to control and interact with the system.
The fourth part of this book explores speciﬁc topics in instrument development.
We look at various types of classic synthesis techniques in its ﬁrst chapter, from
subtractive to distortion and additive methods. The following one examines key
time-domain processing elements, studying ﬁxed and variable delay lines and their
applications, different types of ﬁltering, and sound localisation. The third chapter
introduces sound transformation techniques in the frequency domain, which are a
particularly powerful feature of Csound. The more recent areas of granular synthesis
and physical models are featured in the two remaining chapters of this part.
The ﬁnal section of the book is dedicated to composition applications. An in-
teresting aspect of almost all of the developers and contributors to Csound is that
they are composers. Although the system has applications that go beyond the usual
electronic music composition uses, there is always signiﬁcant interest from old and
Preface
xv
new users in its potential as a music composition tool. The six chapters in this sec-
tion explore the authors’ individual approaches to using the software in this context.
These case studies allow us to have a glimpse of the wide variety of uses that the
system can have.
All the code used as examples in this book is freely available for downloading,
pulling, and forking from the Csound GitHub site (http://csound.github.io), where
readers will also ﬁnd the latest versions of the software sources, links to the release
packages for various platforms, the Csound Reference Manual, and many other re-
sources. In particular, we would like to mention the Csound FLOSS Manual, which
is a community effort led by two of the authors of this book, covering a number
of practical and platform/frontend-speciﬁc aspects of Csound operation that are be-
yond the scope of this book. The Csound Journal, a periodic online publication
co-edited by another one of the book authors, is also an excellent resource, with
articles tackling different elements of the system.
It is also important to mention here that the essential companion to this book,
and to the use of Csound, is the Reference Manual. It is maintained to contain a
complete documentation of all aspects of the system, in a concise, but also precise,
manner. It is important for all users to get acquainted with its layout, and how to ﬁnd
the required information in it. The manual represents a triumph of the collaborative
effort of the Csound community, and it contains a wealth of knowledge about the
system that is quite remarkable.
The development and maintenance of Csound has been led by a small team of
people, including three of the book authors, plus Michael Gogins, who made numer-
ous contributions and has kept the Windows platform versions up to date in a very
diligent way, and Andr´es Cabrera, who also authored a widely used cross-platform
IDE for Csound (CsoundQt). As Free software, Csound is fully open for users to
play with it, fork it, copy it and of course, add to it. Over its thirty-odd years of ex-
istence, it has beneﬁtted from contributions by developers spread all over the world,
too many to be listed here (but duly acknowledged in the source code and manual).
At some point, users will realise that Csound can crash. It should not, but it
does. The developers are always looking out for ﬂaws, bugs and unprotected areas
of the system. We have minimised the occurrence of segmentation faults, but as a
programming system that is very ﬂexible and produces ‘real’, compiled, working
programs, it is vulnerable to these. No matter how closely we look at the system,
there will always be the chance of some small opportunity for perverse code to be
used, which will bring the system down. The development team has introduced a
number of safeguards and a very thorough testing program to keep the software
well maintained, bug free, and defended from misuse.
An important part of this is the issue tracking system, which is at present handled
by the GitHub project. This is a very useful tool for us to keep an eye on problems
that have arisen, and the user community is our ﬁrst line of defence, using and
pushing the software to its limits. Reporting bugs, and also asking for features to be
implemented, is a good way to help strengthen Csound for all users. The developers
work to a reasonably tight schedule, trying to address the issues as they are reported.
Once these are ﬁxed, the new code is made available in the develop branch of the
xvi
Preface
source code revision system (git). They become part of the following software
release, which happens quite regularly (three or four times yearly).
We hope that the present book is a helpful introduction to the system for new
users, and a valuable companion to the ones already acquainted with it.
Maynooth, Rochester, Bath,
Victor Lazzarini
Hannover, Trondheim, and Berlin
Steven Yi
December 2015
John fﬁtch
Joachim Heintz
Øyvind Brandtsegg
Iain McCurdy
Acknowledgements
We would like to thank all contributors to the Csound software and its documenta-
tion, from developers to users, and educators. Firstly, we should acknowledge the
work of Barry Vercoe and his team at the Machine Listening Group, MIT Media
Lab, who brought out and shared the early versions of the software. The availability
of its source code for FTP download was fundamental to its fantastic growth and
development in the three decades that followed.
We are also deeply indebted to Michael Gogins, for many a year a leading ﬁgure
in the community, one of the main system maintainers, a user and a composer, whose
contributions to the system are wide ranging. In fact, he has been single-handedly
carrying out the task of keeping the Windows platform version up to date, a some-
times arduous task as the operating system programming support diverges from the
more commonly shared tools of the *NIX world. Likewise, we would like to thank
Andr´es Cabrera for his work on several aspects of the system, and for developing a
very good cross-platform IDE, which has allowed many command-line-shy people
to approach Csound programming more conﬁdently. We should also acknowledge
the many contributions of Istvan Varga and Anthony Kozar to the early development
of version 5, and of Maurizio Umberto Puxeddu, Gabriel Maldonado and Matt In-
galls to version 4. Third-party frontend developers Rory Walsh and Stefano Bonetti
also deserve recognition for their great work.
A special note of gratitude should also go to a number of power users world-wide,
who have kept pushing the boundaries of the system. Particularly, we would like to
thank Tarmo Johannes, Menno Knevel, Ben Hackbarth, Anders Gennell, Jan-Jacob
Hofmann, Tito Latini, Jim Aikin, Aurelius Prochazka, Dave Seidel, Dave Phillips,
Michael Rhoades, Russell Pinkston, Art Hunkins, Jim Hearon, Olivier Baudoin,
Richard Van Bemmelen, Franc¸ois Pinot, Jacques Deplat, St´ephane Rollandin, Ed
Costello, Brian Carty, Alex Hofmann, Gleb Rogozinsky, Peiman Khosravi, Richard
Dobson, Toshihiro Kita, Anton Kholomiov, and Luis Jure. They, and many others
through the years, have been instrumental in helping us shape the new versions of
the system, and improving its functionality.
We would also like to thank Oscar Pablo de Liscia for reading and commenting
on the ATS sections of the text, which has helped us to clarify and explain its mech-
xvii
xviii
Acknowledgements
anisms to the reader. We would like to express our gratitude to Jean-Claude Risset
for his inspirational work, and for providing a wonderful preface to this book.
Finally, we should acknowledge the essential part that Richard Boulanger has
played as a computer musician and educator. Arguably, this book and the system
that it describes would not have been here if it were not for his inﬂuential work
at the Berklee College of Music, and also world wide, taking his knowledge and
experience to a wide audience of composers, sound designers and developers. The
authors, and indeed, the Csound community, are very grateful and honoured to have
had your help in establishing this system as one of the premier Free computer music
software projects in the world.
Contents
Part I Introduction
1
Music Programming Systems . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
3
1.1
Introduction . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
3
1.2
Early Music Programming Languages . . . . . . . . . . . . . . . . . . . . . . . . .
4
1.2.1
MUSIC IV. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
5
1.2.2
MUSIC V . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
7
1.2.3
MUSIC 360 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
9
1.2.4
MUSIC 11 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 11
1.3
Csound . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 12
1.3.1
Csound 5 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 14
1.3.2
Csound 6 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 14
1.3.3
Compatibility and Preservation . . . . . . . . . . . . . . . . . . . . . . . . . 15
1.4
Conclusions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 16
2
Key System Concepts . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 17
2.1
Introduction . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 17
2.2
General Principles of Operation. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 18
2.2.1
CSD Text Files . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 18
2.2.2
Using the Numeric Score. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 19
2.2.3
Csound Options . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 20
2.3
Frontends . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 20
2.3.1
The csound Command . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 21
2.3.2
Console messages. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 22
2.4
Audio Computation, the Sampling Theorem, and Quantisation . . . . . 23
2.4.1
Aliasing . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 24
2.4.2
Quantisation Precision . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 25
2.4.3
Audio Channels . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 26
2.5
Control Rate, ksmps and Vectors . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 27
2.6
Instruments, Instances, and Events . . . . . . . . . . . . . . . . . . . . . . . . . . . . 29
2.6.1
The Life Cycle of an Instrument . . . . . . . . . . . . . . . . . . . . . . . . 31
xix
xx
Contents
2.6.2
Global Code . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 33
2.7
Function Tables . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 33
2.7.1
GEN Routines . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 33
2.7.2
Normalisation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 34
2.7.3
Precision . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 34
2.7.4
Guard Point . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 35
2.7.5
Table types . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 35
2.8
Audio Input and Output . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 35
2.8.1
Audio Buffers . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 36
2.8.2
The Audio IO Layers . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 36
2.8.3
Real-Time Audio . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 38
2.8.4
Ofﬂine Audio . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 41
2.9
Csound Utilities . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 41
2.10 Environment Variables . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 43
2.10.1 Conﬁguration File . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 43
2.11 The Csound API . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 44
2.11.1 A Simple Example . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 44
2.11.2 Levels of Functionality . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 46
2.12 Conclusions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 49
Part II The Language
3
Fundamentals . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 53
3.1
Introduction . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 53
3.2
Instruments. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 54
3.2.1
Statements . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 54
3.2.2
Expressions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 55
3.2.3
Comments . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 56
3.2.4
Initialisation Pass . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 56
3.2.5
Performance Time . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 56
3.2.6
Parameters . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 58
3.2.7
Global Space Code . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 58
3.3
Data Types and Variables . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 59
3.3.1
Init-Time Variables . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 59
3.3.2
Control-Rate Variables. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 61
3.3.3
Audio-Rate Variables . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 62
3.3.4
Global Variables . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 64
3.4
Opcodes . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 65
3.4.1
Structure . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 65
3.4.2
Syntax . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 66
3.4.3
Functions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 67
3.4.4
Initialisation and Performance . . . . . . . . . . . . . . . . . . . . . . . . . 67
3.5
Fundamental Opcodes. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 69
3.5.1
Input and Output. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 69
3.5.2
Oscillators . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 69
Contents
xxi
3.5.3
Table Generators. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 73
3.5.4
Table Access . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 75
3.5.5
Reading Soundﬁles. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 77
3.5.6
Pitch and Amplitude Converters . . . . . . . . . . . . . . . . . . . . . . . . 78
3.5.7
Envelope Generators . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 80
3.5.8
Randomness . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 82
3.6
The Orchestra Preprocessor . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 86
3.7
Conclusions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 89
4
Advanced Data Types. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 91
4.1
Introduction . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 91
4.2
Strings . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 91
4.2.1
Usage . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 92
4.3
Spectral-Domain Signals . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 94
4.3.1
f-sig Variables . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 94
4.3.2
w-sig Variables . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 96
4.4
Arrays . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 97
4.4.1
Initialisation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 97
4.4.2
Setting Values . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 98
4.4.3
Reading Values . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 99
4.4.4
Performance Time . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 99
4.4.5
String and f-sig Arrays. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 100
4.4.6
Arithmetic Expressions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 100
4.4.7
Arrays and Function tables . . . . . . . . . . . . . . . . . . . . . . . . . . . . 101
4.4.8
Audio Arrays . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 102
4.5
Conclusions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 103
5
Control of Flow and Scheduling . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 105
5.1
Introduction . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 105
5.2
Program Flow Control . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 105
5.2.1
Conditions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 106
5.2.2
Branching . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 106
5.2.3
Loops . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 111
5.3
Scheduling . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 114
5.3.1
Performance-Time Event Generation . . . . . . . . . . . . . . . . . . . . 115
5.3.2
Recursion . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 116
5.3.3
MIDI Notes . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 117
5.3.4
Duration Control. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 117
5.3.5
Ties . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 118
5.4
Reinitialisation. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 120
5.5
Compilation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 122
5.6
Conclusions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 123
xxii
Contents
6
Signal Graphs and Busses . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 125
6.1
Introduction . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 125
6.2
Signal Graphs . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 126
6.3
Execution Order . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 127
6.3.1
Instances . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 128
6.3.2
Instruments . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 128
6.4
Busses . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 129
6.4.1
Global Variables . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 129
6.4.2
Tables. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 131
6.4.3
Software Bus . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 134
6.5
Conclusions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 136
7
User-Deﬁned Opcodes . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 139
7.1
Introduction . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 139
7.2
Syntax . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 140
7.2.1
Arguments . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 140
7.3
Instrument State and Parameters . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 143
7.4
Local Control Rate . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 144
7.5
Recursion . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 147
7.6
Subinstruments . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 150
7.7
Conclusions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 151
Part III Interaction
8
The Numeric Score . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 155
8.1
Introduction . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 155
8.2
Basic Statements . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 156
8.3
Sections . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 158
8.4
Preprocessing . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 159
8.4.1
Carry . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 159
8.4.2
Tempo . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 160
8.4.3
Sort. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 160
8.4.4
Next-p and Previous-p . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 161
8.4.5
Ramping . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 161
8.4.6
Expressions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 161
8.4.7
Macros . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 162
8.4.8
Include . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 163
8.5
Repeated Execution and Loops . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 163
8.6
Performance Control . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 165
8.6.1
Extract . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 166
8.6.2
Orchestra Control of Score Playback . . . . . . . . . . . . . . . . . . . . 166
8.6.3
Real-Time Events . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 167
8.7
External Score Generators . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 167
8.8
Alternatives to the Numeric Score . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 169
8.9
Conclusions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 170
Contents
xxiii
9
MIDI Input and Output . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 171
9.1
Introduction . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 171
9.2
MIDI Messages . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 171
9.2.1
Channel Message Types. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 172
9.3
The Csound MIDI System . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 173
9.3.1
Input. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 173
9.3.2
Output . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 176
9.3.3
MIDI Backends . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 177
9.4
Conclusions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 178
10
Open Sound Control and Networking . . . . . . . . . . . . . . . . . . . . . . . . . . . . 181
10.1 Introduction . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 181
10.2 Open Sound Control . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 181
10.2.1 The OSC Protocol . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 182
10.2.2 Csound Implementation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 182
10.2.3 Inter-application Examples . . . . . . . . . . . . . . . . . . . . . . . . . . . . 185
10.3 Network Opcodes . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 191
10.4 Csound UDP Server . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 192
10.5 Conclusions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 193
11
Scripting Csound . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 195
11.1 Introduction . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 195
11.2 Csound API . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 195
11.3 Managing an Instance of Csound. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 196
11.3.1 Initialisation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 196
11.3.2 First Compilation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 197
11.3.3 Performing . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 198
11.3.4 Score Playback Control and Clean-up . . . . . . . . . . . . . . . . . . . 199
11.4 Sending Events . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 200
11.5 The Software Bus . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 200
11.5.1 Control Data . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 200
11.5.2 Audio Channels . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 201
11.6 Manipulating Tables . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 202
11.7 Compiling Orchestra Code . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 203
11.8 A Complete Example . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 203
11.9 Conclusions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 205
Part IV Instrument Development
12
Classic Synthesis . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 209
12.1 Introduction . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 209
12.1.1 Waveforms and Spectra . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 210
12.2 Source-Modiﬁer Methods. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 212
12.2.1 Sources . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 212
12.2.2 Modiﬁers . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 219
12.2.3 Design Example 1: Analogue Modelling . . . . . . . . . . . . . . . . . 223
xxiv
Contents
12.2.4 Design Example 2: Channel Vocoder . . . . . . . . . . . . . . . . . . . . 225
12.3 Distortion Synthesis Methods . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 228
12.3.1 Summation Formulae . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 228
12.3.2 Waveshaping . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 232
12.3.3 Frequency and Phase Modulation . . . . . . . . . . . . . . . . . . . . . . . 234
12.3.4 Phase-Aligned Formant Synthesis . . . . . . . . . . . . . . . . . . . . . . 239
12.3.5 Modiﬁed FM Synthesis . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 240
12.4 Additive Synthesis. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 243
12.4.1 A Tonewheel Organ Instrument . . . . . . . . . . . . . . . . . . . . . . . . 245
12.4.2 Synthesis by Analysis . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 249
12.5 Conclusions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 253
13
Time-Domain Processing. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 255
13.1 Introduction . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 255
13.2 Delay Lines . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 255
13.2.1 Feedback . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 258
13.2.2 All-Pass Filters . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 260
13.2.3 Reverb . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 262
13.2.4 Convolution. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 268
13.3 Variable Delays . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 270
13.3.1 Flanger. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 271
13.3.2 Chorus . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 273
13.3.3 Vibrato . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 274
13.3.4 Doppler . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 276
13.3.5 Pitch Shifter . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 278
13.4 Filters . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 280
13.4.1 Design Example: a Second-Order All-Pass Filter . . . . . . . . . . 280
13.4.2 Equalisation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 284
13.4.3 FIR Filters . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 285
13.4.4 Head-Related Transfer Functions . . . . . . . . . . . . . . . . . . . . . . . 289
13.5 Multichannel Spatial Audio . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 290
13.5.1 Ambisonics . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 290
13.5.2 Vector Base Amplitude Panning . . . . . . . . . . . . . . . . . . . . . . . . 293
13.6 Conclusions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 293
14
Spectral Processing . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 295
14.1 Introduction . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 295
14.2 Tools for Spectral Analysis and Synthesis . . . . . . . . . . . . . . . . . . . . . . 296
14.2.1 Fourier Transform . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 296
14.2.2 Fourier Series . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 297
14.2.3 Discrete Fourier Transform . . . . . . . . . . . . . . . . . . . . . . . . . . . . 298
14.3 Fast Convolution . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 302
14.4 The Phase Vocoder . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 306
14.4.1 Frequency Effects . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 311
14.4.2 Formant Extraction. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 312
Contents
xxv
14.4.3 Spectral Filters . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 314
14.4.4 Cross-synthesis and Morphing . . . . . . . . . . . . . . . . . . . . . . . . . 315
14.4.5 Timescaling . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 316
14.4.6 Spectral Delays . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 319
14.4.7 Miscellaneous Effects . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 321
14.5 Sinusoidal Modelling . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 321
14.5.1 Additive Synthesis . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 323
14.5.2 Residual Extraction . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 324
14.5.3 Transformation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 326
14.6 Analysis Transformation and Synthesis . . . . . . . . . . . . . . . . . . . . . . . . 326
14.6.1 The ATS Analysis. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 326
14.6.2 The ATS Analysis File Format . . . . . . . . . . . . . . . . . . . . . . . . . 328
14.6.3 Resynthesis of the Sinusoidal Part . . . . . . . . . . . . . . . . . . . . . . 329
14.6.4 Resynthesis of the Residual Part . . . . . . . . . . . . . . . . . . . . . . . . 332
14.6.5 Transformations . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 334
14.7 Conclusions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 336
15
Granular Synthesis . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 337
15.1 Introduction . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 337
15.1.1 Low Grain Rates, Long Grains . . . . . . . . . . . . . . . . . . . . . . . . . 338
15.1.2 High Grain Rates, Periodic Grain Clock . . . . . . . . . . . . . . . . . 340
15.1.3 Grain Clouds, Irregular Grain Clock . . . . . . . . . . . . . . . . . . . . 342
15.2 Granular Synthesis Versus Granular Effects Processing . . . . . . . . . . . 343
15.2.1 Grain Delay . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 344
15.2.2 Granular Reverb . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 348
15.3 Manipulation of Individual Grains . . . . . . . . . . . . . . . . . . . . . . . . . . . . 353
15.3.1 Channel Masks, Outputs and Spatialisation. . . . . . . . . . . . . . . 357
15.3.2 Waveform Mixing . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 360
15.4 Clock Synchronisation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 363
15.5 Amplitude Modulation and Granular Synthesis . . . . . . . . . . . . . . . . . . 368
15.6 Pitch Synchronous Granular Synthesis . . . . . . . . . . . . . . . . . . . . . . . . . 372
15.7 Morphing Between Classic Granular Synthesis Types . . . . . . . . . . . . 374
15.7.1 Glissons . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 374
15.7.2 Grainlets . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 375
15.7.3 Trainlets . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 375
15.7.4 Pulsars . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 376
15.7.5 Formant Synthesis . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 376
15.7.6 Morphing Between Types of Granular Synthesis . . . . . . . . . . 378
15.8 Conclusions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 384
16
Physical Models . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 385
16.1 Introduction . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 385
16.2 Waveguides . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 385
16.2.1 Simple Plucked String . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 386
16.2.2 Wind Instruments . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 390
xxvi
Contents
16.2.3 More Waveguide Ideas. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 394
16.3 Modal Models . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 395
16.4 Differential Equations and Finite Differences . . . . . . . . . . . . . . . . . . . 397
16.5 Physically Inspired Models . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 399
16.6 Other Approaches . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 399
16.6.1 Spring-Mass System . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 399
16.6.2 Scanned Synthesis . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 402
16.6.3 ... and More . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 405
16.7 Conclusions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 405
Part V Composition Case Studies
17
Iain McCurdy: Csound Haiku . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 409
17.1 Introduction . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 409
17.2 Groundwork . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 410
17.3 The Pieces . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 411
17.3.1 Haiku I . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 412
17.3.2 Haiku II . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 415
17.3.3 Haiku III . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 420
17.3.4 Haiku IV . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 423
17.3.5 Haiku V . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 426
17.3.6 Haiku VI . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 428
17.3.7 Haiku VII . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 431
17.3.8 Haiku VIII . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 435
17.3.9 Haiku IX . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 440
17.4 Conclusions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 442
18
Øyvind Brandtsegg: Feedback Piece. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 443
18.1 Introduction . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 443
18.2 Feedback-Processing Techniques . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 444
18.3 Coloring Effects . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 447
18.4 Hosting and Interfacing . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 450
18.5 Automation and Composed Form . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 450
18.6 Spatial and Performative Considerations . . . . . . . . . . . . . . . . . . . . . . . 451
19
Joachim Heintz: Knuth and Alma, Live Electronics with Spoken
Word . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 455
19.1 Introduction . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 455
19.2 Idea and Set-up . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 456
19.3 Knuth . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 456
19.3.1 Rhythm Analysis . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 457
19.3.2 Possibilities . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 458
19.4 Alma . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 460
19.4.1 Game of Times . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 460
19.4.2 Speech as Different-Sized Pieces of Sounding Matter . . . . . . 460
19.4.3 Bringing Back the Past: Four Modes . . . . . . . . . . . . . . . . . . . . 463
Contents
xxvii
19.4.4 Improvisation or Composition . . . . . . . . . . . . . . . . . . . . . . . . . 464
19.5 Conclusions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 468
20
John fﬁtch: Se’nnight . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 469
20.1 Introduction . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 469
20.2 H´enon Map and Torus Map . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 470
20.3 Genesis of Se’nnight . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 471
20.4 Instruments. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 472
20.5 Score Generation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 472
20.5.1 Score1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 472
20.5.2 Score2 and Score3 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 473
20.6 Start and End . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 474
20.7 Multichannel Delivery . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 474
20.8 Conclusions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 475
21
Steven Yi: Transit . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 477
21.1 Introduction . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 477
21.2 About Blue . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 478
21.3 Mixer, Effects and the Signal Graph . . . . . . . . . . . . . . . . . . . . . . . . . . . 478
21.4 Instruments. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 480
21.5 Improvisation and Sketching . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 483
21.6 Score . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 485
21.7 Conclusions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 486
22
Victor Lazzarini: Noctilucent Clouds . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 487
22.1 Introduction . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 487
22.2 The Basic Ingredients . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 488
22.2.1 Dynamic Spectral Delays . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 488
22.2.2 Variable Delay Processing . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 491
22.2.3 Feedback . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 492
22.3 Source Sounds . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 493
22.4 Large-Scale Structure . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 495
22.5 Post-production . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 496
22.5.1 Source Code Packaging . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 498
22.6 Conclusions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 498
References . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 501
Index . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 507
Acronyms
0dbfs
zero decibel full scale
ADC
Analogue-to-Digital Converter
ADSR
Attack-Decay-Sustain-Release
AIFF
Audio Interchange File Format
ALSA
Advanced Linux Sound Architecture
AM
Amplitude Modulation
API
Application Programming Interface
ATS
Analysis Transformation and Synthesis
bpm
beats per minute
CLI
Command-Line Interface
CODEC
Coder-Encoder
cps
cycles per second
DAC
Digital-to-Analogue Converter
DAW
Digital Audio Workstation
dB
Decibel
DFT
Discrete Fourier Transform
EMG
Electromyogram
FDN
Feedback Delay Network
FIR
Finite Impulse Response
FIFO
First In First Out
FLAC
Free Lossless Audio CODEC
FLTK
Fast Light Toolkit
FM
Frequency Modulation
FOF
Fonction D’Onde Formantique, formant wave function
FS
Fourier Series
FT
Fourier Transform
FFT
Fast Fourier Transform
GIL
Global Interpreter Lock
GPU
Graphic Programming Unit
GUI
Graphical User Interface
HRIR
Head-Related Impulse Response
xxix
xxx
Acronyms
HRTF
Head-Related Transfer Function
Hz
Hertz
IDE
Integrated Development Environment
IDFT
Inverse Discrete Fourier Transform
IFD
Instantaneous Frequency Distribution
IID
Inter-aural Intensity Difference
IIR
Inﬁnite Impulse Response
IO
Input-Output
IP
Internet Protocol
IR
Impulse Response
ITD
Inter-aural Time Delay
JNI
Java Native Interface
LADSPA
Linux Audio Simple Plugin Architecture
LFO
Low Frequency Oscillator
LTI
Linear Time-Invariant
MIDI
Musical Instrument Digital Interface
MIT
Massachusetts Institute of Technology
MTU
Maximum Transmission Unit
OSC
Open Sound Control
PAF
Phase-Aligned Formant
PM
Phase Modulation
PRN
Pseudo-random number
PV
Phase Vocoder
STFT
Short-Time Fourier Transform
TCP
Transport Control Protocol
UDO
User-Deﬁned Opcode
UDP
User Datagram Protocol
UG
Unit Generator
UI
User Interface
VBAP
Vector Base Amplitude Panning
VST
Virtual Studio Technology
Part I
Introduction
