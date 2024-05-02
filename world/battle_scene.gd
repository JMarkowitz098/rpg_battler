extends Node2D

var enemies: Array[Node]
var players: Array[Node]

var action_queue: Array[Dictionary] = []
var is_battling: bool = false
var enemy_index: int = 0
var player_index: int = 0
var action_index: int = 0

var state: State

enum State { CHOOSING_ENEMY, CHOOSING_ACTION_POS, IS_BATTLING, CHOOSING_ACTION }

const ActionListItemScene = preload("res://action_list_item.tscn")

@onready var action_list = $CanvasLayer/ActionList
@onready var action_choice = $CanvasLayer/ActionChoice
@onready var enemy_group = $EnemyGroup
@onready var player_group = $PlayerGroup
@onready var info_label = $CanvasLayer/InfoBackground/InfoLabel

signal next_player

func _ready():
	state = State.CHOOSING_ACTION
	show_action_choice()
	
func _process(_delta: float):
	players = player_group.players
	enemies = enemy_group.enemies
	_draw_action_queue()
	
	match state:
		State.IS_BATTLING:
			return
		State.CHOOSING_ENEMY:
			_handle_choose_enemy_input()
		State.CHOOSING_ACTION:
			pass
		State.CHOOSING_ACTION_POS:
			_handle_choose_action_input()
		
	if _count_player_actions() == players.size():
		_process_turn()
		
func _process_action_queue(stack: Array[Dictionary]):
	for action in stack:
		match action.action:
			"player_action":
				enemies[action.enemy_index].stats.take_damage(1)
			"enemy_action":
				players[action.player_index].stats.take_damage(1)
		await get_tree().create_timer(2).timeout
	action_queue.clear()
	state = State.CHOOSING_ENEMY
		
func show_action_choice():
	action_choice.show()
	action_choice.find_child("Attack").grab_focus()

func _start_choosing_enemy():
	state = State.CHOOSING_ENEMY
	enemy_group.reset_focus()
	enemies[0].focus.focus()
	_queue_enemy_actions()

func _on_attack_pressed():
	action_choice.hide()
	_start_choosing_enemy()

func _draw_action_queue():
	for child in action_list.get_children():
		child.queue_free()
		
	for action in action_queue:
		var message: String
		match action.action:
			"player_action":
				#message = action.player_label + "-> Atk " + action.enemy_label
				message = "O"
			"enemy_action":
				#message = action.enemy_label + "-> Atk " + action.player_label
				message = "X"
				
		var list_item = ActionListItemScene.instantiate()
		list_item.get_node("Label").text = message
		if(action.is_focused): list_item.get_node("Focus").focus()
		action_list.add_child(list_item)
		
func _handle_choose_enemy_input():
	if Input.is_action_just_pressed("ui_right"):
		var new_enemy_index = (enemy_index - 1) % enemies.size()
		enemy_group.switch_focus(new_enemy_index, enemy_index)
		enemy_index = new_enemy_index
			
	if Input.is_action_just_pressed("ui_left"):
		var new_enemy_index = (enemy_index + 1) % enemies.size()
		enemy_group.switch_focus(new_enemy_index, enemy_index)
		enemy_index = new_enemy_index
		
	if Input.is_action_just_pressed("ui_accept"):
		_start_choosing_action_pos()
	
		
func _start_choosing_action_pos():
	state = State.CHOOSING_ACTION_POS
	action_queue[0].is_focused = true
	
func _handle_choose_action_input():
	action_queue[action_index].is_focused = false
	
	if Input.is_action_just_pressed("ui_right"):
		action_index = (action_index + 1) % action_queue.size()
	if Input.is_action_just_pressed("ui_left"):
		action_index = (action_index - 1) % action_queue.size()
	if Input.is_action_just_pressed("ui_accept"):
		var action = _create_action(enemy_index, player_index, "player_action")
		action_queue.insert(action_index, action)
		player_index += 1
		emit_signal("next_player")
		action_index = 0
		state = State.CHOOSING_ENEMY
		return
		
	#action_queue[action_index].is_focused = true
	
	var action = action_queue[action_index]
	action.is_focused = true
	
	var message: String
	match action.action:
		"player_action":
			message = action.player_label + "-> Atk " + action.enemy_label
		"enemy_action":
			message = action.enemy_label + "-> Atk " + action.player_label
	info_label.text = message + "\n" + str(action_index)
	
		
func _create_action(
	enemy_i: int, 
	player_i: int, 
	action: String
) -> Dictionary:
	return {
		"enemy_index": enemy_i,
		"enemy_label": enemies[enemy_i].stats.label,
		"enemy_id": enemies[enemy_i].stats.id,
		"player_index": player_i,
		"player_label": players[player_i].stats.label,
		"player_id": players[player_i].stats.id,
		"action": action,
		"is_focused": false
	}
		
func _process_turn():
	state = State.IS_BATTLING
	_reset_groups_and_indexes()
	await get_tree().create_timer(1).timeout
	await _process_action_queue(action_queue)
	show_action_choice()
	players[0].focus.focus()
	state = State.CHOOSING_ACTION
	
func _reset_groups_and_indexes():
	player_group.reset_focus()
	enemy_group.reset_focus()
	enemy_index = 0
	player_index = 0

func _queue_enemy_actions():
	for i in enemies.size():
		var rand_player_i = randi() % players.size()
		var enemy_action = _create_action(i, rand_player_i, "enemy_action")
		action_queue.push_back(enemy_action)
		
func _count_player_actions() -> int:
	return action_queue.filter(
		func(action): return action.action == "player_action").size()

