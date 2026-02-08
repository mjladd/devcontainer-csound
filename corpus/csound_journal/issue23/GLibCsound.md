---
source: Csound Journal
issue: 23
title: "GLib Data Structures and Csound"
author: "Jim Hearon"
url: https://csoundjournal.com/issue23/GLibCsound.html
---

# GLib Data Structures and Csound

**Author:** Jim Hearon
**Issue:** 23
**Source:** [Csound Journal](https://csoundjournal.com/issue23/GLibCsound.html)

---

[CSOUND JOURNAL ISSUE 23](https://csoundjournal.com/index.html)

 [INDEX](http://www.csoundjournal.com/) | [ABOUT](https://csoundjournal.com/about.html) | [LINKS](https://csoundjournal.com/links.html)     ![Hashtable image](images/GLibSquare.png)
# GLib Data Structures and Csound

###


by Jim Hearon
## Introduction


This article is about including GLib data structures with the Csound API. GLib is a general-purpose c utility library, released under the GNU Library General Public License (GNU LGPL), with an Application Programming Interface (API) used in many applications, the most notable being The GNOME (GNU Object Model Environment) desktop operating system for linux. GLib is different from and should not be confused with glibc, a unix c library containing system calls and other basic functions, or GTK+ (Gimp Toolkit), utilized for graphical interfaces.

On linux, glib and glib-devel are easily available as packages for installation on your system. The GLib API Data Types [[1]](https://csoundjournal.com/#ref1) can be included in your c code by adding the GLib headers from glib-devel using the header statement ` #include <glib.h>`.

A good source of examples using GLib is the IBMdeveloperWorks site article on "Manage C data using the GLib collections"[[2]](https://csoundjournal.com/#ref2). That online tutorial is one of the best available, but it generally uses strings instead of numbers in the examples for the contents of the data structures. This article focuses on using numbers versus strings as the data. However, the Csound API, orchestra and score code support the use of strings liberally. For example strings can be utilized in the API function `csoundGetChannelPtr`, shown below, to pass a value to Csound where `*p` of `MYFLT **p` can be of type `CSOUND_STRING_CHANNEL`, and also the Opcode *nstrunum* returns the number of a named instrument.
```csound
 PUBLIC int csoundGetChannelPtr(CSOUND *,
  MYFLT **p, const char *name, int type);
```


GLib features many useful data types and utilities, but this article will focus only on a few of the data structures from the GLib Data Types [[1]](https://csoundjournal.com/#ref1). Suggestions for developing the concepts and examples for a more compositional approach by passing data from the structures to Csound via the Csound API are also given. GLib data types also contain many more functions than shown in the examples below. Including the GLib API calls for implementations of singly and doubly linked lists, hash tables, trees, and sequences along with basic memory management are an efficient way of adding the work which has already been done, to your own Csound API code. Versions used for this article were Fedora 24, Csound Version 6.08, and glib-2-42.
## I. Csound API


For interfacing with Csound, a standard c code API template, available from Floss Manuals was used with added GLib calls [[3]](https://csoundjournal.com/#ref3). By using a uniform approach to the Csound API, the differences in the GLib calls for the various data structures can be more readily observed. The c code template used for the examples with this article features a struct for userData, a function which passes the data as input to a Csound performance loop calling `csoundGetChannelPtr` which passes the data on to the orchestra, and a main program which creates a separate thread for each call to the performance loop.

Also the same .csd, with twelve different instruments triggered by using the Opcode *chnget* is utilized for each example, providing further uniformity. The .csd receives the data as instrument numbers from `csoundGetChannelPtr`, and utilizing the *chnget* and *schedwhen* opcodes various instruments are triggered in the orchestra.

The overall approach is to load numbers as data into data structures, retrieve that data in some order, and utilize the CsoundAPI to send the data to a .csd file which will trigger instruments using the data as instrument numbers. The examples therefore, are basic ones, providing a series of different beeps as proof the data structure is working correctly. Much more creativity and further development should be applied in order to yield musical applications from the starter code. For example, the Csound API template has been ordered to initialize Csound and create a new thread for each call thru the performance loop. Thus each beep represents the potential for expansion and development of richer, more varied sounds and textures, primarily by developing the .csd to utilize the potential for the Csound initialization and thread running at that time. You can download and view the complete examples shown in this article from the following link: [GLib_exs.zip](https://csoundjournal.com/downloads/GLib_exs.zip)

## II. Lists


For the singly-linked list, there is a head and end or tail, and each element in the list has data, and a pointer which links to the next element in the list. Using the pointer it is possible to move through the list in one direction, but GLib offers several functions, giving the list the flexibility to append, prepend, sort, reverse, etc. the elements of the list. Essentially we are reading the list in one direction, performing various operations. The images shown below, such as in figure 1, provide only a very basic visualization of the data structure for which more details could be added for clarity.

![linkedlist image](images/singlelist_500px.png)

**Figure 1. Visualization of a singly-linked list.**

One suggestion, for a compositional method utilizing the singly-linked list, would be to have a list of numbered instruments in the .csd, and the have the compiled executable from the API code traverse that list of instruments in some simple sequential manner.

In the examples for the singly-linked list, a struct member as integer named `myinst` was added to the userData struct. A GSList was created, and integer values were loaded into the list elements as data via a for loop. Next that data was retrieved from the singly-linked list and assigned to the pointer to the struct userData value `myinst`. Finally userData was passed to the `csoundCreateThread` function of the performance loop for Csound.

In the doubly-linked list examples, each element in the list has data, and pointers which link to the previous and next elements in the list. Using those pointers, and various GLib functions for the doubly-linked list, it is possible to move through the list in both directions, forwards, and backwards.

![doublylinked list image](images/doublelist_500px.png)

**Figure 2. Visualization of a doubly-linked list.**

In the doubly-linked list examples, a similar approach to the singly-linked list was implemented using the GLIB function `g_list_nth_data`, which iterates over the list and returns the data of the element at the given position, listed below as `guint n`.
```csound
 g_list_nth_data (GList *list, guint n)
```


In the list examples each element of the list contains data, a number which in these examples represents an instrument in the .csd orchestra, and the call to that number or instrument is placed in a separate Csound thread. As a suggestion, this approach could be expanded compositionally, thinking of list elements as events controlling an overall flow of some type of process management. The process moves thru a list, going forward and/or in reverse at times, to trigger and perform a sequence of events from the .csd. Recall for the doubly-linked list it is easier to move in different directions with the use of GLib functions such as `g_list_previous`, and `g_list_next`.

## III. Hash Table


Hash Tables have keys and associated values. With this data structure one can organize terms as keys which have associated numbers as values, allowing the use of look up for a particular value, or having it reference a particular value associated with that key.

![hashtable image](images/hashtable_300px.png)

**Figure 3. A basic hash table design.**

Shown below is the string duplicate function to create a pointer to a value, then loading the key using the `GINT_To_POINTER` function.
```csound
char* value = NULL;
...
value = strdup("gaussian");
g_hash_table_insert(map, GINT_TO_POINTER(8), value);
```


To extend this data structure example in a more musical direction, you could think of utilizing the key, to look up something, ex. term "gaussian", and have it perform an instrument or number of instruments from the .csd based on that term. In this manner, you might, for example, organize larger groups of instruments under particular terms which describe those instruments in some way.
### Iterators


Another good source for GLib is the source code [[4]](https://csoundjournal.com/#ref4) which shows the implementation of the GLib functions for the data structures, and includes the test files which call the functions of the API. One type of function, among several different approaches, for accessing data in GLib data structures is an iterator function. In the case of hash tables, and ghash.c from the GLIB sources, the function is listed as `g_hash_table_iter_init`.
```csound
g_hash_table_iter_init (GHashTableIter *iter,
  GHashTable *hash_table);
```


Below, a code snippet from [[5]](https://csoundjournal.com/#ref5) shows an implementation of a hashtable iterator.
```csound
GHashTableIter iter;
gpointer key, value;

g_hash_table_iter_init (&iter, hash_table);
  while (g_hash_table_iter_next (&iter, &key, &value))
  {
  // do something with key and value
  }
```

## IV. Balanced Binary Tree


A binary tree is a hierarchical structure which is a balanced tree in GLib.

![Balanced Binary image](images/btree_300.png)

**Figure 4. Sample view of a balanced binary tree.**

Traversing the binary tree can be accomplished using a GLib `g_tree_foreach` function [[6]](https://csoundjournal.com/#ref6) which takes a traversal function as a parameter. Shown below also is an example traversal function called `TraverseTree` which returns keys and values for the tree elements.
```csound
void g_tree_foreach (GTree *tree, GTraverseFunc func, gpointer user_data);

...

gint TraverseTree (gpointer key, gpointer value, gpointer data)
  {
  int	* j = key;
  int * k = value;
  g_print ("Key: %d  Value: %d\n", *j, *k);
  return FALSE;
  }
```


For a simple compositional approach for this data structure we could select a node which calls all child notes or leafs from the .csd At a higher level, and with a large number of branches to the tree, decision making could also be applied in some manner to determine the tree's traversal routes, for example including conditional branching initiated by control statements.

## V. N-ary Tree


The GLib N-ary Tree allows for insertion of nodes at a given position. Thus it can become an unbalanced tree.


![N-ary Tree image](images/narytree_300.png)

**Figure 5. Possible arrangement for an N-ary tree.**

In the n-ary tree, searching and identifying the position of a particular node, as a means for insertion or the initiation of traversal becomes a more intricate process than using the binary tree. Also the depth of particular nodes indicates complexity along a given traversal route for inserting or retrieving data. Thus in a compositional manner, we might think of utilizing the n-ary tree for collections of more and less complicated groupings of data within an overall hierarchical structure. A collection of chords for example, say from two notes to six note chords, would have increasing levels of complexity considering inversions and voicings, etc., but could nevertheless be grouped or branched according to the number of notes; such as dyad, triad, tetrad, and so forth.
## VI. Sequences


GLib has many different and useful data types besides lists, hash tables and trees [[1]](https://csoundjournal.com/#ref1). Sequences are somewhat like vectors in that they can grow and change easily, as well as begin and end at different points in the sequence using the many function calls available for a sequence[[7]](https://csoundjournal.com/#ref7). The example provided shows traversal from different points of the sequence.
## VII. Slices


Equal-sized pieces of memory can be allocated using GLib's function for the allocation of memory chunks[[8]](https://csoundjournal.com/#ref8). A very brief example is provided which could be useful for a more extensive GLib application, but for accessing the data structures, you need not manage memory at the slice level. In the background, GLib is using the slice method for memory allocation in the source code of the data structures, such as when you create and free the data structure.
## VIII. Advanced Example


GLib data structures can be combined in interesting combinations. An advanced example is provided with this article which shows the creation of a hash table employing singly-linked lists as values.

An `add_element` function is passed pointers for the hash table, the singly-linked list, the hash table key, and data in order to load data into a list and also insert the list as a value in the hash table.
```csound
void add_element(GHashTable* hashtable, GSList *list, gchar * key, gpointer data) {
  list = g_hash_table_lookup(hashtable, key);
  list = g_slist_append(list, data);
  g_hash_table_insert(hashtable, key, list);
  }
```


In this example, we are able to organize lists of data based on terms. Those lists contain data useful for a Csound performance. The .csd instruments have been modified with this example to group sounds together as short sounds, long sounds, and chords primarily by applying envelopes to shorten some sounds, and by adding offsets or delays for simultaneous sounding tones to help give the impression of chords. In the main function of the example, instrument numbers associated with short sounds, for example, are loaded into a singly-linked list and given a hash table key through which the user is able to select that term and send those values to Csound in order to hear just the short beeps.

One could continue this approach more creatively, say with a hash table which includes a doubly-linked list, or a binary tree, a sequence or even an n-ary tree. From a user selected list of terms describing particular musical events, decisions could then be made about how to traverse the data utilizing the data structure which has been implemented as the value for the hash table.
## IX. Conclusion


Some of the benefits of using GLib are as a low-level c library it is also utilized by GTK+ should you choose to continue on with building graphical interfaces for your code, as it provides the functionality for event loops, threads, dynamic loading of objects, as well as the data structures for GTK+. An extensive list of functions for each GLib data structure, such as append, prepend, remove, free, length, etc. is readily available for use, so you do not have to code those from scratch [[9]](https://csoundjournal.com/#ref9). The source code for GLib is available, and is transparent in the manner in which the functions for the data structures are implemented [[4]](https://csoundjournal.com/#ref4).

There are a few drawbacks to using GLib too. There is a lack of clear, complete code examples for many of the abstract and complicated API calls. The library is in c, and therefore not object oriented and memory management is accomplished with pointers which causes frequent and confusing segfaults. Also the API can and does change frequently, possibly deprecating your code.

To create interesting, useful music employing data structures we generally need to do more than just generate numbers using the data structures and send that data to Csound. While the use of data structures can facilitate the creation of music composition by helping to arrange, access, and control data; more creativity is required than is shown here, in order to develop a complete, final, musical application. The implication for the use of data structures may be that there are many different types, with particular uses, and each should be utilized methodically. But for a musical application, if the final result works, then the data structure has been used effectively. Thus it is best to experiment, test ideas, then use the data structure which has the most API functions to access your ordered data most efficiently.

The approach outlined in this article was to demonstrate, at least on linux, that the GLib package is readily available and easily included in moderately low-level applications such as including the GLib data structures as functions along with Csound API calls in order to organize and access data when calling a Csound performance.
## References


[][1] GNOME DEVELOPER, 2006-2014. "GLib Data Types." [Online] Available: [https://developer.gnome.org/glib/stable/glib-data-types.html ](https://developer.gnome.org/glib/stable/glib-data-types.html). [Accessed July 16, 2016].

[][2]Tom Copeland, 2005. IBMdeveloperWorks. "Manage C data using the Glib collections." [Online] Available: [http://www.ibm.com/developerworks/linux/tutorials/l-glib/](http://www.ibm.com/developerworks/linux/tutorials/l-glib/). [Accessed July 16, 2016].

[][3] Michael Gogins, Rory Walsh, and Francois Pinot, 2006-2011. *FLOSS MANUALS*. "The Csound API." [Online] Available: [http://files.csound-tutorial.net/floss_manual/Release03/Cs_FM_03_ScrapBook/the-csound-api.html](http://files.csound-tutorial.net/floss_manual/Release03/Cs_FM_03_ScrapBook/the-csound-api.html). [Accessed July 15, 2016].

[][4]The GNOME Project, 2002-2015. "Git Repository, index: glib." [Online] Available: [https://git.gnome.org/browse/glib/](https://git.gnome.org/browse/glib/). [Accessed July 14, 2016].

[][5] GNOME DEVELOPER, 2005-2014. "Hash Tables." [Online] Available: [https://developer.gnome.org/glib/stable/glib-Hash-Tables.html#g-hash-table-iter-init](https://developer.gnome.org/glib/stable/glib-Hash-Tables.html#g-hash-table-iter-init). [Accessed July 16, 2016].

[][6] GNOME DEVELOPER, 2005-2014. "Balanced Binary Trees." [Online] Available: [https://developer.gnome.org/glib/stable/glib-Balanced-Binary-Trees.html#g-tree-foreach](https://developer.gnome.org/glib/stable/glib-Balanced-Binary-Trees.html#g-tree-foreach). [Accessed July 16, 2016].

[][7] GNOME DEVELOPER, 2005-2014. "Sequences." [Online] Available: [https://developer.gnome.org/glib/stable/glib-Sequences.html](https://developer.gnome.org/glib/stable/glib-Sequences.html). [Accessed July 16, 2016].

[][8] GNOME DEVELOPER, 2005-2014. "Memory Slices." [Online] Available: [https://developer.gnome.org/glib/stable/glib-Memory-Slices.html](https://developer.gnome.org/glib/stable/glib-Memory-Slices.html). [Accessed July 16, 2016].

[][9] GNOME DEVELOPER, 2005-2014. "GLib Reference Manual." [Online] Available: [https://developer.gnome.org/glib/2.49/](https://developer.gnome.org/glib/2.49/). [Accessed July 16, 2016].
## Biography


![Hearon image](images/Jhearon150x150.png) Jim Hearon has been Csounding since the early 1990s, and has helped to edit "Csound Journal" since 2005. Jim's articles continue to cover a wide range of topics and approaches. In his spare time Jim also enjoys playing electric violin, piano, and tenor guitar.

 email: j_hearon AT hotmail.com
