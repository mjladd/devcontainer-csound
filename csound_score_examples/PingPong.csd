<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from PingPong.orc and PingPong.sco
; Original files preserved in same directory

sr       = 44100
kr       = 44100
ksmps    = 1
nchnls   = 2


instr    1 ; Ping-Pong Delay

ilevl    = p4                            ; Output level
idelay   = p5/1000                       ; Delay in ms
ifreq    = p6                            ; Cutoff frequency
ifdbk    = p7                            ; Feedback
imode    = p8                            ; Mode: 0=Normal 1=Scaled
i1st     = p9                            ; 1st Echo: 0=L 1=R
imix1    = p10                           ; Mix: 0=Dry 1=PingPong
imix2    = 1 - imix1                     ; Inverse mix
afdbk    init 0                          ; Initialize feedback

ain      soundin  "Marimba.aif"

adel0    = ain + afdbk                   ; Add feedback
adel1    delay  adel0, idelay            ; 1st delay
adel1    tone  adel1, ifreq              ; Lowpass filter
adel1s   = adel1*ifdbk                   ; Create scaled output
adel1    = (imode = 0 ? adel1 : adel1s)  ; Select normal or scaled
adel2    delay  adel1, idelay            ; 2nd delay
adel2    tone  adel2, ifreq              ; Lowpass filter
adel2s   = adel2*ifdbk                   ; Create scaled output
adel2    = (imode = 0 ? adel2 : adel2s)  ; Select normal or scaled
afdbk    = adel2                         ; Feedback 2nd delay
adel1    = (i1st = 0 ? adel1 : adel2)    ; Select 1st echo: L or R
adel2    = (i1st = 0 ? adel2 : adel1)    ; Select 1st echo: R or L
outs1    (ain*imix1 + adel1*imix2)*ilevl ; Level, mix and output
outs2    (ain*imix1 + adel2*imix2)*ilevl ; Level, mix and output

endin

</CsInstruments>
<CsScore>
;Mode: 0=Normal 1=1st echos decay
;1st: 0=L 1=R
;Delay in ms
;Freq in Hz

;   Strt  Leng  Levl  Delay Freq  Fdbk  Mode  1st   Mix
i1  0.00  4.00  1.00  750   7500  0.50  1     1     0.50
e

</CsScore>
</CsoundSynthesizer>
