<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Waveshap.orc and Waveshap.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


          instr   2
icps      cpsmidi
iamp      ampmidi   512, 100
iscale    =         iamp * 30
kamp      linseg    0, .25, iamp, .25, iamp-100, 5, 0
awtosc    oscil     kamp, icps, 1
aout      table     awtosc + 512, 2
aeg       linenr    iscale, .01, .5, .01
          out       aout * aeg
          endin

          instr   3
icps      cpsmidi
iamp      ampmidi   8192, 100
iscale    =         iamp * .5
k1        expseg    .01, .1, iamp, .03, iamp-1000, 5, .01
a1        oscili    k1, icps, 1
a1        tablei    a1, 3
aeg       linenr    iscale, .01, .5, .01
          out       a1 * aeg
endin

          instr   1
icps      cpsmidi
iamp      ampmidi   256, 100
iscale    =         iamp*20
kamp      linseg    0, .01, iamp, .35, iamp-30, 5, 0
ktabmov   linseg    0, .01,  512, .35, 1024, 2, 1536, 5, 0
awtosc    oscil     kamp, icps, 1
aout      table     awtosc + 256 + ktabmov, 4, 0, 0, 1
aeg       linenr    iscale, .01, .5, .01
          out       aout * aeg
          endin

</CsInstruments>
<CsScore>
f0   600
f1     0  4096 10 1
f2     0  1025 13 1 1 6 4 2 3
f3     0  8193 13 1 1  0 5 -2 -3 0 8 -9 0 2 0 -3 0 2
f4     0   513  3 -1 1 0 0 3 0 -10.5 0 6
f100   0   128  7  0 128 1
e

</CsScore>
</CsoundSynthesizer>
