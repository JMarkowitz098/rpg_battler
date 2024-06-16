extends Node2D

var current_skill_button: Button
var current_skill_type: Skill.Type
var current_skill: SkillStats
var defeated: Array[String]
var enemies: Array[Node2D]
var players: Array[Node2D]
var prev_state: State.Type

var skill_index := 0

@onready var action_queue := $CanvasLayer/ActionQueue
@onready var action_choice := $CanvasLayer/ActionChoice
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var dodge = $CanvasLayer/ActionChoice/Dodge
@onready var enemy_group := $EnemyGroup
@onready var enemy_group_location = $EnemyGroupLocation
@onready var help_menu = $CanvasLayer/HelpMenu
@onready var incursion = $CanvasLayer/ActionChoice/Incursion
@onready var info_label := $CanvasLayer/InfoBackground/InfoLabel
@onready var player_group := $PlayerGroup
@onready var refrain = $CanvasLayer/ActionChoice/Refrain
@onready var skill_choice_list = $CanvasLayer/SkillChoiceList

@onready var current_action_button: Button = incursion
@onready var holder = ComponentHolder.new({
	"action_queue": action_queue,
	"action_choice": action_choice,
	"current_action_button": current_action_button,
	"current_skill_button": current_skill_button,
	"current_skill_type": current_skill_type,
	"current_skill": current_skill,
	"enemy_group": enemy_group,
	"info_label": info_label,
	"player_group": player_group,
	"skill_choice_list": skill_choice_list,
})
@onready var state := State.new(holder)

func _ready() -> void:
	audio_stream_player_2d.play()
	_load_enemy_group()
	_connect_signals()
	action_queue.fill_initial_turn_items(player_group.players, enemy_group.enemies)
	state.change_state(State.Type.CHOOSING_ACTION)
	
func _process(_delta: float) -> void:
	players = player_group.players
	enemies = enemy_group.enemies

	state.current.handle_input()

	if action_queue.is_turn_over():
		set_process(false)
		await _process_turn()
		set_process(true)

		if _is_game_over():
			get_tree().change_scene_to_file("res://menus/start_menu.tscn")
			#get_tree().change_scene_to_file("res://world/battle_scene.tscn")
		elif _is_victory():
			if Utils.round_number == Utils.FINAL_ROUND:
				get_tree().change_scene_to_file("res://menus/start_menu.tscn")
			else:
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
	Events.choosing_action_state_entered.connect(_on_choosing_action_state_entered)
	Events.choosing_skill_state_entered.connect(_on_choosing_skill_state_entered)
	Events.choosing_enemy_state_entered.connect(_on_choosing_enemy_state_entered)
	Events.choose_enemy.connect(_on_choose_enemy)

# -------------------
# Action Buttons
# -------------------
func _on_incursion_focus_entered():
	if info_label: info_label.draw_action_button_description(0)
	
func _on_refrain_focus_entered():
	if info_label: info_label.draw_action_button_description(1)
	
func _on_dodge_focus_entered():
	if info_label: info_label.draw_action_button_description(2)
	
func _on_incursion_pressed():
	holder.current_skill_type = Skill.Type.INCURSION
	state.change_state(State.Type.CHOOSING_SKILL)
	holder.current_skill = skill_choice_list.current_skills[0]

func _on_refrain_pressed():
	holder.current_skill_type = Skill.Type.REFRAIN
	state.change_state(State.Type.CHOOSING_SKILL)
	holder.current_skill = skill_choice_list.current_skills[0]
	
func _on_dodge_pressed():
	var unique_id = players[action_queue.player_index].stats.unique_id
	var current_action_id = action_queue.get_action_index_by_unique_id(unique_id)
	var current_action = action_queue.items[current_action_id].action
	action_queue.set_dodge(current_action)

	if !holder.action_queue.is_turn_over():
		holder.action_queue.next_player()
		state.change_state(State.Type.CHOOSING_ACTION)
	else:
		state.change_state.call(State.Type.IS_BATTLING)
		
func _draw_action_button_description(action_choice_index: int):
	if !info_label: return
	match action_choice_index:
		0:
			info_label.text = "Use an incursion"
		1: 
			info_label.text = "Use a refrain"
		2: 
			info_label.text = "Attempt to dodge an attack"

func _handle_choose_skill(skill: SkillStats):
	current_skill = skill
		
	match holder.current_skill.target:
		Skill.Target.ENEMY:
			state.change_state.call(State.Type.CHOOSING_ENEMY)
			return
		Skill.Target.SELF:
			action_queue.update_player_action_with_skill(
			player_group.players, 
			enemy_group.get_current_enemy(),
			current_skill
		)

			# Factor into function in state class
			if !holder.action_queue.is_turn_over():
				holder.action_queue.next_player()
				state.change_state.call(State.Type.CHOOSING_ACTION)
			else:
				state.change_state.call(State.Type.IS_BATTLING)
			return
	
# ----------------------
# Process Turn Functions
# ----------------------
	
func _process_turn() -> void:
	_set_dodging_animation()

	await get_tree().create_timer(1).timeout
	await action_queue.process_action_queue(get_tree(), players, enemies, set_process)
	state.change_state(State.Type.IS_BATTLING)
	action_queue.reset_indexes()

func _reset_turn() -> void:
	action_queue.fill_initial_turn_items(player_group.players, enemy_group.enemies)
	state.change_state(State.Type.CHOOSING_ACTION)
	_reset_dodges()
	
func _reset_dodges():
	for player in player_group.players:
		player.stats.is_dodging = false
		player.base_sprite.self_modulate = Color("ffffff")
	for enemy in enemy_group.enemies:
		enemy.stats.is_dodging = false
	
func _is_game_over():
	return player_group.players.size() == 0
	
func _clear_info_label():
	info_label.text = ""
	
func _is_victory():
	return enemy_group.enemies.size() == 0
	
func _set_dodging_animation():
	for item in action_queue.items:
		if item.action.skill.id == Skill.Id.DODGE:
			item.action.actor.base_sprite.self_modulate = Color("ffffff9b")

func _get_current_player() -> Node2D:
	return player_group.players[action_queue.player_index]

func _get_current_enemy() -> Node2D:
	return enemy_group.enemies[action_queue.enemy_index]

	
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

func _on_help_button_pressed():
	help_menu.show()

func _on_choosing_action_state_entered():
	current_action_button.focus()
	var current_player = _get_current_player()
	current_player.turn.focus()
	action_queue.set_turn_on_player(current_player.stats.unique_id)

func _on_choosing_skill_state_entered():
	var current_player = _get_current_player()
	skill_choice_list.set_current_skills(current_player, current_skill_type)
	skill_choice_list.prepare_skill_menu(_handle_choose_skill)
	skill_choice_list.get_children()[0].focus()
	current_player.turn.focus()
	action_queue.set_turn_on_player(current_player.stats.unique_id)

func _on_choosing_enemy_state_entered():
	enemy_group.get_current_enemy().focus.focus()

func _on_choose_enemy():
	action_queue.update_player_action_with_skill(
		player_group.players,
		enemy_group.get_current_enemy(),
		skill_choice_list.get_current_skill()
	)
	if !action_queue.is_turn_over():
		action_queue.next_player()
		state.change_state(State.Type.CHOOSING_ACTION)
	else:
		state.change_state(State.Type.IS_BATTLING)
