extends ColorRect

const MAX_SLOTS := 2

@onready var slot_one_button := $VBoxContainer/HBoxContainer/SlotOneContainer/SlotOneButton
@onready var slot_two_button := $VBoxContainer/HBoxContainer/SlotTwoContainer/SlotTwoButton
@onready var slot_one_portrait := $VBoxContainer/HBoxContainer/SlotOneContainer/SlotOnePortrait
@onready var slot_two_portrait := $VBoxContainer/HBoxContainer/SlotTwoContainer/SlotTwoPortrait
@onready var start_button := $VBoxContainer/StartButton

var players_data: Array[PlayerData]

func _ready() -> void:
	_load_players_data()
	_set_focus()
	if players_data: _render_player_slots()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("menu_back"):
		Sound.play(Sound.focus)
		Utils.change_scene("res://menus/start_menu.tscn", {})


func _set_focus() -> void:
	match Utils.get_param("slot"):
		0:
			slot_one_button.focus_no_sound()
		1: 
			slot_two_button.focus_no_sound()
		_:
			slot_one_button.focus_no_sound()


func _load_players_data() -> void:
	var save_and_load := SaveAndLoad.new()
	var save_data := save_and_load.load_data("0")
	if not save_data:
		return
	players_data = save_data.players_data

	
func _render_player_slots() -> void:
	for data in players_data:
		if(data): _render_slot(data)
	
func _render_slot(player_data: PlayerData) -> void:
	var player_details := player_data.player_details
	var player_portrait: Texture2D
	
	match player_data.player_details.player_id:
		Player.Id.TALON:
			player_portrait = Utils.get_player_portrait(Player.Id.TALON)
		Player.Id.NASH:
			player_portrait = Utils.get_player_portrait(Player.Id.NASH)
		Player.Id.ESEN:
			player_portrait = Utils.get_player_portrait(Player.Id.ESEN)
	
	match player_data.slot:
		0:
			slot_one_button.text = player_details.label
			slot_one_portrait.texture = player_portrait
			
		1: 
			slot_two_button.text = player_details.label
			slot_two_portrait.texture = player_portrait
		#2:
			#slot_three_button_container.text = slot.label
		#3: 
			#slot_four_button_container.text = slot.label
			
func _change_to_character_creation(slot: int) -> void:
	Sound.play(Sound.confirm)
	Utils.change_scene("res://menus/character_creation_menu.tscn", { "slot": slot })

func _on_slot_one_button_pressed() -> void:
	_change_to_character_creation(0)

func _on_slot_two_button_pressed() -> void:
	_change_to_character_creation(1)

func _on_start_button_pressed() -> void:
	Sound.play(Sound.confirm)
	get_tree().change_scene_to_file("res://battle_scene/battle_scene.tscn")
