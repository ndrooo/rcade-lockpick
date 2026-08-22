class_name Lock
extends Node2D

const PINS = 5

@export var cross_section = true

@onready var pins = $Pins.get_children()
@onready var pick: Pick = $Pick

var active_pin = 0
var binding_order: Array[PinStack] = []
var bind_index = 0:
	set(new_index):
		binding_order[bind_index].binding = false
		binding_order[new_index].binding = true
		bind_index = new_index

signal picked

var flip = false

func _ready() -> void:
	flip = scale.x < 0
	$Body.visible = !cross_section
	for pin in $Pins.get_children():
		var pin_stack: PinStack = pin
		pin.pick = pick
		pin_stack.key_pin_height = randi() % 10 + 10
	binding_order.assign($Pins.get_children())
	binding_order.shuffle()
	bind_index = 0
	binding_order[bind_index].set_pin.connect(advance)
	pick.enabled = false

func enable(player: Player):
	pick.enabled = true
	pick.set_player(player)

func disable():
	pick.enabled = false

func advance():
	binding_order[bind_index].set_pin.disconnect(advance)
	if bind_index >= 4:
		$Pick.visible = false
		$Body.visible = true
		disable()
		picked.emit()
	else:
		bind_index += 1
		binding_order[bind_index].bind_pins()
		binding_order[bind_index].set_pin.connect(advance)
