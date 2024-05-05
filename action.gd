class_name Action

var actor_stats: CharacterStats
var target_stats: CharacterStats
var action: String
var is_focused:= false

func _init(
	actor: Node2D, 
	target: Node2D, 
	init_action: String
) -> void:
	actor_stats = actor.stats
	target_stats = target.stats
	action = init_action
