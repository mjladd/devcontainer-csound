---
source: Csound Reference Manual
url: https://csound.com/docs/manual/st2ms.html
opcode: st2ms
category: Signal Modifiers:Panning and Spatialization
description: "Stereo to Mid-Side Conversion...."
related: ["Panning and Spatialization: Amplitude spatialization"]
---

<!--
id:st2ms
category:Signal Modifiers:Panning and Spatialization
-->
# st2ms
Stereo to Mid-Side Conversion.

It is a pure function with no side effects.

## Syntax
=== "Modern"
    ``` csound-orc
    am,as = st2ms(aleft,aright)
    ```

=== "Classic"
    ``` csound-orc
    am,as st2ms aleft,aright
    ```

### Performance

_am_ -- mid signal output.

_as_ -- side signal output.

_aleft_ -- left channel input.

_aright_ -- right channel input.

## Examples

Here is an example of the st2ms opcode. It uses the files [st2ms.csd](../examples/st2ms.csd) and [stereoJungle.wav](../examples/stereoJungle.wav).

``` csound-csd title="Example of the st2ms opcode." linenums="1"
--8<-- "examples/st2ms.csd"
```

## See also

[Panning and Spatialization: Amplitude spatialization](../sigmod/panspatl.md)

## Credits

Author: Victor Lazzarini<br>
April 2021<br>
