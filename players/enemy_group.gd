extends Node2D

var enemies: Array[Node2D] = []
#var action_queue: Array = [] #:TODO Remove after confimring not used in battle scene
var is_battling: bool = false
var index: int = 0

func _ready():
	var slot := 0
	for enemy in get_children():
		if enemy is Node2D: 
			enemies.append(enemy)
			enemy.stats.slot = slot
			slot += 1
			enemy.player_name.text = enemy.stats.player_details.label
			enemy.stats.unique_id = enemy.stats.create_unique_id(enemy.stats.player_details.player_id)

func switch_focus(x, y):
	enemies[x].focus.focus()
	enemies[y].focus.unfocus()
	
func reset_focus():
	index = 0
	clear_focus()

func clear_focus():
	for enemy in enemies:
		enemy.focus.unfocus()

func clear_turn_focus():
	for enemy in enemies:
		enemy.turn.unfocus()

func remove_enemy_by_id(id: String):
	enemies = enemies.filter(func(enemy): return enemy.stats.unique_id != id)
