extends Node2D

var enemies: Array[Node2D] = []
var is_battling: bool = false
var current := 0

func _ready() -> void:
	_connect_signals()
	_set_enemies()
	
func _connect_signals() -> void:
	pass
	#Events.choosing_action_queue_state_entered.connect(_on_choosing_action_queue_state_entered)
	#Events.choosing_action_state_entered.connect(_on_choosing_action_state_entered)
	#Events.choosing_enemy_all_state_entered.connect(_on_choosing_enemy_state_all_entered)
	#Events.choosing_enemy_state_entered.connect(_on_choosing_enemy_state_entered)
	#Events.choosing_skill_state_entered.connect(_on_choosing_skill_state_entered)
	#Events.enter_action_queue_handle_input.connect(_on_enter_action_queue_handle_input)
	#Events.is_battling_state_entered.connect(_on_is_battling_state_entered)
	#Events.update_enemy_group_current.connect(_on_update_enemy_group_current)

func switch_focus(x: int, y: int) -> void:
	enemies[x].focus()
	enemies[y].unfocus()
	
func reset_focus() -> void:
	clear_focus()

func clear_focus() -> void:
	for enemy in enemies:
		enemy.unfocus()

func clear_turn_focus() -> void:
	for enemy in enemies:
		enemy.turn.unfocus()

func remove_enemy_by_id(id: String) -> void:
	enemies = enemies.filter(func(enemy: Node2D) -> bool: return enemy.stats.unique_id != id)

func get_current_enemy() -> Node2D:
	if current < enemies.size():
		return enemies[current]
	else:
		return enemies[0]

func _set_enemies() -> void:
	var slot := 0
	for enemy in get_children():
		if enemy is Node2D: 
			enemies.append(enemy)
			enemy.stats.slot = slot
			slot += 1
			enemy.player_name.text = enemy.stats.player_details.label
			enemy.stats.unique_id = enemy.stats.create_unique_id(enemy.stats.player_details.player_id)

func _focus_all() -> void:
	for enemy in enemies:
		enemy.focus()

# -------
# Signals
# -------

func _on_choosing_action_state_entered() -> void:
	clear_focus()
	clear_turn_focus()

func _on_choosing_action_queue_state_entered() -> void:
	clear_focus()

func _on_choosing_skill_state_entered() -> void:
	clear_focus()

func _on_is_battling_state_entered() -> void:
	clear_focus()
	clear_turn_focus()

func _on_enter_action_queue_handle_input() -> void:
	clear_turn_focus()

func _on_update_enemy_group_current(direction: Direction.Type) -> void:
	match direction:
		Direction.Type.LEFT:
			var new_enemy_index := (current - 1) % enemies.size()
			switch_focus(new_enemy_index, current)
			current = new_enemy_index
		Direction.Type.RIGHT:
			var new_enemy_index := (current + 1) % enemies.size()
			switch_focus(new_enemy_index, current)
			current = new_enemy_index

# func _on_choosing_enemy_state_entered() -> void:
# 	get_current_enemy().icon_focus.focus()

func _on_choosing_enemy_state_all_entered() -> void:
	_focus_all()
