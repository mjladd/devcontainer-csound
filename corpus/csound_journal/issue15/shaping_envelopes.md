---
source: Csound Journal
issue: 15
title: "Shaping Envelopes Interactively"
author: "simply adding the three
      bumps"
url: https://csoundjournal.com/issue15/shaping_envelopes.html
---

# Shaping Envelopes Interactively

**Author:** simply adding the three
      bumps
**Issue:** 15
**Source:** [Csound Journal](https://csoundjournal.com/issue15/shaping_envelopes.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 15](https://csoundjournal.com/index.html)
## Shaping Envelopes Interactively

### an apercu of the Surmulot framework
 Stéphane Rollandin hepta AT zogotounga.net
## Introduction


Surmulot is a complex environment for music composition. It connects the Csound-x Emacs front-end with the ecosystem of Musical Objects for Squeak, also known as muO.

In this paper we will focus on a very specific subset of Surmulot functionality, namely graphical envelope editing. It is a simple entry point involving no programming skills at all.You are encouraged to follow this paper as a tutorial, performing the operations alongside the reading: this will give you a taste of Surmulot.

Installing Surmulot in Windows is as simple as unzipping an archived folder; on Linux it is almost as straightforward. Please follow the instructions at the [Surmulot web site](https://csoundjournal.com/#ref1). Note: This tutorial has been done using version pre.14 of Surmulot.


## Preparation


First let us set-up a CSD file for working in. Instead of writing a new one from scratch, we will just use a CSD from the Csound manual.

Start Emacs from the Surmulot folder, then from the "Documentation" submenu of the main "Csound" menu (that is in the upper menu bar), select the item "Fetch Opcode Example". In the minibuffer (the bottom line of the Emacs window), type "phasor". This may also be done by evaluating:
```csound

(csdoc-fetch-opcode-example "phasor")
```


Now the phasor CSD is displayed in Emacs. To play it, hit the ![](images/shaping_envelopes/play.png) button.


## I. Envelopes as GEN tables

### Displaying f-tables


The phasor CSD uses two tables, defined in the score section. From the "SCO" menu, select item "Display f-table" then type 1 to see the sine table shape. It should appear in its own frame shown in Figure 1:  ![](images/shaping_envelopes/ft1.png)  **Figure 1. The Emacs built-in table editor frame **
### Modifying f-tables


Now click on [Edit] and enter "f 2 0 16384 10 1 4 8". The display is shown in Figure 2:  ![](images/shaping_envelopes/ft2.png)  **Figure 2. The same frame, after editing**

Click on [Apply] and the f2 statement will be updated in the phasor CSD. What we just saw is how tables can be edited with visual feedback in Csound-x.


## II. Envelopes as breakpoints and interpolations


Let us tackle f1, currently a simple line. From the "New widget" submenu of the "Widgets" menu, select "Envelope Editor". This time we are leaving Emacs: a Squeak window appears as shown in Figure 3:  ![](images/shaping_envelopes/ed1.png)  **Figure 3. The muO envelope editor with default envelope**

This is a muO envelope. Each breakpoint can have its own interpolation function defining how it will connect to the next point. When a breakpoint does no have a specific interpolation setting, it simply re-uses the previous one.

Let us change the interpolation for the second point, via the context menu we get by right-clicking on the point itself as shown in Figure 4:  ![](images/shaping_envelopes/ed2.png)  **Figure 4. Breakpoint editing via a contextual menu**

See how the two last segments changed. Before we can have this envelope replace the f1 table, we need to scale it, shown in Figure 5:  ![](images/shaping_envelopes/ed3.png)  **Figure 5. Scaling the envelope via a contextual menu **

A pop-up window should appear, with code:
```csound

0@0 corner: 1.0@1.0
```


This is a rectangle definition in Smalltalk. Do not bother about this, just replace it with:
```csound

0@200 corner: 1.0@2000
```


and accept. We are now ready to update the phasor CSD shown in Figure 6:![](images/shaping_envelopes/ed4.png)

**Figure 6. Updating the related CSD via a contextual menu** This replaces the line
```csound

f 1 0 1025 -7 200 1024 2000
```
with the two lines
```csound

;backup; f 1 0 1025 -7 200 1024 2000
f1 0 1025 -7 200.0 103 2000.0 14 1999.469 7 1998.962 7 1998.217 7 1997.171 ...(more)
```


We can play the CSD and hear the difference (![](images/shaping_envelopes/play.png)). Note that you do not have to save the CSD file to do so: Csound-x transparently works on temporary files whenever it needs to. We can also check that the new table has indeed the right shape, shown in Figure 7:  ![](images/shaping_envelopes/ft4.png)

**Figure 7. Our f-table displayed by Emacs** Below is an envelope example with a few more breakpoints and a different interpolation for each of them, shown in Figure 8:  ![](images/shaping_envelopes/ed5.png)

**Figure 8. Any breakpoint may define its own interpolation**  This gets translated nicely as a GEN7, shown in Figure 9:  ![](images/shaping_envelopes/ft3.png)   **Figure 9. The previous envelope as seen in an Emacs buffer**


## III. Envelopes as functions


Now let us see the ultimate tool for envelope shaping: symbolic algebra. Now, we will not do any algebra ourselves, but rather let the tools do it for us. From the "New widget" submenu of the "Widgets" menu, select "Function Editor". This is a muO tool allowing the interactive edition of any algebric function. It comes with a library of functions, so we let us fetch a "circularBump" from it via the editor context menu (right-click anywhere), shown in Figure 10:  ![](images/shaping_envelopes/fed1.png)

**Figure 10. The muO function editor and its contextual menu**

Once the bump appears, we can zoom in and out and otherwise rescale the displayed area by left-clicking and dragging with the `shift` key down. This way you can see something like below, shown in Figure 11:  ![](images/shaping_envelopes/fed2.png)   **Figure 11. Accessing the f1 function from the menu**

The bump is called "f1"; from its dedicated submenu, let us invoke "clone with generic handles" three times. Each invocation creates a new version of the bump, along with two yellow dots. Dragging them around with the mouse scales and moves the corresponding function (you can also directly set their position via their own context menu). Next remove f1 so we have something like below, shown in Figure 12:  ![](images/shaping_envelopes/fed3.png)   **Figure 12. Three interactive clones of the original bump function**

We are now going to define a brand new function by simply adding the three bumps: select item "add function" in the context menu, then type `f2+f3+f4`. This new function is unimaginatively called f5. Next set its color to green, then resize the display (shift key + mouse left-click and drag again) so that it fills the width of the editor, shown in Figure 13:  ![](images/shaping_envelopes/fed4.png)

**Figure 13. The sum function (in green)**

Now invoking "edit as envelope" from the "f5" submenu will convert the function editor into a good old envelope editor, shown in Figure 14, below:  ![](images/shaping_envelopes/fed5.png)

**Figure 14. The green function converted into an envelope**

We just have to scale the envelope height from 200 to 2000 and the envelope is ready to go replace the f1 table in the phasor CSD. Play it !


## Closely related topics that were not covered


In order to keep it simple, many interesting things that we could have done in our way have been ignored. For now just be aware of the following points.
- Envelope editors have way more functionality than what was introduced in this paper: you can define a selection and operate on it, specific breakpoints can be grouped and moved together, etc.
- The widgets (envelope editors, function editors) can be cloned on the fly, so that it is easy and safe to experiment at will.
- Widgets can be embedded in a CSD. They are then serialized in a specific XML section whose contents are hidden in Csound-x, and this way get automatically saved and restored along the CSD.


## Follow-up documentation


 The main documentation for Surmulot is available within Surmulot itself. The main pieces of documentation related to envelopes and functions can be found in Emacs: see the topic "Widgets reference" in the Surmulot info pages (available under "documentation" in the main Surmulot menu).

 See also the following demos available from the welcome buffer:
- "CSD composition with graphical envelope editing"
- "CSD composition with sound wave editing"

In Squeak, see the two function editor examples in the muO documentation (available at the bottom of the main muO menu).


## Surmulot links


[]Get Surmulot at: [http://www.zogotounga.net/surmulot/surmulot.html](http://www.zogotounga.net/surmulot/surmulot.html)
