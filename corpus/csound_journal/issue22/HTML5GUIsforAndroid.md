---
source: Csound Journal
issue: 22
title: "HTML GUIs for Android Csound6"
author: "the power of the Android device itself"
url: https://csoundjournal.com/issue22/HTML5GUIsforAndroid.html
---

# HTML GUIs for Android Csound6

**Author:** the power of the Android device itself
**Issue:** 22
**Source:** [Csound Journal](https://csoundjournal.com/issue22/HTML5GUIsforAndroid.html)

---

CSOUND JOURNAL[](https://csoundjournal.com/../index.html) | [Issue 22](https://csoundjournal.com/index.html)
## HTML5 GUIS for Android Csound6

### A Tutorial in 14 Examples


Art Hunkins
 abhunkin AT [uncg.edu](http://uncg.edu/)

## Introduction


In June 2015, Michael Gogins introduced a version of Csound6 for Android[[1]](https://csoundjournal.com/#ref1) that included HTML5, a development that permitted Csound to include its own performance GUI. Shortly thereafter, he followed with a tutorial chapter in the Csound FLOSS manual[[2]](https://csoundjournal.com/#ref2), detailing this new facility, and documenting it with 5 examples[[3]](https://csoundjournal.com/#ref3). This article is based on Michael's excellent introductory tutorial, and is meant to supplement it.. Michael's tutorial is fairly bare-bones; and his composing methods are both advanced and somewhat unique, which led to some rather complex examples.
## I. Goals


My goals for this tutorial were: 1) to plant .csds for canonical Android Csound directly into HTML5 GUIs with little or no change to the original code; 2) to offer simple and functional HTML design, while basically mirroring the "canonical" GUI; 3) to be detailed and specific in GUI code, illustrating differing numbers/collections of widgets; 4) to use the full screen of the Android device, or most of it, for maximum playability, and 5) to auto-scale to device size. This last criterion turned out to be the most challenging.

