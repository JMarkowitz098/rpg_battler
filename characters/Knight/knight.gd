extends Node2D

@onready var progress_bar = $ProgressBar
@onready var focus = $Focus
@onready var knight_animations_creator = $KnightAnimationsCreator
@onready var base_sprite = $BaseSprite
@onready var stats = $CharacterStats

@export var MAX_HEALTH: float = 10

var animation_player: AnimationPlayer

func _ready():
	base_sprite.hide()
	animation_player = knight_animations_creator.create_animations().get_node("AnimationPlayer")
	animation_player.play("idle")


	
