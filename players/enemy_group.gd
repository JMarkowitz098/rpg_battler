extends Node2D

enum Direction{ LEFT, RIGHT }

var enemies: Array[Node2D] = []
var is_battling: bool = false
var current := 0

func _ready():
	var slot := 0
	for enemy in get_children():
		if enemy is Node2D: 
			enemies.append(enemy)
			enemy.stats.slot = slot
			slot += 1
			enemy.player_name.text = enemy.stats.player_details.label
			enemy.stats.unique_id = enemy.stats.create_unique_id(enemy.stats.player_details.player_id)
	Events.choosing_action_state_entered.connect(_on_choosing_action_state_entered)
	Events.choosing_action_queue_state_entered.connect(_on_choosing_action_queue_state_entered)
	Events.choosing_skill_state_entered.connect(_on_choosing_skill_state_entered)
	Events.is_battling_state_entered.connect(_on_is_battling_state_entered)
	Events.enter_action_queue_handle_input.connect(_on_enter_action_queue_handle_input)
	Events.update_enemy_group_current.connect(_on_update_enemy_group_current)

func switch_focus(x, y):
	enemies[x].focus.focus()
	enemies[y].focus.unfocus()
	
func reset_focus():
	clear_focus()

func clear_focus():
	for enemy in enemies:
		enemy.focus.unfocus()

func clear_turn_focus():
	for enemy in enemies:
		enemy.turn.unfocus()

func remove_enemy_by_id(id: String):
	enemies = enemies.filter(func(enemy): return enemy.stats.unique_id != id)

func get_current_enemy():
	return enemies[current]

func _on_choosing_action_state_entered():
	clear_focus()
	clear_turn_focus()

func _on_choosing_action_queue_state_entered():
	clear_focus()

func _on_choosing_skill_state_entered():
	clear_focus()

func _on_is_battling_state_entered():
	clear_focus()
	clear_turn_focus()

func _on_enter_action_queue_handle_input():
	clear_turn_focus()

func _on_update_enemy_group_current(direction: Direction):
	match direction:
		Direction.LEFT:
			var new_enemy_index = (current - 1) % enemies.size()
			switch_focus(new_enemy_index, current)
			current = new_enemy_index
		Direction.RIGHT:
			var new_enemy_index = (current + 1) % enemies.size()
			switch_focus(new_enemy_index, current)
			current = new_enemy_index
