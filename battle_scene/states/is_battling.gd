class_name IsBattling

var change_state: Callable
var holder: ComponentHolder

func _init(init):
	holder = init.holder
	change_state = init.change_state

func enter():
	Events.is_battling_state_entered.emit()

func handle_input():
	pass