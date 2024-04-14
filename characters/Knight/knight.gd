extends Node2D

const CharacterBase := preload("res://characters/base_character.gd")

@onready var progress_bar = $ProgressBar
@onready var focus = $Focus
@onready var knight_animations_creator = $KnightAnimationsCreator

@export var MAX_HEALTH: float = 10

var action: CharacterBase

func _ready():
	var animations: Node2D = knight_animations_creator.create_animations()
	action = CharacterBase.new(MAX_HEALTH, progress_bar, animations, focus)


	
