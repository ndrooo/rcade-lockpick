class_name Game
extends Node2D

@export var p1: Player
@export var p2: Player

var lock_scene = preload("res://lock/lock.tscn")
var lap_timer_scene = preload("res://ui/lap_timer.tscn")

var elapsed = 0.0
var stopwatch_running = false

signal game_ended

func start() -> void:
	stopwatch_running = true
	if p1 != null:
		p1.anchor = $PlayerOneAnchor
		p1.lock = $PlayerOneAnchor/Lock
		p1.side = LapTimer.Side.LEFT
	if p2 != null:
		p2.anchor = $PlayerTwoAnchor
		p2.lock = $PlayerTwoAnchor/Lock
		p2.side = LapTimer.Side.RIGHT
	# TODO: run a countdown
	if p1 != null:
		p1.locks_remaining = p1.locks_to_pick - 1
		p1.lock.picked.connect(lock_picked.bind(p1))
		p1.lock.enable(p1)
	if p2 != null:
		p2.locks_remaining = p2.locks_to_pick - 1
		p2.lock.picked.connect(lock_picked.bind(p2))
		p2.lock.enable(p2)

func _process(delta: float) -> void:
	if stopwatch_running:
		elapsed += delta
	%TimeElapsed.text = Util.get_long_time(elapsed)

func lock_picked(player: Player) -> void:
	var lap_timer = lap_timer_scene.instantiate() as LapTimer
	lap_timer.side = player.side
	lap_timer.time = elapsed
	%LapTimes.add_child(lap_timer)

	if player.locks_remaining <= 0:
		trigger_win(player)
		return
	player.locks_remaining -= 1
	var new_lock = lock_scene.instantiate() as Lock
	player.anchor.add_child(new_lock)
	player.lock.queue_free()
	player.lock = new_lock
	player.lock.picked.connect(lock_picked.bind(player))
	player.lock.enable(player)

func trigger_win(player: Player) -> void:
	stopwatch_running = false
	if p1 != null:
		p1.lock.disable()
	if p2 != null:
		p2.lock.disable()
	%WinLabel.text = "%s wins!" % player.player_name
	%WinUI.visible = true
	await get_tree().create_timer(3.0).timeout
	%WinUI.visible = false
	game_ended.emit()
