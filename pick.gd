extends CharacterBody2D

class_name Pick

@export var y_speed = 24.0
@export var x_speed = 30.0
@export var enabled = true

var up_action = ""
var down_action = ""
var left_action = ""
var right_action = ""

func set_player(player: Types.Player) -> void:
	up_action = "p1_up" if player == Types.Player.ONE else "p2_up"
	down_action = "p1_down" if player == Types.Player.ONE else "p2_down"
	left_action = "p1_left" if player == Types.Player.ONE else "p2_left"
	right_action = "p1_right" if player == Types.Player.ONE else "p2_right"

func _physics_process(_delta: float) -> void:
	if not enabled:
		return
	velocity = Vector2.ZERO
	if Input.is_action_pressed(up_action):
		velocity += Vector2.UP * y_speed
	if Input.is_action_pressed(down_action):
		velocity += Vector2.DOWN * y_speed
	if Input.is_action_pressed(left_action):
		velocity += Vector2.LEFT * x_speed
	if Input.is_action_pressed(right_action):
		velocity += Vector2.RIGHT * x_speed
	move_and_slide()
