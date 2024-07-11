extends TextureRect
class_name ActionQueueItem

@onready var triangle_focus := $TriangleFocus
@onready var finger_focus := $FingerFocus

var action: Action

func get_actor_agi() -> int:
	return action.actor.stats.level_stats.agility


func get_rand_agi() -> int:
	return action.actor.stats.rand_agi


func get_actor_unique_id() -> String:
	return action.get_actor_unique_id()


func is_player_action() -> bool:
	return action.actor.is_player()


func set_rand_agi() -> void:
	action.actor.stats.rand_agi = get_actor_agi() + randi() % 10


func set_empty_action(player: Node2D) -> void:
	action = Action.new(player)

func action_has_unique_id(unique_id: String) -> bool:
	return action.has_unique_id(unique_id)

func set_portrait(player: Node2D) -> void:
	texture = Utils.get_player_portrait(player.stats.player_details.player_id)
	if(player.is_enemy()): self_modulate = Color("Red")


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
