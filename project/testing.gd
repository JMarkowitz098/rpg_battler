extends Node

@onready var group := $Group
@onready var player_group := $PlayerGroup
@onready var enemy_group := $EnemyGroup


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# var data: Array[PlayerData] = [PlayerData.new({
	# 	"player_id": Player.Id.TALON,
	# 	"player_details": MockPlayerDetails.new(),
	# 	"stats": MockStats.new(),
	# 	"unique_id": UniqueId.new(),
	# 	"skills": MockIngress.create_array(),
	# 	"type": Player.Type.PLAYER
	# })]
	# group.instantiate_members(data)
	
	# var save_and_load := SaveAndLoad.new()

	# var players_data: Array[PlayerData] = [ MockPlayerData.new(), MockPlayerData.new() ]
	# var data := SaveFileData.new("0", players_data, Time.get_datetime_string_from_system(), Round.Number.ONE)
	# save_and_load.save_data(data)

	# data = SaveFileData.new("1", players_data, Time.get_datetime_string_from_system(), Round.Number.ONE)
	# save_and_load.save_data(data)
	enemy_group.load_members_from_round_data(Round.Number.ONE)
	




