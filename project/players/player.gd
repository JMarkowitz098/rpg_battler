extends Node2D
class_name Player

enum Id { TALON, NASH, ESEN, NONE }
enum Type { PLAYER, ENEMY }

@onready var animation_player := $AnimationPlayer
@onready var attack_sprite := $AttackSprite
@onready var base_sprite := $BaseSprite
@onready var finger_focus := $FingerFocus
@onready var ingress_energy := $Info/IngressEnergy
@onready var modifiers := $Modifiers
@onready var player_name := $Info/PlayerName
@onready var refrain_aura := $RefrainAura
@onready var triangle_focus := $TriangleFocus

@export var details: PlayerDetails

var stats: Stats
var skill_group: SkillGroup

var slot: int
var type: Type
var unique_id: UniqueId

func _ready() -> void:
	animation_player.play("idle")
	if(details): player_name.text = details.label
	unique_id = UniqueId.new()

# ----------------
# Public Functions
# ----------------

func load_stats(incoming_stats: Stats) -> void:
	stats = incoming_stats
	update_energy_bar()


func focus(focus_type: Focus.Type) -> void:
	match focus_type:
		Focus.Type.FINGER:
			finger_focus.focus()
		Focus.Type.TRIANGLE:
			triangle_focus.focus()
		Focus.Type.ALL:
			finger_focus.focus()
			triangle_focus.focus()

func unfocus(focus_type: Focus.Type) -> void:
	match focus_type:
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

func set_skills(incoming_skills: SkillGroup) -> void:
	skill_group = incoming_skills

func set_unique_id(incoming_unique_id: UniqueId) -> void:
	unique_id = incoming_unique_id

func set_is_eth_dodging(val: bool) -> void:
	stats.is_eth_dodging = val

func set_dodge_flag(val: bool) -> void:
	if val:
		modifiers.is_dodging = true
	else:
		modifiers.is_dodging = false

func set_dodge_animation(val: bool) -> void:
	if val:
		base_sprite.self_modulate = Color("ffffff9b")
	else:
		base_sprite.self_modulate = Color("White")

func update_energy_bar() -> void:
	ingress_energy.text = str(modifiers.current_ingress) + "/" + str(stats.max_ingress)

func is_player() -> bool:
	return type == Type.PLAYER

func is_enemy() -> bool:
	return type == Type.ENEMY

func get_usable_skills() -> Array[NewIngress]: 
	return skill_group.filter_by_usable(modifiers.current_ingress)


func is_alive() -> bool:
	return modifiers.current_ingress > 0


func set_current_ingress(new_value: int) -> void:
	modifiers.set_current_ingress(new_value, stats.max_ingress)


func use_ingress(amount: int) -> void:
	set_current_ingress(modifiers.current_ingress - amount)


func take_damage(amount: int) -> void:
	animation_player.play("hurt")
	set_current_ingress(modifiers.current_ingress - amount)
	await get_tree().create_timer(1.4).timeout
	animation_player.play("idle")

# ----------------
# Helper Functions
# ----------------

# Need to replace with modifiers on took damage or something
func _on_character_stats_took_damage() -> void:
	update_energy_bar()
	animation_player.play("hurt")
	await get_tree().create_timer(1.4).timeout
	animation_player.play("idle")
	


func _is_usable_skill(skill: NewIngress) -> bool:
	return skill.ingress < modifiers.current_ingress


func _usable_skill_filter(skill: NewIngress) -> bool: return _is_usable_skill(skill)


func _on_modifiers_ingress_updated() -> void:
	update_energy_bar()


func _on_modifiers_no_ingress(_unique_id: String) -> void:
	queue_free()
