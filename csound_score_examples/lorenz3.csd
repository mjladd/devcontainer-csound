<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from lorenz3.orc and lorenz3.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2


; LORENZ ATTRACTOR
          instr 1
;--------------------------------------------------------------------
ax        init      p5
ay        init      p6
az        init      p7
as        init      p8
ar        init      p9
ab        init      p10
ah        init      p11
;--------------------------------------------------------------------
kampenv   linseg    0, .01, p4, p3-.02, p4, .01, 0
axnew     =         ax+ah*as*(ay-ax)
aynew     =         ay+ah*(-ax*az+ar*ax-ay)
aznew     =         az+ah*(ax*ay-ab*az)
;--------------------------------------------------------------------
ax        =         axnew
ay        =         aynew
az        =         aznew
;--------------------------------------------------------------------
          outs      ax*kampenv,ay*kampenv
          endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1
t 0 400
; Start Dur Amp X Y Z S R B   h
i1 0 8 600 .6 .6 .6 10 28 2.667 .01
i1 + . 600 .6 .6 .6 22 28 2.667 .01
i1 . . 600 .6 .6 .6 32 28 2.667 .01

</CsScore>
</CsoundSynthesizer>
