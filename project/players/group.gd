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

func instantiate_members(data_array: Array[PlayerData]) -> void:
	for slot_index in data_array.size():
		var data := data_array[slot_index]
		_instantiate_member(data, slot_index)

func get_current_member() -> Node2D:
	return members[current_member]

func get_member_by_unique_id(unique_id: String) -> Node2D:
	if members.size() > 0:
		return members.filter(func(member: Node2D) -> bool: return member.unique_id.id == unique_id)[0]
	else: return null

func focus_all(type: Focus.Type) -> void:
	for member in members:
		member.focus(type)
		
func unfocus_all(type: Focus.Type) -> void:
	for member in members:
		member.unfocus(type)

func set_triangle_focus_color_all(color: Color) -> void:
	for member in members:
		member.set_triangle_focus_color(color)

func set_triangle_focus_size_all(size: Vector2) -> void:
	for member in members:
		member.set_triangle_focus_size(size)

func switch_focus(type: Focus.Type, old_index: int, new_index: int) -> void:
	members[old_index].unfocus(type)
	members[new_index].focus(type)

func remove_member_by_id(id: String) -> void:
	members = members.filter(func(player: Node2D) -> bool: return player.unique_id.id != id)
	#TODO: Do they queue_free? Check

func reset_current_member() -> void:
	current_member = 0

func reset_dodges() -> void:
	for member in members:
		member.set_dodge_flag(false)
		if not member.modifiers.is_eth_dodging: 
			member.set_dodge_animation(false)


# ----------------
# Helper Functions
# ----------------

func _instantiate_member(data: PlayerData, slot_index: int) -> void:
	var new_member: Node2D
	match data.player_details.player_id:
		PlayerId.Id.TALON:
			new_member = TALON.instantiate()
		PlayerId.Id.NASH:
			new_member = NASH.instantiate()
		PlayerId.Id.ESEN:
			new_member = ESEN.instantiate()

	add_child(new_member)
	members.append(new_member)

	new_member.slot = slot_index
	new_member.stats = data.stats
	new_member.type = data.type
	new_member.unique_id = data.unique_id
	new_member.details = data.player_details
	new_member.player_name.text = data.player_details.label

	new_member.set_skills(data.learned_skills)
	new_member.set_current_ingress(new_member.stats.max_ingress)
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

func _on_update_current(direction: Direction.Type) -> void:
	if(members.size() > 0):
		var new_current_index: int
		match direction:
			Direction.Type.LEFT:
				if current_member == 0:
					new_current_index = members.size() - 1
				else:
					new_current_index = (current_member - 1) % members.size()
			Direction.Type.RIGHT:
				new_current_index = (current_member + 1) % members.size()
	
		switch_focus(Focus.Type.FINGER, current_member, new_current_index)
		current_member = new_current_index

func _on_enter_action_queue_handle_input() -> void:
	unfocus_all(Focus.Type.ALL)
	set_triangle_focus_color_all("White")
	set_triangle_focus_size_all(Vector2(.4, .4))

func _on_action_queue_focus_all_members(type: Focus.Type, color: Color) -> void:
	focus_all(type)
	set_triangle_focus_color_all(color)
