class_name ChoosingSkill

func enter():
	Events.choosing_skill_state_entered.emit()

func handle_input():
	Events.update_info_label_with_skill_description.emit()

	if Input.is_action_just_pressed("to_action_queue"):
		Events.change_state.emit(State.Type.CHOOSING_ACTION_QUEUE)
		
	if Input.is_action_just_pressed("menu_back"):
		Events.change_state.emit(State.Type.CHOOSING_ACTION)

	if Input.is_action_just_pressed("pause"):
		Events.pause_game.emit(State.Type.CHOOSING_SKILL)
