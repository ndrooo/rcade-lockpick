class_name Pick
extends CharacterBody2D

@export var y_speed = 24.0
@export var x_speed = 30.0
@export var enabled = true

var up_action = ""
var down_action = ""
var left_action = ""
var right_action = ""

func set_player(player: Player) -> void:
	up_action = player.up_action
	down_action = player.down_action
	left_action = player.left_action
	right_action = player.right_action

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
