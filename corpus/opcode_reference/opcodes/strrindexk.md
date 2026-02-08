---
source: Csound Reference Manual
url: https://csound.com/docs/manual/strrindexk.html
opcode: strrindexk
category: Strings:Manipulation
description: "Return the position of the last occurence of S2 in S1, or -1 if not found. If S2 is empty, the length of S1 is returned...."
related: ["String Manipulation Opcodes"]
---

<!--
id:strrindexk
category:Strings:Manipulation
-->
# strrindexk
Return the position of the last occurence of S2 in S1, or -1 if not found. If S2 is empty, the length of S1 is returned.

_strrindexk_ runs both at init and performance time.

## Syntax
=== "Modern"
    ``` csound-orc
    kpos = strrindexk(S1, S2)
    ```

=== "Classic"
    ``` csound-orc
    kpos strrindexk S1, S2
    ```

## See Also

[String Manipulation Opcodes](../strings/manipulate.md)

## Credits

Author: Istvan Varga<br>
2006<br>

New in version 5.02
