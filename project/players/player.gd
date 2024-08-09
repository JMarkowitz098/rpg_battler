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
@onready var refrain_block := $RefrainBlock
@onready var triangle_focus := $TriangleFocus

@export var details: PlayerDetails

var stats: Stats
var learned_skills: SkillGroup

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


func focus(focus_type: Focus.Type, color: Color = Color.WHITE) -> void:
	match focus_type:
		Focus.Type.FINGER:
			finger_focus.focus()
			finger_focus.self_modulate = color
		Focus.Type.TRIANGLE:
			triangle_focus.focus()
			triangle_focus.self_modulate = color
		Focus.Type.ALL:
			finger_focus.focus()
			triangle_focus.focus()
			finger_focus.self_modulate = color
			triangle_focus.self_modulate = color
	

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
	learned_skills = incoming_skills

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

func get_usable_skills() -> Array[Ingress]: 
	return learned_skills.filter_by_usable(modifiers.current_ingress)


func is_alive() -> bool:
	return modifiers.current_ingress > 0


func set_current_ingress(new_value: int) -> void:
	modifiers.set_current_ingress(new_value, stats.max_ingress)


func use_ingress(amount: int) -> void:
	set_current_ingress(modifiers.current_ingress - amount)


func current_ingress() -> int:
	return modifiers.current_ingress


func can_damage() -> bool:
	return not modifiers.has_refrain_block


func set_modifier(flag: String, val: Variant) -> void:
	modifiers[flag] = val


func set_refrain(actor: Node2D, element: Element.Type) -> void:
	modifiers.has_small_refrain_open = true
	modifiers.current_refrain_element = element
	modifiers.refrain_actor = actor
	refrain_aura.show()


func clear_refrain() -> void:
	modifiers.has_small_refrain_open = false
	modifiers.current_refrain_element = Element.Type.NONE
	modifiers.refrain_actor = null
	refrain_aura.hide()


func set_refrain_block(element: Element.Type, actor: Node2D) -> void:
	modifiers.current_refrain_block_element = element
	modifiers.refrain_blocker = actor
	modifiers.has_refrain_block = true
	refrain_block.show()


func clear_refrain_block() -> void:
	modifiers.current_refrain_block_element = Element.Type.NONE
	modifiers.refrain_blocker = null
	modifiers.has_refrain_block = false
	refrain_block.hide()


func take_damage(amount: int, action: Action) -> void:
	if action.actor_can_damage() and _can_take_damage(action.skill): 
		animation_player.play("hurt")
		if not Utils.is_test: await animation_player.animation_finished
		set_current_ingress(modifiers.current_ingress - amount)
		animation_player.play("idle")
	elif not action.actor.can_damage():
		_handle_refrain_block(action, amount)
	elif not _can_take_damage(action.skill):
		_handle_refrain(action, amount)


# ----------------
# Helper Functions
# ----------------

# Need to replace with modifiers on took damage or something
func _on_character_stats_took_damage() -> void:
	update_energy_bar()
	if not Utils.is_test: 
		animation_player.play("hurt")
		await animation_player.animation_finished
	animation_player.play("idle")
	

func _is_usable_skill(skill: Ingress) -> bool:
	return skill.ingress < modifiers.current_ingress


func _usable_skill_filter(skill: Ingress) -> bool: return _is_usable_skill(skill)


func _on_modifiers_ingress_updated() -> void:
	update_energy_bar()


func _on_modifiers_no_ingress(_unique_id: String) -> void:
	queue_free()


func _on_finger_focus_visibility_changed() -> void:
	if finger_focus.visible: 
		Events.update_current_member.emit(self, true)
	else: 
		Events.update_current_member.emit(self, false)


func _handle_refrain(action: Action, amount: int) -> void:
	var refrain_actor: Node2D = modifiers.refrain_actor
	if action.skill.element == modifiers.current_refrain_element:
		if not Utils.is_test:
			refrain_actor.animation_player.play("refrain")
			await refrain_actor.animation_player.animation_finished
		refrain_actor.set_current_ingress(refrain_actor.modifiers.current_ingress - amount)
	elif action.skill.id == Ingress.Id.PIERCING_INCURSION:
		set_current_ingress(amount)

	clear_refrain()


func _handle_refrain_block(action: Action, amount: int) -> void:
	if action.actor.modifiers.current_refrain_block_element == action.skill.element:
		if not Utils.is_test:
			animation_player.play("refrain")
			await animation_player.animation_finished
		set_current_ingress(modifiers.current_ingress - amount * -1)
	action.actor.clear_refrain_block()


func _can_take_damage(skill: Ingress) -> bool:
	if skill.id == Ingress.Id.PIERCING_INCURSION and skill.element != modifiers.current_refrain_element:
		return true
	else:
		return not modifiers.has_small_refrain_open

