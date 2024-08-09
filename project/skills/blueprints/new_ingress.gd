extends Resource
class_name Ingress

const INGRESS_ANIMATION = preload("res://skills/ingress_animation.tscn")

enum Id {
  DOUBLE_INCURSION, # 0
  GROUP_INCURSION, # 1
  GROUP_REFRAIN, # 2
  INCURSION, #3
  MOVEMENT, #4
  PIERCING_INCURSION, #5
  REFRAIN, # 6
	DODGE, # 7
	RECOVER, # 8
	REFRAIN_BLOCK # 9
}

enum Type {
	INCURSION,
	REFRAIN,
	DODGE,
	RECOVER,
	NONE
}

enum Target {
	SELF,
	ENEMY,
	ALLY,
	ALL_ENEMIES,
	ALL_ALLIES
}

@export var label: String
@export var ingress: int
@export var element: Element.Type
@export_multiline var description: String


func _play_attack_animation(action: Action) -> void:
	action.actor.base_sprite.hide()
	action.actor.attack_sprite.show()
	action.actor.animation_player.play("attack")
	await action.actor.animation_player.animation_finished
	if action.actor != null:
		action.actor.base_sprite.show()
		action.actor.attack_sprite.hide()
		action.actor.animation_player.play("idle")

func _play_ingress_animation(action: Action, tree: SceneTree) -> void:
	if action.actor.modifiers.has_refrain_block: return
	var ingress_element: Element.Type = action.skill.element
	var ingress_animation := INGRESS_ANIMATION.instantiate()
	tree.get_root().add_child(ingress_animation)

	ingress_animation.global_position = action.target.global_position
	if action.target.is_player():
		ingress_animation.global_position.x += 10
	else:
		ingress_animation.global_position.x -= 20

	match ingress_element:
		Element.Type.SHOR:
			ingress_animation.self_modulate = Color("Blue")
		Element.Type.SCOR:
			ingress_animation.self_modulate = Color(100, 1, 1)  # Red
		Element.Type.ETH:
			ingress_animation.self_modulate = Color("Green")
		Element.Type.ENH:
			ingress_animation.self_modulate = Color(37, 1, 0)  # Orange

	ingress_animation.play()
	await ingress_animation.animation_finished
	ingress_animation.queue_free()

func _play_refrain_animation(action: Action) -> void:
	action.actor.animation_player.play("refrain")
	await action.actor.animation_player.animation_finished
	action.actor.animation_player.play("idle")

func _set_refrain(player: Node2D, skill_element: Element.Type) -> void:
	player.modifiers.has_small_refrain_open = true
	player.modifiers.current_refrain_element = skill_element
	player.refrain_aura.show()

	var refrain_color: Color
	match skill_element:
		Element.Type.ETH:
			refrain_color = Color("Green")
		Element.Type.ENH:
			refrain_color = Color("Orange")
		Element.Type.SCOR:
			refrain_color = Color("Red")
		Element.Type.SHOR:
			refrain_color = Color("Blue")
	player.refrain_aura.self_modulate = refrain_color

func _set_refrain_block(actor: Node2D, target: Node2D, skill_element: Element.Type) -> void:
	target.set_refrain_block(skill_element, actor)

	var refrain_color: Color
	match skill_element:
		Element.Type.ETH:
			refrain_color = Color("Green")
		Element.Type.ENH:
			refrain_color = Color("Orange")
		Element.Type.SCOR:
			refrain_color = Color("Red")
		Element.Type.SHOR:
			refrain_color = Color("Blue")
	target.refrain_block.self_modulate = refrain_color

