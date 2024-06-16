extends Sprite2D

func focus():
	show()
	
func unfocus():
	hide()

func clear():
	self_modulate = Color("White")
	# self_modulate = Color("94b0da")
	unfocus()
