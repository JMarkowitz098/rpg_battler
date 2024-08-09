class_name Action

var actor: Node2D
var target: Node2D
var skill: Ingress
var is_focused := false
var is_choosing := false
var action_chosen := false


func _init(init_actor: Node2D, init_target: Node2D = null, init_skill: Ingress = null) -> void:
	actor = init_actor
	target = init_target
	skill = init_skill


func actor_can_damage() -> bool:
	return actor.can_damage()


func get_actor_unique_id() -> String:
	return actor.unique_id.id


func get_target_unique_id() -> String:
	if target:
		return target.unique_id.id
	else:
		return ""


func get_actor_type() -> Player.Type:
	return actor.type


func get_target_type() -> Player.Type:
	return target.type


func get_actor_label() -> String:
	return actor.details.label


func get_target_label() -> String:
	return target.details.label


func has_unique_id(unique_id: String) -> bool:
	if actor.unique_id.id == unique_id: return true
	elif target and target.stats.unique_id == unique_id: return true
	else: return false


func is_player_action() -> bool:
	return get_actor_type() == Player.Type.PLAYER


func is_enemy_action() -> bool:
	return get_actor_type() == Player.Type.ENEMY


func set_skill(attack_skill: Ingress, attack_target: Node2D = null) -> void:
	target = attack_target
	skill = attack_skill
	action_chosen = true


func set_dodge() -> void:
	actor.modifiers.is_dodging = true
	var dodge := load("res://skills/dodge.tres")
	set_skill(dodge)


func set_recover() -> void:
	var recover := load("res://skills/recover.tres")
	set_skill(recover)


func set_modifier(member: Node2D, flag: String, val: Variant) -> void:
	member.set_modifier(flag, val)


func set_enemy_skill(
	incoming_skill: Ingress, battle_groups: BattleGroups, skill_actor: Node2D
) -> void:
	var incoming_target: Node2D = null

	# This is from the enemies perspective
	match incoming_skill.target:
		Ingress.Target.ENEMY:
			incoming_target = battle_groups.get_random_player()
		Ingress.Target.ALLY:
			incoming_target = battle_groups.get_random_enemy()
		Ingress.Target.SELF:
			incoming_target = skill_actor

	set_skill(incoming_skill, incoming_target)
