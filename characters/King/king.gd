extends Node2D

@onready var ingress_energy_bar = $IngressEnergyBar
@onready var focus = $Focus
@onready var stats = $CharacterStats
@onready var animation_player = $AnimationPlayer
@onready var skills = $Skills

func _ready():
	animation_player.play("idle")
	stats.unique_id = CharacterStats.create_unique_id(CharacterStats.PlayerId.KING)

func _on_character_stats_took_damage():
	ingress_energy_bar.value = (stats.current_ingress_energy / stats.max_ingress_energy) * 100
	animation_player.play("hurt")
	await get_tree().create_timer(1.4).timeout
	animation_player.play("idle")
	
func _on_character_stats_no_health(_id):
	queue_free()


func _on_character_stats_used_skill():
	ingress_energy_bar.value = (stats.current_ingress_energy / stats.max_ingress_energy) * 100


func _on_character_stats_no_ingress_energy(id):
	pass # Replace with function body.
