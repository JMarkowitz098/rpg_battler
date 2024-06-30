extends Sprite2D
class_name Focus

enum Type{
	FINGER,
	TRIANGLE,
	ALL
}

func focus() -> void:
	show()
	
func unfocus() -> void:
	hide()

func clear() -> void:
	self_modulate = Color("White")
	# self_modulate = Color("94b0da")
	unfocus()
