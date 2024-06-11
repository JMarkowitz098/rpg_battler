extends Node2D

var enemies: Array[Node2D]
var players: Array[Node2D]
var defeated: Array[String]

var action_queue := ActionQueue.new()
var skill_index := 0

var current_action := "Incursion"
var current_skill: Skill
var current_skill_button: HBoxContainer
var current_skill_type: Skill.Type
var state: State
var prev_state: State

enum State { 
	CHOOSING_ENEMY, 
	CHOOSING_ACTION_POS, 
	IS_BATTLING, 
	CHOOSING_ACTION,
	CHOOSING_SKILL,
	GAME_OVER,
	VICTORY
}

@onready var action_list := $CanvasLayer/ActionList
@onready var action_type := $CanvasLayer/ActionType
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var enemy_group := $EnemyGroup
@onready var info_label := $CanvasLayer/InfoBackground/InfoLabel
@onready var player_group := $PlayerGroup
@onready var skill_choice_list = $CanvasLayer/SkillChoiceList
@onready var skill_ui = SkillMenuUi.new(skill_choice_list)
@onready var enemy_group_location = $EnemyGroupLocation
@onready var help_menu = $CanvasLayer/HelpMenu


signal next_player

func _ready() -> void:
	audio_stream_player_2d.play()
	_load_enemy_group()
	_connect_signals()
	state = State.CHOOSING_ACTION
	_show_action_type()
	action_queue.queue_initial_turn_actions(player_group.players, enemy_group.enemies)
	
func _process(_delta: float) -> void:
	players = player_group.players
	enemies = enemy_group.enemies
	
	if state != State.IS_BATTLING:
		action_queue.draw_action_queue(action_list)
	
	match state:
		State.IS_BATTLING:
			return
		State.CHOOSING_ENEMY:
			_handle_choose_enemy_input()
		State.CHOOSING_ACTION:
			_handle_choosing_action()
		State.CHOOSING_ACTION_POS:
			_handle_choose_action_pos_input()
		State.CHOOSING_SKILL:
			_handle_choose_skill_input()
		
	if action_queue.is_turn_over():
		await _process_turn()
		if _is_game_over():
			get_tree().change_scene_to_file("res://menus/start_menu.tscn")
			#get_tree().change_scene_to_file("res://world/battle_scene.tscn")
		elif _is_victory():
			if Utils.round_number == Utils.FINAL_ROUND:
				get_tree().change_scene_to_file("res://menus/start_menu.tscn")
			else:
				#get_tree().change_scene_to_file("res://menus/victory_screen.tscn")
				Utils.round_number += 1
				Utils.change_scene("res://menus/victory_screen.tscn", { "defeated": defeated })
		else:
			_reset_turn()
			
func _load_enemy_group() -> void:
	var old_enemy_group = enemy_group
	match Utils.round_number:
		0:
			return
		1:
			enemy_group = load("res://characters/enemy_group_round_two.tscn").instantiate()
			enemy_group.global_position = enemy_group_location.global_position
			add_child(enemy_group)
	old_enemy_group.queue_free()
		
func _connect_signals() -> void:
	for enemy in enemy_group.enemies:
		enemy.stats.no_ingress_energy.connect(_on_enemy_no_ingress_energy)
	for player in player_group.players:
		player.stats.no_ingress_energy.connect(_on_player_no_ingress_energy)

func _show_action_type() -> void:
	action_type.show()
	action_type.find_child(current_action).grab_focus()

# -------------------
# Action Buttons
# -------------------
	
func _on_incursion_pressed():
	skill_ui.set_current_skills(players[action_queue.player_index], Skill.Type.INCURSION)
	skill_ui.prepare_skill_menu(_handle_choose_skill, action_type)
	state = State.CHOOSING_SKILL
	current_skill_type = Skill.Type.INCURSION

func _on_refrain_pressed():
	skill_ui.set_current_skills(players[action_queue.player_index], Skill.Type.REFRAIN)
	skill_ui.prepare_skill_menu(_handle_choose_skill, action_type)
	state = State.CHOOSING_SKILL
	current_skill_type = Skill.Type.REFRAIN
	
func _on_dodge_pressed():
	players[action_queue.player_index].stats.is_dodging = true
	_handle_choose_skill(Skill.create_dodge())
	
func _draw_action_button_description(action_type_index: int):
	match action_type_index:
		0:
			info_label.text = "Use an incursion"
		1: 
			info_label.text = "Use a refrain"
		2: 
			info_label.text = "Attempt to dodge an attack"
			
func _handle_choosing_action() -> void:
	for i in action_type.get_children().size():
		var action_type_button = action_type.get_children()[i]
		if(action_type_button.has_focus()):
			_draw_action_button_description(i)
			action_type_button.find_child("Focus").focus()
			current_action = action_type_button.text
		else:
			action_type_button.find_child("Focus").unfocus()
	
	if Input.is_action_just_pressed("to_action_queue"):
		for child in action_type.get_children():
			child.release_focus()
		_start_choosing_action_pos()
		_clear_action_button_focus()
		
func _clear_action_button_focus():
	for button in action_type.get_children():
		button.find_child("Focus").unfocus()
	
# ----------------------
# Shared Skill Functions
# ----------------------
	
func _handle_choose_skill(skill):
	current_skill = skill
	for child in skill_choice_list.get_children():
		child.unfocus()
		
	match current_skill.target:
		Skill.Target.ENEMY:
			_start_choosing_enemy()
		Skill.Target.SELF:
			skill_choice_list.hide()
			action_queue.update_player_action_with_skill(players, enemies, current_skill)
			_clear_info_label()
			_process_next_player()
			enemy_group.clear_focus()
	
func _handle_choose_skill_input():
	var skills := skill_ui.current_skills as Array[Node]
	var skill_buttons = skill_ui.skill_menu.get_children()

	for i in skill_buttons.size():
		var skill_button = skill_buttons[i]
		if(skill_button.skill_button.has_focus()):
			current_skill_button = skill_button
			_draw_skill_desciption(skills[i])
			skill_button.focus()
		else:
			skill_button.unfocus()

	if Input.is_action_just_pressed("menu_left"):
		pass
			
	if Input.is_action_just_pressed("menu_right"):
		pass
		
	if Input.is_action_just_pressed("menu_accept"):
		pass

	if Input.is_action_just_pressed("to_action_queue"):
		_start_choosing_action_pos()
		_clear_skill_button_focus(skill_buttons)
		
	if Input.is_action_just_pressed("menu_back"):
		_return_to_action_choice()
		skill_choice_list.hide()
		_clear_info_label()
		
func _handle_buff_skill():
	action_queue.queue_player_skill_action(players, enemies, current_skill)
	skill_choice_list.hide()
	_process_next_player()
		
func _return_to_choose_skill():
	enemy_group.clear_focus()
	current_skill_button.focus()
	state = State.CHOOSING_SKILL
	
func _draw_skill_desciption(skill: Skill):
	info_label.text  = "Ingress Energy Cost: {0}\nElement: {1}\n{2}".format([
		skill.ingress_energy_cost,
		CharacterStats.get_element_label(skill.element),
		skill.description
	])
	
func _clear_skill_button_focus(buttons):
	for button in buttons:
		button.unfocus()
	
# ------------------------
# Choosing Enemy Functions
# ------------------------
	
func _start_choosing_enemy() -> void:
	state = State.CHOOSING_ENEMY
	enemies[action_queue.enemy_index].focus.focus()
		
func _handle_choose_enemy_input() -> void:
	if Input.is_action_just_pressed("menu_left"):
		var new_enemy_index = (action_queue.enemy_index - 1) % enemies.size()
		enemy_group.switch_focus(new_enemy_index, action_queue.enemy_index)
		action_queue.enemy_index = new_enemy_index
			
	if Input.is_action_just_pressed("menu_right"):
		var new_enemy_index = (action_queue.enemy_index + 1) % enemies.size()
		enemy_group.switch_focus(new_enemy_index, action_queue.enemy_index)
		action_queue.enemy_index = new_enemy_index

	if Input.is_action_just_pressed("to_action_queue"):
		_start_choosing_action_pos()
		
	if Input.is_action_just_pressed("menu_accept"):
		skill_choice_list.hide()
		action_queue.update_player_action_with_skill(players, enemies, current_skill)
		_clear_info_label()
		_process_next_player()
		enemy_group.clear_focus()
		
	if Input.is_action_just_pressed("menu_back"):
		_return_to_choose_skill()
				
func _return_to_enemy_choice():
	_start_choosing_enemy()
	action_queue.action_index = 0
	players[action_queue.player_index].turn.focus()
	
# ----------------------
# Process Turn Functions
# ----------------------
	
func _process_turn() -> void:
	_clear_ui_for_battle()
	state = State.IS_BATTLING
	_reset_groups_and_indexes()
	await get_tree().create_timer(1).timeout
	await action_queue.process_action_queue(get_tree(), players, enemies)

