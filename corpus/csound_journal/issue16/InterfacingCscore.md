---
source: Csound Journal
issue: 16
title: "Interfacing Cscore"
author: "several contemporary Csounders"
url: https://csoundjournal.com/issue16/InterfacingCscore.html
---

# Interfacing Cscore

**Author:** several contemporary Csounders
**Issue:** 16
**Source:** [Csound Journal](https://csoundjournal.com/issue16/InterfacingCscore.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 16](https://csoundjournal.com/index.html)
## Interfacing Cscore
 Jim Hearon
 j_hearon AT hotmail.com
## Introduction


This article describes an approach with accompanying code for the score preprocessor function of Cscore. A `main.c` and several other files are provided for compiling and linking with Csound. These files include code for entering and manipulating data prior to the preprocessor function, as well as saving score files, and performing those via Csound utilizing the Csound API. The approach of this article is to offer suggestions and possibilities for a "new" look at an older, possibly less utilized, Csound utility—Cscore.
##
 I. The Preprocessor


 Cscore is a utility application from the programming interface which manipulates and generates score files. Cscore normally takes a `scorefilein` and `scorefileout` as arguments. The Csound source code frontends folder contains examples of a simple main function as well as a controller function file, as a starting point, for compiling and linking with the Csound library which will create a standalone Cscore executable. The details of various Cscore functions which utilize Cscore events or event lists for the score file preprocessor controller function are listed in *The Canonical Csound Reference Manual* [[1]](https://csoundjournal.com/#ref1).

 In addition to compiling code as a Cscore standalone executable it is possible to create a unique version of Csound by coding a custom `cscore()` function, as part of Csound source code, and compiling that file with the larger body of Csound source code. The custom `cscore` function could then be invoked using the -C flag from the command line along with the csound command. For more information and instructions utilizing that approach, see [[1]](https://csoundjournal.com/#ref1).

 Cscore is categorized as a Csound utility, and the score in/score out method is consistent with other utilities—such as Scsort—that also utilize the same approach to processing score events. There are several references regarding the historical computer music approach to score files, but none clearly describe Csound's utility `scorefilein`, `scorefileout` approach to score files which perhaps derives from Music 360, and Music 11. Arfib and Kessous outline the use of PLF (play first) routines in Music V [[2]](https://csoundjournal.com/#ref2), and Loy and Abbot describe differences between Music IV and Music V in detail in [[3]](https://csoundjournal.com/#ref3). Both languages were early predecessors of Music 360 and Music 11 in the Music N family of computer music languages.

 The concept of `scorefilein` and `scorefileout`, or recycling existing score files to form new ones, using Cscore has been described and utilized by several contemporary Csounders. In his article, "Anything2Score, A guide For the Perplexed", Dave Phillips writes about the Cscore library as a score generator/masseuse[[4]](https://csoundjournal.com/#ref4). In *GeoMaestro, An environment for experimental musical composition with MIDI and Csound*, based on Tim Thompson's KeyKit, St�phane Rollandin writes about scores in GeoMaestro from events modified by distortion functions[[5]](https://csoundjournal.com/#ref5). Also Anthony Kozar has provided separate preprocessor example files in the Csound source code examples folder which generate scales, copy input scores a parallel fifth higher, and multiply durations by one-half (0.5)[[6]](https://csoundjournal.com/#ref6).
##
 II. C Programming


 The potential for interconnectivity to the preprocessor's structure of events or event lists is great if one is willing to work with the C programming language. Initially this project was begun in KDevelop, which no longer comes with a C compiler, but was abandoned in favor of Code::Blocks IDE which includes a good C compiler, an effective debugger and a good selection of tools. Fedora 14, and Csound 5.13 were also used for this article. You can download the code for this article, [preprocessor.c.zip](https://csoundjournal.com/preprocessor.c.zip), here.

 The C code included with this article utilizes only a few of the event pointers from the Cscore API. The functions shown simply create MIDI pitch numbers via random distributions and generate patterns of durations as rhythms for p-fields 2 and 3, as start time and duration. This is just one simple approach of many possible methods for computing data for use with Cscore.

 The code functions shown in the examples accompanying this article also utilize aspects of random distributions, but the approach here is not to develop an algorithmic composition environment, rather to simply demonstrate an approach to feeding the Cscore preprocessor on its on terms so to speak, using the C language.
##
 III. Why Cscore?


 The purpose of developing code to feed the score preprocessor was to generate sound files, first of all, which included rhythm and pitch content, and to do it in a code-driven manner from a command prompt without interference from computer graphics. In other words the generated score file drives the orchestra file to create waveforms of melodies, chords, bass lines, etc. all using Csound. It seemed the use of the venerable Cscore was well suited for that purpose, as it provides a means to access the power of Csound through the API of Cscore via a custom user-defined code-driven interface. Of course, there are many other very good helper applications for the generation of Csound scores (Cecilia for example), as well as graphical and controller interfaces, all of which serve the purpose of making creative content using Csound.
##
 IV. One-dimensional Arrays


 Several functions, employing random distributions were utilized to pass MIDI pitch numbers to a p-field 4 Cscore event pointer in the preprocessor custom `cscore.c` file. In this example `EVENT` is a structure from Csound which is assigned a pointer. The abbreviated code snippit below, shows a simple for loop with p4 event pointer reading MIDI pitch numbers from an array of integers.
```csound

      ...
      EVENT *j;
      int *s;

      for (n = 1; n< numspitches; n++)
      {
            ...
            j->p[4] = s[n];

      cscorePutEvent(cs,j);
      }
      ...

```


 Because Cscore event pointers (described in the Csound Manual) access data in a relatively straightforward manner, arrays of MIDI pitch numbers were utilized for entering numbers of pitches to be returned, where lowest value, highest value as a range, and random distributions select the number of pitches. Instead of utilizing Cscore event pointers to point to input data from an existing `inscore`, an array of original pitch data was passed to the custom Cscore preprocessor function and written as a Csound `outscore` file.

 The standalone approach to Cscore in the code accompanying this article has been expanded to include a larger main function, functions to generate pitches, functions to generate rhythms, and a custom `cscore.c` file—all which when compiled serve the purpose of an example of a standalone Cscore application.
##
 V. Two-dimensional Arrays


 Passing floating point values as rhythms to the custom Cscore preprocessor function requires more work than passing data to the p4 field for pitch shown above. In this case a `p3array` of floating point values of durations is passed as a parameter to the custom `cscore` function. Durations, p3, are shown in the code snippit below where the start time, p2, is the sum of the previous durations.
```csound

	...
      float sum = 0.0;
      float *t = p3array;

      for (n = 1; n< numspitches; n++)
      {
	...
            sum = sum + t[n-1];
            j->p[2] = sum;
            j->p[3] = t[n];
      cscorePutEvent(cs,j);
      }

```


 Recall, you can view the Csound source code examples folder to see many more creative examples of standalone Cscore preprocessor files. The main purpose of this article is to demonstrate simple code to feed the preprocessor. Thus the coding of distributions to generate an array of rhythms to feed the preprocessor required developing a particular strategy. The basic approach for rhythm was to return or "spin" a distribution of rhythm patterns from a number of patterns entered. In this way simple musical groups of patterns could be selected. This could also be viewed as a somewhat beat focused method of organizing rhythmic patterns.

 While multi-dimensional arrays, with page, row, and column could be employed to compute rhythmic patterns, in this case groups of rhythms such as two, three, and four rhythms, etc. were all viewed as two dimensional arrays only which however included two, three, or four columns depending upon the size of the grouping pattern. An example of rhythmic dyads (groups of two rhythms) is shown in the two-dimensional array chart below in Figure 1 with two-dimensional array index numbers and a floating point value which represents a rhythmic value (ex. 0.5 = eighth note, etc.).
```csound

for (j = 0; j<rows; j++)
    {
        for (k = 0; k<cols; k++)
        {
            scanf("%f",&inputarray [j][k]);
        }
    }

```


 ![](images/Cscore1.png) ** Figure 1. Rhythmic dyads in a two-dimensional array.**

 For spinning or distributing the patterns as array elements, aspects of an unrolled linked list seemed to offer the best data structure model as a starting point. A basic structure was created to hold the row, column, and struct number (see the pseudo code below), and an array of those structures was allocated to hold a particular index (rhythm) from the two-dimensional array from which distributions would be drawn, Figure 2.

 ![](images/Cscore2.png) ** Figure 2. An array of structures.**

 A basic structure holds one index from the two-dimensional array and has a `structnum` variable to keep track of the struct number.
```csound

#define ASTRUCT_MAXROWS 1
#define ASTRUCT_MAXCOLS 1

struct thestruct
{
    int structnum;
    int nrows;
    int ncols;
    float astruct[ASTRUCT_MAXROWS][ASTRUCT_MAXCOLS];
};

```
 The size of the array holding the structures was dynamically increased employing realloc, utilizing aspects of an unrolled linked list as a model data structure.
```csound

    ArrayofStructs = (struct thestruct *)calloc(1, sizeof(struct thestruct));

    h= inrows*incols;
    for (x=0; x<=h; x++)
    {
        ArrayStructs= (struct thestruct **)realloc(ArrayofStructs, (x + 1) * sizeof(struct thestruct *));
        ArrayofStructs[x] = (struct thestruct *)malloc(sizeof(struct thestruct));
    }

```
 Durations as rhythmic patterns were loaded into an array of structures, and a counter variable `y` provided an array element number for the structure.
```csound

    y=1;
    for (j = 0; j<inrows; j++)
    {
        for (k = 0; k<incols; k++)
        {
            Arrayof2dStructs[x]->a2dstruct[0][0] = inputarray[j][k];
            Arrayof2dStructs[y]->structnum = y;
            y++;
        }
    }

```


 Not described here is the method for the selection and distribution of the groups of rhythmic patterns of two, three, four values, etc.. Those interested may see the accompanying code for more details.
##
 Conclusion


 While the code accompanying this article is a very simple effort in generating data to feed a custom Cscore preprocessor, the potential exists for much more development in terms of your own ideas. Not every creative Csound project requires intensive score files; but when called upon, Cscore is a venerable utility which can provide added potential for score generation. It would also be useful if Cscore source code were available in an alternate, wrapped C++ version, opening the way for ease of interface applications by employing C++ compilers, and allowing the use of the Boost Random library. However it should be noted that GSL (GNU Scientific Library) uses the C programming language and has random generators and distributions. It has been a long time since Csound utilities were significantly upgraded, still there exists much opportunity for creativity and production using those tools, hopefully shown somewhat in this article.
## References


[][1]]Barry Vercoe et Al. 2005. *The Canonical Csound Reference Manual*. [Online]. Available: [http://www.csounds.com/manual/html/index.html](http://www.csounds.com/manual/html/index.html). [Accessed December 7, 2011].

[][2]]Daniel Arfib and Loïc Kessous, *From "Music V" to "Creative Gestures in computer music"*. [Online] Available: http://muse.jhu.edu/journals/computer_music_journal/summary/v035/35.2.agon.html. [Accessed December 16, 2011].

[][3]]Gareth Loy and Curtis Abbott, *Programming Languages for Computer Music synthesis, Performance, and Composition*. [Online] Available for purchase: http://dl.acm.org/citation.cfm?doid=4468.4485. [Accessed December 17, 2011].

[][4]] Dave Phillips, "Anything2Score, A Guide For The Perplexed," *Csound Magazine,* Spring 1999. [Online]. Available: http://www.csounds.com/ezine/spring1999/score2/index.html. [Accessed: September 16, 2011].

[][5]] Stéphane Rollandin, "The CScore array," *GeoMaestro, An environment for experimental musical composition with MIDI and Csound*, 2002. [Online]. Available: http://www.zogotounga.net/GM/GMcsound.html#CScore.[ Accessed September 16, 2011].

 [][6]] Barry Vercoe, John ffitch et AL, *Csound.* [Downloadable]. Boston, MA: Free Sofware Foundation, Inc.,1991-2008.


### Additional Resources


 Alessandro Cipriani and Riccardo Bianchini, "Generating and Modifying Scores with General Purpose Programming Languages," in *Virtual Sound,* Riccardo Bianchini, Rome: ConTempo s.a.s., 2000, pp-361-368.

 John ffitch, "A Look at Random Numbers, Noise, and Chaos with Csound," in *The Csound Book,* Richard Boulanger,Ed. Cambridge, Mass: The MIT Press, 2000, pp-321-338.

 Denis Lorrain, "A Panoply of Stochastic Canons," *Computer Music Journal,* Vol. 4, No. 1 (Spring, 1980), pp. 53-81.[Online .pdf]. Available: http://www.jstor.org/stable/3679442. [Accessed: 15/09/2008].

 F. Richard Moore, *Elements of Computer Music.* Englewood Cliffs, New Jersey: Prentice Hall, 1990.
