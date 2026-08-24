extends Control

@onready var p1_join_label = %JoinLabel1
@onready var p2_join_label = %JoinLabel2
@onready var p1_ready_box = %ReadyBox1
@onready var p2_ready_box = %ReadyBox2
@onready var p1_ready_button = %ReadyButton1
@onready var p2_ready_button = %ReadyButton2
@onready var p1_ready_label = %ReadyLabel1
@onready var p2_ready_label = %ReadyLabel2

var game = preload("res://game.tscn")
var player_one = preload("res://player_one.tres")
var player_two = preload("res://player_two.tres")

var enabled = true

var a_button = preload("res://ui/a_button.tres")
var b_button = preload("res://ui/b_button.tres")

var msg_join = ": Join"
var msg_leave = ": Leave"
var msg_ready = ": Ready"
var msg_unready = ": Unready"
var msg_start = ": Start"

var p1_joined = false:
	set (new_joined):
		p1_joined = new_joined
		if not new_joined:
			p1_ready = false
			p2_ready = false
		update_gui()
var p2_joined = false:
	set (new_joined):
		p2_joined = new_joined
		if not new_joined:
			p1_ready = false
			p2_ready = false
		update_gui()
var p1_ready = false:
	set (new_ready):
		p1_ready = new_ready
		update_gui()
		if p1_ready:
			maybe_start()
var p2_ready = false:
	set (new_ready):
		p2_ready = new_ready
		update_gui()
		if p2_ready:
			maybe_start()

func _process(_delta: float) -> void:
	if not enabled:
		return
	if Input.is_action_just_pressed("one_player"):
		p1_joined = not p1_joined
	if Input.is_action_just_pressed("two_player"):
		p2_joined = not p2_joined
	if Input.is_action_just_pressed("p1_a") and p1_joined and not p1_ready:
		p1_ready = true
	if Input.is_action_just_pressed("p1_b") and p1_joined and p1_ready:
		p1_ready = false
	if Input.is_action_just_pressed("p2_a") and p2_joined and not p2_ready:
		p2_ready = true
	if Input.is_action_just_pressed("p2_b") and p2_joined and p2_ready:
		p2_ready = false

func reset():
	p1_joined = false
	p2_joined = false

func update_gui():
	p1_ready_box.visible = p1_joined
	p1_join_label.text = msg_leave if p1_joined else msg_join
	p2_ready_box.visible = p2_joined
	p2_join_label.text = msg_leave if p2_joined else msg_join
	p1_ready_button.texture = a_button
	p2_ready_button.texture = a_button
	if p1_joined and not p2_joined:
		p1_ready_label.text = msg_start
		return
	if p2_joined and not p1_joined:
		p2_ready_label.text = msg_start
		return
	# both joined
	if not p1_ready and not p2_ready:
		p1_ready_label.text = msg_ready
		p2_ready_label.text = msg_ready
	if p1_ready and not p2_ready:
		p1_ready_label.text = msg_unready
		p1_ready_button.texture = b_button
		p2_ready_label.text = msg_start
	if p2_ready and not p1_ready:
		p1_ready_label.text = msg_start
		p2_ready_label.text = msg_unready
		p2_ready_button.texture = b_button

func maybe_start():
	if p1_joined and p1_ready and not p2_joined:
		start_game()
		return
	if p2_joined and p2_ready and not p1_joined:
		start_game()
		return
	if p1_ready and p2_ready:
		start_game()
		return

func start_game():
	var new_game: Game = game.instantiate()
	get_tree().root.add_child(new_game)
	if not p1_joined:
		new_game.p1 = null
	if not p2_joined:
		new_game.p2 = null
	enabled = false
	visible = false
	new_game.start()
	reset()
	await new_game.game_ended
	new_game.queue_free()
	enabled = true
	visible = true
