class_name Action

var actor: Node2D
var target: Node2D
var skill: SkillStats
var is_focused:= false
var is_choosing := false
var action_chosen := false

func _init(
	init_actor: Node2D, 
	init_target: Node2D = null, 
	init_skill: SkillStats = null
) -> void:
	actor = init_actor
	if(init_target): target = init_target
	skill = init_skill

func set_attack(attack_target: Node2D = null, attack_skill: SkillStats = null):
	if (attack_target): target = attack_target
	skill = attack_skill
	action_chosen = true

func set_dodge():
	actor.stats.is_dodging = true
	set_attack(null, Skill.create_skill_instance(Skill.Id.DODGE))

func set_enemy_skill(incoming_skill: SkillStats, players: Array[Node2D]):
	var incoming_target = null
	if incoming_skill.target == Skill.Target.ENEMY:
		incoming_target = players[randi() % players.size()]
	set_attack(incoming_target, incoming_skill)