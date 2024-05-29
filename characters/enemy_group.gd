extends Node2D

var enemies: Array[Node2D] = []
var action_queue: Array = []
var is_battling: bool = false
var index: int = 0

func _ready():
	print(get_children())
	for enemy in get_children():
		enemies.append(enemy)

func switch_focus(x, y):
	enemies[x].focus.focus()
	enemies[y].focus.unfocus()
	
func reset_focus():
	index = 0
	for enemy in enemies:
		enemy.focus.unfocus()

func remove_enemy_by_id(id):
	enemies = enemies.filter(func(enemy): return enemy.stats.id != id)
	
