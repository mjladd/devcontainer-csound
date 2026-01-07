# 4. A resynthesis instrument, of which only one instance is required.

4. A resynthesis instrument, of which only one instance is required.
We will need global variables to act as busses for the PV signals, and to carry the
time and buffer references from the writer to the readers. An important implementa-
tion detail here is that we will need to be careful when clearing the f-sig bus. We will
have to make sure this is done in the correct sequence with the synthesis, otherwise
the output will be zero. Normally, this is not required for the streaming PV opcodes,
but because we are making the f-sig zero deliberately, it needs to happen exactly
after the synthesis.
There are two solutions: one is to ﬁx ksmps to the hopsize, which will align
the analysis rate to the k-rate; the other is to make the clearing happen only after
an analysis period has elapsed. If this is not done, the clearing step will prevent
the streaming mechanism from working. The reason for this is that PV signals and
opcodes work using an internal frame counter, and this can get out of sync with
the synthesis that happens exactly every hopsize samples. In normal use, we do not
clear f-sigs, and the synthesis always happens at the end of a signal graph, so this
situation never arises.
Another aspect to note is that we need to ﬁnd a convenient way to set the indi-
vidual delay for each band. We can do this by deﬁning a curve in a function table,
from which the readers can take their individual delays. The bands themselves can
be deﬁned in various ways, but making them have a constant Q is a perceptually
relevant method. The reader bands can be deﬁned from a starting point upwards,
and we just need to space them evenly until the maximum frequency (e.g. sr
2 ). The
bandwidth is then determined by the Q value.
A simpliﬁed example extracted from the piece is shown in listing 22.1. In this
code, we spawn 120 readers, covering 50 Hz upwards with Q = 10. The delay times
range from 0.5 to 10 seconds, and are deﬁned in a function table created with GEN
5 (which creates exponential curve segments).
Listing 22.1 Dynamic spectral delays example. Note that the bus clearing is protected to make
sure it happens in sync with the synthesis
gisiz init 1024
gfmix pvsinit gisiz
gifn1 ftgen 1,0,gisiz,-5,
10,gisiz/8,
.5,gisiz/4,
2,gisiz/8,
8,gisiz/2,4
instr 1
asig
diskin2 p4,1
490
22 Victor Lazzarini: Noctilucent Clouds
fsig pvsanal asig,gisiz,gisiz/4,gisiz,1
gibuf,gkt
pvsbuffer fsig,10
endin
schedule(1,0,60,"src1x.wav")
instr 2
kst init p4
ibands init p5
kq init p6
kcnt init 0
kdel init 0
even:
kpow
pow
sr/(2*kst), kcnt/ibands
kcf = kst*kpow
kdel tablei (2*kcf)/sr, p7, 1
event "i",p8,0,p3,kdel,kcf,kcf/kq,p7
kcnt = kcnt + 1
if kcnt < ibands kgoto even
turnoff
endin
schedule(2,0,60,50,120,10,gifn1,3)
instr 3
icf = p5
ihbw = p6/2
idel tablei (2*icf)/sr, p7, 1
fsig pvsbufread gkt-idel,gibuf,icf-ihbw,icf+ihbw
gfmix pvsmix
fsig, gfmix
endin
instr 20
kcnt init 0
asig pvsynth gfmix
outs asig
if kcnt >= gisiz/4 then
gfmix pvsgain gfmix,0
kcnt -= gisiz/4
endif
kcnt += ksmps
endin
schedule(20,0,60)
This example is very close to the early sketches of the dynamic spectral delays
that I did for the piece. In their ﬁnal form, I made four reader variants to be used at
different times. These included some extra spectral smoothing and frequency shift-
ing. The reader instruments also feature a choice of two output channels, and in-
22.2 The Basic Ingredients
491
terpolation between two function tables to obtain the delay values, controlled by
instrument parameters.
22.2.2 Variable Delay Processing
Comb ﬁlters are simple, but very interesting devices. With very short delay times
and high feedback gain, they resonate at their fundamental frequency and its har-
monics; with long delay times, they work as an echo, repeating the sounds going
into them. One of the ideas I had been keen to explore in a piece for a long time was
the transition between these two states by moving the delay time swiftly between the
areas that make these effects come into play. This is reasonably straightforward to
achieve with a variable delay processor with an internal feedback (a variable comb
ﬁlter), which is implemented by the opcode flanger.
The result can be quite striking, but it needs to be carefully managed, and tuned
to yield the correct results. The main idea is to play with these transitions, so we can
encode a series of delay times on a function table, and then read these to feed the
time-varying parameter. In order to provide a good scope for manipulation, I use an
oscillator to read the table at different speeds and with variable amplitude so that the
range of delay times can be expanded or compressed. The output of the oscillator
then modulates the ﬂanger.
Listing 22.2 demonstrates the principle. It uses an instrument adapted from the
piece, which reads the source ﬁle directly, and then places it in the ﬂanger. In the
actual work, the signal feeding the variable delay is taken from the two spectral
delay mix channels. However, this example shows the raw effect very clearly, and
we can hear how it relates to the other materials in the piece.
Listing 22.2 Variable delay line processing, with feedback, moving from echoes to resonant ﬁl-
tering
nchnls = 2
gifn1 ftgen 3,0,1024,-5,
.5,102,
.5,52,
.01,802,
.001,70,.5
instr 10
asig
diskin2 "src1x.wav",1
aspeed line p5, p3, p6
adelnv linseg p4, p3-20,p4,10,p7,10,p4
a1 oscili adelnv,1/aspeed,gifn1
asig1 flanger asig*0.2,a1,p8,1
asig2 flanger asig*0.2,0.501-a1,p8,1
asi2 dcblock
asig2
asi1 dcblock
asig1
492
22 Victor Lazzarini: Noctilucent Clouds
outs asig1,asig2
endin
schedule(10,0,140,1,60,30,0.01,0.99)
In the ﬁnal code, I have four versions with slight variations of this instrument
used for different sections of the work. They also incorporate the long feedback path
between source input and process output, which is discussed in the next section.
22.2.3 Feedback
The instrument designs discussed in the previous sections are also connected to-
gether via a global feedback path, which takes the output of the ﬂanger and mixes it
back into the spectral delay input. This places a delay of ksmps samples in the return
path. Due to the fact that the spectral delay output is placed at a higher instrument
than the ﬂanger, we have one further ksmps block delay. Spectral processing also
places a latency equivalent to N +h, where N is the DFT size and h is the hopsize,
between its input and its output. By making ksmps equal to h and N four times this
value, we have a total feedback delay of 7×h.
In the piece, the total feedback delay is equivalent to about 3.73 ms, creating a
comb ﬁlter with a fundamental at around 268.1 Hz. I also placed an inverse comb
in the feedback path, with a varying delay time, which alters some of the high-
frequency comb ﬁlter peaks. The effect of the feedback line sharpens some of the
gestures used in the piece. It needs to be controlled carefully, otherwise it can get
very explosive in some situations.
Listing 22.3 shows an input connected to the ﬂanger effect, with a high ksmps
to mimic the effect in the piece. It does not include the spectral delays for sake of
simplicity, but it demonstrates how the feedback connection can affect the ﬂanger
process output. A representation of the total feedback path in the piece is shown in
Fig. 22.1.
Listing 22.3 Feedback path from ﬂanger output back to input as used in the piece
nchnls=2
ksmps=1792
gifn1 ftgen 3,0,1024,-5,
.5,102,
.5,52,
.01,802,
.001,70,.5
gafdb init 0
instr 1
gamix
= diskin2:a("src1x.wav",1) + gafdb
endin
schedule(1,0,140)
22.3 Source Sounds
493
instr 10
aspeed line p6, p3, p7
adelnv linseg p5, p3-20,p5,10,p8,10,p5
a1 oscili adelnv,1/aspeed,gifn1
asig1 flanger gamix,a1,p11,5
asig2 flanger gamix,0.501-a1,p11,5
afdb line
p9,p3,p10
ak1 expseg 0.001,5,p4,p3-5,p4,1,0.001
asi2 dcblock
asig2*ak1
asi1 dcblock
asig1*ak1
gafdb = asi1*afdb + asi2*afdb
adel oscili adelnv, -1/aspeed,gifn1
afdb vdelay
gafdb,adel,1
gafdb =(afdb + gafdb)*0.5
asi1 clip asi1,0,0dbfs
asi2 clip asi2,0,0dbfs
outs asi2, asi1
endin
schedule(10,0,140,0.1,1,60,30,0.01,0.2,0.2,0.99)
spectral delays
?
z−ksmps
?
z−ksmps
ﬂanger
?
i
×
?
 gain
