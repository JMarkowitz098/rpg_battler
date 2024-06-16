class_name ChoosingSkill

var change_state: Callable
var holder: ComponentHolder

func _init(init):
	holder = init.holder
	change_state = init.change_state

func enter():
	Events.choosing_skill_state_entered.emit()

func handle_input():
	Events.update_info_label_with_skill_description.emit()

	if Input.is_action_just_pressed("to_action_queue"):
		Events.change_state.emit(State.Type.CHOOSING_ACTION_QUEUE)
		
	if Input.is_action_just_pressed("menu_back"):
		Events.change_state.emit(State.Type.CHOOSING_ACTION)
