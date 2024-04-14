extends Node2D

const CharacterBase := preload("res://characters/base_character.gd")

@onready var progress_bar = $ProgressBar
@onready var focus = $Focus
@onready var king_animations_creator = $AnimationsCreator

@export var MAX_HEALTH: float = 10

var action: CharacterBase

func _ready():
	var animations: Node2D = king_animations_creator.create_animations()
	#var animation_player: AnimationPlayer = king_animations_creator.create_animations().get_node("AnimationPlayer")
	action = CharacterBase.new(MAX_HEALTH, progress_bar, animations, focus)


	
