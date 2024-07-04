extends Button

var ignore_sound := false

@onready var icon_focus := $Focus

@export var focus_offset_x := 0
@export var focus_offset_y := 0
		
func _ready() -> void:
	icon_focus.position = Vector2(size.x + focus_offset_x, size.y + focus_offset_y)
		
func _process(_delta: float) -> void:
	if icon_focus.position.x != size.x:
		icon_focus.position.x = size.x
		
	if has_focus():
		focus()
	else:
		unfocus()
	
func focus(set_ignore := false) -> void:
	if set_ignore: ignore_sound = true
	icon_focus.focus()
	grab_focus()

func focus_no_sound() -> void:
	focus(true)

func unfocus() -> void:
	icon_focus.unfocus()
	release_focus()
	if ignore_sound: ignore_sound = false

func _on_focus_entered() -> void:
	if not ignore_sound:
		Sound.play(Sound.focus)
