# gatesig - Steven Yi's UDO Library

## Metadata

- **Source:** libsyi (Steven Yi's UDO Library)
- **Repository:** https://github.com/kunstmusik/libsyi.git
- **Author:** Steven Yi
- **License:** MIT
- **Opcodes Defined:** gatesig
- **Tags:** `udo`, `libsyi`, `steven-yi`, `gatesig`

---

## Description

User-defined opcode from Steven Yi's libsyi collection.

---

## Code

```csound
/* gatesig - outputs gate signal
   uses atrig signal to trigger when sample == 1; holds for
   khold amount of time in seconds */
opcode gatesig, a, ak
  atrig, khold xin

  kcount init 0
  asig init 0

  kndx = 0
  kholdsamps = khold * sr
  while (kndx < ksmps) do
    if(atrig[kndx] == 1) then
      kcount = 0
    endif

    asig[kndx] = (kcount < kholdsamps) ? 1 : 0 

    kndx += 1
    kcount += 1
  od

  xout asig

endop


```

---

## Usage

Include this UDO in your Csound orchestra:

```csound
#include "gatesig.udo"
```

