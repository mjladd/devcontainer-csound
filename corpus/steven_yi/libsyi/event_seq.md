# event_seq - Steven Yi's UDO Library

## Metadata

- **Source:** libsyi (Steven Yi's UDO Library)
- **Repository:** https://github.com/kunstmusik/libsyi.git
- **Author:** Steven Yi
- **License:** MIT
- **Opcodes Defined:** event_seq
- **Tags:** `udo`, `libsyi`, `steven-yi`, `event_seq`

---

## Description

User-defined opcode from Steven Yi's libsyi collection.

---

## Code

```csound

opcode event_seq, 0, aSK
  atrig, Sinstr_nam, kdur xin

  kndx = 0
  while (kndx < ksmps) do
    if(atrig[kndx] == 1) then
      event "i", Sinstr_nam, 0, kdur
    endif
    kndx += 1
  od
endop


opcode event_seq, 0, aSKK
  atrig, Sinstr_nam, kdur, kp4 xin

  kndx = 0
  while (kndx < ksmps) do
    if(atrig[kndx] == 1) then
      event "i", Sinstr_nam, 0, kdur, kp4
    endif
    kndx += 1
  od
endop


opcode event_seq, 0, aSKKK
  atrig, Sinstr_nam, kdur, kp4, kp5 xin

  kndx = 0
  while (kndx < ksmps) do
    if(atrig[kndx] == 1) then
      event "i", Sinstr_nam, 0, kdur, kp4, kp5
    endif
    kndx += 1
  od
endop

```

---

## Usage

Include this UDO in your Csound orchestra:

```csound
#include "event_seq.udo"
```

