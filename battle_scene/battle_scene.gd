extends Node2D

var current_skill_button: Button
var current_skill_type: Skill.Type
var current_skill: SkillStats
var defeated: Array[String]
var enemies: Array[Node2D]
var players: Array[Node2D]
var prev_state: State.Type
var state: State.Type

var skill_index := 0

@onready var action_queue := $CanvasLayer/ActionQueue
@onready var action_type := $CanvasLayer/ActionType
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var dodge = $CanvasLayer/ActionType/Dodge
@onready var enemy_group := $EnemyGroup
@onready var enemy_group_location = $EnemyGroupLocation
@onready var help_menu = $CanvasLayer/HelpMenu
@onready var incursion = $CanvasLayer/ActionType/Incursion
@onready var info_label := $CanvasLayer/InfoBackground/InfoLabel
@onready var player_group := $PlayerGroup
@onready var refrain = $CanvasLayer/ActionType/Refrain
@onready var skill_choice_list = $CanvasLayer/SkillChoiceList

@onready var current_action_button: Button = incursion
@onready var skill_ui = SkillMenuUi.new(skill_choice_list)
@onready var holder = ComponentHolder.new({
	"action_queue": action_queue,
	"action_type": action_type,
	"current_action_button": current_action_button,
	"current_skill_button": current_skill_button,
	"current_skill_type": current_skill_type,
	"current_skill": current_skill,
	"enemy_group": enemy_group,
	"info_label": info_label,
	"player_group": player_group,
	"skill_choice_list": skill_choice_list,
	"skill_ui": skill_ui
})
@onready var state_t := State.new(holder)

signal next_player


func _ready() -> void:
	audio_stream_player_2d.play()
	_load_enemy_group()
	_connect_signals()
	action_queue.fill_initial_turn_items(player_group.players, enemy_group.enemies)
	state_t.change_state(State.Type.CHOOSING_ACTION)
	
func _process(_delta: float) -> void:
	players = player_group.players
	enemies = enemy_group.enemies
	
	if state != State.Type.IS_BATTLING:
		state_t.current.handle_input()
	
		# State.Type.IS_BATTLING:
		# 	return

	if action_queue.is_turn_over():
		await _process_turn()
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

# -------------------
# Action Buttons
# -------------------
func _on_incursion_focus_entered():
	#TODO Move into action button state maybe
		_draw_action_button_description(0)
	
func _on_refrain_focus_entered():
		_draw_action_button_description(1)
	
func _on_dodge_focus_entered():
		_draw_action_button_description(2)
	
func _on_incursion_pressed():
	holder.current_skill_type = Skill.Type.INCURSION
	state_t.change_state(State.Type.CHOOSING_SKILL)
	holder.current_skill = skill_ui.current_skills[0]

func _on_refrain_pressed():
	holder.current_skill_type = Skill.Type.REFRAIN
	state_t.change_state(State.Type.CHOOSING_SKILL)
	holder.current_skill = skill_ui.current_skills[0]
	
func _on_dodge_pressed():
	var current_action = action_queue.items[action_queue.action_index].action
	action_queue.set_dodge(current_action)
	holder.action_queue.next_player()
	state_t.change_state(State.Type.CHOOSING_ACTION)
	
func _draw_action_button_description(action_type_index: int):
	if !info_label: return
	match action_type_index:
		0:
			info_label.text = "Use an incursion"
		1: 
			info_label.text = "Use a refrain"
		2: 
			info_label.text = "Attempt to dodge an attack"
	
# ----------------------
# Process Turn Functions
# ----------------------
	
func _process_turn() -> void:
	_clear_ui_for_battle()
	state = State.Type.IS_BATTLING
	_reset_groups_and_indexes()
	_set_dodging_animation()
	await get_tree().create_timer(1).timeout
	await action_queue.process_action_queue(get_tree(), players, enemies)

func _process_next_player() -> void:
	action_queue.next_player(players)
	emit_signal("next_player")
	state = State.Type.CHOOSING_ACTION

func _clear_ui_for_battle() -> void:
	action_type.hide()
	_clear_info_label()
	action_queue._set_is_choosing(false)
	

func _reset_turn() -> void:
	state = State.Type.CHOOSING_ACTION
	players[0].turn.focus()
	_reset_dodges()
	action_queue.queue_initial_turn_actions(player_group.players, enemy_group.enemies)
	
func _reset_groups_and_indexes() -> void:
	player_group.clear_focus()
	player_group.clear_turn_focus()
	enemy_group.reset_focus()
	enemy_group.clear_turn_focus()
	action_queue.reset_indexes()
	
func _reset_dodges():
	for player in players:
		player.stats.is_dodging = false
		player.base_sprite.self_modulate = Color("ffffff")
	for enemy in enemies:
		enemy.stats.is_dodging = false
	
func _return_to_action_choice() -> void:
	state = State.Type.CHOOSING_ACTION
	enemy_group.clear_focus()
	action_queue._set_is_choosing(true, players)
	players[action_queue.player_index].turn.focus()
	
func _is_game_over():
	return player_group.players.size() == 0
	
func _clear_info_label():
	info_label.text = ""
	
func _is_victory():
	return enemy_group.enemies.size() == 0
	
func _set_dodging_animation():
	for action in action_queue.queue:
		if action.skill.id == Skill.Id.DODGE:
			action.actor.base_sprite.self_modulate = Color("ffffff9b")
	
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

