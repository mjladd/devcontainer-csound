# 5. The Application class is instantiated and its main loop is run.

5. The Application class is instantiated and its main loop is run.
The application consists of a main window (Fig. 11.1) with a single button
(‘play’), which will trigger an event lasting for 2 seconds.
Listing 11.2 Python GUI application example
#!/usr/bin/python
import Tkinter as tk
import csnd6
class Application(tk.Frame):
def __init__(self, master=None):
# setup Csound
self.cs = csnd6.Csound()
self.cs.SetOption('-odac')
if self.cs.CompileOrc('''
instr 1
a1 oscili p4, p5
k1 expseg 1,p3,0.001
out a1*k1*0dbfs
endin
''') == 0:
self.cs.Start()
self.t = csnd6.CsoundPerformanceThread(self.cs)
self.t.Play()
# setup GUI
tk.Frame.__init__(self, master)
tk.Frame.config(self, height=200, width=200)
self.grid(ipadx=50, ipady=25)
self.Button = tk.Button(self, text='play',
command=self.playSound)
self.Button.pack(padx=50, pady=50, fill='both')
self.master.protocol("WM_DELETE_WINDOW",
self.quit)
self.master.title('Beep')
# called on quit
def quit(self):
self.master.destroy()
self.t.Stop()
self.t.Join()
11.9 Conclusions
205
# called on button press
def playSound(self):
self.cs.InputMessage('i 1 0 2 0.5 440')
app = Application()
app.mainloop()
Fig. 11.1 Main window of Python application (as deﬁned in listing 11.2)
11.9 Conclusions
This chapter set about introducing a scripting dimension to the interactive side of
Csound. We have looked at how the engine can be instantiated and its performance
controlled in a very precise and ﬂexible way through the Python language. A sim-
ple, yet complete, example was given at the end, providing pointers to the types of
applications this functionality can have. In addition to the ideas discussed here, we
should mention that Csound can be fully integrated into the workﬂow of a program-
ming environment such as Python, providing a highly efﬁcient and conﬁgurable
audio engine. Applications in music performance, composition, soniﬁcation and in
signal-processing research are enabled by the system.
Part IV
Instrument Development
