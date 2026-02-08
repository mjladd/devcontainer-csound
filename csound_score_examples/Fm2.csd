<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Fm2.orc and Fm2.sco
; Original files preserved in same directory

sr      	=       	44100
kr      	=       	4410
ksmps   	=       	10
nchnls	=		1

; =================== A Simple FM Instrument ====================== ;
; ================ with swept modulation index ==================== ;
; ================   Non Sinusoidal Waveforms   =================== ;



		instr 	1
icar    	=       	1
imod    	=       	1
ifreq   	=       	55                              ; FUNCTION f1 (SINE WAVE: 2K)
iamp    	=       	ampdb(86)                       ; FUNCTION f2
kamp    	linseg  	0,p3*.1,iamp,p3*.8,iamp,p3*.1,0 ; FUNCTION f3
kind    	line    	p5,p3,p6                        ; FUNCTION f4
a1      	foscili 	kamp,ifreq,icar,imod,kind,p4    ; p4=ALTERNATE WAVEFORM
   		out     	a1                              ; p5=SWEPT MODULATION INDEX BEGIN
		endin                                     ; p6=SWEPT MODULATION INDEX PEAK

</CsInstruments>
<CsScore>
; =============================================================== ;
; =========== Testing Modulation Index and C:M Ratios =========== ;
; =============================================================== ;

f1      0     1024      10     1
f2      0     1024      10    10  8  0  6  0  4  0  1
f3      0     1024      10    10  0  5  5  0  4  3  0  1
f4      0    1024     10    10  0  9  0  0  8  0  7  0  4  0  2  0  1  0

; =========================================== ;
;    Start    Dur      Func   Start   End
;    in Sec   in Sec   Table  Index   Index
; =========================================== ;

i1      0      5       1      40      0
i1     10      .       2      80      0
i1     20      .       3     120      0
i1     30      .       4     240      0
s
i1      0      5       1      40     10
i1     10      .       2      80     20
i1     20      .       3     120     30
i1     30      .       4     240     40
s
i1      0      2       1      40      0
i1      2      .       2      80      0
i1      4      .       3     120      0
i1      6      .       4     160      0
s
i1      0      2       1     200      0
i1      2      .       2     300      0
i1      4      .       3     500      0
i1      6      .       4     800      0
e


</CsScore>
</CsoundSynthesizer>
