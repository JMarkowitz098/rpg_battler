extends Node2D

@onready var ingress_energy_bar = $IngressEnergy
@onready var focus := $Focus
@onready var animation_player := $AnimationPlayer
@onready var base_sprite := $BaseSprite
@onready var stats := $CharacterStats
@onready var skills = $Skills

func _ready():
	animation_player.play("idle")

func _on_character_stats_took_damage():
	ingress_energy_bar.value = (stats.current_ingress_energy / stats.max_ingress_energy) * 100
	animation_player.play("hurt")
	await get_tree().create_timer(1.4).timeout
	animation_player.play("idle")

func get_skills():
	return skills.get_children()

func _on_character_stats_used_skill():
	ingress_energy_bar.value = (stats.current_ingress_energy / stats.max_ingress_energy) * 100

func _on_character_stats_no_ingress_energy(_id):
	queue_free()
