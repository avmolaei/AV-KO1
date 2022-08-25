^+#z::
		gosub Move
return

^+#s::
	gosub Move
return

^+#d::
	gosub Move
return

^+#q::
	gosub Move
return


^+#a:: MouseClick, left
^+#e:: MouseClick, right

^+#r:: WheelUp
^+#f:: WheelDown



Move:
	Rate := 20
	Loop
	{
		X := Y := 0
		if GetKeyState("q", "P" )
			X := -++Rate
		else if GetKeyState("d", "P")
			X := ++Rate
		if GetKeyState("z", "P")
			Y := -++Rate
		else if GetKeyState("s", "P")
			Y := ++Rate
		if (!X and !Y)
			return
		else
			MouseMove, X, Y,,R
	}
return


Esc::ExitApp