---
source: Csound Journal
issue: 6
title: "Using Python Inside Csound"
author: "the function"
url: https://csoundjournal.com/issue6/pythonOpcodes.html
---

# Using Python Inside Csound

**Author:** the function
**Issue:** 6
**Source:** [Csound Journal](https://csoundjournal.com/issue6/pythonOpcodes.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 6](https://csoundjournal.com/index.html)
## Using Python Inside Csound

### An introduction to the Python opcodes
 Andrés Cabrera
 andres AT geminiflux.com
## Introduction


Csound has the ability of executing Python scripts from within the orchestra text using a group of opcodes called the Python opcodes. These opcodes are a valuable but relatively unexplored extension to the Csound language, which can not only simplify data handling for parameter control or note generation, but also open the door for any type of interfacing, communication and extensions available in the Python language.
## I. Requirements

### Python


To use the Python opcodes, you first need to obtain Python, which is a separate install from Csound on Windows and Linux. You can obtain the latest version from [www.python.org](http://www.python.org/), but you need to check which version of Python your version of Csound has been compiled against. Recent versions of Csound require Python 2.4.

You can check if you already have Python by opening a DOS prompt or Terminal and typing "python". If Python is installed on your system, you should get something like:
```csound
Python 2.4.4 (#2, Oct 20 2006, 00:23:25)
Type "help", "copyright", "credits" or "license" for more information.

>>>

```


This is the Python "interactive shell". This just means that you can type Python code directly there, and have it execute immediately. Try something like:
```csound
>>>a=4

```


When you press the Enter, apparently nothing happens, but you have assigned the value of 4 to the variable "a". Now type:
```csound
>>>print a

```


You will see the shell prints a "4".

While an instance of a Python interpreter (like the interactive shell, or inside a Csound execution) is running, it remembers all the variables and functions that have been declared. To declare a function (a set of instructions grouped under a single name), you must use this syntax:
```csound
def average(a,b):
    ave = (a + b)/2
    return ave

```


Notice that you use the keyword *def* to define a function, and that you specify the function's arguments between parenthesis. You must use ":" to define the start of the function. You use the keyword *return* to specify variables returned by the function. Also notice that indentation (the spaces between the start of the line and the start of text) in Python is very important. In the case of functions, indentation tells Python which instructions are part of the function, and when the function ends. So you must be very careful about indentation when writing Python code. To define this function in the interpreter, just type each line one by one. Notice that when you type the first line, the prompt changes to "..." instead of ">>>", indicating that you are defining the function. You can continue typing the other lines. When you're finished writing your function, press enter again to tell the shell you're done with the function. The prompt returns to normal, and your function has been defined. You can now use your function like this:
```csound
>>>print average(100, 200)

```


This will naturally print the value "150".
### Learning Python


The net is full of Python tutorials and examples, but two popular resources to get started are the "official Python tutorial" at [http://docs.python.org/tut/tut.html](http://docs.python.org/tut/tut.html) and the "Dive into Python" book at [www.diveintopython.org](http://www.diveintopython.org/). If you already know Csound, all the Python code used here should be easy to read.
### Why Python?


Though learning Python means having to grasp a new syntax and a new way to express algorithms, it is generally accepted that Python is one of the easiest programming languages to learn. Python is an interpreted language, which means it executes the code line by line as it receives it, without the need of building (compiling) a binary to run, like in C or Java. Python is also a weakly typed language, which means you don't need to declare variable types (you don't need to specify whether you want a string, an array or an integer, Python deduces it from what you fill it with), and more importantly, many variable type conversions and operations are greatly simplified[1](https://csoundjournal.com/#sdfootnote1sym). It also has very easy-to-use arrays and lists, which can be nested and controlled easily. The big bonus of learning Python is that apart from enabling more complex data structures, and that all the features from the Python language will be available from a Csound orchestra or .csd file, you learn a very powerful but simple language that can help you in many computer chores.
## II. The Python Opcodes

### pyinit and pyruni


To use the Python opcodes inside Csound, you must first start the Python interpreter. This is done using the *pyinit* opcode. The *pyinit* opcode must be put in the header before any other Python opcode is used, otherwise, since the interpreter is not running, all Python opcodes will return an error. You can run any Python code by placing it within quotes as argument to the opcode *pyruni*. This opcode executes the Python code at init time. If it is put in the header, it will be run once, at the start of Csound compilation, before any score events. The example below, shows a simple *csd* file which prints the text "44100" to the terminal. Note that a dummy instrument must be declared to satisfy the Csound parser.



```csound
**<CsoundSynthesizer>**
**<CsInstruments>**
**sr**=44100
**ksmps**=128
**nchnls**=2

*;Start python interpreter*
**pyinit**

**pyruni** "print 44100"

**instr **1
**endin**

**</CsInstruments>**
**<CsScore>**
**</CsScore>**
**</CsoundSynthesizer>**
```


When using quoted text, you can't have any line breaks, as that will confuse the Csound parser. Csound provides the {{ and }} delimiters to specify multi-line strings, which can be used to create multi-line Python scripts. You can use these delimiters any place you use quotes -e.g. the *system* opcode-, and they will allow line breaks. These delimiters also allow you to use quotes inside them.

The Python interpreter maintains its state for the length of the Csound run. This means that any variables declared will be available on all calls to the Python interpreter. In other words, they are global. The code below shows variables "a" and "b" being modified by Python opcodes, and that they are available in all instruments. Also, you must convert the number (a+b) to a string to concatenate it with another string using the function *str()*.
```csound
**<CsoundSynthesizer>**
**<CsInstruments>**

**sr**=44100
**ksmps**=128
**nchnls**=2

**pyinit** *;Start python interpreter*

**pyruni** {{
a = 2
b = 3
print "a + b = " + str(a+b)
}} *;Execute a python script on the header*

**instr **1
**pyruni** {{a = 6
b = 5
print "a + b = " + str(a+b)}}
**endin**


**instr **2
**pyruni** {{print "a + b = " + str(a+b)}}
**endin**


**</CsInstruments>**

**<CsScore>**

**i** 1 0 1
**i** 2 1 0

**</CsScore>**
**</CsoundSynthesizer>**
```


The previous program will print among the rest of the Csound output or on the calling shell (if using a frontend[2](https://csoundjournal.com/#sdfootnote2sym)) the following lines:
```csound
a + b = 5
a + b = 11
a + b = 11

```


The first of these was executed in the header, the second was printed by instrument 1 and the second by instrument 2.
### pyrun


Python scripts can also be executed at k-rate using *pyrun*. When *pyrun* is used, the script will be executed again on every k-pass for the instrument, which means it will be executed *kr* times per second. The example below shows a simple example of *pyrun*.
```csound
**<CsoundSynthesizer>**
**<CsInstruments>**

**sr**=44100
**kr**=100

**nchnls**=2

**pyinit**

**pyruni** "a = 0"

**instr **1
    **pyrun** "a = a + 1"

**endin**


**instr **2
    **pyruni** {{print "a = " + str(a)}}

**endin**


**</CsInstruments>**
**<CsScore>**

**i** 1 0 1  *;Adds to a for 1 second*

**i** 2 1 0  *;Prints a*
**i** 1 2 1  *;Adds to a for another second*

**i** 2 3 0  *;Prints a*

**</CsScore>**
**</CsoundSynthesizer>**
```


This csd file produces the following output from Python:
```csound
a = 100
a = 200

```


This shows that the Python script in instrument 1 was executed 100 times per second. Which is what is expected since kr = 100. If *kr* is not defined, remember that *kr = sr/ksmps*.
### pyexec


Csound allows you to run Python script files that exist outside your *csd* file. This is done using *pyexec*. The *pyexec* opcode will run the script indicated, like this:
```csound
pyexec "c:/python/myscript.py"

```


In this case, the script "myscript.py" will be executed at k-rate. You can give full or relative path names.

You can create Python scripts using any ordinary (non-rich-text) text editor like notepad.

There are other versions of the *pyexec* opcode, which run at initialization only (*pyexeci*) and others that include an additional trigger argument (*pyexect*).
### pyeval and friends


The opcode *pyeval* and its relatives, allow you to pass to Csound the value of a Python variable. You specify the name of the variable in quotes, and Csound will assign the Python variable's value to the opcode's output variable. You can replace instrument 2 from the previous example with (notice I've used *pyevali* which works at initialization only):
```csound
**instr **2
ival **pyevali** "a"

**prints** "a = %i\\n", ival
**endin**

```


It should be this easy, but this is where a small pitfall comes in... Maybe you already tried and got:
```csound
INIT ERROR in instr 2: pyevali: expression must evaluate in a float

```


What happens is that Python has delivered an integer to Csound, which expects a floating-point number. In other words, Csound always works with numbers which are not integer (to represent a 1, Csound actually uses 1.0). This is equivalent mathematically, but in computer memory these two numbers are stored in a different way. So what you need to do is tell Python to deliver a floating-point number (also called a float) to Csound. What you need to do is "fool" Python into thinking you will be using decimals, even if you won't, so that the automatic type detection in Python, declares a value as a float instead of an integer. You can do this by changing the line in the header to:
```csound
**pyruni** "a = 0.0"


```


This will make the variable "a" be declared as a float within Python, and it will then be a valid variable to pass to Csound.
### pyassign and friends


Likewise, you can also assign values to Python variables directly, using *pyassign*. You could change the statement:
```csound
**pyruni** "a = 0.0"

```


to:
```csound
**pyassigni** "a", 0

```


Doing this also prevents problems with integer/floats types, because "a" is declared as a float by Csound, since all numbers are floats for Csound.

As before, *pyassign* comes in different versions, for k-rate and i-rate, and there are also versions with a trigger argument (*pyassignt*).
### pycall


Apart from reading and setting variables directly with an opcode, you can also call Python functions from Csound and have the function return values directly to Csound. This is the purpose of the *pycall* opcodes. With these opcodes you specify the function to call and the function arguments as arguments to the opcode. You can have the function return values (up to 8 return values are allowed) directly to Csound i- or k-rate variables. You must choose the appropriate opcode depending on the number of return values from the function, and the Csound rate (i- or k-rate) at which you want to run the Python function. Just add a number from 1 to 8 after to *pycall*, to select the number of outputs for the opcode. If you just want to execute a function without return value simply use *pycall*. For example, the function "average" defined above, can be called directly from Csound using:
```csound
kave   **pycall1** "average", ka, kb

```


The output variable *kave*, will calculate the average of the variable *ka* and *kb* at k-rate.

As you may have noticed, the Python opcodes run at k-rate, but also have i-rate versions if an "i" is added to the opcode name. This is also true for *pycall*. You can use *pycall1i*, *pycall2i*, etc. if you want the function to be evaluated at instrument initialization, or in the header. The following csd shows a simple usage of the *pycall* opcodes:
```csound
**<CsoundSynthesizer>**
**<CsInstruments>**

**sr**=44100
**kr**=100
**nchnls**=2

**pyinit**

**pyruni** {{
def average(a,b):
    ave = (a + b)/2
    return ave
}} *;Define function "average"*

**instr **1

iave   **pycall1i** "average", **p4**, **p5**
**prints** "a = %i\\n", iave
**endin**


**</CsInstruments>**
**<CsScore>**

**i** 1 0 1  100  200

**i** 1 1 1  1000 2000

**</CsScore>**
**</CsoundSynthesizer>**


```


This csd will print the following output:
```csound
a = 150
B  0.000 ..  1.000 T  1.000 TT  1.000 M:      0        0
a = 1500
B  1.000 ..  2.000 T  2.000 TT  2.000 M:      0        0
```

### Local instrument scope


Sometime you want Python variables to be global, and sometimes you may want Python variables to be local to the instrument instance. This is possible using the local Python opcodes. These opcodes are the same as the ones shown above, but have the prefix *pyl* instead of *py*. There are opcodes like *pylruni*, *pylcall1t* and *pylassigni*, which will behave just like their global counterparts, but they will affect local Python variables only. It is important to have in mind that this locality applies to instrument instances, not instrument numbers.
 You can think of local python calls as behaving like i-rate (or init) variables within instruments, and non-local versions behaving like global variables. Each instrument instance or note holds a unique and independent value for each i-rate variable, while global variables affect all instruments, as can be seen here:

```csound
<CsoundSynthesizer>
<CsInstruments>

gkprint init 0

instr 1
ivalue init p4
ktrig changed gkprint
if (ktrig == 1) then
  printk 0.5, ivalue
endif
endin

instr 2
gkprint init 1
endin

</CsInstruments>

<CsScore>
;          p4
i 1 0 5   100
i 1 1 5   200
i 1 2 5   300
i 1 3 5   400

i 2 3 1
</CsScore>
</CsoundSynthesizer>

```


This Csound File will print the following, showing that all ivalue variables hold a different value at the same time for each individual note:
```csound
 i   1 time     3.00023:   100.00000
```

```csound
 i   1 time     3.00023:   200.00000
```

```csound
 i   1 time     3.00023:   300.00000
```

```csound
 i   1 time     3.00023:   400.00000

```


In the same way, the local versions of the python opcodes store information which is local to a particular note. This can be seen in this example which does the same as above, but storing the values in local python variables.
```csound
<CsoundSynthesizer>
<CsInstruments>

pyinit

gkprint init 0

instr 1
;assign 4th p-field to local python variable "value"
pylassigni "value", p4
ktrig changed gkprint

; If gkprint has changed (i.e. instr 2 was triggered)
; print the value of the local python variable "value"
if (ktrig == 1) then
  kvalue pyleval "value"
  printk 0.5, kvalue
endif
endin

instr 2
gkprint init 1
endin

</CsInstruments>

<CsScore>
;          p4
i 1 0 5   100
i 1 1 5   200
i 1 2 5   300
i 1 3 5   400

i 2 3 1
</CsScore>
</CsoundSynthesizer>

```


This file will print the same values as the previous one. Notice that the 4th p-field for each instance or note is stored in a local python variable called "value". Even though all instances of the instrument use the same name for the variable, since we are using pylassign and pyleval, they are local to the note.

### Triggered versions of python opcodes
 All of the python opcodes have a "triggered" version, which will only execute when its trigger value is different to 0. The names of these opcodes have a "t" added at the end of them (e.g. pycallt or pylassignt), and all have an additional parameter called ktrig for triggering purposes. See the example in the next chapter for usage.



## III. Simple Markov chains using the Python opcodes


Python opcodes can simplify the creation of complex data structures for algorithmic composition. Below you'll find a simple example of using the Python opcodes to generate Markov chains for a pentatonic scale. Markov chains require in practice building matrices, which start becoming unwieldy in Csound, especially for more than two dimensions. In Python multi-dimensional matrices can be handled as nested lists very easily. Another advange is that the size of matrices (or arrays) need not be known in advance, since it is not necessary in python to declare the sizes of arrays.

The file has explanations intermixed with the code (just be sure to take them out if you copy/paste into an editor). You can get this and the other examples from this article in the file [journalpython.zip](https://csoundjournal.com/journalpython.zip).

```csound
**<CsoundSynthesizer>**
**<CsInstruments>**

**sr**=44100
**ksmps**=128

**nchnls**=2

**pyinit**
**

```
 The python code below, run at initialization, creates a matrix for the markov chain definition. Notice that the matrix is created as a vector of vectors. Each vector contains the normalized probability for each of the five notes. It also defines the function for generating a new note from a present note called "get_new_note". It uses the random() function from the random module to generate random number values. This shows that you can use any python module within Csound, including graphics modules like wxPython, sqlite3 for database mangement or even dom or sax for XML parsing.

```csound
**pyruni** {{c = [0.1, 0.2, 0.05, 0.4, 0.25]
d = [0.4, 0.1, 0.1, 0.2, 0.2]
e = [0.2, 0.35, 0.05, 0.4, 0]
g = [0.7, 0.1, 0.2, 0, 0]
a = [0.1, 0.2, 0.05, 0.4, 0.25]

markov = [c, d, e, g, a]

import random

random.seed()

def get_new_note(previous_note):
    number = random.random()
    accum = 0
    i = 0
    while accum < number:
        accum = accum + markov[int(previous_note)] [int(i)]
        i = i + 1
    return i - 1.0

}}

```
 Instrument 1 is in charge of executing the python function "get_new_note" and of spawing instrument 2 (which generates the sound) at a constant rate determined by p-field 4. You can generate several simultaneous notes for instrument 1, to create polyphony, and give each instance a different frequency for note generation, and a different octave using p-field 5.

```csound
 **instr **1 *;Markov chain reader and note spawner*
*;p4 = frequency of note generation*
*;p5 = octave*

ioct **init** **p5**
klastnote** init 0 ***;Used to remember last note played (start at first note of scale)*
ktrig **metro** **p4** *;generate a trigger with frequency p4*

knewnote **pycall1t** ktrig, "get_new_note", klastnote *;get new note from chain*
**schedkwhen** ktrig, 0, 10, 2, 0, 0.2, knewnote, ioct *;launch note on instrument 2*
klastnote = knewnote *;New note is now the old note*

**endin
**
```
 Instrument 2 is spawned from instrument 1 using the opcode schedkwhen. It produces a simple sine wave, but it's not hard to use more complex or interesting sounds. When spawned, the instrument is given 2 p-fields, which tell it which note to produce and on which octave (in pitch class format, but separating octave from note). You could produce articulation or other control data from python as well and pass it to the instrument through additional p-fields.

```csound
**
** **instr **2 *;A simple sine wave instrument*
*;p4 = note to be played*
*;p5 = octave*
ioct **init** **p5**

ipclass **table** **p4**, 2
ipclass = ioct + (ipclass / 100) *; Pitch class of the note*
ifreq = **cpspch**(ipclass) *;Note frequency in Hertz*

aenv **linen** 6000, 0.05, **p3**, 0.1 *;Amplitude envelope*
aout **oscil**  aenv, ifreq , 1 *;Simple oscillator*

**outs** aout, aout

```

```csound
**endin**

**</CsInstruments>**
**<CsScore>
**
```
 The score defines a simple sine wave in table 1, to be used as waveform for the sound and defines the pitch classes of the scale to be used in table 2. Changing these values will change the scale generated by the orchestra.
 Notice that new layers of polyphony (on different octaves and at different rates) are added every 5 seconds.

```csound
**f** 1 0 2048 10 1 *;sine wave*

**f** 2 0 8  -2  0  2  4  7 9  *;Pitch classes for pentatonic scale*

*;        frequency of       Octave of*
*;        note generation    melody*
**i** 1 0 30      3               7
**i** 1 5 25      6               9

**i** 1 10 20     9               10
**i** 1 15 15     1               8**
</CsScore>**
**</CsoundSynthesizer>**
```

##  Examples


[Download all examples](https://csoundjournal.com/journalpython.zip)
##  References


[www.python.org](http://www.python.org/)

[www.diveintopython.org](http://www.diveintopython.org/)

[The Python opcodes page in the Csound Manual](http://www.csounds.com/manual/html/py.html)

[Documentation for the Python random module](http://docs.python.org/lib/module-random.html)

[1](https://csoundjournal.com/#sdfootnote1anc)The fact that Python is interpreted and weakly typed is one of the reasons it is not an extremely efficient language like C or C++, which is why it finds greater use for scripting and prototyping.

[2](https://csoundjournal.com/#sdfootnote2anc)It's important to be aware that frontends only show the output of Csound in their console window or display. If using a frontend, run it from a DOS prompt or Terminal to see Python's output there.
