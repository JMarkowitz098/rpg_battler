extends TextureRect
class_name ActionQueueItem

@onready var triangle_focus := $TriangleFocus
@onready var finger_focus := $FingerFocus

var action: Action

# --------------------
# Initialize Functions
# --------------------

func set_empty_action(player: Node2D) -> void:
	action = Action.new(player)


func set_portrait(player: Node2D) -> void:
	texture = Utils.get_player_portrait(player.details.player_id)
	if(player.is_enemy()): self_modulate = Color("Red")


# --------------------
# Focus Functions
# --------------------


func focus(type: Focus.Type, color: Color = Color.WHITE) -> void:
	match type:
		Focus.Type.FINGER:
			finger_focus.focus(color)
		Focus.Type.TRIANGLE:
			triangle_focus.focus(color)
		Focus.Type.ALL:
			finger_focus.focus(color)
			triangle_focus.focus(color)


func unfocus(type: Focus.Type) -> void:
	match type:
		Focus.Type.FINGER:
			finger_focus.unfocus()
		Focus.Type.TRIANGLE:
			triangle_focus.unfocus()
		Focus.Type.ALL:
			finger_focus.unfocus()
			triangle_focus.unfocus()


# --------------------
# Set and Get Functions
# --------------------


func get_actor() -> Node2D:
	return action.actor


func get_actor_agi() -> int:
	return action.actor.stats.agility


func get_rand_agi() -> int:
	return action.actor.modifiers.rand_agi


func get_actor_unique_id() -> String:
	return action.get_actor_unique_id()


func is_player_action() -> bool:
	return action.actor.is_player()


func set_rand_agi() -> void:
	action.actor.modifiers.rand_agi = get_actor_agi() + randi() % 10


func action_has_unique_id(unique_id: String) -> bool:
	return action.has_unique_id(unique_id)

