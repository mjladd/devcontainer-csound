---
source: Csound Reference Manual
url: https://csound.com/docs/manual/opbitshr.html
opcode: opbitshr
category: Mathematical Operations:Arithmetic and Logic Operations
description: "Bitshift right operator...."
related: ["Arithmetic and Logic Operations"]
---

<!--
id:opbitshr
category:Mathematical Operations:Arithmetic and Logic Operations
-->
# &gt;&gt;
Bitshift right operator.

The bitshift operators shift the bits to the left or to the right the number of bits given.

The priority of these operators is less binding that the arithmetic ones, but more binding that the comparisons.

Parentheses may be used as above to force particular groupings.

## Syntax
``` csound-orc
a >> b  (bitshift left)
```

where the arguments $a$ and $b$ may be further expressions.

## Examples

See the entry for the [&lt;&lt;](../opcodes/opbitshl.md) operator for an example.

## See also

[Arithmetic and Logic Operations](../math/artlogic.md)
