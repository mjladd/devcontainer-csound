---
source: Csound Journal
issue: 17
title: "Creating Graphical User Interfaces for Csound using Quartz Composer"
author: "describing this simple example"
url: https://csoundjournal.com/issue17/costello_quartz_composer_csound.html
---

# Creating Graphical User Interfaces for Csound using Quartz Composer

**Author:** describing this simple example
**Issue:** 17
**Source:** [Csound Journal](https://csoundjournal.com/issue17/costello_quartz_composer_csound.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 17](https://csoundjournal.com/index.html)
## Creating Graphical User Interfaces for Csound using Quartz Composer
 Edward Costello
 edwardcostelloAT gmail.com
## Introduction


Although they are quite different, Csound and Quartz Composer are great specialised programming languages that can compliment each other as part of a larger creative project. Csound has become a valuable tool for live musical performance and when used in conjunction with a graphical programming language such as Apple's Quartz Composer[[1]](https://csoundjournal.com/#ref1), it is possible to create rich interactive audio visual installations. In this article I will explain how to create a simple step sequencer with Csound and Quartz Composer. By describing this simple example, the aim of this tutorial is to outline the fundamental concepts of programming graphics with Quartz Composer and handling two way communication between Quartz Compositions and a Csound audio backend. The sequencer will receive its input from a GUI created with Quartz Composer and the sequencer's pattern state and audio will all be handled through Csound. The GUI will also show visual feedback of the sequencer's tempo and which notes are selected within the sequence. In this tutorial all communication between Csound and Quartz Composer will be handled using Open Sound Control (OSC). The advantages of using OSC control over MIDI or the software bus is that it offers the flexibility of either having an instance of Csound and Quartz Composer running on the same system or communicating between two separate systems over a LAN or the Internet with very few modifications. For processor intensive applications, this kind of flexibility can be hugely beneficial.
##
 I. The Step Sequencer Interface



The step sequencer we are going to create will contain eight rectangular buttons that, when activated, will trigger an instrument in Csound. To begin the project we will lay out the buttons in Quartz Composer first and then start adding communication between our GUI and the necessary Csound instruments.
  ![](costello/quartz_composer_csound_html_22693143.png)

 **Figure 1.** Quartz Composer's template chooser window
### Creating an Interactive Button


Start by opening a new file in Quartz Composer that is of the type **Basic Composition**. This will give you a document that contains one **Clear** patch. This patch paints the target rendering layer with a constant colour and clears the depth buffer preventing unwanted visual artefacts from appearing in the composition. Quartz Composer comes with a library of patches that can be used to create a composition, these range from patches that perform basic mathematical operations to 3D rendering and visual effects patches[[2]](https://csoundjournal.com/#ref2). The patch library can be opened through the Window menu bar item or using the ⌘ + ↵ (Apple key and Return key) combination. Specific patches within the library can be browsed through the scrollable menu or found by typing their title in the search field. When selected, patches can be placed into the composition by double clicking them with the mouse or by pressing the return key. The rectangular buttons of our step sequencer are going to be rendered to the screen using a **Sprite** patch. Select a **Sprite** patch from the library and add it to the composition.
  ![](costello/quartz_composer_csound_html_7652c2b0.png)

 **Figure 2.** The patch editor

Patches can be connected to each other by clicking and dragging a connector cable from one patch's outlet to another patch's inlet. The outlets of a patch are represented by labelled white circles on the right and the inlets are the labelled white circles on the left side of a patch. The shape of our **Sprite** patch is determined by the patch's **Image** inlet. As we need a rectangular button we will use the **Rounded Rectangle** patch as its image input. ![](costello/quartz_composer_csound_html_7c086266.png)

 **Figure 3.** Connecting the Rounded Rectangle Image outlet to the Sprite Image inlet

Add a **Rounded Rectangle** patch from the library and connect the **Image** outlet of the **Rounded Rectangle** patch to the **Image** inlet of the **Sprite** patch. You can see the result of this connection in the **Viewer** window which shows a render of the Quartz Composition in realtime. To open the **Viewer** window press ⌘ + ⇑+ v (Command and Shift and 'v'), and press the **Run** button on the **Viewer** window if it is not currently rendering. You should now see the shape of the **Rounded Rectangle** rendered in the **Viewer** window. ![](costello/quartz_composer_csound_html_371896cd.png)

 **Figure 4.** Viewer window

Select the **Sprite** object by clicking on it. When it is selected it will have a yellow border around its edge. Now open the **Patch Inspector** for the **Sprite** patch by pressing ⌘ + i (Command key and 'i'). ![](costello/quartz_composer_csound_html_73f4db94.png)

 **Figure 5.** Patch Inspector

The **Patch Inspector** has three pages of properties that can be adjusted within a patch, the **Input Parameters**, **Settings** and **Published Inputs & Outputs** pages. These are selected by the drop down menu or arrow keys at the top of the **Patch Inspector** window. You can adjust the **Height** and **Width** of the **Sprite** patch by rotating the round knobs beside the **Height** and **Width** parameters or by typing the value directly into the text field.

Now make the **Height** and **Width** of the **Sprite** patch 0.1. You should be able to see the rectangle has become a lot smaller in the **Viewer** window. This white rounded rectangle is going to be used as a button for our simple step sequencer. However, in order for it to be useful, it has to be able to detect mouse events from the user. To do this, add an **Interaction** patch to the workspace and connect its **interaction** outlet to the **interaction** inlet of the **Sprite** patch. These outlets and inlets are not labelled but they are located at the very top of the **Interaction** and **Sprite** objects. ![](costello/quartz_composer_csound_html_m30d28f26.png)

 **Figure 6.** Connecting the Interaction patch interaction outlet to the Sprite patch interaction inlet

In order to get some visual feedback of when the buttons of our step sequencer are being interacted with we will change their size when they receive a mouse click. The** Interaction** patch will output a value of **true** from its **Mouse Down** outlet when a mouse click event is detected over the **Sprite** patch, otherwise the value is **false**. We can use this value to scale the size of our rectangular button.

Add a **Mathematical Expression** patch to the workspace. Open the workspace **Patch Inspector** and go to the **Settings** page. Edit the expression field so it reads:

`mouseDown == true ? 0.15 : 0.1`

So if the variable **mouseDown** is equal to true (a mouse click has been detected), output 0.15, if not (no mouse clicks have been detected), output 0.1. The inlets of the **Mathematical Expression** patch will have changed so there is an inlet labelled **mouseDown** and there should also be an outlet labelled **Result**. Connect from the **Mouse Down** outlet of the **Interaction** patch to the **mouseDown** inlet of the **Mathematical Expression** patch, then connect from the **Mathematical Expression** **Result** outlet to the **Width** and **Height** inlets of the **Sprite** patch. ![](costello/quartz_composer_csound_html_m2ec1afb0.png)

 **Figure 7.** Adding a Mathematical Expression patch

Clicking on the rectangle in the **Viewer** window should now result in the rectangle increasing in size.
### Duplicating the Button for an Eight Step Sequencer


As our step sequencer will consist of eight of these rectangle buttons, we need to duplicate every patch in our composition eight times. This can be achieved using an **Iterator **patch which is similar to a *for* loop construction used in most other programming languages. An **Iterator** patch is a type of macro patch, which means you can nest other patches inside of it. As we want eight copies of the rectangular button we need to place all the patches that make up the button into the **Iterator** and set it to iterate eight times. ![](costello/quartz_composer_csound_html_b963ea5.png)

 **Figure 8.** Inside of an Iterator patch

Add an **Iterator** patch to the workspace. You will notice its edges are squared indicating that it is a macro patch. In order to add other patches to the **Iterator** you can double click it in the area below its label (note that double-clicking the label allows you to edit its label). The address bar at the top left of the window will change indicating where you are in relation to the top patch level or **Root Macro Patch**. To move back to the top level you can either click the **Edit Parent** button in the menu bar, click **Root Macro Patch** in the address bar, or press ⌘ + u. Navigate back to the **Root Macro Patch** and select every object in the workspace except for the **Iterator** and **Clear** objects. This can be done by clicking and dragging across the relevant objects until they are highlighted in yellow. Press ⌘ + x to cut these objects, then double click the **Iterator** to navigate inside it and press ⌘ + v to paste the objects into it.  ![](costello/quartz_composer_csound_html_694970af.png)

 **Figure 9.** The sequencer button patches copied into an Iterator patch

While inside the **Iterator** patch, and making sure none of the objects are selected, press ⌘ + t to open the **Parameters** area to the right of the workspace. This shows the same settings that are in the **Input Parameters** **Patch Inspector** page of selected patches within the workspace. As we are currently viewing the contents of the **Iterator** patch the** Parameters** area will show the number of iterations the patch performs. Change the **Iterations** value to eight and make sure the **Enable** checkbox is ticked. ![](costello/quartz_composer_csound_html_3131d86.png)

 **Figure 10.** Changing the Iterations value using the Parameters area

The **Iterator** will have made eight copies of our button but we now need to translate them across the **Viewer** so they can be selected individually by the mouse.

Each iteration within an **Iterator** patch has an associated index which can be used to access a particular instance of our step sequencer buttons. The **Iterator** index values are accessed using the **Iterator Variables** patch placed inside an **Iterator** patch. We will use the **Current Index** number from the **Iterator Variables** patch as a scalar which will change the X position of the **Sprite** object.

Add an **Iterator Variables** patch and **Mathematical Expression** patch to the **Iterator**'s workspace. Enter this expression in the **Mathematical Expression** patch's settings page (in the Patch Inspector):

`index * scale - offset`

This will create inlets for **index**, **scale** and **offset** on the **Mathematical Expression** patch.

Connect the **Current Index** outlet on the **Iterator Variables** patch to the **index** inlet of the **Mathematical Expression** patch. Next, connect the **Result** outlet from the** Mathematical Expression** patch to the **X Position** inlet of the **Sprite** patch. Now open the **Patch Inspector** for the **Mathematical Expression** patch to the **Input Parameters** page and set the value of **scale** to '0.13' and **offset** to '0.47'. In the **Viewer** window you should now see the step-sequencers buttons arranged into a horizontal row. ![](costello/quartz_composer_csound_html_m25693542.png)

 **Figure 11.** Adjusting the position of the sequencer buttons using a Mathematical Expression patch ![](costello/quartz_composer_csound_html_m2d5fb49.png)

 **Figure 12.** Viewer window showing the sequencer buttons arranged into a row
##
 II. Adding a Visual Metronome Using Csound



At this point we can begin working with Csound. We will start by creating a visual metronome for the step sequencer which will give an indication of the speed and phase of our sequencer. Csound will create a phasor signal which will be sent via OSC to Quartz Composer. Quartz Composer will then increase the size of the sequencer button corresponding to the current phase of the sequence.

We will begin with a basic Csound file template:
```csound
<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 128
nchnls = 2
0dbfs  = 1

instr Init, 1

endin

</CsInstruments>
<CsScore>
i "Init" 0 100
</CsScore>
</CsoundSynthesizer>
```


Here we have created an empty instrument entitled `Init` which will run for 100 seconds. In our Quartz composition the **Iterator** patch has made eight copies of the step sequencer button. It is important to note that the **Iterator** patch starts the index count from zero, like many other programming languages, so the first button will be **Iterator** index zero and the last will be **Iterator** index seven. If we make a metronome that counts from zero to seven in Csound, we can send these values to Quartz Composer via OSC. We can then check if the number being sent from Csound is the same as the button's index that we want to increase in size. If it is, we will increase the size of the button, if not, the button's size will be unaltered.

To create a metronome in Csound, we first add a table to the `Init` instrument which will contain values from zero to seven.
```csound

<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 128
nchnls = 2
0dbfs  = 1

instr Init, 1

    **gi_MetroTable ftgen 0, 0, 8, -2, 0, 1, 2, 3, 4, 5, 6, 7**
endin

</CsInstruments>
<CsScore>
i "Init" 0 100
</CsScore>
</CsoundSynthesizer>

```


Next we add the `Clock` instrument, this will contain the `phasor` opcode which will generate a global control signal that will be used to move through the values of the table we have created. The `phasor` is set to repeat once every second.
```csound

<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 128
nchnls = 2
0dbfs  = 1

instr Init, 1

     gi_MetroTable ftgen 0, 0, 8, -2, 0, 1, 2, 3, 4, 5, 6, 7
endin

**instr Clock, 10

     gk_Phasor phasor 1
endin**

</CsInstruments>
<CsScore>
i "Init" 0 100
</CsScore>
</CsoundSynthesizer>

```


Now add an instrument that will read the current value from the `gi_MetroTable` table using the `phasor` control signal.
```csound
<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 128
nchnls = 2
0dbfs  = 1

instr Init, 1

     gi_MetroTable ftgen 0, 0, 8, -2, 0, 1, 2, 3, 4, 5, 6, 7
endin

instr Clock, 10

     gk_Phasor phasor 1
endin

**instr TableReader, 20

     gk_Metronome table gk_Phasor, gi_MetroTable, 1
endin**

</CsInstruments>
<CsScore>
i "Init" 0 100
</CsScore>
</CsoundSynthesizer>
```


We can test to see if the metronome is working correctly by turning on the `Clock` and `TableReader` instruments from the `Init` instrument and printing the `gk_Metronome` value. The `turnon` opcode in Csound only takes instrument numbers as an argument so for the sake clarity I have made definitions at the beginning of the Csound file that will show which instruments are being activated.
```csound

<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 128
nchnls = 2
0dbfs  = 1

**#define Clock #10#
#define TableReader #20#**

instr Init, 1

     **turnon $Clock
     turnon $TableReader**
     gi_MetroTable ftgen 0, 0, 8, -2, 0, 1, 2, 3, 4, 5, 6, 7
endin

instr Clock, 10

     gk_Phasor phasor 1
endin

instr TableReader, 20

     gk_Metronome table gk_Phasor, gi_MetroTable, 1
     **printk2 gk_Metronome**
endin

</CsInstruments>
<CsScore>
i "Init" 0 100
</CsScore>
</CsoundSynthesizer>

```


Once the metronome is working we can send the output values to Quartz Composer using the `OSCsend` opcode. The `OSCsend` opcode is created in a new instrument entitled `OSCSendMetronome`.
```csound
<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 128
nchnls = 2
0dbfs  = 1

#define Clock #10#
#define TableReader #20#
**#define OSCSendMetronome #30#**

instr Init, 1

     turnon $Clock
     turnon $TableReader
     turnon $OSCSendMetronome

     gi_MetroTable ftgen 0, 0, 8, -2, 0, 1, 2, 3, 4, 5, 6, 7
endin

instr Clock, 10

     gk_Phasor phasor 1
endin

instr TableReader, 20

     gk_Metronome table gk_Phasor, gi_MetroTable, 1
     printk2 gk_Metronome
endin

**instr OSCSendMetronome, 30

     OSCsend gk_Metronome, "127.0.0.1", 20002, "/phasor", "f", gk_Metronome
endin**

</CsInstruments>
<CsScore>
i "Init" 0 100
</CsScore>
</CsoundSynthesizer>
```


This will transmit the metronome values to port **20002** of the TCP/IP loopback device at address **127.0.0.1/phasor**. The instrument is turned on from the `Init` instrument and uses the instrument name definition at the beginning of the file.

Back in Quartz Composer there needs to be an OSC Receiver patch that will listen for the values being transmitted by Csound. In Quartz Composer navigate to the **Root Macro********Patch**, the top most level of your composition, which contains the **Clear** and **Iterator** patches.

Add an **OSC Receiver** patch and open the **Settings** page in the **Patch Inspector**. Change the **Port Number** value to **20002**, then remove the **/test** key from the **OSC Arguments** section. Next, add a key of type **Float** to the **OSC Arguments** and name it **/phasor**, the path we specified in our `OSCsend` arguments in Csound. ![](costello/quartz_composer_csound_html_22d8d99.png)

**Figure 13.** OSC Receiver patch Settings page

We now need to create an inlet on our **Iterator** patch for the **OSC Receiver** **/phasor** outlet. Navigate to inside the **Iterator** patch, create a **Mathematical Expression** patch and enter the following equation:

`index == metronome ? .02 : 0`

When the value of the **index** inlet is equal to the **metronome** value which we will be sent from Csound, this patch will output the value of .02, otherwise it will just output 0. Connect the **Iterator Variable's** **Current Index** outlet to the **index** inlet of the **Mathematical Expression** patch we just created. Note that you can take as many connections from a patches outlet as you want, you can however only have one connection into an inlet. You should have two connection lines coming out from the **Iterator Variable's** **Current Index **outlet now.

Right click (or ctrl + click), on the new **Mathematical Expression** object and select **Publish Inputs > metronome**. This will create an inlet for the **Iterator** patch that we can use to input OSC messages. You will be given the option to rename the published input, however this step is not necessary. Navigate up one level back to the **Root Macro Patch**—you should see a new inlet in the **Iterator**—and connect from the **OSC Receiver** **/phasor** outlet to the **metronome** inlet. ![](costello/quartz_composer_csound_html_756b9800.png)

 **Figure 14.** OSC Receiver patch connected to the Iterator patch

Now that the **Iterator** is receiving OSC messages we can alter the size of our sequencer buttons depending on which message is received. Inside the **Iterator** patch create a **Math **patch, connect the **Result** outlets from the **Mathematical Expression** patches with the equations:

`index == metronome ? .02 : 0`

and

`mouseDown == true ? 0.15 : 0.1`

to the inlets of the **Math** patch, then connect the single outlet from the **Math** patch to the **Width** and **Height** inlets of the **Sprite** patch. (Note that this will remove the previous connections that were made to these inlets as inlets may only have one input.) ![](costello/quartz_composer_csound_html_379aeae9.png)

 **Figure 15.** Connecting a Math patch to the Sprite Width and Height inlets

By running the Csound instrument now you should see the sequencer buttons changing size while moving from left to right in the Quartz Composer **Viewer**. ![](costello/quartz_composer_csound_html_40550a77.png)

 **Figure 16.** Viewer window showing the visual metronome
### Sending the Step Sequencer Button State to Csound using OSC


Now that our visual metronome is complete, we can start sending messages back to Csound from Quartz Composer. Next we will make it so that when a button has been clicked in the step sequence, it will trigger an audio signal in Csound.

Csound needs to know which of the eight buttons the user clicked on, so we will need to receive output from the **Iterator Variables** **Current Index** outlet in combination with the **Interaction** patch's **Mouse Down** outlet. We can send both of these variables within a single OSC message to Csound using a **Structure.******

The best way of creating a **Structure** in Quartz Composer is to use a **Javascript** patch where we can programmatically combine different variables from **Structure's** inlets. Add a **Javascript** patch inside of the **Iterator** patch and open its **Patch Inspector**.

Replace the default Javascript code with the following code:
```csound
function (__structure output) main (__number index, __boolean mouseDown)
{
        var result = new Object();
        var outArray = new Array();
        outArray[0] = index;
        outArray[1] = mouseDown == true ? 1 : 0;
        result.output = outArray;
        return result;
}
```


The first line of this code is the function declaration. The brackets on the left contain the output variable (here it is a structure), and the input variables are in the brackets on the right (here they are a number and a boolean value). The variable **result** is the object that returns the output structure. The variable **outArray** is an array that will store the data within the structure. It will store the **index** number (the current Iteration), and a number representing the mouse state. The mouse state number will be 1 if the ` mouseDown` value is true and 0 if it is false.

To output the **Structure** as OSC messages to Csound we need to use an **OSC Sender** patch. Add an **OSC Sender** patch to the **Iterator** patch and go to the **Settings** page within its **Patch Inspector**. Change its **IP Address** field to **127.0.0.1** and the **Port Number** field to **10001**. Next add an **OSC Argument** with a key of **/buttons** and type of **Floats**.

Now that the **Javascript** and **OSC Sender** patches are correctly configured we can connect them to the rest of the composition. Connect from the **Mouse Down** inlet in the **Interaction** patch to **mouseDown** in the **Javascript** patch, then connect **Current Index** from **Iterator Variables** patch to the **index** inlet in the **Javascript** patch. Finally connect from the **output** outlet in the **Javascript** patch to the **/buttons** inlet in the **OSC Sender** patch.

Next we need to make sure that the **OSC Sender** patch is enabled and sending a single OSC message per mouse click. To accomplish this, create a **Pulse** patch and in its **Input********Parameters** page set the **Detection Mode** to **Both**. Connect **Mouse Down** from the **Interaction** patch to the **Input Signal** inlet in the **Pulse** patch, then connect the **Pulse** outlet from the **Pulse** patch to the **Enable** inlet in the **OSC Sender** patch. ![](costello/quartz_composer_csound_html_5b28a2cc.png)

 **Figure 17.** Pulse and Javascript patches connected to the OSC sender patch

Back in Csound we now need to create an instrument which will store the sequencers current button states. To do this we will create an instrument with a table to store the button states and an OSC receiver instrument which will relay the button state information to the instrument.

First we will create the OSC receiver instrument, to do so add the following code to Csound:
```csound
<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 128
nchnls = 2
0dbfs  = 1

#define Clock #10#
#define TableReader #20#
#define OSCSendMetronome #30#
**#define OSCReceive #40#

gi_OSCHandle OSCinit 10001**

instr Init, 1

     turnon $Clock
     turnon $TableReader
     turnon $OSCSendMetronome
     **turnon $OSCReceive

     gk_ButtonNumber init 0
     gk_ButtonState init 0**


     gi_MetroTable ftgen 0, 0, 8, -2, 0, 1, 2, 3, 4, 5, 6, 7
     **gi_TriggerTable ftgen 0, 0, 8, -2, 0, 0, 0, 0, 0, 0, 0, 0**
endin

instr Clock, 10

     gk_Phasor phasor 1
endin

instr TableReader, 20

     gk_Metronome table gk_Phasor, gi_MetroTable, 1
endin

instr OSCSendMetronome, 30

     OSCsend gk_Metronome, "127.0.0.1", 20002, "/phasor", "f", gk_Metronome
endin

**instr OSCReceive, 40

     nxtmsg:

          k_OSCReceived OSClisten gi_OSCHandle, "/buttons", "ii", gk_ButtonNumber, gk_ButtonState

          if (k_OSCReceived == 0) goto ex

               kgoto nxtmsg
          endif

     ex:
endin**

</CsInstruments>
<CsScore>
i "Init" 0 100
</CsScore>
</CsoundSynthesizer>

```


Here we initialise our OSC listener to listen on port 10001 using the `OSCinit` opcode at the beginning of the file. In the `Init` instrument we then create the global variables to store the button number and state. The table for storing this information is created and called `gk_TriggerTable`. The `OSCReceive` instrument uses the `OSClisten` opcode to receive OSC messages from Quartz Composer, in this case it is receiving two integer variables which are accessed using the `gk_ButtonNumber` and `gk_ButtonState` variables.

To test if we are receiving OSC from Quartz Composer, add two print statements to the `Init` instrument for the `gk_ButtonNumber` and `gk_ButtonState` variables and click on the sequencer buttons within the Quartz Composer **Viewer** window. Also, by removing the metronome print statement within the `TableReader` instrument, this will make the Csound terminal output easier to read.
```csound
instr Init, 1

     turnon $Clock
     turnon $TableReader
     turnon $OSCSendMetronome
     turnon $OSCReceive

     gk_ButtonNumber init 0
     gk_ButtonState init 0

     **printk2 gk_ButtonNumber
     printk2 gk_ButtonState**

     gi_MetroTable ftgen 0, 0, 8, -2, 0, 1, 2, 3, 4, 5, 6, 7
     gi_TriggerTable ftgen 0, 0, 8, -2, 0, 0, 0, 0, 0, 0, 0, 0

endin

```


If everything is working correctly you should see the numbers corresponding to the buttons being clicked printed in the Csound output terminal.

The values in the button state table will need to alternate between zero and one whenever Csound receives a message from the corresponding Quartz Composer sequencer button.

We will now create an instrument which changes the value of the table depending on its current state and the input from the `OSCReceive` instrument.
```csound

<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 128
nchnls = 2
0dbfs  = 1

#define Clock #10#
#define TableReader #20#
#define OSCSendMetronome #30#
#define OSCReceive #40#

gi_OSCHandle OSCinit 10001

instr Init, 1

     turnon $Clock
     turnon $TableReader
     turnon $OSCSendMetronome
     turnon $OSCReceive

     gk_ButtonNumber init 0
     gk_ButtonState init 0

     gi_MetroTable ftgen 0, 0, 8, -2, 0, 1, 2, 3, 4, 5, 6, 7
     gi_TriggerTable ftgen 0, 0, 8, -2, 0, 0, 0, 0, 0, 0, 0, 0
endin

instr Clock, 10

     gk_Phasor phasor 1
endin

instr TableReader, 20

     gk_Metronome table gk_Phasor, gi_MetroTable, 1
     printk2 gk_Metronome
endin

instr OSCSendMetronome, 30

     OSCsend gk_Metronome, "127.0.0.1", 20002, "/phasor", "f", gk_Metronome

endin

instr OSCReceive, 40
     nxtmsg:

          k_OSCReceived OSClisten gi_OSCHandle, "/buttons", "ii", gk_ButtonNumber, gk_ButtonState

          if (k_OSCReceived == 0) goto ex

               **if (gk_ButtonState == 1) then

                    event "i", "TableWriter", 0, -1
               endif**

               kgoto nxtmsg
          endif

	ex:
endin

**instr TableWriter, 50

     k_CurrentValue table gk_ButtonNumber, gi_TriggerTable

     if (k_CurrentValue == 0) then

          tablew 1, gk_ButtonNumber, gi_TriggerTable
     else

          tablew 0, gk_ButtonNumber, gi_TriggerTable
     endif

     turnoff
endin**

</CsInstruments>
<CsScore>
i "Init" 0 100
</CsScore>
</CsoundSynthesizer>

```


Here we have set up a trigger inside the `OSCReceive` instrument that will activate our new `TableWriter` instrument when `gk_ButtonState` value is 1 using the `event` opcode.

When the `TableWriter` instrument is triggered, it reads the value of the table `gi_TriggerTable` at the index it receives from Quartz Composer. If this value is 0 it writes a 1 to this index, if the value is 1 it writes a 0. This instrument then turns itself off as we need only one control pass to perform the necessary operations.
### Adding Visual Feedback for the Step Sequencer Button State


At this point the buttons in Quartz Composer are triggering our `TableWriter` instrument to change the values of the `gi_TriggerTable` but as yet we have no visual feedback of the tables current value. We can fix this by sending an OSC message back to Quartz Composer when values have been written into the table. We can then increase the size of the button to indicate its current corresponding table value.
```csound

<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 128
nchnls = 2
0dbfs  = 1

#define Clock #10#
#define TableReader #20#
#define OSCSendMetronome #30#
#define OSCReceive #40#

gi_OSCHandle OSCinit 10001

instr Init, 1

     turnon $Clock
     turnon $TableReader
     turnon $OSCSendMetronome
     turnon $OSCReceive

     gk_ButtonNumber init 0
     gk_ButtonState init 0

     gi_MetroTable ftgen 0, 0, 8, -2, 0, 1, 2, 3, 4, 5, 6, 7
     gi_TriggerTable ftgen 0, 0, 8, -2, 0, 0, 0, 0, 0, 0, 0, 0
endin

instr Clock, 10

     gk_Phasor phasor 1
endin

instr TableReader, 20

     gk_Metronome table gk_Phasor, gi_MetroTable, 1
     printk2 gk_Metronome
endin

instr OSCSendMetronome, 30

     OSCsend gk_Metronome, "127.0.0.1", 20002, "/phasor", "f", gk_Metronome

endin

instr OSCReceive, 40
     nxtmsg:

          k_OSCReceived OSClisten gi_OSCHandle, "/buttons", "ii", gk_ButtonNumber, gk_ButtonState

          if (k_OSCReceived == 0) goto ex

               if (gk_ButtonState == 1) then

                    event "i", "TableWriter", 0, -1
               endif

               kgoto nxtmsg
          endif

	ex:
endin

instr TableWriter, 50

     k_CurrentValue table gk_ButtonNumber, gi_TriggerTable

     if (k_CurrentValue == 0) then

          tablew 1, gk_ButtonNumber, gi_TriggerTable
     else

          tablew 0, gk_ButtonNumber, gi_TriggerTable
     endif

     **event "i", "OSCSendTableState", 0, -1**

     turnoff
endin

**instr OSCSendTableState, 60

     k0 table 0, gi_TriggerTable
     k1 table 1, gi_TriggerTable
     k2 table 2, gi_TriggerTable
     k3 table 3, gi_TriggerTable
     k4 table 4, gi_TriggerTable
     k5 table 5, gi_TriggerTable
     k6 table 6, gi_TriggerTable
     k7 table 7, gi_TriggerTable

     OSCsend 1, "127.0.0.1", 20002, "/tablestate", "ffffffff", k0, k1, k2, k3, k4, k5, k6, k7

     turnoff
endin**

</CsInstruments>
<CsScore>
i "Init" 0 100
</CsScore>
</CsoundSynthesizer>

```


In the code example above, just before the `TableWriter` instrument turns itself off, it triggers the `OSCSendTableState` instrument. This instrument reads all eight values from the `gi_TriggerTable` table and sends them to the address **127.0.0.1/tablestate**. Now we need to make sure Quartz Composer can receive OSC messages at this address.

In Quartz Composer at the **Root Macro Patch** level open the **Settings** inspector of **OSC Receiver**, add a new key entitled **/tablestate** and select the **Floats** type from the drop down menu.

Navigate to inside the **Iterator** patch and create a **Structure Index Member** patch. This patch will output a single selected value from the OSC structure sent from the Csound` OSCSendTableState` instrument. To retrieve the correct value from the OSC structure connect from the **Current Index** outlet of the **Iterator Variables** patch to the **Index** inlet of the **Structure Index Member** patch. Next publish the **Structure** inlet of the **Structure Index Member** object and change its label to **tablestate**.

Create a new **Mathematical Expression** patch that contains the function:

`member * scalar`

Change the value of **scalar** in the **Input Parameters** inspector to 0.03. Open the **Settings** inspector for the **Math** patch inside the **Iterator** and change the number of operations to two. Now connect from the **Member** outlet in the **Structure Index Member** patch to the **member** inlet in the new **Mathematical Expression** patch and connect from its' **Result** outlet to the new inlet of the **Math** patch. ![](costello/quartz_composer_csound_html_7beadc1b.png)

 **Figure 18.** Structure Index Member and Mathematical Expression patches connected to the Math patch

Finally, go back to the **Root Macro Patch** level and connect from the **OSC Receiver**'s **/tablestate** outlet to the **tablestate** inlet of the **Iterator**. ![](costello/quartz_composer_csound_html_61797b99.png)

**Figure 19.** OSC Receiver sending tablestate values to Iterator patch

The sequencer buttons within Quartz Composer should now change their size depending on the table value in Csound.
##
 III. Adding an Audio Synthesizer in Csound



At this point we can create our audio synthesiser within Csound. First we need to add some logic to the `TableReader` instrument so that it triggers a simple audio synthesiser instrument when it reads a 1 value from the `gi_TriggerTable`.
```csound
<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 128
nchnls = 2
0dbfs  = 1

#define Clock #10#
#define TableReader #20#
#define OSCSendMetronome #30#
#define OSCReceive #40#

gi_OSCHandle OSCinit 10001

instr Init, 1

     turnon $Clock
     turnon $TableReader
     turnon $OSCSendMetronome
     turnon $OSCReceive

     gk_ButtonNumber init 0
     gk_ButtonState init 0

     gi_MetroTable ftgen 0, 0, 8, -2, 0, 1, 2, 3, 4, 5, 6, 7
     gi_TriggerTable ftgen 0, 0, 8, -2, 0, 0, 0, 0, 0, 0, 0, 0
endin

instr Clock, 10

     gk_Phasor phasor 1
endin

instr TableReader, 20

     gk_Metronome table gk_Phasor, gi_MetroTable, 1

     **k_Trigger table gk_Phasor, gi_TriggerTable, 1

     k_Gate init 0
     k_StopTime init 0

     k_Timer times

     if (k_Trigger == 1 && k_Gate == 0) then

          event "i", "Beep", 0, 1/8

          k_StopTime = k_Timer + (1/8)
          k_Gate = 1
     endif

     if (k_Timer > k_StopTime) then

          k_Gate = 0
     endif**
endin

instr OSCSendMetronome, 30

     OSCsend gk_Metronome, "127.0.0.1", 20002, "/phasor", "f", gk_Metronome

endin

instr OSCReceive, 40
     nxtmsg:

          k_OSCReceived OSClisten gi_OSCHandle, "/buttons", "ii", gk_ButtonNumber, gk_ButtonState

          if (k_OSCReceived == 0) goto ex

               if (gk_ButtonState == 1) then

                    event "i", "TableWriter", 0, -1
               endif

               kgoto nxtmsg
          endif

	ex:
endin

instr TableWriter, 50

     k_CurrentValue table gk_ButtonNumber, gi_TriggerTable

     if (k_CurrentValue == 0) then

          tablew 1, gk_ButtonNumber, gi_TriggerTable
     else

          tablew 0, gk_ButtonNumber, gi_TriggerTable
     endif

     event "i", "OSCSendTableState", 0, -1

     turnoff
endin

instr OSCSendTableState, 60

     k0 table 0, gi_TriggerTable
     k1 table 1, gi_TriggerTable
     k2 table 2, gi_TriggerTable
     k3 table 3, gi_TriggerTable
     k4 table 4, gi_TriggerTable
     k5 table 5, gi_TriggerTable
     k6 table 6, gi_TriggerTable
     k7 table 7, gi_TriggerTable

     OSCsend 1, "127.0.0.1", 20002, "/tablestate", "ffffffff", k0, k1, k2, k3, k4, k5, k6, k7

     turnoff
endin

**instr Beep

     a_Out vco2 .2, 220
     outs a_Out, a_Out
endin **

</CsInstruments>
<CsScore>
i "Init" 0 100
</CsScore>
</CsoundSynthesizer>
```


A timer has been added to the `TableReader` instrument which will trigger the `Beep` instrument every 1/8th of a second. When the `TableReader` is activated the `k_Gate` and `k_StopTime` variables are initialised to zero it begins reading the values from the `gi_TriggerTable`. If the value read is a 1 and the `k_Gate` variable is 0 the `Beep` instrument is triggered for 1/8th of a second, the `k_StopTime` variable is set at the present instrument time plus 1/8th of a second and the `k_Gate` variable is set to 1. When the `k_Timer` variable is greater than the value of `k_StopTime` this means 1/8th of a second has passed and the `k_Gate` variable is set back to 0. The `Beep` instrument being triggered by the` TableReader` instrument is a very simple synthesiser using one `vco2` oscillator set at an amplitude of 0.2 and a pitch of 220Hz.

If the Csound file is compiled and run with Quartz Composer running you can now click on the buttons within the composition and this will trigger the `Beep` instrument.
### Colouring and Smoothing the Animations of the Step Sequencer Interface


Our step sequencer is now functionally complete but the presentation of the graphics can be improved greatly by modifying some parts of the composition. Instead of our buttons suddenly growing and shrinking we can make the size of the buttons grow with a smooth animation. We can also change the colours of the buttons, which makes them more aesthetically pleasing and adds more visual feedback regarding the `gi_TriggerTable`'s current state.

Inside the **Iterator** patch add a **Smooth** object and connect from the outlet of the **Math** patch to the **Value** inlet of the **Smooth** patch. Also connect from the **Smoothed Value** outlet to the **Width** and **Height** inlets of the Sprite patch. Next set the **Increasing Duration** and **Decreasing Duration** values in the **Smooth** patches **Input Parameters** inspector to 0.1. This should smooth the increase and decrease in size of our step sequencers buttons.

To change the colour of the buttons create an **RGB Color** patch and connect its outlet to the **Color** inlet of the **Sprite** patch. In the **Input Parameters** inspector set the **Red** value to 1, leave the **Green** as it is, set the **Blue** to 0.25 and the **Alpha** to 1.

Make a new **Mathematical Expression** patch and enter the following formula:

`smoothed * scalar`

Set the **scalar** value to 5 in the **Input Parameters** inspector, then connect the **Smoothed** outlet from the **Smooth** object to **smoothed** inlet of the **Mathematical Expression** patch and the **Result** outlet to the **Green** inlet of the **RGB Color** patch. ![](costello/quartz_composer_csound_html_4893dd38.png)

 **Figure 20.** Smooth patch connected to Sprite width and height inlets and Mathematical Expression patch

If you compile and run the Csound file now you should see the colours of the buttons changing as they increase in size. ![](costello/quartz_composer_csound_html_7a5f9342.png)
 **Fig 21. Completed step sequencer interface**
## Conclusion


Quartz Composer is a powerful language which allows the creation of complex interactive graphical elements. Although this is a simple example, this project shows how to make GUI for a Csound instrument using many of Quartz Composers features. This sequencer can be further expanded into a more fully featured interactive system by using just the patches outlined in this tutorial. For example another **Iterator** patch can be added to alter the pitch of the Csound instrument. By creating a further eight copies of the current eight buttons and arranging them into rows with a small amount of further patching each row can send a different pitch value.
##  References


 [][1]]Quartz Composer visual programming environment included with Xcode. [Online]. Available: [https://developer.apple.com/technologies/mac/graphics-and-animation.html](https://developer.apple.com/technologies/mac/graphics-and-animation.html). [Accessed October 9, 2012].

[][2]]QuartzComposer.com. (2009 - 2012). [Online]. Available: [http://quartzcomposer.com/patches](http://quartzcomposer.com/patches). [Accessed October 10, 2012].
