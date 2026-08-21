extends Node2D

class_name PinStack

@onready var key: Area2D = $KeyPin
@onready var driver: Area2D = $DriverPin

@export var fall_speed = 10

@export var binding = false
@export var pin_set = false:
	set(is_set):
		# driver.freeze = is_set
		pin_set = is_set

@export var key_pin_height = 10:
	set(new_height):
		key_pin_height = new_height
		$KeyPin/NinePatchSprite2D.size.y = key_pin_height
		$KeyPin/Collider.shape.size.y = key_pin_height + 1
		$KeyPin/Collider.position.y = key_pin_height / 2.0
		$KeyPin.position.y = -key_pin_height - 1
		$DriverPin.position.y = -key_pin_height - 15

@export var pick: CharacterBody2D = null

func _physics_process(_delta: float) -> void:
	if key.overlaps_body(pick):
		key.global_position.y = pick.global_position.y
	else:
		key.position.y += fall_speed
		if key.position.y > 0:
			key.position.y = 0
