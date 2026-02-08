<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from testmid.orc and testmid.sco
; Original files preserved in same directory

sr 		= 		44100
kr 		= 		4410
ksmps 	= 		10
nchnls	=		1


		instr 1
ifr   	cpsmidib 2
a1    	oscil    32000, ifr, 1
          out      a1
		endin

</CsInstruments>
<CsScore>
f0 100
f1 0 1024 10 1
e

</CsScore>
</CsoundSynthesizer>
