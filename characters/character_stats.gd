class_name CharacterStats
extends Node2D

signal no_ingress_energy(id)
signal took_damage
signal used_skill

enum IconType { PLAYER, ENEMY }
enum Elements { ENH, ETH, SHOR, SCOR }
enum PlayerId { TALON }

@export var id: PlayerId
@export var label: String
@export var icon_type: IconType
@export var elements: Array
@export var max_ingress_energy: float
@export var current_ingress_energy: float = max_ingress_energy : set = set_ingress_energy
@export var incursion_power : int = 1
@export var refrain_power : int = 1

var is_defending := false

var slot: int

func set_ingress_energy(value: float) -> void:
	current_ingress_energy = clamp(value, 0, max_ingress_energy)
	if current_ingress_energy <= 0: 
		no_ingress_energy.emit(id)

func take_damage(value: float) -> void:
	current_ingress_energy -= value
	took_damage.emit()
	
func use_ingress_energy(value: float) -> void:
	current_ingress_energy -= value
	used_skill.emit()
	
