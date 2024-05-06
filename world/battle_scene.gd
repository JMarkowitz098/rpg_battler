extends Node2D

var enemies: Array[Node]
var players: Array[Node]

var action_queue := ActionQueue.new()
var is_battling := false

var state: State

enum State { CHOOSING_ENEMY, CHOOSING_ACTION_POS, IS_BATTLING, CHOOSING_ACTION }

@onready var action_list = $CanvasLayer/ActionList
@onready var action_choice = $CanvasLayer/ActionChoice
@onready var enemy_group = $EnemyGroup
@onready var player_group = $PlayerGroup
@onready var info_label = $CanvasLayer/InfoBackground/InfoLabel

signal next_player

func _ready():
	for enemy in enemy_group.enemies:
		enemy.stats.no_health.connect(_on_enemy_no_health)
		
	state = State.CHOOSING_ACTION
	show_action_choice()
	action_queue.queue_enemy_actions(enemy_group.enemies, player_group.players)
	
func _process(_delta: float):
	players = player_group.players
	enemies = enemy_group.enemies
	action_queue.draw_action_queue(action_list)
	
	match state:
		State.IS_BATTLING:
			return
		State.CHOOSING_ENEMY:
			_handle_choose_enemy_input()
		State.CHOOSING_ACTION:
			pass
		State.CHOOSING_ACTION_POS:
			_handle_choose_action_input()
		
	if action_queue.count_player_actions() == players.size():
		_process_turn()
		
func show_action_choice():
	action_choice.show()
	action_choice.find_child("Attack").grab_focus()
	
func _on_attack_pressed():
	action_choice.hide()
	_start_choosing_enemy()
	
func _start_choosing_enemy():
	state = State.CHOOSING_ENEMY
	enemy_group.reset_focus()
	enemies[0].focus.focus()

func _on_defend_pressed():
	#TODO refactor with choose_action_pos
	action_queue.queue_player_defend_action(players)
	action_queue.next_player()
	emit_signal("next_player")
	state = State.CHOOSING_ACTION
	show_action_choice()
		
func _handle_choose_enemy_input():
	if Input.is_action_just_pressed("ui_left"):
		var new_enemy_index = (action_queue.enemy_index - 1) % enemies.size()
		enemy_group.switch_focus(new_enemy_index, action_queue.enemy_index)
		action_queue.enemy_index = new_enemy_index
			
	if Input.is_action_just_pressed("ui_right"):
		var new_enemy_index = (action_queue.enemy_index + 1) % enemies.size()
		enemy_group.switch_focus(new_enemy_index, action_queue.enemy_index)
		action_queue.enemy_index = new_enemy_index
		
	if Input.is_action_just_pressed("ui_accept"):
		_start_choosing_action_pos()
	
		
func _start_choosing_action_pos():
	state = State.CHOOSING_ACTION_POS
	if action_queue.size() > 0:
		action_queue.set_focus(0, true)
	
func _handle_choose_action_input():
	if action_queue.size() == 0:
		_handle_choose_action_pos()
		return
		
	action_queue.set_focus(action_queue.action_index, false)
	
	if Input.is_action_just_pressed("ui_right"):
		action_queue.action_index = (action_queue.action_index + 1) % action_queue.size()
	if Input.is_action_just_pressed("ui_left"):
		if action_queue.action_index == 0:
			action_queue.action_index = action_queue.size() - 1
		else:
			action_queue.action_index = action_queue.action_index - 1
	if Input.is_action_just_pressed("ui_accept"):
		_handle_choose_action_pos()
		return
	
	var action = action_queue.get_current_action()
	action.is_focused = true
	
	var message = "{0} -> {1} -> {2}".format([
		action.actor_stats.label, 
		action.action, 
		action.target_stats.label
	])
	info_label.text = message + "\n" + str(action_queue.action_index)

func _handle_choose_action_pos():
	action_queue.queue_player_attack_action(players, enemies)
	action_queue.next_player()
	emit_signal("next_player")
	state = State.CHOOSING_ACTION
	show_action_choice()

func _process_turn():
	state = State.IS_BATTLING
	_reset_groups_and_indexes()
	await get_tree().create_timer(1).timeout
	await action_queue.process_action_queue(get_tree())
	player_group.reset_defense()
	
	# For next turn
	show_action_choice()
	players[0].focus.focus()
	action_queue.queue_enemy_actions(enemies, players)
	state = State.CHOOSING_ACTION
	
func _reset_groups_and_indexes():
	player_group.reset_focus()
	enemy_group.reset_focus()
	action_queue.reset_indexes()
	
func _on_enemy_no_health(enemy_id):
	action_queue.queue = action_queue.queue.filter(
		func(action): 
			return action.actor_stats.id != enemy_id and action.target_stats.id != enemy_id)
	
	
