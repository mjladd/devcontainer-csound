---
source: Csound Journal
issue: 18
title: "Csound Eurorack Module"
author: "the German company Doepfer in"
url: https://csoundjournal.com/issue18/eurorack.html
---

# Csound Eurorack Module

**Author:** the German company Doepfer in
**Issue:** 18
**Source:** [Csound Journal](https://csoundjournal.com/issue18/eurorack.html)

---

CSOUND JOURNAL[](https://csoundjournal.com/index.html) | [Issue 18](https://csoundjournal.com/index.html)
## Csound Eurorack Module

### Building an FM oscillator in the Eurorack format using Csound, a Raspberry Pi, and an Arduino Uno
 Andrew Ikenberry and Jason Lim
 aikenberry AT berklee.edu
 jhjl AT me.com
## Introduction


Analog modular synthesizers and embedded systems are currently enjoying a large amount of attention due to the arrival of extremely cost effective and unbelievably powerful devices. This article will describe the process of building a Eurorack FM oscillator using Csound's `foscili` opcode. The module will have three potentiometers with associated control voltage inputs, 1/v per octave pitch tracking, a push button for powering down, and a push button which cycles through 4 possible portamento times.
## I. Eurorack


The Eurorack modular synthesizer format was started by the German company Doepfer in 1995. A Eurorack module must be 5 ¼" tall, and run on a ±12V power supply with the option of adding an additional +5V on the bus board. Control Voltage signals must fall within ±2.5V and connections between modules use 3.5mm TS connections. The majority of modules on the market have an aluminum faceplate but for DIY projects, plexi glass, PCB material, or even cardboard will suffice. To connect a module to a standard Eurorack case's power supply, a ribbon cable is used. The cable can have a 10 or 16 pin connector. For modules not requiring the additional +5v from the case, the 10-pin connector will be adequate[[1]](https://csoundjournal.com/#ref1).
## II. Arduino

### About Arduino


Arduino is an open-source micro-controller platform used by hobbyists and developers for prototyping and designing interactive tools, products, artworks and general household gizmos. The platform emerged from Ivrea, Italy in 2005 to aid student physical computing projects. It has since blossomed into an array of very affordable micro-controllers of all shapes and sizes. There has been a growing community of Arduino users who use the platform to build custom MIDI controllers using the vast array of sensors and technologies readily available from online suppliers like Sparkfun[[2]](https://csoundjournal.com/#ref2).
### DIY Arduino UNO


A perk to Arduino's open-source philosophy is the freedom to build Arudinos yourself in your own preferred format. The Arduino UNO is one of the platform's more popular devices and houses an ATMega328 IC as its brain. This little THT 8-bit chip can be purchased pre-flashed with the Arduino boot-loader for little over $5. The following schematic (fig1.) shows how to construct an Arduino UNO without the standard development board. It will require a timing source (16MHz crystal oscillator) and regulated 5V power source to complete the basic stand alone circuit. Flashing the chip with an Arduino sketch is easily done using an Arduino UNO to temporarily house the chip on its 28 pin DIP socket. A small flathead screwdriver will easily remove chips from the board. Be aware to match the notch on the IC with the notch on the socket, and be gentle with the legs. (Flashing the solo chip is also possible using a USB-FTDI breakout circuit.)

Pins 23 to 28 are the Analog inputs A0 through A5 respectively. These can receive variable voltages from 0V to 5V. 10KΩ linear tapered potentiometers work nicely as physical MIDI controls. The 10KΩ pull-down resistors grounding the buttons eliminate the need for software de-bouncing. ![](eurorack/ArduinoDiagram.png)

**Figure 1. ATMega328 chip circuit with analog inputs from 3 potentiometers and 3 control voltage sources (source must be unipolar positive 0-5V). MIDI output from TX pin is linked to an opto-isolator chip. (6N137 is shown but many other optocouplers may be used instead.)**
### Control Voltage to Arduino


Control Voltage (CV) standards for Eurorack are bipolar signals that range from -2.5V to +2.5V. The analog to digital convertors (ADC's) on the Arduino can receive only unipolar positive voltages up to 5V. This requires our CV source to be biased into a positive signal before being accepted by the Arduino chip. An operational-amplifier (op-amp) can be used to perform this task. The TL074 14 pin IC from Texas Instruments contains 4 op-amps. Fig2. shows a TL074 with 3 of the op-amps receiving CV inputs through voltage dividers. These attenuation networks scale any incoming signals to a little over a quarter of the initial input voltage, which is then biased by the op-amp. The op-amp outputs then lead into an optional protective circuit, which stops any negative voltage bleed from reaching the Arduino. The maximum voltage is also limited to 5V. (This diode network may not be required but in the authors' experiences some issues arose when expanding the circuit.) ![](eurorack/ArduinoDiagram.png)

**Figure 2. TL074 op-amp chip. CV inputs enter via a voltage divider. Outputs lead to a diode protection circuit before reaching the Arduino ADC's. (Based on the Tabula Rasa schematic by Greg Surges[[3]](https://csoundjournal.com/#ref3))**
### CV to MIDI


The final step in the controller circuit design is bridging the gap between the MIDI signal generated by the Arduino, and the Raspberry Pi. There is a standard USB-MIDI protocol followed by most modern USB MIDI interfaces and devices. Many of these are class compliant, meaning no driver installation is necessary. Conversion from standard MIDI to USB-MIDI is the simplest way to get the Raspberry Pi to read our Arduino MIDI controller's messages. Many companies offer out-the-box interfaces that perform this task. M-Audio offers the Uno - 1-In/1-Out USB bus-powered MIDI interface[[4]](https://csoundjournal.com/#ref4).

If size is a concern, one particular solution is the GM5 IC offered by Ploytec[[5]](https://csoundjournal.com/#ref5). This chip is a QFN 32 pin IC, a surface mount device that will require a breakout board to easily integrate into a larger circuit. (Schmartboard offer a 32 - 64 pin, 0.8mm Pitch breakout board for those less experienced with SMD soldering.)

The GM5 is based on ATMEL's 90USB162 chip flashed with firmware developed by Ploytec. The chip is recognized by the Raspberry Pi as a USB-MIDI device and allows for up to 5 simultaneous MIDI input and outputs. Note that the GM5, like the ATMega328, requires a timing source. The GM5 draws its power from the Raspberry Pi's USB port and is isolated from the voltage of the Arduino by the 6N137 opto-isolator. ![](eurorack/GM5Diagram.png)

**Figure 3. GM5 MIDI chip by Ploytec wired as a USB-MIDI interface. Note that the GM5 is a QFN SMD and is not physically formed as the schematic depicts.**  ![](eurorack/ArticleSchematic.png)

**Figure 4. Complete voltage to MIDI schematic.**
### Arduino Code


The Arduino platform utilizes its own integrated development environment (IDE), which is based on the Processing programming language. The IDE can be found for free on the Arduino website[[6]](https://csoundjournal.com/#ref6). The following Arduino sketch defines all variables and some of their initial values at the top before the `setup`, `loop` and `midiOUT` functions. The `midiOUT` function at the bottom of the sketch formats the serial bytes sent from the Arduino TX pin to conform with the standard MIDI spec. Each of the module's three main parameters has two control sources (potentiometer and CV). The Arduino must differentiate between these two and respond only to the active one. This occurs in the 'Analog Reads' segment of the code. The absolute value of a scaled ADC variable from the previous iteration is subtracted from the current read value. If this value exceeds the 'selectThresh' threshold variable, the parameter's control variable will switch to the manipulated analog input source. (A threshold of 2 was chosen to cover any interference variation, which may affect a non-connected CV input.)

The portamento value selection button will send a cycling increment from 0 to 3 on MIDI CC 10. This allows for 4 selectable portamento time scale values.

The Off button must be held for half a second, after which it will send MIDI CC 14 at value 127, which will shutdown Csound.
```csound

//Variables
int pot1, cv1, pot2, cv2, pot3, cv3;
int pot1prev = 0, cv1prev = 0, pot2prev = 0, cv2prev = 0, pot3prev = 0, cv3prev = 0;

//On startup control parameters default to the Pot values
int carrier = pot1, modulator = pot2, index = pot3;
int control1prev, control2prev, control3prev;
int selectThresh = 2;                     //Input source toggle threshold
int portaButtonVal = 1, portaButtonState, portaButtonCount = 0;
int offButton;

void setup(){
  Serial.begin(31250);  //MIDI Baud rate
  pinMode(7, INPUT);    //Portamento Button
  pinMode(8, INPUT);    //Off Button
}

void loop(){
  //========= Analog Reads ===============//

  //--------- Control set 1 Read ---------//
  cv1 = (analogRead(A0))/8;//Scaling 0-1023 to 0-127
  if(abs(cv1 - cv1prev) >= selectThresh){
    carrier = cv1;
    cv1prev = cv1;
  }
  pot1 = (analogRead(A3))/8;
  if(abs(pot1 - pot1prev) >= selectThresh){
    carrier = pot1;
    pot1prev = pot1;
  }

  //--------- Control set 2 Read ---------//
  cv2 = (analogRead(A1))/8;
  if(abs(cv2 - cv2prev) >= selectThresh){
    modulator = cv2;
    cv2prev = cv2;
  }
  pot2 = (analogRead(A4))/8;
  if(abs(pot2 - pot2prev) >= selectThresh){
    modulator = pot2;
    pot2prev = pot2;
  }

  //--------- Control set 3 Read ---------//
  cv3 = (analogRead(A2))/8;
  if(abs(cv3 - cv3prev) >= selectThresh){
    index = cv3;
    cv3prev = cv3;
  }
  pot3 = (analogRead(A5))/8;
  if(abs(pot3 - pot3prev) >= selectThresh){
    index = pot3;
    pot3prev = pot3;
  }

  //-------------- MIDI control OUT messages -----------//
  //MODULATOR
  midiOUT(0xB0, 11, carrier);

  //CARRIER
  midiOUT(0xB0, 12, modulator);

  //INDEX
  midiOUT(0xB0, 13, index);

  //============ Portamento ammount =========//
  portaButtonState = digitalRead(7);

  if(portaButtonState == HIGH && portaButtonVal == 1){
    portaButtonCount = portaButtonCount++;
    if(portaButtonCount > 3){
      portaButtonCount = 0;
    }
    midiOUT(0xB0, 10, portaButtonCount);
    portaButtonVal = 0;
  }
  if(portaButtonState == LOW && portaButtonVal == 0){
    portaButtonVal = 1;
  }

  //-------------- Off Button --------------//
  offButton = digitalRead(8);
  if(offButton == HIGH){
    delay(500);
    digitalRead(8);
    if(offButton == HIGH){
      midiOUT(0xB0, 14, 127);
      delay(2000);
    }
  }
  midiOUT(0xB0, 14, 0);

  delay(30);

}

//MIDI format
void midiOUT(char command, char value1, char value2) {
  Serial.write(command);
  Serial.write(value1);
  Serial.write(value2);
}

```

## III. Raspberry Pi

### About the Raspberry Pi


The Raspberry Pi is a $35 Arm GNU/Linux computer the size of a credit card. It has revolutionized the "tinyware" market by its size, cost, and computing power. The Raspberry Pi will be used to run Csound, read MIDI information, and output analog audio. This article will assume that the Raspberry Pi is running Raspbian, the default Raspberry Pi OS.
### Configuring Audio Output


The Raspberry Pi can output analog audio to a 3.5mm jack or through an HDMI cable. By default the Pi will try to send audio out through HDMI. To change this setting and send audio out the 3.5mm jack, run:
```csound
amixer cset numid=3 1
```


In the code, `amixer` means ALSA mixer, `numid` means the ID number of the ALSA parameter you wish to change, and the last number represents the new value for the parameter that is being affected. This code will set the sound output to 1, which is the 3.5mm jack.
### Installing Csound


To install Csound, connect to the Internet with an Ethernet cable and use the package manager `apt` with the following code:
```csound
sudo apt-get install csound
```


The Raspberry Pi will now have Csound installed.
## Auto Login


Since a module needs to run automatically when it is turned on, automatic login will need to be configured. To do this, edit the file `/etc/inittab` in nano with:
```csound
sudo nano /etc/inittab
```


Scroll down until you see:
```csound
1:2345:respawn:/sbin/getty 115200 tty1
```


Comment that line out by adding # in front of it like this:
```csound
#1:2345:respawn:/sbin/getty 115200 tty1
```


Then, under that line type:
```csound
1:2345:respawn:/bin/login -f pi tty1 </dev/tty1 >/dev/tty1 2>&1
```


Type 'Ctrl+X' to exit, 'Y' to save, followed by 'Enter', which will close nano[[7]](https://csoundjournal.com/#ref7).
### Startup Script


Now that automatic login has been set up, a startup script can be written that will run a .csd file upon boot and shutdown the Raspberry Pi when Csound closes. To do this modify the file `/home/pi/.bash_profile` with:
```csound
sudo csound -d -odac --sched -+rtaudio=alsa -Ma -b512 -B1024 /home/oscillator.csd
sudo shutdown -h now
```


The Raspberry Pi will look for this file after login and run whatever is inside it. The first line will run Csound with flags to ensure efficient CPU processing and MIDI input. The `-d` flag suppresses displays, `-odac` sets Csound's sound output to the default output of the Raspberry Pi, `--sched` gives Csound priority over other processes, `-+rtaudio=alsa` tells Csound to use ALSA for handling sound input/output, `-Ma` is the flag for accepting MIDI from all available ports, `-b` is the software buffer size, `-B` is the hardware buffer size and `/home/oscillator.csd` is the path to the .csd file that will be run on startup. The second line will shutdown the Raspberry Pi when Csound finishes.
## IV. Csound

### FM Oscillator Using Foscili


The following instrument is an FM oscillator with interpolation using the opcode `foscili`. The values for carrier frequency, modulator frequency and modulation index are entering Csound on CCs 11, 12, and 13 respectively. CC 10 determines the current mode for portamento time. The push button is attached to CC 14, which will shutdown Csound when held for a half second.
```csound

<CsoundSynthesizer>
<CsInstruments>

sr = 44100
ksmps = 512
nchnls = 1
0dbfs = 1

	instr 1
; Portamento
initc7 1, 10, 0
kporta ctrl7 1, 10, 0, 127
if (kporta == 0) then
	kporta = 0
endif
if (kporta == 1) then
	kporta = .5
endif
if (kporta == 2) then
	kporta = 3
endif
if (kporta == 3) then
	kporta = 10
endif

; Carrier
initc7 1, 11,0
kcar ctrl7 1, 11, 40, 100

; Modulator
initc7 1, 12, .1
kmod ctrl7 12, 11, 40, 100

; Index
initc7 1, 13, .2
kindex ctrl7 1, 13, 0, 20

; Turn off
initc7 1, 14, 0
kturnoff ctrl7 1, 14, 0, 127

; Shut down Csound
if (kturnoff > 60) then
	event "e", 1, 0, 0
endif

asig foscili 1,1, kcar, kmod, kindex, 1
	out asig

	endin

</CsInstruments>
<CsScore>

f1 0 4097 10 1
i1 0 9999999

</CsScore>
</CsoundSynthesizer>

```

## Conclusion


It is an exciting time for embedded systems and hardware modular synthesizers as cost continues to decline and capabilities dramatically increase. Only time will tell what exciting things the future holds for these two fields. Hopefully this article has shed some light on how to get started in this area and will inspire imaginative modules that will add to the beautiful sounds in the world.
## Acknowledgements


Thanks to Dr. Richard Boulanger for inspiring this project, Paul Batchelor for Linux guidance, and Steven Yi and James Hearon for interest in the topic.
## References


[][1] "A-100 Technical Details", Doepfer, [Online]. Available: [http://www.doepfer.de/home_e.htm](http://www.doepfer.de/home_e.htm) [Accessed March 27, 2013]

[][2] "Sparkfun" [Online]. Available: [https://www.sparkfun.com ](https://www.sparkfun.com)[Accessed March 27, 2013]

[][3] "Tabula Rasa" Greg Surges, [Online]. Available: [http://gregsurges.com/circuitry/tabularasa/](http://gregsurges.com/circuitry/tabularasa/) [Accessed March 27, 2013]

[][4] "Uno - USB-Powered MIDI interface" M-audio, [Online]. Available: [http://www.m-audio.com/products/en_us/Uno.html](http://www.m-audio.com/products/en_us/Uno.html) [Accessed March 27, 2013]

[][5] "GM5" Ploytec [Online]. Available: [http://www.ploytec.com](http://www.ploytec.com) [Accessed March 27, 2013]

[][6] "Arduino" [Online]. Available: [http://arduino.cc](http://arduino.cc) [Accessed March 27, 2013]

[][7] "RPi Debian Auto Login", eLinux.org, [Online]. Available: [http://elinux.org/RPi_Debian_Auto_Logi](http://elinux.org/RPi_Debian_Auto_Logi)n [Accessed March 27, 2013]
