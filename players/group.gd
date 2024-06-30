extends Node2D
class_name Group

var TALON := load("res://players/Talon/talon.tscn")
var NASH := load("res://players/Nash/nash.tscn")
var ESEN := load("res://players/Esen/esen.tscn")

@onready var slot_one_location := $SlotOneLocation
@onready var slot_two_location := $SlotTwoLocation
@onready var slot_three_location := $SlotThreeLocation
@onready var slot_four_location := $SlotFourLocation

var members: Array[Node2D] = []
var current_member: int = 0

# ----------------
# Public Functions
# ----------------

func instantiate_members(data_array: Array[NewPlayerData]) -> void:
	for slot_index in data_array.size():
		var data := data_array[slot_index]
		_instantiate_member(data, slot_index)

func get_current_member() -> Node2D:
	return members[current_member]

func focus_all(type: Focus.Type) -> void:
	for member in members:
		member.focus(type)
		
func unfocus_all(type: Focus.Type) -> void:
	for member in members:
		member.unfocus(type)

func switch_focus(type: Focus.Type, old_index: int, new_index: int) -> void:
	members[old_index].unfocus(type)
	members[new_index].focus(type)

func remove_member_by_id(id: String) -> void:
	members = members.filter(func(player: Node2D) -> bool: return player.stats.unique_id != id)
	#TODO: Do they queue_free? Check

func reset_current() -> void:
	current_member = 0


# ----------------
# Helper Functions
# ----------------

func _instantiate_member(data: NewPlayerData, slot_index: int) -> void:
	var new_member: Node2D
	match data.player_id:
		PlayerId.Id.TALON:
			new_member = TALON.instantiate()
		PlayerId.Id.NASH:
			new_member = NASH.instantiate()
		PlayerId.Id.ESEN:
			new_member = ESEN.instantiate()

	add_child(new_member)
	members.append(new_member)

	new_member.stats.player_details = data.player_details
	new_member.stats.level_stats = data.level_stats
	new_member.stats.current_ingress = data.level_stats.max_ingress
	new_member.update_energy_bar()
	new_member.set_skills()

	_set_location(slot_index, new_member)

func _set_location(slot_index: int, player: Node2D) -> void:
	match slot_index:
		0:
			player.global_position = slot_one_location.global_position
		1:
			player.global_position = slot_two_location.global_position
		2: 
			player.global_position = slot_three_location.global_position
		3:
			player.global_position = slot_four_location.global_position
