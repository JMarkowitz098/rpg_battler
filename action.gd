class_name Action

enum Type {ATTACK, DEFEND, SKILL, NONE}

var actor_stats: CharacterStats
var target_stats: CharacterStats
var type: Type
var skill: Skill
var is_focused:= false
var action_chosen := false

func _init(
	actor: Node2D, 
	target: Node2D = null, 
	init_type: Type = Type.NONE,
	init_skill: Skill = null
) -> void:
	actor_stats = actor.stats
	if(target): target_stats = target.stats
	type = init_type
	skill = init_skill

func set_attack(target: Node2D, attack_type: Action.Type, attack_skill: Skill =null):
	target_stats = target.stats
	type = attack_type
	skill = attack_skill
	action_chosen = true
