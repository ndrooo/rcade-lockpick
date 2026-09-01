class_name Pick
extends CharacterBody2D

@export var free_speed = 28.0
@export var pin_speed = 24.0
@export var binding_speed = 14.0
@export var x_speed = 30.0
@export var enabled = true
@export var player: Player:
	set(new_player):
		player = new_player
		up_action = player.up_action
		down_action = player.down_action
		left_action = player.left_action
		right_action = player.right_action
@export var animation_move_step = 10.0
@export var animation_move_offset = 40.0

@onready var sprite = $AnimatedSprite2D
@onready var y_origin = position.y

var up_action = ""
var down_action = ""
var left_action = ""
var right_action = ""

var touching_pin_stacks: Dictionary[PinStack, bool] = {}

func _physics_process(_delta: float) -> void:
	if not enabled:
		return
	velocity = Vector2.ZERO
	var y_speed = free_speed
	for stack in touching_pin_stacks:
		if not touching_pin_stacks[stack]:
			continue
		y_speed = pin_speed
		if stack.binding:
			y_speed = binding_speed
			break
	if Input.is_action_pressed(up_action):
		velocity += Vector2.UP * y_speed
	if Input.is_action_pressed(down_action):
		velocity += Vector2.DOWN * free_speed
	if Input.is_action_pressed(left_action):
		velocity += Vector2.LEFT * x_speed
	if Input.is_action_pressed(right_action):
		velocity += Vector2.RIGHT * x_speed
	move_and_slide()

func _process(_delta: float) -> void:
	if (position.y - y_origin + animation_move_offset) > animation_move_step * 3:
		sprite.frame = 3
	elif (position.y - y_origin + animation_move_offset) > animation_move_step * 2:
		sprite.frame = 2
	elif (position.y - y_origin + animation_move_offset) > animation_move_step:
		sprite.frame = 1
	else:
		sprite.frame = 0
