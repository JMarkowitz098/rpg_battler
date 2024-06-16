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
		change_state.call(State.Type.CHOOSING_ACTION_QUEUE)

func draw_action_button_description(info_label: Label, action_type_index: int):
	if !info_label: return
	match action_type_index:
		0:
			info_label.text = "Use an incursion"
		1: 
			info_label.text = "Use a refrain"
		2: 
			info_label.text = "Attempt to dodge an attack"
