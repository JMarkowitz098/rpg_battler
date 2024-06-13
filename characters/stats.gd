class_name Stats
extends Node

signal no_ingress_energy(id)
signal took_damage
signal used_skill

enum IconType { PLAYER, ENEMY }
enum Element { ENH, ETH, SHOR, SCOR }
enum PlayerId { TALON, NASH }

@export var player_details: PlayerDetails
@export var level_stats: LevelStats

@onready var current_ingress := level_stats.max_ingress

var has_small_refrain_open := false
var is_dodging := false

var current_refrain_element: Element
var slot: int
var rand_agi: int
var unique_id: String
var level: int

func set_ingress_energy(value: float) -> void:
	current_ingress = clamp(value, 0, level_stats.max_ingress_energy)
	if current_ingress <= 0: 
		no_ingress_energy.emit(unique_id)

func take_damage(value: float) -> void:
	current_ingress -= value
	took_damage.emit()
	
func use_ingress_energy(value: float) -> void:
	current_ingress -= value
	used_skill.emit()

static func create_unique_id(new_player_id):
	var rand_player_i = randi() % 1000
	return str(new_player_id) + "_" + str(rand_player_i)
	
static func get_element_label(element_id: int) -> String:
	match element_id:
		0:
			return "Enh"
		1:
			return "Eth"
		2:
			return "Shor"
		3:
			return "Scor"
		_:
			return ""

static func get_player_label(incoming_player_id: int) -> String:
	match incoming_player_id:
		0:
			return "Talon"
		1:
			return "Nash"
		_:
			return "No match"
