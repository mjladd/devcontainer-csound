<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from tienote2.orc and tienote2.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1

;DAVID KIRSH


;----- TIES ORCHESTRA WITH DCLIC ----------


          instr     5
inote     =         cpspch(p4)  ; THIS NOTE'S PITCH
idur      =         abs(p3)
istied    tival

tigoto    tieinit

ibegpitch =         inote
iprevpitch =        inote
goto      cont

tieinit:

ibegpitch =         iprevpitch
iprevpitch =        inote

cont:

kpitchenv linseg    ibegpitch, .9, inote, abs(p3), inote

        ; IF THIS IS A TIED NOTE, THEN DECLICK ENVELOPE AMPLITUDE
        ; STARTS OUT AT '1' (I.E., SAME AS ENDING VALUE OF NOTE
        ; WE'RE TYING ONTO).  OTHERWISE, IT STARTS AT '0'.
ibegdclic =         (istied == 1 ? 1 : 0)

        ; IF THIS NOTE IS BEING HELD (IN ANTICIPATION OF BEING TIED
        ; ONTO), THEN DECLICK AMPLITUDE ENDS AT '1' (SO IT
        ; MATCHES THE BEGINNING DECLICK AMPLITUDE OF THE TIED-ON NOTE).
        ; OTHERWISE, AMPLITUDE ENDS AT '0'.
ienddclic =         (p3 < 0 ? 1 : 0)

kdclic    linseg    ibegdclic, 0.1, 1, abs(p3)-0.2, 1, 0.1, ienddclic

a1        buzz      10000, kpitchenv, 6, 1, -1
          out       a1 * kdclic
          endin

</CsInstruments>
<CsScore>
;----- TIES SCORE ----------
f1 0 32769 10 1
;p1 DECIMAL ALLOWS POLYPHONY.
;
i5.1    0.0     -2      7.00
i5.2    0.0     -2      7.04
i5.1    2.0     -2      7.07
i5.2    2.0     -2      7.11
i5.1    4.0     -2      6.07
i5.2    4.0     -2      7.00
i5.1    6.0     2       7.00
i5.2    6.0     2       6.00
i5      8.1             .8              7.00
i5      9.1             .8              7.04
i5     10.1             .8              7.07
i5     11.1             .8              7.00
e

</CsScore>
</CsoundSynthesizer>
