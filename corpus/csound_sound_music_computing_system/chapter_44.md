# 5. Parameters are mostly numeric, but strings in double quotes can be used wherever

5. Parameters are mostly numeric, but strings in double quotes can be used wherever
appropriate.
A couple of important things to remember always are that commas are not used
to separate parameters (as in the orchestra), but spaces; and that statements do not
necessarily execute in the order they are placed, also unlike the orchestra language,
where they do. The score is read at the ﬁrst compilation of Csound and stored in
memory, and its playback can be controlled by the Csound language. Further single
events, or full scores can be sent to Csound, but these will be taken as real-time
events, which are treated slightly differently as some score features such as tempo
warping are not available to them.
Score comments are allowed in the same format used in the Csound language.
Single-line comments, running until the end of the line, are started by a semicolon
(;). Multiple-line comments are enclosed by /* and */, and cannot be nested.
Scores are generally provided to Csound in a CSD ﬁle, inside the <CsScore>
section (see Chapter 2).
Ultimately, the score is concerned with event scheduling. These events are mostly
to do with instantiating instruments, but can also target function table generation.
Before the appearance of function table generator opcodes and real-time events,
all of these could only be executed through the score. While modern usage can
bypass and ignore it completely, the score is still an important system resource.
Many classic examples of Csound code rely heavily on the score. This chapter will
provide a full description of its features.
8.2 Basic Statements
As outlined above, the score is a list of statements, on separate lines, each one with
the following format:
op [p1 p2 ...]
where op is one of a, b, e, f, i, m, n, q, r, s, t, v, x, y, {, and }. The statement
parameters (p-ﬁelds) are p1, p2 etc. separated by spaces. Depending on op, these
might be optional.
The main score statement is indicated by the i opcode, and it schedules an event
on a given instrument:
i p1 p2 p3 [p4 ...]
8.2 Basic Statements
157
p1 is the instrument number, or name (a string in double quotes). If using a non-
integral number, the fractional part identiﬁes a given instance, which can be used
for tied notes. A negative p1 turns a corresponding indeterminate-length instance
off.
p2 is starting time.
p3 is duration time: if negative, an indeterminate-length is set, which starts a
held note.
p4 ... are extra parameters to instruments.
The i-statement format follows the form already shown for scheduling instances.
Time is set in arbitrary units called beats, which are later translated in tempo pro-
cessing (defaulting to 1 second). Events can be placed in the score in any order
(within a section, see Section 8.3), as they are sorted before performance. As usual,
any number of concurrent i-statements are allowed for a given instrument (disre-
garding any computation time requirements). Parameters are usually numeric, but
strings can also be used in double quotes, if an instrument expects them.
A second statement affecting events is deﬁned by q. This can be used to mute i-
statements, but only affects events before they get started. The form of the statement
is:
q p1 p2 p3
p1 is the instrument number, or name (in double quotes).
p2 is the action time; the statement will affect instruments with start time equal
to or later than it.
p3 is 0 to mute an instrument and 1 to un-mute it.
This can be used to listen to selected parts of the score by muting others.
Finally, we can create function tables from the score with an f-statement. This
has the following general form:
f p1 p2 p3 p4 p5 [p6 ...]
p1 is the table number; a negative number destroys (deallocates) the table.
p2 is the creation or destruction time.
p3 is the table size.
p4 is the GEN routine code; negative values cause re-scaling to be skipped.
p5 ... are the relevant GEN parameters.
The form of the f-statement is very similar to the ftgen opcode, and all the
aspects of table creation, such as GEN codes, re-scaling and sizes are the same here.
A special form of the f-statement has a different, very speciﬁc, purpose. It is used
to create a creation time with no associated table, which will extend the duration of
the score by a given amount of time:
f 0 p2
In this case, Csound will run for p2 beats. This is useful to keep Csound running
for as long as necessary, in the presence of a score. If no score is provided, Csound
will stay open until it is stopped by a frontend (or killed).
158
8 The Numeric Score
8.3 Sections
The score is organised in sections. By default there is one single section, but further
ones can be set by using an s-statement, which sets the end of a section:
s [p1]
A single optional opcode can be used to deﬁne an end time, which is used to
extend the section (creating a pause) before the start of the next. For this, the p1
value needs to be beyond the end of the last event in the ordered list, otherwise it
has no effect. Extending a section can be useful to avoid cutting off the release of
events that employ extra time.
The score is read section by section, and events are sorted with respect to the
section in which they are placed. Time is relative to the start of the section, and gets
reset at the end of each one. Sections also have an important control role in Csound,
as memory for instrument instances is also freed/recovered at the end of a section.
This was more signiﬁcant in older platforms with limited resources, but it is still
part of the system.
The ﬁnal section of a score can optionally be terminated by an e-statement:
e [p1]
This also includes an optional extended time, which works in the same way as
in the s-statement. Note that any statements after this one will be ignored. Once the
last section of a score ﬁnishes, Csound will exit unless an f 0 statement has been
used. An example of a score with two sections is given in listing 8.1, where four
statements are performed in each section. If p4 and p5 are interpreted as amplitude
and frequency, respectively, we have an upward arpeggio in the ﬁrst section, and a
downward one in the second. Note that the order of statements does not necessarily
indicate the order of the performed events.
Listing 8.1 Score example
f 1 0 16384 10 1 0.5 0.33 0.25 0.2
; first section
i1 0 5 1000 440
i1 1 1 1000 550
i1 2 1 1000 660
i1 3 1 1000 880
s
; second section
i1 3 1 1000 440
i1 2 1 1000 550
i1 1 1 1000 660
i1 1 5 1000 880
e
The x-statement can be used to skip the subsequent statements in a section:
8.4 Preprocessing
159
x
It takes no arguments. Reading of the score moves to the next section.
8.4 Preprocessing
Scores are processed before being sent to the Csound engine for performance. The
three basic operations applied to a score’s events are carry, tempo, and sort, executed
in this order. Following these, two other processing steps are optionally performed,
to interpret next-p/previous-p and ramping symbols.
8.4.1 Carry
Carry works on groups of consecutive i-statements. It is used to reduce the need to
type repeated values. Its basic rules are:
