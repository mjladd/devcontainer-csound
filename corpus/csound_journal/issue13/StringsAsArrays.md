---
source: Csound Journal
issue: 13
title: "Working With Strings As Arrays in Csound"
author: "Istvan Varga in"
url: https://csoundjournal.com/issue13/StringsAsArrays.html
---

# Working With Strings As Arrays in Csound

**Author:** Istvan Varga in
**Issue:** 13
**Source:** [Csound Journal](https://csoundjournal.com/issue13/StringsAsArrays.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 13](https://csoundjournal.com/index.html)
## Working With Strings As Arrays in Csound

### Designing a Sub-Language with the String Opcodes


Joachim Heintz
 jh AT joachimheintz.de
##  Introduction


Csound has no proper data structure for a collection of elements (numbers, symbols, strings)[[1]](https://csoundjournal.com/#ref1). Other languages call these collections arrays or lists. This article is about to show how such an array can be built in Csound in a user definable way as a string.

##  I. Csound's String Opcodes


The string opcodes, implemented in Csound by Istvan Varga in 2005, offer all the necessary tools for working with strings as arrays. This is a short overview over some of those opcodes:

*sprintf* generates a string variable by a format string:
```csound
Svar sprintf "%s: %d, %f, %.5f.", "Some numbers", 1, 4/3, sqrt(2)
puts Svar, 1
-> 'Some numbers: 1, 1.333333, 1.41421'
```


*strlen* returns the length of a string:
```csound

ilen strlen "Some numbers: 1, 1.333333, 1.41421."
prints "%d", ilen
-> '35'
```


*strindex* returns the position of the first occurrence of string S2 in string S1:
```csound

ipos strindex "Some numbers: 1, 1.333333,1.41421.", "m"
prints "%d", ipos
-> '2'
```


*strsub* extracts a portion of a string by indexing the start and end:
```csound

Ssub strsub "Some numbers: 1, 1.333333,1.41421.", 5, 11
puts Ssub, 1
-> 'number'
```


*strtod* converts a numerical string back to a number:
```csound

inum strtod "1.333333"
prints "%f", inum
-> '1.333333'
```


All these opcodes have a counterpart for working at the k-rate (*sprintfk*, *strlenk*, etc).

Csound is very restricted in dealing with strings: just one string in a score line, no string output in user defined opcodes, etc[[2]](https://csoundjournal.com/#ref2). In many situations you need the help of *strset* and *strget*:
- *strset* links a string with a number
- *strget* gets the string back from this number
```csound

strset 1, "Some numbers: 1, 1.333333, 1.41421."
Sback strget 1
-> 'Some numbers: 1, 1.333333, 1.41421.'
```

##  II. Drafting Opcodes for Strings as Arrays


As working with strings as arrays in Csound means writing user defined opcodes (UDO), the user must first decide how he wants to use strings as arrays, and which opcodes he needs as tools. Typical situations are the following ones:
- Getting an element (token) by indexing: *StrayGetEl* and *StrayGetNum*. This is similar to the use of the *tablei* or *tab_i* opcodes for function tables in Csound.
- Inserting an element by indexing: *StraySetEl* and *StraySetNum*. This is similar to the use of the *tableiw* or *tabw_i* opcodes for function tables in Csound.
- Getting the number of elements: *StrayLen*.
- Removing duplicates: *StrayRemDup*.
- Testing whether an element is a numerical string: *StrNumP*;* *or whether a string or a number is a member of the array-string: *StrayElMem* or *StrayNumMem*.
- Checking the number of numerical elements: *StrayNumLen*; converting a string of numbers or mathematical expressions to a function table: *StrayNumToFt*; calculating the sum in such a string: *StrayNumSum*.

The next section describes the syntax of these opcodes and gives general examples. The definition, and working examples of each User Defined Opcode can be found in the example code files. All the example files for this article, including .csd, .sh, and .inc files are available here in [StraysExs.zip](https://csoundjournal.com/StraysExs.zip).
### Getting Elements by Indexing

```csound
iselst, iselend **StrayGetEl** Stray, ielindx [, isep1 [, isep2]]
```


Gets the *ielindx* element of a string. By default, the elements are separated by spaces (*isep1* = 32) or tabs (*isep2* = 9). Others characters can be defined by their ASCII codes. If just *isep1* is defined, it is the only separator. If you want two separators which are different from spaces and tabs, you must give both arguments, for instance *isep1*=44 and *isep2*=32 for using commas and spaces.

 At present no UDO can return a string, so *iselst* and *iselend* are returned. From them, the actual element can be extracted as a string.
```csound

Stray = "The ASCII code of a comma (,) is 44"
isel1, isel2 StrayGetEl	Stray, 2
Sel strsub isel1, isel2
puts Sel, 1
->'code'
```

```csound

Stray = "Audio 01.wav|Audio 02.wav|Audio 03.wav|Audio 04.wav"
isel1, isel2 StrayGetEl	Stray, 1, 124
Sel strsub isel1, isel2
puts Sel, 1
-> 'Audio 02.wav'
```

```csound

Stray = "Audio 01.wav|Audio 02.wav|Audio 03.wav|Audio 04.wav"
isel1, isel2 StrayGetEl	Stray, 1, 124, 32
Sel strsub isel1, isel2
puts Sel, 1
->'01.wav'
```

```csound
inum **StrayGetNum **Stray, ielindx [, isep1 [, isep2]]
```


If the *ielindx* element of *Stray* is a number, it can be returned straightforwardly.
```csound

Stray = "The ASCII code of a comma (,) is 44"
inum StrayGetNum Stray, 8
prints "%f", inum
->'44.000000'
```

```csound

Stray = "44,can,not,be,called,a,number."
inum StrayGetNum Stray, 0, 44
prints "%f", inum
->'44.000000'
```

### Writing Elements by Indexing

```csound
**StraySetEl** Stray [, istrin [, ielindx [, istrout] [, isep1 [, isep2]]]]
```


This is very difficult to use at the moment because of the restrictions on working with strings (which will hopefully be resolved soon). This opcode should have two strings as input and one string as output. But it can take just one string as input, and no string as output. So the *strset* ability must help: *istrin* is the *strset* number (default = 0) which contains the new element to be put in *Stray*, and *istrout* (default = 1) is the *strset* number which contains the modified input string *Stray*. By default, *ielindx *is -1 which means that the new element is appended at the end of *Stray*.
```csound

Stray = "the number 1 is not a"
strset 0, "bubu"
StraySetEl Stray
Sres strget 1
puts Sres, 1
->'the number 1 is not a bubu'
```

```csound

strset 10, "bubu"
StraySetEl Stray, 10, 1, 100
Sres strget 100
puts Sres, 1
->'the bubu number 1 is not a'
```

```csound
**StraySetNum** Stray, inum [, ielindx [, istrout] [, isep1 [, isep2]]]]
```


With numbers as input, it is a bit easier. At least you can pass the number as input. But the output has to be encoded in a *strset* number, (default = 1), too. Like in *StrSetEl*, *ielindx* defaults to -1 (= append).
```csound

Stray = "1 2 a b"
StraySetNum Stray, 3
Sres strget 1
puts Sres, 1
->'1 2 a b 3'
```

```csound
StraySetNum Stray, 3, 2, 100
Sres strget 100
puts Sres, 1
->'1 2 3 a b'
```

### Length (number of elements)

```csound
ilen **StrayLen** Stray [, isep1 [, isep2]]
```


Returns the number of elements in *Stray*. Like in *StrayGetEls*, elements are defined by two separators as ASCII coded characters: *isep1* defaults to 32 (= space), *isep2* defaults to 9 (= tab). If just one separator is used, *isep2 *equals *isep1*.
```csound

ilen StrayLen {{these are "not" 5 elements -}}
print ilen
->'6'
```

```csound

ilen StrayLen "seperation just, by commas", 44
print ilen
->'2'
```

```csound

ilen StrayLen "seperation by,commas,or  spaces", 44, 32
print ilen
->'5'
```

### Removing Duplicates

```csound
**StrayRemDup** Stray [, istrout [, isep1 [, isep2]]]
```


Removes duplicates in *Stray* and returns the result in the strset number *istrout* (default = 1). The use of the separators *isep1* and *isep2* is similar to *StrayGetEl* or *StrayLen*.
```csound
StrayRemDup "1 a 2 a b 3 1"
Sres strget 1
puts Sres, 1
->'1 a 2 b 3'
```

### Tests

```csound
itest** StrNumP **Stray
```


Looks whether a string is a numerical string - which can be converted by the *strtod* opcode -, and returns 1/0 for yes/no.
```csound
itest StrNumP "3.456"
prints "%d", itest
->'1'
```

```csound
itest StrNumP "3.456/2"
prints "%d", itest
->'0' (does not accept math expressions)
```

```csound
itest** StrayElMem **Stray [, istrin [, isep1 [, isep2]]]
```


Looks whether a string which is given as the *strset* number *istrin* (default = 0) and is equal to one of the elements in *Stray*. If yes, *itest* returns 1, if no, 0. The use of the separators *isep1* and *isep2* is similar to *StrayGetEl* or *StrayLen*.
```csound
strset 0, "a"
itest StrayElMem "sdhgfa elh 4 876"
prints "%d", itest
->'0'
```

```csound
itest StrayElMem "sdhgf a elh 4 876"
prints "%d",itest
->'1'
```

```csound
itest **StrayNumMem** Stray, inum [, isep1 [, isep2]]
```


Looks whether a number *inum* is a member of *Stray*. If yes, *itest* returns 1, if no, 0. The use of the separators *isep1* and *isep2* is similar to *StrayGetEl* or *StrayLen*.
```csound
Stray = "sdhgfa elh 4,876"
itest StrayNumMem Stray 4
prints "%d", itest
->'0'
```

```csound
itest StrayNumMem Stray, 4, 44
prints "%d", itest
->'0'
```

```csound
itest StrayNumMem Stray, 4, 44, 32
prints "%d", itest
->'1'
```

### Miscellaneous Opcodes for Numbering Strings

```csound
ilen **StrayNumLen** Stray [, isep1 [, isep2]
```


Returns the number of numerical elements in *Stray*. Like in *StrayGetEls*, elements are defined by two separators as ASCII coded characters: *isep1* defaults to 32 (= space), *isep2* defaults to 9 (= tab). If just one separator is used, *isep2 *equals *isep1*.
```csound
ilen StrayNumLen "these 1 are 2 not 5 elements -3 .009"
print ilen
->'5'
```

```csound
ift, ilen **StrayNumToFt** Stray [, iftno [, isep1 [, isep2]]]
```


Puts all numbers in *Stray* (which must not contain non-numerical elements) in a function table and returns its variable *ift* and its length *ilen*. Simple mathematical expressions like +, -, *, /, ^ and % are allowed (no parentheses at the moment). For practical reasons, 2^1/12 is resolved as 2^(1/12).
```csound
Stray = "1+2.7  2^1/12  3.10*65  27%6"
ift, ilen StrayNumToFt Stray
prints "ift = %d ilen = %d%n", ift, ilen
->'ift = 101 ilen = 4'
TableDumpSimp ift, 5
->'3.70000 1.05946 201.50000 3.00000'
```

```csound
isum **StrayNumSum** Stray [, isep1 [, isep2]]]
```


Sums all numbers in *Stray* (which must not contain non-numerical elements) and returns the result as *isum*. Simple math expressions like +, -, *, /, ^ and % are allowed (no parentheses at the moment). For practical reasons, 2^1/12 is resolved as 2^(1/12).
```csound
Stray = "1+2.7  2^1/12  3.10*65  27%6"
isum StrayNumSum Stray
prints "%f", isum
->'209.259460'
```


A complete collection of these UDOs can be found in the file StrayUDOs.inc in the "StraysExs.zip" file listed above. If you include this file via an #*include* statement,[[3]](https://csoundjournal.com/#ref3) you can use any of the UDOs.
## III. Some Applications for Strings as Arrays[ [4]](https://csoundjournal.com/#ref4)


There are many situations in which the usage of strings as arrays can be helpful. In a future issue of the *Csound Journal*, I'd like to show its use in sound spatialization. For example, the string "1 3 3,4,5 10 2,8 3 2,8 5 1" could be interpreted as: "Let the sound move from speaker 1 in 3 seconds to speaker 3, 4 and 5; then in 10 seconds move to speaker 2 and 8; stay there for 3 seconds; go back to speaker 1 in 5 seconds."

The following are three small examples in which the Stray UDOs are useful: working with the user input from a GUI widget, simplifying the creation of GEN02 function tables, and dealing with file names.
### Getting and Transforming the User Input of a GUI Widget


The *invalue* or *chnget* opcodes can import a user input of certain widgets from a Graphical User Interface in Csound. In QuteCsound, for instance, this widget is called LineEdit. If you create a LineEdit widget with the channel "scale", you get the input as a string via this simple statement:
```csound
Stray invalue "scale"
```


But how can you work with the string called *Stray*? The defined Stray UDOs give you the ability to work with it as an array: getting the first element, performing a loop over all elements (not knowing how many there will be), or transforming the *Stray* into a function table, if *Stray* consists just of numbers.

The QuteCsound file *MIDI_Tunings.csd* from the *StraysEx.zip* gives a rather extended example for the transformation of user input via LineEdit widgets to function tables.
### Simplifying the Creation of a Function Table


Even in normal Csound Code, frequently there is a situation where you have to type values in a function table via the GEN02 routine. This is always a bit awkward, because you have to tell the table how many values you will type in, and have to separate the values by commas. The *Stray* UDOs can simplify that process. So instead of typing
```csound
iftawk ftgen 0, 0, -5, -2, 3, 5, 1, 4, 2
```


you just type[[5]](https://csoundjournal.com/#ref5)
```csound
iftnice, ilen	StrayNumToFt "3 5 1 4 2"
```


This may be useful if you have many of these tables or if the user input contains many values. As the table is created at init time, using this has no effect on the performance.
### A Shell Script For a Multichannel Mixdown


A typical situation where the Stray UDOs can be useful is to handle a set of filenames. The file "LiveMixdown.sh" from the "StraysEx.zip" makes a live mixdown of a number of mono files to any number of output channels. For instance, you can listen to an eight-channel soundfile (as 8 mono files) even if you just have stereo output. Or you can listen to 16 channels with 8 speakers, or with 5. The script asks for the number of channels and for the filenames. Then it transforms the filenames to a comma-separated list *Stray* in this manner: "/Bla/Audio01.wav,/Bla/Audio02.wav,/Bla/Audio03.wav,/Bla/Audio04.wav", (assuming that there are no commas in the filenames). This *Stray* is given to Csound, and a recursive UDO calls as many instances as there are filenames. The simple user interface is done employing FLTK widgets inside Csound shown below in Figure 1[[6]](https://csoundjournal.com/#ref6). ![](images/StraysMixdownPlayer.png)

**Figure 1:** A Strays Mixdown Player Graphical User Interface.
## Conclusion


With the string opcodes in Csound, you can define your own language for working with strings as arrays. An example of that has been shown. If you prefer another syntax or you need new opcodes: no problem - just change the string parsing UDOs or write additional ones.

Of course, the use of strings as arrays is not meant to be an alternative to the use of function tables in audio processing. The place for strings as arrays is mainly at the control of Csound, where the user wants to tell Csound what to do, in a way which is as simple and intuitive as possible.
##  Acknowledgements


 Thanks, as always, to Anna for reading the manuscript, and to Alex and Andrés for their suggestions.
## Notes


 [[1]] In many situations, a function table can be used with GEN02, but this is restricted to numbers and the table must have a fixed length.

 [[2]] This will hopefully be improved with the new parser.

 [[3]]See the file *Easier.csd* in the *StraysExs.zip* as an example for this statement.

 [[4]] If you use the Stray UDOs, make sure that you do not get any problems due to the default maximum string length of 256 characters in Csound. I would recommend to insert the flag -+max_str_len=10000 in the CsOptions tag of a .csd file to avoid problems.

 [[5]] See the file *Easier.csd* in *StraysExs.zip*, which requires the file* StrayUDOs.inc *also in the same directory.

 [[6]] For using the script, it might be necessary to type first chmod 755 /your/script/path in your command line tool, for making it executable.
