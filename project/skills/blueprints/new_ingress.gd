extends Resource
class_name Ingress

const INGRESS_ANIMATION = preload("res://skills/ingress_animation.tscn")

enum Id {
  DOUBLE_INCURSION, # 1
  GROUP_INCURSION, # 2
  GROUP_REFRAIN, # 3
  INCURSION, #4
  MOVEMENT, #5
  PIERCING_INCURSION, #6
  REFRAIN,
	DODGE,
	RECOVER
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
	player.refrain_aura.modulate = refrain_color


