class_name ActionQueue
extends Node

var queue: Array[Action] = []
var enemy_index := 0
var player_index := 0
var action_index := 0

const ActionListItemScene = preload("res://ui/action_list_item.tscn")

func draw_action_queue(action_list):
	for child in action_list.get_children():
		child.queue_free()
		
	for action in queue:
		var message: String
		match action.actor_stats.icon_type:
			"player":
				message = "O"
			"enemy":
				message = "X"
				
		var list_item = ActionListItemScene.instantiate()
		list_item.get_node("Label").text = message
		if(action.is_focused): list_item.get_node("Focus").focus()
		action_list.add_child(list_item)

func process_action_queue(tree):
	for action in queue:
		match action.action:
			"attack":
				var damage = Utils.calucluate_attack_damage(action.actor_stats, action.target_stats)
				action.target_stats.take_damage(damage)
		await tree.create_timer(2).timeout
	queue.clear()

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
	
func size():
	return queue.size()
	
func insert(index: int, action: Action):
	queue.insert(index, action)
	
func get_current_action():
	return queue[action_index]

func set_focus(index: int, value: bool):
	queue[index].is_focused = value
