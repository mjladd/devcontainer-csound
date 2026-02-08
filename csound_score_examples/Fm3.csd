<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Fm3.orc and Fm3.sco
; Original files preserved in same directory

sr      	= 		44100
kr      	= 		4410
ksmps   	= 		10
nchnls  	= 		1

; =================== A Simple FM Instrument ====================== ;
; ================ with swept modulation index ==================== ;


		instr 	1
iamp    	=       	ampdb(p4)               ; p4=CARRIER AMPLITUDE IN dB
ifreq   	=       	p5                      ; p5=BASE FREQUENCY
icar    	=       	p6*ifreq                ; p6=CARRIER FREQUENCY RATIO
imod    	=       	p7*ifreq                ; p7=MODULATOR FREQUENCY RATIO
indx    	=       	ampdb(p8)               ; p8=MODULATION INDEX
kind    	linseg  	0,p3*.5,indx,p3*.5,0    ; SWEEPING MODULATION INDEX
amod    	oscili  	kind,imod,1
kamp    	linseg  	0,p3*.01,iamp,p3*.98,iamp,p3*.01,0
acar    	oscili  	kamp,icar+amod,1
  		out     	acar
		endin

</CsInstruments>
<CsScore>
; =============================================================== ;
; ===== f1 defines a 2K (2048 point) sine wave using Gen10 ====== ;
; =============================================================== ;

f1      0     2048      10     1

; ========================================================= ;
;    Start    Dur      Amp    Pitch Carrier  Mod    Peak
;    in Sec   in Sec   in Db  in Hz Ratio    Ratio  Index
; ========================================================= ;

i1      0      2        86    110      1      1      70
i1      2.5    .        86      .      1      2       .
i1      5      .        86      .      1      4       .
e


</CsScore>
</CsoundSynthesizer>
