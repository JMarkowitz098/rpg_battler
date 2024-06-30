extends Node

@onready var group := $Group
@onready var player_group_new := $PlayerGroupNew
@onready var enemy_group_new := $EnemyGroupNew


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_group_new.load_members_from_save_data()
	player_group_new.focus_all(Focus.Type.FINGER)

	enemy_group_new.load_members_from_round_data(Round.Number.ONE)


