class_name ChoosingAction

func enter():
	Events.choosing_action_state_entered.emit()

func handle_input():
	if Input.is_action_just_pressed("to_action_queue"):
		Events.change_state.emit(State.Type.CHOOSING_ACTION_QUEUE)
