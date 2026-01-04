# CSound Notes

## Terminology

- arguments: the inputs to an opcode
  - `poscil(0.2, 400)`
- opcode: a processing unit (built-in function) in CSound
  - audio signal (a), produces a new value with every sample (ex. 44.1k times a second)
  - `aSine = poscil:a(0.2, 400)`
  - `outall(aSine) # aSine is sent out all audio channels`

## Example Instrument

```csound
instr hello
  aSine = poscil:a(0.2, 400)
  outall(aSine)
endin
```

## Example Score

```csound
<CsoundSynthesizer>
<CsOptions>
-o dac
</CsOptions>

<CsInstruments>
sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 1

instr hello                  # keywork to start an instrument
  aSine = poscil:a(0.2, 400) # oscillator at audio rate
  outall(aSine)              # outputs aSignal to all output channels
endin                        # keyword to end an instrument
</CsInstruments>

<CsScore>
i "Hello" 0 2
</CsScore>
</CsoundSynthesizer>
```
