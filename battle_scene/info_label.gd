extends Label

func _ready():
	Events.is_battling_state_entered.connect(_on_is_battling_state_entered)
	Events.update_info_label.connect(_on_update_info_label)

func clear():
	text = ""

func draw_action_button_description(action_type_index: int):
	match action_type_index:
		0:
			text = "Use an incursion"
		1: 
			text = "Use a refrain"
		2: 
			text = "Attempt to dodge an attack"
	
func _on_is_battling_state_entered():
	clear()

func _on_update_info_label(new_message):
	text = new_message
