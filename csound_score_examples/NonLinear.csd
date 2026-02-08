<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from NonLinear.orc and NonLinear.sco
; Original files preserved in same directory

sr     = 44100
kr     = 4410
ksmps  = 10
nchnls = 1


instr    1 ; Limit / Mirror / Wrap

igain1   = p4       ; Gain start
igain2   = p5       ; Gain end
ilevl1   = p6*32768 ; +Level
ilevl2   = p7*32768 ; -Level
imode    = p8       ; 1=Limit, 2=Mirror, 3=Wrap

kgain    line  igain1, p3, igain2

ain      soundin  "AllOfMe.aif"
ain      = ain*kgain

if       imode = 1 goto limit
if       imode = 2 goto mirror

a1       wrap  ain, ilevl2, ilevl1
goto     out

limit:
a1       limit  ain, ilevl2, ilevl1
goto     out

mirror:
a1       mirror  ain, ilevl2, ilevl1
out:

out      a1

endin

</CsInstruments>
<CsScore>
;Mode: 1=Limit 2=Mirror 3=Wrap
;Gain1=Start
;Gain2=End

;   Strt  Leng  Gain1 Gain2 +Levl -Levl  Mode
i1  0.00  1.47  4.00  1.00  0.25  -1.00  2
e

</CsScore>
</CsoundSynthesizer>
