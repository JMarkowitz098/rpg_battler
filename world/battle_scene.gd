extends Node2D

var action_queue: Array[Dictionary] = []
var is_battling: bool = false
var enemy_index: int = 0
var player_index: int = 0

@onready var choice = $CanvasLayer/choice
@onready var enemy_group = $EnemyGroup
@onready var item_list = $CanvasLayer/ItemList
@onready var player_group = $PlayerGroup
@onready var action_focus = $CanvasLayer/ActionFocus

var enemies: Array[Node]
var players: Array[Node]

signal next_player

func _ready():
	show_choice()
	
func _process(_delta: float):
	players = player_group.players
	enemies = enemy_group.enemies
	_draw_action_queue()
	
	if is_battling: return
	
	if not choice.visible:
		_handle_input()
		
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
	is_battling = false
	
		
func show_choice():
	choice.show()
	choice.find_child("Attack").grab_focus()

func _start_choosing():
	enemy_group.reset_focus()
	enemies[0].focus.focus()
	_queue_enemy_actions()

func _on_attack_pressed():
	choice.hide()
	_start_choosing()

func _draw_action_queue():
	item_list.clear()
		
	for action in action_queue:
		var message: String
		match action.action:
			"player_action":
				message = action.player_label + "-> Atk " + action.enemy_label
			"enemy_action":
				message = action.enemy_label + "-> Atk " + action.player_label
				
		item_list.add_item(message)
		
func _handle_input():
	if Input.is_action_just_pressed("ui_up"):
			if enemy_index == 0:
				enemy_index = enemies.size() - 1
				enemy_group.switch_focus(enemy_index, 0)
			else:
				enemy_index -= 1
				enemy_group.switch_focus(enemy_index, enemy_index + 1)
			
	if Input.is_action_just_pressed("ui_down"):
		if enemy_index == enemies.size() - 1:
			enemy_index = 0
			enemy_group.switch_focus(enemy_index, enemies.size() - 1)
		else:
			enemy_index += 1
			enemy_group.switch_focus(enemy_index, enemy_index - 1)
		
	if Input.is_action_just_pressed("ui_accept"):
		action_focus.focus()
		var action = _create_action(enemy_index, player_index, "player_action")
		action_queue.push_back(action)
		player_index += 1
		emit_signal("next_player")
		
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
		"action": action
	}
		
func _process_turn():
	is_battling = true
	_reset_groups_and_indexes()
	await get_tree().create_timer(1).timeout
	await _process_action_queue(action_queue)
	show_choice()
	players[0].focus.focus()
	
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