6
icomb
6
- i
+?
?
Fig. 22.1 The complete feedback signal path between instruments in the Noctilucent Clouds code.
The boxes marked z−ksmps denote ksmps-sample delays
22.3 Source Sounds
Conceptually, the source sounds for this piece are not particularly important. Any
audio material with a reasonably complex and time-varying spectrum would do.
494
22 Victor Lazzarini: Noctilucent Clouds
In practice, however, once I settled for the ﬁnal sources used, I started to tune the
transformations to make the most of their characteristics. Thus, in the process, they
became an integral part of the work.



	


	


















   
  
 

 
  


 

  
  
 	 
 	


 
  
 
 	
 

     
  


 
 


 
















	
 










 

 
 

 






























  



  

    


  

 
 
 


  



  














 




 

 











 
 



 




 













 



 





 
  
 


 


 


  











   































	




 	


 
	


 







 




  














    
   


  
 






  



 


  

    


 

  
















 	




 




 


 



 





 



 























 




 



 



 






  



  



    


   




  
















 	





	



  





 



 




 














 





 

  
 
   





   


   
 



 



 



  


  


















 













 



 








 





	




 	




 	


 










 
   

  








  


 












Fig. 22.2 The ﬁrst page of the piano score for Time-Lines IV, which is used as the source material
for the transformations in Noctilucent Clouds
The selection of these was made more or less randomly with various recordings
I had at hand. After trying different types of materials, I experimented with the
recording of one of my instrumental pieces, Time-Lines IV for piano. The actual
22.4 Large-Scale Structure
495
version used was an early draft containing half of the ﬁnal work, whose last few
bars ended up being edited out of the score. As this seemed to have worked well
for the beginning of the piece, I brought in a recording of the second half of the
ﬁnished piece to complement it. This had the effect of shaping the overall piece in
two sections. The start of the piano score is shown in Fig. 22.2.
The piece uses a lot of repeated-note rhythmic ﬁgures, which get scrambled once
they pass through the spectral delay processing. The thickening of the texture caused
by this, the variable delays and the feedback obscures almost completely the origi-
nal texture, casting a veil over it. This is one of the key ideas I wanted to explore in
the piece, how the signal processing can build sound curtains that hide the original
sounds from the listener. It also gives the title to the piece: Noctilucent Clouds are
the visible edge of a much brighter polar cloud layer in the upper atmosphere, a
metaphor for the original musical material that lies on the other side of the process-
ing veil.
22.4 Large-Scale Structure
The work is divided evenly into two sections of 241 seconds (4:01 minutes). These
two sections form, from the point of view of dynamics, an inverted arch, with a dip
and a short silence in the middle. This is also slightly translated to the musical mate-
rials, as the big intense sections at the start and end have a certain common textural
quality. However,no real repetition of sonic material is audible, even though the un-
derlying piano piece is actually structured as an ABA form. The transformations
are worked in different ways, providing the variation between the beginning and the
ﬁnal sections.
The overarching principle of hiding the sources dominates almost the whole of
the piece, but not completely, as the piano music is revealed at the end of the work.
The idea here is to lift the veil and let the original source show its face. As it coin-
cides with the end of the piano score, it works as a ‘composed’ end for the piece,
and it provides a ready-made solution for the tricky issue of ﬁnishing the work. The
ﬁnal few bars of the piano piece are shown in Fig. 22.3, where we can observe that
the descending gesture has a deﬁnite ‘concluding’ characteristic.
It is fair to say that, beyond a few general ideas, such as this ‘hiding and then re-
vealing’ concept, no special effort was made to deﬁne the large-scale structure very
precisely prior to the actual composition process. This can be attributed to the fact
that the underlying piano work was already very well deﬁned in structural terms.
Although this music is hidden from the listener, it actually provides the shape for
the transformations that were imposed on it, as I tuned and adjusted the instruments
to make the most of the source material. This is evident in the fact that the afore-
mentioned dip in the middle is also a feature of the piano score, which is dominated
by rhythmically intense and frantic outer sections, and a quieter, steadier middle.
496
22 Victor Lazzarini: Noctilucent Clouds

















 



 









 











 


 











 
	







 


  
 


 
   

       
          
      
  













 



 









 

 











 



 




 

   


 
  
    

  


 
    
   




