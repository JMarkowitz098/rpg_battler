class_name ChoosingAllyAll

func enter(_params: StateParams = null) -> void:
	Events.choosing_ally_all_state_entered.emit()

func handle_input() -> void:
	if Input.is_action_just_pressed("to_action_queue"):
		Sound.play(Sound.focus)
		Events.change_state.emit(State.Type.CHOOSING_ACTION_QUEUE)
		
	if Input.is_action_just_pressed("menu_accept"):
		Sound.play(Sound.confirm)
		Events.choose_ally.emit()

	if Input.is_action_just_pressed("menu_back"):
		Sound.play(Sound.focus)
		Events.change_state.emit(State.Type.CHOOSING_SKILL)
	
	if Input.is_action_just_pressed("pause"):
		Sound.play(Sound.focus)
		Events.pause_game.emit(State.Type.CHOOSING_ALLY_ALL)