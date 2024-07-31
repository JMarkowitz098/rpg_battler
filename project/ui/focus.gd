extends Sprite2D
class_name Focus

enum Type{
	FINGER,
	TRIANGLE,
	ALL
}

func focus(color: Color = Color.WHITE) -> void:
	self_modulate = color
	show()
	
func unfocus() -> void:
	hide()

func clear() -> void:
	self_modulate = Color.WHITE
	unfocus()
