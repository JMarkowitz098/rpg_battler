extends Node2D
class_name Player

@onready var turn = $Turn
@onready var focus := $Focus
@onready var animation_player := $AnimationPlayer
@onready var base_sprite := $BaseSprite
@onready var stats := $Stats
@onready var ingress_energy = $Info/IngressEnergy
@onready var player_name = $Info/PlayerName
@onready var attack_sprite = $AttackSprite
@onready var refrain_aura = $RefrainAura

@onready var skills: Array[SkillStats] = []

func _ready():
	animation_player.play("idle")
	update_energy_bar()
	player_name.text = stats.player_details.label
	_set_skills()
	stats.unique_id = Stats.create_unique_id(stats.player_details.player_id)

func _on_character_stats_took_damage():
	update_energy_bar()
	animation_player.play("hurt")
	await get_tree().create_timer(1.4).timeout
	animation_player.play("idle")
	
func _set_skills():
	for skill_id in stats.level_stats.skills:
		var skill = Skill.create_skill_instance(skill_id)
		skills.append(skill)

func _on_character_stats_used_skill():
	update_energy_bar()

func _on_character_stats_no_ingress_energy(_id):
	queue_free()
	
func update_energy_bar():
	ingress_energy.text = str(stats.current_ingress) + "/" + str(stats.level_stats.max_ingress)
