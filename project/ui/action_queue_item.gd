extends TextureRect
class_name ActionQueueItem

@onready var triangle_focus := $TriangleFocus
@onready var finger_focus := $FingerFocus

var action: Action

func set_empty_action(player: Node2D) -> void:
	action = Action.new(player)

func focus(type: Focus.Type) -> void:
	match type:
		Focus.Type.FINGER:
			finger_focus.focus()
		Focus.Type.TRIANGLE:
			triangle_focus.focus()
		Focus.Type.ALL:
			finger_focus.focus()
			triangle_focus.focus()

func unfocus(type: Focus.Type) -> void:
	match type:
		Focus.Type.FINGER:
			finger_focus.unfocus()
		Focus.Type.TRIANGLE:
			triangle_focus.unfocus()
		Focus.Type.ALL:
			finger_focus.unfocus()
			triangle_focus.unfocus()
