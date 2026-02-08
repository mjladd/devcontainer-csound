---
source: Csound Reference Manual
url: https://csound.com/docs/manual/qnan.html
opcode: qnan
category: Mathematical Operations:Mathematical Functions
description: "Returns the number of times the argument is not a number...."
related: ["Mathematical Functions"]
---

<!--
id:qnan
category:Mathematical Operations:Mathematical Functions
-->
# qnan
Returns the number of times the argument is not a number.

## Syntax
``` csound-orc
qnan(x) (no rate restriction)
```

## Examples

Here is an example of the qnan opcode. It uses the file [qnan.csd](../examples/qnan.csd).

``` csound-csd title="Example of the qnan opcode." linenums="1"
--8<-- "examples/qnan.csd"
```

## See also

[Mathematical Functions](../math/mathfunc.md)

## Credits

Written by John ffitch.

New in Csound 5.14
