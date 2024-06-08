class_name SkillMenuUi

const SKILL_BUTTON = preload("res://menus/skill_button.tscn")

var skill_menu: GridContainer
var current_skills: Array[Node]

func _init(skill_menu_orig) -> void:
	skill_menu = skill_menu_orig

func set_current_skills(player: Node2D, skill_type: Skill.Type) -> void: 
	current_skills = player.get_skills(skill_type)

func prepare_skill_menu(_handle_choose_skill, action_type: GridContainer) -> void:
	_fill_skill_menu_with_current_skills()
	_connect_skill_button_signals(_handle_choose_skill)
	_show_skill_choice_list(action_type)
	
func release_focus_from_all_buttons():
	for child in skill_menu.get_children():
		child.release_focus()

func _fill_skill_menu_with_current_skills() -> void:
	for child in skill_menu.get_children():
		# queue_free is deferred until end of frame, so we remove node from list
		# to prevent indexing issues while turn is processing
		skill_menu.remove_child(child)
		child.queue_free()
		
	for skill in current_skills:
		_create_button_choice(skill.label)

func _create_button_choice(button_text: String) -> void:
	var button = SKILL_BUTTON.instantiate()
	button.text = button_text
	skill_menu.add_child(button)

func _connect_skill_button_signals(_handle_choose_skill) -> void:
	var skill_buttons := skill_menu.get_children()
	for i in skill_buttons.size():
		var skill = current_skills[i]
		var skill_button = skill_buttons[i]
		skill_button.pressed.connect(_handle_choose_skill.bind(skill))

func _show_skill_choice_list(action_type: GridContainer):
	action_type.hide()
	skill_menu.show()
	skill_menu.get_children()[0].grab_focus()
