extends Button

@onready var icon_focus = $Focus

@export var focus_offset_x = 0
@export var focus_offset_y = 0
		
func _ready():
	icon_focus.position = Vector2(size.x + focus_offset_x, size.y + focus_offset_y)
		
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
