extends Node2D

var enemies: Array[Node]
var players: Array[Node]

var action_queue := ActionQueue.new()
var is_battling := false
var skill_index := 0

var current_action_type: Action.Type
var current_skill: Skill
var state: State

enum State { 
	CHOOSING_ENEMY, 
	CHOOSING_ACTION_POS, 
	IS_BATTLING, 
	CHOOSING_ACTION,
	CHOOSING_SKILL
}

@onready var action_list := $CanvasLayer/ActionList
@onready var action_type := $CanvasLayer/ActionType
@onready var enemy_group := $EnemyGroup
@onready var player_group := $PlayerGroup
@onready var info_label := $CanvasLayer/InfoBackground/InfoLabel
@onready var skill_choice_list = $CanvasLayer/SkillChoiceList

signal next_player

func _ready() -> void:
	_connect_signals()
	state = State.CHOOSING_ACTION
	_show_action_type()
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
			_handle_choose_action_pos_input()
		State.CHOOSING_SKILL:
			_handle_choose_skill_input()
			pass
		
	if action_queue.count_player_actions() == players.size():
		await _process_turn()
		_reset_turn()
		
func _connect_signals() -> void:
	for enemy in enemy_group.enemies:
		enemy.stats.no_health.connect(_on_enemy_no_health)
	for player in player_group.players:
		player.stats.no_health.connect(_on_player_no_health)

func _show_action_type() -> void:
	action_type.show()
	action_type.find_child("Attack").grab_focus()

# ----------------
# Attack Functions
# ----------------
	
func _on_attack_pressed() -> void:
	current_action_type = Action.Type.ATTACK
	action_type.hide()
	_start_choosing_enemy()
	
# -----------------
# Defense Functions
# -----------------

func _on_defend_pressed() -> void:
	action_queue.queue_player_defend_action(players)
	_process_next_player()
	
# ---------------
# Skill Functions
# ---------------

func _on_skill_pressed():
	# Possibly move to on next player setup
	Skill.fill_skill_choice_list(
		players[action_queue.player_index], 
		skill_choice_list
	)
	_connect_skill_button_signals()
	action_type.hide()
	skill_choice_list.show()
	skill_choice_list.get_children()[0].grab_focus()
	state = State.CHOOSING_SKILL

func _connect_skill_button_signals():
	var skills = players[action_queue.player_index].get_skills()
	var skill_buttons := skill_choice_list.get_children()
	for i in skill_buttons.size():
		var skill = skills[i]
		var skill_button = skill_buttons[i]
		skill_button.pressed.connect(_handle_choose_skill.bind(skill))
	
func _handle_choose_skill(skill):
	current_action_type = Action.Type.SKILL
	current_skill = skill
	#TODO: Can probably get the focused child directly from signal
	for child in skill_choice_list.get_children():
		child.release_focus()
	_start_choosing_enemy()
	
func _handle_choose_skill_input():
	if Input.is_action_just_pressed("menu_left"):
		pass
			
	if Input.is_action_just_pressed("menu_right"):
		pass
		
	if Input.is_action_just_pressed("menu_accept"):
		pass
		
	if Input.is_action_just_pressed("menu_back"):
		_return_to_action_choice()
		skill_choice_list.hide()
		
func _return_to_choose_skill():
	enemy_group.reset_focus()
	action_queue.enemy_index = 0
	skill_choice_list.get_children()[0].grab_focus()
	state = State.CHOOSING_SKILL
	
# ------------------------
# Choosing Enemy Functions
# ------------------------
	
func _start_choosing_enemy() -> void:
	state = State.CHOOSING_ENEMY
	enemy_group.reset_focus()
	enemies[0].focus.focus()
		
