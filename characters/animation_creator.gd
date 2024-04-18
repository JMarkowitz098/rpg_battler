extends Node2D

@export var ANIMATIONS_SCENE: PackedScene

var animations

func create_animations():
	if not ANIMATIONS_SCENE is PackedScene: return
	var world = get_tree().current_scene
	animations = ANIMATIONS_SCENE.instantiate()
	world.add_child.call_deferred(animations)
	animations.global_position = global_position
	return animations

func get_animations_node():
	return animations
