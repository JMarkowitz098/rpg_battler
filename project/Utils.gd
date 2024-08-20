extends Node

enum GameOver {
	VICTORY,
	DEFEAT
}

const DEVLIN_PLAYER_DETAILS := preload("res://players/Devlin/details/devlin_player_details.tres")
const DEVLIN_PORTRAIT := preload("res://players/Devlin/details/devlin_portrait.jpeg")
const ESEN_PLAYER_DETAILS := preload("res://players/Esen/details/esen_player_details.tres")
const ESEN_PORTRAIT := preload("res://players/Esen/details/esen_portrait.jpeg")
const NALTA_PLAYER_DETAILS := preload("res://players/Nalta/details/nalta_player_details.tres")
const NALTA_PORTRAIT := preload("res://players/Nalta/details/nalta_portrait.jpeg")
const NASH_PLAYER_DETAILS = preload("res://players/Nash/details/nash_player_details.tres")
const NASH_PORTRAIT := preload("res://players/Nash/details/NashPortrait.jpeg")
const SORAH_PLAYER_DETAILS := preload("res://players/Sorah/details/sorah_player_details.tres")
const SORAH_PORTRAIT := preload("res://players/Sorah/details/sorah_portrait.jpeg")
const TALON_PLAYER_DETAILS := preload("res://players/Talon/details/talon_player_details.tres")
const TALON_PORTRAIT := preload("res://players/Talon/details/TalonPortrait.jpeg")
const NARRATOR_PORTRAIT := preload("res://icon.svg")

const FINAL_ROUND = Round.Number.THREE
var _params: Dictionary
var current_round := Round.Number.ONE
var current_team: Team.Id
# var current_round := Round.Number.TWO # For testing
# var current_team := Team.Id.THREE

var is_test := false
var save_path := SaveAndLoad.Path.GAME

func calucluate_attack_damage(actor_stats: Stats, target_stats: Stats) -> int:
	return _clamped_damage(actor_stats.level_stats.incursion - target_stats.level_stats.refrain)
	
func calculate_skill_damage(action: Action) -> int:
	match action.skill.id:
		Ingress.Id.INCURSION, Ingress.Id.DOUBLE_INCURSION, Ingress.Id.GROUP_INCURSION, Ingress.Id.PIERCING_INCURSION:
			var incursion_power: int = action.actor.stats.incursion
			if action.skill.id == Ingress.Id.INCURSION or action.skill.id == Ingress.Id.PIERCING_INCURSION:
				incursion_power += action.skill.ingress
			else:
				incursion_power += action.skill.ingress / 2


			var target_refrain: int = action.target.stats.refrain
			
			if _is_dodged(action): return 0
				
			if action.target.modifiers.has_small_refrain_open:
				return _get_refrain_damage(action, incursion_power, target_refrain)
	
			return _clamped_damage(incursion_power - target_refrain)
		_:
			return 0

func _is_dodged(action: Action) -> bool:
	if action.target.modifiers.is_dodging:
		return randi() % 2 == 1
	elif action.target.modifiers.is_eth_dodging:
		return randi() % 4 == 1

	return false

func _get_refrain_damage(action: Action, incursion_power: int, target_refrain: int) -> int:
	if action.skill.element == action.target.modifiers.current_refrain_element:
		return incursion_power * -1
	elif action.skill.id == Ingress.Id.PIERCING_INCURSION:
		return incursion_power - target_refrain
	else:
		return 0


func change_scene(next_scene: String, params: Dictionary) -> void:
	_params = params
	get_tree().change_scene_to_file(next_scene)

func get_param(key: String) -> Variant:
	if _params != null and _params.has(key):
		return _params[key]
	return null

func next_round() -> void:
	match(current_round):
		Round.Number.ONE:
			current_round = Round.Number.TWO
		Round.Number.TWO:
			current_round = Round.Number.THREE
	
func _clamped_damage(value: int) -> int:
	return clamp(value, 1, INF)

func get_player_portrait(player_id: PlayerId.Id) -> Texture:
	match(player_id):
		PlayerId.Id.TALON:
			return TALON_PORTRAIT
		PlayerId.Id.NASH:
			return NASH_PORTRAIT
		PlayerId.Id.ESEN:
			return ESEN_PORTRAIT
		PlayerId.Id.NALTA:
			return NALTA_PORTRAIT
		PlayerId.Id.SORAH:
			return SORAH_PORTRAIT
		PlayerId.Id.DEVLIN:
			return DEVLIN_PORTRAIT
		PlayerId.Id.NONE:
			return NARRATOR_PORTRAIT
		_:
			return null

func get_player_details(player_id: PlayerId.Id) -> Resource:
	match(player_id):
		PlayerId.Id.TALON:
			return TALON_PLAYER_DETAILS
		PlayerId.Id.NASH:
			return NASH_PLAYER_DETAILS
		PlayerId.Id.ESEN:
			return ESEN_PLAYER_DETAILS
		PlayerId.Id.NALTA:
			return NALTA_PLAYER_DETAILS
		PlayerId.Id.SORAH:
			return SORAH_PLAYER_DETAILS
		PlayerId.Id.DEVLIN:
			return DEVLIN_PLAYER_DETAILS
		_:
			return null

func connect_signals(signals: Array) -> void:
	for new_signal: Array in signals:
		Events[new_signal[0]].connect(new_signal[1])


func get_cutscene_texts(team_id: Team.Id, round_num: Round.Number) -> Array[SceneText]:
	var file_path := CutsceneTextLoader.get_file_path(team_id, round_num)
	return CutsceneTextLoader.load_chapter(file_path)
