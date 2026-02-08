---
source: Csound Journal
issue: 10
title: "My Search for the Perfect MIDI Controller"
author: "as many performers as possible"
url: https://csoundjournal.com/issue10/MIDI_Controller.html
---

# My Search for the Perfect MIDI Controller

**Author:** as many performers as possible
**Issue:** 10
**Source:** [Csound Journal](https://csoundjournal.com/issue10/MIDI_Controller.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 10](https://csoundjournal.com/index.html)
## My Search for the Perfect MIDI Controller
 Art Hunkins
 www.arthunkins.com
 abhunkin AT uncg DOT edu

## Introduction


Perfection is clearly in the eye of the beholder. In this case, perfection equates to meeting the musical needs of the composer—of a *specific* composer. It also refers to the needs of the performer, as he/she attempts to project a given composer's message. In this sense, the perfect controller may be specific to a specific work, to a specific version of a work, or to a particular performer of a version of a work! However, my focus here is on controllers that meet my compositional needs for a range of works.

As a composer of live-performance music for Csound, I have acquired an enormous collection of MIDI controllers both with an eye to discovering my "perfect" control device, as well as simply learning "what is out there", so that I can gear my creative efforts to available technology. Like other composers of live music, I am eager to have my music performed - by as many performers as possible. Realizing that potential performers will have access to a diverse range of MIDI controllers, I create multiple versions of my compositions. These variants accommodate simple as well as more complex realizations of my ideas, for as many different controllers as feasible. Knowing that performers will be working with varied operating systems, I make most versions cross-platform. It is important, then, that prospective MIDI controllers be multi-platform compatible as well.

In the back of my mind, the idea of a "perfect control surface" persists - a device that can fully develop my musical thought, and be appropriate for the traveling (laptop) performer as well - regardless of platform. It should be a device that makes no unnecessary demands and requires no additional work on the part of the performer. Csound is complicated enough as it is.
##
 I. Performance and Composition


### Other Performance Options?


As an aside, earlier in my work with realtime Csound, I created sets of FLTK sliders and buttons on-screen. These were controlled by a mouse. The method worked because typically I moved only one slider at a time. While the *buttons* worked well, the sliders did not. Eye/hand coordination was crucial, but often, under performance conditions (especially for the age-challenged), woefully lacking. There was another significant issue: whereas FLTK widgets worked well in Windows, for both Linux and Mac there were ongoing problems. Conclusion: on-screen FLTK performance widgets were not a viable cross-platform solution.

 Another performance option, however, proved much more workable - if minimal. (I continue to use it today.) That option is to use the ASCII keyboard (via the *sensekey* opcode) instead of MIDI. The ASCII keyboard is an abundant, if unintuitive, source of buttons/triggers. Though the keyboard has no rotary knobs or sliders at all, quite a lot can be done simply by performing stops and starts. This is especially true when triggering is supplemented by a set of visual cues as to what is "on" and "off". (Fade times can be set interactively by pushing other keys.) Unhappily, I have recently discovered that the *sensekey* opcode interfaces with Linux quite differently from Windows, causing several performance issues. These include audio breakup and garbled console display of visual cues. These problems must be resolved within Csound if the "ASCII keyboard as controller" is to prove viable for all platforms.
### Compositional Needs


 My recent music can be characterized as minimal, static and meditative - "process music." Things last a long time, fade in (normally to maximum level), then eventually fade out. Hardly anything happens suddenly. Pitches are constant, or glide slowly up or down.

 Since my first involvement with live performance on analog synthesizers, my main attraction was the slider, or rotary pot. Only occasionally was a trigger required (usually to generate an envelope). The musical keyboard only rarely took part, usually to set a level of some sort. The usual performance task was to move/rotate sliders/knobs smoothly at the appropriate rate, and to start and end the fades at the right time. Actions normally happened one at a time.

 The ARP2600, my main performance instrument, thankfully consisted primarily of the far more performance-friendly sliders, as well as triggers (buttons/keys). Moving to digital media, the questions became: 1) how many sliders (or rotary knobs) did I really need? 2) how many (if any) keys/buttons/pads might also be desirable? 3) How might these devices best be laid out to facilitate performance, and to require the fewest resources?

 A word about buttons: though not generally crucial, up to 10 or so can often be useful - especially in sample-based works. Their physical layout is important. Placed between sliders or rotary knobs, they can get in the way. In particular, they can make slider sets unwieldy and confusing (see candidate 4 below). Most intuitive is placement below or above each slider, such as on the Peavey PC-1600 (below) or the Kenton Control Freak Studio Edition (above). Somewhat less ideal is the button (telephone-style) keypad found on the first three candidates below. They do not interfere with the other controllers, but neither are they suggestive in their meaning and layout.

 What follows is my needs list, based on the kind of music I make and on the state of my finances. (I am cheap, and a music-professor type; these characteristics may necessarily be related). I find myself focussing on collections of sliders (or the less friendly rotary knobs), and on the occasional button. I am also drawn to the used market, especially eBay. Your music and personal situation may well point in a different direction. I encourage you to develop your own list and priorities.
