extends GridContainer

func _ready():
	Events.choosing_action_state_entered.connect(_on_choosing_action_state_entered)
	Events.choosing_action_queue_state_entered.connect(_on_choosing_action_queue_state_entered)
	Events.choosing_skill_state_entered.connect(_on_choosing_skill_state_entered)

func clear_focus():
	for child in get_children():
		child.unfocus()

func _on_choosing_action_state_entered():
	show()

func _on_choosing_action_queue_state_entered():
	clear_focus()

func _on_choosing_skill_state_entered():
	hide()
