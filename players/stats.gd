class_name Stats
extends Node

signal no_ingress_energy(id: String)
signal took_damage
signal used_skill

enum IconType { PLAYER, ENEMY }
enum Element { ENH, ETH, SHOR, SCOR, NONE }
enum PlayerId { TALON, NASH, ESEN }

@export var player_details: PlayerDetails
@export var level_stats: LevelStats

@onready var current_ingress := level_stats.max_ingress: 
	set = set_ingress_energy

var has_small_refrain_open := false
var is_dodging := false

var current_refrain_element: Element.Type
var slot: int
var rand_agi: int
var unique_id: String
var level: int

func set_ingress_energy(value: float) -> void:
	current_ingress = clamp(value, 0, level_stats.max_ingress)
	if current_ingress <= 0: 
		no_ingress_energy.emit(unique_id)

func take_damage(value: int) -> void:
	current_ingress -= value
	took_damage.emit()
	
func use_ingress_energy(value: int) -> void:
	current_ingress -= value
	used_skill.emit()

static func create_unique_id(new_player_id: int) -> String:
	var rand_player_i := randi() % 1000
	return str(new_player_id) + "_" + str(rand_player_i)
	

static func get_player_label(incoming_player_id: Stats.PlayerId) -> String:
	match incoming_player_id:
		Stats.PlayerId.TALON:
			return "Talon"
		Stats.PlayerId.NASH:
			return "Nash"
		Stats.PlayerId.ESEN:
			return "Esen"
		_:
			return "No match"
