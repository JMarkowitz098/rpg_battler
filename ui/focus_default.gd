extends Sprite2D

func focus() -> void:
	show()
	
func unfocus() -> void:
	hide()

func clear() -> void:
	self_modulate = Color("White")
	# self_modulate = Color("94b0da")
	unfocus()
