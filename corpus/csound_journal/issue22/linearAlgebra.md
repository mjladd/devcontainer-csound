---
source: Csound Journal
issue: 22
title: "Exploring The Linear Algebra Opcodes"
author: "Michael Gogins"
url: https://csoundjournal.com/issue22/linearAlgebra.html
---

# Exploring The Linear Algebra Opcodes

**Author:** Michael Gogins
**Issue:** 22
**Source:** [Csound Journal](https://csoundjournal.com/issue22/linearAlgebra.html)

---

CSOUND JOURNAL | [Issue 22](https://csoundjournal.com/index.html)
## Exploring The Linear Algebra Opcodes
 Jim Hearon
 j_hearon AT hotmail.com
## Introduction
 This article is about exploring the *Linear Algebra* *Opcodes*, implemented in Csound by Michael Gogins. These opcodes utilize the gmm++ package [[1]](https://csoundjournal.com/#ref1) and call several of those methods as Csound opcodes[[2]](https://csoundjournal.com/#ref2). While some of the capability of linear algebra exists in other opcodes, such as arrays, tables, and stacks, the *Linear Algebra* *Opcodes* also provide additional specific lower level vector and matrix functions such as conjugation, dot product, eigenvectors, etc.; all very useful for matrix composition. Hopefully this article will introduce some to these perhaps underutilized opcodes, and spark additional ideas for how they might be utilized creatively. Versions used for this article were Csound 6.07, and Fedora 23.
##  I. Linear Algebra


 Linear algebra can be computed via a number of different applications such as MatLab, Octave, Numpy, Eigen, gmm++, or GSL, to name but a few applications. Compiling and computing linear algebra within an application is instructive and powerful, but the integration of those methods into the world of Csound also provides some of that same capability directly to Csound users thru the use of opcodes.

 CsoundAC, CsoundVST, CsoundACPython and the compiled libCsoundAC all use Eigen while the *Linear Algebra Opcodes* employ gmm++ for linear algebra. In order to use the *Linear Algebra Opcodes* in Csound you will need to build a version of Csound that includes the *Linear Algebra Opcodes* by selecting the option to build them in CMake, and including the header files on your machine, which on Fedora, is the gmm-devel package. If the header files are not installed in a standard location, then you will also need to point CMake to your custom location. If successful with the build, typing the csound command with the `-z` flag (`./csound -z`) from your Csound build location should list all the opcodes and show you the *Linear Algebra Opcodes*, which for my machine lists 180 "la_ " opcodes. The large number of those opcodes is on account of the need to include a unique opcode to handle variations for init time, k-rate, real, or complex numbers for vectors and matrices, along with numerous additional functions such as getters and setters, printing, math functions, and type conversions.

Linear algebra, employing vector and matrix operations, is perhaps best suited to algorithmic composition. For example, CsoundAC[[3]](https://csoundjournal.com/#ref3), the Python extension module, includes several node classes such as Counterpoint.cpp, Cell.cpp, and Node.cpp etc., which utilize Eigen's[[4]](https://csoundjournal.com/#ref4) methods to aid in algorithmic composition. However this article, will focus mainly on gmm++, the *Linear Algebra Opcodes*, and signal processing as a means of exploring those opcodes.
## II. Standalone Applications


 To begin exploring linear algebra for signal processing, a standalone gmm++ example in cpp below shows the creation of a vector with an allocated initial size of eleven doubles. A simple `for` loop then places a trigonometric `sin` value of a sequence of numbers from 0 to 10 in the vector.
```csound
#define SIZE 10
#define N 11
int main()
{

std::vector V(N);

gmm::vect_size(0->N)
gmm::clear(V);

for (int s=0;s<SIZE;s++) {
    V[s] = sin(s);
    }
std::cout << " Vector V: "  << V << std::endl;
}
```


 This a good start mathematically, but additional musical information such as amplitude, number of samples, and frequency are needed for a more useful example. The code fragments from the example below, shows how we might create our own named sine function, passing it values for amplitude(A), number of samples (D), frequency (f), and period (i), then calling it from the `for` loop of our main function, sending the output to a file to create a vector of information more useful for musical applications. Several examples shown below are abbreviated or extracted from the complete code in order to save space and present only essential lines of code. You can download and view the complete examples shown in this article from the following link: [LinearAlgebra_exs.zip](https://csoundjournal.com/downloads/LinearAlgebra.zip)
```csound

double sine(double D, double i, double f, int num, double A)
{
       double pi = 4 * atan(1.0);
       return A * (sin(2 * pi * i / D * f * num));
}

...

for (int s=0;s<SIZE;s++) {
    V[s] = sine(D, i, f, s, A);
fprintf(outf2, "%4.20f\n", V[s]);
    }

```


 An expanded .cpp example, from above, for waveform functions is provided in the downloadable examples and shows separate functions for sine, sawtooth, square, and triangle waves, with output to a file for use in a graphics application. Below, for example, is a portion of that code showing a sawtooth function.
```csound

double sawtooth(double D, double i, double f, int num, double A)
{
       double sawtooth;
return sawtooth  = A * (2 * (double(num)/double(D/f) - (double(floor((double(num)/double(D/f)) + 0.5)))));
}

...

for (int s=0;s<SIZE;s++) {
    V[s] = sawtooth(D, i, f, s, A);
fprintf(outf2, "%4.20f\n", V[s]);
    }

```


 The output headerless data file of the sawtooth wave can easily be plotted on Linux, shown below in figure 1, using a graphics program such as Gnuplot. If you have it installed on your machine then the following commands will show a sampling of the waveform in the time domain. For more information, see below in "Section IV. Graphics Plotting" for plotting files generated by Csound.
```csound

> gnuplot
> plot [0:1000] "td_sig.dat" with lines 1 linetype 1; set terminal x11 1;

```


![](images/sawtooth_linearalgebra.png)

**Figure 1. Gnuplot, sawtooth wave timedomain graph.**
## III. Linear Algebra Opcodes in Csound


To begin employing the *Linear Algebra Opcodes* in Csound, a similar approach to the standalone application code in the .cpp shown above is provided below, employing the opcodes `la_i_vr_create`, `la_k_vr_set`, and `la_k_a_assign` to create a vector, set the values of the vector, and assign vector ouput to an `asig` for listening.
```csound
sr=44100
kr=1
nchnls=2
0dbfs = 1

ginum init  44100
givr  la_i_vr_create  ginum
gitablenum1 ftgen 100, 0, -44100, 7, 0, 44100, 0

	instr 1 ; 400 Hz Sine
krow init 0
kcntr init 0
kvalue init 0
itwopi=3.14
ifreq = 400

reset:
givr    la_k_vr_set  krow, kvalue
krow = krow+1
kvalue = sin(itwopi*kcntr/(sr/2)*ifreq)
kcntr = kcntr + 1
if kcntr < ginum kgoto reset
	endin

	instr 2;Assign to asig and listen
asig  la_k_a_assign   givr
outs asig * .7, asig * .7
	endin
```


 Notice that the `k-rate` in the above example is set to 1, and the k-loop in instrument 1 will fill the allocated vector with `sin` values up to the sample rate. Instrument 2 will assign the global vector to an `asig` for audio playback output.

The *Linear Algebra Opcode's* implementation of gmm++ methods includes many additional math operators as opcodes, such a dot product, conjugation, normalization etc. for performing a variety of useful math operations on vectors and matrices. These operations are the same ones that could be employed using standalone gmm++ code, but have been implemented for use in Csound. It is also useful and interesting to view the Csound source code classes for the *Linear Algebra Opcodes* shown in the file linear_algebra.cpp located in the Opcodes folder of the Csound source code in order to better understand what happens when one of these opcodes is called in Csound.
## IV. Graphics Plotting


The ability to plot signals in the time and frequency domains is beneficial for visual proof and additional feedback that code is working properly so that it will produce the desired signal output. For plotting from Csound there are several different useful options on Linux that employ external applications; a few of those are described below.

If an empty table (100), as a global variable, has been allocated in Csound, then `la_i_t_assign` can assign a global vector to the table, and `ftsave` can be used to write the table to disk.
```csound
gitablenum1 ftgen 100, 0, -44100, 7, 0, 44100, 0

...
	instr 3 ; assign to table for printing
gitablenum1    la_i_t_assign         givr
	endin

	instr 4;--Save table
 ftsave "sine_la.save", 1, 100
	endin
```


For plotting the table using Gnuplot, the Csound function table header and footer information need to be deleted from the saved file, which can be done using sed commands in a bash script file.
```csound

#!/bin/bash

sed -i '1,25d' sine_la.save
sed -i '$d' sine_la.save
```


Another option for plotting is to change the CsOptions `csound` command line flag for output and save the audio output as a .wav file.
```csound

<CsoundSynthesizer>
<CsOptions>
csound -g -+rtaudio=ALSA -omysine.wav -b1024 -B16384
</CsoundSynthesizer>
</CsOptions>

```


SoX can then be employed to extract a few seconds of the audio file and save the output to a .dat file. The sox command below shows trimming the file to 2 seconds, then saving the output to .dat file.
```csound

sox mysine.wav  trim_sine.wav trim 0 00:02

sox trim_sine.wav output_sine.dat

```


Next, open the output .dat file and delete the initial text, and resave as .dat for use in Gnuplot.

For plotting in both the time and frequency domains from an audio input signal, a useful, and handy application on Linux is Snd by Bill Schottstaedt.
## V. SSB Example


A single side band modulation example is included here as a means to further explore aspects of the *Linear Algebra Opcodes*. A more succint example of pitch shifting is available in the Csound Manual under *hilbert*[[5]](https://csoundjournal.com/#ref5), a hilbert transformer. The approach shown here is for the purpose of utilizing several aspects of the *Linear Algebra Opcodes* in one, complex, signal processing example. The SSB example provides pitch shifting through upper and lower frequency sidebands utilizing vector creation, and filling those with sin, cos, or also complex (*buzz*) input signals, utilizing the hilbert transform on a vector of sin signals, and multiplying and subtracting vectors to yield vectors of upper and lower sidebands. Finally all vectors are saved to tables and written to disk for use in a graphics program such as Gnuplot.

From the *hilbert *example in the Csound Manual, and where `givr` below is a global vector, we can employ the *Linear Algebra Opcodes* in the following manner:
```csound
amod1 = givr_hilbertreal * givr_sin
amod2 = givr_hilbertimag * givr_cos

//then upshift is
aupshift = amod1 - amod2
adownshift = amod1 + amod2

//Applying the Linear Algebra Opcodes, this portion could be written as:
givr_mod1	la_i_multiply_vr    givr_cos, givr_hilbertreal
givr_mod2	la_i_multiply_vr    givr_sin, givr_hilbertimag

//And sum and differences can be calculated as:
givr_upper  la_i_subtract_vr givr_mod1, givr_mod2
givr_lower  la_i_add_vr givr_mod1, givr_mod2
```


The output of a Gnuplot multiplot, shown below in figure 2, for a portion of the time domain signals gives the sin and cos signals, the input signal (as sin), and resulting upper and lower sidebands. The complete Csound code for the SSB example, and sed and Gnuplot script files, are all located in the downloadable examples from the link given previously.

![](images/ssb_linearalgebra.png)

**Figure 2. Gnuplot, multiplot timedomain output of single side band signals.**
## VI. Eigenvalues and Eigenvectors


A complex topic, related to signal processing, is Eigenvalues and Eigenvectors. The *babo* opcode, a physical model reverberator, employs eigenvalues, for example, for continuous control of diffusion by moving the eigenvalues along the unit circle and taking the inverse discrete fourier transform of them. The source code for babo.c is located in the Csound opcode folder. Other interesting approaches for musical applications of Eigenvalues and Eigenvectors are also discussed in "Eigenvalues and musical instruments" by V.E. Howle, and Lloyd N. Trefethen, and also "Can One Hear...? An Exploration Into Inverse Eigenvalue Problems Related to Musical Instruments" a master's thesis by Christine Adams where she offers mathematical proof of famous problems such as "Can One Hear the Shape of a Drum?".

 Using the *Linear Algebra Opcodes* in Csound we can create a matrix and then employ the gmm++ qr_algorithm to show the Eigenvalues and Eigenvectors of the matrix.

 There are a number of ways in which to fill a matrix programmatically. Shown below is a k-loop used to fill a 3 X 3 matrix of real values beginning with the number 20. Instrument 2, below, then alters the diagonal of the matrix manually using `la_i_mr_set`.
```csound
instr 1; k fill matrix
krow init 0
kcolumn init 0
kvalue init 20

reset:
  while kcolumn < 3 do
gimr_matrix	la_k_mr_set	 krow, kcolumn, kvalue
kvalue = kvalue + 1
kcolumn = kcolumn + 1
  od
kcolumn  = 0
krow = krow + 1
if krow < 3 kgoto reset
	endin

	instr 2 ; alter the diagonal of the matrix
gimr_matrix	 la_i_mr_set   0, 0, 4
gimr_matrix	 la_i_mr_set   1, 1, 4
gimr_matrix	 la_i_mr_set   2, 2, 4
	endin
```


 Once we have a suitable matrix, the qr_algorithm can be employed as an opcode to provide a vector of Eigenvalues, and a matrix of Eigenvectors.
```csound

givr_eig_vals, gimr_eig_vecs  la_i_qr_sym_eigen_mr  gimr_matrix, 0.001

```


The results of the .csd output, using a tolerance of 0.001, are shown below.

3x3 Matrix    4 21 22   23 4 25   26 27 4

Eigenvalues   51.9551 -17.668 -22.2871

Eigenvectors   0.535929 0.812406 -0.229731   0.57767 -0.551301 -0.601967   0.615692 -0.189903 0.76471

 It becomes useful and instructive to verify results against standalone code in gmm++ and also Eigen. Eigen will give slightly different results because it employs a different algorithm (EigenSolver) than the qr_algorithm in gmm++. Both versions of the .cpp files, as well as the complete .csd, are included in the downloadable code for the examples.
## VII. Matrix Restoration


 As a standalone application, Eigen becomes more practical for complex topics than gmm++ on account of having more functions, better user documentation, and example code. If we want to restore the matrix, from the eigenvectors and eigenvalues, using the Eigen ComplexEigenSolver (ces) method, it becomes easier to compute the matrix restoration. The approach shown below, with the output in figure 3, employs Eigen using the multiplication of a matrix V with eigenvectors as its columns, a diagonal matrix D with eigenvalues A on the diagonal, and the inversion V-1 of the matrix of eigenvectors as its columns[[6]](https://csoundjournal.com/#ref6).
```csound
Eigen::ComplexEigenSolver ces;
ces.compute(A);
ces.eigenvectors() * ces.eigenvalues().asDiagonal() * ces.eigenvectors().inverse()

```
 ![](images/matrixrestore_linearalgegra.png)

**Figure 3. Screen output of matrix restoration using the ComplexEigenSolver. **

Once we have the Eigenvectors and Eigenvalues for the matrix, mathematical operations applied to those numbers before restoration can result in restored, but proportional matrices, as shown below in figure 4.
```csound
(ces.eigenvectors()*2) * ces.eigenvalues().asDiagonal() * ces.eigenvectors().inverse()
```


Multiplying the matrix V of eigenvectors by the number 2, for example, yields, before restoration, a matrix with numbers twice as large as the original. ![](images/matrixrestore2_linearalgebra.png)

**Figure 4. Portion of screen output of proportional matrix restoration. **
## VIII. Matrix of Gen08 Splines


 A final example provides a practical demonstration of utilizing the matrix as an array of arrays in order to help with signal processing. In this example, an `if` statement for row control within an `until` statement to control columns, facilitates traversing the rows and columns of a 2 X 2 matrix. The ivalues of the matrix from the getter `la_i_get_mr` represent f-numbers from a list of *GEN08* spline curves.
```csound
GEN08 spline curves
gione ftgen 1, 0, 65, 8, 0, 32, 1, 33, 0
gitwo ftgen 2, 0, 65, 8, 0, 32, 0, 33, 1
githree ftgen 3, 0, 65, 8, 0, 16, 1, 16, 0, 16, 0, 17, 1
gifour ftgen 4, 0, 65, 8, 0, 16, 0, 16, 1, 16, 0, 17, 1

gimr_matrix	   la_i_mr_create        2, 2
...
	instr 1
irows, icolumns  la_i_size_mr   gimr_matrix
icntr init 1
irow init 0
icolumn init 0

until icntr > irows * icolumns do
	ivalue   la_i_get_mr   gimr_matrix, irow, icolumn

	schedule 10, ivalue, 1, 9.00 + (0.01 * ivalue), ivalue

	if (icolumn == icolumns - 1)then
		irow = irow + 1;
        	icolumn = -1;
        	igoto cont;
        	endif;
cont:
icolumn = icolumn+1
icntr = icntr + 1
od
      endin
```


 The *schedule* opcode, above, sends the ivalue f numbers to the instrument below, which uses the *table* opcode to retrieve the numbers from the *GEN08* tables shown above, and adds those to the frequency input of a precision oscillator to create frequency glissandos of various spline curves.
```csound

instr 10
ifn  = p5 ;get function table number
kcps init 1/p3 ;create index over duration of note.
kndx phasor kcps
ixmode = 1
kval table kndx, p5, ixmode ;get the table data
kfreq = kval * 100 ;scale the data
aspline  poscil .7,  cpspch(p4) + kfreq, 1 ;add data to frequency
      outs aspline, aspline
	endin

```

## IX. CONCLUSION


 In this article several of the *Linear Algebra Opcodes* have been employed in brief Csound examples. Gmm++ and Eigen code employed as standalone applications, have also been demonstrated for clarification of linear algebra methods. Eigen, at a certain point, begins to become a more useful standalone application for more complex tasks. It was noted also that CsoundAC .cpp files from the Csound source code frontends/CsoundAC folder, such as Counterpoint.cpp, Cell.cpp, Node.cpp etc., are useful and instructive for viewing how Eigen and linear algebra function as node classes for CsoundAC, the Python extension module. One suggestion might be to consider also moving the *Linear Algebra Opcodes* to Eigen similar to the use of Eigen in CsoundAC.  ![](images/matrix_linearalgebra.png)

A final idea, with the increase in popularity of music grid controllers such as Launchpad Pro, Push 2, LinnStrument, Adafruit, as well as others, is that users on their own should easily be able to employ Csound opcodes to map MIDI controller values to *Linear Algebra Opcode *vectors and matrices, perhaps increasing the usefulness of interfacing those controllers with the *Linear Algebra Opcodes* in order to develop interesting live performance practices.
## References


[][1] GetFEM++ project, "Gmm++." [Online] Available: [http://download.gna.org/getfem/html/homepage/gmm/](http://download.gna.org/getfem/html/homepage/gmm/)/. [Accessed December 09, 2015].

[][2] Barry Vercoe et al., 2005. "Linear Algebra Opcodes." *The Canonical Csound Reference Manual, *Version 6.00.1 [Online] Available: [http://www.csounds.com/manual/html/linearalgebraopcodes.html](http://www.csounds.com/manual/html/linearalgebraopcodes.html). [Accessed December 09, 2015].

[][3] Barry Vercoe et al., 2005. "Features of CsoundAC." *The Canonical Csound Reference Manual, *Version 6.00.1 [Online] Available: [http://www.csounds.com/manual/html/featuresOfCsoundAC.html](http://www.csounds.com/manual/html/featuresOfCsoundAC.html). [Accessed December 09, 2015].

[][4] Benoît Jacob and Gaël Guennebaud et al., 2015. "Eigen." [Online] Available: [http://eigen.tuxfamily.org/index.php?title=Main_Page](http://eigen.tuxfamily.org/index.php?title=Main_Page). [Accessed December 09, 2015].

[][5] Barry Vercoe et al., 2005. "hilbert." *The Canonical Csound Reference Manual, *Version 6.00.1 [Online] Available: [http://www.csounds.com/manual/html/hilbert.html](http://www.csounds.com/manual/html/hilbert.html). [Accessed December 10, 2015].

[][6] Benoît Jacob and Gaël Guennebaud et al., 2015. "Eigen." [Online] Available: [http://eigen.tuxfamily.org/dox/classEigen_1_1ComplexEigenSolver.html](http://eigen.tuxfamily.org/dox/classEigen_1_1ComplexEigenSolver.html). [Accessed December 10, 2015].
## Additional Links and Info


Chris Bagwell, robs, and Ulrich Klauer, "SoX-Sound eXchange." [Online] Available: [http://sourceforge.net/projects/sox/](http://sourceforge.net/projects/sox/)/. [Accessed December 09, 2015].

Hans-Bernhard Broeker, Clark Gaylord, Lars Hecking, and Ethan Merritt, "Gnuplot." [Online] Available: [http://www.gnuplot.info/index.html](http://www.gnuplot.info/index.html)/. [Accessed December 09, 2015]. Lee E. McMahon, "sed." [Online] Available: [https://www.gnu.org/software/sed/](https://www.gnu.org/software/sed/)/. [Accessed December 09, 2015].

Bill Schottstaedt, "Snd." [Online] Available: [https://ccrma.stanford.edu/software/snd/](https://ccrma.stanford.edu/software/snd/)/. [Accessed December 09, 2015].
