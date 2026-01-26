# Chapter 4

Chapter 4
Advanced Data Types
Abstract This chapter will explore the more advanced data types in Csound. We will
begin by discussing Strings and manipulating texts. Next, we will explore Csound’s
spectral data types for signal analysis and transformations. Finally, we will discuss
arrays, a data type that acts as a container for other data types.
4.1 Introduction
In Section 3.1, we discussed Csound’s basic data types: i-, k- and a-types. These
allow us to express numeric processing of signals that cover a large area of sound
computing and are the foundation signals used in Csound.
In this chapter, we will cover more advanced data types. These include strings,
spectral-domain signals and arrays. These allow us to extend what we can represent
and work with in Csound, as well as to express new kinds of ideas.
4.2 Strings
Strings are ordered sets of characters and are often thought of as “text”. They may
be constant strings–text surrounded by quotes–or may be values held in S-type vari-
ables. They are useful for specifying paths to ﬁles, names of channels, and printing
out messages to the user. They can also be used to create ad hoc data formats.
© Springer International Publishing Switzerland 2016
V. Lazzarini et al., Csound, DOI 10.1007/978-3-319-45370-5_4
91
92
4 Advanced Data Types
4.2.1 Usage
String constants are deﬁned using a starting quote, then the text to use for the string,
followed by a closing quote. The quotes are used to mark where the string starts and
ends, and are not part of the string’s value.
prints
"Hello World"
In the above example, “Hello World” deﬁnes a string constant. It is used with the
prints opcode to print out “Hello World” to the console. Besides the value, strings
also have a length property. This may be retrieved using the strlen opcode, and
may be useful for certain computations.
print
strlen("Hello World")
Executing the code in the above example will print out 11.000, which is the num-
ber of characters in the text “Hello World”. String constants are the most common
use of strings in Csound.
print
strlen("\t\"Hello World\"\n")
Certain characters require escaping, which means they are processed in a special
way. Escaped characters start with a backslash and are followed by the character to
escape. The valid escape characters are given in Table 4.1.
Table 4.1 Escape sequences
Escape Sequence
Description
\a
alert bell
\b
backspace
\n
newline
\r
carriage return
\t
tab
\\
a single backslash
\"
double quote
\{
open brace
\}
close brace
\nnn
ASCII character code in octal number for-
mat
In addition to single-line strings delimited by quotes, one can use double braces
to deﬁne multi-line strings. In the following example, a multi-line string is used to
print four lines of text. The text is delimited by opening double braces ({{) and clos-
ing double braces (}}). All text found within those delimiters is treated as a string
text values and is not processed by Csound. For example, on line 2, the semicolon
and the text following it are read in as part of the text and are not processed as a
comment.
4.2 Strings
93
prints {{Hello
World ; This is not a comment
Hello
World}}
Deﬁning string constants may be enough for many use cases. However, if one
wants to deﬁne a string value and refer to it from multiple locations, one can store
the string into an S-type variable.
Svalue = "Hello World"
prints Svalue
In the above example, we have deﬁned a string variable called Svalue and
assigned it the value “Hello World”. We then pass that variable as an argument
to the prints opcode and we get the same “Hello World” message printed to the
console as we did when using a string constant. The difference here from the original
example is that we are now storing the string value into a variable which we can now
refer to in our code by name.
Listing 4.1 String processing
Sformat = "Hello \%s\n"
Smessage sprintf Sformat, "World"
Smessage2 sprintf Sformat, "Csounder"
prints Smessage
prints Smessage2
Here we are using the Sformat as a template string for use with the sprintf
opcode. The Sformat is used twice with two different values, “World” and
“Csounder”. The return values from the calls to sprintf are stored in two vari-
ables, Smessage and Smessage2. When the prints opcode is used with the
two variables, two messages are printed, “Hello World” and “Hello Csounder”.
Csound includes a whole suite of opcodes for string data processing. These can
be used for concatenation, substitution, conversion from numeric data, etc.:
•
strlen - obtains the length of a string
•
strcat - concatenates two strings
•
strcpy - string copy
•
strcmp - string comparison.
•
sprintf - formatting/conversion of strings
•
puts, prints, printf - printing to console
•
strindex, strrindex - searching for substrings
•
strsub - copying substrings
•
strtod - string to ﬂoating point conversion
•
strtol - string to integer conversion
•
strlower - lower case conversion
•
strupper - upper case conversion
The following example demonstrates string processing at i-time.
94
4 Advanced Data Types
Listing 4.2 String processing example
instr 1
S1 = p4
S2 sprintf {{
This is p4: \"%s\".
It is a string with %d characters.\n
}}, S1, strlen(S1)
prints S2
endin
schedule(1,0,0, "Hello World !!!")
Note that it is also possible to process strings at performance time, since most
opcodes listed above have k-rate versions for this purpose.
4.3 Spectral-Domain Signals
Spectral-domain signals represent a streaming analysis of an audio signal. They use
their own rates of update, independent of the control frequency, but this is largely
transparent to the end user. Users will use speciﬁc families of opcodes to analyse au-
dio signals, process spectral-domain signals and generate new audio signals. There
are two main types of these variables: f-sig and w-sig. The ﬁrst one is used for stan-
dard spectral audio manipulation, while the second is mostly employed for specialist
data analysis operations.
4.3.1 f-sig Variables
Standard frequency-domain, or f-sig, variables are used to hold time-ordered frames
of spectral data. They are generated by certain spectral analysis opcodes and can
be consumed by a variety of processing units. The data carried by an f-sig can be
transformed back to the time domain via various methods of synthesis. Outside of
audio-processing contexts, a frequency-domain signal may be used as is without
resynthesis, such as for visualising the contents of an audio signal. Signals carried
by f-sig are completely self-describing, which means that additional information on
the format is carried alongside the raw data from opcode to opcode.
Frequency-domain manipulation offers additional methods to work with audio
compared with time-domain processing alone. It allows time and frequencies to be
worked with separately, and can be used to do things like stretching a sound over
time without affecting pitch, or modifying the pitch without affecting the duration
of the sound. The options for processing f-sigs will depend on the source. There
are four sub types of f-sigs. The characteristics of the data, and their accompanying
descriptive information, will depend on these:
4.3 Spectral-Domain Signals
95
