extends Button

@onready var icon_focus = $Focus
		
func _ready():
	icon_focus.position = Vector2(size.x, size.y)
	focus()
		
func _process(_delta):
	if icon_focus.position.x != size.x:
		icon_focus.position.x = size.x
		
	if has_focus():
		focus()
	else:
		unfocus()
	
func focus():
	icon_focus.focus()
	grab_focus()

func unfocus():
	icon_focus.unfocus()
	release_focus()
