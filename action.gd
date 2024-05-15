class_name Action

enum Type {ATTACK, DEFEND, SKILL, NONE}

var actor_stats: CharacterStats
var target_stats: CharacterStats
var type: Type
var skill: Skill
var is_focused:= false

func _init(
	actor: Node2D, 
	target: Node2D, 
	init_type: Type,
	init_skill: Skill = null
) -> void:
	actor_stats = actor.stats
	target_stats = target.stats
	type = init_type
	skill = init_skill
