extends Node

@export var menu_theme: AudioStream
@export var battle_theme: AudioStream

@onready var audio_stream_player_2d := $AudioStreamPlayer2D

func play(song: AudioStream) -> void:
	audio_stream_player_2d.stream = song
	audio_stream_player_2d.play()