Another difficult task was to come up with workable trackpad code. Michael had good examples of both slider and button code in his introductory tutorial, but had not implemented an HTML trackpad. Addressing both the auto-scaling and trackpad challenges, my son Dave Hunkins ([www.zatchu.com](http://www.zatchu.com/)), an experienced Android programmer, came to the rescue. I am indebted to him for his extensive help on these and related technical coding issues. His solutions are incorporated in the script found at the end of each tutorial example. His trackpad widget is realized via the HTML element.
## II. Android Csound and HTML5


The value of including HTML5 in Android Csound, for both portability and live performance, is clear. The basic benefit is that of customization: layout and selection/number of widgets, availability of text and labels, and color. For the advanced programmer, this is just the beginning. There is also an additional drawback: increased latency, seen especially in button and trackpad clicks. Latency is, on the other hand, primarily determined by the power of the Android device itself. It is now possible to perform live anywhere with only an Android device and a set of headphones. No electricity, no MIDI or other controller, and no cords. The only software needed is one of the free Csound apps and your .csd file. The sole dedicated expense is the Android device; and your performance interface is customized to your individual composition. There is no longer a limitation to 5 generic sliders and buttons. These benefits accrue to the performer as well as to the composer, and there is no need, or expense, for anything other than a low-cost Android device for any musician to perform your piece. The only current, if temporary, proviso is that the Android OS must be at least 4.2.2, and preferably 5.0+.

This article, along with its accompanying examples, is a kind of "tutorial for the rest of us"—one designed for the more conventional Csounder. The amount of required HTML, JavaScript, and CSS (cascade style sheets) is formidable, and necessitates a lot of additional code. The examples attempt to simplify and standardize to the greatest degree possible, eliminating all the bells and whistles. There is no doubt about it; the learning curve for these technologies can be steep. Many potential users may not find the effort worth the trouble, and may opt to stay with the canonical or alternative Csound6 apps. The lines of added HTML code vastly exceed those of an original .csd, as the examples listed below amply demonstrate. Thankfully, many segments of this code, can be copy/pasted directly into user .csds.
## III. The Android Csound App


Csound for Android with an HTML5 GUI option is currently available in two versions: the recommended version requires Android OS 5.0+ while the other version is for OS 4.2.2 and up. The former is downloadable from [[4]](https://csoundjournal.com/#ref4), and is called CsoundApplication-release.apk. It is also available at [[5]](https://csoundjournal.com/#ref5), as "Cs - Csound for Android" at no cost. Devices at or above 5.0 should certainly choose this version, as it includes a number of significant enhancements and corrections.

The latter version is required for devices with OS below 5.0. It is based on Csound 6.05, and is located at[[6]](https://csoundjournal.com/#ref6) as Csound6.apk. If you are using the standard canonical Android GUI channel names, this edition necessitates several changes in both HTML code and your basic .csd. First, if there are buttons, channel names butt1-5 need to be changed to but1-5, or some other name. Butt6 and up are not affected. Secondly, if there is a trackpad, you must change channel names trackpad.x and trackpad.y to trackpadx and trackpady, or some other name without a dot. This version lacks some desirable Settings options, and sometimes exhibits the bothersome habit of the GUI viewport opening only partially the first time Csound is started. It opens a bit more each time Csound is stopped or restarted. After 4 or more restarts, the GUI occupies the entire screen! Meanwhile, widgets obligingly resize to occupy a constant percentage of viewport space. Thankfully, this only happens when the Csound app is first opened and a .csd selected.

Be aware that the latter version adapts automatically to HTML in a .csd. Your HTML widgets substitute for the stock GUI with no action on your part. The more recent version, only available to Android OS 5.0+, does *not* automatically adapt. Instead, it offers a new option under Settings: Screen Layout. The default layout is the stock GUI (Widgets). To display your custom HTML, you must first select one of the HTML options. If you need the full screen, select "HTML." If you'd like a 10-line Csound console output at the bottom, and only need 75% of the screen for your GUI, select "HTML with message console." Your selection will persist.
## IV. Important Notes About Labels and Text


It is crucial to test your HTML GUI on a smartphone or very small tablet early in your work. If the display looks right on a small screen, it will look fine on a larger one. Less text will fit per line on a small screen, or put another way, text, including button labels, take up relatively more space on a small screen. Button labels are especially problematic. Longer labels, or more properly, a longer single string in a label, force a wider button, and will push the row of buttons partially off-screen. If you need more characters in a narrow button, you can often split a single longer string into two strings such as into two lines, using a space, forward slash or a dash. Keep in mind that buttons will only remain the same width if their longest string is the same length. Also an opening and/or trailing space, perhaps alternating with "space" characters, will add to string length. If you need more characters per label than you have space, you can always reduce the relative size of a label by using the <small> tag. Of course, this should then be done for all the labels in a row.

Here is a basic guide for maximum characters per button label: For a row of buttons using the entire width of the screen with normal size text, 6 buttons will accommodate 4 characters, 5 buttons 5 characters, and 4 buttons 7 characters. As might be expected, 4 buttons encompassing 80% of screen width, also accommodates 5 characters (see example 6, below, Simply Noise). With the HTML <small> tag, 5 and 6 button rows allow one more character per label, and a 4 button row allows two additional characters. Note that a single <small> does not make a noticeable difference in appearance or readability of button labels.

With regard to the *slider* widget label or text, most of the same comments apply, as apply to buttons. All sliders within a table autosize in width to the longest single string in the slider group. It is not necessary for the longest string in each label to be the same length, unlike the buttons. If you wish to keep two strings from potentially separating into two lines of text, you can either omit the space or substitute the space for a dot. On a smartphone with lots of sliders, there may not be enough vertical space for two text lines (see example 14, below, Peace2AndroidGUI). With regard to a *trackpad*, all text must be external to the widget itself.
## V. The Examples


You can download all the Android HTML5 GUI examples from the following link: [Android_HTML5_GUIs.zip](https://csoundjournal.com/downloads/Android_HTML5_GUIs.zip). Though all these examples stand on their own, they are listed below, in a suggested order of study. They deal uniquely with sliders and buttons - both with text labels, and an x/y trackpad. Buttons are implemented both as simple triggers and as more complex "touch down/touch up"
 mechanisms. Sliders are illustrated both with and without displayed values. Both sliders and buttons, as in Gogins' examples, are implemented in tables for a neat and user-friendly appearance.

For consistency and easy comparison, the following procedures are followed in the examples: 1) All HTML is placed at the bottom of the file. It could just as easily be placed at the top. Either way, messages regarding HTML do not appear in Csound console output. 2) CSS (Cascade Style Sheet) appears within the HTML <head> section of code. 3) JavaScript code also appears within the HTML code, but at the bottom of the <body> section. 4) Within both style sheets and JavaScript, slider data appear above button data. Any trackpad code appears at the bottom of the code. 5) Within the <body> section, following any title text, slider table(s) appear above button table(s), with the trackpad below. This formatting parallels the layout of canonical Android app GUIs.
### Example 1, Csound6 HTML5 GUI Clone


