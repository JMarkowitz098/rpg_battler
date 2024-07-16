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

# Legacy - TO BE DELETED

# signal no_ingress_energy(id: String)
# signal took_damage
# signal used_skill

# enum IconType { PLAYER, ENEMY }

# @export var player_details: PlayerDetails
# @export var level_stats: LevelStats

# @onready var current_ingress := level_stats.max_ingress: 
# 	set = set_ingress_energy

# var has_small_refrain_open := false
# var is_dodging := false
# var is_eth_dodging := false

# var current_refrain_element: Element.Type
# var slot: int
# var rand_agi: int
# var unique_id: String

# func set_ingress_energy(value: float) -> void:
# 	current_ingress = clamp(value, 0, level_stats.max_ingress)
# 	if current_ingress <= 0: 
# 		no_ingress_energy.emit(unique_id)

# func take_damage(value: int) -> void:
# 	current_ingress -= value
# 	took_damage.emit()
	
# func use_ingress_energy(value: int) -> void:
# 	current_ingress -= value
# 	used_skill.emit()

# static func create_unique_id(new_player_id: int) -> String:
# 	var rand_player_i := randi() % 1000
# 	return str(new_player_id) + "_" + str(rand_player_i)
	

# static func get_player_label(incoming_player_id: Stats.PlayerId) -> String:
# 	match incoming_player_id:
# 		Stats.PlayerId.TALON:
# 			return "Talon"
# 		Stats.PlayerId.NASH:
# 			return "Nash"
# 		Stats.PlayerId.ESEN:
# 			return "Esen"
# 		_:
# 			return "No match"
