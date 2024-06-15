extends HBoxContainer
class_name ActionQueue

var items: Array[ActionQueueItem] = []
var enemy_index := 0
var player_index := 0
var action_index := 0

const ACTION_QUEUE_ITEM = preload("res://ui/action_queue_item.tscn")
const NASH_PORTRAIT := preload("res://players/Nash/NashPortrait.jpeg")
const TALON_PORTRAIT := preload("res://players/Talon/TalonPortrait.jpeg")

func update_action_queue(action_list: HBoxContainer) -> void:
	pass
	# for child in action_list.get_children():
	# 	child.queue_free()
		
	# for item in items:
	# 	var portrait
	# 	match action.actor.stats.player_details.player_id:
	# 		Stats.PlayerId.TALON:
	# 			portrait = TALON_PORTRAIT
	# 		Stats.PlayerId.NASH:
	# 			portrait = NASH_PORTRAIT
	# 		_:
	# 			portrait = TALON_PORTRAIT
				
	# 	var list_item = ACTION_QUEUE_ITEM.instantiate()
	# 	list_item.texture = portrait
	# 	if action.actor.stats.player_details.icon_type == Stats.IconType.ENEMY:
	# 		list_item.self_modulate = Color("ff1c00")
		# if(action.is_focused): list_item.get_node("Focus").focus()
		# if(action.is_choosing): list_item.get_node("Turn").show()
		# action_list.add_child(list_item)

func process_action_queue(tree: SceneTree, players = null, enemies = null) -> void:
	while items.size() > 0:
		var action = items.pop_front()
		await _process_skill(action, tree, players, enemies)

func fill_initial_turn_items(players: Array[Node2D], enemies: Array[Node2D]):
	_queue_empty_items(players)
	_queue_empty_items(enemies)
	_sort_items_by_agility()
	_fill_enemy_actions(players)
	for item in items:
		add_child(item)

func _is_player_action(action: Action) -> bool:
	return action.actor.stats.player_details.icon_type == Stats.IconType.PLAYER

func _is_choosing_player(action: Action, choosing_player: Node2D) -> bool:
	return action.actor.stats.unique_id == choosing_player.stats.unique_id


func is_turn_over():
	return items.all(func(item): return item.action.action_chosen)
		
func reset_indexes() -> void:
	enemy_index = 0
	player_index = 0
	action_index = 0
	
func size() -> int:
	return items.size()
	
# func push_back(action: Action) -> void:
# 	items.push_back(action)
	
# func push_front(action: Action) -> void:
# 	items.push_front(action)
	
# func insert(index: int, action: Action) -> void:
# 	items.insert(index, action)
	
func get_current_item() -> ActionQueueItem:
	return items[action_index]

func set_focus(index: int) -> void:
	items[index].focus.focus()

func set_turn_focus(index: int) -> void:
	items[index].turn.focus()


func update_player_action_with_skill(players, enemies, skill):
	var current_player_id = players[player_index].stats.unique_id
	var action_to_update = items.filter(func(action): 
		return action.actor.stats.unique_id == current_player_id)[0]
	if skill.target == Skill.Target.SELF:
		action_to_update.set_attack(null, skill)
	else:
		action_to_update.set_attack(enemies[enemy_index], skill)
		
	
func next_player(players) -> void:
	player_index += 1
	action_index = 0
	
func remove_action_by_character_id(id: String) -> void:
	items = items.filter(
		func(action): 
			var action_matches = false
			if action.target and action.target.stats.unique_id == id:
				action_matches = true
			if action.actor.stats.unique_id == id:
				action_matches = true
			return !action_matches)
			
func create_action_message(action: Action) -> String:
	var message = "Player: " + action.actor.player_name.text
	if action.skill:
		message += "\nAction: " + action.skill.label
	if action.target:
		message += "\nTarget -> " + action.target.player_name.text
	return message

func _queue_empty_items(players: Array[Node2D]):
	for player in players:
		var new_item = ACTION_QUEUE_ITEM.instantiate()
		new_item.set_empty_action(player)
		new_item.texture = _get_protrait(player.stats.player_details.player_id)
		if(player.stats.player_details.icon_type == Stats.IconType.ENEMY):
			new_item.self_modulate = Color("Red")
		items.push_back(new_item)

func _fill_enemy_actions(players: Array[Node2D]):
	for item in items:
		var action := item.action
		if(action.actor.stats.player_details.icon_type == Stats.IconType.ENEMY):
			if action.actor.stats.current_ingress == 1:
				action.set_dodge()
			else:
				var enemy_skill = _select_enemy_skill(action.actor.stats.level_stats.skills)
				action.set_enemy_skill(enemy_skill, players)
				
