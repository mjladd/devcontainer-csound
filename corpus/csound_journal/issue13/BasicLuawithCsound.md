---
source: Csound Journal
issue: 13
title: "Basic Lua with Csound"
author: "Michael Gogins are acknowledged"
url: https://csoundjournal.com/issue13/BasicLuawithCsound.html
---

# Basic Lua with Csound

**Author:** Michael Gogins are acknowledged
**Issue:** 13
**Source:** [Csound Journal](https://csoundjournal.com/issue13/BasicLuawithCsound.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 13](https://csoundjournal.com/index.html)
## Basic Lua with Csound
 Jim Hearon
 j_hearon AT hotmail.com
## Introduction
 This article discusses basic Lua script examples that use the Csound Lua interface and the SWIG-wrapped Lua library luaCsnd. It also explains the approach to utilizing certain Csound API methods via luaCsnd, as pure Lua, and also for embedded Lua. A basic background for Lua as a lightweight scripting language is provided with simple comparisons to Java and JavaScript. Previous examples employing Lua and Csound by Michael Gogins are acknowledged, as well as help from Victor Lazzarini utilizing the *pvsin* and *pvsout* opcodes .
##  I. luaCsnd


 Versions of software used for this article were Fedora 10, Lua 5.14, and Csound 5.11 with API version 2.02. In order to utilize the library luaCsnd, Lua must be installed on your machine. The typical Linux installation places the Lua compiler, luac, and virtual machine, lua, applications in /usr/bin. Additionally, an empty folder is created as /usr/lib/lua/lua5.1 for external libs. The configure option "buildLuaWrapper" in the Csound source code file SConstruct, will attempt to build the luaCsnd library employing the SWIG-generated wrapper code in interfaces/lua_interface_wrap.cc. Additionally libcsnd.so is built by Csound which is used by all Csound wrapper libraries[[1]](https://csoundjournal.com/#ref1).

 For Lua there is no easily readable code available for inspecting the wrapped Csound API methods. However a somewhat useful tool on Linux is to inspect the contents of a library to reveal a partial list of objects using the 'nm' command.
```csound

>nm luaCsnd.so | tee myfile.txt

```
 This shows a partial(edited) list of objects in luaCsnd.so and writes the results to a .txt file.

 Lua is often called lightweight, and is a scripting language which, like Java, is compiled and runs interpreted byte code[[2]](https://csoundjournal.com/#ref2). The Lua script is usually written in a text editor and saved and run as a .lua file. The lua command invokes the Lua compiler, luac, which translates programs written in Lua into binary code, and the virtual machine, lua, interprets the binary code at runtime. Unlike Java, and more like JavaScript, the interpreted byte code step is transparent for the user in Lua. Normally if no instructions are given for compilation, the Lua compiler outputs to a binary luac.out file which is then run on the Lua virtual machine. The user is generally not concerned with the byte code file while running a .lua script[[3]](https://csoundjournal.com/#ref3).

 There are many differences between Lua and programming languages such as C or C++, but because Lua is considered lightweight or an extension programming language, it is suitable for scripting purposes. Lua is dynamically typed, and variables do not have types;only the values of those variables do. There are no type definitions and all values carry their own type[[4]](https://csoundjournal.com/#ref4), so that when csound.h methods are wrapped by SWIG and called from the Lua Interface, those method parameters and values are typed at runtime. Since variables are not assigned a type, this can be a challenge when coding calls to CsoundAPI methods or functions which are strongly typed and include the use of pointers. Michael Gogins has included .lua files from the Csound sources interfaces folder, and additional files from the examples/lua folder in the Csound source code; all of which utilize the library luaCsnd.
## II. Pure Lua


 Once Lua is installed and libCsnd is built, a .lua script file is easily run from the command line using the lua command.
```csound

> lua myfile.lua

```


 If the .lua file contains "require luaCsnd", then the script should be able to access SWIG-generated Lua wrappers for the Csound API available through the luaCsnd library, however path issues may arise when using the "require" statement. On the Fedora10 installation of Lua5.14, placing a copy of a library or a symlink to it, in /usr/lib/lua/lua5.1 seemed to solve the "library not found" issue.

 Lua has many Addons and external packages for tools, bindings, graphics, and utilities, some of which come in the form of pure Lua, but others utilize compiled libraries. Thus in addition to basic Lua for scripting and employing the Lua C API, much more functionality can be gained by additional Addons and external libraries[[5]](https://csoundjournal.com/#ref5). However after briefly working with graphics bindings such as tklua, Lua FLTK, gllua, and wxLua to investigate possibilities for a simple Lua frontend to Csound, it was decided to pursue an alternative approach to using the interface which is outlined in the examples below.
### Example1


 Printinfo.lua is a simple script which demonstrates basic Csound API instantiation methods and attributes, as well as a basic message, and a short performance thread which plays a sine wave using a .csd file. If run successfully using the lua command (>lua printinfo.lua), the script should display basic information about Csound such as version, API version, sample rate, k-rate, number of channels etc. The script contains the "require luaCsnd" statement and is a simple test if the Lua installation can locate the luaCsnd library, and utilize it effectively.
```csound

*** PRECOMPILE result **** = 	0
*** GETVERSION result **** = 	5.111
*** GETAPIVERSION result **** =	2.02
*** GETSR result **** = 	44100
*** GETKR result **** = 	4410
*** GETKSMPS result **** = 	10
*** GETNCHNLS result **** = 	1
*** GET0DBFS result **** = 	32768
**** A MESSAGE FROM MYCSOUND API ****


```


 Various issues may result from attempting to run pure Lua accessing the Csound library luaCsnd such as non-standard installations of Lua, non-standard installations of Csound, Load Library path, Csound environment variables, sound card drivers and settings, csoptions flags, etc., Using pure Lua is a good way to troubleshoot before moving on to more advanced applications since Lua will print a variety of error messages.
### Example2


 The second example employs a .lua script which sends a frequency to an oscillator via the *chani* bus opcode at the k-rate. All example files for this article may be downloaded here: [Lua_Examples.zip](https://csoundjournal.com/Lua_Examples.zip)
```csound

chn_k "pitch", 1
gifn ftgen 1,0, 16384, 10, 1, .5, .33, .25, .2, .16, .14, .12, .1, .9, .8, \
.7, .6, .5

	instr	1
           k1   chani     1
		;printk2   k1
           a1   oscil     5000, k1, 1
                out      a1
	endin
------
require "luaCsnd"
csound = luaCsnd.Csound()
args = luaCsnd.CsoundArgVList()

        args.Append(args, "csound")
        args.Append(args, "-s")
        args.Append(args, "-d")
        args.Append(args, "-+rtaudio=ALSA")
        args.Append(args, "-odac:hw:0,0")
        args.Append(args, "-b1024")
        args.Append(args, "-B16384")
	csd = "chanitest.csd"
        args.Append(args, csd)

	result = csound:Compile(args.argc(args), args.argv(args))

	if result == 0 then
	 	while csound:PerformKsmps()== 0 do
		 	csound:ChanIKSet(400, 1)
		end
	end

	csound:Reset()
	args:Clear()

```

### Example3


 The third example of pure Lua is a script which calls a simple .csd file which plays a sine wave using the *oscil* opcode. While the .csd is playing the sine, the Lua script changes the table at k-rate performance time to a square wave using the CsoundAPI TableSet Method. Part of the script is shown below, which is a performance loop. If the script is working correctly you should hear something close to a square wave instead of the sine which is indicated in the f-statement in the .csd file (f2 0 512 10 1).
```csound

result = csound:Compile(args.argc(args), args.argv(args))

mytab = 2
myindex = 0
myvalue = 0.00

if result == 0 then
    while csound:PerformKsmps()== 0 do
		while myindex < csound:TableLength(mytab) do
		csound:TableSet(mytab, myindex, myvalue)
		myvalue = 2*((myindex/csound:TableLength(mytab)) -
 math.floor((myindex/csound:TableLength(mytab)) + 1/2)) --sawtooth shape
		myindex	= myindex + 1
		end
	end
end

```

##  III. Embedded Lua

### Example 4


 Lua can be embedded in C/C++, thus C/C++ is calling Lua, and Lua can also be employed to define functions within C or C++. Those functions, defined with Lua API calls, can be called from .lua. Thus Lua can also call C functions or C++ methods. Normally embedded Lua code in C/C++ will call a C function or C++ method which calls a .lua script file[[6]](https://csoundjournal.com/#ref6). One benefit of using Lua embedded in C/C++ is that once the .cpp is compiled and an executable created, the .lua script can be easily modified and the result of its output tested without recompilation of the .cpp file since the .exe is running a script. For very large applications simply revising the Lua script to yield new test results can be more efficient than recompiling the whole large C or C++ application.

 This approach can be utilized effectively in gaming where say for example the goal may be something simple with graphics, and the Lua script is performing the task of altering the graphics in some manner, while the C or C++ code is part of a larger body of code used for lower level functions. The graphics could be more easily fleshed out by running the compiled executable again and again while tweaking the .lua script to refine the graphics.

 To give an example of how a Lua script might be used with Csound somewhat in the manner of the graphics approach outlined above, a script was coded to manipulate a text file of pvs data as amplitude frequency pairs (*pvsanal* iformat 0 = amplitude + frequency). The approach of the example was to allow the C code to create a performance loop, sending pvs data to the *pvsin* opcode via the Csound API pvs bus, while the .lua code was employed to modify the pvs text file without recompiling the C++ executable. The purpose of the example was to demonstrate embedded Lua using the CsoundAPI. Users of phase vocoding data know that analysis files can become large quickly, thus the example works best with small amounts of analysis data.

 Initially a .csd file provides analysis of an Erhu sample and sends the data to the pvsbus using the *pvsout* opcode. A CSV (comma separated values) text file of pvs data was saved by a C++ program using the Csound API method PvsoutGet to receive the data from the bus(V. Lazzarini, Csound Dev List communication regarding *pvsout*, and help with data structure PVSDATEXT, December, 2009). Figure 1 below is a diagram of the approach to saving the pvs data as CSV file for manipulation by a Lua script[[7]](https://csoundjournal.com/#ref7).  ![](images/Lua_flowleft.jpg) **Figure 1:** Chart of approach to saving pvs data.

 Once you have a CSV file of data, then the embedded Lua example approach can be used to manipulate the data before it is performed by another C or C++ program employing the Csound API method PvsinSet, and resynthesized by Csound using the *pvsin* opcode to retrieve the data from the pvsbus. Figure 2 below is a diagram of the approach to CSV pvs iformat 0 data manipulation employing embedded Lua.  ![](images/Lua_flowright.jpg) **Figure 2:** Chart of data manipulation employing embedded Lua.

 The following is an example of Lua Script to read amplitude, frequency data from a CSV file, perform very simple manipulation on the data and save it to disk. The script is called from Lua embedded in a .cpp file which is shown in the example files listed above.
```csound

  t_odd = {}        -- table to collect odd fields(amp)
  t_even = {}       -- table to collect even fields(freq)
  t_all = {}        -- table to collect all fields
  mycntr = 1        -- global var as counter

-- Convert from CSV string and write to a table as number
function fromCSV (s)
  s = s .. ','        -- ending comma
  local fieldstart = 1   -- local variable
  repeat
      i  = fieldstart
      local nexti = string.find(s, ',', fieldstart)

      if (mycntr % 2 == 1) then
      table.insert(t_odd, mycntr, tonumber(string.sub(s, fieldstart, nexti-1)))
      else
      table.insert(t_even, mycntr, tonumber(string.sub(s, fieldstart, nexti-1)))
      end
      mycntr = mycntr + 1
      fieldstart = nexti + 1
    until fieldstart > string.len(s)

--checking against a nil value being accidentally entered
for i=1, mycntr-1 do
      if(t_odd[i] == nil)then
       t_odd[i] = t_odd[i-1]
      end
end
for i=1,mycntr-1 do
      if (t_even[i] == nil) then
	t_even[i] = t_even[i-1]
      end
end

return t_odd, t_even
end

-- Do math on table numbers and merge to one table as a string
function tableMath (t, tt)
local ampval = 2.1234
local freqval = 400.0

for i=1,mycntr-2 do
      if (i % 2 == 1 and t_odd[i]~= nil) then
		if (t_odd[i] >= 0.01) then
		t_odd[i] = t_odd[i] + ampval --increase gain
		else
		t_odd[i] = t_odd[i]
		end
        t_all[i] = tostring(t_odd[i].. ",")--comma is added to table entry
      elseif (i % 2 == 0 and t_even[i] ~= nil) then
		if (t_even[i] >= 400.00 and t_even[i] < 22050) then
		t_even[i] = t_even[i] + freqval -alter frequencies
		else
		t_even[i] = t_even[i]
		end
	t_all[i] = tostring(t_even[i].. ",")--comma is added to table entry
     end --end if
    end --end for

return table.concat(t_all)--this makes one string from the table
end --end function

filename = "Erhu.txt"
file = assert(io.open(filename, "r+"))--a+, or r+
file2 = assert(io.open("Erhu2.txt", "w"))--a+, or r+
stringOne = file:read("*all")    --read it all
	--print("input:\n"..stringOne)
fromCSV(stringOne)
stringTwo=tableMath(t_odd, t_even)
	--print("output:\n"..stringTwo)
file2:write(stringTwo) --write the new data
file:close()
file2:close()

```


 To compile the embedded Lua example from the command line you also need to link to Lua (-llua) and Csound (-lcsound64).
```csound

g++ luaembed.cpp -o luaembed -I/opt/csound511/H -L/opt/csound511 -I/dl
 -lcsound64 -llua

```

##  IV. Conclusion


 Manipulation of pvs data is done more straightforwardly in Csound employing any of the pvs opcodes such as *pvsblur*, *pvsmorph*, *pvshift*, etc. from within a .csd. The example above is intended to demonstrate just one approach to employing a .lua script as embedded Lua in C/C++, and show how a script might be utilized effectively to modify test values without recompiling the C/C++ sources. The embedded Lua script manipulates pvs data, and the executable can be rerun, calling Csound to hear the results.

 Lua has many Addons and bindings and may be useful for working with Csound, but strongly typed Csound API methods may prove difficult for coding in Lua which is dynamically typed, where variables do not have types. The SWIG-generated wrapper essentially attempts to sort out those differences.

 The usefulness of Lua as an interface may also be compared with Python and Java since Python is embedded in Csound and Java, like Lua, has a SWIG-wrapped CsoundAPI library. The speed of pure Lua over Java is apparent due to the transparent step of running byte code, however Lua is more comparable to JavaScript than to the Java Language in that regard. It should be noted that alternatives to Lua exist such as LuaJIT which can easily be used with the library luaCsnd.([http://luajit.org/](http://luajit.org/))

 While the luaCsnd wrapper, as interface for Csound, has not yet been widely employed in creative applications, it may be that Lua scripting might prove beneficial in someway within the larger scope of Csound sources, since compilation for the entire Csound application can take a fair amount of time, depending on the various options selected.
## References


 [[1]] Vercoe, Barry, et. al. (1992). *Csound* (Version 5.12) [Software]. "SConstruct" from *Csound* by Michael Gogins. Available from [http://csound.sourceforge.net/](http://csound.sourceforge.net/)

 [[2]] Lua. (2010, February 7). In *Wikipedia*, the free encyclopedia. Retrieved February 7, 2010, from [http://en.wikipedia.org/wiki/Lua_(programming_language)](http://en.wikipedia.org/wiki/Lua_(programming_language))

 [[3]] Ierusalimschy, R., Henrique de Figueiredo, L., and Celes, W. *Reference Manual of the Programming Language Lua 4.0*. Retrieved Februrary 7, 2010 from [http://www.lua.org/manual/4.0/luac.html](http://www.lua.org/manual/4.0/luac.html)

 [[4]] Ierusalimschy, R., Henrique de Figueiredo, L., and Celes, W. *Reference Manual of the Programming Language Lua 5.1*. "Section 2.2 Values and Types", retrieved Februrary 7, 2010 from [http://www.lua.org/manual/5.1/manual.html#2](http://www.lua.org/manual/5.1/manual.html#2)

 [[5]] Lua Addons. (2010, February 7). From *lua-users wiki*. Retrieved February 7, 2010, from [http://lua-users.org/wiki/LuaAddons](http://lua-users.org/wiki/LuaAddons)

 [[6]] Ierusalimschy, Roberto. *Programming in Lua*, first edition(online version). "Part IV. The C API". Available from [http://www.lua.org/pil/index.html](http://www.lua.org/pil/index.html)

 [[7]] Csound Utilities PVLOOK allows users to view formatted text output of STFT analysis files (amp and freq bins with header information) and PV_EXPORT converts a file generated by *pvanal* to a text file. These utilities provide different formats of CSV files with header information.
### Additional Links and Information


 Several general Lua tutorials are available online at:
 [http://lua-users.org/wiki/TutorialDirectory](http://lua-users.org/wiki/TutorialDirectory)

 See also the Sample Code section at the lua-users wiki:
 [http://lua-users.org/wiki/SampleCode](http://lua-users.org/wiki/SampleCode)

 A good tutorial for embedded Lua with heavy comments:
 [http://heavycoder.com/tutorials/lua_embed.php](http://heavycoder.com/tutorials/lua_embed.php)

 A Simple Lua Api Example:
 [ http://lua-users.org/wiki/SimpleLuaApiExample](http://lua-users.org/wiki/SimpleLuaApiExample)

 Information on Lua Rocks:
 [http://luarocks.org/repositories/rocks/](http://luarocks.org/repositories/rocks/)
