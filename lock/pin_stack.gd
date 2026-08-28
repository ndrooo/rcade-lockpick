class_name PinStack
extends Node2D

@onready var key: Area2D = $KeyPin
@onready var driver: Area2D = $DriverPin
@onready var scraping_sfx = $ScrapingSFX as AudioStreamPlayer2D
@onready var scraping_sfx_stream = scraping_sfx.stream as AudioStreamGenerator

@export var fall_speed = 80
@export var shear_height = 25
@export var scraping_hz = 440.0
@export var scraping_volume = 0.1

@onready var last_height = driver.position.y
var scraping = false
var scraping_audio_phase = 0.0

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
		toggle_scraping(false)
		pin_set_effect()
		set_pin.emit()
	if pin_set and driver.position.y > -shear_height:
		driver.position.y = -shear_height
	if binding and driver.position.y < last_height and not scraping:
		toggle_scraping(true)
	if binding and driver.position.y >= last_height and scraping:
		toggle_scraping(false)
	last_height = driver.position.y

func _process(_delta: float) -> void:
	if scraping_sfx.playing:
		var increment = scraping_hz / scraping_sfx_stream.mix_rate
		var playback = scraping_sfx.get_stream_playback()
		for frame in range(playback.get_frames_available()):
			# var amplitude = sin(scraping_audio_phase * TAU)
			var amplitude = randf_range(-0.5, 0.5) * (sin(scraping_audio_phase * TAU) / 2.0)
			playback.push_frame(Vector2.ONE * amplitude * scraping_volume)
			scraping_audio_phase = fmod(scraping_audio_phase + increment, 1.0)

func bind_pins():
	binding = true

func toggle_scraping(is_scraping):
	scraping = is_scraping
	$ScrapingVFX.visible = is_scraping
	if is_scraping:
		scraping_sfx.play()
	else:
		scraping_sfx.stop()

func pin_set_effect():
	($PinSetSFX as AudioStreamPlayer2D).play(0.25)
	var vfx = $PinSetVFX as AnimatedSprite2D
	vfx.play()

func _on_key_pin_body_entered(body: Node2D) -> void:
	if body is Pick:
		body.touching_pin_stacks[self] = true

func _on_key_pin_body_exited(body: Node2D) -> void:
	if body is Pick:
		body.touching_pin_stacks[self] = false
