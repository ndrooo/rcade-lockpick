extends Node2D

class_name Lock

const PINS = 5

enum Player {ONE, TWO}

@export var normal_speed = 18.0
@export var fast_speed = 120.0
@export var player = Player.ONE
@export var cross_section = true

var up_action = ""
var down_action = ""
var left_action = ""
var right_action = ""
var a_action = ""
var b_action = ""

@onready var shear_area: Area2D = $ShearArea

var active_pin = 0
var binding_order = []
var bind_index = 0:
	set(new_index):
		binding_order[bind_index].binding = false
		binding_order[new_index].binding = true
		bind_index = new_index
var win_state = false

var flip = false

func _ready() -> void:
	up_action = "p1_up" if player == Player.ONE else "p2_up"
	down_action = "p1_down" if player == Player.ONE else "p2_down"
	left_action = "p1_left" if player == Player.ONE else "p2_left"
	right_action = "p1_right" if player == Player.ONE else "p2_right"
	a_action = "p1_a" if player == Player.ONE else "p2_a"
	b_action = "p1_b" if player == Player.ONE else "p2_b"
	flip = scale.x < 0
	$Body.visible = !cross_section
	for pin in $Pins.get_children():
		var pin_stack: PinStack = pin
		pin_stack.key_pin_height = randi() % 10 + 10
	binding_order = $Pins.get_children()
	binding_order.shuffle()
	bind_index = 0


func _process(delta: float) -> void:
	if win_state:
		return
	var pick: CharacterBody2D = $Pick
	$Pick.velocity = Vector2.ZERO
	var speed = fast_speed if Input.is_action_pressed(a_action) else normal_speed
	if Input.is_action_pressed(up_action):
		pick.position += Vector2.UP * speed * delta
	if Input.is_action_pressed(down_action):
		pick.position += Vector2.DOWN * speed * delta
	if Input.is_action_just_pressed(left_action):
		set_pin(1 if flip else -1)
	if Input.is_action_just_pressed(right_action):
		set_pin(-1 if flip else 1)
	if not shear_area.overlaps_body(binding_order[bind_index].driver):
		advance()

func advance():
	binding_order[bind_index].pin_set = true
	if bind_index >= 4:
		$Pick.visible = false
		$Body.visible = true
		win_state = true
	else:
		bind_index += 1

func set_pin(relative) -> void:
	var next_pin = active_pin + relative
	if next_pin < 0 or next_pin >= PINS:
		return
	active_pin = next_pin
	$Pick.position.x = active_pin * 16
