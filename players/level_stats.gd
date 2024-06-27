extends Resource
class_name LevelStats

@export var level: int
@export var max_ingress: int
@export var incursion: int
@export var refrain: int
@export var agility: int
@export var skills: Array[Skill.Id]

static func load_level_data(player_id: int, new_level: int) -> Resource:
	match player_id: 
		Stats.PlayerId.TALON:
			match new_level:
				1:
					return load("res://players/Talon/levels/talon_level_1.tres")
				2:
					return load("res://players/Talon/levels/talon_level_2.tres")
				_:
					return null
		Stats.PlayerId.NASH:
			match new_level:
				1:
					return load("res://players/Nash/levels/nash_level_1.tres")
				2:
					return load("res://players/Nash/levels/nash_level_2.tres")
				_:
					return null
		_:
			return null
				
	
