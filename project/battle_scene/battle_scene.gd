extends Node2D

var current_action_item: ActionQueueItem
var current_skill_button: Button
var current_skill_type: Ingress.Type
var current_skill: Ingress
var defeated: Array[Player.Id]
var prev_state: State.Type
var before_pause_focus: Variant
var battle_groups: BattleGroups

var skill_index := 0

@onready var action_queue := $CanvasLayer/ActionQueue
@onready var action_choice := $CanvasLayer/ActionChoice
@onready var dodge := $CanvasLayer/ActionChoice/Recover
@onready var enemy_group := $EnemyGroup
@onready var help_menu := $CanvasLayer/HelpMenu
@onready var incursion := $CanvasLayer/ActionChoice/Incursion
@onready var info_label := $CanvasLayer/InfoBackground/InfoLabel
@onready var player_group := $PlayerGroup
@onready var refrain := $CanvasLayer/ActionChoice/Refrain
@onready var skill_choice_list := $CanvasLayer/SkillChoiceList

@onready var current_action_button: Button = incursion
@onready var state := State.new()

# ----------------------
# Initializing Functions
# ----------------------

func _ready() -> void:
	_create_battle_groups()
	_connect_signals()
	action_queue.fill_initial_turn_items(battle_groups)
	current_action_item = action_queue.items.front()
	# await Music.fade()
	Music.play(Music.battle_theme)
	
func _process(_delta: float) -> void:
	var current_action := current_action_item.action
	if current_action.action_chosen:
		state.change_state(State.Type.IS_BATTLING)
		set_process(false)
		await current_action.skill.process(current_action, get_tree(), battle_groups)
		set_process(true)
		if action_queue.items.size() > 0:
			current_action_item.queue_free()
			action_queue.items.pop_front()
			current_action_item = action_queue.items.front()
		else:
			_reset_turn()
	elif !current_action.is_choosing:
		current_action.is_choosing = true
		player_group.current_member = player_group.get_member_index(current_action.actor.unique_id.id)
		state.change_state(State.Type.CHOOSING_ACTION, StateParams.new(current_action_item))

	state.current.handle_input()

	

		# LEGACY CODE
		# set_process(false)
		# await _process_turn()
		# set_process(true)
		# if _is_game_over():
		# 	Utils.change_scene("res://menus/game_completion_screen.tscn", { "status": Utils.GameOver.DEFEAT })
		# elif _is_victory():
		# 	if Utils.current_round == Utils.FINAL_ROUND:
		# 		Utils.change_scene("res://menus/game_completion_screen.tscn", { "status": Utils.GameOver.VICTORY })
		# 	else:
		# 		Utils.next_round()
		# 		Utils.change_scene("res://menus/victory_screen.tscn", { "defeated": defeated })
		# else:
		# 	_reset_turn()

		
func _connect_signals() -> void:
	for enemy: Node2D in enemy_group.members:
		enemy.modifiers.no_ingress.connect(_on_enemy_no_ingress)
	for player: Node2D in player_group.members:
		player.modifiers.no_ingress.connect(_on_player_no_ingress)

	var signals := [
		["choose_enemy", _on_choose_enemy],
		["choose_ally", _on_choose_ally],
		["pause_game", _on_game_paused],
	]

	Utils.connect_signals(signals)

# -------------------
# Action Buttons
# -------------------
func _on_incursion_focus_entered() -> void:
	if info_label: info_label.draw_action_button_description(0)
	
func _on_refrain_focus_entered() -> void:
	if info_label: info_label.draw_action_button_description(1)
	
func _on_recover_focus_entered() -> void:
	if info_label: info_label.draw_action_button_description(2)
	
func _on_incursion_pressed() -> void:
	Sound.play(Sound.confirm)
	state.change_state(State.Type.CHOOSING_SKILL, StateParams.new(
		current_action_item, null, null, Ingress.Type.INCURSION))

func _on_refrain_pressed() -> void:
	Sound.play(Sound.confirm)
	state.change_state(State.Type.CHOOSING_SKILL, StateParams.new(
		current_action_item, null, null, Ingress.Type.REFRAIN))
	
func _on_recover_pressed() -> void:
	Sound.play(Sound.confirm)
	# var unique_id: String = player_group.get_current_member().unique_id.id
	# var current_players_action_id: int = action_queue.get_action_index_by_unique_id(unique_id)
	# var current_action_item: Action = action_queue.items[current_players_action_id].action
	current_action_item.set_recover()

	if !action_queue.is_turn_over():
		player_group.next_player()
		state.change_state(State.Type.CHOOSING_ACTION)
	else:
		state.change_state.call(State.Type.IS_BATTLING)
		
func _draw_action_button_description(action_choice_index: int) -> void:
	if !info_label: return
	match action_choice_index:
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
	_set_dodging_animation()
	await get_tree().create_timer(1).timeout
	await action_queue.process_action_queue(get_tree(), battle_groups)
	state.change_state(State.Type.IS_BATTLING)

