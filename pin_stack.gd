extends Node2D

@export var binding = false
@export var key_pin_height = 10

func _ready() -> void:
	$KeyPin/NinePatchSprite2D.size.y = key_pin_height
	$KeyPin/Collider.shape.y = key_pin_height + 1

func _process(delta: float) -> void:
	pass
