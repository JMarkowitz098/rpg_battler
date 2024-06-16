class_name ChoosingEnemy

var change_state: Callable
var holder: ComponentHolder

func _init(init):
	holder = init.holder
	change_state = init.change_state

func enter():
	Events.choosing_enemy_state_entered.emit()

func handle_input():
	var action_queue = holder.action_queue
	var enemy_group = holder.enemy_group
	var enemies = holder.enemy_group.enemies

	if Input.is_action_just_pressed("menu_left"):
		var new_enemy_index = (action_queue.enemy_index - 1) % enemies.size()
		enemy_group.switch_focus(new_enemy_index, action_queue.enemy_index)
		action_queue.enemy_index = new_enemy_index
			
	if Input.is_action_just_pressed("menu_right"):
		var new_enemy_index = (action_queue.enemy_index + 1) % enemies.size()
		enemy_group.switch_focus(new_enemy_index, action_queue.enemy_index)
		action_queue.enemy_index = new_enemy_index

	if Input.is_action_just_pressed("to_action_queue"):
		change_state.call(State.Type.CHOOSING_ACTION_QUEUE)
		
	if Input.is_action_just_pressed("menu_accept"):
		# Factor into action_queue
		holder.action_queue.update_player_action_with_skill(
			holder.player_group.players, 
			holder.enemy_group.enemies, 
			holder.current_skill
		)
		
		if !holder.action_queue.is_turn_over():
			holder.action_queue.next_player()
			change_state.call(State.Type.CHOOSING_ACTION)
		else:
			change_state.call(State.Type.IS_BATTLING)
		
	if Input.is_action_just_pressed("menu_back"):
		change_state.call(State.Type.CHOOSING_SKILL)
