extends Node2D

class_name PinStack

@onready var key: Area2D = $KeyPin
@onready var driver: Area2D = $DriverPin

@export var fall_speed = 80
@export var shear_height = 25

var binding = false
var pin_set = false
signal set_pin

@export var key_pin_height = 10:
	set(new_height):
		key_pin_height = new_height
		$KeyPin/NinePatchSprite2D.size.y = key_pin_height
		$KeyPin/Collider.shape.size.y = key_pin_height + 1
		$KeyPin/Collider.position.y = -key_pin_height / 2.0
		$KeyPin/NinePatchSprite2D.position.y = -key_pin_height
		$DriverPin.position.y = -key_pin_height

@export var pick: CharacterBody2D = null

func _physics_process(delta: float) -> void:
	if key.overlaps_body(pick):
		key.global_position.y = pick.global_position.y
	else:
		key.position.y += fall_speed * delta
	if key.position.y > 0:
		key.position.y = 0
	driver.position.y = key.position.y - key_pin_height
	if binding and not pin_set and driver.position.y < -shear_height:
		binding = false
		pin_set = true
		set_pin.emit()
	if pin_set and driver.position.y > -shear_height:
		driver.position.y = -shear_height

func bind_pins():
	binding = true