Fig. 22.3 The ﬁnal bars of the score, where the piano music is ﬁnally fully revealed to the listener
22.5 Post-production
Once the piece was ﬁnalised, a ﬁnal step was required to give it a more polished
form. It is often the case with some of the more unusual processing techniques
(especially with spectral methods), that many of the interesting sound results are
somewhat raw and unbalanced, sometimes leaning too heavily on certain frequency
bands, or lacking energy in others. The process also led to some sections being too
loud in comparison to others, and an adjustment of the overall amplitude curve was
needed.
To implement these post-production, mastering requirements, I routed all the au-
dio to a main output instrument, shown in listing 22.4. This allowed me to make all
the necessary changes to overall output, without having to modify a very complex
code, which relies on very delicately poised and precise parameter settings. In this
instrument, I used a graphic equaliser to adjust the overall spectral envelope, and
an envelope generator to balance the amplitude of the various sections. This instru-
ment runs from the beginning to the end, and is responsible for switching Csound
off when the piece ends (using an ‘e’ event). It also prints time and rms values each
second as it runs.
Listing 22.4 Main output instrument, taking the signals from all sources, and applying equalisa-
tion and volume adjustments
instr 1000
al = gaout1 + gaout3 + gaeff1
ar = gaout2 + gaout4 + gaeff2
ig1 = ampdb(1)
ig2 = ampdb(-1.44)
ig3 = ampdb(-2.88)
ig4 = ampdb(-3.84)
ig5 = ampdb(-4.56)
ig6 = ampdb(-3.36)
ig7 = ampdb(-1.68)
22.5 Post-production
497
ig8 = ampdb(2.88)
ig9 = ampdb(6)
aleq eqfil al,
75,
75,ig1
aleq eqfil aleq, 150, 150,ig2
aleq eqfil aleq, 300, 300,ig3
aleq eqfil aleq, 600, 600,ig4
aleq eqfil aleq,1200,1200,ig5
aleq eqfil aleq,2400,2400,ig6
aleq eqfil aleq,4800,4800,ig7
aleq eqfil aleq,9600,9600,ig8
al
eqfil aleq,15000,10000,ig9
aleq eqfil ar,
75,
75,ig1
aleq eqfil aleq, 150, 150,ig2
aleq eqfil aleq, 300, 300,ig3
aleq eqfil aleq, 600, 600,ig4
aleq eqfil aleq,1200,1200,ig5
aleq eqfil aleq,2400,2400,ig6
aleq eqfil aleq,4800,4800,ig7
aleq eqfil aleq,9600,9600,ig8
ar
eqfil aleq,15000,10000,ig9
again1 expseg 8,30, 2,15,
1.5,30,1,45, 1,20,
1,25, 2,55,1,140,
1,30,
2,30, 1.8,30,
3,30,3
again2 expseg 8,30,2,15,
2,30, 2,45,2,20,
2,25,1,55,1,140,
1,30,2,30,1.8,30,
3,30,3
asig_left =
al*again1*0.94
asig_right =
ar*again2*0.8
outs asig_left,asig_right
ktrig = int(times:k())
printf "%ds - L:%.1f R:%.1f \n",
ktrig,ktrig,
rms(asig_left),
rms(asig_right)
gaout1 = 0
gaout2 = 0
gaout3 = 0
gaout4 = 0
gaeff1 = 0
gaeff2 = 0
xtratim 0.1
498
22 Victor Lazzarini: Noctilucent Clouds
if release() == 1 then
event "e", 0, 0
endif
endin
schedule(1000,0,482)
Feeding this instrument are three sources per channel: the direct spectral envelope
output, the ﬂanger signal and an effect bus that is used for reverb in the middle
section, and for a string resonator at the end. This approach also allows me to create
other versions that can use different routings for the sources, and/or create speciﬁc
EQ and amplitude adjustments for a given performance situation.
22.5.1 Source Code Packaging
One ﬁnal detail is how to make the piece available. As a ﬁxed-medium work, a
soundﬁle or a CD recording would appear to be sufﬁcient. However, it is possible
to take advantage of the fact that the whole work is deﬁned by its source code and
distribute it as a Csound ﬁle (CSD). The advantage is that it allows the piece to be
studied and even reused in other settings, as well as adjusted for speciﬁc perfor-
mance venues (e.g. equalisation, amplitude control etc.). Most modern computers
would have no problem in running the work in real time, so even ofﬂine rendering
is not at all necessary. All we need is to have Csound installed.
The only issue to be resolved is how to make the two audio source ﬁles available.
We could package them as an archive, but there is a more ﬂexible way. We can take
advantage of the CSD functionality and include the source ﬁles together with the
code. They are encoded and added as two extra sections with their associated tags at
the end of the CSD. When Csound runs it unpacks the ﬁles, and performs the piece.
Packaging is done with the makecsd utility. From the command line, we can just
do
makecsd -o noctilucent.csd noctilucent.orc \
src1x.wav src2x.wav
and the result will be a CSD ﬁle noctilucent.csd containing the piece and its audio
sources. This will be a large ﬁle (111 MB) as it contains all the audio data, but any
high-quality rendering of the piece would exceed that, so there is no trade-off.
22.6 Conclusions
This chapter explored the process of composing a ﬁxed-media piece using Csound
as the only software resource. It employed some non-standard methods such as spec-
tral delays, together with a classic technique of ﬂanging to completely transform its
source material. If anything is to be learned at all from this case study, and indeed
22.6 Conclusions
499
from this book, it is that experimenting is good, and experimenting with knowledge
and skill is even better. Also while we should try to be deﬁnite and precise about
what we do, it is never a problem to let chance and lucky coincidences play a part
in the process.
Another important thing to note is that complicated-looking orchestras are often
arrived at in stages, with earlier versions using few components, and more function-
ality added as the piece gets developed. This allows the work to grow organically
from a few basic principles into more complex structures. Simplicity and elegance
go together well, and it is from one that we get to the other.
Noctilucent Clouds was premiered in Edinburgh, October 2012. It has also
spawned a sister piece, Timelines + Clouds, for piano and live electronics, which
turns the process inside out, exposing the piano, and creating the ‘clouds’ around it.
It shares some instruments and processing ideas with this piece, and it is designed
to be performed with Csound, of course.
References