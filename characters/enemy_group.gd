extends Node2D

var enemies: Array[Node] = []
var action_queue: Array = []
var is_battling: bool = false
var index: int = 0

func _ready():
	enemies = get_children()

func switch_focus(x, y):
	enemies[x].focus.focus()
	enemies[y].focus.unfocus()
	
func reset_focus():
	index = 0
	for enemy in enemies:
		enemy.focus.unfocus()
