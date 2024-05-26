class_name CharacterStats
extends Node2D

signal no_health(id)
signal took_damage

enum CharacterTypes { KNIGHT }
enum IconTypes { PLAYER, ENEMY }

@export var max_health: float : set = set_max_health
@export var current_health: float = max_health : set = set_health
@export var attack : int = 1
@export var defense : int = 1
@export var label: String
@export var id: String
@export var icon_type: IconTypes
@export var character_type: CharacterTypes
@export_enum("CharacterTypes") var type: String
var is_defending := false
var slot: int

func set_max_health(value):
	max_health = value

func set_health(value):
	current_health = clamp(value, 0, max_health)
	if current_health <= 0: 
		no_health.emit(id)

func take_damage(value):
	current_health -= value
	took_damage.emit()
