extends Node2D

class_name Lock

const PINS = 5

enum Player {ONE, TWO}

@export var speed = 18.0
@export var player = Player.ONE
@export var cross_section = true

var up_action = ""
var down_action = ""
var left_action = ""
var right_action = ""
var b_action = ""

var active_pin = 0

var flip = false

func _ready() -> void:
	up_action = "p1_up" if player == Player.ONE else "p2_up"
	down_action = "p1_down" if player == Player.ONE else "p2_down"
	left_action = "p1_left" if player == Player.ONE else "p2_left"
	right_action = "p1_right" if player == Player.ONE else "p2_right"
	b_action = "p1_b" if player == Player.ONE else "p2_b"
	flip = scale.x < 0
	$Body.visible = !cross_section


func _process(delta: float) -> void:
	var pick: CharacterBody2D = $Pick
	$Pick.velocity = Vector2.ZERO
	if Input.is_action_pressed(up_action):
		pick.position += Vector2.UP * speed * delta
	if Input.is_action_pressed(down_action):
		pick.position += Vector2.DOWN * speed * delta
	if Input.is_action_just_pressed(left_action):
		set_pin(1 if flip else -1)
	if Input.is_action_just_pressed(right_action):
		set_pin(-1 if flip else 1)
	if Input.is_action_just_pressed(b_action):
		cross_section = !cross_section
		$Body.visible = !cross_section

func set_pin(relative) -> void:
	var next_pin = active_pin + relative
	if next_pin < 0 or next_pin >= PINS:
		return
	active_pin = next_pin
	$Pick.position.x = active_pin * 16
