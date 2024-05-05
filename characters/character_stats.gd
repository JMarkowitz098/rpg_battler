class_name CharacterStats
extends Node2D

signal no_health
signal took_damage

@export var max_health: float : set = set_max_health
@export var current_health: float = max_health : set = set_health
@export var attack : int = 1
@export var defense : int = 1
@export var label: String
@export var id: String
@export var icon_type: String

func set_max_health(value):
	max_health = value

func set_health(value):
	current_health = clamp(value, 0, max_health)
	if current_health <= 0: no_health.emit()

func take_damage(value):
	current_health -= value
	emit_signal("took_damage")
