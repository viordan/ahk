Git https://github.com/viordan/ahk/

AHK https://www.autohotkey.com/download/ahk-install.exe

VSCode extension https://github.com/cweijan/vscode-autohotkey


Hello everyone, 

The term automation is a simple concept that has a large scope.  This is especially true for software development, and I would venture to say more so for QA in software development.

In this presentation I will go over a tool that can be used to automate tasks in Windows, to be noted this explicitly does not work on a Mac.  The purpose of this is Lunch and Learn is to provide an example of  how to create and execute a macro in Windows. The scope of the automation can be from trivial to extremely complex, and your imagination is the limit.  Also note the fact that this tool is not meant as a solution for Prodigy’s current automation needs but a general introduction.  The concepts between automation tools are similar, therefore understanding one tool, will give you a good idea of basic principles.

The expectation of this tutorial is that you have looked at code before, but you are not a developer.  I will intentionally avoid complicating the logic.  This means that while at times there will be much more efficient ways of writing the code, I will always choose simplicity over best practices.  Warning, some developers may cringe. 

I will use autohotkey vs 1.1.33.00 released June 29th, 2020.  You can download it from https://autohotkey.com.   In my experience, for a Windows environment AutoHotkey (henceforth AHK) is by far the best tool.

For an editor you can use VS Code with the autohotkey extension (search for autohotkey).  You can also use an older editor called SciTE4AutoHotkey found at http://fincs.ahk4.net/scite4ahk/.  For this tutorial I will use that.

Ok, enough introduction.  Let’s look at what we’re trying to accomplish.  In order to automate a process, you have to first clearly understand and document the manual steps needed for that process.  Once you have that, it’s a matter of choosing a tool that can perform those manual steps for you.

The benefits of a tool like AHK is that you get instant gratification and you can also build the logic gradually.  It will produce results from the first line of code without any setup necessary.

Let’s jump right into it.  For our first process I want to:
Open Notepad.exe
Wait for it to be fully operational (this step is kind of tricky)
Type “Hello World”
Press “{Enter}” to move to the next line
Type “Welcome to automation!”

Cool, let’s do that (go through steps)

Now if I want to write a macro to do just that I will open up my trusty editor (scti)
Save the script

>run, notepad.exe

>Sleep, 1000

>send, Hello World

>end, {Enter 2}

>send, Welcome to automation!

The one line here that stands out is sleep, 1000, that basically tells the macro to wait 1 second which works, but imagine you’re running this on a computer that takes 2 seconds to open notepad, or 5 seconds.  Using any sort of time delay in automation is the least elegant way of doing things.  It will work in that instance on that computer.  A much better way to write this is if the computer somehow told us when notepad.exe was ready after we execute it. 

Luckily there is a function built into AHK that does just that, it’s called WinWait, and there are a few variations of it, WinWaitActive, WinWaitClose, etc (see online documentation for complete list).

In this particular case we want to know if the window is active. We will use WinWaitActive

run, notepad.exe
WinWaitActive, Untitled - Notepad
{
	send, Hello World
	send, {Enter}
	send, Welcome to automation!
}

Now, no matter how long it will take for the window to open, it will wait for that amount of time.  Let’s save and run this… cool… automation.


The HK in AHK stands for HotKey, what is that exactly?  Well it means that if you want to set a key combination to run a specific macro, you can do that quite easily.  In this example let’s suppose that we want to run this script every time we press CTRL+J.  It’s as simple as this.

^j::
run, notepad.exe
WinWaitActive, Untitled - Notepad
{
	send, Hello World
	send, {Enter}
	send, Welcome to automation!
}
Exit

Observe what happens to the script now, rather than just running it and closing it, when it encounters the :: it knows that it has to wait for the command before those dots.

The Exit simply tells it that it’s done with that hotkey.

