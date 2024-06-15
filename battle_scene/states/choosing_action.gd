class_name ChoosingAction

var change_state: Callable
var holder: ComponentHolder

func _init(init):
	holder = init.holder
	change_state = init.change_state

func enter():
	holder.action_type.show()
	holder.current_action_button.focus()

	var action_queue = holder.action_queue
	action_queue.clear_all_focus()
	action_queue.clear_all_turn_focus()
	holder.player_group.clear_turn_focus()
	holder.enemy_group.clear_turn_focus()
	holder.enemy_group.clear_focus()
	
	# Refactor into action queue
	var current_player = holder.player_group.players[action_queue.player_index]
	current_player.turn.focus()
	var index = holder.action_queue.get_action_index_by_unique_id(current_player.stats.unique_id)
	holder.action_queue.set_turn_focus(index)

	holder.skill_choice_list.hide()


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
