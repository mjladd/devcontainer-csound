<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from tienote1.orc and tienote1.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1

;DAVID KIRSH

; ============== TIED NOTES.ORC ========


; DEMONSTRATION OF PORTAMENTO BETWEEN TIED NOTES
; THIS TECHNIQUE COULD BE APPLIED TO OTHER PARAMETERS AND TO
; NON-TIED NOTES WITH STRAIGHTFORWARD CHANGES.
          instr     5
inote     =         cpspch(p4)  ; THIS NOTE'S PITCH

     ; IF THIS IS NOT A TIED NOTE, THEN THERE'S NO PREVIOUS
     ; PITCH TO GLIDE FROM, SO SET BEGINNING PITCH OF
     ; PORTAMENTO TO THIS NOTE'S PITCH.  THEN SAVE THIS SAME
     ; PITCH IN 'IPREVPITCH' SO WE CAN REMEMBER WHAT PITCH WE
     ; ARE COMING FROM WHEN WE HAVE A TIED NOTE.  WE HAVE TO
     ; SAVE IT BOTH HERE AND IN THE TIED NOTE CASE BECAUSE IF
     ; WE DO IT IN A COMMON PLACE BELOW, CSOUND COMPLAINS ABOUT
     ; IPREVPITCH BEING USED BEFORE SET.
tigoto    tieinit

     ; AT THIS POINT WE KNOW WE'RE NOT IN A TIED NOTE.
     ; SET BEGINNING AND PREVIOUS PITCHES TO THE SAME THING.
ibegpitch =    inote
iprevpitch     =    inote
goto      cont

tieinit:
     ; WE'RE IN A TIED NOTE.
     ; SET UP BEGINNING PITCH FOR PORTAMENTO TO NEW PITCH.
     ; BEGINNING PITCH IS PITCH OF PREVIOUS NOTE THAT THIS ONE IS
     ; TIED ONTO THE END OF.  SAVE CURRENT PITCH IN CASE ANOTHER
     ; NOTE TIES ONTO THIS ONE; THEN WE'LL BE ABLE TO PORTAMENTO
     ; AGAIN TO THAT NEW PITCH.
ibegpitch =    iprevpitch
iprevpitch     =    inote

cont:
     ; NOW SET UP A PITCH ENVELOPE THAT MOVES FROM THE BEGINNING
     ; PITCH (AS DETERMINED ABOVE) TO THIS NOTE'S NOMINAL PITCH.
kpitchenv linseg    ibegpitch, .9, inote, abs(p3), inote

     ; GENERATE A SOUND USING THE PITCH ENVELOPE.  NOTICE THE
     ; LAST 'BUZZ' ARGUMENT (-1), WHICH CAUSES PHASE
     ; INITIALIZATION TO BE SKIPPED.  THIS IS IMPORTANT TO AVOID
     ; CLICKS ON TIED NOTES.  (THIS SIMPLE EXAMPLE CLICKS ON
     ; UNTIED NOTES, THOUGH, BECAUSE THERE'S NO AMPLITUDE
     ; ENVELOPE.)
a1        buzz 10000, kpitchenv, 6, 1, -1
          out  a1
          endin

</CsInstruments>
<CsScore>

;=========== TIED NOTES.SCO ====================

; A LITTLE TEST MUSIC
f1 0 1025 10 1
;
i5.1 0.0  -2   7.00
i5.2 0.0  -2   7.04
i5.1 2.0  -2   7.07
i5.2 2.0  -2   7.11
i5.1 4.0  -2   6.07
i5.2 4.0  -2   7.00
i5.1 6.0  2    7.00
i5.2 6.0  2    6.00
e

</CsScore>
</CsoundSynthesizer>
