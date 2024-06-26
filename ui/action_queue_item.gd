extends TextureRect
class_name ActionQueueItem

@onready var icon_focus := $Focus
@onready var turn := $Turn

var action: Action

func set_empty_action(player: Node2D) -> void:
  action = Action.new(player)

func focus() -> void:
  icon_focus.focus()
