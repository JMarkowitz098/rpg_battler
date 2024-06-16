class_name ChoosingAction

var change_state: Callable
var holder: ComponentHolder

func _init(init):
	holder = init.holder
	change_state = init.change_state

func enter():
	Events.choosing_action_state_entered.emit()

func handle_input():
	if Input.is_action_just_pressed("to_action_queue"):
		Events.change_state.emit(State.Type.CHOOSING_ACTION_QUEUE)
