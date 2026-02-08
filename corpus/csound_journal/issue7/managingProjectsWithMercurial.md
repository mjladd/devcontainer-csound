---
source: Csound Journal
issue: 7
title: "Managing Projects with Mercurial"
author: "having all files
within"
url: https://csoundjournal.com/issue7/managingProjectsWithMercurial.html
---

# Managing Projects with Mercurial

**Author:** having all files
within
**Issue:** 7
**Source:** [Csound Journal](https://csoundjournal.com/issue7/managingProjectsWithMercurial.html)

---

CSOUND JOURNAL: [Home](https://csoundjournal.com/../index.html) | [Issue 7](https://csoundjournal.com/index.html)
## Managing Projects with Mercurial

### Using Source Code Management software to version and archive your Csound work
 Steven Yi
 Email: steven AT gmail.com
## Introduction


I have been using Source Code Management(SCM) software for a number of years to manage both the software I write as well as the music projects I work on. In that time, the use of SCM software has time and again proven its usefulness in helping to keep the history of a work, to backup work to remote locations, and to help coordinate versions of projects between different computers. For most programmers, using SCM software is a familiar part of their daily work routine, but I wanted to discuss the benefits and introduce the use of SCM software to those not familiar with it as I think it is can be easy to use and beneficial to everyone composing with Csound.

This article will discuss the benefits of using Source Code Management software to manage your Csound projects, specifically using the SCM software Mercurial. If you are interested in using other SCM software, you may still find the information in this article useful and should be able to find comparable methods and commands in other SCM tools. Most SCM software support many features which are incredibly useful for large collaborative projects but may not be necessary for users managing personal projects. In this article we will be introducing concepts and features but will focus on learning enough to get started managing our personal projects. For more advanced features, the reader is encouraged to read the documentation for Mercurial and other tutorials for the software.

**Note:** Familiarity with using command line interfaces (a.k.a. terminals or command prompts) is required to follow along with the tutorial.


## I. About Source Code Management Software

### What is Source Code Management Software


Source Code Management software is software which allows us to manage the life of our project. It allows us to keep a history of our files in the project with meta-data such as who worked on what changes, when the changes were made, and descriptions of what changed. It allows us to mark milestones in the project, create extra versions of our project with complete history tracking, view the history of our project and view how thigns have changed, as well as be able to retrieve and recreate any committed version of files in our project.

### Benefits to Using SCM Software


Some of the benefits of using SCM software are marked below:
- **Safety and Freedom** - by having all files within a project tracked in time, one can always revert to a previous version if changes don't work out as one would like. This freedom to return to a previous point at any time can be very liberating for creativity as it allows us to expermient without fear of losing any of our work


- **History** - Everytime a user checks in changes into the source code repository, the user is required to add a commit message: a brief description of the changes that are being commited. With this information, one can track a narrated history of the project over time. This can be useful to remind one's self of decisions made in the development of a piece of music as well as can be used as a journal to describe one's state of mind while working on the piece.
### Types of SCM Software


There are two main types of SCM software based on their architecture: centralized and decentralized. While they share many common features and concepts, there are both advantages and disadvantages to using either type of system. A brief description of these two types of systems follow below.
#### Centralized


With centralized SCM software, there is a single server which houses the project and its history. This server may live on the same computer in which you work on but is often found somewhere accessible on a network. Typical user work flow is to checkout a copy of the source code from the server and to work on their local copies. When changes are made to a point where the user wants to save a version in the repository, the user will commit changes to the server. If other changes have been commited to the server between the time the user has checked out and attempted to commit, the user will be notified that they are required to merge the changes they have made with the updated copies in the server before commiting to the server.

Two very popular examples of centralized SCM software are the Concurrent Versioning Software (CVS) and Subversion (SVN).

Some drawbacks to centralized SCM software include:
- Requires network access to the server to make commits, updates, and requests for logs and history
- Requires setting up a centralized server location; this may be local but regardless it will be separate than the local checked-out repository where one works
- Difficult branching/merging
- Difficult backup procedures

I have used centralized SCM software (particularly SVN) in the past to manage my personal music work and have found that it can work well, but once I started working with decentralized SCM software I found it more appropriate and easier to use for managing my personal work.
#### Decentralized


With decentralized SCM software, every copy of a repository is a complete and self-sufficient copy of the entire repository. Instead of checking out a copy of a repository, one generally clones a copy of one. When changes are made to a point where the user wants to save a version in the repository, the user will commit changes to the repository they are working in directly.

Benefits over centralized SCM software include:
- Does not require network access to make commits, updates, and requests for logs and history
- Easy to setup
- Backups of complete repository are as simple as copying and archiving the repository directory
- Branching/merging is many ways easier to do and encouraged

Some drawbacks over centralized SCM software include:
- Can be more difficult to communicate changes when working with groups of people (contract for how to work with changes is not as enforced as with centralized systems)

For the purpose of this article, I have chosen to use Mercurial. Besides being my favorite SCM software, I have chosen to use this for this article as it is easy to setup a repository with Mercural, its commands are familiar for those with experience with CVS and Subersion, and it also is cross-platform and stable.


## II. Concepts


Before we start to experiment with SCM software, let's discuss a few fundamental concepts. These topics could certainly be discussed much further than I will present here, but hopefully for the purpose of this introductory and hands-on article, the following will be enough to get an overview of what is involved with working with SCM software and to get you going with working with it.
### Repository


A repository is a single project that contains all of your project's files and the complete history of all revisions of those files. A repository is made up of the *store* of your project where all history and revisions are kept as well as a *working copy *of your project which you are currently working on. For Mercurial, the store is located in the special .hg directory in the top directory of your project, while all the files in your project's directory and subdirectories thereof are your working copy.
#### Store


The store is where all of the data is kept for the complete history of your project. Within the store, data is held to allow reconstructing any checked-in version of the files over the lifetime of the project. In centralized version control systems, the store is generally located in only one location, on the server, while in distributed systems, each copy of a repository has a complete copy of the store. By having a a complete copy of the store in distributed systems, users can query and view the history of the project as well as interact with the store without requiring network access to a server which may be the case with centralized SCM systems.
#### Working Copy


The working copy is the current version of the project you have on your system available to you to work on. While a file may have x number of versions held in the repository's store of history, there will be only one version of that file that is active which you work on. When working with SCM software, you will be working on the working copy of the project and then interacting with the store to commit changes as well as other operations working with the history.
### Versioning


This is the fundamental action in dealing with Source Code Management. The basic actions in working with SCM software are:
- add - add files to the repository
- commit - commit changes in files to the repository
- rename - rename files with the SCM tool so that the SCM tool can continue to track the file after the name change
- move - works like rename but for following moving around of files
- remove - remove file from the repository
- revert - rollback to a version of a file, set of files, or a change set
- diff - view changes between versions of a file

We add files to a repository to initially get them into the repository. Afterwards, we can continue to work and then when we feel it would be a good time to record a version of our work, we commit our changes to the repository. Between commits, we may add new files, edit current files, remove files no longer in use, rename files, as well as move files around amongst other operations. Each of those operations can be done with the commands listed above, though none will be recorded by Mercurial until a commit been done.

Every time we commit something to the repository, we are marking the changes that happened between the last commit and this one as a new version in the repository (called "revisions" in Mercurial). With Mercurial, when we go to commit, we are commiting not files individually but a group of changes at a time. For the purposes of this article and our simple single-person usage this will likely not mean much, but this is a fundamental difference from systems like CVS which track changes to every file individually. Systems which track changes by file are generally quicker to report changes on a single file, while systems that track changes by changesets offer the ability to report the overall view of what changes are happening as a group. There's benefits to both but I prefer changeset-based systems as I think it logically makes sense to group a set of changed files as a single change to a project.

Besides commiting changes to a project to add versions to the history of the project, SCM software allows us to revert to a previous version of a project. This gives us a great deal of safety when working on a project and allows us freedom to experiment without fear of losing any work. At any point in time we can decide to revert our work to a previous version and then continue on from there.

Another great thing about SCM tools is not only do we have recorded versions of our project, but using diff (short for differences) we can ask the SCM tool to show only what changed between two files. This can be very useful if you're working and something seems fine and then later you realize there is a problem and you don't remember what you did: you can do a diff between a known good version and the problematic one and it may help to see only what lines of text changed.

Versioning is the primary purpose of using SCM tools and allows us great freedom to work as well as records a history of a project.
###  Tagging


Within the lifetime of a project we might find that we reach a change that might have some particular significance. At that point, we may decide to *tag* a particular version in the repository. By tagging a version of the project with a descriptive name, we can easily view tags that have been given as well as use them as ways to recall a particular version of the project, something which can be easier to do than using revision numbers alone. It also helps to easily demarcate something of importance.

In software, tagging is often done when new versions of a piece of software is completed (i.e. if version 2.0 of a piece of software is completed, a repository may be tagged with VERSION_2_0 as a tag name). Musically you might want to tag your project before you embark on a large scale change that you don't know if you'll like in the end, or maybe you'll tag a big change when you've had a significant breakthrough on the piece you are working on. If you're working on a collaborative project, it might help to tag a version of your project everytime you send a recording to a collaborator so that if you continue to work and then have to discuss the work with a collaborator, you can recall the precise version you sent to the collaborator and make comparisons to your current work if necessary.
### Branching


Branching allows the forking of a repository into separate versions of a repository. The history up to the branch point is shared in common between the branches while afterwards each branch manages its own history. In software, branches are generally made for either experimentation or stability.

When experimenting, one may want to try a very drastic experiment with code architecture or some other change which if it fails you wouldn't want to keep the history of in the main branch, but if it succeeds you would want to keep the history and then merge back into the main branch. This would be a case where one has their main branch and then branches off an experimental branch.

In the case of stability, branches are generally made when a new milestone is hit such a new release version. The stable branch is branched off from the main "current" branch so that any bug fixes to the stable version can be done in the stable branch and releases of bug-fix only versions can be done from that stable branch, while mainline development is continued in the "current" branch or "head" branch.

The correlate to branching is merging. Merging on a file by file basis can happen in everyday usage while merging of branches back together is not as common and generally much more difficult to do. One generally has to resolve all clashing differences manually before finally merging together. Once branches are merged back together, the complete history for both branches will be maintained in the new merged branch. This is useful for being able to retrieve the history of the project.

For the purpose of managing our Csound projects, more than likely we won't really need to use branching so much for tracking different versions though we will use them to create clones of repositories (discussed later in this article), but it is good to be aware of what is possible in case you find a need for it in the future. Also to note, in centralized systems like CVS, creating a branch and merging them is generally a difficult task to handle and is somewhat of a monumental event, while in distributed systems like Mercurial, all copies of a repository are branches in themselves which may share history between each other as well as their own history and is a common everyday thing to do.


## III. Introduction to Mercurial


Mercurial is an open source, cross-platform, distributed version control system. It is available at:

[http://www.selenic.com/mercurial/](http://www.selenic.com/mercurial/)

The website has quite a bit of documentation, tutorials, references, and other information available for the reader. For now, we'll be walking through some basic usage of Mercurial in the following sections to get ourselves on track to managing our Csound music projects.
### Installation


The simplest way to install is to use a pre-compiled binary installer. If you can not find the link on the website, the direct link is:

[http://www.selenic.com/mercurial/wiki/index.cgi/BinaryPackages](http://www.selenic.com/mercurial/wiki/index.cgi/BinaryPackages)

You should follow the instructions for installation found on the Mercurial website. (If you're on a Linux system, Mercurial is likely available to install via the package manager your system uses(apt, yum, etc.).)

Afterwards, you should have Mercurial installed and on the path and should be able to open up a terminal/command prompt and type `hg --version` to get something like:
```csound

Mercurial Distributed SCM (version f48290864625+20070705)
Copyright (C) 2005-2007 Matt Mackall <mpm@selenic.com> and others
This is free software; see the source for copying conditions. There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE

```


After you are able to do this, you should also set up your ~/.hgrc file (if using Windows, the file to edit is Mercurial.ini in your user home directory) and setup your username:
```csound

[ui]
username = Steven Yi <stevenyi@gmail.com>
```
 This will be used when committing changes to your repository so as to know who did the change committed.
### Planning Your Project


With Mercurial, each repository should hold everything for one project. This might be a single piece of music, or it could be all the files making up an album of music. It's really up to you to decide what is the scope of the project that will be in your repository.

For myself, I use one piece per project repository. In my project directory I have my .blue project file, a Rakefile (a build script that makes it easy to generate CSD, WAV, MP3, OGG, and FLAC files with a single command), any notes or charts I may have written regarding the piece and material, as well as any files my .blue project may depend on (i.e. convolution files, wave files, etc.). I also keep one repository of experiments that contains a number of files, each with a single experiment I may work on quickly to try out a sound synthesis technique or idea. I find that these experiments work well to keep together in one repository.

**Note:** It is wise to figure out the scope of your project before working with SCM tools, as it can be very difficult if not impossible to merge or split repositories at a later time (i.e. you decide you want to track one project as multiple different projects or you decide you would want to track multiple projects as a single project).
### Initializing a Repository


To start a project we will need to initialize a repository which will setup our project to start working with versioning. To start, you can either create a new directory or go into the root directory of an existing project. For the purpose of this article, we will create a new directory entitled "test". Open up a terminal and go into a directory where you will create your new project folder. Once there, type:
```csound
mkdir test
cd test
hg init
```


These three commands will create a directory named test, change into the directory test, and then initialize a repository (`hg` is the command used for Mecurial and is the chemical symbol of mercury). Mercurial will create a folder named `.hg` in the directory you are in. This is is where Mercurial will hold all of the information for tracking the complete history of your project. (This is different than other systems like Subversion where an .svn directory is added to every directory and subdirectory within a tree of folders and holds data for just that directory).
### Checking Status of the Repository


At this point we have initiated the repository and we are at the beginning of our project with no changes yet checked into our project. To check the status of our repository type:
```csound
hg status
```


This will compare the current contents of the project directory tree against the last version committed to the repository and give us a note of what differences of status of files there are (new files found, files modified, etc.). In this case, since we have not added or created any files, typing this command will report no changes as there is no difference between what is currently in the project directory and the initial empty state of the project.

We will be using this command very often to see our current status. It will help us to know what has changed in our working copy since we have last commit changes to the store. Its use will become more obvious as we use it in context to the other commands below.
### Adding Files into a Repository


The first thing to do for our project is to create a new file and add it to our project. Let's start off by creating an empty text file named `myTestProject.csd` in our `test` project directory. After doing this, while in the `test` project directory, type `hg status`. Mercurial should report to you:
```csound
? test.csd
```


Mercurial is reporting that it has found a file named `test.csd` and the current status is of this file is that Mercurial has no history for this file and does not currently track this file. Whenever we add new files to our directory or subdirectories below the root of the project, Mercurial will report the status of these files as being unknown.

Since this will be a file that we would like to have tracked by Mercurial, we will need to add it to the repository. We can do this using either of the following commands:
```csound
hg add
hg add test.csd
```


The first command will add all files that are currently marked as unknown to Mercurial. The second command would explicitly add just `test.csd` to the repository. For the purpose of our tutorial we can use the first form, though we may want to use the second form if we've done a lot of work and want to check in files one at a time.

Although we have told Mercurial to add the file to the repository, the test.csd is not yet checked into our system. The add command has simply tells Mercurial that we have a file that we would like to start tracking changes, that this a type of change that has happened. If we type `hg status`, Mercurial should now report to you:
```csound
A test.csd
```


This tells us that this Mercurial has now scheduled to add this file when you next commit your changes to the repository. After commiting the file, Mercurial will then know to look at this file when looking for changes between the working copy and what it has in its store of history.
### Commiting Files into a Repository


Now that we have told Mercurial that we want to start tracking `test.csd`, let's commit the change to the project. We can commit our change using either of the following commands:
```csound
hg commit
hg commit -m "Message describing this commit"
```


Mercurial, like all SCM software, requires that a user describe the change that is being committed. This will allow us to later look at the reveision history of our repostiory and review the message that accompanied the commit to understand why the change was done. Using the first form above, Mercurial would create a temporary file and then use a text editor (configurable by the user in their .hgrc file (Mercurial.ini on Windows) in their home directory, please see the Mercurial documentation for [hgrc](http://www.selenic.com/mercurial/hgrc.5.html) and look for the editor property in the ui section) to allow you to type in a descriptive message in the text editor, save, then close the editor. For example, on Windows, if we type `hg commit`, Notepad would open up with a text file that had contents like:
```csound
HG: user: Steven Yi <stevenyi AT gmail.com>
HG: branch default
HG: changed test.csd
```


You would type in your comments about the change being committed above those lines starting with "HG:" that Mercurial has pre-filled in. Those lines, which are there to help you know what your commiting, will be ignored when you commit your change. Saving the file and then closing the edtor will signal to Mercurial that you have finished writing your commit message and Mercurial will then use that to commit the change. If you do not save the file before closing the text editor, Mercurial will assume you are canceling the commit and will not proceed.

By using the second form of commit above with the `-m` flag followed by a quoted string message, we can more quickly type in a message to do a commit. This is often used when doing a simple change while using the text editor may be more effective for describing larger changes. For programming projects I've often used just the commandline `-m` flag, but for my music project I've gotten into the habit of using the text editor to write very detailed comments about changes that were done, reasons why, things I'm thinking about trying next, etc. to keep a very detailed journal about the piece and the changes that happened. I've found this kind of very descriptive messages useful in my musical work which can be very subjecive, while working within the context of a programming project I would use shorter messages as looking at the changed code can tell exactly what changed, something not always possible with music work.

Ultimately, what you write and how much you write to describe your changes will be for you to decide and should be whatever will help you most to understand the history of your project. For the purpose of this tutorial, let's use the following command:
```csound
hg commit -m "Added initial empty version of test.csd"

```


This will commit our first change to the repository. Now if we type `hg status`, Mercurial should now report back nothing as what is in our project directory is now identical to the last version commited to the repository.

**Note:** Similarly to the the add command, the commit command can be used with no arguments to commit all changes or it can take a list of files if you would like to explicitly commit a set of files as a single change.
### Viewing Logs


Now that we've made our first commit, let's take a look at the history of our project. If you type `hg log`, you should now see something similar to:
```csound
changeset:   0:c5b775945631
user:        Steven Yi <stevenyi@gmail.com>
date:        Tue Sep 25 21:45:25 2007 -0700
summary:     Added initial empty version of test.csd

```


This gives us a log of all of our changes for this project including the user commiting the change, the date and time of the change, and the summary of our commit message for our change (usually the text of our commit message up to the first newline).
### Viewing Differences Between Versions


Now at this point we really only have one version in our repository. Let's modify our test.csd file with a text editor to have:
```csound
<CsoundSynthesizer>
<CsInstruments>

sr = 44100
ksmps = 1
nchnls = 2

	instr 1

iamp	= ampdb(80)
kenv	linseg 0, .01, 1, p3 - .02, 1, .01, 0
aout 	vco2 1, 440
aout	moogladder aout, 6000, .01

aout 	= aout * kenv * iamp

	outs aout, aout
	endin

</csInstruments>
<CsScore>
i1 0 2
</CsScore>
</CsoundSynthesizer>
```


After saving the file, view the status of the repository by issuing `hg status`. You should see the following:
```csound
M test.csd

```


which means that the test.csd file has been modified since the last commit. Now before committing, I can tell Mercurial to show me the difference between what is in the current directory and what is the last version in the repository. Issuing `hg diff` should show:
```csound

diff -r c5b775945631 test.csd
--- a/test.csd  Tue Sep 25 21:45:25 2007 -0700
+++ b/test.csd  Tue Sep 25 21:50:12 2007 -0700
@@ -0,0 +1,24 @@
+<CsoundSynthesizer>
+<CsInstruments>
+
+sr = 44100
+ksmps = 1
+nchnls = 2
+
+       instr 1
+
+iamp   = ampdb(80)
+kenv   linseg 0, .01, 1, p3 - .02, 1, .01, 0
+aout   vco2 1, 440
+aout   moogladder aout, 6000, .01
+
+aout   = aout * kenv * iamp
+
+       outs aout, aout
+       endin
+
+</CsInstruments>
+<CsScore>
+i1 0 2
+</CsScore>
+</CsoundSynthesizer>
\ No newline at end of file
```


This message can be cryptic but it is in the standard diff format, which generally shows sets of differences in lines between two files, alternating between lines in the first file that are differerent than lines in the second file. In this case, the first version is empty and the second version has a number of new lines added (shown by the + signs). At this point, lets go ahead and commit this by using:
```csound
hg commit -m "Initial version of this project."
```


After this, typing `hg status` should report nothing has changed since the last version. Now if view the log using `hg log`, we should now see two sets of changes as part of our log:
```csound
changeset:   1:30043f58bb34
tag:         tip
user:        Steven Yi <stevenyi@gmail.com>
date:        Tue Sep 25 21:56:35 2007 -0700
summary:     Initial version of this project.

changeset:   0:c5b775945631
user:        Steven Yi <stevenyi@gmail.com>
date:        Tue Sep 25 21:45:25 2007 -0700
summary:     Added initial empty version of test.csd

```


**Note:** From our log we can see that changesets are labeled with a revision number, a colon, then a unique identifier. The revision number can often come in handy in conjunction with the Mercurial commands that take a revision option. Say for instance we want to the log for revision 0, we can do that just by using `hg log -r 0`. Also to note, you can always get help for Mercurial commands by adding `--help` after a command, such as using `hg log --help` or `hg diff --help`. Issuing the help for diff would show that you can control what two revisions to diff between, a very handy feature when you need it!
### Reverting to a Version


So far we have shown how to add files, make changes, view changes, and generally see the history of our work. One of the most important features of SCM software is the ability to revert our work to a previous version. This allows us great freedom to experiment with our work as we do not have to fear losing anything should we later decide we did not take the correct path with our work.

Let's modify our test.csd file and remove the line of code from the instrument that is filtering with `moogladder.` Now, issue this command:
```csound
hg commit -m "Experimenting with removing use of moogladder."
```


Now, say we're at the end of the day and are a bit tired and decided to commit our work. The next day we're fresh again and we come back ready to work on our project and we give it a listen and think "Wow, this wasn't a good idea. Let's go back to the previous version and start from there". If we weren't using SCM software or some other form of primitive management of files (i.e. using multiple copies of files with different version numbers as part of their filenames), we'd have to remember exactly what we had done before and basically redo the work.

With SCM software, we can use the software to automatically go back to a version we commited to the repo. First, we need to know what version we want to go back to. If we issue the command `hg log` we might decide just to go back one version to version 1. Now, we use the Mercurial revert command to go back to revision 1 by issuing:

```csound
hg revert -r 1 test.csd
```


 This will return our working copy of test.csd to the way it was in revision 1. Now, although we are now back to having the same contents as we did in revision 1, if we type `hg status` you should get a message from Mercurial that test.csd has been modified, which is accurate as the contents in the working directory have changed since the last commited version of the project (revision 2). At this point, before continuing with our work, we can commit our changes with a comment like:
```csound
hg commit -m "reverted to previous version as sound was too harsh
without some low pass filtering"
```


which would give us some good information as what why we did the change we did. We may look back later at our project and read these comments with interest to get a sense of why we made the decisions we made when we made them.

The revert command can also be used with an `--all` commandline flag and no filename which will revert all files in the workspace to the given revision number (or to the last revision if no number given, discarding any changes we've made to our working copy since the last commit). This is a powerful feature which can allow us to revert to a version and see exactly what our project looked like when we checked in that revision.

**Note:** If you do a revert on a file in your working copy that had changes since the last saved revision committed to the repository, Mercurial will make a copy of the modified file with extension .orig added to it before reverting the contents of that file. This is a safety measure in case you wanted those changes or wanted to reference something in that modified version. If you are going to do a revert and know for sure you don't need anything in the modified file, you can use the `--no-backup` commandline flag.
### Removing, Moving, Renaming, and Copying Files


We may normally be accustomed to removing, moving, or copying files by issuing commandline commands or using file explorers or other GUI tools. When working with a SCM tool to track the changes of our files, we will need to use the SCM tool's versions of these commands so that the tool can track the changes and add those changes as part of the history of the project.

For Mercurial, we can use the following commands:
```csound
hg remove [file]
hg move [file] [some other location]
hg rename [file] [new file name]
hg copy [file] [new file name]
```


to remove, move, rename, or copy a file respectively. Like the add command, when we issue any of the above commands, they will describe a change to Mercurial but it will not be a part of the history of the project until you commit the change. If we do not use Mercurial's versions of these commands, Mercurial would not not know how to track the change (i.e. a renamed file might be tracked as the original file being deleted and the newly renamed file as a new file).
### Ignoring Files


While working with Mercurial and any other SCM software there will often be files which you would like to ignore having their history tracked. These are usually files which themselves are generated from the other project files. With software, you would normally want to track just the source code but not the generated exectuble binaries as those can always be generated by the source code and adding them to the history of our project would bulk up the storage requirements of our repository.

In the context of Csound music projects, one may want to keep track of wave files which are used as part of our project, but probably would not want to track the actual generated wave files one gets after running Csound and outputting to disk, as one could always generate those with the source CSD and wave files.

The means by which to tell Mercurial what files should not be included as part of the history of your project is the .hgignore file, created and placed in the root directory of your project. The file is a text file that has entries using either regular expression syntax or shell glob syntax. For this tutorial, we will use the glob syntax which should be familiar to those using commandlines.

A standard .hgignore file I use is as follows:
```csound
# Comments here
syntax:glob

*.mp3
*.wav
*.csd
*.flac
*.ogg
*.png
```


You can add comments to your .hgignore file by prepending any line with #. By adding `syntax:glob` it tells Mercurial to use the glob syntax in interpreting the lines following that directive to Mercurial. In this case, my default .hgignore file will ignore any generated MP3, WAV, CSD, FLAC, OGG, and PNG files, as my projects are generally blue project files from which CSD's are generated, later rendered by Csound into WAV, MP3, OGG, and FLAC via a Rakefile (a Rakefile is like a Makefile but done in Ruby code; this allows me to generate all of the target audio files easily with one command) and rendered into a PNG file by a score visualization script. Only the main project files are kept in the project history while all of the generated files are ignored.

For most users, a similar script but removing the `*.csd` would probably cover most cases (assuming you are working with CSD files as your primary project file). The .hgignore file itself is a file which can be tracked for history and will not be ignored unless you explicitly add itself to the contents of the file. In most cases it probably would be best to add and commit the .hgignore file to your project. That way, if you make copies of your project you will have your list of files to ignore available as part of your project.
### Summary


With the brief introduction above we've learned how to use Mercurial to create a new respository as well as to commit and track versions of the files in our project, view the log messages, as well as how to revert to previous versions of a file or state of project. This gives us enough to start working with Mercurial for our own personal projects and to gain the benefits of Source Code Management software. The user is encouraged to continue to experiment with all of these commands with the example project to become more familiar with tracking and working with the history of their projects.

Next, we'll be looking at managing the repository itself and working with multiple copies of the repository.
##

## IV. Managing Repositories


Beyond the ability to track and retrieve the history of our project we will also learn how to manage the repository. This will include backing up a repository, cloning a repository, as well as syncing between different repositories.
### Backing up a Repository


Like most distributed version control systems, backing up a Mercurial repository is as simple as making a copy of your project's directory. This is because every repository and copy of a repository contains the complete history of the of the project. You can zip up the directory if you want to make an archive file or burn a copy of your project's directory to a CD and those copies will be complete copies of the entire project, history and all.

While this may seem obvious, those with experience with centralized version control systems will find this an incredibly useful feature as centralized systems only have the complete history of a project at the server side and generally require tools to make and restore backups. Compared to these systems, distributed systems like Mercurial are much simpler to backup.
### Cloning a Repository


Cloning a repository is much like making a copy, but by using the clone command Mercurial will automatically setup hgrc within the .hg file of the cloned repository to have a default path pointing to the original repository. (The hgrc file is an optional file that contains configuration for that repository; a system-wide one can also be used was mentioned earlier in this article. More information on the .hgrc file can be found [here](http://www.selenic.com/mercurial/hgrc.5.html).) On systems which support it, Mercurial can also use hard links when creating clones on the same filesystem, saving hard drive space.

For those experienced with centralized source control software, cloning a repository is very much akin to checking out a copy of a project. If one was to grab a copy of the source of a project managed by Mercurial, one would often issue the clone command from a public copy of the repository over the interent. (Clones can occur locally on the same harddrive, between different drives, and across networks).

For our purpose, let say we want to create a second copy of our work on a USB keydrive, one in which we will want to sync to and from often to always have a copy of our work on hand in case we want to work on our project on the go. On windows, let's say the keydrive was assigned the drive letter g: and our project exists at c:\work\myProject. Going to the commandline, we could type the following:
```csound
g:
hg clone c:\work\myProject myProject

```


This would first change to the g: drive, then clone the project at c:\work\myProject as myProject on the g: drive. Mercurial should report that the project cloned successfully, and we now have a copy of our project on the keydrive.

Now, going to the keydrive's version of the project, if you go to the .hg directory within the keydrive you should find a hgrc file there with the following contents:
```csound
[paths]
default = C:\work\myProject
```


This means that the cloned project is setup to use the location in which it was cloned from as the default for synchronization. If we did not use clone and simply copied the project, we would have had to create this hgrc file ourselves or manually type in the sync location everytime we synced.
### Syncing Between Repositories and Updating


Imagine a scenario where we will want to have our project on two different computers (say a home computer and a work computer, or a laptop and a desktop). Ultimately we want everything to be in sync and to be able to have our latest work be available on all computers. Let us set up a system where we keep copies on each computer and sync to an easy to access location, such as a keydrive.

To make this easy, let's move the test project to the keydrive and remove it from our computers. Next, stick the key drive in and using the clone command, clone from the keydrive to the computer. Do this for each computer you want work on. What this will do is setup the cloned repositories to have the default sync location be the keydrive, and that will use whatever the keydrive's assigned harddrive or mount point is on that particular system.

Now, let's imagine we do some work locally on one of the computer's drives and not directly on the keydrive. We do some work and commit changes to our local repository on the hard drive. After a while, we finish up and decide to sync it to the keydrive. The command to move changes from the repository you are working in to another repository is `hg push`, which will check the target repository (in this case, the one on the keydrive that is setup as the default sync location since we cloned from there) for what the last version was on there, then push all of the new changes since that last version found to the keydrive.

From here we take the keydrive and move over to another computer we want to work on and now want to grab the changes from the keydrive. In this case, we will use the `hg pull` command to grab new changes from the keydrive to the repository on the other computer.

After we pull changes, this will update the history data in the repository's store, but this will not affect the current working files. If you want to update the working files to the last revision in the store you will have to issue the `hg update` command. This will apply all the new changes to the working files. At this point we may do some more work locally, then push our changes to the keydrive, switch computers, and pull from the drive once again to get the changes back to the first computer. (Don't forget to issue the `hg update `command!).

Before doing pushes and pulls you can ask to see a log of incoming and outgoing changes by issuing `hg incoming` and `hg outgoing` respectively. These commands will actually compare the source and target repositories so you can see what changes are going to be sent across or received before actually doing the actual push or pull, which can be useful at times.

We now have a means to work on two different computers and keep them in sync via a third common location of a keydrive. We can always have our project on us anywhere and work off the keydrive when on the go or work on different computer systems and have a meants to keep them in sync. Also, as a reminder, we can always do work locally and push changes to other repositories at a later time when it is convenient, so working on a plane or at a cafe where there is no internet connection doesn't mean we can't keep committing and tracking changes.
### Experimenting with Local Cloned Repositories


We can also use the clone, push, and pull mechanism with locally cloned repositores to do experimental work. We may want to have our stable repository in which we receive changes as well as do our main work, but then have a locally cloned repository where we might want to try doing drastic changes. The experimental repository can still pull changes from the stable repository and you can do work within each repository without interfering with the other. If later you decide the experimental work was a success, you can push your changes into the stable repository and delete the experimental respository as the complete history of your experimental work has been added to the stable repository's store of history.
### Remote Repositories


All of the above features allow us a great deal of flexibility in where we work with our projects as well as makes it possible to work on any number of systems without worrying about how to synchronize everything. For myself, I normally have a copy of my project repositories on a server to which I synchronize with over the internet via SSH. This allows me to work on a number of different computers and communicate my changes easily to the other computers by synchronizing through the repository on the server. This kind of system works well for distributed or centralized SCM software, and can be a very good option for having a backup of your work. I know this from my own experience where twice a hard drive has failed on me but I did not need to worry as my work was all backed up on the server. Once I got a new hard drive all I had to do to get back to working was clone the project from my server and instantly I had a copy of my work with all of its history right there. A great relief!
### Conflicts and Merging


One of the most difficult things to handle when working with SCM software is dealing with conflicting changes. Some familiar with SCM software may ask why I've taken so long to get to this very crucial issue which users working in collaborative environments have to deal with regularly. I have found that when managing my own personal work I am alway synchronizing changes before working and that I rarely have conflicting changes in different repositories that I am working with. There are times though that I will work in one location, then another without opportunity to sync between the two and something may conflict so it does happen on a rare occassion, but it is important to know what to do when this happens. I will cover this topic only briefly to get an overview of the conflict resolution and merging process as there are tutorials which cover this topic linked to below.

Often times changes in files don't conflict, for example lines 2-8 change in file A in repository A and lines 10-12 change in file A in repository B. These changes can likely just be pushed and pulled between repositories without problem as they do not conflict. Sometimes the changes may not makes sense when done separately and within different contexts, but at least they can be merged automatically and you can work out what is supposed to happen and update from there.

For conflicting changes, they can not be automatically merged. For example, if in repository A you have a file A which you edit lines 3-12, then in repository B lines 10-14 were modified in file A, lines 10-12 will both have changed in the different repositories. Trying to push changes to a repository will alert you to an error that there are conflicts which require merging to be done and issuing a pull will succeed but will alert the user that conflicting changes have occurred (new heads have been created in Mercurial parlance, meaning end points in the graph of the history of the project) and that merge work should be done.

In general, when working with multiple repositories, it is best to get into the habit of pulling from the location you sync with before you do any work. That way, you will always be working with the most up to date version and will minimize the chance of a conflicting change occuring. If a pull results in conflcting changes coming in, you'll see a message like this after you pull:
```csound
added 1 changesets with 1 changes to 1 files (+1 heads)
(run 'hg heads' to see heads, 'hg merge' to merge)
```


It is best to do the merge work as soon you realize there is merge required so that it doesn't complicate matters even more later. The `hg heads` command will give you a report of all the changesets in the repository that end up with an unique history endpoint. Most of the time you'll find that if you have conflicting changesets you'll end up with 2 heads. If so, typing in `hg merge` would start the merge process between the two revisions. If you have more than 2 heads, Mercurial would force you to give explicit revision numbers to merge between (the revision numbers can be looked up from the log given by running `hg heads`) so that it knows which ones to merge, and you would have to do this a number of times to merge all the different conflicting versions back down to one unique version.

The actual process of merging generally requires you to view the two different versions and figure out what changes from both are needed to create a satisfying merged third version. It might very well be the case that you decide to use one version or another in its entirety and to discard the changes from the other version, but you will need to at least make that decision and commit that to Mercurial so that it knows in the history of the project it branched for a moment but merged back together with the new file.

Because this topic is complicated and something which you may not ever come across when working on personal projects, I will not go into further details here as there are good tutorials on merging and conflicts [here](http://www.selenic.com/mercurial/wiki/index.cgi/TutorialMerge) and [here](http://www.selenic.com/mercurial/wiki/index.cgi/TutorialConflict).


## V. Conclusions


This article introduced basic concepts of Source Code Management software, given reasons and benefits for using this for your Csound music projects, and provided a basic tutorial to using Mercurial for your work. Hopefully by this now you will have given this approach to managing your music projects a try and found the benefits to using such a software to be easy and useful. I hope you have enjoyed this article and found it useful for managing your own work!

*If you've found you liked using Mercurial and would like to learn more, please consult the excellent book "[Distributed revision control with Mercurial](http://hgbook.red-bean.com/)" by Bryan O'Sullivan. Reading this text will give you a deeper knowledge of version control systems and learn how to take advantage of Mercurial's many features.*
