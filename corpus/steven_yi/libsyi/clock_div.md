# clock_div - Steven Yi's UDO Library

## Metadata

- **Source:** libsyi (Steven Yi's UDO Library)
- **Repository:** https://github.com/kunstmusik/libsyi.git
- **Author:** Steven Yi
- **License:** MIT
- **Opcodes Defined:** clock_div
- **Tags:** `udo`, `libsyi`, `steven-yi`, `clock_div`

---

## Description

User-defined opcode from Steven Yi's libsyi collection.

---

## Code

```csound
/* clock_div - divides clock signal by given integer amount
   uses atrig signal to trigger when sample == 1 */


opcode clock_div, a, ak
  atrig, kdiv xin

  kcount init 1000
  asig init 0

  kndx = 0
  while (kndx < ksmps) do
    if(atrig[kndx] == 1) then
      kcount += 1

      if(kcount >= kdiv) then
        asig[kndx] = 1
        kcount = 0
      else
        asig[kndx] = 0
      endif
    else
      asig[kndx] = 0
    endif

    kndx += 1
  od

  xout asig
endop


```

---

## Usage

Include this UDO in your Csound orchestra:

```csound
#include "clock_div.udo"
```
