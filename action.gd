class_name Action

var actor: Node2D
var target: Node2D
var skill: Ingress
var is_focused:= false
var is_choosing := false
var action_chosen := false

func _init(
	init_actor: Node2D, 
	init_target: Node2D = null, 
	init_skill: Ingress = null
) -> void:
	actor = init_actor
	if(init_target): target = init_target
	skill = init_skill

func set_attack(attack_target: Node2D = null, attack_skill: Ingress = null) -> void:
	if (attack_target): target = attack_target
	skill = attack_skill
	action_chosen = true

func set_dodge() -> void:
	actor.stats.is_dodging = true
	var dodge := load("res://skills/dodge.tres")
	set_attack(null, dodge)

func set_enemy_skill(incoming_skill: Ingress, players: Array[Node2D]) -> void:
	var incoming_target: Node2D = null
	if incoming_skill.target == Ingress.Target.ENEMY:
		incoming_target = players[randi() % players.size()]
	set_attack(incoming_target, incoming_skill)