func _reset_turn() -> void:
	current_action_item = action_queue.items.front()
	action_queue.reset_current_member()
	player_group.reset_current_member_and_turn()
	enemy_group.reset_current_member()
	action_queue.fill_initial_turn_items(battle_groups)
	state.change_state(State.Type.CHOOSING_ACTION)
	player_group.reset_dodges()
	enemy_group.reset_dodges()

	
func _is_game_over() -> bool:
	return player_group.members.size() == 0
	
func _is_victory() -> bool:
	return enemy_group.members.size() == 0
	
func _set_dodging_animation() -> void:
	for item: ActionQueueItem in action_queue.items:
		if item.action.skill.id == Ingress.Id.DODGE:
			item.action.actor.set_dodge_animation(true)

# ----------------------
# Helper Functions
# ----------------------

func _handle_choose_skill(skill: Ingress) -> void:
	Sound.play(Sound.confirm)
	current_skill = skill
		
	match current_skill.target:
		Ingress.Target.ENEMY:
			state.change_state.call(State.Type.CHOOSING_ENEMY)
			return
		Ingress.Target.ALLY:
			state.change_state.call(State.Type.CHOOSING_ALLY)
			return
		Ingress.Target.SELF: 
			state.change_state.call(State.Type.CHOOSING_SELF)
			return
		Ingress.Target.ALL_ALLIES:
			state.change_state.call(State.Type.CHOOSING_ALLY_ALL)
			return
		Ingress.Target.ALL_ENEMIES:
			state.change_state.call(State.Type.CHOOSING_ENEMY_ALL)
			return
	
func _handle_done_choosing() -> void:
	action_queue.items[0].action.is_choosing = false
	if !action_queue.is_turn_over():
		player_group.next_player()
		state.change_state(State.Type.CHOOSING_ACTION)
	else:
		player_group.reset_current_member_and_turn()
		state.change_state(State.Type.IS_BATTLING)

func _create_battle_groups() -> void:
	player_group.load_members_from_save_data("0")
	enemy_group.load_members_from_round_data(Utils.current_round)
	battle_groups = BattleGroups.new(player_group.members, enemy_group.members)

# -------
# Signals
# -------
	
func _on_enemy_no_ingress(enemy_unique_id: String) -> void:
	var enemy: Node2D = enemy_group.get_member_by_unique_id(enemy_unique_id)
	defeated.append(enemy.details.player_id)

	enemy_group.remove_member_by_id(enemy_unique_id)
	battle_groups.enemies = enemy_group.members
	enemy_group.reset_current_member()

	if enemy_group.members.size() > 0:
		action_queue.update_actions_with_targets_with_removed_id(enemy_unique_id, battle_groups)
		action_queue.remove_actions_without_target_with_removed_id(enemy_unique_id)

func _on_player_no_ingress(player_unique_id: String) -> void:
	player_group.remove_member_by_id(player_unique_id)
	battle_groups.players = player_group.members
	player_group.reset_current_member()

	if player_group.members.size() > 0:
		action_queue.update_actions_with_targets_with_removed_id(player_unique_id, battle_groups)
		action_queue.remove_actions_without_target_with_removed_id(player_unique_id)

# func _on_help_button_pressed():
# 	get_tree().paused = true
# 	help_menu.show()
# 	help_menu.close_button.focus()



func _on_choose_enemy() -> void:
	action_queue.update_player_action_with_skill(
		current_action_item.action,
		current_action_item.action.actor,
		enemy_group.get_current_member(),
		skill_choice_list.get_current_skill()
	)
	_handle_done_choosing()

func _on_choose_ally() -> void:
	action_queue.update_player_action_with_skill(
		current_action_item.action,
		current_action_item.action.actor,
		player_group.get_current_member(),
		skill_choice_list.get_current_skill()
	)
	_handle_done_choosing()

func _on_game_paused(current_state: int) -> void:
	match current_state:
		State.Type.CHOOSING_ACTION:
			before_pause_focus = current_action_button
		State.Type.CHOOSING_SKILL:
			before_pause_focus = skill_choice_list.get_current_skill_button()
		State.Type.CHOOSING_ACTION_QUEUE:
			before_pause_focus = action_queue.get_current_item()
		State.Type.CHOOSING_ENEMY:
			before_pause_focus = enemy_group.get_current_member()
		State.Type.IS_BATTLING:
			before_pause_focus = null

	get_tree().paused = true
	help_menu.show()
	help_menu.close_button.focus(true)
	Music.set_from()
	Music.play(Music.menu_theme)

func _on_help_menu_hidden() -> void:
	# Need to figure out how to return focus. Check heartbest tutorials on pausing probably
	get_tree().paused = false
	before_pause_focus.focus(true)
	Music.play(Music.battle_theme, Music.get_from())

