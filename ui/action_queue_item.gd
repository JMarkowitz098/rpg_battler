extends TextureRect
class_name ActionQueueItem

@onready var focus = $Focus
@onready var turn = $Turn

var action: Action

func set_empty_action(player: Node2D):
  action = Action.new(player)
