extends Node
class_name ChoosingActionQueue

var change_state: Callable
var change_to_previous_state: Callable
var holder = ComponentHolder

func enter():
	holder.action_queue.set_focus(0)
	holder.action_type.clear_focus()
	holder.player_group.clear_focus()
	holder.player_group.clear_turn_focus()
	holder.skill_ui.release_focus_from_all_buttons()
	holder.enemy_group.clear_focus()
	
func _init(init):
	change_state = init.change_state
	change_to_previous_state = init.change_to_previous_state
	holder = init.holder
	
func handle_input():
	var action_queue = holder.action_queue
	var action = action_queue.get_current_item().action
	action_queue.clear_all_focus()
	action_queue.clear_all_turn_focus()
	holder.player_group.clear_turn_focus()
	holder.enemy_group.clear_turn_focus()

	if Input.is_action_just_pressed("menu_right"):
		action_queue.action_index = (action_queue.action_index + 1) % action_queue.size()
		
	if Input.is_action_just_pressed("menu_left"):
		if action_queue.action_index == 0:
			action_queue.action_index = action_queue.size() - 1
		else:
			action_queue.action_index = action_queue.action_index - 1
	
	if Input.is_action_just_pressed("menu_back") or Input.is_action_just_pressed("to_action_queue"):
		change_to_previous_state.call()
		return

	holder.info_label.text = action_queue.create_action_message(action)
	action = action_queue.get_current_item()
	action_queue.set_focuses()
