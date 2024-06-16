extends GridContainer

const BATTLE_SCENE_BUTTON = preload("res://menus/battle_scene_button.tscn")

var current_skills: Array[SkillStats]

func _ready():
	Events.choosing_action_state_entered.connect(_on_choosing_action_state_entered)
	Events.choosing_action_queue_state_entered.connect(_on_choosing_action_queue_state_entered)
	Events.choosing_skill_state_entered.connect(_on_choosing_skill_state_entered)
	Events.choosing_enemy_state_entered.connect(_on_choosing_enemy_state_entered)

func set_current_skills(player: Node2D, type: Skill.Type) -> void:
	current_skills = player.skills.filter(func(skill): return skill.type == type)

func prepare_skill_menu(_handle_choose_skill) -> void:
	_fill_skill_menu_with_current_skills()
	_connect_skill_button_signals(_handle_choose_skill)
	
func release_focus_from_all_buttons():
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
	var button = BATTLE_SCENE_BUTTON.instantiate()
	add_child(button)
	button.text = button_text
	button.add_theme_font_size_override("font_size", 10)

func _connect_skill_button_signals(_handle_choose_skill) -> void:
	var skill_buttons := get_children()
	for i in skill_buttons.size():
		var skill = current_skills[i]
		var skill_button = skill_buttons[i]
		skill_button.pressed.connect(_handle_choose_skill.bind(skill))

func show_list():
	show()
	get_children()[0].focus()

# -------
# Signals
# -------

func _on_choosing_action_state_entered():
	hide()

func _on_choosing_action_queue_state_entered():
	release_focus_from_all_buttons()

func _on_choosing_skill_state_entered():
	show_list()

func _on_choosing_enemy_state_entered():
	release_focus_from_all_buttons()
