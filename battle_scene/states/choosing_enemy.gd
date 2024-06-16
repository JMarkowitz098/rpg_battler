class_name ChoosingEnemy

func enter():
	Events.choosing_enemy_state_entered.emit()

func handle_input():
	if Input.is_action_just_pressed("menu_left"):
		Events.update_enemy_group_current.emit(ActionQueue.Direction.LEFT)
			
	if Input.is_action_just_pressed("menu_right"):
		Events.update_enemy_group_current.emit(ActionQueue.Direction.RIGHT)

	if Input.is_action_just_pressed("to_action_queue"):
		Events.change_state.emit(State.Type.CHOOSING_ACTION_QUEUE)
		
	if Input.is_action_just_pressed("menu_accept"):
		Events.choose_enemy.emit()

	if Input.is_action_just_pressed("menu_back"):
		Events.change_state.emit(State.Type.CHOOSING_SKILL)
