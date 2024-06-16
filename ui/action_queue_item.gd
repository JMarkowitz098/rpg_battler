extends TextureRect
class_name ActionQueueItem

@onready var icon_focus = $Focus
@onready var turn = $Turn

var action: Action

func set_empty_action(player: Node2D):
  action = Action.new(player)

func focus():
  icon_focus.focus()
