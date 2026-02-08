---
source: Csound Reference Manual
url: https://csound.com/docs/manual/pvs2array.html
opcode: pvs2array
category: Spectral Processing:Streaming
description: "Same as the [pvs2tab](../opcodes/pvs2tab.md) opcode...."
related: []
---

<!--
id:pvs2array
category:Spectral Processing:Streaming
-->
# pvs2array
Same as the [pvs2tab](../opcodes/pvs2tab.md) opcode.

## Syntax
=== "Modern"
    ``` csound-orc
    kframe = pvs2array(kvar[], fsig)
    kframe = pvs2array(kmags[], kfreqs[], fsig)
    ```

=== "Classic"
    ``` csound-orc
    kframe pvs2array kvar[], fsig
    kframe pvs2array kmags[], kfreqs[], fsig
    ```
