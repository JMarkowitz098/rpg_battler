class_name BattleGroups

var players: Array[Node2D]
var enemies: Array[Node2D]

func _init(init_players: Array[Node2D], init_enemies: Array[Node2D]) -> void:
	players = init_players
	enemies = init_enemies