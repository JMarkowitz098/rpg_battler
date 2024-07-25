extends GridContainer

@onready var incursion := $Incursion
@onready var refrain := $Refrain
@onready var recover := $Recover

var current_button: Button

func _ready() -> void:
	var signals := [
		["choosing_action_state_entered",_on_choosing_action_state_entered],
		["choosing_action_queue_state_entered",_on_choosing_action_queue_state_entered],
		["choosing_skill_state_entered",_on_choosing_skill_state_entered],
		["is_battling_state_entered",_on_is_battling_state_entered]
	]

	Utils.connect_signals(signals)

func clear_focus() -> void:
	for child in get_children():
		child.unfocus()

func _on_choosing_action_state_entered(params: StateParams = null) -> void:
	show()
	if params and params.button: current_button = params.button
	elif !current_button: current_button = incursion
	current_button.focus(true)

func _on_choosing_action_queue_state_entered() -> void:
	clear_focus()

func _on_choosing_skill_state_entered() -> void:
	hide()

func _on_is_battling_state_entered() -> void:
	clear_focus()


func _on_incursion_focus_entered() -> void:
	current_button = incursion


func _on_refrain_focus_entered() -> void:
	current_button = refrain


func _on_recover_focus_entered() -> void:
	current_button = recover
