#SingleInstance force
^j:: 
While WinExist("ahk_exe chrome.exe")
{
WinClose, ahk_exe chrome.exe
}
sleep, 1000
CoordMode, Pixel
Run, C:\Program Files (x86)\Google\Chrome\Application\chrome.exe play.prodigygame.com,,max
pageLoaded := false
while (pageLoaded = false)
{
	sleep, 500
	ImageSearch, X, Y, 0, 0, A_ScreenWidth, A_ScreenHeight, loginbutton.PNG
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
		MouseClick, left, X+40, Y+40, 2
		Send, ahktest
		Send, {Tab}
		Send, test123
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
		sleep, 500
		MouseClick, left, X+10, Y+10
	}
	ImageSearch, X, Y, 0, 0, A_ScreenWidth, A_ScreenHeight, wronglogin.png
		if ErrorLevel = 0
	{
		MsgBox, it broke
		exit
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
		sleep, 500
		MouseClick, left, X+10, Y+10
	}
}
pageLoaded := false
while (pageLoaded = false)
{
sleep, 500
	ImageSearch, X, Y, 0, 0, A_ScreenWidth, A_ScreenHeight, choose.png
	if ErrorLevel = 0
	{
		pageLoaded := true
		sleep, 1000
		MouseClick, left, 400, 450
	}
}
MsgBox, we're done!

exit