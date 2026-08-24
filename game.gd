class_name Game
extends Node2D

@export var p1: Player
@export var p2: Player

var lock_scene = preload("res://lock/lock.tscn")

var elapsed = 0.0
var stopwatch_running = false

signal game_ended

func start() -> void:
	stopwatch_running = true
	if p1 != null:
		p1.anchor = $PlayerOneAnchor
		p1.lock = $PlayerOneAnchor/Lock
	if p2 != null:
		p2.anchor = $PlayerTwoAnchor
		p2.lock = $PlayerTwoAnchor/Lock
	# TODO: run a countdown
	if p1 != null:
		p1.locks_remaining -= 1
		p1.lock.picked.connect(lock_picked.bind(p1))
		p1.lock.enable(p1)
	if p2 != null:
		p2.locks_remaining -= 1
		p2.lock.picked.connect(lock_picked.bind(p2))
		p2.lock.enable(p2)

func _process(delta: float) -> void:
	if stopwatch_running:
		elapsed += delta
	var minutes = int(elapsed / 60.0)
	var seconds = int(elapsed) % 60
	var tenths = int(elapsed * 10) % 10
	%TimeElapsed.text = "%01d:%02d.%01d" % [minutes, seconds, tenths]

func lock_picked(player: Player) -> void:
	# TODO: update the ui with timestamp
	if player.locks_remaining <= 0:
		trigger_win(player)
		return
	player.locks_remaining -= 1
	var new_lock = lock_scene.instantiate() as Lock
	player.anchor.add_child(new_lock)
	player.lock.queue_free()
	player.lock = new_lock
	player.lock.picked.connect(lock_picked.bind(player))
	# TODO: run a countdown
	player.lock.enable(player)

func trigger_win(player: Player) -> void:
	stopwatch_running = false
	if p1 != null:
		p1.lock.disable()
	if p2 != null:
		p2.lock.disable()
	$GameUI/WinLabel.text = "%s wins!" % player.player_name
	await get_tree().create_timer(3.0).timeout
	game_ended.emit()
