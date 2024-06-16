class_name IsBattling

func enter():
	Events.is_battling_state_entered.emit()

func handle_input():
	# Doesn't work because process is paused while playing animations
	if Input.is_action_just_pressed("pause"):
		Events.pause_game.emit(State.Type.IS_BATTLING)