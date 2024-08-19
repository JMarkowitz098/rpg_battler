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

static func get_new_stats(player_id: PlayerId.Id, new_level: int) -> Stats:
	match player_id:
		PlayerId.Id.TALON:
			return _get_talon_stats(new_level)
		PlayerId.Id.NASH:
			return _get_nash_stats(new_level)
		PlayerId.Id.ESEN:
			return _get_esen_stats(new_level)
		PlayerId.Id.NALTA:
			return _get_nalta_stats(new_level)
		PlayerId.Id.SORAH:
			return _get_sorah_stats(new_level)
		PlayerId.Id.DEVLIN:
			return _get_devlin_stats(new_level)
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

static func _get_nalta_stats(new_level: int) -> Stats:
	match(new_level):
		1:
			return load("res://players/Nalta/levels/nalta_1_stats.tres")
		2:
			return load("res://players/Nalta/levels/nalta_2_stats.tres")
		3:
			return load("res://players/Nalta/levels/nalta_3_stats.tres")
		_:
			return null

static func _get_sorah_stats(new_level: int) -> Stats:
	match(new_level):
		1:
			return load("res://players/Sorah/levels/sorah_1_stats.tres")
		2:
			return load("res://players/Sorah/levels/sorah_2_stats.tres")
		3:
			return load("res://players/Sorah/levels/sorah_3_stats.tres")
		_:
			return null

static func _get_devlin_stats(new_level: int) -> Stats:
	match(new_level):
		1:
			return load("res://players/Devlin/levels/devlin_1_stats.tres")
		2:
			return load("res://players/Devlin/levels/devlin_2_stats.tres")
		3:
			return load("res://players/Devlin/levels/devlin_3_stats.tres")
		_:
			return null