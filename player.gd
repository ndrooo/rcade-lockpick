class_name Player
extends Resource

@export var player_name = ""

var anchor: Node2D
var lock: Lock
@export var locks_remaining: int = 3

@export var action_prefix = ""
var up_action:
	get:
		return "%s_up" % action_prefix
var down_action:
	get:
		return "%s_down" % action_prefix
var left_action:
	get:
		return "%s_left" % action_prefix
var right_action:
	get:
		return "%s_right" % action_prefix