##
 II. Controller Hardware


### My List of Requirements


 In approximate order of importance:
- **Compactness:** The controller should ideally fit in the accessory pouch (along with necessary cables, etc.) of a laptop computer. (This obviously rules out MIDI keyboards.) The emphasis is on easy portability. Also, "desk space" is often at a premium.
-  **Cost:** < $150US street price; preferably < $100US. It is not the purpose of music making to go broke - at least, not if you do not have to. Your needs can be satisfied in this price range, and you can will not meet these qualifications any better by paying more.
-  **Class-Compatible USB:** The controller should not require additional power, nor more cables than absolutely necessary. At least a minimal performance could happen without any external power source at all (only the laptop's battery). Major benefits: the elimination of a "wall wart" power converter, and the fact that the controller works on all platforms.
-  **A minimum of 16 sliders/knobs**, preferably sliders; 17 or 18 if available without increasing bulk. (A "master volume" is often a welcome addition to a basic set of 16 sliders.) Sliders/knobs usually come in "banks" of 8 or 16. I find I can work with 8-9 for minimal versions of my works, but 16-18 are necessary for full-bodied realizations.
-  **Useful Factory Presets:** One or more presets should implement either of the following patterns: 1) on a single channel, two groups of 8 contiguously numbered controllers; 2) 16 channels of continuous controller 7. Almost all control surfaces offer one of these options, and I consider these configurations "normal" or "standard". So I have created versions of all my compositions that the performer can customize to make such "standard" presets compatible: any controller (CC) may be specified as the starting point for each "bank" of 8. Another (less ideal) way of meeting this criterion is an ability to program presets on-board. Any requirement to use editor software to program presets is cumbersome, and is not recommended (see further below).
-  **Reasonable Ergonomics** (a wish list of human engineering):
  - **Layout of the controls:** either a single row of 16 (preferred), or two sets of 8, one above the other. Controls close enough to be identified at a single glance, far enough apart so they do not interfere with each other (and are unlikely to be moved inadvertently).
  - **Clearly marked levels:** this is crucial for rotary knobs, and is a potential deal-breaker. Unhappily, not all rotary knobs have clearly visible pointers. (This is a drawback of both the UC-33(e) and the UC-16.) Level pointers can, however, sometimes be improved by judicious use of a fine-point, permanent marking pen. (Such is the case with the Korg nanoKontrol.)
  - **Long-throw sliders:** 60mm is ideal; the longer the better. (The UC-33(e) is excellent in this regard.)
  - **Knobs that have a good grip and are not too small** (making them difficult to turn and control). Width, height and slope are all factors here. (There is no substitute for actually feeling and working with the controls.) Once again: sliders are preferable to knobs. Do not make any performance selection before you have tried a set of fairly long-throw sliders.

 One requirement I did *not* have: the need for any traditional MIDI In/Out connections. (Laptops do not have them, in any case.) I connect only to a computer, and use a single control surface. The controllers below differ widely with regard to the usual MIDI connectors. Most units (including three of these four) offer a MIDI In but no MIDI Thru. However, the Korg nanoKontrol offers none.

 Needless to say, any unit designed for portable use must be solid, well-built, and not subject to easy breakage or coming apart. (Knobs and sliders are especially vulnerable.) The controllers discussed here all meet these criteria.


