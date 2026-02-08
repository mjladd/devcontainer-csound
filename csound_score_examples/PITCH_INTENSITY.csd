<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from PITCH_INTENSITY.orc and PITCH_INTENSITY.sco
; Original files preserved in same directory

 sr            =         44100
 kr            =         4410
 ksmps         =         10
 nchnls        =         1


;*************************************   PITCH AND INTENSITY   ***********************************

; SINE WAVES WILL BE PRESENTED AT 6 DIFFERENT FREQUENCIES TO THE LISTENER(S) IN ORDER TO ILLUSTRATE
; THE AFFECT OF INTENSITY ON THE LISTENER(S) PERCEPTION OF PITCH. THE FREQUENCIES ARE AS FOLLOWS:
; 200HZ, 500HZ, 1000HZ, 3000HZ, 4000HZ, 8000HZ. THE ENVELOPE FOR EACH TONE BURST WILL BE A SIMPLE
; GATE WITH A 5MS. DELAY AND RELEASE. EACH TONE WILL HAVE A DURATION OF 500MS. THE SIX PAIR OF TONES
; ARE PRESENTED AT EACH FREQUENCY SUCH THAT THE SECOND TONE WILL BE 40DB HIGHER THAN THE FIRST. A
; NOTICABLE PITCH CHANGE SHOULD BE AUDIBLE.


;******************************************   HEADER   *******************************************



 instr         1

 iamp          =         ampdb(p4)           ;P4 = AMPLITUDE IN DB
 iamp          =         ampdb(p4)


 k1            linen     iamp,.05,p3,.05
 a1            oscili    k1,p5,1
               out       a1
 endin

</CsInstruments>
<CsScore>

f1 0 32768 10 1                                                  ; SINE WAVE






;*************************************   PITCH AND INTENSITY  **************************************

;**************************************   CALIBRATION TONE   ***************************************
;   p1      p2      p3    p4       p5
;  inst    strt    dur    amp     freq
    i1      0       8     45       200
s

;   p1      p2      p3    p4       p5
;  inst    strt    dur    amp     freq
    i1      1      .5     45       200
    i1      1.75   .5     85       200
    i1      3.25   .5     45       500
    i1      4.00   .5     85       500
    i1      5.50   .5     45      1000
    i1      6.25   .5     85      1000
    i1      7.75   .5     45      3000
    i1      8.50   .5     85      3000
    i1     10.00   .5     45      4000
    i1     10.75   .5     85      4000
    i1     12.25   .5     45      8000
    i1     13.00   .5     85      8000
 endin


</CsScore>
</CsoundSynthesizer>
