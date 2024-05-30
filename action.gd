class_name Action

var actor: Node2D
var target: Node2D
var skill: Skill
var is_focused:= false
var action_chosen := false

func _init(
	init_actor: Node2D, 
	init_target: Node2D = null, 
	init_skill: Skill = null
) -> void:
	actor = init_actor
	if(init_target): target = init_target
	skill = init_skill

func set_attack(attack_target: Node2D = null, attack_skill: Skill = null):
	if (attack_target): target = attack_target
	skill = attack_skill
	action_chosen = true
