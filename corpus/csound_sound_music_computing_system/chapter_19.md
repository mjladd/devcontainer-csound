# Chapter 6.

Chapter 6.
3.4 Opcodes
The fundamental building block of an instrument is the opcode. They implement
the unit generators that are used for the various functional aspects of the system. It
is possible to write code that is largely based on mathematical expressions, using
very few opcodes (as shown in listing 3.12), but that can become complex very
quickly. In any case, some opcodes always have to be present, because they handle
input/output (IO) and events, and although we have not introduced the idea formally,
we have used print, printk and out for data output, and schedule for events.
3.4.1 Structure
An opcode has a structure that is composed of two elements:
1. state: internal data that the opcode maintains throughout its life cycle
2. subroutines: the code that is run at initialisation and/or performance time. Gen-
erally, an opcode will have distinct subroutines for these execution stages.
We can think of opcodes as black box-type (i.e. opaque, you can only see input
and output arguments) instruments: recipes for performing some processing, which
will only execute when instantiated. When an opcode is placed in an instrument,
which is then scheduled, the engine will