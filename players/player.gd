extends Node2D

@onready var turn = $Turn
@onready var focus := $Focus
@onready var animation_player := $AnimationPlayer
@onready var base_sprite := $BaseSprite
@onready var stats := $Stats
@onready var skills = $Skills
@onready var ingress_energy = $Info/IngressEnergy
@onready var player_name = $Info/PlayerName
@onready var attack_sprite = $AttackSprite
@onready var refrain_aura = $RefrainAura

func _ready():
	animation_player.play("idle")
	update_energy_bar()
	player_name.text = stats.player_details.label

func _on_character_stats_took_damage():
	update_energy_bar()
	animation_player.play("hurt")
	await get_tree().create_timer(1.4).timeout
	animation_player.play("idle")

func get_skills(skill_type: Skill.Type):
	return skills.get_children().filter(func(skill): return skill.type == skill_type)

func _on_character_stats_used_skill():
	update_energy_bar()

func _on_character_stats_no_ingress_energy(_id):
	queue_free()
	
func update_energy_bar():
	ingress_energy.text = str(stats.current_ingress) + "/" + str(stats.level_stats.max_ingress)
