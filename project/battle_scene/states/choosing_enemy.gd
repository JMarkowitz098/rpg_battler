class_name ChoosingEnemy

func enter(_params: StateParams = null) -> void:
	Events.choosing_enemy_state_entered.emit()

func handle_input() -> void:
	if Input.is_action_just_pressed("menu_left"):
		Sound.play(Sound.focus)
		Events.update_enemy_group_current.emit(Direction.Type.LEFT)
			
	if Input.is_action_just_pressed("menu_right"):
		Sound.play(Sound.focus)
		Events.update_enemy_group_current.emit(Direction.Type.RIGHT)

	if Input.is_action_just_pressed("to_action_queue"):
		Sound.play(Sound.focus)
		Events.change_state.emit(State.Type.CHOOSING_ACTION_QUEUE)
		
	if Input.is_action_just_pressed("menu_accept"):
		Sound.play(Sound.confirm)
		Events.choose_enemy.emit()

	if Input.is_action_just_pressed("menu_back"):
		Sound.play(Sound.focus)
		Events.change_state.emit(State.Type.CHOOSING_SKILL)
	
	if Input.is_action_just_pressed("pause"):
		Sound.play(Sound.focus)
		Events.pause_game.emit(State.Type.CHOOSING_ENEMY)