func _set_dodge(action: Action):
	action.actor.stats.is_dodging = true
	action.set_attack(null, Skill.create_skill_instance(Skill.Id.DODGE))

func _select_enemy_skill(skill_ids: Array) -> SkillStats:
	var rand_skill_i = randi() % skill_ids.size()
	return Skill.create_skill_instance(skill_ids[rand_skill_i])
				
func _process_skill(action: Action, tree: SceneTree, players = null, enemies = null) -> void:
	action.actor.stats.use_ingress_energy(action.skill.ingress)
	if action.actor.stats.current_ingress <= 0:
		return

	match action.skill.id: 
		Skill.Id.ETH_INCURSION, Skill.Id.ENH_INCURSION, Skill.Id.SCOR_INCURSION, Skill.Id.SHOR_INCURSION:
			await _use_incursion(action, tree)
			
		Skill.Id.ETH_INCURSION_DOUBLE, Skill.Id.SHOR_INCURSION_DOUBLE:
			await _use_incursion(action, tree)
			await tree.create_timer(2).timeout
			if action.target != null:
				_use_incursion(action, tree)
				await tree.create_timer(2).timeout
				
		Skill.Id.ETH_REFRAIN, Skill.Id.ENH_REFRAIN, Skill.Id.SHOR_REFRAIN, Skill.Id.SCOR_REFRAIN:
			await _play_refrain_animation(action, tree)
			_set_refrain(action.actor, action.skill.element)
			
		Skill.Id.ETH_REFRAIN_GROUP, Skill.Id.SHOR_REFRAIN_GROUP, Skill.Id.SCOR_REFRAIN_GROUP:
			await _play_refrain_animation(action, tree)
			var target_players = players if action.actor.stats.player_details.icon_type == Stats.IconType.PLAYER else enemies
			for player in target_players:
				_set_refrain(player, action.skill.element)
				
	if action.skill.id != Skill.Id.DODGE:
		await tree.create_timer(2).timeout
		
func _use_incursion(action: Action, tree: SceneTree):
	await _play_attack_animation(action, tree)
	var damage = Utils.calucluate_skill_damage(action)
	action.target.stats.take_damage(damage)
		
func _play_attack_animation(action: Action, tree: SceneTree) -> void:
	action.actor.base_sprite.hide()
	action.actor.attack_sprite.show()
	action.actor.animation_player.play("attack")
	await tree.create_timer(2.2).timeout
	if(action.actor != null):
		action.actor.base_sprite.show()
		action.actor.attack_sprite.hide()
		action.actor.animation_player.play("idle")

func _play_refrain_animation(action: Action, tree: SceneTree):
	action.actor.animation_player.play("refrain")
	await tree.create_timer(1).timeout
	action.actor.animation_player.play("idle")
		
func _set_refrain(player: Node2D, skill_element):
	player.stats.has_small_refrain_open = true
	player.stats.current_refrain_element = skill_element
	player.refrain_aura.show()
	match skill_element:
		Stats.Element.ETH:
			player.refrain_aura.modulate = Color("Green")
		Stats.Element.ENH:
			player.refrain_aura.modulate = Color("Orange")
		Stats.Element.SCOR:
			player.refrain_aura.modulate = Color("Red")
		Stats.Element.SHOR:
			player.refrain_aura.modulate = Color("Blue")

func _sort_items_by_agility():
	for item in items:
		item.action.actor.stats.rand_agi = item.action.actor.stats.level_stats.agility + randi() % 10 
	items.sort_custom(func(a, b): 
		return a.action.actor.stats.rand_agi  > b.action.actor.stats.rand_agi )
	
func clear_all_turn_focus():
	for item in items:
		item.turn.clear()

func clear_all_focus():
	for item in items:
		item.focus.clear()

func set_focuses():
	var item := get_current_item()
	var action: Action = item.action
	action.actor.turn.focus()
	item.focus.focus()
	
	if action.target:
		action.target.turn.self_modulate = Color("Red")
		action.target.find_child("Turn").focus()
	elif action.skill and action.skill.target == Skill.Target.SELF:
		action.actor.find_child("Turn").self_modulate = Color("Green")

func get_action_index_by_unique_id(unique_id: String) -> int:
	for i in items.size():
		var action = items[i].action
		if action.actor.stats.unique_id == unique_id:
			return i
	return 0

func _get_protrait(player_id: Stats.PlayerId):
	match player_id:
		Stats.PlayerId.TALON:
			return TALON_PORTRAIT
		Stats.PlayerId.NASH:
			return NASH_PORTRAIT
		_:
			return TALON_PORTRAIT
