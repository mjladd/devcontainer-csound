<CsoundSynthesizer>
<CsOptions>
-odac Logic_out.aiff
</CsOptions>
<CsInstruments>

sr       = 44100
kr       = 44100
ksmps    = 1
nchnls   = 2


instr    1 ; AND/NAND gate - Complementary outputs

ilevl    = p4                          ; Output level

ain1     soundin  "../scores/samples/apoc.aiff"
ain2     soundin  "../scores/samples/female.aiff"

kin1     downsamp  ain1                ; Convert to kr
kin2     downsamp  ain2                ; Convert to kr
k1       = ( kin1 > 0 ? 1 : 0 )        ; See if above zero crossing line
k2       = ( kin2 > 0 ? 1 : 0 )        ; See if above zero crossing line
if       k1 + k2 == 2 goto and1        ; If both above, goto and1
goto     and2
and1:
aand     = 1                           ; Set AND gate to 1...
goto     out                           ; ...then goto out
and2:
aand     = 0                           ; Set AND gate to 1
out:
outs1    aand*(ain1 + ain2)            ; AND gate signals and output L
outs2    (1 - aand)*(ain1 + ain2)      ; NAND gate signals and output R

endin

instr    2 ; Exclusive OR gate - Complementary outputs

ilevl    = p4                          ; Output level

ain1     soundin  "../scores/samples/apoc.aiff"
ain2     soundin  "../scores/samples/apoc.aiff"

kin1     downsamp  ain1                ; Convert to kr
kin2     downsamp  ain2                ; Convert to kr
k1       = ( kin1 > 0 ? 1 : 0 )        ; See if above zero crossing line
k2       = ( kin2 > 0 ? 1 : 0 )        ; See if above zero crossing line
if       k1 + k2 == 0 goto xor1        ; If both below, goto xor1
if       k1 + k2 == 1 goto xor2        ; If 1 below goto xor2
xor1:                                  ; If neither below, also go to xor1
aexor    = 0                           ; Set Exclusive OR gate to 0...
goto     out                           ; ...then goto out
xor2:
aexor    = 1                           ; Set Exclusive OR gate to 1
out:
outs1    aexor*ain1 + (1 - aexor)*ain2 ; Gate signals and output L
outs2    (1 - aexor)*ain1 + aexor*ain2 ; Gate signals and output R

endin

</CsInstruments>
<CsScore>
;AND/NAND
;     Strt  Leng  Levl
i01   0.00  1.50  1.00

;Exclusive OR
;     Strt  Leng  Levl
i02   2.00  1.50  1.00
e

</CsScore>
</CsoundSynthesizer>
