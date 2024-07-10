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

func get_actor_unique_id() -> String:
	return actor.stats.unique_id

func get_target_unique_id() -> String:
	if target: 
		return target.stats.unique_id
	else:
		return ""

func set_target(attack_target: Node2D = null, attack_skill: Ingress = null) -> void:
	if (attack_target): target = attack_target
	skill = attack_skill
	action_chosen = true

func set_dodge() -> void:
	actor.stats.is_dodging = true
	var dodge := load("res://skills/dodge.tres")
	set_target(null, dodge)

func set_recover() -> void:
	var recover := load("res://skills/recover.tres")
	set_target(null, recover)

func set_enemy_skill(incoming_skill: Ingress, players: Array[Node2D], enemies: Array[Node2D], skill_actor: Node2D) -> void:
	var incoming_target: Node2D = null
	if incoming_skill.target == Ingress.Target.ENEMY:
		incoming_target = players[randi() % players.size()]
	elif incoming_skill.target == Ingress.Target.ALLY:
		incoming_target = enemies[randi() % enemies.size()]
	elif incoming_skill.target == Ingress.Target.SELF:
		incoming_target = skill_actor
	set_target(incoming_target, incoming_skill)
