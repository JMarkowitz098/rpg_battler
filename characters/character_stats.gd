class_name CharacterStats
extends Node2D

signal no_health(id)
signal took_damage
signal used_skill

enum CharacterTypes { KNIGHT }
enum IconTypes { PLAYER, ENEMY }

@export_enum("CharacterTypes") var type: String

@export var max_health: float : set = set_max_health
@export var max_mp: float : set = set_max_mp
@export var current_health: float = max_health : set = set_health
@export var current_mp: float = max_mp : set = set_mp
@export var attack : int = 1
@export var defense : int = 1
@export var label: String
@export var id: String
@export var icon_type: IconTypes
@export var character_type: CharacterTypes

var is_defending := false
var slot: int

func set_max_health(value):
	max_health = value
	
func set_max_mp(value):
	max_mp = value

func set_health(value):
	current_health = clamp(value, 0, max_health)
	if current_health <= 0: 
		no_health.emit(id)

func set_mp(value):
	current_mp = clamp(value, 0, max_mp)

func take_damage(value):
	current_health -= value
	took_damage.emit()
	
func use_mp(value):
	current_mp -= value
	used_skill.emit()
	
