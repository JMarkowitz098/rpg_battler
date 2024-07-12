class_name BattleGroups

var players: Array[Node2D]
var enemies: Array[Node2D]

func _init(init_players: Array[Node2D], init_enemies: Array[Node2D]) -> void:
	players = init_players
	enemies = init_enemies


func get_random_player() -> Node2D:
	return players[randi() % players.size()] 


func get_random_enemy() -> Node2D:
	return enemies[randi() % enemies.size()] 