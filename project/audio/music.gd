extends Node

@export var menu_theme: AudioStream
@export var battle_theme: AudioStream

@onready var audio_stream_player_2d := $AudioStreamPlayer2D

var prev_song_from_position: float

func play(song: AudioStream, from_position := 0.0) -> void:
	audio_stream_player_2d.stream = song
	audio_stream_player_2d.play(from_position)

func fade(duration := 1.0) -> void:
	var previous_volume_db: float = audio_stream_player_2d.volume_db
	var volume_fade := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	volume_fade.tween_property(audio_stream_player_2d, "volume_db", -50.0, duration)
	await volume_fade.finished
	audio_stream_player_2d.stop()
	audio_stream_player_2d.volume_db = previous_volume_db

func get_from() -> float:
	return prev_song_from_position

func set_from() -> void:
	prev_song_from_position = audio_stream_player_2d.get_playback_position()
