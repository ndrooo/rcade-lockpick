class_name LapTimer
extends VBoxContainer

func record(lap_time: int):
	var lap_label = Label.new()
	lap_label.text = Util.get_short_time(lap_time)
	add_child(lap_label)
	move_child(lap_label, 0)
