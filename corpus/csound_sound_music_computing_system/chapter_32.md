# Chapter 6

Chapter 6
Signal Graphs and Busses
Abstract This chapter discusses how instruments are constructed as signal graphs,
looking at how unit generators (opcodes, functions, operators) are linked together
through the use of variables. We also detail the order of execution of code inside
instruments, and how instances of the same or different instruments are sequenced
inside a k-cycle. We introduce the notion of patch-cords and busses, as metaphors
for the various types of connections that we can make in Csound program code.
To conclude the chapter, the most important mechanisms for passing data between
separate instances of instruments are examined in detail.
6.1 Introduction
Although Csound instruments are independent code objects, it is possible to con-
nect them together in different ways. This is often required, if for instance we want
to use audio effects that apply to all sound-generating instruments, rather than to
each instance separately. This is a typical feature of music systems such as syn-
thesis workstations and sequencing and multi-tracking programs. In these types of
applications, ideally we have a single instrument instance implementing the desired
effect, to which we send audio from various sources in different instruments. Con-
necting instances in this way creates dependencies between parts of the code, and it
is important to understand how the signal ﬂows from origin to destination, and how
the execution of the various elements is ordered.
In this chapter, we will ﬁrst review how unit generators are connected together
to make up the instrument signal graph, looking at how variables are used to link
them up and how the execution of code is sequenced. We will also look at how
instances of the same and of different instruments are ordered in a k-cycle. This will
be followed by a detailed discussion of various methods that can be used to set up
connections between instruments.
© Springer International Publishing Switzerland 2016 
V. Lazzarini et al., Csound, DOI 10.1007/978-3-319-45370-5_
125
6
126
6 Signal Graphs and Busses
6.2 Signal Graphs
A Csound instrument can be described as a graph of unit generators connected to-
gether using variables, which can be thought of, conceptually, as patch-cords. This
metaphor is useful to understand their operation, although it should be stressed that
there are other, equally valid, interpretations of the role and behaviour of Csound
program code.
In any case, whenever we connect one unit generator (opcode, function, arith-
metic operator) into another, such a patch-cord will be involved, either explicitly or
implicitly. We can picture an instrument as a graph whose nodes are its unit genera-
tors, and the connecting lines, its variables. For instance, we can make an oscillator
modulate the amplitude of another with the following code excerpt:
asig oscili oscili(kndx,kfm)+p4,kfc
This creates the signal graph shown in Fig. 6.1. The compiler will create two
synthetic k-rate variables, and use them to connect the ﬁrst oscillator to the addition
operator, and the output of this to the second oscillator amplitude. These variables,
marked with a # and hidden from the user, are crucial to deﬁne the graph unambigu-
ously. In other words, the single line of code is unwrapped internally in these three
steps:
#k1 oscili kndx,kfm
#k2 = p4 + #k1
asig oscili #k2,kfc
kfm
kndx
?
?

?
#k1
˜
+i
-
p4
?
?kfc
#k2
??
˜

?
asig
Fig. 6.1 The representation of a signal graph in Csound, which involves two synthetic variables
created by the compiler to connect the unit generators deﬁned in it
The compiler creates the structure of the signal graph from the user code. The
actual executable form of this is only formed when an instance of the instrument is
6.3 Execution Order
127
allocated. At that point the memory for the variables, as well as for each opcode,
is reserved, and the connections to the unit generators are established. Any init-
pass routine that exists in the instrument is then run. When the instance performs,
the order in which the different elements are placed in the code will determine the
execution sequence. In the example above, this is easy to determine: