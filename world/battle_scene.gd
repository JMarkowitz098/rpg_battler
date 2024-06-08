extends Node2D

var enemies: Array[Node2D]
var players: Array[Node2D]
var defeated: Array[String]

var action_queue := ActionQueue.new()
var skill_index := 0

var current_skill: Skill
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

signal next_player

func _ready() -> void:
	audio_stream_player_2d.play()
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
			#get_tree().change_scene_to_file("res://menus/start_menu.tscn")
			get_tree().change_scene_to_file("res://world/battle_scene.tscn")
		elif _is_victory():
			get_tree().change_scene_to_file("res://menus/victory_screen.tscn")
			Utils.change_scene("res://menus/victory_screen.tscn", { "defeated": defeated })
		else:
			_reset_turn()
		
func _connect_signals() -> void:
	for enemy in enemy_group.enemies:
		enemy.stats.no_ingress_energy.connect(_on_enemy_no_ingress_energy)
	for player in player_group.players:
		player.stats.no_ingress_energy.connect(_on_player_no_ingress_energy)

func _show_action_type() -> void:
	action_type.show()
	action_type.find_child("Incursion").grab_focus()

func _handle_choosing_action() -> void:
	for i in action_type.get_children().size():
		if(action_type.get_children()[i].has_focus()):
			_draw_action_button_description(i)
	
	if Input.is_action_just_pressed("to_action_queue"):
		for child in action_type.get_children():
			child.release_focus()
		_start_choosing_action_pos()

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
	
# ----------------------
# Shared Skill Functions
# ----------------------
	
func _handle_choose_skill(skill):
	current_skill = skill
	#TODO: Can probably get the focused child directly from signal
	for child in skill_choice_list.get_children():
		child.release_focus()
		
	match current_skill.target:
		Skill.Target.ENEMY:
			_start_choosing_enemy()
		Skill.Target.SELF:
			skill_choice_list.hide()
			action_queue.update_player_action_with_skill(players, enemies, current_skill)
			_clear_info_label()
			_process_next_player()
			enemy_group.reset_focus()
	
func _handle_choose_skill_input():
	var skills := skill_ui.current_skills as Array[Node]
	var skill_buttons = skill_ui.skill_menu.get_children()

	for i in skill_buttons.size():
		if(skill_buttons[i].has_focus()):
			_draw_skill_desciption(skills[i])

	if Input.is_action_just_pressed("menu_left"):
		pass
			
	if Input.is_action_just_pressed("menu_right"):
		pass
		
	if Input.is_action_just_pressed("menu_accept"):
		pass

	if Input.is_action_just_pressed("to_action_queue"):
		_start_choosing_action_pos()
		
	if Input.is_action_just_pressed("menu_back"):
		_return_to_action_choice()
		skill_choice_list.hide()
		_clear_info_label()
		
func _handle_buff_skill():
	action_queue.queue_player_skill_action(players, enemies, current_skill)
	skill_choice_list.hide()
	_process_next_player()
		
func _return_to_choose_skill():
	enemy_group.reset_focus()
	action_queue.enemy_index = 0
	skill_choice_list.get_children()[0].grab_focus()
	state = State.CHOOSING_SKILL
	
func _draw_skill_desciption(skill: Skill):
	info_label.text  = "Ingress Energy Cost: {0}\nElement: {1}\n{2}".format([
		skill.ingress_energy_cost,
		CharacterStats.get_element_label(skill.element),
		skill.description
	])
	
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

	if Input.is_action_just_pressed("to_action_queue"):
		_start_choosing_action_pos()
		
	if Input.is_action_just_pressed("menu_accept"):
		skill_choice_list.hide()
		action_queue.update_player_action_with_skill(players, enemies, current_skill)
		_clear_info_label()
		_process_next_player()
		enemy_group.reset_focus()
		
	if Input.is_action_just_pressed("menu_back"):
		_return_to_choose_skill()
				
func _return_to_enemy_choice():
	_start_choosing_enemy()
	action_queue.action_index = 0
	
# ----------------------
# Process Turn Functions
# ----------------------
	
func _process_turn() -> void:
	_clear_ui_for_battle()
	state = State.IS_BATTLING
	_reset_groups_and_indexes()
	await get_tree().create_timer(1).timeout
	await action_queue.process_action_queue(get_tree(), players)

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
	players[0].focus.focus()
	_reset_dodges()
	action_queue.queue_initial_turn_actions(player_group.players, enemy_group.enemies)
	_show_action_type()
	
func _reset_groups_and_indexes() -> void:
	player_group.reset_focus()
	enemy_group.reset_focus()
	action_queue.reset_indexes()
	
func _reset_dodges():
	for player in players:
		player.stats.is_dodging = false
	for enemy in enemies:
		enemy.stats.is_dodging = false
	
func _return_to_action_choice() -> void:
	state = State.CHOOSING_ACTION
	_show_action_type()
	enemy_group.reset_focus()
	action_queue.enemy_index = 0
	
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

#TODO: Redesign so you can just view at any time by pressing a button

func _start_choosing_action_pos() -> void:
	prev_state = state
	state = State.CHOOSING_ACTION_POS
	action_queue.set_focus(0, true)
	
func _handle_choose_action_pos_input() -> void:
	action_queue.set_focus(action_queue.action_index, false)
	
	if Input.is_action_just_pressed("menu_right"):
		action_queue.action_index = (action_queue.action_index + 1) % action_queue.size()
		
	if Input.is_action_just_pressed("menu_left"):
		if action_queue.action_index == 0:
			action_queue.action_index = action_queue.size() - 1
		else:
			action_queue.action_index = action_queue.action_index - 1
			
	if Input.is_action_just_pressed("menu_accept"):
		pass
	
	if Input.is_action_just_pressed("menu_back"):
		for child in action_list.get_children():
			child.release_focus()
		action_queue.action_index = 0
		_clear_info_label()

		match prev_state:
			State.CHOOSING_ACTION:
				state = State.CHOOSING_ACTION
				_show_action_type()
			State.CHOOSING_SKILL:
				skill_ui.prepare_skill_menu(_handle_choose_skill, action_type)
				state = State.CHOOSING_SKILL
			State.CHOOSING_ENEMY:
				_return_to_enemy_choice()

		return
	
	var action = action_queue.get_current_action()
	action.is_focused = true
	info_label.text = action_queue.create_action_message(action)



