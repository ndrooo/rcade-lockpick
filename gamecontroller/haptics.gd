class_name Haptic
extends Node

var lock: Lock
var device_id: int

@export var scrape_vibe_light: float = 0.5
@export var scrape_vibe_heavy: float = 0
@export var scrape_vibe_duration: float = 0.2

@export var pin_set_vibe_light: float = 1.0
@export var pin_set_vibe_heavy: float = 0.3
@export var pin_set_vibe_duration: float = 0.2

func _ready() -> void:
	var parent = get_parent()
	lock = parent.get_node("Lock")
	scrape_rumble()

func test() -> void:
	prints("signal working in haptics")

func set_device_id(_device_id: int) -> void:
	device_id = _device_id
	
func scrape_rumble() -> void:
	Input.start_joy_vibration(device_id, scrape_vibe_light, scrape_vibe_heavy, scrape_vibe_duration)

func pin_set_rumble() -> void:
	Input.start_joy_vibration(device_id, pin_set_vibe_light, pin_set_vibe_heavy, pin_set_vibe_duration)
