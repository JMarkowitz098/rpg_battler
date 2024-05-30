class_name ActionQueue
extends Node

var queue: Array[Action] = []
var enemy_index := 0
var player_index := 0
var action_index := 0

const ActionListItemScene := preload("res://ui/action_list_item.tscn")

func draw_action_queue(action_list: HBoxContainer) -> void:
	for child in action_list.get_children():
		child.queue_free()
		
	for action in queue:
		var message: String
		match action.actor.stats.icon_type:
			CharacterStats.IconType.PLAYER:
				message = "O"
			CharacterStats.IconType.ENEMY:
				message = "X"
			_:
				message = "_"
				
		var list_item = ActionListItemScene.instantiate()
		list_item.get_node("Label").text = message
		if(action.is_focused): list_item.get_node("Focus").focus()
		action_list.add_child(list_item)

func process_action_queue(tree: SceneTree) -> void:
	while queue.size() > 0:
		var action = queue.pop_front()
		await _process_skill(action, tree)

func queue_initial_turn_actions(players: Array[Node2D], enemies: Array[Node2D]):
	_queue_empty_actions(players)
	_queue_empty_actions(enemies)
	_sort_queue_by_agility()
	_fill_enemy_actions(players)

func is_turn_over():
	return queue.all(func(action): return action.action_chosen)
		
func reset_indexes() -> void:
	enemy_index = 0
	player_index = 0
	action_index = 0
	
func size() -> int:
	return queue.size()
	
func push_back(action: Action) -> void:
	queue.push_back(action)
	
func push_front(action: Action) -> void:
	queue.push_front(action)
	
func insert(index: int, action: Action) -> void:
	queue.insert(index, action)
	
func get_current_action() -> Action:
	return queue[action_index]

func set_focus(index: int, value: bool) -> void:
	queue[index].is_focused = value


func update_player_action_with_skill(players, enemies, skill):
	var current_player_id = players[player_index].stats.unique_id
	var action_to_update = queue.filter(func(action): 
		return action.actor.stats.unique_id == current_player_id)[0]
	action_to_update.set_attack(enemies[enemy_index], skill)
	
func next_player() -> void:
	player_index += 1
	action_index = 0
	
func remove_action_by_character_id(id: CharacterStats.PlayerId) -> void:
	queue = queue.filter(
		func(action): 
			return action.actor.stats.id != id and action.target.stats.id != id)
			
func create_action_message(action: Action) -> String:
	return action.actor.stats.label
	#return "{0} -> {1} -> {2}".format([
		#action.actor.stats.label, 
		#Action.Type.keys()[action.type], 
		#action.target.stats.label
	#])

func _queue_empty_actions(characters: Array[Node2D]):
	for character in characters:
		var new_action = Action.new(character)
		queue.push_back(new_action)

func _fill_enemy_actions(players: Array[Node2D]):
	for action in queue:
		if(action.actor.stats.icon_type == CharacterStats.IconType.ENEMY):
			var rand_player_i = randi() % players.size()
			var enh_incursion = action.actor.skills.get_children()[0]
			action.set_attack(players[rand_player_i], enh_incursion)

func _process_skill(action: Action, tree: SceneTree) -> void:
	action.actor.stats.use_ingress_energy(action.skill.ingress_energy_cost)

	match action.skill.id:
		Skill.Id.ETH_INCURSION_SMALL, Skill.Id.ENH_INCURSION_SMALL:
			var damage = Utils.calucluate_skill_damage(action)
			if action.target.stats.is_defending: damage /= 2.0
			action.target.stats.take_damage(damage)

		Skill.Id.ETH_REFRAIN_SMALL:
			action.actor.stats.is_defending = true
	
	await tree.create_timer(2).timeout

func _sort_queue_by_agility():
	queue.sort_custom(func(a, b): 
		return a.actor.stats.agility < b.actor.stats.agility)
