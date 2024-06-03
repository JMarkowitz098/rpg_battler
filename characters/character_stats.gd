class_name CharacterStats
extends Node2D

signal no_ingress_energy(id)
signal took_damage
signal used_skill

enum IconType { PLAYER, ENEMY }
enum Element { ENH, ETH, SHOR, SCOR }
enum PlayerId { TALON, KING }

@export var player_id: PlayerId 
@export var label: String
@export var icon_type: IconType
@export var elements: Array
@export var max_ingress_energy: float
@export var current_ingress_energy: float = max_ingress_energy : set = set_ingress_energy
@export var incursion_power := 1
@export var refrain_power := 1
@export var agility := 1

var has_small_refrain_open := false
var is_dodging := false

var current_refrain_element: Element
var slot: int
var rand_agi: int
var unique_id: String

func set_ingress_energy(value: float) -> void:
	current_ingress_energy = clamp(value, 0, max_ingress_energy)
	if current_ingress_energy <= 0: 
		no_ingress_energy.emit(unique_id)

func take_damage(value: float) -> void:
	current_ingress_energy -= value
	took_damage.emit()
	
func use_ingress_energy(value: float) -> void:
	current_ingress_energy -= value
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