func _handle_choose_enemy_input() -> void:
	if Input.is_action_just_pressed("menu_left"):
		var new_enemy_index = (action_queue.enemy_index - 1) % enemies.size()
		enemy_group.switch_focus(new_enemy_index, action_queue.enemy_index)
		action_queue.enemy_index = new_enemy_index
			
	if Input.is_action_just_pressed("menu_right"):
		var new_enemy_index = (action_queue.enemy_index + 1) % enemies.size()
		enemy_group.switch_focus(new_enemy_index, action_queue.enemy_index)
		action_queue.enemy_index = new_enemy_index
		
	if Input.is_action_just_pressed("menu_accept"):
		_start_choosing_action_pos()
		
	if Input.is_action_just_pressed("menu_back"):
		if current_action_type == Action.Type.SKILL:
			_return_to_choose_skill()
		else:
			_return_to_action_choice()
			
func _return_to_enemy_choice():
	_start_choosing_enemy()
	action_queue.action_index = 0
		
# -----------------------------
# Choosing Action Pos Functions
# -----------------------------
	
func _start_choosing_action_pos() -> void:
	state = State.CHOOSING_ACTION_POS
	if action_queue.size() > 0:
		action_queue.set_focus(0, true)
	
func _handle_choose_action_pos_input() -> void:
	if action_queue.size() == 0:
		_handle_choose_action_pos()
		return
		
	action_queue.set_focus(action_queue.action_index, false)
	
	if Input.is_action_just_pressed("menu_right"):
		action_queue.action_index = (action_queue.action_index + 1) % action_queue.size()
		
	if Input.is_action_just_pressed("menu_left"):
		if action_queue.action_index == 0:
			action_queue.action_index = action_queue.size() - 1
		else:
			action_queue.action_index = action_queue.action_index - 1
			
	if Input.is_action_just_pressed("menu_accept"):
		_handle_choose_action_pos()
		return
	
	if Input.is_action_just_pressed("menu_back"):
		_return_to_enemy_choice()
		return
	
	var action = action_queue.get_current_action()
	action.is_focused = true
	info_label.text = action_queue.create_action_message(action)

func _handle_choose_action_pos() -> void:
	match current_action_type:
		Action.Type.ATTACK:
			action_queue.queue_player_attack_action(players, enemies)
		Action.Type.SKILL:
			skill_choice_list.hide()
			action_queue.queue_player_skill_action(players, enemies, current_skill)
			
	_process_next_player()
	enemy_group.reset_focus()
	current_action_type = Action.Type.NONE
	
# ----------------------
# Process Turn Functions
# ----------------------
	
func _process_turn() -> void:
	_clear_ui_for_battle()
	state = State.IS_BATTLING
	_reset_groups_and_indexes()
	await get_tree().create_timer(1).timeout
	await action_queue.process_action_queue(get_tree())

func _process_next_player() -> void:
	action_queue.next_player()
	emit_signal("next_player")
	state = State.CHOOSING_ACTION
	_show_action_type()

func _clear_ui_for_battle() -> void:
	action_type.hide()
	info_label.text = ""

func _reset_turn() -> void:
	state = State.CHOOSING_ACTION
	player_group.reset_defense()
	players[0].focus.focus()
	action_queue.queue_enemy_actions(enemies, players)
	_show_action_type()
	
func _reset_groups_and_indexes() -> void:
	player_group.reset_focus()
	enemy_group.reset_focus()
	action_queue.reset_indexes()
	
func _return_to_action_choice() -> void:
	state = State.CHOOSING_ACTION
	_show_action_type()
	enemy_group.reset_focus()
	action_queue.enemy_index = 0
	current_action_type = Action.Type.NONE
	
# ----------------------
# Signals
# ----------------------
	
func _on_enemy_no_health(enemy_id: String) -> void:
	action_queue.remove_action_by_character_id(enemy_id)
	enemy_group.remove_enemy_by_id(enemy_id)
	
func _on_player_no_health(player_id: String) -> void:
	action_queue.remove_action_by_character_id(player_id)
	player_group.remove_player_by_id(player_id)


	
	
