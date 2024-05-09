class_name ActionQueue
extends Node

var queue: Array[Action] = []
var enemy_index := 0
var player_index := 0
var action_index := 0

const ActionListItemScene := preload("res://ui/action_list_item.tscn")

func draw_action_queue(action_list: HBoxContainer):
	for child in action_list.get_children():
		child.queue_free()
		
	for action in queue:
		var message: String
		match action.actor_stats.icon_type:
			"player":
				message = "O"
			"enemy":
				message = "X"
			_:
				message = "_"
				
		var list_item = ActionListItemScene.instantiate()
		list_item.get_node("Label").text = message
		if(action.is_focused): list_item.get_node("Focus").focus()
		action_list.add_child(list_item)

func process_action_queue(tree: SceneTree):
	while queue.size() > 0:
		var action = queue.pop_front()
		match action.action:
			"attack":
				await _process_attack(action, tree)
			"defend":
				action.actor_stats.is_defending = true

func _process_attack(action: Action, tree: SceneTree):
	var damage = Utils.calucluate_attack_damage(action.actor_stats, action.target_stats)
	if action.target_stats.is_defending: damage /= 2.0
	action.target_stats.take_damage(damage)
	await tree.create_timer(2).timeout
	
func queue_enemy_actions(enemies, players):
	for i in enemies.size():
		var rand_player_i = randi() % players.size()
		var enemy_action = Action.new(enemies[i], players[rand_player_i], "attack")
		queue.push_back(enemy_action)
		
func count_player_actions() -> int:
	return queue.filter(
		func(action): return action.actor_stats.icon_type == "player").size()
		
func reset_indexes():
	enemy_index = 0
	player_index = 0
	action_index = 0
	
func size() -> int:
	return queue.size()
	
func push_back(action: Action):
	queue.push_back(action)
	
func push_front(action: Action):
	queue.push_front(action)
	
func insert(index: int, action: Action):
	queue.insert(index, action)
	
func get_current_action() -> Action:
	return queue[action_index]

func set_focus(index: int, value: bool):
	queue[index].is_focused = value
	
func queue_player_attack_action(players, enemies):
	var new_action = Action.new(players[player_index], enemies[enemy_index], "attack")
	queue.insert(action_index, new_action)
	
func queue_player_defend_action(players):
	var new_action = Action.new(players[player_index], players[player_index], "defend")
	queue.push_front(new_action)
	
func next_player():
	player_index += 1
	action_index = 0
	
func remove_action_by_character_id(id):
	queue = queue.filter(
		func(action): 
			return action.actor_stats.id != id and action.target_stats.id != id)
