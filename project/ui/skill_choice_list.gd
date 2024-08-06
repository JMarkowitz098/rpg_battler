extends GridContainer

const BATTLE_SCENE_BUTTON := preload("res://menus/battle_scene_button.tscn")

var current_skill: Ingress
var current_skill_button: Button
var current_skills: Array[Ingress]

func _ready() -> void:
	var signals := [
		["choosing_action_queue_state_entered",_on_choosing_action_queue_state_entered],
		["choosing_action_state_entered",_on_choosing_action_state_entered],
		["choosing_ally_state_entered",_on_choosing_ally_state_entered],
		["choosing_ally_all_state_entered",_on_choosing_ally_all_state_entered],
		["choosing_enemy_all_state_entered",_on_choosing_enemy_all_state_entered],
		["choosing_enemy_state_entered",_on_choosing_enemy_state_entered],
		["choosing_self_state_entered",_on_choosing_self_state_entered],
		["choosing_skill_state_entered",_on_choosing_skill_state_entered],
		["is_battling_state_entered",_on_is_battling_state_entered],
	]

	Utils.connect_signals(signals)


func set_current_skills(player: Node2D, type: Ingress.Type) -> void:
	current_skills = player.learned_skills.filter_by_type(type)


func prepare_skill_menu() -> void:
	_fill_skill_menu_with_current_skills()
	_connect_skill_button_signals()
	

func release_focus_from_all_buttons() -> void:
	for child in get_children():
		child.release_focus()


func _fill_skill_menu_with_current_skills() -> void:
	for child in get_children():
		# queue_free is deferred until end of frame, so we remove node from list
		# to prevent indexing issues while turn is processing
		remove_child(child)
		child.queue_free()
		
	for skill in current_skills:
		_create_button_choice(skill.label)

func _create_button_choice(button_text: String) -> void:
	var button := BATTLE_SCENE_BUTTON.instantiate()
	add_child(button)
	button.text = button_text
	button.add_theme_font_size_override("font_size", 8)

func _connect_skill_button_signals() -> void:
	var skill_buttons := get_children()
	for i in skill_buttons.size():
		var skill := current_skills[i]
		var skill_button := skill_buttons[i]
		skill_button.pressed.connect(_handle_choose_skill.bind(skill))
		skill_button.focus_entered.connect(_handle_button_focus.bind(skill, skill_button))

func _create_skill_desciption(skill: Ingress) -> String:
	return "{0}\nIngress Energy Cost: {1}\nElement: {2}\n{3}".format([
		skill.label,
		skill.ingress,
		Element.get_label(skill.element),
		skill.description
	])


func show_list() -> void:
	show()
	current_skill_button.focus_no_sound()


func _handle_choose_skill(skill: Ingress) -> void:
	Sound.play(Sound.confirm)
		
	match skill.target:
		Ingress.Target.ENEMY:
			Events.change_state.emit(State.Type.CHOOSING_ENEMY)
		Ingress.Target.ALLY:
			Events.change_state.emit(State.Type.CHOOSING_ALLY)
		Ingress.Target.SELF: 
			Events.change_state.emit(State.Type.CHOOSING_SELF)
		Ingress.Target.ALL_ALLIES:
			Events.change_state.emit(State.Type.CHOOSING_ALLY_ALL)
		Ingress.Target.ALL_ENEMIES:
			Events.change_state.emit(State.Type.CHOOSING_ENEMY_ALL)


func _handle_button_focus(skill: Ingress, button: Button) -> void:
	current_skill = skill
	current_skill_button = button
	Events.update_info_label.emit(_create_skill_desciption(skill))

# -------
# Signals
# -------

func _on_choosing_action_state_entered(_params: StateParams = null) -> void:
	hide()


func _on_choosing_skill_state_entered(_params: StateParams = null) -> void:
	if _params and _params.item and _params.ingress_type >= 0:
		set_current_skills(_params.item.action.actor, _params.ingress_type)
		prepare_skill_menu()
		current_skill_button = get_children()[0]
	show_list()


func _on_is_battling_state_entered() -> void:
	release_focus_from_all_buttons()
	hide()


func _on_choosing_action_queue_state_entered() -> void: release_focus_from_all_buttons()
func _on_choosing_enemy_state_entered() -> void: release_focus_from_all_buttons()
func _on_choosing_enemy_all_state_entered() -> void: release_focus_from_all_buttons()
func _on_choosing_ally_state_entered() -> void: release_focus_from_all_buttons()
func _on_choosing_self_state_entered() -> void: release_focus_from_all_buttons()
func _on_choosing_ally_all_state_entered() -> void: release_focus_from_all_buttons()

