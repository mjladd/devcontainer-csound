# Chapter 7

Chapter 7
User-Deﬁned Opcodes
Abstract In this chapter, we will examine the different ways in which Csound code
can be composed into bigger units. This is enabled by the user-deﬁned opcode
(UDO) mechanism. After looking at its syntax in detail, we will explore the various
aspects of the UDO operation. We will examine the idea of local control rate and
how it can be useful in signal processing applications. A very powerful program-
ming device, recursion, will be introduced to the UDO context, with a discussion
of its general use cases. To complete this chapter, we will look at the concept of
subinstruments, which provide another means of composing Csound code.
7.1 Introduction
Although the Csound language has a large collection of opcodes, there are always
situations where a new algorithm is required. In this case, there is a need for mech-
anisms to add new unit generators to the system. The Csound language can be ex-
panded in two ways:
