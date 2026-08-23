extends Node2D

@export var p1: Player
@export var p2: Player

var lock_scene = preload("res://lock/lock.tscn")

var elapsed = 0.0
var stopwatch_running = true

func _ready() -> void:
	p1.anchor = $PlayerOneAnchor
	p2.anchor = $PlayerTwoAnchor
	p1.lock = $PlayerOneAnchor/Lock
	p2.lock = $PlayerTwoAnchor/Lock
	p1.locks_remaining -= 1
	p2.locks_remaining -= 1
	# TODO: run a countdown
	p1.lock.enable(p1)
	p1.lock.picked.connect(lock_picked.bind(p1))
	p2.lock.enable(p2)
	p2.lock.picked.connect(lock_picked.bind(p2))

func _process(delta: float) -> void:
	if stopwatch_running:
		elapsed += delta
		$GameUI/TimeElapsed.text = "%0.2f" % elapsed

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
	p1.lock.disable()
	p2.lock.disable()
	$GameUI/WinLabel.text = "%s wins!" % player.player_name
