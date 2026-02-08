---
source: Csound Journal
issue: 5
title: "Perl and Csound - Part I"
author: "sharing some of my findings here"
url: https://csoundjournal.com/issue5/perlCsound.html
---

# Perl and Csound - Part I

**Author:** sharing some of my findings here
**Issue:** 5
**Source:** [Csound Journal](https://csoundjournal.com/issue5/perlCsound.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 5](https://csoundjournal.com/index.html)
## Perl and Csound - Part I
 Jacob Joaquin
 jacobjoaquin AT gmail.com
## Introduction


Csound is a powerful computer music language capable of just about every type of digital synthesis one can imagine[[1](https://csoundjournal.com/perlCsound.html#References)]. Due to the inherent disadvantages of hand coding orchestra and score files, much of Csound's potential is often looked over or ignored. The limits of the syntax can also hinder the composer's ability to translate their musical ideas to code.

With Perl we can overcome many of these obstacles. Perl can manage and generate massive amounts of orchestra and score code that would be otherwise unfeasible using strictly Csound. The flexibility of Perl allows computer musicians to design tools that cater to their own compositional thought processes while retaining all of Csound's functions and capabilities.

Since I began experimenting with integrating Csound and Perl, I've discovered what works well, and what does not. My hope is that by sharing some of my findings here, you will be inspired to try incorporating Perl into your Csound experiences. There is no right way or wrong way of integrating Perl with Csound, and once you've used Perl enough, you will find your own methods of exploration.
## I. Overview

### Perl - A Quick Synopsis


Perl stands for "Practical Extraction and Report Language[[2](https://csoundjournal.com/perlCsound.html#References)]." It is a scripting language, meaning it is interpreted at run-time. The language was designed to create scripts quickly and efficiently. The trade-off is that Perl is slow compared to number-crunching languages such as C and Fortran. However, since we will be using Perl to generate text and not digital audio, this drawback is not an issue when generating Csound code.
### Hello World! - A Brief Glimpse of Perl Syntax


The following example is the traditional "Hello World!" program often written by programmers when they learn a new computer language[[3](https://csoundjournal.com/perlCsound.html#References)].
```csound
#!/usr/bin/Perl
print "Hello World!";
```
 **Figure 1.0** [*helloworld.pl*](https://csoundjournal.com/PerlCsoundArticle/helloworld.pl) prints "Hello World!" to the terminal window.

The first line, `#!/usr/bin/Perl/`, indicates to the operating system or shell to use the Perl interpreter. The second line writes the message `Hello World!` to the terminal or output window.
### How does it work?


In a nutshell, Perl is used to generate orchestra and score data. However, it can be thought of as more than just a code generator. Perl can also be used to process and filter Csound code, make self sufficient sound objects, and aid in the realization of algorithmic/process music.

The way this entire process works can be quantified into three stages. First, a Csounder writes a Perl script that is designed to generate Csound files. Second, the Perl file is executed, and if successful, a pure Csound file is generated. The last stage is rendering the generated file or files with Csound, producing an audio file or a real-time audio stream.

![image](PerlCsoundArticle/FlowChart.gif) **Figure 1.1** The three stages of using Perl and Csound.
### Why use Perl with Csound?


Using Perl with Csound is quite simple, once you get the hang of it. Though I believe that Perl can benefit all Csounders, I realize that this method of using Csound isn't for everyone. I will list what I consider to be the pros and cons, and let you decide for yourself whether or not Perl will benefit you.

**Pros**
- Generate massive scores
- Dynamically create instruments
- Manipulate existing Csound files
- Allows finer control over algorithmic and process music
- More flexible than the built-in Csound macro system
- Explore new methods of synthesis and composition
- Files generated are 100% pure Csound
- Both Perl and Csound are cross platform
- Do things that are otherwise impractical
- Customize the syntax to make Csound your own

**Cons**
- Having to think through an extra layer of code
- Potentially steep learning curve
- Must know your way around the command line
- Must be a programmer versed in both Perl and Csound
- Code can quickly get ugly and hard to read
### Other Scripting Languages


Scripting languages other than Perl will also generate Csound code. Javascript, Lisp, PHP, Python and Ruby are all great candidates. I recommend avoiding using languages such as C and Java, as they are particularly unwieldy in processing and managing text compared to the languages I've just mentioned.
## II. Perl Building Blocks


In this section, I will build a foundation of Perl specific functions, and how they can be applied to Csound. My intent was to design the simplest and cleanest methods possible for demonstration purposes. I'm also using unified Csound csd files, which helps reduce the number of files we work with.
### A Simple Csound File with Perl


Creating a Csound file requires very little Perl code. We start with creating a file called [*simple.pl*](https://csoundjournal.com/PerlCsoundArticle/simple.pl). When executed, the **open** function creates a unified Csound file called *simple.csd*. If [*simple.csd*](https://csoundjournal.com/PerlCsoundArticle/simple.csd) already exists, the original file is destroyed "in favor of its new matrix[[4](https://csoundjournal.com/perlCsound.html#References)]." `CSD` is the name of the filehandle we use to refer to the opened file. All of the Csound code between `print CSD << "END";` and `END` is written to `CSD`[[5](https://csoundjournal.com/perlCsound.html#References)]. The **close** function finalizes `CSD`.
```csound
#!/usr/bin/Perl

open( CSD, "> simple.csd" ) || die "Can't write file simple.csd: $!";

print CSD << "END";
<CsoundSynthesizer>

<CsInstruments>
sr     = 44100
kr     = 4410
ksmps  = 10
nchnls = 1

instr 1
    aosc oscil 30000, 440, 1
    out aosc
endin

</CsInstruments>

<CsScore>
f1 0 8192 10 1
i1 0 10
e
</CsScore>

</CsoundSynthesizer>

END

close CSD;

```
 **Figure 2.0** [*simple.pl*](https://csoundjournal.com/PerlCsoundArticle/simple.pl) demonstrates one of the simplest Perl scripts for generating a valid unified Csound file.

Disregarding white space, only five lines of Perl code have been added. Later, we'll see how these hybrid scripts can be much shorter than the generated orc, sco and csd files.

** See [<<EOF](http://www.ayni.com/perldoc/perl5.8.0/pod/perlop.html#%3c%3cEOF), [close](http://www.ayni.com/perldoc/perl5.8.0/pod/func/close.html), [open](http://www.ayni.com/perldoc/perl5.8.0/pod/func/open.html), [print](http://www.ayni.com/perldoc/perl5.8.0/pod/func/print.html)*
### Scalars


In languages such as C, data is stored in variables. Perl also stores data in variables, though in Perl, they are referred to as scalars. A scalar has the prefix `$` attached. An advantage that scalars have over C variables is that your don't need to manually cast their datatypes. Any scalar can hold an integer, float, or string. Perl can usually distinguish between datatypes, based on the context in which each instance of a scalar is used.
```csound
#!/usr/bin/Perl
use strict;

my $foo = "Csound";
my $bar = "5.04";

print "Have you upgraded to $foo version $bar, yet?\n"
```
 **Figure 2.1** [*scalar.pl*](https://csoundjournal.com/PerlCsoundArticle/scalar.pl) demonstrates that a scalar can hold both numbers and strings.

[*scalar.pl*](https://csoundjournal.com/PerlCsoundArticle/scalar.pl) writes the following to the terminal window:
```csound
Have you upgraded to Csound version 5.04, yet?
```
 **Figure 2.2** This is the output of [*scalar.pl*](https://csoundjournal.com/PerlCsoundArticle/scalar.pl).

In this script, I've introduced `use strict` which, when used, requires all scalars, arrays and hashes to defined using the **my** function. One of the benefits of `use strict` is that it encourages programmers to write cleaner code.

** See [my](http://www.ayni.com/perldoc/perl5.8.0/pod/func/my.html), [Scalars](http://www.ayni.com/perldoc/perl5.8.0/pod/perlintro.html#Scalars), [use strict](http://www.ayni.com/perldoc/perl5.8.0/lib/strict.html)*.
### Random


The following excerpt demonstrates generating score data with Perl's built-in random function, **rand**.
```csound
my $frequency = rand() * 900 + 100;

print CSD "i1 0 4 $frequency\n";
```
 **Figure 2.3** This excerpt from [*random.pl*](https://csoundjournal.com/PerlCsoundArticle/random.pl) generates a score event with a random frequency between the values 100 and 1000.

**rand** returns a float between 0 and 1, including 0 and excluding 1[[6](https://csoundjournal.com/perlCsound.html#References)]. The statement `$frequency = rand() * 900 + 100` creates bias, so that the final value will fall between 100 and 1000, including 100 and excluding 1000.
```csound
i1 0 4 787.613566146414
```
 **Figure 2.4** This score event was generated with the code found in figure 2.3. See [*random.csd*](https://csoundjournal.com/PerlCsoundArticle/random.csd).

** See [rand](http://www.ayni.com/perldoc/perl5.8.0/pod/func/rand.html)*.
### Formatting Numbers with printf


The **printf** function is a wonderful tool for formatting numbers. The generated frequency found in figure 2.4 is `787.613566146414`. We can use **printf** to shave off extraneous levels of precision. Since the just noticeable difference for frequency is �5 cents, we can get away with two decimal places of precision[[7](https://csoundjournal.com/perlCsound.html#References)]. I usually work with four or six decimal places.

If we are generating the scores, then why does it matter if we use six decimal places versus twelve? Untamed, generated Csound code can be hard to read. There will be times when it is necessary to analyze generated code to be sure the Perl script is doing what is expected. By shaving off unnecessary precision, you get the best of both worlds: precise enough numbers and cleaner Csound code.

To format numbers with **printf**, we use simple format codes. The two most important codes for generating Csound are `%d` for integers and `%.f` floating point numbers. To specify the precision of the float, we insert a number between the `%.` and the `f`. When the **printf** function is called, these format codes are replaced by the numbers located in parameters two and higher, in the same sequence in which they are used in the first parameter.
```csound
my $frequency = rand() * 900 + 100;

printf CSD ( "i%d %.4f %.4f %.6f\n", 1, 0, 4, $frequency );
```
 **Figure 2.5** [*printf.pl*](https://csoundjournal.com/PerlCsoundArticle/printf.pl) demonstrates formatting numbers in score events.
```csound
i1 0.0000 4.0000 312.478207
```
 **Figure 2.6** This score event was generated with the code in figure 2.5. See [printf.csd](https://csoundjournal.com/PerlCsoundArticle/printf.csd).

Here I used one integer, two floats with a precision of four, and a float with a precision of six. As you can see, **printf** when used proPerly will help straighten your columns, producing cleaner code.

** See [printf](http://www.ayni.com/perldoc/perl5.8.0/pod/func/printf.html), [sprintf](http://www.ayni.com/perldoc/perl5.8.0/pod/func/sprintf.html)*.
### Loops


Loops are perhaps the most important mechanism for generating code. With loops, we can automate certain processes to repeat over and over until a defined condition is met.

Perl comes with various types of loops, including the for-loop, the while-loop and the do-while-loop. Perl also has a few loop variants that make certain tasks easier, including the foreach-loop, the until-loop and the do-until-loop. Here is a basic for-loop in Perl:
```csound
for( $i = 1; $i <= 10; $i++ )
{
    print "$i\n";
}
```
 **Figure 2.7** This for-loop prints the numbers 1 through 10. See [*forloop.pl*](https://csoundjournal.com/PerlCsoundArticle/forloop.pl).

Perl provides an alternative to the for-loop that is easier to implement, and easier to read. Here is the equivalent of the previous example with the foreach-loop:
```csound
foreach( 1 .. 10 )
{
	print "$_\n";
}
```
 **Figure 2.8** Though the foreach loop differs from the for-loop in figure 2.7, the output is identical. See [*forloop.pl*](https://csoundjournal.com/PerlCsoundArticle/forloop.pl).

The `$_` is a special scalar built into Perl that automatically retains iterated values. In the case of the for-each loop in figure 2.8, `$_` holds a value between 1 and 10 depending on which iteration the loop is currently on. In cases where using the `$_` doesn't make sense, one can specify a scalar that will instead hold the values. For example: `foreach $value ( 1 .. 10 ) { }`

For a working Perl-Csound example, I have chosen to use the while-loop. This loop will continue generating new events at a random time interval between one-eighth of a second and one second, until the scalar `$startTime` exceeds four seconds.
```csound
my $startTime = 0;
my $frequency;

while( $startTime < 4 )
{
    $frequency = rand() * 900 + 100;

    printf CSD ( "i1 %.4f 0.5 %.6f\n", $startTime, $frequency );

    $startTime = $startTime + rand() * 0.825 + 0.125;
}
```
 **Figure 2.9** The while-loop in [*whileloop.pl*](https://csoundjournal.com/PerlCsoundArticle/whileloop.pl) continues to generate score events at random time intervals until `$startTime` reaches or exceeds the value 4.
```csound
i1 0.0000 0.5 894.709577
i1 0.4779 0.5 109.692073
i1 0.8381 0.5 289.274825
i1 0.9852 0.5 216.057307
i1 1.3320 0.5 280.710331
i1 1.6873 0.5 321.337319
i1 1.9777 0.5 115.167399
i1 2.2663 0.5 623.591924
i1 2.8348 0.5 918.851922
i1 3.7560 0.5 336.182481
```
 **Figure 2.10** These score events were generated with the code in figure 2.9. See [*whileloop.csd*](https://csoundjournal.com/PerlCsoundArticle/whileloop.csd).

** See [$_](http://www.ayni.com/perldoc/perl5.8.0/pod/perlvar.html#%24_), [Range Operators](http://www.ayni.com/perldoc/perl5.8.0/pod/perlop.html#Range-Operators).*
### Subroutines


A **sub** is Perl's definition of a user-defined function or subroutine. Subroutines are a great way of consolidating code for reusability and help programmers save time of having to manually type blocks of code over and over.
```csound
sub sineCluster
{
    my $instr    = shift;  # instrument number
    my $start    = shift;  # start time of score event
    my $duration = shift;  # duration of score event
    my $nVoices  = shift;  # the number of voices to generate
    my $amp      = shift;  # the amplitude of the pad
    my $minFreq  = shift;  # minimum possible frequency for pad voices
    my $maxFreq  = shift;  # maximum possible frequency for pad voices
    my $rise     = shift;  # attack time of the pad
    my $score    = '';     # stores the score events


    for( 1 .. $nVoices )
    {
        $score .= sprintf( "i%d %.4f %.4f %.4f %.4f %.4f\n",
                           $instr,
                           $start,
                           $duration,
                           $amp / $nVoices,
                           rand() * ( $maxFreq - $minFreq ) + $minFreq,
                           $rise );

    }

    return $score;
}
```
 **Figure 2.11** The user-defined subroutine `sineCluster` returns a string of generated score events. See [*sub.pl*](https://csoundjournal.com/PerlCsoundArticle/sub.pl).

To use our custom subroutine `sineCluster`, we call it as we would call any Perl built-in function. `sineCluster` returns a block of score code as a string. Since we want this code to be written to our file, we print it directly to the the filehandle `CSD`.
```csound
print CSD sineCluster( 1, 0.00, 8.00, 8, 30000, 100, 300, 0.500 );
```
 **Figure 2.12** This calls the custom subroutine `sineCluster` and writes the results to the [*sub.csd*](https://csoundjournal.com/PerlCsoundArticle/sub.csd). See [*sub.pl*](https://csoundjournal.com/PerlCsoundArticle/sub.pl).
```csound
i1 0.0000 8.0000 3750.0000 213.6142 0.5000
i1 0.0000 8.0000 3750.0000 206.5978 0.5000
i1 0.0000 8.0000 3750.0000 209.8422 0.5000
i1 0.0000 8.0000 3750.0000 195.3327 0.5000
i1 0.0000 8.0000 3750.0000 274.6884 0.5000
i1 0.0000 8.0000 3750.0000 113.7666 0.5000
i1 0.0000 8.0000 3750.0000 249.6883 0.5000
i1 0.0000 8.0000 3750.0000 188.4543 0.5000
```
 **Figure 2.13** These score events were generated with the call to `sineCluster` in figure 2.12. See [*sub.csd*](https://csoundjournal.com/PerlCsoundArticle/sub.csd).

One point of interest is that the number of parameters passed to `sineCluster` is larger than the number of p-fields in *instr 1*.

** See [sub](http://www.ayni.com/perldoc/perl5.8.0/pod/perlsub.html), [return](http://www.ayni.com/perldoc/perl5.8.0/pod/func/return.html), [shift](http://www.ayni.com/perldoc/perl5.8.0/pod/func/shift.html).*
### Arrays


Much like a table in Csound, an array can hold multiple values of data. An array is denoted in Perl with the prefix `@`. However, when you want to use a single value in an array, you need treat the value as if it were a scalar using the prefix `$`. To specify which value you would like to access in an array, an index must be provided. For example, `@foo` refers to the array. `$foo[ 0 ]` refers to the first value of array `@foo`. In this example, I have created an array called `@pitchTable` which holds five different pitch values, which are chosen using the **rand** function.
```csound
my $startTime;
my $index;
my $pitch;

my @pitchTable = ( 8.00, 8.02, 8.03, 8.07, 8.09 );

foreach $startTime ( 0 .. 9 )
{
    $index = int( rand() * scalar( @pitchTable ) );
    $pitch = $pitchTable[ $index ];

    printf CSD ( "i1 %d 1 %.2f\n", $startTime, $pitch );
}
```
 **Figure 2.14** [*array.pl*](https://csoundjournal.com/PerlCsoundArticle/array.pl) randomly selects values found in the array `@pitchTable`.
```csound
i1 0 1 8.03
i1 1 1 8.07
i1 2 1 8.07
i1 3 1 8.09
i1 4 1 8.02
i1 5 1 8.07
i1 6 1 8.00
i1 7 1 8.09
i1 8 1 8.03
i1 9 1 8.03
```
 **Figure 2.15** The score events in [*array.csd*](https://csoundjournal.com/PerlCsoundArticle/array.csd) were generated with the code in figure 2.15.

** See [Arrays](http://www.ayni.com/perldoc/perl5.8.0/pod/perlintro.html#Arrays), [for](http://www.ayni.com/perldoc/perl5.8.0/pod/perlintro.html#for), [foreach](http://www.ayni.com/perldoc/perl5.8.0/pod/perlintro.html#foreach), [int](http://www.ayni.com/perldoc/perl5.8.0/pod/func/int.html), [scalar](http://www.ayni.com/perldoc/perl5.8.0/pod/func/scalar.html), [while](http://www.ayni.com/perldoc/perl5.8.0/pod/perlintro.html#while)*
### Conditional Branching


With the use of the branching statements `if`, `else`, `elsif` and `unless`, we can design smarter Perl scripts that make decisions about which code to execute and which code to ignore based on defined conditions. When the simple `if` is used, the conditional statement is checked for truth. When the conditional statement is true, the proceeding code, either a single line of code or a block of code contained within two curly brackets, is executed. When the statement is false, the proceeding code is bypassed.

The conditional statement `$frequency > 22050` in figure 2.16 checks if `$frequency` is greater than `22050`.
```csound
if( $frequency > 22050 )
{
	$frequency = 22050;
}
```
 **Figure 2.16** The scalar `$frequency` is only set to `22050` if the value of `$frequency` is greater than `22050`.

The if-else is a compound statement that chooses between which two blocks of code to execute: The code block proceeding the `if` or the code block proceeding the `else`.
```csound
if( $bool == TRUE )
{
	print "Hello World!\n";
}
else
{
	print "Goodbye World!\n";
}
```
 **Figure 2.17** If `$bool` is true, `Hello World!` is written to the terminal window. Otherwise, `Goodbye World!` is written.

This next demonstration uses the `elsif` conditional branch to choose between three possible waveforms based on the frequency of the score event.
```csound
my $frequency = 50;
my $startTime = 0;
my $waveshape;

while( $frequency <= 1600 )
{

    if( $frequency >= 800 )
    {
        # Sine wave
        $waveshape = 1;
    }
    elsif ( ( $frequency >= 200 ) && ( $frequency < 1000 ) )
    {
        # Triangle Wave
        $waveshape = 2;
    }
    else
    {
        # Saw wave
        $waveshape = 3;
    }

    printf CSD ( "i1 %d 1 %.6f %d\n", $startTime, $frequency, $waveshape );

    $startTime = $startTime + 1;
    $frequency = $frequency * 2;
}
```
 **Figure 2.18** [*ifelse.pl*](https://csoundjournal.com/PerlCsoundArticle/ifelse.pl) changes the timbre of *instr 1* by choosing between three wave forms (sine, triangle and saw) based on frequency.
```csound
i1 0 1 50.000000 3
i1 1 1 100.000000 3
i1 2 1 200.000000 2
i1 3 1 400.000000 2
i1 4 1 800.000000 1
i1 5 1 1600.000000 1
```
 **Figure 2.19** P-field six indicates the waveshape table chosen by the conditional branches in figure 2.18. See [*ifelse.csd*](https://csoundjournal.com/PerlCsoundArticle/ifelse.csd).

** See [Simple statements](http://www.ayni.com/perldoc/perl5.8.0/pod/perlsyn.html#Simple-Statements), [Compound statements](http://www.ayni.com/perldoc/perl5.8.0/pod/perlsyn.html#Compound-Statements)*.
## III. Further Study of Perl


The task of writing code that generates code can seem daunting at first. With a little bit of time and a little bit of persistence, you will soon start reaping the benefits of integrating Perl into your Csound compositions. I hope at this point I have provided enough information to get you started.

If you are interesting in learning more about Perl, there is a wealth of information on the net. I recommend starting with the community website, [PerlMonks.org](http://www.perlmonks.org/). There you will find a very comprehensive list of [Perl tutorials](http://www.perlmonks.org/?node=Tutorials) and a thorough database of [Questions and Answers](http://www.perlmonks.org/?node=Categorized%20Questions%20and%20Answers).

There are also three books that I personally recommend. The first is *Learning Perl* by Randal L. Schwartz and Tom Phoenix. My first baby steps in Perl were taken with this book. It's perfect for those with little to no prior programming experience. If you are already a solid programmer, you can skip this title. The second book is the *Perl Cookbook* by Tom Christiansen and Nathan Torkington, which contains nothing but solutions for the most common Perl problems. The third is *Programming Perl* by Larry Wall, Tom Christiansen and Randal L. Schwartz. This book is often referred to as the "Camel Book" and is considered by many to be the "Perl Bible." I always have this book by my side when I do any serious Perl scripting. If you want to know Perl, you need to read this book.
## To Be Continued...


Now that the basic foundation of using Perl with Csound has been laid, I look forward to writing Part II. As of now, the power that Perl brings to Csound might not yet be apparent. However, in the next issue, I will showcase more advanced Perl-Csound techniques that will act as guides for you to design your own custom scripts and complex instruments, such as creating your own custom syntax to augment Csound's score environment.

In the meantime, if you have any questions or comments, feel free to email me at jacobjoaquin@gmail.com. I will do my best to help you in any way I can.

Until next time,
 Jacob Joaquin


### Files
 [PerlCsound.zip](https://csoundjournal.com/PerlCsoundArticle/PerlCsound.zip) - All the Perl scripts and unified Csound csd files for this article.]

### Links
 [Csounds.com](http://www.csounds.com/) - ... almost everything Csound.
 [Csound Journal](http://www.csounds.com/journal/) - Inspiration in Ezine form.]
 [Hacking Perl in Nightclubs](http://www.perl.com/pub/a/2004/08/31/livecode.html) - By Alex Mclean
 [Granul 01](http://www.adp-gmbh.ch/csound/granular/granul01.html) - Perl Granular Instrument Generator by René Nyffenegger.
 [Harmonic Trees](http://www.csounds.com/ezine/trees/index.html) - Perl-Csound related compositions and theory by Jacob Joaquin.
 [PerlMonks.org](http://perlmonks.org/) - An Online Monastery of Perl Programmers and Perl Resources.
 [Perldoc.com](http://www.ayni.com/perldoc/index.html) - Perl Documentation Online
 [Thumbuki.com](http://www.thumbuki.com/) - The Cosmos in 20 Words or Less.

### References
 [1] Boulanger, R. 2000. *Introduction to Sound Design in Csound*. Cambridge, Mass.: MIT Press [http://www.Csounds.com/chapter1/index.html](http://www.Csounds.com/chapter1/index.html)
 [2] Perl. Wikipedia.org. [http://en.wikipedia.org/wiki/Perl](http://en.wikipedia.org/wiki/Perl)
 [3] Hello world program. Wikipedia.org. [http://en.wikipedia.org/wiki/Hello_World](http://en.wikipedia.org/wiki/Hello_World)
 [4] Spock. 1982. Quote from *Star Trek II: The Wrath of Khan*. Paramount Pictures.
 [5] I discovered the `<< 'END'` method in Granul 01 by René Nyffenegger. [http://www.adp-gmbh.ch/csound/granular/granul01.html](http://www.adp-gmbh.ch/csound/granular/granul01.html)
 [6] Siever E., Spainhour S. & Patwardhan N. 1999. *Perl In A Nutshell*. O'Reilly & Associates. [http://www.goldfish.org/books/O'Reilly%20Perl%20CD%20Bookshelf%202.0/Perlnut/c05_117.htm](http://www.goldfish.org/books/O'Reilly%20Perl%20CD%20Bookshelf%202.0/perlnut/c05_117.htm)
 [7] Just noticeable difference. Wikipedia.org. [http://en.wikipedia.org/wiki/Just_noticeable_difference](http://en.wikipedia.org/wiki/Just_noticeable_difference)
