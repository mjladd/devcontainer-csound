# Chapter 22

Chapter 22
Victor Lazzarini: Noctilucent Clouds
Abstract This chapter presents a case study of a ﬁxed-media piece composed en-
tirely using Csound. It discusses the main ideas that motivated the work, and its
three basic ingredients: a non-standard spectral delay method; a classic algorithm
using time-varying delays; and feedback. The source sounds used for the piece are
discussed, as well as its overall structure. The case study is completed by looking at
how post-production aspects can be seamlessly integrated into the orchestra code.
22.1 Introduction
There are many ways to go about using Csound in ﬁxed-media electronic music
composition. An initial approach might be to create orchestras to generate speciﬁc
sounds, render them to soundﬁles and arrange, edit, mix and further process these
using a multi-track sequencer. This is often a good starting point for dipping our
toes in the water. However, very quickly, we will realise that Csound offers very
precise control over all the aspects of producing the ﬁnal work. Very soon we ﬁnd
ourselves ditching the multi-tracker and start coding the whole process in Csound.
One of the additional advantages of this is that the composition work is better doc-
umented, and the ﬁnal program becomes the equivalent to the traditional score: a
textual representation of the composition, which can be preserved for further use.
The path leading to this might start with a few separate sketches, which can be
collated as the work grows, and it can begin to take shape in various versions. Once
the complete draft of the piece is done, we can work on mastering and retouching
it to perfect the ﬁnal sound of the work. It is also important to note that the process
of composing can be quite chaotic, sometimes leading to messy code that creates
the right result for us, even though it might not use the most orthodox methods. It
is good to allow for some lucky coincidences and chance discoveries, which are at
times what gives a special touch to the composition.
My approach in composing Noctilucent Clouds followed this path, starting with
some unconnected sketches, and the exploration of particular processes. Some of
© Springer International Publishing Switzerland 2016
V. Lazzarini et al., Csound, DOI 10.1007/978-3-319-45370-5_22
487
488
22 Victor Lazzarini: Noctilucent Clouds
the experimentation with these ideas paid off, and the composition of the piece pro-
gressed following the most successful results. The overall shape and structure was
only arrived at later, once a good portion of the start had already been drafted. This
allowed me to grow it from the material, rather than impose it from the outside. Once
the piece was completely constructed, I went back to tame some of its excesses, to
give a well-rounded shape lacking in the raw instrument output.
22.2 The Basic Ingredients
The processes used in this piece can be grouped into three main methods: spectral
delays, variable time-domain delay effects and feedback. Although they are used
together, closely linked, it is possible to discuss their operation and function sep-
arately. This also allows us a glimpse of the sketching process that goes on in the
early stages of composition.
22.2.1 Dynamic Spectral Delays
The original idea for this piece came from discussions on the Csound e-mail list
on the topic of delays, and how these could be implemented at sub-band level (i.e.
independent frequency bands). I had written a pair of opcodes, pvsbuffer and
pvsbufread (discussed earlier in Chapter 14), that implemented a circular buffer
for phase vocoder (PV) data, and noted that these could be used to create spectral
signal delays. These are delay lines that are created in the frequency domain, acting
on speciﬁc sub-bands of the spectrum, applying different delay times to each. The
idea is simple: once a buffer is set up, we can have multiple readers at these different
bands in the spectrum.
A small number of these can be coded by hand, but if we are talking of a larger
number, it could be quite tedious to do. Also, we would like to be able to use a vari-
able number of bands, instead of ﬁxing these. In order to do this, we have to ﬁnd a
way of dynamically spawning the readers as required. This can be done recursively,
as shown in various examples in this book, or alternatively we can use a loop to
instantiate instruments containing the readers. This turns out to be simpler for this
application.
The reader instrument signals will have to be mixed together. This can be done
either in the time domain or in the spectral domain. The results are not exactly the
same, as the implementation of PV signal mixing accounts for masking effects, and
removes the softer parts of the spectrum. However, it is preferable to work in the
frequency domain to avoid having to take multiple inverse DFTs, one for each sub-
band. This way, we can have one single synthesis operation per channel.
To implement these ideas we can split the different components of the code into
four instruments:
22.2 The Basic Ingredients
489
