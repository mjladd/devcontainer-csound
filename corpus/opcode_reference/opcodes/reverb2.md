---
source: Csound Reference Manual
url: https://csound.com/docs/manual/reverb2.html
opcode: reverb2
category: Signal Modifiers:Reverberation
description: "Same as the [nreverb](../opcodes/nreverb.md) opcode...."
related: []
---

<!--
id:reverb2
category:Signal Modifiers:Reverberation
-->
# reverb2
Same as the [nreverb](../opcodes/nreverb.md) opcode.

## Syntax
=== "Modern"
    ``` csound-orc
    ares = reverb2(asig, ktime, khdif [, iskip] [,inumCombs] [, ifnCombs] \
                   [, inumAlpas] [, ifnAlpas])
    ```

=== "Classic"
    ``` csound-orc
    ares reverb2 asig, ktime, khdif [, iskip] [,inumCombs] [, ifnCombs] \
                 [, inumAlpas] [, ifnAlpas]
    ```
