extends Node2D

@onready var progress_bar := $ProgressBar
@onready var focus := $Focus
@onready var animation_player := $AnimationPlayer
@onready var base_sprite := $BaseSprite
@onready var stats := $CharacterStats
@onready var skills = $Skills

func _ready():
	animation_player.play("idle")

func _on_character_stats_took_damage():
	progress_bar.value = (stats.current_health / stats.max_health) * 100
	animation_player.play("hurt")
	await get_tree().create_timer(1.4).timeout
	animation_player.play("idle")


func _on_character_stats_no_health(_id):
	queue_free()
