---
source: Csound Reference Manual
url: https://csound.com/docs/manual/strlen.html
opcode: strlen
category: Strings:Manipulation
description: "Return the length of a string, or zero if it is empty. strlen runs at init time only...."
related: ["String Manipulation Opcodes"]
---

<!--
id:strlen
category:Strings:Manipulation
-->
# strlen
Return the length of a string, or zero if it is empty. strlen runs at init time only.

## Syntax
=== "Modern"
    ``` csound-orc
    ilen = strlen(Sstr)
    ```

=== "Classic"
    ``` csound-orc
    ilen strlen Sstr
    ```

## See Also

[String Manipulation Opcodes](../strings/manipulate.md)

## Credits

Author: Istvan Varga<br>
2006<br>

New in version 5.02
