class_name ChoosingSkill

var change_state: Callable
var holder: ComponentHolder

func _init(init):
	holder = init.holder
	change_state = init.change_state

func enter():
	Events.choosing_skill_state_entered.emit()

func handle_input():
	var skills := holder.skill_choice_list.current_skills as Array[SkillStats]
	var skill_buttons = holder.skill_choice_list.get_children()

	for i in skill_buttons.size():
		var skill_button = skill_buttons[i]
		if(skill_button.has_focus()):
			holder.current_skill_button = skill_button
			_draw_skill_desciption(skills[i])
			skill_button.focus()
		else:
			skill_button.unfocus()


	if Input.is_action_just_pressed("to_action_queue"):
		change_state.call(State.Type.CHOOSING_ACTION_QUEUE)
		
	if Input.is_action_just_pressed("menu_back"):
		holder.skill_choice_list.hide()
		change_state.call(State.Type.CHOOSING_ACTION)

func _draw_skill_desciption(skill: SkillStats):
	holder.info_label.text  = "Ingress Energy Cost: {0}\nElement: {1}\n{2}".format([
		skill.ingress,
		Stats.get_element_label(skill.element),
		skill.description
	])
