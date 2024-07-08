extends Node

@export var confirm: AudioStream
@export var decline: AudioStream
@export var denied: AudioStream
@export var focus: AudioStream

@onready var sound_players := get_children()

func play(sound_stream: AudioStream, pitch_scale:=1.0, volume_db:=0.0) -> void:
	for sound_player in sound_players:
		if not sound_player.playing:
			sound_player.pitch_scale = pitch_scale
			sound_player.volume_db = volume_db
			sound_player.stream = sound_stream
			sound_player.play()
			return