You can then add a second hotkey let’s say CTRL+K to something else like so. (when saving add #SingleInstance force)

#SingleInstance, force
^j::
run, notepad.exe
WinWaitActive, Untitled - Notepad
{
	send, Hello World
	send, {Enter}
	send, Welcome to automation!
}
Exit
^k::
send, I'm doing some other thing now
Exit


Second, and last example, we’ll try to automate something a bit more fun.  
Let’s start a new script
At the top we can begin with this since we already know what it does.  It will start this script, and only one instance of it, and wait for us to press CTRL+J

#SingleInstance, force
^j::

Let’s try to open Chrome at play.prodigygame.com. In order to do that from windows, you can find wherever your chrome executable is, mine is in C:\Program Files (x86)\Google\Chrome\Application\chrome.exe and add the URL play.prodigygame.com

C:\Program Files (x86)\Google\Chrome\Application\chrome.exe play.prodigygame.com

Let’s try that in windows Run. (open Run and paste the above).  Cool that worked,  let’s go to AHK.  

#SingleInstance, force
^j::
run,  C:\Program Files (x86)\Google\Chrome\Application\chrome.exe play.prodigygame.com,,max

Now this gets a little tricky, remember the winwaitactive? In order to check if the webpage has opened, that command will not work, that will simply check that Chrome has opened a window, not that it navigated to it.  There is an easy way to determine if something is loaded in the window and there is a proper way.  We’re going to do it the easy way :).

Let’s observe what we do once the page opens, as a human user, we observe that the button is loaded and we click on it.  Luckily AHK can do the same thing.  It’s called imageSearch and it searches for an image that you have previously.  Let’s go back to the page and take an image.


This gets a little tricky, there’s a bit of logic involved.  FIrst of all we need to create a variable called pageLoaded and we need to make it false. Then check for the image and make it true if found.  Ok let’s do that

pageLoaded := false

This again is very simple in AHK, you just create a variable and assign it a value.  Next you need to do something until it’s no longer false.

while (pageLoaded = false)
{
	; in here we’re going to do some stuff in a loop until that’s true.
	; this will run way too fast so let’s do something every half a second
	Sleep, 500
	; next we do the image search
	ImageSearch, X, Y, 0, 0, A_ScreenWidth, A_ScreenHeight, login.png
	If ErrorLevel = 0
	{
	pageLoaded := true
	MouseClick, left, X+10, Y+10
}
}



And the complete script 

#SingleInstance, force
^j::
While WinExist("ahk_exe chrome.exe")
{
WinClose, ahk_exe chrome.exe
}
sleep, 1000
CoordMode, Pixel
run,  C:\Program Files (x86)\Google\Chrome\Application\chrome.exe play.prodigygame.com,,max
pageLoaded := false
while (pageLoaded = false)
{
	sleep, 500
	ImageSearch, X, Y, 0, 0, A_ScreenWidth, A_ScreenHeight, login.png
	if ErrorLevel = 0
	{
		pageLoaded := true
		MouseClick, left, X+10, Y+10
	}
}
pageLoaded := false
while (pageLoaded = false)
{
	sleep, 500
	ImageSearch, X, Y, 0, 0, A_ScreenWidth, A_ScreenHeight, username.png
	if ErrorLevel = 0
	{
		pageLoaded := true
		MouseClick, left, X+40, Y+40,2
		Send, julianai213
		Send, {Tab}
		Send, june242006
		Send, {Tab 2}
		Send, {Enter}
	}
}
pageLoaded := false
while (pageLoaded = false)
{
	sleep, 500
	ImageSearch, X, Y, 0, 0, A_ScreenWidth, A_ScreenHeight, next.png
	if ErrorLevel = 0
	{
		pageLoaded := true
		sleep, 1000
		MouseClick, left, X+20, Y+20
	}
}
pageLoaded := false
while (pageLoaded = false)
{
sleep, 500
	ImageSearch, X, Y, 0, 0, A_ScreenWidth, A_ScreenHeight, home.png
	if ErrorLevel = 0
	{
		pageLoaded := true
		sleep, 1000
		MouseClick, left, X+10, Y+10
	}
}