This file simply clones the canonical Android Csound5/6 GUIs, except that it includes no x/y trackpad. Any .csd for canonical Android Csound5/6 without trackpad may be prepended to this file as is, with one exception: if you use `chnget` button channels, you must rename the channels from butt1-5 to but1-5. This is a quirk only of the Android Csound6.05 build, and is remedied in the 6.06 edition, called "CsoundApplication-release". The 6.06 edition is the same Csound app as on Google Play. Try it with your Android .csd on any recent device; or append the included code to the bottom of your Android .csd, and run it. Note that the five buttons accommodate a 5-character label maximum. This approach parallels the canonical Android GUI label - e.g., Butt1. There is, however, little inline explanation in this file.

IMPORTANT NOTE: This example implements a simple trigger for buttons. It deals only with "touch down," not with "touch up." The code for this kind of button is substantially less complex than for a "touch down/touch up" mechanism which is useful for "notes" and other gated events. Surprisingly, however, there is substantially *less* latency for the full down/up arrangement. Both types of button exhibit some inherent delay,
 which seems to be a disadvantage to using HTML widgets in contrast to canonical Android GUIs. Except for the three examples marked "Enhanced Button" below, however, the tutorials that follow incorporate the simpler trigger mechanism. They do not require "touch up", nor are they particularly sensitive to latency.
### Example 2, Csound6 HTML5 GUI Clone Enhanced Button


This is identical to example 1 except for enhanced button coding that responds to "touch up." This single feature lengthens the amount of javascript extensively. Like example #1, this is an excellent candidate for appending canonical Android Csound5/6 .csd code. It is most appropriate for button code that requires full "touch down/touch up" response. Note, however, that it is compatible with simple button triggers.

The next five tutorials are the most informative and worthy of study. Their .csds are all heavily commented.
### Example 3, HTML5 Slider GUI Demo


This is a basic demo for sliders only. Sliders all have labels; some display values, others not. Slider height is specified as a percentage of viewport height at the beginning of the <script> (bottom of .csd). While canonical Android sliders range only between 0 and 1, HTML5 sliders can range between any two values, though default values remain 0 to 1. Special steps must be taken, as shown in this demo, to constrain displayed values to a limited number of characters; here 3. In short, the displayed values of all sliders should show the same number of characters, as should the initial display. Also, if the start value of the slider is not 0, the .csd must be initialized to this value as is again explained and illustrated by the .csd.
### Example 4, HTML5 Button GUI Demo


This is a basic demo for buttons only. Buttons all have labels. Button height is specified as a percentage of viewport height at the beginning of the <script> (bottom of .csd). Whereas slider labels auto-size to the longest text string in any label within a table, button labels are more difficult, forcing individual button width to its longest text string. In all buttons, the clickable area is restricted to the text label itself. If button height permits, a long label string may be shortened by introducing spaces, forward slashes or dashes as string dividers, thus creating additional, but shorter lines of text.
### Example 5, HTML5 Enhanced Button GUI Demo


This is identical to example 4, except for enhanced button coding that responds to "touch up."
### Example 6, SimplyNoise


This is a button-only drumset simulation. Two tables: one of two rows of 4 drums, and another of a single row of 4 amplitudes. Button height is again specified at the beginning of the <script>. This .csd demos larger title and interpolated text. It also shows how to center tables when filling less than the full width of the screen. The second table of buttons, for amplitude, is extended with spaces to enhance the clickable area, and to match spacing of the previous table.
### Example 7, SimplyNoise Enhanced Button


This is similar to example 6 except for enhanced button coding that responds to "touch up." In addition, .csd instrument coding is expanded to include control of percussive "note" duration. These simple modifications increase the length of the .csd by 50%. This example is a basic template suggesting how to use HTML5 buttons as a simple "keyboard". Note that the final four amplitude buttons might just as well be coded as trigger-only widgets, as they don't make use of "touch up."

