class_name ChoosingSkill

var change_state: Callable
var holder: ComponentHolder

func _init(init):
	holder = init.holder
	change_state = init.change_state

func enter():
	var skill_ui = holder.skill_ui
	skill_ui.set_current_skills(
		holder.player_group.players[holder.action_queue.player_index], 
		holder.current_skill_type)
	holder.action_type.hide()
	skill_ui.prepare_skill_menu(_handle_choose_skill)
	skill_ui.show_skill_choice_list()

	# Factor into action queue
	var current_player = holder.player_group.players[holder.action_queue.player_index]
	var index = holder.action_queue.get_action_index_by_unique_id(current_player.stats.unique_id)
	holder.action_queue.set_turn_focus(index)

func handle_input():
	var skills := holder.skill_ui.current_skills as Array[SkillStats]
	var skill_buttons = holder.skill_ui.skill_menu.get_children()

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

func _handle_choose_skill(skill: SkillStats):
	holder.current_skill = skill
	for child in holder.skill_choice_list.get_children():
		child.unfocus()
		
	match holder.current_skill.target:
		Skill.Target.ENEMY:
			change_state.call(State.Type.CHOOSING_ENEMY)
			return
		Skill.Target.SELF:
			# Factor into action_queue
			holder.action_queue.update_player_action_with_skill(
			holder.player_group.players, 
			holder.enemy_group.enemies, 
			holder.current_skill
		)
			holder.action_queue.next_player()
			change_state.call(State.Type.CHOOSING_ACTION)
			return

func _draw_skill_desciption(skill: SkillStats):
	holder.info_label.text  = "Ingress Energy Cost: {0}\nElement: {1}\n{2}".format([
		skill.ingress,
		Stats.get_element_label(skill.element),
		skill.description
	])
