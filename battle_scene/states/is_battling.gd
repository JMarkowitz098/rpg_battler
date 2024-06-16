class_name IsBattling

var change_state: Callable
var holder: ComponentHolder

func _init(init):
	holder = init.holder
	change_state = init.change_state

func enter():
	var action_queue = holder.action_queue
	action_queue.clear_all_focus()
	action_queue.clear_all_turn_focus()
	holder.player_group.clear_turn_focus()
	holder.enemy_group.clear_turn_focus()
	holder.enemy_group.clear_focus()
	holder.info_label.text = ""

func handle_input():
	pass