These next three examples build on those from above, but are more lightly commented.
### Example 8, Csound6 HTML5 GUI Clone with Trackpad


This is similar to example 1 but with an added trackpad. The commentary describes how touchmove outside the trackpad can be handled. The code, as it stands, constrains values to the stated trackpad limits, even when the touch moves outside the pad. Options are shown that allow x and/or y values to exceed these limits when touch moves outside. In contrast, note that all canonical Android GUIs allow touchmove out-of-range values on the y axis. Since x-axis width is fixed at 100%, there is no issue of an out-of-range value on this axis. Our trackpad implementation differs from the canonical GUI only in that both width and height percentages of screen, or more properly viewport, are set by the user at the top of the <script>. The two axes can be constrained independently, or not.
### Example 9, Csound6 HTML5 GUI Clone with Trackpad and Spiritus2


This is the same as example 8, but with an added composition, *SPIRITUS SANCTUS 2* (2015)[[7]](https://csoundjournal.com/#ref7) for realtime Android Csound. It is the same composition employed again in example 11, below, but adapted to the canonical Android collection of 5 sliders, 5 buttons and a trackpad. The trackpad is acting as a dual slider, and the 5 buttons are substituting for an 8th slider. The trackpad axes x and y are both constrained when touchmove exceeds stated limits, thus emulating dual sliders.
### Example 10, NoisePad


This example is similar to example 6, but implemented using a single trackpad. Because touchmove is not involved here, only discrete clicks within trackpad boundaries, with no constriction of out-of-bounds values, are needed. Thus the code is somewhat simplified. This is an excellent template for a .csd that uses only a trackpad.

The remaining four examples are modified HTML5 GUI versions of my recent works for regular Android Csound. All the compositions require more than 5 buttons and/or sliders. They were originally designed for performance by my alternative Csound6 apps: Csound6a, Csound6b and Csound6c - all described and linked in [[8]](https://csoundjournal.com/#ref8). These .csds contain minimal commentary inline. As mentioned previously, these examples implement simple trigger buttons only.

The original Android versions of these works are listed in [[11]](https://csoundjournal.com/#ref11). The titles all have an "alt" suffix, indicating that these .csds require my alternative Android apps.

Csound6c includes a single-line Csound console output, used to feed back important data to the performer from Csound. Both the canonical Android Csound and its HTML5-enabled version currently lack implementation of `chnset` and/or `chnexport` for on-screen data display purposes. Both *Peace alt* and *Peace2 alt* make good use of this feature of Csound6c. Thus significant .csd code had to be rewritten in these two works to cope with this canonical limitation. Compare particularly the code for sliders 2, 5, and 8 in parallel versions of this composition shown in PeaceAndroidGUI.csd and PeacealtAndroid.csd, to see how this issue was dealt with using HTML code. I found that solution acceptable, though not ideal.
### Example 11, Spiritus2AndroidGUI


This example has 8 sliders, and no buttons. This required no changes to the original .csd in order to port the code to HTML5. This is the same composition employed in example 6, but with a different and unique set of widgets. The original .csd, minimally adapted here, was only performable on one of the alternative Android apps. See Csound5a.apk and Csound6a.apk in [[8]](https://csoundjournal.com/#ref8). This example is a good template for a multiple-sliders-only GUI. An explanation of what the various controls do, as adapted from the alternative Android version, can be found in [[7]](https://csoundjournal.com/#ref7).
### Example 12, SpiritusAndroidGUI


This example has 9 sliders, and 12 buttons. There were no changes required to the original .csd in order to port this example to HTML5 except for the substitution of but1-5 for butt1-5. Note the 3-character limitation for button labels to accommodate, for smartphones, the 6 buttons per row. As with example 11, this was originally intended for the Csound5a and Csound6a, or alternative apps. This is a good template for multiple sliders and several rows of buttons. An explanation of what the various controls do, from the alternative Android version, can be found in [[9]](https://csoundjournal.com/#ref9).
### Example 13, PeaceAndroidGUI


This example has 12 sliders, and 9 buttons. It probably holds the largest cohort of widgets that should be attempted on smartphones. The 4-character limitation on button labels here accommodates, for smartphones, 5 buttons per row. Considerable recoding of the original Android .csd was required, especially involving display of values for sliders 2, 5 and 8, which is not possible in canonical Android and is dealt with by the one-line Csound console display in the alternative Csound6c app. Hopefully, in upcoming builds of Android Csound, `chnset` and/or `chnexport` will be implemented. This demonstrates a mix of sliders, displaying their values in an additional column, and simpler ones that that do not, so as to involve no compositional recoding. An explanation of the various controls can be found in [[10]](https://csoundjournal.com/#ref10).
### Example 14, Peace2AndroidGUI


This example has 16 sliders, and 9 buttons. It represents probably the largest cohort of widgets that should be attempted, even on large tablets. This example is largely unworkable on smartphones due to the extreme narrowness of the sliders. This also limits the sliders to single-line labels. *Peace2AndroidGUI* is identical to *PeaceAndroidGUI* except for three additional sliders, which equals one additional voice. An explanation of the various controls is also found in [[10]](https://csoundjournal.com/#ref10).
## References


[[1]John ffitch, Victor Lazzarini, Steven Yi, et. al., "Csound." [Online] Available: ][http://sourceforge.net/projects/csound/files/csound6/Csound6.05/Csound6.apk/](http://sourceforge.net/projects/csound/files/csound6/Csound6.05/Csound6.apk/). [Accessed March 4, 2016]. Earlier HTML5 versions, introduced from Csound6.03, apparently observe a somewhat different syntax, and do not work for me. The FLOSS manual examples do not work for me either.

[[2]Joachim Heintz, Michael Gogins, Iain McCurdy, et. al. *FLOSS Manuals, Csound*. Amsterdam, Netherlands: Floss Manuals Foundation, [online document]. Available: ][http://floss.booktype.pro/csound/h-csound-and-html/ ](http://floss.booktype.pro/csound/h-csound-and-html/)[Accessed March 5, 2016].

[[3]Michael Gogins, "Csound", HTML examples, GITHub repository. [Online] Available: ][https://github.com/csound/csound/tree/develop/examples/html](https://github.com/csound/csound/tree/develop/examples/html). [Accessed March 5, 2016].

[[4]John ffitch, Victor Lazzarini, Steven Yi, et. al., "Csound." [Online] Available: ][http://sourceforge.net/projects/csound/files/csound6/Csound6.06/](http://sourceforge.net/projects/csound/files/csound6/Csound6.06/). [Accessed March 4, 2016].

[[5]Google play, 2016. "Apps." [Online] Available:][ https://play.google.com/store/apps/details?id=com.csounds.Csound6](https://play.google.com/store/apps/details?id=com.csounds.Csound6). [Accessed March 4, 2016].

[[6]John ffitch, Victor Lazzarini, Steven Yi, et. al., "Csound." [Online] Available: ][http://sourceforge.net/projects/csound/files/csound6/Csound6.05/](http://sourceforge.net/projects/csound/files/csound6/Csound6.05/). [Accessed March 4, 2016].

[[7]Arthur B. Hunkins, "Spiritus Sanctus 2 alt" [Online]. Available: ][Recent Compositions by Arthur B. Hunkins](http://arthunkins.com/SpiritusSanctus2altAndroid.txt) [Accessed March 4, 2016].

[[8]Arthur B. Hunkins, "Android Csound Apps and Other Android Materials for Csound" [Online]. Available: ][http://arthunkins.com/Android_Csound_Apps.htm](http://arthunkins.com/Android_Csound_Apps.htm) [Accessed March 4, 2016].

[[9]Arthur B. Hunkins, "Spiritus Sanctus alt" [Online]. Available: ][Recent Compositions by Arthur B. Hunkins](http://arthunkins.com/SpiritusSanctusaltAndroid.txt) [Accessed March 4, 2016].

[[10]Arthur B. Hunkins, "Peace Be With You alt" and "Peace Be With You 2 alt" [Online]. Available: ][Recent Compositions by Arthur B. Hunkins](http://arthunkins.com/PeacealtAndroid.txt) [Accessed March 4, 2016].

[[11]Arthur B. Hunkins. [Online]. Available: ][Recent Compositions by Arthur B. Hunkins](http://www.arthunkins.com/) [Accessed March 3, 2016].
