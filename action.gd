class_name Action

var actor_stats: CharacterStats
var target_stats: CharacterStats
var skill: Skill
var is_focused:= false
var action_chosen := false

func _init(
	actor: Node2D, 
	target: Node2D = null, 
	init_skill: Skill = null
) -> void:
	actor_stats = actor.stats
	if(target): target_stats = target.stats
	skill = init_skill

func set_attack(target: Node2D = null, attack_skill: Skill = null):
	if (target): target_stats = target.stats
	skill = attack_skill
	action_chosen = true
