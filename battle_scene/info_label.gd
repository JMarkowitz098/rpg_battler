extends Label

func _ready() -> void:
	Events.is_battling_state_entered.connect(_on_is_battling_state_entered)
	Events.update_info_label.connect(_on_update_info_label)

func clear() -> void:
	text = ""

func draw_action_button_description(action_type_index: int) -> void:
	match action_type_index:
		0:
			text = "Use an incursion"
		1: 
			text = "Use a refrain"
		2: 
			text = "Recover 1 Ingress. Small chance to dodge attack."
	
func _on_is_battling_state_entered() -> void:
	clear()

func _on_update_info_label(new_message: String) -> void:
	text = new_message
