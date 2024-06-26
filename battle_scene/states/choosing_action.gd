class_name ChoosingAction

func enter() -> void:
	Events.choosing_action_state_entered.emit()

func handle_input() -> void:
	if Input.is_action_just_pressed("to_action_queue"):
		Events.change_state.emit(State.Type.CHOOSING_ACTION_QUEUE)
	if Input.is_action_just_pressed("pause"):
		Events.pause_game.emit(State.Type.CHOOSING_ACTION)
