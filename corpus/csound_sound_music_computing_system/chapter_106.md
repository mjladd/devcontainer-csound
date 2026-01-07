# 4. A sound snippet is transformed6 into a bell-like sound which gently seems to

4. A sound snippet is transformed6 into a bell-like sound which gently seems to
speak. This sound can be of very different durations, starting from the original
(= short) duration to a stretch factor of a thousand. Although it reproduces the
6 via some FFT code which selects a number of prominent bins.
464
19 Joachim Heintz: Knuth and Alma, Live Electronics with Spoken Word
most prominent partials of the original sound, it sounds high and adds a pitched,
slowly decaying sound to the overall image.
19.4.4 Improvisation or Composition
As for Knuth, one major application for Alma is to be an instrument for improvisa-
tion. Figure 19.7 shows the CsoundQt interface for a MIDI-driven improvisation.
Fig. 19.7 Alma as an instrument for improvisation in CsoundQt
The microphone input is recorded in one huge buffer of arbitrary length, for in-
stance ten minutes. The threshold can be adjusted in real time, as well as some
parameters for the four modes. The markers for the modes are written in four ta-
bles, created automatically by an array which holds pairs of silence time span and
maximum number of markers to be written.
Listing 19.3 Generation of marker tables in Alma
/* pairs of time span and number of markers */
giArrCreator[] fillarray .005, 100000, .02, 10000,
.001, 500000, .01, 50000
instr CreateFtables
iIndx = 0
;for each pair
while iIndx < lenarray(giArrCreator) do
iTableNum = giTableNumbers[iIndx/2]
;create a table
event_i "f", iTableNum, 0, -iMarkers, 2, 0
;start an instance of instr WriteMarker
iSilenceTime = giArrCreator[iIndx]
schedule "WriteMarker", 0, p3, iTableNum,
iMarkers, iSilenceTime
iIndx += 2
od
turnoff
19.4 Alma
465
endin
As for compositional sketches, I am currently working on some studies which
focus on only one of the four modes. For the second mode for example, I took a text
by Ludwig Wittgenstein [132]7, separated it into parts of three, ﬁve, seven, nine or
eleven words, followed by pauses of one, two, three, four, ﬁve or six time units.8
Alma herself acts in a similar way, creating new “sentences” of ﬁve, seven, nine or
thirteen “words” and breaks of two, four, six or eight time units afterwards.9
Listing 19.4 Alma reading a text in her way
/* time unit in seconds */
giTimUnit = 1.2
/* number of syllables in a word */
giWordMinNumSyll = 1
giWordMaxNumSyll = 5
/* pause between words (sec) */
giMinDurWordPause = 0
giMaxDurWordPause = .5
/* possible number of words in a "sentence" */
giNumWordSent[] fillarray 5, 7, 9, 13
/* possible pauses (in TimUnits) after a sentence */
giDurSentPause[] fillarray 2, 4, 6, 8
/* possibe maximum decrement of volume (db) */
giMaxDevDb = -40
instr NewLangSentence
/* how many words */
iNumWordsIndx = int(random(0,
lenarray:i(giNumWordSent)-.001))
iNumWords = giNumWordSent[iNumWordsIndx]
/* which one pause at the end */
iLenPauseIndx =
int(random(0,lenarray:i(giDurSentPause)-.001))
iLenPause = giDurSentPause[iLenPauseIndx]
/* get current pointer position and
make sure it is even (= end of a section) */
S_MarkerChnl sprintf "MaxMarker_%d", giMarkerTab
iCurrReadPos chnget S_MarkerChnl
7 Numbers 683 and 691.
8 A time unit is what the speaker feels as an inner pulse, so something around one second.
9 I presented this study as part of my talk at the 3rd International Csound Conference in St. Peters-
burg, 2015.
466
19 Joachim Heintz: Knuth and Alma, Live Electronics with Spoken Word
iCurrReadPos = iCurrReadPos % 2 == 1 ?
iCurrReadPos-1 : iCurrReadPos-2
/* make sure not to read negative */
if iCurrReadPos < 2 then
prints {{
Not enough Markers available.
Instr %d turned off.\n}}, p1
turnoff
endif
/* set possible read position */
iMinReadPos = 1
iMaxReadPos = iCurrReadPos-1
/* actual time */
kTime timeinsts
/* time for next word */
kTimeNextWord init 0
/* word count */
kWordCount init 0
/* if next word */
if kTime >= kTimeNextWord then
/* how many units */
kNumUnits = int(random:k(giWordMinNumSyll,
giWordMaxNumSyll))
/* call instrument to play units */
kNum = 0
kStart = 0
while kNum < kNumUnits do
/* select one of the sections */
kPos = int(random:k(iMinReadPos, iMaxReadPos+.999))
kPos = kPos % 2 == 1 ?
kPos : kPos-1 ;get odd = start marker
/* calculate duration */
kDur = (table:k(kPos+1, giMarkerTab) -
table:k(kPos, giMarkerTab)) * giBufLenSec
/* reduce if larger than giSylMaxTim */
19.4 Alma
467
kDur = kDur > giSylMaxTim ? giSylMaxTim : kDur
/* get max peak in this section */
kReadStart =
table:k(kPos, giMarkerTab) * giBufLenSec ;sec
kReadEnd = kReadStart + kDur
kPeak GetPeak giBuf, kReadStart*sr, kReadEnd*sr
/* normalisation in db */
kNormDb = -dbamp(kPeak)
/* calculate db deviation */
kDevDb random giMaxDevDb, 0
/* fade in/out */
iFade = giMinSilTim/2 < 0.003 ?
0.003 : giMinSilTim/2
/* add giMinSilTim duration at the end */
event "i", "NewLangPlaySnip", kStart,
kDur+giMinSilTim, table:k(kPos, giMarkerTab),
iFade, kDevDb+kNormDb
/* but not for the start
(so crossfade is possible) */
kStart += kDur
/* increase pointer */
kNum += 1
od
/* which pause after this word */
kPause random giMinDurWordPause, giMaxDurWordPause
/* set time for next word to it */
kTimeNextWord += kStart + kPause
/* increase word count */
kWordCount += 1
endif
/* terminate this instance and
create a new one if number
468
19 Joachim Heintz: Knuth and Alma, Live Electronics with Spoken Word
of words are generated */
if kWordCount == iNumWords then
event "i", "NewLangSentence", iLenPause, p3
turnoff
endif
endin
instr NewLangPlaySnip
iBufPos = p4
iFade = p5
iDb = p6
aSnd poscil3 1, 1/giBufLenSec, giBuf, iBufPos
aSnd linen aSnd, iFade, p3, iFade
out aSnd * ampdb(iDb)
endin
I think the main question for further steps with Alma is how the human speaker
reacts to the accompaniment which comes out of the lantern. I hope I can go on
exploring this ﬁeld.10
19.5 Conclusions
This chapter showed an example of the usage of Csound for a live electronics set-up
in both an improvisational and compositional environment. It explained how the ba-
sic idea derives from a mixture of rational and irrational, adult and childish, recent
and past images, feelings, desires and thoughts, leading to two different emanations,
called Knuth and Alma. It showed how Knuth is able to detect the irregular accents
of spoken word, or its internal rhythm. Different possibilities of artistic working
and playing with Knuth based on these detections were demonstrated, implemented
either as a MIDI-based instrument for improvisation, or as a concept for a prede-
ﬁned composition. For the second branch, Alma’s way of analysing and marking
sounding units of different sizes was explained in detail. The implementation of an
instrument for improvising with Alma was shown, as well as a study for reading a
text in partnership with her. The code snippets in this chapter display some ways to
write a ﬂexible, always developing live electronics set-up in Csound.
10 Thanks here to Laureline Koenig, Tom Schr¨opfer, Anna Heintz-Buschart and others who ac-
companied my journey with Knuth and Alma.