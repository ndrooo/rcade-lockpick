class_name LapTimer
extends Container

enum Side {LEFT, RIGHT}

@export var side: LapTimer.Side = Side.LEFT:
	set(value):
		side = value
		if value == Side.LEFT:
			%LeftPointer.visible = true
			%RightPointer.visible = false
		else:
			%LeftPointer.visible = false
			%RightPointer.visible = true

@export var time: float = 0.0:
	set(value):
		time = value
		%Time.text = Util.get_short_time(time)
