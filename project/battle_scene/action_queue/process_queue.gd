class_name ProcessQueue

const INGRESS_ANIMATION = preload("res://skills/ingress_animation.tscn")


func process_action_queue(
	items: Array[ActionQueueItem],
	tree: SceneTree,
	battle_groups: BattleGroups,
	set_battle_process: Callable
) -> void:
	while items.size() > 0:
		var action: Action = items.pop_front().action
		set_battle_process.call(false)
		await _process_skill(action, tree, battle_groups)
		set_battle_process.call(true)


func _process_skill(action: Action, tree: SceneTree, battle_groups: BattleGroups) -> void:
	if not action.actor:
		return
	if action.actor.modifiers.current_ingress - action.skill.ingress <= 0:
		print("Not enough Ingress")
		return
	action.actor.use_ingress(action.skill.ingress)

	match action.skill.id:
		Ingress.Id.INCURSION, Ingress.Id.PIERCING_INCURSION, Ingress.Id.DOUBLE_INCURSION:
			await _use_incursion(action, tree)
			if action.skill.id == Ingress.Id.DOUBLE_INCURSION and action.target.is_alive():
				await tree.create_timer(2).timeout
				await _use_incursion(action, tree)
		Ingress.Id.GROUP_INCURSION:
			await _use_group_incursion(action, battle_groups.enemies)  # Fix to target players when enemy is using
		Ingress.Id.REFRAIN:
			await _use_refrain(action)
		Ingress.Id.GROUP_REFRAIN:
			await _use_group_refrain(action, battle_groups)
		Ingress.Id.MOVEMENT:
			await _use_movement(action)
		Ingress.Id.RECOVER:
			await _use_recover(action)

	await tree.create_timer(2).timeout


func _use_incursion(action: Action, tree: SceneTree) -> void:
	await _play_attack_animation(action)
	await _play_ingress_animation(action, tree)
	var damage := Utils.calculate_skill_damage(action)
	action.target.take_damage(damage)


func _use_group_incursion(action: Action, enemies: Array[Node2D]) -> void:
	await _play_attack_animation(action)
	for enemy in enemies:
		action.target = enemy
		var damage := Utils.calculate_skill_damage(action)
		enemy.take_damage(damage)


func _use_refrain(action: Action) -> void:
	await _play_refrain_animation(action)
	_set_refrain(action.target, action.skill.element)


func _use_group_refrain(action: Action, battle_groups: BattleGroups) -> void:
	await _play_refrain_animation(action)
	var targets := (
		battle_groups.players
		if action.get_actor_type() == Player.Type.PLAYER
		else battle_groups.enemies
	)
	for target in targets:
		_set_refrain(target, action.skill.element)


func _use_movement(action: Action) -> void:
	await _play_refrain_animation(action)
	action.actor.modifiers.plus_agility += action.actor.stats.agility
	action.actor.set_is_eth_dodging(true)
	action.actor.set_dodge_animation(true)


func _use_recover(action: Action) -> void:
	await _play_refrain_animation(action)
	action.actor.use_ingress(-1)


func _play_attack_animation(action: Action) -> void:
	action.actor.base_sprite.hide()
	action.actor.attack_sprite.show()
	action.actor.animation_player.play("attack")
	await action.actor.animation_player.animation_finished
	if action.actor != null:
		action.actor.base_sprite.show()
		action.actor.attack_sprite.hide()
		action.actor.animation_player.play("idle")


func _play_ingress_animation(action: Action, tree: SceneTree) -> void:
	var element: Element.Type = action.skill.element
	var ingress := INGRESS_ANIMATION.instantiate()
	tree.get_root().add_child(ingress)

	ingress.global_position = action.target.global_position
	if action.target.is_player():
		ingress.global_position.x += 10
	else:
		ingress.global_position.x -= 20

	match element:
		Element.Type.SHOR:
			ingress.self_modulate = Color("Blue")
		Element.Type.SCOR:
			ingress.self_modulate = Color(100, 1, 1)  # Red
		Element.Type.ETH:
			ingress.self_modulate = Color("Green")
		Element.Type.ENH:
			ingress.self_modulate = Color(37, 1, 0)  # Orange

	ingress.play()
	await ingress.animation_finished
	ingress.queue_free()


func _play_refrain_animation(action: Action) -> void:
	action.actor.animation_player.play("refrain")
	await action.actor.animation_player.animation_finished
	action.actor.animation_player.play("idle")


func _set_refrain(player: Node2D, skill_element: Element.Type) -> void:
	player.modifiers.has_small_refrain_open = true
	player.modifiers.current_refrain_element = skill_element
	player.refrain_aura.show()

	var refrain_color: Color
	match skill_element:
		Element.Type.ETH:
			refrain_color = Color("Green")
		Element.Type.ENH:
			refrain_color = Color("Orange")
		Element.Type.SCOR:
			refrain_color = Color("Red")
		Element.Type.SHOR:
			refrain_color = Color("Blue")
	player.refrain_aura.modulate = refrain_color
