extends Node
class_name ChoosingActionQueue

var change_state: Callable
var change_to_previous_state: Callable

func enter() -> void:
	Events.choosing_action_queue_state_entered.emit()
	
func handle_input() -> void:
	Events.enter_action_queue_handle_input.emit()

	if Input.is_action_just_pressed("menu_right"):
		Events.update_action_index.emit(Direction.Type.RIGHT)
		
	if Input.is_action_just_pressed("menu_left"):
		Events.update_action_index.emit(Direction.Type.LEFT)

	if Input.is_action_just_pressed("menu_back") or Input.is_action_just_pressed("to_action_queue"):
		Events.change_to_previous_state.emit()
		return

	if Input.is_action_just_pressed("pause"):
		Events.pause_game.emit(State.Type.CHOOSING_ACTION_QUEUE)
		return

	Events.update_action_queue_focuses.emit()
