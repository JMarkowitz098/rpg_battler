extends Sprite2D
class_name Focus

enum Type{
	FINGER,
	TRIANGLE,
	ALL
}

func focus(new_color: Color = Color.WHITE) -> void:
	self_modulate = new_color
	show()
	
func unfocus() -> void:
	hide()

func clear() -> void:
	self_modulate = Color.WHITE
	unfocus()


static func color(target: Ingress.Target) -> Color:
	match target:
		Ingress.Target.ENEMY, Ingress.Target.ALL_ENEMIES:
			return Color.RED
		Ingress.Target.SELF, Ingress.Target.ALLY, Ingress.Target.ALL_ALLIES:
			return Color.GREEN
		_:
			return Color.WHITE
