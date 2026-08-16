extends Node2D

class_name PinStack

@export var binding = false
@export var key_pin_height = 10:
	set(new_height):
		key_pin_height = new_height
		$KeyPin/NinePatchSprite2D.size.y = key_pin_height
		$KeyPin/Collider.shape.size.y = key_pin_height + 1
		$KeyPin/Collider.position.y = key_pin_height / 2.0
