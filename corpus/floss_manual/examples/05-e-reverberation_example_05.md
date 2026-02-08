# 05 E. REVERBERATION - Code Example 6

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** 05-e-reverberation
- **Section:** Method III: chn opcodes
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `05`

---

## Code

```csound
<CsoundSynthesizer>
<CsOptions>
-odac ; activates real time sound output
</CsOptions>
<CsInstruments>

sr =  44100
ksmps = 32
nchnls = 2
0dbfs = 1

  instr 1 ; sound generating instrument - sparse noise bursts
kEnv         loopseg   0.5,0, 0,1,0.003,1,0.0001,0,0.9969,0,0 ; amp. envelope
aSig         pinkish   kEnv                                 ; noise pulses
             outs      aSig, aSig                           ; audio to outs
iRvbSendAmt  =         0.4                        ; reverb send amount (0 - 1)
;write audio into the named software channel:
             chnmix    aSig*iRvbSendAmt, "ReverbSend"
  endin

  instr 5 ; reverb (always on)
aInSig       chnget    "ReverbSend"   ; read audio from the named channel
kTime        init      4              ; reverb time
kHDif        init      0.5            ; 'high frequency diffusion' (0 - 1)
aRvb         nreverb   aInSig, kTime, kHDif ; create reverb signal
outs         aRvb, aRvb               ; send audio to outputs
             chnclear  "ReverbSend"   ; clear the named channel
endin

</CsInstruments>
<CsScore>
i 1 0 10 ; noise pulses (input sound)
i 5 0 12 ; start reverb
</CsScore>
</CsoundSynthesizer>
;example by Iain McCurdy
```

---

## Context

This code example is from the FLOSS Manual chapter "05 E. REVERBERATION".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/05-e-reverberation.md](../chapters/05-e-reverberation.md)