### Four Contenders


 The Evolution (M-Audio) UC-33e U-Control is the bulkiest and most expensive (about $150US used) of the four contenders. (It is 2/3 the size of a compact, 25-key keyboard, and almost as heavy.) However, it also has the largest number of useful controls: 9 long-throw sliders (with single LEDs as an aid to level indicators!), 24 rotary knobs (all ergonomically positioned), and 14 programmable buttons in a telephone-key matrix. Pros: the 9th slider. Cons: only 9 sliders, the placement of the buttons (see further below), and the lack of clear level indicators for the knobs.

 The original version of this unit, the UC-33, differs only in its inability to be programmed by an editor. Several factory settings work well. Besides, unless extensive numbers of presets are required, on-board creation of presets (an option found on most control surfaces) is quite satisfactory. Since the UC-33 may well be found for less on the used market, they represent excellent value. While the UC-33 is long discontinued, the UC-33e is still being made.

 The UC-33 has inspired two very similar baby brothers: the Evolution UC-16 U-Control and the Evolution X-Session (also known as the UC-17, and not to be confused with the totally different X-Session Pro). At half the size of the UC-33, their cases are the same and layouts near-identical. Neither is currently in production. Both are occasionally available used at < $100US, and have several standard presets.

 While both models are programmable on-board and consist of two rows of 8 rotary knobs each, the X-Session is superior on several counts. 1) The X-Session's knobs are quite workable, and show level well. The UC-16 is a disaster in both respects. (As a practical necessity, I replaced all the UC-16's knobs.) 2) The X-Session has a very useful slider (17th controller), and a set of 10 programmable buttons (telephone key matrix, similar to the UC-33). The UC-16 lacks these features. 3) Though of minimal import, the UC-16 lacks MIDI In and cannot be programmed via an external editor.

 Our final contender, the Korg nanoKONTROL, is both the newest and least expensive - at $59US street price (new). Though its case is entirely plastic, it is rugged and its knobs and sliders well protected. It is by far the smallest and lightest of these units. (It is certainly the controller of choice for the OLPC [One Laptop Per Child] computer; the controller, complete with its mini-USB cable, will fit in a deep pocket. The nanoKONTROL and OLPC may well look like toys, but they are two tough and versatile little partners.)

 The nanoKONTROL comprises an amazing 9 sliders, 9 rotary knobs and 24 programmable buttons. Though slider throw is only 30mm, the feel is reasonable. While the layout is in general good, there is one serious flaw: pairs of buttons are situated *between* sliders. This interferes with slider operation and makes returning multiple sliders to zero difficult. (Buttons are raised, while sliders are shallow and a bit difficult to manipulate.) The layout also keeps sliders and knobs from being as close as they might be. (A better idea would have been to place buttons above and/or below the slider/knob columns.) The modestly visible level indicators on the knobs can be enhanced with magic marker, as described above.

 There is one other major design issue: none of the four presets is standard! This unfortunate situation is exacerbated by two facts: you cannot program the unit on-board, and the very good editor (Enigma) is only available for PC and Mac. Linux users - including the OLPC - have little recourse. You are either stuck with the factory presets or must program them on a PC or Mac. (This would seem a major impediment in the OLPC environment.)
