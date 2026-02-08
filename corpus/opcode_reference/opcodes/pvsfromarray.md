---
source: Csound Reference Manual
url: https://csound.com/docs/manual/pvsfromarray.html
opcode: pvsfromarray
category: Spectral Processing:Streaming
description: "Same as the [tab2pvs](../opcodes/tab2pvs.md) opcode...."
related: []
---

<!--
id:pvsfromarray
category:Spectral Processing:Streaming
-->
# pvsfromarray
Same as the [tab2pvs](../opcodes/tab2pvs.md) opcode.

## Syntax
=== "Modern"
    ``` csound-orc
    fsig = pvsfromarray(karr[] [,ihopsize, iwinsize, iwintype])
    fsig = pvsfromarray(kmags[], kfreqs[] [,ihopsize, iwinsize, iwintype])
    ```

=== "Classic"
    ``` csound-orc
    fsig pvsfromarray karr[] [,ihopsize, iwinsize, iwintype]
    fsig pvsfromarray kmags[], kfreqs[] [,ihopsize, iwinsize, iwintype]
    ```
