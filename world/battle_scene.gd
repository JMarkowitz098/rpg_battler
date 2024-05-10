extends Node2D

var enemies: Array[Node]
var players: Array[Node]

var action_queue := ActionQueue.new()
var is_battling := false
var skill_index := 0

var state: State

enum State { 
	CHOOSING_ENEMY, 
	CHOOSING_ACTION_POS, 
	IS_BATTLING, 
	CHOOSING_ACTION,
	CHOOSING_SKILL
}

@onready var action_list := $CanvasLayer/ActionList
@onready var action_choice := $CanvasLayer/ActionChoice
@onready var enemy_group := $EnemyGroup
@onready var player_group := $PlayerGroup
@onready var info_label := $CanvasLayer/InfoBackground/InfoLabel
@onready var skill_choice = $CanvasLayer/SkillChoice

signal next_player

func _ready() -> void:
	_connect_signals()
	state = State.CHOOSING_ACTION
	_show_action_choice()
	action_queue.queue_enemy_actions(enemy_group.enemies, player_group.players)
	
func _process(_delta: float) -> void:
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
		State.CHOOSING_SKILL:
			_handle_choose_skill_input()
		
	if action_queue.count_player_actions() == players.size():
		await _process_turn()
		_reset_turn()
		
func _connect_signals() -> void:
	for enemy in enemy_group.enemies:
		enemy.stats.no_health.connect(_on_enemy_no_health)
	for player in player_group.players:
		player.stats.no_health.connect(_on_player_no_health)

func _show_action_choice() -> void:
	action_choice.show()
	action_choice.find_child("Attack").grab_focus()
	
func _on_attack_pressed() -> void:
	action_choice.hide()
	_start_choosing_enemy()
	
func _start_choosing_enemy() -> void:
	state = State.CHOOSING_ENEMY
	enemy_group.reset_focus()
	enemies[0].focus.focus()

func _on_defend_pressed() -> void:
	action_queue.queue_player_defend_action(players)
	_process_next_player()
		
func _handle_choose_enemy_input() -> void:
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
	
		
func _start_choosing_action_pos() -> void:
	state = State.CHOOSING_ACTION_POS
	if action_queue.size() > 0:
		action_queue.set_focus(0, true)
	
func _handle_choose_action_input() -> void:
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
	info_label.text = _create_action_message(action)
	
func _create_action_message(action: Action) -> String:
	return "{0} -> {1} -> {2}".format([
		action.actor_stats.label, 
		action.action, 
		action.target_stats.label
	])

func _handle_choose_action_pos() -> void:
	action_queue.queue_player_attack_action(players, enemies)
	_process_next_player()
	enemy_group.reset_focus()
	
func _process_next_player() -> void:
	action_queue.next_player()
	emit_signal("next_player")
	state = State.CHOOSING_ACTION
	_show_action_choice()

func _process_turn() -> void:
	_clear_ui_for_battle()
	state = State.IS_BATTLING
	_reset_groups_and_indexes()
	await get_tree().create_timer(1).timeout
	await action_queue.process_action_queue(get_tree())

func _clear_ui_for_battle() -> void:
	action_choice.hide()
	info_label.text = ""

func _reset_turn() -> void:
	state = State.CHOOSING_ACTION
	player_group.reset_defense()
	players[0].focus.focus()
	action_queue.queue_enemy_actions(enemies, players)
	_show_action_choice()
	
func _reset_groups_and_indexes() -> void:
	player_group.reset_focus()
	enemy_group.reset_focus()
	action_queue.reset_indexes()
	
func _on_enemy_no_health(enemy_id: String) -> void:
	action_queue.remove_action_by_character_id(enemy_id)
	enemy_group.remove_enemy_by_id(enemy_id)
	
func _on_player_no_health(player_id: String) -> void:
	action_queue.remove_action_by_character_id(player_id)
	player_group.remove_player_by_id(player_id)
	
func _fill_skill_list(player):
	for child in skill_choice.get_children():
		child.queue_free()
		
	for skill in player.skills.get_children():
		var button = Button.new()
		button.text = skill.label
		skill_choice.add_child(button)
		
	var button = Button.new()
	button.text = "Back"
	skill_choice.add_child(button)

func _on_skill_pressed():
	_fill_skill_list(players[action_queue.player_index])
	action_choice.hide()
	skill_choice.show()
	print(skill_choice.get_children()[0])
	skill_choice.get_children()[0].grab_focus()
	state = State.CHOOSING_SKILL
	
func _handle_choose_skill_input():
	if Input.is_action_just_pressed("ui_right"):
		skill_index = (skill_index + 1) % action_queue.size()
	if Input.is_action_just_pressed("ui_left"):
		if skill_index == 0:
			skill_index = action_queue.size() - 1
		else:
			skill_index = skill_index - 1
	if Input.is_action_just_pressed("ui_accept"):
		_handle_choose_action_pos()
		return
	
