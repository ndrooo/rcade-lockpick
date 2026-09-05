class_name Util
extends Object

static func get_long_time(timestamp: float) -> String:
	var minutes = int(timestamp / 60.0)
	var seconds = int(timestamp) % 60
	var tenths = int(timestamp * 10) % 10
	return "%01d:%02d.%01d" % [minutes, seconds, tenths]

static func get_short_time(timestamp: float) -> String:
	var minutes = int(timestamp / 60.0)
	var seconds = int(timestamp) % 60
	return "%01d:%02d" % [minutes, seconds]
