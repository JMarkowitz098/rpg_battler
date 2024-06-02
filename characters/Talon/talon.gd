extends Node2D

@onready var focus := $Focus
@onready var animation_player := $AnimationPlayer
@onready var base_sprite := $BaseSprite
@onready var stats := $CharacterStats
@onready var skills = $Skills
@onready var ingress_energy = $IngressEnergy
@onready var player_name = $PlayerName

func _ready():
	animation_player.play("idle")
	_update_energy_bar()
	if(stats.unique_id): player_name.text = stats.unique_id

func _on_character_stats_took_damage():
	_update_energy_bar()
	animation_player.play("hurt")
	await get_tree().create_timer(1.4).timeout
	animation_player.play("idle")

func get_skills(skill_type: Skill.Type):
	return skills.get_children().filter(func(skill): return skill.type == skill_type)

func _on_character_stats_used_skill():
	_update_energy_bar()


func _on_character_stats_no_ingress_energy(_id):
	queue_free()
	
func _update_energy_bar():
	ingress_energy.text = str(stats.current_ingress_energy) + " / " + str(stats.max_ingress_energy)
