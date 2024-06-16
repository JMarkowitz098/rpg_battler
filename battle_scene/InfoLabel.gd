extends Label

func _ready():
	Events.is_battling_state_entered.connect(_on_is_battling_state_entered)

func clear():
	text = ""
	
func _on_is_battling_state_entered():
	clear()
