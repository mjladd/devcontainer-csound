---
source: Csound Journal
issue: 10
title: "An Overview of Csound Variable Types"
author: "the phase
		vocoder streaming"
url: https://csoundjournal.com/issue10/CsoundRates.html
---

# An Overview of Csound Variable Types

**Author:** the phase
		vocoder streaming
**Issue:** 10
**Source:** [Csound Journal](https://csoundjournal.com/issue10/CsoundRates.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 10](https://csoundjournal.com/index.html)
## An Overview of Csound Variable Types
 Andrés Cabrera
 mantaraya36 AT gmail DOT com
## Introduction


All Csounders have at one time or another been bitten by the "type k not allowed when expecting i" message. One invariably wonders: why not make all variables a-type and just be done with it?

This could be a solution, but Csound's internal mechanisms, although more complex, provide greater control over performance optimization and memory usage through the use of variable types with different update rates.
## I. Variable types in Csound


Csound has very few variable types, and has no built-in system for type definition. All variables in Csound must start with a letter that designates its type. This is somewhat archaic, but it is useful since the variable name always carries the type.

Csound has six variable types that can be split in three categories:
-

Numeric Value types:
  -

a-type: These variables hold audio samples, or control signals that are calculated and updated every audio sample. These variables are in fact vectors, as will be explained below.
  -

k-type: These variables hold scalar values which are updated only once per control period.
  -

i-type: Initialization variables are only updated on every note's initialization pass. This may not make sense yet, but hopefully it will.
-

String type
  -

S-type: Modern versions of Csound handle strings as a builtin data type.
-

Spectral analysis data types
  -

F-type: f-type signals are generated and used by the phase vocoder streaming (pvs) opcodes.
  -

w-type: Rarely used now that the more practical and efficient pvs opcodes exist, these variables hold data for the older non-standard spectral opcodes.

The oldest and more commonly used variable types are the ones that hold values, the *a*, *k*, and *i* types. To understand why these different types exist and their exact behavior, it is necessary to understand how Csound works internally.
### The Csound Processing Chain and Control Blocks


Like most computer music software and hardware, Csound splits audio samples in blocks. Each block is calculated as a single entity, and only when Csound has finished processing a block, will it start to process the next. These blocks are called control blocks in Csound and they are processed at a rate set by the *kr* header variable: the control rate. Each block contains *ksmps* number of samples. Since there are *kr* number of blocks of *ksmps* samples which are processed every second, *kr***ksmps* must be equal to *sr*.

When Csound runs, it parses the orchestra and score sections of the csd file (or the separate .orc and .sco) files, and prepares a set of instruments and a set of events scheduled for these instruments. A Csound instrument defines a particular algorithm, but an instrument does nothing until it is instantiated: until an event triggers it. When an event starts (from the score, from MIDI or from API events), the corresponding instrument is instantiated. Instantiating an instrument means allocating memory for the opcodes and local variables of the instrument, so each note is an independent system. Once allocated, the instrument must be initialized. Initializing an instrument means preparing everything for execution and includes actions like resetting oscillator phases, allocating memory for delay lines and basically all things that need to be done once for the algorithm to work. This process is called the initialization pass.

Csound uses a processing chain to produce output. When an instrument is instantiated, it is placed in the processing chain. The chain is traversed once every control block, making every active instrument instance generate output. An instrument can appear several times in the processing chain if several notes for it are playing simultaneously. This is the reason why Csound is polyphonic by default.

Each processing of the chain is known in Csound-speak as the "performance pass" or perf-pass. The processing chain starts empty on every Csound run and a new "link" in it is added every time an instrument is turned on by a score, MIDI or other type of event.

![image](images/Csound%20Rates_html_m21f3e1a5.png)

 **Figure 1.** Illustration of performance pass

The instance (or note) of a certain instrument will remain in the processing chain until it finishes, and when it does, it is removed from the chain or "deallocated".

Perf-passes occur at regular intervals determined by the control rate and init-passes only occur before perf-passes when a new event triggers the instantiation of an instrument. There can be a special case of an init-pass occurring within a perf-pass if the *reinit* opcode is used.

So in fact, Csound processes all its input and output at control rate (k-rate). Audio signals are processed also at k-rate, but they do not have a single value for every control period, like k-type variables have. They are vectors, which contain a sequential group of *ksmps* audio samples. In every perf-pass, Csound updates k-type variables once and also updates *each of the individual values* contained in a-type vectors. When *kr* = *sr*, k-type signals and a-type signals are actually both scalar values, since there will be one value for each type updated every perf-pass.
### i-, k- and a-types


Control variables (k-types) are the natural values in Csound, since Csound executes its process loop at Control Rate (kr). A-type variables are vectors of values which are processed at k-rate as well, but opcodes must traverse the vector and apply processing to each element. A- and k-type variables are processed at constant intervals, but i-type variables are processed only when an init-pass is performed.
### Strings


Strings (variables starting with S), are processed during the init-pass or the perf-pass, depending on the particular opcode that is processing them. As a rule of thumb, string opcodes operate on the init-pass, unless they are specified to work at k-rate. You can usually tell by the name, for example *strlen *operates during the init pass only and *strlenk* works on every perf-pass.
### Spectral data types


There are two other types supported in Csound, which from the user's perspective have their own rate, but which are internally processed during the ordinary perf-pass. These are the f- and w-type variables, which are designed to hold sound analysis frames. The f-rate type is used by the [pvs opcodes](http://www.csounds.com/manual/html/SpectralRealTime.html), and holds the output frames from a streaming phase vocoder analysis (using FFT). The older w-type is used by the ["Non-standard spectral processors"](http://www.csounds.com/manual/html/SpectralNonstand.html) which are incompatible with the pvs opcodes, and use DFT instead of phase vocoder from FFT. This makes them less efficient, although useful under certain circumstances. The actual rates at which these opcodes work depends on the analysis parameters specified, specifically window size and overlap. Note that different f-sigs can actually have different rates and combining two f-signals which have different internal rates, may produce undesired results.
## II. Converting between types


Inevitably, when working with Csound, one will want to use a variable with a different rate than the opcode is designed to use. If you get the dreaded "type X not allowed when expecting X", there are several ways to get around it, and have Csound do what you need.
### a-type to k-type


There are opcodes designed to convert a-type signals to k-type variables. Bear in mind that what we are actually converting is a group of values to a single value, so the question is, how exactly do you want to convert? Do you want to average? Do you want the maximum? Do you want a certain element?

The *downsamp* opcode, produces a single value from an a-type vector, taking the first element of the audio vector by default. By using the optional *iwlen* parameter, you can specify the number of samples of the vector which will be averaged to produce the k-rate value. Naturally, *iwlen* cannot be greater than the control block size (*ksmps*), because that is the length of the audio vector, and there are no more samples to average.

If you want to have control over the rate of downsampling, instead of having it depend on *kr*, you can use the *samphold* opcode.

The *max_k* opcode allows you to find the maximum or minimum value within an a-type vector, and stores that single value in a k-type variable.

Another useful way of turning an a-type variable to k-type is using the *rms* opcode. While this is not exactly converting the values directly, but a type of averaging, it is useful in cases where you want to have a value that corresponds to the energy the a-type signal carries, independently of its actual movement.

Since a-rate signals are vectors, they can actually be treated as such, with access to their individual elements using the *vaget* and *vaset* opcodes. Notice that values produced by *downsamp* and *max_k* will vary if *kr* or *ksmps* is changed, whereas *rms* and *samphold* are independent of it.
### k-type to a-type


k-type to a-type operations involve turning one value into a vector of values. As we saw before, this may seem trivial, but it can be done in different ways.

The simplest way is using *upsamp*, which will fill the whole audio vector with the same value given by the k-rate variable. *Upsamp* is equivalent to the = operator:
```csound
avalue = kvalue

```

 but it is slightly more efficient.

*Upsample* will create an audio signal which may be too jagged for certain uses (with many abrupt changes instead of a fluid shape). That is why the *interp* opcode exists. This opcode will produce a straight line trajectory between the different k-rate values, to fill the audio-rate vector. ![image](images/Csound%20Rates_html_m74df850d.png)

 **Figure 2.** Conversion of k- to a- using *upsamp* and *interp*.

Using *interp* is equivalent to using the* a*() converter, which will upsample a k-rate variable with interpolation:
```csound
avalue = a(kvalue)
```

###  k-type to i-type


This is a tricky one. At first look, it may seem analogous to the a-rate to k-rate conversion, since it appears to involve just a simple downsampling. This is not the case, and this is a great source of confusion for Csound users, particularly when using *goto* and *if* statements.

There is a simple converter which will convert a k-type signal to i-type: i(). The problem lies in the fact that the conversion takes place during the init-pass, which is a moment when the k-type variable might actually have a value of 0, because there has been no perf-pass to update it!

Solving this issue depends on the specific case. Many times it may be necessary to create a separate "always on" instrument which updates a global k-rate variable; other times a reinit pass may be needed (See chapter III below).
### i-type to k-type


I-rate variables can be converted to k-rate variables simply with the = operator like this:
```csound
kval = ival

```

 Bear in mind that this operation runs every perf-pass, so whenever the i-type value changes (if it is a global variable or is changed in a reinit pass), the k-type variable will be changed as well.

The *init* opcode provides a convenient way to set the value of a k-type variable during the init-pass only. This means the value will be stored in the variable during initialization only, and the opcode will do nothing during the perf-pass, so it is a convenient way of having a k-type variable start with a value, but be independent from there on.

I-type can also be converted to k-type, with the k() converter. This is equivalent to the *upsample* opcode, but can be used within expressions. This is usually done implicitly by opcodes and there is rarely a need to do it.
### a-type to/from i-type


These conversions are uncommon, and must pass through an intermediate k-type variable, except when going from i- to a-type, in which case you can do:
```csound
avalue = ivalue

```

 Bear in mind that this statement runs at k-rate!
### a-type to/from f-type


This conversion implies an analysis or resynthesis process, and is taken care by opcodes like *pvsanal* and *pvsynth*.
### f-type to k-type


Though not really a conversion, you can obtain k-rate values from f-signals by extracting a single value of information, directly or through further analysis, for instance using *pvsbin* or *pvspitch*.
### Implicit conversions


There are cases where Csound performs an implicit conversion of rates. An example of this is the *schedkwhen* opcode, which even though it takes k-rate parameters, it "freezes" them into i-rate for the spawned instrument. For example, the p-fields for this instrument do not change from their initial values even if the values *schedkwhen* receives change.
## III. Reinit


You can change the values of i-type variables within an instrument instance using the *reinit* opcode. The *reinit* opcode runs at k-type (i.e. it goes to the specified label on every perf-pass), and produces a new init-pass in the middle of the perf-pass. *reinit* performs a new init-pass for all lines contained within the *reinit* label and the *rireturn* statement. This way you can selectively reinitialize certain opcodes while leaving others in their current state. Reinitialization of many opcodes like filters and oscillators will cause a discontinuity (and an audible click) in the audio, but it will allow you to change i-type variables during the course of an instrument instance. If an opcode does not take k-type variables, *reinit* can help you achieve this, but it may produce undesired noises or clicks.
## IV. Instrument 0


There is a special init-pass at the start of every Csound run, which processes all statements outside instrument blocks, which usually placed directly below the headers. This section is called *instrument 0* and is generally used to initialize global variables, or for the FTLK sections of the orchestra file. It is important to note that this section receives only an init-pass, so you cannot use any opcodes that perform perf-passes. Csound will throw an error if any opcodes which perform perf-passes are placed outside instrument blocks.
## V. Different rates in action


Below is an example which shows the different rates in action. Comments and explanations are inline.


```csound
<CsoundSynthesizer>
<CsInstruments>
sr = 44100
kr = 100

; all variables start at 0
givar init 0
gkvar init 0
gavar init 0

instr 1
; this instrument prints the i-type variables then adds 1
; then prints it again. No matter the duration of the note,
; givar is only updated once per instrument. Notice that
; the value changes between both print statements, since
; everything is processed during the init-pass

print givar
givar = givar + 1
print givar
endin

instr 2
; Since the variable is global, we add to whatever
; instrument 1 has added.
print givar
ivar init givar  ; ivar only changes on the init-pass
givar = givar + 10
print givar

; This instrument adds 1 to the k-rate variable on
; every perf-pass.
gkvar = gkvar + 1

; This instrument adds 1 to all the elements of
; the a-type variable once every perf-pass.
; it will produce the same value as the
; previous statement, since it means adding
; a scalar value to the whole vector.
gavar = gavar + 1

; there is no print stament for a-type variables so
; we must downsample
karate downsamp gavar
printks "gkvar (%d) = %d\n", 0.25, ivar, gkvar
printks "gavar (%d) = %d\n", 0.25, ivar, karate
endin

</CsInstruments>
<CsScore>
i 1 0 1
i 1 2 2
i 1 3 1

i 2 4 1
i 2 5 0.5
i 2 5 0.5

</CsScore>
<CsoundSynthesizer>
```



This csd file produces the following output:


```csound
SECTION 1:
new alloc for instr 1:
instr 1:  givar = 0.000
instr 1:  givar = 1.000
B  0.000 ..  2.000 T  2.000 TT  2.000 M:      0.0
instr 1:  givar = 1.000
instr 1:  givar = 2.000
B  2.000 ..  3.000 T  3.000 TT  3.000 M:      0.0
new alloc for instr 1:
instr 1:  givar = 2.000
instr 1:  givar = 3.000
B  3.000 ..  4.000 T  4.000 TT  4.000 M:      0.0
new alloc for instr 2:
instr 2:  givar = 3.000
instr 2:  givar = 13.000
gkvar (3) = 1
gavar (3) = 1
gkvar (3) = 25
gavar (3) = 25
gkvar (3) = 50
gavar (3) = 50
gkvar (3) = 75
gavar (3) = 75
gkvar (3) = 100
gavar (3) = 100
B  4.000 ..  5.000 T  5.000 TT  5.000 M:      0.0
instr 2:  givar = 13.000
instr 2:  givar = 23.000
new alloc for instr 2:
instr 2:  givar = 23.000
instr 2:  givar = 33.000
gkvar (13) = 101
gavar (13) = 101
gkvar (23) = 102
gavar (23) = 102
gkvar (13) = 149
gavar (13) = 149
gkvar (23) = 150
gavar (23) = 150
gkvar (13) = 199
gavar (13) = 199
gkvar (23) = 200
gavar (23) = 200
B  5.000 ..  5.500 T  5.500 TT  5.500 M:      0.0
```



Note that instrument 1 prints *givar* twice, first showing the value before modifying and the after modifying *givar*.

The addition statement (and the *printks* opcode) is passed through on the init-pass and the perf-passes. For this reason we see an initial addition of 1, and then four subsequent additions of 25 every 0.25 seconds. The total addition is 100, the number of control periods in a second (*kr*).

Also note that in instrument 2, the value of *givar* is preserved in *ivar*, even if it changes. This is used in the *printks* statements to identify to which instrument instance the statement belongs.

Simultaneous instances of an instrument will increment the k-variable at the same time, as we can see by the last set of values, which increment the variable by 100, through two instances lasting half a second each.

If you change the value of *kr* to 50 for this file, you will get the following output:


```csound
SECTION 1:
new alloc for instr 1:
instr 1:  givar = 0.000
instr 1:  givar = 1.000
B  0.000 ..  2.000 T  2.000 TT  2.000 M:      0.0
instr 1:  givar = 1.000
instr 1:  givar = 2.000
B  2.000 ..  3.000 T  3.000 TT  3.000 M:      0.0
new alloc for instr 1:
instr 1:  givar = 2.000
instr 1:  givar = 3.000
B  3.000 ..  4.000 T  4.000 TT  4.000 M:      0.0
new alloc for instr 2:
instr 2:  givar = 3.000
instr 2:  givar = 13.000
gkvar (3) = 1
gavar (3) = 1
gkvar (3) = 13
gavar (3) = 13
gkvar (3) = 25
gavar (3) = 25
gkvar (3) = 38
gavar (3) = 38
gkvar (3) = 50
gavar (3) = 50
B  4.000 ..  5.000 T  5.000 TT  5.000 M:      0.0
instr 2:  givar = 13.000
instr 2:  givar = 23.000
new alloc for instr 2:
instr 2:  givar = 23.000
instr 2:  givar = 33.000
gkvar (13) = 51
gavar (13) = 51
gkvar (23) = 52
gavar (23) = 52
gkvar (13) = 75
gavar (13) = 75
gkvar (23) = 76
gavar (23) = 76
gkvar (13) = 99
gavar (13) = 99
gkvar (23) = 100
gavar (23) = 100
B  5.000 ..  5.500 T  5.500 TT  5.500 M:      0.0
```



As expected, the values of the variables never contain decimal places, and end up adding the correct amount at the end. Notice that the results for the changes in the i-type variables is the same, while addition to k- and a-type variables has changed since it is occurring less frequently.
## VI. Other implications of Csound's different rates


Variable types have implications not only for opcodes, but also for program flow control structures using gotos and ifs. Csound provides different structures to control this, but many times the rate for flow control depends on the types used in comparison expressions.
## References


The Canonical Csound Reference Manual. Barry Vercoe et. al. [http://www.csounds.com/manual/html/index.html](http://www.csounds.com/manual/html/index.html)