func _process_next_player() -> void:
	action_queue.next_player()
	emit_signal("next_player")
	state = State.CHOOSING_ACTION
	_show_action_type()

func _clear_ui_for_battle() -> void:
	action_type.hide()
	_clear_info_label()
	_clear_action_queue()
	
func _clear_action_queue():
	for child in action_list.get_children():
		child.turn.hide()

func _reset_turn() -> void:
	state = State.CHOOSING_ACTION
	players[0].turn.focus()
	_reset_dodges()
	action_queue.queue_initial_turn_actions(player_group.players, enemy_group.enemies)
	_show_action_type()
	
func _reset_groups_and_indexes() -> void:
	player_group.reset_focus()
	player_group.clear_turn_focus()
	enemy_group.reset_focus()
	enemy_group.clear_turn_focus()
	action_queue.reset_indexes()
	
func _reset_dodges():
	for player in players:
		player.stats.is_dodging = false
	for enemy in enemies:
		enemy.stats.is_dodging = false
	
func _return_to_action_choice() -> void:
	state = State.CHOOSING_ACTION
	_show_action_type()
	enemy_group.clear_focus()
	action_queue._set_is_choosing(true)
	players[action_queue.player_index].turn.focus()
	
func _is_game_over():
	return player_group.players.size() == 0
	
func _clear_info_label():
	info_label.text = ""
	
func _is_victory():
	return enemy_group.enemies.size() == 0
	
# ----------------------
# Signals
# ----------------------
	
func _on_enemy_no_ingress_energy(enemy_id: String) -> void:
	defeated.append(enemy_id)
	action_queue.remove_action_by_character_id(enemy_id)
	enemy_group.remove_enemy_by_id(enemy_id)
	
func _on_player_no_ingress_energy(player_id: String) -> void:
	action_queue.remove_action_by_character_id(player_id)
	player_group.remove_player_by_id(player_id)

# -----------------------------
# Choosing Action Pos Functions
# -----------------------------

func _start_choosing_action_pos() -> void:
	prev_state = state
	state = State.CHOOSING_ACTION_POS
	action_queue.set_focus(0, true)
	player_group.reset_focus()
	player_group.clear_turn_focus()
	action_queue.clear_is_choosing()
	skill_ui.release_focus_from_all_buttons()
	enemy_group.clear_focus()
	
func _handle_choose_action_pos_input() -> void:
	var action = action_queue.get_current_action()
	_remove_action_focuses(action)
	
	if Input.is_action_just_pressed("menu_right"):
		action_queue.action_index = (action_queue.action_index + 1) % action_queue.size()
		
	if Input.is_action_just_pressed("menu_left"):
		if action_queue.action_index == 0:
			action_queue.action_index = action_queue.size() - 1
		else:
			action_queue.action_index = action_queue.action_index - 1
			
	if Input.is_action_just_pressed("menu_accept"):
		pass
	
	if Input.is_action_just_pressed("menu_back") or Input.is_action_just_pressed("to_action_queue"):
		for child in action_list.get_children():
			child.release_focus()
		action_queue.action_index = 0
		_clear_info_label()

		match prev_state:
			State.CHOOSING_ACTION:
				state = State.CHOOSING_ACTION
				_show_action_type()
				players[action_queue.player_index].turn.focus()
				action_queue._set_is_choosing(true)
			State.CHOOSING_SKILL:
				state = State.CHOOSING_SKILL
				players[action_queue.player_index].turn.focus()
				current_skill_button.focus()
			State.CHOOSING_ENEMY:
				_return_to_enemy_choice()

		return
	
	info_label.text = action_queue.create_action_message(action)
	action = action_queue.get_current_action()
	_set_action_focuses(action)
		
func _set_action_focuses(action: Action):
	action.is_focused = true
	action.actor.find_child("Turn").focus()
	
	if action.target:
		action.target.find_child("Turn").self_modulate = Color("Red")
		action.target.find_child("Turn").focus()
	elif action.skill and action.skill.target == Skill.Target.SELF:
		action.actor.find_child("Turn").self_modulate = Color("Green")

func _remove_action_focuses(action: Action):
	action.actor.find_child("Turn").unfocus()
	action_queue.set_focus(action_queue.action_index, false)
	action.actor.find_child("Turn").self_modulate = Color("White")
	if action.target:
		action.target.find_child("Turn").self_modulate = Color("White")
		action.target.find_child("Turn").unfocus()





func _on_help_button_pressed():
	help_menu.show()
