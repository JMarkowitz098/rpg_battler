extends Node2D

var current_skill_button: Button
var current_skill_type: Ingress.Type
var current_skill: Ingress
var defeated: Array[String]
var prev_state: State.Type
var before_pause_focus: Variant

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
	player_group.load_members_from_save_data()
	enemy_group.load_members_from_round_data(Utils.current_round)
	_connect_signals()
	action_queue.fill_initial_turn_items(player_group.members, enemy_group.members)
	state.change_state(State.Type.CHOOSING_ACTION)
	# await Music.fade()
	Music.play(Music.battle_theme)
	
func _process(_delta: float) -> void:
	state.current.handle_input()

	if action_queue.is_turn_over():
		set_process(false)
		await _process_turn()
		set_process(true)

		if _is_game_over():
			Utils.change_scene("res://menus/game_completion_screen.tscn", { "status": Utils.GameOver.DEFEAT })
		elif _is_victory():
			if Utils.current_round == Utils.FINAL_ROUND:
				Utils.change_scene("res://menus/game_completion_screen.tscn", { "status": Utils.GameOver.VICTORY })
			else:
				Utils.next_round()
				Utils.change_scene("res://menus/victory_screen.tscn", { "defeated": defeated })
		else:
			_reset_turn()

		
func _connect_signals() -> void:
	for enemy: Node2D in enemy_group.members:
		enemy.stats.no_ingress_energy.connect(_on_enemy_no_ingress_energy)
	for player: Node2D in player_group.members:
		player.stats.no_ingress_energy.connect(_on_player_no_ingress_energy)
	Events.choosing_action_state_entered.connect(_on_choosing_action_state_entered)
	Events.choosing_skill_state_entered.connect(_on_choosing_skill_state_entered)
	Events.choose_enemy.connect(_on_choose_enemy)
	Events.choose_ally.connect(_on_choose_ally)
	Events.pause_game.connect(_on_game_paused)

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
	current_skill_type = Ingress.Type.INCURSION
	state.change_state(State.Type.CHOOSING_SKILL)
	current_skill = skill_choice_list.current_skills[0]

func _on_refrain_pressed() -> void:
	Sound.play(Sound.confirm)
	current_skill_type = Ingress.Type.REFRAIN
	state.change_state(State.Type.CHOOSING_SKILL)
	current_skill = skill_choice_list.current_skills[0]
	
func _on_recover_pressed() -> void:
	Sound.play(Sound.confirm)
	var unique_id: String = player_group.get_current_member().stats.unique_id
	var current_players_action_id: int = action_queue.get_action_index_by_unique_id(unique_id)
	var current_action: Action = action_queue.items[current_players_action_id].action
	current_action.set_dodge()

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
	await action_queue.process_action_queue(
		get_tree(), 
		player_group.members, 
		enemy_group.members, 
		set_process
	)
	state.change_state(State.Type.IS_BATTLING)

func _reset_turn() -> void:
	action_queue.reset_current_member()
	player_group.reset_current_member_and_turn()
	enemy_group.reset_current_member()
	action_queue.fill_initial_turn_items(player_group.members, enemy_group.members)
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
	if !action_queue.is_turn_over():
		player_group.next_player()
		state.change_state(State.Type.CHOOSING_ACTION)
	else:
		player_group.reset_current_member_and_turn()
		state.change_state(State.Type.IS_BATTLING)

# -------
# Signals
# -------
	
func _on_enemy_no_ingress_energy(enemy_id: String) -> void:
	defeated.append(enemy_id)
	action_queue.remove_action_by_character_id(enemy_id)
	enemy_group.remove_member_by_id(enemy_id)
	enemy_group.reset_current_member()
	
func _on_player_no_ingress_energy(player_id: String) -> void:
	action_queue.remove_action_by_character_id(player_id)
	player_group.remove_member_by_id(player_id)
	player_group.reset_current_member()

# func _on_help_button_pressed():
# 	get_tree().paused = true
# 	help_menu.show()
# 	help_menu.close_button.focus()

func _on_choosing_action_state_entered() -> void:
	current_action_button.focus(true)
	var current_player: Node2D = player_group.get_current_member_turn()
	current_player.focus(Focus.Type.TRIANGLE) # move to player group
	action_queue.set_turn_on_player(current_player.stats.unique_id)

func _on_choosing_skill_state_entered() -> void:
	var current_player: Node2D = player_group.get_current_member_turn()
	skill_choice_list.set_current_skills(current_player, current_skill_type)
	skill_choice_list.prepare_skill_menu(_handle_choose_skill)
	skill_choice_list.get_children()[0].focus(true)
	current_player.focus(Focus.Type.TRIANGLE) # move to player group
	action_queue.set_turn_on_player(current_player.stats.unique_id)

func _on_choose_enemy() -> void:
	action_queue.update_player_action_with_skill(
		player_group.get_current_member_turn(),
		enemy_group.get_current_member(),
		skill_choice_list.get_current_skill()
	)
	_handle_done_choosing()

func _on_choose_ally() -> void:
	action_queue.update_player_action_with_skill(
		player_group.get_current_member_turn(),
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

