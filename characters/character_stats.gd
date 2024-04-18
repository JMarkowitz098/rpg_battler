extends Node2D

signal took_damage

@export var max_health: float
@export var label: String
@export var id: String
@export var current_health: float

func take_damage(value):
	current_health -= value
	emit_signal("took_damage")
