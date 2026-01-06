# seqsig - Steven Yi's UDO Library

## Metadata

- **Source:** libsyi (Steven Yi's UDO Library)
- **Repository:** https://github.com/kunstmusik/libsyi.git
- **Author:** Steven Yi
- **License:** MIT
- **Opcodes Defined:** seqsig
- **Tags:** `udo`, `libsyi`, `steven-yi`, `seqsig`

---

## Description

User-defined opcode from Steven Yi's libsyi collection.

---

## Code

```csound
/* seqsig - plays sequence of values from k-array and outputs
   a-rate signal
*/

#ifndef SEQSIG_UDO
#define SEQSIG_UDO # 1 #

opcode seqsig, a, ak[]
  agate, kpattern[] xin

  aout init 0
  karrlen = lenarray:k(kpattern)
  kpatindx init (lenarray:i(kpattern) - 1)

  kindx = 0
  while (kindx < ksmps) do
    if(agate[kindx] == 1) then 
      kpatindx = (kpatindx + 1) % karrlen
    endif

    aout[kindx] = kpattern[kpatindx]
    kindx += 1
  od

  xout aout

endop


opcode seqsig, k, ak[]
  agate, kpattern[] xin

  kout init 0
  karrlen = lenarray:k(kpattern)
  kpatindx init (lenarray:i(kpattern) - 1)

  kindx = 0
  while (kindx < ksmps) do
    if(agate[kindx] == 1) then 
      kpatindx = (kpatindx + 1) % karrlen
      kout = kpattern[kpatindx]
    endif

    kindx += 1
  od

  xout kout

endop

#endif


```

---

## Usage

Include this UDO in your Csound orchestra:

```csound
#include "seqsig.udo"
```

