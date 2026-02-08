<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from pitchsoundin.orc and pitchsoundin.sco
; Original files preserved in same directory

    sr   	=   18900
    kr   	=   1890
    ksmps   =   10

;====================================================================;
;       EXAMPLE ORCHESTRA FOR PLAYING SOUNDIN FILES                  ;
;====================================================================;
;===========================================;
;      		STRAIGHT MIXING INSTRUMENT             ;
;   P4 		= 	FILE A     P5 	= 	FILE B         ;
;   P6 		= 	A RISE     P7 	= 	A DECAY        ;
;   P8 		= 	B RISE     P9 	= 	B DECAY        ;
;===========================================;
instr	1
    	asiga   soundin 	p4
    	asiga   linen   	asiga,p6,p3,p7
    	asigb   soundin 	p5
    	asigb   linen   	asigb,p8,p3,p9
        		out     	asiga+asigb
endin
;===========================================;
;        PITCH CHANGING INSTRUMENT          ;
;       P4 = SOUNDIN #  P5 = DESIRED PITCH  ;
;       P6 = OLD PITCH  P7 = ORIGINAL SR    ;
;===========================================;
 instr   2
    	icpsnew 	=       cpspch(p5)
    	icpsold 	=       cpspch(p6)
    	ioldsr  	=       p7
    	incr    	=       ioldsr/sr * icpsnew/icpsold
    	kphase  	init    0                       	;INITIALIZE PHASE
    	aphase  	interp  kphase                  	;CONVERT TO ARATE
    	asig    	tablei  aphase,1                	;RESAMPLE THE SOUND
    	kphase  	=       kphase+incr*ksmps       	;UPDATE FOR NEXT K
            		out     asig
endin

</CsInstruments>
<CsScore>
;===========================================;
;       STRAIGHT MIXING INSTRUMENT          ;
;       P4 = FILE A     P5 = FILE B         ;
;       P6 = A RISE     P7 = A DECAY        ;
;       P8 = B RISE     P9 = B DECAY        ;
;===========================================;
;                       soundA  soundB  riseA   decA    riseB   decB
i01     0       4       5       6       .01     3.99    3       1
s
; Sample File is Soundin.5 -- no rescaling
f1  	0   	32768  	-1   	5   	0
;===========================================;
;        PITCH CHANGING INSTRUMENT          ;
;       P4 = SOUNDIN #  P5 = DESIRED PITCH  ;
;       P6 = OLD PITCH  P7 = ORIGINAL SR    ;
;===========================================;
i02 	0   	4   	5   	5.01    6.00    18900
i02     4   	2   	6.00    7.00
i02 	6   	3   	5   	4.06
e

</CsScore>
</CsoundSynthesizer>
