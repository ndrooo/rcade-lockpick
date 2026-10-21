class_name Haptic
extends Node

var device_id: int
var lock: Lock

@export var scrape_vibe_light: float = 0.5
@export var scrape_vibe_heavy: float = 0
@export var scrape_vibe_duration: float = 0.2

@export var pin_set_vibe_light: float = 1.0
@export var pin_set_vibe_heavy: float = 1.0
@export var pin_set_vibe_duration: float = 0.1

func _ready() -> void:
	var parent = get_parent()
	lock = parent.get_node("Lock")
	scrape_rumble()
	for pin in lock.pins:
		var pin_stack: PinStack = pin
		pin.set_pin.connect(pin_set_rumble)
		pin.scrape_start.connect(scrape_rumble)
		pin.scrape_end.connect(stop_rumble)

func reconnect(new_lock: Lock) -> void:
	lock = new_lock
	for pin in lock.pins:
		var pin_stack: PinStack = pin
		pin.set_pin.connect(pin_set_rumble)
		pin.scrape_start.connect(scrape_rumble)
		pin.scrape_end.connect(stop_rumble)
	

func test() -> void:
	prints("signal working in haptics")

# TODO Emma doublecheck make sure it will not crash if someone is not playing with a game controller
func set_device_id(_device_id: int) -> void:
	device_id = _device_id
	
func scrape_rumble() -> void:
	Input.start_joy_vibration(device_id, scrape_vibe_light, scrape_vibe_heavy, scrape_vibe_duration)
	prints("start vibration", device_id)

func pin_set_rumble() -> void:
	Input.start_joy_vibration(device_id, pin_set_vibe_light, pin_set_vibe_heavy, pin_set_vibe_duration)
	
func stop_rumble() -> void:
	Input.stop_joy_vibration(device_id)
	prints("stop vibration", device_id)
