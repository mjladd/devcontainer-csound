---
source: Csound Reference Manual
url: https://csound.com/docs/manual/cntDelete_i.html
opcode: cntDelete_i
category: Instrument Control:Sensing and Control
description: "Delete a counter...."
related: ["Program Flow Control: Counter"]
---

<!--
id:cntDelete_i
category:Instrument Control:Sensing and Control
-->
# cntDelete_i
Delete a counter.

Plugin opcode in counter and render any memory used.

## Syntax
=== "Modern"
    ``` csound-orc
    ival = cntDelete_i(icnt)
    ```

=== "Classic"
    ``` csound-orc
    ival cntDelete_i icnt
    ```

### Initialization

_icnt_ -- the handle of a counter object from a call to _cntCreate_.

### Performance

_ival_ -- the handle deleted or a negative number if there was no such counter.

## See also

[Program Flow Control: Counter](../control/pgmctl.md)

## Credits

By: John ffitch August 2020

New in version 6.16