### One More Possibility


 I hesitate to mention one more item, and an unusual one it is: the JL Cooper FM3 Midi Mixer. Resembling a single slider row of the same company's CS-32 MiniDesk, it has long since totally disappeared from JL Cooper's website, and is only rarely seen on the used market (at well under $100US). The 16 sliders are ultra-compact and measure only 20mm. It, like other JL Cooper products, is built like a tank - in this case, a super-portable tank that *easily* fits in your pocket, complete with attached MIDI cable. Yes, a single MIDI Out cable, but with a tether that connects as a MIDI In. Both male MIDI connectors attach to a set of female MIDI "jacks" on a USB to MIDI converter cable. (Several class-compatible models of this sort are available inexpensively from Edirol). The purpose of the MIDI In tether is simply to get +5V to power the FM3. This voltage is always available on the MIDI (or USB) Out from a computer. Why more manufacturers have not taken advantage of this +5V source on the MIDI interface is a mystery to me. (A variety of creative options could make this possible.) My only guess is that older devices may have required higher voltages and more power than MIDI Out provides.

 Another aside: USB to MIDI converter cables are very inexpensive (< $10US on eBay), and allow any traditional MIDI device to be used with a laptop. This is the combination of equipment I currently use in performance (see further below). The problem of external power source remains, unfortunately.
##
 III. Conclusion



 I have not yet found my perfect MIDI controller. What comes closest, and the unit I normally perform with, is the Doepfer Pocket Fader. It is compact, with 16 delightful, long-throw (60mm) sliders egonomically placed in a single row. Levels are clearly visible and all sliders are easily returned to zero. On-board presets are standard and immediately useable. (Though an editor is available, it is not needed.) The only problem is that it is not USB, and requires a power converter.

 When I want USB (and do not feel like fooling with additional cables or power supply), I normally find myself working with the Evolution X-Session. Its 16 rotary pots sport clear level indicators, and they are easy to grip and turn. In addition, the programmable buttons and (especially) single slider often come in handy. The main downside are the knobs themselves: they are annoying when I must individually return them to zero, and their relative levels are not easy to grasp at a glance.
### MIDI Keyboards?


 I have not found any small (25-key) USB keyboard to be satisfactory either. To my knowledge, the only reasonably compact keyboard with 16 controllers is the E-mu X-board 25. Though the controllers are well laid-out, sturdy, and level indicators are highly visible, they remain rotary knobs. While the modulation wheel may be operated as a quasi-slider, the master volume slider does not issue normal controller messages, and so is effectively unavailable. In addition, the unit is fairly bulky; its keyboard is not well protected.

 If you really need a MIDI keyboard, I would suggest the M-Audio O2. At less than $100US used, it is compact and lightweight, with one of the better-protected keyboard mechanisms. It has 8 ergonomic rotary knobs with high visibility level indicators. Eight programmable buttons are located directly below the knobs. More importantly, the O2 also has a 30mm assignable master slider. The currently produced M-Audio KeyRig 25 appears identical, and is available in the same price range.

 Unfortunately, few compact keyboards include sliders. When they do, slider travel is rarely greater than 30mm. The problem is that a bank of substantial sliders markedly increases the size of the unit, making it less attractive as a compact controller. Performance-wise, too, since the knobs and sliders are placed above the (normally full-size) keys, it is awkward and somewhat tiring to reach these controls. I normally end by wishing the keyboard was not there.

 One obvious conclusion: look to M-Audio products for relevant features and a range of cost-effective controllers. Its catalog is extensive; M-Audio clearly leads the field in these areas. (Also, most M-Audio products are programmable using the same Enigma editor. This is a real bonus for users of multiple M-Audio products. Notable too is the wealth of different controller functions that M-Audio and Enigma support.) Highly adaptable to the requirements of Csound, these are versatile, well priced controllers.

 My search certainly proves one thing: you cannot have everything. Perfection is both elusive and personal. I am stubborn though. I will keep on looking!
