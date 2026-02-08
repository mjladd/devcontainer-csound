---
source: Csound Reference Manual
url: https://csound.com/docs/manual/strlowerk.html
opcode: strlowerk
category: Strings:Conversion
description: "Convert Ssrc to lower case, and write the result to Sdst...."
related: ["String Conversion Opcodes"]
---

<!--
id:strlowerk
category:Strings:Conversion
-->
# strlowerk
Convert Ssrc to lower case, and write the result to Sdst.

_strlowerk_ runs both at init and performance time.

## Syntax
=== "Modern"
    ``` csound-orc
    Sdst = strlowerk(Ssrc)
    ```

=== "Classic"
    ``` csound-orc
    Sdst strlowerk Ssrc
    ```

## See Also

[String Conversion Opcodes](../strings/convert.md)

## Credits

Author: Istvan Varga<br>
2006<br>

New in version 5.02
