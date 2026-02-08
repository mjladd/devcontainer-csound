---
source: Csound Journal
issue: 19
title: "Using Python in Blue"
author: "Python generated scores"
url: https://csoundjournal.com/issue19/python_in_blue.html
---

# Using Python in Blue

**Author:** Python generated scores
**Issue:** 19
**Source:** [Csound Journal](https://csoundjournal.com/issue19/python_in_blue.html)

---

CSOUND JOURNAL[](https://csoundjournal.com/index.html) | [Issue 19](https://csoundjournal.com/index.html)
## Using Python in Blue

### Create Csound instruments and score with a few lines of code
 Richard van Bemmelen
 zappfinger AT gmail.com
## Introduction


In Blue[[1]](https://csoundjournal.com/#ref1), selecting a 'PythonInstrument' from the Orchestra menu allows one to use Python[[2]](https://csoundjournal.com/#ref2) code to generate a Csound[[3]](https://csoundjournal.com/#ref3) instrument. Within the Blue Score, a 'PythonObject' also allows one to use Python to generate score text. This powerful combination makes it easy to create synthesizer instruments and musical scores with a few lines of code.

This article will use a Python library named ESMSblue that contains both instrument and score generation functions. ESMS stands for Extremely Simple Music System. This library can serve as a starting point for further exploration of this subject. The first section will describe some instruments created with this library, triggered with a generic score. In the second section some additional instruments are described, triggered by Python generated scores.

Some elementary knowledge of Blue, Csound and Python is required to use this article. I also recommend exploring the examples that come with Blue.

Download example project files for this article [here](https://csoundjournal.com/downloads/python_in_blue.zip).
## I. Python-generated instruments

### Installation


To use the examples it is required to install the python library ESMSblue.py into the `$HOME/.blue/pythonLib` library folder. The two Blue projects pythonInstrument.blue, and pythonInstrumentScore.blue, along with pipe.wav can be installed into your regular Blue projects folder.

When you load one of the Blue projects you will note that the ESMSblue library is imported in a peculiar way:
```csound
import ESMSblue
reload(ESMSblue)
from ESMSblue import *
```


Why are the first two lines required? It has to do with the way Python variables are initialized in Blue, as well as the design of the library. If these first two lines are omitted (or commented out), a Python instrument using this library would double its code each time it is used or tested with the 'Test' button.
### The PythonInstrument object


To create a Python Instrument, click the '+' sign in the Orchestra tab and click on the 'PythonInstrument' selection, shown below in Figure 1.

![image](images/python_blue1.png)

**Figure 1. Select PythonInstrument in Blue from the Orchestra Menu.**

An untitled instrument appears with basic Python code in it.  ![image](images/python_blue2.png)

**Figure 2. Untitled instrument in Blue.**

The comment says to use the variable `instrument` to bring the instrument back into Blue. This must be a line or multiple lines of Csound code, separated by a `CR LF` or only a `LF`. To use a Python function to generate the Csound code, the function output should be one or more lines of Csound code that we then assign to the `instrument` variable, like so:
```csound
instrument = somefunction(args,..)

```


We could also incrementally add to the variable in the manner shown below.
```csound
instrument = function1()
instrument += function2()

```


In ESMSblue I have chosen an approach that uses pure Python to create instruments and variables. At the end of instrument generation, a call to one of the output functions from ESMSblue will add the accumulated orchestra lines to Blue's `instrument` variable, as you will see later in this article.
### Arguments, arguments...


Python function arguments are quite flexible, and to fully benefit from this fact, a little explanation is necessary. Keyword arguments[[4]](https://csoundjournal.com/#ref4) are used to pass default values to a function, when the arguments are omitted. By picking clever default values, coding effort can be reduced.

An example from ESMSblue is shown below.
```csound
def fltMoog(self, asig, kfco = 1000, kres = .2, out = 'amoog'):
```


Here the argument `asig` is required (not default), while the other arguments `kfco`, `kres` and `out` are keyword arguments. (Since this function is defined in a class, the `self` argument can be ignored here.) The keyword arguments get their value when the function is called in the manner shown below.
```csound
filter1 = fltMoog(vco())
```


The required `asig` argument of the `fltMoog` function gets the return value from the function `vco`, which is called with only default arguments. (Internally, calling the function `vco()` will create a Csound orchestra line for the `vco` opcode. The same goes for `fltMoog`, when creating a `moogvcf` orchestra line.) In this case the variable `filter1` will get the default value for `out`, being the string `amoog`. If we want to further only change the value for `kres`, we could call the function as below,
```csound
filter1 = fltMoog(vco(), kres=.5)
```


making use of the keyword argument `kres`.

Notice that I call the function with `fltMoog(vco())`, not with `someclass.fltMoog(vco())`, even though this is a class function. If you look at the end of the code in ESMSbue.py, after the class definition, you will see that one instance is created of the ESMS class and all the instance functions are converted to local function names, shown below.
```csound

c = ESMS()
# can't use c.vco(), because that would call the function, we want the address only
vco = c.vco
lfo = c.lfo
osc = c.osc
...
```


This allows us to use the local function name after the line:
```csound
from ESMSblue import *
```

### Inside a function


In the ESMS class, the function `vco()` is defined as:
```csound
def vco(self, wave = 'saw', kamp ='p4', kcps='cpspch(p5)', kpw=0.5, out='avco'):
  # avco vco xamp, xcps, iwave, kpw
  iwave = vcowaves[wave]
  self.instr += 'isin ftgenonce 0, 0, 65536, 10, 1\n'
  self.instr += '%s vco %s, %s, %s, %s, isin\n' % (out, kamp, kcps, iwave, kpw)
  return out
```


As you can see, the class variable `self.instr` (which is used as a kind of global variable) is first incremented with a line containing a `ftgenonce` opcode that generates a sine wave. Note the new line character `\n` at the end of the string. `self.instr` is next appended with the actual `vco` opcode line. That operation will yield the string:
```csound
avco vco p4, cpspch(p5), 1, 0.5, isin
```


The function `vco()` then returns the string `avco` (when left to default), to be passed as input to another function.

The final function that is called in an instrument will have to return the accumulated orchestra lines in `self.instr` to Blue's `instrument` variable. This is done in one of the output functions like `panmix`, shown in the code below.
```csound
env1 = expon()
fltVCO = fltMoog(vco(), mul(env1,3500),.3)
instrument = panmix(fltVCO, .3)
```


Notice the `mul` function here. This function multiplies its arguments, in this case the variable `env1` (containing a string) and the value 3500. The function returns a string. There is also a function called `add` that adds its arguments, as the name suggests.
### Testing and debugging


Blue has several ways to test the validity of a Python script. Of course it is a good habit to test the Python functions first in a Python only environment. When Python script is entered in a Python Instrument, the 'Test' button can be used check the validity of the script. Normally pressing the 'Test' button should bring up a screen showing the generated Csound code for the instrument. Likewise, Blue's menu item 'Project/Generate CSD to Screen' should show the total generated .csd file, containing all orchestra and score lines.

If there are errors in a script, nothing will be displayed in these cases. But pressing the 'Test' button will show a red error marker in the lower right corner of Blue's screen. Clicking on this 'Unexpected Exception' marker and again in the dialog that appears will show the error in the code, as shown below in Figure 3:  ![image](images/python_blue3.png)

**Figure 3. Script errors shown in Blue.**

Should you want to debug your Python code, it must be noted that a print statement output will not appear in the generated instrument. To see the print output, you have to use Blue's menu 'Window/Python Console'.
### Fun with the functions


It is time to see all this in action, so we will load the project pythonInstrument.blue. You can hear the 5 instruments together by pressing Blue's 'Play' button. You can also disable/enable them one by one with the [X] check mark in the orchestra manager or mute them in the score.

The first instrument, gbuzz is defined as:

`knh1 = kline(1,25, out = 'knh1') instrument = bluemix(declick(gbuzz(knh=knh1, kmul=kline())),vol=[.15,.6])`

It is a `gbuzz` opcode, multiplied with a declick envelope and then sent to the output function `bluemix`. This `bluemix` function has a `vol` argument, which is a list containing the values .15 and .6. These are the left and right volumes of the instrument, giving it a pan position in the BlueMixer channel.

The `kline` function generates a line between 1 and 25 and changes its default `out` name to `knh1`. Notice that this is then given to the variable with the same name. This is just good practice. Notice that another `kline()` function is given to the `kmul` argument of `gbuzz`. This `kline` has only default arguments, which are: `istart=1`, `iend=0`, `idur='p3'`, and `out='kline'`. This second `kline` acts as a downward envelope.

Because we use the function `kline` twice in this instrument, one of them must have a non-default output name. This is very important, otherwise the first `kline` output variable will be overridden by the second one! This is true for all ESMSblue functions that you would want to use more than once inside an instrument, except for `mul()` and `add()`.

In instrument 3, '`osc('saw') lfo pan`' consists of a One Line Synth (OLS):
```csound
instrument = panmix(declick(osc('saw')), lfo(0.3,1.5))
```


The output function `panmix` uses a `lfo(0.3, 1.5)` to pan the signal.

The `osc` functions first argument can accept the following strings: `saw`, `squ`, `tri`, `sin`, and `cos`. These strings determine the wave form: sawtooth, square, triangle, sine and cosine.

With this in mind you are invited the explore the other instruments.
## II. Python-generated score

### PythonObject


So far we have only created Csound instruments with Python. These instruments were triggered by regular GenericScore objects in Blue.

The 'PythonObject' in the Score tab of Blue allows us to create score lines as well. In this case Blue's variable `score` has to be used to return all score lines to Blue. Again, this should be a string with lines separated by `\n`.

You are invited to load the project pythonInstrumentScore.blue, located in the downloadable code for this article, and run it. This project also contains some new Python instruments, one of them being a very nice sampled bass sound derived form a cardboard pipe, named 'pipe.wav', also located within the downloadable code. What you will hear is a simple blues scheme, that seems appropriate to Blue (pun intended).

The real power of using Python becomes clear when generating score lines.
### Chords


ESMSblue uses a simple representation for notes, melodies and chords.

Looking at the 'chords@1' score object code in the Blue Orchestra tab, it shows the output shown below.
```csound
chordDict = {'C7':('c','e','g','bb'),'F7':('c','eb','f','a')}
chordpat = '1@1: C7 . F7 . | C7 , F7 , '
score += ParseChords(chordDict, chordpat, times=1)
```


Two chords, C7 and F7 are defined in a chord dictionary. A chord pattern is defined as a string, where `1@1:` means instrument 1, base length 1. The `|` symbol is used to indicate the end of a measure or pattern, but they are ignored. In fact a pattern can also consist of a few notes. The dot `.` after the chord means repeat this chord (with the base length defined earlier). A comma `,` means a rest with the duration of the base length. The function `ParseChords` uses the chord dictionary, the chord pattern and a repeat parameter (`times`) to generate the score lines. Note that the Time Behavior selection of the PythonObject in Blue is set to 'None'.
### Melodies


Score line 'bass@2' is a melody line, playing instrument 2, the 'pipe sample bass'. The code is as follows:
```csound
melpat = '2@.25: c , e , g , g f# f , a , c1 , a , |'
score += ParseMelody(melpat, times=2, length=.25, transpose = -3, vol=.5)
```


Here the function `ParseMelody()` parses the melody pattern.

Finally, the 'perc@3' object, also a melody line, uses a `ramp()` function to add accents every fourth note of a percussive instrument 3. Please look at the comments in the object for the explanation.

As you can hear and see, with just a few lines of code interesting scores can be created!
### Further exploration in the score domain


Of course this is a matter of personal taste, but I would be very interested in the exploring following score related subjects:
-  Humanization of scores by adding randomness, both in position and loudness
-  Using Markov chains to generate score / rhythmic patterns
-  Arpeggiators

These subjects are very suitable to be tackled by Python in Blue!
### Acknowledgements


I would like to thank Steven Yi, the creator of Blue, for his comments on this article.
## References


[][1] Steven Yi, "Blue." [Online]. Available: [http://www.csounds.com/stevenyi/blue/](http://www.csounds.com/stevenyi/blue/). [Accessed January 26, 2014].

[][2] Python Software Foundation, "Python." [Online]. Available: [http://www.python.org/](http://www.python.org/). [Accessed January 26, 2014].

[][3] Barry Vercoe, John ffitch et al., "Csound." [Online]. Available: [http://www.csounds.com/](http://www.csounds.com/). [Accessed January 26, 2014].

[][4] Python Software Foundation, "The Python Tutorial." [Online]. Available: [http://docs.python.org/2/tutorial/controlflow.html#keyword-arguments](http://docs.python.org/2/tutorial/controlflow.html#keyword-arguments). [Accessed January 26, 2014].
