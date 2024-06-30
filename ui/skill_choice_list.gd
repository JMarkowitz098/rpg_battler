extends GridContainer

const BATTLE_SCENE_BUTTON := preload("res://menus/battle_scene_button.tscn")

var current_skills: Array[Ingress]
var current_skill_index := 0

func _ready() -> void:
	Events.choosing_action_state_entered.connect(_on_choosing_action_state_entered)
	Events.choosing_action_queue_state_entered.connect(_on_choosing_action_queue_state_entered)
	Events.choosing_skill_state_entered.connect(_on_choosing_skill_state_entered)
	Events.choosing_enemy_state_entered.connect(_on_choosing_enemy_state_entered)
	Events.choosing_enemy_all_state_entered.connect(_on_choosing_enemy_all_state_entered)
	Events.is_battling_state_entered.connect(_on_is_battling_state_entered)
	Events.update_info_label_with_skill_description.connect(_on_update_info_label_with_skill_description)

func set_current_skills(player: Node2D, type: Ingress.Type) -> void:
	current_skills = player.skills.filter(func(skill: Ingress) -> bool: return skill.type == type)

func prepare_skill_menu(_handle_choose_skill: Callable) -> void:
	_fill_skill_menu_with_current_skills()
	_connect_skill_button_signals(_handle_choose_skill)
	
func release_focus_from_all_buttons() -> void:
	for child in get_children():
		child.release_focus()

func get_current_skill() -> Ingress:
	return current_skills[current_skill_index]

func get_current_skill_button() -> Button:
	return get_children()[current_skill_index]

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

func _connect_skill_button_signals(_handle_choose_skill: Callable) -> void:
	var skill_buttons := get_children()
	for i in skill_buttons.size():
		var skill := current_skills[i]
		var skill_button := skill_buttons[i]
		skill_button.pressed.connect(_handle_choose_skill.bind(skill))

func _create_skill_desciption(skill: Ingress) -> String:
	return "{0}\nIngress Energy Cost: {1}\nElement: {2}\n{3}".format([
		skill.label,
		skill.ingress,
		Element.get_label(skill.element),
		skill.description
	])

func show_list() -> void:
	show()
	get_children()[0].focus()

# -------
# Signals
# -------

func _on_choosing_action_state_entered() -> void:
	hide()

func _on_choosing_action_queue_state_entered() -> void:
	release_focus_from_all_buttons()

func _on_choosing_skill_state_entered() -> void:
	show_list()

func _on_choosing_enemy_state_entered() -> void:
	release_focus_from_all_buttons()

func _on_choosing_enemy_all_state_entered() -> void:
	release_focus_from_all_buttons()

func _on_is_battling_state_entered() -> void:
	release_focus_from_all_buttons()

func _on_update_info_label_with_skill_description() -> void:
	var skill_buttons := get_children()
	for i in skill_buttons.size():
		if(skill_buttons[i].has_focus()):
			Events.update_info_label.emit(_create_skill_desciption(current_skills[i]))
			current_skill_index = i
