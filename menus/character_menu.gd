extends ColorRect

const MAX_SLOTS := 2

@onready var slot_one_button := $VBoxContainer/HBoxContainer/SlotOneContainer/SlotOneButton
@onready var slot_two_button := $VBoxContainer/HBoxContainer/SlotTwoContainer/SlotTwoButton
@onready var slot_one_portrait := $VBoxContainer/HBoxContainer/SlotOneContainer/SlotOnePortrait
@onready var slot_two_portrait := $VBoxContainer/HBoxContainer/SlotTwoContainer/SlotTwoPortrait
@onready var start_button := $VBoxContainer/StartButton

func _ready() -> void:
	_set_focus()
	_render_player_slots()

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
	
func _render_player_slots() -> void:
	for player_slot_index in MAX_SLOTS:
		_render_slot(player_slot_index)
	
func _render_slot(slot_index: int) -> void:
	var save_data := SaveAndLoadPlayer.load_player(slot_index)
	if not save_data:
		return
		
	var player_details: Resource
	var player_portrait: Texture2D
	
	match save_data.player_id:
		Stats.PlayerId.TALON:
			player_details = Utils.get_player_details(Stats.PlayerId.TALON)
			player_portrait = Utils.get_player_portrait(Stats.PlayerId.TALON)
		Stats.PlayerId.NASH:
			player_details = Utils.get_player_details(Stats.PlayerId.NASH)
			player_portrait = Utils.get_player_portrait(Stats.PlayerId.NASH)
		Stats.PlayerId.ESEN:
			player_details = Utils.get_player_details(Stats.PlayerId.ESEN)
			player_portrait = Utils.get_player_portrait(Stats.PlayerId.ESEN)
	
	match slot_index:
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
