extends Node2D
class_name Player

@onready var animation_player := $AnimationPlayer
@onready var attack_sprite := $AttackSprite
@onready var base_sprite := $BaseSprite
@onready var finger_focus := $FingerFocus
@onready var ingress_energy := $Info/IngressEnergy
@onready var player_name := $Info/PlayerName
@onready var refrain_aura := $RefrainAura
@onready var stats := $Stats
@onready var triangle_focus := $TriangleFocus

@onready var skills: Array[Ingress] = []

func _ready() -> void:
	animation_player.play("idle")
	update_energy_bar()
	player_name.text = stats.player_details.label
	set_skills()
	stats.unique_id = Stats.create_unique_id(stats.player_details.player_id)

# ----------------
# Public Functions
# ----------------

func focus(type: Focus.Type) -> void:
	match type:
		Focus.Type.FINGER:
			finger_focus.focus()
		Focus.Type.TRIANGLE:
			triangle_focus.focus()
		Focus.Type.ALL:
			finger_focus.focus()
			triangle_focus.focus()

func unfocus(type: Focus.Type) -> void:
	match type:
		Focus.Type.FINGER:
			finger_focus.unfocus()
		Focus.Type.TRIANGLE:
			triangle_focus.unfocus()
		Focus.Type.ALL:
			finger_focus.unfocus()
			triangle_focus.unfocus()

func set_triangle_focus_color(color: Color) -> void:
	triangle_focus.self_modulate = color

func set_triangle_focus_size(size: Vector2) -> void:
	triangle_focus.scale = size

func set_skills() -> void:
	skills = stats.level_stats.skills

func set_is_eth_dodging(val: bool) -> void:
	stats.is_eth_dodging = val

func set_dodge_flag(val: bool) -> void:
	if val:
		stats.is_dodging = true
	else:
		stats.is_dodging = false

func set_dodge_animation(val: bool) -> void:
	if val:
		base_sprite.self_modulate = Color("ffffff9b")
	else:
		base_sprite.self_modulate = Color("White")

func update_energy_bar() -> void:
	ingress_energy.text = str(stats.current_ingress) + "/" + str(stats.level_stats.max_ingress)

func is_player() -> bool:
	return stats.player_details.icon_type == Stats.IconType.PLAYER

func is_enemy() -> bool:
	return stats.player_details.icon_type == Stats.IconType.ENEMY

func get_usable_skills() -> Array[Ingress]: 
	return skills.filter(_usable_skill_filter)

func is_alive() -> bool:
	return stats.current_ingress > 0


# ----------------
# Helper Functions
# ----------------

func _on_character_stats_took_damage() -> void:
	update_energy_bar()
	animation_player.play("hurt")
	await get_tree().create_timer(1.4).timeout
	animation_player.play("idle")


func _on_character_stats_used_skill() -> void:
	update_energy_bar()


func _on_character_stats_no_ingress_energy(_id: String) -> void:
	queue_free()


func _is_usable_skill(skill: Ingress) -> bool:
	return skill.ingress < stats.current_ingress


func _usable_skill_filter(skill: Ingress) -> bool: return _is_usable_skill(skill)
