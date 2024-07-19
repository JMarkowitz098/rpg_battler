extends Resource
class_name Stats

@export var level: int
@export var max_ingress: int
@export var incursion: int
@export var refrain: int
@export var agility: int

func _init(_level: int = 0, _max_ingress: int = 0, _incursion: int = 0, _refrain: int = 0, _agility: int = 0) -> void:
	level = _level
	max_ingress = _max_ingress
	incursion = _incursion
	refrain = _refrain
	agility = _agility

func format_for_save() -> Dictionary:
	return {
		"level": level,
		"max_ingress": max_ingress,
		"incursion": incursion,
		"refrain": refrain,
		"agility": agility
	}

static func get_new_stats(player_id: Player.Id, new_level: int) -> Stats:
	match player_id:
		Player.Id.TALON:
			return Stats._get_talon_stats(new_level)
		Player.Id.NASH:
			return Stats._get_nash_stats(new_level)
		Player.Id.ESEN:
			return Stats._get_esen_stats(new_level)
		_:
			return null

static func _get_talon_stats(new_level: int) -> Stats:
	match(new_level):
		1:
			return load("res://players/Talon/levels/talon_1_stats.tres")
		2:
			return load("res://players/Talon/levels/talon_2_stats.tres")
		3:
			return load("res://players/Talon/levels/talon_3_stats.tres")
		_:
			return null

static func _get_nash_stats(new_level: int) -> Stats:
	match(new_level):
		1:
			return load("res://players/Nash/levels/nash_1_stats.tres")
		2:
			return load("res://players/Nash/levels/nash_2_stats.tres")
		3:
			return load("res://players/Nash/levels/nash_3_stats.tres")
		_:
			return null

static func _get_esen_stats(new_level: int) -> Stats:
	match(new_level):
		1:
			return load("res://players/Esen/levels/esen_1_stats.tres")
		2:
			return load("res://players/Esen/levels/esen_2_stats.tres")
		3:
			return load("res://players/Esen/levels/esen_3_stats.tres")
		_:
			return null
