extends GridContainer

func _ready() -> void:
	Events.choosing_action_state_entered.connect(_on_choosing_action_state_entered)
	Events.choosing_action_queue_state_entered.connect(_on_choosing_action_queue_state_entered)
	Events.choosing_skill_state_entered.connect(_on_choosing_skill_state_entered)
	Events.is_battling_state_entered.connect(_on_is_battling_state_entered)

func clear_focus() -> void:
	for child in get_children():
		child.unfocus()

func _on_choosing_action_state_entered() -> void:
	show()

func _on_choosing_action_queue_state_entered() -> void:
	clear_focus()

func _on_choosing_skill_state_entered() -> void:
	hide()

func _on_is_battling_state_entered() -> void:
	clear_focus()
