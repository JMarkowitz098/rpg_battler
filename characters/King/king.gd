extends Node2D

@onready var ingress_energy = $IngressEnergy
@onready var focus = $Focus
@onready var stats = $CharacterStats
@onready var animation_player = $AnimationPlayer
@onready var skills = $Skills
@onready var player_name = $PlayerName

func _ready():
	animation_player.play("idle")
	stats.unique_id = CharacterStats.create_unique_id(CharacterStats.PlayerId.KING)
	_update_energy_bar()

func _on_character_stats_took_damage():
	_update_energy_bar()
	animation_player.play("hurt")
	await get_tree().create_timer(1.4).timeout
	animation_player.play("idle")

func _on_character_stats_used_skill():
	_update_energy_bar()

func _on_character_stats_no_ingress_energy(_id):
	queue_free()
	
func _update_energy_bar():
	ingress_energy.text = str(stats.current_ingress_energy) + " / " + str(stats.max_ingress_energy)
