extends Node2D

@onready var progress_bar = $ProgressBar
@onready var focus = $Focus
@onready var knight_animations_creator = $KnightAnimationsCreator
@onready var base_sprite = $BaseSprite
@onready var stats = $CharacterStats

var animation_player: AnimationPlayer

func _ready():
	base_sprite.hide()
	animation_player = knight_animations_creator.create_animations().get_node("AnimationPlayer")
	animation_player.play("idle")

func _on_character_stats_took_damage():
	progress_bar.value = (stats.current_health / stats.max_health) * 100
	animation_player.play("hurt")
	await get_tree().create_timer(1.4).timeout
	animation_player.play("idle")


func _on_character_stats_no_health():
	queue_free()
