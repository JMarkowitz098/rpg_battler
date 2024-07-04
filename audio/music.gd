extends Node

@export var menu_theme: AudioStream
@export var battle_theme: AudioStream

@onready var audio_stream_player_2d := $AudioStreamPlayer2D

func play(song: AudioStream) -> void:
	audio_stream_player_2d.stream = song
	audio_stream_player_2d.play()

func fade(duration := 1.0) -> void:
	var previous_volume_db: float = audio_stream_player_2d.volume_db
	var volume_fade := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	volume_fade.tween_property(audio_stream_player_2d, "volume_db", -50.0, duration)
	await volume_fade.finished
	audio_stream_player_2d.stop()
	audio_stream_player_2d.volume_db = previous_volume_db
